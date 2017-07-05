import h3d.scene.*;

class Stencil extends hxd.App {

	var time : Float = 0.;
	var root : Object;

	override function init() {
		root = new Object(s3d);

		// creates a new unit cube
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, 0.0);
		prim.unindex();
		prim.addNormals();
		prim.addUVs();
		var tex = hxd.Res.hxlogo.toTexture();

		{	// create the top cube
			var obj = new Mesh(prim, new h3d.mat.Material(tex), root);
			obj.material.mainPass.enableLights = true;
		}

		{	// create the cube reflection
			var obj = new Mesh(prim, new h3d.mat.Material(tex), root);
			obj.scaleZ = -1;
			obj.material.color.setColor(0x55C8FF);

			var p = obj.material.mainPass;
			var s = new h3d.mat.Stencil();
			p.culling = Front;
			p.enableLights = true;
			s.setFunc(Both, Equal, 1, 0xFF);
			s.setMask(Both, 0x00);
			p.stencil = s;
		}

		{	// create reflection plane
			var prim = new h3d.prim.Cube(2, 2, 0.0001);
			prim.addNormals();
			prim.translate( -1, -1, 0);

			var obj = new Mesh(prim, root);
			obj.material.color.setColor(0x0080C0);

			var p = obj.material.mainPass;
			var s = new h3d.mat.Stencil();
			p.depthWrite = false;
			p.stencil = new h3d.mat.Stencil();
			s.setFunc(Both, Always, 1, 0xFF);
			s.setOp(Both, Keep, Keep, Replace);
			s.setMask(Both, 0xFF);
			p.stencil = s;
		}

		// adds a directional light to the scene
		var light = new h3d.scene.DirLight(new h3d.Vector(-0.5, -0.5, -0.5), s3d);
		light.enableSpecular = true;
		s3d.lightSystem.ambientLight.set(0.3, 0.3, 0.3);

		s3d.camera.pos.set(5, 5, 5);
	}

	override function update( dt : Float ) {
		time += 0.01 * dt;
		root.setRotateAxis (0, 0, 1.0, time);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Stencil();
	}

}
