package h3d.scene;

/**
	h3d.scene.Mesh is the base class for all 3D objects displayed on screen.
	Unlike Object base class, all properties of Mesh only apply to the current object and are not inherited by its children.
**/
class Mesh extends Object {

	/**
		The primitive of the mesh: the list of vertexes and indices necessary to display the mesh.
	**/
	public var primitive : h3d.prim.Primitive;

	/**
		The material of the mesh: the properties used to display it (texture, color, shaders, etc.)
	**/
	public var material : h3d.mat.Material;

	/**
		Creates a new mesh with given primitive, material and parent object.
		If material is not specified, a new default material is created for the current renderer.
	**/
	public function new( primitive, ?material, ?parent ) {
		super(parent);
		this.primitive = primitive;
		if( material == null ) {
			material = h3d.mat.MaterialSetup.current.createMaterial();
			material.props = material.getDefaultProps();
		}
		this.material = material;
	}

	/**
		Return all materials for the current object.
	**/
	public function getMeshMaterials() {
		return [material];
	}

	override function getBoundsRec( b : h3d.col.Bounds ) {
		b = super.getBoundsRec(b);
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

	override function getLocalCollider() : h3d.col.Collider {
		return primitive.getCollider();
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
		if( material != null && a.indexOf(material) < 0 ) a.push(material);
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