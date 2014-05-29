#include <hxcpp.h>

#ifndef INCLUDED_flash_text_GridFitType
#include <flash/text/GridFitType.h>
#endif
namespace flash{
namespace text{

::flash::text::GridFitType GridFitType_obj::NONE;

::flash::text::GridFitType GridFitType_obj::PIXEL;

::flash::text::GridFitType GridFitType_obj::SUBPIXEL;

HX_DEFINE_CREATE_ENUM(GridFitType_obj)

int GridFitType_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("NONE")) return 0;
	if (inName==HX_CSTRING("PIXEL")) return 1;
	if (inName==HX_CSTRING("SUBPIXEL")) return 2;
	return super::__FindIndex(inName);
}

int GridFitType_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("NONE")) return 0;
	if (inName==HX_CSTRING("PIXEL")) return 0;
	if (inName==HX_CSTRING("SUBPIXEL")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic GridFitType_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("NONE")) return NONE;
	if (inName==HX_CSTRING("PIXEL")) return PIXEL;
	if (inName==HX_CSTRING("SUBPIXEL")) return SUBPIXEL;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("NONE"),
	HX_CSTRING("PIXEL"),
	HX_CSTRING("SUBPIXEL"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GridFitType_obj::NONE,"NONE");
	HX_MARK_MEMBER_NAME(GridFitType_obj::PIXEL,"PIXEL");
	HX_MARK_MEMBER_NAME(GridFitType_obj::SUBPIXEL,"SUBPIXEL");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GridFitType_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(GridFitType_obj::NONE,"NONE");
	HX_VISIT_MEMBER_NAME(GridFitType_obj::PIXEL,"PIXEL");
	HX_VISIT_MEMBER_NAME(GridFitType_obj::SUBPIXEL,"SUBPIXEL");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class GridFitType_obj::__mClass;

Dynamic __Create_GridFitType_obj() { return new GridFitType_obj; }

void GridFitType_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.text.GridFitType"), hx::TCanCast< GridFitType_obj >,sStaticFields,sMemberFields,
	&__Create_GridFitType_obj, &__Create,
	&super::__SGetClass(), &CreateGridFitType_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void GridFitType_obj::__boot()
{
hx::Static(NONE) = hx::CreateEnum< GridFitType_obj >(HX_CSTRING("NONE"),0);
hx::Static(PIXEL) = hx::CreateEnum< GridFitType_obj >(HX_CSTRING("PIXEL"),1);
hx::Static(SUBPIXEL) = hx::CreateEnum< GridFitType_obj >(HX_CSTRING("SUBPIXEL"),2);
}


} // end namespace flash
} // end namespace text
