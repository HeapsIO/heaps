#ifndef INCLUDED_h2d_Font
#define INCLUDED_h2d_Font

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS1(h2d,Font)
HX_DECLARE_CLASS1(h2d,FontChar)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS1(hxd,Charset)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Font_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Font_obj OBJ_;
		Font_obj();
		Void __construct(::String name,int size);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Font_obj > __new(::String name,int size);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Font_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Font"); }

		::String name;
		int size;
		int lineHeight;
		::h2d::Tile tile;
		::hxd::Charset charset;
		::haxe::ds::IntMap glyphs;
		::h2d::FontChar defaultChar;
		virtual ::h2d::FontChar getChar( int code);
		Dynamic getChar_dyn();

		virtual Void resizeTo( int size);
		Dynamic resizeTo_dyn();

		virtual bool hasChar( int code);
		Dynamic hasChar_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Font */ 
