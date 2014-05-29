#include <hxcpp.h>

#ifndef INCLUDED_openfl_AssetData
#include <openfl/AssetData.h>
#endif
#ifndef INCLUDED_openfl_AssetType
#include <openfl/AssetType.h>
#endif
namespace openfl{

Void AssetData_obj::__construct()
{
HX_STACK_FRAME("openfl.AssetData","new",0x369fb4ae,"openfl.AssetData.new","openfl/Assets.hx",1319,0x989d477c)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//AssetData_obj::~AssetData_obj() { }

Dynamic AssetData_obj::__CreateEmpty() { return  new AssetData_obj; }
hx::ObjectPtr< AssetData_obj > AssetData_obj::__new()
{  hx::ObjectPtr< AssetData_obj > result = new AssetData_obj();
	result->__construct();
	return result;}

Dynamic AssetData_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AssetData_obj > result = new AssetData_obj();
	result->__construct();
	return result;}


AssetData_obj::AssetData_obj()
{
}

void AssetData_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AssetData);
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(path,"path");
	HX_MARK_MEMBER_NAME(type,"type");
	HX_MARK_END_CLASS();
}

void AssetData_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(path,"path");
	HX_VISIT_MEMBER_NAME(type,"type");
}

Dynamic AssetData_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"path") ) { return path; }
		if (HX_FIELD_EQ(inName,"type") ) { return type; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic AssetData_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< ::String >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"path") ) { path=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"type") ) { type=inValue.Cast< ::openfl::AssetType >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void AssetData_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("path"));
	outFields->push(HX_CSTRING("type"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(AssetData_obj,id),HX_CSTRING("id")},
	{hx::fsString,(int)offsetof(AssetData_obj,path),HX_CSTRING("path")},
	{hx::fsObject /*::openfl::AssetType*/ ,(int)offsetof(AssetData_obj,type),HX_CSTRING("type")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("id"),
	HX_CSTRING("path"),
	HX_CSTRING("type"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AssetData_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(AssetData_obj::__mClass,"__mClass");
};

#endif

Class AssetData_obj::__mClass;

void AssetData_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.AssetData"), hx::TCanCast< AssetData_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void AssetData_obj::__boot()
{
}

} // end namespace openfl
