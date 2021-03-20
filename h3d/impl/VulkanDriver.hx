package h3d.impl;
import h3d.impl.Driver;
import sdl.Vulkan;

class CompiledShader {
	public var shader : hxsl.RuntimeShader;
	public var vertex : VkShaderModule;
	public var fragment : VkShaderModule;
	public var stages : ArrayStruct<VkPipelineShaderStage>;
	public var input : VkPipelineVertexInput;
	public var inputID : InputNames;
	public function new(shader) {
		this.shader = shader;
	}
}

#if (hlsdl && heaps_vulkan)

class VulkanDriver extends Driver {

	var ctx : VKContext;
	var currentShader : CompiledShader;
	var programs : Map<Int,CompiledShader> = new Map();
	var defaultInput : VkPipelineInputAssembly;
	var defaultViewport : VkPipelineViewport;
	var defaultMultisample : VkPipelineMultisample;
	var defaultLayout : VkPipelineLayout;

	public function new() {
		var win = hxd.Window.getInstance();
		ctx = @:privateAccess win.window.vkctx;
		ctx.setCurrent();
		initViewport(win.width, win.height);
		if( !ctx.beginFrame() ) throw "assert";
		defaultInput = new VkPipelineInputAssembly();
		defaultInput.topology = TRIANGLE_LIST;
		defaultMultisample = new VkPipelineMultisample();
		defaultMultisample.rasterizationSamples = 1;

		var inf = new VkPipelineLayoutInfo();
		defaultLayout = ctx.createPipelineLayout(inf);
	}

	function initViewport(width:Int,height:Int) {
		var vp = new VkPipelineViewport();

		var vdef = new VkViewport();
		vdef.width = width;
		vdef.height = height;
		vdef.maxDepth = 1;
		vp.viewportCount = 1;
		vp.viewports = makeArray([vdef]);

		var sdef = new VkRect2D();
		sdef.extendX = width;
		sdef.extendY = height;
		vp.scissorCount = 1;
		vp.scissors = makeArray([sdef]);

		defaultViewport = vp;
	}

	override function hasFeature( f : Feature ) {
		return true;
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return true;
	}

	override function logImpl(str:String) {
		#if sys
		Sys.println(str);
		#else
		trace(str);
		#end
	}

	override function isDisposed() {
		return false;
	}

	override function getDriverName( details : Bool ) {
		return "Vulkan";
	}

	override function present() {
		ctx.endFrame();
		if( !ctx.beginFrame() ) {
			var win = hxd.Window.getInstance();
			if( !ctx.initSwapchain(win.width, win.height) )
				throw "assert";
			initViewport(win.width, win.height);
			if( !ctx.beginFrame() )
				throw "assert";
		}
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		onCreate(false);
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		if( currentShader != null && currentShader.shader == shader )
			return false;
		var p = programs.get(shader.id);
		if( p == null ) {
			p = compileShader(shader);
			programs.set(shader.id, p);
		}
		currentShader = p;
		return true;
	}

	static var STAGE_NAME = @:privateAccess "main".toUtf8();

	function compile( shader : hxsl.RuntimeShader.RuntimeShaderData ) {
		var out = new hxsl.GlslOut();
		out.version = 450;
		out.isVulkan = true;
		var source = out.run(shader.data);
		var bytes = sdl.Vulkan.compileShader(source, "", "main", shader.vertex ? Vertex : Fragment);
		var mod = ctx.createShaderModule(bytes, bytes.length);
		if( mod == null ) throw "assert";
		return mod;
	}

	/**
		/!\ Warning : this function converts an array of struct pointers into a single
		block aligned struct array. All references inside this block are not scanned so
		it's important to keep any pointer that is referenced by this data
	**/
	@:generic static inline function makeArray<T>( a : Array<T> ) {
		var n = new hl.NativeArray<T>(a.length);
		for( i in 0...a.length )
			n[i] = a[i];
		return Vulkan.makeArray(n);
	}

	function compileShader( shader : hxsl.RuntimeShader ) {
		var c = new CompiledShader(shader);
		c.vertex = compile(shader.vertex);
		c.fragment = compile(shader.fragment);
		inline function makeStage(module,t) {
			var stage = new VkPipelineShaderStage();
			stage.module = module;
			stage.name = STAGE_NAME;
			stage.stage.set(t);
			return stage;
		}
		c.stages = makeArray([makeStage(c.vertex,VERTEX_BIT), makeStage(c.fragment,FRAGMENT_BIT)]);

		var attribs = [], position = 0;
		var names = [];
		for( v in shader.vertex.data.vars )
			if( v.kind == Input ) {
				names.push(v.name);
				var a = new VkVertexInputAttributeDescription();
				a.binding = attribs.length;
				a.offset = position;
				a.format = switch( v.type ) {
				case TFloat: position++; R32_SFLOAT;
				case TVec(2, t): position += 2; R32G32_SFLOAT;
				case TVec(3, t): position += 3; R32G32B32_SFLOAT;
				case TVec(4, t): position += 4; R32G32B32A32_SFLOAT;
				default: throw "assert";
				}
				attribs.push(a);
			}

		var vin = new VkPipelineVertexInput();
		vin.vertexAttributeDescriptionCount = attribs.length;
		vin.vertexAttributeDescriptions = makeArray(attribs);
		var bindings = [for( i in 0...attribs.length ) {
			var b = new VkVertexInputBindingDescription();
			b.binding = i;
			b.inputRate = VERTEX;
			b.stride = position;
			b;
		}];
		vin.vertexBindingDescriptionCount = bindings.length;
		vin.vertexBindingDescriptions = makeArray(bindings);

		c.input = vin;
		c.inputID = InputNames.get(names);

		return c;
	}

	override function getShaderInputNames() : InputNames {
		return currentShader.inputID;
	}

	override function begin(frame:Int) {
		sdl.Vulkan.clearColorImage(0, 0.5, 0, 1);
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		return cast {};
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		return cast {};
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		return cast {};
	}

	override function selectMaterial( pass : h3d.mat.Pass ) {
		var inf = new VkGraphicsPipelineInfo();

		inf.stageCount = 2;
		inf.stages = currentShader.stages;
		inf.vertexInput = currentShader.input;
		inf.inputAssembly = defaultInput;
		inf.viewport = defaultViewport;

		var raster = new VkPipelineRasterization();
		raster.rasterizerDiscardEnable = true;
		raster.polygonMode = pass.wireframe	? LINE : FILL;
		raster.cullMode = CULLING[pass.culling.getIndex()];
		raster.lineWidth = 1;
		inf.rasterization = raster;

		inf.multisample = defaultMultisample;

		var stencil = new VkPipelineDepthStencil();
		stencil.depthTestEnable = pass.depthTest != Always;
		stencil.depthWriteEnable = pass.depthWrite;
		stencil.depthCompareOp = COMPARE[pass.depthTest.getIndex()];
		inf.depthStencil = stencil;

		var blend = new VkPipelineColorBlend();
		inf.colorBlend = blend;


		inf.layout = defaultLayout;
		//inf.renderPass = new VkRenderPass();

		var pipe = ctx.createGraphicsPipeline(inf);
		if( pipe == null ) throw "Failed to create pipeline";
	}

	static var CULLING : Array<VkCullModeFlags> = [NONE, BACK, FRONT, FRONT_AND_BACK];
	static var COMPARE : Array<VkCompareOp> = [ALWAYS, NEVER, EQUAL, NOT_EQUAL, GREATER, GREATER_OR_EQUAL, LESS, LESS_OR_EQUAL];

}

#end
