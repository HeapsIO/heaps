
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
		var modelView : Mat4;
		var modelViewInverse : Mat4;
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

}

// ----------------------------------------------------------------------------------------------------------------

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
	
	function vertex() {
		calculatedUV += animationUV * globalTime;
	}
}
}

// ----------------------------------------------------------------------------------------------------------------

class LightSystem extends hxsl.Shader {
static var SRC = {

	@global("light.ndirs") @const var NDirLights : Int;
	@global("light.npoints") @const var NPointLights : Int;
	
	@global var light : {
		@const var perPixel : Bool;
		@const var ndirs : Int;
		@const var npoints : Int;
		var ambient : Vec3;
		var dirs : Array<{ dir : Vec3, color : Vec3 }, NDirLights>;
		var points : Array<{ pos : Vec3, color : Vec3, att : Vec3 }, NPointLights>;
	};
	
	var transformedPosition : Vec3;
	var transformedNormal : Vec3; // will be tagged as read in either vertex or fragment depending on conditional
	
	@private var color : Vec3; // will be tagged as written in vertex and read in fragment if !perPixel, or unused either
	
	var pixelColor : Vec4; // will be tagged as read+written in fragment

	function calcLight() : Vec3 {
		var col = light.ambient;
		var tn = transformedNormal.normalize();
		for( d in light.dirs )
			col += d.color * tn.dot(-d.dir).max(0.);
		for( p in light.points ) {
			var d = transformedPosition - p.pos;
			var dist2 = d.dot(d);
			var dist = dist2.sqrt();
			col += p.color * (tn.dot(d).max(0.) / p.att.dot(vec3(dist,dist2,dist2 * dist)));
		}
		return col;
	}
	
	function vertex() {
		if( !light.perPixel ) color = calcLight();
	}
	
	function fragment() {
		if( light.perPixel )
			pixelColor.rgb *= calcLight();
		else
			pixelColor.rgb *= color;
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
	
	var output : {
		var color : Vec4;
	};
	
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
		output.color = color * e.pow(power);
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

}}

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
	
	static function main() {
		var shaders = [
			new Proto().compile(),
			new Outline().compile(),
		];
		var s = new hxsl.Linker().link(shaders, "vertex", "out.color");
		trace("\n"+hxsl.Printer.shaderToString(s));
	}
		
}