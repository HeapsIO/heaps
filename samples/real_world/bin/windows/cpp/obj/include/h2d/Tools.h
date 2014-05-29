#ifndef INCLUDED_h2d_Tools
#define INCLUDED_h2d_Tools

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,Tools)
HX_DECLARE_CLASS2(h2d,_Tools,CoreObjects)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Tools_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Tools_obj OBJ_;
		Tools_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Tools_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Tools_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Tools"); }

		static ::h2d::_Tools::CoreObjects CORE;
		static ::h2d::_Tools::CoreObjects getCoreObjects( );
		static Dynamic getCoreObjects_dyn();

		static Void checkCoreObjects( );
		static Dynamic checkCoreObjects_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Tools */ 
