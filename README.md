<p align="center">
  <img src="https://raw.githubusercontent.com/sinfulbobcat/PolygonCounter/main/icon.svg" 
       alt="Sublime's custom image" 
       width="500" 
       height="500" 
       style="border: 5px solid #000000; border-radius: 10px;"/>
</p>

# Polygon Counter Plugin

## Description
A Godot plugin that counts polygons and vertices for selected `MeshInstance3D`, `CSGShape3D`, and `CSGCombiner3D` nodes in the scene.

> [!IMPORTANT]
> This plugin is still very immature. Things WILL BREAK. If you find any bugs, please make a issue.

> [!TIP]
> If you want to contribute and make this plugin better for everyone, please do not hesitate to make a pull request.

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
- 
- Tested on Godot 4.4 alpha; compatibility with other versions (e.g., 4.3) is unverified.

## License
MIT License (see LICENSE.md)
