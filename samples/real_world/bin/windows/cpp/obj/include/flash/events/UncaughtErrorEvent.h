#ifndef INCLUDED_flash_events_UncaughtErrorEvent
#define INCLUDED_flash_events_UncaughtErrorEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/ErrorEvent.h>
HX_DECLARE_CLASS2(flash,events,ErrorEvent)
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,TextEvent)
HX_DECLARE_CLASS2(flash,events,UncaughtErrorEvent)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  UncaughtErrorEvent_obj : public ::flash::events::ErrorEvent_obj{
	public:
		typedef ::flash::events::ErrorEvent_obj super;
		typedef UncaughtErrorEvent_obj OBJ_;
		UncaughtErrorEvent_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,Dynamic error_in);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< UncaughtErrorEvent_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,Dynamic error_in);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~UncaughtErrorEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("UncaughtErrorEvent"); }

		Dynamic error;
		virtual ::flash::events::Event clone( );

		virtual ::String toString( );

		static ::String UNCAUGHT_ERROR;
};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_UncaughtErrorEvent */ 
