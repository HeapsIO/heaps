package h3d.scene;
import hxd.Profiler;

class Mesh extends Object {

	public var primitive : h3d.prim.Primitive;
	public var material : h3d.mat.MeshMaterial;
	
	public function new( prim, ?mat, ?parent ) {
		super(parent);
		this.primitive = prim;
		if( mat == null ) mat = new h3d.mat.MeshMaterial(null);
		this.material = mat;
	}
	
	override function getBounds( ?b : h3d.col.Bounds ) {
		b = super.getBounds(b);
		var tmp = primitive.getBounds().clone();
		tmp.transform3x4(absPos);
		b.add(tmp);
		return b;
	}
	
	override function clone( ?o : Object ) {
		var m = o == null ? new Mesh(null,material) : cast o;
		m.primitive = primitive;
		m.material = material.clone();
		super.clone(m);
		return m;
	}
	
	@:access(h3d.mat.MeshMaterial.setup)
	override function draw( ctx : RenderContext ) {
		if ( material.renderPass > ctx.currentPass ) {
			
			ctx.addPass(draw);
			return;
		}
		Profiler.begin("mesh.draw");
		
			ctx.localPos = absPos;
		
			Profiler.begin("mesh.draw.setup");
			material.setup(ctx);
			Profiler.end("mesh.draw.setup");
			
			Profiler.begin("mesh.draw.selMat");
			ctx.engine.selectMaterial(material);
			Profiler.end("mesh.draw.selMat");
		
			Profiler.begin("mesh.draw.prim.render");
			primitive.render(ctx.engine);
			Profiler.end("mesh.draw.prim.render");
			
		Profiler.end("mesh.draw");
	}
	
	override function dispose() {
		primitive.dispose();
		super.dispose();
	}
	
}