package;

import sdl.Sdl; // Import SDL library
import hxd.Window; // Import Window module from HaxeD
import hxd.System; // Import System module from HaxeD
import hxd.Event; // Import Event module from HaxeD
import h3d.Vector4; // Import Vector4 class from H3D
import h2d.Text; // Import Text class from H2D
import hxd.Key; // Import Key module from HaxeD

// Define a Point class for 2D coordinates
class Point {
    public var x:Float;
    public var y:Float;

    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }
}

// Define a Rect class for a rectangle's position and dimensions
class Rect {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}

// Define an enum for different camera modes
enum CameraMode {
    FirstPerson; // First-person camera mode
    ThirdPerson; // Third-person camera mode
}

// Main class extending HaxeD's App class
class Main extends hxd.App {
    var light: h3d.scene.fwd.DirLight; // Directional light object
    var player: h3d.scene.Object; // Player object
    var floor: h3d.scene.Object; // Floor object
    var playerPosition: Point; // Player's current position
    var cameraDistance: Float; // Camera distance from player
    var cameraHeight: Float; // Camera height from player
    var cache: h3d.prim.ModelCache; // Model cache for storing loaded models
    var isMoving: Bool = false; // Flag indicating if player is moving
    var movementSpeed: Float = 0.0; // Current movement speed of player
    var walkSpeed: Float = 0.04; // Base walking speed
    var playerSpeed: Float; // Player's speed factor
    var worldBounds: Rect; // World boundary rectangle
    var walkingAnimation: h3d.anim.Animation; // Walking animation object
    var cylinder: h3d.scene.Mesh; // Cylinder mesh for player
    var circle: differ.shapes.Circle; // Circle shape for player collision
    var obstacles: Array<differ.shapes.Polygon>; // Array of obstacles in the scene
    var cameraMode: CameraMode; // Current camera mode (FirstPerson or ThirdPerson)
    var cameraModeText: Text; // Text object for displaying camera mode
    var lastMouseX: Float = 0.0; // Last recorded mouse X position
    var lastMouseY: Float = 0.0; // Last recorded mouse Y position
    var mouseSensitivity: Float = 0.002; // Mouse sensitivity for camera control
    var yaw: Float = 0.0; // Yaw angle for camera orientation
    var pitch: Float = 0.0; // Pitch angle for camera orientation

