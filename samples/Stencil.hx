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
			var obj = new Mesh(prim, h3d.mat.Material.create(tex), root);
			obj.material.shadows = false;
		}

		{	// create the cube reflection
			var obj = new Mesh(prim, h3d.mat.Material.create(tex), root);
			obj.scaleZ = -1;
			obj.material.color.setColor(0x55C8FF);
			obj.material.shadows = false;

			var p = obj.material.mainPass;
			p.setPassName("alpha");
			p.culling = Front;
			var s = new h3d.mat.Stencil();
			s.setFunc(LessEqual, 1, 0xFF, 0);
			p.stencil = s;
		}

		{	// create reflection plane
			var prim = new h3d.prim.Cube(2, 2, 0.0001);
			prim.addNormals();
			prim.translate( -1, -1, 0);

			var obj = new Mesh(prim, root);
			obj.material.color.setColor(0x0080C0);
			obj.material.shadows = false;

			var p = obj.material.mainPass;
			var s = new h3d.mat.Stencil();
			p.depthWrite = false;

			s.setFunc(Always, 1);
			s.setOp(Keep, Keep, Replace);
			p.stencil = s;
		}

		// adds a directional light to the scene
		var light = new h3d.scene.fwd.DirLight(new h3d.Vector(-0.5, -0.5, -0.5), s3d);
		light.enableSpecular = true;
		cast(s3d.lightSystem,h3d.scene.fwd.LightSystem).ambientLight.set(0.3, 0.3, 0.3);

		s3d.camera.pos.set(5, 5, 5);
	}

	override function update( dt : Float ) {
		time += 0.6 * dt;
		root.setRotationAxis(0, 0, 1.0, time);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Stencil();
	}

}
