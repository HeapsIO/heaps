package hxd.res;
import hxd.fmt.grd.Data;

class Gradients extends Resource {
	var data : Data;

	// creates a texture for the specified "name" gradient
	public function toTexture(name : String, ?resolution = 256) : h3d.mat.Texture {
		if (!isPOT(resolution)) throw "gradient resolution should be a power of two";

		var data   = getData();
		var pixels = hxd.Pixels.alloc(resolution, 1, ARGB);
		appendPixels(pixels, data.get(name), resolution, 1, 0);
		return h3d.mat.Texture.fromPixels(pixels);
	}

	// creates a texture for each specified gradient in "names"
	// if "names" is null, all gradient textures are created
	public function toTextureMap(?names : Array<String>, ?resolution = 256) : Map<String, h3d.mat.Texture> {
		if (!isPOT(resolution)) throw "gradient resolution should be a power of two";

		var data   = getData();
		var map    = new Map<String, h3d.mat.Texture>();
		var pixels = hxd.Pixels.alloc(resolution, 1, ARGB);

		for (d in data) {
			if (names != null && names.indexOf(d.name) < 0) continue;
			appendPixels(pixels, d, resolution, 1, 0);
			map.set(d.name, h3d.mat.Texture.fromPixels(pixels));
		}

		return map;
	}

	// all gradients are written into the same texture
	// if "names" is null, all gradient tiles are created
	@:access(h2d.Tile)
	public function toTileMap(?names : Array<String>, ?resolution = 256) : Map<String, h2d.Tile> {
		if (!isPOT(resolution)) throw "gradient resolution should be a power of two";

		var data   = getData();
		var map    = new Map<String, h2d.Tile>();

		var grads = [];
		var thei  = 0;
		for (d in data) {
			if (names != null && names.indexOf(d.name) < 0) continue;
			grads.push(d);
			thei += 3;
		}
		thei = nextPOT(thei);

		var pixels = hxd.Pixels.alloc(resolution, 1, ARGB);
		var yoff   = 0;
		for (d in grads) {
			appendPixels(pixels, d, resolution, 3, yoff);
			map.set(d.name, new h2d.Tile(null, 0, yoff + 1, resolution, 1));
			yoff += 3;
		}

		var tex = h3d.mat.Texture.fromPixels(pixels);
		for (t in map) t.setTexture(tex);

		return map;
	}

	inline function isPOT(v : Int) : Bool {
		return (v & (v - 1)) == 0;
	}

	inline function nextPOT(v : Int) : Int {
		--v;
		v |= v >> 1;
		v |= v >> 2;
		v |= v >> 4;
		v |= v >> 8;
		v |= v >> 16;
		return ++v;
	}

	static function appendPixels(pixels : hxd.Pixels, dat : Gradient, wid : Int, hei : Int, yoff : Int) {
		var colors = new Array<{value : h3d.Vector, loc : Int}>();

		{	// preprocess gradient data
			for (cs in dat.gradientStops) {
				var color : h3d.Vector;
				switch(cs.colorStop.color) {
					case RGB(r, g, b): color = new h3d.Vector(r / 255, g / 255, b / 255);
					case HSB(h, s, b): color = HSVtoRGB(h, s / 100, b / 100);
					default : throw "unhandled color type";
				}
				color.w = cs.opacity / 100;
				colors.push({value : color, loc : Std.int((wid-1) * cs.colorStop.location / dat.interpolation)});
			}
			colors.sort(function(a, b) { return a.loc - b.loc; } );

			if (colors[0].loc > 0)
				colors.unshift( { value : colors[0].value, loc : 0 } );
			if (colors[colors.length - 1].loc < wid - 1)
				colors.push( { value : colors[colors.length-1].value, loc : wid-1 } );
		}

		{	// create gradient texture
			var px = 0;
			var ci = 0; // color index
			var tmpCol = new h3d.Vector();

			while (px < wid) {
				var prevLoc = colors[ci    ].loc;
				var nextLoc = colors[ci + 1].loc;

				var prevCol = colors[ci    ].value;
				var nextCol = colors[ci + 1].value;

				while (px <= nextLoc) {
					tmpCol.lerp(prevCol, nextCol, (px - prevLoc) / (nextLoc - prevLoc));
					for (py in 0...hei) pixels.setPixel(px, yoff + py, tmpCol.toColor());
					++px;
				}
				++ci;
			}
		}
	}

	static function HSVtoRGB(h : Float, s : Float, v : Float) : h3d.Vector
	{
		var i : Int;
		var f : Float; var p : Float; var q : Float; var t : Float;
		if( s == 0 )
			return new h3d.Vector(v, v, v);
		h /= 60;
		i = Math.floor( h );
		f = h - i;
		p = v * ( 1 - s );
		q = v * ( 1 - s * f );
		t = v * ( 1 - s * ( 1 - f ) );
		switch( i ) {
			case 0 : return new h3d.Vector(v, t, p);
			case 1 : return new h3d.Vector(q, v, p);
			case 2 : return new h3d.Vector(p, v, t);
			case 3 : return new h3d.Vector(p, q, v);
			case 4 : return new h3d.Vector(t, p, v);
			default: return new h3d.Vector(v, p, q);
		}
	}

	function getData() : Data {
		if (data != null) return data;
		data = new hxd.fmt.grd.Reader(new hxd.fs.FileInput(entry)).read();
		return data;
	}
}