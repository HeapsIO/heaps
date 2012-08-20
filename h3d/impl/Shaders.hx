package h3d.impl;

class PointShader extends Shader {

	static var SRC = {
		var input : {
			pos : Float2,
		};
		var tuv : Float2;
		function vertex( mproj : Matrix, delta : Float4, size : Float2 ) {
			var p = delta * mproj;
			p.xy += pos.xy * size;
			out = p;
			tuv = pos;
		}
		function fragment( color : Color ) {
			kill( 1 - (tuv.x * tuv.x + tuv.y * tuv.y) );
			out = color;
		}
	}
	
}

class LineShader extends Shader {

	static var SRC = {
		var input : {
			pos : Float2,
		};

		function vertex( mproj : Matrix, start : Float4, end : Float4 ) {
			var spos = start * mproj;
			var epos = end * mproj;
			var delta = epos.xy  - spos.xy;
			delta.xy *= 1 / sqrt(delta.x * delta.x + delta.y * delta.y);
			
			
			var p = (epos - spos) * (pos.x + 1) * 0.5 + spos;
			p.xy += delta.yx * pos.y;
			out = p;
		}
		function fragment( color : Color ) {
			out = color;
		}
	}
	
}