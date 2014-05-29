#ifndef INCLUDED_h2d_DrawableShader
#define INCLUDED_h2d_DrawableShader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/impl/Shader.h>
HX_DECLARE_CLASS1(h2d,DrawableShader)
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,mat,Texture)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  DrawableShader_obj : public ::h3d::impl::Shader_obj{
	public:
		typedef ::h3d::impl::Shader_obj super;
		typedef DrawableShader_obj OBJ_;
		DrawableShader_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< DrawableShader_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~DrawableShader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("DrawableShader"); }

		int ref;
		bool hasColorKey;
		::h3d::Vector sinusDeform;
		bool filter;
		bool tileWrap;
		bool killAlpha;
		bool hasAlpha;
		bool hasVertexAlpha;
		bool hasVertexColor;
		bool hasAlphaMap;
		bool hasMultMap;
		bool isAlphaPremul;
		virtual ::String getConstants( bool vertex);

		::h3d::Vector size;
		::h3d::Vector matA;
		::h3d::Vector matB;
		Float zValue;
		::h3d::Vector uvPos;
		::h3d::Vector uvScale;
		::h3d::mat::Texture tex;
		::h3d::Vector alphaUV;
		::h3d::mat::Texture alphaMap;
		Float multMapFactor;
		::h3d::Vector multUV;
		::h3d::mat::Texture multMap;
		Float alpha;
		int colorKey;
		::h3d::Vector colorAdd;
		::h3d::Vector colorMul;
		::h3d::Matrix colorMatrix;
		static ::String VERTEX;
		static ::String FRAGMENT;
};

} // end namespace h2d

#endif /* INCLUDED_h2d_DrawableShader */ 
