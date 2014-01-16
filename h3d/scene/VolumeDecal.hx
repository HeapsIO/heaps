package h3d.scene;

class VolumeDecal extends h3d.scene.Mesh {

	static var prim : h3d.prim.Polygon = null;
	static function getVolumePrim() {
		if( prim != null ) return prim;
		prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addNormals();
		prim.addUVs();
		return prim;
	}
	
	public function new(texture, ?parent) {
		super(getVolumePrim(), new h3d.mat.MeshMaterial(texture), parent);
		material.depthWrite = false;
	}
	
	override function sync( ctx : RenderContext ) {
		// should be done in decals pass
//		infos.screenToLocal.multiply(ctx.camera.getInverseViewProj(), getInvPos());
//		material.volumeDecal = infos;
		super.sync(ctx);
	}
	
}