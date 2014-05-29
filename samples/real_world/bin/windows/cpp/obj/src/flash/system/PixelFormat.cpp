#include <hxcpp.h>

#ifndef INCLUDED_flash_system_PixelFormat
#include <flash/system/PixelFormat.h>
#endif
namespace flash{
namespace system{

::flash::system::PixelFormat PixelFormat_obj::ABGR1555;

::flash::system::PixelFormat PixelFormat_obj::ABGR4444;

::flash::system::PixelFormat PixelFormat_obj::ABGR8888;

::flash::system::PixelFormat PixelFormat_obj::ARGB1555;

::flash::system::PixelFormat PixelFormat_obj::ARGB2101010;

::flash::system::PixelFormat PixelFormat_obj::ARGB4444;

::flash::system::PixelFormat PixelFormat_obj::ARGB8888;

::flash::system::PixelFormat PixelFormat_obj::BGR24;

::flash::system::PixelFormat PixelFormat_obj::BGR555;

::flash::system::PixelFormat PixelFormat_obj::BGR565;

::flash::system::PixelFormat PixelFormat_obj::BGR888;

::flash::system::PixelFormat PixelFormat_obj::BGRA4444;

::flash::system::PixelFormat PixelFormat_obj::BGRA5551;

::flash::system::PixelFormat PixelFormat_obj::BGRA8888;

::flash::system::PixelFormat PixelFormat_obj::BGRX8888;

::flash::system::PixelFormat PixelFormat_obj::INDEX1LSB;

::flash::system::PixelFormat PixelFormat_obj::INDEX1MSB;

::flash::system::PixelFormat PixelFormat_obj::INDEX4LSB;

::flash::system::PixelFormat PixelFormat_obj::INDEX4MSB;

::flash::system::PixelFormat PixelFormat_obj::INDEX8;

::flash::system::PixelFormat PixelFormat_obj::IYUV;

::flash::system::PixelFormat PixelFormat_obj::RGB24;

::flash::system::PixelFormat PixelFormat_obj::RGB332;

::flash::system::PixelFormat PixelFormat_obj::RGB444;

::flash::system::PixelFormat PixelFormat_obj::RGB555;

::flash::system::PixelFormat PixelFormat_obj::RGB565;

::flash::system::PixelFormat PixelFormat_obj::RGB888;

::flash::system::PixelFormat PixelFormat_obj::RGBA4444;

::flash::system::PixelFormat PixelFormat_obj::RGBA5551;

::flash::system::PixelFormat PixelFormat_obj::RGBA8888;

::flash::system::PixelFormat PixelFormat_obj::RGBX8888;

::flash::system::PixelFormat PixelFormat_obj::UNKNOWN;

::flash::system::PixelFormat PixelFormat_obj::UYVY;

::flash::system::PixelFormat PixelFormat_obj::YUY2;

::flash::system::PixelFormat PixelFormat_obj::YV12;

::flash::system::PixelFormat PixelFormat_obj::YVYU;

HX_DEFINE_CREATE_ENUM(PixelFormat_obj)

int PixelFormat_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("ABGR1555")) return 16;
	if (inName==HX_CSTRING("ABGR4444")) return 12;
	if (inName==HX_CSTRING("ABGR8888")) return 28;
	if (inName==HX_CSTRING("ARGB1555")) return 14;
	if (inName==HX_CSTRING("ARGB2101010")) return 30;
	if (inName==HX_CSTRING("ARGB4444")) return 10;
	if (inName==HX_CSTRING("ARGB8888")) return 26;
	if (inName==HX_CSTRING("BGR24")) return 21;
	if (inName==HX_CSTRING("BGR555")) return 9;
	if (inName==HX_CSTRING("BGR565")) return 19;
	if (inName==HX_CSTRING("BGR888")) return 24;
	if (inName==HX_CSTRING("BGRA4444")) return 13;
	if (inName==HX_CSTRING("BGRA5551")) return 17;
	if (inName==HX_CSTRING("BGRA8888")) return 29;
	if (inName==HX_CSTRING("BGRX8888")) return 25;
	if (inName==HX_CSTRING("INDEX1LSB")) return 1;
	if (inName==HX_CSTRING("INDEX1MSB")) return 2;
	if (inName==HX_CSTRING("INDEX4LSB")) return 3;
	if (inName==HX_CSTRING("INDEX4MSB")) return 4;
	if (inName==HX_CSTRING("INDEX8")) return 5;
	if (inName==HX_CSTRING("IYUV")) return 32;
	if (inName==HX_CSTRING("RGB24")) return 20;
	if (inName==HX_CSTRING("RGB332")) return 6;
	if (inName==HX_CSTRING("RGB444")) return 7;
	if (inName==HX_CSTRING("RGB555")) return 8;
	if (inName==HX_CSTRING("RGB565")) return 18;
	if (inName==HX_CSTRING("RGB888")) return 22;
	if (inName==HX_CSTRING("RGBA4444")) return 11;
	if (inName==HX_CSTRING("RGBA5551")) return 15;
	if (inName==HX_CSTRING("RGBA8888")) return 27;
	if (inName==HX_CSTRING("RGBX8888")) return 23;
	if (inName==HX_CSTRING("UNKNOWN")) return 0;
	if (inName==HX_CSTRING("UYVY")) return 34;
	if (inName==HX_CSTRING("YUY2")) return 33;
	if (inName==HX_CSTRING("YV12")) return 31;
	if (inName==HX_CSTRING("YVYU")) return 35;
	return super::__FindIndex(inName);
}

