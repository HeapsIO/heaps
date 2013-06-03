package h3d.scene;

class MultiMaterial extends Object {

	public var primitive : h3d.prim.Primitive;
	public var materials : Array<h3d.mat.MeshMaterial>;
	
	public function new( prim, mats, ?parent ) {
		super(parent);
		this.primitive = prim;
		this.materials = mats;
	}
	
	override function getBounds( ?b : h3d.col.Bounds ) {
		if( b == null ) b = new h3d.col.Bounds();
		b.add(primitive.getBounds());
		return super.getBounds(b);
	}
	
	override function clone( ?o : Object ) {
		var m = o == null ? new MultiMaterial(null,materials) : cast o;
		m.primitive = primitive;
		m.materials = [for( m in materials ) m.clone()];
		super.clone(m);
		return m;
	}
	
	@:access(h3d.mat.MeshMaterial.setup)
	function drawMaterial( ctx : RenderContext, mid : Int ) {
		var m = materials[mid];
		if( m == null )
			return;
		if( m.renderPass > ctx.currentPass ) {
			ctx.addPass(drawMaterial.bind(_,mid));
			return;
		}
		m.setup(ctx.camera, this.absPos);
		ctx.engine.selectMaterial(m);
		primitive.selectMaterial(mid);
		primitive.render(ctx.engine);
	}
	
	override function draw( ctx : RenderContext ) {
		for( mid in 0...materials.length )
			drawMaterial(ctx,mid);
	}
	
	override function dispose() {
		primitive.dispose();
		super.dispose();
	}
}