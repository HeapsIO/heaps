package h3d.mat;
import h3d.mat.Data;

@:allow(h3d.mat.BaseMaterial)
@:build(hxd.impl.BitsBuilder.build())
class Pass implements hxd.impl.Serializable {

	@:s public var name(default, null) : String;
	var passId : Int;
	@:s var bits : Int = 0;
	@:s var parentPass : Pass;
	var parentShaders : hxsl.ShaderList;
	var shaders : hxsl.ShaderList;
	@:s var nextPass : Pass;

	@:s public var enableLights : Bool;
	/**
		Inform the pass system that the parameters will be modified in object draw() command,
		so they will be manually uploaded by calling RenderContext.uploadParams.
	**/
	@:s public var dynamicParameters : Bool;

	@:bits(bits) public var culling : Face;
	@:bits(bits) public var depthWrite : Bool;
	@:bits(bits) public var depthTest : Compare;
	@:bits(bits) public var blendSrc : Blend;
	@:bits(bits) public var blendDst : Blend;
	@:bits(bits) public var blendAlphaSrc : Blend;
	@:bits(bits) public var blendAlphaDst : Blend;
	@:bits(bits) public var blendOp : Operation;
	@:bits(bits) public var blendAlphaOp : Operation;
	@:bits(bits, 4) public var colorMask : Int;

	@:s public var stencil : Stencil;

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
		shaders = hxsl.ShaderList.addSort(s, shaders);
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

	public function getShaderByName( name : String ) : hxsl.Shader {
		var s = shaders;
		while( s != parentShaders ) {
			if( Std.is(s.s, hxsl.DynamicShader) )
				trace(@:privateAccess s.s.shader.data.name);
			if( @:privateAccess s.s.shader.data.name == name )
				return s.s;
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
		if (stencil != null) p.stencil = stencil.clone();
		return p;
	}

	public function getDebugShaderCode( scene : h3d.scene.Scene, toHxsl = true ) {
		var shader = scene.renderer.debugCompileShader(this);
		if( toHxsl ) {
			var toString = hxsl.Printer.shaderToString.bind(_, true);
			return "// vertex:\n" + toString(shader.vertex.data) + "\n\nfragment:\n" + toString(shader.fragment.data);
		} else {
			return h3d.Engine.getCurrent().driver.getNativeShaderCode(shader);
		}
	}

	#if hxbit

	public function customSerialize( ctx : hxbit.Serializer ) {
		var ctx : hxd.fmt.hsd.Serializer = cast ctx;
		var s = shaders;
		while( s != parentShaders ) {
			ctx.addShader(s.s);
			s = s.next;
		}
		ctx.addShader(null);
	}
	public function customUnserialize( ctx : hxbit.Serializer ) {
		var ctx : hxd.fmt.hsd.Serializer = cast ctx;
		var head = null;
		while( true ) {
			var s = ctx.getShader();
			if( s == null ) break;
			var sl = new hxsl.ShaderList(s);
			if( head == null ) {
				head = shaders = sl;
			} else {
				head.next = sl;
				head = sl;
			}
		}
		setPassName(name);
		loadBits(bits);
	}
	#end

}