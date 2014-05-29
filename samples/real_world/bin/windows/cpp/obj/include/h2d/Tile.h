#ifndef INCLUDED_h2d_Tile
#define INCLUDED_h2d_Tile

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(haxe,ds,IntMap)
HX_DECLARE_CLASS1(hxd,Pixels)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Tile_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Tile_obj OBJ_;
		Tile_obj();
		Void __construct(::h3d::mat::Texture tex,int x,int y,int w,int h,hx::Null< int >  __o_dx,hx::Null< int >  __o_dy);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Tile_obj > __new(::h3d::mat::Texture tex,int x,int y,int w,int h,hx::Null< int >  __o_dx,hx::Null< int >  __o_dy);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Tile_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Tile"); }

		::h3d::mat::Texture innerTex;
		Float u;
		Float v;
		Float u2;
		Float v2;
		int dx;
		int dy;
		int x;
		int y;
		int width;
		int height;
		virtual ::h3d::mat::Texture getTexture( );
		Dynamic getTexture_dyn();

		virtual bool isDisposed( );
		Dynamic isDisposed_dyn();

		virtual Void setTexture( ::h3d::mat::Texture tex);
		Dynamic setTexture_dyn();

		virtual Void switchTexture( ::h2d::Tile t);
		Dynamic switchTexture_dyn();

		virtual ::h2d::Tile sub( int x,int y,int w,int h,hx::Null< int >  dx,hx::Null< int >  dy);
		Dynamic sub_dyn();

		virtual ::h2d::Tile center( Dynamic dx,Dynamic dy);
		Dynamic center_dyn();

		virtual ::h2d::Tile centerRatio( Dynamic px,Dynamic py);
		Dynamic centerRatio_dyn();

		virtual Void setCenter( Dynamic dx,Dynamic dy);
		Dynamic setCenter_dyn();

		virtual Void setCenterRatio( Dynamic px,Dynamic py);
		Dynamic setCenterRatio_dyn();

		virtual Void setPos( int x,int y);
		Dynamic setPos_dyn();

		virtual Void setSize( int w,int h);
		Dynamic setSize_dyn();

		virtual Void scaleToSize( int w,int h);
		Dynamic scaleToSize_dyn();

		virtual Void scrollDiscrete( Float dx,Float dy);
		Dynamic scrollDiscrete_dyn();

		virtual Void flipX( );
		Dynamic flipX_dyn();

		virtual Void flipY( );
		Dynamic flipY_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		virtual ::h2d::Tile clone( );
		Dynamic clone_dyn();

		virtual ::h2d::Tile copy( ::h2d::Tile t);
		Dynamic copy_dyn();

		virtual Array< ::Dynamic > split( int frames,hx::Null< bool >  vertical);
		Dynamic split_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual Void upload( ::flash::display::BitmapData bmp);
		Dynamic upload_dyn();

		static Float EPSILON_PIXEL;
		static ::h2d::Tile fromFlashBitmap( ::flash::display::BitmapData bmp,Dynamic allocPos);
		static Dynamic fromFlashBitmap_dyn();

		static ::h2d::Tile fromBitmap( ::flash::display::BitmapData bmp,Dynamic allocPos);
		static Dynamic fromBitmap_dyn();

		static ::h2d::Tile fromTexture( ::h3d::mat::Texture t);
		static Dynamic fromTexture_dyn();

		static ::h2d::Tile fromPixels( ::hxd::Pixels pixels,Dynamic allocPos);
		static Dynamic fromPixels_dyn();

		static ::h2d::Tile fromSprite( ::flash::display::DisplayObject sprite,Dynamic allocPos);
		static Dynamic fromSprite_dyn();

		static Array< ::Dynamic > fromSprites( Array< ::Dynamic > sprites,Dynamic allocPos);
		static Dynamic fromSprites_dyn();

		static ::haxe::ds::IntMap COLOR_CACHE;
		static ::h2d::Tile fromColor( int color,hx::Null< int >  width,Dynamic height,Dynamic allocPos);
		static Dynamic fromColor_dyn();

		static Dynamic autoCut( ::flash::display::BitmapData bmp,int width,Dynamic height,Dynamic allocPos);
		static Dynamic autoCut_dyn();

		static Dynamic isEmpty( ::flash::display::BitmapData b,int px,int py,int width,int height,int bg);
		static Dynamic isEmpty_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Tile */ 
