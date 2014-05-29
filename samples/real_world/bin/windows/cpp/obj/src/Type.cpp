#include <hxcpp.h>

#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_ValueType
#include <ValueType.h>
#endif

Void Type_obj::__construct()
{
	return null();
}

//Type_obj::~Type_obj() { }

Dynamic Type_obj::__CreateEmpty() { return  new Type_obj; }
hx::ObjectPtr< Type_obj > Type_obj::__new()
{  hx::ObjectPtr< Type_obj > result = new Type_obj();
	result->__construct();
	return result;}

Dynamic Type_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Type_obj > result = new Type_obj();
	result->__construct();
	return result;}

::Class Type_obj::getClass( Dynamic o){
	HX_STACK_FRAME("Type","getClass",0xc4e49bd6,"Type.getClass","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",35,0x3af91da4)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(36)
	if (((  ((!(((o == null()))))) ? bool(!(::Reflect_obj::isObject(o))) : bool(true) ))){
		HX_STACK_LINE(36)
		return null();
	}
	HX_STACK_LINE(37)
	Dynamic c = o->__GetClass();		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(38)
	{
		HX_STACK_LINE(38)
		::String _g = c->toString();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(38)
		::String _switch_1 = (_g);
		if (  ( _switch_1==HX_CSTRING("__Anon"))){
			HX_STACK_LINE(40)
			return null();
		}
		else if (  ( _switch_1==HX_CSTRING("Class"))){
			HX_STACK_LINE(41)
			return null();
		}
	}
	HX_STACK_LINE(43)
	return c;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getClass,return )

::Enum Type_obj::getEnum( Dynamic o){
	HX_STACK_FRAME("Type","getEnum",0x326d2523,"Type.getEnum","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",46,0x3af91da4)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(47)
	if (((o == null()))){
		HX_STACK_LINE(47)
		return null();
	}
	HX_STACK_LINE(48)
	return o->__GetClass();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getEnum,return )

::Class Type_obj::getSuperClass( ::Class c){
	HX_STACK_FRAME("Type","getSuperClass",0xd9ffa85f,"Type.getSuperClass","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",53,0x3af91da4)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(53)
	return c->GetSuper();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getSuperClass,return )

::String Type_obj::getClassName( ::Class c){
	HX_STACK_FRAME("Type","getClassName",0x8e66dd41,"Type.getClassName","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",56,0x3af91da4)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(57)
	if (((c == null()))){
		HX_STACK_LINE(58)
		return null();
	}
	HX_STACK_LINE(59)
	return c->mName;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getClassName,return )

