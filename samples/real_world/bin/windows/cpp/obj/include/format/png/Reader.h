#ifndef INCLUDED_format_png_Reader
#define INCLUDED_format_png_Reader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(List)
HX_DECLARE_CLASS2(format,png,Chunk)
HX_DECLARE_CLASS2(format,png,Reader)
HX_DECLARE_CLASS2(haxe,io,Input)
namespace format{
namespace png{


class HXCPP_CLASS_ATTRIBUTES  Reader_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Reader_obj OBJ_;
		Reader_obj();
		Void __construct(::haxe::io::Input i);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Reader_obj > __new(::haxe::io::Input i);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Reader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Reader"); }

		::haxe::io::Input i;
		bool checkCRC;
		virtual ::List read( );
		Dynamic read_dyn();

		virtual Dynamic readHeader( ::haxe::io::Input i);
		Dynamic readHeader_dyn();

		virtual ::format::png::Chunk readChunk( );
		Dynamic readChunk_dyn();

};

} // end namespace format
} // end namespace png

#endif /* INCLUDED_format_png_Reader */ 
