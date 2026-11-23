# Death Race asset provenance

This file tracks third-party assets used by the Godot project.

## Current prototype

No third-party art, vehicle models, textures, fonts, music or sound effects are currently included.

| Asset or category | Current implementation | Creator/source | Licence |
|---|---|---|---|
| Track and barriers | Primitive meshes and collision shapes generated in `scripts/race_manager.gd` | Original project code | Original |
| Player and rival vehicles | Primitive box/cylinder meshes generated in `scripts/race_manager.gd` | Original project code | Original |
| Garage preview vehicles | Primitive box/cylinder meshes generated in `scripts/garage.gd` | Original project code | Original |
| Catalogue data | Six manufacturer/model labels and game-balance values in `scripts/car_catalog.gd` | Project-authored catalogue data; no manufacturer assets/logos included | Original data entry |
| Materials | `StandardMaterial3D` instances generated in code | Original project code | Original |
| Audio | None yet | — | — |

## Required record for future assets

Before adding any downloaded or commissioned asset, record:

- Asset name and intended in-game use
- Creator or publisher
- Original source URL
- Exact licence and any attribution requirement
- Modifications made
- Repository path and date added

Do not include ripped game assets, unlicensed vehicle models, brand logos or copyrighted music. Vehicle catalogue names and visual designs must be handled carefully; use licensed assets or original designs.
