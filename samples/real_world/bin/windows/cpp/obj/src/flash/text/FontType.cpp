#include <hxcpp.h>

#ifndef INCLUDED_flash_text_FontType
#include <flash/text/FontType.h>
#endif
namespace flash{
namespace text{

::flash::text::FontType FontType_obj::DEVICE;

::flash::text::FontType FontType_obj::EMBEDDED;

::flash::text::FontType FontType_obj::EMBEDDED_CFF;

HX_DEFINE_CREATE_ENUM(FontType_obj)

int FontType_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("DEVICE")) return 0;
	if (inName==HX_CSTRING("EMBEDDED")) return 1;
	if (inName==HX_CSTRING("EMBEDDED_CFF")) return 2;
	return super::__FindIndex(inName);
}

int FontType_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("DEVICE")) return 0;
	if (inName==HX_CSTRING("EMBEDDED")) return 0;
	if (inName==HX_CSTRING("EMBEDDED_CFF")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic FontType_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("DEVICE")) return DEVICE;
	if (inName==HX_CSTRING("EMBEDDED")) return EMBEDDED;
	if (inName==HX_CSTRING("EMBEDDED_CFF")) return EMBEDDED_CFF;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("DEVICE"),
	HX_CSTRING("EMBEDDED"),
	HX_CSTRING("EMBEDDED_CFF"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FontType_obj::DEVICE,"DEVICE");
	HX_MARK_MEMBER_NAME(FontType_obj::EMBEDDED,"EMBEDDED");
	HX_MARK_MEMBER_NAME(FontType_obj::EMBEDDED_CFF,"EMBEDDED_CFF");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FontType_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FontType_obj::DEVICE,"DEVICE");
	HX_VISIT_MEMBER_NAME(FontType_obj::EMBEDDED,"EMBEDDED");
	HX_VISIT_MEMBER_NAME(FontType_obj::EMBEDDED_CFF,"EMBEDDED_CFF");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class FontType_obj::__mClass;

Dynamic __Create_FontType_obj() { return new FontType_obj; }

void FontType_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.text.FontType"), hx::TCanCast< FontType_obj >,sStaticFields,sMemberFields,
	&__Create_FontType_obj, &__Create,
	&super::__SGetClass(), &CreateFontType_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void FontType_obj::__boot()
{
hx::Static(DEVICE) = hx::CreateEnum< FontType_obj >(HX_CSTRING("DEVICE"),0);
hx::Static(EMBEDDED) = hx::CreateEnum< FontType_obj >(HX_CSTRING("EMBEDDED"),1);
hx::Static(EMBEDDED_CFF) = hx::CreateEnum< FontType_obj >(HX_CSTRING("EMBEDDED_CFF"),2);
}


} // end namespace flash
} // end namespace text
