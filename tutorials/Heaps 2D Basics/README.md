# Heaps 2D Tutorial

Step-by-step guide for very basic common game features.

Including:
- Sprites from h2d.Bitmap
- Animated sprites from h2d.Anim
- Shooting bullets
- Interaction between objects (one-to-many, many-to-many)
- Wall collisions (many-to-many)

## Overview: What's added each chapter

### Part 01
  - adding some `h2d.Bitmap` sprites at random positions
  - therefore introducing `hxd.Res.initLocal` to load game assets
  - adding a basic `h2d.Text` for in-game information
### Part 02
  - sprites are now `h2d.Anim` based on sprite strips
  - player can move (arrow keys / W-A-S-D)
    - therefore making first time use of `hxd.App.update` and using a reference to the player (sprite)
### Part 03 ( might scare beginners off a little )
  - setting the game's background color to a dark green
  - player movement now changes the player's sprite as well
    - a little clean-up in the update function and separating keyboard key hitting states
    - for the moment changing this sprite is very unconvenient and verbose (`changePlayerAnimation`)
      - the reference `player` switches and must save/pass all values from the old object
      - the sprite must be re-created here
### Part 04 ( code gets cleaner again and nicer )
  - new fields to store game objects (here only for coins)
    - `coins` (an array to save all coin sprites, needed for easier collision detection with player)
    new field for game information/state
    - `score_collectedCoins` (cointing collected coins)
    - `updatableInfoHUD` (adding an updatable score information)
  - everything gets cleaned up by defining/using methods
    - keyboard key checks are bundled into one method (`checkKeyboardKeys`)
    - sprite creating is bundled (into `createSprite_animated`)
      - (simplifying `changePlayerAnimation` a little bit, but still a bit clumsy)
  - `update` now contains several to-dos:
    - `player_movement`
    - `wrapPlayerInScene` (player can't leave the scene)
    - `update_InfoHUD`
    - `checkCollision_playerAndCoins`
### Part 05 ( from here the code gets a little cluttered and crammed )
  - level editing: loading a map/level from a text file
  - enemies move through the scene (they move and get "wrapped" inside the scene by `wrapInsideScene` which is now more general)
    - therefore we maintain a haxe array with an anonymous object to hold the data `sprite` and `direction` for each enemy
### Part 06
  - player can shoot
  - shot bullets can hit enemies and will reposition them on hit
  - shot bullets can collect coins
  - the player gets carried away by enemies when close to them (collisioning will be fine-tuned later...)
  - loading another level by text file, using a new tile ("stone slabs") and making use of the `h2d.Tilegroup` class (for background tiles)
### Part 07
  - shrinked the bounding boxes inside player-enemy collision for smoother collision
  - "stone slabs" are now walls and can no longer be passed (they are "solid")
    - for that we maintain a simple haxe array containing `h2d.col.Bounds` objects