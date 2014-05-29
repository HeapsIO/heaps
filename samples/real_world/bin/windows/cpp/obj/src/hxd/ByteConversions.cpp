#include <hxcpp.h>

#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_ByteConversions
#include <hxd/ByteConversions.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace hxd{

Void ByteConversions_obj::__construct()
{
	return null();
}

//ByteConversions_obj::~ByteConversions_obj() { }

Dynamic ByteConversions_obj::__CreateEmpty() { return  new ByteConversions_obj; }
hx::ObjectPtr< ByteConversions_obj > ByteConversions_obj::__new()
{  hx::ObjectPtr< ByteConversions_obj > result = new ByteConversions_obj();
	result->__construct();
	return result;}

Dynamic ByteConversions_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ByteConversions_obj > result = new ByteConversions_obj();
	result->__construct();
	return result;}

::haxe::io::Bytes ByteConversions_obj::byteArrayToBytes( ::flash::utils::ByteArray v){
	HX_STACK_FRAME("hxd.ByteConversions","byteArrayToBytes",0x5d9d1812,"hxd.ByteConversions.byteArrayToBytes","hxd/ByteConversions.hx",11,0x0a4240a4)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(22)
	return v;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ByteConversions_obj,byteArrayToBytes,return )

::flash::utils::ByteArray ByteConversions_obj::bytesToByteArray( ::haxe::io::Bytes v){
	HX_STACK_FRAME("hxd.ByteConversions","bytesToByteArray",0xe9e9725e,"hxd.ByteConversions.bytesToByteArray","hxd/ByteConversions.hx",38,0x0a4240a4)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(38)
	return ::flash::utils::ByteArray_obj::fromBytes(v);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ByteConversions_obj,bytesToByteArray,return )


ByteConversions_obj::ByteConversions_obj()
{
}

Dynamic ByteConversions_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 16:
		if (HX_FIELD_EQ(inName,"byteArrayToBytes") ) { return byteArrayToBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"bytesToByteArray") ) { return bytesToByteArray_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ByteConversions_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void ByteConversions_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("byteArrayToBytes"),
	HX_CSTRING("bytesToByteArray"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ByteConversions_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ByteConversions_obj::__mClass,"__mClass");
};

#endif

Class ByteConversions_obj::__mClass;

void ByteConversions_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.ByteConversions"), hx::TCanCast< ByteConversions_obj> ,sStaticFields,sMemberFields,
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

void ByteConversions_obj::__boot()
{
}

} // end namespace hxd
