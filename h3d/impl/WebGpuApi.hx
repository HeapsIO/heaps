/**
	WebGPU API.
	Mostly extracted from https://github.com/gpuweb/types/blob/main/generated/index.d.ts
	And https://www.w3.org/TR/webgpu/
**/
package h3d.impl;

import js.lib.Promise;
import js.lib.BufferSource;
import haxe.ds.ReadOnlyArray;

typedef GPUSize64 = Int;
typedef GPUIntegerCoordinate = Int;
typedef GPUSize32 = Int;
typedef GPUIndex32 = Int;
typedef GPUSignedOffset32 = Int;

enum abstract GPUPowerPreference(String) {
	var LowPower = "low-power";
	var HighPerformance = "high-performance";
}

enum abstract GPUTextureFormat(String) {
	var R8unorm = "r8unorm";
	var R8snorm = "r8snorm";
	var R8uint = "r8uint";
	var R8sint = "r8sint";
	var R16uint = "r16uint";
	var R16sint = "r16sint";
	var R16float = "r16float";
	var Rg8unorm = "rg8unorm";
	var Rg8snorm = "rg8snorm";
	var Rg8uint = "rg8uint";
	var Rg8sint = "rg8sint";
	var R32uint = "r32uint";
	var R32sint = "r32sint";
	var R32float = "r32float";
	var Rg16uint = "rg16uint";
	var Rg16sint = "rg16sint";
	var Rg16float = "rg16float";
	var Rgba8unorm = "rgba8unorm";
	var Rgba8unorm_srgb = "rgba8unorm-srgb";
	var Rgba8snorm = "rgba8snorm";
	var Rgba8uint = "rgba8uint";
	var Rgba8sint = "rgba8sint";
	var Bgra8unorm = "bgra8unorm";
	var Bgra8unorm_srgb = "bgra8unorm-srgb";
	var Rgb9e5ufloat = "rgb9e5ufloat";
	var Rgb10a2unorm = "rgb10a2unorm";
	var Rg11b10ufloat = "rg11b10ufloat";
	var Rg32uint = "rg32uint";
	var Rg32sint = "rg32sint";
	var Rg32float = "rg32float";
	var Rgba16uint = "rgba16uint";
	var Rgba16sint = "rgba16sint";
	var Rgba16float = "rgba16float";
	var Rgba32uint = "rgba32uint";
	var Rgba32sint = "rgba32sint";
	var Rgba32float = "rgba32float";
	var Stencil8 = "stencil8";
	var Depth16unorm = "depth16unorm";
	var Depth24plus = "depth24plus";
	var Depth24plus_stencil8 = "depth24plus-stencil8";
	var Depth32float = "depth32float";
	var Depth32float_stencil8 = "depth32float-stencil8";
	var Bc1_rgba_unorm = "bc1-rgba-unorm";
	var Bc1_rgba_unorm_srgb = "bc1-rgba-unorm-srgb";
	var Bc2_rgba_unorm = "bc2-rgba-unorm";
	var Bc2_rgba_unorm_srgb = "bc2-rgba-unorm-srgb";
	var Bc3_rgba_unorm = "bc3-rgba-unorm";
	var Bc3_rgba_unorm_srgb = "bc3-rgba-unorm-srgb";
	var Bc4_r_unorm = "bc4-r-unorm";
	var Bc4_r_snorm = "bc4-r-snorm";
	var Bc5_rg_unorm = "bc5-rg-unorm";
	var Bc5_rg_snorm = "bc5-rg-snorm";
	var Bc6h_rgb_ufloat = "bc6h-rgb-ufloat";
	var Bc6h_rgb_float = "bc6h-rgb-float";
	var Bc7_rgba_unorm = "bc7-rgba-unorm";
	var Bc7_rgba_unorm_srgb = "bc7-rgba-unorm-srgb";
	var Etc2_rgb8unorm = "etc2-rgb8unorm";
	var Etc2_rgb8unorm_srgb = "etc2-rgb8unorm-srgb";
	var Etc2_rgb8a1unorm = "etc2-rgb8a1unorm";
	var Etc2_rgb8a1unorm_srgb = "etc2-rgb8a1unorm-srgb";
	var Etc2_rgba8unorm = "etc2-rgba8unorm";
	var Etc2_rgba8unorm_srgb = "etc2-rgba8unorm-srgb";
	var Eac_r11unorm = "eac-r11unorm";
	var Eac_r11snorm = "eac-r11snorm";
	var Eac_rg11unorm = "eac-rg11unorm";
	var Eac_rg11snorm = "eac-rg11snorm";
	var Astc_4x4_unorm = "astc-4x4-unorm";
	var Astc_4x4_unorm_srgb = "astc-4x4-unorm-srgb";
	var Astc_5x4_unorm = "astc-5x4-unorm";
	var Astc_5x4_unorm_srgb = "astc-5x4-unorm-srgb";
	var Astc_5x5_unorm = "astc-5x5-unorm";
	var Astc_5x5_unorm_srgb = "astc-5x5-unorm-srgb";
	var Astc_6x5_unorm = "astc-6x5-unorm";
	var Astc_6x5_unorm_srgb = "astc-6x5-unorm-srgb";
	var Astc_6x6_unorm = "astc-6x6-unorm";
	var Astc_6x6_unorm_srgb = "astc-6x6-unorm-srgb";
	var Astc_8x5_unorm = "astc-8x5-unorm";
	var Astc_8x5_unorm_srgb = "astc-8x5-unorm-srgb";
	var Astc_8x6_unorm = "astc-8x6-unorm";
	var Astc_8x6_unorm_srgb = "astc-8x6-unorm-srgb";
	var Astc_8x8_unorm = "astc-8x8-unorm";
	var Astc_8x8_unorm_srgb = "astc-8x8-unorm-srgb";
	var Astc_10x5_unorm = "astc-10x5-unorm";
	var Astc_10x5_unorm_srgb = "astc-10x5-unorm-srgb";
	var Astc_10x6_unorm = "astc-10x6-unorm";
	var Astc_10x6_unorm_srgb = "astc-10x6-unorm-srgb";
	var Astc_10x8_unorm = "astc-10x8-unorm";
	var Astc_10x8_unorm_srgb = "astc-10x8-unorm-srgb";
	var Astc_10x10_unorm = "astc-10x10-unorm";
	var Astc_10x10_unorm_srgb = "astc-10x10-unorm-srgb";
	var Astc_12x10_unorm = "astc-12x10-unorm";
	var Astc_12x10_unorm_srgb = "astc-12x10-unorm-srgb";
	var Astc_12x12_unorm = "astc-12x12-unorm";
	var Astc_12x12_unorm_srgb = "astc-12x12-unorm-srgb";
}

typedef GPURequestAdapterOptions = {
	var ?powerPreference : GPUPowerPreference;
	var ?forceFallbackAdapter : Bool;
}

extern class GPU {
	function requestAdapter( ?options: GPURequestAdapterOptions ): Promise<Null<GPUAdapter>>;
	/**
	 * Returns an optimal {@link GPUTextureFormat} for displaying 8-bit depth, standard dynamic range
	 * content on this system. Must only return {@link GPUTextureFormat#"rgba8unorm"} or
	 * {@link GPUTextureFormat#"bgra8unorm"}.
	 * The returned value can be passed as the {@link GPUCanvasConfiguration#format} to
	 * {@link GPUCanvasContext#configure} calls on a {@link GPUCanvasContext} to ensure the associated
	 * canvas is able to display its contents efficiently.
	 * Note: Canvases which are not displayed to the screen may or may not benefit from using this
	 * format.
	 */
	function getPreferredCanvasFormat(): GPUTextureFormat;

	/** haxe specific way to access navigator.gpu **/
	inline static function get() : GPU {
		return untyped navigator.gpu;
	}
}

extern class GPUSupportedLimits {
	var maxTextureDimension1D(default,null) : Float;
	var maxTextureDimension2D(default,null) : Float;
	var maxTextureDimension3D(default,null) : Float;
	var maxTextureArrayLayers(default,null) : Float;
	var maxBindGroups(default,null) : Float;
	var maxBindingsPerBindGroup(default,null) : Float;
	var maxDynamicUniformBuffersPerPipelineLayout(default,null) : Float;
	var maxDynamicStorageBuffersPerPipelineLayout(default,null) : Float;
	var maxSampledTexturesPerShaderStage(default,null) : Float;
	var maxSamplersPerShaderStage(default,null) : Float;
	var maxStorageBuffersPerShaderStage(default,null) : Float;
	var maxStorageTexturesPerShaderStage(default,null) : Float;
	var maxUniformBuffersPerShaderStage(default,null) : Float;
	var maxUniformBufferBindingSize(default,null) : Float;
	var maxStorageBufferBindingSize(default,null) : Float;
	var minUniformBufferOffsetAlignment(default,null) : Float;
	var minStorageBufferOffsetAlignment(default,null) : Float;
	var maxVertexBuffers(default,null) : Float;
	var maxBufferSize(default,null) : Float;
	var maxVertexAttributes(default,null) : Float;
	var maxVertexBufferArrayStride(default,null) : Float;
	var maxInterStageShaderComponents(default,null) : Float;
	var maxInterStageShaderVariables(default,null) : Float;
	var maxColorAttachments(default,null) : Float;
	var maxColorAttachmentBytesPerSample(default,null) : Float;
	var maxComputeWorkgroupStorageSize(default,null) : Float;
	var maxComputeInvocationsPerWorkgroup(default,null) : Float;
	var maxComputeWorkgroupSizeX(default,null) : Float;
	var maxComputeWorkgroupSizeY(default,null) : Float;
	var maxComputeWorkgroupSizeZ(default,null) : Float;
	var maxComputeWorkgroupsPerDimension(default,null) : Float;
}

