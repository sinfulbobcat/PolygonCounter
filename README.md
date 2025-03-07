# Polygon Counter Plugin

## Description
A Godot plugin that counts polygons and vertices for selected `MeshInstance3D`, `CSGShape3D`, and `CSGCombiner3D` nodes in the scene.

## Installation
1. Download the `polygon_counter` folder.
2. Place it in your project's `addons/` directory.
3. Enable the plugin in `Project > Project Settings > Plugins`.
4. Restart Godot or re-enable the plugin.

## Usage
- Select a 3D node (e.g., `MeshInstance3D` or `CSGBox3D`) in the scene tree.
  ![Desktop View](https://media.discordapp.net/attachments/1268496559285211238/1347512935953727498/image.png?ex=67cc18b7&is=67cac737&hm=f5d68581951be90d510767c5aa2353dc68360f76fc0920c919e7ff531e79bf8e&=&format=webp&quality=lossless&width=1550&height=872)
- The "Polygon Counter" dock at the bottom will display the polygon and vertex counts.
- Toggle visibility with the "Poly Count" button in the toolbar.

## Known Limitations
- CSG node counting uses manual values (12 polygons, 8 vertices for a default `CSGBox3D`) due to a bug in Godot 4.4 alpha with `get_meshes()`. This may not reflect modified shapes.
- Tested on Godot 4.4 alpha; compatibility with other versions (e.g., 4.3) is unverified.

## License
MIT License (see LICENSE.md)
# PolygonCounter
Displays polygon and vertex count for selected MeshInstance3D nodes.
