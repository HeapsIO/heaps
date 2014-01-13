package h2d;

class RenderContext {
	
	public var engine : h3d.Engine;
	public var time : Float;
	public var elapsedTime : Float;
	public var frame : Int;

	public var buffer : hxd.FloatBuffer;
	public var bufPos : Int;
	
	var texture : h3d.mat.Texture;
	var baseShader : h3d.shader.Base2d;
	var manager : h3d.shader.Manager;
	var compiledShader : hxsl.RuntimeShader;
	var buffers : h3d.shader.Buffers;
	var pass : h3d.pass.Pass;
	var currentShaders : Array<hxsl.Shader>;
	var stride : Int;
	var blendMode : BlendMode;
	
	public function new() {
		frame = 0;
		time = 0.;
		elapsedTime = 1. / hxd.Stage.getInstance().getFrameRate();
		buffer = new hxd.FloatBuffer();
		bufPos = 0;
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
		pass = new h3d.pass.Pass("",[]);
		pass.depth(true, Always);
		pass.culling = None;
		baseShader = new h3d.shader.Base2d();
		baseShader.zValue = 0.;
	}
	
	public function begin() {
		texture = null;
		bufPos = 0;
		stride = 0;
		if( compiledShader == null )
			initShaders([baseShader]);
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
	}
	
	public function end() {
		flush();
		texture = null;
	}
	
	public function flush() {
		if( bufPos == 0 ) return;
		baseShader.texture = texture;
		switch( blendMode ) {
		case Normal:
			pass.blend(SrcAlpha, OneMinusSrcAlpha);
		case None:
			pass.blend(One, Zero);
		case Add:
			pass.blend(SrcAlpha, One);
		case SoftAdd:
			pass.blend(OneMinusDstColor, One);
		case Multiply:
			pass.blend(DstColor, OneMinusSrcAlpha);
		case Erase:
			pass.blend(Zero, OneMinusSrcAlpha);
		}
		manager.fillParams(buffers, compiledShader, currentShaders);
		@:privateAccess {
			engine.driver.selectMaterial(pass);
			engine.driver.uploadShaderBuffers(buffers, Params);
			engine.driver.uploadShaderBuffers(buffers, Textures);
		}
		var nverts = Std.int(bufPos / stride);
		var tmp = engine.mem.alloc(nverts, stride, 4);
		tmp.uploadVector(buffer, 0, nverts);
		engine.renderQuadBuffer(tmp);
		tmp.dispose();
		bufPos = 0;
		texture = null;
	}
	
	public function beginDraw( texture : h3d.mat.Texture, stride : Int, blendMode : BlendMode, shaders : Array<hxsl.Shader> ) {
		if( texture != this.texture || stride != this.stride || blendMode != this.blendMode )
			flush();
		var shaderChanged = false, paramsChanged = false;
		if( shaders.length + 1 != currentShaders.length )
			shaderChanged = true;
		else {
			for( i in 0...shaders.length ) {
				var s = shaders[i];
				var t = currentShaders[i + 1];
				if( s == t ) continue;
				paramsChanged = true;
				s.updateConstants(manager.globals);
				@:privateAccess {
					if( s.instance != t.instance )
						shaderChanged = true;
				}
			}
		}
		if( shaderChanged ) {
			flush();
			var ns = shaders.copy();
			ns.unshift(baseShader);
			initShaders(ns);
		} else if( paramsChanged ) {
			flush();
			// copy so the next flush will fetch their params
			for( i in 0...shaders.length )
				currentShaders[i+1] = shaders[i];
		}
			
		this.texture = texture;
		this.stride = stride;
		this.blendMode = blendMode;
	}

}