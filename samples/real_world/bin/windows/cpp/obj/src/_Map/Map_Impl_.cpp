#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED__Map_Map_Impl_
#include <_Map/Map_Impl_.h>
#endif
#ifndef INCLUDED_haxe_ds_BalancedTree
#include <haxe/ds/BalancedTree.h>
#endif
#ifndef INCLUDED_haxe_ds_EnumValueMap
#include <haxe/ds/EnumValueMap.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_ObjectMap
#include <haxe/ds/ObjectMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
namespace _Map{

Void Map_Impl__obj::__construct()
{
	return null();
}

//Map_Impl__obj::~Map_Impl__obj() { }

Dynamic Map_Impl__obj::__CreateEmpty() { return  new Map_Impl__obj; }
hx::ObjectPtr< Map_Impl__obj > Map_Impl__obj::__new()
{  hx::ObjectPtr< Map_Impl__obj > result = new Map_Impl__obj();
	result->__construct();
	return result;}

Dynamic Map_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Map_Impl__obj > result = new Map_Impl__obj();
	result->__construct();
	return result;}

Dynamic Map_Impl__obj::_new;

Void Map_Impl__obj::set( ::IMap this1,Dynamic key,Dynamic value){
{
		HX_STACK_FRAME("_Map.Map_Impl_","set",0x2d56f19f,"_Map.Map_Impl_.set","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",70,0x2d1fb181)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(key,"key")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(70)
		this1->set(key,value);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Map_Impl__obj,set,(void))

Dynamic Map_Impl__obj::get( ::IMap this1,Dynamic key){
	HX_STACK_FRAME("_Map.Map_Impl_","get",0x2d4dd693,"_Map.Map_Impl_.get","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",87,0x2d1fb181)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(87)
	return this1->get(key);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Map_Impl__obj,get,return )

bool Map_Impl__obj::exists( ::IMap this1,Dynamic key){
	HX_STACK_FRAME("_Map.Map_Impl_","exists",0x529ee3ff,"_Map.Map_Impl_.exists","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",94,0x2d1fb181)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(94)
	return this1->exists(key);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Map_Impl__obj,exists,return )

bool Map_Impl__obj::remove( ::IMap this1,Dynamic key){
	HX_STACK_FRAME("_Map.Map_Impl_","remove",0x97476267,"_Map.Map_Impl_.remove","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",102,0x2d1fb181)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(102)
	return this1->remove(key);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Map_Impl__obj,remove,return )

Dynamic Map_Impl__obj::keys( ::IMap this1){
	HX_STACK_FRAME("_Map.Map_Impl_","keys",0x7972c957,"_Map.Map_Impl_.keys","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",110,0x2d1fb181)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(110)
	return this1->keys();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,keys,return )

Dynamic Map_Impl__obj::iterator( ::IMap this1){
	HX_STACK_FRAME("_Map.Map_Impl_","iterator",0x68311ed1,"_Map.Map_Impl_.iterator","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",119,0x2d1fb181)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(119)
	return this1->iterator();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,iterator,return )

::String Map_Impl__obj::toString( ::IMap this1){
	HX_STACK_FRAME("_Map.Map_Impl_","toString",0x0d05a58f,"_Map.Map_Impl_.toString","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",128,0x2d1fb181)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(128)
	return this1->toString();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,toString,return )

Dynamic Map_Impl__obj::arrayWrite( ::IMap this1,Dynamic k,Dynamic v){
	HX_STACK_FRAME("_Map.Map_Impl_","arrayWrite",0x12269829,"_Map.Map_Impl_.arrayWrite","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",131,0x2d1fb181)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(k,"k")
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(132)
	this1->set(k,v);
	HX_STACK_LINE(133)
	return v;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Map_Impl__obj,arrayWrite,return )

::haxe::ds::StringMap Map_Impl__obj::toStringMap( ::IMap t){
	HX_STACK_FRAME("_Map.Map_Impl_","toStringMap",0x930fc04d,"_Map.Map_Impl_.toStringMap","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",137,0x2d1fb181)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(137)
	return ::haxe::ds::StringMap_obj::__new();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,toStringMap,return )

::haxe::ds::IntMap Map_Impl__obj::toIntMap( ::IMap t){
	HX_STACK_FRAME("_Map.Map_Impl_","toIntMap",0x9a49b1ab,"_Map.Map_Impl_.toIntMap","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",141,0x2d1fb181)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(141)
	return ::haxe::ds::IntMap_obj::__new();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,toIntMap,return )

::haxe::ds::EnumValueMap Map_Impl__obj::toEnumValueMapMap( ::IMap t){
	HX_STACK_FRAME("_Map.Map_Impl_","toEnumValueMapMap",0x168455b2,"_Map.Map_Impl_.toEnumValueMapMap","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",145,0x2d1fb181)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(145)
	return ::haxe::ds::EnumValueMap_obj::__new();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,toEnumValueMapMap,return )

::haxe::ds::ObjectMap Map_Impl__obj::toObjectMap( ::IMap t){
	HX_STACK_FRAME("_Map.Map_Impl_","toObjectMap",0x0ed4531f,"_Map.Map_Impl_.toObjectMap","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",149,0x2d1fb181)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(149)
	return ::haxe::ds::ObjectMap_obj::__new();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,toObjectMap,return )

::haxe::ds::StringMap Map_Impl__obj::fromStringMap( ::haxe::ds::StringMap map){
	HX_STACK_FRAME("_Map.Map_Impl_","fromStringMap",0x72ce03be,"_Map.Map_Impl_.fromStringMap","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",153,0x2d1fb181)
	HX_STACK_ARG(map,"map")
	HX_STACK_LINE(153)
	return map;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,fromStringMap,return )

::haxe::ds::IntMap Map_Impl__obj::fromIntMap( ::haxe::ds::IntMap map){
	HX_STACK_FRAME("_Map.Map_Impl_","fromIntMap",0x29584d9a,"_Map.Map_Impl_.fromIntMap","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",157,0x2d1fb181)
	HX_STACK_ARG(map,"map")
	HX_STACK_LINE(157)
	return map;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,fromIntMap,return )

::haxe::ds::ObjectMap Map_Impl__obj::fromObjectMap( ::haxe::ds::ObjectMap map){
	HX_STACK_FRAME("_Map.Map_Impl_","fromObjectMap",0xee929690,"_Map.Map_Impl_.fromObjectMap","D:\\Workspace\\motionTools\\haxe3\\std/Map.hx",161,0x2d1fb181)
	HX_STACK_ARG(map,"map")
	HX_STACK_LINE(161)
	return map;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Map_Impl__obj,fromObjectMap,return )


Map_Impl__obj::Map_Impl__obj()
{
}

Dynamic Map_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new; }
		if (HX_FIELD_EQ(inName,"keys") ) { return keys_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"toIntMap") ) { return toIntMap_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"arrayWrite") ) { return arrayWrite_dyn(); }
		if (HX_FIELD_EQ(inName,"fromIntMap") ) { return fromIntMap_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"toStringMap") ) { return toStringMap_dyn(); }
		if (HX_FIELD_EQ(inName,"toObjectMap") ) { return toObjectMap_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"fromStringMap") ) { return fromStringMap_dyn(); }
		if (HX_FIELD_EQ(inName,"fromObjectMap") ) { return fromObjectMap_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"toEnumValueMapMap") ) { return toEnumValueMapMap_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Map_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { _new=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Map_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("set"),
	HX_CSTRING("get"),
	HX_CSTRING("exists"),
	HX_CSTRING("remove"),
	HX_CSTRING("keys"),
	HX_CSTRING("iterator"),
	HX_CSTRING("toString"),
	HX_CSTRING("arrayWrite"),
	HX_CSTRING("toStringMap"),
	HX_CSTRING("toIntMap"),
	HX_CSTRING("toEnumValueMapMap"),
	HX_CSTRING("toObjectMap"),
	HX_CSTRING("fromStringMap"),
	HX_CSTRING("fromIntMap"),
	HX_CSTRING("fromObjectMap"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Map_Impl__obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Map_Impl__obj::_new,"_new");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Map_Impl__obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Map_Impl__obj::_new,"_new");
};

#endif

Class Map_Impl__obj::__mClass;

void Map_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("_Map.Map_Impl_"), hx::TCanCast< Map_Impl__obj> ,sStaticFields,sMemberFields,
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

void Map_Impl__obj::__boot()
{
}

} // end namespace _Map
