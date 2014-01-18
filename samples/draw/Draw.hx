class Draw extends hxd.App {
	
	override function init() {
		var g = new h2d.Graphics(s2d);
		g.beginFill(0xFF0000);
		g.drawRect(10, 10, 100, 100);
		g.addHole();
		g.drawRect(20, 20, 80, 80);
		g.beginFill(0x00FF00, 0.5);
		g.lineStyle(1, 0xFF00FF);
		g.drawCircle(100, 100, 30);
		g.endFill();
	}
	
	static function main() {
		new Draw();
	}
	
}