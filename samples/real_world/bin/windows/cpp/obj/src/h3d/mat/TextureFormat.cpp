#include <hxcpp.h>

#ifndef INCLUDED_h3d_mat_TextureFormat
#include <h3d/mat/TextureFormat.h>
#endif
namespace h3d{
namespace mat{

::h3d::mat::TextureFormat TextureFormat_obj::Atf;

::h3d::mat::TextureFormat  TextureFormat_obj::AtfCompressed(bool alpha)
	{ return hx::CreateEnum< TextureFormat_obj >(HX_CSTRING("AtfCompressed"),2,hx::DynamicArray(0,1).Add(alpha)); }

::h3d::mat::TextureFormat TextureFormat_obj::Rgba;

HX_DEFINE_CREATE_ENUM(TextureFormat_obj)

int TextureFormat_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Atf")) return 1;
	if (inName==HX_CSTRING("AtfCompressed")) return 2;
	if (inName==HX_CSTRING("Rgba")) return 0;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(TextureFormat_obj,AtfCompressed,return)

int TextureFormat_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Atf")) return 0;
	if (inName==HX_CSTRING("AtfCompressed")) return 1;
	if (inName==HX_CSTRING("Rgba")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic TextureFormat_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Atf")) return Atf;
	if (inName==HX_CSTRING("AtfCompressed")) return AtfCompressed_dyn();
	if (inName==HX_CSTRING("Rgba")) return Rgba;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Rgba"),
	HX_CSTRING("Atf"),
	HX_CSTRING("AtfCompressed"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TextureFormat_obj::Atf,"Atf");
	HX_MARK_MEMBER_NAME(TextureFormat_obj::Rgba,"Rgba");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TextureFormat_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(TextureFormat_obj::Atf,"Atf");
	HX_VISIT_MEMBER_NAME(TextureFormat_obj::Rgba,"Rgba");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class TextureFormat_obj::__mClass;

Dynamic __Create_TextureFormat_obj() { return new TextureFormat_obj; }

void TextureFormat_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.mat.TextureFormat"), hx::TCanCast< TextureFormat_obj >,sStaticFields,sMemberFields,
	&__Create_TextureFormat_obj, &__Create,
	&super::__SGetClass(), &CreateTextureFormat_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void TextureFormat_obj::__boot()
{
hx::Static(Atf) = hx::CreateEnum< TextureFormat_obj >(HX_CSTRING("Atf"),1);
hx::Static(Rgba) = hx::CreateEnum< TextureFormat_obj >(HX_CSTRING("Rgba"),0);
}


} // end namespace h3d
} // end namespace mat
