#ifndef INCLUDED_hxd_res_Loader
#define INCLUDED_hxd_res_Loader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(hxd,res,Any)
HX_DECLARE_CLASS2(hxd,res,BitmapFont)
HX_DECLARE_CLASS2(hxd,res,FileSystem)
HX_DECLARE_CLASS2(hxd,res,Font)
HX_DECLARE_CLASS2(hxd,res,Loader)
HX_DECLARE_CLASS2(hxd,res,Model)
HX_DECLARE_CLASS2(hxd,res,Resource)
HX_DECLARE_CLASS2(hxd,res,Sound)
HX_DECLARE_CLASS2(hxd,res,Texture)
HX_DECLARE_CLASS2(hxd,res,TiledMap)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  Loader_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Loader_obj OBJ_;
		Loader_obj();
		Void __construct(::hxd::res::FileSystem fs);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Loader_obj > __new(::hxd::res::FileSystem fs);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Loader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Loader"); }

		::hxd::res::FileSystem fs;
		::haxe::ds::StringMap cache;
		virtual bool exists( ::String path);
		Dynamic exists_dyn();

		virtual ::hxd::res::Any load( ::String path);
		Dynamic load_dyn();

		virtual ::hxd::res::Texture loadTexture( ::String path);
		Dynamic loadTexture_dyn();

		virtual ::hxd::res::Model loadModel( ::String path);
		Dynamic loadModel_dyn();

		virtual ::hxd::res::Sound loadSound( ::String path);
		Dynamic loadSound_dyn();

		virtual ::hxd::res::Font loadFont( ::String path);
		Dynamic loadFont_dyn();

		virtual ::hxd::res::BitmapFont loadBitmapFont( ::String path);
		Dynamic loadBitmapFont_dyn();

		virtual ::hxd::res::Resource loadData( ::String path);
		Dynamic loadData_dyn();

		virtual ::hxd::res::TiledMap loadTiledMap( ::String path);
		Dynamic loadTiledMap_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Loader */ 
