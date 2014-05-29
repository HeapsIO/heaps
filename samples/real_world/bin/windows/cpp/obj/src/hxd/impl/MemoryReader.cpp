#include <hxcpp.h>

#ifndef INCLUDED_flash_Memory
#include <flash/Memory.h>
#endif
#ifndef INCLUDED_hxd_impl_Memory
#include <hxd/impl/Memory.h>
#endif
#ifndef INCLUDED_hxd_impl_MemoryReader
#include <hxd/impl/MemoryReader.h>
#endif
namespace hxd{
namespace impl{

Void MemoryReader_obj::__construct()
{
HX_STACK_FRAME("hxd.impl.MemoryReader","new",0x1cabcaea,"hxd.impl.MemoryReader.new","hxd/impl/Memory.hx",6,0x0cc426a9)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//MemoryReader_obj::~MemoryReader_obj() { }

Dynamic MemoryReader_obj::__CreateEmpty() { return  new MemoryReader_obj; }
hx::ObjectPtr< MemoryReader_obj > MemoryReader_obj::__new()
{  hx::ObjectPtr< MemoryReader_obj > result = new MemoryReader_obj();
	result->__construct();
	return result;}

Dynamic MemoryReader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MemoryReader_obj > result = new MemoryReader_obj();
	result->__construct();
	return result;}

int MemoryReader_obj::b( int addr){
	HX_STACK_FRAME("hxd.impl.MemoryReader","b",0x86af646c,"hxd.impl.MemoryReader.b","hxd/impl/Memory.hx",11,0x0cc426a9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(11)
	return ::flash::Memory_obj::getByte(addr);
}


HX_DEFINE_DYNAMIC_FUNC1(MemoryReader_obj,b,return )

Void MemoryReader_obj::wb( int addr,int v){
{
		HX_STACK_FRAME("hxd.impl.MemoryReader","wb",0x52c88cc1,"hxd.impl.MemoryReader.wb","hxd/impl/Memory.hx",19,0x0cc426a9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(addr,"addr")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(19)
		::flash::Memory_obj::setByte(addr,v);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(MemoryReader_obj,wb,(void))

Float MemoryReader_obj::_double( int addr){
	HX_STACK_FRAME("hxd.impl.MemoryReader","double",0xc162e2c7,"hxd.impl.MemoryReader.double","hxd/impl/Memory.hx",27,0x0cc426a9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(27)
	return ::flash::Memory_obj::getDouble(addr);
}


HX_DEFINE_DYNAMIC_FUNC1(MemoryReader_obj,_double,return )

int MemoryReader_obj::i32( int addr){
	HX_STACK_FRAME("hxd.impl.MemoryReader","i32",0x1ca7d3d2,"hxd.impl.MemoryReader.i32","hxd/impl/Memory.hx",36,0x0cc426a9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(addr,"addr")
	HX_STACK_LINE(36)
	return ::flash::Memory_obj::getI32(addr);
}


HX_DEFINE_DYNAMIC_FUNC1(MemoryReader_obj,i32,return )

Void MemoryReader_obj::end( ){
{
		HX_STACK_FRAME("hxd.impl.MemoryReader","end",0x1ca4fe65,"hxd.impl.MemoryReader.end","hxd/impl/Memory.hx",44,0x0cc426a9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(44)
		::hxd::impl::Memory_obj::end();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryReader_obj,end,(void))


MemoryReader_obj::MemoryReader_obj()
{
}

Dynamic MemoryReader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b_dyn(); }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"wb") ) { return wb_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"i32") ) { return i32_dyn(); }
		if (HX_FIELD_EQ(inName,"end") ) { return end_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"double") ) { return _double_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MemoryReader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void MemoryReader_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("wb"),
	HX_CSTRING("double"),
	HX_CSTRING("i32"),
	HX_CSTRING("end"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MemoryReader_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MemoryReader_obj::__mClass,"__mClass");
};

#endif

Class MemoryReader_obj::__mClass;

void MemoryReader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.impl.MemoryReader"), hx::TCanCast< MemoryReader_obj> ,sStaticFields,sMemberFields,
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

void MemoryReader_obj::__boot()
{
}

} // end namespace hxd
} // end namespace impl