extern class GPUAdapterInfo {
	/**
		* The name of the vendor of the adapter, if available. Empty string otherwise.
		*/
	var vendor(default,null) : String;
	/**
		* The name of the family or class of GPUs the adapter belongs to, if available. Empty
		* string otherwise.
		*/
	var architecture(default,null) : String;
	/**
		* A vendor-specific identifier for the adapter, if available. Empty string otherwise.
		* Note: This is a value that represents the type of adapter. For example, it may be a
		* [PCI device ID](https://pcisig.com/). It does not uniquely identify a given piece of
		* hardware like a serial Float.
		*/
	var device(default,null) : String;
	/**
		* A human readable string describing the adapter as reported by the driver, if available.
		* Empty string otherwise.
		* Note: Because no formatting is applied to {@link GPUAdapterInfo#description} attempting to parse
		* this value is not recommended. Applications which change their behavior based on the
		* {@link GPUAdapterInfo}, such as applying workarounds for known driver issues, should rely on the
		* other fields when possible.
		*/
	var description(default,null) : String;
}

enum abstract GPUFeatureName(String) {
	var Depth_clip_control = "depth-clip-control";
	var Depth32float_stencil8 = "depth32float-stencil8";
	var Texture_compression_bc = "texture-compression-bc";
	var Texture_compression_etc2 = "texture-compression-etc2";
	var Texture_compression_astc = "texture-compression-astc";
	var Timestamp_query = "timestamp-query";
	var Indirect_first_instance = "indirect-first-instance";
	var Shader_f16 = "shader-f16";
	var Rg11b10ufloat_renderable = "rg11b10ufloat-renderable";
	var Bgra8unorm_storage = "bgra8unorm-storage";
}

typedef GPUObjectDescriptorBase = {
	var ?label : String;
}

typedef GPUQueueDescriptor = GPUObjectDescriptorBase;

typedef GPUDeviceDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * Specifies the features that are required by the device request.
	 * The request will fail if the adapter cannot provide these features.
	 * Exactly the specified set of features, and no more or less, will be allowed in validation
	 * of API calls on the resulting device.
	 */
	var ?requiredFeatures: Array<GPUFeatureName>;
	/**
	 * Specifies the limits that are required by the device request.
	 * The request will fail if the adapter cannot provide these limits.
	 * Each key must be the name of a member of supported limits.
	 * Exactly the specified limits, and no limit/better or worse,
	 * will be allowed in validation of API calls on the resulting device.
	 * <!-- If we ever need limit types other than GPUSize32/GPUSize64, we can change the value
	 * type to `double` or `any` in the future and write out the type conversion explicitly (by
	 * reference to WebIDL spec). Or change the entire type to `any` and add back a `dictionary
	 * GPULimits` and define the conversion of the whole object by reference to WebIDL. -->
	 */
	var ?requiredLimits: Dynamic<GPUSize64>;
	var ?defaultQueue: GPUQueueDescriptor;
}

typedef GPUSupportedFeatures = ReadOnlyArray<String>;

extern class GPUAdapter {
	public var features(default,null) : GPUSupportedFeatures;
	public var limits(default,null) : GPUSupportedLimits;
	public var isFallbackAdapter(default,null) : Bool;

	/**
		* Requests a device from the adapter.
		* @param descriptor - Description of the {@link GPUDevice} to request.
		*/
	public function requestDevice( ?descriptor: GPUDeviceDescriptor ): Promise<GPUDevice>;

	/**
		* Requests the {@link GPUAdapterInfo} for this {@link GPUAdapter}.
		* Note: Adapter info values are returned with a Promise to give user agents an
		* opportunity to perform potentially long-running checks when requesting unmasked values,
		* such as asking for user consent before returning. If no `unmaskHints` are specified,
		* however, no dialogs should be displayed to the user.
		* @param unmaskHints - A list of {@link GPUAdapterInfo} attribute names for which unmasked
		* 	values are desired if available.
		*/
	public function requestAdapterInfo( ?unmaskHints: Array<String> ): Promise<GPUAdapterInfo>;

}

extern class GPUCommandBuffer {}

enum abstract GPUBufferMapState(String) {
	var Unmapped = "unmapped";
	var Pending = "pending";
	var Mapped = "mapped";
}

enum GPUMapMode {
	READ;
	WRITE;
}

typedef GPUMapModeFlags = haxe.EnumFlags<GPUMapMode>;

extern class GPU_Buffer {
	var size(default,null) : GPUSize64;
	var usage(default,null) : GPUBufferUsageFlags;
	var mapState(default,null) : GPUBufferMapState;
	/**
	 * Maps the given range of the {@link GPU_Buffer} and resolves the returned {@link Promise} when the
	 * {@link GPU_Buffer}'s content is ready to be accessed with {@link GPU_Buffer#getMappedRange}.
	 * The resolution of the returned {@link Promise} **only** indicates that the buffer has been mapped.
	 * It does not guarantee the completion of any other operations visible to the content timeline,
	 * and in particular does not imply that any other {@link Promise} returned from
	 * {@link GPUQueue#onSubmittedWorkDone()} or {@link GPU_Buffer#mapAsync} on other {@link GPU_Buffer}s
	 * have resolved.
	 * The resolution of the {@link Promise} returned from {@link GPUQueue#onSubmittedWorkDone}
	 * **does** imply the completion of
	 * {@link GPU_Buffer#mapAsync} calls made prior to that call,
	 * on {@link GPU_Buffer}s last used exclusively on that queue.
	 * @param mode - Whether the buffer should be mapped for reading or writing.
	 * @param offset - Offset in bytes into the buffer to the start of the range to map.
	 * @param size - Size in bytes of the range to map.
	 */
	function mapAsync( mode: GPUMapModeFlags, ?offset: GPUSize64, ?size: GPUSize64 ) : Promise<Void>;
	/**
	 * Returns an {@link ArrayBuffer} with the contents of the {@link GPU_Buffer} in the given mapped range.
	 * @param offset - Offset in bytes into the buffer to return buffer contents from.
	 * @param size - Size in bytes of the {@link ArrayBuffer} to return.
	 */
	function getMappedRange( ?offset: GPUSize64, ?size: GPUSize64 ) : js.lib.ArrayBuffer;
	/**
	 * Unmaps the mapped range of the {@link GPU_Buffer} and makes it's contents available for use by the
	 * GPU again.
	 */
	function unmap() : Void;
	/**
	 * Destroys the {@link GPU_Buffer}.
	 * Note: It is valid to destroy a buffer multiple times.
	 * Note: Since no further operations can be enqueued using this buffer, implementations can
	 * free resource allocations, including mapped memory that was just unmapped.
	 */
	 function destroy() : Void;
}

enum abstract GPUTextureDimension(String) {
	var D1 = "1d";
	var D2 = "2d";
	var D3 = "3d";
}

enum GPUTextureUsage {
	COPY_SRC;
	COPY_DST;
	TEXTURE_BINDING;
	STORAGE_BINDING;
	RENDER_ATTACHMENT;
}

typedef GPUTextureUsageFlags = haxe.EnumFlags<GPUTextureUsage>;


enum abstract GPUTextureViewDimension(String) {
	var D1 = "1d";
	var D2 = "2d";
	var D2_array = "2d-array";
	var Cube = "cube";
	var Cube_array = "cube-array";
	var D3 = "3d";
}

