import h3d.parts.Data;

class Main implements h3d.parts.Collider {
	
	var s3d : h3d.scene.Scene;
	var s2d : h2d.Scene;
	var engine : h3d.Engine;
	var emit : h3d.parts.Emiter;
	var edit : h3d.parts.Editor;
	
	public function new() {
		hxd.res.Embed.embedFont("Arial.ttf");
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.init();
	}
	
	public function collidePart( p : h3d.parts.Particle, n : h3d.Vector ) {
		if( p.z > 0 ) return false;
		n.set(0, 0, 1);
		return true;
	}
	
	function init() {
		hxd.Key.initialize();
		hxd.System.setLoop(update);
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		s3d.addPass(s2d);
		
		var bmp = new hxd.BitmapData(2, 2);
		bmp.setPixel(0, 0, 0xFF202020);
		bmp.setPixel(1, 1, 0xFF202020);
		bmp.setPixel(0, 1, 0xFF808080);
		bmp.setPixel(1, 0, 0xFF808080);
		var tex = h3d.mat.Texture.fromBitmap(bmp);
		tex.filter = Nearest;
		tex.wrap = Repeat;
		bmp.dispose();
		var size = 10;
		var cube = new h3d.prim.Cube(size, size, size);
		cube.addUVs();
		cube.uvScale(size, size);
		cube.translate( -size * 0.5, -size * 0.5, -size);
		var box = new h3d.scene.Mesh(cube, s3d);
		box.material.texture = tex;
		
		emit = new h3d.parts.Emiter(s3d);
		emit.collider = this;
		edit = new h3d.parts.Editor(emit, s2d);
	}
	
	function update() {
		s3d.setElapsedTime(1 / engine.fps);
		engine.render(s3d);
		s2d.checkEvents();
	}
	
	static function main() {
		new Main();
	}
	
}