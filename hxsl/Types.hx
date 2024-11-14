package hxsl;

typedef Vec = h3d.Vector;
typedef Vec4 = h3d.Vector4;
typedef IVec = Array<Int>;
typedef BVec = Array<Bool>;
typedef Matrix = h3d.Matrix;
typedef Texture = h3d.mat.Texture;
typedef TextureArray = h3d.mat.TextureArray;
typedef TextureChannel = h3d.mat.Texture;
typedef Buffer = h3d.Buffer;

class ChannelTools {
	public static inline function isPackedFormat( c : TextureChannel ) {
		return c.format == h3d.mat.Texture.nativeFormat;
	}
}