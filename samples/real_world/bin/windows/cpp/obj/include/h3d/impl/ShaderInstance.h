#ifndef INCLUDED_h3d_impl_ShaderInstance
#define INCLUDED_h3d_impl_ShaderInstance

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,Attribute)
HX_DECLARE_CLASS2(h3d,impl,ShaderInstance)
HX_DECLARE_CLASS2(h3d,impl,Uniform)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLProgram)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  ShaderInstance_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ShaderInstance_obj OBJ_;
		ShaderInstance_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ShaderInstance_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ShaderInstance_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("ShaderInstance"); }

		::openfl::gl::GLProgram program;
		Array< ::Dynamic > attribs;
		Array< ::Dynamic > uniforms;
		int stride;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_ShaderInstance */ 
