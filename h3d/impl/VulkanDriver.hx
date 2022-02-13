package h3d.impl;
#if (hlsdl && heaps_vulkan)
import h3d.impl.Driver;
import sdl.Vulkan;

class CompiledShaderData {
	public var vertex : Bool;
	public var module : VkShaderModule;
	public var pushConstantsOffset : Int;
	public var globalsOffset : Int;
	public function new() {
	}
}

class CompiledShader {
	public var shader : hxsl.RuntimeShader;
	public var vertex : CompiledShaderData;
	public var fragment : CompiledShaderData;
	public var stages : ArrayStruct<VkPipelineShaderStage>;
	public var input : VkPipelineVertexInput;
	public var inputID : InputNames;
	public var layout : VkPipelineLayout;
	public var samplerSets : hl.NativeArray<VkDescriptorSet>;
	public function new(shader) {
		this.shader = shader;
	}
}

class VulkanFrame {
	public var command : VkCommandBuffer;
	public var fence : VkFence;
	public var submit : VkSubmitInfo;
	public var imageAvailable : VkSemaphore;
	public var renderFinished : VkSemaphore;
	public function new() {
	}
}

class VulkanDriver extends Driver {

	var ctx : VkContext;
	var currentShader : CompiledShader;
	var programs : Map<Int,CompiledShader> = new Map();
	var command : VkCommandBuffer;
	var commandPool : VkCommandPool;
	var samplerPool : VkDescriptorPool;
	var savedPointers : Array<Dynamic> = [];

	var memReq = new VkMemoryRequirements();
	var allocInfo = new VkMemoryAllocateInfo();

	var rangeAll : VkImageSubResourceRange;
	var defaultViewport : VkPipelineViewport;
	var defaultRenderPass : VkRenderPass;

	var queueFamily : Int;
	var depthFormat : VkFormat;
	var outImageFormat : VkFormat;
	var outImages : Array<{ img : VkImage, framebuffer : VkFramebuffer, fence : VkFence }>;
	var viewportWidth : Int;
	var viewportHeight : Int;

	var frames : Array<VulkanFrame>;
	var currentImageIndex : Int;
	var currentFrameIndex : Int;
	var limits : VkPhysicalDeviceLimits;

	var defaultSampler : VkSampler; // TOREMOVE
	var frameCount = 2;

	public function new() {
		var win = hxd.Window.getInstance();
		initContext(@:privateAccess win.window.vkctx);
		initDefaults();
		initSwapchain(win.width, win.height);
		beginFrame();
	}

	function initContext(surface) {
		var queueFamily = 0;

		ctx = Vulkan.initContext(surface, queueFamily);
		if( ctx == null ) throw "Failed to init context";
		this.queueFamily = queueFamily;
		this.depthFormat = D24_UNORM_S8_UINT;

		var poolInf = new VkCommandPoolCreateInfo();
		poolInf.flags.set(RESET_COMMAND_BUFFER);
		poolInf.queueFamilyIndex = queueFamily;
		commandPool = ctx.createCommandPool(poolInf);


		var inf = new VkSamplerCreateInfo();
		defaultSampler = ctx.createSampler(inf);

		frames = [];
		for( i in 0...frameCount ) {
			var frame = new VulkanFrame();
			var inf = new VkCommandBufferAllocateInfo();
			inf.commandPool = commandPool;
			inf.commandBufferCount = 1;

			var arr = new hl.NativeArray(1);
			if( !ctx.allocateCommandBuffers(inf,arr) )
				throw "assert";
			frame.command = arr[0];

			var inf = new VkFenceCreateInfo();
			inf.flags.set(SIGNALED);
			frame.fence = ctx.createFence(inf);

			var inf = new VkSemaphoreCreateInfo();
			frame.imageAvailable = ctx.createSemaphore(inf);
			frame.renderFinished = ctx.createSemaphore(inf);

			var submit = new VkSubmitInfo();
			submit.waitSemaphoreCount = 1;
			submit.pWaitSemaphores = makeArray([frame.imageAvailable]);
			var flags = new haxe.EnumFlags<VkPipelineStageFlag>();
			flags.set(COLOR_ATTACHMENT_OUTPUT);
			submit.pWaitDstStageMask = makeArray([flags]);
			submit.commandBufferCount = 1;
			submit.pCommandBuffers = makeArray([frame.command]);
			submit.signalSemaphoreCount = 1;
			submit.pSignalSemaphores = makeArray([frame.renderFinished]);
			frame.submit = submit;

			frames.push(frame);
		}

		limits = ctx.getLimits();
	}

