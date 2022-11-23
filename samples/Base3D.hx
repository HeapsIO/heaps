import h3d.scene.*;

class Base3D extends SampleApp {

	var time : Float = 0.;
	var obj1 : Mesh;
	var obj2 : Mesh;

	override function init() {
		super.init();

		// creates a new unit cube
		var prim = new h3d.prim.Cube();

		// translate it so its center will be at the center of the cube
		prim.translate( -0.5, -0.5, -0.5);

		// unindex the faces to create hard edges normals
		prim.unindex();

		// add face normals
		prim.addNormals();

		// add texture coordinates
		prim.addUVs();

		// accesss the logo resource and convert it to a texture
		var tex = hxd.Res.hxlogo.toTexture();

		// create a material with this texture
		var mat = h3d.mat.Material.create(tex);

		// our first cube mesh on the 3D scene with our created material
		obj1 = new Mesh(prim, mat, s3d);

		// creates another cube, this time with no texture
		obj2 = new Mesh(prim, s3d);

		// set the second cube color
		obj2.material.color.setColor(0xFFB280);

		// put it above the first cube
		obj2.z = 0.7;

		// scale it down to 60%
		obj2.scale(0.6);

		// adds a directional light to the scene
		var light = new h3d.scene.fwd.DirLight(new h3d.Vector(0.5, 0.5, -0.5), s3d);
		light.enableSpecular = true;

		// set the ambient light to 30%
		cast(s3d.lightSystem,h3d.scene.fwd.LightSystem).ambientLight.set(0.3, 0.3, 0.3);

		// disable shadows
		obj1.material.shadows = false;
		obj2.material.shadows = false;

		if (engine.driver.hasFeature(Wireframe)) {
			addCheck("Wireframe", function() { return obj2.material.mainPass.wireframe; }, function(v) { obj2.material.mainPass.wireframe = v; });
		}
	}

	override function update( dt : Float ) {

		// time is flying...
		time += 0.6 * dt;

		// move the camera position around the two cubes
		var dist = 5;
		s3d.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, dist * 0.7 * Math.sin(time));

		// rotate the second cube along a given axis + angle
		obj2.setRotationAxis(-0.5, 2, Math.cos(time), time + Math.PI / 2);
	}

	static function main() {

		// initialize embeded ressources
		hxd.Res.initEmbed();

		// start the application
		new Base3D();
	}

}
