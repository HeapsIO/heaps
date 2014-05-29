#include <hxcpp.h>

#ifndef INCLUDED_h3d_mat_Filter
#include <h3d/mat/Filter.h>
#endif
namespace h3d{
namespace mat{

::h3d::mat::Filter Filter_obj::Linear;

::h3d::mat::Filter Filter_obj::Nearest;

HX_DEFINE_CREATE_ENUM(Filter_obj)

int Filter_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Linear")) return 1;
	if (inName==HX_CSTRING("Nearest")) return 0;
	return super::__FindIndex(inName);
}

int Filter_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Linear")) return 0;
	if (inName==HX_CSTRING("Nearest")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Filter_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Linear")) return Linear;
	if (inName==HX_CSTRING("Nearest")) return Nearest;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Nearest"),
	HX_CSTRING("Linear"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Filter_obj::Linear,"Linear");
	HX_MARK_MEMBER_NAME(Filter_obj::Nearest,"Nearest");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Filter_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Filter_obj::Linear,"Linear");
	HX_VISIT_MEMBER_NAME(Filter_obj::Nearest,"Nearest");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Filter_obj::__mClass;

Dynamic __Create_Filter_obj() { return new Filter_obj; }

void Filter_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.Filter"), hx::TCanCast< Filter_obj >,sStaticFields,sMemberFields,
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
hx::Static(Linear) = hx::CreateEnum< Filter_obj >(HX_CSTRING("Linear"),1);
hx::Static(Nearest) = hx::CreateEnum< Filter_obj >(HX_CSTRING("Nearest"),0);
}


} // end namespace h3d
} // end namespace mat
