#ifndef INCLUDED_openfl_gl_GLBuffer
#define INCLUDED_openfl_gl_GLBuffer

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <openfl/gl/GLObject.h>
HX_DECLARE_CLASS2(openfl,gl,GLBuffer)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
namespace openfl{
namespace gl{


class HXCPP_CLASS_ATTRIBUTES  GLBuffer_obj : public ::openfl::gl::GLObject_obj{
	public:
		typedef ::openfl::gl::GLObject_obj super;
		typedef GLBuffer_obj OBJ_;
		GLBuffer_obj();
		Void __construct(int version,Dynamic id);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GLBuffer_obj > __new(int version,Dynamic id);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GLBuffer_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("GLBuffer"); }

		virtual ::String getType( );

};

} // end namespace openfl
} // end namespace gl

#endif /* INCLUDED_openfl_gl_GLBuffer */ 