int PixelFormat_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("ABGR1555")) return 0;
	if (inName==HX_CSTRING("ABGR4444")) return 0;
	if (inName==HX_CSTRING("ABGR8888")) return 0;
	if (inName==HX_CSTRING("ARGB1555")) return 0;
	if (inName==HX_CSTRING("ARGB2101010")) return 0;
	if (inName==HX_CSTRING("ARGB4444")) return 0;
	if (inName==HX_CSTRING("ARGB8888")) return 0;
	if (inName==HX_CSTRING("BGR24")) return 0;
	if (inName==HX_CSTRING("BGR555")) return 0;
	if (inName==HX_CSTRING("BGR565")) return 0;
	if (inName==HX_CSTRING("BGR888")) return 0;
	if (inName==HX_CSTRING("BGRA4444")) return 0;
	if (inName==HX_CSTRING("BGRA5551")) return 0;
	if (inName==HX_CSTRING("BGRA8888")) return 0;
	if (inName==HX_CSTRING("BGRX8888")) return 0;
	if (inName==HX_CSTRING("INDEX1LSB")) return 0;
	if (inName==HX_CSTRING("INDEX1MSB")) return 0;
	if (inName==HX_CSTRING("INDEX4LSB")) return 0;
	if (inName==HX_CSTRING("INDEX4MSB")) return 0;
	if (inName==HX_CSTRING("INDEX8")) return 0;
	if (inName==HX_CSTRING("IYUV")) return 0;
	if (inName==HX_CSTRING("RGB24")) return 0;
	if (inName==HX_CSTRING("RGB332")) return 0;
	if (inName==HX_CSTRING("RGB444")) return 0;
	if (inName==HX_CSTRING("RGB555")) return 0;
	if (inName==HX_CSTRING("RGB565")) return 0;
	if (inName==HX_CSTRING("RGB888")) return 0;
	if (inName==HX_CSTRING("RGBA4444")) return 0;
	if (inName==HX_CSTRING("RGBA5551")) return 0;
	if (inName==HX_CSTRING("RGBA8888")) return 0;
	if (inName==HX_CSTRING("RGBX8888")) return 0;
	if (inName==HX_CSTRING("UNKNOWN")) return 0;
	if (inName==HX_CSTRING("UYVY")) return 0;
	if (inName==HX_CSTRING("YUY2")) return 0;
	if (inName==HX_CSTRING("YV12")) return 0;
	if (inName==HX_CSTRING("YVYU")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic PixelFormat_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("ABGR1555")) return ABGR1555;
	if (inName==HX_CSTRING("ABGR4444")) return ABGR4444;
	if (inName==HX_CSTRING("ABGR8888")) return ABGR8888;
	if (inName==HX_CSTRING("ARGB1555")) return ARGB1555;
	if (inName==HX_CSTRING("ARGB2101010")) return ARGB2101010;
	if (inName==HX_CSTRING("ARGB4444")) return ARGB4444;
	if (inName==HX_CSTRING("ARGB8888")) return ARGB8888;
	if (inName==HX_CSTRING("BGR24")) return BGR24;
	if (inName==HX_CSTRING("BGR555")) return BGR555;
	if (inName==HX_CSTRING("BGR565")) return BGR565;
	if (inName==HX_CSTRING("BGR888")) return BGR888;
	if (inName==HX_CSTRING("BGRA4444")) return BGRA4444;
	if (inName==HX_CSTRING("BGRA5551")) return BGRA5551;
	if (inName==HX_CSTRING("BGRA8888")) return BGRA8888;
	if (inName==HX_CSTRING("BGRX8888")) return BGRX8888;
	if (inName==HX_CSTRING("INDEX1LSB")) return INDEX1LSB;
	if (inName==HX_CSTRING("INDEX1MSB")) return INDEX1MSB;
	if (inName==HX_CSTRING("INDEX4LSB")) return INDEX4LSB;
	if (inName==HX_CSTRING("INDEX4MSB")) return INDEX4MSB;
	if (inName==HX_CSTRING("INDEX8")) return INDEX8;
	if (inName==HX_CSTRING("IYUV")) return IYUV;
	if (inName==HX_CSTRING("RGB24")) return RGB24;
	if (inName==HX_CSTRING("RGB332")) return RGB332;
	if (inName==HX_CSTRING("RGB444")) return RGB444;
	if (inName==HX_CSTRING("RGB555")) return RGB555;
	if (inName==HX_CSTRING("RGB565")) return RGB565;
	if (inName==HX_CSTRING("RGB888")) return RGB888;
	if (inName==HX_CSTRING("RGBA4444")) return RGBA4444;
	if (inName==HX_CSTRING("RGBA5551")) return RGBA5551;
	if (inName==HX_CSTRING("RGBA8888")) return RGBA8888;
	if (inName==HX_CSTRING("RGBX8888")) return RGBX8888;
	if (inName==HX_CSTRING("UNKNOWN")) return UNKNOWN;
	if (inName==HX_CSTRING("UYVY")) return UYVY;
	if (inName==HX_CSTRING("YUY2")) return YUY2;
	if (inName==HX_CSTRING("YV12")) return YV12;
	if (inName==HX_CSTRING("YVYU")) return YVYU;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("UNKNOWN"),
	HX_CSTRING("INDEX1LSB"),
	HX_CSTRING("INDEX1MSB"),
	HX_CSTRING("INDEX4LSB"),
	HX_CSTRING("INDEX4MSB"),
	HX_CSTRING("INDEX8"),
	HX_CSTRING("RGB332"),
	HX_CSTRING("RGB444"),
	HX_CSTRING("RGB555"),
	HX_CSTRING("BGR555"),
	HX_CSTRING("ARGB4444"),
	HX_CSTRING("RGBA4444"),
	HX_CSTRING("ABGR4444"),
	HX_CSTRING("BGRA4444"),
	HX_CSTRING("ARGB1555"),
	HX_CSTRING("RGBA5551"),
	HX_CSTRING("ABGR1555"),
	HX_CSTRING("BGRA5551"),
	HX_CSTRING("RGB565"),
	HX_CSTRING("BGR565"),
	HX_CSTRING("RGB24"),
	HX_CSTRING("BGR24"),
	HX_CSTRING("RGB888"),
	HX_CSTRING("RGBX8888"),
	HX_CSTRING("BGR888"),
	HX_CSTRING("BGRX8888"),
	HX_CSTRING("ARGB8888"),
	HX_CSTRING("RGBA8888"),
	HX_CSTRING("ABGR8888"),
	HX_CSTRING("BGRA8888"),
	HX_CSTRING("ARGB2101010"),
	HX_CSTRING("YV12"),
	HX_CSTRING("IYUV"),
	HX_CSTRING("YUY2"),
	HX_CSTRING("UYVY"),
	HX_CSTRING("YVYU"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ABGR1555,"ABGR1555");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ABGR4444,"ABGR4444");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ABGR8888,"ABGR8888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ARGB1555,"ARGB1555");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ARGB2101010,"ARGB2101010");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ARGB4444,"ARGB4444");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ARGB8888,"ARGB8888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGR24,"BGR24");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGR555,"BGR555");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGR565,"BGR565");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGR888,"BGR888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGRA4444,"BGRA4444");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGRA5551,"BGRA5551");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGRA8888,"BGRA8888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGRX8888,"BGRX8888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::INDEX1LSB,"INDEX1LSB");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::INDEX1MSB,"INDEX1MSB");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::INDEX4LSB,"INDEX4LSB");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::INDEX4MSB,"INDEX4MSB");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::INDEX8,"INDEX8");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::IYUV,"IYUV");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGB24,"RGB24");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGB332,"RGB332");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGB444,"RGB444");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGB555,"RGB555");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGB565,"RGB565");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGB888,"RGB888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGBA4444,"RGBA4444");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGBA5551,"RGBA5551");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGBA8888,"RGBA8888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGBX8888,"RGBX8888");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::UNKNOWN,"UNKNOWN");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::UYVY,"UYVY");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::YUY2,"YUY2");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::YV12,"YV12");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::YVYU,"YVYU");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ABGR1555,"ABGR1555");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ABGR4444,"ABGR4444");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ABGR8888,"ABGR8888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ARGB1555,"ARGB1555");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ARGB2101010,"ARGB2101010");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ARGB4444,"ARGB4444");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ARGB8888,"ARGB8888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGR24,"BGR24");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGR555,"BGR555");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGR565,"BGR565");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGR888,"BGR888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGRA4444,"BGRA4444");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGRA5551,"BGRA5551");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGRA8888,"BGRA8888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGRX8888,"BGRX8888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::INDEX1LSB,"INDEX1LSB");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::INDEX1MSB,"INDEX1MSB");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::INDEX4LSB,"INDEX4LSB");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::INDEX4MSB,"INDEX4MSB");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::INDEX8,"INDEX8");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::IYUV,"IYUV");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGB24,"RGB24");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGB332,"RGB332");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGB444,"RGB444");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGB555,"RGB555");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGB565,"RGB565");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGB888,"RGB888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGBA4444,"RGBA4444");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGBA5551,"RGBA5551");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGBA8888,"RGBA8888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGBX8888,"RGBX8888");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::UNKNOWN,"UNKNOWN");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::UYVY,"UYVY");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::YUY2,"YUY2");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::YV12,"YV12");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::YVYU,"YVYU");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class PixelFormat_obj::__mClass;

