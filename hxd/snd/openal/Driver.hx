package hxd.snd.openal;

import hxd.snd.openal.AudioTypes;
import hxd.snd.Driver.DriverFeature;

#if hlopenal
import openal.AL;
import openal.ALC;
import openal.EFX;
#else
import hxd.snd.openal.Emulator;
#end

class Driver implements hxd.snd.Driver {
	public var device   (default, null) : Device;
	public var context  (default, null) : Context;
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

		if (AL.getError() != AL.NO_ERROR)
			throw "could not init openAL Driver";
	}

	public function hasFeature( f : DriverFeature ) {
		return switch( f ) {
		case MasterVolume: #if (hl || js) true #else false #end ;
		}
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
		source.inst = Source.ofInt(bytes.getInt32(0));
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
		source.sampleOffset = 0;
		source.playing = true;
	}

	public function stopSource(source : SourceHandle) : Void {
		AL.sourceStop(source.inst);
		source.playing = false;
	}

	public function setSourceVolume(source : SourceHandle, value : Float) : Void {
		AL.sourcef(source.inst, AL.GAIN, value);
	}

	public function createBuffer() : BufferHandle {
		var buffer = new BufferHandle();
		var bytes = getTmpBytes(4);
		AL.genBuffers(1, bytes);
		buffer.inst = Buffer.ofInt(bytes.getInt32(0));
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
			#if (js)
			case F32 : channelCount == 1 ? AL.FORMAT_MONOF32 : AL.FORMAT_STEREOF32;
			#else
			case F32 : channelCount == 1 ? AL.FORMAT_MONO16 : AL.FORMAT_STEREO16;
			#end
		}
		AL.bufferData(buffer.inst, alFormat, data, size, samplingRate);
	}

	public function getPlayedSampleCount(source : SourceHandle) : Int {
		var v = source.sampleOffset + AL.getSourcei(source.inst, AL.SAMPLE_OFFSET);
		if (v < 0)
			v = 0;
		return v;
	}

	public function getProcessedBuffers(source : SourceHandle) : Int {
		return AL.getSourcei(source.inst, AL.BUFFERS_PROCESSED);
	}

	public function queueBuffer(source : SourceHandle, buffer : BufferHandle, sampleStart : Int, endOfStream : Bool) : Void {
		var bytes = getTmpBytes(4);
		bytes.setInt32(0, buffer.inst.toInt());
		AL.sourceQueueBuffers(source.inst, 1, bytes);

		var err = AL.getError();
		if (err != AL.NO_ERROR)
			throw "Failed to queue buffers: " + StringTools.hex(err)+" ("+buffer.inst.toInt()+")";

		if (AL.getSourcei(source.inst, AL.SOURCE_STATE) == AL.STOPPED) {
			if (sampleStart > 0) {
				AL.sourcei(source.inst, AL.SAMPLE_OFFSET, sampleStart);
			} else {
				AL.sourcei(source.inst, AL.SAMPLE_OFFSET, 0);
			}
			if (source.playing)
				AL.sourcePlay(source.inst);
		}
		buffer.isEnd = endOfStream;
	}

	public function unqueueBuffer(source : SourceHandle, buffer : BufferHandle) : Void {
		var bytes = getTmpBytes(4);
		bytes.setInt32(0, buffer.inst.toInt());
		AL.sourceUnqueueBuffers(source.inst, 1, bytes);

		var size    = AL.getBufferi(buffer.inst, AL.SIZE);
		var bps     = AL.getBufferi(buffer.inst, AL.BITS) * AL.getBufferi(buffer.inst, AL.CHANNELS) / 8;
		var samples = Std.int(size / bps);

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

	public function getEffectDriver(type : String) : hxd.snd.Driver.EffectDriver<Dynamic> {
		return switch(type) {
			#if hlopenal
			case "pitch"          : new PitchDriver();
			case "spatialization" : new SpatializationDriver(this);
			case "lowpass"        : new LowPassDriver(this);
			case "reverb"         : new ReverbDriver(this);
			#end
			default               : new hxd.snd.Driver.EffectDriver<Dynamic>();
		}
	}
}