typedef GPUTextureViewDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * The format of the texture view. Must be either the {@link GPUTextureDescriptor#format} of the
	 * texture or one of the {@link GPUTextureDescriptor#viewFormats} specified during its creation.
	 */
	var ?format: GPUTextureFormat;
	/**
	 * The dimension to view the texture as.
	 */
	var ?dimension: GPUTextureViewDimension;
	/**
	 * Which {@link GPUTextureAspect|aspect(s)} of the texture are accessible to the texture view.
	 */
	var ?aspect: GPUTextureAspect;
	/**
	 * The first (most detailed) mipmap level accessible to the texture view.
	 */
	var ?baseMipLevel: GPUIntegerCoordinate;
	/**
	 * How many mipmap levels, starting with {@link GPUTextureViewDescriptor#baseMipLevel}, are accessible to
	 * the texture view.
	 */
	var ?mipLevelCount: GPUIntegerCoordinate;
	/**
	 * The index of the first array layer accessible to the texture view.
	 */
	var ?baseArrayLayer: GPUIntegerCoordinate;
	/**
	 * How many array layers, starting with {@link GPUTextureViewDescriptor#baseArrayLayer}, are accessible
	 * to the texture view.
	 */
	var ?arrayLayerCount: GPUIntegerCoordinate;
}

extern class GPUTextureView {
}

extern class GPUTexture {
	/**
	 * Creates a {@link GPUTextureView}.
	 * @param descriptor - Description of the {@link GPUTextureView} to create.
	 */
	function createView( ?descriptor: GPUTextureViewDescriptor ) : GPUTextureView;
	function destroy() : Void;
	var width(default,null) : GPUIntegerCoordinate;
	var height(default,null) : GPUIntegerCoordinate;
	var depthOrArrayLayers(default,null) : GPUIntegerCoordinate;
	var mipLevelCount(default,null) : GPUIntegerCoordinate;
	var sampleCount(default,null) : GPUSize32;
	var dimension(default,null) : GPUTextureDimension;
	var format(default,null) : GPUTextureFormat;
	var usage(default,null) : GPUTextureUsageFlags;
}

typedef GPUOrigin2D = {
	var ?x : Int;
	var ?y : Int;
}

typedef GPUOrigin3D = {
	var ?x : Int;
	var ?y : Int;
	var ?z : Int;
}

enum abstract GPUTextureAspect(String) {
	var All = "all";
	var Stencil_only = "stencil-only";
	var Depth_only = "depth-only";
}

typedef GPUImageCopyTexture = {
	var texture : GPUTexture;
	var ?mipLevel : Int;
	var ?origin : GPUOrigin3D;
	var ?aspect : GPUTextureAspect;
}

typedef GPUImageDataLayout = {
	var bytesPerRow : Int;
	var ?offset : Int;
	var ?rowsPerImage : Int;
}

typedef GPUExtent3D = {
	var width: GPUIntegerCoordinate;
	var ?height: GPUIntegerCoordinate;
	var ?depthOrArrayLayers: GPUIntegerCoordinate;
}

typedef GPUImageCopyExternalImage = {
	var source : Dynamic;
	var ?origin : GPUOrigin2D;
	var ?flipY : Bool;
}

// html spec
enum abstract PredefinedColorSpace(String) {
	var srgb;
	var Display_p3 = "display-p3";
}

typedef GPUImageCopyTextureTagged = { > GPUImageCopyTexture,
	var ?colorSpace : PredefinedColorSpace;
	var ?premultipliedAlpha : Bool;
}

extern class GPUQueue {
	/**
	 * Schedules the execution of the command buffers by the GPU on this queue.
	 * Submitted command buffers cannot be used again.
	 * 	`commandBuffers`:
	 */
	function submit( commandBuffers: Array<GPUCommandBuffer> ) : Void;
	function onSubmittedWorkDone() : Promise<Void>;
	/**
	 * Issues a write operation of the provided data into a {@link GPU_Buffer}.
	 * @param buffer - The buffer to write to.
	 * @param bufferOffset - Offset in bytes into `buffer` to begin writing at.
	 * @param data - Data to write into `buffer`.
	 * @param dataOffset - Offset in into `data` to begin writing from. Given in elements if
	 * 	`data` is a `TypedArray` and bytes otherwise.
	 * @param size - Size of content to write from `data` to `buffer`. Given in elements if
	 * 	`data` is a `TypedArray` and bytes otherwise.
	 */
	function writeBuffer( buffer: GPU_Buffer, bufferOffset: GPUSize64, data: BufferSource, ?dataOffset: GPUSize64, ?size: GPUSize64 ) : Void;
	/**
	 * Issues a write operation of the provided data into a {@link GPUTexture}.
	 * @param destination - The texture subresource and origin to write to.
	 * @param data - Data to write into `destination`.
	 * @param dataLayout - Layout of the content in `data`.
	 * @param size - Extents of the content to write from `data` to `destination`.
	 */
	function writeTexture( destination: GPUImageCopyTexture, data: BufferSource, dataLayout: GPUImageDataLayout, size: GPUExtent3D ) : Void;
	/**
	 * Issues a copy operation of the contents of a platform image/canvas
	 * into the destination texture.
	 * This operation performs [[#color-space-conversions|color encoding]] into the destination
	 * encoding according to the parameters of {@link GPUImageCopyTextureTagged}.
	 * Copying into a `-srgb` texture results in the same texture bytes, not the same decoded
	 * values, as copying into the corresponding non-`-srgb` format.
	 * Thus, after a copy operation, sampling the destination texture has
	 * different results depending on whether its format is `-srgb`, all else unchanged.
	 * <!-- POSTV1(srgb-linear) : If added, explain here how it interacts. -->
	 * @param source - source image and origin to copy to `destination`.
	 * @param destination - The texture subresource and origin to write to, and its encoding metadata.
	 * @param copySize - Extents of the content to write from `source` to `destination`.
	 */
	function copyExternalImageToTexture( source: GPUImageCopyExternalImage, destination: GPUImageCopyTextureTagged, copySize: GPUExtent3D ) : Void;
}

enum abstract GPUDeviceLostReason(String) {
	var destroyed;
}

enum abstract GPUErrorFilter(String) {
	var Validation = "validation";
	var Out_of_memory = "out-of-memory";
	var Internal = "internal";
}

typedef GPUDeviceLostInfo = {
	final reason : GPUDeviceLostReason;
	final message : String;
}

typedef GPUError = {
	/**
	 * A human-readable, localizable text message providing information about the error that
	 * occurred.
	 * Note: This message is generally intended for application developers to debug their
	 * applications and capture information for debug reports, not to be surfaced to end-users.
	 * Note: User agents should not include potentially machine-parsable details in this message,
	 * such as free system memory on {@link GPUErrorFilter#"out-of-memory"} or other details about the
	 * conditions under which memory was exhausted.
	 * Note: The {@link GPUError#message} should follow the best practices for language and
	 * direction information. This includes making use of any future standards which may emerge
	 * regarding the reporting of String language and direction metadata.
	 * <p class="note editorial">Editorial:
	 * At the time of this writing, no language/direction recommendation is available that provides
	 * compatibility and consistency with legacy APIs, but when there is, adopt it formally.
	 */
	var message(default,null) : String;
}


typedef GPUTextureDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * The width, height, and depth or layer count of the texture.
	 */
	var size : GPUExtent3D;
	/**
	 * The Float of mip levels the texture will contain.
	 */
	var ?mipLevelCount: GPUIntegerCoordinate;
	/**
	 * The sample count of the texture. A {@link GPUTextureDescriptor#sampleCount} &gt; `1` indicates
	 * a multisampled texture.
	 */
	var ?sampleCount: GPUSize32;
	/**
	 * Whether the texture is one-dimensional, an array of two-dimensional layers, or three-dimensional.
	 */
	var ?dimension: GPUTextureDimension;
	/**
	 * The format of the texture.
	 */
	var format: GPUTextureFormat;
	/**
	 * The allowed usages for the texture.
	 */
	var usage: GPUTextureUsageFlags;
	/**
	 * Specifies what view {@link GPUTextureViewDescriptor#format} values will be allowed when calling
	 * {@link GPUTexture#createView} on this texture (in addition to the texture's actual
	 * {@link GPUTextureDescriptor#format}).
	 * <div class=note>
	 * Note:
	 * Adding a format to this list may have a significant performance impact, so it is best
	 * to avoid adding formats unnecessarily.
	 * The actual performance impact is highly dependent on the target system; developers must
	 * test various systems to find out the impact on their particular application.
	 * For example, on some systems any texture with a {@link GPUTextureDescriptor#format} or
	 * {@link GPUTextureDescriptor#viewFormats} entry including
	 * {@link GPUTextureFormat#"rgba8unorm-srgb"} will perform less optimally than a
	 * {@link GPUTextureFormat#"rgba8unorm"} texture which does not.
	 * Similar caveats exist for other formats and pairs of formats on other systems.
	 * </div>
	 * Formats in this list must be texture view format compatible with the texture format.
	 * <div algorithm>
	 * Two {@link GPUTextureFormat}s `format` and `viewFormat` are <dfn dfn for=>texture view format compatible</dfn> if:
	 * - `format` equals `viewFormat`, or
	 * - `format` and `viewFormat` differ only in whether they are `srgb` formats (have the `-srgb` suffix).
	 * Issue(gpuweb/gpuweb#168) : Define larger compatibility classes.
	 * </div>
	 */
	var ?viewFormats: Array<GPUTextureFormat>;
}

enum GPUBufferUsage {
	MAP_READ;
	MAP_WRITE;
	COPY_SRC;
	COPY_DST;
	INDEX;
	VERTEX;
	UNIFORM;
	STORAGE;
	INDIRECT;
	QUERY_RESOLVE;
}

typedef GPUBufferUsageFlags = haxe.EnumFlags<GPUBufferUsage>;

typedef GPUBufferDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * The size of the buffer in bytes.
	 */
	var size: GPUSize64;
	/**
	 * The allowed usages for the buffer.
	 */
	var usage: GPUBufferUsageFlags;
	/**
	 * If `true` creates the buffer in an already mapped state, allowing
	 * {@link GPU_Buffer#getMappedRange} to be called immediately. It is valid to set
	 * {@link GPUBufferDescriptor#mappedAtCreation} to `true` even if {@link GPUBufferDescriptor#usage}
	 * does not contain {@link GPUBufferUsage#MAP_READ} or {@link GPUBufferUsage#MAP_WRITE}. This can be
	 * used to set the buffer's initial data.
	 * Guarantees that even if the buffer creation eventually fails, it will still appear as if the
	 * mapped range can be written/read to until it is unmapped.
	 */
	var ?mappedAtCreation: Bool;
}

extern class GPUShaderModule {
	/**
	 * Returns any messages generated during the {@link GPUShaderModule}'s compilation.
	 * The locations, order, and contents of messages are implementation-defined.
	 * In particular, messages may not be ordered by {@link GPUCompilationMessage#lineNum}.
	 */
	function compilationInfo() : Promise<GPUCompilationInfo>;
}

typedef GPUCompilationInfo = {
	var messages(default,null) : ReadOnlyArray<GPUCompilationMessage>;
}

enum abstract GPUCompilationMessageType(String) {
	var error;
	var warning;
	var info;
}

typedef GPUCompilationMessage = {
	/**
	 * The human-readable, localizable text for this compilation message.
	 * Note: The {@link GPUCompilationMessage#message} should follow the best practices for language
	 * and direction information. This includes making use of any future standards which may
	 * emerge regarding the reporting of String language and direction metadata.
	 * <p class="note editorial">Editorial:
	 * At the time of this writing, no language/direction recommendation is available that provides
	 * compatibility and consistency with legacy APIs, but when there is, adopt it formally.
	 */
	var message(default,null) : String;
	/**
	 * The severity level of the message.
	 * If the {@link GPUCompilationMessage#type} is {@link GPUCompilationMessageType#"error"}, it
	 * corresponds to a shader-creation error.
	 */
	var type(default,null) : GPUCompilationMessageType;
	/**
	 * The line Float in the shader {@link GPUShaderModuleDescriptor#code} the
	 * {@link GPUCompilationMessage#message} corresponds to. Value is one-based, such that a lineNum of
	 * `1` indicates the first line of the shader {@link GPUShaderModuleDescriptor#code}. Lines are
	 * delimited by line breaks.
	 * If the {@link GPUCompilationMessage#message} corresponds to a substring this points to
	 * the line on which the substring begins. Must be `0` if the {@link GPUCompilationMessage#message}
	 * does not correspond to any specific point in the shader {@link GPUShaderModuleDescriptor#code}.
	 */
	var lineNum(default,null) : Int;
	/**
	 * The offset, in UTF-16 code units, from the beginning of line {@link GPUCompilationMessage#lineNum}
	 * of the shader {@link GPUShaderModuleDescriptor#code} to the point or beginning of the substring
	 * that the {@link GPUCompilationMessage#message} corresponds to. Value is one-based, such that a
	 * {@link GPUCompilationMessage#linePos} of `1` indicates the first code unit of the line.
	 * If {@link GPUCompilationMessage#message} corresponds to a substring this points to the
	 * first UTF-16 code unit of the substring. Must be `0` if the {@link GPUCompilationMessage#message}
	 * does not correspond to any specific point in the shader {@link GPUShaderModuleDescriptor#code}.
	 */
	var linePos(default,null) : Int;
	/**
	 * The offset from the beginning of the shader {@link GPUShaderModuleDescriptor#code} in UTF-16
	 * code units to the point or beginning of the substring that {@link GPUCompilationMessage#message}
	 * corresponds to. Must reference the same position as {@link GPUCompilationMessage#lineNum} and
	 * {@link GPUCompilationMessage#linePos}. Must be `0` if the {@link GPUCompilationMessage#message}
	 * does not correspond to any specific point in the shader {@link GPUShaderModuleDescriptor#code}.
	 */
	var offset(default,null) : Int;
	/**
	 * The Float of UTF-16 code units in the substring that {@link GPUCompilationMessage#message}
	 * corresponds to. If the message does not correspond with a substring then
	 * {@link GPUCompilationMessage#length} must be 0.
	 */
	var length(default,null) : Int;
}


