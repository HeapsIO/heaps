package h2d;

/**
	The blending rules when rendering a Tile/Material.
**/
enum BlendMode {
	/**
		`Out = 1 * Src + 0 * Dst`
	**/
	None;
	/**
		`Out = SrcA * Src + (1 - SrcA) * Dst`
	**/
	Alpha;
	/**
		`Out = SrcA * Src + 1 * Dst`
	**/
	Add;
	/**
		`Out = Src + (1 - SrcA) * Dst`
	**/
	AlphaAdd;
	/**
		`Out = (1 - Dst) * Src + 1 * Dst`
	**/
	SoftAdd;
	/**
		`Out = Dst * Src + 0 * Dst`
	**/
	Multiply;
	/**
		`Out = Dst * Src + (1 - SrcA) * Dst`
	**/
	AlphaMultiply;
	/**
		`Out = 0 * Src + (1 - Srb) * Dst`
	**/
	Erase;
	/**
		`Out = 1 * Src + (1 - Srb) * Dst`
	**/
	Screen;
	/**
		`Out = 1 * Dst - SrcA * Src`
	**/
	Sub;
	/**
		The output color is the max of the source and dest colors.  
		The blend parameters Src and Dst are ignored for this equation.  
		`Out = MAX( Src, Dst )`
	**/
	Max;
	/**
		The output color is the min of the source and dest colors.  
		The blend parameters Src and Dst are ignored for this equation.  
		`Out = MAX( Src, Dst )`
	**/
	Min;
}
