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
			var obj = new Mesh(prim, new h3d.mat.MeshMaterial(tex), root);
			obj.material.mainPass.enableLights = true;
		}

		{	// create the cube reflection
			var obj = new Mesh(prim, new h3d.mat.MeshMaterial(tex), root);
			obj.scaleZ = -1;
			obj.material.color.setColor(0x55C8FF);

			var p = obj.material.mainPass;
			p.culling = Front;
			p.setStencilFunc(Both, Equal, 1, 0xFF);
			p.setStencilMask(Both, 0x00);
			p.enableLights = true;
		}

		{	// create reflection plane
			var prim = new h3d.prim.Cube(2, 2, 0.0001);
			prim.addNormals();
			prim.translate( -1, -1, 0);

			var obj = new Mesh(prim, root);
			obj.material.color.setColor(0x55C8FF);

			var p = obj.material.mainPass;
			p.depthWrite = false;
			p.setStencilFunc(Both, Always, 1, 0xFF);
			p.setStencilOp(Both, Keep, Keep, Replace);
			p.setStencilMask(Both, 0xFF);
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
