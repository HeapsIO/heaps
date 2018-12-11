package h3d.scene.helper;

/**
**/
class PointLightHelper extends h3d.scene.Mesh {

	public function new( light : h3d.scene.PointLight, sphereSize = 0.5 ) {
		var prim = new h3d.prim.Sphere( sphereSize, 4, 2 );
		prim.addNormals();
		prim.addUVs();
		super( prim, light );
		material.color = light.color;
		material.mainPass.wireframe = true;
	}

}
