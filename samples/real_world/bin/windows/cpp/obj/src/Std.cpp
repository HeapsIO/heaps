#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif

Void Std_obj::__construct()
{
	return null();
}

//Std_obj::~Std_obj() { }

Dynamic Std_obj::__CreateEmpty() { return  new Std_obj; }
hx::ObjectPtr< Std_obj > Std_obj::__new()
{  hx::ObjectPtr< Std_obj > result = new Std_obj();
	result->__construct();
	return result;}

Dynamic Std_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Std_obj > result = new Std_obj();
	result->__construct();
	return result;}

bool Std_obj::is( Dynamic v,Dynamic t){
	HX_STACK_FRAME("Std","is",0x3c56d6f5,"Std.is","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Std.hx",24,0x1389509b)
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(24)
	return ::__instanceof(v,t);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Std_obj,is,return )

Dynamic Std_obj::instance( Dynamic value,::Class c){
	HX_STACK_FRAME("Std","instance",0x1431f4e0,"Std.instance","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Std.hx",28,0x1389509b)
	HX_STACK_ARG(value,"value")
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(28)
	if ((::Std_obj::is(value,c))){
		HX_STACK_LINE(28)
		return value;
	}
	else{
		HX_STACK_LINE(28)
		return null();
	}
	HX_STACK_LINE(28)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Std_obj,instance,return )

::String Std_obj::string( Dynamic s){
	HX_STACK_FRAME("Std","string",0xcf48855c,"Std.string","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Std.hx",32,0x1389509b)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(32)
	if (((s == null()))){
		HX_STACK_LINE(32)
		return HX_CSTRING("null");
	}
	else{
		HX_STACK_LINE(32)
		return s->toString();
	}
	HX_STACK_LINE(32)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Std_obj,string,return )

int Std_obj::_int( Float x){
	HX_STACK_FRAME("Std","int",0x8fa53b84,"Std.int","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Std.hx",36,0x1389509b)
	HX_STACK_ARG(x,"x")
	HX_STACK_LINE(36)
	return ::__int__(x);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Std_obj,_int,return )

Dynamic Std_obj::parseInt( ::String x){
	HX_STACK_FRAME("Std","parseInt",0x90c2ebc7,"Std.parseInt","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Std.hx",40,0x1389509b)
	HX_STACK_ARG(x,"x")
	HX_STACK_LINE(40)
	return ::__hxcpp_parse_int(x);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Std_obj,parseInt,return )

Float Std_obj::parseFloat( ::String x){
	HX_STACK_FRAME("Std","parseFloat",0xbca10a74,"Std.parseFloat","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Std.hx",44,0x1389509b)
	HX_STACK_ARG(x,"x")
	HX_STACK_LINE(44)
	return ::__hxcpp_parse_float(x);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Std_obj,parseFloat,return )

int Std_obj::random( int x){
	HX_STACK_FRAME("Std","random",0x75a77e8e,"Std.random","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Std.hx",47,0x1389509b)
	HX_STACK_ARG(x,"x")
	HX_STACK_LINE(48)
	if (((x <= (int)0))){
		HX_STACK_LINE(48)
		return (int)0;
	}
	HX_STACK_LINE(49)
	return ::__hxcpp_irand(x);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Std_obj,random,return )


Std_obj::Std_obj()
{
}

Dynamic Std_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"is") ) { return is_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"int") ) { return _int_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"string") ) { return string_dyn(); }
		if (HX_FIELD_EQ(inName,"random") ) { return random_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"instance") ) { return instance_dyn(); }
		if (HX_FIELD_EQ(inName,"parseInt") ) { return parseInt_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"parseFloat") ) { return parseFloat_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Std_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Std_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("is"),
	HX_CSTRING("instance"),
	HX_CSTRING("string"),
	HX_CSTRING("int"),
	HX_CSTRING("parseInt"),
	HX_CSTRING("parseFloat"),
	HX_CSTRING("random"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Std_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Std_obj::__mClass,"__mClass");
};

#endif

Class Std_obj::__mClass;

void Std_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("Std"), hx::TCanCast< Std_obj> ,sStaticFields,sMemberFields,
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

void Std_obj::__boot()
{
}

