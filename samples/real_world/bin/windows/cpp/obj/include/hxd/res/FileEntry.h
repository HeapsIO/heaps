#ifndef INCLUDED_hxd_res_FileEntry
#define INCLUDED_hxd_res_FileEntry

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,impl,ArrayIterator)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  FileEntry_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FileEntry_obj OBJ_;
		FileEntry_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FileEntry_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FileEntry_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FileEntry"); }

		::String name;
		virtual int getSign( );
		Dynamic getSign_dyn();

		virtual ::haxe::io::Bytes getBytes( );
		Dynamic getBytes_dyn();

		virtual Void open( );
		Dynamic open_dyn();

		virtual Void skip( int nbytes);
		Dynamic skip_dyn();

		virtual int readByte( );
		Dynamic readByte_dyn();

		virtual Void read( ::haxe::io::Bytes out,int pos,int size);
		Dynamic read_dyn();

		virtual Void close( );
		Dynamic close_dyn();

		virtual Void load( Dynamic onReady);
		Dynamic load_dyn();

		virtual Void loadBitmap( Dynamic onLoaded);
		Dynamic loadBitmap_dyn();

		virtual bool exists( ::String name);
		Dynamic exists_dyn();

		virtual ::hxd::res::FileEntry get( ::String name);
		Dynamic get_dyn();

		virtual ::hxd::impl::ArrayIterator iterator( );
		Dynamic iterator_dyn();

		virtual bool get_isAvailable( );
		Dynamic get_isAvailable_dyn();

		virtual bool get_isDirectory( );
		Dynamic get_isDirectory_dyn();

		virtual int get_size( );
		Dynamic get_size_dyn();

		virtual ::String get_path( );
		Dynamic get_path_dyn();

		virtual ::String get_extension( );
		Dynamic get_extension_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_FileEntry */ 
