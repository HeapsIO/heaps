#include <hxcpp.h>

#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_UncaughtErrorEvents
#include <flash/events/UncaughtErrorEvents.h>
#endif
namespace flash{
namespace events{

Void UncaughtErrorEvents_obj::__construct(::flash::events::IEventDispatcher target)
{
HX_STACK_FRAME("flash.events.UncaughtErrorEvents","new",0x77705be7,"flash.events.UncaughtErrorEvents.new","flash/events/UncaughtErrorEvents.hx",3,0x1a26e789)
HX_STACK_THIS(this)
HX_STACK_ARG(target,"target")
{
	HX_STACK_LINE(3)
	super::__construct(target);
}
;
	return null();
}

//UncaughtErrorEvents_obj::~UncaughtErrorEvents_obj() { }

Dynamic UncaughtErrorEvents_obj::__CreateEmpty() { return  new UncaughtErrorEvents_obj; }
hx::ObjectPtr< UncaughtErrorEvents_obj > UncaughtErrorEvents_obj::__new(::flash::events::IEventDispatcher target)
{  hx::ObjectPtr< UncaughtErrorEvents_obj > result = new UncaughtErrorEvents_obj();
	result->__construct(target);
	return result;}

Dynamic UncaughtErrorEvents_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< UncaughtErrorEvents_obj > result = new UncaughtErrorEvents_obj();
	result->__construct(inArgs[0]);
	return result;}


UncaughtErrorEvents_obj::UncaughtErrorEvents_obj()
{
}

Dynamic UncaughtErrorEvents_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic UncaughtErrorEvents_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void UncaughtErrorEvents_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(UncaughtErrorEvents_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(UncaughtErrorEvents_obj::__mClass,"__mClass");
};

#endif

Class UncaughtErrorEvents_obj::__mClass;

void UncaughtErrorEvents_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.events.UncaughtErrorEvents"), hx::TCanCast< UncaughtErrorEvents_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void UncaughtErrorEvents_obj::__boot()
{
}

} // end namespace flash
} // end namespace events
