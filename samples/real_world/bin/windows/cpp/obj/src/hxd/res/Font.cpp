#include <hxcpp.h>

#ifndef INCLUDED_h2d_Font
#include <h2d/Font.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_Font
#include <hxd/res/Font.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
namespace hxd{
namespace res{

Void Font_obj::__construct(::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.Font","new",0x4db4dc89,"hxd.res.Font.new","hxd/res/Font.hx",3,0xff4fa6c5)
HX_STACK_THIS(this)
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(3)
	super::__construct(entry);
}
;
	return null();
}

//Font_obj::~Font_obj() { }

Dynamic Font_obj::__CreateEmpty() { return  new Font_obj; }
hx::ObjectPtr< Font_obj > Font_obj::__new(::hxd::res::FileEntry entry)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(entry);
	return result;}

Dynamic Font_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Font_obj > result = new Font_obj();
	result->__construct(inArgs[0]);
	return result;}

::h2d::Font Font_obj::build( int size,Dynamic options){
	HX_STACK_FRAME("hxd.res.Font","build",0xebc60397,"hxd.res.Font.build","hxd/res/Font.hx",5,0xff4fa6c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(size,"size")
	HX_STACK_ARG(options,"options")
	HX_STACK_LINE(12)
	HX_STACK_DO_THROW(HX_CSTRING("Not implemented for this platform"));
	HX_STACK_LINE(13)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Font_obj,build,return )


Font_obj::Font_obj()
{
}

Dynamic Font_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"build") ) { return build_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Font_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Font_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("build"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Font_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Font_obj::__mClass,"__mClass");
};

#endif

Class Font_obj::__mClass;

void Font_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Font"), hx::TCanCast< Font_obj> ,sStaticFields,sMemberFields,
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

void Font_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
