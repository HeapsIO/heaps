#ifndef INCLUDED_hxd_text_Utf8Tools
#define INCLUDED_hxd_text_Utf8Tools

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,text,Utf8Tools)
namespace hxd{
namespace text{


class HXCPP_CLASS_ATTRIBUTES  Utf8Tools_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Utf8Tools_obj OBJ_;
		Utf8Tools_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Utf8Tools_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Utf8Tools_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Utf8Tools"); }

		static int getLastBits( int code,int nth);
		static Dynamic getLastBits_dyn();

		static int toCharCode( ::String str);
		static Dynamic toCharCode_dyn();

		static int getByteLength( int cc);
		static Dynamic getByteLength_dyn();

};

} // end namespace hxd
} // end namespace text

#endif /* INCLUDED_hxd_text_Utf8Tools */ 
