#ifndef INCLUDED_openfl_gl__GL_Float32Data_Impl_
#define INCLUDED_openfl_gl__GL_Float32Data_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS3(openfl,gl,_GL,Float32Data_Impl_)
HX_DECLARE_CLASS2(openfl,utils,ArrayBufferView)
HX_DECLARE_CLASS2(openfl,utils,Float32Array)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace openfl{
namespace gl{
namespace _GL{


class HXCPP_CLASS_ATTRIBUTES  Float32Data_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Float32Data_Impl__obj OBJ_;
		Float32Data_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Float32Data_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Float32Data_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Float32Data_Impl_"); }

		static Dynamic _new( Dynamic data);
		static Dynamic _new_dyn();

		static Array< Float > toDynamic( Dynamic this1);
		static Dynamic toDynamic_dyn();

		static Dynamic fromFloat32Array( ::openfl::utils::Float32Array f);
		static Dynamic fromFloat32Array_dyn();

		static Dynamic fromArrayFloat( Array< Float > f);
		static Dynamic fromArrayFloat_dyn();

};

} // end namespace openfl
} // end namespace gl
} // end namespace _GL

#endif /* INCLUDED_openfl_gl__GL_Float32Data_Impl_ */ 
