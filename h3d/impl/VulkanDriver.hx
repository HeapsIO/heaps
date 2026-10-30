package h3d.impl;

#if hlvk

import h3d.impl.Driver;
import h3d.impl.PipelineCache.PipelineDynamicState;
import vk.Vk;

enum abstract ResState(Int) to Int {
	var UNDEFINED = 0;
	var COPY_SRC = 1;
	var COPY_DST = 2;
	var READ = 3;
	var SHADER_READ = 4;
	var UAV = 5;
	var RENDER_TARGET = 6;
	var DEPTH_WRITE = 7;
	var DEPTH_READ = 8;
	var PRESENT = 9;
	var TRANSFER_GENERAL = 10;
}

class ResourceData {
	public var state : ResState = UNDEFINED;
	public var pending : Int = -1;
	public var isImage = false;
	public function new() {
	}
}

class BufferData extends ResourceData {
	public var buffer : vk.Vk.Buffer;
	public var handle : NativeBuffer;
	public var size : Int;
	public var is32 : Bool;
	public var bindless : h3d.BufferHandle;
	public var uavEpoch = -1;
	public var stages = 0;
}

class TextureData extends ResourceData {
	public var image : vk.Vk.Image;
	public var handle : NativeImage;
	public var format : Format;
	public var aspect : Int;
	public var isDepth : Bool;
	public var hasStencil : Bool;
	public var srvViews : Map<Int, ImageView>;
	public var rtViews : Map<Int, ImageView>;
	public var uavViews : Map<Int, ImageView>;
	public var depthViews : Map<Int, ImageView>;
	public function new() {
		super();
		isImage = true;
	}
	public function disposeViews( out : Array<Garbage> ) {
		for( m in [srvViews, rtViews, uavViews, depthViews] )
			if( m != null )
				for( v in m )
					out.push(GView(v));
		srvViews = rtViews = uavViews = depthViews = null;
	}
}

class QueryData {
	public var pool : Int = -1;
	public var offset : Int;
	public var result : Float;
	public function new() {
	}
}

enum abstract BufferMemory(Int) {
	var GPU = 0;
	var UPLOAD = 1;
	var READBACK = 2;
}

enum Garbage {
	GBuffer( b : vk.Vk.Buffer );
	GImage( i : vk.Vk.Image );
	GView( v : ImageView );
}

class UploadBuffer {
	public var buffer : vk.Vk.Buffer;
	public var handle : NativeBuffer;
	public function new( size : Int ) {
		buffer = VulkanDriver.allocCheck(() -> VulkanDriver.createVkBuffer(size, BufferUsage.TRANSFER_SRC | BufferUsage.UNIFORM | BufferUsage.STORAGE | BufferUsage.VERTEX | BufferUsage.INDEX, UPLOAD));
		Vk.bufferSetName(buffer, "UploadPage");
		handle = Vk.bufferGetHandle(buffer);
	}
}

class AsyncRead {
	public var tmp : vk.Vk.Buffer;
	public var size : Int;
	public var buf : haxe.io.Bytes;
	public var bufPos : Int;
	public var callback : Void -> Void;
	public function new() {
	}
}

class VkFrame {
	public var pool : CommandPool;
	public var cmd : CommandBuffer;
	public var fence : Fence;
	public var acquireSem : Semaphore;
	public var submitted = false;
	public var toRelease : Array<Garbage> = [];
	public var allocator : LinearAllocator<UploadBuffer>;
	public var descPools : Array<DescriptorPool> = [];
	public var descPoolIndex = 0;
	public var queryPools : Array<QueryPool> = [];
	public var queriesPending : Array<QueryData> = [];
	public var queryPool = 0;
	public var queryOffset = 0;
	public var asyncReads : Array<AsyncRead> = [];
	public var bindlessSet : DescriptorSet;
	public var bindlessDirty : Array<Int> = [];
	public var texHandlesToRelease : Array<h3d.mat.TextureHandle> = [];
	public var bufHandlesToRelease : Array<h3d.BufferHandle> = [];
	public function new() {
	}
}

class StageRegs {
	public var globals = -1;
	public var params = -1;
	public var globalsDyn = -1;
	public var paramsDyn = -1;
	public var pushOffset = -1;
	public var pushSize = 0;
	public var pushStage = 0;
	public var buffers : Array<Int> = [];
	public var bufferTypes : Array<hxsl.Ast.BufferKind> = [];
	public var texTypes : Array<hxsl.Ast.Type> = [];
	public var texSlots : Array<Int> = [];
	public var samplerSlots : Array<Int> = [];
	public function new() {
	}
}

class CompiledShader {
	public var shader : hxsl.RuntimeShader;
	public var isCompute : Bool;
	public var vertexRegs : StageRegs;
	public var fragmentRegs : StageRegs;
	public var vs : ShaderModule;
	public var fs : ShaderModule;
	public var setLayout : DescriptorSetLayout;
	public var layout : PipelineLayout;
	public var computePipeline : Pipeline;
	public var pipelines : h3d.impl.PipelineCache<Pipeline> = new h3d.impl.PipelineCache();
	public var format : hxd.BufferFormat;
	public var inputCount : Int;
	public var inputDivisors : Array<Int>;
	public var usedInputs : Array<Bool>;
	public var writes : hl.CArray<WriteDescriptorSet>;
	public var imageInfos : hl.CArray<DescriptorImageInfo>;
	public var bufferInfos : hl.CArray<DescriptorBufferInfo>;
	public var writeCount : Int;
	public var bindless : Bool;
	public var dynCount : Int;
	public var dynOffsets : hl.Bytes;
	public var pushData : hl.Bytes;
	public var set : DescriptorSet;
	public var setGeneration = -1;
	public var dirty = true;
	public function new() {
	}
}

class BindlessIndices {
	var free : Array<Int> = [];
	var next = 0;
	var max : Int;
	var name : String;
	public function new( max : Int, name : String ) {
		this.max = max;
		this.name = name;
	}
	public function alloc() {
		if( free.length > 0 ) return free.pop();
		if( next == max ) throw 'Too many bindless $name : $max allowed (see VulkanDriver.BINDLESS_*_COUNT and the device update-after-bind limits)';
		return next++;
	}
	public function release( index : Int ) {
		free.push(index);
	}
}

class VulkanDriver extends h3d.impl.Driver {

	public static var BUFFER_COUNT = 2;
	/** requires VK_LAYER_KHRONOS_validation to be installed (Vulkan SDK) **/
	public static var DEBUG = false;
	public static var DEVICE_NAME : String = null;
	public static var DEFAULT_DEPTH_FORMAT : hxd.PixelFormat = Depth24Stencil8;
	public static var DEFAULT_DEPTH_VALUE = 1.0;
	public static var INITIAL_UPLOAD_SIZE = 4 << 20;
	public static var BINDLESS_TEXTURE_COUNT = 65536;
	public static var BINDLESS_SAMPLER_COUNT = 2048;
	public static var BINDLESS_BUFFER_COUNT = 16384;
	public static var BINDLESS_RESERVED_DESCRIPTORS = 256;
	static inline var QUERY_COUNT = 128;
	static inline var VK_API_VERSION_1_2 = (1 << 22) | (2 << 12);
	static inline var VK_API_VERSION_1_3 = (1 << 22) | (3 << 12);
	static var VK_1_3_EXTENSIONS = ["VK_KHR_synchronization2", "VK_KHR_dynamic_rendering", "VK_KHR_copy_commands2", "VK_EXT_extended_dynamic_state", "VK_EXT_extended_dynamic_state2"];
	static var VK_1_3_OPTIONAL_EXTENSIONS = ["VK_KHR_maintenance4", "VK_EXT_shader_demote_to_helper_invocation", "VK_KHR_shader_non_semantic_info"];

	// binding offsets of HLSL registers, per register class and per shader stage (see dxc -fvk-*-shift)
	static inline var BIND_B = 0;
	static inline var BIND_T = 100;
	static inline var BIND_S = 400;
	static inline var BIND_U = 500;
	static inline var BIND_FRAGMENT = 1000;
	static inline var BINDLESS_IMAGES = 0;
	static inline var BINDLESS_SAMPLERS = 1;
	static inline var BINDLESS_BUFFERS = 2;

	var physicalDevice : PhysicalDevice;
	var deviceProps = new PhysicalDeviceProperties2();
	var limits(get, never) : PhysicalDeviceLimits;
	inline function get_limits() return deviceProps.properties.limits;
	var queueFamily = 0;
	var timestampValidBits = 0;
	var enabledDeviceExtensions : Array<String> = [];
	var shaderArgs : Array<String>;
	var formatProps = new FormatProperties();
	var instanceExtensions : Array<String> = [];
	var deviceExtensions : Array<String> = [];
	var hasDeviceError = false;
	var onContextLost : Void -> Void;
	var frames : Array<VkFrame>;
	var frame : VkFrame;
	var frameIndex = 0;
	var frameCount = 0;
	var cmd : CommandBuffer;
	#if heaps_mt_hxsl_cache
	var compilers = new sys.thread.Tls<ShaderCompiler>();
	#else
	var compiler : ShaderCompiler;
	#end
	var uniformAlign : Int;
	var copyAlign : Int;
	var depthStencilFormat : Format;

	var swapchainCount = 0;
	var swapchainDirty = true;
	var swapchainVsync = false;
	var swapchainWidth = 0;
	var swapchainHeight = 0;
	var surfaceCaps = new SurfaceCaps();
	var swapchainInfo = new SwapchainCreateInfo();
	var swapchainImages : Array<NativeImage> = [];
	var surfaceQueryBuf = new hl.Bytes(64 * 8);
	var renderSemaphores : Array<Semaphore> = [];
	var currentWidth = 0;
	var currentHeight = 0;
	var backBuffer : h3d.mat.Texture;
	var defaultDepth : h3d.mat.Texture;
	var errorTex : h3d.mat.Texture;

	var renderingActive = false;
	var rtColorViews = new hl.NativeArray<ImageView>(8);
	var rtColorCount = 0;
	var rtColorTextures : Array<h3d.mat.Texture> = [];
	var rtDepthView : ImageView;
	var rtDepthLayout : ImageLayout = UNDEFINED;
	var rtHasStencil = false;
	var rtWidth = 1;
	var rtHeight = 1;
	var currentRenderTargets : Array<h3d.mat.Texture> = [];
	var viewportW = 1.;
	var viewportH = 1.;
	var scissorX = 0;
	var scissorY = 0;
	var scissorW = 1;
	var scissorH = 1;

	static inline var MAX_BARRIERS = 64;
	var imageBarriers : hl.CArray<ImageMemoryBarrier2>;
	var bufferBarriers : hl.CArray<BufferMemoryBarrier2>;
	var memoryBarriers : hl.CArray<MemoryBarrier2>;
	var imageBarrierRes : Array<ResourceData> = [];
	var bufferBarrierRes : Array<ResourceData> = [];
	var imageBarrierCount = 0;
	var bufferBarrierCount = 0;
	var needUAVBarrier = false;
	var uavBarrierEpoch = 0;
	var boundUAVBuffers : Array<BufferData> = [];
	var dependency = new DependencyInfo();
	var tmpImageBarriers : hl.CArray<ImageMemoryBarrier2>;
	var tmpMemoryBarriers : hl.CArray<MemoryBarrier2>;
	var tmpDependency = new DependencyInfo();

	var queue : Queue;
	var swapchain : Swapchain;
	var beginInfo = new CommandBufferBeginInfo();
	var renderingInfo = new RenderingInfo();
	var colorAttachments : hl.CArray<RenderingAttachmentInfo>;
	var depthAttachment = new RenderingAttachmentInfo();
	var stencilAttachment = new RenderingAttachmentInfo();
	var pendingColorClears = 0;
	var pendingDepthClears = 0;
	var clearAttachments : hl.CArray<ClearAttachment>;
	var clearRects : hl.CArray<ClearRect>;
	var viewports : hl.CArray<Viewport>;
	var scissors : hl.CArray<Rect2D>;
	var bufferCopy = new CopyBufferInfo2();
	var bufferImageCopy = new CopyBufferToImageInfo2();
	var imageBufferCopy = new CopyImageToBufferInfo2();
	var imageCopy = new CopyImageInfo2();
	var imageBlit = new BlitImageInfo2();
	var submits : hl.CArray<SubmitInfo2>;
	var cmdSubmits : hl.CArray<CommandBufferSubmitInfo>;
	var waitSubmits : hl.CArray<SemaphoreSubmitInfo>;
	var signalSubmits : hl.CArray<SemaphoreSubmitInfo>;
	var presentInfo = new PresentInfo();
	var presentWaits : hl.CArray<SemaphoreHandle>;
	var presentSwapchains : hl.CArray<SwapchainHandle>;
	var presentIndices = new hl.Bytes(4);

	var setLayoutInfo = new DescriptorSetLayoutCreateInfo();
	var pipelineLayoutInfo = new PipelineLayoutCreateInfo();
	var descriptorPoolInfo = new DescriptorPoolCreateInfo();
	var descriptorSetAlloc = new DescriptorSetAllocateInfo();
	var setLayouts : hl.CArray<DescriptorSetLayoutHandle>;
	var pipelineSetLayouts : hl.CArray<DescriptorSetLayoutHandle>;
	var descriptorSets : hl.CArray<DescriptorSetHandle>;
	var queryResultBytes = haxe.io.Bytes.alloc(8);

	var compiledShaders : Map<Int, CompiledShader> = [];
	var currentShader : CompiledShader;
	static var DYNAMIC_PIPELINE_STATES = getDynamicPipelineStates();
	var pipelineBuilder = new PipelineCache.PipelineBuilder(DYNAMIC_PIPELINE_STATES);
	var psoConfigCache : h3d.impl.PipelineCache.PipelineConfigCache;
	var pipelineCache : PipelineCache;
	var pipelineInfos : hl.CArray<GraphicsPipelineCreateInfo>;
	var pipelineStages : hl.CArray<PipelineShaderStageCreateInfo>;
	var vertexInputState = new PipelineVertexInputStateCreateInfo();
	var vertexBindings : hl.CArray<VertexInputBindingDescription>;
	var vertexAttributes : hl.CArray<VertexInputAttributeDescription>;
	var inputAssemblyState = new PipelineInputAssemblyStateCreateInfo();
	var viewportState = new PipelineViewportStateCreateInfo();
	var rasterizationState = new PipelineRasterizationStateCreateInfo();
	var multisampleState = new PipelineMultisampleStateCreateInfo();
	var depthStencilState = new PipelineDepthStencilStateCreateInfo();
	var colorBlendState = new PipelineColorBlendStateCreateInfo();
	var colorBlendAttachments : hl.CArray<PipelineColorBlendAttachmentState>;
	var dynamicState = new PipelineDynamicStateCreateInfo();
	var renderingState = new PipelineRenderingCreateInfo();
	var colorFormats = new hl.Bytes(8 * 4);
	var computeInfos : hl.CArray<ComputePipelineCreateInfo>;
	var createdPipelines : hl.CArray<PipelineHandle>;
	var createdComputePipelines : hl.CArray<PipelineHandle>;
	#if heaps_mt_hxsl_cache
	var compileMutex = new sys.thread.Mutex();
	var pipelineMutex = new sys.thread.Mutex();
	#end
	var shaderModuleInfo = new ShaderModuleCreateInfo();
	var currentPipeline : Pipeline;
	var needBind = true;
	var pushDirty = true;
	static inline var PUSH_HALF = 128;
	var descriptorGeneration = 0;
	var useDepthClamp = false;
	var curStencilRef = -1;
	var matPass = new h3d.mat.Pass("");
	var matStencil = new h3d.mat.Stencil();
	var matHasStencil = false;
	var matDepthBias = 0.;
	var matSlopeBias = 0.;
	var dynamicDirty = true;
	var curCull = -1;
	var curDepthTest = -1;
	var curDepthWrite = -1;
	var curDepthCompare = -1;
	var curBiasEnable = -1;
	var curDepthBias = 0.;
	var curSlopeBias = 0.;
	var curStencilTest = -1;
	var curStencilOps = -1;
	var curStencilMasks = -1;
	var currentIndex : h3d.Buffer;
	var vertexBuffers = hl.CArray.alloc(BufferHandle, 16);
	var vbOffsets = hl.CArray.alloc(DeviceSize, 16);
	var vbStrides = hl.CArray.alloc(DeviceSize, 16);

	var samplers : Map<Int, Sampler> = [];
	var blitFormats : Map<Int, Bool> = [];
	var imageInfo = new ImageCreateInfo();
	var imageAlloc = new AllocationCreateInfo();
	var viewInfo = new ImageViewCreateInfo();
	var samplerInfo = new SamplerCreateInfo();
	var memProperties = new hl.Bytes(MemoryReport.PROPERTIES_SIZE);
	var memBudgets = haxe.io.Bytes.alloc(MemoryReport.MAX_HEAPS * MemoryReport.BUDGET_STRIDE);

	var useBindless = false;
	var bindlessLayout : DescriptorSetLayout;
	var bindlessPool : DescriptorPool;
	var bindlessTextures : BindlessIndices;
	var bindlessSamplers : BindlessIndices;
	var bindlessBuffers : BindlessIndices;
	var bindlessViews : Array<ImageView> = [];
	var bindlessViewLayouts : Array<ImageLayout> = [];
	var bindlessSamplerValues : Array<Sampler> = [];
	var bindlessBufferValues : Array<NativeBuffer> = [];
	var bindlessWrite : hl.CArray<WriteDescriptorSet>;
	var bindlessImageInfo = new DescriptorImageInfo();
	var bindlessBufferInfo = new DescriptorBufferInfo();
	var textureHandles : Map<h3d.mat.Texture, Map<Int, h3d.mat.TextureHandle>> = [];
	var samplerHandles : Map<Int, Int> = [];

	public function new() {
		reset();
	}

	static function getDynamicPipelineStates() {
		var states = new haxe.EnumFlags<PipelineDynamicState>();
		for( s in [Culling, DepthTest, DepthWrite, DepthBias, Stencil] )
			states.set(s);
		return states;
	}

	static var bufferInfo = new BufferCreateInfo();
	static var bufferAlloc = new AllocationCreateInfo();

	@:allow(h3d.impl) static function createVkBuffer( size : Int, usage : Int, memory : BufferMemory ) : vk.Vk.Buffer {
		var b = bufferInfo;
		b.size = size;
		b.usage = usage;
		b.sharingMode = EXCLUSIVE;
		var a = bufferAlloc;
		switch( memory ) {
		case GPU:
			a.usage = AUTO_PREFER_DEVICE;
			a.flags = 0;
			a.requiredFlags = 0;
		case UPLOAD:
			a.usage = AUTO;
			a.flags = AllocationCreateFlags.HOST_ACCESS_SEQUENTIAL_WRITE | AllocationCreateFlags.MAPPED;
			a.requiredFlags = MemoryProperty.HOST_COHERENT;
		case READBACK:
			a.usage = AUTO;
			a.flags = AllocationCreateFlags.HOST_ACCESS_RANDOM | AllocationCreateFlags.MAPPED;
			a.requiredFlags = MemoryProperty.HOST_COHERENT;
		}
		var r = SUCCESS;
		var buf = Vk.bufferCreate(b, a, r);
		if( buf == null && !isOutOfMemory(r) )
			throw "vmaCreateBuffer failed (VkResult " + r + ")";
		return buf;
	}

	static inline function isOutOfMemory( r : Result ) {
		return r == ERROR_OUT_OF_DEVICE_MEMORY || r == ERROR_OUT_OF_HOST_MEMORY;
	}

	@:allow(h3d.impl) static function allocCheck<T>( f : Void -> T ) {
		var ret = f();
		if( ret == null ) {
			var mem = Engine.getCurrent()?.mem;
			if( mem == null ) throw "Out of GPU memory";
			mem.garbage();
			ret = f();
			if( ret == null ) mem.errorOutOfMemory();
		}
		return ret;
	}

