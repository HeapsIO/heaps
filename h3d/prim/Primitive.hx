package h3d.prim;

/**
	h3d.prim.Primitive is the base class for all 3D primitives.
	You can't create an instance of it and need to use one of its subclasses.
**/
class Primitive implements hxd.impl.Serializable {

	/**
		The primitive vertex buffer, holding its vertexes data.
	**/
	public var buffer : Buffer;

	/**
		The primitive indexes buffer, holding its triangles indices.
	**/
	public var indexes : Indexes;

	/**
		The number of triangles the primitive has.
	**/
	public function triCount() {
		return if( indexes != null ) Std.int(indexes.count / 3) else if( buffer == null ) 0 else Std.int(buffer.totalVertices() / 3);
	}

	/**
		The number of vertexes the primitive has.
	**/
	public function vertexCount() {
		return 0;
	}

	/**
		Return a local collider for the primitive
	**/
	public function getCollider() : h3d.col.Collider {
		throw "not implemented for "+this;
		return null;
	}

	/**
		Return the bounds for the primitive
	**/
	public function getBounds() : h3d.col.Bounds {
		throw "not implemented for "+this;
		return null;
	}

	/**
		Allocate the primitive on GPU. Used for internal usage.
	**/
	public function alloc( engine : h3d.Engine ) {
		throw "not implemented";
	}

	/**
		Select the specified sub material before drawin. Used for internal usage.
	**/
	public function selectMaterial( material : Int ) {
	}

	@:noCompletion public function buildNormalsDisplay() : Primitive {
		throw "not implemented for "+this;
		return null;
	}

	/**
		Render the primitive. Used for internal usage.
	**/
	public function render( engine : h3d.Engine ) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		if( indexes == null ) {
			if( buffer.flags.has(Quads) )
				engine.renderQuadBuffer(buffer);
			else
				engine.renderTriBuffer(buffer);
		} else
			engine.renderIndexed(buffer,indexes);
	}

	/**
		Dispose the primitive, freeing the GPU memory it uses.
	**/
	public function dispose() {
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
		if( indexes != null ) {
			indexes.dispose();
			indexes = null;
		}
	}

	/**
		Return the primitive type.
	**/
	public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop();
	}

	#if hxbit
	function customSerialize( ctx : hxbit.Serializer ) {
		throw "Cannot serialize " + toString();
	}
	function customUnserialize( ctx : hxbit.Serializer ) {
		throw "customUnserialize not implemented on " + toString();
	}
	#end

}