#include <hxcpp.h>

#ifndef INCLUDED_haxe_Resource
#include <haxe/Resource.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
namespace haxe{

Void Resource_obj::__construct()
{
	return null();
}

//Resource_obj::~Resource_obj() { }

Dynamic Resource_obj::__CreateEmpty() { return  new Resource_obj; }
hx::ObjectPtr< Resource_obj > Resource_obj::__new()
{  hx::ObjectPtr< Resource_obj > result = new Resource_obj();
	result->__construct();
	return result;}

Dynamic Resource_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Resource_obj > result = new Resource_obj();
	result->__construct();
	return result;}

Array< ::String > Resource_obj::listNames( ){
	HX_STACK_FRAME("haxe.Resource","listNames",0xb6810652,"haxe.Resource.listNames","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Resource.hx",28,0xbcc38267)
	HX_STACK_LINE(28)
	return ::__hxcpp_resource_names();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Resource_obj,listNames,return )

::String Resource_obj::getString( ::String name){
	HX_STACK_FRAME("haxe.Resource","getString",0x974269cf,"haxe.Resource.getString","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Resource.hx",31,0xbcc38267)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(31)
	return ::__hxcpp_resource_string(name);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Resource_obj,getString,return )

::haxe::io::Bytes Resource_obj::getBytes( ::String name){
	HX_STACK_FRAME("haxe.Resource","getBytes",0x9bc1712d,"haxe.Resource.getBytes","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/Resource.hx",33,0xbcc38267)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(34)
	Array< unsigned char > array = ::__hxcpp_resource_bytes(name);		HX_STACK_VAR(array,"array");
	HX_STACK_LINE(35)
	if (((array == null()))){
		HX_STACK_LINE(35)
		return null();
	}
	HX_STACK_LINE(36)
	return ::haxe::io::Bytes_obj::ofData(array);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Resource_obj,getBytes,return )


Resource_obj::Resource_obj()
{
}

Dynamic Resource_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"listNames") ) { return listNames_dyn(); }
		if (HX_FIELD_EQ(inName,"getString") ) { return getString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Resource_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Resource_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("listNames"),
	HX_CSTRING("getString"),
	HX_CSTRING("getBytes"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Resource_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Resource_obj::__mClass,"__mClass");
};

#endif

Class Resource_obj::__mClass;

void Resource_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.Resource"), hx::TCanCast< Resource_obj> ,sStaticFields,sMemberFields,
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

void Resource_obj::__boot()
{
}

} // end namespace haxe
