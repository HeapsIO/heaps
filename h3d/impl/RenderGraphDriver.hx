package h3d.impl;
import h3d.impl.Driver;

#if render_graph
class RenderGraphDriver extends Driver {

	var d : Driver;
	var loggedShaders = new Map<Int,Bool>();
	var currentShader : hxsl.RuntimeShader;
	public var logLines : Array<String> = null;

	public function new( driver : Driver ) {
		this.d = driver;
		logEnable = true;
		driver.logEnable = true;
	}

	override function hasFeature( f : Feature ) {
		return d.hasFeature(f);
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return d.isSupportedFormat(fmt);
	}

	override function isDisposed() {
		return d.isDisposed();
	}

	override function dispose() {
		d.dispose();
	}

	override function begin( frame : Int ) {
		d.begin(frame);
	}

	override function clear( ?color : h3d.Vector4, ?depth : Float, ?stencil : Int ) {
		h3d.impl.RenderGraph.clearTarget();
		d.clear(color, depth, stencil);
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		d.captureRenderBuffer(pixels);
	}

	override function getDriverName( details : Bool ) {
		return "RenderGraphDriver " + d.getDriverName(details);
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		d.init(function(b) {
			log('OnCreate $b');
			onCreate(b);
		},forceSoftware);
	}

	override function resize( width : Int, height : Int ) {
		d.resize(width, height);
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		currentShader = shader;
		return d.selectShader(shader);
	}

	override function getNativeShaderCode( shader ) {
		return d.getNativeShaderCode(shader);
	}

	override function selectMaterial( pass : h3d.mat.Pass ) {
		d.selectMaterial(pass);
	}

	override function uploadShaderBuffers( buffers : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		uploadBuffer(buffers, currentShader.vertex, buffers.vertex, which);
		if ( currentShader.fragment != null )
			uploadBuffer(buffers, currentShader.fragment, buffers.fragment, which);
		d.uploadShaderBuffers(buffers, which);
	}

	function uploadBuffer( buffer : h3d.shader.Buffers, s : hxsl.RuntimeShader.RuntimeShaderData, buf : h3d.shader.Buffers.ShaderBuffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Globals:
		case Params:
		case Buffers:
		case Textures:
			inline function logVars( s : hxsl.RuntimeShader.RuntimeShaderData, buf : h3d.shader.Buffers.ShaderBuffers ) {
				var t = s.textures;
				while( t != null ) {
					RenderGraph.sampleTexture(buf.tex[t.pos]);
					log('Set ${s.kind.getName()} Texture@${t.pos} ' + t.name);
					t = t.next;
				}
			}
			logVars(s, buf);
		}
	}

	override function selectBuffer( buffer : Buffer ) {
		d.selectBuffer(buffer);
	}

	override function selectMultiBuffers( formats : hxd.BufferFormat.MultiFormat, buffers : Array<Buffer> ) {
		d.selectMultiBuffers(formats,buffers);
	}

	override function draw( ibuf : h3d.Buffer, startIndex : Int, ntriangles : Int ) {
		d.draw(ibuf, startIndex, ntriangles);
	}

	override function drawInstanced( ibuf, commands ) {
		d.drawInstanced(ibuf, commands);
	}

	override function flushShaderBuffers() {
		d.flushShaderBuffers();
	}

	override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		d.setRenderZone(x, y, width, height);
	}

	override function setRenderTarget( tex : Null<h3d.mat.Texture>, face = 0, mipMap = 0, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		h3d.impl.RenderGraph.setTarget(tex, face, mipMap, depthBinding);
		d.setRenderTarget(tex, face);
	}

	override function setRenderTargets( textures : Array<h3d.mat.Texture>, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		h3d.impl.RenderGraph.setTargets(textures, depthBinding);
		d.setRenderTargets(textures);
	}

	override function setDepth( depthBuffer : h3d.mat.Texture ) {
		h3d.impl.RenderGraph.setDepth(depthBuffer);
		d.setDepth(depthBuffer);
	}

	override function end() {
		d.end();
	}

	override function present() {
		d.present();
	}

	override function setDebug( b : Bool ) {
		d.setDebug(b);
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		return d.allocTexture(t);
	}

	override function allocDepthBuffer( t : h3d.mat.Texture ) : Texture {
		return d.allocDepthBuffer(t);
	}

	override function allocBuffer( b : Buffer ) : GPUBuffer {
		return d.allocBuffer(b);
	}

	override function allocInstanceBuffer(b, bytes) {
		d.allocInstanceBuffer(b, bytes);
	}

	override function uploadInstanceBufferBytes(b, startVertex, vertexCount, buf, bufPos) {
		d.uploadInstanceBufferBytes(b, startVertex, vertexCount, buf, bufPos);
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		d.disposeTexture(t);
	}

	override function disposeDepthBuffer(t : h3d.mat.Texture ) {
		d.disposeDepthBuffer(t);
	}

	override function disposeBuffer( b : h3d.Buffer ) {
		d.disposeBuffer(b);
	}

	override function disposeInstanceBuffer(b) {
		d.disposeInstanceBuffer(b);
	}

	override function uploadIndexData(i, startIndice, indiceCount, buf, bufPos) {
		d.uploadIndexData(i, startIndice, indiceCount, buf, bufPos);
	}

	override function uploadBufferData( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		d.uploadBufferData(b, startVertex, vertexCount, buf, bufPos);
	}

	override function uploadBufferBytes( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		d.uploadBufferBytes(b, startVertex, vertexCount, buf, bufPos);
	}

	override function readBufferBytes( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		d.readBufferBytes(b, startVertex, vertexCount, buf, bufPos);
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		d.uploadTextureBitmap(t, bmp, mipLevel, side);
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		d.uploadTexturePixels(t, pixels, mipLevel, side);
	}

	override function computeDispatch( x : Int = 1, y : Int = 1, z : Int = 1, barrier : Bool = true ) {
		d.computeDispatch(x, y, z, barrier);
	}

	override function getDefaultDepthBuffer() {
		return d.getDefaultDepthBuffer();
	}

	override function capturePixels(tex, layer, mipLevel, ?region) {
		return d.capturePixels(tex, layer, mipLevel, region);
	}

	override function copyTexture(from, to) {
		return d.copyTexture(from, to);
	}

	override function allocQuery(queryKind) {
		return d.allocQuery(queryKind);
	}

	override function deleteQuery(q) {
		d.deleteQuery(q);
	}

	override function beginQuery(q : Query) {
		d.beginQuery(q);
	}

	override function endQuery(q) {
		d.endQuery(q);
	}

	override function queryResultAvailable(q) {
		return d.queryResultAvailable(q);
	}

	override function queryResult( q : Query ) {
		return d.queryResult(q);
	}
}
#end