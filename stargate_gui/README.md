# STARGATE: GUI

Implementation of GUI used in stargate gamemode. Gamemode currently uses (globally) these GUI elements:

## Models loading window

Notification in the center of players screen when player joins the server about loading models. Hides after models are loaded and player spawns.

## Info window

Generic info window at top of users screen with some title and content. Window will be hidden automatically after given time (default: 5 seconds).

## Keyboard keys

Three keyboard keys are defined for GUI:
- Action key
    - Opens any GUI
    - Default: 'E'
- Close key
    - Closes any GUI
    - Default: 'F1'
- Toggle key
    - Close or Open any GUI
    - Default: same as Action key ('E')
    - May be disabled in some GUIs (mostly in those where there is any text field and typing letter E in any text field would cause users GUI to close)

These keys are valid globally and are used in every other stargate resource.