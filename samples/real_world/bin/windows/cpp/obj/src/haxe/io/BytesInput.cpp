#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesInput
#include <haxe/io/BytesInput.h>
#endif
#ifndef INCLUDED_haxe_io_Eof
#include <haxe/io/Eof.h>
#endif
#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
namespace haxe{
namespace io{

Void BytesInput_obj::__construct(::haxe::io::Bytes b,Dynamic pos,Dynamic len)
{
HX_STACK_FRAME("haxe.io.BytesInput","new",0x7fa18571,"haxe.io.BytesInput.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesInput.hx",38,0xa9366ba0)
HX_STACK_THIS(this)
HX_STACK_ARG(b,"b")
HX_STACK_ARG(pos,"pos")
HX_STACK_ARG(len,"len")
{
	HX_STACK_LINE(39)
	if (((pos == null()))){
		HX_STACK_LINE(39)
		pos = (int)0;
	}
	HX_STACK_LINE(40)
	if (((len == null()))){
		HX_STACK_LINE(40)
		len = (b->length - pos);
	}
	HX_STACK_LINE(41)
	if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > b->length))))){
		HX_STACK_LINE(41)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(53)
	this->b = b->b;
	HX_STACK_LINE(54)
	this->pos = pos;
	HX_STACK_LINE(55)
	this->len = len;
	HX_STACK_LINE(56)
	this->totlen = len;
}
;
	return null();
}

//BytesInput_obj::~BytesInput_obj() { }

Dynamic BytesInput_obj::__CreateEmpty() { return  new BytesInput_obj; }
hx::ObjectPtr< BytesInput_obj > BytesInput_obj::__new(::haxe::io::Bytes b,Dynamic pos,Dynamic len)
{  hx::ObjectPtr< BytesInput_obj > result = new BytesInput_obj();
	result->__construct(b,pos,len);
	return result;}

Dynamic BytesInput_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BytesInput_obj > result = new BytesInput_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

int BytesInput_obj::get_position( ){
	HX_STACK_FRAME("haxe.io.BytesInput","get_position",0x9ad9f581,"haxe.io.BytesInput.get_position","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesInput.hx",64,0xa9366ba0)
	HX_STACK_THIS(this)
	HX_STACK_LINE(64)
	return this->pos;
}


HX_DEFINE_DYNAMIC_FUNC0(BytesInput_obj,get_position,return )

int BytesInput_obj::get_length( ){
	HX_STACK_FRAME("haxe.io.BytesInput","get_length",0xbaeb83be,"haxe.io.BytesInput.get_length","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesInput.hx",72,0xa9366ba0)
	HX_STACK_THIS(this)
	HX_STACK_LINE(72)
	return this->totlen;
}


HX_DEFINE_DYNAMIC_FUNC0(BytesInput_obj,get_length,return )

