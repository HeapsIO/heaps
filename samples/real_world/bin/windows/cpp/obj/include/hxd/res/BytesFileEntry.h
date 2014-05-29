#ifndef INCLUDED_hxd_res_BytesFileEntry
#define INCLUDED_hxd_res_BytesFileEntry

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/FileEntry.h>
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,impl,ArrayIterator)
HX_DECLARE_CLASS2(hxd,res,BytesFileEntry)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  BytesFileEntry_obj : public ::hxd::res::FileEntry_obj{
	public:
		typedef ::hxd::res::FileEntry_obj super;
		typedef BytesFileEntry_obj OBJ_;
		BytesFileEntry_obj();
		Void __construct(::String path,::haxe::io::Bytes bytes);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BytesFileEntry_obj > __new(::String path,::haxe::io::Bytes bytes);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BytesFileEntry_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BytesFileEntry"); }

		::String fullPath;
		::haxe::io::Bytes bytes;
		int pos;
		virtual ::String get_path( );

		virtual int getSign( );

		virtual ::haxe::io::Bytes getBytes( );

		virtual Void open( );

		virtual Void skip( int nbytes);

		virtual int readByte( );

		virtual Void read( ::haxe::io::Bytes out,int pos,int size);

		virtual Void close( );

		virtual Void load( Dynamic onReady);

		virtual Void loadBitmap( Dynamic onLoaded);

		virtual bool exists( ::String name);

		virtual ::hxd::res::FileEntry get( ::String name);

		virtual ::hxd::impl::ArrayIterator iterator( );

		virtual int get_size( );

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_BytesFileEntry */ 
