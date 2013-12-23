
class Proto extends hxsl.Shader {

	static var SRC = {
		
	// globals are injected by passes, they are not local to the per-shader-object. They are thus accessible in sub passes as well
	@global var camera : {
		var view : Mat4;
		var proj : Mat4;
		var position : Vec3;
		var projDiag : Vec3; // [_11,_22,_33]
		var viewProj : Mat4;
		var inverseViewProj : Mat4;
		@var var dir : Vec3; // allow mix of variable types in structure (each variable is independent anyway)
	};

	@global var global : {
		var time : Float;
		@perObject var modelView : Mat4;
		@perObject var modelViewInverse : Mat4;
		// ... other available globals in BasePass
	};
	
	@input var input : {
		var position : Vec3;
		var normal : Vec3;
	};
	
	var output : {
		var position : Vec4; // written in vertex
		var color : Vec4; // written in fragment
	};
	
	// vars are always exported
	
	var transformedPosition : Vec3;
	var transformedNormal : Vec3;
	var projectedPosition : Vec4;
	var pixelColor : Vec4;
	
	@param var color : Vec4;
	
	// each __init__ expr is out of order dependency-based
	function __init__() {
		transformedPosition = global.modelView.mat3x4() * input.position;
		projectedPosition = camera.viewProj * vec4(transformedPosition, 1);
		transformedNormal = global.modelViewInverse.mat3() * input.normal;
		camera.dir = (camera.position - transformedPosition).normalize();
		pixelColor = color;
	}
	
	function vertex() {
		output.position = projectedPosition;
	}
	
	function fragment() {
		output.color = pixelColor;
	}

	};
	
	public function new() {
		super();
		color.set(1, 1, 1);
	}

}

// -------------------buildGlobals()---------------------------------------------------------------------------------------------

class VertexColor extends hxsl.Shader {
static var SRC = {
		
	@input var input : {
		var color : Vec3;
	};
	
	var pixelColor : Vec4;
	
	function fragment() {
		pixelColor.rgb *= input.color;
	}
	
}
}

// ----------------------------------------------------------------------------------------------------------------

class Texture extends hxsl.Shader {
static var SRC = {

	// will add extra required fields to input
	@input var input : {
		var uv : Vec2;
	};
	
	@const var additive : Bool;
	@const var killAlpha : Bool;
	@param var killAlphaThreshold : Float;
	
	@param var texture : Sampler2D;
	var calculatedUV : Vec2;
	var pixelColor : Vec4;
	
	function vertex() {
		calculatedUV = input.uv;
	}
	
	function fragment() {
		var c = texture.get(calculatedUV);
		if( killAlpha && c.a - killAlphaThreshold < 0 ) discard; // in multipass, we will have to specify if we want to keep the kill's or not
		if( additive )
			pixelColor += c;
		else
			pixelColor *= c;
	}
}
}

// ----------------------------------------------------------------------------------------------------------------

class AnimatedUV extends hxsl.Shader {
static var SRC = {
	var calculatedUV : Vec2;
	@global("global.time") var globalTime : Float;
	@param var animationUV : Vec2;
	@param var timeOffset : Float;
	
	function vertex() {
		calculatedUV += animationUV * (globalTime + timeOffset);
	}
}
}

// ----------------------------------------------------------------------------------------------------------------

