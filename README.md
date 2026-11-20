# Sonic: Shattered Reality

A 2D top-down Sonic-inspired action-roguelike foundation made with Godot 4.7.2.

## Run the project

1. Install Godot 4.7.2 standard (not .NET).
2. Extract this ZIP.
3. Open the folder containing `project.godot` in Godot.
4. Press **F5** to run the project.

## Controls

- Keyboard: WASD or arrow keys to move; Space or Enter to spin attack; Esc to pause.
- Controller: left stick / D-pad to move; South face button to attack; Start / Options or Esc to pause.
- Touch: use the lower-left virtual stick and lower-right spin button.
- Touch/controller switching: touch input reveals touch controls; subsequent controller input hides them. Disconnecting the controller reveals touch controls again.

## Included in this foundation

- Title screen and start button
- Top-down arena
- Player movement
- Chasing enemies
- Spin attack
- Ring pickups
- Health, timer, pause, and game-over screens
- Basic touch and controller input

This is a playable foundation, not the complete planned game. It currently uses code-drawn placeholder graphics and does not yet include the full campaign, procedural room generation, bosses, shops, final art, music, or save system.

## iOS build with GitHub Actions

The workflow is `.github/workflows/build.yml`. It runs on GitHub's macOS runner, installs **Godot 4.7.2** and the matching export templates, exports the iOS Xcode project, builds the app with code signing disabled, and packages the app as `SonicShattered-unsigned.ipa`.

1. Upload the contents of this project folder to the root of the GitHub repository, keeping `.github/workflows/build.yml` at that exact path.
2. Commit and push to the `main` branch, or open **Actions → Build unsigned Sonic Shattered IPA → Run workflow**.
3. When the workflow succeeds, open its run and download the `SonicShattered-unsigned-IPA` artifact.
4. Sign that IPA with the signing app and certificate you already use.

### Bundle identifier and Team ID placeholder

- Bundle identifier: `com.squirtle.sonicshattered`
- `application/app_store_team_id` is currently set to `SQUIRTLE00` only as a non-secret placeholder because Godot's iOS exporter requires a non-empty Team ID field even when exporting an Xcode project for an unsigned build. It is **not** a real Apple Team ID. Replace it with the actual Team ID before attempting an Apple-managed signing or App Store workflow. This workflow disables Xcode code signing and does not use a certificate or provisioning profile.

### Important signing note

The generated IPA is deliberately **unsigned**. It is packaged for later signing; it is not directly installable until a signing tool applies a valid signature and provisioning profile. The GitHub workflow never receives or stores the `.p12` certificate or its password.

## Project layout

- `assets/` - placeholder asset directories
- `scenes/` - Godot scenes
- `scripts/` - GDScript files
- `project.godot` - project configuration
- `export_presets.cfg` - iOS export settings
- `.github/workflows/build.yml` - automated iOS build
