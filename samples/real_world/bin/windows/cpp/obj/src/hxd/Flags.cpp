#include <hxcpp.h>

#ifndef INCLUDED_hxd_Flags
#include <hxd/Flags.h>
#endif
namespace hxd{

::hxd::Flags Flags_obj::ALPHA_PREMULTIPLIED;

::hxd::Flags Flags_obj::NO_CONVERSION;

::hxd::Flags Flags_obj::NO_REUSE;

HX_DEFINE_CREATE_ENUM(Flags_obj)

int Flags_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("ALPHA_PREMULTIPLIED")) return 2;
	if (inName==HX_CSTRING("NO_CONVERSION")) return 0;
	if (inName==HX_CSTRING("NO_REUSE")) return 1;
	return super::__FindIndex(inName);
}

int Flags_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("ALPHA_PREMULTIPLIED")) return 0;
	if (inName==HX_CSTRING("NO_CONVERSION")) return 0;
	if (inName==HX_CSTRING("NO_REUSE")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Flags_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("ALPHA_PREMULTIPLIED")) return ALPHA_PREMULTIPLIED;
	if (inName==HX_CSTRING("NO_CONVERSION")) return NO_CONVERSION;
	if (inName==HX_CSTRING("NO_REUSE")) return NO_REUSE;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("NO_CONVERSION"),
	HX_CSTRING("NO_REUSE"),
	HX_CSTRING("ALPHA_PREMULTIPLIED"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Flags_obj::ALPHA_PREMULTIPLIED,"ALPHA_PREMULTIPLIED");
	HX_MARK_MEMBER_NAME(Flags_obj::NO_CONVERSION,"NO_CONVERSION");
	HX_MARK_MEMBER_NAME(Flags_obj::NO_REUSE,"NO_REUSE");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Flags_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Flags_obj::ALPHA_PREMULTIPLIED,"ALPHA_PREMULTIPLIED");
	HX_VISIT_MEMBER_NAME(Flags_obj::NO_CONVERSION,"NO_CONVERSION");
	HX_VISIT_MEMBER_NAME(Flags_obj::NO_REUSE,"NO_REUSE");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Flags_obj::__mClass;

Dynamic __Create_Flags_obj() { return new Flags_obj; }

void Flags_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Flags"), hx::TCanCast< Flags_obj >,sStaticFields,sMemberFields,
	&__Create_Flags_obj, &__Create,
	&super::__SGetClass(), &CreateFlags_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Flags_obj::__boot()
{
hx::Static(ALPHA_PREMULTIPLIED) = hx::CreateEnum< Flags_obj >(HX_CSTRING("ALPHA_PREMULTIPLIED"),2);
hx::Static(NO_CONVERSION) = hx::CreateEnum< Flags_obj >(HX_CSTRING("NO_CONVERSION"),0);
hx::Static(NO_REUSE) = hx::CreateEnum< Flags_obj >(HX_CSTRING("NO_REUSE"),1);
}


} // end namespace hxd
