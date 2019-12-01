package hxd.snd.openal;

private typedef F32 = Float;
private typedef Bytes = haxe.io.Bytes;

private class Channel extends NativeChannel {

	var source : Source;
	var startup = 0.;
	static inline var FADE_START = 10; // prevent clic at startup

	public function new(source, samples) {
		this.source = source;
		super(samples);
		#if js
		gain.gain.value = source.volume;
		#end
	}

	@:noDebug
	override function onSample( out : haxe.io.Float32Array ) {
		var pos = 0;
		var count = out.length >> 1;
		if( source.duration > 0 ) {
			var volume = #if js 1.0 #else source.volume #end;
			var bufferIndex = 0;
			var baseSample = 0;
			var curSample = source.currentSample;
			var buffer = source.buffers[bufferIndex++];
			while( count > 0 ) {
				while( buffer != null && curSample >= buffer.samples ) {
					baseSample += buffer.samples;
					curSample -= buffer.samples;
					buffer = source.buffers[bufferIndex++];
				}
				if( buffer == null ) {
					if( source.loop ) {
						curSample = 0;
						baseSample = 0;
						bufferIndex = 0;
						buffer = source.buffers[bufferIndex++];
						continue;
					}
					break;
				}
				var scount = buffer.samples - curSample;
				if( scount > count ) scount = count;
				var read = curSample << 1;
				var data = buffer.data;
				if( startup < 1 ) {
					for( i in 0...scount ) {
						out[pos++] = data[read++] * volume * startup;
						out[pos++] = data[read++] * volume * startup;
						if( startup < 1. ) {
							startup += 1 / FADE_START;
							if( startup > 1 ) startup = 1;
						}
					}
				} else {
					for( i in 0...scount ) {
						out[pos++] = data[read++] * volume;
						out[pos++] = data[read++] * volume;
					}
				}
				count -= scount;
				curSample += scount;
			}
			source.currentSample = baseSample + curSample;
			if( source.currentSample < 0 ) throw baseSample+"/" + curSample;
		}

		for( i in 0...count<<1 )
			out[pos++] = 0.;
	}

}

class Source {

	// Necessary to prevent stopping the channel while it's still playing
	// This seems related to some lag in NativeChannel creation and data delivery
	static inline var STOP_DELAY = #if js 200 #else 0 #end;

	public static var CHANNEL_BUFSIZE = #if js 8192 #else 4096 #end; /* 100 ms latency @44.1Khz */

	static var ID = 0;
	static var all = new Map<Int,Source>();

	public var id : Int;
	public var chan : hxd.snd.NativeChannel;

	public var playedTime = 0.;
	public var currentSample : Int = 0;
	public var buffers : Array<Buffer> = [];
	public var loop = false;
	public var volume : F32 = 1.;
	public var playing(get, never) : Bool;
	public var duration : Float;
	public var frequency : Int;

	public function new() {
		id = ++ID;
		all.set(id, this);
	}

	public function updateDuration() {
		frequency = buffers.length == 0 ? 1 : buffers[0].frequency;
		duration = 0.;
		for( b in buffers )
			duration += b.samples / b.frequency;
	}

	inline function get_playing() return chan != null;

	public function play() {
		if( chan == null ) {
			playedTime = haxe.Timer.stamp() - currentSample / frequency;
			chan = new Channel(this, CHANNEL_BUFSIZE);
		}
	}

	public function stop( immediate = false ) {
		if( chan != null ) {
			if( STOP_DELAY == 0 || immediate )
				chan.stop();
			else
				haxe.Timer.delay(chan.stop, STOP_DELAY);
			chan = null;
		}
	}

	public function dispose() {
		stop();
		all.remove(id);
		id = 0;
	}

	public inline function toInt() return id;
	public static inline function ofInt(i) return all.get(i);
}


class Buffer {
	static var ID = 0;
	static var all = new Map<Int,Buffer>();

	public var id : Int;
	public var data : haxe.ds.Vector<F32>;
	public var frequency : Int = 1;
	public var samples : Int = 0;

	public function new() {
		id = ++ID;
		all.set(id, this);
	}

	public function dispose() {
		data = null;
		all.remove(id);
		id = 0;
	}

	public function alloc(size) {
		if( data == null || data.length != size )
			data = new haxe.ds.Vector(size);
		return data;
	}

