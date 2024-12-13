package h3d.scene;

/**
	h3d.scene.Mesh is the base class for all 3D objects displayed on screen.
	Unlike Object base class, all properties of Mesh only apply to the current object and are not inherited by its children.
**/
class Mesh extends Object {

	/**
		The primitive of the mesh: the list of vertexes and indices necessary to display the mesh.
	**/
	public var primitive(default, set) : h3d.prim.Primitive;

	/**
		The material of the mesh: the properties used to display it (texture, color, shaders, etc.)
	**/
	public var material : h3d.mat.Material;

	/**
		When enabled, the lod level is inherited by children objects.
	**/
	public var inheritLod : Bool = false;

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

	static var tmpMat = new h3d.Matrix();
	override function addBoundsRec( b : h3d.col.Bounds, relativeTo : h3d.Matrix ) {
		super.addBoundsRec(b, relativeTo);
		if( primitive == null || flags.has(FIgnoreBounds) )
			return;
		var bounds = primitive.getBounds();
		if( relativeTo == null ) {
			b.addTransform(bounds,absPos);
		} else {
			tmpMat.multiply(absPos, relativeTo);
			b.addTransform(bounds,tmpMat);
		}
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

	var curScreenRatio : Float = 1.0;
	override function draw( ctx : RenderContext ) {
		primitive.selectMaterial(0,	primitive.screenRatioToLod(curScreenRatio));
		primitive.render(ctx.engine);
	}

	function calcScreenRatio( ctx : RenderContext ) {
		if ( primitive == null || primitive.lodCount() == 1 )
			return;

		if ( ctx.forcedScreenRatio >= 0.0 ) {
			curScreenRatio = ctx.forcedScreenRatio;
			return;
		}

		var bounds = primitive.getBounds();
		if ( bounds == null ) {
			curScreenRatio = 1.0;
			return;
		}

		var absPos = getAbsPos();
		var worldCenter = absPos.getPosition();
		var worldScale = absPos.getScale();
		var worldRadius = bounds.dimension() * hxd.Math.max( worldScale.x, hxd.Math.max(worldScale.y, worldScale.z) ) / 2.0;

		var cameraRight = ctx.camera.getRight();
		var cameraUp = ctx.camera.getUp();
		var cameraTopLeft = (cameraUp - cameraRight).normalized();
		var worldTopLeft = worldCenter + cameraTopLeft * worldRadius;
		var worldBottomRight = worldCenter - cameraTopLeft * worldRadius;

		var screenTopLeft = ctx.camera.projectInline( worldTopLeft.x, worldTopLeft.y, worldTopLeft.z, 1.0, 1.0, false );
		var screenBottomRight = ctx.camera.projectInline( worldBottomRight.x, worldBottomRight.y, worldBottomRight.z, 1.0, 1.0, false );

		var screenArea = hxd.Math.max( screenBottomRight.x - screenTopLeft.x, screenBottomRight.y - screenTopLeft.y );

		curScreenRatio = screenArea * screenArea;

		if ( inheritLod )
			ctx.forcedScreenRatio = curScreenRatio;
	}

	override function emit( ctx : RenderContext ) {
		calcScreenRatio(ctx);
		ctx.emit(material, this);
	}

	override function getMaterialByName( name : String ) : h3d.mat.Material {
		if( material != null && material.name == name )
			return material;
		return super.getMaterialByName(name);
	}

	override function getMaterials( ?a : Array<h3d.mat.Material>, recursive = true ) {
		if( a == null ) a = [];
		if( material != null && a.indexOf(material) < 0 ) a.push(material);
		return super.getMaterials(a, recursive);
	}

	override private function onAdd() {
		super.onAdd();
		if ( primitive != null ) primitive.incref();
	}

	override private function onRemove() {
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