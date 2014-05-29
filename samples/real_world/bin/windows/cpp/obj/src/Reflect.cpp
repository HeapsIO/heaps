#include <hxcpp.h>

#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif

Void Reflect_obj::__construct()
{
	return null();
}

//Reflect_obj::~Reflect_obj() { }

Dynamic Reflect_obj::__CreateEmpty() { return  new Reflect_obj; }
hx::ObjectPtr< Reflect_obj > Reflect_obj::__new()
{  hx::ObjectPtr< Reflect_obj > result = new Reflect_obj();
	result->__construct();
	return result;}

Dynamic Reflect_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Reflect_obj > result = new Reflect_obj();
	result->__construct();
	return result;}

bool Reflect_obj::hasField( Dynamic o,::String field){
	HX_STACK_FRAME("Reflect","hasField",0xef8c2571,"Reflect.hasField","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",25,0xc4090141)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(field,"field")
	HX_STACK_LINE(25)
	if (((o != null()))){
		HX_STACK_LINE(25)
		return o->__HasField(field);
	}
	else{
		HX_STACK_LINE(25)
		return false;
	}
	HX_STACK_LINE(25)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Reflect_obj,hasField,return )

Dynamic Reflect_obj::field( Dynamic o,::String field){
	HX_STACK_FRAME("Reflect","field",0x54b04da9,"Reflect.field","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",29,0xc4090141)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(field,"field")
	HX_STACK_LINE(29)
	if (((o == null()))){
		HX_STACK_LINE(29)
		return null();
	}
	else{
		HX_STACK_LINE(29)
		return o->__Field(field,false);
	}
	HX_STACK_LINE(29)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Reflect_obj,field,return )

