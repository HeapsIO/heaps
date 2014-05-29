#include <hxcpp.h>

#ifndef INCLUDED_h2d_Align
#include <h2d/Align.h>
#endif
namespace h2d{

::h2d::Align Align_obj::Center;

::h2d::Align Align_obj::Left;

::h2d::Align Align_obj::Right;

HX_DEFINE_CREATE_ENUM(Align_obj)

int Align_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Center")) return 2;
	if (inName==HX_CSTRING("Left")) return 0;
	if (inName==HX_CSTRING("Right")) return 1;
	return super::__FindIndex(inName);
}

int Align_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Center")) return 0;
	if (inName==HX_CSTRING("Left")) return 0;
	if (inName==HX_CSTRING("Right")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Align_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Center")) return Center;
	if (inName==HX_CSTRING("Left")) return Left;
	if (inName==HX_CSTRING("Right")) return Right;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Left"),
	HX_CSTRING("Right"),
	HX_CSTRING("Center"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Align_obj::Center,"Center");
	HX_MARK_MEMBER_NAME(Align_obj::Left,"Left");
	HX_MARK_MEMBER_NAME(Align_obj::Right,"Right");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Align_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Align_obj::Center,"Center");
	HX_VISIT_MEMBER_NAME(Align_obj::Left,"Left");
	HX_VISIT_MEMBER_NAME(Align_obj::Right,"Right");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Align_obj::__mClass;

Dynamic __Create_Align_obj() { return new Align_obj; }

void Align_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Align"), hx::TCanCast< Align_obj >,sStaticFields,sMemberFields,
	&__Create_Align_obj, &__Create,
	&super::__SGetClass(), &CreateAlign_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Align_obj::__boot()
{
hx::Static(Center) = hx::CreateEnum< Align_obj >(HX_CSTRING("Center"),2);
hx::Static(Left) = hx::CreateEnum< Align_obj >(HX_CSTRING("Left"),0);
hx::Static(Right) = hx::CreateEnum< Align_obj >(HX_CSTRING("Right"),1);
}


} // end namespace h2d
