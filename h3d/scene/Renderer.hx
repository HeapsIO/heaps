package h3d.scene;

class PassObjects {
	public var name : String;
	public var passes : h3d.pass.Object;
	public var rendered : Bool;
	public function new(name, passes) {
		this.name = name;
		this.passes = passes;
	}
}

private typedef SMap<T> = #if flash haxe.ds.UnsafeStringMap<T> #else Map<String,T> #end

class Renderer extends hxd.impl.AnyProps {

	var defaultPass : h3d.pass.Base;
	var passObjects : SMap<PassObjects>;
	var allPasses : Array<h3d.pass.Base>;
	var ctx : RenderContext;
	var hasSetTarget = false;
	public var effects : Array<hxd.prefab.rfx.RendererFX> = [];

	public function new() {
		allPasses = [];
		passObjects = new SMap();
		props = getDefaultProps();
	}

	public function dispose() {
		for( p in allPasses )
			p.dispose();
		passObjects = new SMap();
	}

	public function getPass<T:h3d.pass.Base>( c : Class<T> ) : T {
		for( p in allPasses )
			if( Std.is(p, c) )
				return cast p;
		return null;
	}

	public function getPassByName( name : String ) {
		for( p in allPasses )
			if( p.name == name )
				return p;
		return null;
	}

	public function debugCompileShader( pass : h3d.mat.Pass ) {
		var p = getPassByName(pass.name);
		if( p == null ) p = defaultPass;
		p.setContext(ctx);
		return p.compileShader(pass);
	}

	function hasFeature(f) {
		return h3d.Engine.getCurrent().driver.hasFeature(f);
	}

	function getDefaultLight<T:h3d.scene.Light>( l : T ) : T {
		return l;
	}

	function getLightSystem() : h3d.scene.LightSystem {
		return ctx.scene.lightSystem;
	}

	function time( name : String ) {
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

	inline function clear( ?color, ?depth, ?stencil ) {
		ctx.engine.clear(color, depth, stencil);
	}

	inline function allocTarget( name : String, depth = true, size = 1., ?format ) {
		return ctx.textures.allocTarget(name, Math.round(ctx.engine.width * size), Math.round(ctx.engine.height * size), depth, format);
	}

	function copy( from, to, ?blend ) {
		h3d.pass.Copy.run(from, to, blend);
	}

	function setTarget( tex ) {
		if( hasSetTarget ) ctx.engine.popTarget();
		ctx.engine.pushTarget(tex);
		hasSetTarget = true;
	}

	function setTargets<T:h3d.mat.Texture>( textures : Array<T> ) {
		if( hasSetTarget ) ctx.engine.popTarget();
		ctx.engine.pushTargets(cast textures);
		hasSetTarget = true;
	}

	function resetTarget() {
		if( hasSetTarget ) {
			ctx.engine.popTarget();
			hasSetTarget = false;
		}
	}

	function has( name : String ) {
		return passObjects.get(name) != null;
	}

	function get( name : String ) {
		var p = passObjects.get(name);
		if( p == null ) return null;
		p.rendered = true;
		return p.passes;
	}

	function getSort( name : String, front2Back = false ) {
		var p = passObjects.get(name);
		if( p == null ) return null;
		p.passes = depthSort(p.passes, front2Back);
		p.rendered = true;
		return p.passes;
	}

	function draw( name : String ) {
		defaultPass.draw(get(name));
	}

	function render() {
		throw "Not implemented";
	}

	public function start() {
	}

	public function process( passes : Array<PassObjects> ) {
		hasSetTarget = false;
		for( p in allPasses )
			p.setContext(ctx);
		for( p in passes )
			passObjects.set(p.name, p);
		ctx.textures.begin();
		render();
		resetTarget();
		for( p in passes )
			passObjects.set(p.name, null);
	}

}