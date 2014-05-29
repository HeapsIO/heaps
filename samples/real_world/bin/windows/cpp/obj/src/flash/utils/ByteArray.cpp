#include <hxcpp.h>

#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_errors_EOFError
#include <flash/errors/EOFError.h>
#endif
#ifndef INCLUDED_flash_errors_Error
#include <flash/errors/Error.h>
#endif
#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_CompressionAlgorithm
#include <flash/utils/CompressionAlgorithm.h>
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
#ifndef INCLUDED_haxe_zip_Compress
#include <haxe/zip/Compress.h>
#endif
#ifndef INCLUDED_haxe_zip_Uncompress
#include <haxe/zip/Uncompress.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace flash{
namespace utils{

Void ByteArray_obj::__construct(hx::Null< int >  __o_size)
{
HX_STACK_FRAME("flash.utils.ByteArray","new",0xd3dfba08,"flash.utils.ByteArray.new","flash/utils/ByteArray.hx",37,0xfb64f02a)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_size,"size")
int size = __o_size.Default(0);
{
	HX_STACK_LINE(39)
	this->bigEndian = true;
	HX_STACK_LINE(40)
	this->position = (int)0;
	HX_STACK_LINE(42)
	if (((size >= (int)0))){
		HX_STACK_LINE(52)
		Array< unsigned char > data = Array_obj< unsigned char >::__new();		HX_STACK_VAR(data,"data");
		HX_STACK_LINE(54)
		if (((size > (int)0))){
			HX_STACK_LINE(56)
			data[(size - (int)1)] = (int)0;
		}
		HX_STACK_LINE(60)
		super::__construct(size,data);
	}
}
;
	return null();
}

//ByteArray_obj::~ByteArray_obj() { }

Dynamic ByteArray_obj::__CreateEmpty() { return  new ByteArray_obj; }
hx::ObjectPtr< ByteArray_obj > ByteArray_obj::__new(hx::Null< int >  __o_size)
{  hx::ObjectPtr< ByteArray_obj > result = new ByteArray_obj();
	result->__construct(__o_size);
	return result;}

Dynamic ByteArray_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ByteArray_obj > result = new ByteArray_obj();
	result->__construct(inArgs[0]);
	return result;}

hx::Object *ByteArray_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::flash::utils::IDataInput_obj)) return operator ::flash::utils::IDataInput_obj *();
	if (inType==typeid( ::flash::utils::IDataOutput_obj)) return operator ::flash::utils::IDataOutput_obj *();
	if (inType==typeid( ::openfl::utils::IMemoryRange_obj)) return operator ::openfl::utils::IMemoryRange_obj *();
	return super::__ToInterface(inType);
}

