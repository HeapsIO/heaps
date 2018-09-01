package h3d.scene;

class Sphere extends Graphics {

	public var color : Int;
	public var radius(default, set) : Float;

	public function new( ?color = 0xFFFF0000, ?radius : Float=1.0, ?depth = true, ?parent) {
		super(parent);
		this.color = color;
		this.radius = radius;
		if( !depth ) material.mainPass.depth(true, Always);
	}

	function set_radius(v: Float) {
		this.radius = v;
		refresh();
		return v;
	}

	function refresh() {
		clear();
		lineStyle(1, color);

		var nsegments = 32;

		inline function circle(f) {
			for(i in 0...nsegments) {
				var c = hxd.Math.cos(i / (nsegments - 1) * hxd.Math.PI * 2.0) * radius;
				var s = hxd.Math.sin(i / (nsegments - 1) * hxd.Math.PI * 2.0) * radius;
				f(i, c, s);
			}
		}
		inline function seg(i, x, y, z) {
			if(i == 0)
				moveTo(x, y, z);
			else
				lineTo(x, y, z);
		}

		circle(function(i, c, s) return seg(i, c, s, 0));
		circle(function(i, c, s) return seg(i, 0, c, s));
		circle(function(i, c, s) return seg(i, c, 0, s));
	}

	override function getLocalCollider() {
		return null;
	}

	override function sync(ctx) {
		super.sync(ctx);
	}

}