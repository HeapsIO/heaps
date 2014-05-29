#ifndef INCLUDED_hxd_ByteConversions
#define INCLUDED_hxd_ByteConversions

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS1(hxd,ByteConversions)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  ByteConversions_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ByteConversions_obj OBJ_;
		ByteConversions_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ByteConversions_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ByteConversions_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("ByteConversions"); }

		static ::haxe::io::Bytes byteArrayToBytes( ::flash::utils::ByteArray v);
		static Dynamic byteArrayToBytes_dyn();

		static ::flash::utils::ByteArray bytesToByteArray( ::haxe::io::Bytes v);
		static Dynamic bytesToByteArray_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_ByteConversions */ 
