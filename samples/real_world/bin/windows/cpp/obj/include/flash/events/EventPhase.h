#ifndef INCLUDED_flash_events_EventPhase
#define INCLUDED_flash_events_EventPhase

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,events,EventPhase)
namespace flash{
namespace events{


class EventPhase_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef EventPhase_obj OBJ_;

	public:
		EventPhase_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.events.EventPhase"); }
		::String __ToString() const { return HX_CSTRING("EventPhase.") + tag; }

		static ::flash::events::EventPhase AT_TARGET;
		static inline ::flash::events::EventPhase AT_TARGET_dyn() { return AT_TARGET; }
		static ::flash::events::EventPhase BUBBLING_PHASE;
		static inline ::flash::events::EventPhase BUBBLING_PHASE_dyn() { return BUBBLING_PHASE; }
		static ::flash::events::EventPhase CAPTURING_PHASE;
		static inline ::flash::events::EventPhase CAPTURING_PHASE_dyn() { return CAPTURING_PHASE; }
};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_EventPhase */ 
