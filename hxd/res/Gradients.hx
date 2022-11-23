package hxd.res;
import hxd.fmt.grd.Data;

class Gradients extends Resource {
	var data : Data;

	// creates a texture for the specified "name" gradient
	public function toTexture(name : String, ?resolution = 256) : h3d.mat.Texture {
		var data = getData();
		return createTexture([data.get(name)], resolution);
	}

	// creates a texture for each gradient
	public function toTextureMap(?resolution = 256) : Map<String, h3d.mat.Texture> {
		var map  = new Map<String, h3d.mat.Texture>();
		var data = getData();
		for (d in data) map.set(d.name, createTexture([d], resolution));
		return map;
	}

	// all gradients are written into the same texture
	public function toTileMap(?resolution = 256) : Map<String, h2d.Tile> {
		var data  = getData();
		var grads = [for (d in data) d];
		var tex   = createTexture(grads, resolution);
		var tile  = h2d.Tile.fromTexture(tex);

		var map = new Map<String, h2d.Tile>();
		var y = 1;
		for (d in grads) {
			map.set(d.name, tile.sub(0, y, resolution, 1));
			y += 3;
		}
		return map;
	}

	static function createTexture(grads : Array<Gradient>, twid : Int) {
		if (!hxd.Math.isPOT(twid)) throw "gradient resolution should be a power of two";

		var ghei = grads.length > 1 ? 3 : 1;
		var thei = hxd.Math.nextPOT(ghei * grads.length);
		var tex  = new h3d.mat.Texture(twid, thei);

		function uploadPixels() {
			var pixels = hxd.Pixels.alloc(twid, thei, ARGB);
			var yoff   = 0;
			for (g in grads) {
				appendPixels(pixels, g, tex.width, ghei, yoff);
				yoff += ghei;
			}
			tex.uploadPixels(pixels);
			pixels.dispose();
		}

		uploadPixels();
		tex.realloc = uploadPixels;
		return tex;
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

		{	// create gradient pixels
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
		var fs = entry.open();
		data = new hxd.fmt.grd.Reader(fs).read();
		fs.close();
		return data;
	}
}