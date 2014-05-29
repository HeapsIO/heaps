#include <hxcpp.h>

#ifndef INCLUDED_flash_net_URLLoaderDataFormat
#include <flash/net/URLLoaderDataFormat.h>
#endif
namespace flash{
namespace net{

::flash::net::URLLoaderDataFormat URLLoaderDataFormat_obj::BINARY;

::flash::net::URLLoaderDataFormat URLLoaderDataFormat_obj::TEXT;

::flash::net::URLLoaderDataFormat URLLoaderDataFormat_obj::VARIABLES;

HX_DEFINE_CREATE_ENUM(URLLoaderDataFormat_obj)

int URLLoaderDataFormat_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("BINARY")) return 0;
	if (inName==HX_CSTRING("TEXT")) return 1;
	if (inName==HX_CSTRING("VARIABLES")) return 2;
	return super::__FindIndex(inName);
}

int URLLoaderDataFormat_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("BINARY")) return 0;
	if (inName==HX_CSTRING("TEXT")) return 0;
	if (inName==HX_CSTRING("VARIABLES")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic URLLoaderDataFormat_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("BINARY")) return BINARY;
	if (inName==HX_CSTRING("TEXT")) return TEXT;
	if (inName==HX_CSTRING("VARIABLES")) return VARIABLES;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("BINARY"),
	HX_CSTRING("TEXT"),
	HX_CSTRING("VARIABLES"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(URLLoaderDataFormat_obj::BINARY,"BINARY");
	HX_MARK_MEMBER_NAME(URLLoaderDataFormat_obj::TEXT,"TEXT");
	HX_MARK_MEMBER_NAME(URLLoaderDataFormat_obj::VARIABLES,"VARIABLES");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(URLLoaderDataFormat_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(URLLoaderDataFormat_obj::BINARY,"BINARY");
	HX_VISIT_MEMBER_NAME(URLLoaderDataFormat_obj::TEXT,"TEXT");
	HX_VISIT_MEMBER_NAME(URLLoaderDataFormat_obj::VARIABLES,"VARIABLES");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class URLLoaderDataFormat_obj::__mClass;

Dynamic __Create_URLLoaderDataFormat_obj() { return new URLLoaderDataFormat_obj; }

void URLLoaderDataFormat_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.net.URLLoaderDataFormat"), hx::TCanCast< URLLoaderDataFormat_obj >,sStaticFields,sMemberFields,
	&__Create_URLLoaderDataFormat_obj, &__Create,
	&super::__SGetClass(), &CreateURLLoaderDataFormat_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void URLLoaderDataFormat_obj::__boot()
{
hx::Static(BINARY) = hx::CreateEnum< URLLoaderDataFormat_obj >(HX_CSTRING("BINARY"),0);
hx::Static(TEXT) = hx::CreateEnum< URLLoaderDataFormat_obj >(HX_CSTRING("TEXT"),1);
hx::Static(VARIABLES) = hx::CreateEnum< URLLoaderDataFormat_obj >(HX_CSTRING("VARIABLES"),2);
}


} // end namespace flash
} // end namespace net