    override function init() {
        cameraMode = FirstPerson; // Initialize camera mode to FirstPerson

        // Setup directional light
        light = new h3d.scene.fwd.DirLight(new h3d.Vector(0.3, -0.4, -0.9), s3d);
        light.enableSpecular = true;
        light.color.set(0.28, 0.28, 0.28);
        
        // Initialize model cache and load player model
        cache = new h3d.prim.ModelCache();
        player = cache.loadModel(hxd.Res.Model);
        player.scale(1 / 20);
        player.rotate(0, 0, Math.PI / 2);
        s3d.addChild(player);

        playerPosition = new Point(player.x, player.y);

        // Load walking animation
        walkingAnimation = cache.loadAnimation(hxd.Res.Model);
        worldBounds = new Rect(-10, -10, 20, 20);

        // Create floor mesh and set its properties
        var prim = new h3d.prim.Cube(worldBounds.width, worldBounds.height, 1.0);
        prim.unindex();
        prim.addNormals();
        prim.addUVs();
        var tex = hxd.Res.load("hxlogo.png").toImage().toTexture();
        var mat = h3d.mat.Material.create(tex);
        var floor = new h3d.scene.Mesh(prim, mat, s3d);
        floor.material.color.setColor(0xFFB280);
        floor.x = worldBounds.x;
        floor.y = worldBounds.y;
        floor.z = -1;

        // Initialize obstacle array with boundary polygons and random cubes
        obstacles = [];
        obstacles.push(differ.shapes.Polygon.rectangle(worldBounds.x - 1, worldBounds.y - 1, worldBounds.width + 1, 1, false));
        obstacles.push(differ.shapes.Polygon.rectangle(worldBounds.x + worldBounds.width, worldBounds.y - 1, 1, worldBounds.height + 1, false));
        obstacles.push(differ.shapes.Polygon.rectangle(worldBounds.x, worldBounds.y + worldBounds.height, worldBounds.width + 1, 1, false));
        obstacles.push(differ.shapes.Polygon.rectangle(worldBounds.x - 1, worldBounds.y, 1, worldBounds.height + 1, false));

        var prim = new h3d.prim.Cylinder(12, 0.35, 0.1);
        prim.addNormals();
        cylinder = new h3d.scene.Mesh(prim, s3d);
        cylinder.material.color.setColor(0x00ff00);
        cylinder.material.receiveShadows = false;
        cylinder.material.mainPass.culling = None;

        circle = new differ.shapes.Circle(0, 0, 0.35);

        // Create random cubes as obstacles
        var prim = new h3d.prim.Cube(1.0, 1.0, 1.0);
        prim.unindex();
        prim.addNormals();
        prim.addUVs();
        for (i in 0...50) {
            var cube = new h3d.scene.Mesh(prim, s3d);
            cube.material.color.setColor(Std.int(Math.random() * 0xff0000));
            cube.material.receiveShadows = false;
            cube.material.shadows = false;
            var scale = 0.3 + 0.7 * Math.random();
            cube.scale(scale);
            cube.x = worldBounds.x + Math.random() * (worldBounds.width - scale);
            cube.y = worldBounds.y + Math.random() * (worldBounds.height - scale);
            obstacles.push(differ.shapes.Polygon.square(cube.x, cube.y, scale, false));
        }

        // Perform initial collision check
        collideWithObstacles();

        cameraHeight = 5; // Set initial camera height
        updateCamera(); // Update camera position and orientation

        // Setup camera mode text display
        cameraModeText = new Text(hxd.res.DefaultFont.get(), s2d);
        cameraModeText.x = 0;
        cameraModeText.y = 0;
        cameraModeText.color = new Vector4(255, 255, 255, 255);
        cameraModeText.scale(3);
        cameraModeText.text = "First Person Camera\n1 - First Person\n2 - Third Person";

        // Initialize mouse position and set cursor position
        lastMouseX = s2d.mouseX;
        lastMouseY = s2d.mouseY;
        Window.getInstance().setCursorPos(s2d.width >> 1, s2d.height >> 1);
    }

