package h3d.pass;

@:build(hxsl.Macros.buildGlobals())
@:access(h3d.pass.Pass)
class Base {

	var globals : hxsl.Globals;
	var ctx : h3d.scene.RenderContext;
	var shaderCache : hxsl.Cache;
	var output : Int;

	@global("camera.view") var cameraView : h3d.Matrix = ctx.camera.mcam;
	@global("camera.proj") var cameraProj : h3d.Matrix = ctx.camera.mproj;
	@global("camera.position") var cameraPos : h3d.Vector = ctx.camera.pos;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector = new h3d.Vector(ctx.camera.mproj._11,ctx.camera.mproj._22,ctx.camera.mproj._33,ctx.camera.mproj._44);
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix = ctx.camera.m;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix = ctx.camera.getInverseViewProj();
	@global("global.time") var globalTime : Float = ctx.time;
	@global("global.modelView") var globalModelView : h3d.Matrix;
	
	public function new() {
		shaderCache = hxsl.Cache.get();
		output = shaderCache.allocOutputVars(["output.position", "output.color"]);
		globals = new hxsl.Globals();
		initGlobals();
	}
	
	function fillRec( v : Dynamic, type : hxsl.Ast.Type, out : haxe.ds.Vector<Float>, pos : Int ) {
		switch( type ) {
		case TFloat:
			out[pos] = v;
			return 1;
		case TVec(n, _):
			var v : h3d.Vector = v;
			out[pos++] = v.x;
			out[pos++] = v.y;
			switch( n ) {
			case 3:
				out[pos++] = v.z;
			case 4:
				out[pos++] = v.z;
				out[pos++] = v.w;
			}
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
		case TArray(t, SConst(len)):
			var v : Array<Dynamic> = v;
			var stride = 0;
			for( i in 0...len ) {
				stride = fillRec(v[i], t, out, pos);
				// align
				stride += (4 - (stride & 3)) & 3;
				pos += stride;
			}
			return len * stride;
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
	
	function getParamValue( p : hxsl.Cache.AllocParam, shaders : Array<hxsl.Shader> ) : Dynamic {
		if( p.perObjectGlobal != null )
			return globals.fastGet(p.perObjectGlobal.gid);
		return shaders[p.instance].getParamValue(p.index);
	}
	
	function allocBuffer( s : hxsl.Cache.CompleteShader, shaders : Array<hxsl.Shader> ) {
		var buf = new hxsl.Cache.ShaderBuffers(s);
		for( g in s.globals )
			fillRec(globals.fastGet(g.gid), g.type, buf.globals, g.pos);
		for( p in s.params ) {
			var v = getParamValue(p, shaders);
			fillRec(v, p.type, buf.params, p.pos);
		}
		var tid = 0;
		for( p in s.textures ) {
			var t = getParamValue(p, shaders);
			if( t == null ) t = h3d.mat.Texture.fromColor(0xFFFF00FF);
			buf.tex[tid++] = t;
		}
		return buf;
	}
	
	@:access(hxsl.Shader)
	public function compileShader( p : Pass ) {
		var shaders = p.getShadersRec();
		var instances = [for( s in shaders ) { s.updateConstants(globals); s.instance; }];
		var shader = shaderCache.link(instances, output);
		return shader;
	}
	
	@:access(h3d.scene.Object)
	@:access(h3d.Engine.driver)
	public function draw( ctx : h3d.scene.RenderContext, passes : Object ) {
		this.ctx = ctx;
		setGlobals();
		var p = passes;
		while( p != null ) {
			var shaders = p.pass.getShadersRec();
			var shader = compileShader(p.pass);
			// TODO : sort passes by shader/textures
			globalModelView.set(globals, p.obj.absPos);
			// TODO : reuse buffers between calls
			var vbuf = allocBuffer(shader.vertex, shaders);
			var fbuf = allocBuffer(shader.fragment, shaders);
			ctx.engine.driver.selectShader(shader.vertex, shader.fragment);
			ctx.engine.driver.selectMaterial(p.pass);
			ctx.engine.driver.uploadShaderBuffers(vbuf, fbuf, Globals);
			ctx.engine.driver.uploadShaderBuffers(vbuf, fbuf, Params);
			ctx.engine.driver.uploadShaderBuffers(vbuf, fbuf, Textures);
			p.obj.draw(ctx);
			p = p.next;
		}
		this.ctx = null;
	}
	
}