	function reset() {
		upscaling.beforeCreateDevice();
		createInstance();
		createSurface();
		createDevice();
		upscaling.afterCreateDevice();
		upscaling.afterCreateQueue();
		if( limits.maxPushConstantsSize < PUSH_HALF << 1 )
			throw "Vulkan device supports only " + limits.maxPushConstantsSize + " bytes of push constants, " + (PUSH_HALF << 1) + " required";
		uniformAlign = hxd.Math.imax(limits.minUniformBufferOffsetAlignment.toInt(), 16);
		uniformAlign = hxd.Math.imax(uniformAlign, limits.minStorageBufferOffsetAlignment.toInt());
		copyAlign = hxd.Math.imax(limits.optimalBufferCopyOffsetAlignment.toInt(), 16);
		depthStencilFormat = (getFormatFeatures(D24_UNORM_S8_UINT) & FormatFeature.DEPTH_STENCIL_ATTACHMENT) != 0 ? D24_UNORM_S8_UINT : D32_SFLOAT_S8_UINT;

		Vk.getMemoryProperties(memProperties);
		frames = [];
		var r = SUCCESS;
		for( i in 0...BUFFER_COUNT ) {
			var f = new VkFrame();
			f.pool = Vk.commandPoolCreate(CommandPoolCreateFlags.TRANSIENT, queueFamily, r);
			checkResult(r, "vkCreateCommandPool");
			f.cmd = Vk.commandBufferCreate(f.pool, PRIMARY, r);
			checkResult(r, "vkAllocateCommandBuffers");
			f.fence = Vk.fenceCreate(0, r);
			checkResult(r, "vkCreateFence");
			f.acquireSem = createSemaphore();
			f.allocator = new LinearAllocator(INITIAL_UPLOAD_SIZE, (size) -> new UploadBuffer(size), (b) -> Vk.bufferGetMapped(b.buffer), (b) -> Vk.bufferDestroy(b.buffer), 64 << 20);
			frames.push(f);
		}
		frameIndex = BUFFER_COUNT - 1;
		initCommandStructs();
		initPipelineStructs();
		initBindless();
		psoConfigCache = h3d.impl.PipelineCache.PipelineConfigCache.get();
		psoConfigCache?.load(DYNAMIC_PIPELINE_STATES);

		errorTex = new h3d.mat.Texture(1, 1, [NoAlloc], RGBA);
		errorTex.t = allocTexture(errorTex);
		errorTex.name = "errorTex";
		errorTex.preventAutoDispose();

		var win = hxd.Window.getInstance();
		resize(win.width, win.height);
	}

	static inline var VALIDATION_LAYER = "VK_LAYER_KHRONOS_validation";
	static inline var RENDERDOC_LAYER = "VK_LAYER_RENDERDOC_Capture";

	function createInstance() {
		if( Vk.getInstanceVersion() < VK_API_VERSION_1_2 )
			throw "Vulkan 1.2 is not available";
		var available = Vk.getInstanceExtensions();
		var extensions = #if hlnx ["VK_KHR_surface", "VK_NN_vi_surface"] #elseif hlsdl sdl.Window.vkGetInstanceExtensions() #else ["VK_KHR_surface", "VK_KHR_win32_surface"] #end;
		if( extensions == null )
			throw "Vulkan surface extensions are not available";
		var debugUtils = available.indexOf("VK_EXT_debug_utils") >= 0;
		if( debugUtils )
			extensions.push("VK_EXT_debug_utils");
		for( e in instanceExtensions )
			if( extensions.indexOf(e) < 0 && available.indexOf(e) >= 0 )
				extensions.push(e);
		var layers = [];
		if( DEBUG ) {
			if( Vk.getInstanceLayers().indexOf(VALIDATION_LAYER) >= 0 )
				layers.push(VALIDATION_LAYER);
			else
				Sys.println("[Vulkan] " + VALIDATION_LAYER + " not found, validation disabled");
		}
		#if renderdoc
		if( Vk.getInstanceLayers().indexOf(RENDERDOC_LAYER) >= 0 )
			layers.push(RENDERDOC_LAYER);
		else
			Sys.println("[Vulkan] " + RENDERDOC_LAYER + " not found, capture disabled");
		#end

		var app = new ApplicationInfo();
		var name = @:privateAccess "Heaps".toUtf8();
		app.pApplicationName = name;
		app.pEngineName = name;
		app.apiVersion = VK_API_VERSION_1_3;
		var inf = new InstanceCreateInfo();
		inf.pApplicationInfo = app;
		var extNames = Vk.makeNames(extensions), layerNames = Vk.makeNames(layers);
		inf.enabledExtensionCount = extensions.length;
		inf.ppEnabledExtensionNames = extNames;
		inf.enabledLayerCount = layers.length;
		inf.ppEnabledLayerNames = layerNames;
		var r = Vk.instanceCreate(inf);
		if( r != SUCCESS )
			throw "Failed to create Vulkan instance (VkResult " + r + ")";
		if( debugUtils && layers.indexOf(VALIDATION_LAYER) >= 0 )
			Vk.debugMessengerCreate(DebugMessageSeverity.WARNING | DebugMessageSeverity.ERROR, DebugMessageType.GENERAL | DebugMessageType.VALIDATION | DebugMessageType.PERFORMANCE);
	}

	function findQueueFamily( pdev : PhysicalDevice ) {
		var count = 0;
		Vk.getPhysicalDeviceQueueFamilyProperties(pdev, count, null);
		var families = hl.CArray.alloc(QueueFamilyProperties, count == 0 ? 1 : count);
		Vk.getPhysicalDeviceQueueFamilyProperties(pdev, count, families);
		var need = QueueFlags.GRAPHICS | QueueFlags.COMPUTE;
		for( i in 0...count )
			if( families[i].queueFlags & need == need && Vk.getPhysicalDeviceSurfaceSupport(pdev, i) ) {
				timestampValidBits = families[i].timestampValidBits;
				return i;
			}
		return -1;
	}

	function selectPhysicalDevice() {
		var best = null, bestScore = -1, bestFamily = -1, bestBits = 0;
		var props = new PhysicalDeviceProperties2();
		var rejected = [];
		for( pdev in Vk.getPhysicalDevices() ) {
			Vk.getPhysicalDeviceProperties2(pdev, props);
			var p = props.properties;
			var name = p.deviceName.toString();
			var version = "Vulkan " + (p.apiVersion >>> 22) + "." + ((p.apiVersion >>> 12) & 0x3FF);
			if( p.apiVersion < VK_API_VERSION_1_2 ) {
				rejected.push(name + " (" + version + ")");
				continue;
			}
			if( p.apiVersion < VK_API_VERSION_1_3 ) {
				var available = Vk.getDeviceExtensions(pdev);
				var missing = [for( e in VK_1_3_EXTENSIONS ) if( available.indexOf(e) < 0 ) e];
				if( missing.length == 0 ) {
					var sync2 = new PhysicalDeviceSynchronization2Features();
					var dynRendering = new PhysicalDeviceDynamicRenderingFeatures();
					var dynState = new PhysicalDeviceExtendedDynamicStateFeaturesEXT();
					var dynState2 = new PhysicalDeviceExtendedDynamicState2FeaturesEXT();
					var sup = new PhysicalDeviceFeatures2();
					sup.pNext = VkConst.pointer(sync2);
					sync2.pNext = VkConst.pointer(dynRendering);
					dynRendering.pNext = VkConst.pointer(dynState);
					dynState.pNext = VkConst.pointer(dynState2);
					Vk.getPhysicalDeviceFeatures2(pdev, sup);
					if( sync2.synchronization2 == 0 ) missing.push("synchronization2");
					if( dynRendering.dynamicRendering == 0 ) missing.push("dynamicRendering");
					if( dynState.extendedDynamicState == 0 ) missing.push("extendedDynamicState");
					if( dynState2.extendedDynamicState2 == 0 ) missing.push("extendedDynamicState2");
				}
				if( missing.length > 0 ) {
					rejected.push(name + " (" + version + " without " + missing.join(", ") + ")");
					continue;
				}
			}
			var family = findQueueFamily(pdev);
			if( family < 0 ) {
				rejected.push(name + " (no graphics+compute queue presenting to the surface)");
				continue;
			}
			var score = switch( (cast p.deviceType : PhysicalDeviceType) ) {
			case DISCRETE_GPU: 3;
			case INTEGRATED_GPU: 2;
			default: 1;
			}
			if( DEVICE_NAME != null && name.indexOf(DEVICE_NAME) >= 0 ) score = 10;
			if( score > bestScore ) {
				best = pdev;
				bestScore = score;
				bestFamily = family;
				bestBits = timestampValidBits;
			}
		}
		if( best == null )
			throw "No suitable Vulkan device found" +(rejected.length > 0 ? ": " + rejected.join(", ") : "");
		physicalDevice = best;
		queueFamily = bestFamily;
		timestampValidBits = bestBits;
		Vk.getPhysicalDeviceProperties2(physicalDevice, deviceProps);
	}

	function createDevice() {
		selectPhysicalDevice();
		var available = Vk.getDeviceExtensions(physicalDevice);
		var core13 = deviceProps.properties.apiVersion >= VK_API_VERSION_1_3;
		shaderArgs = ["-spirv", "-fspv-target-env=" + (core13 ? "vulkan1.3" : "vulkan1.2")].concat(SHADER_ARGS);
		#if shader_debug_info
		if( !core13 && available.indexOf("VK_KHR_shader_non_semantic_info") < 0 )
			shaderArgs.remove("-fspv-debug=vulkan-with-source");
		#end

		var sup13 = new PhysicalDeviceVulkan13Features();
		var sup12 = new PhysicalDeviceVulkan12Features();
		var sup11 = new PhysicalDeviceVulkan11Features();
		var sup = new PhysicalDeviceFeatures2();
		var sync2 = new PhysicalDeviceSynchronization2Features();
		var dynRendering = new PhysicalDeviceDynamicRenderingFeatures();
		var dynState = new PhysicalDeviceExtendedDynamicStateFeaturesEXT();
		var dynState2 = new PhysicalDeviceExtendedDynamicState2FeaturesEXT();
		var maintenance4 = new PhysicalDeviceMaintenance4Features();
		var demote = new PhysicalDeviceShaderDemoteToHelperInvocationFeatures();
		var extensions = [];
		if( core13 )
			sup12.pNext = VkConst.pointer(sup13);
		else {
			for( e in VK_1_3_EXTENSIONS ) extensions.push(e);
			for( e in VK_1_3_OPTIONAL_EXTENSIONS ) if( available.indexOf(e) >= 0 ) extensions.push(e);
			sup12.pNext = VkConst.pointer(sync2);
			sync2.pNext = VkConst.pointer(dynRendering);
			dynRendering.pNext = VkConst.pointer(dynState);
			dynState.pNext = VkConst.pointer(dynState2);
			if( extensions.indexOf("VK_KHR_maintenance4") >= 0 ) {
				maintenance4.pNext = dynState2.pNext;
				dynState2.pNext = VkConst.pointer(maintenance4);
			}
			if( extensions.indexOf("VK_EXT_shader_demote_to_helper_invocation") >= 0 ) {
				demote.pNext = dynState2.pNext;
				dynState2.pNext = VkConst.pointer(demote);
			}
		}
		sup11.pNext = VkConst.pointer(sup12);
		sup.pNext = VkConst.pointer(sup11);
		Vk.getPhysicalDeviceFeatures2(physicalDevice, sup);
		if( !core13 ) {
			dynState2.extendedDynamicState2LogicOp = 0;
			dynState2.extendedDynamicState2PatchControlPoints = 0;
		} else if( sup13.dynamicRendering == 0 || sup13.synchronization2 == 0 )
			throw "Vulkan device does not support dynamic rendering and synchronization2";

		var f13 = new PhysicalDeviceVulkan13Features();
		var f12 = new PhysicalDeviceVulkan12Features();
		var f11 = new PhysicalDeviceVulkan11Features();
		var f = new PhysicalDeviceFeatures2();
		f12.pNext = core13 ? VkConst.pointer(f13) : sup12.pNext;
		f11.pNext = VkConst.pointer(f12);
		f.pNext = VkConst.pointer(f11);
		var c = f.features, s = sup.features;
		c.samplerAnisotropy = s.samplerAnisotropy;
		c.fillModeNonSolid = s.fillModeNonSolid;
		c.independentBlend = s.independentBlend;
		c.dualSrcBlend = s.dualSrcBlend;
		c.depthClamp = s.depthClamp;
		c.depthBiasClamp = s.depthBiasClamp;
		c.multiDrawIndirect = s.multiDrawIndirect;
		c.drawIndirectFirstInstance = s.drawIndirectFirstInstance;
		c.textureCompressionBC = s.textureCompressionBC;
		c.imageCubeArray = s.imageCubeArray;
		c.fragmentStoresAndAtomics = s.fragmentStoresAndAtomics;
		c.vertexPipelineStoresAndAtomics = s.vertexPipelineStoresAndAtomics;
		c.shaderStorageImageReadWithoutFormat = s.shaderStorageImageReadWithoutFormat;
		c.shaderStorageImageWriteWithoutFormat = s.shaderStorageImageWriteWithoutFormat;
		c.shaderSampledImageArrayDynamicIndexing = s.shaderSampledImageArrayDynamicIndexing;
		c.shaderStorageImageExtendedFormats = s.shaderStorageImageExtendedFormats;
		c.shaderImageGatherExtended = s.shaderImageGatherExtended;
		c.shaderInt16 = s.shaderInt16;
		f11.shaderDrawParameters = sup11.shaderDrawParameters;
		f12.drawIndirectCount = sup12.drawIndirectCount;
		f12.scalarBlockLayout = sup12.scalarBlockLayout;
		f12.uniformBufferStandardLayout = sup12.uniformBufferStandardLayout;
		f12.hostQueryReset = sup12.hostQueryReset;
		f12.shaderFloat16 = sup12.shaderFloat16;
		f12.shaderSampledImageArrayNonUniformIndexing = sup12.shaderSampledImageArrayNonUniformIndexing;
		f12.runtimeDescriptorArray = sup12.runtimeDescriptorArray;
		f12.separateDepthStencilLayouts = sup12.separateDepthStencilLayouts;
		useBindless = h3d.impl.Driver.requestedFeatures.has(Bindless) && sup12.runtimeDescriptorArray != 0
			&& sup12.shaderSampledImageArrayNonUniformIndexing != 0 && sup12.shaderStorageBufferArrayNonUniformIndexing != 0
			&& sup12.descriptorBindingPartiallyBound != 0 && sup12.descriptorBindingSampledImageUpdateAfterBind != 0
			&& sup12.descriptorBindingStorageBufferUpdateAfterBind != 0;
		if( useBindless ) {
			f12.shaderStorageBufferArrayNonUniformIndexing = 1;
			f12.descriptorBindingPartiallyBound = 1;
			f12.descriptorBindingSampledImageUpdateAfterBind = 1;
			f12.descriptorBindingStorageBufferUpdateAfterBind = 1;
		}
		if( core13 ) {
			f13.dynamicRendering = 1;
			f13.synchronization2 = 1;
			f13.maintenance4 = sup13.maintenance4;
			f13.shaderDemoteToHelperInvocation = sup13.shaderDemoteToHelperInvocation;
		}

		if( available.indexOf("VK_KHR_swapchain") < 0 )
			throw "Vulkan device does not support VK_KHR_swapchain";
		extensions.push("VK_KHR_swapchain");
		var memoryBudget = available.indexOf("VK_EXT_memory_budget") >= 0;
		if( memoryBudget ) extensions.push("VK_EXT_memory_budget");
		for( e in deviceExtensions )
			if( extensions.indexOf(e) < 0 && available.indexOf(e) >= 0 )
				extensions.push(e);
		enabledDeviceExtensions = extensions;

		var priorities = new hl.Bytes(4);
		priorities.setF32(0, 1);
		var queues = DeviceQueueCreateInfo.alloc(1);
		queues[0].queueFamilyIndex = queueFamily;
		queues[0].queueCount = 1;
		queues[0].pQueuePriorities = priorities;
		var inf = new DeviceCreateInfo();
		inf.pNext = VkConst.pointer(f);
		inf.queueCreateInfoCount = 1;
		inf.pQueueCreateInfos = queues;
		var names = Vk.makeNames(extensions);
		inf.enabledExtensionCount = extensions.length;
		inf.ppEnabledExtensionNames = names;
		var r = Vk.deviceCreate(physicalDevice, inf);
		if( r != SUCCESS )
			throw "Failed to create Vulkan device (VkResult " + r + ")";
		queue = Vk.getDeviceQueue(queueFamily, 0);
		r = Vk.allocatorCreate(memoryBudget ? AllocatorCreateFlags.EXT_MEMORY_BUDGET : 0, core13 ? VK_API_VERSION_1_3 : VK_API_VERSION_1_2);
		if( r != SUCCESS )
			throw "Failed to create the Vulkan memory allocator (VkResult " + r + ")";
	}

	function getFormatFeatures( format : Format ) {
		Vk.getPhysicalDeviceFormatProperties(physicalDevice, format, formatProps);
		return formatProps.optimalTilingFeatures;
	}

	function createSurface() {
		#if hlnx
		var w = 0, h = 0;
		nx.Display.getDefaultResolution(w, h);
		var window = nx.Display.createLayer(w, h);
		if( window == null || !Vk.surfaceCreateVi(window) )
			throw "Failed to create Vulkan surface";
		@:privateAccess {
			var win = hxd.Window.getInstance();
			win.windowWidth = w;
			win.windowHeight = h;
		}
		#elseif hlsdl
		var win = @:privateAccess hxd.Window.getInstance().window;
		var surface = win.vkCreateSurface(Vk.getInstance());
		if( surface == null )
			throw "Failed to create Vulkan surface: " + sdl.Sdl.getError();
		Vk.setSurface(surface);
		#else
		var win = @:privateAccess hxd.Window.getInstance().window;
		if( !Vk.surfaceCreateWin32(win) )
			throw "Failed to create Vulkan surface";
		#end
	}

