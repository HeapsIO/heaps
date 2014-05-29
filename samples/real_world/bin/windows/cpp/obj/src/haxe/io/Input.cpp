#include <hxcpp.h>

#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesBuffer
#include <haxe/io/BytesBuffer.h>
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

Void Input_obj::__construct()
{
	return null();
}

//Input_obj::~Input_obj() { }

Dynamic Input_obj::__CreateEmpty() { return  new Input_obj; }
hx::ObjectPtr< Input_obj > Input_obj::__new()
{  hx::ObjectPtr< Input_obj > result = new Input_obj();
	result->__construct();
	return result;}

Dynamic Input_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Input_obj > result = new Input_obj();
	result->__construct();
	return result;}

int Input_obj::readByte( ){
	HX_STACK_FRAME("haxe.io.Input","readByte",0x4de8a3c2,"haxe.io.Input.readByte","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",37,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(39)
	HX_STACK_DO_THROW(HX_CSTRING("Not implemented"));
	HX_STACK_LINE(40)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readByte,return )

int Input_obj::readBytes( ::haxe::io::Bytes s,int pos,int len){
	HX_STACK_FRAME("haxe.io.Input","readBytes",0xdda6a671,"haxe.io.Input.readBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",46,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(47)
	int k = len;		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(48)
	Array< unsigned char > b = s->b;		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(49)
	if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > s->length))))){
		HX_STACK_LINE(50)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(51)
	while((true)){
		HX_STACK_LINE(51)
		if ((!(((k > (int)0))))){
			HX_STACK_LINE(51)
			break;
		}
		HX_STACK_LINE(57)
		b[pos] = this->readByte();
		HX_STACK_LINE(61)
		(pos)++;
		HX_STACK_LINE(62)
		(k)--;
	}
	HX_STACK_LINE(64)
	return len;
}


HX_DEFINE_DYNAMIC_FUNC3(Input_obj,readBytes,return )

