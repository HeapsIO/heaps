#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesBuffer
#include <haxe/io/BytesBuffer.h>
#endif
#ifndef INCLUDED_haxe_io_BytesOutput
#include <haxe/io/BytesOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
#ifndef INCLUDED_hxd__BytesBuffer_BytesBuffer_Impl_
#include <hxd/_BytesBuffer/BytesBuffer_Impl_.h>
#endif
namespace hxd{
namespace _BytesBuffer{

Void BytesBuffer_Impl__obj::__construct()
{
	return null();
}

//BytesBuffer_Impl__obj::~BytesBuffer_Impl__obj() { }

Dynamic BytesBuffer_Impl__obj::__CreateEmpty() { return  new BytesBuffer_Impl__obj; }
hx::ObjectPtr< BytesBuffer_Impl__obj > BytesBuffer_Impl__obj::__new()
{  hx::ObjectPtr< BytesBuffer_Impl__obj > result = new BytesBuffer_Impl__obj();
	result->__construct();
	return result;}

Dynamic BytesBuffer_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BytesBuffer_Impl__obj > result = new BytesBuffer_Impl__obj();
	result->__construct();
	return result;}

::haxe::io::BytesOutput BytesBuffer_Impl__obj::_new( ){
	HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","_new",0x836cc68c,"hxd._BytesBuffer.BytesBuffer_Impl_._new","hxd/BytesBuffer.hx",14,0x83b80b8e)
	HX_STACK_LINE(14)
	return ::haxe::io::BytesOutput_obj::__new();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(BytesBuffer_Impl__obj,_new,return )

::haxe::io::BytesOutput BytesBuffer_Impl__obj::fromU8Array( Array< int > arr){
	HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","fromU8Array",0xc1fc5661,"hxd._BytesBuffer.BytesBuffer_Impl_.fromU8Array","hxd/BytesBuffer.hx",19,0x83b80b8e)
	HX_STACK_ARG(arr,"arr")
	HX_STACK_LINE(20)
	::haxe::io::BytesOutput v = ::haxe::io::BytesOutput_obj::__new();		HX_STACK_VAR(v,"v");
	HX_STACK_LINE(21)
	{
		HX_STACK_LINE(21)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(21)
		int _g = arr->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(21)
		while((true)){
			HX_STACK_LINE(21)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(21)
				break;
			}
			HX_STACK_LINE(21)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(22)
			v->writeByte((int(arr->__get(i)) & int((int)255)));
		}
	}
	HX_STACK_LINE(23)
	return v;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_Impl__obj,fromU8Array,return )

::haxe::io::BytesOutput BytesBuffer_Impl__obj::fromIntArray( Array< int > arr){
	HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","fromIntArray",0x3f96bddf,"hxd._BytesBuffer.BytesBuffer_Impl_.fromIntArray","hxd/BytesBuffer.hx",26,0x83b80b8e)
	HX_STACK_ARG(arr,"arr")
	HX_STACK_LINE(27)
	::haxe::io::BytesOutput v = ::haxe::io::BytesOutput_obj::__new();		HX_STACK_VAR(v,"v");
	HX_STACK_LINE(28)
	{
		HX_STACK_LINE(28)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(28)
		int _g = arr->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(28)
		while((true)){
			HX_STACK_LINE(28)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(28)
				break;
			}
			HX_STACK_LINE(28)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(29)
			v->writeInt32(arr->__get(i));
		}
	}
	HX_STACK_LINE(30)
	return v;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_Impl__obj,fromIntArray,return )

Void BytesBuffer_Impl__obj::writeByte( ::haxe::io::BytesOutput this1,int v){
{
		HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","writeByte",0xaaa0467c,"hxd._BytesBuffer.BytesBuffer_Impl_.writeByte","hxd/BytesBuffer.hx",34,0x83b80b8e)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(34)
		this1->writeByte((int(v) & int((int)255)));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BytesBuffer_Impl__obj,writeByte,(void))

Void BytesBuffer_Impl__obj::writeFloat( ::haxe::io::BytesOutput this1,Float v){
{
		HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","writeFloat",0xe69c23a8,"hxd._BytesBuffer.BytesBuffer_Impl_.writeFloat","hxd/BytesBuffer.hx",38,0x83b80b8e)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(38)
		this1->writeFloat(v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BytesBuffer_Impl__obj,writeFloat,(void))

Void BytesBuffer_Impl__obj::writeInt32( ::haxe::io::BytesOutput this1,int v){
{
		HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","writeInt32",0xa225f15a,"hxd._BytesBuffer.BytesBuffer_Impl_.writeInt32","hxd/BytesBuffer.hx",45,0x83b80b8e)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(45)
		this1->writeInt32(v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BytesBuffer_Impl__obj,writeInt32,(void))

::haxe::io::Bytes BytesBuffer_Impl__obj::getBytes( ::haxe::io::BytesOutput this1){
	HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","getBytes",0xbb243aa0,"hxd._BytesBuffer.BytesBuffer_Impl_.getBytes","hxd/BytesBuffer.hx",53,0x83b80b8e)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(53)
	return this1->getBytes();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_Impl__obj,getBytes,return )

int BytesBuffer_Impl__obj::get_length( ::haxe::io::BytesOutput this1){
	HX_STACK_FRAME("hxd._BytesBuffer.BytesBuffer_Impl_","get_length",0xded2681a,"hxd._BytesBuffer.BytesBuffer_Impl_.get_length","hxd/BytesBuffer.hx",61,0x83b80b8e)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(61)
	return this1->b->b->length;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_Impl__obj,get_length,return )


BytesBuffer_Impl__obj::BytesBuffer_Impl__obj()
{
}

Dynamic BytesBuffer_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"writeByte") ) { return writeByte_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"writeFloat") ) { return writeFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"writeInt32") ) { return writeInt32_dyn(); }
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"fromU8Array") ) { return fromU8Array_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"fromIntArray") ) { return fromIntArray_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BytesBuffer_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void BytesBuffer_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("fromU8Array"),
	HX_CSTRING("fromIntArray"),
	HX_CSTRING("writeByte"),
	HX_CSTRING("writeFloat"),
	HX_CSTRING("writeInt32"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("get_length"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BytesBuffer_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BytesBuffer_Impl__obj::__mClass,"__mClass");
};

#endif

Class BytesBuffer_Impl__obj::__mClass;

void BytesBuffer_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd._BytesBuffer.BytesBuffer_Impl_"), hx::TCanCast< BytesBuffer_Impl__obj> ,sStaticFields,sMemberFields,
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

void BytesBuffer_Impl__obj::__boot()
{
}

} // end namespace hxd
} // end namespace _BytesBuffer