typedef GPUShaderModuleCompilationHint = {
	/**
	 * A {@link GPUPipelineLayout} that the {@link GPUShaderModule} may be used with in a future
	 * {@link GPUDevice#createComputePipeline()} or {@link GPUDevice#createRenderPipeline} call.
	 * If set to {@link GPUAutoLayoutMode#"auto"} the layout will be the [$default pipeline layout$]
	 * for the entry point associated with this hint will be used.
	 */
	var ?layout: GPUPipelineLayout; // | "auto"
}

typedef GPUShaderModuleDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * The <a href="https://gpuweb.github.io/gpuweb/wgsl/">WGSL</a> source code for the shader
	 * module.
	 */
	var code: String;
	/**
	 * If defined MAY be interpreted as a source-map-v3 format.
	 * Source maps are optional, but serve as a standardized way to support dev-tool
	 * integration such as source-language debugging [[SourceMap]].
	 * WGSL names (identifiers) in source maps follow the rules defined in WGSL identifier
	 * comparison.
	 */
	var ?sourceMap: Dynamic;
	/**
	 * If defined maps an entry point name from the shader to a {@link GPUShaderModuleCompilationHint}.
	 * No validation is performed with any of these {@link GPUShaderModuleCompilationHint}.
	 * Implementations should use any information present in the {@link GPUShaderModuleCompilationHint}
	 * to perform as much compilation as is possible within {@link GPUDevice#createShaderModule}.
	 * Entry point names follow the rules defined in WGSL identifier comparison.
	 * Note: Supplying information in {@link GPUShaderModuleDescriptor#hints} does not have any
	 * observable effect, other than performance. Because a single shader module can hold
	 * multiple entry points, and multiple pipelines can be created from a single shader
	 * module, it can be more performant for an implementation to do as much compilation as
	 * possible once in {@link GPUDevice#createShaderModule} rather than multiple times in
	 * the multiple calls to {@link GPUDevice#createComputePipeline} /
	 * {@link GPUDevice#createRenderPipeline}.
	 */
	var ?hints: Dynamic<GPUShaderModuleCompilationHint>;
}

extern class GPUBindGroupLayout {}

typedef GPUPipelineLayoutDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * A list of {@link GPUBindGroupLayout}s the pipline will use. Each element corresponds to a
	 * @group attribute in the {@link GPUShaderModule}, with the `N`th element corresponding with
	 * `@group(N)`.
	 */
	var bindGroupLayouts: Array<GPUBindGroupLayout>;
}

typedef GPUPipelineDescriptorBase = {> GPUObjectDescriptorBase,
	var layout : GPUPipelineLayout; // | "auto"
}

typedef GPUPipelineConstantValue = Float;

typedef GPUProgrammableStage = {
	var module: GPUShaderModule;
	var entryPoint: String;
	var ?constants: Dynamic<GPUPipelineConstantValue>;
}

typedef GPUComputePipelineDescriptor = {> GPUPipelineDescriptorBase,
	var compute: GPUProgrammableStage;
}

enum abstract GPUVertexStepMode(String) {
	var Vertex = "vertex";
	var Instance = "instance";
}

enum abstract GPUVertexFormat(String) {
	var Uint8x2 = "uint8x2";
	var Uint8x4 = "uint8x4";
	var Sint8x2 = "sint8x2";
	var Sint8x4 = "sint8x4";
	var Unorm8x2 = "unorm8x2";
	var Unorm8x4 = "unorm8x4";
	var Snorm8x2 = "snorm8x2";
	var Snorm8x4 = "snorm8x4";
	var Uint16x2 = "uint16x2";
	var Uint16x4 = "uint16x4";
	var Sint16x2 = "sint16x2";
	var Sint16x4 = "sint16x4";
	var Unorm16x2 = "unorm16x2";
	var Unorm16x4 = "unorm16x4";
	var Snorm16x2 = "snorm16x2";
	var Snorm16x4 = "snorm16x4";
	var Float16x2 = "float16x2";
	var Float16x4 = "float16x4";
	var Float32 = "float32";
	var Float32x2 = "float32x2";
	var Float32x3 = "float32x3";
	var Float32x4 = "float32x4";
	var Uint32 = "uint32";
	var Uint32x2 = "uint32x2";
	var Uint32x3 = "uint32x3";
	var Uint32x4 = "uint32x4";
	var Sint32 = "sint32";
	var Sint32x2 = "sint32x2";
	var Sint32x3 = "sint32x3";
	var Sint32x4 = "sint32x4";
}

typedef GPUVertexAttribute = {
	/**
	 * The {@link GPUVertexFormat} of the attribute.
	 */
	var format: GPUVertexFormat;
	/**
	 * The offset, in bytes, from the beginning of the element to the data for the attribute.
	 */
	var offset: GPUSize64;
	/**
	 * The numeric location associated with this attribute, which will correspond with a
	 * <a href="https://gpuweb.github.io/gpuweb/wgsl/#input-output-locations">"@location" attribute</a>
	 * declared in the {@link GPURenderPipelineDescriptor#vertex}.{@link GPUProgrammableStage#module|module}.
	 */
	var shaderLocation: GPUIndex32;
}

typedef GPUVertexBufferLayout = {
	/**
	 * The stride, in bytes, between elements of this array.
	 */
	var arrayStride: GPUSize64;
	/**
	 * Whether each element of this array represents per-vertex data or per-instance data
	 */
	var ?stepMode: GPUVertexStepMode;
	/**
	 * An array defining the layout of the vertex attributes within each element.
	 */
	var attributes: Array<GPUVertexAttribute>;
}

typedef GPUVertexState = {>  GPUProgrammableStage,
	var ?buffers: Array<Null<GPUVertexBufferLayout>>;
}

enum abstract GPUBlendOperation(String) {
	var Add = "add";
	var Subtract = "subtract";
	var Reverse_subtract = "reverse-subtract";
	var Min = "min";
	var Max = "max";
}

enum abstract GPUBlendFactor(String) {
	var Zero = "zero";
	var One = "one";
	var Src = "src";
	var One_minus_src = "one-minus-src";
	var Src_alpha = "src-alpha";
	var One_minus_src_alpha = "one-minus-src-alpha";
	var Dst = "dst";
	var One_minus_dst = "one-minus-dst";
	var Dst_alpha = "dst-alpha";
	var One_minus_dst_alpha = "one-minus-dst-alpha";
	var Src_alpha_saturated = "src-alpha-saturated";
	var Constant = "constant";
	var One_minus_constant = "one-minus-constant";
}

typedef GPUBlendComponent = {
	/**
	 * Defines the {@link GPUBlendOperation} used to calculate the values written to the target
	 * attachment components.
	 */
	var ?operation: GPUBlendOperation;
	/**
	 * Defines the {@link GPUBlendFactor} operation to be performed on values from the fragment shader.
	 */
	var ?srcFactor: GPUBlendFactor;
	/**
	 * Defines the {@link GPUBlendFactor} operation to be performed on values from the target attachment.
	 */
	var ?dstFactor: GPUBlendFactor;
}



typedef GPUBlendState = {
	var color: GPUBlendComponent;
	var alpha: GPUBlendComponent;
}

typedef GPUColorWriteFlags = Int;

typedef GPUColorTargetState = {
	var format: GPUTextureFormat;
	var ?blend: GPUBlendState;
	var ?writeMask: GPUColorWriteFlags;
}

typedef GPUFragmentState = {>GPUProgrammableStage,
	var targets: Array<Null<GPUColorTargetState>>;
}

enum abstract GPUPrimitiveTopology(String) {
	var Point_list = "point-list";
	var Line_list = "line-list";
	var Line_strip = "line-strip";
	var Triangle_list = "triangle-list";
	var Triangle_strip = "triangle-strip";
}

enum abstract GPUIndexFormat(String) {
	var Uint16 = "uint16";
	var Uint32 = "uint32";
}

enum abstract GPUFrontFace(String) {
	var CCW = "ccw";
	var CW = "cw";
}

enum abstract GPUCullMode(String) {
	var None = "none";
	var Front = "front";
	var Back = "back";
}

typedef GPUPrimitiveState = {
	/**
	 * The type of primitive to be constructed from the vertex inputs.
	 */
	var ?topology: GPUPrimitiveTopology;
	/**
	 * For pipelines with strip topologies
	 * ({@link GPUPrimitiveTopology#"line-strip"} or {@link GPUPrimitiveTopology#"triangle-strip"}),
	 * this determines the index buffer format and primitive restart value
	 * ({@link GPUIndexFormat#"uint16"}/`0xFFFF` or {@link GPUIndexFormat#"uint32"}/`0xFFFFFFFF`).
	 * It is not allowed on pipelines with non-strip topologies.
	 * Note: Some implementations require knowledge of the primitive restart value to compile
	 * pipeline state objects.
	 * To use a strip-topology pipeline with an indexed draw call
	 * ({@link GPURenderCommandsMixin#drawIndexed()} or {@link GPURenderCommandsMixin#drawIndexedIndirect}),
	 * this must be set, and it must match the index buffer format used with the draw call
	 * (set in {@link GPURenderCommandsMixin#setIndexBuffer}).
	 * See [[#primitive-assembly]] for additional details.
	 */
	var ?stripIndexFormat: GPUIndexFormat;
	/**
	 * Defines which polygons are considered front-facing.
	 */
	var ?frontFace: GPUFrontFace;
	/**
	 * Defines which polygon orientation will be culled, if any.
	 */
	var ?cullMode: GPUCullMode;
	/**
	 * If true, indicates that depth clipping is disabled.
	 * Requires the {@link GPUFeatureName#"depth-clip-control"} feature to be enabled.
	 */
	var ?unclippedDepth: Bool;
}

