#ifndef INCLUDED_haxe_crypto_BaseCode
#define INCLUDED_haxe_crypto_BaseCode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,crypto,BaseCode)
HX_DECLARE_CLASS2(haxe,io,Bytes)
namespace haxe{
namespace crypto{


class HXCPP_CLASS_ATTRIBUTES  BaseCode_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BaseCode_obj OBJ_;
		BaseCode_obj();
		Void __construct(::haxe::io::Bytes base);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BaseCode_obj > __new(::haxe::io::Bytes base);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BaseCode_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BaseCode"); }

		::haxe::io::Bytes base;
		int nbits;
		Array< int > tbl;
		virtual ::haxe::io::Bytes encodeBytes( ::haxe::io::Bytes b);
		Dynamic encodeBytes_dyn();

		virtual Void initTable( );
		Dynamic initTable_dyn();

		virtual ::haxe::io::Bytes decodeBytes( ::haxe::io::Bytes b);
		Dynamic decodeBytes_dyn();

		virtual ::String encodeString( ::String s);
		Dynamic encodeString_dyn();

		virtual ::String decodeString( ::String s);
		Dynamic decodeString_dyn();

		static ::String encode( ::String s,::String base);
		static Dynamic encode_dyn();

		static ::String decode( ::String s,::String base);
		static Dynamic decode_dyn();

};

} // end namespace haxe
} // end namespace crypto

#endif /* INCLUDED_haxe_crypto_BaseCode */ 