int BytesInput_obj::set_position( int p){
	HX_STACK_FRAME("haxe.io.BytesInput","set_position",0xafd318f5,"haxe.io.BytesInput.set_position","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesInput.hx",76,0xa9366ba0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(77)
	if (((p < (int)0))){
		HX_STACK_LINE(77)
		p = (int)0;
	}
	else{
		HX_STACK_LINE(78)
		if (((p > this->totlen))){
			HX_STACK_LINE(78)
			p = this->totlen;
		}
	}
	HX_STACK_LINE(82)
	this->len = (this->totlen - p);
	HX_STACK_LINE(83)
	return this->pos = p;
}


HX_DEFINE_DYNAMIC_FUNC1(BytesInput_obj,set_position,return )

int BytesInput_obj::readByte( ){
	HX_STACK_FRAME("haxe.io.BytesInput","readByte",0xb70e46cd,"haxe.io.BytesInput.readByte","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesInput.hx",87,0xa9366ba0)
	HX_STACK_THIS(this)
	HX_STACK_LINE(91)
	if (((this->len == (int)0))){
		HX_STACK_LINE(92)
		HX_STACK_DO_THROW(::haxe::io::Eof_obj::__new());
	}
	HX_STACK_LINE(93)
	(this->len)--;
	HX_STACK_LINE(99)
	int _g = (this->pos)++;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(99)
	return this->b->__get(_g);
}


int BytesInput_obj::readBytes( ::haxe::io::Bytes buf,int pos,int len){
	HX_STACK_FRAME("haxe.io.BytesInput","readBytes",0x756fad06,"haxe.io.BytesInput.readBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/BytesInput.hx",108,0xa9366ba0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(buf,"buf")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(110)
	if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > buf->length))))){
		HX_STACK_LINE(111)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(134)
	if (((bool((this->len == (int)0)) && bool((len > (int)0))))){
		HX_STACK_LINE(135)
		HX_STACK_DO_THROW(::haxe::io::Eof_obj::__new());
	}
	HX_STACK_LINE(136)
	if (((this->len < len))){
		HX_STACK_LINE(137)
		len = this->len;
	}
	HX_STACK_LINE(143)
	Array< unsigned char > b1 = this->b;		HX_STACK_VAR(b1,"b1");
	HX_STACK_LINE(144)
	Array< unsigned char > b2 = buf->b;		HX_STACK_VAR(b2,"b2");
	HX_STACK_LINE(145)
	{
		HX_STACK_LINE(145)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(145)
		while((true)){
			HX_STACK_LINE(145)
			if ((!(((_g < len))))){
				HX_STACK_LINE(145)
				break;
			}
			HX_STACK_LINE(145)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(146)
			b2[(pos + i)] = b1->__get((this->pos + i));
		}
	}
	HX_STACK_LINE(148)
	hx::AddEq(this->pos,len);
	HX_STACK_LINE(149)
	hx::SubEq(this->len,len);
	HX_STACK_LINE(151)
	return len;
}



BytesInput_obj::BytesInput_obj()
{
}

void BytesInput_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BytesInput);
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_MEMBER_NAME(len,"len");
	HX_MARK_MEMBER_NAME(totlen,"totlen");
	HX_MARK_END_CLASS();
}

void BytesInput_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(b,"b");
	HX_VISIT_MEMBER_NAME(pos,"pos");
	HX_VISIT_MEMBER_NAME(len,"len");
	HX_VISIT_MEMBER_NAME(totlen,"totlen");
}

Dynamic BytesInput_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		if (HX_FIELD_EQ(inName,"len") ) { return len; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"totlen") ) { return totlen; }
		if (HX_FIELD_EQ(inName,"length") ) { return get_length(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"position") ) { return get_position(); }
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"readBytes") ) { return readBytes_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"get_position") ) { return get_position_dyn(); }
		if (HX_FIELD_EQ(inName,"set_position") ) { return set_position_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BytesInput_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< Array< unsigned char > >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"len") ) { len=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"totlen") ) { totlen=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"position") ) { return set_position(inValue); }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BytesInput_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("pos"));
	outFields->push(HX_CSTRING("len"));
	outFields->push(HX_CSTRING("totlen"));
	outFields->push(HX_CSTRING("position"));
	outFields->push(HX_CSTRING("length"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< unsigned char >*/ ,(int)offsetof(BytesInput_obj,b),HX_CSTRING("b")},
	{hx::fsInt,(int)offsetof(BytesInput_obj,pos),HX_CSTRING("pos")},
	{hx::fsInt,(int)offsetof(BytesInput_obj,len),HX_CSTRING("len")},
	{hx::fsInt,(int)offsetof(BytesInput_obj,totlen),HX_CSTRING("totlen")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("pos"),
	HX_CSTRING("len"),
	HX_CSTRING("totlen"),
	HX_CSTRING("get_position"),
	HX_CSTRING("get_length"),
	HX_CSTRING("set_position"),
	HX_CSTRING("readByte"),
	HX_CSTRING("readBytes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BytesInput_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BytesInput_obj::__mClass,"__mClass");
};

#endif

Class BytesInput_obj::__mClass;

void BytesInput_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.BytesInput"), hx::TCanCast< BytesInput_obj> ,sStaticFields,sMemberFields,
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

void BytesInput_obj::__boot()
{
}

} // end namespace haxe
} // end namespace io
