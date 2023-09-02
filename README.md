# Stargate for MTA San Andreas

 Gamemode created for Multi Theft Auto: San Andreas (1.6 and newer) which is multiplayer mode for GTA: San Andreas. Heavily inspired by and lots of things just 'converted' from STARGATE: Horizon of the Universe - San Andreas mod.

 ## Requirements

- GTA: San Andreas
    - compatible with MTA: San Andreas
    - unmodified
- MTA: San Andreas
    - version 1.6 and newer
    - MTA server
- PC running Windows (or any other operating system that is capable to run MTA: San Andreas)
    - hardware requirements are almost same as GTA/MTA: San Andreas except GPU Video Memory
    - GPU Video Memory of **3 GB** and more is recommended; minimum is 512 MB.
    - **if minimum hardware requirements are not met, there is no guarantee, that this gamemode won't crash your game or that it will work properly**

## Prerequisites

This is MTA server resource. That simply means, for running and playing this gamemode, you need to have MTA Server. There is no need to have hosting - you can play it on local server just fine. All you need to do is have MTA server which can be done by following steps:
- I. Have installed MTA: San Andreas

After completing step I., you can navigate to MTA: San Andreas folder (typically ``C:/Program Files (x86)/MTA San Andreas 1.6``) and enter ``server`` directory, which contains everything you need. 

You may still need to do one more step to ensure that gamemode works properly - add ACL privileges to stargate_gamemode resource. This can be done by following steps:
- I. Open ``ACL.xml`` file located in ``MTA San Andreas 1.6/server/mods/deathmatch``
- II. Locate **Admin** group (``<group name="Admin">``) and add stargate_gamemode resource to this group
    - Insert this line there: ``<object name="resource.stargate_gamemode"></object>``

## Installation and play

- I. You must download the entire content of this branch
- II. Copy (or extract if downloaded archive) all folders and their contents (except README.md and TBD.md) into your MTA server's resource directory
    - this could be for example: ``C:/Program Files (x86)/MTA San Andreas 1.6/server/mods/deathmatch/resources``
    - if you do not have MTA server, you should see Prerequisites section (above this one) first
- III. You are good to go - now start your server, start resource ``stargate_gamemode`` and enjoy! 
    - recommended: start the resource in server console (command ``start stargate_gamemode``) and then join

## This is development branch

This project - gamemode is not completed yet. All scripts and parts of gamemode are gathered here, in this branch - they are tested to some extent, however they still probably have some issues, bugs and incomplete parts. Development branch can be considered as **Beta** version - somehow stable, have some (new) features, however needs more testing, fixing and implementing.

Features, updates here are not the newest, but more up-to-date unlike **release** branch, which is considered to be (mostly) fully stable release. If you want the newest features, try **development-alpha** branch.

# Current release

- Release 0.5
- Note: Map and Stargate update

## New features

- Map
    - SGC
        - DHD has type Base - DHD is replaced by dialling computer
        - Energy is generated from external source device (energy room)
    - New maps
        - Loading all (or atleast 99%) maps from STARGATE:Horizon of the Universe mod
            - Exceptions: Interiors (generated but not being loaded) and "non-planets" (or: maps without stargate)
        - Only Stargates and DHDs spawned; no map functionality or interactions
            - Note: Just spawned at +- correct position
        - Asgard homeworld map - currently its planet galaxy is set as MilkyWay (correct: Othala)
- Stargate
    - Internal: not using 7th (8th) symbol in SG address
        - stargates address is always sixth symbol one (with exception of Destiny and possible others - there address is not address but a code)
        - point of origin (last symbol; 7th symbol mostly) and galaxy symbol (7th symbol in 8 symbol address) are autofilled in DHD GUI
    - Can be now attached to any element
        - Command: /sgattach [SG_ID] - will attach stargate to players vehicle (above; floating)
    - Wormhole transport
        - Since now, players are not transported directly when they go through stargate, instead player is in "void" until his models are loaded (and then transported to destination)
    - Stargate Pegasus and Universe models - *work in progress*
        - No dialling animations yet
        - No sounds nor special (non model related) effects yet - everything is (re)used from MilkyWay gate
        - For Universe model - no non-Destiny DHD (going to any Universe world except Destiny is one-way road; mobile DHD is not implemented yet)
    - 8th and 9th chevron dialling
        - No dial animations yet (using 7 chevron dialling animations now)
        - No integration with energy resource
            - Currently any stargate can be dialed by any other stargate without any restrictions
                - The only thing that is restricted is DHD List in DHD GUI which shows stargates *that are supposed to be diallable*
                - If user enters address manually in address bar (in DHD GUI) *and correctly*, any stargate can be dialed (currently)
            - Energy requirements will be introduced for dialling to another galaxy (or Destiny) - in further releases
        - Fully implemented in DHD, Stargates
        - Stargates are local or global
            - Local stargates can dial only other stargates within their galaxy (local stargates)
            - Global stargates can additionally dial stargates in any other galaxy (but: the destination stargate must be global too and it cannot be Destiny if not special case)
            - Special cases:
                - Icarus base (or Icarus type stargate) - only this stargate can dial Destiny
                - Destiny - this stargate is special for its own reason (is Destiny, the only stargate that has 9 chevron address)