enum abstract GPUCompareFunction(String) {
	var Never = "never";
	var Less = "less";
	var Equal = "equal";
	var Less_equal = "less-equal";
	var Greater = "greater";
	var Not_equal = "not-equal";
	var Greater_equal = "greater-equal";
	var Always = "always";
}

enum abstract GPUStencilOperation(String) {
	var Keep = "keep";
	var Zero = "zero";
	var Replace = "replace";
	var Invert = "invert";
	var Increment_clamp = "increment-clamp";
	var Decrement_clamp = "decrement-clamp";
	var Increment_wrap = "increment-wrap";
	var Decrement_wrap = "decrement-wrap";
}

typedef GPUStencilFaceState = {
	/**
	 * The {@link GPUCompareFunction} used when testing fragments against
	 * {@link GPURenderPassDescriptor#depthStencilAttachment} stencil values.
	 */
	var ?compare: GPUCompareFunction;
	/**
	 * The {@link GPUStencilOperation} performed if the fragment stencil comparison test described by
	 * {@link GPUStencilFaceState#compare} fails.
	 */
	var ?failOp: GPUStencilOperation;
	/**
	 * The {@link GPUStencilOperation} performed if the fragment depth comparison described by
	 * {@link GPUDepthStencilState#depthCompare} fails.
	 */
	var ?depthFailOp: GPUStencilOperation;
	/**
	 * The {@link GPUStencilOperation} performed if the fragment stencil comparison test described by
	 * {@link GPUStencilFaceState#compare} passes.
	 */
	var ?passOp: GPUStencilOperation;
}

typedef GPUStencilValue = Int;
typedef GPUDepthBias = Float;

typedef GPUDepthStencilState = {
	/**
	 * The {@link GPUTextureViewDescriptor#format} of {@link GPURenderPassDescriptor#depthStencilAttachment}
	 * this {@link GPURenderPipeline} will be compatible with.
	 */
	var format: GPUTextureFormat;
	/**
	 * Indicates if this {@link GPURenderPipeline} can modify
	 * {@link GPURenderPassDescriptor#depthStencilAttachment} depth values.
	 */
	var ?depthWriteEnabled: Bool;
	/**
	 * The comparison operation used to test fragment depths against
	 * {@link GPURenderPassDescriptor#depthStencilAttachment} depth values.
	 */
	var ?depthCompare: GPUCompareFunction;
	/**
	 * Defines how stencil comparisons and operations are performed for front-facing primitives.
	 */
	var ?stencilFront: GPUStencilFaceState;
	/**
	 * Defines how stencil comparisons and operations are performed for back-facing primitives.
	 */
	var ?stencilBack: GPUStencilFaceState;
	/**
	 * Bitmask controlling which {@link GPURenderPassDescriptor#depthStencilAttachment} stencil value
	 * bits are read when performing stencil comparison tests.
	 */
	var ?stencilReadMask: GPUStencilValue;
	/**
	 * Bitmask controlling which {@link GPURenderPassDescriptor#depthStencilAttachment} stencil value
	 * bits are written to when performing stencil operations.
	 */
	var ?stencilWriteMask: GPUStencilValue;
	/**
	 * Constant depth bias added to each fragment. See [$biased fragment depth$] for details.
	 */
	var ?depthBias: GPUDepthBias;
	/**
	 * Depth bias that scales with the fragment’s slope. See [$biased fragment depth$] for details.
	 */
	var ?depthBiasSlopeScale: Float;
	/**
	 * The maximum depth bias of a fragment. See [$biased fragment depth$] for details.
	 */
	var ?depthBiasClamp: Float;
}

typedef GPUSampleMask = Int;

typedef GPUMultisampleState = {
	/**
	 * Number of samples per pixel. This {@link GPURenderPipeline} will be compatible only
	 * with attachment textures ({@link GPURenderPassDescriptor#colorAttachments}
	 * and {@link GPURenderPassDescriptor#depthStencilAttachment})
	 * with matching {@link GPUTextureDescriptor#sampleCount}s.
	 */
	var ?count: GPUSize32;
	/**
	 * Mask determining which samples are written to.
	 */
	var ?mask: GPUSampleMask;
	/**
	 * When `true` indicates that a fragment's alpha channel should be used to generate a sample
	 * coverage mask.
	 */
	var ?alphaToCoverageEnabled: Bool;
}

typedef GPURenderPipelineDescriptor = {> GPUPipelineDescriptorBase,
	/**
	* Describes the vertex shader entry point of the pipeline and its input buffer layouts.
	*/
	var vertex: GPUVertexState;
	/**
	* Describes the primitive-related properties of the pipeline.
	*/
	var ?primitive: GPUPrimitiveState;
	/**
	* Describes the optional depth-stencil properties, including the testing, operations, and bias.
	*/
	var ?depthStencil: GPUDepthStencilState;
	/**
	* Describes the multi-sampling properties of the pipeline.
	*/
	var ?multisample: GPUMultisampleState;
	/**
	* Describes the fragment shader entry point of the pipeline and its output colors. If
	* `Void`, the [[#no-color-output]] mode is enabled.
	*/
	var ?fragment: GPUFragmentState;
}


extern class GPUPipelineLayout {}

extern class GPUPipelineBase {
	function getBindGroupLayout( index: Int ) : GPUBindGroupLayout;
}
extern class GPUComputePipeline extends GPUPipelineBase {}
extern class GPURenderPipeline extends GPUPipelineBase {}

typedef GPUCommandEncoderDescriptor = {> GPUObjectDescriptorBase, }

extern class GPUDebugCommands {
	/**
		* Begins a labeled debug group containing subsequent commands.
		* @param groupLabel - The label for the command group.
		*/
	function pushDebugGroup( groupLabel: String ) : Void;
	/**
		* Ends the labeled debug group most recently started by {@link GPUDebugCommandsMixin#pushDebugGroup}.
		*/
	function popDebugGroup() : Void;
	/**
		* Marks a point in a stream of commands with a label.
		* @param markerLabel - The label to insert.
		*/
	function insertDebugMarker( markerLabel: String ) : Void;
}

extern class GPUBindGroup {}

typedef GPUBufferDynamicOffset = Int;

extern class GPUBindingCommands extends GPUDebugCommands {
	function setBindGroup( index: GPUIndex32, bindGroup: GPUBindGroup, ?dynamicOffsets: Dynamic, ?dynamicOffsetsDataStart: GPUSize64, ?dynamicOffsetsDataLength: GPUSize32 ) : Void;
}

extern class GPURenderCommands extends GPUBindingCommands {
	/**
	 * Sets the current {@link GPURenderPipeline}.
	 * @param pipeline - The render pipeline to use for subsequent drawing commands.
	 */
	function setPipeline( pipeline: GPURenderPipeline ) : Void;
	/**
	 * Sets the current index buffer.
	 * @param buffer - Buffer containing index data to use for subsequent drawing commands.
	 * @param indexFormat - Format of the index data contained in `buffer`.
	 * @param offset - Offset in bytes into `buffer` where the index data begins. Defaults to `0`.
	 * @param size - Size in bytes of the index data in `buffer`.
	 * 	Defaults to the size of the buffer minus the offset.
	 */
	function setIndexBuffer( buffer: GPU_Buffer, indexFormat: GPUIndexFormat, ?offset: GPUSize64, ?size: GPUSize64 ) : Void;
	/**
	 * Sets the current vertex buffer for the given slot.
	 * @param slot - The vertex buffer slot to set the vertex buffer for.
	 * @param buffer - Buffer containing vertex data to use for subsequent drawing commands.
	 * @param offset - Offset in bytes into `buffer` where the vertex data begins. Defaults to `0`.
	 * @param size - Size in bytes of the vertex data in `buffer`.
	 * 	Defaults to the size of the buffer minus the offset.
	 */
	function setVertexBuffer( slot: GPUIndex32, buffer: GPU_Buffer, ?offset: GPUSize64, ?size: GPUSize64 ) : Void;
	/**
	 * Draws primitives.
	 * See [[#rendering-operations]] for the detailed specification.
	 * @param vertexCount - The Float of vertices to draw.
	 * @param instanceCount - The Float of instances to draw.
	 * @param firstVertex - Offset into the vertex buffers, in vertices, to begin drawing from.
	 * @param firstInstance - First instance to draw.
	 */
	function draw( vertexCount: GPUSize32, ?instanceCount: GPUSize32, ?firstVertex: GPUSize32, ?firstInstance: GPUSize32 ) : Void;
	function drawIndexed( indexCount: GPUSize32, ?instanceCount: GPUSize32, ?firstIndex: GPUSize32, ?baseVertex: GPUSignedOffset32, ?firstInstance: GPUSize32 ) : Void;
	function drawIndirect( indirectBuffer: GPU_Buffer, indirectOffset: GPUSize64 ) : Void;
	function drawIndexedIndirect( indirectBuffer: GPU_Buffer, indirectOffset: GPUSize64 ) : Void;
}

typedef GPUColor = {
	var r: Float;
	var g: Float;
	var b: Float;
	var a: Float;
}

enum abstract GPULoadOp(String) {
	var Load = "load";
	var Clear = "clear";
}


enum abstract GPUStoreOp(String) {
	var Store = "store";
	var Discard = "discard";
}

typedef GPURenderPassColorAttachment = {
	/**
	 * A {@link GPUTextureView} describing the texture subresource that will be output to for this
	 * color attachment.
	 */
	var view: GPUTextureView;
	/**
	 * A {@link GPUTextureView} describing the texture subresource that will receive the resolved
	 * output for this color attachment if {@link GPURenderPassColorAttachment#view} is
	 * multisampled.
	 */
	var ?resolveTarget: GPUTextureView;
	/**
	 * Indicates the value to clear {@link GPURenderPassColorAttachment#view} to prior to executing the
	 * render pass. If not map/exist|provided, defaults to `{r: 0, g: 0, b: 0, a: 0}`. Ignored
	 * if {@link GPURenderPassColorAttachment#loadOp} is not {@link GPULoadOp#"clear"}.
	 * The components of {@link GPURenderPassColorAttachment#clearValue} are all double values.
	 * They are converted [$to a texel value of texture format$] matching the render attachment.
	 * If conversion fails, a validation error is generated.
	 */
	var ?clearValue: GPUColor;
	/**
	 * Indicates the load operation to perform on {@link GPURenderPassColorAttachment#view} prior to
	 * executing the render pass.
	 * Note: It is recommended to prefer clearing; see {@link GPULoadOp#"clear"} for details.
	 */
	var loadOp: GPULoadOp;
	/**
	 * The store operation to perform on {@link GPURenderPassColorAttachment#view}
	 * after executing the render pass.
	 */
	var storeOp: GPUStoreOp;
}

