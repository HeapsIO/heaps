#ifndef INCLUDED_hxd_System
#define INCLUDED_hxd_System

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS1(hxd,Cursor)
HX_DECLARE_CLASS1(hxd,System)
HX_DECLARE_CLASS2(openfl,display,DirectRenderer)
HX_DECLARE_CLASS2(openfl,display,OpenGLView)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  System_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef System_obj OBJ_;
		System_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< System_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~System_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("System"); }

		static int debugLevel;
		static Void ensureViewBelow( );
		static Dynamic ensureViewBelow_dyn();

		static ::openfl::display::OpenGLView VIEW;
		static int spin;
		static Void setLoop( Dynamic f);
		static Dynamic setLoop_dyn();

		static Dynamic setCursor;
		static Dynamic &setCursor_dyn() { return setCursor;}
		static Void setNativeCursor( ::hxd::Cursor c);
		static Dynamic setNativeCursor_dyn();

		static ::String get_lang( );
		static Dynamic get_lang_dyn();

		static Float get_screenDPI( );
		static Dynamic get_screenDPI_dyn();

		static bool get_isAndroid( );
		static Dynamic get_isAndroid_dyn();

		static ::String CACHED_NAME;
		static ::String getDeviceName( );
		static Dynamic getDeviceName_dyn();

		static Void exit( );
		static Dynamic exit_dyn();

		static bool get_isWindowed( );
		static Dynamic get_isWindowed_dyn();

		static bool get_isTouch( );
		static Dynamic get_isTouch_dyn();

		static int get_width( );
		static Dynamic get_width_dyn();

		static int get_height( );
		static Dynamic get_height_dyn();

		static Dynamic trace1( Dynamic msg,Dynamic pos);
		static Dynamic trace1_dyn();

		static Dynamic trace2( Dynamic msg,Dynamic pos);
		static Dynamic trace2_dyn();

		static Dynamic trace3( Dynamic msg,Dynamic pos);
		static Dynamic trace3_dyn();

		static Void trace4( ::String _);
		static Dynamic trace4_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_System */ 
