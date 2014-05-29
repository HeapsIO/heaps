#ifndef INCLUDED_flash_events_IOErrorEvent
#define INCLUDED_flash_events_IOErrorEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/ErrorEvent.h>
HX_DECLARE_CLASS2(flash,events,ErrorEvent)
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,IOErrorEvent)
HX_DECLARE_CLASS2(flash,events,TextEvent)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  IOErrorEvent_obj : public ::flash::events::ErrorEvent_obj{
	public:
		typedef ::flash::events::ErrorEvent_obj super;
		typedef IOErrorEvent_obj OBJ_;
		IOErrorEvent_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text,hx::Null< int >  __o_id);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< IOErrorEvent_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text,hx::Null< int >  __o_id);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~IOErrorEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("IOErrorEvent"); }

		virtual ::flash::events::Event clone( );

		virtual ::String toString( );

		static ::String IO_ERROR;
};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_IOErrorEvent */ 