Dynamic __Create_PixelFormat_obj() { return new PixelFormat_obj; }

void PixelFormat_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.system.PixelFormat"), hx::TCanCast< PixelFormat_obj >,sStaticFields,sMemberFields,
	&__Create_PixelFormat_obj, &__Create,
	&super::__SGetClass(), &CreatePixelFormat_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void PixelFormat_obj::__boot()
{
hx::Static(ABGR1555) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ABGR1555"),16);
hx::Static(ABGR4444) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ABGR4444"),12);
hx::Static(ABGR8888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ABGR8888"),28);
hx::Static(ARGB1555) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ARGB1555"),14);
hx::Static(ARGB2101010) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ARGB2101010"),30);
hx::Static(ARGB4444) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ARGB4444"),10);
hx::Static(ARGB8888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ARGB8888"),26);
hx::Static(BGR24) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGR24"),21);
hx::Static(BGR555) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGR555"),9);
hx::Static(BGR565) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGR565"),19);
hx::Static(BGR888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGR888"),24);
hx::Static(BGRA4444) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGRA4444"),13);
hx::Static(BGRA5551) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGRA5551"),17);
hx::Static(BGRA8888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGRA8888"),29);
hx::Static(BGRX8888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGRX8888"),25);
hx::Static(INDEX1LSB) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("INDEX1LSB"),1);
hx::Static(INDEX1MSB) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("INDEX1MSB"),2);
hx::Static(INDEX4LSB) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("INDEX4LSB"),3);
hx::Static(INDEX4MSB) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("INDEX4MSB"),4);
hx::Static(INDEX8) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("INDEX8"),5);
hx::Static(IYUV) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("IYUV"),32);
hx::Static(RGB24) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGB24"),20);
hx::Static(RGB332) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGB332"),6);
hx::Static(RGB444) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGB444"),7);
hx::Static(RGB555) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGB555"),8);
hx::Static(RGB565) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGB565"),18);
hx::Static(RGB888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGB888"),22);
hx::Static(RGBA4444) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGBA4444"),11);
hx::Static(RGBA5551) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGBA5551"),15);
hx::Static(RGBA8888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGBA8888"),27);
hx::Static(RGBX8888) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGBX8888"),23);
hx::Static(UNKNOWN) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("UNKNOWN"),0);
hx::Static(UYVY) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("UYVY"),34);
hx::Static(YUY2) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("YUY2"),33);
hx::Static(YV12) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("YV12"),31);
hx::Static(YVYU) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("YVYU"),35);
}


} // end namespace flash
} // end namespace system
