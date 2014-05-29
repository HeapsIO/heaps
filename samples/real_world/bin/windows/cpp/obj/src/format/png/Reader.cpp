#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_format_png_Chunk
#include <format/png/Chunk.h>
#endif
#ifndef INCLUDED_format_png_Color
#include <format/png/Color.h>
#endif
#ifndef INCLUDED_format_png_Reader
#include <format/png/Reader.h>
#endif
#ifndef INCLUDED_haxe_crypto_Crc32
#include <haxe/crypto/Crc32.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesInput
#include <haxe/io/BytesInput.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
namespace format{
namespace png{

Void Reader_obj::__construct(::haxe::io::Input i)
{
HX_STACK_FRAME("format.png.Reader","new",0x8a4e4ad1,"format.png.Reader.new","format/png/Reader.hx",35,0xe65084fd)
HX_STACK_THIS(this)
HX_STACK_ARG(i,"i")
{
	HX_STACK_LINE(36)
	this->i = i;
	HX_STACK_LINE(37)
	i->set_bigEndian(true);
	HX_STACK_LINE(38)
	this->checkCRC = true;
}
;
	return null();
}

//Reader_obj::~Reader_obj() { }

Dynamic Reader_obj::__CreateEmpty() { return  new Reader_obj; }
hx::ObjectPtr< Reader_obj > Reader_obj::__new(::haxe::io::Input i)
{  hx::ObjectPtr< Reader_obj > result = new Reader_obj();
	result->__construct(i);
	return result;}

Dynamic Reader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Reader_obj > result = new Reader_obj();
	result->__construct(inArgs[0]);
	return result;}

::List Reader_obj::read( ){
	HX_STACK_FRAME("format.png.Reader","read",0x7cd7f3c5,"format.png.Reader.read","format/png/Reader.hx",41,0xe65084fd)
	HX_STACK_THIS(this)
	HX_STACK_LINE(42)
	{
		HX_STACK_LINE(42)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(42)
		Array< int > _g1 = Array_obj< int >::__new().Add((int)137).Add((int)80).Add((int)78).Add((int)71).Add((int)13).Add((int)10).Add((int)26).Add((int)10);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(42)
		while((true)){
			HX_STACK_LINE(42)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(42)
				break;
			}
			HX_STACK_LINE(42)
			int b = _g1->__get(_g);		HX_STACK_VAR(b,"b");
			HX_STACK_LINE(42)
			++(_g);
			HX_STACK_LINE(43)
			int _g2 = this->i->readByte();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(43)
			if (((_g2 != b))){
				HX_STACK_LINE(44)
				HX_STACK_DO_THROW(HX_CSTRING("Invalid header"));
			}
		}
	}
	HX_STACK_LINE(46)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(47)
	while((true)){
		HX_STACK_LINE(48)
		::format::png::Chunk c = this->readChunk();		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(49)
		l->add(c);
		HX_STACK_LINE(50)
		if (((c == ::format::png::Chunk_obj::CEnd))){
			HX_STACK_LINE(51)
			break;
		}
	}
	HX_STACK_LINE(53)
	return l;
}


HX_DEFINE_DYNAMIC_FUNC0(Reader_obj,read,return )