class LightSystem extends hxsl.Shader {
static var SRC = {

	@global var light : {
		@const var perPixel : Bool;
		@const(16) var NDirs : Int;
		@const(64) var NPoints : Int;
		var ambient : Vec3;
		var dirDir : Array<Vec3, light.NDirs>;
		var dirColor : Array<Vec3, light.NDirs>;
		var pointPos : Array<Vec3, light.NPoints>;
		var pointColor : Array<Vec3, light.NPoints>;
		var pointAtt : Array<Vec3, light.NPoints>;
	};
	
	var transformedPosition : Vec3;
	var transformedNormal : Vec3; // will be tagged as read in either vertex or fragment depending on conditional
	var pixelColor : Vec4;

	function calcLight() : Vec3 {
		var col = light.ambient;
		var tn = transformedNormal.normalize();
		for( i in 0...light.NDirs )
			col += light.dirColor[i] * tn.dot(-light.dirDir[i]).max(0.);
		for( i in 0...light.NPoints ) {
			var d = transformedPosition - light.pointPos[i];
			var dist2 = d.dot(d);
			var dist = dist2.sqrt();
			col += light.pointColor[i] * (tn.dot(d).max(0.) / light.pointAtt[i].dot(vec3(dist,dist2,dist2 * dist)));
		}
		return col;
	}
	
	function vertex() {
		if( !light.perPixel ) pixelColor.rgb *= calcLight();
	}
	
	function fragment() {
		if( light.perPixel )
			pixelColor.rgb *= calcLight();
	}

}
}

// ----------------------------------------------------------------------------------------------------------------

class Outline extends hxsl.Shader {
static var SRC = {
	
	// Param are always local
	@param var color : Vec4;
	@param var power : Float;
	@param var size : Float;
	
	var pixelColor : Vec4;
	
	@global var camera : {
		var projDiag : Vec3;
		@var var dir : Vec3;
	};
	var transformedNormal : Vec3;
	var transformedPosition : Vec3;

	function vertex() {
		transformedPosition.xy += transformedNormal.xy * camera.projDiag.xy * size;
	}
	
	function fragment() {
		var e = 1. - transformedNormal.normalize().dot(camera.dir.normalize());
		pixelColor = color * e.pow(power);
	}

}}

// ----------------------------------------------------------------------------------------------------------------

class Skinning extends hxsl.Shader {
static var SRC = {

	@input var input : {
		pos : Vec3,
		normal : Vec3,
		weights : Vec3,
		indexes : IVec3,
	};
	
	var transformedPosition : Vec3;
	var transformedNormal : Vec3;
	
	@const var MaxBones : Int;
	@param var skinMatrixes : Array< Mat3x4, MaxBones >;
	
	function vertex() {
		var p = input.pos, n = input.normal;
		// TODO : accessing skimMatrixes should multiply by 255*3 in AGAL (byte converted to [0-1] float + stride for 3 vec4 per element)
		transformedPosition = skinMatrixes[input.indexes.x] * (p * input.weights.x) + skinMatrixes[input.indexes.y] * (p * input.weights.y) + skinMatrixes[input.indexes.z] * (p * input.weights.z);
		transformedNormal = skinMatrixes[input.indexes.x].mat3() * (n * input.weights.x) + skinMatrixes[input.indexes.y].mat3() * (n * input.weights.y) + skinMatrixes[input.indexes.z].mat3() * (n * input.weights.z);
	}

}

	public function new() {
		super();
		MaxBones = 34;
	}

}

// ----------------------------------------------------------------------------------------------------------------

class ApplyShadow extends hxsl.Shader {
static var SRC = {
	
	@global var shadow : {
		var map : Sampler2D;
		var color : Vec3;
		var power : Float;
		var lightProj : Mat4;
		var lightCenter : Mat4;
	};

	// Nullable params, allow to check them in shaders. Will create a isNull Const automatically
	// actually use the global values unless object-specific local values are defined
	@param @nullable var shadowColor : Vec3;
	@param @nullable var shadowPower : Float;

	var pixelColor : Vec4;
	var transformedPosition : Vec3;

	@private var tshadowPos : Vec3;
	
	function vertex() {
		tshadowPos = shadow.lightProj.mat3x4() * (shadow.lightCenter.mat3x4() * transformedPosition);
	}
	
	function fragment() {
		var s = exp( (shadowPower == null ? shadow.power : shadowPower) * (tshadowPos.z - shadow.map.get(tshadowPos.xy).dot(vec4(1, 1. / 255., 1. / (255. * 255.), 1. / (255. * 255. * 255.))))).saturate();
		pixelColor.rgb *= (1. - s) * (shadowColor == null ? shadow.color : shadowColor) + s.xxx;
	}

}}

