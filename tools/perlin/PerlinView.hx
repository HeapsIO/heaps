@:enum abstract Mode {
	var Perlin = 0;
	var Ridged = 1;
}

class PerlinView extends hxd.App {
	
	var globalScale : Float = 2;
	
	var bmp : h2d.Bitmap;
	var octaves = 3;
	var persist = 0.5;
	var lacunarity = 2.;
	var scale = 0.1;
	var seed = 0;
	var ridged = false;
	var gain = 2.0;
	var offset = 0.5;
	var mode = Mode.Perlin;
	
	var dx = 1000.;
	var dy = 1000.;
	
	override function onResize() {
		generate();
	}
	
	override function init() {
		var comp = h2d.comp.Parser.fromHtml('
			<div class="panel" style="padding:10px; dock:top; height : 20px">
				<span>Octaves</span> <slider min="1" max="10" value="${octaves}" style="increment:1" onchange="api.p.octaves = this.value; api.changed()"/>
				<span>Scale</span> <value id="scale" value="${1/scale}" onchange="api.p.scale = 1/this.value; api.changed()"/>
				<span>Persist</span> <value value="${persist}" increment="0.01" onchange="api.p.persist = this.value; api.changed()"/>
				<span>Lacunarity</span> <value value="${lacunarity}" increment="0.01" onchange="api.p.lacunarity = this.value; api.changed()"/>
				<span>Mode</span>
					<select value="${mode}" onchange="api.p.mode = this.value; api.changed()">
						<option value="0">Perlin</option>
						<option value="1">Ridged</option>
					</select>
				<span>Gain</span> <value value="${gain}" increment="0.01" onchange="api.p.gain = this.value; api.changed()"/>
				<span>Offset</span> <value value="${offset}" increment="0.01" onchange="api.p.offset = this.value; api.changed()"/>
			</div>
		',{ p : this, changed : generate });
		bmp = new h2d.Bitmap(null, s2d);
		bmp.filter = true;
		var i = new h2d.Interactive(3000, 3000, s2d);
		var drag = null;
		i.onPush = function(_) {
			drag = { x : s2d.mouseX, y : s2d.mouseY };
		};
		i.onRelease = function(_) {
			drag = null;
		};
		i.onMove = function(_) {
			if( drag == null ) return;
			var mx = s2d.mouseX - drag.x;
			var my = s2d.mouseY - drag.y;
			dx -= mx * scale * globalScale;
			dy -= my * scale * globalScale;
			drag.x += mx;
			drag.y += my;
			generate();
		};
		i.onWheel = function(e) {
			scale *= e.wheelDelta > 0 ? 1.1 : 0.9;
			Std.instance(comp.getElementById("scale"), h2d.comp.Value).value = 1/scale;
			generate();
		};
		i.cursor = Move;
		s2d.addChild(comp);
		generate();
	}
	
	function generate() {
		if( bmp.tile != null )
			bmp.tile.dispose();
		var bmp = new hxd.BitmapData(Math.ceil(engine.width/globalScale), Math.ceil(engine.height/globalScale));
		var p = new hxd.Perlin();
		p.select();
		var invMax = 255 * 0.5;
		var scale = scale * globalScale;
		var dx = dx - bmp.width * 0.5 * scale;
		var dy = dy - bmp.height * 0.5 * scale;
		for( y in 0...bmp.height )
			for( x in 0...bmp.width ) {
				inline function ridged(ds) {
					return p.ridged(seed+ds, x * scale + dx, y * scale + dy, octaves, offset, gain, persist, lacunarity);
				}
				inline function perlin(ds) {
					return p.perlin(seed+ds, x * scale + dx, y * scale + dy, octaves, persist, lacunarity);
				}
				var p;
				switch( mode ) {
				case Perlin:
					p = (perlin(0) + 1) * invMax;
				case Ridged:
					p = ridged(0) * 255;
				}
				var v = Std.int(p);
				if( v < 0 ) v = 0;
				if( v > 255 ) v = 255;
				bmp.setPixel(x, y, (v|(v<<8)|(v<<16)) | 0xFF000000);
			}
		this.bmp.tile = h2d.Tile.fromBitmap(bmp);
		this.bmp.setScale(globalScale);
		bmp.dispose();
	}
	
	static function main() {
		new PerlinView();
	}

}