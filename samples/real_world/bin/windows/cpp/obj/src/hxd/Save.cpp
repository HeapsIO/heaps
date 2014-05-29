#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxd_Save
#include <hxd/Save.h>
#endif
namespace hxd{

Void Save_obj::__construct()
{
	return null();
}

//Save_obj::~Save_obj() { }

Dynamic Save_obj::__CreateEmpty() { return  new Save_obj; }
hx::ObjectPtr< Save_obj > Save_obj::__new()
{  hx::ObjectPtr< Save_obj > result = new Save_obj();
	result->__construct();
	return result;}

Dynamic Save_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Save_obj > result = new Save_obj();
	result->__construct();
	return result;}

::haxe::ds::StringMap Save_obj::cur;

Dynamic Save_obj::load( Dynamic defValue,::String __o_name){
::String name = __o_name.Default(HX_CSTRING("save"));
	HX_STACK_FRAME("hxd.Save","load",0x6daa8f3d,"hxd.Save.load","hxd/Save.hx",28,0xdc157e86)
	HX_STACK_ARG(defValue,"defValue")
	HX_STACK_ARG(name,"name")
{
		HX_STACK_LINE(28)
		return defValue;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Save_obj,load,return )

bool Save_obj::save( Dynamic val,::String __o_name,Dynamic quick){
::String name = __o_name.Default(HX_CSTRING("save"));
	HX_STACK_FRAME("hxd.Save","save",0x72408054,"hxd.Save.save","hxd/Save.hx",42,0xdc157e86)
	HX_STACK_ARG(val,"val")
	HX_STACK_ARG(name,"name")
	HX_STACK_ARG(quick,"quick")
{
		HX_STACK_LINE(42)
		return false;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Save_obj,save,return )


Save_obj::Save_obj()
{
}

Dynamic Save_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"cur") ) { return cur; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		if (HX_FIELD_EQ(inName,"save") ) { return save_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Save_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"cur") ) { cur=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Save_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("cur"),
	HX_CSTRING("load"),
	HX_CSTRING("save"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Save_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Save_obj::cur,"cur");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Save_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Save_obj::cur,"cur");
};

#endif

Class Save_obj::__mClass;

void Save_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Save"), hx::TCanCast< Save_obj> ,sStaticFields,sMemberFields,
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

void Save_obj::__boot()
{
	cur= ::haxe::ds::StringMap_obj::__new();
}

} // end namespace hxd
