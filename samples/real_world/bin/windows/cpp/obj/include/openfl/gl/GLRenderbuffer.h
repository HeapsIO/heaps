#ifndef INCLUDED_openfl_gl_GLRenderbuffer
#define INCLUDED_openfl_gl_GLRenderbuffer

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <openfl/gl/GLObject.h>
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLRenderbuffer)
namespace openfl{
namespace gl{


class HXCPP_CLASS_ATTRIBUTES  GLRenderbuffer_obj : public ::openfl::gl::GLObject_obj{
	public:
		typedef ::openfl::gl::GLObject_obj super;
		typedef GLRenderbuffer_obj OBJ_;
		GLRenderbuffer_obj();
		Void __construct(int version,Dynamic id);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GLRenderbuffer_obj > __new(int version,Dynamic id);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GLRenderbuffer_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("GLRenderbuffer"); }

		virtual ::String getType( );

};

} // end namespace openfl
} // end namespace gl

#endif /* INCLUDED_openfl_gl_GLRenderbuffer */ 
