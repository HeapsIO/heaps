#ifndef INCLUDED_haxe_io_BytesBuffer
#define INCLUDED_haxe_io_BytesBuffer

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,io,BytesBuffer)
namespace haxe{
namespace io{


class HXCPP_CLASS_ATTRIBUTES  BytesBuffer_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BytesBuffer_obj OBJ_;
		BytesBuffer_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BytesBuffer_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BytesBuffer_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BytesBuffer"); }

		Array< unsigned char > b;
		virtual int get_length( );
		Dynamic get_length_dyn();

		virtual Void addByte( int byte);
		Dynamic addByte_dyn();

		virtual Void add( ::haxe::io::Bytes src);
		Dynamic add_dyn();

		virtual Void addString( ::String v);
		Dynamic addString_dyn();

		virtual Void addFloat( Float v);
		Dynamic addFloat_dyn();

		virtual Void addDouble( Float v);
		Dynamic addDouble_dyn();

		virtual Void addBytes( ::haxe::io::Bytes src,int pos,int len);
		Dynamic addBytes_dyn();

		virtual ::haxe::io::Bytes getBytes( );
		Dynamic getBytes_dyn();

};

} // end namespace haxe
} // end namespace io

#endif /* INCLUDED_haxe_io_BytesBuffer */ 
