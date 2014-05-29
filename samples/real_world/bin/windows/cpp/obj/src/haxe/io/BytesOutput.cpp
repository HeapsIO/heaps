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
#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
namespace haxe{
namespace io{

Void BytesOutput_obj::__construct()
{
HX_STACK_FRAME("haxe.io.BytesOutput","new",0x130b775e,"haxe.io.BytesOutput.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesOutput.hx",35,0x507dd631)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(40)
	::haxe::io::BytesBuffer _g = ::haxe::io::BytesBuffer_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(40)
	this->b = _g;
}
;
	return null();
}

//BytesOutput_obj::~BytesOutput_obj() { }

Dynamic BytesOutput_obj::__CreateEmpty() { return  new BytesOutput_obj; }
hx::ObjectPtr< BytesOutput_obj > BytesOutput_obj::__new()
{  hx::ObjectPtr< BytesOutput_obj > result = new BytesOutput_obj();
	result->__construct();
	return result;}

Dynamic BytesOutput_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BytesOutput_obj > result = new BytesOutput_obj();
	result->__construct();
	return result;}

int BytesOutput_obj::get_length( ){
	HX_STACK_FRAME("haxe.io.BytesOutput","get_length",0xc7c55971,"haxe.io.BytesOutput.get_length","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesOutput.hx",45,0x507dd631)
	HX_STACK_THIS(this)
	HX_STACK_LINE(45)
	return this->b->b->length;
}


HX_DEFINE_DYNAMIC_FUNC0(BytesOutput_obj,get_length,return )

Void BytesOutput_obj::writeByte( int c){
{
		HX_STACK_FRAME("haxe.io.BytesOutput","writeByte",0xed1b0d05,"haxe.io.BytesOutput.writeByte","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesOutput.hx",52,0x507dd631)
		HX_STACK_THIS(this)
		HX_STACK_ARG(c,"c")
		HX_STACK_LINE(52)
		this->b->b->push(c);
	}
return null();
}


int BytesOutput_obj::writeBytes( ::haxe::io::Bytes buf,int pos,int len){
	HX_STACK_FRAME("haxe.io.BytesOutput","writeBytes",0x8a9057ce,"haxe.io.BytesOutput.writeBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesOutput.hx",56,0x507dd631)
	HX_STACK_THIS(this)
	HX_STACK_ARG(buf,"buf")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(61)
	{
		HX_STACK_LINE(61)
		::haxe::io::BytesBuffer _this = this->b;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(61)
		if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > buf->length))))){
			HX_STACK_LINE(61)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
		}
		HX_STACK_LINE(61)
		Array< unsigned char > b1 = _this->b;		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(61)
		Array< unsigned char > b2 = buf->b;		HX_STACK_VAR(b2,"b2");
		HX_STACK_LINE(61)
		{
			HX_STACK_LINE(61)
			int _g1 = pos;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(61)
			int _g = (pos + len);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(61)
			while((true)){
				HX_STACK_LINE(61)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(61)
					break;
				}
				HX_STACK_LINE(61)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(61)
				_this->b->push(b2->__get(i));
			}
		}
	}
	HX_STACK_LINE(63)
	return len;
}


::haxe::io::Bytes BytesOutput_obj::getBytes( ){
	HX_STACK_FRAME("haxe.io.BytesOutput","getBytes",0x9fe35837,"haxe.io.BytesOutput.getBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesOutput.hx",119,0x507dd631)
	HX_STACK_THIS(this)
	HX_STACK_LINE(119)
	return this->b->getBytes();
}


HX_DEFINE_DYNAMIC_FUNC0(BytesOutput_obj,getBytes,return )


BytesOutput_obj::BytesOutput_obj()
{
}

void BytesOutput_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BytesOutput);
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_END_CLASS();
}

void BytesOutput_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(b,"b");
}

Dynamic BytesOutput_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return get_length(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"writeByte") ) { return writeByte_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
		if (HX_FIELD_EQ(inName,"writeBytes") ) { return writeBytes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BytesOutput_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< ::haxe::io::BytesBuffer >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BytesOutput_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("length"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::io::BytesBuffer*/ ,(int)offsetof(BytesOutput_obj,b),HX_CSTRING("b")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("get_length"),
	HX_CSTRING("writeByte"),
	HX_CSTRING("writeBytes"),
	HX_CSTRING("getBytes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BytesOutput_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BytesOutput_obj::__mClass,"__mClass");
};

#endif

Class BytesOutput_obj::__mClass;

void BytesOutput_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.BytesOutput"), hx::TCanCast< BytesOutput_obj> ,sStaticFields,sMemberFields,
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

void BytesOutput_obj::__boot()
{
}

} // end namespace haxe
} // end namespace io
