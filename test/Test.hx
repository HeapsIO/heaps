
class Proto extends hxsl.Shader {

	static var SRC = {
		
	// globals are injected by passes, they are not local to the per-shader-object. They are thus accessible in sub passes as well
	@global var camera : {
		var view : Mat4;
		var proj : Mat4;
		var projDiag : Vec3; // [_11,_22,_33]
		var viewProj : Mat4;
		var inverseViewProj : Mat4;
		@var var dir : Vec3; // allow mix of variable types in structure (each variable is independent anyway)
	};

	@global var global : {
		var time : Float;
		var modelView : Mat4;
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
	
	// each __init__ expr is out of order dependency-based
	function __init__() {
		transformedPosition = global.modelView.mat3x4() * vec4(input.position, 1);
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

class Test {
	
	static function main() {
		trace("Hello World");
	}
		
}