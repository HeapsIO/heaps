package hxd.snd.openal;

import hxd.snd.Driver;

#if hlopenal
typedef AL           = openal.AL;
typedef ALC          = openal.ALC;
typedef ALSource     = openal.AL.Source;
typedef ALBuffer     = openal.AL.Buffer;
typedef ALDevice     = openal.ALC.Device;
typedef ALContext    = openal.ALC.Context;
typedef EFX          = openal.EFX;
typedef ALFilter     = openal.EFX.Filter;
typedef ALEffect     = openal.EFX.Effect;
typedef ALEffectSlot = openal.EFX.EffectSlot;
#else
// todo remove emulator & implement another driver
typedef AL           = ALEmulator;
typedef ALC          = ALEmulator.ALCEmulator;
typedef ALSource     = ALEmulator.ALSource;
typedef ALBuffer     = ALEmulator.ALBuffer;
typedef ALDevice     = ALEmulator.ALDevice;
typedef ALContext    = ALEmulator.ALContext;
typedef EFX          = ALEmulator.EFXEmulator;
typedef ALFilter     = Dynamic;
typedef ALEffect     = Dynamic;
typedef ALEffectSlot = Dynamic;
#end

class BufferHandle {
	public var inst : ALBuffer;
	public var isEnd : Bool;
	public function new() { }
}

class SourceHandle {
	public var inst           : ALSource;
	public var sampleOffset   : Int;
	var nextAuxiliarySend     : Int;
	var freeAuxiliarySends    : Array<Int>;
	var effectToAuxiliarySend : Map<Effect, Int>;

	public function new() {
		nextAuxiliarySend = 0;
		freeAuxiliarySends = [];
		effectToAuxiliarySend = new Map();
	}

	public function acquireAuxiliarySend(effect : Effect) : Int {
		var send = freeAuxiliarySends.length > 0
			? freeAuxiliarySends.shift()
			: nextAuxiliarySend++;
		effectToAuxiliarySend.set(effect, send);
		return send;
	}

	public function getAuxiliarySend(effect : Effect) : Int {
		return effectToAuxiliarySend.get(effect);
	}

	public function releaseAuxiliarySend(effect : Effect) : Int {
		var send = effectToAuxiliarySend.get(effect);
		effectToAuxiliarySend.remove(effect);
		freeAuxiliarySends.push(send);
		return send;
	}
}

class DriverImpl implements Driver {
	public var device   (default, null) : ALDevice;
	public var context  (default, null) : ALContext;
	public var maxAuxiliarySends(default, null) : Int;

	var tmpBytes : haxe.io.Bytes;

	public function new() {
		tmpBytes = haxe.io.Bytes.alloc(4 * 3 * 2);
		device   = ALC.openDevice(null);
		context  = ALC.createContext(device, null);

		ALC.makeContextCurrent(context);
		ALC.loadExtensions(device);
		AL.loadExtensions();

		// query maximum number of auxiliary sends
		var bytes = getTmpBytes(4);
		ALC.getIntegerv(device, EFX.MAX_AUXILIARY_SENDS, 1, bytes);
		maxAuxiliarySends = bytes.getInt32(0);
	}

	public function getTmpBytes(size) {
		if (tmpBytes.length < size) tmpBytes = haxe.io.Bytes.alloc(size);
		return tmpBytes;
	}

	public function setMasterVolume(value : Float) : Void {
		AL.listenerf(AL.GAIN, value);
	}

	public function setListenerParams(position : h3d.Vector, direction : h3d.Vector, up : h3d.Vector, ?velocity : h3d.Vector) : Void {
		AL.listener3f(AL.POSITION, -position.x, position.y, position.z);

		var bytes = getTmpBytes(24);
		bytes.setFloat(0,  -direction.x);
		bytes.setFloat(4,   direction.y);
		bytes.setFloat(8,   direction.z);

		up.normalize();
		bytes.setFloat(12, -up.x);
		bytes.setFloat(16,  up.y);
		bytes.setFloat(20,  up.z);

		AL.listenerfv(AL.ORIENTATION, tmpBytes);

		if (velocity != null)
			AL.listener3f(AL.VELOCITY, -velocity.x, velocity.y, velocity.z);
	}

	public function createSource() : SourceHandle {
		var source = new SourceHandle();
		var bytes = getTmpBytes(4);

		AL.genSources(1, bytes);
		if (AL.getError() != AL.NO_ERROR) throw "could not create source";
		source.inst = ALSource.ofInt(bytes.getInt32(0));
		AL.sourcei(source.inst, AL.SOURCE_RELATIVE, AL.TRUE);

		return source;
	}