	public inline function toInt() return id;
	public static inline function ofInt(i) return all.get(i);

}

/**
	On platforms that don't have native support for OpenAL, the Driver uses this
	emulator that only requires a NativeChannel implementation
**/
class Emulator {

	public static var NATIVE_FREQ(get,never) : Int;
	static var CACHED_FREQ : Null<Int>;
	static function get_NATIVE_FREQ() {
		if( CACHED_FREQ == null )
			CACHED_FREQ = #if js Std.int(hxd.snd.webaudio.Context.get().sampleRate) #else 44100 #end;
		return CACHED_FREQ;
	}

	// api

	public static function dopplerFactor(value : F32) {}
	public static function dopplerVelocity(value : F32) {}
	public static function speedOfSound(value : F32) {}
	public static function distanceModel(distanceModel : Int) {}

	// Renderer State management
	public static function enable(capability : Int) {}
	public static function disable(capability : Int) {}
	public static function isEnabled(capability : Int) return false;

	// State retrieval
	public static function getBooleanv(param : Int, values : Bytes) {
		throw "TODO";
	}
	public static function getIntegerv(param : Int, values : Bytes) {
		throw "TODO";
	}
	public static function getFloatv(param : Int, values : Bytes) {
		throw "TODO";
	}
	public static function getDoublev(param : Int, values : Bytes) {
		throw "TODO";
	}

	public static function getString(param : Int) : Bytes {
		throw "TODO";
	}

	public static function getBoolean(param : Int) : Bool {
		throw "TODO";
	}

	public static function getInteger(param : Int) : Int {
		throw "TODO";
	}

	public static function getFloat(param : Int) : F32 {
		throw "TODO";
	}

	public static function getDouble(param : Int) : Float {
		throw "TODO";
	}

	// Error retrieval
	public static function getError() : Int {
		return 0;
	}

	// Extension support
	public static function loadExtensions() {}

	public static function isExtensionPresent(extname : Bytes) : Bool {
		return false;
	}

	public static function getEnumValue(ename : Bytes) : Int {
		throw "TODO";
	}
	//public static function getProcAddress(fname   : Bytes) : Void*;

	// Set Listener parameters
	public static function listenerf(param : Int, value  : F32)
	{
		#if js
		switch (param) {
			case GAIN:
				hxd.snd.webaudio.Context.masterGain.gain.value = value;
		}
		#end
	}
	public static function listener3f(param : Int, value1 : F32, value2 : F32, value3 : F32) {}
	public static function listenerfv(param : Int, values : Bytes) {}
	public static function listeneri(param : Int, value  : Int) {}
	public static function listener3i(param : Int, value1 : Int, value2 : Int, value3 : Int) {}
	public static function listeneriv(param : Int, values : Bytes) {}

	// Get Listener parameters
	public static function getListenerf(param : Int) : F32 {
		throw "TODO";
	}
	public static function getListener3f(param : Int, values : Array<F32> ) {
		throw "TODO";
	}

	public static function getListenerfv(param : Int, values : Bytes) {
		throw "TODO";
	}
	public static function getListeneri(param : Int) : Int {
		throw "TODO";
	}
	public static function getListener3i(param : Int, values : Array<Int> ) {
		throw "TODO";
	}
	public static function getListeneriv(param : Int, values : Bytes) {
		throw "TODO";
	}

	// Source management
	public static function genSources(n : Int, sources : Bytes) {
		for( i in 0...n )
			sources.setInt32(i << 2, new Source().toInt());
	}

	public static function deleteSources(n : Int, sources : Bytes) {
		for( i in 0...n )
			Source.ofInt(sources.getInt32(i << 2)).dispose();
	}

	public static function isSource(source : Source) : Bool {
		return source != null;
	}

