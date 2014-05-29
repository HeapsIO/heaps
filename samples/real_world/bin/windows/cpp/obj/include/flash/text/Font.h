#ifndef INCLUDED_flash_text_Font
#define INCLUDED_flash_text_Font

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,Font)
HX_DECLARE_CLASS2(flash,text,FontStyle)
HX_DECLARE_CLASS2(flash,text,FontType)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace flash{
namespace text{


class HXCPP_CLASS_ATTRIBUTES  Font_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Font_obj OBJ_;
		Font_obj();
		Void __construct(::String __o_filename,::flash::text::FontStyle style,::flash::text::FontType type);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Font_obj > __new(::String __o_filename,::flash::text::FontStyle style,::flash::text::FontType type);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Font_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Font"); }

		::String fontName;
		::flash::text::FontStyle fontStyle;
		::flash::text::FontType fontType;
		virtual ::String toString( );
		Dynamic toString_dyn();

		static Array< ::Dynamic > __registeredFonts;
		static Array< ::Dynamic > __deviceFonts;
		static Array< ::Dynamic > enumerateFonts( hx::Null< bool >  enumerateDeviceFonts);
		static Dynamic enumerateFonts_dyn();

		static Dynamic load( ::String filename);
		static Dynamic load_dyn();

		static Dynamic loadBytes( ::flash::utils::ByteArray bytes);
		static Dynamic loadBytes_dyn();

		static Void registerFont( ::Class font);
		static Dynamic registerFont_dyn();

		static Dynamic freetype_import_font;
		static Dynamic &freetype_import_font_dyn() { return freetype_import_font;}
		static Dynamic lime_font_register_font;
		static Dynamic &lime_font_register_font_dyn() { return lime_font_register_font;}
		static Dynamic lime_font_iterate_device_fonts;
		static Dynamic &lime_font_iterate_device_fonts_dyn() { return lime_font_iterate_device_fonts;}
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_Font */ 
