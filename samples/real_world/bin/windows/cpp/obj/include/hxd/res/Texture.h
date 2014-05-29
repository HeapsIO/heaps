#ifndef INCLUDED_hxd_res_Texture
#define INCLUDED_hxd_res_Texture

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/Resource.h>
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS1(hxd,Pixels)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Resource)
HX_DECLARE_CLASS2(hxd,res,Texture)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  Texture_obj : public ::hxd::res::Resource_obj{
	public:
		typedef ::hxd::res::Resource_obj super;
		typedef Texture_obj OBJ_;
		Texture_obj();
		Void __construct(::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Texture_obj > __new(::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Texture_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Texture"); }

		bool needResize;
		::h3d::mat::Texture tex;
		Dynamic inf;
		virtual bool isPNG( );
		Dynamic isPNG_dyn();

		virtual Void checkResize( );
		Dynamic checkResize_dyn();

		virtual Dynamic getSize( );
		Dynamic getSize_dyn();

		virtual ::hxd::Pixels getPixels( );
		Dynamic getPixels_dyn();

		virtual ::flash::display::BitmapData toBitmap( );
		Dynamic toBitmap_dyn();

		virtual Void loadTexture( );
		Dynamic loadTexture_dyn();

		virtual ::h3d::mat::Texture toTexture( );
		Dynamic toTexture_dyn();

		virtual ::h2d::Tile toTile( );
		Dynamic toTile_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Texture */ 
