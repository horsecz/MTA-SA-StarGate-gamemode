# To be done

Test:
- Creation of stargate pegasus and universe model(s)

Medium priority (needed but can be skipped for now):
- Teleport element rotation (currently incorrect sometimes)
- (Better) collisions for stargate iris
- Wrong gate ring rotation to last symbol (point of origin)
- Transport animation
    - to hide model loading
    - can be very short; no need for long one (but can be optional)
    - make element really be transported
        - while loading models (player), set his position to neutral dimension/position
        - after models are loaded teleport player into correct dimension and position
- Stargate remove
- Support of galaxies and other gate types
    - 8th chevron; dialling to another galaxy; support of galaxies and gate types
    - 9th chevron; dialling to Destiny;
    - Pegasus gate model
    - Universe gate model

Lower priority (good to have):
- Support transport of all elements
    - Supporting: Player, Ped, Vehicle, Projectile
    - Not Supporting: Weapon bullet
- Wormhole jump after strong enough explosion near gate
    - need also: implement bombs, explosions
- Unstable wormhole
    - possible scenarios: explosion near gate, solar flare, damaged gate, energy issues
- Stargate time travel
- Gate overload (overload weapon & overload gate heating, explosion)

Lowest priority (definitely not needed; do only when everything else is done):
- Do not allow creation of stargate in some conditions
    - possible conditions: same dimension (= planet), close proximity to another gate
    - but: allow **moving** one stargate close to another (or to other dimension=planet); e.g. mothership w/ gate with implementing precedence ("dominance")
    - temp solution could be (it is now): allow creation only in gate_spawner.s
- Use XML/External file instead arrays for important stargate data such as list of created stargates
    - related: after this is done, do not createStargate() every time resource-gamemode will run (load instead)