	function initCommandStructs() {
		imageBarriers = ImageMemoryBarrier2.alloc(MAX_BARRIERS);
		bufferBarriers = BufferMemoryBarrier2.alloc(MAX_BARRIERS);
		memoryBarriers = MemoryBarrier2.alloc(1);
		for( i in 0...MAX_BARRIERS ) {
			var b = imageBarriers[i];
			b.srcQueueFamilyIndex = b.dstQueueFamilyIndex = VkConst.IGNORED;
			var b = bufferBarriers[i];
			b.srcQueueFamilyIndex = b.dstQueueFamilyIndex = VkConst.IGNORED;
			b.offset = 0;
			b.size = VkConst.WHOLE_SIZE;
		}
		dependency.pImageMemoryBarriers = imageBarriers;
		dependency.pBufferMemoryBarriers = bufferBarriers;
		dependency.pMemoryBarriers = memoryBarriers;
		tmpImageBarriers = ImageMemoryBarrier2.alloc(1);
		tmpImageBarriers[0].srcQueueFamilyIndex = tmpImageBarriers[0].dstQueueFamilyIndex = VkConst.IGNORED;
		tmpMemoryBarriers = MemoryBarrier2.alloc(1);
		tmpDependency.pImageMemoryBarriers = tmpImageBarriers;
		tmpDependency.pMemoryBarriers = tmpMemoryBarriers;

		beginInfo.flags = CommandBufferUsage.ONE_TIME_SUBMIT;

		colorAttachments = RenderingAttachmentInfo.alloc(8);
		renderingInfo.pColorAttachments = colorAttachments;
		renderingInfo.layerCount = 1;
		clearAttachments = hl.CArray.alloc(ClearAttachment, 1);
		clearRects = hl.CArray.alloc(ClearRect, 1);
		clearRects[0].layerCount = 1;
		viewports = hl.CArray.alloc(Viewport, 1);
		viewports[0].maxDepth = 1;
		scissors = hl.CArray.alloc(Rect2D, 1);

		bufferCopy.regionCount = 1;
		bufferCopy.pRegions = BufferCopy2.alloc(1);
		var regions = BufferImageCopy2.alloc(1);
		bufferImageCopy.regionCount = 1;
		bufferImageCopy.pRegions = regions;
		bufferImageCopy.dstImageLayout = TRANSFER_DST_OPTIMAL;
		imageBufferCopy.regionCount = 1;
		imageBufferCopy.pRegions = regions;
		imageBufferCopy.srcImageLayout = TRANSFER_SRC_OPTIMAL;
		imageCopy.regionCount = 1;
		imageCopy.pRegions = ImageCopy2.alloc(1);
		imageCopy.srcImageLayout = TRANSFER_SRC_OPTIMAL;
		imageCopy.dstImageLayout = TRANSFER_DST_OPTIMAL;
		imageBlit.regionCount = 1;
		imageBlit.pRegions = ImageBlit2.alloc(1);

		submits = SubmitInfo2.alloc(1);
		cmdSubmits = CommandBufferSubmitInfo.alloc(1);
		waitSubmits = SemaphoreSubmitInfo.alloc(1);
		signalSubmits = SemaphoreSubmitInfo.alloc(1);
		waitSubmits[0].stageMask = PipelineStage.ALL_COMMANDS;
		signalSubmits[0].stageMask = PipelineStage.ALL_COMMANDS;
		var s = submits[0];
		s.commandBufferInfoCount = 1;
		s.pCommandBufferInfos = cmdSubmits;
		s.pWaitSemaphoreInfos = waitSubmits;
		s.pSignalSemaphoreInfos = signalSubmits;

		presentWaits = hl.CArray.alloc(SemaphoreHandle, 1);
		presentSwapchains = hl.CArray.alloc(SwapchainHandle, 1);
		presentInfo.waitSemaphoreCount = 1;
		presentInfo.pWaitSemaphores = presentWaits;
		presentInfo.swapchainCount = 1;
		presentInfo.pSwapchains = presentSwapchains;
		presentInfo.pImageIndices = presentIndices;

		setLayouts = hl.CArray.alloc(DescriptorSetLayoutHandle, 1);
		pipelineSetLayouts = hl.CArray.alloc(DescriptorSetLayoutHandle, 2);
		descriptorSets = hl.CArray.alloc(DescriptorSetHandle, 2);
		pipelineLayoutInfo.setLayoutCount = 1;
		pipelineLayoutInfo.pSetLayouts = pipelineSetLayouts;
		descriptorSetAlloc.descriptorSetCount = 1;
		descriptorSetAlloc.pSetLayouts = setLayouts;
		var sizes : Array<DescriptorType> = [UNIFORM_BUFFER, UNIFORM_BUFFER_DYNAMIC, STORAGE_BUFFER, SAMPLED_IMAGE, SAMPLER, STORAGE_IMAGE];
		var counts = [2048, 4096, 1024, 8192, 8192, 512];
		var poolSizes = hl.CArray.alloc(DescriptorPoolSize, sizes.length);
		for( i in 0...sizes.length ) {
			poolSizes[i].type = sizes[i];
			poolSizes[i].descriptorCount = counts[i];
		}
		descriptorPoolInfo.maxSets = 1024;
		descriptorPoolInfo.poolSizeCount = sizes.length;
		descriptorPoolInfo.pPoolSizes = poolSizes;
	}

	function initBindless() {
		if( !useBindless ) return;
		var types : Array<DescriptorType> = [SAMPLED_IMAGE, SAMPLER, STORAGE_BUFFER];
		var counts = getBindlessCounts();
		var bindings = hl.CArray.alloc(DescriptorSetLayoutBinding, types.length);
		var poolSizes = hl.CArray.alloc(DescriptorPoolSize, types.length);
		var flags = new hl.Bytes(types.length << 2);
		for( i in 0...types.length ) {
			var b = bindings[i];
			b.binding = i;
			b.descriptorType = types[i];
			b.descriptorCount = counts[i];
			b.stageFlags = ShaderStage.ALL;
			flags.setI32(i << 2, DescriptorBindingFlags.PARTIALLY_BOUND | DescriptorBindingFlags.UPDATE_AFTER_BIND);
			poolSizes[i].type = types[i];
			poolSizes[i].descriptorCount = counts[i] * BUFFER_COUNT;
		}
		var bindingFlags = new DescriptorSetLayoutBindingFlagsCreateInfo();
		bindingFlags.bindingCount = types.length;
		bindingFlags.pBindingFlags = flags;
		var inf = new DescriptorSetLayoutCreateInfo();
		inf.pNext = VkConst.pointer(bindingFlags);
		inf.flags = DescriptorSetLayoutCreateFlags.UPDATE_AFTER_BIND_POOL;
		inf.bindingCount = types.length;
		inf.pBindings = bindings;
		var r = SUCCESS;
		bindlessLayout = Vk.descriptorSetLayoutCreate(inf, r);
		checkResult(r, "vkCreateDescriptorSetLayout");
		var pool = new DescriptorPoolCreateInfo();
		pool.flags = DescriptorPoolCreateFlags.UPDATE_AFTER_BIND;
		pool.maxSets = BUFFER_COUNT;
		pool.poolSizeCount = types.length;
		pool.pPoolSizes = poolSizes;
		bindlessPool = Vk.descriptorPoolCreate(pool, r);
		checkResult(r, "vkCreateDescriptorPool");
		var alloc = new DescriptorSetAllocateInfo();
		alloc.descriptorPool = bindlessPool;
		alloc.descriptorSetCount = 1;
		alloc.pSetLayouts = setLayouts;
		setLayouts[0].handle = bindlessLayout;
		for( f in frames ) {
			checkResult(Vk.allocateDescriptorSets(alloc, descriptorSets), "vkAllocateDescriptorSets");
			f.bindlessSet = descriptorSets[0].handle;
		}
		bindlessTextures = new BindlessIndices(counts[0], "textures");
		bindlessSamplers = new BindlessIndices(counts[1], "samplers");
		bindlessBuffers = new BindlessIndices(counts[2], "buffers");
		bindlessWrite = WriteDescriptorSet.alloc(1);
		var w = bindlessWrite[0];
		w.descriptorCount = 1;
		w.pImageInfo = bindlessImageInfo;
		w.pBufferInfo = bindlessBufferInfo;
		bindlessBufferInfo.range = VkConst.WHOLE_SIZE;
	}

	function getBindlessCounts() {
		var limits = new PhysicalDeviceDescriptorIndexingProperties();
		var props = new PhysicalDeviceProperties2();
		props.pNext = VkConst.pointer(limits);
		Vk.getPhysicalDeviceProperties2(physicalDevice, props);
		inline function ulimit( v : Int ) return v < 0 ? 0x7FFFFFFF : v;
		inline function clamp( count : Int, perStage : Int, perSet : Int ) return hxd.Math.imin(count, hxd.Math.imin(ulimit(perStage), ulimit(perSet)));
		var textures = clamp(BINDLESS_TEXTURE_COUNT, limits.maxPerStageDescriptorUpdateAfterBindSampledImages, limits.maxDescriptorSetUpdateAfterBindSampledImages);
		var samplers = clamp(BINDLESS_SAMPLER_COUNT, limits.maxPerStageDescriptorUpdateAfterBindSamplers, limits.maxDescriptorSetUpdateAfterBindSamplers);
		var buffers = clamp(BINDLESS_BUFFER_COUNT, limits.maxPerStageDescriptorUpdateAfterBindStorageBuffers, limits.maxDescriptorSetUpdateAfterBindStorageBuffers);
		var perStage = ulimit(limits.maxPerStageUpdateAfterBindResources) - BINDLESS_RESERVED_DESCRIPTORS;
		textures = hxd.Math.imin(textures, perStage - samplers - buffers);
		textures = hxd.Math.imin(textures, Std.int(ulimit(limits.maxUpdateAfterBindDescriptorsInAllPools) / BUFFER_COUNT) - samplers - buffers);
		if( textures <= 0 )
			throw "Vulkan device update-after-bind limits are too low for bindless (" + samplers + " samplers and " + buffers + " buffers leave no room for textures)";
		return [textures, samplers, buffers];
	}

	function writeBindless( binding : Int, index : Int ) {
		for( f in frames ) {
			if( f == frame && !f.submitted )
				applyBindless(f.bindlessSet, binding, index);
			else
				f.bindlessDirty.push((index << 2) | binding);
		}
	}

	function applyBindless( set : DescriptorSet, binding : Int, index : Int ) {
		var w = bindlessWrite[0];
		w.dstSet = set;
		w.dstBinding = binding;
		w.dstArrayElement = index;
		var img = bindlessImageInfo;
		if( binding == BINDLESS_IMAGES ) {
			w.descriptorType = SAMPLED_IMAGE;
			img.sampler = null;
			img.imageView = bindlessViews[index];
			img.imageLayout = bindlessViewLayouts[index];
		} else if( binding == BINDLESS_SAMPLERS ) {
			w.descriptorType = SAMPLER;
			img.sampler = bindlessSamplerValues[index];
			img.imageView = null;
		} else {
			w.descriptorType = STORAGE_BUFFER;
			bindlessBufferInfo.buffer = bindlessBufferValues[index];
		}
		Vk.updateDescriptorSets(1, bindlessWrite, 0, null);
	}

	function beginBindlessFrame() {
		for( h in frame.texHandlesToRelease )
			if( h.handle != -1 && h.texture.t == null ) {
				bindlessTextures.release(h.handle.low);
				h.handle = -1;
			}
		frame.texHandlesToRelease = [];
		for( h in frame.bufHandlesToRelease ) {
			bindlessBuffers.release(h.handle);
			h.handle = -1;
		}
		frame.bufHandlesToRelease = [];
		for( k in frame.bindlessDirty )
			applyBindless(frame.bindlessSet, k & 3, k >> 2);
		frame.bindlessDirty = [];
	}

	function writeBindlessTexture( t : h3d.mat.Texture, index : Int ) {
		bindlessViews[index] = getSRV(t);
		bindlessViewLayouts[index] = layoutOf(t.t, SHADER_READ);
		writeBindless(BINDLESS_IMAGES, index);
	}

	function getBindlessSampler( t : h3d.mat.Texture ) {
		var key = t.bits & ~getTexMask();
		var index = samplerHandles.get(key);
		if( index == null ) {
			index = bindlessSamplers.alloc();
			samplerHandles.set(key, index);
			bindlessSamplerValues[index] = getSampler(t);
			writeBindless(BINDLESS_SAMPLERS, index);
		}
		return index;
	}

	override function getTextureHandle( t : h3d.mat.Texture ) : h3d.mat.TextureHandle {
		if( !useBindless )
			throw "Bindless is not available : call h3d.impl.Driver.requestFeature(Bindless) before creating the engine";
		if( t.t == null && t.realloc != null ) {
			t.alloc();
			t.realloc();
		}
		var handles = textureHandles.get(t);
		if( handles == null ) {
			handles = [];
			textureHandles.set(t, handles);
		}
		var h = handles.get(t.bits);
		if( h == null ) {
			var index = bindlessTextures.alloc();
			writeBindlessTexture(t, index);
			h = new h3d.mat.TextureHandle(t, haxe.Int64.make(getBindlessSampler(t), index));
			handles.set(t.bits, h);
		}
		return h;
	}

	override function getBufferHandle( b : h3d.Buffer ) : h3d.BufferHandle {
		if( !useBindless )
			throw "Bindless is not available : call h3d.impl.Driver.requestFeature(Bindless) before creating the engine";
		var v = b.vbuf;
		if( v.bindless == null ) {
			var index = bindlessBuffers.alloc();
			bindlessBufferValues[index] = v.handle;
			writeBindless(BINDLESS_BUFFERS, index);
			v.bindless = new h3d.BufferHandle(b, index);
		}
		return v.bindless;
	}

	function refreshTextureHandles( t : h3d.mat.Texture, td : TextureData ) {
		var handles = textureHandles.get(t);
		if( handles == null ) return;
		var prevTd = t.t, prevBits = t.bits;
		t.t = td;
		for( bits => h in handles ) {
			if( h.handle == -1 ) continue;
			t.loadBits(bits);
			writeBindlessTexture(t, h.handle.low);
		}
		t.t = prevTd;
		t.loadBits(prevBits);
	}

	function releaseTextureHandles( t : h3d.mat.Texture ) {
		var handles = textureHandles.get(t);
		if( handles == null || t.realloc != null || frame == null ) return;
		for( h in handles )
			frame.texHandlesToRelease.push(h);
		textureHandles.remove(t);
	}

	function selectTextureHandle( h : h3d.mat.TextureHandle ) {
		if( h.handle == -1 )
			throw "Handle is invalid";
		var t = h.texture;
		if( t.t == null && t.realloc != null ) {
			var s = currentShader;
			t.alloc();
			t.realloc();
			if( hasDeviceError ) return;
			if( s != currentShader )
				throw "Shader change detected";
		}
		t.lastFrame = frameCount;
		if( !(t.t.isDepth && t.t.state == DEPTH_READ) )
			transition(t.t, SHADER_READ);
	}

	function selectBufferHandle( h : h3d.BufferHandle ) {
		if( h.handle == -1 )
			throw "Handle is invalid";
		transition(h.buffer.vbuf, READ);
	}

	override function selectTextureHandles( handles : Array<h3d.mat.TextureHandle> ) {
		for( h in handles )
			selectTextureHandle(h);
	}

	override function selectBufferHandles( handles : Array<h3d.BufferHandle> ) {
		for( h in handles )
			selectBufferHandle(h);
	}

	static var ENTRY_POINT : hl.Bytes = @:privateAccess "main".toUtf8();
	static var DYNAMIC_STATES : Array<DynamicState> = [
		VIEWPORT, SCISSOR, VERTEX_INPUT_BINDING_STRIDE, CULL_MODE, DEPTH_TEST_ENABLE, DEPTH_WRITE_ENABLE, DEPTH_COMPARE_OP,
		DEPTH_BIAS_ENABLE, DEPTH_BIAS, STENCIL_TEST_ENABLE, DynamicState.STENCIL_OP, STENCIL_COMPARE_MASK, STENCIL_WRITE_MASK, STENCIL_REFERENCE,
	];
	static inline var MAX_VERTEX_INPUTS = 16;

	function initPipelineStructs() {
		var r = SUCCESS;
		pipelineCache = Vk.pipelineCacheCreate(new PipelineCacheCreateInfo(), r);
		checkResult(r, "vkCreatePipelineCache");

		pipelineInfos = GraphicsPipelineCreateInfo.alloc(1);
		var p = pipelineInfos[0];
		pipelineStages = PipelineShaderStageCreateInfo.alloc(2);
		pipelineStages[0].stage = ShaderStage.VERTEX;
		pipelineStages[0].pName = ENTRY_POINT;
		pipelineStages[1].stage = ShaderStage.FRAGMENT;
		pipelineStages[1].pName = ENTRY_POINT;
		p.stageCount = 2;
		p.pStages = pipelineStages;

		vertexBindings = hl.CArray.alloc(VertexInputBindingDescription, MAX_VERTEX_INPUTS);
		vertexAttributes = hl.CArray.alloc(VertexInputAttributeDescription, MAX_VERTEX_INPUTS);
		vertexInputState.pVertexBindingDescriptions = vertexBindings;
		vertexInputState.pVertexAttributeDescriptions = vertexAttributes;
		p.pVertexInputState = vertexInputState;

		inputAssemblyState.topology = 3;
		p.pInputAssemblyState = inputAssemblyState;
		viewportState.viewportCount = 1;
		viewportState.scissorCount = 1;
		p.pViewportState = viewportState;
		rasterizationState.frontFace = 1;
		rasterizationState.lineWidth = 1;
		p.pRasterizationState = rasterizationState;
		multisampleState.rasterizationSamples = 1;
		p.pMultisampleState = multisampleState;
		depthStencilState.maxDepthBounds = 1;
		p.pDepthStencilState = depthStencilState;
		colorBlendAttachments = hl.CArray.alloc(PipelineColorBlendAttachmentState, 8);
		colorBlendState.pAttachments = colorBlendAttachments;
		p.pColorBlendState = colorBlendState;
		var states = new hl.Bytes(DYNAMIC_STATES.length * 4);
		for( i => s in DYNAMIC_STATES ) states.setI32(i << 2, s);
		dynamicState.dynamicStateCount = DYNAMIC_STATES.length;
		dynamicState.pDynamicStates = states;
		p.pDynamicState = dynamicState;
		renderingState.pColorAttachmentFormats = colorFormats;
		p.pNext = VkConst.pointer(renderingState);

		computeInfos = ComputePipelineCreateInfo.alloc(1);
		var c = computeInfos[0].stage;
		c.setType();
		c.stage = ShaderStage.COMPUTE;
		c.pName = ENTRY_POINT;
		createdPipelines = hl.CArray.alloc(PipelineHandle, 1);
		createdComputePipelines = hl.CArray.alloc(PipelineHandle, 1);
	}

	function createShaderModule( code : haxe.io.Bytes ) {
		var m = shaderModuleInfo;
		m.codeSize = code.length;
		m.pCode = @:privateAccess code.b;
		var r = SUCCESS;
		var sm = Vk.shaderModuleCreate(m, r);
		checkResult(r, "vkCreateShaderModule");
		return sm;
	}

	function checkResult( r : Result, what : String ) {
		if( r == SUCCESS ) return true;
		if( r == ERROR_DEVICE_LOST ) {
			hasDeviceError = true;
			return false;
		}
		throw what + " failed (VkResult " + r + ")";
	}

	function createSemaphore() {
		var r = SUCCESS;
		var s = Vk.semaphoreCreate(r);
		checkResult(r, "vkCreateSemaphore");
		return s;
	}

	function waitFence( fence : Fence ) {
		var f = fence;
		if( checkResult(Vk.waitForFences(1, f, true, VkConst.WHOLE_SIZE), "vkWaitForFences") )
			checkResult(Vk.resetFences(1, f), "vkResetFences");
	}

	function submit( wait : Semaphore, signal : Semaphore, fence : Fence ) {
		cmdSubmits[0].commandBuffer = cmd;
		waitSubmits[0].semaphore = wait;
		signalSubmits[0].semaphore = signal;
		var s = submits[0];
		s.waitSemaphoreInfoCount = wait == null ? 0 : 1;
		s.signalSemaphoreInfoCount = signal == null ? 0 : 1;
		checkResult(Vk.queueSubmit2(queue, 1, submits, fence), "vkQueueSubmit2");
	}

	function setViewport( x : Float, y : Float, width : Float, height : Float ) {
		var v = viewports[0];
		v.x = x;
		v.y = y + height;
		v.width = width;
		v.height = -height;
		Vk.cmdSetViewport(cmd, 0, 1, viewports);
	}

	function setScissor( x : Int, y : Int, width : Int, height : Int ) {
		scissors[0].set(x, y, width, height);
		Vk.cmdSetScissor(cmd, 0, 1, scissors);
	}

	function clearColorAttachment( index : Int, r : Float, g : Float, b : Float, a : Float ) {
		var c = clearAttachments[0];
		c.aspectMask = ImageAspect.COLOR;
		c.colorAttachment = index;
		c.clearValue.setColor(r, g, b, a);
		clearRects[0].rect.set(0, 0, rtWidth, rtHeight);
		Vk.cmdClearAttachments(cmd, 1, clearAttachments, 1, clearRects);
	}

