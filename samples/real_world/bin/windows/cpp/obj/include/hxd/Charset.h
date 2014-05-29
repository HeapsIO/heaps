#ifndef INCLUDED_hxd_Charset
#define INCLUDED_hxd_Charset

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS1(hxd,Charset)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Charset_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Charset_obj OBJ_;
		Charset_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Charset_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Charset_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Charset"); }

		::haxe::ds::IntMap map;
		virtual Dynamic resolveChar( int cc,::haxe::ds::IntMap glyphs);
		Dynamic resolveChar_dyn();

		virtual bool isSpace( int cc);
		Dynamic isSpace_dyn();

		virtual bool isBreakChar( int cc);
		Dynamic isBreakChar_dyn();

		static ::String JP_KANA;
		static ::String ASCII;
		static ::String LATIN1;
		static ::String DEFAULT_CHARS;
		static ::hxd::Charset inst;
		static ::hxd::Charset getDefault( );
		static Dynamic getDefault_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Charset */ 
