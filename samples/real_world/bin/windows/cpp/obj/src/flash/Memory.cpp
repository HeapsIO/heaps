#include <hxcpp.h>

#ifndef INCLUDED_flash_Memory
#include <flash/Memory.h>
#endif
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
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace flash{

Void Memory_obj::__construct()
{
	return null();
}

//Memory_obj::~Memory_obj() { }

Dynamic Memory_obj::__CreateEmpty() { return  new Memory_obj; }
hx::ObjectPtr< Memory_obj > Memory_obj::__new()
{  hx::ObjectPtr< Memory_obj > result = new Memory_obj();
	result->__construct();
	return result;}

Dynamic Memory_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Memory_obj > result = new Memory_obj();
	result->__construct();
	return result;}

::flash::utils::ByteArray Memory_obj::gcRef;

int Memory_obj::len;

Void Memory_obj::select( ::flash::utils::ByteArray bytes){
{
		HX_STACK_FRAME("flash.Memory","select",0x65928d6b,"flash.Memory.select","flash/Memory.hx",20,0x29e6a1de)
		HX_STACK_ARG(bytes,"bytes")
		HX_STACK_LINE(33)
		::flash::Memory_obj::gcRef = bytes;
		HX_STACK_LINE(34)
		if (((bytes == null()))){
			HX_STACK_LINE(36)
			::__hxcpp_memory_clear();
		}
		else{
			HX_STACK_LINE(40)
			::__hxcpp_memory_select(bytes->b);
		}
		HX_STACK_LINE(45)
		if (((bytes == null()))){
			HX_STACK_LINE(47)
			::flash::Memory_obj::len = (int)0;
		}
		else{
			HX_STACK_LINE(51)
			::flash::Memory_obj::len = bytes->length;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Memory_obj,select,(void))

int Memory_obj::getByte( int addr){
	HX_STACK_FRAME("flash.Memory","getByte",0x0bca7d6f,"flash.Memory.getByte","flash/Memory.hx",136,0x29e6a1de)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(138)
	if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
		HX_STACK_LINE(138)
		HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
	}
	HX_STACK_LINE(139)
	return ::__hxcpp_memory_get_byte(addr);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Memory_obj,getByte,return )

Float Memory_obj::getDouble( int addr){
	HX_STACK_FRAME("flash.Memory","getDouble",0x7cd43138,"flash.Memory.getDouble","flash/Memory.hx",144,0x29e6a1de)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(146)
	if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
		HX_STACK_LINE(146)
		HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
	}
	HX_STACK_LINE(147)
	return ::__hxcpp_memory_get_double(addr);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Memory_obj,getDouble,return )

Float Memory_obj::getFloat( int addr){
	HX_STACK_FRAME("flash.Memory","getFloat",0x8a620155,"flash.Memory.getFloat","flash/Memory.hx",152,0x29e6a1de)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(154)
	if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
		HX_STACK_LINE(154)
		HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
	}
	HX_STACK_LINE(155)
	return ::__hxcpp_memory_get_float(addr);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Memory_obj,getFloat,return )

int Memory_obj::getI32( int addr){
	HX_STACK_FRAME("flash.Memory","getI32",0x9e7e84c1,"flash.Memory.getI32","flash/Memory.hx",160,0x29e6a1de)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(162)
	if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
		HX_STACK_LINE(162)
		HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
	}
	HX_STACK_LINE(163)
	return ::__hxcpp_memory_get_i32(addr);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Memory_obj,getI32,return )

int Memory_obj::getUI16( int addr){
	HX_STACK_FRAME("flash.Memory","getUI16",0x1834e480,"flash.Memory.getUI16","flash/Memory.hx",168,0x29e6a1de)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(170)
	if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
		HX_STACK_LINE(170)
		HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
	}
	HX_STACK_LINE(171)
	return ::__hxcpp_memory_get_ui16(addr);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Memory_obj,getUI16,return )

