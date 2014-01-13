package h2d;

class RenderContext {
	
	public var engine : h3d.Engine;
	public var time : Float;
	public var elapsedTime : Float;
	public var frame : Int;

	public var buffer : hxd.FloatBuffer;
	public var bufPos : Int;
	
	var texture : h3d.mat.Texture;
	var shader : h3d.shader.Base2d;
	var manager : h3d.shader.Manager;
	var compiledShader : hxsl.RuntimeShader;
	var buffers : h3d.shader.Buffers;
	var pass : h3d.pass.Pass;
	var currentShaders : Array<hxsl.Shader>;
	var stride : Int;
	
	public function new() {
		frame = 0;
		time = 0.;
		elapsedTime = 1. / hxd.Stage.getInstance().getFrameRate();
		buffer = new hxd.FloatBuffer();
		bufPos = 0;
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
	}
	
	public function begin() {
		texture = null;
		bufPos = 0;
		stride = 0;
		if( shader == null ) {
			shader = new h3d.shader.Base2d();
			shader.zValue = 0.;
			initShaders([shader]);
		}
		@:privateAccess {
			engine.driver.selectShader(compiledShader);
			engine.driver.selectMaterial(pass);
			engine.driver.uploadShaderBuffers(buffers, Globals);
		}
	}
	
	function initShaders( shaders ) {
		currentShaders = shaders;
		compiledShader = manager.compileShaders(shaders);
		buffers = new h3d.shader.Buffers(compiledShader);
		manager.fillGlobals(buffers, compiledShader);
		pass = new h3d.pass.Pass("",[]);
		pass.blend(SrcAlpha, OneMinusSrcAlpha);
		pass.depth(true, Always);
		pass.culling = None;
	}
	
	public function end() {
		flush();
		texture = null;
	}
	
	public function flush() {
		if( bufPos == 0 ) return;
		shader.texture = texture;
		manager.fillParams(buffers, compiledShader, currentShaders);
		@:privateAccess engine.driver.uploadShaderBuffers(buffers, Params);
		var nverts = Std.int(bufPos / stride);
		var tmp = engine.mem.alloc(nverts, stride, 4);
		tmp.uploadVector(buffer, 0, nverts);
		engine.renderQuadBuffer(tmp);
		tmp.dispose();
		bufPos = 0;
		texture = null;
		trace(nverts);
		trace(buffer);
	}
	
	public function beginDraw( texture : h3d.mat.Texture, stride : Int ) {
		if( texture != this.texture || stride != this.stride )
			flush();
		this.texture = texture;
		this.stride = stride;
	}

}