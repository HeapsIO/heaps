#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_openfl_utils_WeakRef
#include <openfl/utils/WeakRef.h>
#endif
namespace openfl{
namespace utils{

Void WeakRef_obj::__construct(Dynamic object,hx::Null< bool >  __o_makeWeak)
{
HX_STACK_FRAME("openfl.utils.WeakRef","new",0xd43957f2,"openfl.utils.WeakRef.new","openfl/utils/WeakRef.hx",16,0xb7dba900)
HX_STACK_THIS(this)
HX_STACK_ARG(object,"object")
HX_STACK_ARG(__o_makeWeak,"makeWeak")
bool makeWeak = __o_makeWeak.Default(true);
{
	HX_STACK_LINE(16)
	if ((makeWeak)){
		HX_STACK_LINE(18)
		Dynamic _g = ::openfl::utils::WeakRef_obj::lime_weak_ref_create(hx::ObjectPtr<OBJ_>(this),object);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(18)
		this->weakRef = _g;
		HX_STACK_LINE(19)
		this->hardRef = null();
	}
	else{
		HX_STACK_LINE(23)
		this->weakRef = (int)-1;
		HX_STACK_LINE(24)
		this->hardRef = object;
	}
}
;
	return null();
}

//WeakRef_obj::~WeakRef_obj() { }

Dynamic WeakRef_obj::__CreateEmpty() { return  new WeakRef_obj; }
hx::ObjectPtr< WeakRef_obj > WeakRef_obj::__new(Dynamic object,hx::Null< bool >  __o_makeWeak)
{  hx::ObjectPtr< WeakRef_obj > result = new WeakRef_obj();
	result->__construct(object,__o_makeWeak);
	return result;}

Dynamic WeakRef_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< WeakRef_obj > result = new WeakRef_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Dynamic WeakRef_obj::get( ){
	HX_STACK_FRAME("openfl.utils.WeakRef","get",0xd4340828,"openfl.utils.WeakRef.get","openfl/utils/WeakRef.hx",31,0xb7dba900)
	HX_STACK_THIS(this)
	HX_STACK_LINE(33)
	if (((this->hardRef != null()))){
		HX_STACK_LINE(35)
		return this->hardRef;
	}
	HX_STACK_LINE(39)
	if (((this->weakRef < (int)0))){
		HX_STACK_LINE(41)
		return null();
	}
	HX_STACK_LINE(45)
	Dynamic result = ::openfl::utils::WeakRef_obj::lime_weak_ref_get(this->weakRef);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(46)
	if (((result == null()))){
		HX_STACK_LINE(48)
		this->weakRef = (int)-1;
	}
	HX_STACK_LINE(52)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC0(WeakRef_obj,get,return )

::String WeakRef_obj::toString( ){
	HX_STACK_FRAME("openfl.utils.WeakRef","toString",0xb43a97da,"openfl.utils.WeakRef.toString","openfl/utils/WeakRef.hx",57,0xb7dba900)
	HX_STACK_THIS(this)
	HX_STACK_LINE(59)
	if (((this->hardRef == null()))){
		HX_STACK_LINE(61)
		::String _g = ::Std_obj::string(this->hardRef);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(61)
		return (HX_CSTRING("") + _g);
	}
	HX_STACK_LINE(65)
	return ((HX_CSTRING("WeakRef(") + this->weakRef) + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(WeakRef_obj,toString,return )

Dynamic WeakRef_obj::lime_weak_ref_create;

Dynamic WeakRef_obj::lime_weak_ref_get;


WeakRef_obj::WeakRef_obj()
{
}

void WeakRef_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(WeakRef);
	HX_MARK_MEMBER_NAME(hardRef,"hardRef");
	HX_MARK_MEMBER_NAME(weakRef,"weakRef");
	HX_MARK_END_CLASS();
}

void WeakRef_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(hardRef,"hardRef");
	HX_VISIT_MEMBER_NAME(weakRef,"weakRef");
}

Dynamic WeakRef_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hardRef") ) { return hardRef; }
		if (HX_FIELD_EQ(inName,"weakRef") ) { return weakRef; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"lime_weak_ref_get") ) { return lime_weak_ref_get; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"lime_weak_ref_create") ) { return lime_weak_ref_create; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic WeakRef_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"hardRef") ) { hardRef=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"weakRef") ) { weakRef=inValue.Cast< int >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"lime_weak_ref_get") ) { lime_weak_ref_get=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"lime_weak_ref_create") ) { lime_weak_ref_create=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void WeakRef_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("hardRef"));
	outFields->push(HX_CSTRING("weakRef"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("lime_weak_ref_create"),
	HX_CSTRING("lime_weak_ref_get"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(WeakRef_obj,hardRef),HX_CSTRING("hardRef")},
	{hx::fsInt,(int)offsetof(WeakRef_obj,weakRef),HX_CSTRING("weakRef")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("hardRef"),
	HX_CSTRING("weakRef"),
	HX_CSTRING("get"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(WeakRef_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(WeakRef_obj::lime_weak_ref_create,"lime_weak_ref_create");
	HX_MARK_MEMBER_NAME(WeakRef_obj::lime_weak_ref_get,"lime_weak_ref_get");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(WeakRef_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(WeakRef_obj::lime_weak_ref_create,"lime_weak_ref_create");
	HX_VISIT_MEMBER_NAME(WeakRef_obj::lime_weak_ref_get,"lime_weak_ref_get");
};

#endif

Class WeakRef_obj::__mClass;

void WeakRef_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.utils.WeakRef"), hx::TCanCast< WeakRef_obj> ,sStaticFields,sMemberFields,
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

void WeakRef_obj::__boot()
{
	lime_weak_ref_create= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_weak_ref_create"),(int)2);
	lime_weak_ref_get= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_weak_ref_get"),(int)1);
}

} // end namespace openfl
} // end namespace utils
