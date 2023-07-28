# Stargate for MTA San Andreas

 Gamemode created for Multi Theft Auto: San Andreas (1.6 and newer) which is multiplayer mode for GTA: San Andreas. Heavily inspired by and lots of things just 'converted' from STARGATE: Horizon of the Universe - San Andreas mod.

## This is release branch

This project - gamemode is not completed yet. When there will be *first* **final version**, it will be here, in this branch. Until then, see development branch, development-alpha or partial development branches. For releasing final version, the gamemode must be:
- stable
- completed
- tested

to some extent.

## Branch differences

- **release**
    - best stability, only final, completed and tested features
- **development**
    - less stable, more new features which are mostly tested and (to some point) stable
- **development-alpha**
    - mostly unstable, and untested, a lot of bugs but the newest features
- **previews**
    - contains screenshots or recorded videos from development (for feature and progress preview)
- **stargate_\* branches**
    - other branches that start their name with *stargate_*
    - partial development of every part script of this project


# Script list

- stargate_energy
    - energy creation, consumption, "factories" and ZPMs
- stargate_exports
    - functions that are used in all stargate_* scripts
- stargate_gamemode
    - resource type 'gamemode' which runs all other stargate scripts
    - initialization, beginning
    - run script
    - global server and client events (player connect; join; respawn; ...), commands and actions
- stargate_gate
    - stargate, its physics, model(s), behavior
    - dhd
- stargate_lifesupport
    - planet atmosphere
    - oxygen, nitrogen, water, vacuum; event&actions related to LS
- stargate_map
    - resource type 'map' containing all maps used in this gamemode
    - map specific scripts included
- stargate_planets
    - planets, dimensions, their stats (behavior, events)
    - list of existing planets
- stargate_rings
    - transport rings element
- stargate_spawner
    - spawns all elements (stargates, rings, etc.) which can be spawned/created at gamemode start
    - including gatespawner script
