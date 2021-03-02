package h3d.scene;

class MultiMaterial extends Mesh {

	public var materials : Array<h3d.mat.Material>;

	public function new( prim, ?mats, ?parent ) {
		super(prim, mats == null ? null : mats[0], parent);
		this.materials = mats == null ? [material] : mats;
	}

	override function getMeshMaterials() {
		return materials.copy();
	}

	override function clone( ?o : Object ) {
		var m = o == null ? new MultiMaterial(null, materials) : cast o;
		m.materials = [];
		for( mat in materials )
			m.materials.push(if( mat == null ) null else cast mat.clone());
		super.clone(m);
		m.material = m.materials[0];
		return m;
	}

	override function emit( ctx : RenderContext ) {
		for( i in 0...materials.length ) {
			var m = materials[i];
			if( m != null )
				ctx.emit(m, this, i);
		}
	}

	override function getMaterialByName( name : String ) : h3d.mat.Material {
		for( m in materials )
			if( m != null && m.name == name )
				return m;
		return super.getMaterialByName(name);
	}

	override function getMaterials( ?a : Array<h3d.mat.Material>, recursive = true ) {
		if( a == null ) a = [];
		for( m in materials )
			if( m != null && a.indexOf(m) < 0 )
				a.push(m);
		if( recursive ) {
			for( o in children )
				o.getMaterials(a);
		}
		return a;
	}

	override function draw( ctx : RenderContext ) {
		if( materials.length > 1 )
			primitive.selectMaterial(ctx.drawPass.index);
		super.draw(ctx);
	}

	#if (hxbit && !macro && heaps_enable_serialize)
	override function customSerialize(ctx:hxbit.Serializer) {
		super.customSerialize(ctx);
		ctx.addInt(materials.length);
		for( m in materials ) ctx.addKnownRef(m);
	}

	override function customUnserialize(ctx:hxbit.Serializer) {
		super.customUnserialize(ctx);
		materials = [for( i in 0...ctx.getInt() ) ctx.getKnownRef(h3d.mat.Material)];
	}
	#end

}