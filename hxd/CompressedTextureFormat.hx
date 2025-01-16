package hxd;

enum abstract ASTC_FORMAT(Int) from Int to Int {
	final RGBA_4x4 = 0x93B0;
}

enum abstract DXT_FORMAT(Int) from Int to Int {
	final RGB_DXT1 = 0x83F0;
	final RGBA_DXT1 = 0x83F1;
	final RGBA_DXT3 = 0x83F2;
	final RGBA_DXT5 = 0x83F3;
}

enum abstract ETC_FORMAT(Int) from Int to Int {
	final RGB_ETC1 = 0x8D64;
	final RGBA_ETC2 = 0x9278;
}

enum abstract BPTC_FORMAT(Int) from Int to Int {
	final RGB_BPTC_UNSIGNED = 0x8E8F;
	final RGBA_BPTC = 0x8E8C;
}
