#ifndef INCLUDED_h3d_mat_Material
#define INCLUDED_h3d_mat_Material

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,mat,Blend)
HX_DECLARE_CLASS2(h3d,mat,Compare)
HX_DECLARE_CLASS2(h3d,mat,Face)
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h3d{
namespace mat{


class HXCPP_CLASS_ATTRIBUTES  Material_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Material_obj OBJ_;
		Material_obj();
		Void __construct(::h3d::impl::Shader shader);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Material_obj > __new(::h3d::impl::Shader shader);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Material_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Material"); }

		int bits;
		::h3d::mat::Face culling;
		bool depthWrite;
		::h3d::mat::Compare depthTest;
		::h3d::mat::Blend blendSrc;
		::h3d::mat::Blend blendDst;
		int colorMask;
		::h3d::impl::Shader shader;
		int renderPass;
		virtual Void setup( ::h3d::scene::RenderContext ctx);
		Dynamic setup_dyn();

		virtual Void blend( ::h3d::mat::Blend src,::h3d::mat::Blend dst);
		Dynamic blend_dyn();

		virtual ::h3d::mat::Material clone( ::h3d::mat::Material m);
		Dynamic clone_dyn();

		virtual Void depth( bool write,::h3d::mat::Compare test);
		Dynamic depth_dyn();

		virtual Void setColorMask( bool r,bool g,bool b,bool a);
		Dynamic setColorMask_dyn();

		virtual ::h3d::mat::Face set_culling( ::h3d::mat::Face f);
		Dynamic set_culling_dyn();

		virtual bool set_depthWrite( bool b);
		Dynamic set_depthWrite_dyn();

		virtual ::h3d::mat::Compare set_depthTest( ::h3d::mat::Compare c);
		Dynamic set_depthTest_dyn();

		virtual ::h3d::mat::Blend set_blendSrc( ::h3d::mat::Blend b);
		Dynamic set_blendSrc_dyn();

		virtual ::h3d::mat::Blend set_blendDst( ::h3d::mat::Blend b);
		Dynamic set_blendDst_dyn();

		virtual int set_colorMask( int m);
		Dynamic set_colorMask_dyn();

};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_Material */ 
