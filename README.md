# Sonic: Shattered Reality

A 2D top-down action-roguelike foundation made with Godot 4.7.2.

## Run it
1. Install Godot 4.7.2 (or a compatible Godot 4 release).
2. Extract this ZIP.
3. Open the folder containing `project.godot` in Godot.
4. Press **F6** to run the main scene, or **F5** to run the project.

## Controls
- Keyboard: WASD or arrow keys to move; Space or Enter to spin attack; Esc to pause.
- Controller: any face button starts from the title screen; left stick / D-pad to move; South face button to attack; Start / Options or Esc to pause.
- Touch: drag the lower-left virtual stick to move; tap/hold the lower-right button to spin.
- Touch/controller switching: touch input shows touch controls; subsequent controller input hides them.

## Included in this foundation
- Title screen and start button
- Top-down arena
- Player movement
- Chasing enemies
- Spin attack
- Ring pickups
- Health, timer, pause, and game-over screens
- Basic touch and controller input

## Important limitations
This is a playable gameplay foundation, not the complete planned game. It uses temporary code-drawn graphics and has no final Sonic artwork, music, story campaign, room generation, bosses, shops, or save system yet.

The project does not include an iOS export preset or a signed IPA. iOS export requires configuring an iOS export preset, installing matching Godot export templates, and using valid Apple signing credentials on a macOS runner. Do not add fake Team IDs or signing secrets.

## Folder layout
- `Scenes/` - Godot scenes
- `Scripts/` - gameplay scripts
- `Assets/Sprites/` - future art assets
- `Assets/Audio/` - future sound and music assets
- `project.godot` - project configuration

All folder names are visible in the iPhone Files app; no hidden folders are included in this ZIP.
