package h3d.mat;
import h3d.mat.Data;

@:allow(h3d.mat.BaseMaterial)
#if !macro
@:build(hxd.impl.BitsBuilder.build())
#end
class Pass {

	public var name(default, null) : String;
	var flags : Int;
	var passId : Int;
	var bits : Int = 0;
	var parentPass : Pass;
	var parentShaders : hxsl.ShaderList;
	var selfShaders(default, null) : hxsl.ShaderList;
	var selfShadersChanged(default, null) : Bool;
	var selfShadersCache : hxsl.ShaderList;
	var shaders : hxsl.ShaderList;
	var nextPass : Pass;
	var culled : Bool = false;
	var rendererFlags : Int = 0;

	@:bits(flags) public var enableLights : Bool;
	/**
		Inform the pass system that the parameters will be modified in object draw() command,
		so they will be manually uploaded by calling RenderContext.uploadParams.
	**/
	@:bits(flags) public var dynamicParameters : Bool;

	/**
		Mark the pass as static, this will allow some renderers or shadows to filter it
		when rendering static/dynamic parts.
	**/
	@:bits(flags) public var isStatic : Bool;

	@:bits(flags) var batchMode : Bool; // for MeshBatch

	@:bits(bits) public var culling : Face;
	@:bits(bits) public var depthWrite : Bool;
	@:bits(bits) public var depthTest : Compare;
	@:bits(bits) public var blendSrc : Blend;
	@:bits(bits) public var blendDst : Blend;
	@:bits(bits) public var blendAlphaSrc : Blend;
	@:bits(bits) public var blendAlphaDst : Blend;
	@:bits(bits) public var blendOp : Operation;
	@:bits(bits) public var blendAlphaOp : Operation;
	@:bits(bits) public var wireframe : Bool;
	public var colorMask : Int;
	public var layer : Int = 0;

	public var stencil : Stencil;

	// one bit for internal engine usage
	@:bits(bits) @:noCompletion var reserved : Bool;

	public function new(name, ?shaders, ?parent) {
		this.parentPass = parent;
		this.shaders = shaders;
		setPassName(name);
		culling = Back;
		blend(One, Zero);
		depth(true, Less);
		blendOp = blendAlphaOp = Add;
		colorMask = 15;
	}

	public function load( p : Pass ) {
		name = p.name;
		passId = p.passId;
		bits = p.bits;
		enableLights = p.enableLights;
		dynamicParameters = p.dynamicParameters;
		culling = p.culling;
		depthWrite = p.depthWrite;
		depthTest = p.depthTest;
		blendSrc = p.blendSrc;
		blendDst = p.blendDst;
		blendOp = p.blendOp;
		blendAlphaSrc = p.blendAlphaSrc;
		blendAlphaDst = p.blendAlphaDst;
		blendAlphaOp = p.blendAlphaOp;
		colorMask = p.colorMask;
		if (p.stencil != null) {
			if (stencil == null) stencil = new Stencil();
			stencil.load(p.stencil);
		}
	}

	public function setPassName( name : String ) {
		this.name = name;
		passId = hxsl.Globals.allocID(name);
	}

	public inline function blend( src, dst ) {
		this.blendSrc = src;
		this.blendAlphaSrc = src;
		this.blendDst = dst;
		this.blendAlphaDst = dst;
	}

