package h3d.shader;

class UVScroll extends hxsl.Shader {

	static var SRC = {
		@global var global : {
			var time : Float;
		};
		@param var uvSpeed : Vec2;
		var calculatedUV : Vec2;
		function vertex() {
			calculatedUV += uvSpeed * global.time;
		}
	};

	public function new( vx = 0., vy = 0. ) {
		super();
		uvSpeed.set(vx, vy);
	}

}