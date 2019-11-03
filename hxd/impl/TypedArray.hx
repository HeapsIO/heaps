package hxd.impl;

#if js

#if haxe4
typedef Float32Array = js.lib.Float32Array;
typedef Uint16Array = js.lib.Uint16Array;
typedef Int16Array = js.lib.Int16Array;
typedef Uint8Array = js.lib.Uint8Array;
typedef ArrayBuffer = js.lib.ArrayBuffer;
typedef Uint32Array = js.lib.Uint32Array;
typedef ArrayBufferView = js.lib.ArrayBufferView;
#else
typedef Float32Array = js.html.Float32Array;
typedef Uint16Array = js.html.Uint16Array;
typedef Int16Array = js.html.Int16Array;
typedef Uint8Array = js.html.Uint8Array;
typedef ArrayBuffer = js.html.ArrayBuffer;
typedef Uint32Array = js.html.Uint32Array;
typedef ArrayBufferView = js.html.ArrayBufferView;
#end

#else
typedef Float32Array = haxe.ds.Vector<Float32>;
#end