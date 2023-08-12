# Stargate for MTA San Andreas

 Gamemode created for Multi Theft Auto: San Andreas (1.6 and newer) which is multiplayer mode for GTA: San Andreas. Heavily inspired by and lots of things just 'converted' from STARGATE: Horizon of the Universe - San Andreas mod.

## This is development branch

This project - gamemode is not completed yet. All scripts and parts of gamemode are gathered here, in this branch - they are tested to some extent, however they still probably have some issues, bugs and incomplete parts. Development branch can be considered as **Beta** version - somehow stable, have some (new) features, however needs more testing, fixing and implementing.

Features, updates here are not the newest, but more up-to-date unlike **release** branch, which is considered to be (mostly) fully stable release. If you want the newest features, try **development-alpha** branch.

# Current release

- Release 0.3c
- No release notes

## New features
- Models
    - Dynamic model loading now consumes even less memory thanks to reusing loaded textures
        - Atlantis map is now correctly loaded (in 0.3b release, it wouldn't load due to insufficient video memory)
        - The video memory usage dropped atleast 20 times (from 0.3b release; before: Atlantis map used >4 GB of memory, now: Atlantis map is using 200 MB;)
        - Note: Atlantis map is the greatest and most model/texture/resource heavy map in the HOTU mod
    - Fixed bug when models from other dimension/planet were also loaded when close to player
- Map
    - *Temporary feature: HOTU objects are created dynamically on resource start (for sorting and generating .map files)*
- Spawner
    - Creating stargates at these planets:
        - Earth (SGC)
        - Icarus base
        - Atlantis (using MilkyWay model)

## Features
- Gamemode
    - stargate_gamemode resource was changed from script type to gamemode type
    - commands: 
        - /mypos          - outputs your current position
        - /mypos x y z    - moves you to new coordinates based on your current position
        - /dim d          - sets your planet/dimension to d
        - /poselement eID - teleports you to elements position (eID = elements ID)
- Models
    - Models are now loaded (and unloaded) dynamically depending on client's occupied planet instead loading all of them at server join
        - Thanks to this, models with size > 15 MB are no longer an issue and **all models from HOTU mod can be loaded**
    - Finally fixed dynamic loading and unloading models (models were not unloaded properly, which causes video memory to be bloated)
    - Player will freeze and move its camera far away when loading models and unfreeze (and move back) when models are fully loaded
- Map
    - Earth planet with stargate including (incompleted and buggy) SGC base model [DHD dial command: '/dial 5']
    - Ability to generate .map file from IPL file (HOTU objects mostly) *development purposes only*
    - Ability to generate .map file based on players surrounding objects (HOTU objects only) *development purposes only*
    - Ability to regenerate .IPL file based on if given line contains HOTU object or not *development purposes only*
    - Note: HOTU object is object with custom model ID from Stargate: Horizon of the Universe v2.0 mod
    - San Andreas work in progress map is finally included in gamemode (Mount Everest base)
    - Ability to generate full and correct .map files
    - Earth - SGC map objects are full and complete without (noticed) bugs
    - Icarus - map objects are full and complete
- Models
    - All (or atleast 99%) models from STARGATE:Horizon of the Universe V2.0 mode are contained (script size increased to 1.4 GB)
    - Easy loading models based on 'element_model_data' attribute
- Stargate Iris
    - for MilkyWay Stargate; SGC Iris model
    - Iris autoclose option (when incoming wormhole) and autoopen (when gate closes)
    - If element is passing through stargate and destination gate has iris active, this element is destroyed
- DHD separated into default (dhd device) and base (SGC 'custom' DHD, Atlantis DHD, ...) types
    - default DHD gives enough energy for stargate to operate (non broken DHD)
    - base DHD gives no energy (stargate gets energy from external source instead)
    - Note: currently no external sources are present, as well as base DHD's or SGC/Atlantis map
- Energy system
    - every element can have element data "energy" with all required statuses, on which can the element change its behavior; they can produce, store or transfer energy between themselves
    - integration with stargate and dhd scripts
        - stargates require energy to operate
        - dhds generate energy and transfer it to stargate (currently all dhds are non breakable => automatically work)
        - stargates without de
        - without enough energy stargate won't:
            - dial out (not enough energy when started dialling)
            - estabilish connection (not enough energy when last chevron locked)
            - continue maintaining wormhole (not enough energy when wormhole is created)
- Planet system
    - each dimension represents one planet with own atmosphere
    - integrated with stargates, spawner, etc.
- Lifesupport system
    - each player/ped has its own lifesupport stats depending on occupied planet (and its atmosphere)
    - very basic application of lifesupport stats (dying of low oxygen/high temperature/...)
    - integrated with planet system
- Player is currently spawning at development "world"
- Basic gamemode script (spawn, respawn, join)
- Stargate element (MilkyWay model)
    - dialling, dial modes;
    - animations;
    - ability to transport all elements (except bullets from weapons)
- DHD element (MilkyWay model)
    - dial ability
    - attaching to gates
- Working gatespawner; dhdspawner
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