Void Memory_obj::setByte( int addr,int v){
{
		HX_STACK_FRAME("flash.Memory","setByte",0xfecc0e7b,"flash.Memory.setByte","flash/Memory.hx",176,0x29e6a1de)
		HX_STACK_ARG(addr,"addr")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(178)
		if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
			HX_STACK_LINE(178)
			HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
		}
		HX_STACK_LINE(179)
		::__hxcpp_memory_set_byte(addr,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Memory_obj,setByte,(void))

Void Memory_obj::setDouble( int addr,Float v){
{
		HX_STACK_FRAME("flash.Memory","setDouble",0x60251d44,"flash.Memory.setDouble","flash/Memory.hx",184,0x29e6a1de)
		HX_STACK_ARG(addr,"addr")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(186)
		if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
			HX_STACK_LINE(186)
			HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
		}
		HX_STACK_LINE(187)
		::__hxcpp_memory_set_double(addr,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Memory_obj,setDouble,(void))

Void Memory_obj::setFloat( int addr,Float v){
{
		HX_STACK_FRAME("flash.Memory","setFloat",0x38bf5ac9,"flash.Memory.setFloat","flash/Memory.hx",192,0x29e6a1de)
		HX_STACK_ARG(addr,"addr")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(194)
		if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
			HX_STACK_LINE(194)
			HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
		}
		HX_STACK_LINE(195)
		::__hxcpp_memory_set_float(addr,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Memory_obj,setFloat,(void))

Void Memory_obj::setI16( int addr,int v){
{
		HX_STACK_FRAME("flash.Memory","setI16",0x6ac6d77b,"flash.Memory.setI16","flash/Memory.hx",200,0x29e6a1de)
		HX_STACK_ARG(addr,"addr")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(202)
		if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
			HX_STACK_LINE(202)
			HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
		}
		HX_STACK_LINE(203)
		::__hxcpp_memory_set_i16(addr,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Memory_obj,setI16,(void))

Void Memory_obj::setI32( int addr,int v){
{
		HX_STACK_FRAME("flash.Memory","setI32",0x6ac6d935,"flash.Memory.setI32","flash/Memory.hx",208,0x29e6a1de)
		HX_STACK_ARG(addr,"addr")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(210)
		if (((bool((addr < (int)0)) || bool((addr >= ::flash::Memory_obj::len))))){
			HX_STACK_LINE(210)
			HX_STACK_DO_THROW(HX_CSTRING("Bad address"));
		}
		HX_STACK_LINE(211)
		::__hxcpp_memory_set_i32(addr,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Memory_obj,setI32,(void))


Memory_obj::Memory_obj()
{
}

Dynamic Memory_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"len") ) { return len; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"gcRef") ) { return gcRef; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"select") ) { return select_dyn(); }
		if (HX_FIELD_EQ(inName,"getI32") ) { return getI32_dyn(); }
		if (HX_FIELD_EQ(inName,"setI16") ) { return setI16_dyn(); }
		if (HX_FIELD_EQ(inName,"setI32") ) { return setI32_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getByte") ) { return getByte_dyn(); }
		if (HX_FIELD_EQ(inName,"getUI16") ) { return getUI16_dyn(); }
		if (HX_FIELD_EQ(inName,"setByte") ) { return setByte_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getFloat") ) { return getFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"setFloat") ) { return setFloat_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getDouble") ) { return getDouble_dyn(); }
		if (HX_FIELD_EQ(inName,"setDouble") ) { return setDouble_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Memory_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"len") ) { len=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"gcRef") ) { gcRef=inValue.Cast< ::flash::utils::ByteArray >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Memory_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("gcRef"),
	HX_CSTRING("len"),
	HX_CSTRING("select"),
	HX_CSTRING("getByte"),
	HX_CSTRING("getDouble"),
	HX_CSTRING("getFloat"),
	HX_CSTRING("getI32"),
	HX_CSTRING("getUI16"),
	HX_CSTRING("setByte"),
	HX_CSTRING("setDouble"),
	HX_CSTRING("setFloat"),
	HX_CSTRING("setI16"),
	HX_CSTRING("setI32"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Memory_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Memory_obj::gcRef,"gcRef");
	HX_MARK_MEMBER_NAME(Memory_obj::len,"len");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Memory_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Memory_obj::gcRef,"gcRef");
	HX_VISIT_MEMBER_NAME(Memory_obj::len,"len");
};

#endif

Class Memory_obj::__mClass;

void Memory_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.Memory"), hx::TCanCast< Memory_obj> ,sStaticFields,sMemberFields,
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

void Memory_obj::__boot()
{
}

} // end namespace flash
