#ifndef INCLUDED_flash_display_GraphicsPathWinding
#define INCLUDED_flash_display_GraphicsPathWinding

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,GraphicsPathWinding)
namespace flash{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  GraphicsPathWinding_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef GraphicsPathWinding_obj OBJ_;
		GraphicsPathWinding_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GraphicsPathWinding_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GraphicsPathWinding_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("GraphicsPathWinding"); }

		static ::String EVEN_ODD;
		static ::String NON_ZERO;
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_GraphicsPathWinding */ 
