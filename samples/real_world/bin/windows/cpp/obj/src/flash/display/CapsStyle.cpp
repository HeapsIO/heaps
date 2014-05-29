#include <hxcpp.h>

#ifndef INCLUDED_flash_display_CapsStyle
#include <flash/display/CapsStyle.h>
#endif
namespace flash{
namespace display{

::flash::display::CapsStyle CapsStyle_obj::NONE;

::flash::display::CapsStyle CapsStyle_obj::ROUND;

::flash::display::CapsStyle CapsStyle_obj::SQUARE;

HX_DEFINE_CREATE_ENUM(CapsStyle_obj)

int CapsStyle_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("NONE")) return 1;
	if (inName==HX_CSTRING("ROUND")) return 0;
	if (inName==HX_CSTRING("SQUARE")) return 2;
	return super::__FindIndex(inName);
}

int CapsStyle_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("NONE")) return 0;
	if (inName==HX_CSTRING("ROUND")) return 0;
	if (inName==HX_CSTRING("SQUARE")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic CapsStyle_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("NONE")) return NONE;
	if (inName==HX_CSTRING("ROUND")) return ROUND;
	if (inName==HX_CSTRING("SQUARE")) return SQUARE;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("ROUND"),
	HX_CSTRING("NONE"),
	HX_CSTRING("SQUARE"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(CapsStyle_obj::NONE,"NONE");
	HX_MARK_MEMBER_NAME(CapsStyle_obj::ROUND,"ROUND");
	HX_MARK_MEMBER_NAME(CapsStyle_obj::SQUARE,"SQUARE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(CapsStyle_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(CapsStyle_obj::NONE,"NONE");
	HX_VISIT_MEMBER_NAME(CapsStyle_obj::ROUND,"ROUND");
	HX_VISIT_MEMBER_NAME(CapsStyle_obj::SQUARE,"SQUARE");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class CapsStyle_obj::__mClass;

Dynamic __Create_CapsStyle_obj() { return new CapsStyle_obj; }

void CapsStyle_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.CapsStyle"), hx::TCanCast< CapsStyle_obj >,sStaticFields,sMemberFields,
	&__Create_CapsStyle_obj, &__Create,
	&super::__SGetClass(), &CreateCapsStyle_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void CapsStyle_obj::__boot()
{
hx::Static(NONE) = hx::CreateEnum< CapsStyle_obj >(HX_CSTRING("NONE"),1);
hx::Static(ROUND) = hx::CreateEnum< CapsStyle_obj >(HX_CSTRING("ROUND"),0);
hx::Static(SQUARE) = hx::CreateEnum< CapsStyle_obj >(HX_CSTRING("SQUARE"),2);
}


} // end namespace flash
} // end namespace display