typedef GPURenderPassDepthStencilAttachment = {
	/**
	 * A {@link GPUTextureView} describing the texture subresource that will be output to
	 * and read from for this depth/stencil attachment.
	 */
	var view: GPUTextureView;
	/**
	 * Indicates the value to clear {@link GPURenderPassDepthStencilAttachment#view}'s depth component
	 * to prior to executing the render pass. Ignored if {@link GPURenderPassDepthStencilAttachment#depthLoadOp}
	 * is not {@link GPULoadOp#"clear"}. Must be between 0.0 and 1.0, inclusive.
	 * <!-- POSTV1(unrestricted-depth) : unless unrestricted depth is enabled -->
	 */
	var ?depthClearValue: Float;
	/**
	 * Indicates the load operation to perform on {@link GPURenderPassDepthStencilAttachment#view}'s
	 * depth component prior to executing the render pass.
	 * Note: It is recommended to prefer clearing; see {@link GPULoadOp#"clear"} for details.
	 */
	var ?depthLoadOp: GPULoadOp;
	/**
	 * The store operation to perform on {@link GPURenderPassDepthStencilAttachment#view}'s
	 * depth component after executing the render pass.
	 */
	var ?depthStoreOp: GPUStoreOp;
	/**
	 * Indicates that the depth component of {@link GPURenderPassDepthStencilAttachment#view}
	 * is read only.
	 */
	var ?depthReadOnly: Bool;
	/**
	 * Indicates the value to clear {@link GPURenderPassDepthStencilAttachment#view}'s stencil component
	 * to prior to executing the render pass. Ignored if {@link GPURenderPassDepthStencilAttachment#stencilLoadOp}
	 * is not {@link GPULoadOp#"clear"}.
	 * The value will be converted to the type of the stencil aspect of `view` by taking the same
	 * Float of LSBs as the Float of bits in the stencil aspect of one texel block of `view`.
	 */
	var ?stencilClearValue: GPUStencilValue;
	/**
	 * Indicates the load operation to perform on {@link GPURenderPassDepthStencilAttachment#view}'s
	 * stencil component prior to executing the render pass.
	 * Note: It is recommended to prefer clearing; see {@link GPULoadOp#"clear"} for details.
	 */
	var ?stencilLoadOp: GPULoadOp;
	/**
	 * The store operation to perform on {@link GPURenderPassDepthStencilAttachment#view}'s
	 * stencil component after executing the render pass.
	 */
	var ?stencilStoreOp: GPUStoreOp;
	/**
	 * Indicates that the stencil component of {@link GPURenderPassDepthStencilAttachment#view}
	 * is read only.
	 */
	var ?stencilReadOnly: Bool;
}

enum abstract GPURenderPassTimestampLocation(String) {
	var Beginning = "beginning";
	var End = "end";
}

typedef GPURenderPassTimestampWrite = {
	var querySet: GPUQuerySet;
	var queryIndex: GPUSize32;
	var location: GPURenderPassTimestampLocation;
}

typedef GPURenderPassTimestampWrites = Array<GPURenderPassTimestampWrite>;

typedef GPURenderPassDescriptor = {>GPUObjectDescriptorBase,
	/**
	 * The set of {@link GPURenderPassColorAttachment} values in this sequence defines which
	 * color attachments will be output to when executing this render pass.
	 * Due to compatible usage list|usage compatibility, no color attachment
	 * may alias another attachment or any resource used inside the render pass.
	 */
	var colorAttachments: Array<Null<GPURenderPassColorAttachment>>;
	/**
	 * The {@link GPURenderPassDepthStencilAttachment} value that defines the depth/stencil
	 * attachment that will be output to and tested against when executing this render pass.
	 * Due to compatible usage list|usage compatibility, no writable depth/stencil attachment
	 * may alias another attachment or any resource used inside the render pass.
	 */
	var ?depthStencilAttachment: GPURenderPassDepthStencilAttachment;
	/**
	 * The {@link GPUQuerySet} value defines where the occlusion query results will be stored for this pass.
	 */
	var ?occlusionQuerySet: GPUQuerySet;
	/**
	 * A sequence of {@link GPURenderPassTimestampWrite} values defines where and when timestamp values will be written for this pass.
	 */
	var ?timestampWrites: GPURenderPassTimestampWrites;
	/**
	 * The maximum Float of draw calls that will be done in the render pass. Used by some
	 * implementations to size work injected before the render pass. Keeping the default value
	 * is a good default, unless it is known that more draw calls will be done.
	 */
	var ?maxDrawCount: GPUSize64;
}

extern class GPURenderPassEncoder extends GPURenderCommands {
	/**
	 * Sets the viewport used during the rasterization stage to linearly map from normalized device
	 * coordinates to viewport coordinates.
	 * @param x - Minimum X value of the viewport in pixels.
	 * @param y - Minimum Y value of the viewport in pixels.
	 * @param width - Width of the viewport in pixels.
	 * @param height - Height of the viewport in pixels.
	 * @param minDepth - Minimum depth value of the viewport.
	 * @param maxDepth - Maximum depth value of the viewport.
	 */
	function setViewport( x: Int, y: Int, width: Int, height: Int, minDepth: Float, maxDepth: Float ) : Void;
	/**
	 * Sets the scissor rectangle used during the rasterization stage.
	 * After transformation into viewport coordinates any fragments which fall outside the scissor
	 * rectangle will be discarded.
	 * @param x - Minimum X value of the scissor rectangle in pixels.
	 * @param y - Minimum Y value of the scissor rectangle in pixels.
	 * @param width - Width of the scissor rectangle in pixels.
	 * @param height - Height of the scissor rectangle in pixels.
	 */
	function setScissorRect( x: GPUIntegerCoordinate, y: GPUIntegerCoordinate, width: GPUIntegerCoordinate, height: GPUIntegerCoordinate ) : Void;
	/**
	 * Sets the constant blend color and alpha values used with {@link GPUBlendFactor#"constant"}
	 * and {@link GPUBlendFactor#"one-minus-constant"} {@link GPUBlendFactor}s.
	 * @param color - The color to use when blending.
	 */
	function setBlendConstant( color: GPUColor ) : Void;
	/**
	 * Sets the {@link RenderState#[[stencilReference]]} value used during stencil tests with
	 * the {@link GPUStencilOperation#"replace"} {@link GPUStencilOperation}.
	 * @param reference - The new stencil reference value.
	 */
	function setStencilReference( reference: GPUStencilValue ) : Void;
	/**
	 * @param queryIndex - The index of the query in the query set.
	 */
	function beginOcclusionQuery( queryIndex: GPUSize32 ) : Void;
	/**
	 */
	function endOcclusionQuery() : Void;
	/**
	 * Executes the commands previously recorded into the given {@link GPURenderBundle}s as part of
	 * this render pass.
	 * When a {@link GPURenderBundle} is executed, it does not inherit the render pass's pipeline, bind
	 * groups, or vertex and index buffers. After a {@link GPURenderBundle} has executed, the render
	 * pass's pipeline, bind group, and vertex/index buffer state is cleared
	 * (to the initial, empty values).
	 * Note: The state is cleared, not restored to the previous state.
	 * This occurs even if zero {@link GPURenderBundle|GPURenderBundles} are executed.
	 * @param bundles - List of render bundles to execute.
	 */
	function executeBundles( bundles: Array<GPURenderBundle> ) : Void;
	/**
	 * Completes recording of the render pass commands sequence.
	 */
	function end() : Void;
}

extern class GPURenderBundle {}

typedef GPUImageCopyBuffer = {>  GPUImageDataLayout,
	var ?offset : GPUSize64;
    var bytesPerRow : GPUSize32;
    var rowsPerImage : GPUSize32;
}

typedef GPUCommandBufferDescriptor = GPUObjectDescriptorBase;

enum abstract GPUComputePassTimestampLocation(String) {
	var Beginning = "beginning";
	var End = "end";
}

typedef GPUComputePassTimestampWrite = {
	var querySet: GPUQuerySet;
	var queryIndex: GPUSize32;
	var location: GPUComputePassTimestampLocation;
}

typedef GPUComputePassTimestampWrites = Array<GPUComputePassTimestampWrite>;

typedef GPUComputePassDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * A sequence of {@link GPUComputePassTimestampWrite} values define where and when timestamp values will be written for this pass.
	 */
	var ?timestampWrites: GPUComputePassTimestampWrites;
}

extern class GPUComputePassEncoder extends GPUBindingCommands {
	/**
	 * Sets the current {@link GPUComputePipeline}.
	 * @param pipeline - The compute pipeline to use for subsequent dispatch commands.
	 */
	function setPipeline( pipeline: GPUComputePipeline ) : Void;
	/**
	 * Dispatch work to be performed with the current {@link GPUComputePipeline}.
	 * See [[#computing-operations]] for the detailed specification.
	 * @param workgroupCountX - X dimension of the grid of workgroups to dispatch.
	 * @param workgroupCountY - Y dimension of the grid of workgroups to dispatch.
	 * @param workgroupCountZ - Z dimension of the grid of workgroups to dispatch.
	 */
	function dispatchWorkgroups( workgroupCountX: GPUSize32, ?workgroupCountY: GPUSize32, ?workgroupCountZ: GPUSize32 ) : Void;
	/**
	 * Dispatch work to be performed with the current {@link GPUComputePipeline} using parameters read
	 * from a {@link GPU_Buffer}.
	 * See [[#computing-operations]] for the detailed specification.
	 * packed block of **three 32-bit unsigned integer values (12 bytes total)**,
	 * given in the same order as the arguments for {@link GPUComputePassEncoder#dispatchWorkgroups}.
	 * For example:
	 * @param indirectBuffer - Buffer containing the indirect dispatch parameters.
	 * @param indirectOffset - Offset in bytes into `indirectBuffer` where the dispatch data begins.
	 */
	function dispatchWorkgroupsIndirect( indirectBuffer: GPU_Buffer, indirectOffset: GPUSize64 ) : Void;
	/**
	 * Completes recording of the compute pass commands sequence.
	 */
	function end() : Void;
}

