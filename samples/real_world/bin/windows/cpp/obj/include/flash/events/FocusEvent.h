#ifndef INCLUDED_flash_events_FocusEvent
#define INCLUDED_flash_events_FocusEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/Event.h>
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,FocusEvent)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  FocusEvent_obj : public ::flash::events::Event_obj{
	public:
		typedef ::flash::events::Event_obj super;
		typedef FocusEvent_obj OBJ_;
		FocusEvent_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::flash::display::InteractiveObject relatedObject,hx::Null< bool >  __o_shiftKey,hx::Null< int >  __o_keyCode,::String __o_direction);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FocusEvent_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::flash::display::InteractiveObject relatedObject,hx::Null< bool >  __o_shiftKey,hx::Null< int >  __o_keyCode,::String __o_direction);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FocusEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FocusEvent"); }

		int keyCode;
		::flash::display::InteractiveObject relatedObject;
		bool shiftKey;
		virtual ::flash::events::Event clone( );

		virtual ::String toString( );

		static ::String FOCUS_IN;
		static ::String FOCUS_OUT;
		static ::String KEY_FOCUS_CHANGE;
		static ::String MOUSE_FOCUS_CHANGE;
};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_FocusEvent */ 
