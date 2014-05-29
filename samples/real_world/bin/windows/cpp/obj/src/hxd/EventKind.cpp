#include <hxcpp.h>

#ifndef INCLUDED_hxd_EventKind
#include <hxd/EventKind.h>
#endif
namespace hxd{

::hxd::EventKind EventKind_obj::EFocus;

::hxd::EventKind EventKind_obj::EFocusLost;

::hxd::EventKind EventKind_obj::EKeyDown;

::hxd::EventKind EventKind_obj::EKeyUp;

::hxd::EventKind EventKind_obj::EMove;

::hxd::EventKind EventKind_obj::EOut;

::hxd::EventKind EventKind_obj::EOver;

::hxd::EventKind EventKind_obj::EPush;

::hxd::EventKind EventKind_obj::ERelease;

::hxd::EventKind EventKind_obj::EWheel;

HX_DEFINE_CREATE_ENUM(EventKind_obj)

int EventKind_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("EFocus")) return 6;
	if (inName==HX_CSTRING("EFocusLost")) return 7;
	if (inName==HX_CSTRING("EKeyDown")) return 8;
	if (inName==HX_CSTRING("EKeyUp")) return 9;
	if (inName==HX_CSTRING("EMove")) return 2;
	if (inName==HX_CSTRING("EOut")) return 4;
	if (inName==HX_CSTRING("EOver")) return 3;
	if (inName==HX_CSTRING("EPush")) return 0;
	if (inName==HX_CSTRING("ERelease")) return 1;
	if (inName==HX_CSTRING("EWheel")) return 5;
	return super::__FindIndex(inName);
}

int EventKind_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("EFocus")) return 0;
	if (inName==HX_CSTRING("EFocusLost")) return 0;
	if (inName==HX_CSTRING("EKeyDown")) return 0;
	if (inName==HX_CSTRING("EKeyUp")) return 0;
	if (inName==HX_CSTRING("EMove")) return 0;
	if (inName==HX_CSTRING("EOut")) return 0;
	if (inName==HX_CSTRING("EOver")) return 0;
	if (inName==HX_CSTRING("EPush")) return 0;
	if (inName==HX_CSTRING("ERelease")) return 0;
	if (inName==HX_CSTRING("EWheel")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic EventKind_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("EFocus")) return EFocus;
	if (inName==HX_CSTRING("EFocusLost")) return EFocusLost;
	if (inName==HX_CSTRING("EKeyDown")) return EKeyDown;
	if (inName==HX_CSTRING("EKeyUp")) return EKeyUp;
	if (inName==HX_CSTRING("EMove")) return EMove;
	if (inName==HX_CSTRING("EOut")) return EOut;
	if (inName==HX_CSTRING("EOver")) return EOver;
	if (inName==HX_CSTRING("EPush")) return EPush;
	if (inName==HX_CSTRING("ERelease")) return ERelease;
	if (inName==HX_CSTRING("EWheel")) return EWheel;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("EPush"),
	HX_CSTRING("ERelease"),
	HX_CSTRING("EMove"),
	HX_CSTRING("EOver"),
	HX_CSTRING("EOut"),
	HX_CSTRING("EWheel"),
	HX_CSTRING("EFocus"),
	HX_CSTRING("EFocusLost"),
	HX_CSTRING("EKeyDown"),
	HX_CSTRING("EKeyUp"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EventKind_obj::EFocus,"EFocus");
	HX_MARK_MEMBER_NAME(EventKind_obj::EFocusLost,"EFocusLost");
	HX_MARK_MEMBER_NAME(EventKind_obj::EKeyDown,"EKeyDown");
	HX_MARK_MEMBER_NAME(EventKind_obj::EKeyUp,"EKeyUp");
	HX_MARK_MEMBER_NAME(EventKind_obj::EMove,"EMove");
	HX_MARK_MEMBER_NAME(EventKind_obj::EOut,"EOut");
	HX_MARK_MEMBER_NAME(EventKind_obj::EOver,"EOver");
	HX_MARK_MEMBER_NAME(EventKind_obj::EPush,"EPush");
	HX_MARK_MEMBER_NAME(EventKind_obj::ERelease,"ERelease");
	HX_MARK_MEMBER_NAME(EventKind_obj::EWheel,"EWheel");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EventKind_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EFocus,"EFocus");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EFocusLost,"EFocusLost");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EKeyDown,"EKeyDown");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EKeyUp,"EKeyUp");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EMove,"EMove");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EOut,"EOut");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EOver,"EOver");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EPush,"EPush");
	HX_VISIT_MEMBER_NAME(EventKind_obj::ERelease,"ERelease");
	HX_VISIT_MEMBER_NAME(EventKind_obj::EWheel,"EWheel");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class EventKind_obj::__mClass;

Dynamic __Create_EventKind_obj() { return new EventKind_obj; }

void EventKind_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.EventKind"), hx::TCanCast< EventKind_obj >,sStaticFields,sMemberFields,
	&__Create_EventKind_obj, &__Create,
	&super::__SGetClass(), &CreateEventKind_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void EventKind_obj::__boot()
{
hx::Static(EFocus) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EFocus"),6);
hx::Static(EFocusLost) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EFocusLost"),7);
hx::Static(EKeyDown) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EKeyDown"),8);
hx::Static(EKeyUp) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EKeyUp"),9);
hx::Static(EMove) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EMove"),2);
hx::Static(EOut) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EOut"),4);
hx::Static(EOver) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EOver"),3);
hx::Static(EPush) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EPush"),0);
hx::Static(ERelease) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("ERelease"),1);
hx::Static(EWheel) = hx::CreateEnum< EventKind_obj >(HX_CSTRING("EWheel"),5);
}


} // end namespace hxd
