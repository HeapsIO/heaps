#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Eof
#include <haxe/io/Eof.h>
#endif
namespace haxe{
namespace io{

Void Eof_obj::__construct()
{
HX_STACK_FRAME("haxe.io.Eof","new",0x2166e64e,"haxe.io.Eof.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Eof.hx",28,0x65aa9e41)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//Eof_obj::~Eof_obj() { }

Dynamic Eof_obj::__CreateEmpty() { return  new Eof_obj; }
hx::ObjectPtr< Eof_obj > Eof_obj::__new()
{  hx::ObjectPtr< Eof_obj > result = new Eof_obj();
	result->__construct();
	return result;}

Dynamic Eof_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Eof_obj > result = new Eof_obj();
	result->__construct();
	return result;}

::String Eof_obj::toString( ){
	HX_STACK_FRAME("haxe.io.Eof","toString",0xf9ff7bfe,"haxe.io.Eof.toString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Eof.hx",31,0x65aa9e41)
	HX_STACK_THIS(this)
	HX_STACK_LINE(31)
	return HX_CSTRING("Eof");
}


HX_DEFINE_DYNAMIC_FUNC0(Eof_obj,toString,return )


Eof_obj::Eof_obj()
{
}

Dynamic Eof_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Eof_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Eof_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Eof_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Eof_obj::__mClass,"__mClass");
};

#endif

Class Eof_obj::__mClass;

void Eof_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.Eof"), hx::TCanCast< Eof_obj> ,sStaticFields,sMemberFields,
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

void Eof_obj::__boot()
{
}

} // end namespace haxe
} // end namespace io
