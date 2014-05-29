#include <hxcpp.h>

#ifndef INCLUDED_flash_display_IGraphicsData
#include <flash/display/IGraphicsData.h>
#endif
namespace flash{
namespace display{

Void IGraphicsData_obj::__construct(Dynamic handle)
{
HX_STACK_FRAME("flash.display.IGraphicsData","new",0x02bfb906,"flash.display.IGraphicsData.new","flash/display/IGraphicsData.hx",12,0x8f6fd62c)
HX_STACK_THIS(this)
HX_STACK_ARG(handle,"handle")
{
	HX_STACK_LINE(12)
	this->__handle = handle;
}
;
	return null();
}

//IGraphicsData_obj::~IGraphicsData_obj() { }

Dynamic IGraphicsData_obj::__CreateEmpty() { return  new IGraphicsData_obj; }
hx::ObjectPtr< IGraphicsData_obj > IGraphicsData_obj::__new(Dynamic handle)
{  hx::ObjectPtr< IGraphicsData_obj > result = new IGraphicsData_obj();
	result->__construct(handle);
	return result;}

Dynamic IGraphicsData_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< IGraphicsData_obj > result = new IGraphicsData_obj();
	result->__construct(inArgs[0]);
	return result;}


IGraphicsData_obj::IGraphicsData_obj()
{
}

void IGraphicsData_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(IGraphicsData);
	HX_MARK_MEMBER_NAME(__handle,"__handle");
	HX_MARK_END_CLASS();
}

void IGraphicsData_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(__handle,"__handle");
}

Dynamic IGraphicsData_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"__handle") ) { return __handle; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic IGraphicsData_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"__handle") ) { __handle=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void IGraphicsData_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__handle"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(IGraphicsData_obj,__handle),HX_CSTRING("__handle")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__handle"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IGraphicsData_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IGraphicsData_obj::__mClass,"__mClass");
};

#endif

Class IGraphicsData_obj::__mClass;

void IGraphicsData_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.IGraphicsData"), hx::TCanCast< IGraphicsData_obj> ,sStaticFields,sMemberFields,
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

void IGraphicsData_obj::__boot()
{
}

} // end namespace flash
} // end namespace display
