# Heaps 2D Basics - OOP Extension

This is the tutorial game from "Heaps 2D Basics" but with an object oriented design approach (proposal).

This makes single files smaller again and may be easier to scale, however using only one class crammed with functions like before works as well and the approach designed here is only a possible option amongst many others.
Another option would be data oriented design, for instance with an ECS (entity-component-system architecture).

Every *game piece* (like in a board game) `extends` a common game object class (here named `GameObject`, it's also common to use "entity" as a name). This class itself just `extends h2d.Object`, the common visual container for 2D objects in Heaps.

Every *level/scene/place in the game world* `extends Level` which itself `extends h2d.Scene` the common root `h2d.Object` in Heaps which serves as a canvas or *game board* for all *game pieces*.