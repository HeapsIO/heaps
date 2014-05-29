#include <hxcpp.h>

#ifndef INCLUDED_cpp_NativeArray
#include <cpp/NativeArray.h>
#endif
namespace cpp{

Void NativeArray_obj::__construct()
{
	return null();
}

//NativeArray_obj::~NativeArray_obj() { }

Dynamic NativeArray_obj::__CreateEmpty() { return  new NativeArray_obj; }
hx::ObjectPtr< NativeArray_obj > NativeArray_obj::__new()
{  hx::ObjectPtr< NativeArray_obj > result = new NativeArray_obj();
	result->__construct();
	return result;}

Dynamic NativeArray_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< NativeArray_obj > result = new NativeArray_obj();
	result->__construct();
	return result;}

Void NativeArray_obj::blit( Dynamic ioDestArray,int inDestElement,Dynamic inSourceArray,int inSourceElement,int inElementCount){
{
		HX_STACK_FRAME("cpp.NativeArray","blit",0x99e37f6c,"cpp.NativeArray.blit","D:\\Workspace\\motionTools\\haxe3\\std/cpp/NativeArray.hx",8,0x32ecd487)
		HX_STACK_ARG(ioDestArray,"ioDestArray")
		HX_STACK_ARG(inDestElement,"inDestElement")
		HX_STACK_ARG(inSourceArray,"inSourceArray")
		HX_STACK_ARG(inSourceElement,"inSourceElement")
		HX_STACK_ARG(inElementCount,"inElementCount")
		HX_STACK_LINE(8)
		ioDestArray->__Field(HX_CSTRING("blit"),true)(inDestElement,inSourceArray,inSourceElement,inElementCount);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(NativeArray_obj,blit,(void))

Void NativeArray_obj::zero( Dynamic ioDestArray,Dynamic inFirst,Dynamic inElements){
{
		HX_STACK_FRAME("cpp.NativeArray","zero",0xa9bb565f,"cpp.NativeArray.zero","D:\\Workspace\\motionTools\\haxe3\\std/cpp/NativeArray.hx",12,0x32ecd487)
		HX_STACK_ARG(ioDestArray,"ioDestArray")
		HX_STACK_ARG(inFirst,"inFirst")
		HX_STACK_ARG(inElements,"inElements")
		HX_STACK_LINE(12)
		ioDestArray->__Field(HX_CSTRING("zero"),true)(inFirst,inElements);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(NativeArray_obj,zero,(void))

Dynamic NativeArray_obj::unsafeGet( Dynamic inDestArray,int inIndex){
	HX_STACK_FRAME("cpp.NativeArray","unsafeGet",0x4fd18179,"cpp.NativeArray.unsafeGet","D:\\Workspace\\motionTools\\haxe3\\std/cpp/NativeArray.hx",16,0x32ecd487)
	HX_STACK_ARG(inDestArray,"inDestArray")
	HX_STACK_ARG(inIndex,"inIndex")
	HX_STACK_LINE(16)
	return inDestArray->__Field(HX_CSTRING("__unsafe_get"),true)(inIndex);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(NativeArray_obj,unsafeGet,return )

Dynamic NativeArray_obj::unsafeSet( Dynamic ioDestArray,int inIndex,Dynamic inValue){
	HX_STACK_FRAME("cpp.NativeArray","unsafeSet",0x4fda9c85,"cpp.NativeArray.unsafeSet","D:\\Workspace\\motionTools\\haxe3\\std/cpp/NativeArray.hx",19,0x32ecd487)
	HX_STACK_ARG(ioDestArray,"ioDestArray")
	HX_STACK_ARG(inIndex,"inIndex")
	HX_STACK_ARG(inValue,"inValue")
	HX_STACK_LINE(19)
	return ioDestArray->__Field(HX_CSTRING("__unsafe_set"),true)(inIndex,inValue);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(NativeArray_obj,unsafeSet,return )

int NativeArray_obj::memcmp( Dynamic inArrayA,Dynamic inArrayB){
	HX_STACK_FRAME("cpp.NativeArray","memcmp",0xda0a6e88,"cpp.NativeArray.memcmp","D:\\Workspace\\motionTools\\haxe3\\std/cpp/NativeArray.hx",23,0x32ecd487)
	HX_STACK_ARG(inArrayA,"inArrayA")
	HX_STACK_ARG(inArrayB,"inArrayB")
	HX_STACK_LINE(23)
	return inArrayA->__Field(HX_CSTRING("memcmp"),true)(inArrayB);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(NativeArray_obj,memcmp,return )

Dynamic NativeArray_obj::setSize( Dynamic ioArray,int inSize){
	HX_STACK_FRAME("cpp.NativeArray","setSize",0xe5ceb6ac,"cpp.NativeArray.setSize","D:\\Workspace\\motionTools\\haxe3\\std/cpp/NativeArray.hx",27,0x32ecd487)
	HX_STACK_ARG(ioArray,"ioArray")
	HX_STACK_ARG(inSize,"inSize")
	HX_STACK_LINE(27)
	return ioArray->__Field(HX_CSTRING("__SetSizeExact"),true)(inSize);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(NativeArray_obj,setSize,return )


NativeArray_obj::NativeArray_obj()
{
}

Dynamic NativeArray_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"blit") ) { return blit_dyn(); }
		if (HX_FIELD_EQ(inName,"zero") ) { return zero_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"memcmp") ) { return memcmp_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"setSize") ) { return setSize_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"unsafeGet") ) { return unsafeGet_dyn(); }
		if (HX_FIELD_EQ(inName,"unsafeSet") ) { return unsafeSet_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic NativeArray_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void NativeArray_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("blit"),
	HX_CSTRING("zero"),
	HX_CSTRING("unsafeGet"),
	HX_CSTRING("unsafeSet"),
	HX_CSTRING("memcmp"),
	HX_CSTRING("setSize"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(NativeArray_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(NativeArray_obj::__mClass,"__mClass");
};

#endif

Class NativeArray_obj::__mClass;

void NativeArray_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("cpp.NativeArray"), hx::TCanCast< NativeArray_obj> ,sStaticFields,sMemberFields,
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

void NativeArray_obj::__boot()
{
}

} // end namespace cpp
