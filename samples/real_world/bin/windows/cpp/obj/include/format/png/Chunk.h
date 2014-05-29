#ifndef INCLUDED_format_png_Chunk
#define INCLUDED_format_png_Chunk

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(format,png,Chunk)
HX_DECLARE_CLASS2(haxe,io,Bytes)
namespace format{
namespace png{


class Chunk_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Chunk_obj OBJ_;

	public:
		Chunk_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("format.png.Chunk"); }
		::String __ToString() const { return HX_CSTRING("Chunk.") + tag; }

		static ::format::png::Chunk CData(::haxe::io::Bytes b);
		static Dynamic CData_dyn();
		static ::format::png::Chunk CEnd;
		static inline ::format::png::Chunk CEnd_dyn() { return CEnd; }
		static ::format::png::Chunk CHeader(Dynamic h);
		static Dynamic CHeader_dyn();
		static ::format::png::Chunk CPalette(::haxe::io::Bytes b);
		static Dynamic CPalette_dyn();
		static ::format::png::Chunk CUnknown(::String id,::haxe::io::Bytes data);
		static Dynamic CUnknown_dyn();
};

} // end namespace format
} // end namespace png

#endif /* INCLUDED_format_png_Chunk */ 
