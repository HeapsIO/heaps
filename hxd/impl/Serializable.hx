package hxd.impl;

#if (!hxbit || macro || !heaps_enable_serialize)

// disable serialization support
private interface NoSerializeSupport {
}
typedef Serializable = NoSerializeSupport;
typedef StructSerializable = NoSerializeSupport;

#else

typedef Serializable = hxbit.Serializable;
typedef StructSerializable = hxbit.StructSerializable;

#end

