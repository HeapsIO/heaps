#include <hxcpp.h>

#ifndef INCLUDED_flash_display_StageQuality
#include <flash/display/StageQuality.h>
#endif
namespace flash{
namespace display{

::flash::display::StageQuality StageQuality_obj::BEST;

::flash::display::StageQuality StageQuality_obj::HIGH;

::flash::display::StageQuality StageQuality_obj::LOW;

::flash::display::StageQuality StageQuality_obj::MEDIUM;

HX_DEFINE_CREATE_ENUM(StageQuality_obj)

int StageQuality_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("BEST")) return 3;
	if (inName==HX_CSTRING("HIGH")) return 2;
	if (inName==HX_CSTRING("LOW")) return 0;
	if (inName==HX_CSTRING("MEDIUM")) return 1;
	return super::__FindIndex(inName);
}

int StageQuality_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("BEST")) return 0;
	if (inName==HX_CSTRING("HIGH")) return 0;
	if (inName==HX_CSTRING("LOW")) return 0;
	if (inName==HX_CSTRING("MEDIUM")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic StageQuality_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("BEST")) return BEST;
	if (inName==HX_CSTRING("HIGH")) return HIGH;
	if (inName==HX_CSTRING("LOW")) return LOW;
	if (inName==HX_CSTRING("MEDIUM")) return MEDIUM;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("LOW"),
	HX_CSTRING("MEDIUM"),
	HX_CSTRING("HIGH"),
	HX_CSTRING("BEST"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StageQuality_obj::BEST,"BEST");
	HX_MARK_MEMBER_NAME(StageQuality_obj::HIGH,"HIGH");
	HX_MARK_MEMBER_NAME(StageQuality_obj::LOW,"LOW");
	HX_MARK_MEMBER_NAME(StageQuality_obj::MEDIUM,"MEDIUM");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StageQuality_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(StageQuality_obj::BEST,"BEST");
	HX_VISIT_MEMBER_NAME(StageQuality_obj::HIGH,"HIGH");
	HX_VISIT_MEMBER_NAME(StageQuality_obj::LOW,"LOW");
	HX_VISIT_MEMBER_NAME(StageQuality_obj::MEDIUM,"MEDIUM");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class StageQuality_obj::__mClass;

Dynamic __Create_StageQuality_obj() { return new StageQuality_obj; }

void StageQuality_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.StageQuality"), hx::TCanCast< StageQuality_obj >,sStaticFields,sMemberFields,
	&__Create_StageQuality_obj, &__Create,
	&super::__SGetClass(), &CreateStageQuality_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void StageQuality_obj::__boot()
{
hx::Static(BEST) = hx::CreateEnum< StageQuality_obj >(HX_CSTRING("BEST"),3);
hx::Static(HIGH) = hx::CreateEnum< StageQuality_obj >(HX_CSTRING("HIGH"),2);
hx::Static(LOW) = hx::CreateEnum< StageQuality_obj >(HX_CSTRING("LOW"),0);
hx::Static(MEDIUM) = hx::CreateEnum< StageQuality_obj >(HX_CSTRING("MEDIUM"),1);
}


} // end namespace flash
} // end namespace display
