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

Void BytesBuffer_obj::__construct()
{
HX_STACK_FRAME("haxe.io.BytesBuffer","new",0x022790dd,"haxe.io.BytesBuffer.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",45,0x1cc1b192)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(54)
	Array< unsigned char > _g = Array_obj< unsigned char >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(54)
	this->b = _g;
}
;
	return null();
}

//BytesBuffer_obj::~BytesBuffer_obj() { }

Dynamic BytesBuffer_obj::__CreateEmpty() { return  new BytesBuffer_obj; }
hx::ObjectPtr< BytesBuffer_obj > BytesBuffer_obj::__new()
{  hx::ObjectPtr< BytesBuffer_obj > result = new BytesBuffer_obj();
	result->__construct();
	return result;}

Dynamic BytesBuffer_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BytesBuffer_obj > result = new BytesBuffer_obj();
	result->__construct();
	return result;}

int BytesBuffer_obj::get_length( ){
	HX_STACK_FRAME("haxe.io.BytesBuffer","get_length",0x8154fdd2,"haxe.io.BytesBuffer.get_length","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",72,0x1cc1b192)
	HX_STACK_THIS(this)
	HX_STACK_LINE(72)
	return this->b->length;
}


HX_DEFINE_DYNAMIC_FUNC0(BytesBuffer_obj,get_length,return )

