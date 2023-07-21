# TO BE DONE

Functional related, medium priority:
- Stargate object rotation
- On player join -> models are scuffed (sg; ring; chevron 1 is fine)
- Use XML/External file instead arrays for important stargate data such as list of created stargates
    - related: after this is done, do not createStargate() every time resource-gamemode will run (load instead)
- Iris (or Atlantis gate shield)
- Implement DHD; and/or DHD dial mode (or: use fast dial)
- Galaxies and other gate types (Pegasus, Universe); use of 8th and 9th chevron

Functional related but lower priority:
- Support transport of all elements
    - Supporting: Player, Ped, Vehicle, Projectile
    - Not Supporting: Weapon bullet
- Wormhole jump after strong enough explosion near gate
    - need also: implement bombs, explosions
- Unstable wormhole
    - possible scenarios: explosion near gate, solar flare, damaged gate, energy issues
- Enhanced animations and effects
- Gate overload (overload weapon & overload gate heating, explosion)
- Do not allow creation of stargate in some conditions
    - possible conditions: same dimension (= planet), close proximity to another gate
    - but: allow **moving** one stargate close to another (or to other dimension=planet); e.g. mothership w/ gate with implementing precedence ("dominance")
    - temp solution could be: allow creation only in gate_spawner.s