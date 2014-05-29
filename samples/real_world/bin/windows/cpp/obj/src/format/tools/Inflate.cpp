#include <hxcpp.h>

#ifndef INCLUDED_format_tools_Inflate
#include <format/tools/Inflate.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_zip_Uncompress
#include <haxe/zip/Uncompress.h>
#endif
namespace format{
namespace tools{

Void Inflate_obj::__construct()
{
	return null();
}

//Inflate_obj::~Inflate_obj() { }

Dynamic Inflate_obj::__CreateEmpty() { return  new Inflate_obj; }
hx::ObjectPtr< Inflate_obj > Inflate_obj::__new()
{  hx::ObjectPtr< Inflate_obj > result = new Inflate_obj();
	result->__construct();
	return result;}

Dynamic Inflate_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Inflate_obj > result = new Inflate_obj();
	result->__construct();
	return result;}

::haxe::io::Bytes Inflate_obj::run( ::haxe::io::Bytes bytes){
	HX_STACK_FRAME("format.tools.Inflate","run",0xb5ba51fa,"format.tools.Inflate.run","format/tools/Inflate.hx",35,0x3a975883)
	HX_STACK_ARG(bytes,"bytes")
	HX_STACK_LINE(35)
	return ::haxe::zip::Uncompress_obj::run(bytes,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Inflate_obj,run,return )


Inflate_obj::Inflate_obj()
{
}

Dynamic Inflate_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"run") ) { return run_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Inflate_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Inflate_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("run"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Inflate_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Inflate_obj::__mClass,"__mClass");
};

#endif

Class Inflate_obj::__mClass;

void Inflate_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.tools.Inflate"), hx::TCanCast< Inflate_obj> ,sStaticFields,sMemberFields,
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

void Inflate_obj::__boot()
{
}

} // end namespace format
} // end namespace tools
