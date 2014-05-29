#include <hxcpp.h>

#ifndef INCLUDED_h3d_mat_Face
#include <h3d/mat/Face.h>
#endif
namespace h3d{
namespace mat{

::h3d::mat::Face Face_obj::Back;

::h3d::mat::Face Face_obj::Both;

::h3d::mat::Face Face_obj::Front;

::h3d::mat::Face Face_obj::None;

HX_DEFINE_CREATE_ENUM(Face_obj)

int Face_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Back")) return 1;
	if (inName==HX_CSTRING("Both")) return 3;
	if (inName==HX_CSTRING("Front")) return 2;
	if (inName==HX_CSTRING("None")) return 0;
	return super::__FindIndex(inName);
}

int Face_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Back")) return 0;
	if (inName==HX_CSTRING("Both")) return 0;
	if (inName==HX_CSTRING("Front")) return 0;
	if (inName==HX_CSTRING("None")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Face_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Back")) return Back;
	if (inName==HX_CSTRING("Both")) return Both;
	if (inName==HX_CSTRING("Front")) return Front;
	if (inName==HX_CSTRING("None")) return None;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("None"),
	HX_CSTRING("Back"),
	HX_CSTRING("Front"),
	HX_CSTRING("Both"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Face_obj::Back,"Back");
	HX_MARK_MEMBER_NAME(Face_obj::Both,"Both");
	HX_MARK_MEMBER_NAME(Face_obj::Front,"Front");
	HX_MARK_MEMBER_NAME(Face_obj::None,"None");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Face_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Face_obj::Back,"Back");
	HX_VISIT_MEMBER_NAME(Face_obj::Both,"Both");
	HX_VISIT_MEMBER_NAME(Face_obj::Front,"Front");
	HX_VISIT_MEMBER_NAME(Face_obj::None,"None");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Face_obj::__mClass;

Dynamic __Create_Face_obj() { return new Face_obj; }

void Face_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.Face"), hx::TCanCast< Face_obj >,sStaticFields,sMemberFields,
	&__Create_Face_obj, &__Create,
	&super::__SGetClass(), &CreateFace_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Face_obj::__boot()
{
hx::Static(Back) = hx::CreateEnum< Face_obj >(HX_CSTRING("Back"),1);
hx::Static(Both) = hx::CreateEnum< Face_obj >(HX_CSTRING("Both"),3);
hx::Static(Front) = hx::CreateEnum< Face_obj >(HX_CSTRING("Front"),2);
hx::Static(None) = hx::CreateEnum< Face_obj >(HX_CSTRING("None"),0);
}


} // end namespace h3d
} // end namespace mat
