#ifndef INCLUDED_flash_events_UncaughtErrorEvents
#define INCLUDED_flash_events_UncaughtErrorEvents

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/EventDispatcher.h>
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,events,UncaughtErrorEvents)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  UncaughtErrorEvents_obj : public ::flash::events::EventDispatcher_obj{
	public:
		typedef ::flash::events::EventDispatcher_obj super;
		typedef UncaughtErrorEvents_obj OBJ_;
		UncaughtErrorEvents_obj();
		Void __construct(::flash::events::IEventDispatcher target);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< UncaughtErrorEvents_obj > __new(::flash::events::IEventDispatcher target);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~UncaughtErrorEvents_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("UncaughtErrorEvents"); }

};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_UncaughtErrorEvents */ 
