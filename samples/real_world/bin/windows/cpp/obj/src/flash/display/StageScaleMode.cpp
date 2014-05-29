#include <hxcpp.h>

#ifndef INCLUDED_flash_display_StageScaleMode
#include <flash/display/StageScaleMode.h>
#endif
namespace flash{
namespace display{

::flash::display::StageScaleMode StageScaleMode_obj::EXACT_FIT;

::flash::display::StageScaleMode StageScaleMode_obj::NO_BORDER;

::flash::display::StageScaleMode StageScaleMode_obj::NO_SCALE;

::flash::display::StageScaleMode StageScaleMode_obj::SHOW_ALL;

HX_DEFINE_CREATE_ENUM(StageScaleMode_obj)

int StageScaleMode_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("EXACT_FIT")) return 3;
	if (inName==HX_CSTRING("NO_BORDER")) return 2;
	if (inName==HX_CSTRING("NO_SCALE")) return 1;
	if (inName==HX_CSTRING("SHOW_ALL")) return 0;
	return super::__FindIndex(inName);
}

int StageScaleMode_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("EXACT_FIT")) return 0;
	if (inName==HX_CSTRING("NO_BORDER")) return 0;
	if (inName==HX_CSTRING("NO_SCALE")) return 0;
	if (inName==HX_CSTRING("SHOW_ALL")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic StageScaleMode_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("EXACT_FIT")) return EXACT_FIT;
	if (inName==HX_CSTRING("NO_BORDER")) return NO_BORDER;
	if (inName==HX_CSTRING("NO_SCALE")) return NO_SCALE;
	if (inName==HX_CSTRING("SHOW_ALL")) return SHOW_ALL;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("SHOW_ALL"),
	HX_CSTRING("NO_SCALE"),
	HX_CSTRING("NO_BORDER"),
	HX_CSTRING("EXACT_FIT"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StageScaleMode_obj::EXACT_FIT,"EXACT_FIT");
	HX_MARK_MEMBER_NAME(StageScaleMode_obj::NO_BORDER,"NO_BORDER");
	HX_MARK_MEMBER_NAME(StageScaleMode_obj::NO_SCALE,"NO_SCALE");
	HX_MARK_MEMBER_NAME(StageScaleMode_obj::SHOW_ALL,"SHOW_ALL");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StageScaleMode_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(StageScaleMode_obj::EXACT_FIT,"EXACT_FIT");
	HX_VISIT_MEMBER_NAME(StageScaleMode_obj::NO_BORDER,"NO_BORDER");
	HX_VISIT_MEMBER_NAME(StageScaleMode_obj::NO_SCALE,"NO_SCALE");
	HX_VISIT_MEMBER_NAME(StageScaleMode_obj::SHOW_ALL,"SHOW_ALL");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class StageScaleMode_obj::__mClass;

Dynamic __Create_StageScaleMode_obj() { return new StageScaleMode_obj; }

void StageScaleMode_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.StageScaleMode"), hx::TCanCast< StageScaleMode_obj >,sStaticFields,sMemberFields,
	&__Create_StageScaleMode_obj, &__Create,
	&super::__SGetClass(), &CreateStageScaleMode_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void StageScaleMode_obj::__boot()
{
hx::Static(EXACT_FIT) = hx::CreateEnum< StageScaleMode_obj >(HX_CSTRING("EXACT_FIT"),3);
hx::Static(NO_BORDER) = hx::CreateEnum< StageScaleMode_obj >(HX_CSTRING("NO_BORDER"),2);
hx::Static(NO_SCALE) = hx::CreateEnum< StageScaleMode_obj >(HX_CSTRING("NO_SCALE"),1);
hx::Static(SHOW_ALL) = hx::CreateEnum< StageScaleMode_obj >(HX_CSTRING("SHOW_ALL"),0);
}


} // end namespace flash
} // end namespace display
