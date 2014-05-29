#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_ShaderType
#include <h3d/impl/ShaderType.h>
#endif
namespace h3d{
namespace impl{

::h3d::impl::ShaderType ShaderType_obj::Byte3;

::h3d::impl::ShaderType ShaderType_obj::Byte4;

::h3d::impl::ShaderType  ShaderType_obj::Elements(::String field,Dynamic size,::h3d::impl::ShaderType t)
	{ return hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Elements"),13,hx::DynamicArray(0,3).Add(field).Add(size).Add(t)); }

::h3d::impl::ShaderType ShaderType_obj::_Float;

::h3d::impl::ShaderType  ShaderType_obj::Index(int index,::h3d::impl::ShaderType t)
	{ return hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Index"),12,hx::DynamicArray(0,2).Add(index).Add(t)); }

::h3d::impl::ShaderType ShaderType_obj::Mat2;

::h3d::impl::ShaderType ShaderType_obj::Mat3;

::h3d::impl::ShaderType ShaderType_obj::Mat4;

::h3d::impl::ShaderType  ShaderType_obj::Struct(::String field,::h3d::impl::ShaderType t)
	{ return hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Struct"),11,hx::DynamicArray(0,2).Add(field).Add(t)); }

::h3d::impl::ShaderType ShaderType_obj::Tex2d;

::h3d::impl::ShaderType ShaderType_obj::TexCube;

::h3d::impl::ShaderType ShaderType_obj::Vec2;

::h3d::impl::ShaderType ShaderType_obj::Vec3;

::h3d::impl::ShaderType ShaderType_obj::Vec4;

HX_DEFINE_CREATE_ENUM(ShaderType_obj)

int ShaderType_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Byte3")) return 9;
	if (inName==HX_CSTRING("Byte4")) return 10;
	if (inName==HX_CSTRING("Elements")) return 13;
	if (inName==HX_CSTRING("Float")) return 0;
	if (inName==HX_CSTRING("Index")) return 12;
	if (inName==HX_CSTRING("Mat2")) return 4;
	if (inName==HX_CSTRING("Mat3")) return 5;
	if (inName==HX_CSTRING("Mat4")) return 6;
	if (inName==HX_CSTRING("Struct")) return 11;
	if (inName==HX_CSTRING("Tex2d")) return 7;
	if (inName==HX_CSTRING("TexCube")) return 8;
	if (inName==HX_CSTRING("Vec2")) return 1;
	if (inName==HX_CSTRING("Vec3")) return 2;
	if (inName==HX_CSTRING("Vec4")) return 3;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC3(ShaderType_obj,Elements,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(ShaderType_obj,Index,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(ShaderType_obj,Struct,return)

int ShaderType_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Byte3")) return 0;
	if (inName==HX_CSTRING("Byte4")) return 0;
	if (inName==HX_CSTRING("Elements")) return 3;
	if (inName==HX_CSTRING("Float")) return 0;
	if (inName==HX_CSTRING("Index")) return 2;
	if (inName==HX_CSTRING("Mat2")) return 0;
	if (inName==HX_CSTRING("Mat3")) return 0;
	if (inName==HX_CSTRING("Mat4")) return 0;
	if (inName==HX_CSTRING("Struct")) return 2;
	if (inName==HX_CSTRING("Tex2d")) return 0;
	if (inName==HX_CSTRING("TexCube")) return 0;
	if (inName==HX_CSTRING("Vec2")) return 0;
	if (inName==HX_CSTRING("Vec3")) return 0;
	if (inName==HX_CSTRING("Vec4")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic ShaderType_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Byte3")) return Byte3;
	if (inName==HX_CSTRING("Byte4")) return Byte4;
	if (inName==HX_CSTRING("Elements")) return Elements_dyn();
	if (inName==HX_CSTRING("Float")) return _Float;
	if (inName==HX_CSTRING("Index")) return Index_dyn();
	if (inName==HX_CSTRING("Mat2")) return Mat2;
	if (inName==HX_CSTRING("Mat3")) return Mat3;
	if (inName==HX_CSTRING("Mat4")) return Mat4;
	if (inName==HX_CSTRING("Struct")) return Struct_dyn();
	if (inName==HX_CSTRING("Tex2d")) return Tex2d;
	if (inName==HX_CSTRING("TexCube")) return TexCube;
	if (inName==HX_CSTRING("Vec2")) return Vec2;
	if (inName==HX_CSTRING("Vec3")) return Vec3;
	if (inName==HX_CSTRING("Vec4")) return Vec4;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Float"),
	HX_CSTRING("Vec2"),
	HX_CSTRING("Vec3"),
	HX_CSTRING("Vec4"),
	HX_CSTRING("Mat2"),
	HX_CSTRING("Mat3"),
	HX_CSTRING("Mat4"),
	HX_CSTRING("Tex2d"),
	HX_CSTRING("TexCube"),
	HX_CSTRING("Byte3"),
	HX_CSTRING("Byte4"),
	HX_CSTRING("Struct"),
	HX_CSTRING("Index"),
	HX_CSTRING("Elements"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ShaderType_obj::Byte3,"Byte3");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Byte4,"Byte4");
	HX_MARK_MEMBER_NAME(ShaderType_obj::_Float,"_Float");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Mat2,"Mat2");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Mat3,"Mat3");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Mat4,"Mat4");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Tex2d,"Tex2d");
	HX_MARK_MEMBER_NAME(ShaderType_obj::TexCube,"TexCube");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Vec2,"Vec2");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Vec3,"Vec3");
	HX_MARK_MEMBER_NAME(ShaderType_obj::Vec4,"Vec4");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ShaderType_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Byte3,"Byte3");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Byte4,"Byte4");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::_Float,"_Float");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Mat2,"Mat2");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Mat3,"Mat3");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Mat4,"Mat4");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Tex2d,"Tex2d");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::TexCube,"TexCube");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Vec2,"Vec2");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Vec3,"Vec3");
	HX_VISIT_MEMBER_NAME(ShaderType_obj::Vec4,"Vec4");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class ShaderType_obj::__mClass;

Dynamic __Create_ShaderType_obj() { return new ShaderType_obj; }

void ShaderType_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.ShaderType"), hx::TCanCast< ShaderType_obj >,sStaticFields,sMemberFields,
	&__Create_ShaderType_obj, &__Create,
	&super::__SGetClass(), &CreateShaderType_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void ShaderType_obj::__boot()
{
hx::Static(Byte3) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Byte3"),9);
hx::Static(Byte4) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Byte4"),10);
hx::Static(_Float) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Float"),0);
hx::Static(Mat2) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Mat2"),4);
hx::Static(Mat3) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Mat3"),5);
hx::Static(Mat4) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Mat4"),6);
hx::Static(Tex2d) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Tex2d"),7);
hx::Static(TexCube) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("TexCube"),8);
hx::Static(Vec2) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Vec2"),1);
hx::Static(Vec3) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Vec3"),2);
hx::Static(Vec4) = hx::CreateEnum< ShaderType_obj >(HX_CSTRING("Vec4"),3);
}


} // end namespace h3d
} // end namespace impl