    override function update(dt: Float) {
        var currentMouseX = s2d.mouseX;
        var currentMouseY = s2d.mouseY;

        // Calculate mouse movement delta
        var deltaX = (currentMouseX - (s2d.width >> 1)) * mouseSensitivity;
        var deltaY = (currentMouseY - (s2d.height >> 1)) * mouseSensitivity;

        // Update camera orientation based on camera mode
        if (cameraMode == FirstPerson) {
            yaw += deltaX;
            pitch -= deltaY;
            pitch = Math.max(-Math.PI / 2, Math.min(Math.PI / 2, pitch));
        }
        else if (cameraMode == ThirdPerson) {
            yaw += deltaX;
            pitch = Math.max(-Math.PI / 2, Math.min(Math.PI / 2, pitch));
        }

        lastMouseX = s2d.width >> 1;
        lastMouseY = s2d.height >> 1;

        // Determine player speed based on key input
        playerSpeed = 0.0;
        if (hxd.Key.isDown(hxd.Key.W)) {
            playerSpeed += 1;
        }
        if (hxd.Key.isDown(hxd.Key.S)) {
            playerSpeed -= 1;
        }

        // Adjust movement speed for running
        var runningMultiplicator = 1.0;
        if (hxd.Key.isDown(hxd.Key.SHIFT)) {
            if (playerSpeed < 0) {
                runningMultiplicator = 1.3;
            } else {
                runningMultiplicator = 2;
            }
        }

        // Move player based on current speed and direction
        if (playerSpeed != 0) {
            var forwardX = Math.cos(yaw) * playerSpeed * walkSpeed;
            var forwardY = Math.sin(yaw) * playerSpeed * walkSpeed;
            playerPosition.x += forwardX;
            playerPosition.y += forwardY;
            collideWithObstacles();

            // Play walking animation if moving
            if (movementSpeed != playerSpeed) {
                if (playerSpeed > 0) {
                    player.playAnimation(walkingAnimation).speed = runningMultiplicator;
                }
                movementSpeed = playerSpeed;
            }

            isMoving = true;
        } else {
            // Stop animation and reset movement state if not moving
            if (isMoving) {
                player.stopAnimation();
            }

            movementSpeed = 0;
            isMoving = false;
        }

        // Update player and camera orientation
        player.setRotation(0, 0, yaw + Math.PI / 2);
        updateCamera();

        // Reset mouse position and set relative mouse mode
        Window.getInstance().setCursorPos(s2d.width >> 1, s2d.height >> 1);
        Sdl.setRelativeMouseMode(true);

        // Switch camera mode based on key input
        if (Key.isPressed(Key.NUMBER_1)) {
            cameraMode = FirstPerson;
            cameraModeText.text = "First Person Camera\n1 - First Person\n2 - Third Person";
        }
        else if (Key.isPressed(Key.NUMBER_2)) {
            cameraMode = ThirdPerson;
            cameraModeText.text = "Third Person Camera\n1 - First Person\n2 - Third Person";
        }

        // Exit application if ESCAPE key is pressed
        if (Key.isPressed(Key.ESCAPE)) {
            System.exit();
        }
    }

    // Function to handle collision detection with obstacles
    function collideWithObstacles() {
        circle.x = playerPosition.x;
        circle.y = playerPosition.y;

        for (i in 0...obstacles.length) {
            var obstacle = obstacles[i];
            var collideInfo = differ.Collision.shapeWithShape(circle, obstacle);
            if (collideInfo != null) {
                circle.x += collideInfo.separationX;
                circle.y += collideInfo.separationY;
            }
        }

        playerPosition.x = circle.x;
        playerPosition.y = circle.y;
        player.x = playerPosition.x;
        player.y = playerPosition.y;
        cylinder.x = playerPosition.x;
        cylinder.y = playerPosition.y;
    }

    // Function to update camera position and orientation based on camera mode
    function updateCamera() {
        if (cameraMode == FirstPerson) {
            cameraHeight = 1.5;
            var forwardX = Math.cos(yaw) * Math.cos(pitch);
            var forwardY = Math.sin(yaw) * Math.cos(pitch);
            var forwardZ = Math.sin(pitch);
            s3d.camera.pos.set(playerPosition.x, playerPosition.y, cameraHeight);
            s3d.camera.target.set(playerPosition.x + forwardX, playerPosition.y + forwardY, cameraHeight + forwardZ);
        }
        else if (cameraMode == ThirdPerson) {
            cameraHeight = 1; // Adjust this height as needed
            var orbitDistance = 4.5; // Adjust this distance as needed
            
            // Adjust the pitch to look down at the player at an angle
            var desiredPitch = 0.2; // Adjust the angle (in radians) to look down
            pitch = Math.max(desiredPitch, Math.min(Math.PI / 2, pitch)); // Clamp the pitch
            
            var orbitX = orbitDistance * Math.cos(yaw) * Math.cos(pitch);
            var orbitY = orbitDistance * Math.sin(yaw) * Math.cos(pitch);
            var orbitZ = orbitDistance * Math.sin(pitch);
            
            s3d.camera.pos.set(playerPosition.x - orbitX, playerPosition.y - orbitY, cameraHeight + orbitZ);
            s3d.camera.target.set(playerPosition.x, playerPosition.y, cameraHeight);
        }
    }

    // Main entry point of the application
    static function main() {
        hxd.Res.initEmbed(); // Initialize embedded resources
        new Main(); // Create an instance of Main
    }
}