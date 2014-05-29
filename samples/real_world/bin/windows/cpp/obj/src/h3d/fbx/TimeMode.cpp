#include <hxcpp.h>

#ifndef INCLUDED_h3d_fbx_TimeMode
#include <h3d/fbx/TimeMode.h>
#endif
namespace h3d{
namespace fbx{

::h3d::fbx::TimeMode TimeMode_obj::TM_CINEMA;

::h3d::fbx::TimeMode TimeMode_obj::TM_CINEMA_ND;

::h3d::fbx::TimeMode TimeMode_obj::TM_CUSTOM;

::h3d::fbx::TimeMode TimeMode_obj::TM_DEFAULT_MODE;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES100;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES1000;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES120;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES30;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES30_DROP;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES48;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES50;

::h3d::fbx::TimeMode TimeMode_obj::TM_FRAMES60;

::h3d::fbx::TimeMode TimeMode_obj::TM_NTSC_DROP_FRAME;

::h3d::fbx::TimeMode TimeMode_obj::TM_NTSC_FULL_FRAME;

::h3d::fbx::TimeMode TimeMode_obj::TM_PAL;

HX_DEFINE_CREATE_ENUM(TimeMode_obj)

int TimeMode_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("TM_CINEMA")) return 11;
	if (inName==HX_CSTRING("TM_CINEMA_ND")) return 13;
	if (inName==HX_CSTRING("TM_CUSTOM")) return 14;
	if (inName==HX_CSTRING("TM_DEFAULT_MODE")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES100")) return 2;
	if (inName==HX_CSTRING("TM_FRAMES1000")) return 12;
	if (inName==HX_CSTRING("TM_FRAMES120")) return 1;
	if (inName==HX_CSTRING("TM_FRAMES30")) return 6;
	if (inName==HX_CSTRING("TM_FRAMES30_DROP")) return 7;
	if (inName==HX_CSTRING("TM_FRAMES48")) return 5;
	if (inName==HX_CSTRING("TM_FRAMES50")) return 4;
	if (inName==HX_CSTRING("TM_FRAMES60")) return 3;
	if (inName==HX_CSTRING("TM_NTSC_DROP_FRAME")) return 8;
	if (inName==HX_CSTRING("TM_NTSC_FULL_FRAME")) return 9;
	if (inName==HX_CSTRING("TM_PAL")) return 10;
	return super::__FindIndex(inName);
}

int TimeMode_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("TM_CINEMA")) return 0;
	if (inName==HX_CSTRING("TM_CINEMA_ND")) return 0;
	if (inName==HX_CSTRING("TM_CUSTOM")) return 0;
	if (inName==HX_CSTRING("TM_DEFAULT_MODE")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES100")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES1000")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES120")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES30")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES30_DROP")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES48")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES50")) return 0;
	if (inName==HX_CSTRING("TM_FRAMES60")) return 0;
	if (inName==HX_CSTRING("TM_NTSC_DROP_FRAME")) return 0;
	if (inName==HX_CSTRING("TM_NTSC_FULL_FRAME")) return 0;
	if (inName==HX_CSTRING("TM_PAL")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic TimeMode_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("TM_CINEMA")) return TM_CINEMA;
	if (inName==HX_CSTRING("TM_CINEMA_ND")) return TM_CINEMA_ND;
	if (inName==HX_CSTRING("TM_CUSTOM")) return TM_CUSTOM;
	if (inName==HX_CSTRING("TM_DEFAULT_MODE")) return TM_DEFAULT_MODE;
	if (inName==HX_CSTRING("TM_FRAMES100")) return TM_FRAMES100;
	if (inName==HX_CSTRING("TM_FRAMES1000")) return TM_FRAMES1000;
	if (inName==HX_CSTRING("TM_FRAMES120")) return TM_FRAMES120;
	if (inName==HX_CSTRING("TM_FRAMES30")) return TM_FRAMES30;
	if (inName==HX_CSTRING("TM_FRAMES30_DROP")) return TM_FRAMES30_DROP;
	if (inName==HX_CSTRING("TM_FRAMES48")) return TM_FRAMES48;
	if (inName==HX_CSTRING("TM_FRAMES50")) return TM_FRAMES50;
	if (inName==HX_CSTRING("TM_FRAMES60")) return TM_FRAMES60;
	if (inName==HX_CSTRING("TM_NTSC_DROP_FRAME")) return TM_NTSC_DROP_FRAME;
	if (inName==HX_CSTRING("TM_NTSC_FULL_FRAME")) return TM_NTSC_FULL_FRAME;
	if (inName==HX_CSTRING("TM_PAL")) return TM_PAL;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("TM_DEFAULT_MODE"),
	HX_CSTRING("TM_FRAMES120"),
	HX_CSTRING("TM_FRAMES100"),
	HX_CSTRING("TM_FRAMES60"),
	HX_CSTRING("TM_FRAMES50"),
	HX_CSTRING("TM_FRAMES48"),
	HX_CSTRING("TM_FRAMES30"),
	HX_CSTRING("TM_FRAMES30_DROP"),
	HX_CSTRING("TM_NTSC_DROP_FRAME"),
	HX_CSTRING("TM_NTSC_FULL_FRAME"),
	HX_CSTRING("TM_PAL"),
	HX_CSTRING("TM_CINEMA"),
	HX_CSTRING("TM_FRAMES1000"),
	HX_CSTRING("TM_CINEMA_ND"),
	HX_CSTRING("TM_CUSTOM"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_CINEMA,"TM_CINEMA");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_CINEMA_ND,"TM_CINEMA_ND");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_CUSTOM,"TM_CUSTOM");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_DEFAULT_MODE,"TM_DEFAULT_MODE");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES100,"TM_FRAMES100");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES1000,"TM_FRAMES1000");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES120,"TM_FRAMES120");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES30,"TM_FRAMES30");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES30_DROP,"TM_FRAMES30_DROP");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES48,"TM_FRAMES48");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES50,"TM_FRAMES50");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_FRAMES60,"TM_FRAMES60");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_NTSC_DROP_FRAME,"TM_NTSC_DROP_FRAME");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_NTSC_FULL_FRAME,"TM_NTSC_FULL_FRAME");
	HX_MARK_MEMBER_NAME(TimeMode_obj::TM_PAL,"TM_PAL");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TimeMode_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_CINEMA,"TM_CINEMA");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_CINEMA_ND,"TM_CINEMA_ND");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_CUSTOM,"TM_CUSTOM");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_DEFAULT_MODE,"TM_DEFAULT_MODE");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES100,"TM_FRAMES100");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES1000,"TM_FRAMES1000");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES120,"TM_FRAMES120");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES30,"TM_FRAMES30");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES30_DROP,"TM_FRAMES30_DROP");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES48,"TM_FRAMES48");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES50,"TM_FRAMES50");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_FRAMES60,"TM_FRAMES60");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_NTSC_DROP_FRAME,"TM_NTSC_DROP_FRAME");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_NTSC_FULL_FRAME,"TM_NTSC_FULL_FRAME");
	HX_VISIT_MEMBER_NAME(TimeMode_obj::TM_PAL,"TM_PAL");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class TimeMode_obj::__mClass;

