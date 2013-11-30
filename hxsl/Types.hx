package hxsl;

#if h3d

typedef Vec = h3d.Vector;
typedef IVec = Array<Int>;
typedef BVec = Array<Bool>;
typedef Matrix = h3d.Matrix;
typedef Sampler2D = /*h3d.mat.Texture*/ Dynamic;
typedef SamplerCube = /*h3d.mat.Texture*/ Dynamic;

#else

typedef Vec = Array<Float>;
typedef IVec = Array<Int>;
typedef BVec = Array<Bool>;
typedef Matrix = Array<Float>;
typedef Sampler2D = Dynamic;
typedef SamplerCube = Dynamic;

#end