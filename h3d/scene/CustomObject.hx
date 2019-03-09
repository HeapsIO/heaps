package h3d.scene;

class CustomObject extends Object {

	public var primitive(default, set) : h3d.prim.Primitive;
	public var material : h3d.mat.Material;

	public function new( prim, mat, ?parent ) {
		super(parent);
		this.primitive = prim;
		this.material = mat;
	}

	override function getBoundsRec( b : h3d.col.Bounds ) {
		b = super.getBounds(b);
		var tmp = primitive.getBounds().clone();
		tmp.transform(absPos);
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
		if ( primitive != null && primitive.refCount == 1 )
			primitive.dispose();
		super.dispose();
	}

	override private function onAdd()
	{
		super.onAdd();
		if ( primitive != null ) primitive.incref();
	}

	override private function onRemove()
	{
		if ( primitive != null ) primitive.decref();
		super.onRemove();
	}

	function set_primitive( prim : h3d.prim.Primitive ) : h3d.prim.Primitive {
		if ( prim != this.primitive && allocated ) {
			if (this.primitive != null) this.primitive.decref();
			if (prim != null) prim.incref();
		}
		return this.primitive = prim;
	}

}