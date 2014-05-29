#ifndef INCLUDED_h3d_mat_MeshMaterial
#define INCLUDED_h3d_mat_MeshMaterial

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/mat/Material.h>
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,mat,MeshMaterial)
HX_DECLARE_CLASS2(h3d,mat,MeshShader)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h3d{
namespace mat{


class HXCPP_CLASS_ATTRIBUTES  MeshMaterial_obj : public ::h3d::mat::Material_obj{
	public:
		typedef ::h3d::mat::Material_obj super;
		typedef MeshMaterial_obj OBJ_;
		MeshMaterial_obj();
		Void __construct(::h3d::mat::Texture texture,::h3d::mat::MeshShader sh);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MeshMaterial_obj > __new(::h3d::mat::Texture texture,::h3d::mat::MeshShader sh);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MeshMaterial_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MeshMaterial"); }

		::h3d::mat::Texture texture;
		bool useMatrixPos;
		Dynamic shadowMap;
		int id;
		virtual ::h3d::mat::Material clone( ::h3d::mat::Material m);

		virtual Void setup( ::h3d::scene::RenderContext ctx);

		virtual ::h3d::mat::MeshShader get_mshader( );
		Dynamic get_mshader_dyn();

		virtual ::h3d::mat::MeshShader set_mshader( ::h3d::mat::MeshShader v);
		Dynamic set_mshader_dyn();

		virtual Void setDXTSupport( bool enable,hx::Null< bool >  alpha);
		Dynamic setDXTSupport_dyn();

		virtual ::h3d::Vector get_uvScale( );
		Dynamic get_uvScale_dyn();

		virtual ::h3d::Vector set_uvScale( ::h3d::Vector v);
		Dynamic set_uvScale_dyn();

		virtual ::h3d::Vector get_uvDelta( );
		Dynamic get_uvDelta_dyn();

		virtual ::h3d::Vector set_uvDelta( ::h3d::Vector v);
		Dynamic set_uvDelta_dyn();

		virtual bool get_killAlpha( );
		Dynamic get_killAlpha_dyn();

		virtual bool set_killAlpha( bool v);
		Dynamic set_killAlpha_dyn();

		virtual ::h3d::Vector get_colorAdd( );
		Dynamic get_colorAdd_dyn();

		virtual ::h3d::Vector set_colorAdd( ::h3d::Vector v);
		Dynamic set_colorAdd_dyn();

		virtual ::h3d::Vector get_colorMul( );
		Dynamic get_colorMul_dyn();

		virtual ::h3d::Vector set_colorMul( ::h3d::Vector v);
		Dynamic set_colorMul_dyn();

		virtual ::h3d::Matrix get_colorMatrix( );
		Dynamic get_colorMatrix_dyn();

		virtual ::h3d::Matrix set_colorMatrix( ::h3d::Matrix v);
		Dynamic set_colorMatrix_dyn();

		virtual bool get_hasSkin( );
		Dynamic get_hasSkin_dyn();

		virtual bool set_hasSkin( bool v);
		Dynamic set_hasSkin_dyn();

		virtual bool get_hasVertexColor( );
		Dynamic get_hasVertexColor_dyn();

		virtual bool set_hasVertexColor( bool v);
		Dynamic set_hasVertexColor_dyn();

		virtual bool get_hasVertexColorAdd( );
		Dynamic get_hasVertexColorAdd_dyn();

		virtual bool set_hasVertexColorAdd( bool v);
		Dynamic set_hasVertexColorAdd_dyn();

		virtual Array< ::Dynamic > get_skinMatrixes( );
		Dynamic get_skinMatrixes_dyn();

		virtual Array< ::Dynamic > set_skinMatrixes( Array< ::Dynamic > v);
		Dynamic set_skinMatrixes_dyn();

		virtual Dynamic get_lightSystem( );
		Dynamic get_lightSystem_dyn();

		virtual Dynamic set_lightSystem( Dynamic v);
		Dynamic set_lightSystem_dyn();

		virtual ::h3d::mat::Texture get_alphaMap( );
		Dynamic get_alphaMap_dyn();

		virtual ::h3d::mat::Texture set_alphaMap( ::h3d::mat::Texture m);
		Dynamic set_alphaMap_dyn();

		virtual Dynamic get_zBias( );
		Dynamic get_zBias_dyn();

		virtual Dynamic set_zBias( Dynamic v);
		Dynamic set_zBias_dyn();

		virtual ::h3d::mat::Texture get_glowTexture( );
		Dynamic get_glowTexture_dyn();

		virtual ::h3d::mat::Texture set_glowTexture( ::h3d::mat::Texture t);
		Dynamic set_glowTexture_dyn();

		virtual Float get_glowAmount( );
		Dynamic get_glowAmount_dyn();

		virtual Float set_glowAmount( Float v);
		Dynamic set_glowAmount_dyn();

		virtual ::h3d::Vector get_fog( );
		Dynamic get_fog_dyn();

		virtual ::h3d::Vector set_fog( ::h3d::Vector v);
		Dynamic set_fog_dyn();

		virtual ::h3d::mat::Texture get_blendTexture( );
		Dynamic get_blendTexture_dyn();

		virtual ::h3d::mat::Texture set_blendTexture( ::h3d::mat::Texture v);
		Dynamic set_blendTexture_dyn();

		virtual Float get_killAlphaThreshold( );
		Dynamic get_killAlphaThreshold_dyn();

		virtual Float set_killAlphaThreshold( Float v);
		Dynamic set_killAlphaThreshold_dyn();

		virtual Dynamic set_shadowMap( Dynamic v);
		Dynamic set_shadowMap_dyn();

		static int uid;
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_MeshMaterial */ 