	function initSwapchain( width : Int, height : Int ) {
		var images = new hl.NativeArray(2);
		var format : VkFormat = UNDEFINED;
		if( !ctx.initSwapchain(width, height, images, format) )
			throw "Failed to init swapchain";

		outImageFormat = format;
		outImages = [];
		for( img in images ) {

			var inf = new VkImageCreateInfo();
			inf.imageType = TYPE_2D;
			inf.width = width;
			inf.height = height;
			inf.depth = 1;
			inf.arrayLayers = 1;
			inf.mipLevels = 1;
			inf.tiling = OPTIMAL;
			inf.samples = 1;
			inf.format = depthFormat;
			inf.usage.set(DEPTH_STENCIL_ATTACHMENT);

			var depth = ctx.createImage(inf);
			ctx.getImageMemoryRequirements(depth,memReq);
			var properties = new haxe.EnumFlags<VkMemoryPropertyFlag>();
			properties.set(DEVICE_LOCAL);
			var mem = allocMemory(properties);
			if( !ctx.bindImageMemory(depth, mem, 0) )
				throw "assert";

			var viewInfo = new VkImageViewCreateInfo();
			viewInfo.image = img;
			viewInfo.viewType = TYPE_2D;
			viewInfo.format = format;
			viewInfo.layerCount = 1;
			viewInfo.levelCount = 1;
			viewInfo.aspectMask.set(COLOR);

			var view = ctx.createImageView(viewInfo);

			var viewInfo = new VkImageViewCreateInfo();
			viewInfo.image = depth;
			viewInfo.viewType = TYPE_2D;
			viewInfo.format = depthFormat;
			viewInfo.layerCount = 1;
			viewInfo.levelCount = 1;
			viewInfo.aspectMask.set(DEPTH);
			var depthView = ctx.createImageView(viewInfo);

			var framebuffer = new VkFramebufferCreateInfo();
			framebuffer.renderPass = defaultRenderPass;
			framebuffer.width = width;
			framebuffer.height = height;
			framebuffer.layers = 1;
			framebuffer.attachmentCount = 2;
			framebuffer.attachments = makeArray([view,depthView]); // abstract

			var fb = ctx.createFramebuffer(framebuffer);
			outImages.push({ img : img, framebuffer : fb, fence : null });
		}

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

	function initDefaults() {
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

		var depthAttach = new VkAttachmentDescription();
		depthAttach.format = depthFormat;
		depthAttach.samples = 1;
		depthAttach.loadOp = LOAD;
		depthAttach.storeOp = STORE;
		depthAttach.stencilLoadOp = LOAD;
		depthAttach.stencilStoreOp = STORE;
		depthAttach.initialLayout = UNDEFINED;
		depthAttach.finalLayout = DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

		var colorAttachRef = new VkAttachmentReference();
		colorAttachRef.attachment = 0;
		colorAttachRef.layout = COLOR_ATTACHMENT_OPTIMAL;

		var depthAttachRef = new VkAttachmentReference();
		depthAttachRef.attachment = 1;
		depthAttachRef.layout = DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

		var subPass = new VkSubpassDescription();
		subPass.pipelineBindPoint = GRAPHICS;
		subPass.colorAttachmentCount = 1;
		subPass.colorAttachments = makeRef(colorAttachRef);
		subPass.depthStencilAttachment = makeRef(depthAttachRef);

        var dep = new VkSubpassDependency();
		dep.srcSubpass = -1;
        dep.srcStageMask.set(COLOR_ATTACHMENT_OUTPUT);
        dep.srcStageMask.set(EARLY_FRAGMENT_TESTS);
        dep.dstStageMask.set(COLOR_ATTACHMENT_OUTPUT);
        dep.dstStageMask.set(EARLY_FRAGMENT_TESTS);
        dep.dstAccessMask.set(COLOR_ATTACHMENT_WRITE);
		dep.dstAccessMask.set(DEPTH_STENCIL_ATTACHMENT_WRITE);

		var renderPass = new VkRenderPassCreateInfo();
		renderPass.attachmentCount = 2;
		renderPass.attachments = makeArray([colorAttach,depthAttach]);
		renderPass.subpassCount = 1;
		renderPass.subpasses = makeRef(subPass);
		renderPass.dependencyCount = 1;
		renderPass.dependencies = makeRef(dep);
		defaultRenderPass = ctx.createRenderPass(renderPass);
	}

	function beginFrame() {
		var frame = frames[currentFrameIndex];
		ctx.waitForFence(frame.fence, -1);
		currentImageIndex = ctx.getNextImageIndex(frame.imageAvailable);
		if( currentImageIndex < 0 )
			throw "assert";
		var img = outImages[currentImageIndex];
		if( img.fence != null )
			ctx.waitForFence(img.fence, -1);
		img.fence = frame.fence;
		ctx.resetFence(frame.fence);

		var inf = new VkCommandBufferBeginInfo();
		inf.flags.set(ONE_TIME_SUBMIT);
		command = frame.command;
		command.begin(inf);

		var begin = new VkRenderPassBeginInfo();
		begin.renderPass = defaultRenderPass;
		begin.framebuffer = outImages[currentImageIndex].framebuffer;
		begin.renderAreaExtentX = viewportWidth;
		begin.renderAreaExtentY = viewportHeight;

		command.beginRenderPass(begin,INLINE);
	}

	function endFrame() {
		command.endRenderPass();
		command.end();
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
		endFrame();
		submit();
		beginFrame();
	}

	function submit() {
		var frame = frames[currentFrameIndex];
		ctx.queueSubmit(frame.submit, frame.fence);
		ctx.present(frame.renderFinished, currentImageIndex);
		currentFrameIndex++;
		currentFrameIndex %= frames.length;
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

	function compile( shader : hxsl.RuntimeShader.RuntimeShaderData, padding : Int ) {
		var out = new hxsl.GlslOut();
		out.version = 450;
		out.isVulkan = true;
		@:privateAccess out.vulkanParametersPadding = padding;
		var source = out.run(shader.data);
		var bytes = sdl.Vulkan.compileShader(source, "", "main", shader.vertex ? Vertex : Fragment);
		var mod = ctx.createShaderModule(bytes, bytes.length);
		if( mod == null ) throw "assert";
		var sh = new CompiledShaderData();
		sh.vertex = shader.vertex;
		sh.module = mod;
		return sh;
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
		c.vertex = compile(shader.vertex, 0);
		c.fragment = compile(shader.fragment, shader.vertex.globalsSize + shader.vertex.paramsSize);
		inline function makeStage(module,t) {
			var stage = new VkPipelineShaderStage();
			stage.module = module;
			stage.name = STAGE_NAME;
			stage.stage.set(t);
			return stage;
		}
		c.stages = makeArray([makeStage(c.vertex.module,VERTEX), makeStage(c.fragment.module,FRAGMENT)]);

		// **** TODO !! *** check for usage of input variable in shader output binary
		var attribs = [], position = 0;
		var names = [];
		for( v in shader.vertex.data.vars )
			if( v.kind == Input ) {
				names.push(v.name);
				var a = new VkVertexInputAttributeDescription();
				a.binding = 0;
				a.location = attribs.length;
				a.offset = position * 4;
				a.format = switch( v.type ) {
				case TFloat: position++; R32_SFLOAT;
				case TVec(2, t): position += 2; R32G32_SFLOAT;
				case TVec(3, t): position += 3; R32G32B32_SFLOAT;
				case TVec(4, t): position += 4; R32G32B32A32_SFLOAT;
				default: throw "assert";
				}
				attribs.push(a);
			}

		var bind = new VkVertexInputBindingDescription();
		bind.binding = 0;
		bind.inputRate = VERTEX;
		bind.stride = position * 4;

		var vin = new VkPipelineVertexInput();
		vin.vertexAttributeDescriptionCount = attribs.length;
		vin.vertexAttributeDescriptions = makeArray(attribs);
		vin.vertexBindingDescriptionCount = 1;
		vin.vertexBindingDescriptions = makeRef(bind);

		c.input = vin;
		c.inputID = InputNames.get(names);


		var vconsts = new VkPushConstantRange();
		vconsts.stageFlags.set(VERTEX);
		vconsts.size = (shader.vertex.globalsSize + shader.vertex.paramsSize) * 16;

		var fconsts = new VkPushConstantRange();
		fconsts.stageFlags.set(FRAGMENT);
		fconsts.offset = vconsts.size;
		fconsts.size = (shader.fragment.globalsSize + shader.fragment.paramsSize) * 16;
		c.fragment.pushConstantsOffset = vconsts.size;

		c.vertex.globalsOffset = shader.vertex.globalsSize * 16;
		c.fragment.globalsOffset = shader.fragment.globalsSize * 16;

		var bindings = [], sets = [];
		for( i in 0...shader.vertex.texturesCount ) {
			var s = new VkDescriptorSetLayoutBinding();
			s.binding = i;
			s.descriptorCount = 1;
			s.descriptorType = COMBINED_IMAGE_SAMPLER;
			s.stageFlags.set(VERTEX);
			bindings.push(s);
		}
		for( i in 0...shader.fragment.texturesCount ) {
			var s = new VkDescriptorSetLayoutBinding();
			s.binding = i;
			s.descriptorCount = 1;
			s.descriptorType = COMBINED_IMAGE_SAMPLER;
			s.stageFlags.set(FRAGMENT);
			bindings.push(s);
		}
		if( bindings.length > 0 ) {
			var desc = new VkDescriptorSetLayoutCreateInfo();
			desc.bindingCount = bindings.length;
			desc.bindings = makeArray(bindings);
			var set = ctx.createDescriptorSetLayout(desc);
			c.samplerSets = allocateDescriptorSets(set);
			sets.push(set);
		}

		var inf = new VkPipelineLayoutCreateInfo();
		inf.pushConstantRangeCount = 2;
		inf.pushConstantRanges = makeArray([vconsts,fconsts]);
		inf.setLayoutCount = sets.length;
		inf.setLayouts = sets.length == 0 ? null : makeArray(sets);
		c.layout = ctx.createPipelineLayout(inf);


		return c;
	}

	function allocateDescriptorSets( set : VkDescriptorSetLayout ) {
		if( samplerPool == null ) {
			var poolSize = new VkDescriptorPoolSize();
			poolSize.descriptorCount = frameCount;
			poolSize.type = COMBINED_IMAGE_SAMPLER;
			var poolInf = new VkDescriptorPoolCreateInfo();
			poolInf.poolSizeCount = 1;
			poolInf.pPoolSizes = makeArray([poolSize]);
			poolInf.maxSets = 4096;
			poolInf.flags.set(UPDATE_AFTER_BIND);
			samplerPool = ctx.createDescriptorPool(poolInf);
			if( samplerPool == null )
				throw "assert";
		}
		var sets = new hl.NativeArray(frameCount);
		var inf = new VkDescriptorSetAllocateInfo();
		inf.descriptorPool = samplerPool;
		inf.descriptorSetCount = frameCount;
		inf.pSetLayouts = makeArray([for( i in 0...frameCount ) set]);
		if( !ctx.allocateDescriptorSets(inf, sets) )
			throw "assert";
		return sets;
	}

	override function getShaderInputNames() : InputNames {
		return currentShader.inputID;
	}

	override function begin(frame:Int) {
	}

	var tmpClearAttach = new VkClearAttachment();
	var tmpClearRect = new VkClearRect();

	override function clear(?color:Vector, ?depth:Float, ?stencil:Int) {
		var clear = tmpClearAttach;
		var rect = tmpClearRect;
		if( color != null ) {
			clear.colorAttachment = 0;
			clear.aspectMask = new haxe.EnumFlags();
			clear.aspectMask.set(COLOR);
			clear.r = color.r;
			clear.g = color.g;
			clear.b = color.b;
			clear.a = color.a;
			rect.extendX = viewportWidth;
			rect.extendY = viewportHeight;
			rect.layerCount = 1;
			command.clearAttachments(1, makeRef(clear), 1, makeRef(rect));
		}
		if( depth != null || stencil != null ) {
			if( depth == null || stencil == null ) throw "Can't clear depth without clearing stencil";
			clear.colorAttachment = 1;
			clear.aspectMask = new haxe.EnumFlags();
			clear.aspectMask.set(DEPTH);
			clear.aspectMask.set(STENCIL);
			clear.depth = (depth:Float);
			clear.stencil = stencil;
			rect.extendX = viewportWidth;
			rect.extendY = viewportHeight;
			rect.layerCount = 1;
			command.clearAttachments(1, makeRef(clear), 1, makeRef(rect));
		}
	}

	function allocMemory( properties : haxe.EnumFlags<VkMemoryPropertyFlag> ) {
		allocInfo.size = memReq.size;
		allocInfo.memoryTypeIndex = ctx.findMemoryType(memReq.memoryTypeBits, properties);
		if( allocInfo.memoryTypeIndex < 0 )
			throw "Could not find matching memory type";
		return ctx.allocateMemory(allocInfo);
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		var inf = new VkImageCreateInfo();
		inf.imageType = TYPE_2D;
		inf.width = t.width;
		inf.height = t.height;
		inf.depth = 1;
		inf.arrayLayers = t.layerCount;
		inf.mipLevels = t.mipLevels;
		inf.tiling = OPTIMAL;
		inf.samples = 1;
		inf.format = switch( t.format ) {
			case BGRA: B8G8R8A8_UNORM;
			case RGBA: R8G8B8A8_UNORM;
			case RGBA16F: R16G16B16A16_SFLOAT;
			case RGBA32F: R32G32B32A32_SFLOAT;
			case R8: R8_UNORM;
			case R16F: R16_SFLOAT;
			case R32F: R32_SFLOAT;
			case RG8: R8G8_UNORM;
			case RG16F: R16G16_SFLOAT;
			case RG32F: R32G32_SFLOAT;
			case RGB8: R8G8_UNORM;
			case RGB16F: R16G16B16_SFLOAT;
			case RGB32F: R32G32B32_SFLOAT;
			case SRGB: R8G8B8_SRGB;
			case SRGB_ALPHA: R8G8B8A8_SRGB;
			case RGB10A2: A2R10G10B10_UNORM_PACK32;
			case R16U: R16_UINT;
			case RGB16U: R16G16B16_UINT;
			case RGBA16U: R16G16B16A16_UINT;
			case S3TC(v):
				switch( v ) {
				case 1: BC1_RGBA_UNORM_BLOCK;
				case 2: BC2_UNORM_BLOCK;
				case 3: BC3_UNORM_BLOCK;
				case 4: BC4_UNORM_BLOCK;
				case 5: BC5_UNORM_BLOCK;
				case 6: BC6H_UFLOAT_BLOCK;
				case 7: BC7_UNORM_BLOCK;
				default: throw "Unsupported texture format "+t.format;
				}
			default: throw "Unsupported texture format " + t.format;
		};
		inf.usage.set(SAMPLED);
		inf.usage.set(TRANSFER_DST);

		var img = ctx.createImage(inf);
		if( img == null )
			throw "Failed to created texture";

		ctx.getImageMemoryRequirements(img,memReq);
		var properties = new haxe.EnumFlags<VkMemoryPropertyFlag>();
		properties.set(DEVICE_LOCAL);
		var mem = allocMemory(properties);
		if( mem == null ) {
			ctx.destroyImage(img);
			return null;
		}

		if( !ctx.bindImageMemory(img, mem, 0) )
			throw "assert";

		var viewInfo = new VkImageViewCreateInfo();
		viewInfo.image = img;
		viewInfo.viewType = TYPE_2D;
		viewInfo.format = inf.format;
		viewInfo.layerCount = t.layerCount;
		viewInfo.levelCount = t.mipLevels;
		viewInfo.aspectMask.set(COLOR);

		var view = ctx.createImageView(viewInfo);
		if( view == null )
			throw "assert";

		return { img : img, view : view, mem : mem };
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, layer : Int ) {
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, layer);
		pixels.dispose();
	}

	override function uploadTexturePixels(t:h3d.mat.Texture, pixels:hxd.Pixels, mipLevel:Int, layer:Int) {
		var tmpBuf = allocBuffer(TRANSFER_SRC,pixels.dataSize,1);
		updateBuffer(tmpBuf.mem, (pixels.bytes:hl.Bytes).offset(pixels.offset), 0, pixels.dataSize);
		transitionImage(t, UNDEFINED, TRANSFER_DST_OPTIMAL, mipLevel, layer);
		var cmd = beginCommand();
		var region = new VkBufferImageCopy();
		region.aspectMask.set(COLOR);
		region.mipLevel = mipLevel;
		region.baseArrayLayer = layer;
		region.layerCount = 1;
		region.imageWidth = t.width >> mipLevel;
		region.imageHeight = t.height >> mipLevel;
		region.imageDepth = 1;
		if( region.imageWidth == 0 ) region.imageWidth = 1;
		if( region.imageHeight == 0 ) region.imageHeight = 1;
		cmd.copyBufferToImage(tmpBuf.buf,t.t.img,TRANSFER_DST_OPTIMAL,1,makeRef(region));
		endCommand(cmd);
		transitionImage(t, TRANSFER_DST_OPTIMAL, SHADER_READ_ONLY_OPTIMAL, mipLevel, layer);
		t.flags.set(WasCleared);
		ctx.destroyBuffer(tmpBuf.buf);
		ctx.freeMemory(tmpBuf.mem);
	}

	function beginCommand() : VkCommandBuffer {
		var allocInfo = new VkCommandBufferAllocateInfo();
        allocInfo.commandPool = commandPool;
        allocInfo.commandBufferCount = 1;
		var bufs = new hl.NativeArray(1);
		ctx.allocateCommandBuffers(allocInfo, bufs);
		var cmd = bufs[0];

        var beginInfo = new VkCommandBufferBeginInfo();
        beginInfo.flags.set(ONE_TIME_SUBMIT);
		cmd.begin(beginInfo);
		return cmd;
	}

	function endCommand( cmd : VkCommandBuffer ) {
		cmd.end();

        var submit = new VkSubmitInfo();
        submit.commandBufferCount = 1;
        submit.pCommandBuffers = makeArray([cmd]);
		ctx.queueSubmit(submit, null);
		ctx.queueWaitIdle();

		var buffers = new hl.NativeArray(1);
		buffers[0] = cmd;
        ctx.freeCommandBuffers(commandPool, buffers);
	}

	function transitionImage(t:h3d.mat.Texture, from, to, mipLevel, layer ) {
		var cmd = beginCommand();

		var b = new VkImageMemoryBarrier();
        b.oldLayout = from;
        b.newLayout = to;
        b.image = t.t.img;
        b.aspectMask.set(COLOR);
        b.baseMipLevel = mipLevel;
        b.levelCount = 1;
        b.baseArrayLayer = layer;
        b.layerCount = 1;

        var source = new haxe.EnumFlags<VkPipelineStageFlag>();
        var dest = new haxe.EnumFlags<VkPipelineStageFlag>();

		switch( [from,to] ) {
		case [UNDEFINED, TRANSFER_DST_OPTIMAL]:
            b.dstAccessMask.set(TRANSFER_WRITE);
            source.set(TOP_OF_PIPE);
            dest.set(TRANSFER);
		case [TRANSFER_DST_OPTIMAL, SHADER_READ_ONLY_OPTIMAL]:
            b.srcAccessMask.set(TRANSFER_WRITE);
            b.dstAccessMask.set(SHADER_READ);
            source.set(TRANSFER);
            dest.set(FRAGMENT_SHADER);
		default:
			throw "assert";
		}

		var flags = new haxe.EnumFlags<VkDependencyFlag>();
        cmd.pipelineBarrier(source, dest, flags, 0, null, 0, null, 1, makeRef(b));
		endCommand(cmd);
	}

	function allocBuffer( type, size, stride ) {
		var inf = new VkBufferCreateInfo();
		inf.usage.set(type);
		if( type != TRANSFER_SRC ) inf.usage.set(TRANSFER_DST);
		inf.size = size * stride;
		var buf = ctx.createBuffer(inf);
		if( buf == null )
			return null;
		ctx.getBufferMemoryRequirements(buf, memReq);
		var properties = new haxe.EnumFlags<VkMemoryPropertyFlag>();
		properties.set(HOST_VISIBLE);
		properties.set(HOST_COHERENT);
		var mem = allocMemory(properties);
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

		var defaultInput = new VkPipelineInputAssembly();
		defaultInput.topology = TRIANGLE_LIST;

		var inf = new VkGraphicsPipelineCreateInfo();

		inf.stageCount = 2;
		inf.stages = currentShader.stages;
		inf.vertexInput = currentShader.input;
		inf.inputAssembly = defaultInput;
		inf.viewport = defaultViewport;

		var raster = new VkPipelineRasterization();
		raster.polygonMode = pass.wireframe	? LINE : FILL;
		raster.cullMode = CULLING[pass.culling.getIndex()];
		raster.frontFace = CLOCKWISE;
		raster.lineWidth = 1;
		inf.rasterization = raster;

		var defaultMultisample = new VkPipelineMultisample();
		defaultMultisample.rasterizationSamples = 1;
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
		inf.layout = currentShader.layout;
		inf.renderPass = defaultRenderPass;

		var pipe = ctx.createGraphicsPipeline(inf);
		if( pipe == null ) throw "Failed to create pipeline";

		command.bindPipeline(GRAPHICS, pipe);
	}

	override function uploadShaderBuffers( buf : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		uploadBuffer(buf, currentShader.vertex, buf.vertex, which);
		uploadBuffer(buf, currentShader.fragment, buf.fragment, which);
	}

	function uploadBuffer( buffer : h3d.shader.Buffers, s : CompiledShaderData, buf : h3d.shader.Buffers.ShaderBuffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Globals:
			if( buf.globals.length > 0 ) {
				var flags = new haxe.EnumFlags<VkShaderStageFlag>();
				flags.set(s.vertex ? VERTEX : FRAGMENT);
				command.pushConstants(currentShader.layout, flags, s.pushConstantsOffset, buf.globals.length*4, hl.Bytes.getArray(buf.globals.toArray()));
			}
		case Params:
			if( buf.params.length > 0 ) {
				var flags = new haxe.EnumFlags<VkShaderStageFlag>();
				flags.set(s.vertex ? VERTEX : FRAGMENT);
				command.pushConstants(currentShader.layout, flags, s.pushConstantsOffset + s.globalsOffset, buf.params.length*4, hl.Bytes.getArray(buf.params.toArray()));
			}
		case Textures:
			if( buf.tex.length > 0 ) {
				var s = currentShader.samplerSets[currentFrameIndex];
				var imageInfo = new VkDescriptorImageInfo();
				imageInfo.imageView = buf.tex[0].t.view;
				imageInfo.sampler = defaultSampler;
				imageInfo.imageLayout = SHADER_READ_ONLY_OPTIMAL;
				var write = new VkWriteDescriptorSet();
				write.descriptorCount = 1;
				write.descriptorType = COMBINED_IMAGE_SAMPLER;
				write.dstSet = s;
				write.pImageInfo = makeArray([imageInfo]);
				ctx.updateDescriptorSets(1, makeArray([write]), 0, null);
				command.bindDescriptorSets(GRAPHICS, currentShader.layout, 0, 1, makeArray([s]), 0, null);
			}
		case Buffers:
		}
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
