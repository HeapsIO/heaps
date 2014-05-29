#include <hxcpp.h>

#ifndef INCLUDED_haxe__EnumFlags_EnumFlags_Impl_
#include <haxe/_EnumFlags/EnumFlags_Impl_.h>
#endif
namespace haxe{
namespace _EnumFlags{

Void EnumFlags_Impl__obj::__construct()
{
	return null();
}

//EnumFlags_Impl__obj::~EnumFlags_Impl__obj() { }

Dynamic EnumFlags_Impl__obj::__CreateEmpty() { return  new EnumFlags_Impl__obj; }
hx::ObjectPtr< EnumFlags_Impl__obj > EnumFlags_Impl__obj::__new()
{  hx::ObjectPtr< EnumFlags_Impl__obj > result = new EnumFlags_Impl__obj();
	result->__construct();
	return result;}

Dynamic EnumFlags_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< EnumFlags_Impl__obj > result = new EnumFlags_Impl__obj();
	result->__construct();
	return result;}

int EnumFlags_Impl__obj::_new( hx::Null< int >  __o_i){
int i = __o_i.Default(0);
	HX_STACK_FRAME("haxe._EnumFlags.EnumFlags_Impl_","_new",0xab4ad0a8,"haxe._EnumFlags.EnumFlags_Impl_._new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/EnumFlags.hx",40,0x039cdf82)
	HX_STACK_ARG(i,"i")
{
		HX_STACK_LINE(40)
		return i;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(EnumFlags_Impl__obj,_new,return )

bool EnumFlags_Impl__obj::has( int this1,Dynamic v){
	HX_STACK_FRAME("haxe._EnumFlags.EnumFlags_Impl_","has",0xcbfcc9f3,"haxe._EnumFlags.EnumFlags_Impl_.has","D:\\Workspace\\motionTools\\haxe3\\std/haxe/EnumFlags.hx",51,0x039cdf82)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(52)
	int _g = v->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(52)
	int _g1 = (int((int)1) << int(_g));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(52)
	int _g2 = (int(this1) & int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(52)
	return (_g2 != (int)0);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(EnumFlags_Impl__obj,has,return )

Void EnumFlags_Impl__obj::set( int this1,Dynamic v){
{
		HX_STACK_FRAME("haxe._EnumFlags.EnumFlags_Impl_","set",0xcc05263b,"haxe._EnumFlags.EnumFlags_Impl_.set","D:\\Workspace\\motionTools\\haxe3\\std/haxe/EnumFlags.hx",63,0x039cdf82)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(64)
		int _g = v->__Index();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(64)
		int _g1 = (int((int)1) << int(_g));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(64)
		hx::OrEq(this1,_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(EnumFlags_Impl__obj,set,(void))

Void EnumFlags_Impl__obj::unset( int this1,Dynamic v){
{
		HX_STACK_FRAME("haxe._EnumFlags.EnumFlags_Impl_","unset",0xe10715c2,"haxe._EnumFlags.EnumFlags_Impl_.unset","D:\\Workspace\\motionTools\\haxe3\\std/haxe/EnumFlags.hx",75,0x039cdf82)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(76)
		int _g = v->__Index();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(76)
		int _g1 = (int((int)1) << int(_g));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(76)
		int _g2 = ((int)268435455 - _g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(76)
		hx::AndEq(this1,_g2);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(EnumFlags_Impl__obj,unset,(void))

int EnumFlags_Impl__obj::ofInt( int i){
	HX_STACK_FRAME("haxe._EnumFlags.EnumFlags_Impl_","ofInt",0x67360ef1,"haxe._EnumFlags.EnumFlags_Impl_.ofInt","D:\\Workspace\\motionTools\\haxe3\\std/haxe/EnumFlags.hx",84,0x039cdf82)
	HX_STACK_ARG(i,"i")
	HX_STACK_LINE(84)
	return i;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(EnumFlags_Impl__obj,ofInt,return )

int EnumFlags_Impl__obj::toInt( int this1){
	HX_STACK_FRAME("haxe._EnumFlags.EnumFlags_Impl_","toInt",0x4e29e10d,"haxe._EnumFlags.EnumFlags_Impl_.toInt","D:\\Workspace\\motionTools\\haxe3\\std/haxe/EnumFlags.hx",92,0x039cdf82)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(92)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(EnumFlags_Impl__obj,toInt,return )


EnumFlags_Impl__obj::EnumFlags_Impl__obj()
{
}

Dynamic EnumFlags_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"has") ) { return has_dyn(); }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"unset") ) { return unset_dyn(); }
		if (HX_FIELD_EQ(inName,"ofInt") ) { return ofInt_dyn(); }
		if (HX_FIELD_EQ(inName,"toInt") ) { return toInt_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic EnumFlags_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void EnumFlags_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("has"),
	HX_CSTRING("set"),
	HX_CSTRING("unset"),
	HX_CSTRING("ofInt"),
	HX_CSTRING("toInt"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(EnumFlags_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(EnumFlags_Impl__obj::__mClass,"__mClass");
};

#endif

Class EnumFlags_Impl__obj::__mClass;

void EnumFlags_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe._EnumFlags.EnumFlags_Impl_"), hx::TCanCast< EnumFlags_Impl__obj> ,sStaticFields,sMemberFields,
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

void EnumFlags_Impl__obj::__boot()
{
}

} // end namespace haxe
} // end namespace _EnumFlags
