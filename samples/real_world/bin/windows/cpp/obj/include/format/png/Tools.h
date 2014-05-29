#ifndef INCLUDED_format_png_Tools
#define INCLUDED_format_png_Tools

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(List)
HX_DECLARE_CLASS2(format,png,Tools)
HX_DECLARE_CLASS2(haxe,io,Bytes)
namespace format{
namespace png{


class HXCPP_CLASS_ATTRIBUTES  Tools_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Tools_obj OBJ_;
		Tools_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Tools_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Tools_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Tools"); }

		static Dynamic getHeader( ::List d);
		static Dynamic getHeader_dyn();

		static ::haxe::io::Bytes getPalette( ::List d);
		static Dynamic getPalette_dyn();

		static int filter( ::haxe::io::Bytes data,int x,int y,int stride,int prev,int p,hx::Null< int >  numChannels);
		static Dynamic filter_dyn();

		static Void reverseBytes( ::haxe::io::Bytes b);
		static Dynamic reverseBytes_dyn();

		static ::haxe::io::Bytes extractGrey( ::List d);
		static Dynamic extractGrey_dyn();

		static ::haxe::io::Bytes extract32( ::List d,::haxe::io::Bytes bytes);
		static Dynamic extract32_dyn();

		static ::List buildGrey( int width,int height,::haxe::io::Bytes data);
		static Dynamic buildGrey_dyn();

		static ::List buildRGB( int width,int height,::haxe::io::Bytes data);
		static Dynamic buildRGB_dyn();

		static ::List build32ARGB( int width,int height,::haxe::io::Bytes data);
		static Dynamic build32ARGB_dyn();

		static ::List build32BGRA( int width,int height,::haxe::io::Bytes data);
		static Dynamic build32BGRA_dyn();

};

} // end namespace format
} // end namespace png

#endif /* INCLUDED_format_png_Tools */ 
