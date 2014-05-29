#ifndef INCLUDED_h2d_Bitmap
#define INCLUDED_h2d_Bitmap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Drawable.h>
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS1(h2d,Bitmap)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,DrawableShader)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h3d,impl,Shader)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
HX_DECLARE_CLASS1(hxd,Pixels)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Bitmap_obj : public ::h2d::Drawable_obj{
	public:
		typedef ::h2d::Drawable_obj super;
		typedef Bitmap_obj OBJ_;
		Bitmap_obj();
		Void __construct(::h2d::Tile tile,::h2d::Sprite parent,::h2d::DrawableShader sh);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Bitmap_obj > __new(::h2d::Tile tile,::h2d::Sprite parent,::h2d::DrawableShader sh);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Bitmap_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Bitmap"); }

		::h2d::Tile tile;
		virtual ::h2d::Bitmap clone( );
		Dynamic clone_dyn();

		virtual Void draw( ::h3d::scene::RenderContext ctx);

		virtual ::h2d::col::Bounds getMyBounds( );

		static ::h2d::Bitmap create( ::flash::display::BitmapData bmp,::h2d::Sprite parent,Dynamic allocPos);
		static Dynamic create_dyn();

		static ::h2d::Bitmap fromBitmapData( ::flash::display::BitmapData bmd,::h2d::Sprite parent);
		static Dynamic fromBitmapData_dyn();

		static ::h2d::Bitmap fromPixels( ::hxd::Pixels pix,::h2d::Sprite parent);
		static Dynamic fromPixels_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Bitmap */ 
