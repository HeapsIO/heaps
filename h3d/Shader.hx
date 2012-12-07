package h3d;
import hxsl.Data.Tools;

typedef FixedArray<T,Const> = Array<T>;

class ShaderInstance {

	public var bits : Int;
	
	public var program : flash.display3D.Program3D;

	public var bufferFormat : Int;
	public var stride : Int;

	public var vertexVars : flash.Vector<Float>;
	public var fragmentVars : flash.Vector<Float>;
	public var textures : flash.Vector<h3d.mat.Texture>;

	public var vertexMap : flash.Vector<Int>;
	public var fragmentMap : flash.Vector<Int>;
	public var textureMap : flash.Vector<Int>;
	
	public var vertexBytes : haxe.io.Bytes;
	public var fragmentBytes : haxe.io.Bytes;
	
	public var varsChanged : Bool;
	
	public function new() {
	}
	
	public function updateVars( allVars : flash.Vector<Float>, allTex : flash.Vector<h3d.mat.Texture> ) {
		varsChanged = true;
		for( i in 0...vertexMap.length )
			vertexVars[i] = allVars[vertexMap[i]];
		for( i in 0...fragmentMap.length )
			fragmentVars[i] = allVars[fragmentMap[i]];
		for( i in 0...textureMap.length )
			textures[i] = allTex[textureMap[i]];
	}
	
}

class ShaderGlobals {
	
	var data : hxsl.Data;
	var instances : IntHash<ShaderInstance>;
	var hparams : IntHash<hxsl.Data.Variable>;
	public var allSize : Int;
	public var texSize : Int;
	
	public function new( hxStr : String ) {
		this.data = hxsl.Unserialize.unserialize(hxStr);
		
		hparams = new IntHash();
		allSize = 0;
		for( v in Tools.getAllVars(data) )
			switch( v.kind ) {
			case VConst, VParam:
				if( v.type != TBool ) {
					v.index = allSize;
					allSize += hxsl.Data.Tools.floatSize(v.type);
					hparams.set(v.id, v);
				}
			case VTexture:
				v.index = texSize++;
				hparams.set(v.id, v);
			default:
			}
		allSize++; // last 0
		
		instances = new IntHash();
	}
	
	function build( code : hxsl.Data.Code ) {
			
		// init map
		var nregs = 0;
		var map = new flash.Vector();
		for( v in code.args ) {
			var realV = hparams.get(v.id);
			if( v == null ) throw "assert " + v.name;
			var size = Tools.floatSize(v.type);
			for( i in 0...size )
				map.push(realV.index + i);
			var regs = Tools.regSize(v.type);
			nregs += regs;
			for( i in size...regs * 4 )
				map.push(allSize - 1);
		}
		
		// add consts
		var pos = nregs * 4;
		nregs += code.consts.length;
		var consts = new flash.Vector(nregs * 4);
		for( c in code.consts ) {
			for( v in c )
				consts[pos++] = v;
			for( i in c.length...4 )
				consts[pos++] = 1.;
		}
		
		var agal = new hxsl.AgalCompiler().compile(code);
		var o = new haxe.io.BytesOutput();
		new format.agal.Writer(o).write(agal);
		return { bytes : o.getBytes(), consts : consts, map : map };
	}
	
	public function getInstance( bits : Int ) {
		var i = instances.get(bits);
		if( i != null )
			return i;
		var r = new hxsl.RuntimeCompiler();
		var consts = { };
		var constCount = 0;
		for( v in Tools.getAllVars(data) )
			if( v.kind == VConst ) {
				if( bits & (1 << constCount) != 0 ) {
					var c : Dynamic;
					if( v.type == TBool ) c = true else c = 0;
					Reflect.setField(consts, v.name, c);
				}
				constCount++;
			}
		
		var data2 = r.compile(data, consts);
		i = new ShaderInstance();
		i.bits = bits;
		
		var v = build(data2.vertex);
		i.vertexBytes = v.bytes;
		i.vertexMap = v.map;
		i.vertexVars = v.consts;
		
		var f = build(data2.fragment);
		i.fragmentBytes = f.bytes;
		i.fragmentMap = f.map;
		i.fragmentVars = f.consts;
				
		i.textureMap = new flash.Vector();
		for( v in data2.vertex.tex.concat(data2.fragment.tex) ) {
			if( v.kind != VTexture ) throw "assert";
			var realV = hparams.get(v.id);
			i.textureMap.push(realV.index);
		}
		i.textures = new flash.Vector(i.textureMap.length);
		
		
		i.bufferFormat = 0;
		i.stride = 0;
		for( v in data2.globals )
			switch( v.kind ) {
			case VInput:
				var size = Tools.floatSize(v.type);
				switch( v.type ) {
				case TInt:
					// 0
				case TFloat, TFloat2, TFloat3, TFloat4:
					i.bufferFormat |= Tools.floatSize(v.type) << (3 * v.index);
				default:
					throw "Type not supported in input " + Type.enumConstructor(v.type).substr(1);
				}
				i.stride += size;
			case VVar:
				// ignore
			default:
				throw "assert " + v.kind;
			}


		instances.set(bits, i);
		
		return i;
	}
	
}