Dynamic __Create_TimeMode_obj() { return new TimeMode_obj; }

void TimeMode_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.TimeMode"), hx::TCanCast< TimeMode_obj >,sStaticFields,sMemberFields,
	&__Create_TimeMode_obj, &__Create,
	&super::__SGetClass(), &CreateTimeMode_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void TimeMode_obj::__boot()
{
hx::Static(TM_CINEMA) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_CINEMA"),11);
hx::Static(TM_CINEMA_ND) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_CINEMA_ND"),13);
hx::Static(TM_CUSTOM) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_CUSTOM"),14);
hx::Static(TM_DEFAULT_MODE) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_DEFAULT_MODE"),0);
hx::Static(TM_FRAMES100) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES100"),2);
hx::Static(TM_FRAMES1000) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES1000"),12);
hx::Static(TM_FRAMES120) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES120"),1);
hx::Static(TM_FRAMES30) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES30"),6);
hx::Static(TM_FRAMES30_DROP) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES30_DROP"),7);
hx::Static(TM_FRAMES48) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES48"),5);
hx::Static(TM_FRAMES50) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES50"),4);
hx::Static(TM_FRAMES60) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_FRAMES60"),3);
hx::Static(TM_NTSC_DROP_FRAME) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_NTSC_DROP_FRAME"),8);
hx::Static(TM_NTSC_FULL_FRAME) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_NTSC_FULL_FRAME"),9);
hx::Static(TM_PAL) = hx::CreateEnum< TimeMode_obj >(HX_CSTRING("TM_PAL"),10);
}


} // end namespace h3d
} // end namespace fbx
