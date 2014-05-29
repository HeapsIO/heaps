#include <hxcpp.h>

#ifndef INCLUDED_h3d_mat_Blend
#include <h3d/mat/Blend.h>
#endif
namespace h3d{
namespace mat{

::h3d::mat::Blend Blend_obj::ConstantAlpha;

::h3d::mat::Blend Blend_obj::ConstantColor;

::h3d::mat::Blend Blend_obj::DstAlpha;

::h3d::mat::Blend Blend_obj::DstColor;

::h3d::mat::Blend Blend_obj::One;

::h3d::mat::Blend Blend_obj::OneMinusConstantAlpha;

::h3d::mat::Blend Blend_obj::OneMinusConstantColor;

::h3d::mat::Blend Blend_obj::OneMinusDstAlpha;

::h3d::mat::Blend Blend_obj::OneMinusDstColor;

::h3d::mat::Blend Blend_obj::OneMinusSrcAlpha;

::h3d::mat::Blend Blend_obj::OneMinusSrcColor;

::h3d::mat::Blend Blend_obj::SrcAlpha;

::h3d::mat::Blend Blend_obj::SrcAlphaSaturate;

::h3d::mat::Blend Blend_obj::SrcColor;

::h3d::mat::Blend Blend_obj::Zero;

HX_DEFINE_CREATE_ENUM(Blend_obj)

int Blend_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("ConstantAlpha")) return 11;
	if (inName==HX_CSTRING("ConstantColor")) return 10;
	if (inName==HX_CSTRING("DstAlpha")) return 4;
	if (inName==HX_CSTRING("DstColor")) return 5;
	if (inName==HX_CSTRING("One")) return 0;
	if (inName==HX_CSTRING("OneMinusConstantAlpha")) return 13;
	if (inName==HX_CSTRING("OneMinusConstantColor")) return 12;
	if (inName==HX_CSTRING("OneMinusDstAlpha")) return 8;
	if (inName==HX_CSTRING("OneMinusDstColor")) return 9;
	if (inName==HX_CSTRING("OneMinusSrcAlpha")) return 6;
	if (inName==HX_CSTRING("OneMinusSrcColor")) return 7;
	if (inName==HX_CSTRING("SrcAlpha")) return 2;
	if (inName==HX_CSTRING("SrcAlphaSaturate")) return 14;
	if (inName==HX_CSTRING("SrcColor")) return 3;
	if (inName==HX_CSTRING("Zero")) return 1;
	return super::__FindIndex(inName);
}

