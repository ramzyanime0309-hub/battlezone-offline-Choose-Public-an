# Death Race — Godot 4 edition

This is the primary Godot 4 / GDScript development track for the offline, single-player Death Race game. The original Unity project in `DeathRace/` remains untouched as a backup. The separate `DeathRace2D/` experiment is also left untouched; this 3D project lives in `DeathRaceGodot/`.

## Current 3D prototype

- Procedurally generated rectangular 3D circuit and barrier collisions
- Player car with acceleration, steering, braking/reverse, drift and rechargeable nitro
- Three AI rivals following ordered track waypoints
- Three-lap checkpoint progression, countdown and finish state
- Speed, lap, countdown and nitro HUD
- Touchscreen controls plus keyboard controls for desktop testing
- Landscape orientation and GL Compatibility renderer
- Offline only: no accounts, network, purchases or online multiplayer

## Open locally

Install Godot 4.3 or a compatible Godot 4.x release, import this folder using `project.godot`, and run the main scene `scenes/race.tscn`.

Keyboard: W/Up accelerate, S/Down brake or reverse, A/D or arrows steer, Shift nitro, Space drift.

## Automated validation

The `Death Race Godot validation` GitHub Actions workflow downloads the official Godot 4.3 Linux editor/runtime, imports the project headlessly, and runs a smoke test for scene construction, camera activation, countdown/start-line progression, player acceleration, nitro drain, right-steering direction and AI movement. A passing workflow is engine/logic validation, not a substitute for visual and collision testing on an Android phone.

## Known limits

The scene remains a greybox prototype made from primitive geometry. It has not yet been visually tested on an Android device or exported as an APK. Android export templates and Android SDK/JDK configuration are still required for a release build. The current phone editor workflow may also be constrained by device memory and performance.

## Development priorities

1. Keep the Godot headless smoke test passing and resolve any engine-reported errors.
2. Continue tuning handling, collision response, touch layout and chase camera using actual device feedback.
3. Build the garage and car catalogue, including fictionalised/licensed Lamborghini- and Apollo-inspired entries.
4. Add only original or properly licensed vehicle/track assets and record each asset's source, creator, licence and modifications in `ASSET_CREDITS.md`.
5. Optimise the finished 3D game for Android before making an APK.
