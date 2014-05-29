#include <hxcpp.h>

#ifndef INCLUDED_h3d_mat_Compare
#include <h3d/mat/Compare.h>
#endif
namespace h3d{
namespace mat{

::h3d::mat::Compare Compare_obj::Always;

::h3d::mat::Compare Compare_obj::Equal;

::h3d::mat::Compare Compare_obj::Greater;

::h3d::mat::Compare Compare_obj::GreaterEqual;

::h3d::mat::Compare Compare_obj::Less;

::h3d::mat::Compare Compare_obj::LessEqual;

::h3d::mat::Compare Compare_obj::Never;

::h3d::mat::Compare Compare_obj::NotEqual;

HX_DEFINE_CREATE_ENUM(Compare_obj)

int Compare_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Always")) return 0;
	if (inName==HX_CSTRING("Equal")) return 2;
	if (inName==HX_CSTRING("Greater")) return 4;
	if (inName==HX_CSTRING("GreaterEqual")) return 5;
	if (inName==HX_CSTRING("Less")) return 6;
	if (inName==HX_CSTRING("LessEqual")) return 7;
	if (inName==HX_CSTRING("Never")) return 1;
	if (inName==HX_CSTRING("NotEqual")) return 3;
	return super::__FindIndex(inName);
}

int Compare_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Always")) return 0;
	if (inName==HX_CSTRING("Equal")) return 0;
	if (inName==HX_CSTRING("Greater")) return 0;
	if (inName==HX_CSTRING("GreaterEqual")) return 0;
	if (inName==HX_CSTRING("Less")) return 0;
	if (inName==HX_CSTRING("LessEqual")) return 0;
	if (inName==HX_CSTRING("Never")) return 0;
	if (inName==HX_CSTRING("NotEqual")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Compare_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Always")) return Always;
	if (inName==HX_CSTRING("Equal")) return Equal;
	if (inName==HX_CSTRING("Greater")) return Greater;
	if (inName==HX_CSTRING("GreaterEqual")) return GreaterEqual;
	if (inName==HX_CSTRING("Less")) return Less;
	if (inName==HX_CSTRING("LessEqual")) return LessEqual;
	if (inName==HX_CSTRING("Never")) return Never;
	if (inName==HX_CSTRING("NotEqual")) return NotEqual;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Always"),
	HX_CSTRING("Never"),
	HX_CSTRING("Equal"),
	HX_CSTRING("NotEqual"),
	HX_CSTRING("Greater"),
	HX_CSTRING("GreaterEqual"),
	HX_CSTRING("Less"),
	HX_CSTRING("LessEqual"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Compare_obj::Always,"Always");
	HX_MARK_MEMBER_NAME(Compare_obj::Equal,"Equal");
	HX_MARK_MEMBER_NAME(Compare_obj::Greater,"Greater");
	HX_MARK_MEMBER_NAME(Compare_obj::GreaterEqual,"GreaterEqual");
	HX_MARK_MEMBER_NAME(Compare_obj::Less,"Less");
	HX_MARK_MEMBER_NAME(Compare_obj::LessEqual,"LessEqual");
	HX_MARK_MEMBER_NAME(Compare_obj::Never,"Never");
	HX_MARK_MEMBER_NAME(Compare_obj::NotEqual,"NotEqual");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Compare_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Compare_obj::Always,"Always");
	HX_VISIT_MEMBER_NAME(Compare_obj::Equal,"Equal");
	HX_VISIT_MEMBER_NAME(Compare_obj::Greater,"Greater");
	HX_VISIT_MEMBER_NAME(Compare_obj::GreaterEqual,"GreaterEqual");
	HX_VISIT_MEMBER_NAME(Compare_obj::Less,"Less");
	HX_VISIT_MEMBER_NAME(Compare_obj::LessEqual,"LessEqual");
	HX_VISIT_MEMBER_NAME(Compare_obj::Never,"Never");
	HX_VISIT_MEMBER_NAME(Compare_obj::NotEqual,"NotEqual");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Compare_obj::__mClass;

Dynamic __Create_Compare_obj() { return new Compare_obj; }

void Compare_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.Compare"), hx::TCanCast< Compare_obj >,sStaticFields,sMemberFields,
	&__Create_Compare_obj, &__Create,
	&super::__SGetClass(), &CreateCompare_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Compare_obj::__boot()
{
hx::Static(Always) = hx::CreateEnum< Compare_obj >(HX_CSTRING("Always"),0);
hx::Static(Equal) = hx::CreateEnum< Compare_obj >(HX_CSTRING("Equal"),2);
hx::Static(Greater) = hx::CreateEnum< Compare_obj >(HX_CSTRING("Greater"),4);
hx::Static(GreaterEqual) = hx::CreateEnum< Compare_obj >(HX_CSTRING("GreaterEqual"),5);
hx::Static(Less) = hx::CreateEnum< Compare_obj >(HX_CSTRING("Less"),6);
hx::Static(LessEqual) = hx::CreateEnum< Compare_obj >(HX_CSTRING("LessEqual"),7);
hx::Static(Never) = hx::CreateEnum< Compare_obj >(HX_CSTRING("Never"),1);
hx::Static(NotEqual) = hx::CreateEnum< Compare_obj >(HX_CSTRING("NotEqual"),3);
}


} // end namespace h3d
} // end namespace mat
