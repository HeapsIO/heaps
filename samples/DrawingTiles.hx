class DrawingTiles extends SampleApp {

	override function init() {
		super.init();

		var logo = hxd.Res.hxlogo.toTile();
		var normalmap = hxd.Res.normalmap.toTile();

		var hbox = new h2d.Flow(fui);
		hbox.horizontalSpacing = 10;

		// Bitmap renders a singular Tile
		new h2d.Bitmap(hxd.Res.hxlogo.toTile(), hbox);

		// TileGroup allows to batch-render multiple tiles.
		// Best performance ahieved when all Tiles are from same Texture.
		var tilegroup = new h2d.TileGroup(hbox);
		var tileSize = logo.width / 8;
		var tiles = logo.gridFlatten(tileSize);
		hxd.Math.shuffle(tiles);
		var i = 0;
		for ( y in 0...8 ) {
			for ( x in 0...8 ) {
				tilegroup.add(x * tileSize, y * tileSize, tiles[i++]);
				if (Math.random() > 0.7) {
					// TileGroup supports different texture sources.
					// but each texture swap causes new drawcall,
					// so it's adviced to use single texture for all group contents.
					tilegroup.addAlpha(x * tileSize, y * tileSize, 0.2, normalmap.sub((normalmap.width - tileSize) * Math.random(), (normalmap.height - tileSize) * Math.random(), tileSize, tileSize));
				}
			}
		}

		// SpriteBatch also allow to batch-render multiple tiles.
		// Compared to TileGroup - it's a dynamic tile geometry and reflushed to GPU every frame.
		// Same drawcall optimizations with unique texture count apply to SpriteBatch.
		var sprites = new h2d.SpriteBatch(null, hbox);
		// Causes containing sprites to receieve `update` calls.
		sprites.hasUpdate = true;
		// Tells SpriteBatch to calculate scale and rotation for sprites.
		// More CPU-intensive.
		sprites.hasRotationScale = true;
		tiles = logo.gridFlatten(tileSize);
		var i = 0;
		for ( y in 0...8 ) {
			for ( x in 0...8 ) {
				var s = new CustomSprite(tiles[i++].center());
				s.x = x * tileSize + tileSize * .5;
				s.y = y * tileSize + tileSize * .5;
				sprites.add(s);
				if ( Math.random() > 0.7 ) {
					var o = new CustomSprite(normalmap.sub((normalmap.width - tileSize) * Math.random(), (normalmap.height - tileSize) * Math.random(), tileSize, tileSize, -tileSize*.5, -tileSize*.5));
					o.x = x * tileSize + tileSize * .5;
					o.y = y * tileSize + tileSize * .5;
					o.alpha = 0.2;
					o.offset = s.offset;
					if (s.effect == 2) o.effect = 0;
					else o.effect = s.effect;
					sprites.add(o);
				}
			}
		}

		// h2d.Graphics can render tiles along with other types of graphics.
		var g = new h2d.Graphics(fui);
		g.drawTile(0, 0, logo);
		// Make drawn textures to wrap UV around.
		// In this tile fill, it starts at 0-0, and drawn outside texture boundaries,
		// if tileWrap is off, it will cause it to render borders of the logo.
		g.tileWrap = true;
		g.beginTileFill(0, 0, 1, 1, logo);
		var ow = logo.width;
		for (pt in [[65, 41], [97, 41], [128, 57], [159, 41], [191, 41], [191, 73], [175, 104], [191, 136], [191, 168],
								[159, 168], [128, 152], [97, 168], [65, 168], [65, 168], [65, 136], [81, 104], [65, 73]]) {
			g.lineTo(ow + pt[0], pt[1]);
		}
		g.drawRect(ow + 64, 183, 129, 34);
	}

	static function main() {
		hxd.Res.initEmbed();
		new DrawingTiles();
	}

}

class CustomSprite extends h2d.SpriteBatch.BatchElement {

	public var effect : Int;
	public var offset : Float;

	public function new( t ) {
		super(t);
		effect = Std.random(4);
		offset = Math.random();
	}

	override function update( et : Float ):Bool {
		switch ( effect ) {
			case 0:
				scale = Math.sin(hxd.Timer.lastTimeStamp + offset);
			case 1:
				rotation += et;
			case 2:
				alpha = (hxd.Timer.lastTimeStamp + offset) % 1;
			case 3:
				t.setCenterRatio(Math.cos(hxd.Timer.lastTimeStamp + offset), Math.sin(hxd.Timer.lastTimeStamp + offset));
		}
		return true;
	}

}