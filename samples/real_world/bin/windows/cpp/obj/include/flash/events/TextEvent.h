#ifndef INCLUDED_flash_events_TextEvent
#define INCLUDED_flash_events_TextEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/Event.h>
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,TextEvent)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  TextEvent_obj : public ::flash::events::Event_obj{
	public:
		typedef ::flash::events::Event_obj super;
		typedef TextEvent_obj OBJ_;
		TextEvent_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< TextEvent_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable,::String __o_text);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~TextEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("TextEvent"); }

		::String text;
		virtual ::flash::events::Event clone( );

		virtual ::String toString( );

		static ::String LINK;
		static ::String TEXT_INPUT;
};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_TextEvent */ 
