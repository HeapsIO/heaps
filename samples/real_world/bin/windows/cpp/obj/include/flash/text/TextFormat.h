#ifndef INCLUDED_flash_text_TextFormat
#define INCLUDED_flash_text_TextFormat

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,TextFormat)
namespace flash{
namespace text{


class HXCPP_CLASS_ATTRIBUTES  TextFormat_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef TextFormat_obj OBJ_;
		TextFormat_obj();
		Void __construct(::String font,Dynamic size,Dynamic color,Dynamic bold,Dynamic italic,Dynamic underline,::String url,::String target,::String align,Dynamic leftMargin,Dynamic rightMargin,Dynamic indent,Dynamic leading);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< TextFormat_obj > __new(::String font,Dynamic size,Dynamic color,Dynamic bold,Dynamic italic,Dynamic underline,::String url,::String target,::String align,Dynamic leftMargin,Dynamic rightMargin,Dynamic indent,Dynamic leading);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~TextFormat_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("TextFormat"); }

		::String align;
		Dynamic blockIndent;
		Dynamic bold;
		Dynamic bullet;
		Dynamic color;
		::String display;
		::String font;
		Dynamic indent;
		Dynamic italic;
		Dynamic kerning;
		Dynamic leading;
		Dynamic leftMargin;
		Dynamic letterSpacing;
		Dynamic rightMargin;
		Dynamic size;
		Array< int > tabStops;
		::String target;
		Dynamic underline;
		::String url;
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_TextFormat */ 
