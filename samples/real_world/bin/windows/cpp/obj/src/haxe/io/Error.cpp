#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
namespace haxe{
namespace io{

::haxe::io::Error Error_obj::Blocked;

::haxe::io::Error  Error_obj::Custom(Dynamic e)
	{ return hx::CreateEnum< Error_obj >(HX_CSTRING("Custom"),3,hx::DynamicArray(0,1).Add(e)); }

::haxe::io::Error Error_obj::OutsideBounds;

::haxe::io::Error Error_obj::Overflow;

HX_DEFINE_CREATE_ENUM(Error_obj)

int Error_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Blocked")) return 0;
	if (inName==HX_CSTRING("Custom")) return 3;
	if (inName==HX_CSTRING("OutsideBounds")) return 2;
	if (inName==HX_CSTRING("Overflow")) return 1;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(Error_obj,Custom,return)

int Error_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Blocked")) return 0;
	if (inName==HX_CSTRING("Custom")) return 1;
	if (inName==HX_CSTRING("OutsideBounds")) return 0;
	if (inName==HX_CSTRING("Overflow")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Error_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Blocked")) return Blocked;
	if (inName==HX_CSTRING("Custom")) return Custom_dyn();
	if (inName==HX_CSTRING("OutsideBounds")) return OutsideBounds;
	if (inName==HX_CSTRING("Overflow")) return Overflow;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Blocked"),
	HX_CSTRING("Overflow"),
	HX_CSTRING("OutsideBounds"),
	HX_CSTRING("Custom"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Error_obj::Blocked,"Blocked");
	HX_MARK_MEMBER_NAME(Error_obj::OutsideBounds,"OutsideBounds");
	HX_MARK_MEMBER_NAME(Error_obj::Overflow,"Overflow");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Error_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Error_obj::Blocked,"Blocked");
	HX_VISIT_MEMBER_NAME(Error_obj::OutsideBounds,"OutsideBounds");
	HX_VISIT_MEMBER_NAME(Error_obj::Overflow,"Overflow");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Error_obj::__mClass;

Dynamic __Create_Error_obj() { return new Error_obj; }

void Error_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.Error"), hx::TCanCast< Error_obj >,sStaticFields,sMemberFields,
	&__Create_Error_obj, &__Create,
	&super::__SGetClass(), &CreateError_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Error_obj::__boot()
{
hx::Static(Blocked) = hx::CreateEnum< Error_obj >(HX_CSTRING("Blocked"),0);
hx::Static(OutsideBounds) = hx::CreateEnum< Error_obj >(HX_CSTRING("OutsideBounds"),2);
hx::Static(Overflow) = hx::CreateEnum< Error_obj >(HX_CSTRING("Overflow"),1);
}


} // end namespace haxe
} // end namespace io
