
class PbrShader extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;

		@param var exposure : Float;

		@param var dirLight : Vec3;

		@const var specularMode : Bool;
		@param var specularPower : Float;

		@param var roughness : Float;

		function fragment() {

			var color = pixelColor.rgb;

			var dirLight = (-dirLight).normalize();
			var normal = transformedNormal.normalize();
			var view = (camera.position - transformedPosition).normalize();


			var lambert = dirLight.dot(normal).max(0.);

			if( specularMode ) {

				var r = reflect(-dirLight, normal).normalize();
				var specValue = r.dot(view).max(0.).pow(specularPower);
				color *= (lambert + specValue);

			} else {

				color *= lambert;


				var alpha = roughness.pow(2);

				// GGX (Trowbridge-Reitz)

				// var D = alpha.pow(2) / (PI * ( n.dot(m).pow(2) * (alpha.pow(2) - 1.) + 1).pow(2));


				// reinhard tonemapping
				color *= exp(exposure);
				color = color / (color + vec3(1.));

				// gamma correct
				color = color.pow(vec3(1 / 2.2));

			}


			pixelColor.rgb = color;
		}

	}

	public function new() {
		super();
		exposure = 0;
		specularMode = true;
		specularPower = 40;
		dirLight.set(0.5, -0.5, -1);
	}

}

class Pbr extends hxd.App {

	var fui : h2d.Flow;
	var cameraRot = Math.PI / 4;
	var cameraDist = 5.5;
	var font : h2d.Font;

	override function init() {

		font = hxd.res.DefaultFont.get();

		var sp = new h3d.prim.Sphere(1, 128, 128);
		sp.addNormals();
		sp.addUVs();
		var sphere = new h3d.scene.Mesh(sp, s3d);
		var shader = sphere.material.mainPass.addShader(new PbrShader());

		fui = new h2d.Flow(s2d);
		fui.y = 5;
		fui.verticalSpacing = 5;
		fui.isVertical = true;

		var g = new h3d.scene.Graphics(s3d);
		g.lineStyle(1, 0xFF0000);
		g.moveTo(0, 0, 0);
		g.lineTo(2, 0, 0);
		g.lineStyle(1, 0x00FF00);
		g.moveTo(0, 0, 0);
		g.lineTo(0, 2, 0);
		g.lineStyle(1, 0x0000FF);
		g.moveTo(0, 0, 0);
		g.lineTo(0, 0, 2);
		g.lineStyle();

		addCheck("Specular", function() return shader.specularMode, function(b) { trace(b); shader.specularMode = b; });
		addSlider("Specular Power", 0, 30, function() return shader.specularPower, function(v) shader.specularPower = v);
		addSlider("Exposure", -3, 3, function() return shader.exposure, function(v) shader.exposure = v);

		s2d.addEventListener(onEvent);
	}

	function onEvent(e:hxd.Event) {
		switch( e.kind ) {
		case EPush:
			var px = e.relX;
			s2d.startDrag(function(e2) {
				switch( e2.kind ) {
				case EMove:
					var dx = e2.relX - px;
					px += dx;
					cameraRot += dx * 0.01;
				case ERelease:
					s2d.stopDrag();
				default:
				}
			});
		case EWheel:
			cameraDist *= Math.pow(1.1, e.wheelDelta);
		default:
		}
	}

	function addCheck( text, get : Void -> Bool, set : Bool -> Void ) {


		var i = new h2d.Interactive(80, font.lineHeight, fui);
		i.backgroundColor = 0xFF808080;

		fui.getProperties(i).paddingLeft = 20;

		var t = new h2d.Text(font, i);
		t.maxWidth = i.width;
		t.text = text+":"+(get()?"ON":"OFF");
		t.textAlign = Center;

		i.onClick = function(_) {
			var v = !get();
			trace(v);
			set(v);
			t.text = text + ":" + (v?"ON":"OFF");
		};
		i.onOver = function(_) {
			t.textColor = 0xFFFFFF;
		};
		i.onOut = function(_) {
			t.textColor = 0xEEEEEE;
		};
		i.onOut(null);
	}

	function addSlider( text, min : Float, max : Float, get : Void -> Float, set : Float -> Void ) {
		var f = new h2d.Flow(fui);

		f.horizontalSpacing = 5;

		var tf = new h2d.Text(font, f);
		tf.text = text;
		tf.maxWidth = 100;
		tf.textAlign = Right;

		var sli = new h2d.Slider(100, 10, f);
		sli.minValue = min;
		sli.maxValue = max;
		sli.value = get();

		var tf = new h2d.TextInput(font, f);
		tf.text = "" + hxd.Math.fmt(sli.value);
		sli.onChange = function() {
			set(sli.value);
			tf.text = "" + hxd.Math.fmt(sli.value);
			f.needReflow = true;
		};
		tf.onChange = function() {
			var v = Std.parseFloat(tf.text);
			if( Math.isNaN(v) ) return;
			sli.value = v;
			set(v);
		};
	}

	override function update(dt:Float) {
		s3d.camera.pos.set(Math.cos(cameraRot) * cameraDist, Math.sin(cameraRot) * cameraDist, cameraDist * 2 / 3);
	}

	static function main() {
		#if hl
		@:privateAccess {
			hxd.System.windowWidth = 1280;
			hxd.System.windowHeight = 800;
		}
		#end
		new Pbr();
	}

}
