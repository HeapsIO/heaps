
//
//  Resolve dependencies :
// 		Given a Proto + X shader modifiers, build a complete shader and optimize it
//		TODO : where to insert changes made by modifiers ?
//		it seems necessary to build a code tree with dependencies in order to allow code permutation
//		it is absolutely necessary to treat each struct field as a single variable (was not in HxSL)
	
Steps :
	A) apply conditionals / reduce
	B) calculate per-function dependencies
	C) resolve order
	D) eliminate code based on final pass requirement (output.color or another var)
	E) calculate used vars and classify them

	
Variable types:

	@global : no per-shader but per-pass (read-only)
	@param : per-object parameter (read - only)
	@input : vertex input
	@var (default) : variable available between shaders (tracked for dependency)

	Qualifiers:
		
	@private : for a @var, hide it from other shaders
	@const : qualifier for param (default) or global. Mean that the value is eliminated at compilation

Proto:
	
	// globals are injected by passes, they are not local to the per-shader-object. They are thus accessible in sub passes as well
	@global var camera : {
		var view : Matrix;
		var proj : Matrix;
		var projDiag : Float3; // [_11,_22,_33]
		var viewProj : Matrix;
		var inverseViewProj : Matrix;
		@var var dir : Float3; // allow mix of variable types in structure (each variable is independent anyway)
	};

	@global var global : {
		var time : Float;
		var modelView : Matrix;
		// ... other available globals in BasePass
	};
	
	@input var input : {
		var position : Float3;
		var normal : Float3;
	};
	
	var output : {
		var position : Float4; // written in vertex
		var color : Float4; // written in fragment
	};
	
	// vars are always exported
	
	var transformedPosition : Float3;
	var transformedNormal : Float3;
	var projectedPosition : Float4;
	var pixelColor : Float4;
	
	// each __init__ expr is out of order dependency-based
	function __init__() {
		transformedPosition = input.position * global.modelView;
		projectedPosition = float4(transformedPosition, 1) * camera.viewProj;
		transformedNormal = input.normal * global.modelView.m33;
		camera.dir = (camera.position - transformedPosition).normalize();
		pixelColor = color;
	}
	
	function vertex() {
		output.position = projectedPosition;
	}
	
	function fragment() {
		output.color = pixelColor;
	}
	
	
VertexColor
	
	@input var input : {
		var color : Float3;
	};
	
	var pixelColor : Float4;
	
	function vertex() {
		vertexColor = input.color;
	}
	
	function fragment() {
		pixelColor.rgb *= vertexColor;
	}


TextureMaterial

	// will add extra required fields to input
	@input var input : {
		var uv : Float2;
	};
	
	@const var additive : Bool;
	@const var killAlpha : Bool;
	@param var killAlphaThreshold : Float;
	
	@param var texture : Texture;
	var calculatedUV : Float2;
	var pixelColor : Float4;
	
	function vertex() {
		calculatedUV = input.uv;
	}
	
	function fragment() {
		var c = texture.get(calculatedUV);
		if( killAlpha ) kill(c.a - killAlphaThreshold); // in multipass, we will have to specify if we want to keep the kill's or not
		if( additive )
			pixelColor += c;
		else
			pixelColor *= c;
	}

	// ajouter plusieurs TextureMaterial permet de faire du multiTexturing (à partir des même UV)

AnimatedUV

	var calculatedUV : Float2;
	@global("global.time") var globalTime : Float;
	@param var animationUV : Float2;
	
	function vertex() {
		calculatedUV += animationUV * globalTime;
	}

	
