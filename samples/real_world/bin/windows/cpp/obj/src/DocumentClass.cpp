#include <hxcpp.h>

#ifndef INCLUDED_Demo
#include <Demo.h>
#endif
#ifndef INCLUDED_DocumentClass
#include <DocumentClass.h>
#endif

Void DocumentClass_obj::__construct()
{
HX_STACK_FRAME("DocumentClass","new",0x4aeb0a6f,"DocumentClass.new","ApplicationMain.hx",196,0x0780ded5)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(196)
	super::__construct();
}
;
	return null();
}

//DocumentClass_obj::~DocumentClass_obj() { }

Dynamic DocumentClass_obj::__CreateEmpty() { return  new DocumentClass_obj; }
hx::ObjectPtr< DocumentClass_obj > DocumentClass_obj::__new()
{  hx::ObjectPtr< DocumentClass_obj > result = new DocumentClass_obj();
	result->__construct();
	return result;}

Dynamic DocumentClass_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DocumentClass_obj > result = new DocumentClass_obj();
	result->__construct();
	return result;}


DocumentClass_obj::DocumentClass_obj()
{
}

Dynamic DocumentClass_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic DocumentClass_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void DocumentClass_obj::__GetFields(Array< ::String> &outFields)
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
	HX_MARK_MEMBER_NAME(DocumentClass_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DocumentClass_obj::__mClass,"__mClass");
};

#endif

Class DocumentClass_obj::__mClass;

void DocumentClass_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("DocumentClass"), hx::TCanCast< DocumentClass_obj> ,sStaticFields,sMemberFields,
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

void DocumentClass_obj::__boot()
{
}

