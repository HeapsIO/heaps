package hxsl;

typedef Vec = h3d.Vector;
typedef IVec = Array<Int>;
typedef BVec = Array<Bool>;
typedef Matrix = h3d.Matrix;
typedef Texture = h3d.mat.Texture;
typedef Sampler2D = h3d.mat.Texture;
typedef Sampler2DArray = h3d.mat.TextureArray;
typedef SamplerCube = h3d.mat.Texture;
typedef ChannelTextureType = h3d.mat.Texture;
typedef Buffer = h3d.Buffer;

class ChannelTools {
	public static inline function isPackedFormat( c : ChannelTextureType ) {
		return c.format == h3d.mat.Texture.nativeFormat;
	}
}