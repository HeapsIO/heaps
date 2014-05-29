#include <hxcpp.h>

#ifndef INCLUDED_flash_display_StageAlign
#include <flash/display/StageAlign.h>
#endif
namespace flash{
namespace display{

::flash::display::StageAlign StageAlign_obj::BOTTOM;

::flash::display::StageAlign StageAlign_obj::BOTTOM_LEFT;

::flash::display::StageAlign StageAlign_obj::BOTTOM_RIGHT;

::flash::display::StageAlign StageAlign_obj::LEFT;

::flash::display::StageAlign StageAlign_obj::RIGHT;

::flash::display::StageAlign StageAlign_obj::TOP;

::flash::display::StageAlign StageAlign_obj::TOP_LEFT;

::flash::display::StageAlign StageAlign_obj::TOP_RIGHT;

HX_DEFINE_CREATE_ENUM(StageAlign_obj)

int StageAlign_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("BOTTOM")) return 7;
	if (inName==HX_CSTRING("BOTTOM_LEFT")) return 6;
	if (inName==HX_CSTRING("BOTTOM_RIGHT")) return 5;
	if (inName==HX_CSTRING("LEFT")) return 4;
	if (inName==HX_CSTRING("RIGHT")) return 3;
	if (inName==HX_CSTRING("TOP")) return 2;
	if (inName==HX_CSTRING("TOP_LEFT")) return 1;
	if (inName==HX_CSTRING("TOP_RIGHT")) return 0;
	return super::__FindIndex(inName);
}

int StageAlign_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("BOTTOM")) return 0;
	if (inName==HX_CSTRING("BOTTOM_LEFT")) return 0;
	if (inName==HX_CSTRING("BOTTOM_RIGHT")) return 0;
	if (inName==HX_CSTRING("LEFT")) return 0;
	if (inName==HX_CSTRING("RIGHT")) return 0;
	if (inName==HX_CSTRING("TOP")) return 0;
	if (inName==HX_CSTRING("TOP_LEFT")) return 0;
	if (inName==HX_CSTRING("TOP_RIGHT")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic StageAlign_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("BOTTOM")) return BOTTOM;
	if (inName==HX_CSTRING("BOTTOM_LEFT")) return BOTTOM_LEFT;
	if (inName==HX_CSTRING("BOTTOM_RIGHT")) return BOTTOM_RIGHT;
	if (inName==HX_CSTRING("LEFT")) return LEFT;
	if (inName==HX_CSTRING("RIGHT")) return RIGHT;
	if (inName==HX_CSTRING("TOP")) return TOP;
	if (inName==HX_CSTRING("TOP_LEFT")) return TOP_LEFT;
	if (inName==HX_CSTRING("TOP_RIGHT")) return TOP_RIGHT;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("TOP_RIGHT"),
	HX_CSTRING("TOP_LEFT"),
	HX_CSTRING("TOP"),
	HX_CSTRING("RIGHT"),
	HX_CSTRING("LEFT"),
	HX_CSTRING("BOTTOM_RIGHT"),
	HX_CSTRING("BOTTOM_LEFT"),
	HX_CSTRING("BOTTOM"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StageAlign_obj::BOTTOM,"BOTTOM");
	HX_MARK_MEMBER_NAME(StageAlign_obj::BOTTOM_LEFT,"BOTTOM_LEFT");
	HX_MARK_MEMBER_NAME(StageAlign_obj::BOTTOM_RIGHT,"BOTTOM_RIGHT");
	HX_MARK_MEMBER_NAME(StageAlign_obj::LEFT,"LEFT");
	HX_MARK_MEMBER_NAME(StageAlign_obj::RIGHT,"RIGHT");
	HX_MARK_MEMBER_NAME(StageAlign_obj::TOP,"TOP");
	HX_MARK_MEMBER_NAME(StageAlign_obj::TOP_LEFT,"TOP_LEFT");
	HX_MARK_MEMBER_NAME(StageAlign_obj::TOP_RIGHT,"TOP_RIGHT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StageAlign_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::BOTTOM,"BOTTOM");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::BOTTOM_LEFT,"BOTTOM_LEFT");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::BOTTOM_RIGHT,"BOTTOM_RIGHT");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::LEFT,"LEFT");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::RIGHT,"RIGHT");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::TOP,"TOP");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::TOP_LEFT,"TOP_LEFT");
	HX_VISIT_MEMBER_NAME(StageAlign_obj::TOP_RIGHT,"TOP_RIGHT");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class StageAlign_obj::__mClass;

Dynamic __Create_StageAlign_obj() { return new StageAlign_obj; }

void StageAlign_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.StageAlign"), hx::TCanCast< StageAlign_obj >,sStaticFields,sMemberFields,
	&__Create_StageAlign_obj, &__Create,
	&super::__SGetClass(), &CreateStageAlign_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void StageAlign_obj::__boot()
{
hx::Static(BOTTOM) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("BOTTOM"),7);
hx::Static(BOTTOM_LEFT) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("BOTTOM_LEFT"),6);
hx::Static(BOTTOM_RIGHT) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("BOTTOM_RIGHT"),5);
hx::Static(LEFT) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("LEFT"),4);
hx::Static(RIGHT) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("RIGHT"),3);
hx::Static(TOP) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("TOP"),2);
hx::Static(TOP_LEFT) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("TOP_LEFT"),1);
hx::Static(TOP_RIGHT) = hx::CreateEnum< StageAlign_obj >(HX_CSTRING("TOP_RIGHT"),0);
}


} // end namespace flash
} // end namespace display
