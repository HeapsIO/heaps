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
	DestAlpha;
	DestColor;
	OneMinusSrcAlpha;
	OneMinusSrcColor;
	OneMinusDestAlpha;
	OneMinusDestColor;
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