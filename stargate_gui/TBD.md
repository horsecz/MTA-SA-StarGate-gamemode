# To be done

- Error window with description
    - more text than info window
    - no autohide
    - maybe: some icon?
    - use: unable to load models at start
- Info window wants to be displayed when another one is already being present
    - currently: second info window won't be displayed at all
    - opt1: second window is stored in stack and displayed after first one
        - issue: too much windows -> too much delays -> too much windows displayed
    - opt2: second window replaces first one (+ resets removeWindow timer)
- Option to change GUI action/close/toggle key
    - GUI Window or command