@:autoBuild(h3d.impl.Macros.buildShader())
class Shader {

	var globals : ShaderGlobals;
	var modified : Bool;
	var constBits : Int;
	var allParams : flash.Vector<Float>;
	var allTextures : flash.Vector<h3d.mat.Texture>;
	var instance : ShaderInstance;
	
	public function new() {
		var c : { HXSL : String, GLOBALS : ShaderGlobals } = cast Type.getClass(this);
		globals = c.GLOBALS;
		if( globals == null ) {
			globals = new ShaderGlobals(c.HXSL);
			c.GLOBALS = globals;
		}
		allParams = new flash.Vector(globals.allSize);
		allTextures = new flash.Vector(globals.texSize);
	}
	
	function updateParams() {
		throw "assert"; // will be overriden in subclass
	}
	
	public function getInstance() : ShaderInstance {
		if( instance == null || instance.bits != constBits )
			instance = globals.getInstance(constBits);
		if( modified )
			updateParams();
		instance.updateVars(allParams, allTextures);
		return instance;
	}
	
	inline function loadMatrixT( index : Int, r : Int, c : Int ) {
		var m = new h3d.Matrix();
		m.identity();
		
		var pos = index;
		m._11 = allParams[pos++];
		if( c > 1 ) m._21 = allParams[pos++];
		if( c > 2 ) m._31 = allParams[pos++];
		if( c > 3 ) m._41 = allParams[pos++];

		if( r > 1 ) {
			m._12 = allParams[pos++];
			if( c > 1 ) m._22 = allParams[pos++];
			if( c > 2 ) m._32 = allParams[pos++];
			if( c > 3 ) m._42 = allParams[pos++];

			if( r > 2 ) {
				m._13 = allParams[pos++];
				if( c > 1 ) m._23 = allParams[pos++];
				if( c > 2 ) m._33 = allParams[pos++];
				if( c > 3 ) m._43 = allParams[pos++];

				if( r > 3 ) {
					m._14 = allParams[pos++];
					if( c > 1 ) m._24 = allParams[pos++];
					if( c > 2 ) m._34 = allParams[pos++];
					if( c > 3 ) m._44 = allParams[pos++];
				}
			}
		}
		
		return m;
	}
	
	inline function saveMatrixT( index : Int, m : h3d.Matrix, r : Int, c : Int ) {
		var pos = index;
		allParams[pos++] = m._11;
		if( c > 1 ) allParams[pos++] = m._21;
		if( c > 2 ) allParams[pos++] = m._31;
		if( c > 3 ) allParams[pos++] = m._41;
		
		if( r > 1 ) {
			allParams[pos++] = m._12;
			if( c > 1 ) allParams[pos++] = m._22;
			if( c > 2 ) allParams[pos++] = m._32;
			if( c > 3 ) allParams[pos++] = m._42;

			if( r > 2 ) {
				allParams[pos++] = m._13;
				if( c > 1 ) allParams[pos++] = m._23;
				if( c > 2 ) allParams[pos++] = m._33;
				if( c > 3 ) allParams[pos++] = m._43;

				if( r > 3 ) {
					allParams[pos++] = m._14;
					if( c > 1 ) allParams[pos++] = m._24;
					if( c > 2 ) allParams[pos++] = m._34;
					if( c > 3 ) allParams[pos++] = m._44;
				}
			}
		}
	}
	
	inline function loadFloats( index : Int, n : Int ) {
		var v = new h3d.Vector();
		var pos = index;
		v.x = allParams[pos++];
		v.y = allParams[pos++];
		if( n > 2 ) v.z = allParams[pos++];
		if( n > 3 ) v.w = allParams[pos++];
		return v;
	}

	inline function saveFloats( index : Int, v : h3d.Vector, n : Int ) {
		allParams[index] = v.x;
		allParams[index + 1] = v.y;
		if( n > 2 ) allParams[index + 2] = v.z;
		if( n > 3 ) allParams[index + 3] = v.w;
		return v;
	}
	
	inline function saveInt( index : Int, v : Int ) {
		allParams[index] = ((v >> 16) & 0xFF) / 255;
		allParams[index + 1] = ((v >> 8) & 0xFF) / 255;
		allParams[index + 2] = (v & 0xFF) / 255;
		allParams[index + 3] = (v >>> 24) / 255;
	}
	
	inline function saveFloat( index : Int, v : Float ) {
		allParams[index] = v;
	}
	
	inline function setConstFlag( n : Int, v : Bool ) {
		if( v ) constBits |= 1 << n else constBits &= ~(1 << n);
	}
	
	public function toString() {
		return Type.getClassName(Type.getClass(this));
	}
	
}