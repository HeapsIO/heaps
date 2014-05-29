#ifndef INCLUDED_flash_display_Shape
#define INCLUDED_flash_display_Shape

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/display/DisplayObject.h>
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,Shape)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
namespace flash{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  Shape_obj : public ::flash::display::DisplayObject_obj{
	public:
		typedef ::flash::display::DisplayObject_obj super;
		typedef Shape_obj OBJ_;
		Shape_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Shape_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Shape_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Shape"); }

};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_Shape */ 
