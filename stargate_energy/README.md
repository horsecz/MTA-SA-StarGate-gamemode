# STARGATE: Energy

This script implements energy element. This element provides functions with energy such as:
- generation
    - producing, creating some amount of energy
    - into energy elements storage
- consumption
    - using, consuming given amount of energy (from storage)
    - consumes all available energy in storage (even if its lower than consumtion rate amount)
    - if there is nothing in storage or less than needed, energy element changes its state (to "energy requirements not satisfied") and otherwise
- storage
    - storing generated or transferred energy
- transfer
    - transferring energy between two energy elements
    - at transfer rate (every element has its own); rate must be same for both elements and the slower transfer rate is used

All of this enables option for every element in game to change its behavior depending on this energy element's state. Changes are made per second.

## Energy Units

Or short - EU; are fictional units used for measuring energy. There can also be Thousands of Energy Units (KEU), Millions of Energy Units (MEU), etc.
