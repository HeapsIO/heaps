package hxd.snd;

#if usesys
typedef SourceHandle = haxe.AudioTypes.SourceHandle;
typedef BufferHandle = haxe.AudioTypes.BufferHandle;
#elseif (js && !useal)
typedef SourceHandle = hxd.snd.webaudio.AudioTypes.SourceHandle;
typedef BufferHandle = hxd.snd.webaudio.AudioTypes.BufferHandle;
#else
typedef SourceHandle = hxd.snd.openal.AudioTypes.SourceHandle;
typedef BufferHandle = hxd.snd.openal.AudioTypes.BufferHandle;
#end

class EffectDriver<T> {
	public function new() {}

	public function acquire () : Void {};
	public function release () : Void {};
	public function update  (e : T) : Void {};
	public function bind    (e : T, source : SourceHandle) : Void {};
	public function apply   (e : T, source : SourceHandle) : Void {};
	public function unbind  (e : T, source : SourceHandle) : Void {};
}

enum DriverFeature {
	MasterVolume;
}

interface Driver {
	public function hasFeature           (d : DriverFeature) : Bool;
	public function setMasterVolume      (value : Float) : Void;
	public function setListenerParams    (position : h3d.Vector, direction : h3d.Vector, up : h3d.Vector, ?velocity : h3d.Vector) : Void;

	public function createSource         () : SourceHandle;
	public function playSource           (source : SourceHandle) : Void;
	public function stopSource           (source : SourceHandle) : Void;
	public function setSourceVolume      (source : SourceHandle, value : Float) : Void;
	public function destroySource        (source : SourceHandle) : Void; 

	public function createBuffer         () : BufferHandle;
	public function setBufferData        (buffer : BufferHandle, data : haxe.io.Bytes, size : Int, format : Data.SampleFormat, channelCount : Int, samplingRate : Int) : Void;
	public function destroyBuffer        (buffer : BufferHandle) : Void;

	public function queueBuffer          (source : SourceHandle, buffer : BufferHandle, sampleStart : Int, endOfStream : Bool) : Void;
	public function unqueueBuffer        (source : SourceHandle, buffer : BufferHandle) : Void;
	public function getProcessedBuffers  (source : SourceHandle) : Int;
	public function getPlayedSampleCount (source : SourceHandle) : Int;

	public function update  () : Void;
	public function dispose () : Void;

	public function getEffectDriver(type : String) : EffectDriver<Dynamic>;
}