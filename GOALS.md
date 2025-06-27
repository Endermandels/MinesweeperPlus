# USER ACTIONS

- User can click on tiles to reveal spaces

# USER INTERFACE

There can only be one overlay menu at a time
Overlay menus can be on top of overlay screens

Go for an Act II Inscryption type of neon vibe with pixel art

- (SCENE) Main menu
    - (BUTTON) Play 
        - Go to Game
    - (BUTTON) Settings 
        - Reveal Settings Menu
    - (BUTTON) Quit 
        - Exit game

- (SCENE) Game
    - (KEY) ESC 
        - Reveal Pause Menu
    - (BUTTON LMB) Tile 
        - Reveal tile if no flag
        - On win, mine tiles flash red, then turn green; reveal Win Screen
        - On lose, wait a bit, then shake the screen while revealing all other mines at once; reveal Lose Screen
    - (BUTTON RMB) Tile
        - Place/Remove flag

- (OVERLAY SCREEN) Win Screen
    - (ANIMATION) Rainbow Panel Border
        - Have a rainbow border circling around the panel
    - (LABEL) YOU WIN
    - (LABEL) Time Spent
        - Time spent on game with a cap of 99 minutes and 99 seconds
    - (BUTTON) Play Again
        - Restart game
    - (BUTTON) Exit
        - Go to Main Menu

- (OVERLAY SCREEN) Lose Screen
    - (ANIMATION) Pulsing Red Panel Border
        - Have a pulsing red border around the panel
    - (LABEL) You Died
    - (LABEL) Time Spent
        - Time spent on game with a cap of 99 minutes and 99 seconds

- (OVERLAY MENU) Pause Menu
    - (KEY) ESC
        - Return to current scene
    - (BUTTON) Settings
        - Reveal Settings Menu
    - (BUTTON) Main Menu
        - Go to Main Menu
    - (BUTTON) Return
        - Return to current scene

- (OVERLAY MENU) Settings Menu
    - (SLIDER) Volume
        - Change Volume
    - (BUTTON) Return
        - Return to current scene

# GAME LOGIC

Grid:
- 24 wide x 20 high
- Width: 172 px 384 px 64 px
- Height: 20 px 320 px 20 px

New Game:
- Upon loading a new game, display tiles
- Upon clicking on a tile, spawn in 99 mines in random locations, excluding the start tile, 
    and spawn in 5 powerup 2s and 1 powerup 1s
- Mine tiles cannot have a powerup

Definition:
- adjacent = is within the 8 surrounding tiles

Reveal tile:
- If tile is a mine, emit lose
- Else if tile is adjacent to at least one mine, display how many mines are adjacent to tile
- Else if there are no adjacent mines to tile, reveal all adjacent tiles
- If tile is powerup 1, if next tile clicked (LMB) is a mine, the mine reveals all the surrounding tiles and diffuses itself and all surrounding bombs
- Else if tile is powerup 2, next flag place will be permanent and will also reveal whether the tile is a mine or not

Flag tile:
- If tile does not have a flag and there are flags remaining, place a flag on tile and remove it from the remaining flags
- Else if tile has a flag, remove the flag and add it to the remaining flags 

Winning:
- If the number of tiles left equals the number of mines (99), emit win
