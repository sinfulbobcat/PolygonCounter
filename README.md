<p align="center">
  <img src="https://raw.githubusercontent.com/sinfulbobcat/PolygonCounter/main/icon.svg" 
       alt="Sublime's custom image" 
       width="500" 
       height="500" 
       style="border: 5px solid #000000; border-radius: 10px;"/>
</p>

# Polygon Counter Plugin

## Description
A Redot/Godot plugin that counts polygons and vertices for selected `MeshInstance3D`, `CSGShape3D`, and `CSGCombiner3D` nodes in the scene.

> [!IMPORTANT]
> This plugin is still very immature. Things WILL BREAK. If you find any bugs, please make a issue.

> [!TIP]
> If you want to contribute and make this plugin better for everyone, please do not hesitate to make a pull request.

## Installation
1. Install it from [Asset Library](https://godotengine.org/asset-library/asset/3794)

**OR,**
1. Download the latest release.
2. Extract it.
3. Place ```addons``` folder in your project's home directory.
4. Enable the plugin in `Project > Project Settings > Plugins`.
5. Restart Redot/Godot or re-enable the plugin.


## Usage
- Expand the Polygon Counter dock by clicking on the button on the bottom tray.
- Select a 3D node (e.g., `MeshInstance3D` or `CSGBox3D`) in the scene tree.
  ![image](https://github.com/user-attachments/assets/4f3d239e-8836-426a-aaee-2c6f8b96d849)

- The "Polygon Counter" dock at the bottom will display the polygon and vertex counts.
- ```Polygon Adjustment Factor``` is used to offset the polygon count incase of any irregularities. But so far I have not faced any issues with polygon count. ***So I suggest to keep it ```1.0```***.
- ```Vertices Adjustment Factor``` is used to offset the vertices count incase of irregilarities. This is an important setting since as of right now, the vertices count on ```CSGCombiner3D``` and ```CSGPolygon3D``` is not calculated properly yet. We or I would implement a more appropriate technique to calculate it. (You should make a Pull Request if you think you can help me out in this!)
> [!WARNING]
> ```Use Manual CSG counting``` : Leave this checked, as it uses custom formulas to calculate the polygon and vertices count on the CSG meshes.
> Currently, converting the CSG shape to mesh to count, is broken.
> This feature is supposedly more performant than the other one too.

## Known Limitations
- It cannot count the number of polygons and vertices on ```CSGCombiner3D``` and ```CSGPolygon3D``` accurately, thus ```Vertices Adjustment Factor``` is employed to get a _somewhat_ ok value.
- The code is a mess, it can be optimized a lot.
- If ```CSGContainer3D``` is selected along with its child, it displays the sum of the poly and vertex count of the childs along with the ```CSGContainer3D```. This will be fixed in the next update.
- Tested on Redot and Godot 4.4 alpha; compatibility with other versions (e.g., 4.3) is unverified.

## License
MIT License (see LICENSE.md)
