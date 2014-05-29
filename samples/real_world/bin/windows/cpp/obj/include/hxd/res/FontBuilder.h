#ifndef INCLUDED_hxd_res_FontBuilder
#define INCLUDED_hxd_res_FontBuilder

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS1(h2d,Font)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(hxd,res,FontBuilder)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  FontBuilder_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FontBuilder_obj OBJ_;
		FontBuilder_obj();
		Void __construct(::String name,int size,Dynamic opt);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FontBuilder_obj > __new(::String name,int size,Dynamic opt);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FontBuilder_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FontBuilder"); }

		::h2d::Font font;
		Dynamic options;
		::h3d::mat::Texture innerTex;
		virtual Array< int > getUtf8StringAsArray( ::String str);
		Dynamic getUtf8StringAsArray_dyn();

		virtual Dynamic isolateUtf8Blocs( Array< int > codes);
		Dynamic isolateUtf8Blocs_dyn();

		virtual ::h2d::Font build( );
		Dynamic build_dyn();

		static ::h2d::Font getFont( ::String name,int size,Dynamic options);
		static Dynamic getFont_dyn();

		static Void dispose( );
		static Dynamic dispose_dyn();

		static ::haxe::ds::StringMap FONTS;
};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_FontBuilder */ 
