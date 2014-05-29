#include <hxcpp.h>

#ifndef INCLUDED_flash_display_PixelSnapping
#include <flash/display/PixelSnapping.h>
#endif
namespace flash{
namespace display{

::flash::display::PixelSnapping PixelSnapping_obj::ALWAYS;

::flash::display::PixelSnapping PixelSnapping_obj::AUTO;

::flash::display::PixelSnapping PixelSnapping_obj::NEVER;

HX_DEFINE_CREATE_ENUM(PixelSnapping_obj)

int PixelSnapping_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("ALWAYS")) return 2;
	if (inName==HX_CSTRING("AUTO")) return 1;
	if (inName==HX_CSTRING("NEVER")) return 0;
	return super::__FindIndex(inName);
}

int PixelSnapping_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("ALWAYS")) return 0;
	if (inName==HX_CSTRING("AUTO")) return 0;
	if (inName==HX_CSTRING("NEVER")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic PixelSnapping_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("ALWAYS")) return ALWAYS;
	if (inName==HX_CSTRING("AUTO")) return AUTO;
	if (inName==HX_CSTRING("NEVER")) return NEVER;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("NEVER"),
	HX_CSTRING("AUTO"),
	HX_CSTRING("ALWAYS"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(PixelSnapping_obj::ALWAYS,"ALWAYS");
	HX_MARK_MEMBER_NAME(PixelSnapping_obj::AUTO,"AUTO");
	HX_MARK_MEMBER_NAME(PixelSnapping_obj::NEVER,"NEVER");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(PixelSnapping_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(PixelSnapping_obj::ALWAYS,"ALWAYS");
	HX_VISIT_MEMBER_NAME(PixelSnapping_obj::AUTO,"AUTO");
	HX_VISIT_MEMBER_NAME(PixelSnapping_obj::NEVER,"NEVER");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class PixelSnapping_obj::__mClass;

Dynamic __Create_PixelSnapping_obj() { return new PixelSnapping_obj; }

void PixelSnapping_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.PixelSnapping"), hx::TCanCast< PixelSnapping_obj >,sStaticFields,sMemberFields,
	&__Create_PixelSnapping_obj, &__Create,
	&super::__SGetClass(), &CreatePixelSnapping_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void PixelSnapping_obj::__boot()
{
hx::Static(ALWAYS) = hx::CreateEnum< PixelSnapping_obj >(HX_CSTRING("ALWAYS"),2);
hx::Static(AUTO) = hx::CreateEnum< PixelSnapping_obj >(HX_CSTRING("AUTO"),1);
hx::Static(NEVER) = hx::CreateEnum< PixelSnapping_obj >(HX_CSTRING("NEVER"),0);
}


} // end namespace flash
} // end namespace display
