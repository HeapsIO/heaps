import h3d.scene.*;

class Main extends hxd.App {
	
	var time : Float = 0.;
	var obj1 : Mesh;
	var obj2 : Mesh;
		
	override function init() {
		
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addUVs();
		prim.addNormals();
		
		var tex = hxd.Res.hxlogo.toTexture();
		var mat = new h3d.mat.MeshMaterial(tex);
		
		obj1 = new Mesh(prim, mat, s3d);
		obj2 = new Mesh(prim, new h3d.mat.MeshMaterial(), s3d);
		obj2.material.color.set(1, 0.7, 0.5);
	
		mat.mainPass.addShader(new h3d.shader.VertexColor()).additive = true; // this will use normals
		
		/*mat.lightSystem = {
			ambient : new h3d.Vector(0, 0, 0),
			dirs : [{ dir : new h3d.Vector(-0.3,-0.5,-1), color : new h3d.Vector(1,1,1) }],
			points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(3,0,0), att : new h3d.Vector(0,0,1) }],
		};*/
		
		update(0);
	}
	
	override function update( dt : Float ) {
		var dist = 5;
		time += 0.01 * dt;
		s3d.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		obj2.setRotateAxis(-0.5, 2, Math.cos(time), time + Math.PI / 2);
	}
	
	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
	
}