	function clearDepthAttachment( aspect : Int, depth : Float, stencil : Int ) {
		var c = clearAttachments[0];
		c.aspectMask = aspect;
		c.colorAttachment = 0;
		c.clearValue.setDepthStencil(depth, stencil);
		clearRects[0].rect.set(0, 0, rtWidth, rtHeight);
		Vk.cmdClearAttachments(cmd, 1, clearAttachments, 1, clearRects);
	}

	function copyBuffer( src : NativeBuffer, srcOffset : Int, dst : NativeBuffer, dstOffset : Int, size : Int ) {
		var c = bufferCopy;
		c.srcBuffer = src;
		c.dstBuffer = dst;
		var r = c.pRegions[0];
		r.srcOffset = srcOffset;
		r.dstOffset = dstOffset;
		r.size = size;
		Vk.cmdCopyBuffer2(cmd, c);
	}

	function setBufferImageRegion( bufferOffset : Int, aspect : Int, mipLevel : Int, layer : Int, is3D : Bool, x : Int, y : Int, width : Int, height : Int ) {
		var r = bufferImageCopy.pRegions[0];
		r.bufferOffset = bufferOffset;
		r.bufferRowLength = 0;
		r.bufferImageHeight = 0;
		var s = r.imageSubresource;
		s.aspectMask = aspect;
		s.mipLevel = mipLevel;
		s.baseArrayLayer = is3D ? 0 : layer;
		s.layerCount = 1;
		r.imageOffset.set(x, y, is3D ? layer : 0);
		r.imageExtent.set(width, height, 1);
	}

	function blitImage( src : NativeImage, srcLayout : ImageLayout, srcMip : Int, srcW : Int, srcH : Int, srcD : Int, dst : NativeImage, dstLayout : ImageLayout, dstMip : Int, dstW : Int, dstH : Int, dstD : Int, baseLayer : Int, layerCount : Int, filter : Filter ) {
		var b = imageBlit;
		b.srcImage = src;
		b.srcImageLayout = srcLayout;
		b.dstImage = dst;
		b.dstImageLayout = dstLayout;
		b.filter = filter;
		var r = b.pRegions[0];
		var s = r.srcSubresource;
		s.aspectMask = ImageAspect.COLOR;
		s.mipLevel = srcMip;
		s.baseArrayLayer = baseLayer;
		s.layerCount = layerCount;
		var s = r.dstSubresource;
		s.aspectMask = ImageAspect.COLOR;
		s.mipLevel = dstMip;
		s.baseArrayLayer = baseLayer;
		s.layerCount = layerCount;
		r.srcOffset0.set(0, 0, 0);
		r.srcOffset1.set(srcW, srcH, srcD);
		r.dstOffset0.set(0, 0, 0);
		r.dstOffset1.set(dstW, dstH, dstD);
		Vk.cmdBlitImage2(cmd, b);
	}

	override function hasFeature( f : Feature ) {
		return switch( f ) {
		case Queries, BottomLeftCoords: false;
		case Bindless: useBindless;
		default: true;
		}
	}

	static function onFeatureRequested( f : Feature ) : Bool {
		return switch( f ) {
		case Queries, BottomLeftCoords: false;
		default: true;
		}
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return true;
	}

	override function isDisposed() {
		return hasDeviceError;
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		onContextLost = onCreate.bind(true);
		haxe.Timer.delay(onCreate.bind(false), 1);
	}

	override function dispose() {
		psoConfigCache?.save();
		Vk.deviceWaitIdle();
		upscaling.dispose();
	}

	override function getDriverName( details : Bool ) {
		var desc = "Vulkan";
		if( details ) desc += " " + Vk.getDeviceName();
		return desc;
	}

	override function getMemoryUsage() {
		Vk.getHeapBudgets(hl.Bytes.fromBytes(memBudgets));
		var total = 0., used = 0.;
		for( i in 0...memProperties.getI32(MemoryReport.HEAP_COUNT_OFFSET) ) {
			var flags = memProperties.getI32(MemoryReport.HEAPS_OFFSET + i * MemoryReport.HEAP_STRIDE + 8);
			if( flags & MemoryHeapFlags.DEVICE_LOCAL == 0 ) continue;
			total += memBudgets.getInt64(i * MemoryReport.BUDGET_STRIDE + MemoryReport.BUDGET_BUDGET_OFFSET).toFloat();
			used += memBudgets.getInt64(i * MemoryReport.BUDGET_STRIDE + MemoryReport.BUDGET_USAGE_OFFSET).toFloat();
		}
		return { total : total, allocated : used, free : total - used };
	}

	// ---- FRAMES

	function releaseGarbage( list : Array<Garbage> ) {
		while( list.length > 0 ) {
			switch( list.pop() ) {
			case GBuffer(b): Vk.bufferDestroy(b);
			case GImage(i): Vk.imageDestroy(i);
			case GView(v): Vk.imageViewDestroy(v);
			}
		}
	}

	function beginFrame() {
		frameCount = hxd.Timer.frameCount;
		frameIndex = (frameIndex + 1) % BUFFER_COUNT;
		frame = frames[frameIndex];
		if( frame.submitted ) {
			waitFence(frame.fence);
			frame.submitted = false;
		}
		releaseGarbage(frame.toRelease);
		for( r in frame.asyncReads ) {
			@:privateAccess r.buf.b.blit(r.bufPos, Vk.bufferGetMapped(r.tmp), 0, r.size);
			Vk.bufferDestroy(r.tmp);
			r.callback();
		}
		frame.asyncReads = [];
		readQueries();
		frame.allocator.reset(frame.allocator.getSize() >= 512 * 1024 * 1024);
		for( i in 0...frame.descPoolIndex + 1 )
			if( i < frame.descPools.length )
				checkResult(Vk.descriptorPoolReset(frame.descPools[i], 0), "vkResetDescriptorPool");
		frame.descPoolIndex = 0;
		descriptorGeneration++;
		if( useBindless ) beginBindlessFrame();

		checkResult(Vk.commandPoolReset(frame.pool, 0), "vkResetCommandPool");
		cmd = frame.cmd;
		checkResult(Vk.beginCommandBuffer(cmd, beginInfo), "vkBeginCommandBuffer");
		for( p in frame.queryPools )
			Vk.cmdResetQueryPool(cmd, p, 0, QUERY_COUNT);
		resetCommandState();
		setRenderTarget(null);
		upscaling.beginFrame();
	}

	function resetCommandState() {
		renderingActive = false;
		currentShader = null;
		currentPipeline = null;
		currentIndex = null;
		curStencilRef = -1;
		curCull = curDepthTest = curDepthWrite = curDepthCompare = curBiasEnable = curStencilTest = curStencilOps = curStencilMasks = -1;
		curDepthBias = curSlopeBias = Math.NaN;
		dynamicDirty = true;
		needBind = true;
		pushDirty = true;
	}

	function submitAndWait() {
		endRendering();
		flushTransitions();
		checkResult(Vk.endCommandBuffer(cmd), "vkEndCommandBuffer");
		submit(null, null, frame.fence);
		waitFence(frame.fence);
		checkResult(Vk.commandPoolReset(frame.pool, 0), "vkResetCommandPool");
		checkResult(Vk.beginCommandBuffer(cmd, beginInfo), "vkBeginCommandBuffer");
		resetCommandState();
		setViewport(0, 0, viewportW, viewportH);
		setScissor(scissorX, scissorY, scissorW, scissorH);
	}

	function recreateSwapchain() {
		Vk.deviceWaitIdle();
		swapchainVsync = hxd.Window.getInstance().vsync;
		swapchainCount = 0;
		swapchainDirty = true;
		var caps = surfaceCaps;
		if( Vk.surfaceGetCapabilities(caps) != SUCCESS )
			return;
		var w = caps.currentWidth, h = caps.currentHeight;
		if( w == -1 ) {
			w = hxd.Math.iclamp(currentWidth, caps.minWidth, caps.maxWidth);
			h = hxd.Math.iclamp(currentHeight, caps.minHeight, caps.maxHeight);
		}
		if( w == 0 || h == 0 )
			return; // minimized
		var d = swapchainInfo;
		if( !selectSurfaceFormat(d) )
			throw "No Vulkan surface format available";
		d.presentMode = selectPresentMode(swapchainVsync);
		var count = BUFFER_COUNT + 1;
		if( count < caps.minImageCount ) count = caps.minImageCount;
		if( caps.maxImageCount > 0 && count > caps.maxImageCount ) count = caps.maxImageCount;
		d.surface = Vk.getSurface();
		d.minImageCount = count;
		d.imageExtent.width = w;
		d.imageExtent.height = h;
		d.imageArrayLayers = 1;
		d.imageUsage = ImageUsage.COLOR_ATTACHMENT | ImageUsage.TRANSFER_DST;
		d.imageSharingMode = EXCLUSIVE;
		d.preTransform = caps.supportedTransforms & SurfaceTransform.IDENTITY != 0 ? SurfaceTransform.IDENTITY : caps.currentTransform;
		d.compositeAlpha = CompositeAlpha.OPAQUE;
		for( a in [CompositeAlpha.OPAQUE, CompositeAlpha.INHERIT, CompositeAlpha.PRE_MULTIPLIED, CompositeAlpha.POST_MULTIPLIED] )
			if( caps.supportedCompositeAlpha & a != 0 ) {
				d.compositeAlpha = a;
				break;
			}
		d.clipped = 1;
		d.oldSwapchain = swapchain;
		var r = SUCCESS;
		var sc = Vk.swapchainCreate(d, r);
		switch( r ) {
		case SUCCESS:
		case ERROR_OUT_OF_DATE:
			return;
		case ERROR_DEVICE_LOST:
			hasDeviceError = true;
			return;
		default:
			throw "Failed to create Vulkan swapchain (" + r + ")";
		}
		if( swapchain != null ) Vk.swapchainDestroy(swapchain);
		swapchain = sc;
		swapchainWidth = w;
		swapchainHeight = h;
		var n = 0;
		Vk.getSwapchainImages(swapchain, n, null);
		var images = hl.CArray.alloc(NativeImageHandle, n);
		checkResult(Vk.getSwapchainImages(swapchain, n, images), "vkGetSwapchainImagesKHR");
		swapchainImages = [for( i in 0...n ) images[i].handle];
		swapchainCount = n;
		swapchainDirty = false;
		while( renderSemaphores.length < swapchainCount )
			renderSemaphores.push(createSemaphore());
		upscaling.afterCreateSwapChain();
	}

	function selectSurfaceFormat( d : SwapchainCreateInfo ) {
		var buf = surfaceQueryBuf;
		var count = Vk.surfaceGetFormats(buf, hxd.Math.imin(Vk.surfaceGetFormats(null, 0), 64));
		if( count == 0 )
			return false;
		d.imageFormat = cast buf.getI32(0);
		d.imageColorSpace = cast buf.getI32(4);
		for( i in 0...count ) {
			var fmt : Format = cast buf.getI32(i << 3);
			var cs : ColorSpace = cast buf.getI32((i << 3) + 4);
			if( cs == SRGB_NONLINEAR && (fmt == B8G8R8A8_UNORM || fmt == R8G8B8A8_UNORM) ) {
				d.imageFormat = fmt;
				d.imageColorSpace = cs;
				break;
			}
		}
		return true;
	}

	function selectPresentMode( vsync : Bool ) : PresentMode {
		if( vsync )
			return FIFO;
		var buf = surfaceQueryBuf;
		var count = Vk.surfaceGetPresentModes(buf, hxd.Math.imin(Vk.surfaceGetPresentModes(null, 0), 64));
		var modes : Array<PresentMode> = [for( i in 0...count ) cast buf.getI32(i << 2)];
		if( modes.indexOf(IMMEDIATE) >= 0 ) return IMMEDIATE;
		if( modes.indexOf(MAILBOX) >= 0 ) return MAILBOX;
		return FIFO;
	}

	override function present() {
		upscaling.beforePresent();
		endRendering();
		transition(backBuffer.t, COPY_SRC);

		#if hlnx
		var displayChanged = nx.Display.hasResolutionChanged();
		if( displayChanged ) {
			Vk.deviceWaitIdle();
			if( swapchain != null ) Vk.swapchainDestroy(swapchain);
			Vk.surfaceDestroy();
			swapchain = null;
			swapchainCount = 0;
			swapchainDirty = true;
			createSurface();
		}
		#end
		if( swapchainDirty || swapchainVsync != hxd.Window.getInstance().vsync )
			recreateSwapchain();
		var imageIndex = -1;
		if( swapchainCount > 0 ) {
			var index = 0;
			var r = Vk.acquireNextImage(swapchain, VkConst.WHOLE_SIZE, frame.acquireSem, null, index);
			if( r == ERROR_OUT_OF_DATE ) {
				recreateSwapchain();
				if( swapchainCount > 0 ) r = Vk.acquireNextImage(swapchain, VkConst.WHOLE_SIZE, frame.acquireSem, null, index);
			}
			switch( r ) {
			case SUCCESS:
				imageIndex = index;
			case SUBOPTIMAL:
				imageIndex = index;
				swapchainDirty = true;
			case ERROR_DEVICE_LOST:
				hasDeviceError = true;
			default:
				swapchainDirty = true;
			}
		}
		if( imageIndex >= 0 ) {
			var img = swapchainImages[imageIndex];
			imageBarrier(img, UNDEFINED, COPY_DST, false);
			flushTransitions();
			blitImage(backBuffer.t.handle, TRANSFER_SRC_OPTIMAL, 0, currentWidth, currentHeight, 1, img, TRANSFER_DST_OPTIMAL, 0, swapchainWidth, swapchainHeight, 1, 0, 1, NEAREST);
			imageBarrier(img, COPY_DST, PRESENT, false);
		} else
			flushTransitions();

		checkResult(Vk.endCommandBuffer(cmd), "vkEndCommandBuffer");
		if( imageIndex >= 0 )
			submit(frame.acquireSem, renderSemaphores[imageIndex], frame.fence);
		else
			submit(null, null, frame.fence);
		frame.submitted = true;
		upscaling.beforeQueuePresent();
		if( imageIndex >= 0 && !hasDeviceError ) {
			presentWaits[0].handle = renderSemaphores[imageIndex];
			presentSwapchains[0].handle = swapchain;
			presentIndices.setI32(0, imageIndex);
			switch( Vk.queuePresent(queue, presentInfo) ) {
			case SUCCESS:
			case ERROR_DEVICE_LOST: hasDeviceError = true;
			default: swapchainDirty = true;
			}
		}
		upscaling.afterQueuePresent();
		psoConfigCache?.save();
		beginFrame();
		#if hlnx
		if( displayChanged )
			@:privateAccess hxd.Window.getInstance().onResize(null);
		#end

		if( hasDeviceError ) {
			Sys.println("----------- Vulkan device lost ----------");
			throw "Vulkan device lost";
		}
	}

	function imageBarrier( img : NativeImage, from : ResState, to : ResState, depth : Bool ) {
		var b = tmpImageBarriers[0];
		b.image = img;
		b.srcStageMask = STAGES[from];
		b.srcAccessMask = ACCESS[from];
		b.dstStageMask = STAGES[to];
		b.dstAccessMask = ACCESS[to];
		b.oldLayout = cast LAYOUTS[from];
		b.newLayout = cast LAYOUTS[to];
		var r = b.subresourceRange;
		r.aspectMask = depth ? ImageAspect.DEPTH_STENCIL : ImageAspect.COLOR;
		r.baseMipLevel = 0;
		r.levelCount = VkConst.IGNORED;
		r.baseArrayLayer = 0;
		r.layerCount = VkConst.IGNORED;
		tmpDependency.imageMemoryBarrierCount = 1;
		tmpDependency.memoryBarrierCount = 0;
		Vk.cmdPipelineBarrier2(cmd, tmpDependency);
	}

	override function resize( width : Int, height : Int ) {
		if( width < 1 ) width = 1;
		if( height < 1 ) height = 1;
		if( backBuffer != null && currentWidth == width && currentHeight == height )
			return;
		var resizing = backBuffer != null;
		if( resizing ) {
			upscaling.beforeResize();
			upscaling.releaseResizeResources();
		}
		currentWidth = width;
		currentHeight = height;
		swapchainDirty = true;
		endRendering();

		if( backBuffer == null ) {
			backBuffer = new h3d.mat.Texture(0, 0, [NoAlloc, Target], RGBA);
			backBuffer.name = "backBuffer";
			backBuffer.preventAutoDispose();
			defaultDepth = new h3d.mat.Texture(0, 0, [NoAlloc], DEFAULT_DEPTH_FORMAT);
			defaultDepth.name = "defaultDepth";
			defaultDepth.preventAutoDispose();
		} else {
			disposeTexture(backBuffer);
			disposeDepthBuffer(defaultDepth);
		}
		@:privateAccess {
			backBuffer.width = defaultDepth.width = width;
			backBuffer.height = defaultDepth.height = height;
		}
		backBuffer.t = allocTexture(backBuffer);
		defaultDepth.t = allocDepthBuffer(defaultDepth);

		if( frame == null )
			beginFrame();
		else
			setRenderTarget(null);
		if( resizing )
			upscaling.afterResize();
	}

	override function begin( frame : Int ) {
		upscaling.begin();
	}

	override function getDefaultDepthBuffer() : h3d.mat.Texture {
		return defaultDepth;
	}

	// ---- BARRIERS

	static var STAGES : Array<Int> = [
		PipelineStage.TOP_OF_PIPE,
		PipelineStage.TRANSFER,
		PipelineStage.TRANSFER,
		PipelineStage.DRAW_INDIRECT | PipelineStage.VERTEX_INPUT | PipelineStage.VERTEX_SHADER | PipelineStage.FRAGMENT_SHADER | PipelineStage.COMPUTE_SHADER,
		PipelineStage.VERTEX_SHADER | PipelineStage.FRAGMENT_SHADER | PipelineStage.COMPUTE_SHADER,
		PipelineStage.VERTEX_SHADER | PipelineStage.FRAGMENT_SHADER | PipelineStage.COMPUTE_SHADER,
		PipelineStage.COLOR_ATTACHMENT_OUTPUT,
		PipelineStage.EARLY_FRAGMENT_TESTS | PipelineStage.LATE_FRAGMENT_TESTS,
		PipelineStage.EARLY_FRAGMENT_TESTS | PipelineStage.LATE_FRAGMENT_TESTS | PipelineStage.VERTEX_SHADER | PipelineStage.FRAGMENT_SHADER | PipelineStage.COMPUTE_SHADER,
		PipelineStage.BOTTOM_OF_PIPE,
		PipelineStage.TRANSFER,
	];
	static var ACCESS : Array<Int> = [
		Access.NONE,
		Access.TRANSFER_READ,
		Access.TRANSFER_WRITE,
		Access.INDIRECT_COMMAND_READ | Access.INDEX_READ | Access.VERTEX_ATTRIBUTE_READ | Access.UNIFORM_READ | Access.SHADER_READ,
		Access.SHADER_READ,
		Access.SHADER_READ | Access.SHADER_WRITE,
		Access.COLOR_ATTACHMENT_READ | Access.COLOR_ATTACHMENT_WRITE,
		Access.DEPTH_STENCIL_ATTACHMENT_READ | Access.DEPTH_STENCIL_ATTACHMENT_WRITE,
		Access.DEPTH_STENCIL_ATTACHMENT_READ | Access.SHADER_READ,
		Access.NONE,
		Access.TRANSFER_READ | Access.TRANSFER_WRITE,
	];
	static var LAYOUTS : Array<Int> = [
		ImageLayout.UNDEFINED,
		ImageLayout.TRANSFER_SRC_OPTIMAL,
		ImageLayout.TRANSFER_DST_OPTIMAL,
		ImageLayout.UNDEFINED,
		ImageLayout.SHADER_READ_ONLY_OPTIMAL,
		ImageLayout.GENERAL,
		ImageLayout.COLOR_ATTACHMENT_OPTIMAL,
		ImageLayout.DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
		ImageLayout.DEPTH_STENCIL_READ_ONLY_OPTIMAL,
		ImageLayout.PRESENT_SRC,
		ImageLayout.GENERAL,
	];

