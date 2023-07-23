# TO BE DONE

Medium priority (needed but can be skipped for now):
- Iris (or Atlantis gate shield)
- Support of galaxies and other gate types
    - 8th chevron; dialling to another galaxy; support of galaxies
    - 9th chevron; dialling to Destiny;
    - Pegasus gate model
    - Universe gate model

Low priority (may be useful to be done one day):
- Weird gate ring lightning? [happened after attachElements]

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
- Enhanced animations and effects
- Do not allow creation of stargate in some conditions
    - possible conditions: same dimension (= planet), close proximity to another gate
    - but: allow **moving** one stargate close to another (or to other dimension=planet); e.g. mothership w/ gate with implementing precedence ("dominance")
    - temp solution could be (it is now): allow creation only in gate_spawner.s
- Use XML/External file instead arrays for important stargate data such as list of created stargates
    - related: after this is done, do not createStargate() every time resource-gamemode will run (load instead)