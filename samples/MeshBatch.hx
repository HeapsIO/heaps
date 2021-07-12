class MeshInst {
	public var x : Float;
	public var y : Float;
	public var scale : Float;
	public var rot : Float;
	public var color : h3d.Vector;

	public var speed : Float;

	public function new() {
		x = Math.random() * 40 - 20;
		y = Math.random() * 40 - 20;
		scale = 0.01;
		speed = 1 + Math.random();
		rot = Math.random() * Math.PI * 2;
		color = new h3d.Vector(Math.random(), Math.random(), Math.random());
		color.normalize();
	}

	public function update(dt:Float) {
		scale += speed * dt;
		rot += Math.abs(speed) * dt;
		if( speed > 1 && scale > Math.sqrt(speed) )
			speed *= -1;
		return scale > 0;
	}

}

class MeshBatch extends hxd.App {

	var batch : h3d.scene.MeshBatch;
	var meshes : Array<MeshInst>;
	var instanced : h3d.prim.Instanced;

	override function init() {
		new h3d.scene.fwd.DirLight(new h3d.Vector(-2,-3,-10), s3d);
		var cube = new h3d.prim.Cube(1,1,1,true);
		cube.unindex();
		cube.addNormals();
		cast(s3d.lightSystem,h3d.scene.fwd.LightSystem).ambientLight.set(0.5,0.5,0.5);
		batch = new h3d.scene.MeshBatch(cube,s3d);
		meshes = [];
		new h3d.scene.CameraController(20,s3d);
	}

	override function update(dt:Float) {
		while( meshes.length < 680 )
			meshes.push(new MeshInst());
		if( Std.random(100) == 0 )
			batch.shadersChanged = true;
		batch.begin(680);
		for( m in meshes.copy() ) {
			if( !m.update(dt) ) {
				meshes.remove(m);
				continue;
			}
			batch.x = m.x;
			batch.y = m.y;
			batch.setScale(m.scale);
			batch.setRotation(0,0,m.rot);
			batch.material.color.load(m.color);
			batch.emitInstance();
		}
	}

	static function main() {
		h3d.mat.PbrMaterialSetup.set();
		hxd.Res.initEmbed();
		new MeshBatch();
	}

}