Dynamic Reader_obj::readHeader( ::haxe::io::Input i){
	HX_STACK_FRAME("format.png.Reader","readHeader",0x49691332,"format.png.Reader.readHeader","format/png/Reader.hx",56,0xe65084fd)
	HX_STACK_THIS(this)
	HX_STACK_ARG(i,"i")
	HX_STACK_LINE(57)
	i->set_bigEndian(true);
	HX_STACK_LINE(59)
	int width = i->readInt32();		HX_STACK_VAR(width,"width");
	HX_STACK_LINE(60)
	int height = i->readInt32();		HX_STACK_VAR(height,"height");
	HX_STACK_LINE(65)
	int colbits = i->readByte();		HX_STACK_VAR(colbits,"colbits");
	HX_STACK_LINE(66)
	int color = i->readByte();		HX_STACK_VAR(color,"color");
	HX_STACK_LINE(67)
	::format::png::Color color1;		HX_STACK_VAR(color1,"color1");
	HX_STACK_LINE(67)
	switch( (int)(color)){
		case (int)0: {
			HX_STACK_LINE(68)
			color1 = ::format::png::Color_obj::ColGrey(false);
		}
		;break;
		case (int)2: {
			HX_STACK_LINE(69)
			color1 = ::format::png::Color_obj::ColTrue(false);
		}
		;break;
		case (int)3: {
			HX_STACK_LINE(70)
			color1 = ::format::png::Color_obj::ColIndexed;
		}
		;break;
		case (int)4: {
			HX_STACK_LINE(71)
			color1 = ::format::png::Color_obj::ColGrey(true);
		}
		;break;
		case (int)6: {
			HX_STACK_LINE(72)
			color1 = ::format::png::Color_obj::ColTrue(true);
		}
		;break;
		default: {
			HX_STACK_LINE(73)
			HX_STACK_DO_THROW((((HX_CSTRING("Unknown color model ") + color) + HX_CSTRING(":")) + colbits));
		}
	}
	HX_STACK_LINE(75)
	int compress = i->readByte();		HX_STACK_VAR(compress,"compress");
	HX_STACK_LINE(76)
	int filter = i->readByte();		HX_STACK_VAR(filter,"filter");
	HX_STACK_LINE(77)
	if (((bool((compress != (int)0)) || bool((filter != (int)0))))){
		HX_STACK_LINE(78)
		HX_STACK_DO_THROW(HX_CSTRING("Invalid header"));
	}
	HX_STACK_LINE(79)
	int interlace = i->readByte();		HX_STACK_VAR(interlace,"interlace");
	HX_STACK_LINE(80)
	if (((bool((interlace != (int)0)) && bool((interlace != (int)1))))){
		HX_STACK_LINE(81)
		HX_STACK_DO_THROW(HX_CSTRING("Invalid header"));
	}
	struct _Function_1_1{
		inline static Dynamic Block( int &width,int &interlace,::format::png::Color &color1,int &colbits,int &height){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","format/png/Reader.hx",82,0xe65084fd)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , width,false);
				__result->Add(HX_CSTRING("height") , height,false);
				__result->Add(HX_CSTRING("colbits") , colbits,false);
				__result->Add(HX_CSTRING("color") , color1,false);
				__result->Add(HX_CSTRING("interlaced") , (interlace == (int)1),false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(82)
	return _Function_1_1::Block(width,interlace,color1,colbits,height);
}


HX_DEFINE_DYNAMIC_FUNC1(Reader_obj,readHeader,return )

::format::png::Chunk Reader_obj::readChunk( ){
	HX_STACK_FRAME("format.png.Reader","readChunk",0xedb57868,"format.png.Reader.readChunk","format/png/Reader.hx",91,0xe65084fd)
	HX_STACK_THIS(this)
	HX_STACK_LINE(92)
	int dataLen = this->i->readInt32();		HX_STACK_VAR(dataLen,"dataLen");
	HX_STACK_LINE(93)
	::String id = this->i->readString((int)4);		HX_STACK_VAR(id,"id");
	HX_STACK_LINE(94)
	::haxe::io::Bytes data = this->i->read(dataLen);		HX_STACK_VAR(data,"data");
	HX_STACK_LINE(95)
	int crc = this->i->readInt32();		HX_STACK_VAR(crc,"crc");
	HX_STACK_LINE(96)
	if ((this->checkCRC)){
		HX_STACK_LINE(98)
		::haxe::crypto::Crc32 c = ::haxe::crypto::Crc32_obj::__new();		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(99)
		{
			HX_STACK_LINE(99)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(99)
			while((true)){
				HX_STACK_LINE(99)
				if ((!(((_g < (int)4))))){
					HX_STACK_LINE(99)
					break;
				}
				HX_STACK_LINE(99)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(100)
				Dynamic _g1 = id.charCodeAt(i);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(100)
				c->byte(_g1);
			}
		}
		HX_STACK_LINE(101)
		c->update(data,(int)0,data->length);
		HX_STACK_LINE(102)
		int _g1 = c->get();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(102)
		if (((_g1 != crc))){
			HX_STACK_LINE(103)
			HX_STACK_DO_THROW(HX_CSTRING("CRC check failure"));
		}
	}
	HX_STACK_LINE(113)
	::String _switch_1 = (id);
	if (  ( _switch_1==HX_CSTRING("IEND"))){
		HX_STACK_LINE(114)
		return ::format::png::Chunk_obj::CEnd;
	}
	else if (  ( _switch_1==HX_CSTRING("IHDR"))){
		HX_STACK_LINE(115)
		::haxe::io::BytesInput _g2 = ::haxe::io::BytesInput_obj::__new(data,null(),null());		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(115)
		Dynamic _g3 = this->readHeader(_g2);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(115)
		return ::format::png::Chunk_obj::CHeader(_g3);
	}
	else if (  ( _switch_1==HX_CSTRING("IDAT"))){
		HX_STACK_LINE(116)
		return ::format::png::Chunk_obj::CData(data);
	}
	else if (  ( _switch_1==HX_CSTRING("PLTE"))){
		HX_STACK_LINE(117)
		return ::format::png::Chunk_obj::CPalette(data);
	}
	else  {
		HX_STACK_LINE(118)
		return ::format::png::Chunk_obj::CUnknown(id,data);
	}
;
;
	HX_STACK_LINE(113)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Reader_obj,readChunk,return )


Reader_obj::Reader_obj()
{
}

void Reader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Reader);
	HX_MARK_MEMBER_NAME(i,"i");
	HX_MARK_MEMBER_NAME(checkCRC,"checkCRC");
	HX_MARK_END_CLASS();
}

void Reader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(i,"i");
	HX_VISIT_MEMBER_NAME(checkCRC,"checkCRC");
}

Dynamic Reader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { return i; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"read") ) { return read_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"checkCRC") ) { return checkCRC; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"readChunk") ) { return readChunk_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"readHeader") ) { return readHeader_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Reader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { i=inValue.Cast< ::haxe::io::Input >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"checkCRC") ) { checkCRC=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Reader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("i"));
	outFields->push(HX_CSTRING("checkCRC"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::io::Input*/ ,(int)offsetof(Reader_obj,i),HX_CSTRING("i")},
	{hx::fsBool,(int)offsetof(Reader_obj,checkCRC),HX_CSTRING("checkCRC")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("i"),
	HX_CSTRING("checkCRC"),
	HX_CSTRING("read"),
	HX_CSTRING("readHeader"),
	HX_CSTRING("readChunk"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Reader_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Reader_obj::__mClass,"__mClass");
};

#endif

Class Reader_obj::__mClass;

void Reader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.png.Reader"), hx::TCanCast< Reader_obj> ,sStaticFields,sMemberFields,
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

void Reader_obj::__boot()
{
}

} // end namespace format
} // end namespace png
