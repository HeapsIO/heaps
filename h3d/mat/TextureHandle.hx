package h3d.mat;

@:allow(h3d.impl.Driver)
class TextureHandle {
	public var texture(default, null) : h3d.mat.Texture;
	public var handle(default, null) : haxe.Int64;
	function new(t : h3d.mat.Texture, handle : haxe.Int64) {
		texture = t;
		this.handle = handle;
	}
}