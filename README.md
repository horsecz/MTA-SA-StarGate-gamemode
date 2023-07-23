# Stargate for MTA San Andreas

 Gamemode created for Multi Theft Auto: San Andreas (1.6 and newer) which is multiplayer mode for GTA: San Andreas. Heavily inspired by and lots of things just 'converted' from STARGATE: Horizon of the Universe - San Andreas mod.

## This is development branch

This project - gamemode is not completed yet. All scripts and parts of gamemode are gathered here, in this branch - they are tested to some extent, however they still probably have some issues, bugs and incomplete parts. Development branch can be considered as **Beta** version - somehow stable, have some (new) features, however needs more testing, fixing and implementing.

Features, updates here are not the newest, but more up-to-date unlike **release** branch, which is considered to be (mostly) fully stable release. If you want the newest features, use partial development branches (beginning with *stargate_*).


# Current release

- Release 0.2
- New Features:
    - A lot of fixes
    - Stargate object can be rotated
    - Better animations
    - Separated model loading into models script
    - DHD element (dial ability, attaching to gates)
    - Global element (used for storing data across whole gamemode; both client and server)
- Features:
    - Skeleton scripts (energy, lifesupport, etc.)
    - Basic gamemode script (spawn, respawn, join)
    - Stargate (MilkyWay model) with dialling, dial modes, animations, ability to transport all elements except bullets
    - Working gatespawner
    - Work in progress map (San Andreas; Stargate base) not used in gamemode yet 


# Script list

- stargate_dhd
    - dhd creation, removal, attaching, etc.
- stargate_energy
    - energy creation, consumption, "factories" and ZPMs
- stargate_exports
    - functions that are used in all stargate_* scripts
    - global element
- stargate_gamemode
    - resource type 'gamemode' which runs all other stargate scripts
    - initialization, beginning
    - run script
    - global server and client events (player connect; join; respawn; ...), commands and actions
- stargate_gate
    - stargate, its physics, model(s), behavior
- stargate_lifesupport
    - planet atmosphere
    - oxygen, nitrogen, water, vacuum; event&actions related to LS
- stargate_map
    - resource type 'map' containing all maps used in this gamemode
    - map specific scripts included
- stargate_models
    - texture, model, collision models loading
- stargate_planets
    - planets, dimensions, their stats (behavior, events)
    - list of existing planets
- stargate_rings
    - transport rings element
- stargate_spawner
    - spawns all elements (stargates, dhds, rings, etc.) which can be spawned/created at gamemode start
