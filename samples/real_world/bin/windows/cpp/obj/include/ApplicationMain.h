#ifndef INCLUDED_ApplicationMain
#define INCLUDED_ApplicationMain

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(ApplicationMain)
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,display,Sprite)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)


class HXCPP_CLASS_ATTRIBUTES  ApplicationMain_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ApplicationMain_obj OBJ_;
		ApplicationMain_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ApplicationMain_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ApplicationMain_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("ApplicationMain"); }

		static ::flash::display::Sprite barA;
		static ::flash::display::Sprite barB;
		static ::flash::display::Sprite container;
		static int forceHeight;
		static int forceWidth;
		static Void main( );
		static Dynamic main_dyn();

};


#endif /* INCLUDED_ApplicationMain */ 
