#ifndef INCLUDED_h2d_FontChar
#define INCLUDED_h2d_FontChar

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,FontChar)
HX_DECLARE_CLASS1(h2d,Kerning)
HX_DECLARE_CLASS1(h2d,Tile)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  FontChar_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FontChar_obj OBJ_;
		FontChar_obj();
		Void __construct(::h2d::Tile t,int w);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FontChar_obj > __new(::h2d::Tile t,int w);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FontChar_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FontChar"); }

		::h2d::Tile t;
		int width;
		::h2d::Kerning kerning;
		virtual Void addKerning( int prevChar,int offset);
		Dynamic addKerning_dyn();

		virtual int getKerningOffset( int prevChar);
		Dynamic getKerningOffset_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_FontChar */ 
