package h3d.scene;

class Capsule extends Graphics {

	public var color : Int;
	public var radius(default, set) : Float;
	public var length(default, set) : Float;

	public function new( ?color = 0xFFFF0000, ?radius : Float=1.0, ?length : Float=2.0, ?depth = true, ?parent) {
		super(parent);
		this.color = color;
		this.radius = radius;
		this.length = length;
		if( !depth ) material.mainPass.depth(true, Always);
	}

	function set_radius(v: Float) {
		this.radius = v;
		refresh();
		return v;
	}

	function set_length(v: Float) {
		this.length = v;
		refresh();
		return v;
	}

	function refresh() {
		clear();
		lineStyle(1, color);

		function line(y, z) {
			moveTo(-length * 0.5, y, z);
			lineTo(length * 0.5, y, z);
		}
		line(radius, 0.0);
		line(-radius, 0.0);
		line(0.0, radius);
		line(0.0, -radius);

		var nsegments = 32;
		inline function circle(f, section = 2.0, start = 0) {
			for(i in 0...nsegments) {
				var j = i + start;
				var c = hxd.Math.cos(j / (nsegments - 1) * hxd.Math.PI * section) * radius;
				var s = hxd.Math.sin(j / (nsegments - 1) * hxd.Math.PI * section) * radius;
				f(i, c, s);
			}
		}
		inline function seg(i, x, y, z) {
			if(i == 0)
				moveTo(x, y, z);
			else
				lineTo(x, y, z);
		}

		circle(function(i, c, s) return seg(i, length * 0.5, c, s));
		circle(function(i, c, s) return seg(i, -length * 0.5, c, s));
		circle(function(i, c, s) return seg(i, c + length * 0.5, s, 0), 1.0, -nsegments >> 1);
		circle(function(i, c, s) return seg(i, c - length * 0.5, s, 0), 1.0, nsegments >> 1);
		circle(function(i, c, s) return seg(i, c + length * 0.5, 0, s), 1.0, -nsegments >> 1);
		circle(function(i, c, s) return seg(i, c - length * 0.5, 0, s), 1.0, nsegments >> 1);
	}

	override function getLocalCollider() {
		return null;
	}
}