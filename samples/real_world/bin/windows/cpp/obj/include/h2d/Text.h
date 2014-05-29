#ifndef INCLUDED_h2d_Text
#define INCLUDED_h2d_Text

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Drawable.h>
HX_DECLARE_CLASS1(h2d,Align)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Font)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Text)
HX_DECLARE_CLASS1(h2d,TileGroup)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Text_obj : public ::h2d::Drawable_obj{
	public:
		typedef ::h2d::Drawable_obj super;
		typedef Text_obj OBJ_;
		Text_obj();
		Void __construct(::h2d::Font font,::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Text_obj > __new(::h2d::Font font,::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Text_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Text"); }

		::h2d::Font font;
		::String text;
		int textColor;
		Dynamic maxWidth;
		Dynamic dropShadow;
		int textWidth;
		int textHeight;
		::h2d::Align textAlign;
		int letterSpacing;
		::h2d::TileGroup glyphs;
		virtual ::h2d::Font set_font( ::h2d::Font font);
		Dynamic set_font_dyn();

		virtual ::h2d::Align set_textAlign( ::h2d::Align a);
		Dynamic set_textAlign_dyn();

		virtual int set_letterSpacing( int s);
		Dynamic set_letterSpacing_dyn();

		virtual Void onAlloc( );

		virtual Void draw( ::h3d::scene::RenderContext ctx);

		virtual ::h2d::col::Bounds getMyBounds( );

		virtual ::String set_text( ::String t);
		Dynamic set_text_dyn();

		virtual Void rebuild( );
		Dynamic rebuild_dyn();

		virtual int calcTextWidth( ::String text);
		Dynamic calcTextWidth_dyn();

		virtual Dynamic initGlyphs( ::String text,hx::Null< bool >  rebuild,Array< int > lines);
		Dynamic initGlyphs_dyn();

		virtual int get_textHeight( );
		Dynamic get_textHeight_dyn();

		virtual int get_textWidth( );
		Dynamic get_textWidth_dyn();

		virtual Dynamic set_maxWidth( Dynamic w);
		Dynamic set_maxWidth_dyn();

		virtual int set_textColor( int c);
		Dynamic set_textColor_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Text */ 
