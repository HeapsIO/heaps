package h3d.impl;

class RenderContext {

	public static var STRICT = true;

	public var engine : h3d.Engine;
	public var time : Float;
	public var elapsedTime : Float;
	public var frame : Int;
	public var textures : h3d.impl.TextureCache;
	public var globals : hxsl.Globals;
	public var shaderBuffers = new h3d.shader.Buffers();

	function new() {
		engine = h3d.Engine.getCurrent();
		frame = 0;
		time = 0.;
		elapsedTime = 1. / hxd.System.getDefaultFrameRate();
		textures = new h3d.impl.TextureCache();
		globals = new hxsl.Globals();
	}

	public function setCurrent() {
		inst = this;
	}

	public function clearCurrent() {
		if( inst == this )
			inst = null;
		else
			throw "Context has changed";
	}

	public function dispose() {
		textures.dispose();
	}

	function fillRec( v : Dynamic, type : hxsl.Ast.Type, out : #if hl hl.BytesAccess<hl.F32> #else h3d.shader.Buffers.ShaderBufferData #end, pos : Int ) {
		switch( type ) {
		case TInt:
			out[pos] = v;
			return 1;
		case TFloat:
			out[pos] = v;
			return 1;
		case TVec(4, _):
			var v : hxsl.Types.Vec4 = v;
			out[pos++] = v.x;
			out[pos++] = v.y;
			out[pos++] = v.z;
			out[pos++] = v.w;
			return 4;
		case TVec(n, _):
			var v : hxsl.Types.Vec = v;
			out[pos++] = v.x;
			out[pos++] = v.y;
			if( n == 3 )
				out[pos++] = v.z;
			return n;
		case TMat4:
			var m : h3d.Matrix = v;
			out[pos++] = m._11;
			out[pos++] = m._21;
			out[pos++] = m._31;
			out[pos++] = m._41;
			out[pos++] = m._12;
			out[pos++] = m._22;
			out[pos++] = m._32;
			out[pos++] = m._42;
			out[pos++] = m._13;
			out[pos++] = m._23;
			out[pos++] = m._33;
			out[pos++] = m._43;
			out[pos++] = m._14;
			out[pos++] = m._24;
			out[pos++] = m._34;
			out[pos++] = m._44;
			return 16;
		case TMat3x4:
			var m : h3d.Matrix = v;
			out[pos++] = m._11;
			out[pos++] = m._21;
			out[pos++] = m._31;
			out[pos++] = m._41;
			out[pos++] = m._12;
			out[pos++] = m._22;
			out[pos++] = m._32;
			out[pos++] = m._42;
			out[pos++] = m._13;
			out[pos++] = m._23;
			out[pos++] = m._33;
			out[pos++] = m._43;
			return 12;
		case TMat3:
			var m : h3d.Matrix = v;
			out[pos++] = m._11;
			out[pos++] = m._21;
			out[pos++] = m._31;
			out[pos++] = 0;
			out[pos++] = m._12;
			out[pos++] = m._22;
			out[pos++] = m._32;
			out[pos++] = 0;
			out[pos++] = m._13;
			out[pos++] = m._23;
			out[pos++] = m._33;
			out[pos++] = 0;
			return 12;
		case TArray(TVec(4,VFloat), SConst(len)):
			var v : Array<h3d.Vector4> = v;
			for( i in 0...len ) {
				var n = v[i];
				if( n == null ) break;
				out[pos++] = n.x;
				out[pos++] = n.y;
				out[pos++] = n.z;
				out[pos++] = n.w;
			}
			return len * 4;
		case TArray(TMat3x4, SConst(len)):
			var v : Array<h3d.Matrix> = v;
			for( i in 0...len ) {
				var m = v[i];
				if( m == null ) break;
				out[pos++] = m._11;
				out[pos++] = m._21;
				out[pos++] = m._31;
				out[pos++] = m._41;
				out[pos++] = m._12;
				out[pos++] = m._22;
				out[pos++] = m._32;
				out[pos++] = m._42;
				out[pos++] = m._13;
				out[pos++] = m._23;
				out[pos++] = m._33;
				out[pos++] = m._43;
			}
			return len * 12;
		case TArray(TFloat, SConst(len)):
			var v : Array<Float> = v;
			var size = 0;
			var count = v.length < len ? v.length : len;
			for( i in 0...count )
				out[pos++] = v[i];
			return len;
		case TArray(t, SConst(len)):
			var v : Array<Dynamic> = v;
			var size = 0;
			for( i in 0...len ) {
				var n = v[i];
				if( n == null ) break;
				size = fillRec(n, t, out, pos);
				pos += size;
			}
			return len * size;
		case TStruct(vl):
			var tot = 0;
			for( vv in vl )
				tot += fillRec(Reflect.field(v, vv.name), vv.type, out, pos + tot);
			return tot;
		default:
			throw "assert " + type;
		}
		return 0;
	}

