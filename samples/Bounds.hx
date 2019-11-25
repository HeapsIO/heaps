class Bounds extends hxd.App {

	var boxes : Array<h2d.Bitmap>;
	var g : h2d.Graphics;
	var colors = [0xFF0000 , 0x00FF00 , 0x0000FF, 0xFF00FF];
	var time = 0.;

	override function init() {
		boxes = [];

		g = new h2d.Graphics(s2d);
		for( i in 0...colors.length ) {
			var size = Std.int(200 / (i + 4));
			var c = colors[i];
			var b = new h2d.Bitmap(h2d.Tile.fromColor(c, size, size, 0.5).sub(0, 0, size, size, -Std.random(size), -Std.random(size)), i == 0 ? s2d : boxes[i - 1]);
			b.addChild(new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 8, 8).sub(0, 0, 8, 8, -4, -4)));
			if( i == 0 ) {
				b.x = s2d.width * 0.5;
				b.y = s2d.height * 0.5;
			} else {
				b.x = Std.random(50) - 25;
				b.y = Std.random(50) - 25;
				if( b.x < 0 ) b.x -= size * 1.5 else b.x += size * 1.5;
				if( b.y < 0 ) b.y -= size * 1.5 else b.y += size * 1.5;
			}
			b.scale(1.2 - i * 0.1);
			boxes.push(b);
		}
		for( b in boxes )
			new h2d.Graphics(b);

		var tf = new h2d.Text(hxd.Res.customFont.toFont(), boxes[0]);
		tf.text = "Some quite long rotating text";
		tf.x = -5;
		tf.y = 15;
		tf.smooth = true;
	}

	override function update(dt:Float) {
		time += dt;
		g.clear();
		for( i in 0...boxes.length ) {
			var b = boxes[i];
			b.rotate( (i + 1) * dt * 0.06 );
			b.setScale(1 + Math.sin(time * 0.1 / (i + 2)) * 0.2);
			var b = b.getBounds();
			g.beginFill((colors[i]>>2)&0x3F3F3F);
			g.drawRect(b.x, b.y, b.width, b.height);
		}
		for( i in 1...2 ) {
			var prev = boxes[i - 1];
			var b = boxes[i].getBounds(prev);
			var g = hxd.impl.Api.downcast(prev.getChildAt(2), h2d.Graphics);
			g.clear();
			g.beginFill(0xFFFFFF, 0.5);
			g.drawRect(b.x, b.y, b.width, b.height);
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Bounds();
	}

}