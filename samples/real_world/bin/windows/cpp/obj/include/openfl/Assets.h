#ifndef INCLUDED_openfl_Assets
#define INCLUDED_openfl_Assets

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,display,MovieClip)
HX_DECLARE_CLASS2(flash,display,Sprite)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,media,Sound)
HX_DECLARE_CLASS2(flash,text,Font)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS1(openfl,AssetCache)
HX_DECLARE_CLASS1(openfl,AssetLibrary)
HX_DECLARE_CLASS1(openfl,AssetType)
HX_DECLARE_CLASS1(openfl,Assets)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace openfl{


class HXCPP_CLASS_ATTRIBUTES  Assets_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Assets_obj OBJ_;
		Assets_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Assets_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Assets_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Assets"); }

		static ::openfl::AssetCache cache;
		static ::haxe::ds::StringMap libraries;
		static bool initialized;
		static bool exists( ::String id,::openfl::AssetType type);
		static Dynamic exists_dyn();

		static ::flash::display::BitmapData getBitmapData( ::String id,hx::Null< bool >  useCache);
		static Dynamic getBitmapData_dyn();

		static ::flash::utils::ByteArray getBytes( ::String id);
		static Dynamic getBytes_dyn();

		static ::flash::text::Font getFont( ::String id,hx::Null< bool >  useCache);
		static Dynamic getFont_dyn();

		static ::openfl::AssetLibrary getLibrary( ::String name);
		static Dynamic getLibrary_dyn();

		static ::flash::display::MovieClip getMovieClip( ::String id);
		static Dynamic getMovieClip_dyn();

		static ::flash::media::Sound getMusic( ::String id,hx::Null< bool >  useCache);
		static Dynamic getMusic_dyn();

		static ::String getPath( ::String id);
		static Dynamic getPath_dyn();

		static ::flash::media::Sound getSound( ::String id,hx::Null< bool >  useCache);
		static Dynamic getSound_dyn();

		static ::String getText( ::String id);
		static Dynamic getText_dyn();

		static Void initialize( );
		static Dynamic initialize_dyn();

		static bool isLocal( ::String id,::openfl::AssetType type,hx::Null< bool >  useCache);
		static Dynamic isLocal_dyn();

		static bool isValidBitmapData( ::flash::display::BitmapData bitmapData);
		static Dynamic isValidBitmapData_dyn();

		static bool isValidSound( ::flash::media::Sound sound);
		static Dynamic isValidSound_dyn();

		static Void loadBitmapData( ::String id,Dynamic handler,hx::Null< bool >  useCache);
		static Dynamic loadBitmapData_dyn();

		static Void loadBytes( ::String id,Dynamic handler);
		static Dynamic loadBytes_dyn();

		static Void loadFont( ::String id,Dynamic handler,hx::Null< bool >  useCache);
		static Dynamic loadFont_dyn();

		static Void loadLibrary( ::String name,Dynamic handler);
		static Dynamic loadLibrary_dyn();

		static Void loadMusic( ::String id,Dynamic handler,hx::Null< bool >  useCache);
		static Dynamic loadMusic_dyn();

		static Void loadMovieClip( ::String id,Dynamic handler);
		static Dynamic loadMovieClip_dyn();

		static Void loadSound( ::String id,Dynamic handler,hx::Null< bool >  useCache);
		static Dynamic loadSound_dyn();

		static Void loadText( ::String id,Dynamic handler);
		static Dynamic loadText_dyn();

		static Void registerLibrary( ::String name,::openfl::AssetLibrary library);
		static Dynamic registerLibrary_dyn();

		static ::Class resolveClass( ::String name);
		static Dynamic resolveClass_dyn();

		static ::Enum resolveEnum( ::String name);
		static Dynamic resolveEnum_dyn();

		static Void unloadLibrary( ::String name);
		static Dynamic unloadLibrary_dyn();

};

} // end namespace openfl

#endif /* INCLUDED_openfl_Assets */ 