Void Reflect_obj::setField( Dynamic o,::String field,Dynamic value){
{
		HX_STACK_FRAME("Reflect","setField",0x71684429,"Reflect.setField","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",33,0xc4090141)
		HX_STACK_ARG(o,"o")
		HX_STACK_ARG(field,"field")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(33)
		if (((o != null()))){
			HX_STACK_LINE(34)
			o->__SetField(field,value,false);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Reflect_obj,setField,(void))

Dynamic Reflect_obj::getProperty( Dynamic o,::String field){
	HX_STACK_FRAME("Reflect","getProperty",0x632ca13a,"Reflect.getProperty","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",38,0xc4090141)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(field,"field")
	HX_STACK_LINE(38)
	if (((o == null()))){
		HX_STACK_LINE(38)
		return null();
	}
	else{
		HX_STACK_LINE(38)
		return o->__Field(field,true);
	}
	HX_STACK_LINE(38)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Reflect_obj,getProperty,return )

Void Reflect_obj::setProperty( Dynamic o,::String field,Dynamic value){
{
		HX_STACK_FRAME("Reflect","setProperty",0x6d99a846,"Reflect.setProperty","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",42,0xc4090141)
		HX_STACK_ARG(o,"o")
		HX_STACK_ARG(field,"field")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(42)
		if (((o != null()))){
			HX_STACK_LINE(43)
			o->__SetField(field,value,true);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Reflect_obj,setProperty,(void))

Dynamic Reflect_obj::callMethod( Dynamic o,Dynamic func,Dynamic args){
	HX_STACK_FRAME("Reflect","callMethod",0xb49e52d0,"Reflect.callMethod","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",46,0xc4090141)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(func,"func")
	HX_STACK_ARG(args,"args")
	struct _Function_1_1{
		inline static bool Block( Dynamic &func){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",47,0xc4090141)
			{
				HX_STACK_LINE(47)
				Dynamic _g = func->__GetType();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(47)
				return (_g == ::vtString);
			}
			return null();
		}
	};
	HX_STACK_LINE(47)
	if (((  (((func != null()))) ? bool(_Function_1_1::Block(func)) : bool(false) ))){
		HX_STACK_LINE(48)
		Dynamic _g1 = o->__Field(func,true);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(48)
		func = _g1;
	}
	HX_STACK_LINE(49)
	func->__SetThis(o);
	HX_STACK_LINE(50)
	return func->__Run(args);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Reflect_obj,callMethod,return )

Array< ::String > Reflect_obj::fields( Dynamic o){
	HX_STACK_FRAME("Reflect","fields",0xc593a6aa,"Reflect.fields","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",53,0xc4090141)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(54)
	if (((o == null()))){
		HX_STACK_LINE(54)
		return Array_obj< ::String >::__new();
	}
	HX_STACK_LINE(55)
	Array< ::String > a = Array_obj< ::String >::__new();		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(56)
	o->__GetFields(a);
	HX_STACK_LINE(57)
	return a;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Reflect_obj,fields,return )

bool Reflect_obj::isFunction( Dynamic f){
	HX_STACK_FRAME("Reflect","isFunction",0x0f1541d3,"Reflect.isFunction","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",61,0xc4090141)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(61)
	if (((f != null()))){
		HX_STACK_LINE(61)
		Dynamic _g = f->__GetType();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(61)
		return (_g == ::vtFunction);
	}
	else{
		HX_STACK_LINE(61)
		return false;
	}
	HX_STACK_LINE(61)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Reflect_obj,isFunction,return )

int Reflect_obj::compare( Dynamic a,Dynamic b){
	HX_STACK_FRAME("Reflect","compare",0xa2d92b54,"Reflect.compare","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",65,0xc4090141)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(65)
	if (((a == b))){
		HX_STACK_LINE(65)
		return (int)0;
	}
	else{
		HX_STACK_LINE(65)
		if (((a > b))){
			HX_STACK_LINE(65)
			return (int)1;
		}
		else{
			HX_STACK_LINE(65)
			return (int)-1;
		}
	}
	HX_STACK_LINE(65)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Reflect_obj,compare,return )

bool Reflect_obj::compareMethods( Dynamic f1,Dynamic f2){
	HX_STACK_FRAME("Reflect","compareMethods",0x8b8ddd7e,"Reflect.compareMethods","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",68,0xc4090141)
	HX_STACK_ARG(f1,"f1")
	HX_STACK_ARG(f2,"f2")
	HX_STACK_LINE(69)
	if (((f1 == f2))){
		HX_STACK_LINE(70)
		return true;
	}
	HX_STACK_LINE(71)
	if (((  ((!((!(::Reflect_obj::isFunction(f1)))))) ? bool(!(::Reflect_obj::isFunction(f2))) : bool(true) ))){
		HX_STACK_LINE(72)
		return false;
	}
	HX_STACK_LINE(73)
	return ::__hxcpp_same_closure(f1,f2);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Reflect_obj,compareMethods,return )

bool Reflect_obj::isObject( Dynamic v){
	HX_STACK_FRAME("Reflect","isObject",0xd04960ba,"Reflect.isObject","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",76,0xc4090141)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(77)
	if (((v == null()))){
		HX_STACK_LINE(77)
		return false;
	}
	HX_STACK_LINE(78)
	int t = v->__GetType();		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(79)
	return (bool((bool((bool((t == ::vtObject)) || bool((t == ::vtClass)))) || bool((t == ::vtString)))) || bool((t == ::vtArray)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Reflect_obj,isObject,return )

bool Reflect_obj::isEnumValue( Dynamic v){
	HX_STACK_FRAME("Reflect","isEnumValue",0x97884d95,"Reflect.isEnumValue","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",84,0xc4090141)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(84)
	if (((v != null()))){
		HX_STACK_LINE(84)
		Dynamic _g = v->__GetType();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(84)
		return (_g == ::vtEnum);
	}
	else{
		HX_STACK_LINE(84)
		return false;
	}
	HX_STACK_LINE(84)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Reflect_obj,isEnumValue,return )

bool Reflect_obj::deleteField( Dynamic o,::String field){
	HX_STACK_FRAME("Reflect","deleteField",0x21895ebe,"Reflect.deleteField","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",87,0xc4090141)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(field,"field")
	HX_STACK_LINE(88)
	if (((o == null()))){
		HX_STACK_LINE(88)
		return false;
	}
	HX_STACK_LINE(89)
	return ::__hxcpp_anon_remove(o,field);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Reflect_obj,deleteField,return )

Dynamic Reflect_obj::copy( Dynamic o){
	HX_STACK_FRAME("Reflect","copy",0x47e2b5a6,"Reflect.copy","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",92,0xc4090141)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(93)
	if (((o == null()))){
		HX_STACK_LINE(93)
		return null();
	}
	HX_STACK_LINE(94)
	Dynamic _g = o->__GetType();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(94)
	if (((_g == ::vtString))){
		HX_STACK_LINE(94)
		return o;
	}
	HX_STACK_LINE(95)
	Dynamic _g1 = o->__GetType();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(95)
	if (((_g1 == ::vtArray))){
		HX_STACK_LINE(96)
		return o->__Field(HX_CSTRING("copy"),true)();
	}
	struct _Function_1_1{
		inline static Dynamic Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",97,0xc4090141)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(97)
	Dynamic o2 = _Function_1_1::Block();		HX_STACK_VAR(o2,"o2");
	HX_STACK_LINE(98)
	{
		HX_STACK_LINE(98)
		int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(98)
		Array< ::String > _g11 = ::Reflect_obj::fields(o);		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(98)
		while((true)){
			HX_STACK_LINE(98)
			if ((!(((_g2 < _g11->length))))){
				HX_STACK_LINE(98)
				break;
			}
			HX_STACK_LINE(98)
			::String f = _g11->__get(_g2);		HX_STACK_VAR(f,"f");
			HX_STACK_LINE(98)
			++(_g2);
			HX_STACK_LINE(99)
			Dynamic value = ::Reflect_obj::field(o,f);		HX_STACK_VAR(value,"value");
			HX_STACK_LINE(99)
			if (((o2 != null()))){
				HX_STACK_LINE(99)
				o2->__SetField(f,value,false);
			}
		}
	}
	HX_STACK_LINE(100)
	return o2;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Reflect_obj,copy,return )

Dynamic Reflect_obj::makeVarArgs( Dynamic f){
	HX_STACK_FRAME("Reflect","makeVarArgs",0x978955c5,"Reflect.makeVarArgs","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Reflect.hx",105,0xc4090141)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(105)
	return ::__hxcpp_create_var_args(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Reflect_obj,makeVarArgs,return )


Reflect_obj::Reflect_obj()
{
}

Dynamic Reflect_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"copy") ) { return copy_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"field") ) { return field_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"fields") ) { return fields_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"compare") ) { return compare_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"hasField") ) { return hasField_dyn(); }
		if (HX_FIELD_EQ(inName,"setField") ) { return setField_dyn(); }
		if (HX_FIELD_EQ(inName,"isObject") ) { return isObject_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"callMethod") ) { return callMethod_dyn(); }
		if (HX_FIELD_EQ(inName,"isFunction") ) { return isFunction_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getProperty") ) { return getProperty_dyn(); }
		if (HX_FIELD_EQ(inName,"setProperty") ) { return setProperty_dyn(); }
		if (HX_FIELD_EQ(inName,"isEnumValue") ) { return isEnumValue_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteField") ) { return deleteField_dyn(); }
		if (HX_FIELD_EQ(inName,"makeVarArgs") ) { return makeVarArgs_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"compareMethods") ) { return compareMethods_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Reflect_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Reflect_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("hasField"),
	HX_CSTRING("field"),
	HX_CSTRING("setField"),
	HX_CSTRING("getProperty"),
	HX_CSTRING("setProperty"),
	HX_CSTRING("callMethod"),
	HX_CSTRING("fields"),
	HX_CSTRING("isFunction"),
	HX_CSTRING("compare"),
	HX_CSTRING("compareMethods"),
	HX_CSTRING("isObject"),
	HX_CSTRING("isEnumValue"),
	HX_CSTRING("deleteField"),
	HX_CSTRING("copy"),
	HX_CSTRING("makeVarArgs"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Reflect_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Reflect_obj::__mClass,"__mClass");
};

#endif

Class Reflect_obj::__mClass;

void Reflect_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("Reflect"), hx::TCanCast< Reflect_obj> ,sStaticFields,sMemberFields,
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

void Reflect_obj::__boot()
{
}

