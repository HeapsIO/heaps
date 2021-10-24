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

	var ctx : VkContext;
	var currentShader : CompiledShader;
	var programs : Map<Int,CompiledShader> = new Map();
	var defaultInput : VkPipelineInputAssembly;
	var defaultViewport : VkPipelineViewport;
	var defaultMultisample : VkPipelineMultisample;
	var defaultLayout : VkPipelineLayout;
	var currentImage : VkImage;
	var savedPointers : Array<Dynamic> = [];

	public function new() {
		var win = hxd.Window.getInstance();
		ctx = @:privateAccess win.window.vkctx;
		currentImage = ctx.setCurrent();
		initViewport(win.width, win.height);
		if( !ctx.beginFrame() ) throw "assert";
		defaultInput = new VkPipelineInputAssembly();
		defaultInput.topology = TRIANGLE_LIST;
		defaultMultisample = new VkPipelineMultisample();
		defaultMultisample.rasterizationSamples = 1;

		var bind0 = new VkDescriptorSetLayoutBinding();
		bind0.binding = 0;
		bind0.descriptorType = UNIFORM_BUFFER;
		bind0.descriptorCount = 1;
		bind0.stageFlags.set(VERTEX_BIT);
		bind0.stageFlags.set(FRAGMENT_BIT);

		var bind1 = new VkDescriptorSetLayoutBinding();
		bind1.binding = 1;
		bind1.descriptorType = UNIFORM_BUFFER;
		bind1.descriptorCount = 1;
		bind1.stageFlags.set(VERTEX_BIT);
		bind1.stageFlags.set(FRAGMENT_BIT);

		var dset = new VkDescriptorSetLayoutInfo();
		dset.bindingCount = 2;
		dset.bindings = makeArray([bind0,bind1]);

		var inf = new VkPipelineLayoutInfo();
		inf.setLayoutCount = 1;
		inf.setLayouts = makeArray([ctx.createDescriptorSetLayout(dset)]);
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
		currentImage = ctx.setCurrent();
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

	@:generic inline function makeArray<T>( a : Array<T>, keepInMemory=true ) {
		var n = new hl.NativeArray<T>(a.length);
		for( i in 0...a.length ) {
			n[i] = a[i];
			if( keepInMemory ) savedPointers.push(a[i]);
		}
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

		// **** TODO !! *** check for usage of input variable in shader output binary
		var attribs = [], position = 0;
		var names = [];
		for( v in shader.vertex.data.vars )
			if( v.kind == Input ) {
				names.push(v.name);
				var a = new VkVertexInputAttributeDescription();
				a.location = attribs.length;
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
	}

	override function clear(?color:Vector, ?depth:Float, ?stencil:Int) {
		if( color != null )
			currentImage.clearColor(color.r, color.g, color.b, color.a);
		if( depth != null || stencil != null ) {
			if( depth == null || stencil == null ) throw "Can't clear depth without clearing stencil";
			// *** TODO *** setup depth buffer
			// currentImage.clearDepthStencil(depth, stencil);
		}
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

		var colorAttach = new VkAttachmentDescription();
		colorAttach.format = B8G8R8A8_UNORM;
		colorAttach.samples = 1;
		colorAttach.loadOp = CLEAR;
		colorAttach.storeOp = STORE;
		colorAttach.stencilLoadOp = DONT_CARE;
		colorAttach.stencilStoreOp = DONT_CARE;
		colorAttach.initialLayout = UNDEFINED;
		colorAttach.finalLayout = PRESENT_SRC_KHR;

		var colorAttachRef = new VkAttachmentReference();
		colorAttachRef.attachment = 0;
		colorAttachRef.layout = COLOR_ATTACHMENT_OPTIMAL;

		var subPass = new VkSubpassDescription();
		subPass.pipelineBindPoint = GRAPHICS;
		subPass.colorAttachmentCount = 1;
		subPass.colorAttachments = makeArray([colorAttachRef]);

		var renderPass = new VkRenderPassInfo();
		renderPass.attachmentCount = 1;
		renderPass.attachments = makeArray([colorAttach]);
		renderPass.subpassCount = 1;
		renderPass.subpasses = makeArray([subPass]);
		inf.renderPass = ctx.createRenderPass(renderPass);

		var pipe = ctx.createGraphicsPipeline(inf);
		if( pipe == null ) throw "Failed to create pipeline";
		Vulkan.bindPipeline(GRAPHICS, pipe);
	}

	override function draw(ibuf:IndexBuffer, startIndex:Int, ntriangles:Int) {
		Vulkan.drawIndexed(ntriangles * 3, 1, startIndex, 0, 0);
		Sys.exit(0);
	}

	override function drawInstanced(ibuf:IndexBuffer, commands:InstanceBuffer) {
		throw "TODO";
	}

	static var CULLING : Array<VkCullModeFlags> = [NONE, BACK, FRONT, FRONT_AND_BACK];
	static var COMPARE : Array<VkCompareOp> = [ALWAYS, NEVER, EQUAL, NOT_EQUAL, GREATER, GREATER_OR_EQUAL, LESS, LESS_OR_EQUAL];

}

#end
