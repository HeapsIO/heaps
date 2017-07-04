package hxsl;

typedef Vec = h3d.Vector;
typedef IVec = Array<Int>;
typedef BVec = Array<Bool>;
typedef Matrix = h3d.Matrix;
typedef Texture = h3d.mat.Texture;
typedef Sampler2D = h3d.mat.Texture;
typedef SamplerCube = h3d.mat.Texture;
typedef ChannelTexture = h3d.mat.Texture;

class ChannelTools {
	public static inline function isPackedFormat( c : ChannelTexture ) {
		return c.format == h3d.mat.Texture.nativeFormat;
	}
}