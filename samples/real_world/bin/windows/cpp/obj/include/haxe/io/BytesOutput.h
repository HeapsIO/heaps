#ifndef INCLUDED_haxe_io_BytesOutput
#define INCLUDED_haxe_io_BytesOutput

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <haxe/io/Output.h>
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,io,BytesBuffer)
HX_DECLARE_CLASS2(haxe,io,BytesOutput)
HX_DECLARE_CLASS2(haxe,io,Output)
namespace haxe{
namespace io{


class HXCPP_CLASS_ATTRIBUTES  BytesOutput_obj : public ::haxe::io::Output_obj{
	public:
		typedef ::haxe::io::Output_obj super;
		typedef BytesOutput_obj OBJ_;
		BytesOutput_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BytesOutput_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BytesOutput_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BytesOutput"); }

		::haxe::io::BytesBuffer b;
		virtual int get_length( );
		Dynamic get_length_dyn();

		virtual Void writeByte( int c);

		virtual int writeBytes( ::haxe::io::Bytes buf,int pos,int len);

		virtual ::haxe::io::Bytes getBytes( );
		Dynamic getBytes_dyn();

};

} // end namespace haxe
} // end namespace io

#endif /* INCLUDED_haxe_io_BytesOutput */ 
