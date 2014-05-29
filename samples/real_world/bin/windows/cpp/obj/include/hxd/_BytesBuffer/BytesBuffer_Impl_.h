#ifndef INCLUDED_hxd__BytesBuffer_BytesBuffer_Impl_
#define INCLUDED_hxd__BytesBuffer_BytesBuffer_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(haxe,io,BytesOutput)
HX_DECLARE_CLASS2(haxe,io,Output)
HX_DECLARE_CLASS2(hxd,_BytesBuffer,BytesBuffer_Impl_)
namespace hxd{
namespace _BytesBuffer{


class HXCPP_CLASS_ATTRIBUTES  BytesBuffer_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BytesBuffer_Impl__obj OBJ_;
		BytesBuffer_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BytesBuffer_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BytesBuffer_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("BytesBuffer_Impl_"); }

		static ::haxe::io::BytesOutput _new( );
		static Dynamic _new_dyn();

		static ::haxe::io::BytesOutput fromU8Array( Array< int > arr);
		static Dynamic fromU8Array_dyn();

		static ::haxe::io::BytesOutput fromIntArray( Array< int > arr);
		static Dynamic fromIntArray_dyn();

		static Void writeByte( ::haxe::io::BytesOutput this1,int v);
		static Dynamic writeByte_dyn();

		static Void writeFloat( ::haxe::io::BytesOutput this1,Float v);
		static Dynamic writeFloat_dyn();

		static Void writeInt32( ::haxe::io::BytesOutput this1,int v);
		static Dynamic writeInt32_dyn();

		static ::haxe::io::Bytes getBytes( ::haxe::io::BytesOutput this1);
		static Dynamic getBytes_dyn();

		static int get_length( ::haxe::io::BytesOutput this1);
		static Dynamic get_length_dyn();

};

} // end namespace hxd
} // end namespace _BytesBuffer

#endif /* INCLUDED_hxd__BytesBuffer_BytesBuffer_Impl_ */ 
