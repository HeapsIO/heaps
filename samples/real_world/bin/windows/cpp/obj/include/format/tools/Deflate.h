#ifndef INCLUDED_format_tools_Deflate
#define INCLUDED_format_tools_Deflate

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(format,tools,Deflate)
HX_DECLARE_CLASS2(haxe,io,Bytes)
namespace format{
namespace tools{


class HXCPP_CLASS_ATTRIBUTES  Deflate_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Deflate_obj OBJ_;
		Deflate_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Deflate_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Deflate_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Deflate"); }

		static ::haxe::io::Bytes run( ::haxe::io::Bytes b);
		static Dynamic run_dyn();

};

} // end namespace format
} // end namespace tools

#endif /* INCLUDED_format_tools_Deflate */ 
