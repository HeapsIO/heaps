#ifndef INCLUDED_hxd_res_Any
#define INCLUDED_hxd_res_Any

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/Resource.h>
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h3d,fbx,Library)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,impl,ArrayIterator)
HX_DECLARE_CLASS2(hxd,res,Any)
HX_DECLARE_CLASS2(hxd,res,BitmapFont)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Font)
HX_DECLARE_CLASS2(hxd,res,Loader)
HX_DECLARE_CLASS2(hxd,res,Model)
HX_DECLARE_CLASS2(hxd,res,Resource)
HX_DECLARE_CLASS2(hxd,res,Sound)
HX_DECLARE_CLASS2(hxd,res,Texture)
HX_DECLARE_CLASS2(hxd,res,TiledMap)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  Any_obj : public ::hxd::res::Resource_obj{
	public:
		typedef ::hxd::res::Resource_obj super;
		typedef Any_obj OBJ_;
		Any_obj();
		Void __construct(::hxd::res::Loader loader,::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Any_obj > __new(::hxd::res::Loader loader,::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Any_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Any"); }

		::hxd::res::Loader loader;
		virtual ::hxd::res::Model toModel( );
		Dynamic toModel_dyn();

		virtual ::h3d::fbx::Library toFbx( );
		Dynamic toFbx_dyn();

		virtual ::h3d::mat::Texture toTexture( );
		Dynamic toTexture_dyn();

		virtual ::h2d::Tile toTile( );
		Dynamic toTile_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::hxd::res::Texture toImage( );
		Dynamic toImage_dyn();

		virtual ::hxd::res::Texture getTexture( );
		Dynamic getTexture_dyn();

		virtual ::hxd::res::Sound toSound( );
		Dynamic toSound_dyn();

		virtual ::hxd::res::Font toFont( );
		Dynamic toFont_dyn();

		virtual ::flash::display::BitmapData toBitmap( );
		Dynamic toBitmap_dyn();

		virtual ::hxd::res::BitmapFont toBitmapFont( );
		Dynamic toBitmapFont_dyn();

		virtual ::hxd::res::TiledMap toTiledMap( );
		Dynamic toTiledMap_dyn();

		virtual ::hxd::impl::ArrayIterator iterator( );
		Dynamic iterator_dyn();

		static ::hxd::res::Any fromBytes( ::String path,::haxe::io::Bytes bytes);
		static Dynamic fromBytes_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Any */ 
