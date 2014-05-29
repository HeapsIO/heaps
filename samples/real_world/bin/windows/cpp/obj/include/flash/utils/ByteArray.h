#ifndef INCLUDED_flash_utils_ByteArray
#define INCLUDED_flash_utils_ByteArray

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <haxe/io/Bytes.h>
#include <flash/utils/IDataOutput.h>
#include <openfl/utils/IMemoryRange.h>
#include <flash/utils/IDataInput.h>
HX_DECLARE_CLASS1(flash,Lib)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,CompressionAlgorithm)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace flash{
namespace utils{


class HXCPP_CLASS_ATTRIBUTES  ByteArray_obj : public ::haxe::io::Bytes_obj{
	public:
		typedef ::haxe::io::Bytes_obj super;
		typedef ByteArray_obj OBJ_;
		ByteArray_obj();
		Void __construct(hx::Null< int >  __o_size);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ByteArray_obj > __new(hx::Null< int >  __o_size);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ByteArray_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		inline operator ::flash::utils::IDataInput_obj *()
			{ return new ::flash::utils::IDataInput_delegate_< ByteArray_obj >(this); }
		inline operator ::flash::utils::IDataOutput_obj *()
			{ return new ::flash::utils::IDataOutput_delegate_< ByteArray_obj >(this); }
		inline operator ::openfl::utils::IMemoryRange_obj *()
			{ return new ::openfl::utils::IMemoryRange_delegate_< ByteArray_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		static void __init__();

		::String __ToString() const { return HX_CSTRING("ByteArray"); }

		typedef int __array_access;
		bool bigEndian;
		int bytesAvailable;
		int position;
		int byteLength;
		virtual ::String asString( );
		Dynamic asString_dyn();

		virtual Void checkData( int length);
		Dynamic checkData_dyn();

		virtual Void clear( );
		Dynamic clear_dyn();

		virtual Void compress( ::flash::utils::CompressionAlgorithm algorithm);
		Dynamic compress_dyn();

		virtual Void deflate( );
		Dynamic deflate_dyn();

		virtual Void ensureElem( int size,bool updateLength);
		Dynamic ensureElem_dyn();

		virtual ::flash::utils::ByteArray getByteBuffer( );
		Dynamic getByteBuffer_dyn();

		virtual int getLength( );
		Dynamic getLength_dyn();

		virtual Dynamic getNativePointer( );
		Dynamic getNativePointer_dyn();

		virtual int getStart( );
		Dynamic getStart_dyn();

		virtual Void inflate( );
		Dynamic inflate_dyn();

		virtual bool readBoolean( );
		Dynamic readBoolean_dyn();

		virtual int readByte( );
		Dynamic readByte_dyn();

		virtual Void readBytes( ::flash::utils::ByteArray data,hx::Null< int >  offset,hx::Null< int >  length);
		Dynamic readBytes_dyn();

		virtual Float readDouble( );
		Dynamic readDouble_dyn();

		virtual Float readFloat( );
		Dynamic readFloat_dyn();

		virtual int readInt( );
		Dynamic readInt_dyn();

		virtual ::String readMultiByte( int length,::String charSet);
		Dynamic readMultiByte_dyn();

		virtual Void writeMultiByte( ::String value,::String charSet);
		Dynamic writeMultiByte_dyn();

		virtual int readShort( );
		Dynamic readShort_dyn();

		virtual int readUnsignedByte( );
		Dynamic readUnsignedByte_dyn();

		virtual int readUnsignedInt( );
		Dynamic readUnsignedInt_dyn();

		virtual int readUnsignedShort( );
		Dynamic readUnsignedShort_dyn();

		virtual ::String readUTF( );
		Dynamic readUTF_dyn();

		virtual ::String readUTFBytes( int length);
		Dynamic readUTFBytes_dyn();

		virtual Void setLength( int length);
		Dynamic setLength_dyn();

		virtual ::flash::utils::ByteArray slice( int begin,Dynamic end);
		Dynamic slice_dyn();

		virtual Void uncompress( ::flash::utils::CompressionAlgorithm algorithm);
		Dynamic uncompress_dyn();

		virtual Void write_uncheck( int byte);
		Dynamic write_uncheck_dyn();

		virtual Void writeBoolean( bool value);
		Dynamic writeBoolean_dyn();

		virtual Void writeObject( Dynamic object);
		Dynamic writeObject_dyn();

		virtual Void writeByte( int value);
		Dynamic writeByte_dyn();

		virtual Void writeBytes( ::haxe::io::Bytes bytes,hx::Null< int >  offset,hx::Null< int >  length);
		Dynamic writeBytes_dyn();

		virtual Void writeDouble( Float x);
		Dynamic writeDouble_dyn();

		virtual Void writeFile( ::String path);
		Dynamic writeFile_dyn();

		virtual Void writeFloat( Float x);
		Dynamic writeFloat_dyn();

		virtual Void writeInt( int value);
		Dynamic writeInt_dyn();

		virtual Void writeShort( int value);
		Dynamic writeShort_dyn();

		virtual Void writeUnsignedInt( int value);
		Dynamic writeUnsignedInt_dyn();

		virtual Void writeUTF( ::String s);
		Dynamic writeUTF_dyn();

		virtual Void writeUTFBytes( ::String s);
		Dynamic writeUTFBytes_dyn();

		virtual Void __fromBytes( ::haxe::io::Bytes bytes);
		Dynamic __fromBytes_dyn();

		virtual int __get( int pos);
		Dynamic __get_dyn();

		virtual Void __set( int pos,int v);
		Dynamic __set_dyn();

		virtual int __throwEOFi( );
		Dynamic __throwEOFi_dyn();

		virtual int get_bytesAvailable( );
		Dynamic get_bytesAvailable_dyn();

		virtual int get_byteLength( );
		Dynamic get_byteLength_dyn();

		virtual ::String get_endian( );
		Dynamic get_endian_dyn();

		virtual ::String set_endian( ::String value);
		Dynamic set_endian_dyn();

		static ::flash::utils::ByteArray fromBytes( ::haxe::io::Bytes bytes);
		static Dynamic fromBytes_dyn();

		static ::flash::utils::ByteArray readFile( ::String path);
		static Dynamic readFile_dyn();

		static Dynamic _double_bytes;
		static Dynamic &_double_bytes_dyn() { return _double_bytes;}
		static Dynamic _double_of_bytes;
		static Dynamic &_double_of_bytes_dyn() { return _double_of_bytes;}
		static Dynamic _float_bytes;
		static Dynamic &_float_bytes_dyn() { return _float_bytes;}
		static Dynamic _float_of_bytes;
		static Dynamic &_float_of_bytes_dyn() { return _float_of_bytes;}
		static Dynamic lime_byte_array_overwrite_file;
		static Dynamic &lime_byte_array_overwrite_file_dyn() { return lime_byte_array_overwrite_file;}
		static Dynamic lime_byte_array_read_file;
		static Dynamic &lime_byte_array_read_file_dyn() { return lime_byte_array_read_file;}
		static Dynamic lime_byte_array_get_native_pointer;
		static Dynamic &lime_byte_array_get_native_pointer_dyn() { return lime_byte_array_get_native_pointer;}
		static Dynamic lime_lzma_encode;
		static Dynamic &lime_lzma_encode_dyn() { return lime_lzma_encode;}
		static Dynamic lime_lzma_decode;
		static Dynamic &lime_lzma_decode_dyn() { return lime_lzma_decode;}
};

} // end namespace flash
} // end namespace utils

#endif /* INCLUDED_flash_utils_ByteArray */ 