	static inline function layoutOf( td : TextureData, s : ResState ) : ImageLayout {
		if( s == SHADER_READ && td.isDepth ) return DEPTH_STENCIL_READ_ONLY_OPTIMAL;
		return cast LAYOUTS[s];
	}

	function transition( res : ResourceData, to : ResState, stages = 0 ) {
		var isImage = res.isImage;
		var bd : BufferData = isImage ? null : cast res;
		var tracked = bd != null && (to == READ || to == UAV);
		if( tracked && stages == 0 ) stages = STAGES[to];
		if( res.pending < 0 ) {
			if( res.state == to ) {
				if( !tracked ) return;
				if( to == READ || bd.stages & stages == stages ) {
					bd.stages |= stages;
					return;
				}
			} else if( tracked && res.state == UAV && to == READ && bd.uavEpoch < uavBarrierEpoch ) {
				res.state = READ;
				bd.stages = stages;
				return;
			}
			if( (isImage ? imageBarrierCount : bufferBarrierCount) == MAX_BARRIERS )
				flushTransitions();
			var from = res.state;
			if( isImage ) {
				var td : TextureData = cast res;
				var b = imageBarriers[imageBarrierCount];
				b.srcStageMask = STAGES[from];
				b.srcAccessMask = ACCESS[from];
				b.oldLayout = layoutOf(td, from);
				b.image = td.handle;
				var r = b.subresourceRange;
				r.aspectMask = td.aspect;
				r.baseMipLevel = 0;
				r.levelCount = VkConst.IGNORED;
				r.baseArrayLayer = 0;
				r.layerCount = VkConst.IGNORED;
				res.pending = imageBarrierCount;
				imageBarrierRes[imageBarrierCount++] = res;
			} else {
				var b = bufferBarriers[bufferBarrierCount];
				b.srcStageMask = (from == READ || from == UAV) && bd.stages != 0 ? bd.stages : STAGES[from];
				b.srcAccessMask = from == READ ? Access.NONE : ACCESS[from];
				b.buffer = bd.handle;
				if( from != to ) bd.stages = 0;
				res.pending = bufferBarrierCount;
				bufferBarrierRes[bufferBarrierCount++] = res;
			}
		} else if( !isImage && res.state != to )
			bd.stages = 0;
		if( isImage ) {
			var b = imageBarriers[res.pending];
			b.dstStageMask = STAGES[to];
			b.dstAccessMask = ACCESS[to];
			b.newLayout = layoutOf(cast res, to);
		} else {
			var b = bufferBarriers[res.pending];
			bd.stages |= stages;
			b.dstStageMask = to == UAV ? bd.stages : STAGES[to];
			b.dstAccessMask = ACCESS[to];
		}
		res.state = to;
	}

	function flushTransitions() {
		if( imageBarrierCount == 0 && bufferBarrierCount == 0 && !needUAVBarrier )
			return;
		endRendering();
		var dep = dependency;
		dep.memoryBarrierCount = 0;
		if( needUAVBarrier ) {
			needUAVBarrier = false;
			var b = memoryBarriers[0];
			b.srcStageMask = PipelineStage.VERTEX_SHADER | PipelineStage.FRAGMENT_SHADER | PipelineStage.COMPUTE_SHADER | PipelineStage.TRANSFER;
			b.srcAccessMask = Access.SHADER_WRITE | Access.TRANSFER_WRITE;
			b.dstStageMask = STAGES[READ] | PipelineStage.TRANSFER;
			b.dstAccessMask = ACCESS[READ] | Access.SHADER_WRITE | Access.TRANSFER_READ;
			dep.memoryBarrierCount = 1;
			uavBarrierEpoch++;
		}
		dep.imageMemoryBarrierCount = imageBarrierCount;
		dep.bufferMemoryBarrierCount = bufferBarrierCount;
		Vk.cmdPipelineBarrier2(cmd, dep);
		for( i in 0...imageBarrierCount ) {
			imageBarrierRes[i].pending = -1;
			imageBarrierRes[i] = null;
		}
		for( i in 0...bufferBarrierCount ) {
			bufferBarrierRes[i].pending = -1;
			bufferBarrierRes[i] = null;
		}
		imageBarrierCount = 0;
		bufferBarrierCount = 0;
	}

	// ---- RENDER TARGETS

	function beginRendering() {
		if( renderingActive ) return;
		flushTransitions();
		startRendering();
	}

	function startRendering() {
		var ri = renderingInfo;
		ri.renderArea.set(0, 0, rtWidth, rtHeight);
		ri.colorAttachmentCount = rtColorCount;
		for( i in 0...rtColorCount ) {
			var c = colorAttachments[i];
			c.imageView = rtColorViews[i];
			c.imageLayout = COLOR_ATTACHMENT_OPTIMAL;
			c.loadOp = pendingColorClears & (1 << i) != 0 ? CLEAR : LOAD;
			c.storeOp = STORE;
		}
		if( rtDepthView != null ) {
			var d = depthAttachment;
			d.imageView = rtDepthView;
			d.imageLayout = rtDepthLayout;
			d.loadOp = pendingDepthClears & ImageAspect.DEPTH != 0 ? CLEAR : LOAD;
			d.storeOp = STORE;
			ri.pDepthAttachment = d;
			if( rtHasStencil ) {
				var s = stencilAttachment;
				s.imageView = rtDepthView;
				s.imageLayout = rtDepthLayout;
				s.loadOp = pendingDepthClears & ImageAspect.STENCIL != 0 ? CLEAR : LOAD;
				s.storeOp = STORE;
				ri.pStencilAttachment = s;
			} else
				ri.pStencilAttachment = null;
		} else {
			ri.pDepthAttachment = null;
			ri.pStencilAttachment = null;
		}
		pendingColorClears = 0;
		pendingDepthClears = 0;
		Vk.cmdBeginRendering(cmd, ri);
		renderingActive = true;
	}

	function endRendering() {
		if( !renderingActive ) {
			if( pendingColorClears == 0 && pendingDepthClears == 0 ) return;
			startRendering();
		}
		Vk.cmdEndRendering(cmd);
		renderingActive = false;
	}

	function flushForTransfer() {
		flushTransitions();
		endRendering();
	}

	function initViewport( w : Int, h : Int ) {
		rtWidth = w;
		rtHeight = h;
		viewportW = w;
		viewportH = h;
		dynamicDirty = true;
		setViewport(0, 0, w, h);
		setRenderZone(0, 0, -1, -1);
	}

	function setupDepth( depth : h3d.mat.Texture, readOnly : Bool, layer : Int ) {
		if( depth.t == null ) depth.alloc();
		depth.lastFrame = frameCount;
		if( readOnly ) {
			if( depth.t.state != DEPTH_READ ) transition(depth.t, DEPTH_READ);
		} else
			transition(depth.t, DEPTH_WRITE);
		rtDepthView = getDepthView(depth, layer);
		rtDepthLayout = readOnly ? DEPTH_STENCIL_READ_ONLY_OPTIMAL : DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
		rtHasStencil = depth.t.hasStencil;
	}

	function clearNewTarget( index : Int, t : h3d.mat.Texture ) {
		if( t.flags.has(WasCleared) ) return;
		t.flags.set(WasCleared);
		clearColor(index, 0, 0, 0, 0);
	}

	function clearColor( index : Int, r : Float, g : Float, b : Float, a : Float ) {
		if( renderingActive ) {
			clearColorAttachment(index, r, g, b, a);
			return;
		}
		flushTransitions();
		colorAttachments[index].clearValue.setColor(r, g, b, a);
		pendingColorClears |= 1 << index;
	}

	override function setRenderTarget( tex : Null<h3d.mat.Texture>, layer = 0, mipLevel = 0, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		endRendering();
		if( tex != null ) {
			if( tex.t == null ) tex.alloc();
			tex.lastFrame = frameCount;
		}
		var t = tex == null ? backBuffer : tex;
		transition(t.t, RENDER_TARGET);
		rtColorViews[0] = getRTView(t, layer, mipLevel);
		rtColorCount = 1;
		rtColorTextures.resize(0);
		rtColorTextures.push(t);

		var w = t.width >> mipLevel, h = t.height >> mipLevel;
		if( w == 0 ) w = 1;
		if( h == 0 ) h = 1;

		var depthBuffer = tex == null ? defaultDepth : tex.depthBuffer;
		var depthEnabled = depthBinding != NotBound && depthBuffer != null;
		rtDepthView = null;
		rtHasStencil = false;
		if( depthEnabled ) {
			if( depthBuffer.width != t.width || depthBuffer.height != t.height )
				throw "Depth size mismatch";
			setupDepth(depthBuffer, depthBinding == ReadOnly, 0);
		}

		while( currentRenderTargets.length > 0 ) currentRenderTargets.pop();
		if( tex != null ) currentRenderTargets.push(tex);

		initViewport(w, h);
		pipelineBuilder.setRenderTarget(t, depthEnabled ? depthBuffer : null);
		if( tex != null ) clearNewTarget(0, tex);
	}

	override function setRenderTargets( textures : Array<h3d.mat.Texture>, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		endRendering();
		while( currentRenderTargets.length > 0 ) currentRenderTargets.pop();
		rtColorTextures.resize(0);
		for( i => t in textures ) {
			if( t.t == null ) {
				t.alloc();
				if( hasDeviceError ) return;
			}
			t.lastFrame = frameCount;
			transition(t.t, RENDER_TARGET);
			rtColorViews[i] = getRTView(t, 0, 0);
			currentRenderTargets.push(t);
			rtColorTextures.push(t);
		}
		rtColorCount = textures.length;
		var t0 = textures[0];
		var depthBuffer = t0.depthBuffer;
		var depthEnabled = depthBinding != NotBound && depthBuffer != null;
		rtDepthView = null;
		rtHasStencil = false;
		if( depthEnabled ) {
			if( depthBuffer.width != t0.width || depthBuffer.height != t0.height )
				throw "Depth size mismatch";
			setupDepth(depthBuffer, depthBinding == ReadOnly, 0);
		}
		initViewport(t0.width, t0.height);
		pipelineBuilder.setRenderTargets(textures, depthEnabled ? depthBuffer : null);
		for( i => t in textures )
			clearNewTarget(i, t);
	}

	override function setDepth( depthBuffer : h3d.mat.Texture, layer = 0 ) {
		endRendering();
		while( currentRenderTargets.length > 0 ) currentRenderTargets.pop();
		rtColorTextures.resize(0);
		rtColorCount = 0;
		setupDepth(depthBuffer, false, layer);
		initViewport(depthBuffer.width, depthBuffer.height);
		pipelineBuilder.setDepth(depthBuffer);
	}

	override function setDepthClamp( enabled : Bool ) {
		useDepthClamp = enabled;
	}

	override function setDepthBias( depthBias : Float, slopeScaledBias : Float ) {
		matDepthBias = Std.int(depthBias);
		matSlopeBias = slopeScaledBias;
		dynamicDirty = true;
	}

