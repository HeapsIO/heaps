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
#ifndef INCLUDED_hxd_ByteConversions
#include <hxd/ByteConversions.h>
#endif
#ifndef INCLUDED_hxd_impl_Memory
#include <hxd/impl/Memory.h>
#endif
#ifndef INCLUDED_hxd_impl_MemoryReader
#include <hxd/impl/MemoryReader.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace hxd{
namespace impl{

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

Array< ::Dynamic > Memory_obj::stack;

::haxe::io::Bytes Memory_obj::current;

::hxd::impl::MemoryReader Memory_obj::inst;

::hxd::impl::MemoryReader Memory_obj::select( ::haxe::io::Bytes b){
	HX_STACK_FRAME("hxd.impl.Memory","select",0x3cccbf75,"hxd.impl.Memory.select","hxd/impl/Memory.hx",55,0x0cc426a9)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(57)
	::flash::utils::ByteArray data = ::hxd::ByteConversions_obj::bytesToByteArray(b);		HX_STACK_VAR(data,"data");
	HX_STACK_LINE(61)
	::flash::Memory_obj::select(data);
	HX_STACK_LINE(63)
	if (((::hxd::impl::Memory_obj::current != null()))){
		HX_STACK_LINE(63)
		::hxd::impl::Memory_obj::stack->push(::hxd::impl::Memory_obj::current);
	}
	HX_STACK_LINE(64)
	::hxd::impl::Memory_obj::current = b;
	HX_STACK_LINE(65)
	return ::hxd::impl::Memory_obj::inst;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Memory_obj,select,return )

Void Memory_obj::end( ){
{
		HX_STACK_FRAME("hxd.impl.Memory","end",0xd6ccc9c2,"hxd.impl.Memory.end","hxd/impl/Memory.hx",68,0x0cc426a9)
		HX_STACK_LINE(69)
		::haxe::io::Bytes _g = ::hxd::impl::Memory_obj::stack->pop().StaticCast< ::haxe::io::Bytes >();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(69)
		::hxd::impl::Memory_obj::current = _g;
		HX_STACK_LINE(71)
		if (((::hxd::impl::Memory_obj::current != null()))){
			HX_STACK_LINE(72)
			::flash::utils::ByteArray _g1 = ::hxd::ByteConversions_obj::bytesToByteArray(::hxd::impl::Memory_obj::current);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(72)
			::flash::Memory_obj::select(_g1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Memory_obj,end,(void))


Memory_obj::Memory_obj()
{
}

Dynamic Memory_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"end") ) { return end_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { return inst; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"stack") ) { return stack; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"select") ) { return select_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"current") ) { return current; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Memory_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { inst=inValue.Cast< ::hxd::impl::MemoryReader >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"stack") ) { stack=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"current") ) { current=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Memory_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("stack"),
	HX_CSTRING("current"),
	HX_CSTRING("inst"),
	HX_CSTRING("select"),
	HX_CSTRING("end"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Memory_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Memory_obj::stack,"stack");
	HX_MARK_MEMBER_NAME(Memory_obj::current,"current");
	HX_MARK_MEMBER_NAME(Memory_obj::inst,"inst");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Memory_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Memory_obj::stack,"stack");
	HX_VISIT_MEMBER_NAME(Memory_obj::current,"current");
	HX_VISIT_MEMBER_NAME(Memory_obj::inst,"inst");
};

#endif

Class Memory_obj::__mClass;

void Memory_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.impl.Memory"), hx::TCanCast< Memory_obj> ,sStaticFields,sMemberFields,
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
	stack= Array_obj< ::Dynamic >::__new();
	current= null();
	inst= ::hxd::impl::MemoryReader_obj::__new();
}

} // end namespace hxd
} // end namespace impl
