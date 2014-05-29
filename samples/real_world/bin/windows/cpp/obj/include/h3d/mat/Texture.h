#ifndef INCLUDED_h3d_mat_Texture
#define INCLUDED_h3d_mat_Texture

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(h3d,impl,MemoryManager)
HX_DECLARE_CLASS2(h3d,mat,Filter)
HX_DECLARE_CLASS2(h3d,mat,MipMap)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(h3d,mat,TextureFormat)
HX_DECLARE_CLASS2(h3d,mat,Wrap)
HX_DECLARE_CLASS1(hxd,Pixels)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLTexture)
namespace h3d{
namespace mat{


class HXCPP_CLASS_ATTRIBUTES  Texture_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Texture_obj OBJ_;
		Texture_obj();
		Void __construct(::h3d::impl::MemoryManager m,::h3d::mat::TextureFormat fmt,int w,int h,bool c,bool ta,int mm);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Texture_obj > __new(::h3d::impl::MemoryManager m,::h3d::mat::TextureFormat fmt,int w,int h,bool c,bool ta,int mm);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Texture_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Texture"); }

		::openfl::gl::GLTexture t;
		::h3d::impl::MemoryManager mem;
		Dynamic allocPos;
		int id;
		int width;
		int height;
		bool isCubic;
		bool isTarget;
		int mipLevels;
		::h3d::mat::TextureFormat format;
		int bits;
		::h3d::mat::MipMap mipMap;
		::h3d::mat::Filter filter;
		::h3d::mat::Wrap wrap;
		bool alpha_premultiplied;
		Dynamic onContextLost;
		Dynamic &onContextLost_dyn() { return onContextLost;}
		virtual ::h3d::mat::MipMap set_mipMap( ::h3d::mat::MipMap m);
		Dynamic set_mipMap_dyn();

		virtual ::h3d::mat::Filter set_filter( ::h3d::mat::Filter f);
		Dynamic set_filter_dyn();

		virtual ::h3d::mat::Wrap set_wrap( ::h3d::mat::Wrap w);
		Dynamic set_wrap_dyn();

		virtual bool hasDefaultFlags( );
		Dynamic hasDefaultFlags_dyn();

		virtual bool isDisposed( );
		Dynamic isDisposed_dyn();

		virtual Void resize( int width,int height);
		Dynamic resize_dyn();

		virtual Void clear( int color);
		Dynamic clear_dyn();

		virtual Void uploadBitmap( ::flash::display::BitmapData bmp,Dynamic mipLevel,Dynamic side);
		Dynamic uploadBitmap_dyn();

		virtual Void uploadPixels( ::hxd::Pixels pixels,hx::Null< int >  mipLevel,hx::Null< int >  side);
		Dynamic uploadPixels_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		static int UID;
		static ::h3d::mat::Texture fromBitmap( ::flash::display::BitmapData bmp,Dynamic allocPos);
		static Dynamic fromBitmap_dyn();

		static ::h3d::mat::Texture fromPixels( ::hxd::Pixels pixels,Dynamic allocPos);
		static Dynamic fromPixels_dyn();

		static ::hxd::Pixels tmpPixels;
		static ::h3d::mat::Texture fromColor( int color,Dynamic allocPos);
		static Dynamic fromColor_dyn();

};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_Texture */ 
