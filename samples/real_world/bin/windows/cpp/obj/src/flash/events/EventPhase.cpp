#include <hxcpp.h>

#ifndef INCLUDED_flash_events_EventPhase
#include <flash/events/EventPhase.h>
#endif
namespace flash{
namespace events{

::flash::events::EventPhase EventPhase_obj::AT_TARGET;

::flash::events::EventPhase EventPhase_obj::BUBBLING_PHASE;

::flash::events::EventPhase EventPhase_obj::CAPTURING_PHASE;

HX_DEFINE_CREATE_ENUM(EventPhase_obj)

int EventPhase_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("AT_TARGET")) return 1;
	if (inName==HX_CSTRING("BUBBLING_PHASE")) return 2;
	if (inName==HX_CSTRING("CAPTURING_PHASE")) return 0;
	return super::__FindIndex(inName);
}

int EventPhase_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("AT_TARGET")) return 0;
	if (inName==HX_CSTRING("BUBBLING_PHASE")) return 0;
	if (inName==HX_CSTRING("CAPTURING_PHASE")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic EventPhase_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("AT_TARGET")) return AT_TARGET;
	if (inName==HX_CSTRING("BUBBLING_PHASE")) return BUBBLING_PHASE;
	if (inName==HX_CSTRING("CAPTURING_PHASE")) return CAPTURING_PHASE;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("CAPTURING_PHASE"),
	HX_CSTRING("AT_TARGET"),
	HX_CSTRING("BUBBLING_PHASE"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EventPhase_obj::AT_TARGET,"AT_TARGET");
	HX_MARK_MEMBER_NAME(EventPhase_obj::BUBBLING_PHASE,"BUBBLING_PHASE");
	HX_MARK_MEMBER_NAME(EventPhase_obj::CAPTURING_PHASE,"CAPTURING_PHASE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EventPhase_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(EventPhase_obj::AT_TARGET,"AT_TARGET");
	HX_VISIT_MEMBER_NAME(EventPhase_obj::BUBBLING_PHASE,"BUBBLING_PHASE");
	HX_VISIT_MEMBER_NAME(EventPhase_obj::CAPTURING_PHASE,"CAPTURING_PHASE");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class EventPhase_obj::__mClass;

Dynamic __Create_EventPhase_obj() { return new EventPhase_obj; }

void EventPhase_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.EventPhase"), hx::TCanCast< EventPhase_obj >,sStaticFields,sMemberFields,
	&__Create_EventPhase_obj, &__Create,
	&super::__SGetClass(), &CreateEventPhase_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void EventPhase_obj::__boot()
{
hx::Static(AT_TARGET) = hx::CreateEnum< EventPhase_obj >(HX_CSTRING("AT_TARGET"),1);
hx::Static(BUBBLING_PHASE) = hx::CreateEnum< EventPhase_obj >(HX_CSTRING("BUBBLING_PHASE"),2);
hx::Static(CAPTURING_PHASE) = hx::CreateEnum< EventPhase_obj >(HX_CSTRING("CAPTURING_PHASE"),0);
}


} // end namespace flash
} // end namespace events
