package hxd.impl;

#if js

typedef Float32Array = js.html.Float32Array;
typedef Uint16Array = js.html.Uint16Array;
typedef Uint8Array = js.html.Uint8Array;
typedef ArrayBuffer = js.html.ArrayBuffer;
typedef Uint32Array = js.html.Uint32Array;
typedef ArrayBufferView = js.html.ArrayBufferView;

#else
typedef Float32Array = haxe.ds.Vector<Float32>;
#end