::String Type_obj::getEnumName( ::Enum e){
	HX_STACK_FRAME("Type","getEnumName",0x9b42910e,"Type.getEnumName","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",63,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(63)
	return e->__ToString();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getEnumName,return )

::Class Type_obj::resolveClass( ::String name){
	HX_STACK_FRAME("Type","resolveClass",0x23b06bc0,"Type.resolveClass","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",66,0x3af91da4)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(67)
	::Class result = ::Class_obj::Resolve(name);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(68)
	if (((  (((result != null()))) ? bool(result->__IsEnum()) : bool(false) ))){
		HX_STACK_LINE(69)
		return null();
	}
	HX_STACK_LINE(70)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,resolveClass,return )

::Enum Type_obj::resolveEnum( ::String name){
	HX_STACK_FRAME("Type","resolveEnum",0x26394079,"Type.resolveEnum","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",73,0x3af91da4)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(74)
	::Class result = ::Class_obj::Resolve(name);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(75)
	if (((  (((result != null()))) ? bool(!(result->__IsEnum())) : bool(false) ))){
		HX_STACK_LINE(76)
		return null();
	}
	HX_STACK_LINE(77)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,resolveEnum,return )

Dynamic Type_obj::createInstance( ::Class cl,Dynamic args){
	HX_STACK_FRAME("Type","createInstance",0xab84f9c5,"Type.createInstance","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",80,0x3af91da4)
	HX_STACK_ARG(cl,"cl")
	HX_STACK_ARG(args,"args")
	HX_STACK_LINE(81)
	if (((cl != null()))){
		HX_STACK_LINE(82)
		return cl->ConstructArgs(args);
	}
	HX_STACK_LINE(83)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Type_obj,createInstance,return )

Dynamic Type_obj::createEmptyInstance( ::Class cl){
	HX_STACK_FRAME("Type","createEmptyInstance",0xcb752312,"Type.createEmptyInstance","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",87,0x3af91da4)
	HX_STACK_ARG(cl,"cl")
	HX_STACK_LINE(87)
	return cl->ConstructEmpty();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,createEmptyInstance,return )

Dynamic Type_obj::createEnum( ::Enum e,::String constr,Dynamic params){
	HX_STACK_FRAME("Type","createEnum",0xd8d56d31,"Type.createEnum","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",91,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_ARG(constr,"constr")
	HX_STACK_ARG(params,"params")
	HX_STACK_LINE(91)
	return e->ConstructEnum(constr,params);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Type_obj,createEnum,return )

Dynamic Type_obj::createEnumIndex( ::Enum e,int index,Dynamic params){
	HX_STACK_FRAME("Type","createEnumIndex",0xd21e2c21,"Type.createEnumIndex","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",94,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_ARG(index,"index")
	HX_STACK_ARG(params,"params")
	HX_STACK_LINE(95)
	Array< ::String > _g = ::Type_obj::getEnumConstructs(e);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(95)
	::String c = _g->__get(index);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(96)
	if (((c == null()))){
		HX_STACK_LINE(96)
		HX_STACK_DO_THROW((index + HX_CSTRING(" is not a valid enum constructor index")));
	}
	HX_STACK_LINE(97)
	return ::Type_obj::createEnum(e,c,params);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Type_obj,createEnumIndex,return )

Array< ::String > Type_obj::getInstanceFields( ::Class c){
	HX_STACK_FRAME("Type","getInstanceFields",0xe970f890,"Type.getInstanceFields","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",101,0x3af91da4)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(101)
	return c->GetInstanceFields();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getInstanceFields,return )

Array< ::String > Type_obj::getClassFields( ::Class c){
	HX_STACK_FRAME("Type","getClassFields",0x7edf22ef,"Type.getClassFields","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",105,0x3af91da4)
	HX_STACK_ARG(c,"c")
	HX_STACK_LINE(105)
	return c->GetClassFields();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getClassFields,return )

Array< ::String > Type_obj::getEnumConstructs( ::Enum e){
	HX_STACK_FRAME("Type","getEnumConstructs",0x7f46cf7f,"Type.getEnumConstructs","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",109,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(109)
	return e->GetClassFields();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,getEnumConstructs,return )

::ValueType Type_obj::_typeof( Dynamic v){
	HX_STACK_FRAME("Type","typeof",0xd6c51d65,"Type.typeof","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",112,0x3af91da4)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(113)
	if (((v == null()))){
		HX_STACK_LINE(113)
		return ::ValueType_obj::TNull;
	}
	HX_STACK_LINE(114)
	int t = v->__GetType();		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(115)
	switch( (int)(t)){
		case (int)2: {
			HX_STACK_LINE(117)
			return ::ValueType_obj::TBool;
		}
		;break;
		case (int)255: {
			HX_STACK_LINE(118)
			return ::ValueType_obj::TInt;
		}
		;break;
		case (int)1: {
			HX_STACK_LINE(119)
			return ::ValueType_obj::TFloat;
		}
		;break;
		case (int)6: {
			HX_STACK_LINE(120)
			return ::ValueType_obj::TFunction;
		}
		;break;
		case (int)4: {
			HX_STACK_LINE(121)
			return ::ValueType_obj::TObject;
		}
		;break;
		case (int)7: {
			HX_STACK_LINE(122)
			Dynamic _g = v->__GetClass();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(122)
			return ::ValueType_obj::TEnum(_g);
		}
		;break;
		default: {
			HX_STACK_LINE(124)
			Dynamic _g1 = v->__GetClass();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(124)
			return ::ValueType_obj::TClass(_g1);
		}
	}
	HX_STACK_LINE(115)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,_typeof,return )

bool Type_obj::enumEq( Dynamic a,Dynamic b){
	HX_STACK_FRAME("Type","enumEq",0x855650e1,"Type.enumEq","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",129,0x3af91da4)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(129)
	return (a == b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Type_obj,enumEq,return )

::String Type_obj::enumConstructor( Dynamic e){
	HX_STACK_FRAME("Type","enumConstructor",0x45f8fde5,"Type.enumConstructor","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",133,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(133)
	return e->__Tag();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,enumConstructor,return )

Dynamic Type_obj::enumParameters( Dynamic e){
	HX_STACK_FRAME("Type","enumParameters",0xf9e1b41f,"Type.enumParameters","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",136,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(137)
	Dynamic result = e->__EnumParams();		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(138)
	if (((result == null()))){
		HX_STACK_LINE(138)
		return Dynamic( Array_obj<Dynamic>::__new());
	}
	else{
		HX_STACK_LINE(138)
		return result;
	}
	HX_STACK_LINE(138)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,enumParameters,return )

int Type_obj::enumIndex( Dynamic e){
	HX_STACK_FRAME("Type","enumIndex",0xb61f99bd,"Type.enumIndex","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",142,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(142)
	return e->__Index();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,enumIndex,return )

Dynamic Type_obj::allEnums( ::Enum e){
	HX_STACK_FRAME("Type","allEnums",0x86200985,"Type.allEnums","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Type.hx",145,0x3af91da4)
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(146)
	Array< ::String > names = e->GetClassFields();		HX_STACK_VAR(names,"names");
	HX_STACK_LINE(147)
	Dynamic enums = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(enums,"enums");
	HX_STACK_LINE(148)
	{
		HX_STACK_LINE(148)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(148)
		while((true)){
			HX_STACK_LINE(148)
			if ((!(((_g < names->length))))){
				HX_STACK_LINE(148)
				break;
			}
			HX_STACK_LINE(148)
			::String name = names->__get(_g);		HX_STACK_VAR(name,"name");
			HX_STACK_LINE(148)
			++(_g);
			HX_STACK_LINE(150)
			try
			{
			HX_STACK_CATCHABLE(::String, 0);
			{
				HX_STACK_LINE(151)
				Dynamic result = e->mConstructEnum(name,null());		HX_STACK_VAR(result,"result");
				HX_STACK_LINE(152)
				enums->__Field(HX_CSTRING("push"),true)(result);
			}
			}
			catch(Dynamic __e){
				if (__e.IsClass< ::String >() ){
					HX_STACK_BEGIN_CATCH
					::String invalidArgCount = __e;{
					}
				}
				else {
				    HX_STACK_DO_THROW(__e);
				}
			}
		}
	}
	HX_STACK_LINE(156)
	return enums;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Type_obj,allEnums,return )


Type_obj::Type_obj()
{
}

Dynamic Type_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"typeof") ) { return _typeof_dyn(); }
		if (HX_FIELD_EQ(inName,"enumEq") ) { return enumEq_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getEnum") ) { return getEnum_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getClass") ) { return getClass_dyn(); }
		if (HX_FIELD_EQ(inName,"allEnums") ) { return allEnums_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"enumIndex") ) { return enumIndex_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"createEnum") ) { return createEnum_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getEnumName") ) { return getEnumName_dyn(); }
		if (HX_FIELD_EQ(inName,"resolveEnum") ) { return resolveEnum_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getClassName") ) { return getClassName_dyn(); }
		if (HX_FIELD_EQ(inName,"resolveClass") ) { return resolveClass_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getSuperClass") ) { return getSuperClass_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"createInstance") ) { return createInstance_dyn(); }
		if (HX_FIELD_EQ(inName,"getClassFields") ) { return getClassFields_dyn(); }
		if (HX_FIELD_EQ(inName,"enumParameters") ) { return enumParameters_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"createEnumIndex") ) { return createEnumIndex_dyn(); }
		if (HX_FIELD_EQ(inName,"enumConstructor") ) { return enumConstructor_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"getInstanceFields") ) { return getInstanceFields_dyn(); }
		if (HX_FIELD_EQ(inName,"getEnumConstructs") ) { return getEnumConstructs_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"createEmptyInstance") ) { return createEmptyInstance_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Type_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Type_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("getClass"),
	HX_CSTRING("getEnum"),
	HX_CSTRING("getSuperClass"),
	HX_CSTRING("getClassName"),
	HX_CSTRING("getEnumName"),
	HX_CSTRING("resolveClass"),
	HX_CSTRING("resolveEnum"),
	HX_CSTRING("createInstance"),
	HX_CSTRING("createEmptyInstance"),
	HX_CSTRING("createEnum"),
	HX_CSTRING("createEnumIndex"),
	HX_CSTRING("getInstanceFields"),
	HX_CSTRING("getClassFields"),
	HX_CSTRING("getEnumConstructs"),
	HX_CSTRING("typeof"),
	HX_CSTRING("enumEq"),
	HX_CSTRING("enumConstructor"),
	HX_CSTRING("enumParameters"),
	HX_CSTRING("enumIndex"),
	HX_CSTRING("allEnums"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Type_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Type_obj::__mClass,"__mClass");
};

#endif

Class Type_obj::__mClass;

void Type_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("Type"), hx::TCanCast< Type_obj> ,sStaticFields,sMemberFields,
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

void Type_obj::__boot()
{
}