extern class GPUCommandEncoder extends GPUDebugCommands {
	/**
	 * Begins encoding a render pass described by `descriptor`.
	 * @param descriptor - Description of the {@link GPURenderPassEncoder} to create.
	 */
	function beginRenderPass( descriptor: GPURenderPassDescriptor ) : GPURenderPassEncoder;
	/**
	 * Begins encoding a compute pass described by `descriptor`.
	 * 	descriptor:
	 */
	function beginComputePass( ?descriptor: GPUComputePassDescriptor ) : GPUComputePassEncoder;
	/**
	 * Encode a command into the {@link GPUCommandEncoder} that copies data from a sub-region of a
	 * {@link GPU_Buffer} to a sub-region of another {@link GPU_Buffer}.
	 * @param source - The {@link GPU_Buffer} to copy from.
	 * @param sourceOffset - Offset in bytes into `source` to begin copying from.
	 * @param destination - The {@link GPU_Buffer} to copy to.
	 * @param destinationOffset - Offset in bytes into `destination` to place the copied data.
	 * @param size - Bytes to copy.
	 */
	function copyBufferToBuffer( source: GPU_Buffer, sourceOffset: GPUSize64, destination: GPU_Buffer, destinationOffset: GPUSize64, size: GPUSize64 ) : Void;
	/**
	 * Encode a command into the {@link GPUCommandEncoder} that copies data from a sub-region of a
	 * {@link GPU_Buffer} to a sub-region of one or multiple continuous texture subresources.
	 * @param source - Combined with `copySize`, defines the region of the source buffer.
	 * @param destination - Combined with `copySize`, defines the region of the destination texture subresource.
	 * 	`copySize`:
	 */
	function copyBufferToTexture( source: GPUImageCopyBuffer, destination: GPUImageCopyTexture, copySize: GPUExtent3D ) : Void;
	/**
	 * Encode a command into the {@link GPUCommandEncoder} that copies data from a sub-region of one or
	 * multiple continuous texture subresourcesto a sub-region of a {@link GPU_Buffer}.
	 * @param source - Combined with `copySize`, defines the region of the source texture subresources.
	 * @param destination - Combined with `copySize`, defines the region of the destination buffer.
	 * 	`copySize`:
	 */
	function copyTextureToBuffer( source: GPUImageCopyTexture, destination: GPUImageCopyBuffer, copySize: GPUExtent3D ) : Void;
	/**
	 * Encode a command into the {@link GPUCommandEncoder} that copies data from a sub-region of one
	 * or multiple contiguous texture subresources to another sub-region of one or
	 * multiple continuous texture subresources.
	 * @param source - Combined with `copySize`, defines the region of the source texture subresources.
	 * @param destination - Combined with `copySize`, defines the region of the destination texture subresources.
	 * 	`copySize`:
	 */
	function copyTextureToTexture( source: GPUImageCopyTexture, destination: GPUImageCopyTexture, copySize: GPUExtent3D ) : Void;
	/**
	 * Encode a command into the {@link GPUCommandEncoder} that fills a sub-region of a
	 * {@link GPU_Buffer} with zeros.
	 * @param buffer - The {@link GPU_Buffer} to clear.
	 * @param offset - Offset in bytes into `buffer` where the sub-region to clear begins.
	 * @param size - Size in bytes of the sub-region to clear. Defaults to the size of the buffer minus `offset`.
	 */
	function clearBuffer( buffer: GPU_Buffer, ?offset: GPUSize64, ?size: GPUSize64 ) : Void;
	/**
	 * Writes a timestamp value into a querySet when all previous commands have completed executing.
	 * @param querySet - The query set that will store the timestamp values.
	 * @param queryIndex - The index of the query in the query set.
	 */
	function writeTimestamp( querySet: GPUQuerySet, queryIndex: GPUSize32 ) : Void;
	/**
	 * Resolves query results from a {@link GPUQuerySet} out into a range of a {@link GPU_Buffer}.
	 * 	querySet:
	 * 	firstQuery:
	 * 	queryCount:
	 * 	destination:
	 * 	destinationOffset:
	 */
	function resolveQuerySet( querySet: GPUQuerySet, firstQuery: GPUSize32, queryCount: GPUSize32, destination: GPU_Buffer, destinationOffset: GPUSize64 ) : Void;
	/**
	 * Completes recording of the commands sequence and returns a corresponding {@link GPUCommandBuffer}.
	 * 	descriptor:
	 */
	function finish( ?descriptor: GPUCommandBufferDescriptor ) : GPUCommandBuffer;
}

enum abstract GPUQueryType(String) {
	var Occlusion = "occlusion";
	var Timestamp = "timestamp";
}

extern class GPUQuerySet {
	/**
	 * Destroys the {@link GPUQuerySet}.
	 */
	function destroy() : Void;
	/**
	 * The type of the queries managed by this {@link GPUQuerySet}.
	 */
	var type(default,null) : GPUQueryType;
	/**
	 * The Float of queries managed by this {@link GPUQuerySet}.
	 */
	var count(default,null) : GPUSize32;
}

enum abstract GPUAddressMode(String) {
	var Clamp_to_edge = "clamp-to-edge";
	var Repeat = "repeat";
	var Mirror_repeat = "mirror-repeat";
}

enum abstract GPUFilterMode(String) {
	var Nearest = "nearest";
	var Linear = "linear";
}

enum abstract GPUMipmapFilterMode(String) {
	var Nearest = "nearest";
	var Linear = "linear";
}

typedef GPUSamplerDescriptor = {>
	/**
	 */
	var ?addressModeU: GPUAddressMode;
	/**
	 */
	var ?addressModeV: GPUAddressMode;
	/**
	 * Specifies the {{GPUAddressMode|address modes}} for the texture width, height, and depth
	 * coordinates, respectively.
	 */
	var ?addressModeW: GPUAddressMode;
	/**
	 * Specifies the sampling behavior when the sample footprint is smaller than or equal to one
	 * texel.
	 */
	var ?magFilter: GPUFilterMode;
	/**
	 * Specifies the sampling behavior when the sample footprint is larger than one texel.
	 */
	var ?minFilter: GPUFilterMode;
	/**
	 * Specifies behavior for sampling between mipmap levels.
	 */
	var ?mipmapFilter: GPUMipmapFilterMode;
	/**
	 */
	var ?lodMinClamp: Int;
	/**
	 * Specifies the minimum and maximum levels of detail, respectively, used internally when
	 * sampling a texture.
	 */
	var ?lodMaxClamp: Int;
	/**
	 * When provided the sampler will be a comparison sampler with the specified
	 * {@link GPUCompareFunction}.
	 * Note: Comparison samplers may use filtering, but the sampling results will be
	 * implementation-dependent and may differ from the normal filtering rules.
	 */
	var ?compare: GPUCompareFunction;
	/**
	 * Specifies the maximum anisotropy value clamp used by the sampler.
	 * Note: Most implementations support {@link GPUSamplerDescriptor#maxAnisotropy} values in range
	 * between 1 and 16, inclusive. The used value of {@link GPUSamplerDescriptor#maxAnisotropy} will
	 * be clamped to the maximum value that the platform supports.
	 */
	var ?maxAnisotropy: Int;
}

extern class GPUSampler {}


typedef GPUBufferBinding = {
	/**
	 * The {@link GPU_Buffer} to bind.
	 */
	var buffer: GPU_Buffer;
	/**
	 * The offset, in bytes, from the beginning of {@link GPUBufferBinding#buffer} to the
	 * beginning of the range exposed to the shader by the buffer binding.
	 */
	var ?offset: GPUSize64;
	/**
	 * The size, in bytes, of the buffer binding. If `Void`, specifies the range starting at
	 * {@link GPUBufferBinding#offset} and ending at the end of {@link GPUBufferBinding#buffer}.
	 */
	var ?size: GPUSize64;
}

extern class GPUExternalTexture {}

abstract GPUBindingResource(Dynamic) from GPUSampler from GPUTextureView from GPUBufferBinding from GPUExternalTexture {
}


typedef GPUBindGroupEntry = {
	/**
	 * A unique identifier for a resource binding within the {@link GPUBindGroup}, corresponding to a
	 * {@link GPUBindGroupLayoutEntry#binding|GPUBindGroupLayoutEntry.binding} and a @binding
	 * attribute in the {@link GPUShaderModule}.
	 */
	var binding: GPUIndex32;
	/**
	 * The resource to bind, which may be a {@link GPUSampler}, {@link GPUTextureView},
	 * {@link GPUExternalTexture}, or {@link GPUBufferBinding}.
	 */
	var resource: GPUBindingResource;
}

typedef GPUBindGroupDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * The {@link GPUBindGroupLayout} the entries of this bind group will conform to.
	 */
	var layout: GPUBindGroupLayout;
	/**
	 * A list of entries describing the resources to expose to the shader for each binding
	 * described by the {@link GPUBindGroupDescriptor#layout}.
	 */
	var entries: Array<GPUBindGroupEntry>;
}

enum GPUShaderStage {
	VERTEX;
	FRAGMENT;
	COMPUTE;
}

typedef GPUShaderStageFlags = haxe.EnumFlags<GPUShaderStage>;

enum abstract GPUBufferBindingType(String) {
	var Uniform = "uniform";
	var Storage = "storage";
	var Read_only_storage = "read-only-storage";
}

