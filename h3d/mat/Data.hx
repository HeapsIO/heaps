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
}

enum TextureFlags {
	/**
		Allocate a texture that will be used as render target.
	**/
	Target;
	/**
		Add depth buffer on target texture
	**/
	TargetDepth;
	/**
		Use depth depth buffer when rendering to target texture
	**/
	TargetUseDefaultDepth;
	/**
		Allocate a cubic texture. Might be restricted to power of two textures only.
	**/
	Cubic;
	/**
		Used to prevent culling inversion on target textures in GL.
	**/
	TargetNoFlipY;
	/**
		Activates Mip Mapping for this texture. Might not be available for target textures.
	**/
	MipMapped;
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
		The texture format will contain Float values
	**/
	FmtFloat;
	/**
		16-bit RGB format
	**/
	Fmt5_6_5;
	/**
		16-bit RGBA format
	**/
	Fmt4_4_4_4;
	/**
		16-bit RGBA format (1 bit of alpha)
	**/
	Fmt5_5_5_1;
	/**
		Assumes that the color value of the texture is premultiplied by the alpha component.
	**/
	AlphaPremultiplied;
	/**
		Tells if the target texture has been cleared (reserved for internal engine usage).
	**/
	WasCleared;
}


