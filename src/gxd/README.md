# Ghost
## Main Classes
### Game
The main entry point for a ghost-powered game. Simply pass in a `GameState` and some configurations and its ready to go!

### GameObject
The base Object of a `Game`.

### GameState
Use these to construct the different States of a `Game`.
For example, a different `GameState` can be made for the Main Menu, the Game Loop, and the Game Over Screen.

### GM
The Game Manager. Use this to access useful methods and properties like resetting the `Game`, changing the `GameState`, and setting the target FPS.

## Sections
* sys  - Ghost system classes.
* ui   - UI elements.
* util - Utility Classes.