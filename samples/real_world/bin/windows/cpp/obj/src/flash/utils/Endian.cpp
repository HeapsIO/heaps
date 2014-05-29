#include <hxcpp.h>

#ifndef INCLUDED_flash_utils_Endian
#include <flash/utils/Endian.h>
#endif
namespace flash{
namespace utils{

Void Endian_obj::__construct()
{
	return null();
}

//Endian_obj::~Endian_obj() { }

Dynamic Endian_obj::__CreateEmpty() { return  new Endian_obj; }
hx::ObjectPtr< Endian_obj > Endian_obj::__new()
{  hx::ObjectPtr< Endian_obj > result = new Endian_obj();
	result->__construct();
	return result;}

Dynamic Endian_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Endian_obj > result = new Endian_obj();
	result->__construct();
	return result;}

::String Endian_obj::_BIG_ENDIAN;

::String Endian_obj::_LITTLE_ENDIAN;


Endian_obj::Endian_obj()
{
}

Dynamic Endian_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic Endian_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Endian_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("BIG_ENDIAN"),
	HX_CSTRING("LITTLE_ENDIAN"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Endian_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Endian_obj::_BIG_ENDIAN,"BIG_ENDIAN");
	HX_MARK_MEMBER_NAME(Endian_obj::_LITTLE_ENDIAN,"LITTLE_ENDIAN");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Endian_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Endian_obj::_BIG_ENDIAN,"BIG_ENDIAN");
	HX_VISIT_MEMBER_NAME(Endian_obj::_LITTLE_ENDIAN,"LITTLE_ENDIAN");
};

#endif

Class Endian_obj::__mClass;

void Endian_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.utils.Endian"), hx::TCanCast< Endian_obj> ,sStaticFields,sMemberFields,
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

void Endian_obj::__boot()
{
	_BIG_ENDIAN= HX_CSTRING("bigEndian");
	_LITTLE_ENDIAN= HX_CSTRING("littleEndian");
}

} // end namespace flash
} // end namespace utils
