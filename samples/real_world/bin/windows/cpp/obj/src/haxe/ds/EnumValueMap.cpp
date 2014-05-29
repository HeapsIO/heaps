#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_haxe_ds_BalancedTree
#include <haxe/ds/BalancedTree.h>
#endif
#ifndef INCLUDED_haxe_ds_EnumValueMap
#include <haxe/ds/EnumValueMap.h>
#endif
namespace haxe{
namespace ds{

Void EnumValueMap_obj::__construct()
{
HX_STACK_FRAME("haxe.ds.EnumValueMap","new",0x9ce29655,"haxe.ds.EnumValueMap.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/EnumValueMap.hx",31,0xb099e57c)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(31)
	super::__construct();
}
;
	return null();
}

//EnumValueMap_obj::~EnumValueMap_obj() { }

Dynamic EnumValueMap_obj::__CreateEmpty() { return  new EnumValueMap_obj; }
hx::ObjectPtr< EnumValueMap_obj > EnumValueMap_obj::__new()
{  hx::ObjectPtr< EnumValueMap_obj > result = new EnumValueMap_obj();
	result->__construct();
	return result;}

Dynamic EnumValueMap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< EnumValueMap_obj > result = new EnumValueMap_obj();
	result->__construct();
	return result;}

hx::Object *EnumValueMap_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::IMap_obj)) return operator ::IMap_obj *();
	return super::__ToInterface(inType);
}

int EnumValueMap_obj::compare( Dynamic _tmp_k1,Dynamic _tmp_k2){
	HX_STACK_FRAME("haxe.ds.EnumValueMap","compare",0x806a7d1a,"haxe.ds.EnumValueMap.compare","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/EnumValueMap.hx",33,0xb099e57c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(_tmp_k1,"_tmp_k1")
	HX_STACK_ARG(_tmp_k2,"_tmp_k2")
	HX_STACK_LINE(34)
	Dynamic k1 = _tmp_k1;		HX_STACK_VAR(k1,"k1");
	HX_STACK_LINE(34)
	Dynamic k2 = _tmp_k2;		HX_STACK_VAR(k2,"k2");
	HX_STACK_LINE(34)
	int _g = k1->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(34)
	int _g1 = k2->__Index();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(34)
	int d = (_g - _g1);		HX_STACK_VAR(d,"d");
	HX_STACK_LINE(35)
	if (((d != (int)0))){
		HX_STACK_LINE(35)
		return d;
	}
	HX_STACK_LINE(36)
	Dynamic p1 = ::Type_obj::enumParameters(k1);		HX_STACK_VAR(p1,"p1");
	HX_STACK_LINE(37)
	Dynamic p2 = ::Type_obj::enumParameters(k2);		HX_STACK_VAR(p2,"p2");
	HX_STACK_LINE(38)
	if (((bool((p1->__Field(HX_CSTRING("length"),true) == (int)0)) && bool((p2->__Field(HX_CSTRING("length"),true) == (int)0))))){
		HX_STACK_LINE(38)
		return (int)0;
	}
	HX_STACK_LINE(39)
	return this->compareArgs(p1,p2);
}


int EnumValueMap_obj::compareArgs( Dynamic a1,Dynamic a2){
	HX_STACK_FRAME("haxe.ds.EnumValueMap","compareArgs",0x37a5cb97,"haxe.ds.EnumValueMap.compareArgs","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/EnumValueMap.hx",42,0xb099e57c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a1,"a1")
	HX_STACK_ARG(a2,"a2")
	HX_STACK_LINE(43)
	int ld = (a1->__Field(HX_CSTRING("length"),true) - a2->__Field(HX_CSTRING("length"),true));		HX_STACK_VAR(ld,"ld");
	HX_STACK_LINE(44)
	if (((ld != (int)0))){
		HX_STACK_LINE(44)
		return ld;
	}
	HX_STACK_LINE(45)
	{
		HX_STACK_LINE(45)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(45)
		int _g = a1->__Field(HX_CSTRING("length"),true);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(45)
		while((true)){
			HX_STACK_LINE(45)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(45)
				break;
			}
			HX_STACK_LINE(45)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(46)
			int d = this->compareArg(a1->__GetItem(i),a2->__GetItem(i));		HX_STACK_VAR(d,"d");
			HX_STACK_LINE(47)
			if (((d != (int)0))){
				HX_STACK_LINE(47)
				return d;
			}
		}
	}
	HX_STACK_LINE(49)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC2(EnumValueMap_obj,compareArgs,return )

int EnumValueMap_obj::compareArg( Dynamic v1,Dynamic v2){
	HX_STACK_FRAME("haxe.ds.EnumValueMap","compareArg",0xcee2e55c,"haxe.ds.EnumValueMap.compareArg","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/EnumValueMap.hx",53,0xb099e57c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v1,"v1")
	HX_STACK_ARG(v2,"v2")
	HX_STACK_LINE(53)
	if (((  ((::Reflect_obj::isEnumValue(v1))) ? bool(::Reflect_obj::isEnumValue(v2)) : bool(false) ))){
		HX_STACK_LINE(54)
		return this->compare(v1,v2);
	}
	else{
		HX_STACK_LINE(55)
		if (((  ((::Std_obj::is(v1,hx::ClassOf< Array<int> >()))) ? bool(::Std_obj::is(v2,hx::ClassOf< Array<int> >())) : bool(false) ))){
			HX_STACK_LINE(56)
			return this->compareArgs(v1,v2);
		}
		else{
			HX_STACK_LINE(58)
			return ::Reflect_obj::compare(v1,v2);
		}
	}
	HX_STACK_LINE(53)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC2(EnumValueMap_obj,compareArg,return )


EnumValueMap_obj::EnumValueMap_obj()
{
}

Dynamic EnumValueMap_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"compare") ) { return compare_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"compareArg") ) { return compareArg_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"compareArgs") ) { return compareArgs_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic EnumValueMap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void EnumValueMap_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("compare"),
	HX_CSTRING("compareArgs"),
	HX_CSTRING("compareArg"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EnumValueMap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EnumValueMap_obj::__mClass,"__mClass");
};

#endif

Class EnumValueMap_obj::__mClass;

void EnumValueMap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds.EnumValueMap"), hx::TCanCast< EnumValueMap_obj> ,sStaticFields,sMemberFields,
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

void EnumValueMap_obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
