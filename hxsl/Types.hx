package hxsl;

#if true

typedef Vec = h3d.Vector;
typedef IVec = Array<Int>;
typedef BVec = Array<Bool>;
typedef Matrix = h3d.Matrix;
typedef Texture = h3d.mat.Texture;
typedef Sampler2D = h3d.mat.Texture;
typedef SamplerCube = h3d.mat.Texture;

#else

typedef Vec = Array<Float>;
typedef IVec = Array<Int>;
typedef BVec = Array<Bool>;
typedef Matrix = Array<Float>;
typedef Texture = Dynamic;
typedef Sampler2D = Dynamic;
typedef SamplerCube = Dynamic;

#end