	public function destroySource(source : SourceHandle) : Void {
		AL.sourcei(source.inst, EFX.DIRECT_FILTER, EFX.FILTER_NULL);

		var bytes = getTmpBytes(4);
		bytes.setInt32(0, source.inst.toInt());
		AL.deleteSources(1, bytes);
	}

	public function playSource(source : SourceHandle) : Void {
		AL.sourcePlay(source.inst);
	}

	public function stopSource(source : SourceHandle) : Void {
		AL.sourceStop(source.inst);
	}

	public function getSourceState(source : SourceHandle) : SourceState {
		return switch (AL.getSourcei(source.inst, AL.SOURCE_STATE)) {
			case AL.STOPPED : Stopped;
			case AL.PLAYING : Playing;
			default : Unhandled;
		};
	}

	public function setSourceVolume(source : SourceHandle, value : Float) : Void {
		AL.sourcef(source.inst, AL.GAIN, value);
	}

	public function createBuffer() : BufferHandle {
		var buffer = new BufferHandle();
		var bytes = getTmpBytes(4);
		AL.genBuffers(1, bytes);
		buffer.inst = ALBuffer.ofInt(bytes.getInt32(0));
		return buffer;
	}

	public function destroyBuffer(buffer : BufferHandle) : Void {
		var bytes = getTmpBytes(4);
		bytes.setInt32(0, buffer.inst.toInt());
		AL.deleteBuffers(1, bytes);
	}
	
	public function setBufferData(buffer : BufferHandle, data : haxe.io.Bytes, size : Int, format : Data.SampleFormat, channelCount : Int, samplingRate : Int) : Void {
		var alFormat = switch (format) {
			case UI8 : channelCount == 1 ? AL.FORMAT_MONO8  : AL.FORMAT_STEREO8;
			case I16 : channelCount == 1 ? AL.FORMAT_MONO16 : AL.FORMAT_STEREO16;
			case F32 : channelCount == 1 ? AL.FORMAT_MONO16 : AL.FORMAT_STEREO16;
		}
		AL.bufferData(buffer.inst, alFormat, data, size, samplingRate);
	}

	public function getPlayedSampleCount(source : SourceHandle) : Int {
		return source.sampleOffset + AL.getSourcei(source.inst, AL.SAMPLE_OFFSET);
	}

	public function getProcessedBuffers(source : SourceHandle) : Int {
		return AL.getSourcei(source.inst, AL.BUFFERS_PROCESSED);
	}
	
	public function queueBuffer(source : SourceHandle, buffer : BufferHandle, sampleStart : Int, endOfStream : Bool) : Void {
		var bytes = getTmpBytes(4);
		bytes.setInt32(0, buffer.inst.toInt());
		AL.sourceQueueBuffers(source.inst, 1, bytes);

		if (AL.getError() != AL.NO_ERROR)
			throw "Failed to queue buffers : format differs";

		if (AL.getSourcei(source.inst, AL.SOURCE_STATE) == AL.STOPPED) {
			if (sampleStart > 0) {
				AL.sourcei(source.inst, AL.SAMPLE_OFFSET, sampleStart);
				source.sampleOffset = -sampleStart;
			} else {
				source.sampleOffset = 0;
			}
		}
		buffer.isEnd = endOfStream;
	}
	
	public function unqueueBuffer(source : SourceHandle, buffer : BufferHandle) : Void {
		var bytes = getTmpBytes(4);
		bytes.setInt32(0, buffer.inst.toInt());
		AL.sourceUnqueueBuffers(source.inst, 1, bytes);

		var samples = Std.int(AL.getBufferi(buffer.inst, AL.SIZE) / AL.getBufferi(buffer.inst, AL.BITS) * 4);
		if (buffer.isEnd) source.sampleOffset = 0;
		else source.sampleOffset += samples;
	}
	
	public function update() : Void {
	}
	
	public function dispose() : Void {
		ALC.makeContextCurrent(null);
		ALC.destroyContext(context);
		ALC.closeDevice(device);
	}

	public function getEffectDriver(type : String) : EffectDriver<Dynamic> {
		switch(type) {
			case "pitch"          : return new PitchDriver(this);
			case "spatialization" : return new SpatializationDriver(this);
			case "lowpass"        : return new LowPassDriver(this);
			case "reverb"         : return new ReverbDriver(this);
			default : throw "nope";
		}
	}
}