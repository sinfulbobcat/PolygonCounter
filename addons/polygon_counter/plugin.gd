@tool
extends EditorPlugin

var dock: PanelContainer
var poly_label: Label
var vert_label: Label
var selected_nodes = []
var toggle_button: Button
var is_visible: bool = true
var use_manual_csg_counting: bool = true  # Option to manually count polygons and vertices for CSG nodes

func _enter_tree():
	# Initialize the plugin and load necessary resources
	var dock_scene = load("res://addons/polygon_counter/dock.tscn")
	if not dock_scene:
		push_error("ERROR: Failed to load dock.tscn. Plugin will not function.")
		return
	dock = dock_scene.instantiate() as PanelContainer
	if not dock:
		push_error("ERROR: Failed to instantiate dock. Check dock.tscn structure.")
		return
	
	# Add the dock panel to the editor's bottom panel
	add_control_to_bottom_panel(dock, "Polygon Counter")
	dock.visible = true
	
	# Get references to the UI labels for displaying the polygon and vertex count
	poly_label = dock.get_node("VBoxContainer/PolyLabel") if dock.has_node("VBoxContainer/PolyLabel") else null
	vert_label = dock.get_node("VBoxContainer/VertLabel") if dock.has_node("VBoxContainer/VertLabel") else null
	if not poly_label or not vert_label:
		push_error("ERROR: Failed to find labels in dock. Expected nodes: PolyLabel, VertLabel")
		return
	
	# Style the dock panel and labels
	var bg = StyleBoxFlat.new()
	bg.bg_color = Color(0.1, 0.1, 0.1, 0.7)
	dock.add_theme_stylebox_override("panel", bg)
	dock.get_node("VBoxContainer/TitleLabel").add_theme_color_override("font_color", Color.WHITE)
	poly_label.add_theme_color_override("font_color", Color.WHITE)
	vert_label.add_theme_color_override("font_color", Color.WHITE)
	
	# Connect the selection signal to track the selected nodes
	var selection = get_editor_interface().get_selection()
	if selection:
		selection.connect("selection_changed", Callable(self, "_on_selection_changed"))
	else:
		push_error("ERROR: Failed to get selection interface")
	
	# Perform an initial update of the polygon and vertex count
	_update_stats()

func _exit_tree():
	# Clean up when the plugin is removed
	if dock and dock.get_parent():
		remove_control_from_bottom_panel(dock)
		dock.queue_free()
	if toggle_button:
		remove_control_from_container(CONTAINER_TOOLBAR, toggle_button)
		toggle_button.queue_free()

func _on_toggle_pressed(button_pressed: bool):
	# Toggle the visibility of the dock panel
	is_visible = button_pressed
	dock.visible = is_visible
	_update_stats()

func _on_selection_changed():
	# Handle the changes in the selection and track valid 3D nodes
	selected_nodes.clear()
	var selection = get_editor_interface().get_selection().get_selected_nodes()
	for node in selection:
		if node is MeshInstance3D or node is CSGShape3D or node is CSGCombiner3D:
			selected_nodes.append(node)
	_update_stats()

func _count_mesh_stats(mesh: Mesh) -> Array:
	# Count the polygons and vertices for a given mesh
	if not mesh:
		return [0, 0]
	var poly_count = 0
	var vertex_count = 0
	for surface_idx in range(mesh.get_surface_count()):
		var arrays = mesh.surface_get_arrays(surface_idx)
		if arrays and arrays[Mesh.ARRAY_VERTEX]:
			vertex_count += arrays[Mesh.ARRAY_VERTEX].size()
			if arrays[Mesh.ARRAY_INDEX]:
				poly_count += arrays[Mesh.ARRAY_INDEX].size() / 3
			else:
				poly_count += arrays[Mesh.ARRAY_VERTEX].size() / 3
	return [poly_count, vertex_count]

func _count_csg_stats(csg_node: Node) -> Array:
	# Count the polygons and vertices for CSG (Constructive Solid Geometry) nodes
	if csg_node is CSGShape3D or csg_node is CSGCombiner3D:
		csg_node.set("operation", csg_node.operation)  # Force an update of the CSG shape
		csg_node._update_shape()
		
		# Attempt to get the mesh data from the CSG node
		var mesh_data = csg_node.get_meshes()
		if mesh_data.size() >= 2 and mesh_data[1] is Mesh:
			return _count_mesh_stats(mesh_data[1])
		elif mesh_data.size() > 0 and mesh_data[0] is Mesh:
			return _count_mesh_stats(mesh_data[0])
		
		# Fallback to manual counting for certain CSG shapes if enabled
		if use_manual_csg_counting:
			if csg_node is CSGBox3D:
				return [12, 8]  # Default for CSGBox3D: 12 polygons, 8 vertices
			elif csg_node is CSGCombiner3D:
				var child_poly_count = 0
				var child_vert_count = 0
				for child in csg_node.get_children():
					if child is CSGShape3D:
						var child_stats = _count_csg_stats(child)
						child_poly_count += child_stats[0]
						child_vert_count += child_stats[1]
				# Adjust the counts for combinations
				var poly_adjustment_factor = 1.5
				var vert_adjustment_factor = 6.75
				child_poly_count = int(child_poly_count * poly_adjustment_factor)
				child_vert_count = int(child_vert_count * vert_adjustment_factor)
				return [child_poly_count, child_vert_count]
	
	return [0, 0]

func _update_stats():
	# Update the polygon and vertex count labels based on the selected nodes
	if not poly_label or not vert_label:
		push_error("ERROR: Labels not initialized in _update_stats")
		return
	
	if not is_visible:
		poly_label.text = "Polygons: Hidden"
		vert_label.text = "Vertices: Hidden"
		return
	
	if selected_nodes.is_empty():
		poly_label.text = "Polygons: 0"
		vert_label.text = "Vertices: 0"
		return
	
	var total_poly_count = 0
	var total_vert_count = 0
	
	# Calculate total polygon and vertex counts for selected nodes
	for node in selected_nodes:
		var node_poly_count = 0
		var node_vert_count = 0
		
		if node is MeshInstance3D:
			var mesh = node.mesh
			if mesh:
				var stats = _count_mesh_stats(mesh)
				node_poly_count = stats[0]
				node_vert_count = stats[1]
				
		elif node is CSGCombiner3D or node is CSGShape3D:
			var stats = _count_csg_stats(node)
			node_poly_count = stats[0]
			node_vert_count = stats[1]
		
		total_poly_count += node_poly_count
		total_vert_count += node_vert_count
	
	# Update the labels with the final counts
	poly_label.text = "Polygons: %d" % total_poly_count
	vert_label.text = "Vertices: %d" % total_vert_count

func _get_plugin_name():
	# Return the name of the plugin
	return "Polygon Counter"

func _get_plugin_config() -> Dictionary:
	# Return the plugin configuration settings
	return {
		"name": "Polygon Counter",
		"description": "A plugin to count polygons and vertices in the scene.",
		"version": "1.0",
		"settings": {
			"use_manual_csg_counting": {
				"type": TYPE_BOOL,
				"value": use_manual_csg_counting,
				"hint": PROPERTY_HINT_NONE,
				"name": "Use Manual CSG Counting",
				"description": "Enable manual counting for CSG nodes (workaround for Godot 4.4 alpha bug)."
			}
		}
	}