Void Input_obj::close( ){
{
		HX_STACK_FRAME("haxe.io.Input","close",0xfc421af4,"haxe.io.Input.close","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",67,0xc02f5173)
		HX_STACK_THIS(this)
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,close,(void))

bool Input_obj::set_bigEndian( bool b){
	HX_STACK_FRAME("haxe.io.Input","set_bigEndian",0x96732a9a,"haxe.io.Input.set_bigEndian","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",70,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(71)
	this->bigEndian = b;
	HX_STACK_LINE(72)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Input_obj,set_bigEndian,return )

::haxe::io::Bytes Input_obj::readAll( Dynamic bufsize){
	HX_STACK_FRAME("haxe.io.Input","readAll",0xaed6e9a7,"haxe.io.Input.readAll","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",77,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_ARG(bufsize,"bufsize")
	HX_STACK_LINE(78)
	if (((bufsize == null()))){
		HX_STACK_LINE(82)
		bufsize = (int)16384;
	}
	HX_STACK_LINE(85)
	::haxe::io::Bytes buf = ::haxe::io::Bytes_obj::alloc(bufsize);		HX_STACK_VAR(buf,"buf");
	HX_STACK_LINE(86)
	::haxe::io::BytesBuffer total = ::haxe::io::BytesBuffer_obj::__new();		HX_STACK_VAR(total,"total");
	HX_STACK_LINE(87)
	try
	{
	HX_STACK_CATCHABLE(::haxe::io::Eof, 0);
	{
		HX_STACK_LINE(88)
		while((true)){
			HX_STACK_LINE(89)
			int len = this->readBytes(buf,(int)0,bufsize);		HX_STACK_VAR(len,"len");
			HX_STACK_LINE(90)
			if (((len == (int)0))){
				HX_STACK_LINE(91)
				HX_STACK_DO_THROW(::haxe::io::Error_obj::Blocked);
			}
			HX_STACK_LINE(92)
			{
				HX_STACK_LINE(92)
				if (((bool((len < (int)0)) || bool((len > buf->length))))){
					HX_STACK_LINE(92)
					HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
				}
				HX_STACK_LINE(92)
				Array< unsigned char > b1 = total->b;		HX_STACK_VAR(b1,"b1");
				HX_STACK_LINE(92)
				Array< unsigned char > b2 = buf->b;		HX_STACK_VAR(b2,"b2");
				HX_STACK_LINE(92)
				{
					HX_STACK_LINE(92)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(92)
					int _g = len;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(92)
					while((true)){
						HX_STACK_LINE(92)
						if ((!(((_g1 < _g))))){
							HX_STACK_LINE(92)
							break;
						}
						HX_STACK_LINE(92)
						int i = (_g1)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(92)
						total->b->push(b2->__get(i));
					}
				}
			}
		}
	}
	}
	catch(Dynamic __e){
		if (__e.IsClass< ::haxe::io::Eof >() ){
			HX_STACK_BEGIN_CATCH
			::haxe::io::Eof e = __e;{
			}
		}
		else {
		    HX_STACK_DO_THROW(__e);
		}
	}
	HX_STACK_LINE(96)
	return total->getBytes();
}


HX_DEFINE_DYNAMIC_FUNC1(Input_obj,readAll,return )

Void Input_obj::readFullBytes( ::haxe::io::Bytes s,int pos,int len){
{
		HX_STACK_FRAME("haxe.io.Input","readFullBytes",0x3db9a162,"haxe.io.Input.readFullBytes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",100,0xc02f5173)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(100)
		while((true)){
			HX_STACK_LINE(100)
			if ((!(((len > (int)0))))){
				HX_STACK_LINE(100)
				break;
			}
			HX_STACK_LINE(101)
			int k = this->readBytes(s,pos,len);		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(102)
			hx::AddEq(pos,k);
			HX_STACK_LINE(103)
			hx::SubEq(len,k);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Input_obj,readFullBytes,(void))

::haxe::io::Bytes Input_obj::read( int nbytes){
	HX_STACK_FRAME("haxe.io.Input","read",0x27b9839a,"haxe.io.Input.read","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",107,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_ARG(nbytes,"nbytes")
	HX_STACK_LINE(108)
	::haxe::io::Bytes s = ::haxe::io::Bytes_obj::alloc(nbytes);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(109)
	int p = (int)0;		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(110)
	while((true)){
		HX_STACK_LINE(110)
		if ((!(((nbytes > (int)0))))){
			HX_STACK_LINE(110)
			break;
		}
		HX_STACK_LINE(111)
		int k = this->readBytes(s,p,nbytes);		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(112)
		if (((k == (int)0))){
			HX_STACK_LINE(112)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::Blocked);
		}
		HX_STACK_LINE(113)
		hx::AddEq(p,k);
		HX_STACK_LINE(114)
		hx::SubEq(nbytes,k);
	}
	HX_STACK_LINE(116)
	return s;
}


HX_DEFINE_DYNAMIC_FUNC1(Input_obj,read,return )

::String Input_obj::readUntil( int end){
	HX_STACK_FRAME("haxe.io.Input","readUntil",0xc6fe56a4,"haxe.io.Input.readUntil","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",119,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_ARG(end,"end")
	HX_STACK_LINE(120)
	::StringBuf buf = ::StringBuf_obj::__new();		HX_STACK_VAR(buf,"buf");
	HX_STACK_LINE(121)
	int last;		HX_STACK_VAR(last,"last");
	HX_STACK_LINE(122)
	while((true)){
		HX_STACK_LINE(122)
		int _g = this->readByte();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(122)
		int _g1 = last = _g;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(122)
		if ((!(((_g1 != end))))){
			HX_STACK_LINE(122)
			break;
		}
		HX_STACK_LINE(123)
		::String _g2 = ::String::fromCharCode(last);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(123)
		buf->b->push(_g2);
	}
	HX_STACK_LINE(124)
	return buf->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC1(Input_obj,readUntil,return )

::String Input_obj::readLine( ){
	HX_STACK_FRAME("haxe.io.Input","readLine",0x54789cae,"haxe.io.Input.readLine","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",127,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(128)
	::StringBuf buf = ::StringBuf_obj::__new();		HX_STACK_VAR(buf,"buf");
	HX_STACK_LINE(129)
	int last;		HX_STACK_VAR(last,"last");
	HX_STACK_LINE(130)
	::String s;		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(131)
	try
	{
	HX_STACK_CATCHABLE(::haxe::io::Eof, 0);
	{
		HX_STACK_LINE(132)
		while((true)){
			HX_STACK_LINE(132)
			int _g = this->readByte();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(132)
			int _g1 = last = _g;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(132)
			if ((!(((_g1 != (int)10))))){
				HX_STACK_LINE(132)
				break;
			}
			HX_STACK_LINE(133)
			::String _g2 = ::String::fromCharCode(last);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(133)
			buf->b->push(_g2);
		}
		HX_STACK_LINE(134)
		::String _g3 = buf->b->join(HX_CSTRING(""));		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(134)
		s = _g3;
		HX_STACK_LINE(135)
		Dynamic _g4 = s.charCodeAt((s.length - (int)1));		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(135)
		if (((_g4 == (int)13))){
			HX_STACK_LINE(135)
			::String _g5 = s.substr((int)0,(int)-1);		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(135)
			s = _g5;
		}
	}
	}
	catch(Dynamic __e){
		if (__e.IsClass< ::haxe::io::Eof >() ){
			HX_STACK_BEGIN_CATCH
			::haxe::io::Eof e = __e;{
				HX_STACK_LINE(137)
				::String _g6 = buf->b->join(HX_CSTRING(""));		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(137)
				s = _g6;
				HX_STACK_LINE(138)
				if (((s.length == (int)0))){
					HX_STACK_LINE(139)
					HX_STACK_DO_THROW(e);
				}
			}
		}
		else {
		    HX_STACK_DO_THROW(__e);
		}
	}
	HX_STACK_LINE(141)
	return s;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readLine,return )

Float Input_obj::readFloat( ){
	HX_STACK_FRAME("haxe.io.Input","readFloat",0x22a563a2,"haxe.io.Input.readFloat","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",144,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(148)
	Array< unsigned char > _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(148)
	{
		HX_STACK_LINE(148)
		::haxe::io::Bytes _this = this->read((int)4);		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(148)
		_g = _this->b;
	}
	HX_STACK_LINE(148)
	return ::haxe::io::Input_obj::_float_of_bytes(_g,this->bigEndian);
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readFloat,return )

Float Input_obj::readDouble( ){
	HX_STACK_FRAME("haxe.io.Input","readDouble",0x1f86d24b,"haxe.io.Input.readDouble","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",198,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(202)
	Array< unsigned char > _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(202)
	{
		HX_STACK_LINE(202)
		::haxe::io::Bytes _this = this->read((int)8);		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(202)
		_g = _this->b;
	}
	HX_STACK_LINE(202)
	return ::haxe::io::Input_obj::_double_of_bytes(_g,this->bigEndian);
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readDouble,return )

int Input_obj::readInt8( ){
	HX_STACK_FRAME("haxe.io.Input","readInt8",0x5280c923,"haxe.io.Input.readInt8","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",271,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(272)
	int n = this->readByte();		HX_STACK_VAR(n,"n");
	HX_STACK_LINE(273)
	if (((n >= (int)128))){
		HX_STACK_LINE(274)
		return (n - (int)256);
	}
	HX_STACK_LINE(275)
	return n;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readInt8,return )

int Input_obj::readInt16( ){
	HX_STACK_FRAME("haxe.io.Input","readInt16",0xde2f2f9a,"haxe.io.Input.readInt16","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",278,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(279)
	int ch1 = this->readByte();		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(280)
	int ch2 = this->readByte();		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(281)
	int n;		HX_STACK_VAR(n,"n");
	HX_STACK_LINE(281)
	if ((this->bigEndian)){
		HX_STACK_LINE(281)
		n = (int(ch2) | int((int(ch1) << int((int)8))));
	}
	else{
		HX_STACK_LINE(281)
		n = (int(ch1) | int((int(ch2) << int((int)8))));
	}
	HX_STACK_LINE(282)
	if (((((int(n) & int((int)32768))) != (int)0))){
		HX_STACK_LINE(283)
		return (n - (int)65536);
	}
	HX_STACK_LINE(284)
	return n;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readInt16,return )

int Input_obj::readUInt16( ){
	HX_STACK_FRAME("haxe.io.Input","readUInt16",0x05cae019,"haxe.io.Input.readUInt16","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",287,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(288)
	int ch1 = this->readByte();		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(289)
	int ch2 = this->readByte();		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(290)
	if ((this->bigEndian)){
		HX_STACK_LINE(290)
		return (int(ch2) | int((int(ch1) << int((int)8))));
	}
	else{
		HX_STACK_LINE(290)
		return (int(ch1) | int((int(ch2) << int((int)8))));
	}
	HX_STACK_LINE(290)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readUInt16,return )

int Input_obj::readInt24( ){
	HX_STACK_FRAME("haxe.io.Input","readInt24",0xde2f3077,"haxe.io.Input.readInt24","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",293,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(294)
	int ch1 = this->readByte();		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(295)
	int ch2 = this->readByte();		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(296)
	int ch3 = this->readByte();		HX_STACK_VAR(ch3,"ch3");
	HX_STACK_LINE(297)
	int n;		HX_STACK_VAR(n,"n");
	HX_STACK_LINE(297)
	if ((this->bigEndian)){
		HX_STACK_LINE(297)
		n = (int((int(ch3) | int((int(ch2) << int((int)8))))) | int((int(ch1) << int((int)16))));
	}
	else{
		HX_STACK_LINE(297)
		n = (int((int(ch1) | int((int(ch2) << int((int)8))))) | int((int(ch3) << int((int)16))));
	}
	HX_STACK_LINE(298)
	if (((((int(n) & int((int)8388608))) != (int)0))){
		HX_STACK_LINE(299)
		return (n - (int)16777216);
	}
	HX_STACK_LINE(300)
	return n;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readInt24,return )

int Input_obj::readUInt24( ){
	HX_STACK_FRAME("haxe.io.Input","readUInt24",0x05cae0f6,"haxe.io.Input.readUInt24","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",303,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(304)
	int ch1 = this->readByte();		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(305)
	int ch2 = this->readByte();		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(306)
	int ch3 = this->readByte();		HX_STACK_VAR(ch3,"ch3");
	HX_STACK_LINE(307)
	if ((this->bigEndian)){
		HX_STACK_LINE(307)
		return (int((int(ch3) | int((int(ch2) << int((int)8))))) | int((int(ch1) << int((int)16))));
	}
	else{
		HX_STACK_LINE(307)
		return (int((int(ch1) | int((int(ch2) << int((int)8))))) | int((int(ch3) << int((int)16))));
	}
	HX_STACK_LINE(307)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readUInt24,return )

int Input_obj::readInt32( ){
	HX_STACK_FRAME("haxe.io.Input","readInt32",0xde2f3154,"haxe.io.Input.readInt32","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",310,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_LINE(311)
	int ch1 = this->readByte();		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(312)
	int ch2 = this->readByte();		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(313)
	int ch3 = this->readByte();		HX_STACK_VAR(ch3,"ch3");
	HX_STACK_LINE(314)
	int ch4 = this->readByte();		HX_STACK_VAR(ch4,"ch4");
	HX_STACK_LINE(322)
	if ((this->bigEndian)){
		HX_STACK_LINE(322)
		return (int((int((int(ch4) | int((int(ch3) << int((int)8))))) | int((int(ch2) << int((int)16))))) | int((int(ch1) << int((int)24))));
	}
	else{
		HX_STACK_LINE(322)
		return (int((int((int(ch1) | int((int(ch2) << int((int)8))))) | int((int(ch3) << int((int)16))))) | int((int(ch4) << int((int)24))));
	}
	HX_STACK_LINE(322)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(Input_obj,readInt32,return )

::String Input_obj::readString( int len){
	HX_STACK_FRAME("haxe.io.Input","readString",0xfdebd00b,"haxe.io.Input.readString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Input.hx",326,0xc02f5173)
	HX_STACK_THIS(this)
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(327)
	::haxe::io::Bytes b = ::haxe::io::Bytes_obj::alloc(len);		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(328)
	this->readFullBytes(b,(int)0,len);
	HX_STACK_LINE(332)
	return b->toString();
}


HX_DEFINE_DYNAMIC_FUNC1(Input_obj,readString,return )

Dynamic Input_obj::_float_of_bytes;

Dynamic Input_obj::_double_of_bytes;


Input_obj::Input_obj()
{
}

Dynamic Input_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"read") ) { return read_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"close") ) { return close_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"readAll") ) { return readAll_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		if (HX_FIELD_EQ(inName,"readLine") ) { return readLine_dyn(); }
		if (HX_FIELD_EQ(inName,"readInt8") ) { return readInt8_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"bigEndian") ) { return bigEndian; }
		if (HX_FIELD_EQ(inName,"readBytes") ) { return readBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"readUntil") ) { return readUntil_dyn(); }
		if (HX_FIELD_EQ(inName,"readFloat") ) { return readFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"readInt16") ) { return readInt16_dyn(); }
		if (HX_FIELD_EQ(inName,"readInt24") ) { return readInt24_dyn(); }
		if (HX_FIELD_EQ(inName,"readInt32") ) { return readInt32_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"readDouble") ) { return readDouble_dyn(); }
		if (HX_FIELD_EQ(inName,"readUInt16") ) { return readUInt16_dyn(); }
		if (HX_FIELD_EQ(inName,"readUInt24") ) { return readUInt24_dyn(); }
		if (HX_FIELD_EQ(inName,"readString") ) { return readString_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"set_bigEndian") ) { return set_bigEndian_dyn(); }
		if (HX_FIELD_EQ(inName,"readFullBytes") ) { return readFullBytes_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_float_of_bytes") ) { return _float_of_bytes; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"_double_of_bytes") ) { return _double_of_bytes; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Input_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"bigEndian") ) { if (inCallProp) return set_bigEndian(inValue);bigEndian=inValue.Cast< bool >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_float_of_bytes") ) { _float_of_bytes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"_double_of_bytes") ) { _double_of_bytes=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Input_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bigEndian"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_float_of_bytes"),
	HX_CSTRING("_double_of_bytes"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(Input_obj,bigEndian),HX_CSTRING("bigEndian")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bigEndian"),
	HX_CSTRING("readByte"),
	HX_CSTRING("readBytes"),
	HX_CSTRING("close"),
	HX_CSTRING("set_bigEndian"),
	HX_CSTRING("readAll"),
	HX_CSTRING("readFullBytes"),
	HX_CSTRING("read"),
	HX_CSTRING("readUntil"),
	HX_CSTRING("readLine"),
	HX_CSTRING("readFloat"),
	HX_CSTRING("readDouble"),
	HX_CSTRING("readInt8"),
	HX_CSTRING("readInt16"),
	HX_CSTRING("readUInt16"),
	HX_CSTRING("readInt24"),
	HX_CSTRING("readUInt24"),
	HX_CSTRING("readInt32"),
	HX_CSTRING("readString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Input_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Input_obj::_float_of_bytes,"_float_of_bytes");
	HX_MARK_MEMBER_NAME(Input_obj::_double_of_bytes,"_double_of_bytes");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Input_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Input_obj::_float_of_bytes,"_float_of_bytes");
	HX_VISIT_MEMBER_NAME(Input_obj::_double_of_bytes,"_double_of_bytes");
};

#endif

Class Input_obj::__mClass;

void Input_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.Input"), hx::TCanCast< Input_obj> ,sStaticFields,sMemberFields,
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

void Input_obj::__boot()
{
	_float_of_bytes= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("float_of_bytes"),(int)2);
	_double_of_bytes= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("double_of_bytes"),(int)2);
}

} // end namespace haxe
} // end namespace io
