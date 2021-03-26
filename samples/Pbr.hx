class Pbr extends SampleApp {

	var hue : Float;
	var saturation : Float;
	var brightness : Float;
	var color : h2d.Bitmap;
	var sphere : h3d.scene.Mesh;
	var grid : h3d.scene.Object;

	var env : h3d.scene.pbr.Environment;
	var renderer : h3d.scene.pbr.Renderer;

	function new() {
		h3d.mat.MaterialSetup.current = new h3d.mat.PbrMaterialSetup();
		super();
	}

	override function init() {
		super.init();

		new h3d.scene.CameraController(5.5, s3d);

		#if flash
		new h2d.Text(getFont(), s2d).text = "Not supported on this platform (requires render to mipmap target and fragment textureCubeLod support)";
		return;
		#end

		#if js
		if( !engine.driver.hasFeature(ShaderModel3) ) {
			new h2d.Text(getFont(), s2d).text = "WebGL 2.0 support required and not available on this browser.";
			return;
		}
		#end

		var sp = new h3d.prim.Sphere(1, 128, 128);
		sp.addNormals();
		sp.addUVs();

		var bg = new h3d.scene.Mesh(sp, s3d);
		bg.scale(10);
		bg.material.mainPass.culling = Front;
		bg.material.mainPass.setPassName("overlay");

		fui = new h2d.Flow(s2d);
		fui.y = 5;
		fui.verticalSpacing = 5;
		fui.layout = Vertical;

		var envMap = new h3d.mat.Texture(512, 512, [Cube]);
		inline function set(face:Int, res:hxd.res.Image) {
			var pix = res.getPixels();
			envMap.uploadPixels(pix, 0, face);
		}
		set(0, hxd.Res.front);
		set(1, hxd.Res.back);
		set(2, hxd.Res.right);
		set(3, hxd.Res.left);
		set(4, hxd.Res.top);
		set(5, hxd.Res.bottom);

		var axis = new h3d.scene.Graphics(s3d);
		axis.lineStyle(2, 0xFF0000);
		axis.lineTo(2, 0, 0);
		axis.lineStyle(2, 0x00FF00);
		axis.moveTo(0, 0, 0);
		axis.lineTo(0, 2, 0);
		axis.lineStyle(2, 0x0000FF);
		axis.moveTo(0, 0, 0);
		axis.lineTo(0, 0, 2);

		axis.material.props = h3d.mat.MaterialSetup.current.getDefaults("ui");
		axis.visible = false;
		axis.material.mainPass.depthWrite = true;

		env = new h3d.scene.pbr.Environment(envMap);
		env.compute();

		renderer = cast(s3d.renderer, h3d.scene.pbr.Renderer);
		renderer.env = env;

		var cubeShader = bg.material.mainPass.addShader(new h3d.shader.pbr.CubeLod(env.env));
		var light = new h3d.scene.pbr.PointLight(s3d);
		light.setPosition(30, 10, 40);
		light.range = 100;
		light.power = 2;

		var pbrValues = new h3d.shader.pbr.PropsValues(0.2,0.5);
		hue = 0;
		saturation = 0;
		brightness = 0.2;

		function addSphere(x,y) {
			var sphere = new h3d.scene.Mesh(sp, s3d);
			sphere.x = x;
			sphere.y = y;
			return sphere;
		}

		sphere = addSphere(0, 0);
		sphere.material.mainPass.addShader(pbrValues);

		grid = new h3d.scene.Object(s3d);
		var max = 8;
		for( x in 0...max )
			for( y in 0...max ) {
				var s = addSphere(x - (max - 1) * 0.5, y - (max - 1) * 0.5);
				grid.addChild(s);
				s.scale(0.4);
				s.material.mainPass.addShader(new h3d.shader.pbr.PropsValues( 1 - x / (max - 1), 1 - y / (max - 1) ));
			}
		grid.visible = false;

		// camera
		addSlider("Exposure", function() return renderer.exposure, function(v) renderer.exposure = v, -3, 3);
		addSlider("Sky", function() return env.power, function(v) env.power = v, 0, 3);
		addSlider("Light", function() return light.power, function(v) light.power = v, 0, 10);

		// material color
		color = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 30, 30), fui);
		fui.getProperties(color).paddingLeft = 150;
		addSlider("Hue", function() return hue, function(v) hue = v, 0, Math.PI*2);
		addSlider("Saturation", function() return saturation, function(v) saturation = v);
		addSlider("Brightness", function() return brightness, function(v) brightness = v, -1, 1);

		addSlider("Metalness", function() return pbrValues.metalnessValue, function(v) pbrValues.metalnessValue = v);
		addSlider("Roughness", function() return pbrValues.roughnessValue, function(v) pbrValues.roughnessValue = v);

		// debug
		addCheck("Axis", function() return axis.visible, function(b) axis.visible = b);
		addCheck("Grid", function() return grid.visible, function(b) {
			grid.visible = !grid.visible;
			sphere.visible = !sphere.visible;
		});

		var r = Math.sqrt(2);
		var cube = new h3d.prim.Cube(r,r,r);
		cube.unindex();
		cube.addNormals();
		cube.addUVs();
		cube.translate( -r * 0.5, -r * 0.5, -r * 0.5);
		var prims : Array<h3d.prim.Primitive> = [sp, cube];
		addChoice("Prim", ["Sphere","Cube"], function(i) sphere.primitive = prims[i], prims.indexOf(sphere.primitive));

		addChoice("EnvMap", ["Default", "IDiff", "ISpec"], function(i) {
			cubeShader.texture = [env.env, env.diffuse, env.specular][i];
		});
		addSlider("EnvLod", function() return cubeShader.lod, function(v) cubeShader.lod = v, 0, env.specLevels);

	}

	function addSeparator() {
		fui.getProperties(fui.getChildAt(fui.numChildren - 1)).paddingBottom += 20;
	}

	override function update(dt:Float) {

		if( grid == null ) return;

		var color = new h3d.Vector(1, 0, 0);
		var m = new h3d.Matrix();
		m.identity();
		m.colorSaturate(saturation - 1);
		m.colorHue(hue);
		m.colorLightness(brightness);
		color.transform3x4(m);
		color.setColor(color.toColor()); // saturate

		this.color.color.load(color);
		this.sphere.material.color.load(color);
		for( s in grid )
			s.toMesh().material.color.load(color);

	}

	// ---------------------


	static function main() {
		#if hl
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end
		new Pbr();
	}

}