	override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		if( width < 0 && height < 0 && x == 0 && y == 0 ) {
			scissorX = 0;
			scissorY = 0;
			scissorW = rtWidth;
			scissorH = rtHeight;
		} else {
			if( x < 0 ) { width += x; x = 0; }
			if( y < 0 ) { height += y; y = 0; }
			if( width < 0 ) width = 0;
			if( height < 0 ) height = 0;
			scissorX = x;
			scissorY = y;
			scissorW = width;
			scissorH = height;
		}
		setScissor(scissorX, scissorY, scissorW, scissorH);
	}

	function restoreTargets() {
		for( t in rtColorTextures )
			if( t.t != null )
				transition(t.t, RENDER_TARGET);
	}

	override function clear( ?color : h3d.Vector4, ?depth : Float, ?stencil : Int ) {
		if( color != null ) {
			for( i in 0...rtColorCount ) {
				clearColor(i, color.r, color.g, color.b, color.a);
				rtColorTextures[i].flags.set(WasCleared);
			}
		}
		if( (depth != null || stencil != null) && rtDepthView != null && rtDepthLayout == DEPTH_STENCIL_ATTACHMENT_OPTIMAL ) {
			var aspect = 0;
			if( depth != null ) aspect |= ImageAspect.DEPTH;
			if( stencil != null && rtHasStencil ) aspect |= ImageAspect.STENCIL;
			if( aspect == 0 ) return;
			if( renderingActive ) {
				clearDepthAttachment(aspect, depth == null ? 0 : depth, stencil == null ? 0 : stencil);
				return;
			}
			flushTransitions();
			if( depth != null ) depthAttachment.clearValue.setDepthStencil(depth, 0);
			if( aspect & ImageAspect.STENCIL != 0 ) stencilAttachment.clearValue.setDepthStencil(0, stencil);
			pendingDepthClears |= aspect;
		}
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		var rt = currentRenderTargets[0];
		captureTexPixels(pixels, rt == null ? backBuffer : rt, 0, 0);
	}

	override function capturePixels( tex : h3d.mat.Texture, layer : Int, mipLevel : Int, ?region : h2d.col.IBounds ) : hxd.Pixels {
		var pixels : hxd.Pixels;
		if( region != null ) {
			if( region.xMax > tex.width ) region.xMax = tex.width;
			if( region.yMax > tex.height ) region.yMax = tex.height;
			if( region.xMin < 0 ) region.xMin = 0;
			if( region.yMin < 0 ) region.yMin = 0;
			var w = region.width >> mipLevel;
			var h = region.height >> mipLevel;
			if( w == 0 ) w = 1;
			if( h == 0 ) h = 1;
			pixels = hxd.Pixels.alloc(w, h, tex.format);
			captureTexPixels(pixels, tex, layer, mipLevel, region.xMin, region.yMin);
		} else {
			var w = tex.width >> mipLevel;
			var h = tex.height >> mipLevel;
			if( w == 0 ) w = 1;
			if( h == 0 ) h = 1;
			pixels = hxd.Pixels.alloc(w, h, tex.format);
			captureTexPixels(pixels, tex, layer, mipLevel);
		}
		return pixels;
	}

	function captureTexPixels( pixels : hxd.Pixels, tex : h3d.mat.Texture, layer : Int, mipLevel : Int, x = 0, y = 0 ) {
		if( pixels.width == 0 || pixels.height == 0 )
			return;
		if( tex.t == null ) throw "Can't capture disposed texture";
		if( mipLevel < tex.residentMip ) throw "Mip level " + mipLevel + " is not resident in " + tex;
		var size = pixels.dataSize;
		var tmp = allocCheck(() -> createVkBuffer(size, BufferUsage.TRANSFER_DST, READBACK));
		transition(tex.t, COPY_SRC);
		flushForTransfer();
		setBufferImageRegion(0, tex.t.isDepth ? ImageAspect.DEPTH : ImageAspect.COLOR, mipLevel - tex.residentMip, layer, tex.flags.has(Is3D), x, y, pixels.width, pixels.height);
		var c = imageBufferCopy;
		c.srcImage = tex.t.handle;
		c.dstBuffer = Vk.bufferGetHandle(tmp);
		Vk.cmdCopyImageToBuffer2(cmd, c);
		restoreTargets();
		submitAndWait();
		(pixels.bytes : hl.Bytes).blit(pixels.offset, Vk.bufferGetMapped(tmp), 0, size);
		Vk.bufferDestroy(tmp);
	}

	// ---- SHADERS

	static function getPushOffset( sh : hxsl.RuntimeShader.RuntimeShaderData ) {
		var size = sh.paramsSize << 4;
		if( size == 0 || size > PUSH_HALF )
			return -1;
		return sh.kind == Fragment ? PUSH_HALF : 0;
	}

	static function generateHlsl( sh : hxsl.RuntimeShader.RuntimeShaderData ) {
		var out = new hxsl.HlslOut();
		out.vulkan = true;
		out.vulkanPushOffset = getPushOffset(sh);
		return out.run(sh.data);
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		var vs = generateHlsl(shader.vertex);
		if( shader.mode == Compute )
			return vs;
		var ps = generateHlsl(shader.fragment);
		return vs + "\n\n\n\n" + ps;
	}

	static final SHADER_ARGS : Array<String> = [
		"-fvk-use-dx-layout", "-fvk-stage-io-order=alpha", "-fvk-support-nonzero-base-instance",
		#if shader_debug_info "-Zi", "-fspv-debug=vulkan-with-source", #end
	];
	function compileSource( rt : hxsl.RuntimeShader, sh : hxsl.RuntimeShader.RuntimeShaderData ) {
		if( sh.code == null )
			sh.code = generateHlsl(sh);
		var profile = switch( sh.kind ) {
		case Vertex: "vs_6_1";
		case Fragment: "ps_6_1";
		default: "cs_6_1";
		}
		var base = sh.kind == Fragment ? BIND_FRAGMENT : 0;
		var args = shaderArgs.concat([
			"-fvk-b-shift", "" + (base + BIND_B), "0",
			"-fvk-t-shift", "" + (base + BIND_T), "0",
			"-fvk-s-shift", "" + (base + BIND_S), "0",
			"-fvk-u-shift", "" + (base + BIND_U), "0",
		]);
		var key = "vk_" + profile + "_" + base;
		for( arg in shaderArgs )
			key += arg;
		var bytes = shaderCache != null ? shaderCache.resolveShaderBinary(sh.code, key) : null;
		if( bytes == null ) {
			var miss = shaderCache != null ? hxsl.ShaderMiss.report(rt) : null;
			try {
				#if (hlnx && shader_server)
				bytes = nx.ShaderClient.compile(sh.code, profile, key, args, miss?.toString());
				#else
				#if heaps_mt_hxsl_cache
				var compiler = compilers.value;
				if( compiler == null ) compilers.value = compiler = new ShaderCompiler();
				#else
				if( compiler == null ) compiler = new ShaderCompiler();
				#end
				bytes = compiler.compile(sh.code, profile, args);
				#end
			} catch( e : Dynamic ) {
				throw "Failed to compile shader:\n" + (miss != null ? miss + "\n" : "") + sh.code + "\n\n" + e;
			}
			if( shaderCache != null )
				shaderCache.saveCompiledShader(sh.code, bytes, key);
		}
		return bytes;
	}

	static function getUsedInputs( code : haxe.io.Bytes, count : Int ) : Array<Bool> {
		var inputVars = new Map<Int, Bool>();
		var locations = new Map<Int, Int>();
		var i = 5;
		var words = code.length >> 2;
		while( i < words ) {
			var w = code.getInt32(i << 2);
			var op = w & 0xFFFF, len = w >>> 16;
			if( len == 0 ) break;
			switch( op ) {
			case 59: // OpVariable result-type result-id storage-class
				if( code.getInt32((i + 3) << 2) == 1 )
					inputVars.set(code.getInt32((i + 2) << 2), true);
			case 71: // OpDecorate target Location n
				if( code.getInt32((i + 2) << 2) == 30 )
					locations.set(code.getInt32((i + 1) << 2), code.getInt32((i + 3) << 2));
			default:
			}
			i += len;
		}
		var used = [for( i in 0...count ) false];
		for( id => loc in locations )
			if( inputVars.exists(id) && loc < count )
				used[loc] = true;
		return used;
	}

	function makeRegs( sh : hxsl.RuntimeShader.RuntimeShaderData, base : Int, stage : Int, bindings : Array<Int>, writes : Array<Int> ) {
		var regs = new StageRegs();
		inline function addBinding( b : Int, type : DescriptorType, count : Int ) {
			bindings.push(b);
			bindings.push(type);
			bindings.push(count);
			bindings.push(stage);
		}
		function addWrite( b : Int, element : Int, type : DescriptorType ) {
			var slot = writes.length >> 2;
			writes.push(b);
			writes.push(element);
			writes.push(type);
			writes.push(0);
			return slot;
		}
		var dynCount = 0;
		var i = 2;
		while( i < writes.length ) {
			if( writes[i] == UNIFORM_BUFFER_DYNAMIC ) dynCount++;
			i += 4;
		}
		if( sh.globalsSize > 0 ) {
			addBinding(base + BIND_B, UNIFORM_BUFFER_DYNAMIC, 1);
			regs.globals = addWrite(base + BIND_B, 0, UNIFORM_BUFFER_DYNAMIC);
			regs.globalsDyn = dynCount++;
		}
		var pushOffset = getPushOffset(sh);
		if( pushOffset >= 0 ) {
			regs.pushOffset = pushOffset;
			regs.pushSize = sh.paramsSize << 4;
			regs.pushStage = stage;
		} else if( sh.paramsSize > 0 ) {
			addBinding(base + BIND_B + 1, UNIFORM_BUFFER_DYNAMIC, 1);
			regs.params = addWrite(base + BIND_B + 1, 0, UNIFORM_BUFFER_DYNAMIC);
			regs.paramsDyn = dynCount++;
		}
		var bReg = 2, tReg = 0, uReg = 0;
		var p = sh.buffers;
		while( p != null ) {
			switch( p.type ) {
			case TBuffer(_, _, kind):
				var b, type : DescriptorType;
				switch( kind ) {
				case Uniform: b = base + BIND_B + bReg++; type = UNIFORM_BUFFER;
				case Storage: b = base + BIND_T + tReg++; type = STORAGE_BUFFER;
				case RW: b = base + BIND_U + uReg++; type = STORAGE_BUFFER;
				default: throw "Unsupported buffer kind " + kind;
				}
				addBinding(b, type, 1);
				regs.buffers.push(addWrite(b, 0, type));
				regs.bufferTypes.push(kind);
			default:
				throw "assert";
			}
			p = p.next;
		}
		if( sh.texturesCount > 0 ) {
			var ctx = new hxsl.HlslOut.Samplers();
			var samplerBinding = base + BIND_S;
			var varRegs = new Map<Int, Int>();
			var varSamplers = new Map<Int, Array<Int>>();
			for( v in sh.data.vars )
				switch( v.type ) {
				case TArray(TRWTexture(_), SConst(n)):
					varRegs.set(v.id, base + BIND_U + uReg);
					addBinding(base + BIND_U + uReg, STORAGE_IMAGE, n);
					uReg += n;
				default:
				}
			for( v in sh.data.vars )
				switch( v.type ) {
				case TArray(TSampler(_), SConst(n)):
					varRegs.set(v.id, base + BIND_T + tReg);
					addBinding(base + BIND_T + tReg, SAMPLED_IMAGE, n);
					tReg += n;
					varSamplers.set(v.id, ctx.make(v, []));
				default:
				}
			if( ctx.count > 0 )
				addBinding(samplerBinding, SAMPLER, ctx.count);
			for( v in sh.data.vars )
				switch( v.type ) {
				case TArray(t = TSampler(_) | TRWTexture(_), SConst(n)):
					var b = varRegs.get(v.id);
					var smp = varSamplers.get(v.id);
					for( i in 0...n ) {
						regs.texTypes.push(t);
						if( smp != null ) {
							regs.texSlots.push(addWrite(b, i, SAMPLED_IMAGE));
							regs.samplerSlots.push(addWrite(samplerBinding, smp[i], SAMPLER));
						} else {
							regs.texSlots.push(addWrite(b, i, STORAGE_IMAGE));
							regs.samplerSlots.push(-1);
						}
					}
				default:
				}
		}
		return regs;
	}

	function compileShader( shader : hxsl.RuntimeShader ) : CompiledShader {
		#if heaps_mt_hxsl_cache
		compileMutex.acquire();
		var c = compiledShaders.get(shader.id);
		compileMutex.release();
		#else
		var c = compiledShaders.get(shader.id);
		#end
		if( c != null ) return c;
		if( shader.hasBindless() && !useBindless )
			throw "Shader using bindless detected, but Bindless is not available : call h3d.impl.Driver.requestFeature(Bindless) before creating the engine";
		var code = shader.mode == Compute ? [compileSource(shader, shader.compute)] : [compileSource(shader, shader.vertex), compileSource(shader, shader.fragment)];
		#if heaps_mt_hxsl_cache
		compileMutex.acquire();
		var created = !compiledShaders.exists(shader.id);
		var c = try createCompiledShader(shader, code) catch( e : haxe.Exception ) {
			compileMutex.release();
			throw e;
		}
		compileMutex.release();
		#else
		var created = true;
		var c = createCompiledShader(shader, code);
		#end
		if( created && psoConfigCache != null && !c.isCompute )
			resolvePSOConfig(c);
		return c;
	}

	function createCompiledShader( shader : hxsl.RuntimeShader, code : Array<haxe.io.Bytes> ) : CompiledShader {
		var c = compiledShaders.get(shader.id);
		if( c != null ) return c;
		c = new CompiledShader();
		c.shader = shader;
		c.isCompute = shader.mode == Compute;
		var bindings = [], writes = [];
		if( c.isCompute ) {
			c.vertexRegs = makeRegs(shader.compute, 0, ShaderStage.COMPUTE, bindings, writes);
		} else {
			c.vertexRegs = makeRegs(shader.vertex, 0, ShaderStage.VERTEX, bindings, writes);
			c.fragmentRegs = makeRegs(shader.fragment, BIND_FRAGMENT, ShaderStage.FRAGMENT, bindings, writes);
		}

		var bcount = bindings.length >> 2;
		var layoutBindings = hl.CArray.alloc(DescriptorSetLayoutBinding, bcount == 0 ? 1 : bcount);
		for( i in 0...bcount ) {
			var b = layoutBindings[i];
			b.binding = bindings[i * 4];
			b.descriptorType = cast bindings[i * 4 + 1];
			b.descriptorCount = bindings[i * 4 + 2];
			b.stageFlags = bindings[i * 4 + 3];
		}
		setLayoutInfo.bindingCount = bcount;
		setLayoutInfo.pBindings = layoutBindings;
		var r = SUCCESS;
		c.setLayout = Vk.descriptorSetLayoutCreate(setLayoutInfo, r);
		checkResult(r, "vkCreateDescriptorSetLayout");
		c.bindless = shader.hasBindless();
		pipelineSetLayouts[0].handle = c.setLayout;
		pipelineSetLayouts[1].handle = bindlessLayout;
		pipelineLayoutInfo.setLayoutCount = c.bindless ? 2 : 1;
		var ranges = hl.CArray.alloc(PushConstantRange, 2);
		var rangeCount = 0;
		for( regs in [c.vertexRegs, c.fragmentRegs] )
			if( regs != null && regs.pushSize > 0 ) {
				var pr = ranges[rangeCount++];
				pr.stageFlags = regs.pushStage;
				pr.offset = regs.pushOffset;
				pr.size = regs.pushSize;
			}
		if( rangeCount > 0 ) c.pushData = new hl.Bytes(PUSH_HALF << 1);
		pipelineLayoutInfo.pushConstantRangeCount = rangeCount;
		pipelineLayoutInfo.pPushConstantRanges = rangeCount == 0 ? null : ranges;
		c.layout = Vk.pipelineLayoutCreate(pipelineLayoutInfo, r);
		checkResult(r, "vkCreatePipelineLayout");

		c.writeCount = writes.length >> 2;
		c.dynCount = 0;
		for( i in 0...c.writeCount )
			if( writes[i * 4 + 2] == UNIFORM_BUFFER_DYNAMIC )
				c.dynCount++;
		c.dynOffsets = new hl.Bytes(c.dynCount == 0 ? 4 : c.dynCount << 2);
		var count = c.writeCount == 0 ? 1 : c.writeCount;
		c.writes = WriteDescriptorSet.alloc(count);
		c.imageInfos = hl.CArray.alloc(DescriptorImageInfo, count);
		c.bufferInfos = hl.CArray.alloc(DescriptorBufferInfo, count);
		for( i in 0...c.writeCount ) {
			var w = c.writes[i];
			w.dstBinding = writes[i * 4];
			w.dstArrayElement = writes[i * 4 + 1];
			w.descriptorCount = 1;
			w.descriptorType = cast writes[i * 4 + 2];
			switch( w.descriptorType ) {
			case UNIFORM_BUFFER, UNIFORM_BUFFER_DYNAMIC, STORAGE_BUFFER:
				w.pBufferInfo = c.bufferInfos[i];
				c.bufferInfos[i].range = VkConst.WHOLE_SIZE;
			default:
				w.pImageInfo = c.imageInfos[i];
			}
		}

		if( c.isCompute ) {
			var m = createShaderModule(code[0]);
			var ci = computeInfos[0];
			ci.stage.module = m;
			ci.layout = c.layout;
			var r = Vk.createComputePipelines(pipelineCache, 1, computeInfos, createdComputePipelines);
			Vk.shaderModuleDestroy(m);
			if( r != SUCCESS ) {
				checkResult(r, "vkCreateComputePipelines");
				throw "Failed to create compute pipeline";
			}
			c.computePipeline = createdComputePipelines[0].handle;
			compiledShaders.set(shader.id, c);
			return c;
		}

		c.vs = createShaderModule(code[0]);
		c.fs = createShaderModule(code[1]);

		var inputs = [];
		for( v in shader.vertex.data.vars )
			if( v.kind == Input )
				inputs.push(v);
		var format : Array<hxd.BufferFormat.BufferInput> = [];
		c.inputDivisors = [];
		c.usedInputs = getUsedInputs(code[0], inputs.length);
		for( v in inputs ) {
			var perInst = 0;
			if( v.qualifiers != null )
				for( q in v.qualifiers )
					switch( q ) {
					case PerInstance(k): perInst = k;
					default:
					}
			c.inputDivisors.push(perInst);
			format.push({ name : v.name, type : hxd.BufferFormat.InputFormat.fromHXSL(v.type) });
		}
		c.format = hxd.BufferFormat.make(format);
		c.inputCount = inputs.length;
		compiledShaders.set(shader.id, c);
		return c;
	}

	override function warmupShader( shader : hxsl.RuntimeShader ) {
		compileShader(shader);
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var sh = compileShader(shader);
		if( currentShader == sh )
			return false;
		currentShader = sh;
		needBind = true;
		pushDirty = true;
		boundUAVBuffers.resize(0);
		pipelineBuilder.setShader(shader);
		if( sh.isCompute )
			Vk.cmdBindPipeline(cmd, COMPUTE, sh.computePipeline);
		return true;
	}

	override function selectMaterial( pass : h3d.mat.Pass ) @:privateAccess {
		var depthClamp = pass.depthClamp;
		pass.depthClamp = depthClamp || useDepthClamp;
		pipelineBuilder.selectMaterial(pass);
		pass.depthClamp = depthClamp;
		if( matPass.bits != pass.bits )
			matPass.loadBits(pass.bits);
		var st = pass.stencil;
		matHasStencil = st != null;
		if( st != null ) matStencil.load(st);
		dynamicDirty = true;
	}

	function flushDynamicState() @:privateAccess {
		dynamicDirty = false;
		var pass = matPass;
		var hasDepth = rtDepthView != null;
		var writable = hasDepth && rtDepthLayout == DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
		var cull = pass.wireframe ? 0 : CULL[pass.culling.getIndex()];
		if( cull != curCull ) {
			curCull = cull;
			Vk.cmdSetCullMode(cmd, cull);
		}
		var test = hasDepth && pass.depthTest != Always ? 1 : 0;
		if( test != curDepthTest ) {
			curDepthTest = test;
			Vk.cmdSetDepthTestEnable(cmd, test == 1);
		}
		var write = writable && pass.depthWrite ? 1 : 0;
		if( write != curDepthWrite ) {
			curDepthWrite = write;
			Vk.cmdSetDepthWriteEnable(cmd, write == 1);
		}
		var compare = COMP[pass.depthTest.getIndex()];
		if( compare != curDepthCompare ) {
			curDepthCompare = compare;
			Vk.cmdSetDepthCompareOp(cmd, compare);
		}
		var biasEnable = matDepthBias != 0 || matSlopeBias != 0 ? 1 : 0;
		if( biasEnable != curBiasEnable ) {
			curBiasEnable = biasEnable;
			Vk.cmdSetDepthBiasEnable(cmd, biasEnable == 1);
		}
		if( biasEnable == 1 && (matDepthBias != curDepthBias || matSlopeBias != curSlopeBias) ) {
			curDepthBias = matDepthBias;
			curSlopeBias = matSlopeBias;
			Vk.cmdSetDepthBias(cmd, matDepthBias, 0, matSlopeBias);
		}
		var stencilTest = matHasStencil && hasDepth ? 1 : 0;
		if( stencilTest != curStencilTest ) {
			curStencilTest = stencilTest;
			Vk.cmdSetStencilTestEnable(cmd, stencilTest == 1);
		}
		if( stencilTest == 0 )
			return;
		var st = matStencil;
		var ops = (st.opBits << 1) | (writable ? 0 : 1);
		if( ops != curStencilOps ) {
			curStencilOps = ops;
			if( writable ) {
				Vk.cmdSetStencilOp(cmd, FRONT, STENCIL_OP[st.frontSTfail.getIndex()], STENCIL_OP[st.frontPass.getIndex()], STENCIL_OP[st.frontDPfail.getIndex()], COMP[st.frontTest.getIndex()]);
				Vk.cmdSetStencilOp(cmd, BACK, STENCIL_OP[st.backSTfail.getIndex()], STENCIL_OP[st.backPass.getIndex()], STENCIL_OP[st.backDPfail.getIndex()], COMP[st.backTest.getIndex()]);
			} else {
				// a read-only stencil attachment requires KEEP for every op
				Vk.cmdSetStencilOp(cmd, FRONT, 0, 0, 0, COMP[st.frontTest.getIndex()]);
				Vk.cmdSetStencilOp(cmd, BACK, 0, 0, 0, COMP[st.backTest.getIndex()]);
			}
		}
		var masks = st.maskBits;
		if( masks != curStencilMasks ) {
			curStencilMasks = masks;
			Vk.cmdSetStencilCompareMask(cmd, FRONT_AND_BACK, st.readMask);
			Vk.cmdSetStencilWriteMask(cmd, FRONT_AND_BACK, st.writeMask);
			if( st.reference != curStencilRef ) {
				curStencilRef = st.reference;
				Vk.cmdSetStencilReference(cmd, FRONT_AND_BACK, st.reference);
			}
		}
	}

	static var CULL = [0, 2, 1, 3];
	static var COMP = [7, 0, 2, 5, 4, 6, 1, 3];
	static var BLEND_OP = [0, 1, 2, 3, 4];
	static var BLEND = [1, 0, 6, 2, 8, 4, 7, 3, 9, 5, 15, 17, 16, 18, 14];
	static var BLEND_ALPHA = [1, 0, 6, 6, 8, 8, 7, 7, 9, 9, 17, 17, 18, 18, 14];
	static var STENCIL_OP = [0, 1, 2, 3, 6, 4, 7, 5];

	function makePipeline( shader : CompiledShader, builder : PipelineCache.PipelineBuilder ) {
		var pass = builder.getCurrentPass();
		var depth = builder.getDepthProps();
		var hasDepth = depth.format != null;

		var p = pipelineInfos[0];
		p.layout = shader.layout;
		pipelineStages[0].module = shader.vs;
		pipelineStages[1].module = shader.fs;

		var rs = rasterizationState;
		rs.polygonMode = pass.wireframe ? 1 : 0;
		rs.depthClampEnable = @:privateAccess pass.depthClamp ? 1 : 0;

		var rtCount = builder.getRenderTargetsCount();
		colorBlendState.attachmentCount = rtCount;
		renderingState.colorAttachmentCount = rtCount;
		for( i in 0...rtCount ) {
			colorFormats.setI32(i << 2, toVkFormat(builder.getRenderTargetFormat(i)));
			var b = colorBlendAttachments[i];
			b.blendEnable = pass.blendSrc != One || pass.blendDst != Zero ? 1 : 0;
			b.srcColorBlendFactor = BLEND[pass.blendSrc.getIndex()];
			b.dstColorBlendFactor = BLEND[pass.blendDst.getIndex()];
			b.colorBlendOp = BLEND_OP[pass.blendOp.getIndex()];
			b.srcAlphaBlendFactor = BLEND_ALPHA[pass.blendAlphaSrc.getIndex()];
			b.dstAlphaBlendFactor = BLEND_ALPHA[pass.blendAlphaDst.getIndex()];
			b.alphaBlendOp = BLEND_OP[pass.blendAlphaOp.getIndex()];
			b.colorWriteMask = pass.colorMask;
		}
		var dfmt : Format = hasDepth ? toVkDepthFormat(depth.format) : Format.UNDEFINED;
		renderingState.depthAttachmentFormat = dfmt;
		renderingState.stencilAttachmentFormat = hasStencil(dfmt) ? dfmt : Format.UNDEFINED;

		if( shader.inputCount > MAX_VERTEX_INPUTS ) throw "Too many vertex inputs";
		var attribCount = 0;
		for( i in 0...shader.inputCount ) {
			var inf = builder.getBufferInput(i);
			var fmt : Format = @:privateAccess switch( [shader.format.inputs[i].type, inf.precision] ) {
			case [DFloat, F32]: R32_SFLOAT;
			case [DFloat, F16]: R16_SFLOAT;
			case [DFloat, S8]: R8_SNORM;
			case [DFloat, U8]: R8_UNORM;
			case [DVec2, F32]: R32G32_SFLOAT;
			case [DVec2, F16]: R16G16_SFLOAT;
			case [DVec2, S8]: R8G8_SNORM;
			case [DVec2, U8]: R8G8_UNORM;
			case [DVec3, F32]: R32G32B32_SFLOAT;
			case [DVec3, F16]: R16G16B16A16_SFLOAT;
			case [DVec3, S8]: R8G8B8A8_SNORM;
			case [DVec3, U8]: R8G8B8A8_UNORM;
			case [DVec4, F32]: R32G32B32A32_SFLOAT;
			case [DVec4, F16]: R16G16B16A16_SFLOAT;
			case [DVec4, S8]: R8G8B8A8_SNORM;
			case [DVec4, U8]: R8G8B8A8_UNORM;
			case [DBytes4, _]: R8G8B8A8_UINT;
			default: throw "assert";
			};
			var b = vertexBindings[i];
			b.binding = i;
			b.stride = 0; // dynamic state
			b.inputRate = shader.inputDivisors[i] > 0 ? 1 : 0;
			if( !shader.usedInputs[i] ) continue;
			var a = vertexAttributes[attribCount++];
			a.location = i;
			a.binding = i;
			a.format = fmt;
			a.offset = inf.offset;
		}
		vertexInputState.vertexBindingDescriptionCount = shader.inputCount;
		vertexInputState.vertexAttributeDescriptionCount = attribCount;

		var r = Vk.createGraphicsPipelines(pipelineCache, 1, pipelineInfos, createdPipelines);
		if( r != SUCCESS ) {
			if( r == ERROR_DEVICE_LOST ) hasDeviceError = true;
			return null;
		}
		return createdPipelines[0].handle;
	}

	function resolvePSOConfig( c : CompiledShader ) {
		psoConfigCache.resolveConfig(c.shader, c.inputCount, function(builder) {
			#if heaps_mt_hxsl_cache
			pipelineMutex.acquire();
			#end
			var cache = builder.lookup(c.pipelines, c.inputCount);
			if( cache.pipeline == null ) {
				var p = try makePipeline(c, builder) catch( e : Dynamic ) {
					trace('Skipping invalid PSO config for ${c.shader.signature}: $e');
					null;
				}
				if( p != null ) {
					cache.pipeline = p;
					hxd.System.timeoutTick();
				}
			}
			#if heaps_mt_hxsl_cache
			pipelineMutex.release();
			#end
		});
	}

	function flushPipeline() {
		if( !pipelineBuilder.needFlush )
			return true;
		#if heaps_mt_hxsl_cache
		pipelineMutex.acquire();
		#end
		var cache = pipelineBuilder.lookup(currentShader.pipelines, currentShader.inputCount);
		if( cache.pipeline == null ) {
			var p = makePipeline(currentShader, pipelineBuilder);
			#if pso_cache_verbose
			trace('Pipeline cache miss: $cache [${currentShader.shader.signature}]\n${currentShader.pipelines.diff(cache)}');
			#end
			if( p != null ) {
				cache.pipeline = p;
				psoConfigCache?.addConfig(currentShader.shader, cache);
			}
		}
		#if heaps_mt_hxsl_cache
		pipelineMutex.release();
		#end
		if( cache.pipeline == null ) {
			trace('Failed to create pipeline for ${currentShader.shader.signature}');
			return false;
		}
		if( currentPipeline != cache.pipeline ) {
			currentPipeline = cache.pipeline;
			Vk.cmdBindPipeline(cmd, GRAPHICS, currentPipeline);
		}
		return true;
	}

	function allocDescriptorSet( layout : DescriptorSetLayout ) : DescriptorSet {
		setLayouts[0].handle = layout;
		while( true ) {
			if( frame.descPoolIndex >= frame.descPools.length ) {
				var r = SUCCESS;
				var pool = Vk.descriptorPoolCreate(descriptorPoolInfo, r);
				if( !checkResult(r, "vkCreateDescriptorPool") ) return null;
				frame.descPools.push(pool);
			}
			descriptorSetAlloc.descriptorPool = frame.descPools[frame.descPoolIndex];
			var r = Vk.allocateDescriptorSets(descriptorSetAlloc, descriptorSets);
			if( r == SUCCESS ) return descriptorSets[0].handle;
			if( r != ERROR_OUT_OF_POOL_MEMORY && r != ERROR_FRAGMENTED_POOL ) {
				checkResult(r, "vkAllocateDescriptorSets");
				return null;
			}
			frame.descPoolIndex++;
		}
	}

	inline function pushConstants( sh : CompiledShader, regs : StageRegs ) {
		if( regs != null && regs.pushSize > 0 )
			Vk.cmdPushConstants(cmd, sh.layout, regs.pushStage, regs.pushOffset, regs.pushSize, sh.pushData.offset(regs.pushOffset));
	}

	function flushDescriptors() {
		var sh = currentShader;
		if( pushDirty && sh.pushData != null ) {
			pushDirty = false;
			pushConstants(sh, sh.vertexRegs);
			pushConstants(sh, sh.fragmentRegs);
		}
		if( sh.writeCount == 0 && !sh.bindless ) return;
		if( sh.dirty || sh.setGeneration != descriptorGeneration ) {
			var set = allocDescriptorSet(sh.setLayout);
			if( set == null ) return;
			for( i in 0...sh.writeCount )
				sh.writes[i].dstSet = set;
			if( sh.writeCount > 0 )
				Vk.updateDescriptorSets(sh.writeCount, sh.writes, 0, null);
			sh.set = set;
			sh.setGeneration = descriptorGeneration;
			sh.dirty = false;
			needBind = true;
		}
		if( !needBind ) return;
		needBind = false;
		descriptorSets[0].handle = sh.set;
		descriptorSets[1].handle = frame.bindlessSet;
		Vk.cmdBindDescriptorSets(cmd, sh.isCompute ? COMPUTE : GRAPHICS, sh.layout, 0, sh.bindless ? 2 : 1, descriptorSets, sh.dynCount, sh.dynOffsets);
	}

	// ---- SHADER BUFFERS

	override function uploadShaderBuffers( buffers : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		if( which == Buffers )
			boundUAVBuffers.resize(0);
		if( currentShader.isCompute ) {
			uploadBuffers(buffers, buffers.vertex, which, currentShader.shader.compute, currentShader.vertexRegs);
			return;
		}
		uploadBuffers(buffers, buffers.vertex, which, currentShader.shader.vertex, currentShader.vertexRegs);
		uploadBuffers(buffers, buffers.fragment, which, currentShader.shader.fragment, currentShader.fragmentRegs);
	}

	function uploadConstants( data : hl.Bytes, size : Int, slot : Int, dyn : Int ) {
		var a = frame.allocator;
		a.alloc(size, uniformAlign);
		a.ptr.blit(0, data, 0, size);
		var sh = currentShader;
		var b = sh.bufferInfos[slot];
		var page = a.resource.handle;
		if( b.buffer != page ) {
			b.buffer = page;
			b.offset = 0;
			b.range = size;
			sh.dirty = true;
		}
		sh.dynOffsets.setI32(dyn << 2, a.offset);
		needBind = true;
	}

	function uploadBuffers( buffers : h3d.shader.Buffers, buf : h3d.shader.Buffers.ShaderBuffers, which : h3d.shader.Buffers.BufferKind, shader : hxsl.RuntimeShader.RuntimeShaderData, regs : StageRegs ) {
		switch( which ) {
		case Params:
			if( regs.pushSize > 0 ) {
				currentShader.pushData.blit(regs.pushOffset, hl.Bytes.getArray(buf.params.toData()), 0, regs.pushSize);
				pushDirty = true;
			} else if( regs.params >= 0 )
				uploadConstants(hl.Bytes.getArray(buf.params.toData()), shader.paramsSize << 4, regs.params, regs.paramsDyn);
			for( i in 0...shader.paramsTexHandleCount )
				selectTextureHandle(buf.texHandles[i]);
			for( i in 0...shader.paramsBufHandleCount )
				selectBufferHandle(buf.bufHandles[i]);
		case Globals:
			if( regs.globals >= 0 )
				uploadConstants(hl.Bytes.getArray(buf.globals.toData()), shader.globalsSize << 4, regs.globals, regs.globalsDyn);
			for( i in shader.paramsTexHandleCount...shader.paramsTexHandleCount + shader.globalsTexHandleCount )
				selectTextureHandle(buf.texHandles[i]);
			for( i in shader.paramsBufHandleCount...shader.paramsBufHandleCount + shader.globalsBufHandleCount )
				selectBufferHandle(buf.bufHandles[i]);
		case Textures:
			for( i in 0...shader.texturesCount ) {
				var t = buf.tex[i];
				var pt = regs.texTypes[i];
				if( t == null || t.isDisposed() ) {
					switch( pt ) {
					case TSampler(TCube, _):
						t = h3d.mat.Texture.defaultCubeTexture();
					case TSampler(_, false):
						var color = h3d.mat.Defaults.loadingTextureColor;
						t = h3d.mat.Texture.fromColor(color, (color >>> 24) / 255);
					default:
						t = errorTex;
					}
				}
				if( t.t == null && t.realloc != null ) {
					var s = currentShader;
					t.alloc();
					t.realloc();
					if( hasDeviceError ) return;
					if( s != currentShader ) {
						// realloc triggered a shader change, reupload everything
						currentShader = null;
						selectShader(s.shader);
						uploadShaderBuffers(buffers, Globals);
						uploadShaderBuffers(buffers, Params);
						uploadShaderBuffers(buffers, Textures);
						return;
					}
				}
				t.lastFrame = frameCount;
				var sh = currentShader;
				var img = sh.imageInfos[regs.texSlots[i]];
				var view, layout : ImageLayout;
				switch( pt ) {
				case TRWTexture(dim, arr, _):
					if( !t.flags.has(Writable) )
						throw "Texture was allocated without Writable flag";
					t.flags.set(WasCleared);
					transition(t.t, UAV);
					view = getUAVView(t, dim, arr);
					layout = GENERAL;
				default:
					if( !(t.t.isDepth && t.t.state == DEPTH_READ) )
						transition(t.t, SHADER_READ);
					view = getSRV(t, pt.match(TSampler(_, true)));
					layout = layoutOf(t.t, SHADER_READ);
					var smp = sh.imageInfos[regs.samplerSlots[i]];
					var s = getSampler(t);
					if( smp.sampler != s ) {
						smp.sampler = s;
						sh.dirty = true;
					}
				}
				if( img.imageView != view || img.imageLayout != layout ) {
					img.imageView = view;
					img.imageLayout = layout;
					sh.dirty = true;
				}
			}
		case Buffers:
			for( i in 0...shader.bufferCount ) {
				var b = buf.buffers[i];
				var vbuf = b.vbuf;
				if( vbuf == null ) continue;
				var w = currentShader.bufferInfos[regs.buffers[i]];
				var range : hl.I64 = VkConst.WHOLE_SIZE;
				switch( regs.bufferTypes[i] ) {
				case Uniform:
					if( !b.flags.has(UniformBuffer) )
						throw "Buffer was allocated without UniformBuffer flag";
					transition(vbuf, READ, shaderStage(shader));
					range = vbuf.size > limits.maxUniformBufferRange ? limits.maxUniformBufferRange : vbuf.size;
				case Storage:
					transition(vbuf, READ, shaderStage(shader));
				case RW:
					if( !b.flags.has(ReadWriteBuffer) )
						throw "Buffer was allocated without ReadWriteBuffer flag";
					transition(vbuf, UAV, shaderStage(shader));
					boundUAVBuffers.push(vbuf);
				default:
					throw "assert";
				}
				if( w.buffer != vbuf.handle || w.range != range ) {
					w.buffer = vbuf.handle;
					w.offset = 0;
					w.range = range;
					currentShader.dirty = true;
				}
			}
		}
	}

	static function shaderStage( sh : hxsl.RuntimeShader.RuntimeShaderData ) : Int {
		return switch( sh.kind ) {
		case Vertex: PipelineStage.VERTEX_SHADER;
		case Fragment: PipelineStage.FRAGMENT_SHADER;
		default: PipelineStage.COMPUTE_SHADER;
		}
	}

	override function flushShaderBuffers() {
	}

	// ---- DRAW

	override function selectBuffer( buffer : h3d.Buffer ) {
		var map = buffer.format.resolveMapping(currentShader.format);
		var vbuf = buffer.vbuf;
		var stride = buffer.format.strideBytes;
		for( i in 0...currentShader.inputCount ) {
			vertexBuffers[i].handle = vbuf.handle;
			vbStrides[i].value = stride;
			pipelineBuilder.setBuffer(i, map[i], stride);
		}
		transition(vbuf, READ, PipelineStage.VERTEX_INPUT);
		if( currentShader.inputCount > 0 )
			Vk.cmdBindVertexBuffers2(cmd, 0, currentShader.inputCount, vertexBuffers, vbOffsets, null, vbStrides);
	}

	override function selectMultiBuffers( formats : hxd.BufferFormat.MultiFormat, buffers : Array<h3d.Buffer> ) {
		var map = formats.resolveMapping(currentShader.format);
		for( i in 0...map.length ) {
			var inf = map[i];
			var b = buffers[inf.bufferIndex];
			var stride = b.format.strideBytes;
			vertexBuffers[i].handle = b.vbuf.handle;
			vbStrides[i].value = stride;
			transition(b.vbuf, READ, PipelineStage.VERTEX_INPUT);
			pipelineBuilder.setBuffer(i, inf, stride);
		}
		if( map.length > 0 )
			Vk.cmdBindVertexBuffers2(cmd, 0, map.length, vertexBuffers, vbOffsets, null, vbStrides);
	}

	function prepareDraw( ibuf : h3d.Buffer ) {
		if( scissorW <= 0 || scissorH <= 0 )
			return false;
		if( !flushPipeline() )
			return false;
		if( dynamicDirty )
			flushDynamicState();
		if( currentIndex != ibuf ) {
			currentIndex = ibuf;
			transition(ibuf.vbuf, READ, PipelineStage.VERTEX_INPUT);
			Vk.cmdBindIndexBuffer(cmd, ibuf.vbuf.handle, 0, ibuf.vbuf.is32 ? UINT32 : UINT16);
		}
		return true;
	}

	inline function stampUAVBuffers() {
		for( b in boundUAVBuffers )
			b.uavEpoch = uavBarrierEpoch;
	}

	override function draw( ibuf : h3d.Buffer, startIndex : Int, ntriangles : Int ) {
		if( !prepareDraw(ibuf) )
			return;
		flushTransitions();
		stampUAVBuffers();
		flushDescriptors();
		beginRendering();
		Vk.cmdDrawIndexed(cmd, ntriangles * 3, 1, startIndex, 0, 0);
	}

	override function drawInstanced( ibuf : h3d.Buffer, commands : h3d.impl.InstanceBuffer ) {
		if( !prepareDraw(ibuf) )
			return;
		@:privateAccess {
			if( commands.data != null ) {
				transition(commands.data, READ, PipelineStage.DRAW_INDIRECT);
				if( commands.countBuffer != null )
					transition(commands.countBuffer, READ, PipelineStage.DRAW_INDIRECT);
			}
			flushTransitions();
			stampUAVBuffers();
			flushDescriptors();
			beginRendering();
			if( commands.data == null )
				Vk.cmdDrawIndexed(cmd, commands.indexCount, commands.commandCount, commands.startIndex, 0, 0);
			else if( commands.countBuffer != null )
				Vk.cmdDrawIndexedIndirectCount(cmd, commands.data.handle, commands.offset * InstanceBuffer.ELEMENT_SIZE, commands.countBuffer.handle, commands.countOffset * 4, commands.commandCount, InstanceBuffer.ELEMENT_SIZE);
			else
				Vk.cmdDrawIndexedIndirect(cmd, commands.data.handle, commands.offset * InstanceBuffer.ELEMENT_SIZE, commands.commandCount, InstanceBuffer.ELEMENT_SIZE);
		}
	}

	override function computeDispatch( x : Int = 1, y : Int = 1, z : Int = 1, barrier : Bool = true ) {
		endRendering();
		flushTransitions();
		stampUAVBuffers();
		flushDescriptors();
		Vk.cmdDispatch(cmd, x, y, z);
		if( barrier )
			memoryBarrier();
	}

	override function memoryBarrier() {
		needUAVBarrier = true;
	}

	// ---- BUFFERS

	static inline function calcCBVSize( size : Int ) {
		return (size + 0xFF) & ~0xFF;
	}

	static inline var BUFFER_USAGE = BufferUsage.TRANSFER_SRC | BufferUsage.TRANSFER_DST | BufferUsage.VERTEX | BufferUsage.INDEX | BufferUsage.UNIFORM | BufferUsage.STORAGE | BufferUsage.INDIRECT;

	function createBuffer( size : Int, name : String ) {
		var b = new BufferData();
		b.buffer = createVkBuffer(size, BUFFER_USAGE, GPU);
		if( b.buffer == null ) return null;
		b.handle = Vk.bufferGetHandle(b.buffer);
		Vk.bufferSetName(b.buffer, name);
		b.size = size;
		return b;
	}

	override function allocBuffer( m : h3d.Buffer ) : GPUBuffer {
		var size = m.getMemSize();
		if( m.flags.has(UniformBuffer) || m.flags.has(ReadWriteBuffer) ) size = calcCBVSize(size);
		if( size == 0 ) size = 4;
		var b = createBuffer(size, 'Buffer#${m.id}');
		if( b == null ) return null;
		b.is32 = m.format.strideBytes == 4;
		return b;
	}

	override function disposeBuffer( b : h3d.Buffer ) {
		var v = b.vbuf;
		if( v == null ) return;
		frame.toRelease.push(GBuffer(v.buffer));
		v.buffer = null;
		if( v.bindless != null ) {
			frame.bufHandlesToRelease.push(v.bindless);
			v.bindless = null;
		}
	}

	override function allocInstanceBuffer( b : h3d.impl.InstanceBuffer, bytes : haxe.io.Bytes ) {
		var size = b.commandCount * InstanceBuffer.ELEMENT_SIZE;
		var buf = allocCheck(() -> createBuffer(size, "InstanceBuffer"));
		updateBuffer(buf, @:privateAccess bytes.b, 0, size);
		@:privateAccess b.data = buf;
	}

	override function uploadInstanceBufferBytes( b : h3d.impl.InstanceBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride = InstanceBuffer.ELEMENT_SIZE;
		updateBuffer(@:privateAccess b.data, @:privateAccess buf.b.offset(bufPos), startVertex * stride, vertexCount * stride);
	}

	override function disposeInstanceBuffer( b : h3d.impl.InstanceBuffer ) @:privateAccess {
		if( b.data == null ) return;
		frame.toRelease.push(GBuffer(b.data.buffer));
		b.data.buffer = null;
		b.data = null;
	}

	function updateBuffer( b : BufferData, data : hl.Bytes, startByte : Int, bytesCount : Int ) {
		if( hasDeviceError || bytesCount <= 0 ) return;
		if( b == null ) throw "Updating buffer which was not allocated";
		var a = frame.allocator;
		a.alloc(bytesCount, 16);
		a.ptr.blit(0, data, 0, bytesCount);
		transition(b, COPY_DST);
		flushForTransfer();
		copyBuffer(a.resource.handle, a.offset, b.handle, startByte, bytesCount);
	}

	override function uploadIndexData( i : h3d.Buffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var bits = i.format.strideBytes >> 1;
		updateBuffer(i.vbuf, hl.Bytes.getArray(buf.getNative()).offset(bufPos << bits), startIndice << bits, indiceCount << bits);
	}

	override function uploadBufferData( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var data = hl.Bytes.getArray(buf.getNative()).offset(bufPos << 2);
		updateBuffer(b.vbuf, data, startVertex * b.format.strideBytes, vertexCount * b.format.strideBytes);
	}

	override function uploadBufferBytes( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		updateBuffer(b.vbuf, @:privateAccess buf.b.offset(bufPos), startVertex * b.format.strideBytes, vertexCount * b.format.strideBytes);
	}

	function copyToReadback( b : h3d.Buffer, startVertex : Int, vertexCount : Int ) {
		var stride = b.format.strideBytes;
		var size = vertexCount * stride;
		var tmp = allocCheck(() -> createVkBuffer(size, BufferUsage.TRANSFER_DST, READBACK));
		transition(b.vbuf, COPY_SRC);
		flushForTransfer();
		copyBuffer(b.vbuf.handle, startVertex * stride, Vk.bufferGetHandle(tmp), 0, size);
		return tmp;
	}

	override function readBufferBytes( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var size = vertexCount * b.format.strideBytes;
		if( size <= 0 ) return;
		var tmp = copyToReadback(b, startVertex, vertexCount);
		submitAndWait();
		@:privateAccess buf.b.blit(bufPos, Vk.bufferGetMapped(tmp), 0, size);
		Vk.bufferDestroy(tmp);
	}

	override function readBufferBytesAsync( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int, callback : Void -> Void ) {
		var r = new AsyncRead();
		r.size = vertexCount * b.format.strideBytes;
		r.tmp = copyToReadback(b, startVertex, vertexCount);
		r.buf = buf;
		r.bufPos = bufPos;
		r.callback = callback;
		frame.asyncReads.push(r);
	}

	// ---- TEXTURES

	static function toVkFormat( fmt : hxd.PixelFormat ) : Format {
		return switch( fmt ) {
		case null: R8G8B8A8_UNORM;
		case RGBA: R8G8B8A8_UNORM;
		case RGBA16F: R16G16B16A16_SFLOAT;
		case RGBA32F: R32G32B32A32_SFLOAT;
		case R32F: R32_SFLOAT;
		case R16F: R16_SFLOAT;
		case R8: R8_UNORM;
		case RG8: R8G8_UNORM;
		case RG16F: R16G16_SFLOAT;
		case RG32F: R32G32_SFLOAT;
		case RGB32F: R32G32B32_SFLOAT;
		case RGB10A2: A2B10G10R10_UNORM_PACK32;
		case RG11B10UF: B10G11R11_UFLOAT_PACK32;
		case SRGB_ALPHA: R8G8B8A8_SRGB;
		case R16U: R16_UNORM;
		case RG16U: R16G16_UNORM;
		case RGBA16U: R16G16B16A16_UNORM;
		case S3TC(n):
			switch( n ) {
			case 1: BC1_RGBA_UNORM_BLOCK;
			case 2: BC2_UNORM_BLOCK;
			case 3: BC3_UNORM_BLOCK;
			case 4: BC4_UNORM_BLOCK;
			case 5: BC5_UNORM_BLOCK;
			case 6: BC6H_UFLOAT_BLOCK;
			case 7: BC7_UNORM_BLOCK;
			default: throw "assert";
			}
		default: throw "Unsupported texture format " + fmt;
		}
	}

	function toVkDepthFormat( fmt : hxd.PixelFormat ) : Format {
		return switch( fmt ) {
		case Depth16: D16_UNORM;
		case Depth24, Depth24Stencil8: depthStencilFormat;
		case Depth32: D32_SFLOAT;
		case Depth32Stencil8: D32_SFLOAT_S8_UINT;
		default: throw "Unsupported depth format " + fmt;
		}
	}

	static inline function hasStencil( f : Format ) {
		return f == D24_UNORM_S8_UINT || f == D32_SFLOAT_S8_UINT;
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		var rmip = t.residentMip;
		if( t.format.match(S3TC(_)) && ((t.width >> rmip) & 3 != 0 || (t.height >> rmip) & 3 != 0) )
			throw t + " is compressed " + t.width + "x" + t.height + " but should be a 4x4 multiple";
		if( t.width < 1 ) @:privateAccess t.width = 1;
		if( t.height < 1 ) @:privateAccess t.height = 1;
		var is3D = t.flags.has(Is3D);
		var isRT = t.flags.has(Target);
		var d = imageInfo;
		d.flags = (t.flags.has(Cube) ? ImageCreateFlags.CUBE_COMPATIBLE : 0) | (is3D && isRT ? ImageCreateFlags.ARRAY_2D_COMPATIBLE : 0);
		d.imageType = is3D ? TYPE_3D : TYPE_2D;
		d.format = toVkFormat(t.format);
		d.extent.set(hxd.Math.imax(1, t.width >> rmip), hxd.Math.imax(1, t.height >> rmip), is3D ? t.layerCount : 1);
		d.mipLevels = t.mipLevels - rmip;
		d.arrayLayers = getImageLayers(t);
		d.usage = ImageUsage.SAMPLED | ImageUsage.TRANSFER_SRC | ImageUsage.TRANSFER_DST | (isRT ? ImageUsage.COLOR_ATTACHMENT : 0) | (t.flags.has(Writable) ? ImageUsage.STORAGE : 0);
		var img = createVkImage(d, isRT);
		if( img == null ) return null;
		Vk.imageSetName(img, t.name == null ? "Texture#" + t.id : t.name);
		var td = new TextureData();
		td.image = img;
		td.handle = Vk.imageGetHandle(img);
		td.format = d.format;
		td.aspect = ImageAspect.COLOR;
		t.lastFrame = frameCount;
		t.flags.unset(WasCleared);
		if( useBindless ) refreshTextureHandles(t, td);
		return td;
	}

	override function allocDepthBuffer( b : h3d.mat.Texture ) : Texture {
		var fmt = toVkDepthFormat(b.format);
		var d = imageInfo;
		d.flags = b.flags.has(Cube) ? ImageCreateFlags.CUBE_COMPATIBLE : 0;
		d.imageType = TYPE_2D;
		d.format = fmt;
		d.extent.set(b.width < 1 ? 1 : b.width, b.height < 1 ? 1 : b.height, 1);
		d.mipLevels = 1;
		d.arrayLayers = getImageLayers(b);
		d.usage = ImageUsage.DEPTH_STENCIL_ATTACHMENT | ImageUsage.SAMPLED | ImageUsage.TRANSFER_SRC | ImageUsage.TRANSFER_DST;
		var img = createVkImage(d, true);
		if( img == null ) return null;
		Vk.imageSetName(img, b.name == null ? "Depth#" + b.id : b.name);
		var td = new TextureData();
		td.image = img;
		td.handle = Vk.imageGetHandle(img);
		td.format = fmt;
		td.isDepth = true;
		td.hasStencil = hasStencil(fmt);
		td.aspect = td.hasStencil ? ImageAspect.DEPTH_STENCIL : ImageAspect.DEPTH;
		if( useBindless ) refreshTextureHandles(b, td);
		return td;
	}

	function createVkImage( d : ImageCreateInfo, isTarget : Bool ) {
		d.samples = 1;
		d.tiling = OPTIMAL;
		d.sharingMode = EXCLUSIVE;
		d.initialLayout = UNDEFINED;
		var a = imageAlloc;
		a.usage = AUTO_PREFER_DEVICE;
		a.priority = isTarget ? 1 : 0;
		var r = SUCCESS;
		var img = Vk.imageCreate(d, a, r);
		if( img == null && !isOutOfMemory(r) )
			throw "vmaCreateImage failed (VkResult " + r + ")";
		return img;
	}

	function createView( td : TextureData, type : ImageViewType, aspect : Int, baseMip : Int, mipCount : Int, baseLayer : Int, layerCount : Int ) {
		var v = viewInfo;
		v.image = td.handle;
		v.viewType = type;
		v.format = td.format;
		var s = v.subresourceRange;
		s.aspectMask = aspect;
		s.baseMipLevel = baseMip;
		s.levelCount = mipCount;
		s.baseArrayLayer = baseLayer;
		s.layerCount = layerCount;
		var r = SUCCESS;
		var view = Vk.imageViewCreate(v, r);
		checkResult(r, "vkCreateImageView");
		return view;
	}

	function disposeTextureData( td : TextureData ) {
		var out = frame == null ? [] : frame.toRelease;
		td.disposeViews(out);
		if( td.image != null ) out.push(GImage(td.image));
		td.image = null;
		if( frame == null ) releaseGarbage(out);
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		if( t.t == null ) return;
		disposeTextureData(t.t);
		if( useBindless ) releaseTextureHandles(t);
		t.t = null;
	}

	override function disposeDepthBuffer( t : h3d.mat.Texture ) {
		if( t.t == null ) return;
		disposeTextureData(t.t);
		if( useBindless ) releaseTextureHandles(t);
		t.t = null;
	}

	override function setResidentMip( t : h3d.mat.Texture, mip : Int ) : Bool {
		var prev = t.t;
		var prevMip = t.residentMip;
		var wasCleared = t.flags.has(WasCleared);
		t.residentMip = mip;
		var td = allocTexture(t);
		if( wasCleared ) t.flags.set(WasCleared);
		if( td == null ) {
			t.residentMip = prevMip;
			return false;
		}
		transition(prev, COPY_SRC);
		transition(td, COPY_DST);
		flushForTransfer();
		var c = imageCopy;
		c.srcImage = prev.handle;
		c.dstImage = td.handle;
		var r = c.pRegions[0];
		var first = mip > prevMip ? mip : prevMip;
		for( m in first...t.mipLevels ) {
			var s = r.srcSubresource;
			s.aspectMask = ImageAspect.COLOR;
			s.mipLevel = m - prevMip;
			s.baseArrayLayer = 0;
			s.layerCount = getImageLayers(t);
			var d = r.dstSubresource;
			d.aspectMask = ImageAspect.COLOR;
			d.mipLevel = m - mip;
			d.baseArrayLayer = 0;
			d.layerCount = s.layerCount;
			r.extent.set(hxd.Math.imax(1, t.width >> m), hxd.Math.imax(1, t.height >> m), 1);
			Vk.cmdCopyImage2(cmd, c);
		}
		disposeTextureData(prev);
		t.t = td;
		t.lastFrame = frameCount;
		return true;
	}

	static function getImageLayers( t : h3d.mat.Texture ) {
		if( t.flags.has(Is3D) ) return 1;
		if( t.flags.has(Cube) && t.flags.has(IsArray) ) return t.layerCount * 6;
		return t.layerCount;
	}

	function getTexMask() {
		return h3d.mat.Texture.__startingMip_mask | h3d.mat.Texture.slice_mask;
	}

	function getSRV( t : h3d.mat.Texture, asArray = false ) : ImageView {
		var td = t.t;
		var key = @:privateAccess t.bits & getTexMask();
		if( asArray ) key |= 1 << 30;
		if( td.srvViews == null ) td.srvViews = [];
		var v = td.srvViews.get(key);
		if( v != null ) return v;
		var type : ImageViewType, base = 0, count = 1;
		if( t.slice > 0 ) {
			type = asArray ? TYPE_2D_ARRAY : TYPE_2D;
			base = t.slice - 1;
		} else if( t.flags.has(Cube) ) {
			type = asArray || t.flags.has(IsArray) ? CUBE_ARRAY : CUBE;
			count = getImageLayers(t);
		} else if( t.flags.has(IsArray) ) {
			type = TYPE_2D_ARRAY;
			count = t.layerCount;
		} else if( t.flags.has(Is3D) )
			type = TYPE_3D;
		else
			type = asArray ? TYPE_2D_ARRAY : TYPE_2D;
		var mip = t.startingMip > t.residentMip ? t.startingMip - t.residentMip : 0;
		v = createView(td, type, td.isDepth ? ImageAspect.DEPTH : ImageAspect.COLOR, mip, VkConst.IGNORED, base, count);
		td.srvViews.set(key, v);
		return v;
	}

	function getRTView( t : h3d.mat.Texture, layer : Int, mip : Int ) : ImageView {
		var td = t.t;
		var key = mip | (layer << 8);
		if( td.rtViews == null ) td.rtViews = [];
		var v = td.rtViews.get(key);
		if( v != null ) return v;
		v = createView(td, TYPE_2D, ImageAspect.COLOR, mip, 1, layer, 1);
		td.rtViews.set(key, v);
		return v;
	}

	function getDepthView( t : h3d.mat.Texture, layer : Int ) : ImageView {
		var td = t.t;
		if( td.depthViews == null ) td.depthViews = [];
		var v = td.depthViews.get(layer);
		if( v != null ) return v;
		v = createView(td, TYPE_2D, td.aspect, 0, 1, layer, 1);
		td.depthViews.set(layer, v);
		return v;
	}

	function getUAVView( t : h3d.mat.Texture, dim : hxsl.Ast.TexDimension, arr : Bool ) : ImageView {
		var td = t.t;
		var type : ImageViewType = switch( [dim, arr] ) {
		case [T1D, false]: TYPE_1D;
		case [T2D, false]: TYPE_2D;
		case [T3D, false]: TYPE_3D;
		case [T1D, true]: TYPE_1D_ARRAY;
		case [T2D, true]: TYPE_2D_ARRAY;
		default: throw "Unsupported RWTexture " + t;
		}
		var key = t.startingMip | ((type : Int) << 8);
		if( td.uavViews == null ) td.uavViews = [];
		var v = td.uavViews.get(key);
		if( v != null ) return v;
		var layers = arr ? getImageLayers(t) : 1;
		v = createView(td, type, ImageAspect.COLOR, t.startingMip, 1, 0, layers);
		td.uavViews.set(key, v);
		return v;
	}

	function getSampler( t : h3d.mat.Texture ) : Sampler {
		var key = @:privateAccess t.bits & ~getTexMask();
		var s = samplers.get(key);
		if( s != null ) return s;
		var d = samplerInfo;
		var aniso = false;
		switch( t.filter ) {
		case Nearest:
			d.magFilter = d.minFilter = NEAREST;
		case Linear:
			d.magFilter = d.minFilter = LINEAR;
		case AnisotropicNearest, AnisotropicLinear:
			d.magFilter = d.minFilter = LINEAR;
			aniso = true;
		}
		d.mipmapMode = t.mipMap == Linear || aniso ? LINEAR : NEAREST;
		d.addressModeU = d.addressModeV = d.addressModeW = switch( t.wrap ) {
		case Clamp: CLAMP_TO_EDGE;
		case Repeat: REPEAT;
		case Mirror: MIRRORED_REPEAT;
		}
		var maxAniso = t.anisotropicMaxLevel;
		if( maxAniso > limits.maxSamplerAnisotropy ) maxAniso = Std.int(limits.maxSamplerAnisotropy);
		d.anisotropyEnable = aniso && maxAniso > 1 ? 1 : 0;
		d.maxAnisotropy = maxAniso < 1 ? 1 : maxAniso;
		d.mipLodBias = t.lodBias;
		d.compareEnable = 0;
		d.compareOp = 0;
		d.minLod = 0;
		d.maxLod = 1000;
		d.borderColor = 0;
		var r = SUCCESS;
		s = Vk.samplerCreate(d, r);
		checkResult(r, "vkCreateSampler");
		samplers.set(key, s);
		return s;
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		pixels.convert(t.format);
		if( mipLevel >= t.mipLevels ) throw "Mip level outside texture range : " + mipLevel + " (max = " + (t.mipLevels - 1) + ")";
		if( mipLevel < t.residentMip ) throw "Mip level " + mipLevel + " is not resident in " + t;
		var size = pixels.dataSize;
		var a = frame.allocator;
		a.alloc(size, copyAlign);
		a.ptr.blit(0, (pixels.bytes : hl.Bytes), pixels.offset, size);
		transition(t.t, COPY_DST);
		flushForTransfer();
		setBufferImageRegion(a.offset, ImageAspect.COLOR, mipLevel - t.residentMip, side, t.flags.has(Is3D), 0, 0, pixels.width, pixels.height);
		var c = bufferImageCopy;
		c.srcBuffer = a.resource.handle;
		c.dstImage = t.t.handle;
		Vk.cmdCopyBufferToImage2(cmd, c);
		t.flags.set(WasCleared);
		t.lastFrame = frameCount;
	}

	function canBlit( f : Format ) {
		var v = blitFormats.get(f);
		if( v == null ) {
			var need = FormatFeature.BLIT_SRC | FormatFeature.BLIT_DST | FormatFeature.SAMPLED_IMAGE_FILTER_LINEAR;
			v = (getFormatFeatures(f) & need) == need;
			blitFormats.set(f, v);
		}
		return v;
	}

	override function generateMipMaps( t : h3d.mat.Texture ) {
		if( t.t == null || t.mipLevels <= 1 || !canBlit(t.t.format) )
			return;
		transition(t.t, TRANSFER_GENERAL);
		flushForTransfer();
		var is3D = t.flags.has(Is3D);
		var layers = getImageLayers(t);
		var depth = is3D ? t.layerCount : 1;
		var b = tmpMemoryBarriers[0];
		b.srcStageMask = b.dstStageMask = PipelineStage.TRANSFER;
		b.srcAccessMask = Access.TRANSFER_WRITE;
		b.dstAccessMask = Access.TRANSFER_READ;
		tmpDependency.memoryBarrierCount = 1;
		tmpDependency.imageMemoryBarrierCount = 0;
		var img = t.t.handle;
		var r = t.residentMip;
		for( i in 1...t.mipLevels - r ) {
			inline function sz( v : Int, m : Int ) { v >>= m; return v < 1 ? 1 : v; }
			blitImage(img, GENERAL, i - 1, sz(t.width, i - 1 + r), sz(t.height, i - 1 + r), sz(depth, i - 1 + r), img, GENERAL, i, sz(t.width, i + r), sz(t.height, i + r), sz(depth, i + r), 0, layers, LINEAR);
			Vk.cmdPipelineBarrier2(cmd, tmpDependency);
		}
	}

	override function copyTexture( from : h3d.mat.Texture, to : h3d.mat.Texture ) {
		if( from.t == null || from.format != to.format || from.width != to.width || from.height != to.height || from.layerCount != to.layerCount || from.mipLevels != to.mipLevels || from.residentMip != to.residentMip )
			return false;
		if( to.t == null ) {
			var prev = from.lastFrame;
			from.preventAutoDispose();
			to.alloc();
			@:bypassAccessor from.lastFrame = prev;
			if( from.t == null ) throw "assert";
			if( to.t == null ) return false;
		}
		from.lastFrame = to.lastFrame = frameCount;
		transition(from.t, COPY_SRC);
		transition(to.t, COPY_DST);
		flushForTransfer();
		var is3D = to.flags.has(Is3D);
		var layers = getImageLayers(to);
		var c = imageCopy;
		c.srcImage = from.t.handle;
		c.dstImage = to.t.handle;
		var r = c.pRegions[0];
		var rmip = to.residentMip;
		for( mip in 0...to.mipLevels - rmip ) {
			inline function sz( v : Int ) { v >>= mip + rmip; return v < 1 ? 1 : v; }
			var s = r.srcSubresource;
			s.aspectMask = from.t.isDepth ? from.t.aspect : ImageAspect.COLOR;
			s.mipLevel = mip;
			s.baseArrayLayer = 0;
			s.layerCount = layers;
			var d = r.dstSubresource;
			d.aspectMask = s.aspectMask;
			d.mipLevel = mip;
			d.baseArrayLayer = 0;
			d.layerCount = layers;
			r.extent.set(sz(to.width), sz(to.height), is3D ? sz(to.layerCount) : 1);
			Vk.cmdCopyImage2(cmd, c);
		}
		to.flags.set(WasCleared);
		restoreTargets();
		return true;
	}

	// ---- EVENTS & QUERIES

	override function beginEvent( name : String ) {
		Vk.cmdBeginLabel(cmd, name);
	}

	override function endEvent() {
		Vk.cmdEndLabel(cmd);
	}

	override function allocQuery( kind : QueryKind ) : Query {
		if( kind != TimeStamp )
			throw "Not implemented";
		return new QueryData();
	}

	override function deleteQuery( q : Query ) {
	}

	override function beginQuery( q : Query ) {
	}

	override function endQuery( q : Query ) {
		var pool = frame.queryPools[frame.queryPool];
		if( pool == null ) {
			var r = SUCCESS;
			pool = Vk.queryPoolCreate(TIMESTAMP, QUERY_COUNT, 0, r);
			checkResult(r, "vkCreateQueryPool");
			frame.queryPools[frame.queryPool] = pool;
			endRendering();
			Vk.cmdResetQueryPool(cmd, pool, 0, QUERY_COUNT);
		}
		q.pool = frame.queryPool;
		q.offset = frame.queryOffset++;
		Vk.cmdWriteTimestamp2(cmd, PipelineStage.ALL_COMMANDS, pool, q.offset);
		frame.queriesPending.push(q);
		if( frame.queryOffset == QUERY_COUNT ) {
			frame.queryOffset = 0;
			frame.queryPool++;
		}
	}

	override function queryResultAvailable( q : Query ) {
		return q.pool < 0;
	}

	override function queryResult( q : Query ) {
		return q.result;
	}

	function readQueries() {
		frame.queryPool = 0;
		frame.queryOffset = 0;
		if( frame.queriesPending.length == 0 )
			return;
		var out = queryResultBytes;
		for( q in frame.queriesPending ) {
			if( q.pool >= 0 && Vk.getQueryPoolResults(frame.queryPools[q.pool], q.offset, 1, 8, hl.Bytes.fromBytes(out), 8, QueryResultFlags.RESULT_64) == SUCCESS )
				q.result = out.getInt64(0).toFloat() * limits.timestampPeriod;
			q.pool = -1;
		}
		frame.queriesPending = [];
	}

}

#end
