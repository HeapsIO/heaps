#include <hxcpp.h>

#ifndef INCLUDED_flash_net_URLRequestHeader
#include <flash/net/URLRequestHeader.h>
#endif
namespace flash{
namespace net{

Void URLRequestHeader_obj::__construct(::String name,::String value)
{
HX_STACK_FRAME("flash.net.URLRequestHeader","new",0xa6daef0e,"flash.net.URLRequestHeader.new","flash/net/URLRequestHeader.hx",11,0xd1f1b0e0)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
HX_STACK_ARG(value,"value")
{
	HX_STACK_LINE(13)
	this->name = name;
	HX_STACK_LINE(14)
	this->value = value;
}
;
	return null();
}

//URLRequestHeader_obj::~URLRequestHeader_obj() { }

Dynamic URLRequestHeader_obj::__CreateEmpty() { return  new URLRequestHeader_obj; }
hx::ObjectPtr< URLRequestHeader_obj > URLRequestHeader_obj::__new(::String name,::String value)
{  hx::ObjectPtr< URLRequestHeader_obj > result = new URLRequestHeader_obj();
	result->__construct(name,value);
	return result;}

Dynamic URLRequestHeader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< URLRequestHeader_obj > result = new URLRequestHeader_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}


URLRequestHeader_obj::URLRequestHeader_obj()
{
}

void URLRequestHeader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(URLRequestHeader);
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(value,"value");
	HX_MARK_END_CLASS();
}

void URLRequestHeader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(value,"value");
}

Dynamic URLRequestHeader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"value") ) { return value; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic URLRequestHeader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"value") ) { value=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void URLRequestHeader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("value"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(URLRequestHeader_obj,name),HX_CSTRING("name")},
	{hx::fsString,(int)offsetof(URLRequestHeader_obj,value),HX_CSTRING("value")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("name"),
	HX_CSTRING("value"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(URLRequestHeader_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(URLRequestHeader_obj::__mClass,"__mClass");
};

#endif

Class URLRequestHeader_obj::__mClass;

void URLRequestHeader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.net.URLRequestHeader"), hx::TCanCast< URLRequestHeader_obj> ,sStaticFields,sMemberFields,
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

void URLRequestHeader_obj::__boot()
{
}

} // end namespace flash
} // end namespace net
