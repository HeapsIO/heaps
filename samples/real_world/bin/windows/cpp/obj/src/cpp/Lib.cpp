#include <hxcpp.h>

#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
namespace cpp{

Void Lib_obj::__construct()
{
	return null();
}

//Lib_obj::~Lib_obj() { }

Dynamic Lib_obj::__CreateEmpty() { return  new Lib_obj; }
hx::ObjectPtr< Lib_obj > Lib_obj::__new()
{  hx::ObjectPtr< Lib_obj > result = new Lib_obj();
	result->__construct();
	return result;}

Dynamic Lib_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Lib_obj > result = new Lib_obj();
	result->__construct();
	return result;}

Dynamic Lib_obj::load( ::String lib,::String prim,int nargs){
	HX_STACK_FRAME("cpp.Lib","load",0xd2b2dcba,"cpp.Lib.load","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",33,0x54074ea4)
	HX_STACK_ARG(lib,"lib")
	HX_STACK_ARG(prim,"prim")
	HX_STACK_ARG(nargs,"nargs")
	HX_STACK_LINE(33)
	return ::__loadprim(lib,prim,nargs);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Lib_obj,load,return )

Dynamic Lib_obj::loadLazy( ::String lib,::String prim,int nargs){
	HX_STACK_FRAME("cpp.Lib","loadLazy",0x865efe4e,"cpp.Lib.loadLazy","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",48,0x54074ea4)
	HX_STACK_ARG(lib,"lib")
	HX_STACK_ARG(prim,"prim")
	HX_STACK_ARG(nargs,"nargs")
	HX_STACK_LINE(49)
	try
	{
	HX_STACK_CATCHABLE(Dynamic, 0);
	{
		HX_STACK_LINE(50)
		return ::__loadprim(lib,prim,nargs);
	}
	}
	catch(Dynamic __e){
		{
			HX_STACK_BEGIN_CATCH
			Dynamic e = __e;{
				HX_STACK_LINE(52)
				Dynamic e1 = Dynamic( Array_obj<Dynamic>::__new().Add(e));		HX_STACK_VAR(e1,"e1");
				HX_STACK_LINE(52)
				switch( (int)(nargs)){
					case (int)0: {

						HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Dynamic,e1)
						Void run(){
							HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",53,0x54074ea4)
							{
								HX_STACK_LINE(53)
								HX_STACK_DO_THROW(e1->__GetItem((int)0));
							}
							return null();
						}
						HX_END_LOCAL_FUNC0((void))

						HX_STACK_LINE(53)
						return  Dynamic(new _Function_3_1(e1));
					}
					;break;
					case (int)2: {

						HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Dynamic,e1)
						Void run(Dynamic _1,Dynamic _2){
							HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",54,0x54074ea4)
							HX_STACK_ARG(_1,"_1")
							HX_STACK_ARG(_2,"_2")
							{
								HX_STACK_LINE(54)
								HX_STACK_DO_THROW(e1->__GetItem((int)0));
							}
							return null();
						}
						HX_END_LOCAL_FUNC2((void))

						HX_STACK_LINE(54)
						return  Dynamic(new _Function_3_1(e1));
					}
					;break;
					case (int)3: {

						HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Dynamic,e1)
						Void run(Dynamic _1,Dynamic _2,Dynamic _3){
							HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",55,0x54074ea4)
							HX_STACK_ARG(_1,"_1")
							HX_STACK_ARG(_2,"_2")
							HX_STACK_ARG(_3,"_3")
							{
								HX_STACK_LINE(55)
								HX_STACK_DO_THROW(e1->__GetItem((int)0));
							}
							return null();
						}
						HX_END_LOCAL_FUNC3((void))

						HX_STACK_LINE(55)
						return  Dynamic(new _Function_3_1(e1));
					}
					;break;
					case (int)4: {

						HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Dynamic,e1)
						Void run(Dynamic _1,Dynamic _2,Dynamic _3,Dynamic _4){
							HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",56,0x54074ea4)
							HX_STACK_ARG(_1,"_1")
							HX_STACK_ARG(_2,"_2")
							HX_STACK_ARG(_3,"_3")
							HX_STACK_ARG(_4,"_4")
							{
								HX_STACK_LINE(56)
								HX_STACK_DO_THROW(e1->__GetItem((int)0));
							}
							return null();
						}
						HX_END_LOCAL_FUNC4((void))

						HX_STACK_LINE(56)
						return  Dynamic(new _Function_3_1(e1));
					}
					;break;
					case (int)5: {

						HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Dynamic,e1)
						Void run(Dynamic _1,Dynamic _2,Dynamic _3,Dynamic _4,Dynamic _5){
							HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",57,0x54074ea4)
							HX_STACK_ARG(_1,"_1")
							HX_STACK_ARG(_2,"_2")
							HX_STACK_ARG(_3,"_3")
							HX_STACK_ARG(_4,"_4")
							HX_STACK_ARG(_5,"_5")
							{
								HX_STACK_LINE(57)
								HX_STACK_DO_THROW(e1->__GetItem((int)0));
							}
							return null();
						}
						HX_END_LOCAL_FUNC5((void))

						HX_STACK_LINE(57)
						return  Dynamic(new _Function_3_1(e1));
					}
					;break;
					default: {

						HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_3_1,Dynamic,e1)
						Void run(Dynamic _1){
							HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",58,0x54074ea4)
							HX_STACK_ARG(_1,"_1")
							{
								HX_STACK_LINE(58)
								HX_STACK_DO_THROW(e1->__GetItem((int)0));
							}
							return null();
						}
						HX_END_LOCAL_FUNC1((void))

						HX_STACK_LINE(58)
						return  Dynamic(new _Function_3_1(e1));
					}
				}
			}
		}
	}
	HX_STACK_LINE(61)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Lib_obj,loadLazy,return )

