# To be done

Plans for next releases. Plans don't have to be fullfilled at all, nor the order in which features will be completed. 

## Complete to release 0.5

- HOTU maps (MilkyWay only; or all of them)
    - Spawned stargates/dhds (only MW except Atlantis)
    - Handling and integration with planet system
    - Every planet is in separated .map file
    - Note: *no map functionality* in *this release* (except: Stargates, DHDs and some minors maybe)
- San Andreas map
    - Complete stargate base
    - Partial map functionality (SG base)
- Wormhole transport
    - don't transport player directly; first some "neutral middle point", horizon -> fade camera -> middle point -> models loaded -> teleport to destination -> unfade camera
- Stargate
    - don't use 7th symbol in SG address (rather auto detect it); except destiny gate ofc
    - maybe: use addresses as in Garrys mod (not just numbers but A-Z and 0-9 -> 36 characters + '#' '*' '@')

## Complete to release 0.6

- All map interactions and functionality (bases first -> SGC, Icarus; only MW galaxy maps)
    - Alarms when activated/open stargate
    - Iris autoclose (or Walter?)
    - Self destruct option
    - Doors
    - Maybe: Walter
    - Maybe maybe: some peds, npcs and traffic
- Maybe: unstable wormhole effect (model from garrys mod CAP?)

## Complete to release 0.7

- Stargate Pegasus model
- Stargate Universe model
- Intergalactic travel

## Complete to release 0.8

- Stargate vehicles
- Stargate weapons
- Other elements

## Complete sometime

- Shooter planet/world  => stargate_shooter
    - Because why not
    - OR: racing/whatever planet with multiple modes (shooter, race, ...)
- Transport rings   => stargate_rings
- Asgard beam   => stargate_asgard_beam
- Player login (or: just use default /login and register commands - good enough)
    - not required for playing => guest mode (no logged in features)
    - save last location before server quit
    - have/save custom vehicle (and its position); note: needs to have vehicles in-game in first place
- Player data saving into db -> new resource: stargate_database
- Game tutorial (do: after most of the gamemode is completed)
    - stargate, how to use it
    - vehicles
    - weapons
    - planets
    - ...
- GUI messages
    - Random/Useful messages
    - Use showInfoWindow from stargate_gamemode instead outputChatBox for messages from server to player
- NPCs and traffic - no ghost towns (and planets)
    - Game traffic
    - NPCs - walking peds
    - All planets (inhabitated; minimum: SA, SGC, Atlantis)
- Maybe: planet distances (with point of origin Earth) and Galaxy map (GUI)

## To be done in scripts

Every script has its own **TBD.md** file containing what needs to be done there.

## Possible new scripts

- stargate_explosion
    - Handling explosions (strength)
    - Stronger explosions with effects, etc.
- stargate_bomb
    - Naquadah bomb, Tampered ZPM, etc.
    - Custom bombs
- stargate_vehicles
    - Puddle Jumper, F302
    - Motherships (Daedalus, Prometheus, Hatak, ...)
- stargate_shields
    - City/Mobile shields
    - Vehicle shields
    - Player personal shields
