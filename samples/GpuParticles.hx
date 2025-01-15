/**
 * Demonstrates a GPU-accelerated particle system using h3d.parts.GpuParticles.
 * Renders a large number of particles with customizable parameters like speed, gravity,
 * and emission patterns.
 */
class GpuParticles extends SampleApp
{
    // The main GPU Particle system, controlling all particle groups.
    var parts:h3d.parts.GpuParticles;

    // A GPU Particle group controlling its own emitter, life cycle, etc.
    var group:h3d.parts.GpuParticles.GpuPartGroup;

    // A basic 3D box used for bounding or demonstration.
    var box:h3d.scene.Box;

    // 2D text displaying debug or status info (e.g. # of active particles).
    var tf:h2d.Text;

    // Whether we move the entire GPU Particle system in a sinusoidal pattern.
    var moving:Bool = false;

    // A local timer used for sinusoidal motion.
    var time:Float = 0.0;


    /**
     * Entry point for the application initialization logic.
     * Called after the underlying 3D context is prepared.
     */
    override function init()
    {
        super.init();

        // 1) Create the main GPU Particle system, passing our Stage3D context.
        parts = new h3d.parts.GpuParticles(s3d);

        // 2) Create a GPU Particle Group, defining emission, life, and rendering behaviors.
        var g = new h3d.parts.GpuParticles.GpuPartGroup(parts);

        // Emitter settings
        g.emitMode = Cone;      // Emitter shape (Cone, Sphere, etc.)
        g.emitAngle = 0.5;      // Emitter angle spread
        g.emitDist = 0;         // Distance offset from the emitter origin

        // Fade in/out timing
        g.fadeIn = 0.8;
        g.fadeOut = 0.8;
        g.fadePower = 10;

        // Physics-like behavior
        g.gravity = 1;          // Downward acceleration factor
        g.size = 0.1;           // Default base size of each particle
        g.sizeRand = 0.5;       // Random variation in size
        g.rotSpeed = 10;        // Rotation speed factor
        g.speed = 2;            // Base velocity
        g.speedRand = 0.5;      // Random variation in velocity
        g.life = 2;             // Particle lifetime in seconds
        g.lifeRand = 0.5;       // Variation in lifetime
        g.nparts = 10000;       // Maximum number of particles in this group

        // 3) Expose interactive sliders/checkboxes for user input
        addSlider("Amount",
            function() return parts.amount,
            function(v) parts.amount = v
        );

        addSlider("Speed",
            function() return g.speed,
            function(v) g.speed = v,
            0,
            10
        );

        addSlider("Gravity",
            function() return g.gravity,
            function(v) g.gravity = v,
            0,
            5
        );

        addCheck("Sort",
            function() return g.sortMode == Dynamic,
            function(v) g.sortMode = v ? Dynamic : None
        );

        addCheck("Loop",
            function() return g.emitLoop,
            function(v)
            {
                g.emitLoop = v;
                // Reset the particle timeline if turning off loop
                if (!v) parts.currentTime = 0;
            }
        );

        addCheck("Move",
            function() return moving,
            function(v) moving = v
        );

        addCheck("Relative",
            function() return g.isRelative,
            function(v) g.isRelative = v
        );

        // 4) Handle the end of the particle emission.
        // For instance, we change background color (fading out, below).
        parts.onEnd = function()
        {
            engine.backgroundColor = 0xFF000080;
            parts.currentTime = 0;
        };

        // 5) Register the group with the particle system
        parts.addGroup(g);
        group = g;

        // 6) A simple camera controller for rotating the scene in 3D.
        new h3d.scene.CameraController(20, s3d);

        // 7) Create a bounding box that encloses the region where particles can appear.
        //    We pass 'parts.bounds' to help visualize the group’s bounding area.
        box = new h3d.scene.Box(0x80404050, parts.bounds, parts);

        // 8) Create a text element on top of the 2D overlay for status updates.
        tf = addText();
    }


    /**
     * Per-frame logic. dt is the delta time in seconds since last frame.
     */
    override function update(dt:Float)
    {
        // If user toggles motion, gently move the entire emitter in a circle
        if (moving)
        {
            time += dt * 0.6;
            parts.x = Math.cos(time) * 5;
            parts.y = Math.sin(time) * 5;
        }

        // Gradually fade the background color if set to non-zero alpha or a certain threshold.
        // Typically fade out any leftover color from onEnd callback.
        if ((engine.backgroundColor & 0xFFFFFF) > 0)
        {
            engine.backgroundColor -= 8;
        }

        // 1) current active particle ratio in the group
        //    @:privateAccess used to access the group's private var if it’s allowed
        var cur = @:privateAccess group.currentParts;

        // Display the percentage of active particles vs. the maximum
        tf.text = "cur=" + Std.int(cur * 100 / group.nparts) + "%";

        // 2) If the system has recently uploaded new geometry buffers, show that too
        if (parts.uploadedCount > 0)
        {
            tf.text += " U=" + parts.uploadedCount;
        }
    }


    /**
     * Main entry point for launching the GpuParticles sample.
     */
    static function main()
    {
        new GpuParticles();
    }
}
