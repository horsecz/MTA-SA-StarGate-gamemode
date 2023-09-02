# To be done

Plans for next releases. Plans don't have to be fullfilled at all, nor the order in which features will be completed. 

## Complete to release 0.5b

- Complete and generate .map files of remaining HOTU maps
- Fixed stargate and dhd positions and rotations
- External energy devices for stargates with base DHD
- Atlantis DHD

## Complete to release 0.5c

- Transport rings
- Energy requirements for dialling to another galaxy or destiny
    - option for disabling/not checking (dev purposes mostly)

## Complete to release 0.6

- All map interactions and functionality (bases first -> SGC, Icarus; only MW galaxy maps)
    - Alarms when activated/open stargate
    - Iris autoclose (or Walter?)
    - Self destruct option
    - Doors
    - Energy generators (base dhd)
    - Maybe: Walter
    - Maybe maybe: some peds, npcs and traffic
- Maybe: unstable wormhole effect (model from garrys mod CAP?)
- Maybe: Development world map (use SA 0,0,z but with custom objects like fences, whatever)

## Complete to release 0.7

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
