# BattleZone Offline

Unity 6 offline single-player Android shooter prototype.

## Prototype contents
- First-person movement and touch look controls
- Touch movement area, fire and reload buttons
- Six basic enemy bots that chase and attack
- Health, ammunition, kill counter and victory state
- Lightweight primitive arena for early device testing

## Project settings
- Unity Editor: 6000.0.64f1
- Android package: com.battlezone.offline
- Landscape orientation
- Android APK for direct installation

## Generate the scene
Open the project in Unity, wait for scripts to compile, then choose BattleZone > Generate Playable Prototype. The editor script creates the arena scene and adds it to Build Settings.

## Cloud build
Connect this GitHub repository in Unity Dashboard > DevOps > Build Automation. Select branch main, Unity 6000.0.64f1 and Android. Choose APK, not AAB, for direct phone installation. Configure Android signing credentials in the dashboard. In Advanced Settings, set the Pre-export Method to BattleZoneProjectSetup.EnsureProject so the scene is generated before the cloud build.

This is an early prototype, not the finished full game. It uses placeholder primitive models and simple bot behavior. It has not yet been compiled or tested on a physical Android device.
