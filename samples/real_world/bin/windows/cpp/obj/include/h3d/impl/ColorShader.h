#ifndef INCLUDED_h3d_impl_ColorShader
#define INCLUDED_h3d_impl_ColorShader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/impl/Shader.h>
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,ColorShader)
HX_DECLARE_CLASS2(h3d,impl,Shader)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  ColorShader_obj : public ::h3d::impl::Shader_obj{
	public:
		typedef ::h3d::impl::Shader_obj super;
		typedef ColorShader_obj OBJ_;
		ColorShader_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ColorShader_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ColorShader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("ColorShader"); }

		::h3d::Matrix mproj;
		::h3d::Matrix mpos;
		::h3d::Vector col;
		static ::String VERTEX;
		static ::String FRAGMENT;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_ColorShader */ 
