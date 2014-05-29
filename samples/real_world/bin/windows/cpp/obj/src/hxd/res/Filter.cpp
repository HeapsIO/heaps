#include <hxcpp.h>

#ifndef INCLUDED_hxd_res_Filter
#include <hxd/res/Filter.h>
#endif
namespace hxd{
namespace res{

::hxd::res::Filter Filter_obj::Chromatic;

::hxd::res::Filter Filter_obj::Fast;

HX_DEFINE_CREATE_ENUM(Filter_obj)

int Filter_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Chromatic")) return 1;
	if (inName==HX_CSTRING("Fast")) return 0;
	return super::__FindIndex(inName);
}

int Filter_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Chromatic")) return 0;
	if (inName==HX_CSTRING("Fast")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Filter_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Chromatic")) return Chromatic;
	if (inName==HX_CSTRING("Fast")) return Fast;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Fast"),
	HX_CSTRING("Chromatic"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Filter_obj::Chromatic,"Chromatic");
	HX_MARK_MEMBER_NAME(Filter_obj::Fast,"Fast");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Filter_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Filter_obj::Chromatic,"Chromatic");
	HX_VISIT_MEMBER_NAME(Filter_obj::Fast,"Fast");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Filter_obj::__mClass;

Dynamic __Create_Filter_obj() { return new Filter_obj; }

void Filter_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Filter"), hx::TCanCast< Filter_obj >,sStaticFields,sMemberFields,
	&__Create_Filter_obj, &__Create,
	&super::__SGetClass(), &CreateFilter_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Filter_obj::__boot()
{
hx::Static(Chromatic) = hx::CreateEnum< Filter_obj >(HX_CSTRING("Chromatic"),1);
hx::Static(Fast) = hx::CreateEnum< Filter_obj >(HX_CSTRING("Fast"),0);
}


} // end namespace hxd
} // end namespace res
