#ifndef INCLUDED_h3d_mat_MeshShader
#define INCLUDED_h3d_mat_MeshShader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/impl/Shader.h>
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,mat,MeshShader)
HX_DECLARE_CLASS2(h3d,mat,Texture)
namespace h3d{
namespace mat{


class HXCPP_CLASS_ATTRIBUTES  MeshShader_obj : public ::h3d::impl::Shader_obj{
	public:
		typedef ::h3d::impl::Shader_obj super;
		typedef MeshShader_obj OBJ_;
		MeshShader_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MeshShader_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MeshShader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MeshShader"); }

		int maxSkinMatrixes;
		bool hasVertexColor;
		bool hasVertexColorAdd;
		Dynamic lightSystem;
		bool hasSkin;
		bool hasZBias;
		bool hasShadowMap;
		bool killAlpha;
		bool hasAlphaMap;
		bool hasBlend;
		bool hasGlow;
		Dynamic lights;
		virtual Dynamic set_lightSystem( Dynamic l);
		Dynamic set_lightSystem_dyn();

		virtual ::String getConstants( bool vertex);

		Array< ::Dynamic > skinMatrixes;
		::h3d::Matrix mpos;
		::h3d::Matrix mproj;
		Float zBias;
		::h3d::Vector uvScale;
		::h3d::Vector uvDelta;
		::h3d::Matrix shadowLightProj;
		::h3d::Matrix shadowLightCenter;
		::h3d::Vector fog;
		::h3d::Matrix mposInv;
		::h3d::mat::Texture tex;
		::h3d::Vector colorAdd;
		::h3d::Vector colorMul;
		::h3d::Matrix colorMatrix;
		Float killAlphaThreshold;
		::h3d::mat::Texture alphaMap;
		::h3d::mat::Texture blendTexture;
		::h3d::mat::Texture glowTexture;
		Float glowAmount;
		::h3d::mat::Texture shadowTexture;
		::h3d::Vector shadowColor;
		static ::String VERTEX;
		static ::String FRAGMENT;
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_MeshShader */ 
