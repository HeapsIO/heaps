package hxd;

enum PixelFormat {
	ARGB;
	BGRA;
	RGBA;
	RGBA16F;
	RGBA32F;
	R8;
	R16F;
	R32F;
	RG8;
	RG16F;
	RG32F;
	RGB8;
	RGB16F;
	RGB32F;
	SRGB;
	SRGB_ALPHA;
	RGB10A2;
	RG11B10UF; // unsigned float
	R16U;
	RG16U;
	RGB16U;
	RGBA16U;
	/**
		Adaptive Scalable Texture Compression
		- `10` 4x4 block size
	 */
	ASTC( v:Int );
	/**
		Ericsson Texture Compression
		- `0` ETC1 (opaque RGB) 
		- `1` ETC2 (with alpha)
	 */
	ETC( v:Int );
	/**
		S3 Texture Compression (DXT/BC)
		- `1`: BC1/DXT1 (opaque or 1-bit alpha)
		- `2`: BC2/DXT3 (explicit alpha)
		- `3`: BC3/DXT5 (interpolated alpha)
		- `6`: BC6H (HDR, unsigned float)
		- `7`: BC7 (high quality, alpha)
	 */
	S3TC( v:Int );
	Depth16;
	Depth24;
	Depth24Stencil8;
	Depth32;
}
