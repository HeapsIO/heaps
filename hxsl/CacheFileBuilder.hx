package hxsl;

enum CacheFilePlatform {
	DirectX;
	OpenGL;
	PS4;
	XBoxOne;
	XBoxSeries;
	NX;
	NXBinaries;
}

private class CustomCacheFile extends CacheFile {

	var build : CacheFileBuilder;
	var shared : Map<String,SharedShader> = new Map();

	public function new(build) {
		this.build = build;
		super(true, true);
	}

	override function load() {
		allowSave = true;
		super.load();
	}

	override function addSource(r:RuntimeShader) {
		r.vertex.code = build.compileShader(r, r.vertex);
		r.fragment.code = build.compileShader(r, r.fragment);
		if ( build.platform == NXBinaries ) {
			// NXBinaries requires both vertex and fragment shader to work, avoid null access and skip the shader instead.
			try {
				super.addSource(r);
			} catch ( e : Dynamic ) {}
		} else
			super.addSource(r);
	}

	override function resolveShader(name:String):hxsl.Shader {
		var s = super.resolveShader(name);
		if( s != null )
			return s;
		var shared = shared.get(name);
		if( shared == null ) {
			var src = build.shaderLib.get(name);
			if( src == null )
				return null;
			shared = new SharedShader(src);
			this.shared.set(name, shared);
		}
		return new hxsl.DynamicShader(shared);
	}

	override function getPlatformTag() {
		return switch( build.platform ) {
		case DirectX: "dx";
		case OpenGL: "gl";
		case PS4: "ps4";
		case XBoxOne: "xboxone";
		case XBoxSeries: "xbox";
		case NX: "nx";
		case NXBinaries: "nxbin";
		};
	}

}

class CacheFileBuilder {

	public var platform : CacheFilePlatform;
	public var platforms : Array<CacheFilePlatform> = [];
	public var shaderLib : Map<String,String> = new Map();
	public var dxInitDone = false;
	#if (hldx && dx12)
	public var dx12Driver : h3d.impl.DX12Driver;
	#end
	public var dxShaderVersion = "5_0";
	public var dxcShaderVersion = "6_0";
	var glout : GlslOut;
	var vertexOut : String;
	var hasCompiled : Bool;
	var binariesPath : String;
	var shaderCache : h3d.impl.ShaderCache;
	var shaderCacheConfig : String = "";

	public function new() {
	}

	public function run() {
		for( p in platforms ) {
			Sys.println("Generating shaders for " + p);
			this.platform = p;
			hasCompiled = false;
			var cache = new CustomCacheFile(this);
			@:privateAccess cache.save();
			if( hasCompiled ) Sys.println("");
		}
		if( shaderCache != null )
			@:privateAccess shaderCache.save();
	}

	function binaryPayload( data : haxe.io.Bytes ) {
		return "\n//BIN=" + haxe.crypto.Base64.encode(data) + "#\n";
	}

	public function compileShader( r : RuntimeShader, rd : RuntimeShader.RuntimeShaderData ) : String {
		hasCompiled = true;
		Sys.print(".");
		var s = generateShader(r, rd);
		if( s == null )
			return null;
		if( s.bytes == null )
			return s.code;
		if( s.code == null )
			return binaryPayload(s.bytes);
		if( shaderCache != null )
			shaderCache.saveCompiledShader(s.code, s.bytes, shaderCacheConfig);
		return s.code + binaryPayload(s.bytes);
	}

