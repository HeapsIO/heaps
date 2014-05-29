#include <hxcpp.h>

#ifndef INCLUDED_h3d_mat_MipMap
#include <h3d/mat/MipMap.h>
#endif
namespace h3d{
namespace mat{

::h3d::mat::MipMap MipMap_obj::Linear;

::h3d::mat::MipMap MipMap_obj::Nearest;

::h3d::mat::MipMap MipMap_obj::None;

HX_DEFINE_CREATE_ENUM(MipMap_obj)

int MipMap_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Linear")) return 2;
	if (inName==HX_CSTRING("Nearest")) return 1;
	if (inName==HX_CSTRING("None")) return 0;
	return super::__FindIndex(inName);
}

int MipMap_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Linear")) return 0;
	if (inName==HX_CSTRING("Nearest")) return 0;
	if (inName==HX_CSTRING("None")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic MipMap_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Linear")) return Linear;
	if (inName==HX_CSTRING("Nearest")) return Nearest;
	if (inName==HX_CSTRING("None")) return None;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("None"),
	HX_CSTRING("Nearest"),
	HX_CSTRING("Linear"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MipMap_obj::Linear,"Linear");
	HX_MARK_MEMBER_NAME(MipMap_obj::Nearest,"Nearest");
	HX_MARK_MEMBER_NAME(MipMap_obj::None,"None");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MipMap_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(MipMap_obj::Linear,"Linear");
	HX_VISIT_MEMBER_NAME(MipMap_obj::Nearest,"Nearest");
	HX_VISIT_MEMBER_NAME(MipMap_obj::None,"None");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class MipMap_obj::__mClass;

Dynamic __Create_MipMap_obj() { return new MipMap_obj; }

void MipMap_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.MipMap"), hx::TCanCast< MipMap_obj >,sStaticFields,sMemberFields,
	&__Create_MipMap_obj, &__Create,
	&super::__SGetClass(), &CreateMipMap_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void MipMap_obj::__boot()
{
hx::Static(Linear) = hx::CreateEnum< MipMap_obj >(HX_CSTRING("Linear"),2);
hx::Static(Nearest) = hx::CreateEnum< MipMap_obj >(HX_CSTRING("Nearest"),1);
hx::Static(None) = hx::CreateEnum< MipMap_obj >(HX_CSTRING("None"),0);
}


} // end namespace h3d
} // end namespace mat