	public function setBlendMode( b : BlendMode ) {
		blendOp = Add;
		blendAlphaOp = Add;

		switch( b ) {
		case None: // Out = 1 * Src + 0 * Dst
			blend(One, Zero);
		case Alpha: // Out = SrcA * Src + (1 - SrcA) * Dst
			blend(SrcAlpha, OneMinusSrcAlpha);
			blendAlphaSrc = One;
		case Add: // Out = SrcA * Src + 1 * Dst
			blend(SrcAlpha, One);
			blendAlphaSrc = One;
		case AlphaAdd: // Out = Src + (1 - SrcA) * Dst
			blend(One, OneMinusSrcAlpha);
		case SoftAdd: // Out = (1 - Dst) * Src + 1 * Dst
			blend(OneMinusDstColor, One);
			blendAlphaSrc = One;
		case Multiply: // Out = Dst * Src + 0 * Dst
			blend(DstColor, Zero);
			blendAlphaSrc = One;
		case AlphaMultiply: // Out = Dst * Src + (1 - SrcA) * Dst
			blend(DstColor, OneMinusSrcAlpha);
		case Erase: // Out = 0 * Src + (1 - Srb) * Dst
			blend(Zero, OneMinusSrcColor);
		case Screen: // Out = 1 * Src + (1 - Srb) * Dst
			blend(One, OneMinusSrcColor);
		case Sub: // Out = 1 * Dst - SrcA * Src
			blend(SrcAlpha, One);
			blendOp = ReverseSub;
			blendAlphaOp = ReverseSub;
		case Max: // Out = MAX( Src, Dst )
			blend(One, One);
			blendAlphaOp = Max;
			blendOp = Max;
		case Min: // Out = MIN( Src, Dst )
			blend(One, One);
			blendAlphaOp = Min;
			blendOp = Min;
		}
	}

	public function depth( write, test ) {
		this.depthWrite = write;
		this.depthTest = test;
	}

	public function setColorMask(r, g, b, a) {
		this.colorMask = (r?1:0) | (g?2:0) | (b?4:0) | (a?8:0);
	}

	public function setColorChannel( c : hxsl.Channel) {
		switch( c ) {
		case R: setColorMask(true, false, false, false);
		case G: setColorMask(false, true, false, false);
		case B: setColorMask(false, false, true, false);
		case A: setColorMask(false, false, false, true);
		default: throw "Unsupported channel "+c;
		}
	}

	public function setColorMaski(r, g, b, a, i) {
		if ( i > 8 )
			throw "Color mask i supports 8 Render target";
		var mask = (r?1:0) | (g?2:0) | (b?4:0) | (a?8:0);
		mask = mask << (i * 4);
		this.colorMask = this.colorMask | mask;
	}

	function resetRendererFlags() {
		rendererFlags = 0;
	}

	public function addShader<T:hxsl.Shader>(s:T) : T {
		// throwing an exception will require NG GameServer review
		if( s == null ) return null;
		shaders = hxsl.ShaderList.addSort(s, shaders);
		resetRendererFlags();
		return s;
	}

	function addSelfShader<T:hxsl.Shader>(s:T) : T {
		if ( s == null ) return null;
		selfShadersChanged = true;
		selfShaders = hxsl.ShaderList.addSort(s, selfShaders);
		resetRendererFlags();
		return s;
	}

	/**
		Can be used for internal usage
	**/
	function addShaderAtIndex<T:hxsl.Shader>(s:T, index:Int) : T {
		var prev = null;
		var cur = shaders;
		while( index > 0 && cur != parentShaders ) {
			prev = cur;
			cur = cur.next;
			index--;
		}
		if( prev == null )
			shaders = new hxsl.ShaderList(s, cur);
		else
			prev.next = new hxsl.ShaderList(s, cur);
		return s;
	}

	function getShaderIndex(s:hxsl.Shader) : Int {
		var index = 0;
		var cur = shaders;
		while( cur != parentShaders ) {
			if( cur.s == s ) return index;
			cur = cur.next;
			index++;
		}
		return -1;
	}

	public function removeShader(s) {
		var sl = shaders, prev = null;
		while( sl != null ) {
			if( sl.s == s ) {
				resetRendererFlags();
				if ( selfShadersCache == sl )
					selfShadersCache = selfShadersCache.next;
				if( prev == null )
					shaders = sl.next;
				else
					prev.next = sl.next;
				return true;
			}
			prev = sl;
			sl = sl.next;
		}
		sl = selfShaders;
		prev = null;
		while ( sl != null ) {
			if ( sl.s == s ) {
				resetRendererFlags();
				if ( selfShadersCache == sl )
					selfShadersCache = selfShadersCache.next;
				if ( prev == null )
					selfShaders = sl.next;
				else
					prev.next = sl.next;
				return true;
			}
			prev = sl;
			sl = sl.next;
		}
		return false;
	}

