package h3d.impl;

//avoid to enable depthWrite with me
class PointShader extends h3d.impl.Shader {

#if flash
	 static var SRC = {
		var input : {
			pos : Float2,
		};
		var tuv : Float2;
		function vertex( mproj : Matrix, delta : Float4, size : Float2 ) {
			var p = delta * mproj;
			p.xy += input.pos.xy * size * p.z;
			out = p;
			tuv = input.pos;
		}
		function fragment( color : Color ) {
			kill( 1 - (tuv.x * tuv.x + tuv.y * tuv.y) );
			out = color;
		}
	}
#elseif (js || cpp)

	static var VERTEX = "
		attribute vec2 pos;
		varying mediump vec2 tuv;
		uniform mat4 mproj;
		uniform vec4 delta;
		uniform vec2 size;
		
		void main(void) {
			vec4 p = delta * mproj;
			p.xy += pos.xy * size * p.z;
			tuv = pos;
			gl_Position = p;
		}
	";
	static var FRAGMENT = "
		varying mediump vec2 tuv;
		uniform vec4 color /*byte4*/;
		
		void main(void) {
			if( 1.0 - dot(tuv, tuv) < 0.0 ) discard;
			gl_FragColor = color;
		}
	";

#end
	
}

//avoid to enable depthWrite with me
class LineShader extends h3d.impl.Shader {

#if flash
	static var SRC = {
		var input : {
				pos : Float2,
		};

		function vertex( mproj : Matrix, start : Float4, end : Float4 ) {
				var spos = start * mproj;
				var epos = end * mproj;
				var delta = epos.xy  - spos.xy;
				delta.xy *= 1 / sqrt(delta.x * delta.x + delta.y * delta.y);
				
				
				var p = (epos - spos) * (input.pos.x + 1) * 0.5 + spos;
				p.xy += delta.yx * input.pos.y * p.z / 400;
				out = p;
		}
		function fragment( color : Color ) {
				out = color;
		}
	}
	
#elseif (js || cpp)

	static var VERTEX = "
		attribute vec2 pos;
		
		uniform mat4 mproj;
		uniform vec4 start;
		uniform vec4 end;
		
		void main(void) {
			
			vec4 spos = start*mproj;
			vec4 epos = end*mproj;
			vec2 delta = epos.xy  - spos.xy;
			normalize(delta);
			
			vec4 p = (epos - spos) * (pos.x + 1.0) * 0.5 + spos;
			p.xy += delta.yx * pos.y * p.z / 400.0;
			gl_Position = p;
		}
	";
	
	static var FRAGMENT = "
		uniform vec4 color /*byte4*/;
		void main(void) {
			gl_FragColor = color;
		}
	";
	
#end
}


