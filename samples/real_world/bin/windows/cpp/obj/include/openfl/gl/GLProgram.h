#ifndef INCLUDED_openfl_gl_GLProgram
#define INCLUDED_openfl_gl_GLProgram

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <openfl/gl/GLObject.h>
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLProgram)
HX_DECLARE_CLASS2(openfl,gl,GLShader)
namespace openfl{
namespace gl{


class HXCPP_CLASS_ATTRIBUTES  GLProgram_obj : public ::openfl::gl::GLObject_obj{
	public:
		typedef ::openfl::gl::GLObject_obj super;
		typedef GLProgram_obj OBJ_;
		GLProgram_obj();
		Void __construct(int version,Dynamic id);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GLProgram_obj > __new(int version,Dynamic id);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GLProgram_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("GLProgram"); }

		Array< ::Dynamic > shaders;
		virtual Void attach( ::openfl::gl::GLShader shader);
		Dynamic attach_dyn();

		virtual Array< ::Dynamic > getShaders( );
		Dynamic getShaders_dyn();

		virtual ::String getType( );

};

} // end namespace openfl
} // end namespace gl

#endif /* INCLUDED_openfl_gl_GLProgram */ 
