#include <hxcpp.h>

#ifndef INCLUDED_ValueType
#include <ValueType.h>
#endif

::ValueType ValueType_obj::TBool;

::ValueType  ValueType_obj::TClass(::Class c)
	{ return hx::CreateEnum< ValueType_obj >(HX_CSTRING("TClass"),6,hx::DynamicArray(0,1).Add(c)); }

::ValueType  ValueType_obj::TEnum(::Enum e)
	{ return hx::CreateEnum< ValueType_obj >(HX_CSTRING("TEnum"),7,hx::DynamicArray(0,1).Add(e)); }

::ValueType ValueType_obj::TFloat;

::ValueType ValueType_obj::TFunction;

::ValueType ValueType_obj::TInt;

::ValueType ValueType_obj::TNull;

::ValueType ValueType_obj::TObject;

::ValueType ValueType_obj::TUnknown;

HX_DEFINE_CREATE_ENUM(ValueType_obj)

int ValueType_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("TBool")) return 3;
	if (inName==HX_CSTRING("TClass")) return 6;
	if (inName==HX_CSTRING("TEnum")) return 7;
	if (inName==HX_CSTRING("TFloat")) return 2;
	if (inName==HX_CSTRING("TFunction")) return 5;
	if (inName==HX_CSTRING("TInt")) return 1;
	if (inName==HX_CSTRING("TNull")) return 0;
	if (inName==HX_CSTRING("TObject")) return 4;
	if (inName==HX_CSTRING("TUnknown")) return 8;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC1(ValueType_obj,TClass,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(ValueType_obj,TEnum,return)

int ValueType_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("TBool")) return 0;
	if (inName==HX_CSTRING("TClass")) return 1;
	if (inName==HX_CSTRING("TEnum")) return 1;
	if (inName==HX_CSTRING("TFloat")) return 0;
	if (inName==HX_CSTRING("TFunction")) return 0;
	if (inName==HX_CSTRING("TInt")) return 0;
	if (inName==HX_CSTRING("TNull")) return 0;
	if (inName==HX_CSTRING("TObject")) return 0;
	if (inName==HX_CSTRING("TUnknown")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic ValueType_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("TBool")) return TBool;
	if (inName==HX_CSTRING("TClass")) return TClass_dyn();
	if (inName==HX_CSTRING("TEnum")) return TEnum_dyn();
	if (inName==HX_CSTRING("TFloat")) return TFloat;
	if (inName==HX_CSTRING("TFunction")) return TFunction;
	if (inName==HX_CSTRING("TInt")) return TInt;
	if (inName==HX_CSTRING("TNull")) return TNull;
	if (inName==HX_CSTRING("TObject")) return TObject;
	if (inName==HX_CSTRING("TUnknown")) return TUnknown;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("TNull"),
	HX_CSTRING("TInt"),
	HX_CSTRING("TFloat"),
	HX_CSTRING("TBool"),
	HX_CSTRING("TObject"),
	HX_CSTRING("TFunction"),
	HX_CSTRING("TClass"),
	HX_CSTRING("TEnum"),
	HX_CSTRING("TUnknown"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ValueType_obj::TBool,"TBool");
	HX_MARK_MEMBER_NAME(ValueType_obj::TFloat,"TFloat");
	HX_MARK_MEMBER_NAME(ValueType_obj::TFunction,"TFunction");
	HX_MARK_MEMBER_NAME(ValueType_obj::TInt,"TInt");
	HX_MARK_MEMBER_NAME(ValueType_obj::TNull,"TNull");
	HX_MARK_MEMBER_NAME(ValueType_obj::TObject,"TObject");
	HX_MARK_MEMBER_NAME(ValueType_obj::TUnknown,"TUnknown");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ValueType_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ValueType_obj::TBool,"TBool");
	HX_VISIT_MEMBER_NAME(ValueType_obj::TFloat,"TFloat");
	HX_VISIT_MEMBER_NAME(ValueType_obj::TFunction,"TFunction");
	HX_VISIT_MEMBER_NAME(ValueType_obj::TInt,"TInt");
	HX_VISIT_MEMBER_NAME(ValueType_obj::TNull,"TNull");
	HX_VISIT_MEMBER_NAME(ValueType_obj::TObject,"TObject");
	HX_VISIT_MEMBER_NAME(ValueType_obj::TUnknown,"TUnknown");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class ValueType_obj::__mClass;

Dynamic __Create_ValueType_obj() { return new ValueType_obj; }

void ValueType_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("ValueType"), hx::TCanCast< ValueType_obj >,sStaticFields,sMemberFields,
	&__Create_ValueType_obj, &__Create,
	&super::__SGetClass(), &CreateValueType_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void ValueType_obj::__boot()
{
hx::Static(TBool) = hx::CreateEnum< ValueType_obj >(HX_CSTRING("TBool"),3);
hx::Static(TFloat) = hx::CreateEnum< ValueType_obj >(HX_CSTRING("TFloat"),2);
hx::Static(TFunction) = hx::CreateEnum< ValueType_obj >(HX_CSTRING("TFunction"),5);
hx::Static(TInt) = hx::CreateEnum< ValueType_obj >(HX_CSTRING("TInt"),1);
hx::Static(TNull) = hx::CreateEnum< ValueType_obj >(HX_CSTRING("TNull"),0);
hx::Static(TObject) = hx::CreateEnum< ValueType_obj >(HX_CSTRING("TObject"),4);
hx::Static(TUnknown) = hx::CreateEnum< ValueType_obj >(HX_CSTRING("TUnknown"),8);
}


