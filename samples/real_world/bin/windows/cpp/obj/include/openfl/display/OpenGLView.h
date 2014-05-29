#ifndef INCLUDED_openfl_display_OpenGLView
#define INCLUDED_openfl_display_OpenGLView

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <openfl/display/DirectRenderer.h>
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(openfl,display,DirectRenderer)
HX_DECLARE_CLASS2(openfl,display,OpenGLView)
namespace openfl{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  OpenGLView_obj : public ::openfl::display::DirectRenderer_obj{
	public:
		typedef ::openfl::display::DirectRenderer_obj super;
		typedef OpenGLView_obj OBJ_;
		OpenGLView_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< OpenGLView_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~OpenGLView_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("OpenGLView"); }

		static ::String CONTEXT_LOST;
		static ::String CONTEXT_RESTORED;
		static bool isSupported;
		static bool get_isSupported( );
		static Dynamic get_isSupported_dyn();

};

} // end namespace openfl
} // end namespace display

#endif /* INCLUDED_openfl_display_OpenGLView */ 
