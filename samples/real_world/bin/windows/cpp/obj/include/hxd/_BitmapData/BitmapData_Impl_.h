#ifndef INCLUDED_hxd__BitmapData_BitmapData_Impl_
#define INCLUDED_hxd__BitmapData_BitmapData_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS1(hxd,Pixels)
HX_DECLARE_CLASS2(hxd,_BitmapData,BitmapData_Impl_)
namespace hxd{
namespace _BitmapData{


class HXCPP_CLASS_ATTRIBUTES  BitmapData_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BitmapData_Impl__obj OBJ_;
		BitmapData_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BitmapData_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BitmapData_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("BitmapData_Impl_"); }

		static ::flash::display::BitmapData _new( int width,int height);
		static Dynamic _new_dyn();

		static Void clear( ::flash::display::BitmapData this1,int color);
		static Dynamic clear_dyn();

		static Void fill( ::flash::display::BitmapData this1,::h2d::col::Bounds rect,int color);
		static Dynamic fill_dyn();

		static Void line( ::flash::display::BitmapData this1,int x0,int y0,int x1,int y1,int color);
		static Dynamic line_dyn();

		static Void dispose( ::flash::display::BitmapData this1);
		static Dynamic dispose_dyn();

		static int getPixel( ::flash::display::BitmapData this1,int x,int y);
		static Dynamic getPixel_dyn();

		static Void setPixel( ::flash::display::BitmapData this1,int x,int y,int c);
		static Dynamic setPixel_dyn();

		static int get_width( ::flash::display::BitmapData this1);
		static Dynamic get_width_dyn();

		static int get_height( ::flash::display::BitmapData this1);
		static Dynamic get_height_dyn();

		static ::hxd::Pixels getPixels( ::flash::display::BitmapData this1);
		static Dynamic getPixels_dyn();

		static Void setPixels( ::flash::display::BitmapData this1,::hxd::Pixels pixels);
		static Dynamic setPixels_dyn();

		static ::flash::display::BitmapData toNative( ::flash::display::BitmapData this1);
		static Dynamic toNative_dyn();

		static ::flash::display::BitmapData fromNative( ::flash::display::BitmapData bmp);
		static Dynamic fromNative_dyn();

		static ::hxd::Pixels nativeGetPixels( ::flash::display::BitmapData b);
		static Dynamic nativeGetPixels_dyn();

		static Void nativeSetPixels( ::flash::display::BitmapData b,::hxd::Pixels pixels);
		static Dynamic nativeSetPixels_dyn();

};

} // end namespace hxd
} // end namespace _BitmapData

#endif /* INCLUDED_hxd__BitmapData_BitmapData_Impl_ */ 
