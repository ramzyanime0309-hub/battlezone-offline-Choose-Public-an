# Death Race — Godot edition

This is the new Godot 4 / GDScript development track for Death Race. The original Unity project in `DeathRace/` is intentionally preserved as a backup; this project lives separately in `DeathRaceGodot/`.

## First playable slice

- 3D arcade racing loop on a closed rectangular circuit
- Player acceleration, steering, reverse/braking, drifting and nitro
- Three AI rival cars following track waypoints
- Three-lap checkpoint progression and finish state
- Speed, lap, countdown and nitro HUD
- Touchscreen buttons plus keyboard controls for desktop testing
- Offline only; no account, network, purchase or online-multiplayer dependency

## Run

Install Godot 4.3 or a compatible Godot 4.x release, open this folder as a project, then press Play (F6/F5). The main scene is `scenes/race.tscn`.

Keyboard: W/Up accelerate, S/Down brake or reverse, A/D or arrows steer, Shift nitro, Space drift.

Android target: landscape orientation, GL Compatibility renderer. Android export templates and SDK setup are still required before an APK can be produced.

## Status and known limits

This is an initial greybox playable slice using original primitive geometry. It is not the final visual quality target. The current repository environment did not have a Godot executable available, so engine parsing, live gameplay, Android export and physical-device performance have not yet been verified.

## Next development priorities

1. Run the scene in Godot and tune car handling/collision stability.
2. Add proper track surface markings, camera shake, engine/nitro audio and responsive touch layout.
3. Replace primitive vehicles with licensed or original optimized 3D car assets; maintain an asset register.
4. Port the existing requested car catalogue and garage progression into Godot resources.
