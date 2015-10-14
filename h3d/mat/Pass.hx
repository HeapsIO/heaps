package h3d.mat;
import h3d.mat.Data;

@:allow(h3d.mat.Material)
@:build(hxd.impl.BitsBuilder.build())
class Pass {

	public var name(default, null) : String;
	var passId : Int;
	var bits : Int = 0;
	var parentPass : Pass;
	var parentShaders : hxsl.ShaderList;
	var shaders : hxsl.ShaderList;
	var nextPass : Pass;

	public var enableLights : Bool;
	/**
		Inform the pass system that the parameters will be modified in object draw() command,
		so they will be manually uploaded by calling RenderContext.uploadParams.
	**/
	public var dynamicParameters : Bool;

	@:bits public var culling : Face;
	@:bits public var depthWrite : Bool;
	@:bits public var depthTest : Compare;
	@:bits public var blendSrc : Blend;
	@:bits public var blendDst : Blend;
	@:bits public var blendAlphaSrc : Blend;
	@:bits public var blendAlphaDst : Blend;
	@:bits public var blendOp : Operation;
	@:bits public var blendAlphaOp : Operation;
	@:bits(4) public var colorMask : Int;

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

	public function loadProps( p : Pass ) {
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
		switch( b ) {
		case None:
			blend(One, Zero);
		case Alpha:
			blend(SrcAlpha, OneMinusSrcAlpha);
		case Add:
			blend(SrcAlpha, One);
		case SoftAdd:
			blend(OneMinusDstColor, One);
		case Multiply:
			blend(DstColor, Zero);
		case Erase:
			blend(Zero, OneMinusSrcColor);
		case Screen:
			blend(One, OneMinusSrcColor);
		}
	}

	public function depth( write, test ) {
		this.depthWrite = write;
		this.depthTest = test;
	}

	public function setColorMask(r, g, b, a) {
		this.colorMask = (r?1:0) | (g?2:0) | (b?4:0) | (a?8:0);
	}

	public function addShader<T:hxsl.Shader>(s:T) : T {
		shaders = new hxsl.ShaderList(s, shaders);
		return s;
	}

	public function addShaderAt<T:hxsl.Shader>(s:T, index:Int) : T {
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

	public function removeShader(s) {
		var sl = shaders, prev = null;
		while( sl != null ) {
			if( sl.s == s ) {
				if( prev == null )
					shaders = sl.next;
				else
					prev.next = sl.next;
				return true;
			}
			prev = sl;
			sl = sl.next;
		}
		return false;
	}

	public function getShader< T:hxsl.Shader >(t:Class<T>) : T {
		var s = shaders;
		while( s != parentShaders ) {
			var sh = Std.instance(s.s, t);
			if( sh != null )
				return sh;
			s = s.next;
		}
		return null;
	}

	public inline function getShaders() {
		return shaders.iterateTo(parentShaders);
	}

	function getShadersRec() {
		if( parentPass == null || parentShaders == parentPass.shaders )
			return shaders;
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
		return shaders;
	}

	public function clone() {
		var p = new Pass(name, shaders.clone());
		p.bits = bits;
		p.enableLights = enableLights;
		return p;
	}

	public function getDebugShaderCode( scene : h3d.scene.Scene, toHxsl = true ) {
		var shader = scene.renderer.compileShader(this);
		var toString = toHxsl ? hxsl.Printer.shaderToString.bind(_, true) : hxsl.GlslOut.toGlsl;
		return "VERTEX=\n" + toString(shader.vertex.data) + "\n\nFRAGMENT=\n" + toString(shader.fragment.data);
	}

}