package h3d.mat;

enum Face {
	None;
	Back;
	Front;
	Both;
}

enum Blend {
	One;
	Zero;
	SrcAlpha;
	SrcColor;
	DstAlpha;
	DstColor;
	OneMinusSrcAlpha;
	OneMinusSrcColor;
	OneMinusDstAlpha;
	OneMinusDstColor;
	// only supported on WebGL
	ConstantColor;
	ConstantAlpha;
	OneMinusConstantColor;
	OneMinusConstantAlpha;
	SrcAlphaSaturate;
}

enum Compare {
	Always;
	Never;
	Equal;
	NotEqual;
	Greater;
	GreaterEqual;
	Less;
	LessEqual;
}

enum StencilOp {
	Keep;
	Zero;
	Replace;
	Increment;
	IncrementWrap;
	Decrement;
	DecrementWrap;
	Invert;
}

enum MipMap {
	None;
	Nearest;
	Linear;
}

enum Filter {
	Nearest;
	Linear;
}

enum Wrap {
	Clamp;
	Repeat;
	//Mirrored;
}

enum Operation {
	Add;
	Sub;
	ReverseSub;
	Min;
	Max;
}

enum TextureFlags {
	/**
		Allocate a texture that will be used as render target.
	**/
	Target;
	/**
		Allocate a cube texture. Might be restricted to power of two textures only.
	**/
	Cube;
	/**
		Activates Mip Mapping for this texture. Might not be available for target textures.
	**/
	MipMapped;
	/**
		By default, textures created with MipMapped will have their mipmaps generated when you upload the mipmap level 0. This flag disables this and manually upload mipmaps instead.
	**/
	ManualMipMapGen;
	/**
		This is a not power of two texture. Automatically set when having width or height being not power of two.
	**/
	IsNPOT;
	/**
		Don't initialy allocate the texture memory.
	**/
	NoAlloc;
	/**
		Inform that we will often perform upload operations on this texture
	**/
	Dynamic;
	/**
		Assumes that the color value of the texture is premultiplied by the alpha component.
	**/
	AlphaPremultiplied;
	/**
		Tells if the target texture has been cleared (reserved for internal engine usage).
	**/
	WasCleared;
	/**
		The texture is being currently loaded. Set onLoaded to get event when loading is complete.
	**/
	Loading;
	/**
		Allow texture data serialization when found in a scene (for user generated textures)
	**/
	Serialize;
	/**
		Tells if it's a texture array
	**/
	IsArray;
}

typedef TextureFormat = hxd.PixelFormat;