- DHD
    - Base DHD is now an option (DHD without model) - enum_galaxy.UNKNOWN as DHD type
    - GUI: Using Toggle key (instead open and close keys)
- Models
    - /showmodel command - displays given model (by hotu dff file name) in development world (zero-ish coordinates)
    - Loading different stargate models depending on occupied (planets) galaxy (except Development world)


## Features

- Stargate element (MilkyWay model)
    - dialling, dial modes;
    - animations;
    - ability to transport all elements (except bullets from weapons)
    - Stargate Iris
        - for MilkyWay Stargate; SGC Iris model
        - Iris autoclose option (when incoming wormhole) and autoopen (when gate closes)
        - If element is passing through stargate and destination gate has iris active, this element is destroyed
        - Note: any iris model can be mounted/used on any stargate model
- DHD
    - dial ability
    - attaching to gates
    - energy generation and transfer to stargate if attached to some
    - DHD separated into default (dhd device) and base (SGC 'custom' DHD, Atlantis DHD, ...) types
        - default DHD gives enough energy for stargate to operate (non broken DHD)
        - base DHD gives no energy (stargate gets energy from external source instead)
    - DHD GUI
        - opens with action button (E; closes with close button F1)
        - selecting available stargates from list and dialling
        - option to dial via manually entering stargate adress
        - dialling speed/type option (if dialling type is not forced)
        - disengage wormhole, cancel dialling process
        - you cannot shutdown gate when wormhole is estabilished
    - Base DHD type
        - DHD without model, invisible (object)
        - Used in bases (SGC, Atlantis, ...)
        - Usually near (or in) some other object that will represent the DHD (like in/near dialling computer in SGC or at Atlantis DHD console object)
- Models
    - Custom models from STARGATE:Horizon of the Universe V2.0 mod (atleast 99% of them)
    - Dynamic loading and unloading of custom models depending on players occupied planet
    - Player will freeze and move its camera far away when loading models and unfreeze (and move back) when models are fully loaded - reducing lag to minimum
    - Anti-crash prevention (GPU VM overflow) and potato PC warning
    - Texture quality levels (models can be loaded into GPUs with VM 512 MB - 3 GB or more)
- Maps
    - Ability to generate full and correct .map files, reading from IPL files and regenerating IPL files (features mostly for development)
    - San Andreas (custom objects)
    - Earth (SGC) 
    - Icarus
    - Note: all maps are work-in-progress
- Gamemode
    - player is currently spawning at development "world"
    - basic gamemode script (spawn, respawn, join)
    - stargate_gamemode resource is gamemode type
    - commands: 
        - /mypos          - outputs your current position
        - /mypos x y z    - moves you to new coordinates based on your current position
        - /dim d          - sets your planet/dimension to d
        - /poselement eID - teleports you to elements position (eID = elements ID)
    - GUI info window at player join when models are being loaded
    - GUI general info window (showInfoWindow function; /infowindow command)
    - at join, player will be spawned and frozen, camera is in clouds - will target player after models are loaded 
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
    - info text about currently occupied planet and galaxy
        - top-center of screen, permanent
- Lifesupport system
    - each player/ped has its own lifesupport stats depending on occupied planet (and its atmosphere)
    - very basic application of lifesupport stats (dying of low oxygen/high temperature/...)
    - integrated with planet system
    - info text regarding occupied planet and its atmosphere
        - right-center of screen, under money, permanent 
- Spawner
    - Spawning all neccessary (server-side) objects, elements on map(s)
    - Gatespawner (spawns Stargates and DHDs)
    - Planetspawner (creates planets)


# Script list

- stargate_dhd
    - dhd creation, removal, attaching, ...
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
- stargate_gui
    - global GUI(s) used in all other stargate resources
- stargate_lifesupport
    - planet atmosphere, element life support stats
    - oxygen, nitrogen, water, vacuum; event&actions related to LS
- stargate_map
    - resource type 'map' containing all maps used in this gamemode
    - map specific scripts included
    - ability to read and generate .MAP files from IPL files
- stargate_models
    - texture, model, collision models loading
- stargate_planets
    - planets, dimensions, their stats (behavior, events)
- stargate_spawner
    - spawns all elements (stargates, dhds, rings, etc.) which can be spawned/created at gamemode start

## Details

For more detailed description of used scripts navigate into script folder and read its README.md file.