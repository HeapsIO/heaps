#ifndef INCLUDED_h3d_impl_PointShader
#define INCLUDED_h3d_impl_PointShader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/impl/Shader.h>
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,PointShader)
HX_DECLARE_CLASS2(h3d,impl,Shader)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  PointShader_obj : public ::h3d::impl::Shader_obj{
	public:
		typedef ::h3d::impl::Shader_obj super;
		typedef PointShader_obj OBJ_;
		PointShader_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< PointShader_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~PointShader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("PointShader"); }

		::h3d::Matrix mproj;
		::h3d::Vector delta;
		::h3d::Vector size;
		int color;
		static ::String VERTEX;
		static ::String FRAGMENT;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_PointShader */ 
