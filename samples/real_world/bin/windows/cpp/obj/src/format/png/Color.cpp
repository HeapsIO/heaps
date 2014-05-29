#include <hxcpp.h>

#ifndef INCLUDED_format_png_Color
#include <format/png/Color.h>
#endif
namespace format{
namespace png{

::format::png::Color  Color_obj::ColGrey(bool alpha)
	{ return hx::CreateEnum< Color_obj >(HX_CSTRING("ColGrey"),0,hx::DynamicArray(0,1).Add(alpha)); }

::format::png::Color Color_obj::ColIndexed;

::format::png::Color  Color_obj::ColTrue(bool alpha)
	{ return hx::CreateEnum< Color_obj >(HX_CSTRING("ColTrue"),1,hx::DynamicArray(0,1).Add(alpha)); }

HX_DEFINE_CREATE_ENUM(Color_obj)

int Color_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("ColGrey")) return 0;
	if (inName==HX_CSTRING("ColIndexed")) return 2;
	if (inName==HX_CSTRING("ColTrue")) return 1;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,ColGrey,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Color_obj,ColTrue,return)

int Color_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("ColGrey")) return 1;
	if (inName==HX_CSTRING("ColIndexed")) return 0;
	if (inName==HX_CSTRING("ColTrue")) return 1;
	return super::__FindArgCount(inName);
}

Dynamic Color_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("ColGrey")) return ColGrey_dyn();
	if (inName==HX_CSTRING("ColIndexed")) return ColIndexed;
	if (inName==HX_CSTRING("ColTrue")) return ColTrue_dyn();
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("ColGrey"),
	HX_CSTRING("ColTrue"),
	HX_CSTRING("ColIndexed"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Color_obj::ColIndexed,"ColIndexed");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Color_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Color_obj::ColIndexed,"ColIndexed");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Color_obj::__mClass;

Dynamic __Create_Color_obj() { return new Color_obj; }

void Color_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.png.Color"), hx::TCanCast< Color_obj >,sStaticFields,sMemberFields,
	&__Create_Color_obj, &__Create,
	&super::__SGetClass(), &CreateColor_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Color_obj::__boot()
{
hx::Static(ColIndexed) = hx::CreateEnum< Color_obj >(HX_CSTRING("ColIndexed"),2);
}


} // end namespace format
} // end namespace png
