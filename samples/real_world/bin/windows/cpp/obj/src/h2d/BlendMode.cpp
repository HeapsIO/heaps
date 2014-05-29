#include <hxcpp.h>

#ifndef INCLUDED_h2d_BlendMode
#include <h2d/BlendMode.h>
#endif
namespace h2d{

::h2d::BlendMode BlendMode_obj::Add;

::h2d::BlendMode BlendMode_obj::Erase;

::h2d::BlendMode BlendMode_obj::Hide;

::h2d::BlendMode BlendMode_obj::Multiply;

::h2d::BlendMode BlendMode_obj::None;

::h2d::BlendMode BlendMode_obj::Normal;

::h2d::BlendMode BlendMode_obj::Screen;

::h2d::BlendMode BlendMode_obj::SoftAdd;

HX_DEFINE_CREATE_ENUM(BlendMode_obj)

int BlendMode_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Add")) return 1;
	if (inName==HX_CSTRING("Erase")) return 5;
	if (inName==HX_CSTRING("Hide")) return 6;
	if (inName==HX_CSTRING("Multiply")) return 2;
	if (inName==HX_CSTRING("None")) return 3;
	if (inName==HX_CSTRING("Normal")) return 0;
	if (inName==HX_CSTRING("Screen")) return 7;
	if (inName==HX_CSTRING("SoftAdd")) return 4;
	return super::__FindIndex(inName);
}

int BlendMode_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Add")) return 0;
	if (inName==HX_CSTRING("Erase")) return 0;
	if (inName==HX_CSTRING("Hide")) return 0;
	if (inName==HX_CSTRING("Multiply")) return 0;
	if (inName==HX_CSTRING("None")) return 0;
	if (inName==HX_CSTRING("Normal")) return 0;
	if (inName==HX_CSTRING("Screen")) return 0;
	if (inName==HX_CSTRING("SoftAdd")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic BlendMode_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Add")) return Add;
	if (inName==HX_CSTRING("Erase")) return Erase;
	if (inName==HX_CSTRING("Hide")) return Hide;
	if (inName==HX_CSTRING("Multiply")) return Multiply;
	if (inName==HX_CSTRING("None")) return None;
	if (inName==HX_CSTRING("Normal")) return Normal;
	if (inName==HX_CSTRING("Screen")) return Screen;
	if (inName==HX_CSTRING("SoftAdd")) return SoftAdd;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Normal"),
	HX_CSTRING("Add"),
	HX_CSTRING("Multiply"),
	HX_CSTRING("None"),
	HX_CSTRING("SoftAdd"),
	HX_CSTRING("Erase"),
	HX_CSTRING("Hide"),
	HX_CSTRING("Screen"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BlendMode_obj::Add,"Add");
	HX_MARK_MEMBER_NAME(BlendMode_obj::Erase,"Erase");
	HX_MARK_MEMBER_NAME(BlendMode_obj::Hide,"Hide");
	HX_MARK_MEMBER_NAME(BlendMode_obj::Multiply,"Multiply");
	HX_MARK_MEMBER_NAME(BlendMode_obj::None,"None");
	HX_MARK_MEMBER_NAME(BlendMode_obj::Normal,"Normal");
	HX_MARK_MEMBER_NAME(BlendMode_obj::Screen,"Screen");
	HX_MARK_MEMBER_NAME(BlendMode_obj::SoftAdd,"SoftAdd");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BlendMode_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::Add,"Add");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::Erase,"Erase");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::Hide,"Hide");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::Multiply,"Multiply");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::None,"None");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::Normal,"Normal");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::Screen,"Screen");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::SoftAdd,"SoftAdd");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class BlendMode_obj::__mClass;

Dynamic __Create_BlendMode_obj() { return new BlendMode_obj; }

void BlendMode_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.BlendMode"), hx::TCanCast< BlendMode_obj >,sStaticFields,sMemberFields,
	&__Create_BlendMode_obj, &__Create,
	&super::__SGetClass(), &CreateBlendMode_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void BlendMode_obj::__boot()
{
hx::Static(Add) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("Add"),1);
hx::Static(Erase) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("Erase"),5);
hx::Static(Hide) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("Hide"),6);
hx::Static(Multiply) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("Multiply"),2);
hx::Static(None) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("None"),3);
hx::Static(Normal) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("Normal"),0);
hx::Static(Screen) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("Screen"),7);
hx::Static(SoftAdd) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("SoftAdd"),4);
}


} // end namespace h2d