int Blend_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("ConstantAlpha")) return 0;
	if (inName==HX_CSTRING("ConstantColor")) return 0;
	if (inName==HX_CSTRING("DstAlpha")) return 0;
	if (inName==HX_CSTRING("DstColor")) return 0;
	if (inName==HX_CSTRING("One")) return 0;
	if (inName==HX_CSTRING("OneMinusConstantAlpha")) return 0;
	if (inName==HX_CSTRING("OneMinusConstantColor")) return 0;
	if (inName==HX_CSTRING("OneMinusDstAlpha")) return 0;
	if (inName==HX_CSTRING("OneMinusDstColor")) return 0;
	if (inName==HX_CSTRING("OneMinusSrcAlpha")) return 0;
	if (inName==HX_CSTRING("OneMinusSrcColor")) return 0;
	if (inName==HX_CSTRING("SrcAlpha")) return 0;
	if (inName==HX_CSTRING("SrcAlphaSaturate")) return 0;
	if (inName==HX_CSTRING("SrcColor")) return 0;
	if (inName==HX_CSTRING("Zero")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Blend_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("ConstantAlpha")) return ConstantAlpha;
	if (inName==HX_CSTRING("ConstantColor")) return ConstantColor;
	if (inName==HX_CSTRING("DstAlpha")) return DstAlpha;
	if (inName==HX_CSTRING("DstColor")) return DstColor;
	if (inName==HX_CSTRING("One")) return One;
	if (inName==HX_CSTRING("OneMinusConstantAlpha")) return OneMinusConstantAlpha;
	if (inName==HX_CSTRING("OneMinusConstantColor")) return OneMinusConstantColor;
	if (inName==HX_CSTRING("OneMinusDstAlpha")) return OneMinusDstAlpha;
	if (inName==HX_CSTRING("OneMinusDstColor")) return OneMinusDstColor;
	if (inName==HX_CSTRING("OneMinusSrcAlpha")) return OneMinusSrcAlpha;
	if (inName==HX_CSTRING("OneMinusSrcColor")) return OneMinusSrcColor;
	if (inName==HX_CSTRING("SrcAlpha")) return SrcAlpha;
	if (inName==HX_CSTRING("SrcAlphaSaturate")) return SrcAlphaSaturate;
	if (inName==HX_CSTRING("SrcColor")) return SrcColor;
	if (inName==HX_CSTRING("Zero")) return Zero;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("One"),
	HX_CSTRING("Zero"),
	HX_CSTRING("SrcAlpha"),
	HX_CSTRING("SrcColor"),
	HX_CSTRING("DstAlpha"),
	HX_CSTRING("DstColor"),
	HX_CSTRING("OneMinusSrcAlpha"),
	HX_CSTRING("OneMinusSrcColor"),
	HX_CSTRING("OneMinusDstAlpha"),
	HX_CSTRING("OneMinusDstColor"),
	HX_CSTRING("ConstantColor"),
	HX_CSTRING("ConstantAlpha"),
	HX_CSTRING("OneMinusConstantColor"),
	HX_CSTRING("OneMinusConstantAlpha"),
	HX_CSTRING("SrcAlphaSaturate"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Blend_obj::ConstantAlpha,"ConstantAlpha");
	HX_MARK_MEMBER_NAME(Blend_obj::ConstantColor,"ConstantColor");
	HX_MARK_MEMBER_NAME(Blend_obj::DstAlpha,"DstAlpha");
	HX_MARK_MEMBER_NAME(Blend_obj::DstColor,"DstColor");
	HX_MARK_MEMBER_NAME(Blend_obj::One,"One");
	HX_MARK_MEMBER_NAME(Blend_obj::OneMinusConstantAlpha,"OneMinusConstantAlpha");
	HX_MARK_MEMBER_NAME(Blend_obj::OneMinusConstantColor,"OneMinusConstantColor");
	HX_MARK_MEMBER_NAME(Blend_obj::OneMinusDstAlpha,"OneMinusDstAlpha");
	HX_MARK_MEMBER_NAME(Blend_obj::OneMinusDstColor,"OneMinusDstColor");
	HX_MARK_MEMBER_NAME(Blend_obj::OneMinusSrcAlpha,"OneMinusSrcAlpha");
	HX_MARK_MEMBER_NAME(Blend_obj::OneMinusSrcColor,"OneMinusSrcColor");
	HX_MARK_MEMBER_NAME(Blend_obj::SrcAlpha,"SrcAlpha");
	HX_MARK_MEMBER_NAME(Blend_obj::SrcAlphaSaturate,"SrcAlphaSaturate");
	HX_MARK_MEMBER_NAME(Blend_obj::SrcColor,"SrcColor");
	HX_MARK_MEMBER_NAME(Blend_obj::Zero,"Zero");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Blend_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Blend_obj::ConstantAlpha,"ConstantAlpha");
	HX_VISIT_MEMBER_NAME(Blend_obj::ConstantColor,"ConstantColor");
	HX_VISIT_MEMBER_NAME(Blend_obj::DstAlpha,"DstAlpha");
	HX_VISIT_MEMBER_NAME(Blend_obj::DstColor,"DstColor");
	HX_VISIT_MEMBER_NAME(Blend_obj::One,"One");
	HX_VISIT_MEMBER_NAME(Blend_obj::OneMinusConstantAlpha,"OneMinusConstantAlpha");
	HX_VISIT_MEMBER_NAME(Blend_obj::OneMinusConstantColor,"OneMinusConstantColor");
	HX_VISIT_MEMBER_NAME(Blend_obj::OneMinusDstAlpha,"OneMinusDstAlpha");
	HX_VISIT_MEMBER_NAME(Blend_obj::OneMinusDstColor,"OneMinusDstColor");
	HX_VISIT_MEMBER_NAME(Blend_obj::OneMinusSrcAlpha,"OneMinusSrcAlpha");
	HX_VISIT_MEMBER_NAME(Blend_obj::OneMinusSrcColor,"OneMinusSrcColor");
	HX_VISIT_MEMBER_NAME(Blend_obj::SrcAlpha,"SrcAlpha");
	HX_VISIT_MEMBER_NAME(Blend_obj::SrcAlphaSaturate,"SrcAlphaSaturate");
	HX_VISIT_MEMBER_NAME(Blend_obj::SrcColor,"SrcColor");
	HX_VISIT_MEMBER_NAME(Blend_obj::Zero,"Zero");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Blend_obj::__mClass;

Dynamic __Create_Blend_obj() { return new Blend_obj; }

void Blend_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.Blend"), hx::TCanCast< Blend_obj >,sStaticFields,sMemberFields,
	&__Create_Blend_obj, &__Create,
	&super::__SGetClass(), &CreateBlend_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Blend_obj::__boot()
{
hx::Static(ConstantAlpha) = hx::CreateEnum< Blend_obj >(HX_CSTRING("ConstantAlpha"),11);
hx::Static(ConstantColor) = hx::CreateEnum< Blend_obj >(HX_CSTRING("ConstantColor"),10);
hx::Static(DstAlpha) = hx::CreateEnum< Blend_obj >(HX_CSTRING("DstAlpha"),4);
hx::Static(DstColor) = hx::CreateEnum< Blend_obj >(HX_CSTRING("DstColor"),5);
hx::Static(One) = hx::CreateEnum< Blend_obj >(HX_CSTRING("One"),0);
hx::Static(OneMinusConstantAlpha) = hx::CreateEnum< Blend_obj >(HX_CSTRING("OneMinusConstantAlpha"),13);
hx::Static(OneMinusConstantColor) = hx::CreateEnum< Blend_obj >(HX_CSTRING("OneMinusConstantColor"),12);
hx::Static(OneMinusDstAlpha) = hx::CreateEnum< Blend_obj >(HX_CSTRING("OneMinusDstAlpha"),8);
hx::Static(OneMinusDstColor) = hx::CreateEnum< Blend_obj >(HX_CSTRING("OneMinusDstColor"),9);
hx::Static(OneMinusSrcAlpha) = hx::CreateEnum< Blend_obj >(HX_CSTRING("OneMinusSrcAlpha"),6);
hx::Static(OneMinusSrcColor) = hx::CreateEnum< Blend_obj >(HX_CSTRING("OneMinusSrcColor"),7);
hx::Static(SrcAlpha) = hx::CreateEnum< Blend_obj >(HX_CSTRING("SrcAlpha"),2);
hx::Static(SrcAlphaSaturate) = hx::CreateEnum< Blend_obj >(HX_CSTRING("SrcAlphaSaturate"),14);
hx::Static(SrcColor) = hx::CreateEnum< Blend_obj >(HX_CSTRING("SrcColor"),3);
hx::Static(Zero) = hx::CreateEnum< Blend_obj >(HX_CSTRING("Zero"),1);
}


} // end namespace h3d
} // end namespace mat
