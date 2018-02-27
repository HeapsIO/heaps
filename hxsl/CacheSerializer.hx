package hxsl;

import hxsl.RuntimeShader;
typedef ShaderCompiler = {
	function run(d : hxsl.Ast.ShaderData) : String;
	var varNames : Map<Int, String>;
}

class CacheSerializer extends hxsl.Cache {

	var allInstances : Map<Int, Bool> = new Map();
	var instancesByShader : Map<String, Array<{id: Int, constBits: Int}>> = new Map();

	var codesMap : Map<String, Int> = new Map();
	var codes : Array<String> = [];

	var allRuntimes : Map<Int, {vars: Array<hxsl.Output>, runtimes: Array<{ids: Array<Int>, runtime: RuntimeShader, vertex: Int, fragment: Int}>}> = new Map();

	public var glslVersion : Int = 150;

	public function new(){
		super();
		@:privateAccess hxsl.Cache.INST = this;
	}

	override function getLinkShader( vars : Array<hxsl.Output> ){
		var shader = super.getLinkShader(vars);
		allRuntimes.set(@:privateAccess shader.instance.id, {vars: vars, runtimes: []});
		return shader;
	}

	override function compileRuntimeShader( list : hxsl.ShaderList ){
		var runtime = super.compileRuntimeShader(list);

		var compiler = initShaderCompiler();
		var vertexId = genCode(compiler, runtime.vertex, true);
		var fragmentId = genCode(compiler, runtime.fragment, false);

		var ids = [];
		for( s in list.next ) @:privateAccess {
			if( !allInstances.exists(s.instance.id) ){
				allInstances.set(s.instance.id, true);
				var c = Type.getClassName(Type.getClass(s));
				var a = instancesByShader.get(c);
				if( a == null ) instancesByShader.set(c,a=[]);
				a.push({id: s.instance.id, constBits: s.constBits});
			}
			ids.push(s.instance.id);
		}

		allRuntimes.get(@:privateAccess list.s.instance.id).runtimes.push({
			ids: ids,
			runtime: runtime, 
			vertex: vertexId, 
			fragment: fragmentId,
		});

		return runtime;
	}

	function genCode( compiler : ShaderCompiler, data : RuntimeShaderData, isVertex : Bool ){
		var code = compileShader(compiler, data.data, isVertex);
		data.code = code;
		
		var hash = haxe.crypto.Sha1.encode(code);
		var id = codesMap.get(hash);
		if( id == null ){
			id = codes.length;
			codesMap.set(hash,id);
			codes.push(code);
		}

		return id;
	}

	function initShaderCompiler() : ShaderCompiler {
		#if usegl
		return new haxe.GLTypes.ShaderCompiler();
		#elseif hldx
		return new hxsl.HlslOut();
		#else
		var r = new hxsl.GlslOut();
		r.version = glslVersion;
		return r;
		#end
	}

	function compileShader( compiler : ShaderCompiler, data : hxsl.Ast.ShaderData, isVertex : Bool ) : String {
		var code = compiler.run(data);

		#if !hldx
		for( v in data.vars ){
			var vname = v.name;
			if( isVertex && v.kind == Input )
				vname = compiler.varNames.get(v.id);
			else if( !isVertex && v.kind == Output )
				vname = compiler.varNames.get(v.id);

			if( vname != v.name ){
				trace('Warning: variable name changed from ${v.name} to $vname');
				v.name = vname;
			}
		}
		#end

		return code;
	}

	public function serialize(){
		var ctx = new hxbit.Serializer();
		ctx.begin();

		// Codes
		ctx.addInt(codes.length);
		for( c in codes )
			ctx.addString(c);

		// Instances
		ctx.addInt( [for( c in instancesByShader.keys()) c].length );
		for( c in instancesByShader.keys() ){
			var a = instancesByShader.get(c);
			ctx.addString(c);
			ctx.addInt(a.length);
			for( o in a){
				ctx.addInt(o.id);
				ctx.addInt(o.constBits);
			}
		}

		// Shader list
		var linkIds = [for( c in allRuntimes.keys()) c];
		ctx.addInt( linkIds.length );
		for( linkId in linkIds ){
			var data = allRuntimes.get(linkId);
			ctx.addString(haxe.Serializer.run(data.vars));
			ctx.addInt(data.runtimes.length);
			for( e in data.runtimes ){
				ctx.addInt(e.ids.length);
				for( id in e.ids ) 
					ctx.addInt(id);
				ctx.addString(serializeRuntime(e.runtime));
				ctx.addInt(e.vertex);
				ctx.addInt(e.fragment);
			}
		}
		return haxe.zip.Compress.run(ctx.end(),9);
	}

	function serializeRuntime( runtime : hxsl.RuntimeShader ){
		// Note: two runtimes can share id with different variables mapping
		if( runtime.id >= 0 )
			runtime.id = -runtime.id - 1;
		
		runtime.signature = null;
		inline function clean(rd:hxsl.RuntimeShader.RuntimeShaderData, isVertex: Bool){
			rd.data.name = null;
			rd.data.funs = null;
			rd.data.vars = rd.data.vars.filter(function(v){
				v.parent = null;
				v.qualifiers = null;
				return v.kind == (isVertex ? Input : Output);
			});
			var p = rd.globals;
			while( p != null ){
				p.gid = -1;
				p = p.next;
			}
			var p = rd.params;
			while( p != null ){
				if( p.perObjectGlobal != null )
					p.perObjectGlobal.gid = -1;
				p = p.next;
			}
			var p = rd.textures2D;
			while( p != null ){
				if( p.perObjectGlobal != null )
					p.perObjectGlobal.gid = -1;
				p = p.next;
			}
			var p = rd.texturesCube;
			while( p != null ){
				if( p.perObjectGlobal != null )
					p.perObjectGlobal.gid = -1;
				p = p.next;
			}
		}
		
		runtime.globals = null;
		clean(runtime.vertex, true);
		clean(runtime.fragment, false);

		haxe.Serializer.USE_CACHE = true;
		return haxe.Serializer.run(runtime);
	}
	
}
