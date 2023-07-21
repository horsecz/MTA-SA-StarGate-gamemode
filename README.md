# Stargate for MTA San Andreas

 Gamemode created for Multi Theft Auto: San Andreas (1.6 and newer) which is multiplayer mode for GTA: San Andreas. Heavily inspired by and lots of things just 'converted' from STARGATE: Horizon of the Universe - San Andreas mod.

## This is release branch

This project - gamemode is not completed yet. When there will be *first* **final version**, it will be here, in this branch. Until then, see development branch or partial development branches. For releasing final version, the gamemode must be:
- stable
- completed
- tested

to some extent.


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
