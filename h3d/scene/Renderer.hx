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

	var defaultPass : h3d.pass.Output;
	var passObjects : Map<String,PassObjects>;
	var allPasses : Array<h3d.pass.Output>;
	var emptyPasses = new h3d.pass.PassList();
	var ctx : RenderContext;
	var hasSetTarget = false;
	var frontToBack : h3d.pass.PassList -> Void;
	var backToFront : h3d.pass.PassList -> Void;
	var debugging = false;

	#if editor
	public var showEditorGuides = false;
	public var showEditorOutlines = true;
	#end

	public var effects : Array<h3d.impl.RendererFX> = [];
	public var volumeEffects : Array<h3d.impl.RendererFXVolume> = [];
	var toRemove : Array<h3d.impl.RendererFX> = [];

	public var renderMode : RenderMode = Default;

	public var shadows : Bool = true;

	public function new() {
		allPasses = [];
		passObjects = new Map();
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
		for( v in volumeEffects )
			for (e in v.effects)
				e.dispose();
		if ( ctx.lightSystem != null )
			ctx.lightSystem.dispose();
		passObjects = new Map();
	}

	function mark(id: String) {
	}

	/**
		Inject a post process shader for the current frame. Shaders are reset after each render.
	**/
	public function addShader( s : hxsl.Shader ) {
	}

	public function getPass<T:h3d.pass.Output>( c : Class<T> ) : T {
		for( p in allPasses )
			if( Std.isOfType(p, c) )
				return cast p;
		return null;
	}

	public function getPassByName( name : String ) {
		for( p in allPasses )
			if( p.name == name )
				return p;
		return null;
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
			p.depth = w > 0.0 ? z / w : - z / w;
		}
		if( frontToBack )
			passes.sort(
				function(p1, p2) {
					if ( p1.pass.layer != p2.pass.layer )
						return p1.pass.layer - p2.pass.layer;
					if ( p1.depth == p2.depth )
						return 0;
					return p1.depth > p2.depth ? 1 : -1;
				}
			);
		else
			passes.sort(
				function(p1, p2) {
					if ( p1.pass.layer != p2.pass.layer )
						return p1.pass.layer - p2.pass.layer;
					if ( p1.depth == p2.depth )
						return 0;
					return p1.depth < p2.depth ? 1 : -1;
				}
			);
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

	function setTarget( tex, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		if( hasSetTarget ) ctx.engine.popTarget();
		ctx.engine.pushTarget(tex, depthBinding);
		hasSetTarget = true;
	}

	function setTargets<T:h3d.mat.Texture>( textures : Array<T>, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		if( hasSetTarget ) ctx.engine.popTarget();
		ctx.engine.pushTargets(cast textures, depthBinding);
		hasSetTarget = true;
	}

	function setDepth( depthBuffer : h3d.mat.Texture ) {
		if( hasSetTarget ) ctx.engine.popTarget();
		ctx.engine.pushDepth(depthBuffer);
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

	@:access(h3d.mat.Pass)
	function setPassFlags( pass : h3d.mat.Pass ) {
		pass.rendererFlags |= 1;
	}

	@:access(h3d.pass.PassList)
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

	public function startEffects() {
		for ( e in effects )
			if ( e.enabled )
				e.start(this);
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

	public function computeDispatch( shader, x = 1, y = 1, z = 1 ) {
		ctx.computeDispatch(shader, x, y, z);
	}

	public function processVolumetricEffects() {
		if (volumeEffects.length == 1) {
			for (e in volumeEffects[0].effects) {
				var newEffect = e.modulate(volumeEffects[0].getFactor());
				if (newEffect == null)
					continue;
				toRemove.push(newEffect);
				this.effects.push(newEffect);
			}
		}
		else if (volumeEffects.length >= 2) {
			// When there is more than 2 active volume effects, we take the top 2 prios and
			// blend them (because blend with more than 2 values isn't commutative)
			var r1 = volumeEffects[0];
			var r2 = volumeEffects[1];
			for (idx => v in volumeEffects) {
				var v = volumeEffects[idx];
				if (v.priority > hxd.Math.min(r1.priority, r2.priority) && r1 != v && r2 != v) {
					if (r1.priority < v.priority)
						r1 = v;
					else
						r2 = v;
				}
			}

			function containsEffectType(volume : h3d.impl.RendererFXVolume, e : h3d.impl.RendererFX) {
				var cl = Type.getClass(e);
				for (effect in volume.effects)
					if (Std.isOfType(effect, cl))
						return true;
				return false;
			}

			// Push unique renderer FX from volume 1 and volume 2
			for (e in r1.effects) {
				if (!containsEffectType(r2, e)) {
					this.toRemove.push(e);
					this.effects.push(e);
				}
			}
			for (e in r2.effects) {
				if (!containsEffectType(r1, e)) {
					this.toRemove.push(e);
					this.effects.push(e);
				}
			}

			// Manage blending of renderer FX that are in volume 1 and volume 2
			// Look for which direction the blend should be (r1 -> r2 or r2 -> r1)
			var isR1toR2 = r1.priority < r2.priority;
			var volume1 = isR1toR2 ? r1 : r2;
			var volume2 = isR1toR2 ? r2 : r1;
			for (e1 in volume1.effects) {
				if (!containsEffectType(volume2, e1))
					continue;

				for (e2 in volume2.effects) {
					var newEffect = e1.transition(e1, e2, volume2.getFactor());
					if (newEffect != null) {
						this.toRemove.push(newEffect);
						this.effects.push(newEffect);
					}
				}
			}
		}
	}

	public function removeVolumetricEffects() {
		for (e in toRemove)
			effects.remove(e);
	}
}