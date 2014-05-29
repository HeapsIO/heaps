#include <hxcpp.h>

#ifndef INCLUDED_hxd__IndexBuffer_IndexBuffer_Impl_
#include <hxd/_IndexBuffer/IndexBuffer_Impl_.h>
#endif
#ifndef INCLUDED_hxd__IndexBuffer_InnerIterator
#include <hxd/_IndexBuffer/InnerIterator.h>
#endif
namespace hxd{
namespace _IndexBuffer{

Void IndexBuffer_Impl__obj::__construct()
{
	return null();
}

//IndexBuffer_Impl__obj::~IndexBuffer_Impl__obj() { }

Dynamic IndexBuffer_Impl__obj::__CreateEmpty() { return  new IndexBuffer_Impl__obj; }
hx::ObjectPtr< IndexBuffer_Impl__obj > IndexBuffer_Impl__obj::__new()
{  hx::ObjectPtr< IndexBuffer_Impl__obj > result = new IndexBuffer_Impl__obj();
	result->__construct();
	return result;}

Dynamic IndexBuffer_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< IndexBuffer_Impl__obj > result = new IndexBuffer_Impl__obj();
	result->__construct();
	return result;}

Array< int > IndexBuffer_Impl__obj::_new( hx::Null< int >  __o_length){
int length = __o_length.Default(0);
	HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","_new",0x06c59afe,"hxd._IndexBuffer.IndexBuffer_Impl_._new","hxd/IndexBuffer.hx",30,0x7cad6c07)
	HX_STACK_ARG(length,"length")
{
		HX_STACK_LINE(30)
		return Array_obj< int >::__new();
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(IndexBuffer_Impl__obj,_new,return )

Array< int > IndexBuffer_Impl__obj::fromArray( Array< int > arr){
	HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","fromArray",0xd5b75912,"hxd._IndexBuffer.IndexBuffer_Impl_.fromArray","hxd/IndexBuffer.hx",37,0x7cad6c07)
	HX_STACK_ARG(arr,"arr")
	HX_STACK_LINE(38)
	Array< int > f = Array_obj< int >::__new();		HX_STACK_VAR(f,"f");
	HX_STACK_LINE(39)
	{
		HX_STACK_LINE(39)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(39)
		int _g = arr->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(39)
		while((true)){
			HX_STACK_LINE(39)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(39)
				break;
			}
			HX_STACK_LINE(39)
			int v = (_g1)++;		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(40)
			f[v] = arr->__get(v);
		}
	}
	HX_STACK_LINE(41)
	return f;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(IndexBuffer_Impl__obj,fromArray,return )

Void IndexBuffer_Impl__obj::push( Array< int > this1,int v){
{
		HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","push",0x12079777,"hxd._IndexBuffer.IndexBuffer_Impl_.push","hxd/IndexBuffer.hx",48,0x7cad6c07)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(48)
		this1->push(v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(IndexBuffer_Impl__obj,push,(void))

int IndexBuffer_Impl__obj::arrayRead( Array< int > this1,int key){
	HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","arrayRead",0x90b826d2,"hxd._IndexBuffer.IndexBuffer_Impl_.arrayRead","hxd/IndexBuffer.hx",53,0x7cad6c07)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(53)
	return this1->__get(key);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(IndexBuffer_Impl__obj,arrayRead,return )

int IndexBuffer_Impl__obj::arrayWrite( Array< int > this1,int key,int value){
	HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","arrayWrite",0xfa089de3,"hxd._IndexBuffer.IndexBuffer_Impl_.arrayWrite","hxd/IndexBuffer.hx",57,0x7cad6c07)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(key,"key")
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(57)
	return this1[key] = value;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(IndexBuffer_Impl__obj,arrayWrite,return )

Array< int > IndexBuffer_Impl__obj::getNative( Array< int > this1){
	HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","getNative",0x9a125410,"hxd._IndexBuffer.IndexBuffer_Impl_.getNative","hxd/IndexBuffer.hx",61,0x7cad6c07)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(61)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(IndexBuffer_Impl__obj,getNative,return )

::hxd::_IndexBuffer::InnerIterator IndexBuffer_Impl__obj::iterator( Array< int > this1){
	HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","iterator",0xd750620b,"hxd._IndexBuffer.IndexBuffer_Impl_.iterator","hxd/IndexBuffer.hx",65,0x7cad6c07)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(65)
	return ::hxd::_IndexBuffer::InnerIterator_obj::__new(this1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(IndexBuffer_Impl__obj,iterator,return )

int IndexBuffer_Impl__obj::get_length( Array< int > this1){
	HX_STACK_FRAME("hxd._IndexBuffer.IndexBuffer_Impl_","get_length",0xbf111e0c,"hxd._IndexBuffer.IndexBuffer_Impl_.get_length","hxd/IndexBuffer.hx",69,0x7cad6c07)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(69)
	return this1->length;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(IndexBuffer_Impl__obj,get_length,return )


IndexBuffer_Impl__obj::IndexBuffer_Impl__obj()
{
}

Dynamic IndexBuffer_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		if (HX_FIELD_EQ(inName,"push") ) { return push_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromArray") ) { return fromArray_dyn(); }
		if (HX_FIELD_EQ(inName,"arrayRead") ) { return arrayRead_dyn(); }
		if (HX_FIELD_EQ(inName,"getNative") ) { return getNative_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"arrayWrite") ) { return arrayWrite_dyn(); }
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic IndexBuffer_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void IndexBuffer_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("fromArray"),
	HX_CSTRING("push"),
	HX_CSTRING("arrayRead"),
	HX_CSTRING("arrayWrite"),
	HX_CSTRING("getNative"),
	HX_CSTRING("iterator"),
	HX_CSTRING("get_length"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IndexBuffer_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IndexBuffer_Impl__obj::__mClass,"__mClass");
};

#endif

Class IndexBuffer_Impl__obj::__mClass;

void IndexBuffer_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd._IndexBuffer.IndexBuffer_Impl_"), hx::TCanCast< IndexBuffer_Impl__obj> ,sStaticFields,sMemberFields,
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

void IndexBuffer_Impl__obj::__boot()
{
}

} // end namespace hxd
} // end namespace _IndexBuffer
