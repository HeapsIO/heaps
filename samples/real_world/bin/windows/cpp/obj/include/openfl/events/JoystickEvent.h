#ifndef INCLUDED_openfl_events_JoystickEvent
#define INCLUDED_openfl_events_JoystickEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/Event.h>
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(openfl,events,JoystickEvent)
namespace openfl{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  JoystickEvent_obj : public ::flash::events::Event_obj{
	public:
		typedef ::flash::events::Event_obj super;
		typedef JoystickEvent_obj OBJ_;
		JoystickEvent_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_device,hx::Null< int >  __o_id,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< JoystickEvent_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_device,hx::Null< int >  __o_id,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~JoystickEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("JoystickEvent"); }

		Array< Float > axis;
		int device;
		int id;
		Float x;
		Float y;
		Float z;
		virtual ::flash::events::Event clone( );

		virtual ::String toString( );

		static ::String AXIS_MOVE;
		static ::String BALL_MOVE;
		static ::String BUTTON_DOWN;
		static ::String BUTTON_UP;
		static ::String HAT_MOVE;
		static ::String DEVICE_ADDED;
		static ::String DEVICE_REMOVED;
};

} // end namespace openfl
} // end namespace events

#endif /* INCLUDED_openfl_events_JoystickEvent */ 
