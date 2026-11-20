# Sonic: Shattered Reality

A 2D, top-down, pixel-art roguelike project built with **Godot 4**. This repository currently contains the initial project foundation, a title screen, a placeholder gameplay scene, and the first pass of touchscreen/controller visibility switching.

> This is an original fan-project starter. It does not include official Sonic assets, music, or other copyrighted game files.

## Requirements

- Godot 4.3 or newer
- For iOS export: a Mac with the required Apple development tools and Godot iOS export templates, plus valid signing credentials
- For GitHub-based iOS builds: a configured macOS runner and signing setup; GitHub Actions does not remove Apple's signing requirements

## Open the project

1. Download and extract this folder.
2. Open Godot Project Manager.
3. Choose **Import** and select this folder's `project.godot` file.
4. Open the project and press **F6** or **F5** to run it.

## Current contents

```text
sonic_shattered/
├── project.godot
├── README.md
├── scenes/
│   ├── main_menu.tscn
│   └── game.tscn
└── scripts/
    ├── main_menu.gd
    ├── game.gd
    └── touch_controller_manager.gd
```

## Controls planned

| Action | Keyboard | Controller | Touch |
|---|---|---|---|
| Move | WASD / arrow keys | Left stick / D-pad | Virtual movement area (visual placeholder in this starter) |
| Attack | Space | South face button | Spin button (visual placeholder in this starter) |
| Pause | Escape | Menu/Start-style button | To be added |

Controller button mappings can differ between controller models and operating systems. The project's input actions will be tested and refined as gameplay is implemented.

## Touch/controller visibility behavior

- A controller connection hides the touchscreen overlay.
- A touch press or drag brings the touchscreen overlay back.
- The next actual controller button or stick input hides it again.
- Disconnecting the last controller restores touchscreen controls.

This first pass handles input-mode visibility. It does not yet implement a complete virtual joystick or gameplay movement system.

## Development roadmap

1. Project foundation, startup screen, and input-mode switching.
2. Player movement, animation, room camera, and collision.
3. Combat, enemies, projectiles, and damage feedback.
4. Room/floor generation, pickups, ring currency, shops, and secrets.
5. Bosses, playable characters, upgrades, areas, endings, and unlocks.
6. Save data, settings, accessibility, audio, balancing, and full-device testing.
7. iOS export workflow and release packaging.

## Important status note

This ZIP is **Milestone 1**, not the complete game. The full game scope is the target, but the remaining systems must be implemented and tested before this can be called a complete playable release. The startup screen uses original placeholder typography and colors; final pixel-art sprites, logo, sound, and animations are still to be created.
