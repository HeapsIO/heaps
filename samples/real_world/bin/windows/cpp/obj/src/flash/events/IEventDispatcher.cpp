#include <hxcpp.h>

#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
namespace flash{
namespace events{

HX_DEFINE_DYNAMIC_FUNC5(IEventDispatcher_obj,addEventListener,)

HX_DEFINE_DYNAMIC_FUNC1(IEventDispatcher_obj,dispatchEvent,return )

HX_DEFINE_DYNAMIC_FUNC1(IEventDispatcher_obj,hasEventListener,return )

HX_DEFINE_DYNAMIC_FUNC3(IEventDispatcher_obj,removeEventListener,)

HX_DEFINE_DYNAMIC_FUNC1(IEventDispatcher_obj,willTrigger,return )


static ::String sMemberFields[] = {
	HX_CSTRING("addEventListener"),
	HX_CSTRING("dispatchEvent"),
	HX_CSTRING("hasEventListener"),
	HX_CSTRING("removeEventListener"),
	HX_CSTRING("willTrigger"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IEventDispatcher_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IEventDispatcher_obj::__mClass,"__mClass");
};

#endif

Class IEventDispatcher_obj::__mClass;

void IEventDispatcher_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.IEventDispatcher"), hx::TCanCast< IEventDispatcher_obj> ,0,sMemberFields,
	0, 0,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void IEventDispatcher_obj::__boot()
{
}

} // end namespace flash
} // end namespace events
