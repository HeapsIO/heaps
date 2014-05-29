#ifndef INCLUDED_DefaultAssetLibrary
#define INCLUDED_DefaultAssetLibrary

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <openfl/AssetLibrary.h>
HX_DECLARE_CLASS0(DefaultAssetLibrary)
HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(flash,display,BitmapData)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,media,Sound)
HX_DECLARE_CLASS2(flash,text,Font)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS1(openfl,AssetLibrary)
HX_DECLARE_CLASS1(openfl,AssetType)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)


class HXCPP_CLASS_ATTRIBUTES  DefaultAssetLibrary_obj : public ::openfl::AssetLibrary_obj{
	public:
		typedef ::openfl::AssetLibrary_obj super;
		typedef DefaultAssetLibrary_obj OBJ_;
		DefaultAssetLibrary_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< DefaultAssetLibrary_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~DefaultAssetLibrary_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("DefaultAssetLibrary"); }

		virtual bool exists( ::String id,::openfl::AssetType type);

		virtual ::flash::display::BitmapData getBitmapData( ::String id);

		virtual ::flash::utils::ByteArray getBytes( ::String id);

		virtual ::flash::text::Font getFont( ::String id);

		virtual ::flash::media::Sound getMusic( ::String id);

		virtual ::String getPath( ::String id);

		virtual ::flash::media::Sound getSound( ::String id);

		virtual ::String getText( ::String id);

		virtual bool isLocal( ::String id,::openfl::AssetType type);

		virtual Void loadBitmapData( ::String id,Dynamic handler);

		virtual Void loadBytes( ::String id,Dynamic handler);

		virtual Void loadFont( ::String id,Dynamic handler);

		virtual Void loadMusic( ::String id,Dynamic handler);

		virtual Void loadSound( ::String id,Dynamic handler);

		virtual Void loadText( ::String id,Dynamic handler);

		static ::haxe::ds::StringMap className;
		static ::haxe::ds::StringMap path;
		static ::haxe::ds::StringMap type;
};


#endif /* INCLUDED_DefaultAssetLibrary */ 
