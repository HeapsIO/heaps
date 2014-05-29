#ifndef INCLUDED_h3d_impl_FBO
#define INCLUDED_h3d_impl_FBO

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,FBO)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(openfl,gl,GLFramebuffer)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLRenderbuffer)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  FBO_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FBO_obj OBJ_;
		FBO_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FBO_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FBO_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FBO"); }

		::openfl::gl::GLFramebuffer fbo;
		::h3d::mat::Texture color;
		::openfl::gl::GLRenderbuffer rbo;
		int width;
		int height;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_FBO */ 