Void Lib_obj::rethrow( Dynamic inExp){
{
		HX_STACK_FRAME("cpp.Lib","rethrow",0x3bf8427f,"cpp.Lib.rethrow","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",64,0x54074ea4)
		HX_STACK_ARG(inExp,"inExp")
		HX_STACK_LINE(64)
		HX_STACK_DO_THROW(inExp);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lib_obj,rethrow,(void))

Void Lib_obj::stringReference( Dynamic inExp){
{
		HX_STACK_FRAME("cpp.Lib","stringReference",0x72c1faa6,"cpp.Lib.stringReference","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",66,0x54074ea4)
		HX_STACK_ARG(inExp,"inExp")
		HX_STACK_LINE(66)
		HX_STACK_DO_THROW(inExp);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lib_obj,stringReference,(void))

Void Lib_obj::print( Dynamic v){
{
		HX_STACK_FRAME("cpp.Lib","print",0xd96a5719,"cpp.Lib.print","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",72,0x54074ea4)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(72)
		::__hxcpp_print(v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lib_obj,print,(void))

Dynamic Lib_obj::haxeToNeko( Dynamic v){
	HX_STACK_FRAME("cpp.Lib","haxeToNeko",0x02e89710,"cpp.Lib.haxeToNeko","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",80,0x54074ea4)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(80)
	return v;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lib_obj,haxeToNeko,return )

Dynamic Lib_obj::nekoToHaxe( Dynamic v){
	HX_STACK_FRAME("cpp.Lib","nekoToHaxe",0x84b99cd0,"cpp.Lib.nekoToHaxe","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",88,0x54074ea4)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(88)
	return v;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lib_obj,nekoToHaxe,return )

Void Lib_obj::println( Dynamic v){
{
		HX_STACK_FRAME("cpp.Lib","println",0xca016ddb,"cpp.Lib.println","D:\\Workspace\\motionTools\\haxe3\\std/cpp/Lib.hx",94,0x54074ea4)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(94)
		::__hxcpp_println(v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lib_obj,println,(void))


Lib_obj::Lib_obj()
{
}

Dynamic Lib_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"print") ) { return print_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"rethrow") ) { return rethrow_dyn(); }
		if (HX_FIELD_EQ(inName,"println") ) { return println_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"loadLazy") ) { return loadLazy_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"haxeToNeko") ) { return haxeToNeko_dyn(); }
		if (HX_FIELD_EQ(inName,"nekoToHaxe") ) { return nekoToHaxe_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"stringReference") ) { return stringReference_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Lib_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Lib_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("load"),
	HX_CSTRING("loadLazy"),
	HX_CSTRING("rethrow"),
	HX_CSTRING("stringReference"),
	HX_CSTRING("print"),
	HX_CSTRING("haxeToNeko"),
	HX_CSTRING("nekoToHaxe"),
	HX_CSTRING("println"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Lib_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Lib_obj::__mClass,"__mClass");
};

#endif

Class Lib_obj::__mClass;

void Lib_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("cpp.Lib"), hx::TCanCast< Lib_obj> ,sStaticFields,sMemberFields,
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

void Lib_obj::__boot()
{
}

} // end namespace cpp