	function generateShader( r : RuntimeShader, rd : RuntimeShader.RuntimeShaderData ) : { code : String, bytes : haxe.io.Bytes } {
		switch( platform ) {
		case DirectX:
			#if (hldx && !dx12)
			if( !dxInitDone ) {
				var win = new dx.Window("", 800, 600);
				win.visible = false;
				dxInitDone = true;
				dx.Driver.create(win, R8G8B8A8_UNORM, None);
			}
			var out = new HlslOut();
			var code = out.run(rd.data);
			var bytes = dx.Driver.compileShader(code, "", "main", (rd.vertex?"vs_":"ps_") + dxShaderVersion, OptimizationLevel3);
			return { code : code, bytes : bytes };
			#else
			throw "DirectX compilation requires -lib hldx without -D dx12";
			#end
		case OpenGL:
			if( rd.vertex ) {
				// both vertex and fragment needs to be compiled with the same GlslOut !
				glout = new GlslOut();
				glout.version = 150;
			}
			return { code : glout.run(rd.data), bytes : null };
		case PS4:
			#if hlps
			var out = new ps.gnm.PsslOut();
			var code = out.run(rd.data);
			var tmpFile = "tmp";
			var tmpSrc = tmpFile + ".pssl";
			var tmpOut = tmpFile + ".sb";
			sys.io.File.saveContent(tmpSrc, code);
			var args = ["-profile", rd.vertex ? "sce_vs_vs_orbis" : "sce_ps_orbis", "-o", tmpOut, tmpSrc];
			var p = new sys.io.Process("orbis-wave-psslc.exe", args);
			var error = p.stderr.readAll().toString();
			var ecode = p.exitCode();
			if( ecode != 0 )
				throw "ERROR while compiling " + tmpSrc + "\n" + error;
			p.close();
			var data = sys.io.File.getBytes(tmpOut);
			sys.FileSystem.deleteFile(tmpSrc);
			sys.FileSystem.deleteFile(tmpOut);
			return { code : code, bytes : data };
			#else
			throw "PS4 compilation requires -lib hlps";
			#end
		case XBoxOne:
			var out = new HlslOut();
			var code = out.run(rd.data);
			var tmpFile = "tmp";
			var tmpSrc = tmpFile + ".hlsl";
			var tmpOut = tmpFile + ".sb";
			sys.io.File.saveContent(tmpSrc, code);
			var args = ["-T", (rd.vertex ? "vs_" : "ps_") + dxShaderVersion,"-O3","-Fo", tmpOut, tmpSrc];
			var p = new sys.io.Process(Sys.getEnv("XboxOneXDKLatest")+ "xdk\\FXC\\amd64\\fxc.exe", args);
			var error = p.stderr.readAll().toString();
			var ecode = p.exitCode();
			if( ecode != 0 )
				throw "ERROR while compiling " + tmpSrc + "\n" + error;
			p.close();
			var data = sys.io.File.getBytes(tmpOut);
			sys.FileSystem.deleteFile(tmpSrc);
			sys.FileSystem.deleteFile(tmpOut);
			return { code : code, bytes : data };
		case XBoxSeries:
			#if (hldx && dx12)
			if( !dxInitDone ) {
				var win = new dx.Window("", 800, 600);
				win.visible = false;
				dxInitDone = true;
				dx12Driver = new h3d.impl.DX12Driver();
			}
			var out = new HlslOut();
			var tmpFile = "tmp";
			var tmpSrc = tmpFile + ".hlsl";
			var tmpOut = tmpFile + ".sb";
			var sign = @:privateAccess dx12Driver.computeRootSignature(r);
			out.baseRegister = rd.vertex ? 0 : sign.fragmentRegStart;
			var code = out.run(rd.data);
			var serializeRootSignature = @:privateAccess dx12Driver.stringifyRootSignature(sign.sign, "ROOT_SIGNATURE", sign.params);
			code = serializeRootSignature + code;
			sys.io.File.saveContent(tmpSrc, code);
			var args = ["-rootsig-define", "ROOT_SIGNATURE", "-T", (rd.vertex ? "vs_" : "ps_") + dxcShaderVersion,"-O3","-Fo", tmpOut, tmpSrc];
			var p = new sys.io.Process(Sys.getEnv("GXDKLatest")+ "bin\\Scarlett\\dxc.exe", args);
			var error = p.stderr.readAll().toString();
			var ecode = p.exitCode();
			if( ecode != 0 )
				throw "ERROR while compiling " + tmpSrc + "\n" + error;
			p.close();
			var data = sys.io.File.getBytes(tmpOut);
			sys.FileSystem.deleteFile(tmpSrc);
			sys.FileSystem.deleteFile(tmpOut);
			return { code : null, bytes : data };
			#else
			throw "-lib hldx and -D dx12 are required to generate binaries for XBoxSeries";
			#end
		case NX:
			if( rd.vertex )
				glout = new hxsl.NXGlslOut();
			return { code : glout.run(rd.data), bytes : null };
		case NXBinaries:
			if( rd.vertex )
				glout = new hxsl.NXGlslOut();
			if ( rd.vertex ) {
				vertexOut = glout.run(rd.data);
				return { code : vertexOut, bytes : null }; // binary is in fragment.code
			}
			var path = binariesPath + '/${r.signature}.glslc';
			if ( !sys.FileSystem.exists(path) || vertexOut == null )
				return null;
			var code = vertexOut + glout.run(rd.data);
			vertexOut = null;
			return { code : code, bytes : sys.io.File.getBytes(path) };
		}
		throw "Missing implementation for " + platform;
	}

	public static function main() {
		var args = Sys.args();
		try sys.FileSystem.deleteFile("hxsl.CacheFileBuilder.hl") catch( e : Dynamic ) {};
		var builder = new CacheFileBuilder();
		while( args.length > 0 ) {
			var f = args.shift();
			var pos = f.indexOf("=");
			if( pos > 0 ) {
				args.unshift(f.substr(pos + 1));
				f = f.substr(0, pos);
			}
			function getArg() {
				if( args.length == 0 ) throw f + " requires argument";
				return args.shift();
			}
			switch( f ) {
			case "-file":
				CacheFile.FILENAME = getArg();
			case "-lib":
				var lib = new format.hl.Reader().read(new haxe.io.BytesInput(sys.io.File.getBytes(getArg())));
				for( s in lib.strings ) {
					if( !StringTools.startsWith(s,"HXSL") ) continue;
					var data = try haxe.crypto.Base64.decode(s) catch( e : Dynamic ) continue;
					var len = data.get(3);
					var name = data.getString(4,len);
					builder.shaderLib.set(name, s);
				}
			case "-gl":
				builder.platforms.push(OpenGL);
			case "-dx":
				builder.platforms.push(DirectX);
			case "-ps4":
				builder.platforms.push(PS4);
			case "-xbox":
				builder.platforms.push(XBoxOne);
			case "-xbs":
				builder.platforms.push(XBoxSeries);
			case "-nx":
				builder.platforms.push(NX);
			case "-nxbinary":
				builder.binariesPath = getArg();
				builder.platforms.push(NXBinaries);
			case "-build-cache":
				builder.shaderCache = new h3d.impl.ShaderCache(getArg());
				builder.shaderCache.initEmpty();
			case "-build-cache-source":
				builder.shaderCache.keepSource = true;
			case "-build-cache-config":
				builder.shaderCacheConfig = getArg();
			default:
				throw "Unknown parameter " + f;
			}
		}
		if( builder.platforms.length == 0 )
			throw "No platform selected";
		builder.run();
		Sys.exit(0);
	}

}