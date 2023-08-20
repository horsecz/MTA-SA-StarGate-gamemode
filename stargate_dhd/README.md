# STARGATE: DHD

Script used for creating, maintaining and removing DHD element. DHD, short term for Dial-Home-Device is element, which works like phone - when its connected to some Stargate, it powers the Stargate and allows user to dial another Stargate by typing 7, 8 or 9 correct symbols and then pressing the middle activation button.

In Stargate Gamemode for MTA:SA, player does not have to remember symbol combinations for every other Stargate. Instead, it works like this:
- I.    Player approaches DHD. When close enough, player is notified about ability to dial.
- II.   After pressing predefined button, DHD GUI will open*. When close to DHD, player can also use these commands:
    - /dial     ID_number
        - dials another stargate by its ID number
- III.  After player leaves DHD, DHD GUI and listed commands cannot be used anymore.

*Only dial command is available. DHD GUI will be available in next release.

## DHD types

There are several types of DHD. They mostly differ in their look:
- MilkyWay
    - DHD used in MilkyWay galaxy (model with golden symbol buttons and red activation button)
- Pegasus**
    - Used in Pegasus galaxy (model with azure symbol buttons and blue activation button)
- Universe**
    - Used in galaxies different than MilkyWay or Pegasus (white symbol buttons and white activation button)
- Base**
    - Special DHD type
    - Uses different DHD GUI
    - Stargate dial mode is enforced
    - DHD object model is invisible
    - Does not produce energy
    - Used in SGC (dialling computer), Atlantis (Atlantis DHD), Destiny (Destiny consoles in gateroom) and other bases without classic DHD 

**Not available in lastest release but will be implemented.

## Energy

Classic DHD has following energy properties:
- 1 MEU production
- 1 MEU storage
- 0 EU consumption

As mentioned above, Base DHD generates no energy, therefore it has following energy properties:
- 0 EU production
- 0 EU storage
- 0 EU consumption

## Development attributes

DHD Element has following attributes:
- "isBroken"
    - determines wheter DHD is broken or not (broken DHD has issues with generating power or generates no power at all)*
- "canDialGalaxy"
    - possibility of dialling stargate from another galaxy; if this is not set to true, dialling to different galaxy will simply fail