	// Set Source parameters
	public static function sourcef(source : Source, param : Int, value : F32) {
		switch( param ) {
		case SEC_OFFSET:
			source.currentSample = source.buffers.length == 0 ? 0 : Std.int(value * source.frequency);
			if( source.playing ) {
				source.stop(true);
				source.play();
			}
		case GAIN:
			source.volume = value;
			#if js
			if (source.chan != null) @:privateAccess source.chan.gain.gain.value = value;
			#end
		case REFERENCE_DISTANCE, ROLLOFF_FACTOR, MAX_DISTANCE:
			// nothing (spatialization)
		case PITCH:
			// nothing
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function source3f(source : Source, param : Int, value1 : F32, value2 : F32, value3 : F32) {
		switch( param ) {
		case POSITION, VELOCITY, DIRECTION:
			// nothing
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function sourcefv(source : Source, param : Int, values : Bytes) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function sourcei(source : Source, param : Int, value  : Int) {
		switch( param ) {
		case BUFFER:
			var b = Buffer.ofInt(value);
			source.buffers = b == null ? [] : [b];
			source.updateDuration();
			source.currentSample = 0;
		case LOOPING:
			source.loop = value != 0;
		case SAMPLE_OFFSET:
            source.currentSample = Std.int(getSourcef(source, SEC_OFFSET) / source.frequency);
			if( source.playing ) {
				source.stop(true);
				source.play();
			}
		case SOURCE_RELATIVE:
			// nothing
		case EFX.DIRECT_FILTER:
			// nothing
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function source3i(source : Source, param : Int, value1 : Int, value2 : Int, value3 : Int) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function sourceiv(source : Source, param : Int, values : Bytes) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}

	// Get Source parameters
	public static function getSourcef(source : Source, param : Int) : F32 {
		switch( param ) {
		case SEC_OFFSET:
			if( source.buffers.length == 0 )
				return 0;
			var now = haxe.Timer.stamp();
			var t = now - source.playedTime;
			var maxT = source.duration;
			if( source.loop ) {
				while( t > maxT ) {
					t -= maxT;
					source.playedTime += maxT;
				}
			} else if( t > maxT )
				t = maxT;
			return t;
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function getSourcei(source : Source, param : Int) : Int {
		switch( param ) {
		case SOURCE_STATE:
			return !source.playing || source.buffers.length == 0 || (!source.loop && (haxe.Timer.stamp() - source.playedTime) >= source.duration ) ? STOPPED : PLAYING;
		case BUFFERS_PROCESSED:
			if( source.loop )
				return 0;
			var count = 0;
			var cur = source.currentSample;
			for( b in source.buffers )
				if( cur >= b.samples ) {
					cur -= b.samples;
					count++;
				} else
					break;
			return count;
		case SAMPLE_OFFSET:
            return Std.int(getSourcef(source, SEC_OFFSET) * source.frequency);
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function getSource3f(source : Source, param : Int, values : Array<F32> ) {
		throw "TODO";
	}
	public static function getSourcefv(source : Source, param : Int, values : Bytes) {
		throw "TODO";
	}
	public static function getSource3i(source : Source, param : Int, values : Array<Int> ) {
		throw "TODO";
	}
	public static function getSourceiv(source : Source, param : Int, values : Bytes) {
		throw "TODO";
	}

	// Source controls
	public static function sourcePlayv(n : Int, sources : Bytes) {
		throw "TODO";
	}
	public static function sourceStopv(n : Int, sources : Bytes) {
		throw "TODO";
	}
	public static function sourceRewindv(n : Int, sources : Bytes) {
		throw "TODO";
	}
	public static function sourcePausev(n : Int, sources : Bytes) {
		throw "TODO";
	}

	public static function sourcePlay(source : Source) {
		source.play();
	}

	public static function sourceStop(source : Source) {
		source.stop();
		source.currentSample = 0;
	}

	public static function sourceRewind(source : Source) {
		throw "TODO";
	}
	public static function sourcePause(source : Source) {
		throw "TODO";
	}

	// Queue buffers onto a source
	public static function sourceQueueBuffers(source : Source, nb : Int, buffers : Bytes) {
		for( i in 0...nb ) {
			var b = Buffer.ofInt(buffers.getInt32(i * 4));
			if( b == null ) throw "assert";
			source.buffers.push(b);
		}
		source.updateDuration();
	}

	public static function sourceUnqueueBuffers(source : Source, nb : Int, buffers : Bytes) {
		for( i in 0...nb ) {
			var b = Buffer.ofInt(buffers.getInt32(i * 4));
			if( b != source.buffers[0] ) throw "assert";
			if( source.playing ) {
				if( source.currentSample < b.samples ) throw "assert";
				source.buffers.shift();
				source.currentSample -= b.samples;
				source.playedTime += b.samples / b.frequency;
			} else
				source.buffers.shift();
			source.updateDuration();
		}
	}

	// Buffer management
	public static function genBuffers(n : Int, buffers : Bytes) {
		for( i in 0...n )
			buffers.setInt32(i << 2, new Buffer().toInt());
	}
	public static function deleteBuffers(n : Int, buffers : Bytes) {
		for( i in 0...n )
			Buffer.ofInt(buffers.getInt32(i << 2)).dispose();
	}
	public static function isBuffer(buffer : Buffer) : Bool {
		return buffer != null;
	}

	@:noDebug
	public static function bufferData(buffer : Buffer, format : Int, data : Bytes, size : Int, freq : Int) {
		if( freq != NATIVE_FREQ )
			throw "Unsupported frequency value: " + freq +" should be " + NATIVE_FREQ;
		inline function sext16(v:Int) {
			return (v & 0x8000) == 0 ? v : v | 0xFFFF0000;
		}
		switch( format ) {
		case FORMAT_MONO8:
			var bdata = buffer.alloc(size*2);
			for( i in 0...size ) {
				var v = data.get(i) / 0xFF;
				bdata[i << 1] = v;
				bdata[(i<<1) | 1] = v;
			}
		case FORMAT_STEREO8:
			var bdata = buffer.alloc(size);
			for( i in 0...size ) {
				var v = data.get(i) / 0xFF;
				bdata[i] = v;
			}
		case FORMAT_MONO16:
			var bdata = buffer.alloc(size);
			for( i in 0...size>>1 ) {
				var v = sext16(data.getUInt16(i << 1)) / 0x8000;
				bdata[i << 1] = v;
				bdata[(i<<1) | 1] = v;
			}
		case FORMAT_STEREO16:
			var bdata = buffer.alloc(size >> 1);
			for( i in 0...size>>1 ) {
				var v = sext16(data.getUInt16(i << 1)) / 0x8000;
				bdata[i] = v;
			}
		case FORMAT_MONOF32:
			var bdata = buffer.alloc(size >> 1);
			for( i in 0...size >> 2 ) {
				var f = data.getFloat(i << 2);
				bdata[i << 1] = f;
				bdata[(i<<1) | 1] = f;
			}
		case FORMAT_STEREOF32:
			var bdata = buffer.alloc(size >> 2);
			#if flash
			flash.Memory.select(data.getData());
			#end
			for( i in 0...size>>2 )
				buffer.data[i] = #if flash flash.Memory.getFloat #else data.getFloat #end(i<<2);
		default:
			throw "Format not supported 0x" + StringTools.hex(format);
		}
		buffer.samples = buffer.data.length >> 1;
		buffer.frequency = freq;
	}

	// Set Buffer parameters
	public static function bufferf(buffer : Buffer, param : Int, value  : F32) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function buffer3f(buffer : Buffer, param : Int, value1 : F32, value2 : F32, value3 : F32) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function bufferfv(buffer : Buffer, param : Int, values : Bytes) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function bufferi(buffer : Buffer, param : Int, value  : Int) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function buffer3i(buffer : Buffer, param : Int, value1 : Int, value2 : Int, value3 : Int) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function bufferiv(buffer : Buffer, param : Int, values : Bytes) {
		switch( param ) {
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}

	// Get Buffer parameters
	public static function getBufferf(buffer : Buffer, param : Int) : F32 {
		throw "TODO";
	}
	public static function getBuffer3f(buffer : Buffer, param : Int, values : Array<F32> ) {
		throw "TODO";
	}
	public static function getBufferfv(buffer : Buffer, param : Int, values : Bytes) {
		throw "TODO";
	}
	public static function getBufferi(buffer : Buffer, param : Int ) : Int {
		switch( param ) {
		case SIZE: return buffer.data.length * 4;
		case BITS: return 32;
		case CHANNELS : return 2;
		default:
			throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}
	public static function getBuffer3i(buffer : Buffer, param : Int, values : Array<Int> ) {
		throw "TODO";
	}
	public static function getBufferiv(buffer : Buffer, param : Int, values : Bytes) {
		throw "TODO";
	}


	// --- our own float32 extension

	public static inline var FORMAT_MONOF32				= 0x1110;
	public static inline var FORMAT_STEREOF32			= 0x1111;

	// ------------------------------------------------------------------------
	// Constants
	// ------------------------------------------------------------------------

	public static inline var NONE                       = 0;
	public static inline var FALSE                      = 0;
	public static inline var TRUE                       = 1;

	public static inline var SOURCE_RELATIVE            = 0x202;
	public static inline var CONE_INNER_ANGLE           = 0x1001;
	public static inline var CONE_OUTER_ANGLE           = 0x1002;
	public static inline var PITCH                      = 0x1003;

	public static inline var POSITION                   = 0x1004;
	public static inline var DIRECTION                  = 0x1005;

	public static inline var VELOCITY                   = 0x1006;
	public static inline var LOOPING                    = 0x1007;
	public static inline var BUFFER                     = 0x1009;

	public static inline var GAIN                       = 0x100A;
	public static inline var MIN_GAIN                   = 0x100D;
	public static inline var MAX_GAIN                   = 0x100E;
	public static inline var ORIENTATION                = 0x100F;
	public static inline var SOURCE_STATE               = 0x1010;

	// Source state values
	public static inline var INITIAL                    = 0x1011;
	public static inline var PLAYING                    = 0x1012;
	public static inline var PAUSED                     = 0x1013;
	public static inline var STOPPED                    = 0x1014;

	public static inline var BUFFERS_QUEUED             = 0x1015;
	public static inline var BUFFERS_PROCESSED          = 0x1016;

	public static inline var REFERENCE_DISTANCE         = 0x1020;
	public static inline var ROLLOFF_FACTOR             = 0x1021;
	public static inline var CONE_OUTER_GAIN            = 0x1022;
	public static inline var MAX_DISTANCE               = 0x1023;

	public static inline var SEC_OFFSET                 = 0x1024;
	public static inline var SAMPLE_OFFSET              = 0x1025;
	public static inline var BYTE_OFFSET                = 0x1026;
	public static inline var SOURCE_TYPE                = 0x1027;

	// Source type value
	public static inline var STATIC                     = 0x1028;
	public static inline var STREAMING                  = 0x1029;
	public static inline var UNDETERMINED               = 0x1030;

	// Buffer format specifier
	public static inline var FORMAT_MONO8               = 0x1100;
	public static inline var FORMAT_MONO16              = 0x1101;
	public static inline var FORMAT_STEREO8             = 0x1102;
	public static inline var FORMAT_STEREO16            = 0x1103;

	// Buffer query
	public static inline var FREQUENCY                  = 0x2001;
	public static inline var BITS                       = 0x2002;
	public static inline var CHANNELS                   = 0x2003;
	public static inline var SIZE                       = 0x2004;

	// Buffer state(private)
	public static inline var UNUSED                     = 0x2010;
	public static inline var PENDING                    = 0x2011;
	public static inline var PROCESSED                  = 0x2012;

	// Errors
	public static inline var NO_ERROR                   = 0;
	public static inline var INVALID_NAME               = 0xA001;
	public static inline var INVALID_ENUM               = 0xA002;
	public static inline var INVALID_VALUE              = 0xA003;
	public static inline var INVALID_OPERATION          = 0xA004;
	public static inline var OUT_OF_MEMORY              = 0xA005;

	// Context strings
	public static inline var VENDOR                     = 0xB001;
	public static inline var VERSION                    = 0xB002;
	public static inline var RENDERER                   = 0xB003;
	public static inline var EXTENSIONS                 = 0xB004;

	// Context values
	public static inline var DOPPLER_FACTOR            = 0xC000;
	public static inline var DOPPLER_VELOCITY          = 0xC001;
	public static inline var SPEED_OF_SOUND            = 0xC003;
	public static inline var DISTANCE_MODEL            = 0xD000;

	// Distance model values
	public static inline var INVERSE_DISTANCE          = 0xD001;
	public static inline var INVERSE_DISTANCE_CLAMPED  = 0xD002;
	public static inline var LINEAR_DISTANCE           = 0xD003;
	public static inline var LINEAR_DISTANCE_CLAMPED   = 0xD004;
	public static inline var EXPONENT_DISTANCE         = 0xD005;
	public static inline var EXPONENT_DISTANCE_CLAMPED = 0xD006;

}




class Device {
	public function new() {
	}
}

class Context {
	public var device : Device;
	public function new(d) {
		this.device = d;
	}
}

class ALC {

	static var ctx : Context = null;

	public static function getError( device : Device ) : Int {
		return 0;
	}

	// Context management
	public static function createContext(device  : Device, attrlist : Bytes) : Context {
		return new Context(device);
	}

	public static function makeContextCurrent(context : Context) : Bool {
		ctx = context;
		return true;
	}

	public static function processContext(context : Context) {
	}

	public static function suspendContext(context : Context) {
	}

	public static function destroyContext(context : Context) {
	}

	public static function getCurrentContext() : Context {
		return ctx;
	}

	public static function getContextsDevice(context : Context) : Device {
		return ctx.device;
	}

	// Device management
	public static function openDevice(devicename : Bytes) : Device {
		return new Device();
	}

	public static function closeDevice(device : Device) : Bool {
		return true;
	}

	// Extension support
	public static function loadExtensions(alDevice : Device) { }

	public static function isExtensionPresent(device : Device, extname : Bytes) : Bool {
		return false;
	}
	public static function getEnumValue(device : Device, enumname : Bytes) : Int {
		throw "TODO";
	}
	// public static function alcGetProcAddress(device : Device, const ALCchar *funcname);

	// Query function
	public static function getString   (device : Device, param : Int) : Bytes {
		throw "TODO";
	}
	public static function getIntegerv (device : Device, param : Int, size : Int, values : Bytes) {
		switch (param) {
			case EFX.MAX_AUXILIARY_SENDS : 0;
			default : throw "Unsupported param 0x" + StringTools.hex(param);
		}
	}

	// Capture function
	// public static function captureOpenDevice(devicename : hl.Bytes, frequency : Int, format : Int, buffersize : Int) : Device;
	// public static function captureCloseDevice (device : Device) : Bool;
	// public static function captureStart       (device : Device) : Void;
	// public static function captureStop        (device : Device) : Void;
	// public static function captureSamples     (device : Device, buffer : hl.Bytes, samples : Int) : Void;

	// ------------------------------------------------------------------------
	// Constants
	// ------------------------------------------------------------------------

	public static inline var FALSE                            = 0;
	public static inline var TRUE                             = 1;

	// Context attributes
	public static inline var FREQUENCY                        = 0x1007;
	public static inline var REFRESH                          = 0x1008;
	public static inline var SYNC                             = 0x1009;
	public static inline var MONO_SOURCES                     = 0x1010;
	public static inline var STEREO_SOURCES                   = 0x1011;

	// Errors
	public static inline var NO_ERROR                         = 0;
	public static inline var INVALID_DEVICE                   = 0xA001;
	public static inline var INVALID_CONTEXT                  = 0xA002;
	public static inline var INVALID_ENUM                     = 0xA003;
	public static inline var INVALID_VALUE                    = 0xA004;
	public static inline var OUT_OF_MEMORY                    = 0xA005;

	// Runtime ALC version
	public static inline var MAJOR_VERSION                    = 0x1000;
	public static inline var MINOR_VERSION                    = 0x1001;

	// Context attribute list properties
	public static inline var ATTRIBUTES_SIZE                  = 0x1002;
	public static inline var ALL_ATTRIBUTES                   = 0x1003;

	// Device strings
	public static inline var DEFAULT_DEVICE_SPECIFIER         = 0x1004;
	public static inline var DEVICE_SPECIFIER                 = 0x1005;
	public static inline var EXTENSIONS                       = 0x1006;

	// Capture extension
	public static inline var EXT_CAPTURE                      = 1;
	public static inline var CAPTURE_DEVICE_SPECIFIER         = 0x310;
	public static inline var CAPTURE_DEFAULT_DEVICE_SPECIFIER = 0x311;
	public static inline var CAPTURE_SAMPLES                  = 0x312;

	// Enumerate All extension
	public static inline var ENUMERATE_ALL_EXT                = 1;
	public static inline var DEFAULT_ALL_DEVICES_SPECIFIER    = 0x1012;
	public static inline var ALL_DEVICES_SPECIFIER            = 0x1013;

}

class EFX {

	// Device attributes
	public static inline var EFX_MAJOR_VERSION                     = 0x20001;
	public static inline var EFX_MINOR_VERSION                     = 0x20002;
	public static inline var MAX_AUXILIARY_SENDS                   = 0x20003;

	// Listener properties.
	public static inline var METERS_PER_UNIT                       = 0x20004;

	// Source properties.
	public static inline var DIRECT_FILTER                         = 0x20005;
	public static inline var FILTER_NULL                           = 0x0000;

}

