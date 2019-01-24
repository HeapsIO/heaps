package h3d.scene.pbr;

class Decal extends Mesh {

	public function new( primitive, ?material, ?parent ) {
		super(primitive, material, parent);
	}

	var decalBounds = new h3d.col.Bounds();
	override function sync( ctx : RenderContext ) {
		super.sync(ctx);

		if( posChanged || decalBounds.isEmpty() ){
			decalBounds.empty();
			getBounds(decalBounds);
		}

		var shader = material.mainPass.getShader(h3d.shader.pbr.VolumeDecal.DecalPBR);
		if( shader != null )
			syncDecalPBR(shader);
		else{
			var shader = material.mainPass.getShader(h3d.shader.pbr.VolumeDecal.DecalOverlay);
			if( shader != null )
				syncDecalOverlay(shader);
		}
	}

	function syncDecalPBR( shader : h3d.shader.pbr.VolumeDecal.DecalPBR ) {
		shader.normal = getAbsPos().up();
		shader.tangent = getAbsPos().right();
		shader.minBound.set(decalBounds.xMin, decalBounds.yMin, decalBounds.zMin);
		shader.maxBound.set(decalBounds.xMax, decalBounds.yMax, decalBounds.zMax);
	}

	function syncDecalOverlay( shader : h3d.shader.pbr.VolumeDecal.DecalOverlay ) {
		shader.minBound.set(decalBounds.xMin, decalBounds.yMin, decalBounds.zMin);
		shader.maxBound.set(decalBounds.xMax, decalBounds.yMax, decalBounds.zMax);
	}

}