	function shaderInfo( shaders : hxsl.ShaderList, path : String ) {
		var name = path.split(".").pop();
		while( shaders != null ) {
			var inst = @:privateAccess shaders.s.instance;
			for( v in inst.shader.vars )
				if( v.name == name )
					return shaders.s.toString();
			shaders = shaders.next;
		}
		return "(not found)";
	}

	inline function getPtr( data : h3d.shader.Buffers.ShaderBufferData ) {
		#if hl
		return (hl.Bytes.getArray((cast data : Array<Single>)) : hl.BytesAccess<hl.F32>);
		#else
		return data;
		#end
	}

	public inline function getParamValue( p : hxsl.RuntimeShader.AllocParam, shaders : hxsl.ShaderList, opt = false ) : Dynamic {
		if( p.perObjectGlobal != null ) {
			var v : Dynamic = globals.fastGet(p.perObjectGlobal.gid);
			if( v == null ) throw "Missing global value " + p.perObjectGlobal.path+" for shader "+shaderInfo(shaders,p.perObjectGlobal.path);
			if( p.type.match(TChannel(_)) )
				return v.texture;
			return v;
		}
		var si = shaders;
		var n = p.instance;
		while( --n > 0 ) si = si.next;
		var v = si.s.getParamValue(p.index);
		if( v == null && !opt ) throw "Missing param value " + si.s + "." + p.name;
		return v;
	}

	public function fillGlobals( buf : h3d.shader.Buffers, s : hxsl.RuntimeShader ) {
		inline function fill(buf:h3d.shader.Buffers.ShaderBuffers, s:hxsl.RuntimeShader.RuntimeShaderData) {
			var g = s.globals;
			var ptr = getPtr(buf.globals);
			while( g != null ) {
				var v = globals.fastGet(g.gid);
				if( v == null )
					throw "Missing global value " + g.path;
				fillRec(v, g.type, ptr, g.pos);
				g = g.next;
			}
		}
		fill(buf.vertex, s.vertex);
		if( s.fragment != null ) fill(buf.fragment, s.fragment);
	}

	public function fillParams( buf : h3d.shader.Buffers, s : hxsl.RuntimeShader, shaders : hxsl.ShaderList ) {
		var curInstance = -1;
		var curInstanceValue = null;
		inline function getInstance( index : Int ) {
			if( curInstance == index )
				return curInstanceValue;
			var si = shaders;
			curInstance = index;
			while( --index > 0 ) si = si.next;
			curInstanceValue = si.s;
			return curInstanceValue;
		}
		inline function getParamValue( p : hxsl.RuntimeShader.AllocParam, shaders : hxsl.ShaderList, opt = false ) : Dynamic {
			if( p.perObjectGlobal != null ) {
				var v : Dynamic = globals.fastGet(p.perObjectGlobal.gid);
				if( v == null ) throw "Missing global value " + p.perObjectGlobal.path+" for shader "+shaderInfo(shaders,p.perObjectGlobal.path);
				if( p.type.match(TChannel(_)) )
					return v.texture;
				return v;
			}
			var v = getInstance(p.instance).getParamValue(p.index);
			if( v == null && !opt ) throw "Missing param value " + shaders.s + "." + p.name;
			return v;
		}
		inline function fill(buf:h3d.shader.Buffers.ShaderBuffers, s:hxsl.RuntimeShader.RuntimeShaderData) {
			var p = s.params;
			var ptr = getPtr(buf.params);
			while( p != null ) {
				var v : Dynamic;
				if( p.perObjectGlobal == null ) {
					if( p.type == TFloat ) {
						var i = getInstance(p.instance);
						ptr[p.pos] = i.getParamFloatValue(p.index);
						p = p.next;
						continue;
					}
					v = getInstance(p.instance).getParamValue(p.index);
					if( v == null ) throw "Missing param value " + curInstanceValue + "." + p.name;
				} else
					v = getParamValue(p, shaders);
				fillRec(v, p.type, ptr, p.pos);
				p = p.next;
			}
			var tid = 0;
			var p = s.textures;
			while( p != null ) {
				var t : Dynamic = getParamValue(p, shaders, !STRICT);
				if( p.pos < 0 ) {
					// is array !
					var arr : Array<h3d.mat.Texture> = t;
					for( i in 0...-p.pos )
						buf.tex[tid++] = arr[i];
				} else
					buf.tex[tid++] = t;
				p = p.next;
			}
			var p = s.buffers;
			var bid = 0;
			while( p != null ) {
				var b : h3d.Buffer = getParamValue(p, shaders, !STRICT);
				buf.buffers[bid++] = b;
				p = p.next;
			}
		}
		fill(buf.vertex, s.vertex);
		if( s.fragment != null ) fill(buf.fragment, s.fragment);
	}

	static var inst : RenderContext;
	public static function get() return inst;
	public static inline function getType<T:RenderContext>( cl : Class<h3d.impl.RenderContext> ) {
		return Std.downcast(inst, cl);
	}

}