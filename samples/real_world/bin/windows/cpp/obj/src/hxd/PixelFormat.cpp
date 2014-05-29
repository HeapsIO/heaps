#include <hxcpp.h>

#ifndef INCLUDED_hxd_PixelFormat
#include <hxd/PixelFormat.h>
#endif
namespace hxd{

::hxd::PixelFormat PixelFormat_obj::ARGB;

::hxd::PixelFormat PixelFormat_obj::BGRA;

::hxd::PixelFormat PixelFormat_obj::RGBA;

HX_DEFINE_CREATE_ENUM(PixelFormat_obj)

int PixelFormat_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("ARGB")) return 0;
	if (inName==HX_CSTRING("BGRA")) return 1;
	if (inName==HX_CSTRING("RGBA")) return 2;
	return super::__FindIndex(inName);
}

int PixelFormat_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("ARGB")) return 0;
	if (inName==HX_CSTRING("BGRA")) return 0;
	if (inName==HX_CSTRING("RGBA")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic PixelFormat_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("ARGB")) return ARGB;
	if (inName==HX_CSTRING("BGRA")) return BGRA;
	if (inName==HX_CSTRING("RGBA")) return RGBA;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("ARGB"),
	HX_CSTRING("BGRA"),
	HX_CSTRING("RGBA"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(PixelFormat_obj::ARGB,"ARGB");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::BGRA,"BGRA");
	HX_MARK_MEMBER_NAME(PixelFormat_obj::RGBA,"RGBA");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::ARGB,"ARGB");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::BGRA,"BGRA");
	HX_VISIT_MEMBER_NAME(PixelFormat_obj::RGBA,"RGBA");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class PixelFormat_obj::__mClass;

Dynamic __Create_PixelFormat_obj() { return new PixelFormat_obj; }

void PixelFormat_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.PixelFormat"), hx::TCanCast< PixelFormat_obj >,sStaticFields,sMemberFields,
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
hx::Static(ARGB) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("ARGB"),0);
hx::Static(BGRA) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("BGRA"),1);
hx::Static(RGBA) = hx::CreateEnum< PixelFormat_obj >(HX_CSTRING("RGBA"),2);
}


} // end namespace hxd
