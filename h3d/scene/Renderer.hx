package h3d.scene;

class PassGroup {
	public var name : String;
	public var passes : h3d.pass.Object;
	public var rendered : Bool;
	public function new(name, passes) {
		this.name = name;
		this.passes = passes;
	}
}

private typedef SMap<T> = #if flash haxe.ds.UnsafeStringMap<T> #else Map<String,T> #end

class Renderer {

	var def : h3d.pass.Base;
	var depth : h3d.pass.Base;
	var normal : h3d.pass.Base;
	var shadow : h3d.pass.Base;
	var passes : SMap<h3d.pass.Base>;
	var passGroups : SMap<PassGroup>;
	var allPasses : Array<{ name : String, p : h3d.pass.Base }>;
	var ctx : RenderContext;
	var tcache : h3d.impl.TextureCache;
	var hasSetTarget = false;

	public function new() {
		passes = new SMap();
		allPasses = [];
		tcache = new h3d.impl.TextureCache();
		passGroups = new SMap();
	}

	public function dispose() {
		for( p in allPasses )
			p.p.dispose();
		passes = new SMap();
		allPasses = [];
		passGroups = new SMap();
		tcache.dispose();
		def = depth = normal = shadow = null;
	}

	public function compileShader( pass : h3d.mat.Pass ) {
		return getPass(pass.name).compileShader(pass);
	}

	function createDefaultPass( name : String ) : h3d.pass.Base {
		switch( name ) {
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
			if( def != null ) return def;
			return def = new h3d.pass.Default();
		}
	}

	public function getPass( name : String, create = true ) {
		var p = passes.get(name);
		if( p == null && create ) {
			p = createDefaultPass(name);
			setPass(name, p);
		}
		return p;
	}

	function getPassPriority( p : { name : String, p : h3d.pass.Base }  ) {
		var pr = p.p.priority * 10;
		switch( p.name ) {
		case "alpha": pr -= 1;
		case "additive": pr -= 2;
		}
		return pr;
	}

	public function setPass( name : String, p : h3d.pass.Base ) {
		for( p in allPasses )
			if( p.name == name )
				allPasses.remove(p);
		passes.set(name, p);
		allPasses.push({ name : name, p : p });
		allPasses.sort(function(p1, p2) return getPassPriority(p2) - getPassPriority(p1));
	}

	@:access(h3d.scene.Object)
	function depthSort( passes : h3d.pass.Object, frontToBack = false ) {
		var p = passes;
		var cam = ctx.camera.m;
		while( p != null ) {
			var z = p.obj.absPos._41 * cam._13 + p.obj.absPos._42 * cam._23 + p.obj.absPos._43 * cam._33 + cam._43;
			var w = p.obj.absPos._41 * cam._14 + p.obj.absPos._42 * cam._24 + p.obj.absPos._43 * cam._34 + cam._44;
			p.depth = z / w;
			p = p.next;
		}
		if( frontToBack ) {
			return haxe.ds.ListSort.sortSingleLinked(passes, function(p1, p2) return p1.depth > p2.depth ? 1 : -1);
		} else {
			return haxe.ds.ListSort.sortSingleLinked(passes, function(p1, p2) return p1.depth > p2.depth ? -1 : 1);
		}
	}

	inline function front2back(passes) {
		return depthSort(passes, true);
	}

	inline function back2front(passes) {
		return depthSort(passes, false);
	}

	inline function allocTarget( name : String, size = 0, depth = true ) {
		return tcache.allocTarget(name, ctx, ctx.engine.width >> size, ctx.engine.height >> size, depth);
	}

	inline function clear( ?color, ?depth, ?stencil ) {
		ctx.engine.clear(color, depth, stencil);
	}

	inline function pushTarget( tex ) {
		ctx.engine.pushTarget(tex);
	}

	inline function setTarget( tex ) {
		if( hasSetTarget ) ctx.engine.popTarget();
		ctx.engine.pushTarget(tex);
		hasSetTarget = true;
	}

	inline function popTarget() {
		ctx.engine.popTarget();
	}

	function get( name : String ) {
		var p = passGroups.get(name);
		if( p == null ) return null;
		p.rendered = true;
		return p.passes;
	}

	function draw( name : String ) {
		if( def == null ) def = new h3d.pass.Default();
		def.draw(get(name));
	}

	function render() {
		for( p in allPasses ) {
			var pdata = passGroups.get(p.name);
			if( pdata != null && pdata.rendered )
				continue;
			if( pdata != null || p.p.forceProcessing ) {
				p.p.setContext(ctx);
				var passes = pdata == null ? null : pdata.passes;
				if( p.name == "alpha" )
					passes = depthSort(passes);
				if( p.name == "default" )
					passes = depthSort(passes, true);
				passes = p.p.draw(passes);
				if( pdata != null ) {
					pdata.passes = passes;
					pdata.rendered = true;
				}
			}
		}
	}

	public function process( ctx : RenderContext, passes : Array<PassGroup> ) {
		this.ctx = ctx;
		hasSetTarget = false;
		// alloc passes
		for( p in passes ) {
			getPass(p.name).setContext(ctx);
			passGroups.set(p.name, p);
		}
		render();
		if( hasSetTarget ) {
			ctx.engine.popTarget();
			hasSetTarget = false;
		}
		for( p in passes )
			passGroups.set(p.name, null);
	}

}