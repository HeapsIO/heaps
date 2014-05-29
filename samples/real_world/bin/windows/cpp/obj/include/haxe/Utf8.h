#ifndef INCLUDED_haxe_Utf8
#define INCLUDED_haxe_Utf8

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(haxe,Utf8)
namespace haxe{


class HXCPP_CLASS_ATTRIBUTES  Utf8_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Utf8_obj OBJ_;
		Utf8_obj();
		Void __construct(Dynamic size);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Utf8_obj > __new(Dynamic size);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Utf8_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Utf8"); }

		Array< int > __s;
		virtual Void addChar( int c);
		Dynamic addChar_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static ::String encode( ::String s);
		static Dynamic encode_dyn();

		static ::String decode( ::String s);
		static Dynamic decode_dyn();

		static Void iter( ::String s,Dynamic chars);
		static Dynamic iter_dyn();

		static int charCodeAt( ::String s,int index);
		static Dynamic charCodeAt_dyn();

		static bool validate( ::String s);
		static Dynamic validate_dyn();

		static int length( ::String s);
		static Dynamic length_dyn();

		static int compare( ::String a,::String b);
		static Dynamic compare_dyn();

		static ::String sub( ::String s,int pos,int len);
		static Dynamic sub_dyn();

};

} // end namespace haxe

#endif /* INCLUDED_haxe_Utf8 */ 
