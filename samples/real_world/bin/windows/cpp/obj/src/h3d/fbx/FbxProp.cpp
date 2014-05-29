#include <hxcpp.h>

#ifndef INCLUDED_h3d_fbx_FbxProp
#include <h3d/fbx/FbxProp.h>
#endif
namespace h3d{
namespace fbx{

::h3d::fbx::FbxProp  FbxProp_obj::PFloat(Float v)
	{ return hx::CreateEnum< FbxProp_obj >(HX_CSTRING("PFloat"),1,hx::DynamicArray(0,1).Add(v)); }

::h3d::fbx::FbxProp  FbxProp_obj::PFloats(Array< Float > v)
	{ return hx::CreateEnum< FbxProp_obj >(HX_CSTRING("PFloats"),5,hx::DynamicArray(0,1).Add(v)); }

::h3d::fbx::FbxProp  FbxProp_obj::PIdent(::String i)
	{ return hx::CreateEnum< FbxProp_obj >(HX_CSTRING("PIdent"),3,hx::DynamicArray(0,1).Add(i)); }

::h3d::fbx::FbxProp  FbxProp_obj::PInt(int v)
	{ return hx::CreateEnum< FbxProp_obj >(HX_CSTRING("PInt"),0,hx::DynamicArray(0,1).Add(v)); }

::h3d::fbx::FbxProp  FbxProp_obj::PInts(Array< int > v)
	{ return hx::CreateEnum< FbxProp_obj >(HX_CSTRING("PInts"),4,hx::DynamicArray(0,1).Add(v)); }

::h3d::fbx::FbxProp  FbxProp_obj::PString(::String v)
	{ return hx::CreateEnum< FbxProp_obj >(HX_CSTRING("PString"),2,hx::DynamicArray(0,1).Add(v)); }

HX_DEFINE_CREATE_ENUM(FbxProp_obj)

int FbxProp_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("PFloat")) return 1;
	if (inName==HX_CSTRING("PFloats")) return 5;
	if (inName==HX_CSTRING("PIdent")) return 3;
	if (inName==HX_CSTRING("PInt")) return 0;
	if (inName==HX_CSTRING("PInts")) return 4;
	if (inName==HX_CSTRING("PString")) return 2;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(FbxProp_obj,PFloat,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(FbxProp_obj,PFloats,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(FbxProp_obj,PIdent,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(FbxProp_obj,PInt,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(FbxProp_obj,PInts,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(FbxProp_obj,PString,return)

int FbxProp_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("PFloat")) return 1;
	if (inName==HX_CSTRING("PFloats")) return 1;
	if (inName==HX_CSTRING("PIdent")) return 1;
	if (inName==HX_CSTRING("PInt")) return 1;
	if (inName==HX_CSTRING("PInts")) return 1;
	if (inName==HX_CSTRING("PString")) return 1;
	return super::__FindArgCount(inName);
}

Dynamic FbxProp_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("PFloat")) return PFloat_dyn();
	if (inName==HX_CSTRING("PFloats")) return PFloats_dyn();
	if (inName==HX_CSTRING("PIdent")) return PIdent_dyn();
	if (inName==HX_CSTRING("PInt")) return PInt_dyn();
	if (inName==HX_CSTRING("PInts")) return PInts_dyn();
	if (inName==HX_CSTRING("PString")) return PString_dyn();
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("PInt"),
	HX_CSTRING("PFloat"),
	HX_CSTRING("PString"),
	HX_CSTRING("PIdent"),
	HX_CSTRING("PInts"),
	HX_CSTRING("PFloats"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FbxProp_obj::__mClass,"__mClass");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class FbxProp_obj::__mClass;

Dynamic __Create_FbxProp_obj() { return new FbxProp_obj; }

void FbxProp_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.FbxProp"), hx::TCanCast< FbxProp_obj >,sStaticFields,sMemberFields,
	&__Create_FbxProp_obj, &__Create,
	&super::__SGetClass(), &CreateFbxProp_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void FbxProp_obj::__boot()
{
}


} // end namespace h3d
} // end namespace fbx
