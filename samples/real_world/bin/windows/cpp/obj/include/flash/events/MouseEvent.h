#ifndef INCLUDED_flash_events_MouseEvent
#define INCLUDED_flash_events_MouseEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/Event.h>
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,events,MouseEvent)
HX_DECLARE_CLASS2(flash,geom,Point)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  MouseEvent_obj : public ::flash::events::Event_obj{
	public:
		typedef ::flash::events::Event_obj super;
		typedef MouseEvent_obj OBJ_;
		MouseEvent_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< Float >  __o_localX,hx::Null< Float >  __o_localY,::flash::display::InteractiveObject relatedObject,hx::Null< bool >  __o_ctrlKey,hx::Null< bool >  __o_altKey,hx::Null< bool >  __o_shiftKey,hx::Null< bool >  __o_buttonDown,hx::Null< int >  __o_delta,hx::Null< bool >  __o_commandKey,hx::Null< int >  __o_clickCount);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MouseEvent_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< Float >  __o_localX,hx::Null< Float >  __o_localY,::flash::display::InteractiveObject relatedObject,hx::Null< bool >  __o_ctrlKey,hx::Null< bool >  __o_altKey,hx::Null< bool >  __o_shiftKey,hx::Null< bool >  __o_buttonDown,hx::Null< int >  __o_delta,hx::Null< bool >  __o_commandKey,hx::Null< int >  __o_clickCount);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MouseEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MouseEvent"); }

		bool altKey;
		bool buttonDown;
		int clickCount;
		bool commandKey;
		bool ctrlKey;
		int delta;
		Float localX;
		Float localY;
		::flash::display::InteractiveObject relatedObject;
		bool shiftKey;
		Float stageX;
		Float stageY;
		virtual ::flash::events::Event clone( );

		virtual ::String toString( );

		virtual Void updateAfterEvent( );
		Dynamic updateAfterEvent_dyn();

		virtual ::flash::events::MouseEvent __createSimilar( ::String type,::flash::display::InteractiveObject related,::flash::display::InteractiveObject target);
		Dynamic __createSimilar_dyn();

		static ::String DOUBLE_CLICK;
		static ::String CLICK;
		static ::String MIDDLE_CLICK;
		static ::String MIDDLE_MOUSE_DOWN;
		static ::String MIDDLE_MOUSE_UP;
		static ::String MOUSE_DOWN;
		static ::String MOUSE_MOVE;
		static ::String MOUSE_OUT;
		static ::String MOUSE_OVER;
		static ::String MOUSE_UP;
		static ::String MOUSE_WHEEL;
		static ::String RIGHT_CLICK;
		static ::String RIGHT_MOUSE_DOWN;
		static ::String RIGHT_MOUSE_UP;
		static ::String ROLL_OUT;
		static ::String ROLL_OVER;
		static int efLeftDown;
		static int efShiftDown;
		static int efCtrlDown;
		static int efAltDown;
		static int efCommandDown;
		static ::flash::events::MouseEvent __create( ::String type,Dynamic event,::flash::geom::Point local,::flash::display::InteractiveObject target);
		static Dynamic __create_dyn();

};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_MouseEvent */ 
