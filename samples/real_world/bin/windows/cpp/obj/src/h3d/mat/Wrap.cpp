#include <hxcpp.h>

#ifndef INCLUDED_h3d_mat_Wrap
#include <h3d/mat/Wrap.h>
#endif
namespace h3d{
namespace mat{

::h3d::mat::Wrap Wrap_obj::Clamp;

::h3d::mat::Wrap Wrap_obj::Repeat;

HX_DEFINE_CREATE_ENUM(Wrap_obj)

int Wrap_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Clamp")) return 0;
	if (inName==HX_CSTRING("Repeat")) return 1;
	return super::__FindIndex(inName);
}

int Wrap_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Clamp")) return 0;
	if (inName==HX_CSTRING("Repeat")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Wrap_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Clamp")) return Clamp;
	if (inName==HX_CSTRING("Repeat")) return Repeat;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Clamp"),
	HX_CSTRING("Repeat"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Wrap_obj::Clamp,"Clamp");
	HX_MARK_MEMBER_NAME(Wrap_obj::Repeat,"Repeat");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Wrap_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Wrap_obj::Clamp,"Clamp");
	HX_VISIT_MEMBER_NAME(Wrap_obj::Repeat,"Repeat");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Wrap_obj::__mClass;

Dynamic __Create_Wrap_obj() { return new Wrap_obj; }

void Wrap_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.Wrap"), hx::TCanCast< Wrap_obj >,sStaticFields,sMemberFields,
	&__Create_Wrap_obj, &__Create,
	&super::__SGetClass(), &CreateWrap_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Wrap_obj::__boot()
{
hx::Static(Clamp) = hx::CreateEnum< Wrap_obj >(HX_CSTRING("Clamp"),0);
hx::Static(Repeat) = hx::CreateEnum< Wrap_obj >(HX_CSTRING("Repeat"),1);
}


} // end namespace h3d
} // end namespace mat
