#ifndef INCLUDED_h3d_impl_GLVB
#define INCLUDED_h3d_impl_GLVB

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,GLVB)
HX_DECLARE_CLASS2(openfl,gl,GLBuffer)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  GLVB_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef GLVB_obj OBJ_;
		GLVB_obj();
		Void __construct(::openfl::gl::GLBuffer b,hx::Null< int >  __o_s);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GLVB_obj > __new(::openfl::gl::GLBuffer b,hx::Null< int >  __o_s);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GLVB_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("GLVB"); }

		::openfl::gl::GLBuffer b;
		int stride;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_GLVB */ 