void ByteArray_obj::__init__() {
HX_STACK_FRAME("flash.utils.ByteArray","__init__",0x0717f2a8,"flash.utils.ByteArray.__init__","flash/utils/ByteArray.hx",712,0xfb64f02a)
{

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	::flash::utils::ByteArray run(int length){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","flash/utils/ByteArray.hx",714,0xfb64f02a)
		HX_STACK_ARG(length,"length")
		{
			HX_STACK_LINE(714)
			return ::flash::utils::ByteArray_obj::__new(length);
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(714)
	Dynamic factory =  Dynamic(new _Function_1_1());		HX_STACK_VAR(factory,"factory");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_2)
	Void run(::flash::utils::ByteArray bytes,int length){
		HX_STACK_FRAME("*","_Function_1_2",0x5200ed38,"*._Function_1_2","flash/utils/ByteArray.hx",715,0xfb64f02a)
		HX_STACK_ARG(bytes,"bytes")
		HX_STACK_ARG(length,"length")
		{
			HX_STACK_LINE(717)
			if (((length > (int)0))){
				HX_STACK_LINE(719)
				bytes->__Field(HX_CSTRING("ensureElem"),true)((length - (int)1),true);
			}
			HX_STACK_LINE(723)
			bytes->__FieldRef(HX_CSTRING("length")) = length;
		}
		return null();
	}
	HX_END_LOCAL_FUNC2((void))

	HX_STACK_LINE(715)
	Dynamic resize =  Dynamic(new _Function_1_2());		HX_STACK_VAR(resize,"resize");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_3)
	Array< unsigned char > run(::flash::utils::ByteArray bytes){
		HX_STACK_FRAME("*","_Function_1_3",0x5200ed39,"*._Function_1_3","flash/utils/ByteArray.hx",727,0xfb64f02a)
		HX_STACK_ARG(bytes,"bytes")
		{
			HX_STACK_LINE(727)
			if (((bytes == null()))){
				HX_STACK_LINE(727)
				return null();
			}
			else{
				HX_STACK_LINE(727)
				return bytes->__Field(HX_CSTRING("b"),true);
			}
			HX_STACK_LINE(727)
			return null();
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(727)
	Dynamic bytes =  Dynamic(new _Function_1_3());		HX_STACK_VAR(bytes,"bytes");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_4)
	int run(::flash::utils::ByteArray bytes1){
		HX_STACK_FRAME("*","_Function_1_4",0x5200ed3a,"*._Function_1_4","flash/utils/ByteArray.hx",728,0xfb64f02a)
		HX_STACK_ARG(bytes1,"bytes1")
		{
			HX_STACK_LINE(728)
			if (((bytes1 == null()))){
				HX_STACK_LINE(728)
				return (int)0;
			}
			else{
				HX_STACK_LINE(728)
				return bytes1->__Field(HX_CSTRING("length"),true);
			}
			HX_STACK_LINE(728)
			return (int)0;
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(728)
	Dynamic slen =  Dynamic(new _Function_1_4());		HX_STACK_VAR(slen,"slen");
	HX_STACK_LINE(730)
	Dynamic init = ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_byte_array_init"),(int)4);		HX_STACK_VAR(init,"init");
	HX_STACK_LINE(731)
	init(factory,slen,resize,bytes);
}
}

::String ByteArray_obj::asString( ){
	HX_STACK_FRAME("flash.utils.ByteArray","asString",0x67a248bb,"flash.utils.ByteArray.asString","flash/utils/ByteArray.hx",71,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(71)
	return this->readUTFBytes(this->length);
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,asString,return )

Void ByteArray_obj::checkData( int length){
{
		HX_STACK_FRAME("flash.utils.ByteArray","checkData",0x7739b6ba,"flash.utils.ByteArray.checkData","flash/utils/ByteArray.hx",78,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(length,"length")
		HX_STACK_LINE(78)
		if ((((length + this->position) > this->length))){
			HX_STACK_LINE(80)
			this->__throwEOFi();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,checkData,(void))

Void ByteArray_obj::clear( ){
{
		HX_STACK_FRAME("flash.utils.ByteArray","clear",0x05f31535,"flash.utils.ByteArray.clear","flash/utils/ByteArray.hx",87,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_LINE(89)
		this->position = (int)0;
		HX_STACK_LINE(90)
		this->length = (int)0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,clear,(void))

Void ByteArray_obj::compress( ::flash::utils::CompressionAlgorithm algorithm){
{
		HX_STACK_FRAME("flash.utils.ByteArray","compress",0x4b5b5cfa,"flash.utils.ByteArray.compress","flash/utils/ByteArray.hx",95,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(algorithm,"algorithm")
		HX_STACK_LINE(100)
		::flash::utils::ByteArray src = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(src,"src");
		HX_STACK_LINE(103)
		if (((algorithm == null()))){
			HX_STACK_LINE(105)
			algorithm = ::flash::utils::CompressionAlgorithm_obj::ZLIB;
		}
		HX_STACK_LINE(109)
		::haxe::io::Bytes result;		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(111)
		if (((algorithm == ::flash::utils::CompressionAlgorithm_obj::LZMA))){
			HX_STACK_LINE(113)
			Array< unsigned char > _g = ::flash::utils::ByteArray_obj::lime_lzma_encode(src->b);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(113)
			::haxe::io::Bytes _g1 = ::haxe::io::Bytes_obj::ofData(_g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(113)
			result = _g1;
		}
		else{
			HX_STACK_LINE(117)
			int windowBits;		HX_STACK_VAR(windowBits,"windowBits");
			HX_STACK_LINE(117)
			switch( (int)(algorithm->__Index())){
				case (int)0: {
					HX_STACK_LINE(119)
					windowBits = (int)-15;
				}
				;break;
				case (int)3: {
					HX_STACK_LINE(120)
					windowBits = (int)31;
				}
				;break;
				default: {
					HX_STACK_LINE(121)
					windowBits = (int)15;
				}
			}
			HX_STACK_LINE(128)
			::haxe::io::Bytes _g2 = ::haxe::zip::Compress_obj::run(src,(int)8);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(128)
			result = _g2;
		}
		HX_STACK_LINE(133)
		this->b = result->b;
		HX_STACK_LINE(134)
		this->length = result->length;
		HX_STACK_LINE(135)
		this->position = this->length;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,compress,(void))

Void ByteArray_obj::deflate( ){
{
		HX_STACK_FRAME("flash.utils.ByteArray","deflate",0xb07fe913,"flash.utils.ByteArray.deflate","flash/utils/ByteArray.hx",145,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_LINE(145)
		this->compress(::flash::utils::CompressionAlgorithm_obj::DEFLATE);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,deflate,(void))

Void ByteArray_obj::ensureElem( int size,bool updateLength){
{
		HX_STACK_FRAME("flash.utils.ByteArray","ensureElem",0x14f8ccc5,"flash.utils.ByteArray.ensureElem","flash/utils/ByteArray.hx",150,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(size,"size")
		HX_STACK_ARG(updateLength,"updateLength")
		HX_STACK_LINE(151)
		int len = (size + (int)1);		HX_STACK_VAR(len,"len");
		HX_STACK_LINE(163)
		if (((this->b->length < len))){
			HX_STACK_LINE(165)
			this->b->__SetSize(len);
		}
		HX_STACK_LINE(170)
		if (((bool(updateLength) && bool((this->length < len))))){
			HX_STACK_LINE(172)
			this->length = len;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(ByteArray_obj,ensureElem,(void))

::flash::utils::ByteArray ByteArray_obj::getByteBuffer( ){
	HX_STACK_FRAME("flash.utils.ByteArray","getByteBuffer",0xd5eb2e06,"flash.utils.ByteArray.getByteBuffer","flash/utils/ByteArray.hx",190,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(190)
	return hx::ObjectPtr<OBJ_>(this);
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,getByteBuffer,return )

int ByteArray_obj::getLength( ){
	HX_STACK_FRAME("flash.utils.ByteArray","getLength",0xfc54b5c4,"flash.utils.ByteArray.getLength","flash/utils/ByteArray.hx",197,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(197)
	return this->length;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,getLength,return )

Dynamic ByteArray_obj::getNativePointer( ){
	HX_STACK_FRAME("flash.utils.ByteArray","getNativePointer",0x8e8866c8,"flash.utils.ByteArray.getNativePointer","flash/utils/ByteArray.hx",204,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(204)
	return ::flash::utils::ByteArray_obj::lime_byte_array_get_native_pointer(hx::ObjectPtr<OBJ_>(this));
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,getNativePointer,return )

int ByteArray_obj::getStart( ){
	HX_STACK_FRAME("flash.utils.ByteArray","getStart",0xab7e9944,"flash.utils.ByteArray.getStart","flash/utils/ByteArray.hx",211,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(211)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,getStart,return )

Void ByteArray_obj::inflate( ){
{
		HX_STACK_FRAME("flash.utils.ByteArray","inflate",0x19a17a2f,"flash.utils.ByteArray.inflate","flash/utils/ByteArray.hx",218,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_LINE(218)
		this->uncompress(::flash::utils::CompressionAlgorithm_obj::DEFLATE);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,inflate,(void))

bool ByteArray_obj::readBoolean( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readBoolean",0xce744f9a,"flash.utils.ByteArray.readBoolean","flash/utils/ByteArray.hx",225,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(225)
	if (((this->position < this->length))){
		HX_STACK_LINE(225)
		int _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(225)
		{
			HX_STACK_LINE(225)
			int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
			HX_STACK_LINE(225)
			_g = this->b->__get(pos);
		}
		HX_STACK_LINE(225)
		return (_g != (int)0);
	}
	else{
		HX_STACK_LINE(225)
		int _g1 = this->__throwEOFi();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(225)
		return (_g1 != (int)0);
	}
	HX_STACK_LINE(225)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readBoolean,return )

int ByteArray_obj::readByte( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readByte",0x30b70ed6,"flash.utils.ByteArray.readByte","flash/utils/ByteArray.hx",230,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(232)
	int value;		HX_STACK_VAR(value,"value");
	HX_STACK_LINE(232)
	if (((this->position < this->length))){
		HX_STACK_LINE(232)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(232)
		value = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(232)
		value = this->__throwEOFi();
	}
	HX_STACK_LINE(233)
	if (((((int(value) & int((int)128))) != (int)0))){
		HX_STACK_LINE(233)
		return (value - (int)256);
	}
	else{
		HX_STACK_LINE(233)
		return value;
	}
	HX_STACK_LINE(233)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readByte,return )

Void ByteArray_obj::readBytes( ::flash::utils::ByteArray data,hx::Null< int >  __o_offset,hx::Null< int >  __o_length){
int offset = __o_offset.Default(0);
int length = __o_length.Default(0);
	HX_STACK_FRAME("flash.utils.ByteArray","readBytes",0x6f75ecdd,"flash.utils.ByteArray.readBytes","flash/utils/ByteArray.hx",238,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(data,"data")
	HX_STACK_ARG(offset,"offset")
	HX_STACK_ARG(length,"length")
{
		HX_STACK_LINE(240)
		if (((length == (int)0))){
			HX_STACK_LINE(242)
			length = (this->length - this->position);
		}
		HX_STACK_LINE(246)
		if ((((this->position + length) > this->length))){
			HX_STACK_LINE(248)
			this->__throwEOFi();
		}
		HX_STACK_LINE(252)
		if (((data->length < (offset + length)))){
			HX_STACK_LINE(254)
			data->ensureElem(((offset + length) - (int)1),true);
		}
		HX_STACK_LINE(261)
		Array< unsigned char > b1 = this->b;		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(262)
		Array< unsigned char > b2 = data->b;		HX_STACK_VAR(b2,"b2");
		HX_STACK_LINE(263)
		int p = this->position;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(264)
		{
			HX_STACK_LINE(264)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(264)
			while((true)){
				HX_STACK_LINE(264)
				if ((!(((_g < length))))){
					HX_STACK_LINE(264)
					break;
				}
				HX_STACK_LINE(264)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(266)
				b2[(offset + i)] = b1->__get((p + i));
			}
		}
		HX_STACK_LINE(271)
		hx::AddEq(this->position,length);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(ByteArray_obj,readBytes,(void))

Float ByteArray_obj::readDouble( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readDouble",0x23152a5f,"flash.utils.ByteArray.readDouble","flash/utils/ByteArray.hx",276,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(278)
	if ((((this->position + (int)8) > this->length))){
		HX_STACK_LINE(280)
		this->__throwEOFi();
	}
	HX_STACK_LINE(287)
	Array< unsigned char > _g = this->b->slice(this->position,(this->position + (int)8));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(287)
	::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::__new((int)8,_g);		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(290)
	hx::AddEq(this->position,(int)8);
	HX_STACK_LINE(291)
	return ::flash::utils::ByteArray_obj::_double_of_bytes(bytes->b,this->bigEndian);
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readDouble,return )

Float ByteArray_obj::readFloat( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readFloat",0xb474aa0e,"flash.utils.ByteArray.readFloat","flash/utils/ByteArray.hx",307,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(309)
	if ((((this->position + (int)4) > this->length))){
		HX_STACK_LINE(311)
		this->__throwEOFi();
	}
	HX_STACK_LINE(318)
	Array< unsigned char > _g = this->b->slice(this->position,(this->position + (int)4));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(318)
	::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::__new((int)4,_g);		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(321)
	hx::AddEq(this->position,(int)4);
	HX_STACK_LINE(322)
	return ::flash::utils::ByteArray_obj::_float_of_bytes(bytes->b,this->bigEndian);
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readFloat,return )

int ByteArray_obj::readInt( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readInt",0x104f90e1,"flash.utils.ByteArray.readInt","flash/utils/ByteArray.hx",327,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(329)
	int ch1;		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(329)
	if (((this->position < this->length))){
		HX_STACK_LINE(329)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(329)
		ch1 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(329)
		ch1 = this->__throwEOFi();
	}
	HX_STACK_LINE(330)
	int ch2;		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(330)
	if (((this->position < this->length))){
		HX_STACK_LINE(330)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(330)
		ch2 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(330)
		ch2 = this->__throwEOFi();
	}
	HX_STACK_LINE(331)
	int ch3;		HX_STACK_VAR(ch3,"ch3");
	HX_STACK_LINE(331)
	if (((this->position < this->length))){
		HX_STACK_LINE(331)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(331)
		ch3 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(331)
		ch3 = this->__throwEOFi();
	}
	HX_STACK_LINE(332)
	int ch4;		HX_STACK_VAR(ch4,"ch4");
	HX_STACK_LINE(332)
	if (((this->position < this->length))){
		HX_STACK_LINE(332)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(332)
		ch4 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(332)
		ch4 = this->__throwEOFi();
	}
	HX_STACK_LINE(334)
	if ((this->bigEndian)){
		HX_STACK_LINE(334)
		return (int((int((int((int(ch1) << int((int)24))) | int((int(ch2) << int((int)16))))) | int((int(ch3) << int((int)8))))) | int(ch4));
	}
	else{
		HX_STACK_LINE(334)
		return (int((int((int((int(ch4) << int((int)24))) | int((int(ch3) << int((int)16))))) | int((int(ch2) << int((int)8))))) | int(ch1));
	}
	HX_STACK_LINE(334)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readInt,return )

::String ByteArray_obj::readMultiByte( int length,::String charSet){
	HX_STACK_FRAME("flash.utils.ByteArray","readMultiByte",0xe6a90b93,"flash.utils.ByteArray.readMultiByte","flash/utils/ByteArray.hx",341,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(length,"length")
	HX_STACK_ARG(charSet,"charSet")
	HX_STACK_LINE(341)
	return this->readUTFBytes(length);
}


HX_DEFINE_DYNAMIC_FUNC2(ByteArray_obj,readMultiByte,return )

Void ByteArray_obj::writeMultiByte( ::String value,::String charSet){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeMultiByte",0xdee00c9a,"flash.utils.ByteArray.writeMultiByte","flash/utils/ByteArray.hx",346,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(value,"value")
		HX_STACK_ARG(charSet,"charSet")
		HX_STACK_LINE(346)
		this->writeUTFBytes(value);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(ByteArray_obj,writeMultiByte,(void))

int ByteArray_obj::readShort( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readShort",0x2e0568ee,"flash.utils.ByteArray.readShort","flash/utils/ByteArray.hx",349,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(351)
	int ch1;		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(351)
	if (((this->position < this->length))){
		HX_STACK_LINE(351)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(351)
		ch1 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(351)
		ch1 = this->__throwEOFi();
	}
	HX_STACK_LINE(352)
	int ch2;		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(352)
	if (((this->position < this->length))){
		HX_STACK_LINE(352)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(352)
		ch2 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(352)
		ch2 = this->__throwEOFi();
	}
	HX_STACK_LINE(354)
	int value;		HX_STACK_VAR(value,"value");
	HX_STACK_LINE(354)
	if ((this->bigEndian)){
		HX_STACK_LINE(354)
		value = (int((int(ch1) << int((int)8))) | int(ch2));
	}
	else{
		HX_STACK_LINE(354)
		value = (int((int(ch2) << int((int)8))) | int(ch1));
	}
	HX_STACK_LINE(356)
	if (((((int(value) & int((int)32768))) != (int)0))){
		HX_STACK_LINE(356)
		return (value - (int)65536);
	}
	else{
		HX_STACK_LINE(356)
		return value;
	}
	HX_STACK_LINE(356)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readShort,return )

int ByteArray_obj::readUnsignedByte( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readUnsignedByte",0xb003386b,"flash.utils.ByteArray.readUnsignedByte","flash/utils/ByteArray.hx",363,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(363)
	if (((this->position < this->length))){
		HX_STACK_LINE(363)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(363)
		return this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(363)
		return this->__throwEOFi();
	}
	HX_STACK_LINE(363)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readUnsignedByte,return )

int ByteArray_obj::readUnsignedInt( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readUnsignedInt",0x75e770ec,"flash.utils.ByteArray.readUnsignedInt","flash/utils/ByteArray.hx",368,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(370)
	int ch1;		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(370)
	if (((this->position < this->length))){
		HX_STACK_LINE(370)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(370)
		ch1 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(370)
		ch1 = this->__throwEOFi();
	}
	HX_STACK_LINE(371)
	int ch2;		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(371)
	if (((this->position < this->length))){
		HX_STACK_LINE(371)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(371)
		ch2 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(371)
		ch2 = this->__throwEOFi();
	}
	HX_STACK_LINE(372)
	int ch3;		HX_STACK_VAR(ch3,"ch3");
	HX_STACK_LINE(372)
	if (((this->position < this->length))){
		HX_STACK_LINE(372)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(372)
		ch3 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(372)
		ch3 = this->__throwEOFi();
	}
	HX_STACK_LINE(373)
	int ch4;		HX_STACK_VAR(ch4,"ch4");
	HX_STACK_LINE(373)
	if (((this->position < this->length))){
		HX_STACK_LINE(373)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(373)
		ch4 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(373)
		ch4 = this->__throwEOFi();
	}
	HX_STACK_LINE(375)
	if ((this->bigEndian)){
		HX_STACK_LINE(375)
		return (int((int((int((int(ch1) << int((int)24))) | int((int(ch2) << int((int)16))))) | int((int(ch3) << int((int)8))))) | int(ch4));
	}
	else{
		HX_STACK_LINE(375)
		return (int((int((int((int(ch4) << int((int)24))) | int((int(ch3) << int((int)16))))) | int((int(ch2) << int((int)8))))) | int(ch1));
	}
	HX_STACK_LINE(375)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readUnsignedInt,return )

int ByteArray_obj::readUnsignedShort( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readUnsignedShort",0x115da1b9,"flash.utils.ByteArray.readUnsignedShort","flash/utils/ByteArray.hx",380,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(382)
	int ch1;		HX_STACK_VAR(ch1,"ch1");
	HX_STACK_LINE(382)
	if (((this->position < this->length))){
		HX_STACK_LINE(382)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(382)
		ch1 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(382)
		ch1 = this->__throwEOFi();
	}
	HX_STACK_LINE(383)
	int ch2;		HX_STACK_VAR(ch2,"ch2");
	HX_STACK_LINE(383)
	if (((this->position < this->length))){
		HX_STACK_LINE(383)
		int pos = (this->position)++;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(383)
		ch2 = this->b->__get(pos);
	}
	else{
		HX_STACK_LINE(383)
		ch2 = this->__throwEOFi();
	}
	HX_STACK_LINE(385)
	if ((this->bigEndian)){
		HX_STACK_LINE(385)
		return (int((int(ch1) << int((int)8))) | int(ch2));
	}
	else{
		HX_STACK_LINE(385)
		return (((int(ch2) << int((int)8))) + ch1);
	}
	HX_STACK_LINE(385)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readUnsignedShort,return )

::String ByteArray_obj::readUTF( ){
	HX_STACK_FRAME("flash.utils.ByteArray","readUTF",0x10589519,"flash.utils.ByteArray.readUTF","flash/utils/ByteArray.hx",390,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(392)
	int len = this->readUnsignedShort();		HX_STACK_VAR(len,"len");
	HX_STACK_LINE(393)
	return this->readUTFBytes(len);
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,readUTF,return )

::String ByteArray_obj::readUTFBytes( int length){
	HX_STACK_FRAME("flash.utils.ByteArray","readUTFBytes",0x2d1cc892,"flash.utils.ByteArray.readUTFBytes","flash/utils/ByteArray.hx",398,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(length,"length")
	HX_STACK_LINE(400)
	if ((((this->position + length) > this->length))){
		HX_STACK_LINE(402)
		this->__throwEOFi();
	}
	HX_STACK_LINE(406)
	int p = this->position;		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(407)
	hx::AddEq(this->position,length);
	HX_STACK_LINE(416)
	::String result = HX_CSTRING("");		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(417)
	::__hxcpp_string_of_bytes(this->b,result,p,length);
	HX_STACK_LINE(418)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,readUTFBytes,return )

Void ByteArray_obj::setLength( int length){
{
		HX_STACK_FRAME("flash.utils.ByteArray","setLength",0xdfa5a1d0,"flash.utils.ByteArray.setLength","flash/utils/ByteArray.hx",424,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(length,"length")
		HX_STACK_LINE(426)
		if (((length > (int)0))){
			HX_STACK_LINE(428)
			this->ensureElem((length - (int)1),false);
		}
		HX_STACK_LINE(432)
		this->length = length;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,setLength,(void))

::flash::utils::ByteArray ByteArray_obj::slice( int begin,Dynamic end){
	HX_STACK_FRAME("flash.utils.ByteArray","slice",0x3c5f67fa,"flash.utils.ByteArray.slice","flash/utils/ByteArray.hx",437,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(begin,"begin")
	HX_STACK_ARG(end,"end")
	HX_STACK_LINE(439)
	if (((begin < (int)0))){
		HX_STACK_LINE(441)
		hx::AddEq(begin,this->length);
		HX_STACK_LINE(443)
		if (((begin < (int)0))){
			HX_STACK_LINE(445)
			begin = (int)0;
		}
	}
	HX_STACK_LINE(451)
	if (((end == null()))){
		HX_STACK_LINE(453)
		end = this->length;
	}
	HX_STACK_LINE(457)
	if (((end < (int)0))){
		HX_STACK_LINE(459)
		hx::AddEq(end,this->length);
		HX_STACK_LINE(461)
		if (((end < (int)0))){
			HX_STACK_LINE(463)
			end = (int)0;
		}
	}
	HX_STACK_LINE(469)
	if (((begin >= end))){
		HX_STACK_LINE(471)
		return ::flash::utils::ByteArray_obj::__new(null());
	}
	HX_STACK_LINE(475)
	::flash::utils::ByteArray result = ::flash::utils::ByteArray_obj::__new((end - begin));		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(477)
	int opos = this->position;		HX_STACK_VAR(opos,"opos");
	HX_STACK_LINE(478)
	result->blit((int)0,hx::ObjectPtr<OBJ_>(this),begin,(end - begin));
	HX_STACK_LINE(480)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(ByteArray_obj,slice,return )

Void ByteArray_obj::uncompress( ::flash::utils::CompressionAlgorithm algorithm){
{
		HX_STACK_FRAME("flash.utils.ByteArray","uncompress",0x00514a53,"flash.utils.ByteArray.uncompress","flash/utils/ByteArray.hx",485,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(algorithm,"algorithm")
		HX_STACK_LINE(487)
		if (((algorithm == null()))){
			HX_STACK_LINE(487)
			algorithm = ::flash::utils::CompressionAlgorithm_obj::ZLIB;
		}
		HX_STACK_LINE(492)
		::flash::utils::ByteArray src = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(src,"src");
		HX_STACK_LINE(495)
		::haxe::io::Bytes result;		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(497)
		if (((algorithm == ::flash::utils::CompressionAlgorithm_obj::LZMA))){
			HX_STACK_LINE(499)
			Array< unsigned char > _g = ::flash::utils::ByteArray_obj::lime_lzma_decode(src->b);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(499)
			::haxe::io::Bytes _g1 = ::haxe::io::Bytes_obj::ofData(_g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(499)
			result = _g1;
		}
		else{
			HX_STACK_LINE(503)
			int windowBits;		HX_STACK_VAR(windowBits,"windowBits");
			HX_STACK_LINE(503)
			switch( (int)(algorithm->__Index())){
				case (int)0: {
					HX_STACK_LINE(505)
					windowBits = (int)-15;
				}
				;break;
				case (int)3: {
					HX_STACK_LINE(506)
					windowBits = (int)31;
				}
				;break;
				default: {
					HX_STACK_LINE(507)
					windowBits = (int)15;
				}
			}
			HX_STACK_LINE(514)
			::haxe::io::Bytes _g2 = ::haxe::zip::Uncompress_obj::run(src,null());		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(514)
			result = _g2;
		}
		HX_STACK_LINE(519)
		this->b = result->b;
		HX_STACK_LINE(520)
		this->length = result->length;
		HX_STACK_LINE(521)
		this->position = (int)0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,uncompress,(void))

Void ByteArray_obj::write_uncheck( int byte){
{
		HX_STACK_FRAME("flash.utils.ByteArray","write_uncheck",0x36cf58d7,"flash.utils.ByteArray.write_uncheck","flash/utils/ByteArray.hx",529,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(byte,"byte")
		HX_STACK_LINE(532)
		int _g = (this->position)++;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(532)
		this->b->__unsafe_set(_g,byte);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,write_uncheck,(void))

Void ByteArray_obj::writeBoolean( bool value){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeBoolean",0x1e3b30e1,"flash.utils.ByteArray.writeBoolean","flash/utils/ByteArray.hx",542,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(542)
		this->ensureElem(this->position,true);
		HX_STACK_LINE(542)
		int _g = (this->position)++;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(542)
		if ((value)){
			HX_STACK_LINE(542)
			this->b[_g] = (int)1;
		}
		else{
			HX_STACK_LINE(542)
			this->b[_g] = (int)0;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeBoolean,(void))

Void ByteArray_obj::writeObject( Dynamic object){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeObject",0xa7c2a2a6,"flash.utils.ByteArray.writeObject","flash/utils/ByteArray.hx",545,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(object,"object")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeObject,(void))

Void ByteArray_obj::writeByte( int value){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeByte",0x2acdab2f,"flash.utils.ByteArray.writeByte","flash/utils/ByteArray.hx",550,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(552)
		this->ensureElem(this->position,true);
		HX_STACK_LINE(555)
		int _g = (this->position)++;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(555)
		this->b[_g] = value;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeByte,(void))

Void ByteArray_obj::writeBytes( ::haxe::io::Bytes bytes,hx::Null< int >  __o_offset,hx::Null< int >  __o_length){
int offset = __o_offset.Default(0);
int length = __o_length.Default(0);
	HX_STACK_FRAME("flash.utils.ByteArray","writeBytes",0x49281e64,"flash.utils.ByteArray.writeBytes","flash/utils/ByteArray.hx",563,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(bytes,"bytes")
	HX_STACK_ARG(offset,"offset")
	HX_STACK_ARG(length,"length")
{
		HX_STACK_LINE(565)
		if (((length == (int)0))){
			HX_STACK_LINE(565)
			length = (bytes->length - offset);
		}
		HX_STACK_LINE(566)
		this->ensureElem(((this->position + length) - (int)1),true);
		HX_STACK_LINE(567)
		int opos = this->position;		HX_STACK_VAR(opos,"opos");
		HX_STACK_LINE(568)
		hx::AddEq(this->position,length);
		HX_STACK_LINE(569)
		this->blit(opos,bytes,offset,length);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(ByteArray_obj,writeBytes,(void))

Void ByteArray_obj::writeDouble( Float x){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeDouble",0xc54e4ef8,"flash.utils.ByteArray.writeDouble","flash/utils/ByteArray.hx",574,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(579)
		Array< unsigned char > _g = ::flash::utils::ByteArray_obj::_double_bytes(x,this->bigEndian);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(579)
		::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::ofData(_g);		HX_STACK_VAR(bytes,"bytes");
		HX_STACK_LINE(582)
		this->writeBytes(bytes,(int)0,(int)0);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeDouble,(void))

Void ByteArray_obj::writeFile( ::String path){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeFile",0x2d665aa3,"flash.utils.ByteArray.writeFile","flash/utils/ByteArray.hx",591,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(path,"path")
		HX_STACK_LINE(591)
		::flash::utils::ByteArray_obj::lime_byte_array_overwrite_file(path,hx::ObjectPtr<OBJ_>(this));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeFile,(void))

Void ByteArray_obj::writeFloat( Float x){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeFloat",0x8e26db95,"flash.utils.ByteArray.writeFloat","flash/utils/ByteArray.hx",598,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(603)
		Array< unsigned char > _g = ::flash::utils::ByteArray_obj::_float_bytes(x,this->bigEndian);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(603)
		::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::ofData(_g);		HX_STACK_VAR(bytes,"bytes");
		HX_STACK_LINE(606)
		this->writeBytes(bytes,(int)0,(int)0);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeFloat,(void))

Void ByteArray_obj::writeInt( int value){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeInt",0xeb8c82a8,"flash.utils.ByteArray.writeInt","flash/utils/ByteArray.hx",611,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(613)
		this->ensureElem((this->position + (int)3),true);
		HX_STACK_LINE(615)
		if ((this->bigEndian)){
			HX_STACK_LINE(617)
			{
				HX_STACK_LINE(617)
				int _g = (this->position)++;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(617)
				this->b->__unsafe_set(_g,(int(value) >> int((int)24)));
			}
			HX_STACK_LINE(618)
			{
				HX_STACK_LINE(618)
				int _g1 = (this->position)++;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(618)
				this->b->__unsafe_set(_g1,(int(value) >> int((int)16)));
			}
			HX_STACK_LINE(619)
			{
				HX_STACK_LINE(619)
				int _g2 = (this->position)++;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(619)
				this->b->__unsafe_set(_g2,(int(value) >> int((int)8)));
			}
			HX_STACK_LINE(620)
			{
				HX_STACK_LINE(620)
				int _g3 = (this->position)++;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(620)
				this->b->__unsafe_set(_g3,value);
			}
		}
		else{
			HX_STACK_LINE(624)
			{
				HX_STACK_LINE(624)
				int _g4 = (this->position)++;		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(624)
				this->b->__unsafe_set(_g4,value);
			}
			HX_STACK_LINE(625)
			{
				HX_STACK_LINE(625)
				int _g5 = (this->position)++;		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(625)
				this->b->__unsafe_set(_g5,(int(value) >> int((int)8)));
			}
			HX_STACK_LINE(626)
			{
				HX_STACK_LINE(626)
				int _g6 = (this->position)++;		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(626)
				this->b->__unsafe_set(_g6,(int(value) >> int((int)16)));
			}
			HX_STACK_LINE(627)
			{
				HX_STACK_LINE(627)
				int _g7 = (this->position)++;		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(627)
				this->b->__unsafe_set(_g7,(int(value) >> int((int)24)));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeInt,(void))

Void ByteArray_obj::writeShort( int value){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeShort",0x07b79a75,"flash.utils.ByteArray.writeShort","flash/utils/ByteArray.hx",634,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(636)
		this->ensureElem((this->position + (int)1),true);
		HX_STACK_LINE(638)
		if ((this->bigEndian)){
			HX_STACK_LINE(640)
			{
				HX_STACK_LINE(640)
				int _g = (this->position)++;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(640)
				this->b->__unsafe_set(_g,(int(value) >> int((int)8)));
			}
			HX_STACK_LINE(641)
			{
				HX_STACK_LINE(641)
				int _g1 = (this->position)++;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(641)
				this->b->__unsafe_set(_g1,value);
			}
		}
		else{
			HX_STACK_LINE(645)
			{
				HX_STACK_LINE(645)
				int _g2 = (this->position)++;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(645)
				this->b->__unsafe_set(_g2,value);
			}
			HX_STACK_LINE(646)
			{
				HX_STACK_LINE(646)
				int _g3 = (this->position)++;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(646)
				this->b->__unsafe_set(_g3,(int(value) >> int((int)8)));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeShort,(void))

Void ByteArray_obj::writeUnsignedInt( int value){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeUnsignedInt",0x2aa601b3,"flash.utils.ByteArray.writeUnsignedInt","flash/utils/ByteArray.hx",655,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(655)
		this->writeInt(value);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeUnsignedInt,(void))

Void ByteArray_obj::writeUTF( ::String s){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeUTF",0xeb9586e0,"flash.utils.ByteArray.writeUTF","flash/utils/ByteArray.hx",660,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(665)
		::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::ofString(s);		HX_STACK_VAR(bytes,"bytes");
		HX_STACK_LINE(668)
		this->writeShort(bytes->length);
		HX_STACK_LINE(669)
		this->writeBytes(bytes,(int)0,(int)0);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeUTF,(void))

Void ByteArray_obj::writeUTFBytes( ::String s){
{
		HX_STACK_FRAME("flash.utils.ByteArray","writeUTFBytes",0xab5b056b,"flash.utils.ByteArray.writeUTFBytes","flash/utils/ByteArray.hx",674,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(679)
		::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::ofString(s);		HX_STACK_VAR(bytes,"bytes");
		HX_STACK_LINE(682)
		this->writeBytes(bytes,(int)0,(int)0);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,writeUTFBytes,(void))

Void ByteArray_obj::__fromBytes( ::haxe::io::Bytes bytes){
{
		HX_STACK_FRAME("flash.utils.ByteArray","__fromBytes",0x9dd70d29,"flash.utils.ByteArray.__fromBytes","flash/utils/ByteArray.hx",687,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(bytes,"bytes")
		HX_STACK_LINE(689)
		this->b = bytes->b;
		HX_STACK_LINE(690)
		this->length = bytes->length;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,__fromBytes,(void))

int ByteArray_obj::__get( int pos){
	HX_STACK_FRAME("flash.utils.ByteArray","__get",0xafc2851e,"flash.utils.ByteArray.__get","flash/utils/ByteArray.hx",702,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(702)
	return this->b->__get(pos);
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,__get,return )

Void ByteArray_obj::__set( int pos,int v){
{
		HX_STACK_FRAME("flash.utils.ByteArray","__set",0xafcba02a,"flash.utils.ByteArray.__set","flash/utils/ByteArray.hx",741,0xfb64f02a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(741)
		this->b[pos] = v;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(ByteArray_obj,__set,(void))

int ByteArray_obj::__throwEOFi( ){
	HX_STACK_FRAME("flash.utils.ByteArray","__throwEOFi",0x964aeafb,"flash.utils.ByteArray.__throwEOFi","flash/utils/ByteArray.hx",749,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(751)
	HX_STACK_DO_THROW(::flash::errors::EOFError_obj::__new());
	HX_STACK_LINE(752)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,__throwEOFi,return )

int ByteArray_obj::get_bytesAvailable( ){
	HX_STACK_FRAME("flash.utils.ByteArray","get_bytesAvailable",0xa5145fff,"flash.utils.ByteArray.get_bytesAvailable","flash/utils/ByteArray.hx",764,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(764)
	return (this->length - this->position);
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,get_bytesAvailable,return )

int ByteArray_obj::get_byteLength( ){
	HX_STACK_FRAME("flash.utils.ByteArray","get_byteLength",0xdfbc4daf,"flash.utils.ByteArray.get_byteLength","flash/utils/ByteArray.hx",765,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(765)
	return this->length;
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,get_byteLength,return )

::String ByteArray_obj::get_endian( ){
	HX_STACK_FRAME("flash.utils.ByteArray","get_endian",0xe1de23bc,"flash.utils.ByteArray.get_endian","flash/utils/ByteArray.hx",766,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(766)
	if ((this->bigEndian)){
		HX_STACK_LINE(766)
		return HX_CSTRING("bigEndian");
	}
	else{
		HX_STACK_LINE(766)
		return HX_CSTRING("littleEndian");
	}
	HX_STACK_LINE(766)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(ByteArray_obj,get_endian,return )

::String ByteArray_obj::set_endian( ::String value){
	HX_STACK_FRAME("flash.utils.ByteArray","set_endian",0xe55bc230,"flash.utils.ByteArray.set_endian","flash/utils/ByteArray.hx",767,0xfb64f02a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(767)
	this->bigEndian = (value == HX_CSTRING("bigEndian"));
	HX_STACK_LINE(767)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,set_endian,return )

::flash::utils::ByteArray ByteArray_obj::fromBytes( ::haxe::io::Bytes bytes){
	HX_STACK_FRAME("flash.utils.ByteArray","fromBytes",0x53178a49,"flash.utils.ByteArray.fromBytes","flash/utils/ByteArray.hx",179,0xfb64f02a)
	HX_STACK_ARG(bytes,"bytes")
	HX_STACK_LINE(181)
	::flash::utils::ByteArray result = ::flash::utils::ByteArray_obj::__new((int)-1);		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(182)
	{
		HX_STACK_LINE(182)
		result->b = bytes->b;
		HX_STACK_LINE(182)
		result->length = bytes->length;
	}
	HX_STACK_LINE(183)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,fromBytes,return )

::flash::utils::ByteArray ByteArray_obj::readFile( ::String path){
	HX_STACK_FRAME("flash.utils.ByteArray","readFile",0x334fbe4a,"flash.utils.ByteArray.readFile","flash/utils/ByteArray.hx",300,0xfb64f02a)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(300)
	return ::flash::utils::ByteArray_obj::lime_byte_array_read_file(path);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ByteArray_obj,readFile,return )

Dynamic ByteArray_obj::_double_bytes;

Dynamic ByteArray_obj::_double_of_bytes;

Dynamic ByteArray_obj::_float_bytes;

Dynamic ByteArray_obj::_float_of_bytes;

Dynamic ByteArray_obj::lime_byte_array_overwrite_file;

Dynamic ByteArray_obj::lime_byte_array_read_file;

Dynamic ByteArray_obj::lime_byte_array_get_native_pointer;

Dynamic ByteArray_obj::lime_lzma_encode;

Dynamic ByteArray_obj::lime_lzma_decode;


ByteArray_obj::ByteArray_obj()
{
}

Dynamic ByteArray_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"slice") ) { return slice_dyn(); }
		if (HX_FIELD_EQ(inName,"__get") ) { return __get_dyn(); }
		if (HX_FIELD_EQ(inName,"__set") ) { return __set_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"endian") ) { return get_endian(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"deflate") ) { return deflate_dyn(); }
		if (HX_FIELD_EQ(inName,"inflate") ) { return inflate_dyn(); }
		if (HX_FIELD_EQ(inName,"readInt") ) { return readInt_dyn(); }
		if (HX_FIELD_EQ(inName,"readUTF") ) { return readUTF_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"readFile") ) { return readFile_dyn(); }
		if (HX_FIELD_EQ(inName,"position") ) { return position; }
		if (HX_FIELD_EQ(inName,"asString") ) { return asString_dyn(); }
		if (HX_FIELD_EQ(inName,"compress") ) { return compress_dyn(); }
		if (HX_FIELD_EQ(inName,"getStart") ) { return getStart_dyn(); }
		if (HX_FIELD_EQ(inName,"readByte") ) { return readByte_dyn(); }
		if (HX_FIELD_EQ(inName,"writeInt") ) { return writeInt_dyn(); }
		if (HX_FIELD_EQ(inName,"writeUTF") ) { return writeUTF_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromBytes") ) { return fromBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"bigEndian") ) { return bigEndian; }
		if (HX_FIELD_EQ(inName,"checkData") ) { return checkData_dyn(); }
		if (HX_FIELD_EQ(inName,"getLength") ) { return getLength_dyn(); }
		if (HX_FIELD_EQ(inName,"readBytes") ) { return readBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"readFloat") ) { return readFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"readShort") ) { return readShort_dyn(); }
		if (HX_FIELD_EQ(inName,"setLength") ) { return setLength_dyn(); }
		if (HX_FIELD_EQ(inName,"writeByte") ) { return writeByte_dyn(); }
		if (HX_FIELD_EQ(inName,"writeFile") ) { return writeFile_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"byteLength") ) { return inCallProp ? get_byteLength() : byteLength; }
		if (HX_FIELD_EQ(inName,"ensureElem") ) { return ensureElem_dyn(); }
		if (HX_FIELD_EQ(inName,"readDouble") ) { return readDouble_dyn(); }
		if (HX_FIELD_EQ(inName,"uncompress") ) { return uncompress_dyn(); }
		if (HX_FIELD_EQ(inName,"writeBytes") ) { return writeBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"writeFloat") ) { return writeFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"writeShort") ) { return writeShort_dyn(); }
		if (HX_FIELD_EQ(inName,"get_endian") ) { return get_endian_dyn(); }
		if (HX_FIELD_EQ(inName,"set_endian") ) { return set_endian_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"readBoolean") ) { return readBoolean_dyn(); }
		if (HX_FIELD_EQ(inName,"writeObject") ) { return writeObject_dyn(); }
		if (HX_FIELD_EQ(inName,"writeDouble") ) { return writeDouble_dyn(); }
		if (HX_FIELD_EQ(inName,"__fromBytes") ) { return __fromBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"__throwEOFi") ) { return __throwEOFi_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"_float_bytes") ) { return _float_bytes; }
		if (HX_FIELD_EQ(inName,"readUTFBytes") ) { return readUTFBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"writeBoolean") ) { return writeBoolean_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_double_bytes") ) { return _double_bytes; }
		if (HX_FIELD_EQ(inName,"getByteBuffer") ) { return getByteBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"readMultiByte") ) { return readMultiByte_dyn(); }
		if (HX_FIELD_EQ(inName,"write_uncheck") ) { return write_uncheck_dyn(); }
		if (HX_FIELD_EQ(inName,"writeUTFBytes") ) { return writeUTFBytes_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"bytesAvailable") ) { return inCallProp ? get_bytesAvailable() : bytesAvailable; }
		if (HX_FIELD_EQ(inName,"writeMultiByte") ) { return writeMultiByte_dyn(); }
		if (HX_FIELD_EQ(inName,"get_byteLength") ) { return get_byteLength_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_float_of_bytes") ) { return _float_of_bytes; }
		if (HX_FIELD_EQ(inName,"readUnsignedInt") ) { return readUnsignedInt_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"_double_of_bytes") ) { return _double_of_bytes; }
		if (HX_FIELD_EQ(inName,"lime_lzma_encode") ) { return lime_lzma_encode; }
		if (HX_FIELD_EQ(inName,"lime_lzma_decode") ) { return lime_lzma_decode; }
		if (HX_FIELD_EQ(inName,"getNativePointer") ) { return getNativePointer_dyn(); }
		if (HX_FIELD_EQ(inName,"readUnsignedByte") ) { return readUnsignedByte_dyn(); }
		if (HX_FIELD_EQ(inName,"writeUnsignedInt") ) { return writeUnsignedInt_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"readUnsignedShort") ) { return readUnsignedShort_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"get_bytesAvailable") ) { return get_bytesAvailable_dyn(); }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_byte_array_read_file") ) { return lime_byte_array_read_file; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_byte_array_overwrite_file") ) { return lime_byte_array_overwrite_file; }
		break;
	case 34:
		if (HX_FIELD_EQ(inName,"lime_byte_array_get_native_pointer") ) { return lime_byte_array_get_native_pointer; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ByteArray_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"endian") ) { return set_endian(inValue); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"position") ) { position=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"bigEndian") ) { bigEndian=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"byteLength") ) { byteLength=inValue.Cast< int >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"_float_bytes") ) { _float_bytes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"_double_bytes") ) { _double_bytes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"bytesAvailable") ) { bytesAvailable=inValue.Cast< int >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"_float_of_bytes") ) { _float_of_bytes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"_double_of_bytes") ) { _double_of_bytes=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_lzma_encode") ) { lime_lzma_encode=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_lzma_decode") ) { lime_lzma_decode=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_byte_array_read_file") ) { lime_byte_array_read_file=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_byte_array_overwrite_file") ) { lime_byte_array_overwrite_file=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 34:
		if (HX_FIELD_EQ(inName,"lime_byte_array_get_native_pointer") ) { lime_byte_array_get_native_pointer=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ByteArray_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bigEndian"));
	outFields->push(HX_CSTRING("bytesAvailable"));
	outFields->push(HX_CSTRING("endian"));
	outFields->push(HX_CSTRING("position"));
	outFields->push(HX_CSTRING("byteLength"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromBytes"),
	HX_CSTRING("readFile"),
	HX_CSTRING("_double_bytes"),
	HX_CSTRING("_double_of_bytes"),
	HX_CSTRING("_float_bytes"),
	HX_CSTRING("_float_of_bytes"),
	HX_CSTRING("lime_byte_array_overwrite_file"),
	HX_CSTRING("lime_byte_array_read_file"),
	HX_CSTRING("lime_byte_array_get_native_pointer"),
	HX_CSTRING("lime_lzma_encode"),
	HX_CSTRING("lime_lzma_decode"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(ByteArray_obj,bigEndian),HX_CSTRING("bigEndian")},
	{hx::fsInt,(int)offsetof(ByteArray_obj,bytesAvailable),HX_CSTRING("bytesAvailable")},
	{hx::fsInt,(int)offsetof(ByteArray_obj,position),HX_CSTRING("position")},
	{hx::fsInt,(int)offsetof(ByteArray_obj,byteLength),HX_CSTRING("byteLength")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bigEndian"),
	HX_CSTRING("bytesAvailable"),
	HX_CSTRING("position"),
	HX_CSTRING("byteLength"),
	HX_CSTRING("asString"),
	HX_CSTRING("checkData"),
	HX_CSTRING("clear"),
	HX_CSTRING("compress"),
	HX_CSTRING("deflate"),
	HX_CSTRING("ensureElem"),
	HX_CSTRING("getByteBuffer"),
	HX_CSTRING("getLength"),
	HX_CSTRING("getNativePointer"),
	HX_CSTRING("getStart"),
	HX_CSTRING("inflate"),
	HX_CSTRING("readBoolean"),
	HX_CSTRING("readByte"),
	HX_CSTRING("readBytes"),
	HX_CSTRING("readDouble"),
	HX_CSTRING("readFloat"),
	HX_CSTRING("readInt"),
	HX_CSTRING("readMultiByte"),
	HX_CSTRING("writeMultiByte"),
	HX_CSTRING("readShort"),
	HX_CSTRING("readUnsignedByte"),
	HX_CSTRING("readUnsignedInt"),
	HX_CSTRING("readUnsignedShort"),
	HX_CSTRING("readUTF"),
	HX_CSTRING("readUTFBytes"),
	HX_CSTRING("setLength"),
	HX_CSTRING("slice"),
	HX_CSTRING("uncompress"),
	HX_CSTRING("write_uncheck"),
	HX_CSTRING("writeBoolean"),
	HX_CSTRING("writeObject"),
	HX_CSTRING("writeByte"),
	HX_CSTRING("writeBytes"),
	HX_CSTRING("writeDouble"),
	HX_CSTRING("writeFile"),
	HX_CSTRING("writeFloat"),
	HX_CSTRING("writeInt"),
	HX_CSTRING("writeShort"),
	HX_CSTRING("writeUnsignedInt"),
	HX_CSTRING("writeUTF"),
	HX_CSTRING("writeUTFBytes"),
	HX_CSTRING("__fromBytes"),
	HX_CSTRING("__get"),
	HX_CSTRING("__set"),
	HX_CSTRING("__throwEOFi"),
	HX_CSTRING("get_bytesAvailable"),
	HX_CSTRING("get_byteLength"),
	HX_CSTRING("get_endian"),
	HX_CSTRING("set_endian"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ByteArray_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(ByteArray_obj::_double_bytes,"_double_bytes");
	HX_MARK_MEMBER_NAME(ByteArray_obj::_double_of_bytes,"_double_of_bytes");
	HX_MARK_MEMBER_NAME(ByteArray_obj::_float_bytes,"_float_bytes");
	HX_MARK_MEMBER_NAME(ByteArray_obj::_float_of_bytes,"_float_of_bytes");
	HX_MARK_MEMBER_NAME(ByteArray_obj::lime_byte_array_overwrite_file,"lime_byte_array_overwrite_file");
	HX_MARK_MEMBER_NAME(ByteArray_obj::lime_byte_array_read_file,"lime_byte_array_read_file");
	HX_MARK_MEMBER_NAME(ByteArray_obj::lime_byte_array_get_native_pointer,"lime_byte_array_get_native_pointer");
	HX_MARK_MEMBER_NAME(ByteArray_obj::lime_lzma_encode,"lime_lzma_encode");
	HX_MARK_MEMBER_NAME(ByteArray_obj::lime_lzma_decode,"lime_lzma_decode");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ByteArray_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::_double_bytes,"_double_bytes");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::_double_of_bytes,"_double_of_bytes");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::_float_bytes,"_float_bytes");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::_float_of_bytes,"_float_of_bytes");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::lime_byte_array_overwrite_file,"lime_byte_array_overwrite_file");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::lime_byte_array_read_file,"lime_byte_array_read_file");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::lime_byte_array_get_native_pointer,"lime_byte_array_get_native_pointer");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::lime_lzma_encode,"lime_lzma_encode");
	HX_VISIT_MEMBER_NAME(ByteArray_obj::lime_lzma_decode,"lime_lzma_decode");
};

#endif

Class ByteArray_obj::__mClass;

void ByteArray_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.utils.ByteArray"), hx::TCanCast< ByteArray_obj> ,sStaticFields,sMemberFields,
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

void ByteArray_obj::__boot()
{
	_double_bytes= ::flash::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("double_bytes"),(int)2);
	_double_of_bytes= ::flash::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("double_of_bytes"),(int)2);
	_float_bytes= ::flash::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("float_bytes"),(int)2);
	_float_of_bytes= ::flash::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("float_of_bytes"),(int)2);
	lime_byte_array_overwrite_file= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_byte_array_overwrite_file"),(int)2);
	lime_byte_array_read_file= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_byte_array_read_file"),(int)1);
	lime_byte_array_get_native_pointer= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_byte_array_get_native_pointer"),(int)1);
	lime_lzma_encode= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_lzma_encode"),(int)1);
	lime_lzma_decode= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_lzma_decode"),(int)1);
}

} // end namespace flash
} // end namespace utils
