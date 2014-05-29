#ifndef INCLUDED_flash_events_ProgressEvent
#define INCLUDED_flash_events_ProgressEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/Event.h>
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,ProgressEvent)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  ProgressEvent_obj : public ::flash::events::Event_obj{
	public:
		typedef ::flash::events::Event_obj super;
		typedef ProgressEvent_obj OBJ_;
		ProgressEvent_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_bytesLoaded,hx::Null< int >  __o_bytesTotal);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ProgressEvent_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,hx::Null< int >  __o_bytesLoaded,hx::Null< int >  __o_bytesTotal);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ProgressEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("ProgressEvent"); }

		int bytesLoaded;
		int bytesTotal;
		virtual ::flash::events::Event clone( );

		virtual ::String toString( );

		static ::String PROGRESS;
		static ::String SOCKET_DATA;
};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_ProgressEvent */ 
