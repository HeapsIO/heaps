package h3d.impl;
#if (hlsdl && heaps_vulkan)
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

class VulkanDriver extends Driver {

	var ctx : VkContext;
	var currentShader : CompiledShader;
	var programs : Map<Int,CompiledShader> = new Map();
	var defaultInput : VkPipelineInputAssembly;
	var defaultViewport : VkPipelineViewport;
	var defaultMultisample : VkPipelineMultisample;
	var defaultLayout : VkPipelineLayout;
	var defaultRenderPass : VkRenderPass;
	var currentImage : VkImage;
	var command : VkCommandBuffer;
	var savedPointers : Array<Dynamic> = [];
	var frameBuffers : Array<{ img : VkImage, fb : VkFramebuffer }> = [];
	var currentFramebuffer : VkFramebuffer;
	var memReq = new VkMemoryRequirements();
	var allocInfo = new VkMemoryAllocateInfo();
	var rangeAll : VkImageSubResourceRange;
	var viewportWidth : Int;
	var viewportHeight : Int;

	public function new() {
		var win = hxd.Window.getInstance();
		ctx = @:privateAccess win.window.vkctx;

		rangeAll = new VkImageSubResourceRange();
		rangeAll.aspectMask.set(COLOR);
		rangeAll.levelCount = -1;
		rangeAll.layerCount = -1;

		var colorAttach = new VkAttachmentDescription();
		colorAttach.format = B8G8R8A8_UNORM;
		colorAttach.samples = 1;
		colorAttach.loadOp = LOAD;
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
		subPass.colorAttachments = makeRef(colorAttachRef);

        var dep = new VkSubpassDependency();
		dep.srcSubpass = -1;
        dep.srcStageMask.set(COLOR_ATTACHMENT_OUTPUT);
        dep.dstStageMask.set(COLOR_ATTACHMENT_OUTPUT);
        dep.dstAccessMask.set(COLOR_ATTACHMENT_WRITE);

		var renderPass = new VkRenderPassInfo();
		renderPass.attachmentCount = 1;
		renderPass.attachments = makeRef(colorAttach);
		renderPass.subpassCount = 1;
		renderPass.subpasses = makeRef(subPass);
		renderPass.dependencyCount = 1;
		renderPass.dependencies = makeRef(dep);
		defaultRenderPass = ctx.createRenderPass(renderPass);

		if( !ctx.beginFrame() ) throw "assert";
		initViewport(win.width, win.height);
		beginFrame();
		defaultInput = new VkPipelineInputAssembly();
		defaultInput.topology = TRIANGLE_LIST;
		defaultMultisample = new VkPipelineMultisample();
		defaultMultisample.rasterizationSamples = 1;
/*
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
*/
		var dset = new VkDescriptorSetLayoutInfo();
		dset.bindingCount = 0;

		var inf = new VkPipelineLayoutInfo();
		inf.setLayoutCount = 1;
		inf.setLayouts = makeArray([ctx.createDescriptorSetLayout(dset)]); // abstract
		defaultLayout = ctx.createPipelineLayout(inf);
	}

	function beginFrame() {
		currentImage = ctx.getCurrentImage();
		command = ctx.getCurrentCommandBuffer();
		var fb = null;
		for( f in frameBuffers ) {
			if( f.img == currentImage ) {
				fb = f.fb;
				break;
			}
		}
		if( fb == null ) {
			var viewInfo = new VkImageViewInfo();
			viewInfo.image = currentImage;
			viewInfo.viewType = TYPE_2D;
			viewInfo.format = ctx.getCurrentImageFormat();
			viewInfo.layerCount = 1;
			viewInfo.levelCount = 1;
			viewInfo.aspectMask.set(COLOR);

			var view = ctx.createImageView(viewInfo);

			var framebuffer = new VkFramebufferInfo();
			framebuffer.renderPass = defaultRenderPass;
			framebuffer.attachmentCount = 1;
			framebuffer.width = viewportWidth;
			framebuffer.height = viewportHeight;
			framebuffer.layers = 1;
			framebuffer.attachments = makeArray([view]); // abstract

			fb = ctx.createFramebuffer(framebuffer);
			if( fb == null ) throw "Failed to create framebuffer";
			frameBuffers.push({ img : currentImage, fb : fb });
		}
		currentFramebuffer = fb;

		var begin = new VkRenderPassBeginInfo();
		begin.renderPass = defaultRenderPass;
		begin.framebuffer = currentFramebuffer;
		begin.renderAreaExtentX = viewportWidth;
		begin.renderAreaExtentY = viewportHeight;
		begin.clearValueCount = 0;
		command.beginRenderPass(begin,INLINE);
	}

