package h3d.scene;

class Renderer {

	var def : h3d.pass.Base;
	var depth : h3d.pass.Base;
	var normal : h3d.pass.Base;
	var shadow : h3d.pass.Base;
	var passes : Map<String, h3d.pass.Base>;
	var allPasses : Array<{ name : String, p : h3d.pass.Base }>;

	public function new() {
		passes = new Map();
		allPasses = [];
	}

	public function dispose() {
	}

	public function compileShader( pass : h3d.mat.Pass ) {
		return getPass(pass.name).compileShader(pass);
	}

	function createDefaultPass( name : String ) : h3d.pass.Base {
		switch( name ) {
		case "default", "alpha", "additive":
			if( def != null ) return def;
			return def = new h3d.pass.Default();
		case "depth":
			if( depth != null ) return depth;
			return depth = new h3d.pass.Depth();
		case "normal":
			if( normal != null ) return normal;
			return normal = new h3d.pass.Normal();
		case "shadow":
			if( shadow != null ) return shadow;
			return shadow = new h3d.pass.ShadowMap(1024);
		default:
			throw "Don't know how to create pass '" + name + "', use s3d.renderer.setPass()";
			return null;
		}
	}

	public function getPass( name : String ) {
		var p = passes.get(name);
		if( p == null ) {
			p = createDefaultPass(name);
			setPass(name, p);
		}
		return p;
	}

	public function setPass( name : String, p : h3d.pass.Base ) {
		for( p in allPasses )
			if( p.name == name )
				allPasses.remove(p);
		passes.set(name, p);
		allPasses.push({ name : name, p : p });
		allPasses.sort(function(p1, p2) return p2.p.priority - p1.p.priority);
	}

	public function process( ctx : RenderContext, passes : Array<{ name : String, data : h3d.pass.Object, rendered : Bool }> ) {
		// alloc passes
		for( p in passes )
			getPass(p.name);
		// render
		for( p in allPasses ) {
			var pdata = null;
			for( pd in passes )
				if( pd.name == p.name ) {
					pdata = pd;
					break;
				}
			if( pdata != null || p.p.forceProcessing ) {
				p.p.setContext(ctx);
				var pret = p.p.draw(p.name, pdata == null ? null : pdata.data);
				if( pdata != null ) {
					pdata.data = pret;
					pdata.rendered = true;
				}
			}
		}
	}

}