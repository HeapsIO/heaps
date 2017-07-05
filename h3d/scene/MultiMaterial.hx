package h3d.scene;

class MultiMaterial extends Mesh {

	public var materials : Array<h3d.mat.Material>;

	public function new( prim, ?mats, ?parent ) {
		super(prim, mats == null ? null : mats[0], parent);
		this.materials = mats == null ? [material] : mats;
	}

	override function clone( ?o : Object ) {
		var m = o == null ? new MultiMaterial(null,materials) : cast o;
		m.materials = [for( m in materials ) cast m.clone()];
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
			if( m.name == name )
				return m;
		return super.getMaterialByName(name);
	}

	override function getMaterials( ?a : Array<h3d.mat.Material> ) {
		if( a == null ) a = [];
		for( m in materials )
			if( m != null )
				a.push(m);
		for( o in childs )
			o.getMaterials(a);
		return a;
	}

	override function draw( ctx : RenderContext ) {
		if( materials.length > 1 )
			primitive.selectMaterial(ctx.drawPass.index);
		super.draw(ctx);
	}

}