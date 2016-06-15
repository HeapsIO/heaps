package hxd.net;

@:autoBuild(hxd.net.Macros.buildSerializable())
interface Serializable {
	public var __uid : Int;
	public function getCLID() : Int;
	public function serialize( ctx : Serializer ) : Void;
	public function unserialize( ctx : Serializer ) : Void;
	public function getSerializeSchema() : Schema;
}

@:genericBuild(hxd.net.Macros.buildSerializableEnum())
class SerializableEnum<T> {
}