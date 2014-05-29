#ifndef INCLUDED_haxe_io_Input
#define INCLUDED_haxe_io_Input

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,io,Input)
namespace haxe{
namespace io{


class HXCPP_CLASS_ATTRIBUTES  Input_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Input_obj OBJ_;
		Input_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Input_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Input_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Input"); }

		bool bigEndian;
		virtual int readByte( );
		Dynamic readByte_dyn();

		virtual int readBytes( ::haxe::io::Bytes s,int pos,int len);
		Dynamic readBytes_dyn();

		virtual Void close( );
		Dynamic close_dyn();

		virtual bool set_bigEndian( bool b);
		Dynamic set_bigEndian_dyn();

		virtual ::haxe::io::Bytes readAll( Dynamic bufsize);
		Dynamic readAll_dyn();

		virtual Void readFullBytes( ::haxe::io::Bytes s,int pos,int len);
		Dynamic readFullBytes_dyn();

		virtual ::haxe::io::Bytes read( int nbytes);
		Dynamic read_dyn();

		virtual ::String readUntil( int end);
		Dynamic readUntil_dyn();

		virtual ::String readLine( );
		Dynamic readLine_dyn();

		virtual Float readFloat( );
		Dynamic readFloat_dyn();

		virtual Float readDouble( );
		Dynamic readDouble_dyn();

		virtual int readInt8( );
		Dynamic readInt8_dyn();

		virtual int readInt16( );
		Dynamic readInt16_dyn();

		virtual int readUInt16( );
		Dynamic readUInt16_dyn();

		virtual int readInt24( );
		Dynamic readInt24_dyn();

		virtual int readUInt24( );
		Dynamic readUInt24_dyn();

		virtual int readInt32( );
		Dynamic readInt32_dyn();

		virtual ::String readString( int len);
		Dynamic readString_dyn();

		static Dynamic _float_of_bytes;
		static Dynamic &_float_of_bytes_dyn() { return _float_of_bytes;}
		static Dynamic _double_of_bytes;
		static Dynamic &_double_of_bytes_dyn() { return _double_of_bytes;}
};

} // end namespace haxe
} // end namespace io

#endif /* INCLUDED_haxe_io_Input */ 
