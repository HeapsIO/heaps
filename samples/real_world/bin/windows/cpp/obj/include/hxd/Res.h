#ifndef INCLUDED_hxd_Res
#define INCLUDED_hxd_Res

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,Res)
HX_DECLARE_CLASS2(hxd,res,Any)
HX_DECLARE_CLASS2(hxd,res,Font)
HX_DECLARE_CLASS2(hxd,res,Loader)
HX_DECLARE_CLASS2(hxd,res,Resource)
HX_DECLARE_CLASS2(hxd,res,Texture)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Res_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Res_obj OBJ_;
		Res_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Res_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Res_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Res"); }

		static ::hxd::res::Any load( ::String name);
		static Dynamic load_dyn();

		static ::hxd::res::Loader loader;
		static ::hxd::res::Texture get_char( );
		static Dynamic get_char_dyn();

		static ::hxd::res::Texture get_haxe( );
		static Dynamic get_haxe_dyn();

		static ::hxd::res::Texture get_haxe2k( );
		static Dynamic get_haxe2k_dyn();

		static ::hxd::res::Texture get_nme( );
		static Dynamic get_nme_dyn();

		static ::hxd::res::Texture get_openfl( );
		static Dynamic get_openfl_dyn();

		static ::hxd::res::Font get_Roboto( );
		static Dynamic get_Roboto_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Res */ 
