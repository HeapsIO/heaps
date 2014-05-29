#include <hxcpp.h>

#ifndef INCLUDED_flash_errors_ArgumentError
#include <flash/errors/ArgumentError.h>
#endif
#ifndef INCLUDED_flash_errors_Error
#include <flash/errors/Error.h>
#endif
namespace flash{
namespace errors{

Void ArgumentError_obj::__construct(Dynamic message,Dynamic id)
{
HX_STACK_FRAME("flash.errors.ArgumentError","new",0x320d6f58,"flash.errors.ArgumentError.new","flash/errors/ArgumentError.hx",4,0x8eb27538)
HX_STACK_THIS(this)
HX_STACK_ARG(message,"message")
HX_STACK_ARG(id,"id")
{
	HX_STACK_LINE(4)
	super::__construct(message,id);
}
;
	return null();
}

//ArgumentError_obj::~ArgumentError_obj() { }

Dynamic ArgumentError_obj::__CreateEmpty() { return  new ArgumentError_obj; }
hx::ObjectPtr< ArgumentError_obj > ArgumentError_obj::__new(Dynamic message,Dynamic id)
{  hx::ObjectPtr< ArgumentError_obj > result = new ArgumentError_obj();
	result->__construct(message,id);
	return result;}

Dynamic ArgumentError_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ArgumentError_obj > result = new ArgumentError_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


ArgumentError_obj::ArgumentError_obj()
{
}

Dynamic ArgumentError_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic ArgumentError_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void ArgumentError_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ArgumentError_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ArgumentError_obj::__mClass,"__mClass");
};

#endif

Class ArgumentError_obj::__mClass;

void ArgumentError_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.errors.ArgumentError"), hx::TCanCast< ArgumentError_obj> ,sStaticFields,sMemberFields,
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

void ArgumentError_obj::__boot()
{
}

} // end namespace flash
} // end namespace errors