Void BytesBuffer_obj::addByte( int byte){
{
		HX_STACK_FRAME("haxe.io.BytesBuffer","addByte",0x4d2aa4c6,"haxe.io.BytesBuffer.addByte","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",84,0x1cc1b192)
		HX_STACK_THIS(this)
		HX_STACK_ARG(byte,"byte")
		HX_STACK_LINE(84)
		this->b->push(byte);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_obj,addByte,(void))

Void BytesBuffer_obj::add( ::haxe::io::Bytes src){
{
		HX_STACK_FRAME("haxe.io.BytesBuffer","add",0x021db29e,"haxe.io.BytesBuffer.add","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",94,0x1cc1b192)
		HX_STACK_THIS(this)
		HX_STACK_ARG(src,"src")
		HX_STACK_LINE(106)
		Array< unsigned char > b1 = this->b;		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(107)
		Array< unsigned char > b2 = src->b;		HX_STACK_VAR(b2,"b2");
		HX_STACK_LINE(108)
		{
			HX_STACK_LINE(108)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(108)
			int _g = src->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(108)
			while((true)){
				HX_STACK_LINE(108)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(108)
					break;
				}
				HX_STACK_LINE(108)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(109)
				this->b->push(b2->__get(i));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_obj,add,(void))

Void BytesBuffer_obj::addString( ::String v){
{
		HX_STACK_FRAME("haxe.io.BytesBuffer","addString",0xd2731a0f,"haxe.io.BytesBuffer.addString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",119,0x1cc1b192)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(119)
		::haxe::io::Bytes src = ::haxe::io::Bytes_obj::ofString(v);		HX_STACK_VAR(src,"src");
		HX_STACK_LINE(119)
		Array< unsigned char > b1 = this->b;		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(119)
		Array< unsigned char > b2 = src->b;		HX_STACK_VAR(b2,"b2");
		HX_STACK_LINE(119)
		{
			HX_STACK_LINE(119)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(119)
			int _g = src->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(119)
			while((true)){
				HX_STACK_LINE(119)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(119)
					break;
				}
				HX_STACK_LINE(119)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(119)
				this->b->push(b2->__get(i));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_obj,addString,(void))

Void BytesBuffer_obj::addFloat( Float v){
{
		HX_STACK_FRAME("haxe.io.BytesBuffer","addFloat",0x7d24461e,"haxe.io.BytesBuffer.addFloat","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",123,0x1cc1b192)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(129)
		::haxe::io::BytesOutput b = ::haxe::io::BytesOutput_obj::__new();		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(130)
		b->writeFloat(v);
		HX_STACK_LINE(131)
		{
			HX_STACK_LINE(131)
			::haxe::io::Bytes src = b->getBytes();		HX_STACK_VAR(src,"src");
			HX_STACK_LINE(131)
			Array< unsigned char > b1 = this->b;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(131)
			Array< unsigned char > b2 = src->b;		HX_STACK_VAR(b2,"b2");
			HX_STACK_LINE(131)
			{
				HX_STACK_LINE(131)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(131)
				int _g = src->length;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(131)
				while((true)){
					HX_STACK_LINE(131)
					if ((!(((_g1 < _g))))){
						HX_STACK_LINE(131)
						break;
					}
					HX_STACK_LINE(131)
					int i = (_g1)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(131)
					this->b->push(b2->__get(i));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_obj,addFloat,(void))

Void BytesBuffer_obj::addDouble( Float v){
{
		HX_STACK_FRAME("haxe.io.BytesBuffer","addDouble",0xf40e1c4f,"haxe.io.BytesBuffer.addDouble","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",135,0x1cc1b192)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(141)
		::haxe::io::BytesOutput b = ::haxe::io::BytesOutput_obj::__new();		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(142)
		b->writeDouble(v);
		HX_STACK_LINE(143)
		{
			HX_STACK_LINE(143)
			::haxe::io::Bytes src = b->getBytes();		HX_STACK_VAR(src,"src");
			HX_STACK_LINE(143)
			Array< unsigned char > b1 = this->b;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(143)
			Array< unsigned char > b2 = src->b;		HX_STACK_VAR(b2,"b2");
			HX_STACK_LINE(143)
			{
				HX_STACK_LINE(143)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(143)
				int _g = src->length;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(143)
				while((true)){
					HX_STACK_LINE(143)
					if ((!(((_g1 < _g))))){
						HX_STACK_LINE(143)
						break;
					}
					HX_STACK_LINE(143)
					int i = (_g1)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(143)
					this->b->push(b2->__get(i));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BytesBuffer_obj,addDouble,(void))

Void BytesBuffer_obj::addBytes( ::haxe::io::Bytes src,int pos,int len){
{
		HX_STACK_FRAME("haxe.io.BytesBuffer","addBytes",0x382588ed,"haxe.io.BytesBuffer.addBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",147,0x1cc1b192)
		HX_STACK_THIS(this)
		HX_STACK_ARG(src,"src")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(149)
		if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > src->length))))){
			HX_STACK_LINE(149)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
		}
		HX_STACK_LINE(162)
		Array< unsigned char > b1 = this->b;		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(163)
		Array< unsigned char > b2 = src->b;		HX_STACK_VAR(b2,"b2");
		HX_STACK_LINE(164)
		{
			HX_STACK_LINE(164)
			int _g1 = pos;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(164)
			int _g = (pos + len);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(164)
			while((true)){
				HX_STACK_LINE(164)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(164)
					break;
				}
				HX_STACK_LINE(164)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(165)
				this->b->push(b2->__get(i));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(BytesBuffer_obj,addBytes,(void))

::haxe::io::Bytes BytesBuffer_obj::getBytes( ){
	HX_STACK_FRAME("haxe.io.BytesBuffer","getBytes",0x1e9f7258,"haxe.io.BytesBuffer.getBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesBuffer.hx",173,0x1cc1b192)
	HX_STACK_THIS(this)
	HX_STACK_LINE(189)
	::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::__new(this->b->length,this->b);		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(191)
	this->b = null();
	HX_STACK_LINE(192)
	return bytes;
}


HX_DEFINE_DYNAMIC_FUNC0(BytesBuffer_obj,getBytes,return )


BytesBuffer_obj::BytesBuffer_obj()
{
}

void BytesBuffer_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BytesBuffer);
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_END_CLASS();
}

void BytesBuffer_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(b,"b");
}

Dynamic BytesBuffer_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return get_length(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"addByte") ) { return addByte_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"addFloat") ) { return addFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"addBytes") ) { return addBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"addString") ) { return addString_dyn(); }
		if (HX_FIELD_EQ(inName,"addDouble") ) { return addDouble_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BytesBuffer_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< Array< unsigned char > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BytesBuffer_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("length"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< unsigned char >*/ ,(int)offsetof(BytesBuffer_obj,b),HX_CSTRING("b")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("get_length"),
	HX_CSTRING("addByte"),
	HX_CSTRING("add"),
	HX_CSTRING("addString"),
	HX_CSTRING("addFloat"),
	HX_CSTRING("addDouble"),
	HX_CSTRING("addBytes"),
	HX_CSTRING("getBytes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BytesBuffer_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BytesBuffer_obj::__mClass,"__mClass");
};

#endif

Class BytesBuffer_obj::__mClass;

void BytesBuffer_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.BytesBuffer"), hx::TCanCast< BytesBuffer_obj> ,sStaticFields,sMemberFields,
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

void BytesBuffer_obj::__boot()
{
}

} // end namespace haxe
} // end namespace io
