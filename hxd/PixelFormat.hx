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
	PVRTC( ?v : Int);
	ASTC( ?v : Int );
	ETC( ?v : Int );
	S3TC( ?v : Int );
	Depth16;
	Depth24;
	Depth24Stencil8;
	Depth32;
}

enum abstract ASTC_FORMAT(Int) from Int to Int {
	final RGBA_4x4 = 0x93B0;
}

enum abstract DXT_FORMAT(Int) from Int to Int {
	final RGBA_DXT1 = 0x83F1;
	final RGBA_DXT3 = 0x83F2;
	final RGBA_DXT5 = 0x83F3;
}

enum abstract ETC_FORMAT(Int) from Int to Int {
	final RGB_ETC1 = 0x8D64;
}

enum abstract PVRTC_FORMAT(Int) from Int to Int {
	final RGB_4BPPV1 = 0x8C00;
	final RGBA_4BPPV1 = 0x8C02;
}