// ----------------------------------------------------------------------------------------------------------------

class DepthMap extends hxsl.Shader {
static var SRC = {

	@global var depthDelta : Float;
	@private var distance : Float;
	
	// the pass setup will have to declare that it will write distanceColor to its rendertarget
	var depthColor : Vec4;

	var projectedPosition : Vec4;
	
	function vertex() {
		distance = projectedPosition.z / projectedPosition.w + depthDelta;
	}
	
	function fragment() {
		var color = (distance.xxxx * vec4(1.,255.,255.*255.,255.*255.*255.)).fract();
		depthColor = color - color.yzww * vec4(1. / 255., 1. / 255., 1. / 255., 0.);
	}

}}

// ----------------------------------------------------------------------------------------------------------------

class DistanceMap extends hxsl.Shader {
static var SRC = {

	@global var distance : {
		var center : Vec3;
		var scale : Float;
		var power : Float;
	};

	@private var dist : Vec3;
	
	// the pass will have to declare that it will write distanceColor to its rendertarget
	var distanceColor : Vec4;
	
	var transformedPosition : Vec3;

	function vertex() {
		dist = (transformedPosition - distance.center).abs();
	}
	
	function fragment() {
		var d = (dist.length() * distance.scale).pow(distance.power);
		var color = (d.xxxx * vec4(1.,255.,255.*255.,255.*255.*255.)).fract();
		distanceColor = color - color.yzww * vec4(1. / 255., 1. / 255., 1. / 255., 0.);
	}

}}

// ----------------------------------------------------------------------------------------------------------------

class Test {
	
	@:access(hxsl)
	static function main() {
		var shaders = [
			new Proto(),
			new LightSystem(),
			{ var t = new Texture(); t.killAlpha = true; t; },
			new AnimatedUV(),
			//new AnimatedUV(),
		];
		var globals = new hxsl.Globals();
		globals.set("light.NDirs", 1);
		globals.set("light.NPoints", 3);
		var instances = [for( s in shaders ) { s.updateConstants(globals); s.instance; }];
		var cache = hxsl.Cache.get();
		var s = cache.link(instances, cache.allocOutputVars(["output.position", "output.color"]));
		//trace("VERTEX=\n" + hxsl.Printer.shaderToString(s.vertex));
		//trace("FRAGMENT=\n" + hxsl.Printer.shaderToString(s.fragment));
		
		#if js
		haxe.Log.trace("START");
		try {
		
		var canvas = js.Browser.document.createCanvasElement();
		var gl = canvas.getContextWebGL();
		var GL = js.html.webgl.GL;
		
		function compile(kind, shader) {
			var code = hxsl.GlslOut.toGlsl(shader);
			trace(code);
			var s = gl.createShader(kind);
			gl.shaderSource(s, code);
			gl.compileShader(s);
			if( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) {
				var log = gl.getShaderInfoLog(s);
				var line = code.split("\n")[Std.parseInt(log.substr(9)) - 1];
				if( line == null ) line = "" else line = "(" + StringTools.trim(line) + ")";
				throw log + line;
			}
			return s;
		}
			
		var vs = compile(GL.VERTEX_SHADER, s.vertex.data);
		var fs = compile(GL.FRAGMENT_SHADER, s.fragment.data);
		
		var p = gl.createProgram();
		gl.attachShader(p, vs);
		gl.attachShader(p, fs);
		gl.linkProgram(p);
		if( gl.getProgramParameter(p, GL.LINK_STATUS) != cast 1 ) {
			var log = gl.getProgramInfoLog(p);
			throw "Program linkage failure: "+log;
		}
		
		trace("LINK SUCCESS");
		
		} catch( e : Dynamic ) {
			trace(e);
		}

		#end
	}
		
}