# Stargate for MTA San Andreas

 Gamemode created for Multi Theft Auto: San Andreas (1.6 and newer) which is multiplayer mode for GTA: San Andreas. Heavily inspired by and lots of things just 'converted' from STARGATE: Horizon of the Universe - San Andreas mod.

## This is development branch

This project - gamemode is not completed yet. All scripts and parts of gamemode are gathered here, in this branch - they are tested to some extent, however they still probably have some issues, bugs and incomplete parts. Development branch can be considered as **Beta** version - somehow stable, have some (new) features, however needs more testing, fixing and implementing.

Features, updates here are not the newest, but more up-to-date unlike **release** branch, which is considered to be (mostly) fully stable release. If you want the newest features, try **development-alpha** branch.

## Branch notes

From this release, there will be no partial development branches *stargate_\**.

# Current release

- Release 0.3
- Note: **Probably** last release with mostly functional-only updates (aka most of the changes are not visible)
- **Gamemode size has been increased dramatically (to 1.4 GB) due to all Horizon of the Universe V2.0 models that are included from now on.**
- New Features:
    - Models 
        - Completely rewritten models script
        - All (or atleast 99%) models from STARGATE:Horizon of the Universe V2.0 mode are contained (script size increased to 1.4 GB)
            - not all models can be loaded now (many great TXD files [size > 15MB] fail to load)
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
    - Bugfixes
        - Incoming wormhole when dialling out
        - Dialling animations and effects
    - Player is now spawning at development "world"
- Features:
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
    - Global element (used for storing data across whole gamemode; both client and server)


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
