# Death Race — Godot 4 edition

This is the primary Godot 4 / GDScript development track for the offline, single-player Death Race game. The project now opens at a 3D-placeholder garage and can launch the race scene with the selected car. The original Unity project in `DeathRace/` remains untouched as a backup. The separate `DeathRace2D/` experiment is also left untouched; this 3D project lives in `DeathRaceGodot/`.

## Current 3D prototype

- Procedurally generated rectangular 3D circuit and barrier collisions
- Player car with acceleration, steering, braking/reverse, drift and rechargeable nitro
- Three AI rivals following ordered track waypoints
- Three-lap checkpoint progression, countdown and finish state
- Speed, lap, countdown and nitro HUD
- Touchscreen controls plus keyboard controls for desktop testing
- Six-entry data-driven garage catalogue: Lamborghini Veneno, Egoista, Terzo Millennio and Apollo Intensa Emozione, Arrow and Evo
- Original primitive 3D preview models; selected-car game stats carry into the race
- Landscape orientation and GL Compatibility renderer
- Offline only: no accounts, network, purchases or online multiplayer

## Open locally

Install Godot 4.3 or a compatible Godot 4.x release, import this folder using `project.godot`, and run the main scene `scenes/garage.tscn`. Select a car and tap Start Race to open `scenes/race.tscn`.

Keyboard: W/Up accelerate, S/Down brake or reverse, A/D or arrows steer, Shift nitro, Space drift.

## Automated validation

The `Death Race Godot validation` GitHub Actions workflow downloads the official Godot 4.3 Linux editor/runtime, imports the project headlessly, and smoke-tests the six-car catalogue, garage selection, selected-car stats, camera activation, countdown/start-line progression, acceleration, nitro drain, right-steering direction and AI movement. A passing workflow is engine/logic validation, not a substitute for visual and collision testing on an Android phone.

## Known limits

The garage previews and race vehicles remain greybox prototypes made from original primitive geometry; they are not official manufacturer models. Catalogue performance numbers are game-balance values, not factory specifications. The game has not yet been visually tested on an Android device or exported as an APK. Android export templates and Android SDK/JDK configuration are still required for a release build. The current phone editor workflow may also be constrained by device memory and performance.

## Development priorities

1. Keep the Godot headless smoke test passing and resolve any engine-reported errors.
2. Validate 3D visuals, collisions, touch layout and performance on the Samsung Galaxy A04s.
3. Expand the garage with unlock progression, upgrades and licensed/original vehicle models.
4. Add only original or properly licensed vehicle/track assets and record each asset's source, creator, licence and modifications in `ASSET_CREDITS.md`.
5. Optimise the finished 3D game for Android before making an APK.
