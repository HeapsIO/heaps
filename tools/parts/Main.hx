import h3d.parts.Data;

class Main extends hxd.App implements h3d.parts.Collider {
	
	var emit : h3d.parts.Emitter;
	var edit : h3d.parts.Editor;
	
	public function collidePart( p : h3d.parts.Particle, n : h3d.Vector ) {
		if( p.z > 0 ) return false;
		n.set(0, 0, 1);
		return true;
	}
	
	override function init() {
		hxd.res.Embed.embedFont("Arial.ttf",true);
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
		
		emit = new h3d.parts.Emitter(s3d);
		emit.collider = this;
		edit = new h3d.parts.Editor(emit, s2d);
		
		s3d.camera.pos.z -= 0.5;
		s3d.camera.target.z += 0.5;
		s3d.camera.viewX = -0.1;
	}
	
	static function main() {
		new Main();
	}
	
}