	function initViewport(width:Int,height:Int) {
		var vp = new VkPipelineViewport();

		var vdef = new VkViewport();
		vdef.width = width;
		vdef.height = height;
		vdef.maxDepth = 1;
		vp.viewportCount = 1;
		vp.viewports = makeRef(vdef);

		var sdef = new VkRect2D();
		sdef.extendX = width;
		sdef.extendY = height;
		vp.scissorCount = 1;
		vp.scissors = makeRef(sdef);

		defaultViewport = vp;
		viewportWidth = width;
		viewportHeight = height;
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
		command.endRenderPass();
		ctx.endFrame();
		if( !ctx.beginFrame() )
			throw "assert:resize";
		beginFrame();
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

	@:generic inline function makeRef<T>( v : T ) : ArrayStruct<T> {
		return Vulkan.makeRef(v);
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
		c.stages = makeArray([makeStage(c.vertex,VERTEX), makeStage(c.fragment,FRAGMENT)]);

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
			b.stride = 24;//position * 4;
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
		if( color != null ) {
			var clear = new VkClearAttachment();
			clear.aspectMask.set(COLOR);
			clear.r = color.r;
			clear.g = color.g;
			clear.b = color.b;
			clear.a = color.a;
			var rect = new VkClearRect();
			rect.extendX = viewportWidth;
			rect.extendY = viewportHeight;
			rect.layerCount = 1;
			command.clearAttachments(1, makeRef(clear), 1, makeRef(rect));
		}
		if( depth != null || stencil != null ) {
			if( depth == null || stencil == null ) throw "Can't clear depth without clearing stencil";
			// *** TODO *** setup depth buffer
			// command.clearDepthStencilImage(currentImage, depth, stencil);
		}
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		return cast {};
	}

	function allocBuffer( type, size, stride ) {
		var inf = new VkBufferCreateInfo();
		inf.usage.set(TRANSFER_DST);
		inf.usage.set(type);
		inf.size = size * stride;
		var buf = ctx.createBuffer(inf);
		if( buf == null )
			return null;
		ctx.getBufferMemoryRequirements(buf, memReq);
		allocInfo.size = memReq.size;
		var properties = new haxe.EnumFlags<VkMemoryPropertyFlag>();
		properties.set(HOST_VISIBLE);
		properties.set(HOST_COHERENT);
		allocInfo.memoryTypeIndex = ctx.findMemoryType(memReq.memoryTypeBits, properties);
		var mem = ctx.allocateMemory(allocInfo);
		if( !ctx.bindBufferMemory(buf, mem, 0) )
			throw "assert";
		return { buf : buf, mem : mem, stride : stride };
	}

	override function selectBuffer( v : h3d.Buffer ) {
		var arr = makeArray([@:privateAccess v.buffer.vbuf.buf], false);
		command.bindVertexBuffers(0, 1, arr, null);
	}

	override function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
		var arr = [], offsets = [];
		while( buffers != null ) {
			arr.push(@:privateAccess buffers.buffer.buffer.vbuf.buf);
			offsets.push(new VkDeviceSize(buffers.offset * 4));
			buffers = buffers.next;
		}
		var count = arr.length;
		var arr = makeArray(arr, false);
		var offsets = makeArray(offsets, false);
		command.bindVertexBuffers(0, count, arr, offsets);
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		return allocBuffer(INDEX_BUFFER, count, is32?8:2);
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		return allocBuffer(VERTEX_BUFFER, m.size, m.stride * 4);
	}

	function updateBuffer( mem : VkDeviceMemory, bytes : hl.Bytes, offset : Int, size : Int ) {
		var ptr = ctx.mapMemory(mem, offset, size, 0);
		if( ptr == null ) throw "Failed to map buffer";
		ptr.blit(0, bytes, 0, size);
		ctx.unmapMemory(mem);
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		updateBuffer(i.mem, hl.Bytes.getArray(buf.getNative()).offset(bufPos * i.stride), startIndice * i.stride, indiceCount * i.stride);
	}

	override function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		updateBuffer(i.mem, @:privateAccess buf.b.offset(bufPos * i.stride), startIndice * i.stride, indiceCount * i.stride);
	}

	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		updateBuffer(v.mem, hl.Bytes.getArray(buf.getNative()).offset(bufPos<<2), startVertex * v.stride, vertexCount * v.stride);
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		updateBuffer(v.mem, @:privateAccess buf.b.offset(bufPos << 2), startVertex * v.stride, vertexCount * v.stride);
	}

	override function selectMaterial( pass : h3d.mat.Pass ) {
		var inf = new VkGraphicsPipelineInfo();

		inf.stageCount = 2;
		inf.stages = currentShader.stages;
		inf.vertexInput = currentShader.input;
		inf.inputAssembly = defaultInput;
		inf.viewport = defaultViewport;

		var raster = new VkPipelineRasterization();
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

		var colorAttach = new VkPipelineColorBlendAttachmentState();
		colorAttach.colorWriteMask = 15;
		colorAttach.blendEnable = false;

		var blend = new VkPipelineColorBlend();
		blend.attachmentCount = 1;
		blend.logicOp = COPY;
		blend.attachmentCount = 1;
		blend.attachments = makeRef(colorAttach);

		inf.colorBlend = blend;
		inf.layout = defaultLayout;
		inf.renderPass = defaultRenderPass;

		var pipe = ctx.createGraphicsPipeline(inf);
		if( pipe == null ) throw "Failed to create pipeline";

		command.bindPipeline(GRAPHICS, pipe);
	}

	override function draw(ibuf:IndexBuffer, startIndex:Int, ntriangles:Int) {
		command.bindIndexBuffer(ibuf.buf, 0, ibuf.stride==8?1:0);
		command.drawIndexed(ntriangles * 3, 1, startIndex, 0, 0);
	}

	override function drawInstanced(ibuf:IndexBuffer, commands:InstanceBuffer) {
		throw "TODO";
	}

	static var CULLING : Array<VkCullModeFlags> = [NONE, BACK, FRONT, FRONT_AND_BACK];
	static var COMPARE : Array<VkCompareOp> = [ALWAYS, NEVER, EQUAL, NOT_EQUAL, GREATER, GREATER_OR_EQUAL, LESS, LESS_OR_EQUAL];

}

#end