LightSystem:

	// the light system is set by the pass setup, even if it's potentially per-object, it's still a global
	@global var light : {
		@const var perPixel : Bool;
		var ambient : Float3;
		var dirs : Array<{ dir : Float3, color : Float3 }>;
		var points : Array<{ pos : Float3, color : Float3, att : Float3 }>;
	};
	
	var transformedNormal : Float3; // will be tagged as read in either vertex or fragment depending on conditional
	
	@private var color : Float3; // will be tagged as written in vertex and read in fragment if !perPixel, or unused either
	
	var pixelColor : Float4; // will be tagged as read+written in fragment

	function calcLight() {
		var col = light.ambient;
		var tn = transformedNormal.normalize();
		for( d in light.dirs )
			col += d.color * tn.dot(-d.dir).max(0);
		for( p in light.points ) {
			var d = transformedPosition - p.pos;
			var dist2 = d.dot(d);
			var dist = dist2.sqt();
			col += p.color * (tn.dot(d).max(0) / (p.att.x * dist + p.att.y * dist2 + p.att.z * dist2 * dist));
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
	
	// DEPENDENCY:
		Vertex:
		READ transformedNormal   |-> must be inserted after all vertex that write transformNormals have been done
		READ transformedPosition |
		WRITE lightColor -> must be inserted before any vertex that reads light color
		Fragment:
		READ lightColor -> must be inserted after all fragments that write these two
		READ+WRITE pixelColor -> must be inserted after it's been written first, but then keep the shader order
		
	CONFLICT if a program read lightColor and write transformNormal (unresolved cycle)
	
	CONFLICT if a program inserted after WRITE both lightColor and pixelColor:
		writing lightColor will put it before, but since it also write pixelColor it should be after to enforce evaluation order
		the user should then put it before

	
Outline

	// Param are always local
	@param var color : Float4;
	@param var power : Float;
	@param var size : Float;
	
	var camera : {
		var projDiag : Float3;
		var dir : Float3;
	};
	var transformedNormal : Float3;

	function vertex() {
		transformedPosition.xy += transformedNormal.xy * camera.projDiag.xy * size;
	}
	
	function fragment() {
		var e = 1 - transformedNormal.normalize().dot(camera.dir.normalize());
		output.color = color * e.pow(power);
	}
	
Skin

	@input var input : {
		pos : Float3,
		normal : Float3,
		weights : Float3,
		indexes : Int,
	};
	
	var transformedPosition : Float3;
	var transformedNormal : Float3;
	
	function vertex() {
		var p = input.pos, n = input.normal;
		transformedPosition = p * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)] + p * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)] + p * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)];
		transformedNormal = n * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)].m33 + n * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)].m33 + n * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)].m33;
	}
	
	// will write TP/TN, hence disabling proto init

ApplyShadow

	@global var shadow : {
		var map : Texture;
		var color : Float3;
		var power : Float;
		var lightProj : Matrix;
		var lightCenter : Matrix;
	};

	// Nullable params, allow to check them in shaders. Will create a isNull Const automatically
	// actually use the global values unless object-specific local values are defined
	var shadowColor : Param<Null<Float3>>;
	var shadowPower : Param<Null<Float>>;

	var pixelColor : Float4;

	@:private var tshadowPos : Float3;
	
	function vertex() {
		tshadowPos = float4(transformedPosition,1) * shadow.lightProj * shadow.lightCenter;
	}
	
	function fragment() {
		var s = exp( (shadowPower == null ? shadow.power : shadowPower) * (tshadowPos.z - shadow.map.get(tshadowPos.xy).dot([1, 1 / 255, 1 / (255 * 255), 1 / (255 * 255 * 255)]))).sat();
		pixelColor.rgb *= (1 - s) * (shadowColor == null ? shadow.color : shadowColor) + s.xxx;
	}

DepthMap

	@global var depthDelta : Float;
	@:private var distance : Float;
	
	// the pass setup will have to declare that it will write distanceColor to its rendertarget
	var depthColor : Float4;

	function vertex() {
		distance = projectedPosition.z / projectedPosition.w + depthDelta;
	}
	
	function fragment() {
		var color : Float4 = (distance.xxxx * [1,255,255*255,255*255*255]).frac();
		depthColor = color - color.yzww * [1 / 255, 1 / 255, 1 / 255, 0];
	}

DistanceMap

	@global var distance : {
		var center : Float3;
		var scale : Float;
		var power : Float;
	};

	@private var dist : Float3;
	
	// the pass will have to declare that it will write distanceColor to its rendertarget
	var distanceColor : Float4;

	function vertex() {
		dist = (transformedPosition - center).abs();
	}
	
	function fragment() {
		var d = (dist.length() * scale).pow(power);
		var color : Float4 = (d.xxxx * [1,255,255*255,255*255*255]).frac();
		distanceColor = color - color.yzww * [1 / 255, 1 / 255, 1 / 255, 0];
	}

