#ifndef INCLUDED_hxd_Stage
#define INCLUDED_hxd_Stage

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(List)
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,display,Stage)
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,events,KeyboardEvent)
HX_DECLARE_CLASS2(flash,events,MouseEvent)
HX_DECLARE_CLASS2(flash,events,TouchEvent)
HX_DECLARE_CLASS1(hxd,Event)
HX_DECLARE_CLASS1(hxd,Stage)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Stage_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Stage_obj OBJ_;
		Stage_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Stage_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Stage_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Stage"); }

		::flash::display::Stage stage;
		bool fsDelayed;
		::List resizeEvents;
		::List eventTargets;
		Float width;
		Float height;
		Float mouseX;
		Float mouseY;
		virtual Void event( ::hxd::Event e);
		Dynamic event_dyn();

		virtual Void addEventTarget( Dynamic et);
		Dynamic addEventTarget_dyn();

		virtual Void removeEventTarget( Dynamic et);
		Dynamic removeEventTarget_dyn();

		virtual Void addResizeEvent( Dynamic f);
		Dynamic addResizeEvent_dyn();

		virtual Void removeResizeEvent( Dynamic f);
		Dynamic removeResizeEvent_dyn();

		virtual Float getFrameRate( );
		Dynamic getFrameRate_dyn();

		virtual Void setFullScreen( bool v);
		Dynamic setFullScreen_dyn();

		virtual Float get_mouseX( );
		Dynamic get_mouseX_dyn();

		virtual Float get_mouseY( );
		Dynamic get_mouseY_dyn();

		virtual int get_width( );
		Dynamic get_width_dyn();

		virtual int get_height( );
		Dynamic get_height_dyn();

		virtual Void onResize( Dynamic _);
		Dynamic onResize_dyn();

		virtual Void onMouseDown( Dynamic e);
		Dynamic onMouseDown_dyn();

		virtual Void onRMouseDown( Dynamic e);
		Dynamic onRMouseDown_dyn();

		virtual Void onMouseUp( Dynamic e);
		Dynamic onMouseUp_dyn();

		virtual Void onRMouseUp( Dynamic e);
		Dynamic onRMouseUp_dyn();

		virtual Void onMouseMove( Dynamic e);
		Dynamic onMouseMove_dyn();

		virtual Void onMouseWheel( ::flash::events::MouseEvent e);
		Dynamic onMouseWheel_dyn();

		virtual Void onKeyUp( ::flash::events::KeyboardEvent e);
		Dynamic onKeyUp_dyn();

		virtual Void onKeyDown( ::flash::events::KeyboardEvent e);
		Dynamic onKeyDown_dyn();

		virtual int getCharCode( ::flash::events::KeyboardEvent e);
		Dynamic getCharCode_dyn();

		virtual Void onTouchDown( ::flash::events::TouchEvent e);
		Dynamic onTouchDown_dyn();

		virtual Void onTouchUp( ::flash::events::TouchEvent e);
		Dynamic onTouchUp_dyn();

		virtual Void onTouchMove( ::flash::events::TouchEvent e);
		Dynamic onTouchMove_dyn();

		static ::hxd::Stage inst;
		static ::hxd::Stage getInstance( );
		static Dynamic getInstance_dyn();

		static Void openFLBoot( Dynamic callb);
		static Dynamic openFLBoot_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Stage */ 
