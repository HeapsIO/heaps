#ifndef INCLUDED_hxd_res__EmbedFileSystem_EmbedEntry
#define INCLUDED_hxd_res__EmbedFileSystem_EmbedEntry

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/FileEntry.h>
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,impl,ArrayIterator)
HX_DECLARE_CLASS2(hxd,res,EmbedFileSystem)
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,FileSystem)
HX_DECLARE_CLASS3(hxd,res,_EmbedFileSystem,EmbedEntry)
namespace hxd{
namespace res{
namespace _EmbedFileSystem{


class HXCPP_CLASS_ATTRIBUTES  EmbedEntry_obj : public ::hxd::res::FileEntry_obj{
	public:
		typedef ::hxd::res::FileEntry_obj super;
		typedef EmbedEntry_obj OBJ_;
		EmbedEntry_obj();
		Void __construct(::hxd::res::EmbedFileSystem fs,::String name,::String relPath,::String data);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< EmbedEntry_obj > __new(::hxd::res::EmbedFileSystem fs,::String name,::String relPath,::String data);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~EmbedEntry_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("EmbedEntry"); }

		::hxd::res::EmbedFileSystem fs;
		::String relPath;
		::String data;
		::haxe::io::Bytes bytes;
		int readPos;
		virtual int getSign( );

		virtual ::haxe::io::Bytes getBytes( );

		virtual Void open( );

		virtual Void skip( int nbytes);

		virtual int readByte( );

		virtual Void read( ::haxe::io::Bytes out,int pos,int size);

		virtual Void close( );

		virtual Void load( Dynamic onReady);

		virtual Void loadBitmap( Dynamic onLoaded);

		virtual bool get_isDirectory( );

		virtual ::String get_path( );

		virtual bool exists( ::String name);

		virtual ::hxd::res::FileEntry get( ::String name);

		virtual int get_size( );

		virtual ::hxd::impl::ArrayIterator iterator( );

};

} // end namespace hxd
} // end namespace res
} // end namespace _EmbedFileSystem

#endif /* INCLUDED_hxd_res__EmbedFileSystem_EmbedEntry */ 
