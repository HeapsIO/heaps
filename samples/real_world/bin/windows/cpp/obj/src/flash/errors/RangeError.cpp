#include <hxcpp.h>

#ifndef INCLUDED_flash_errors_Error
#include <flash/errors/Error.h>
#endif
#ifndef INCLUDED_flash_errors_RangeError
#include <flash/errors/RangeError.h>
#endif
namespace flash{
namespace errors{

Void RangeError_obj::__construct(::String __o_message)
{
HX_STACK_FRAME("flash.errors.RangeError","new",0xefcdff82,"flash.errors.RangeError.new","flash/errors/RangeError.hx",9,0xa078a00e)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_message,"message")
::String message = __o_message.Default(HX_CSTRING(""));
{
	HX_STACK_LINE(9)
	super::__construct(message,(int)0);
}
;
	return null();
}

//RangeError_obj::~RangeError_obj() { }

Dynamic RangeError_obj::__CreateEmpty() { return  new RangeError_obj; }
hx::ObjectPtr< RangeError_obj > RangeError_obj::__new(::String __o_message)
{  hx::ObjectPtr< RangeError_obj > result = new RangeError_obj();
	result->__construct(__o_message);
	return result;}

Dynamic RangeError_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< RangeError_obj > result = new RangeError_obj();
	result->__construct(inArgs[0]);
	return result;}


RangeError_obj::RangeError_obj()
{
}

Dynamic RangeError_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic RangeError_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void RangeError_obj::__GetFields(Array< ::String> &outFields)
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
	HX_MARK_MEMBER_NAME(RangeError_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(RangeError_obj::__mClass,"__mClass");
};

#endif

Class RangeError_obj::__mClass;

void RangeError_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.errors.RangeError"), hx::TCanCast< RangeError_obj> ,sStaticFields,sMemberFields,
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

void RangeError_obj::__boot()
{
}

} // end namespace flash
} // end namespace errors