	public function removeShaders< T:hxsl.Shader >(t:Class<T>) {
		var sl = shaders;
		var prev = null;
		while( sl != null ) {
			if( hxd.impl.Api.isOfType(sl.s, t) ) {
				resetRendererFlags();
				if ( selfShadersCache == sl )
					selfShadersCache = selfShadersCache.next;
				if( prev == null )
					shaders = sl.next;
				else
					prev.next = sl.next;
			}
			else
				prev = sl;
			sl = sl.next;
		}
		sl = selfShaders;
		prev = null;
		while( sl != null ) {
			if( hxd.impl.Api.isOfType(sl.s, t) ) {
				resetRendererFlags();
				if ( selfShadersCache == sl )
					selfShadersCache = selfShadersCache.next;
				if( prev == null )
					selfShaders = sl.next;
				else
					prev.next = sl.next;
			}
			else
				prev = sl;
			sl = sl.next;
		}
	}

	public function getShader< T:hxsl.Shader >(t:Class<T>) : T {
		var s = _getShader(t, shaders);
		return s != null ? s : _getShader(t, selfShaders);
	}

	function _getShader< T:hxsl.Shader >(t:Class<T>, s : hxsl.ShaderList) : T {
		while( s != null && s != parentShaders ) {
			var sh = hxd.impl.Api.downcast(s.s, t);
			if( sh != null )
				return sh;
			s = s.next;
		}
		return null;
	}

	public function getShaderByName( name : String ) : hxsl.Shader {
		var s = _getShaderByName(name, shaders);
		return s != null ? s : _getShaderByName(name, selfShaders);
	}

	function _getShaderByName( name : String, sl : hxsl.ShaderList ) : hxsl.Shader {
		while( sl != null && sl != parentShaders ) {
			if( @:privateAccess sl.s.shader.data.name == name )
				return sl.s;
			sl = sl.next;
		}
		return null;
	}

	public inline function getShaders() {
		return shaders.iterateTo(parentShaders);
	}

	function checkInfiniteLoop() {
		var shaderList = [];
		var s = selfShaders;
		while ( s != null ) {
			for ( already in shaderList )
				if ( already == s )
					throw "infinite loop";
			shaderList.push(s);
			s = s.next;
		}
	}

	function selfShadersRec(rebuild : Bool) {
		if ( selfShaders == null )
			return shaders;
		if ( !selfShadersChanged && !rebuild && shaders == selfShadersCache )
			return selfShaders;
		var sl = selfShaders, prev = null;
		while ( sl != null && sl != selfShadersCache ) {
			prev = sl;
			sl = sl.next;
		}
		selfShadersCache = shaders;
		if ( prev != null )
			prev.next = selfShadersCache;
		else
			selfShaders = shaders;
		return selfShaders;
	}

	function getShadersRec() {
		if( parentPass == null || parentShaders == parentPass.shaders ) {
			return selfShadersRec(false);
		}
		// relink to our parent shader list
		var s = shaders, prev = null;
		while( s != null && s != parentShaders ) {
			prev = s;
			s = s.next;
		}
		parentShaders = parentPass.shaders;
		if( prev == null )
			shaders = parentShaders;
		else
			prev.next = parentShaders;
		return selfShadersRec(true);
	}

	public function clone() {
		var p = new Pass(name, shaders.clone());
		p.selfShaders = selfShaders;
		p.bits = bits;
		p.enableLights = enableLights;
		if (stencil != null) p.stencil = stencil.clone();
		return p;
	}

	#if !macro
	public function getDebugShaderCode( scene : h3d.scene.Scene, toHxsl = true ) {
		var shader = scene.renderer.debugCompileShader(this);
		if( toHxsl ) {
			var toString = hxsl.Printer.shaderToString.bind(_, true);
			return "// vertex:\n" + toString(shader.vertex.data) + "\n\nfragment:\n" + toString(shader.fragment.data);
		} else {
			return h3d.Engine.getCurrent().driver.getNativeShaderCode(shader);
		}
	}
	#end

}