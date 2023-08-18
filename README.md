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
    - GPU video memory higher than 256 MB is required, 512 MB and more is recommended

## Prerequisites

This is MTA server resource. That simply means, for running and playing this gamemode, you need to have MTA Server. There is no need to have hosting - you can play it on local server just fine. All you need to do is have MTA server which can be done by following steps:
- I. Have installed MTA: San Andreas

After completing step I., you can navigate to MTA: San Andreas folder (typically ``C:/Program Files (x86)/MTA San Andreas 1.6``) and enter ``server`` directory, which contains everything you need. 

You may still need to do one more step to ensure that gamemode works properly - add ACL privileges to stargate_gamemode resource. This can be done by following steps:
- I. Open ``ACL.xml`` file located in ``MTA San Andreas 1.6/server/mods/deathmatch``
- II. Locate **Admin** group (``<group name="Admin">``) and add stargate_gamemode resource to this group
    - Insert this line there: ``<object name="resource.stargate_gamemode"></object>``

## Use instructions

- I. You must download the entire content of this branch
- II. Copy (or extract if downloaded archive) all folders and their contents (except README.md and TBD.md) into your MTA server's resource directory
    - this could be for example: ``C:/Program Files (x86)/MTA San Andreas 1.6/server/mods/deathmatch/resources``
    - if you do not have MTA server, you should see Prerequisites section (above this one) first
- III. You are good to go - now start your server, start resource ``stargate_gamemode`` and enjoy! 
    - recommended: start the resource in server console (command ``start stargate_gamemode``) and then join

## This is release branch

This project - gamemode is not completed yet. When there will be *first* **final version**, it will be here, in this branch. Until then, see development branch, development-alpha or partial development branches. For releasing final version, the gamemode must be:
- stable
- completed
- tested

to some extent.

## Lastest release

Branch **release** is intended for final releases. Currently there is **no final release**, however you can look up into other branches (such as *development*) - there you can find *playable* versions of this gamemode.

## Branch differences

- **release**
    - stable
    - may contain bugs, however it's the most tested release, so there should be minimum of them
    - completed and complex features
    - gamemode must be able to load, start and work without crashing client or server
    - *this release is intended for playing and running on live server* and has full 'gamemode experience' (events, missions, map/ped/vehicle interactions, etc.)
- **development**
    - less stable than release, but still more stable than development-alpha
    - still needs some testing
    - new features completed (to some extent)
    - chances of game crash or gamemode not loading is low
    - *until first final release: this release is intended mostly for testing, there won't be any 'gamemode experience' until final release*
- **development-alpha**
    - unstable version
    - needs a lot of testing
    - contains the newest features - they may be incompleted or buggy
    - possibility of game crashing or gamemode not loading is high
    - *this release is intended mostly for testing and development*
- **previews**
    - contains screenshots or recorded videos from development (for feature and progress preview)


# Script list

Will be provided on final release.
