package h3d.scene;

class CustomObject extends Object {

	public var primitive : h3d.prim.Primitive;
	public var material : h3d.mat.Material;

	public function new( prim, mat, ?parent ) {
		super(parent);
		this.primitive = prim;
		this.material = mat;
	}

	override function getBounds( ?b : h3d.col.Bounds, rec = false ) {
		b = super.getBounds(b, rec);
		var tmp = primitive.getBounds().clone();
		tmp.transform3x4(absPos);
		b.add(tmp);
		return b;
	}

	override function clone( ?o : Object ) : Object {
		var m = o == null ? new CustomObject(null,material) : cast o;
		m.primitive = primitive;
		//m.material = material.clone();
		throw "TODO : clone";
		super.clone(m);
		return m;
	}

	override function draw( ctx : RenderContext ) {
		primitive.render(ctx.engine);
	}

	override function emit( ctx : RenderContext ) {
		ctx.emit(material, this);
	}

	override function dispose() {
		primitive.dispose();
		super.dispose();
	}

}