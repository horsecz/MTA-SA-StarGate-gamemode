# Gate script

Contains:
- Stargate model and textures initialization
- Animations (ring rotation, event horizon, kawoosh-vortex effect, etc.) including sound effects
- Element teleportation
- Physics - wormhole operations, "stargate laws"
- Stargate element basic functionality

# Stargate

Stargate element is element of type 'object' with custom ID (assigned on client-side) and custom stargate model.
All models are in 'models' folder and must be downloaded by client (as well as sound effects in 'sounds' folder).
Functions (*methods*) of this element begin their name as **stargate:**, which is *simulating* a *stargate class*. A stargate element can contain other elements (*subclasses*):
- chevron
- galaxy
- horizon
- marker
- ring
- sound
- vortex
- wormhole

## Attributes

Following attributes (element data) are obtainable from stargate element:
    
- "address"
    - Address of stargate within its galaxy
- "active"
    - Is stargate active? (open, dialling or being dialed)
- "diallingAddress"
    - Stargate address that is being dialed by this stargate
- "disabled"
    - Is stargate disabled? (unable to be used or dialed to; ex. buried, damaged, ...)
- "connectionID"
    - ID of stargate, that is connected to this stargate or this stargate is connected to
    - Example: Gate A dialed and estabilished wormhole to Gate B. Gate A then contains ID of Gate B in "connectionID", Gate B contains ID of Gate A in "connectionID".
- "galaxy"
- "incomingStatus"
    - If stargate is active or/and open, is the connection incoming (aka is this the destination gate)?
- "open"
    - Is stargate open? (wormhole estabilished and event horizon present for teleportation)

Another attributes, which are used for development purposes:
- "closeTimer"
    - Timer element of gate's autoshutdown. Used for extracting information regarding remaining time before wormhole disengages.
- Other
    - Attributes which are used temporarily for short period of time
    - Element ID

# Chevron

Element of stargate which represents active chevron object, functions named as *stargate:chevron:*. Has following attributes:
- "number"
    - Represents number of the chevron. First chevron is top-right. Fourth chevron is bottom-left. Seventh chevron is top. Eighth and Nineth chevron are on the bottom.

# Galaxy

Abstract element of stargate which represents galaxy, in which is stargate located. Functions are named as *stargate:galaxy*. This element cannot be created, rather exists as *another **stargate element attribute* named *"galaxy"*.

# Horizon

Element of stargate representing even horizon object, functions named as *stargate:horizon:*. Has no attributes.

# Marker

Element of stargate representing marker with some function. Functions are named as *stargate:marker:* and has one variable attribute (depends on marker function).

# Ring

Element of stargate representing gate ring, functions named as *stargate:ring:*. Has attributes:
- "rotationTime"
    - Time needed for the ring to complete its rotations to complete dialling process (animation).
- "isRotating"
    - Is the ring currently being rotated?

# Sound

Element of stargate representing played sound at stargate position. Functions are named as *stargate:sound:*. Has one variable attribute, which depends on the sound that is played (attribute name starts with *'sound_'*).

# Vortex

Element of stargate representing kawoosh-vortex when gate is opening. Functions named as *stargate:vortex:*.

# Wormhole

Abstract 'class' of wormhole between two stargates. Functions are named as *stargate:wormhole:*. Because it's not element, it has no attributes and cannot be accessed, however this 'class' generates some other elements such as event horizon, vortex or markers, which can be accessed.
