# DEATH RACE

Offline Android arcade racing prototype. Visual target: compact mobile racing visuals in the spirit of Asphalt Nitro; race flow, nitro, drift, rival AI and garage progression inspired by modern arcade racers.

## Unity setup
Use Unity 6.0.64f1 (6000.0.64f1). Open this `DeathRace` folder as the project, wait for compilation, then choose **Death Race > Generate Playable Prototype**. The editor tool creates a demo circuit, cars, camera, HUD and Android scene.

## Prototype systems
Arcade acceleration, steering, braking and nitro; waypoint AI rivals; countdown, speed, lap and nitro HUD; procedural placeholder cars and track; keyboard and touch-oriented controls; offline-first with no network dependency.

## Car catalogue and licensing
Requested catalogue targets include Lamborghini Veneno, Egoista, Terzo Millennio and Apollo models (Intensa Emozione, Evo, Arrow and Project EVO). Production-quality recognizable meshes, badges, logos and audio must be supplied under appropriate licenses. This repository contains only original placeholder geometry, not assets copied from Asphalt Legends or another game.

## Android build
Connect the `DeathRace` folder as the Unity project root in Build Automation, choose Android and APK, and use `DeathRaceProjectSetup.EnsureProject` as the pre-export method. Configure signing credentials. Cloud compilation and physical-device testing have not yet been verified.
