#include <hxcpp.h>

#ifndef INCLUDED_format_tools_Deflate
#include <format/tools/Deflate.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_zip_Compress
#include <haxe/zip/Compress.h>
#endif
namespace format{
namespace tools{

Void Deflate_obj::__construct()
{
	return null();
}

//Deflate_obj::~Deflate_obj() { }

Dynamic Deflate_obj::__CreateEmpty() { return  new Deflate_obj; }
hx::ObjectPtr< Deflate_obj > Deflate_obj::__new()
{  hx::ObjectPtr< Deflate_obj > result = new Deflate_obj();
	result->__construct();
	return result;}

Dynamic Deflate_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Deflate_obj > result = new Deflate_obj();
	result->__construct();
	return result;}

::haxe::io::Bytes Deflate_obj::run( ::haxe::io::Bytes b){
	HX_STACK_FRAME("format.tools.Deflate","run",0x6ec402de,"format.tools.Deflate.run","format/tools/Deflate.hx",40,0x0ea6501f)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(40)
	return ::haxe::zip::Compress_obj::run(b,(int)9);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Deflate_obj,run,return )


Deflate_obj::Deflate_obj()
{
}

Dynamic Deflate_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"run") ) { return run_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Deflate_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Deflate_obj::__GetFields(Array< ::String> &outFields)
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
	HX_MARK_MEMBER_NAME(Deflate_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Deflate_obj::__mClass,"__mClass");
};

#endif

Class Deflate_obj::__mClass;

void Deflate_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.tools.Deflate"), hx::TCanCast< Deflate_obj> ,sStaticFields,sMemberFields,
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

void Deflate_obj::__boot()
{
}

} // end namespace format
} // end namespace tools
