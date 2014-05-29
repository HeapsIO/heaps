#ifndef INCLUDED_hxd_Pixels
#define INCLUDED_hxd_Pixels

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS1(hxd,PixelFormat)
HX_DECLARE_CLASS1(hxd,Pixels)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Pixels_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Pixels_obj OBJ_;
		Pixels_obj();
		Void __construct(int width,int height,::haxe::io::Bytes bytes,::hxd::PixelFormat format,Dynamic __o_offset);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Pixels_obj > __new(int width,int height,::haxe::io::Bytes bytes,::hxd::PixelFormat format,Dynamic __o_offset);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Pixels_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Pixels"); }

		::haxe::io::Bytes bytes;
		::hxd::PixelFormat format;
		int width;
		int height;
		int offset;
		int flags;
		virtual ::hxd::Pixels makeSquare( Dynamic copy);
		Dynamic makeSquare_dyn();

		virtual bool convert( ::hxd::PixelFormat target);
		Dynamic convert_dyn();

		virtual int getPixel( int x,int y);
		Dynamic getPixel_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		static int bytesPerPixel( ::hxd::PixelFormat format);
		static Dynamic bytesPerPixel_dyn();

		static ::hxd::Pixels alloc( int width,int height,::hxd::PixelFormat format);
		static Dynamic alloc_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Pixels */ 
