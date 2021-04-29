package h3d.scene;

class PassObjects {
	public var name : String;
	public var passes : h3d.pass.PassList;
	public var rendered : Bool;
	public function new() {
		passes = new h3d.pass.PassList();
	}
}

enum RenderMode{
	Default;
	LightProbe;
}

@:allow(hrt.prefab.rfx.RendererFX)
@:allow(h3d.pass.Shadows)
class Renderer extends hxd.impl.AnyProps {

	var defaultPass : h3d.pass.Base;
	var passObjects : Map<String,PassObjects>;
	var allPasses : Array<h3d.pass.Base>;
	var emptyPasses = new h3d.pass.PassList();
	var ctx : RenderContext;
	var hasSetTarget = false;
	var frontToBack : h3d.pass.PassList -> Void;
	var backToFront : h3d.pass.PassList -> Void;
	var debugging = false;

	public var effects : Array<h3d.impl.RendererFX> = [];

	public var renderMode : RenderMode = Default;

	public function new() {
		allPasses = [];
		passObjects = new SMap();
		props = getDefaultProps();
		// pre allocate closures
		frontToBack = depthSort.bind(true);
		backToFront = depthSort.bind(false);
	}

	public function getEffect<T:h3d.impl.RendererFX>( cl : Class<T> ) : T {
		for( f in effects ) {
			var f = Std.downcast(f, cl);
			if( f != null ) return f;
		}
		return null;
	}

	public function dispose() {
		for( p in allPasses )
			p.dispose();
		for( f in effects )
			f.dispose();
		passObjects = new SMap();
	}

	function mark(id: String) {
	}

	/**
		Inject a post process shader for the current frame. Shaders are reset after each render.
	**/
	public function addShader( s : hxsl.Shader ) {
	}

	public function getPass<T:h3d.pass.Base>( c : Class<T> ) : T {
		for( p in allPasses )
			if( hxd.impl.Api.isOfType(p, c) )
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

	function getLightSystem() : h3d.scene.LightSystem {
		return ctx.scene.lightSystem;
	}

	@:access(h3d.scene.Object)
	function depthSort( frontToBack, passes : h3d.pass.PassList ) {
		var cam = ctx.camera.m;
		for( p in passes ) {
			var z = p.obj.absPos._41 * cam._13 + p.obj.absPos._42 * cam._23 + p.obj.absPos._43 * cam._33 + cam._43;
			var w = p.obj.absPos._41 * cam._14 + p.obj.absPos._42 * cam._24 + p.obj.absPos._43 * cam._34 + cam._44;
			p.depth = z / w;
		}
		if( frontToBack )
			passes.sort(function(p1, p2) return p1.depth > p2.depth ? 1 : -1);
		else
			passes.sort(function(p1, p2) return p1.depth > p2.depth ? -1 : 1);
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
		if( p == null ) return emptyPasses;
		p.rendered = true;
		return p.passes;
	}

	function draw( name : String ) {
		defaultPass.draw(get(name));
	}

	function render() {
		throw "Not implemented";
	}

	function computeStatic() {
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
		if( ctx.computingStatic )
			computeStatic();
		else
			render();
		resetTarget();
		for( p in passes )
			passObjects.set(p.name, null);
	}

}