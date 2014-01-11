package h3d.scene;

class MultiMaterial extends Mesh {

	public var materials : Array<h3d.mat.MeshMaterial>;
	
	public function new( prim, mats, ?parent ) {
		super(prim, mats[0], parent);
		this.materials = mats;
	}
	
	override function clone( ?o : Object ) {
		throw "TODO";
		return null;
		/*
		var m = o == null ? new MultiMaterial(null,materials) : cast o;
		m.materials = [for( m in materials ) m.clone()];
		super.clone(m);
		m.material = m.materials[0];
		return m;
		*/
	}
	
	/*
	@:access(h3d.mat.MeshMaterial.setup)
	function drawMaterial( ctx : RenderContext, mid : Int ) {
		var m = materials[mid];
		if( m == null )
			return;
		ctx.localPos = this.absPos;
		ctx.engine.selectMaterial(m);
	}
	*/
	
	override function draw( ctx : RenderContext ) {
		primitive.selectMaterial(ctx.drawPass.index);
		primitive.render(ctx.engine);
	}
	
	@:access(h3d.pass.Pass)
	override function emit( ctx : RenderContext ) {
		for( mid in 0...materials.length ) {
			var m = materials[mid];
			var p = m.mainPass;
			while( p != null ) {
				ctx.emitPass(p, this).index = mid;
				p = p.nextPass;
			}
		}
	}
	
}