typedef GPUBufferBindingLayout = {
	/**
	 * Indicates the type required for buffers bound to this bindings.
	 */
	var ?type: GPUBufferBindingType;
	/**
	 * Indicates whether this binding requires a dynamic offset.
	 */
	var ?hasDynamicOffset: Bool;
	/**
	 * Indicates the minimum {@link GPUBufferBinding#size} of a buffer binding used with this bind point.
	 * Bindings are always validated against this size in {@link GPUDevice#createBindGroup}.
	 * If this *is not* `0`, pipeline creation additionally [$validating shader binding|validates$]
	 * that this value &ge; the minimum buffer binding size of the variable.
	 * If this *is* `0`, it is ignored by pipeline creation, and instead draw/dispatch commands
	 * [$Validate encoder bind groups|validate$] that each binding in the {@link GPUBindGroup}
	 * satisfies the minimum buffer binding size of the variable.
	 * Note:
	 * Similar execution-time validation is theoretically possible for other
	 * binding-related fields specified for early validation, like
	 * {@link GPUTextureBindingLayout#sampleType} and {@link GPUStorageTextureBindingLayout#format},
	 * which currently can only be validated in pipeline creation.
	 * However, such execution-time validation could be costly or unnecessarily complex, so it is
	 * available only for {@link GPUBufferBindingLayout#minBindingSize} which is expected to have the
	 * most ergonomic impact.
	 */
	var ?minBindingSize: GPUSize64;
}

enum abstract GPUSamplerBindingType(String) {
	var Filtering = "filtering";
	var Non_filtering = "non-filtering";
	var Comparison = "comparison";
}

typedef GPUSamplerBindingLayout = {
	/**
	 * Indicates the required type of a sampler bound to this bindings.
	 */
	var ?type: GPUSamplerBindingType;
}

enum abstract GPUTextureSampleType(String) {
	var Float = "float";
	var Unfilterable_float = "unfilterable-float";
	var Depth = "depth";
	var Sint = "sint";
	var Uint = "uint";
}

typedef GPUTextureBindingLayout = {
	/**
	 * Indicates the type required for texture views bound to this binding.
	 */
	var ?sampleType: GPUTextureSampleType;
	/**
	 * Indicates the required {@link GPUTextureViewDescriptor#dimension} for texture views bound to
	 * this binding.
	 */
	var ?viewDimension: GPUTextureViewDimension;
	/**
	 * Indicates whether or not texture views bound to this binding must be multisampled.
	 */
	var ?multisampled: Bool;
}

enum abstract GPUStorageTextureAccess(String) {
	var Write_only = "write_only";
}

typedef GPUStorageTextureBindingLayout = {
	/**
	 * Indicates whether texture views bound to this binding will be bound for read-only or
	 * write-only access.
	 */
	var ?access: GPUStorageTextureAccess;
	/**
	 * The required {@link GPUTextureViewDescriptor#format} of texture views bound to this binding.
	 */
	var format: GPUTextureFormat;
	/**
	 * Indicates the required {@link GPUTextureViewDescriptor#dimension} for texture views bound to
	 * this binding.
	 */
	var ?viewDimension: GPUTextureViewDimension;
}

typedef GPUExternalTextureBindingLayout = {}

typedef GPUBindGroupLayoutEntry = {
	/**
	 * A unique identifier for a resource binding within the {@link GPUBindGroupLayout}, corresponding
	 * to a {@link GPUBindGroupEntry#binding|GPUBindGroupEntry.binding} and a @binding
	 * attribute in the {@link GPUShaderModule}.
	 */
	var binding: GPUIndex32;
	/**
	 * A bitset of the members of {@link GPUShaderStage}.
	 * Each set bit indicates that a {@link GPUBindGroupLayoutEntry}'s resource
	 * will be accessible from the associated shader stage.
	 */
	var visibility: GPUShaderStageFlags;
	/**
	 * When not `Void`, indicates the binding resource type for this {@link GPUBindGroupLayoutEntry}
	 * is {@link GPUBufferBinding}.
	 */
	var ?buffer: GPUBufferBindingLayout;
	/**
	 * When not `Void`, indicates the binding resource type for this {@link GPUBindGroupLayoutEntry}
	 * is {@link GPUSampler}.
	 */
	var ?sampler: GPUSamplerBindingLayout;
	/**
	 * When not `Void`, indicates the binding resource type for this {@link GPUBindGroupLayoutEntry}
	 * is {@link GPUTextureView}.
	 */
	var ?texture: GPUTextureBindingLayout;
	/**
	 * When not `Void`, indicates the binding resource type for this {@link GPUBindGroupLayoutEntry}
	 * is {@link GPUTextureView}.
	 */
	var ?storageTexture: GPUStorageTextureBindingLayout;
	/**
	 * When not `Void`, indicates the binding resource type for this {@link GPUBindGroupLayoutEntry}
	 * is {@link GPUExternalTexture}.
	 */
	var ?externalTexture: GPUExternalTextureBindingLayout;
}

typedef GPUBindGroupLayoutDescriptor = {> GPUObjectDescriptorBase,
	var entries: Array<GPUBindGroupLayoutEntry>;
}

typedef GPUQuerySetDescriptor = {> GPUObjectDescriptorBase,
	/**
	 * The type of queries managed by {@link GPUQuerySet}.
	 */
	var type: GPUQueryType;
	/**
	 * The Float of queries managed by {@link GPUQuerySet}.
	 */
	var count: GPUSize32;
}

extern class GPUDevice {
	/**
	 * A set containing the {@link GPUFeatureName} values of the features
	 * supported by the device (i.e. the ones with which it was created).
	 */
	var features(default,null) : GPUSupportedFeatures;
	/**
	 * Exposes the limits supported by the device
	 * (which are exactly the ones with which it was created).
	 */
	var limits(default,null) : GPUSupportedLimits;
	/**
	 * The primary {@link GPUQueue} for this device.
	 */
	var queue(default,null) : GPUQueue;
	/**
	 * Destroys the device, preventing further operations on it.
	 * Outstanding asynchronous operations will fail.
	 * Note: It is valid to destroy a device multiple times.
	 */
	function destroy() : Void;

	function createBuffer( descriptor: GPUBufferDescriptor ) : GPU_Buffer;
	function createTexture( descriptor: GPUTextureDescriptor ) : GPUTexture;
	function createSampler( ?descriptor: GPUSamplerDescriptor ) : GPUSampler;
	//function importExternalTexture( descriptor: GPUExternalTextureDescriptor ) : GPUExternalTexture;
	function createPipelineLayout( descriptor: GPUPipelineLayoutDescriptor ) : GPUPipelineLayout;
	function createBindGroup( descriptor: GPUBindGroupDescriptor ) : GPUBindGroup;
	function createBindGroupLayout( descriptor: GPUBindGroupLayoutDescriptor ) : GPUBindGroupLayout;
	function createShaderModule( descriptor: GPUShaderModuleDescriptor ) : GPUShaderModule;
	function createComputePipeline( descriptor : GPUComputePipelineDescriptor ) : GPUComputePipeline;
	function createRenderPipeline( descriptor : GPURenderPipelineDescriptor ) : GPURenderPipeline;
	function createComputePipelineAsync( descriptor : GPUComputePipelineDescriptor ) : Promise<GPUComputePipeline>;
	function createRenderPipelineAsync( descriptor : GPURenderPipelineDescriptor ) : Promise<GPURenderPipeline>;
	function createCommandEncoder( ?descriptor: GPUCommandEncoderDescriptor ) : GPUCommandEncoder;
	//function createRenderBundleEncoder( descriptor : GPURenderBundleEncoderDescriptor ) : GPURenderBundleEncoder;
	function createQuerySet( descriptor : GPUQuerySetDescriptor ) : GPUQuerySet;
	var lost(default,null) : Promise<GPUDeviceLostInfo>;
	function pushErrorScope( filter : GPUErrorFilter ) : Void;
	function popErrorScope() : Promise<Null<GPUError>>;
	//onuncapturederror : EventHandler;
}


enum abstract GPUCanvasAlphaMode(String) {
	var Opaque = "opaque";
	var Premultiplied = "premultiplied";
}

typedef GPUCanvasConfiguration = {
	/**
	 * The {@link GPUDevice} that textures returned by {@link GPUCanvasContext#getCurrentTexture} will be
	 * compatible with.
	 */
	var device: GPUDevice;
	/**
	 * The format that textures returned by {@link GPUCanvasContext#getCurrentTexture} will have.
	 * Must be one of the Supported context formats.
	 */
	var format: GPUTextureFormat;
	/**
	 * The usage that textures returned by {@link GPUCanvasContext#getCurrentTexture} will have.
	 * {@link GPUTextureUsage#RENDER_ATTACHMENT} is the default, but is not automatically included
	 * if the usage is explicitly set. Be sure to include {@link GPUTextureUsage#RENDER_ATTACHMENT}
	 * when setting a custom usage if you wish to use textures returned by
	 * {@link GPUCanvasContext#getCurrentTexture} as color targets for a render pass.
	 */
	var ?usage: GPUTextureUsageFlags;
	/**
	 * The formats that views created from textures returned by
	 * {@link GPUCanvasContext#getCurrentTexture} may use.
	 */
	var ?viewFormats: Array<GPUTextureFormat>;
	/**
	 * The color space that values written into textures returned by
	 * {@link GPUCanvasContext#getCurrentTexture} should be displayed with.
	 */
	var ?colorSpace: PredefinedColorSpace;
	/**
	 * Determines the effect that alpha values will have on the content of textures returned by
	 * {@link GPUCanvasContext#getCurrentTexture} when read, displayed, or used as an image source.
	 */
	var ?alphaMode: GPUCanvasAlphaMode;
}

extern class GPUCanvasContext {
	var canvas(default,null) : js.html.CanvasElement;
	function configure( configuration: GPUCanvasConfiguration ) : Void;
	function unconfigure() : Void;
	/**
	 * Get the {@link GPUTexture} that will be composited to the document by the {@link GPUCanvasContext}
	 * next.
	 * Note: The same {@link GPUTexture} object will be returned by every
	 * call to {@link GPUCanvasContext#getCurrentTexture} made within the same frame (i.e. between
	 * invocations of "[$update the rendering of the WebGPU canvas$]"), even if that {@link GPUTexture}
	 * is destroyed, failed validation, or failed to allocate, **unless** the current texture has
	 * been removed (in [$Replace the drawing buffer$]).
	 */
	function getCurrentTexture() : GPUTexture;
}