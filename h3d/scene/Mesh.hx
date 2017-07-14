package h3d.scene;

class Mesh extends Object {

	public var primitive : h3d.prim.Primitive;
	public var material : h3d.mat.Material;

	public function new( prim, ?mat, ?parent ) {
		super(parent);
		this.primitive = prim;
		if( mat == null ) mat = new h3d.mat.Material(null);
		this.material = mat;
	}

	override function getBounds( ?b : h3d.col.Bounds, rec = false ) {
		b = super.getBounds(b, rec);
		if( primitive == null || flags.has(FIgnoreBounds) )
			return b;
		var tmp = primitive.getBounds().clone();
		tmp.transform(absPos);
		b.add(tmp);
		return b;
	}

	override function clone( ?o : Object ) : Object {
		var m = o == null ? new Mesh(null,material) : cast o;
		m.primitive = primitive;
		m.material = cast material.clone();
		super.clone(m);
		return m;
	}

	override function getCollider() : h3d.col.Collider {
		return new h3d.col.ObjectCollider(this, primitive.getCollider());
	}

	override function draw( ctx : RenderContext ) {
		primitive.render(ctx.engine);
	}

	override function emit( ctx : RenderContext ) {
		ctx.emit(material, this);
	}

	override function getMaterialByName( name : String ) : h3d.mat.Material {
		if( material != null && material.name == name )
			return material;
		return super.getMaterialByName(name);
	}

	override function getMaterials( ?a : Array<h3d.mat.Material> ) {
		if( a == null ) a = [];
		if( material != null ) a.push(material);
		return super.getMaterials(a);
	}

	override function dispose() {
		if( primitive != null ) primitive.dispose();
		super.dispose();
	}

	#if hxbit
	override function customSerialize(ctx:hxbit.Serializer) {
		super.customSerialize(ctx);
		ctx.addKnownRef(primitive);
		ctx.addKnownRef(material);
	}
	override function customUnserialize(ctx:hxbit.Serializer) {
		super.customUnserialize(ctx);
		primitive = ctx.getKnownRef(h3d.prim.Primitive);
		material = ctx.getKnownRef(h3d.mat.Material);
	}
	#end

}