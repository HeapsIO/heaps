#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_WeakMap
#include <haxe/ds/WeakMap.h>
#endif
namespace haxe{
namespace ds{

Void WeakMap_obj::__construct()
{
HX_STACK_FRAME("haxe.ds.WeakMap","new",0x58f74bbf,"haxe.ds.WeakMap.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",38,0x3c590d70)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(38)
	HX_STACK_DO_THROW(HX_CSTRING("Not implemented for this platform"));
}
;
	return null();
}

//WeakMap_obj::~WeakMap_obj() { }

Dynamic WeakMap_obj::__CreateEmpty() { return  new WeakMap_obj; }
hx::ObjectPtr< WeakMap_obj > WeakMap_obj::__new()
{  hx::ObjectPtr< WeakMap_obj > result = new WeakMap_obj();
	result->__construct();
	return result;}

Dynamic WeakMap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< WeakMap_obj > result = new WeakMap_obj();
	result->__construct();
	return result;}

hx::Object *WeakMap_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::IMap_obj)) return operator ::IMap_obj *();
	return super::__ToInterface(inType);
}

Void WeakMap_obj::set( Dynamic key,Dynamic value){
{
		HX_STACK_FRAME("haxe.ds.WeakMap","set",0x58fb1701,"haxe.ds.WeakMap.set","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",44,0x3c590d70)
		HX_STACK_THIS(this)
		HX_STACK_ARG(key,"key")
		HX_STACK_ARG(value,"value")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(WeakMap_obj,set,(void))

Dynamic WeakMap_obj::get( Dynamic key){
	HX_STACK_FRAME("haxe.ds.WeakMap","get",0x58f1fbf5,"haxe.ds.WeakMap.get","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",51,0x3c590d70)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(51)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(WeakMap_obj,get,return )

bool WeakMap_obj::exists( Dynamic key){
	HX_STACK_FRAME("haxe.ds.WeakMap","exists",0xbb26c7dd,"haxe.ds.WeakMap.exists","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",58,0x3c590d70)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(58)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(WeakMap_obj,exists,return )

bool WeakMap_obj::remove( Dynamic key){
	HX_STACK_FRAME("haxe.ds.WeakMap","remove",0xffcf4645,"haxe.ds.WeakMap.remove","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",65,0x3c590d70)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(65)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(WeakMap_obj,remove,return )

Dynamic WeakMap_obj::keys( ){
	HX_STACK_FRAME("haxe.ds.WeakMap","keys",0x7d6f59b5,"haxe.ds.WeakMap.keys","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",72,0x3c590d70)
	HX_STACK_THIS(this)
	HX_STACK_LINE(72)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(WeakMap_obj,keys,return )

Dynamic WeakMap_obj::iterator( ){
	HX_STACK_FRAME("haxe.ds.WeakMap","iterator",0xed60362f,"haxe.ds.WeakMap.iterator","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",79,0x3c590d70)
	HX_STACK_THIS(this)
	HX_STACK_LINE(79)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(WeakMap_obj,iterator,return )

::String WeakMap_obj::toString( ){
	HX_STACK_FRAME("haxe.ds.WeakMap","toString",0x9234bced,"haxe.ds.WeakMap.toString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/WeakMap.hx",86,0x3c590d70)
	HX_STACK_THIS(this)
	HX_STACK_LINE(86)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(WeakMap_obj,toString,return )


WeakMap_obj::WeakMap_obj()
{
}

Dynamic WeakMap_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"keys") ) { return keys_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic WeakMap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void WeakMap_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("set"),
	HX_CSTRING("get"),
	HX_CSTRING("exists"),
	HX_CSTRING("remove"),
	HX_CSTRING("keys"),
	HX_CSTRING("iterator"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(WeakMap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(WeakMap_obj::__mClass,"__mClass");
};

#endif

Class WeakMap_obj::__mClass;

void WeakMap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds.WeakMap"), hx::TCanCast< WeakMap_obj> ,sStaticFields,sMemberFields,
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

void WeakMap_obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
