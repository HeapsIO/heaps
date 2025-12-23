package h3d.pass;

class OutputShader {

	var shaderCache : hxsl.Cache;
	var currentOutput : hxsl.ShaderList;

	public function new(?output:Array<hxsl.Output>) {
		shaderCache = hxsl.Cache.get();
		currentOutput = new hxsl.ShaderList(null);
		setOutput(output);
	}

	public function setOutput( ?output : Array<hxsl.Output>, ?vertexOutputName ) {
		if( output == null ) output = [Value("output.color")];
		currentOutput.s = shaderCache.getLinkShader(output,vertexOutputName);
	}

	public function compileShaders( globals : hxsl.Globals, shaders : hxsl.ShaderList, mode : hxsl.RuntimeShader.LinkMode = Default ) {
		globals.resetChannels();
		for( s in shaders ) s.updateConstants(globals);
		currentOutput.next = shaders;
		var s = shaderCache.link(currentOutput, mode);
		currentOutput.next = null;
		return s;
	}

}
