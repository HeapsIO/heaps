#include <hxcpp.h>

#ifndef INCLUDED_DefaultAssetLibrary
#include <DefaultAssetLibrary.h>
#endif
#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObjectContainer
#include <flash/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_InteractiveObject
#include <flash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_flash_display_MovieClip
#include <flash/display/MovieClip.h>
#endif
#ifndef INCLUDED_flash_display_Sprite
#include <flash/display/Sprite.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_media_Sound
#include <flash/media/Sound.h>
#endif
#ifndef INCLUDED_flash_text_Font
#include <flash/text/Font.h>
#endif
#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_Unserializer
#include <haxe/Unserializer.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_openfl_AssetCache
#include <openfl/AssetCache.h>
#endif
#ifndef INCLUDED_openfl_AssetLibrary
#include <openfl/AssetLibrary.h>
#endif
#ifndef INCLUDED_openfl_AssetType
#include <openfl/AssetType.h>
#endif
#ifndef INCLUDED_openfl_Assets
#include <openfl/Assets.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace openfl{

Void Assets_obj::__construct()
{
	return null();
}

//Assets_obj::~Assets_obj() { }

Dynamic Assets_obj::__CreateEmpty() { return  new Assets_obj; }
hx::ObjectPtr< Assets_obj > Assets_obj::__new()
{  hx::ObjectPtr< Assets_obj > result = new Assets_obj();
	result->__construct();
	return result;}

Dynamic Assets_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Assets_obj > result = new Assets_obj();
	result->__construct();
	return result;}

::openfl::AssetCache Assets_obj::cache;

::haxe::ds::StringMap Assets_obj::libraries;

bool Assets_obj::initialized;

bool Assets_obj::exists( ::String id,::openfl::AssetType type){
	HX_STACK_FRAME("openfl.Assets","exists",0xd3fc5ce9,"openfl.Assets.exists","openfl/Assets.hx",42,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(type,"type")
	HX_STACK_LINE(44)
	::openfl::Assets_obj::initialize();
	HX_STACK_LINE(48)
	if (((type == null()))){
		HX_STACK_LINE(50)
		type = ::openfl::AssetType_obj::BINARY;
	}
	HX_STACK_LINE(54)
	int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(54)
	::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
	HX_STACK_LINE(55)
	int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(55)
	int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(55)
	::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
	HX_STACK_LINE(56)
	::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
	HX_STACK_LINE(58)
	if (((library != null()))){
		HX_STACK_LINE(60)
		return library->exists(symbolName,type);
	}
	HX_STACK_LINE(66)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,exists,return )

::flash::display::BitmapData Assets_obj::getBitmapData( ::String id,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","getBitmapData",0xc93c7e82,"openfl.Assets.getBitmapData","openfl/Assets.hx",78,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(80)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(84)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->bitmapData->exists(id)) : bool(false) ))){
			HX_STACK_LINE(86)
			::flash::display::BitmapData bitmapData = ::openfl::Assets_obj::cache->bitmapData->get(id);		HX_STACK_VAR(bitmapData,"bitmapData");
			HX_STACK_LINE(88)
			if ((::openfl::Assets_obj::isValidBitmapData(bitmapData))){
				HX_STACK_LINE(90)
				return bitmapData;
			}
		}
		HX_STACK_LINE(96)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(96)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(97)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(97)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(97)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(98)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(100)
		if (((library != null()))){
			HX_STACK_LINE(102)
			if ((library->exists(symbolName,::openfl::AssetType_obj::IMAGE))){
				HX_STACK_LINE(104)
				if ((library->isLocal(symbolName,::openfl::AssetType_obj::IMAGE))){
					HX_STACK_LINE(106)
					::flash::display::BitmapData bitmapData = library->getBitmapData(symbolName);		HX_STACK_VAR(bitmapData,"bitmapData");
					HX_STACK_LINE(108)
					if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){
						HX_STACK_LINE(110)
						::openfl::Assets_obj::cache->bitmapData->set(id,bitmapData);
					}
					HX_STACK_LINE(114)
					return bitmapData;
				}
				else{
					HX_STACK_LINE(118)
					::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] BitmapData asset \"") + id) + HX_CSTRING("\" exists, but only asynchronously")),hx::SourceInfo(HX_CSTRING("Assets.hx"),118,HX_CSTRING("openfl.Assets"),HX_CSTRING("getBitmapData")));
				}
			}
			else{
				HX_STACK_LINE(124)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no BitmapData asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),124,HX_CSTRING("openfl.Assets"),HX_CSTRING("getBitmapData")));
			}
		}
		else{
			HX_STACK_LINE(130)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),130,HX_CSTRING("openfl.Assets"),HX_CSTRING("getBitmapData")));
		}
		HX_STACK_LINE(136)
		return null();
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,getBitmapData,return )

::flash::utils::ByteArray Assets_obj::getBytes( ::String id){
	HX_STACK_FRAME("openfl.Assets","getBytes",0xa062f442,"openfl.Assets.getBytes","openfl/Assets.hx",147,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(149)
	::openfl::Assets_obj::initialize();
	HX_STACK_LINE(153)
	int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(153)
	::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
	HX_STACK_LINE(154)
	int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(154)
	int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(154)
	::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
	HX_STACK_LINE(155)
	::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
	HX_STACK_LINE(157)
	if (((library != null()))){
		HX_STACK_LINE(159)
		if ((library->exists(symbolName,::openfl::AssetType_obj::BINARY))){
			HX_STACK_LINE(161)
			if ((library->isLocal(symbolName,::openfl::AssetType_obj::BINARY))){
				HX_STACK_LINE(163)
				return library->getBytes(symbolName);
			}
			else{
				HX_STACK_LINE(167)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] String or ByteArray asset \"") + id) + HX_CSTRING("\" exists, but only asynchronously")),hx::SourceInfo(HX_CSTRING("Assets.hx"),167,HX_CSTRING("openfl.Assets"),HX_CSTRING("getBytes")));
			}
		}
		else{
			HX_STACK_LINE(173)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no String or ByteArray asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),173,HX_CSTRING("openfl.Assets"),HX_CSTRING("getBytes")));
		}
	}
	else{
		HX_STACK_LINE(179)
		::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),179,HX_CSTRING("openfl.Assets"),HX_CSTRING("getBytes")));
	}
	HX_STACK_LINE(185)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,getBytes,return )

::flash::text::Font Assets_obj::getFont( ::String id,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","getFont",0x9addf9d8,"openfl.Assets.getFont","openfl/Assets.hx",196,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(198)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(202)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->font->exists(id)) : bool(false) ))){
			HX_STACK_LINE(204)
			return ::openfl::Assets_obj::cache->font->get(id);
		}
		HX_STACK_LINE(208)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(208)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(209)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(209)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(209)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(210)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(212)
		if (((library != null()))){
			HX_STACK_LINE(214)
			if ((library->exists(symbolName,::openfl::AssetType_obj::FONT))){
				HX_STACK_LINE(216)
				if ((library->isLocal(symbolName,::openfl::AssetType_obj::FONT))){
					HX_STACK_LINE(218)
					::flash::text::Font font = library->getFont(symbolName);		HX_STACK_VAR(font,"font");
					HX_STACK_LINE(220)
					if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){
						HX_STACK_LINE(222)
						::openfl::Assets_obj::cache->font->set(id,font);
					}
					HX_STACK_LINE(226)
					return font;
				}
				else{
					HX_STACK_LINE(230)
					::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] Font asset \"") + id) + HX_CSTRING("\" exists, but only asynchronously")),hx::SourceInfo(HX_CSTRING("Assets.hx"),230,HX_CSTRING("openfl.Assets"),HX_CSTRING("getFont")));
				}
			}
			else{
				HX_STACK_LINE(236)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no Font asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),236,HX_CSTRING("openfl.Assets"),HX_CSTRING("getFont")));
			}
		}
		else{
			HX_STACK_LINE(242)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),242,HX_CSTRING("openfl.Assets"),HX_CSTRING("getFont")));
		}
		HX_STACK_LINE(248)
		return null();
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,getFont,return )

::openfl::AssetLibrary Assets_obj::getLibrary( ::String name){
	HX_STACK_FRAME("openfl.Assets","getLibrary",0x9baef692,"openfl.Assets.getLibrary","openfl/Assets.hx",253,0x989d477c)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(255)
	if (((bool((name == null())) || bool((name == HX_CSTRING("")))))){
		HX_STACK_LINE(257)
		name = HX_CSTRING("default");
	}
	HX_STACK_LINE(261)
	return ::openfl::Assets_obj::libraries->get(name);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,getLibrary,return )

::flash::display::MovieClip Assets_obj::getMovieClip( ::String id){
	HX_STACK_FRAME("openfl.Assets","getMovieClip",0x1d5e25f7,"openfl.Assets.getMovieClip","openfl/Assets.hx",272,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(274)
	::openfl::Assets_obj::initialize();
	HX_STACK_LINE(278)
	int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(278)
	::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
	HX_STACK_LINE(279)
	int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(279)
	int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(279)
	::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
	HX_STACK_LINE(280)
	::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
	HX_STACK_LINE(282)
	if (((library != null()))){
		HX_STACK_LINE(284)
		if ((library->exists(symbolName,::openfl::AssetType_obj::MOVIE_CLIP))){
			HX_STACK_LINE(286)
			if ((library->isLocal(symbolName,::openfl::AssetType_obj::MOVIE_CLIP))){
				HX_STACK_LINE(288)
				return library->getMovieClip(symbolName);
			}
			else{
				HX_STACK_LINE(292)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] MovieClip asset \"") + id) + HX_CSTRING("\" exists, but only asynchronously")),hx::SourceInfo(HX_CSTRING("Assets.hx"),292,HX_CSTRING("openfl.Assets"),HX_CSTRING("getMovieClip")));
			}
		}
		else{
			HX_STACK_LINE(298)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no MovieClip asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),298,HX_CSTRING("openfl.Assets"),HX_CSTRING("getMovieClip")));
		}
	}
	else{
		HX_STACK_LINE(304)
		::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),304,HX_CSTRING("openfl.Assets"),HX_CSTRING("getMovieClip")));
	}
	HX_STACK_LINE(310)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,getMovieClip,return )

::flash::media::Sound Assets_obj::getMusic( ::String id,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","getMusic",0xf325bc7c,"openfl.Assets.getMusic","openfl/Assets.hx",321,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(323)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(327)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->sound->exists(id)) : bool(false) ))){
			HX_STACK_LINE(329)
			::flash::media::Sound sound = ::openfl::Assets_obj::cache->sound->get(id);		HX_STACK_VAR(sound,"sound");
			HX_STACK_LINE(331)
			if ((::openfl::Assets_obj::isValidSound(sound))){
				HX_STACK_LINE(333)
				return sound;
			}
		}
		HX_STACK_LINE(339)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(339)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(340)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(340)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(340)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(341)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(343)
		if (((library != null()))){
			HX_STACK_LINE(345)
			if ((library->exists(symbolName,::openfl::AssetType_obj::MUSIC))){
				HX_STACK_LINE(347)
				if ((library->isLocal(symbolName,::openfl::AssetType_obj::MUSIC))){
					HX_STACK_LINE(349)
					::flash::media::Sound sound = library->getMusic(symbolName);		HX_STACK_VAR(sound,"sound");
					HX_STACK_LINE(351)
					if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){
						HX_STACK_LINE(353)
						::openfl::Assets_obj::cache->sound->set(id,sound);
					}
					HX_STACK_LINE(357)
					return sound;
				}
				else{
					HX_STACK_LINE(361)
					::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] Sound asset \"") + id) + HX_CSTRING("\" exists, but only asynchronously")),hx::SourceInfo(HX_CSTRING("Assets.hx"),361,HX_CSTRING("openfl.Assets"),HX_CSTRING("getMusic")));
				}
			}
			else{
				HX_STACK_LINE(367)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no Sound asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),367,HX_CSTRING("openfl.Assets"),HX_CSTRING("getMusic")));
			}
		}
		else{
			HX_STACK_LINE(373)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),373,HX_CSTRING("openfl.Assets"),HX_CSTRING("getMusic")));
		}
		HX_STACK_LINE(379)
		return null();
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,getMusic,return )

::String Assets_obj::getPath( ::String id){
	HX_STACK_FRAME("openfl.Assets","getPath",0xa16f81ae,"openfl.Assets.getPath","openfl/Assets.hx",390,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(392)
	::openfl::Assets_obj::initialize();
	HX_STACK_LINE(396)
	int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(396)
	::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
	HX_STACK_LINE(397)
	int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(397)
	int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(397)
	::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
	HX_STACK_LINE(398)
	::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
	HX_STACK_LINE(400)
	if (((library != null()))){
		HX_STACK_LINE(402)
		if ((library->exists(symbolName,null()))){
			HX_STACK_LINE(404)
			return library->getPath(symbolName);
		}
		else{
			HX_STACK_LINE(408)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),408,HX_CSTRING("openfl.Assets"),HX_CSTRING("getPath")));
		}
	}
	else{
		HX_STACK_LINE(414)
		::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),414,HX_CSTRING("openfl.Assets"),HX_CSTRING("getPath")));
	}
	HX_STACK_LINE(420)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,getPath,return )

::flash::media::Sound Assets_obj::getSound( ::String id,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","getSound",0x639778a6,"openfl.Assets.getSound","openfl/Assets.hx",431,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(433)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(437)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->sound->exists(id)) : bool(false) ))){
			HX_STACK_LINE(439)
			::flash::media::Sound sound = ::openfl::Assets_obj::cache->sound->get(id);		HX_STACK_VAR(sound,"sound");
			HX_STACK_LINE(441)
			if ((::openfl::Assets_obj::isValidSound(sound))){
				HX_STACK_LINE(443)
				return sound;
			}
		}
		HX_STACK_LINE(449)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(449)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(450)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(450)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(450)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(451)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(453)
		if (((library != null()))){
			HX_STACK_LINE(455)
			if ((library->exists(symbolName,::openfl::AssetType_obj::SOUND))){
				HX_STACK_LINE(457)
				if ((library->isLocal(symbolName,::openfl::AssetType_obj::SOUND))){
					HX_STACK_LINE(459)
					::flash::media::Sound sound = library->getSound(symbolName);		HX_STACK_VAR(sound,"sound");
					HX_STACK_LINE(461)
					if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){
						HX_STACK_LINE(463)
						::openfl::Assets_obj::cache->sound->set(id,sound);
					}
					HX_STACK_LINE(467)
					return sound;
				}
				else{
					HX_STACK_LINE(471)
					::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] Sound asset \"") + id) + HX_CSTRING("\" exists, but only asynchronously")),hx::SourceInfo(HX_CSTRING("Assets.hx"),471,HX_CSTRING("openfl.Assets"),HX_CSTRING("getSound")));
				}
			}
			else{
				HX_STACK_LINE(477)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no Sound asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),477,HX_CSTRING("openfl.Assets"),HX_CSTRING("getSound")));
			}
		}
		else{
			HX_STACK_LINE(483)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),483,HX_CSTRING("openfl.Assets"),HX_CSTRING("getSound")));
		}
		HX_STACK_LINE(489)
		return null();
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,getSound,return )

::String Assets_obj::getText( ::String id){
	HX_STACK_FRAME("openfl.Assets","getText",0xa41768b6,"openfl.Assets.getText","openfl/Assets.hx",500,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(502)
	::openfl::Assets_obj::initialize();
	HX_STACK_LINE(506)
	int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(506)
	::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
	HX_STACK_LINE(507)
	int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(507)
	int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(507)
	::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
	HX_STACK_LINE(508)
	::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
	HX_STACK_LINE(510)
	if (((library != null()))){
		HX_STACK_LINE(512)
		if ((library->exists(symbolName,::openfl::AssetType_obj::TEXT))){
			HX_STACK_LINE(514)
			if ((library->isLocal(symbolName,::openfl::AssetType_obj::TEXT))){
				HX_STACK_LINE(516)
				return library->getText(symbolName);
			}
			else{
				HX_STACK_LINE(520)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] String asset \"") + id) + HX_CSTRING("\" exists, but only asynchronously")),hx::SourceInfo(HX_CSTRING("Assets.hx"),520,HX_CSTRING("openfl.Assets"),HX_CSTRING("getText")));
			}
		}
		else{
			HX_STACK_LINE(526)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no String asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),526,HX_CSTRING("openfl.Assets"),HX_CSTRING("getText")));
		}
	}
	else{
		HX_STACK_LINE(532)
		::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),532,HX_CSTRING("openfl.Assets"),HX_CSTRING("getText")));
	}
	HX_STACK_LINE(538)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,getText,return )

Void Assets_obj::initialize( ){
{
		HX_STACK_FRAME("openfl.Assets","initialize",0xf9987add,"openfl.Assets.initialize","openfl/Assets.hx",545,0x989d477c)
		HX_STACK_LINE(545)
		if ((!(::openfl::Assets_obj::initialized))){
			HX_STACK_LINE(549)
			::DefaultAssetLibrary _g = ::DefaultAssetLibrary_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(549)
			::openfl::Assets_obj::registerLibrary(HX_CSTRING("default"),_g);
			HX_STACK_LINE(553)
			::openfl::Assets_obj::initialized = true;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Assets_obj,initialize,(void))

bool Assets_obj::isLocal( ::String id,::openfl::AssetType type,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","isLocal",0x9a115974,"openfl.Assets.isLocal","openfl/Assets.hx",560,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(type,"type")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(562)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(566)
		if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){
			HX_STACK_LINE(568)
			if (((bool((type == ::openfl::AssetType_obj::IMAGE)) || bool((type == null()))))){
				HX_STACK_LINE(570)
				if ((::openfl::Assets_obj::cache->bitmapData->exists(id))){
					HX_STACK_LINE(570)
					return true;
				}
			}
			HX_STACK_LINE(574)
			if (((bool((type == ::openfl::AssetType_obj::FONT)) || bool((type == null()))))){
				HX_STACK_LINE(576)
				if ((::openfl::Assets_obj::cache->font->exists(id))){
					HX_STACK_LINE(576)
					return true;
				}
			}
			HX_STACK_LINE(580)
			if (((bool((bool((type == ::openfl::AssetType_obj::SOUND)) || bool((type == ::openfl::AssetType_obj::MUSIC)))) || bool((type == null()))))){
				HX_STACK_LINE(582)
				if ((::openfl::Assets_obj::cache->sound->exists(id))){
					HX_STACK_LINE(582)
					return true;
				}
			}
		}
		HX_STACK_LINE(588)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(588)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(589)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(589)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(589)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(590)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(592)
		if (((library != null()))){
			HX_STACK_LINE(594)
			return library->isLocal(symbolName,type);
		}
		HX_STACK_LINE(600)
		return false;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assets_obj,isLocal,return )

bool Assets_obj::isValidBitmapData( ::flash::display::BitmapData bitmapData){
	HX_STACK_FRAME("openfl.Assets","isValidBitmapData",0xc2fb171e,"openfl.Assets.isValidBitmapData","openfl/Assets.hx",605,0x989d477c)
	HX_STACK_ARG(bitmapData,"bitmapData")
	HX_STACK_LINE(610)
	return (bitmapData->__handle != null());
	HX_STACK_LINE(631)
	return true;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,isValidBitmapData,return )

bool Assets_obj::isValidSound( ::flash::media::Sound sound){
	HX_STACK_FRAME("openfl.Assets","isValidSound",0x9717a58a,"openfl.Assets.isValidSound","openfl/Assets.hx",636,0x989d477c)
	HX_STACK_ARG(sound,"sound")
	HX_STACK_LINE(641)
	return (bool((sound->__handle != null())) && bool((sound->__handle != (int)0)));
	HX_STACK_LINE(646)
	return true;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,isValidSound,return )

Void Assets_obj::loadBitmapData( ::String id,Dynamic handler,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","loadBitmapData",0x79a7538c,"openfl.Assets.loadBitmapData","openfl/Assets.hx",651,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(handler,"handler")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(651)
		Dynamic handler1 = Dynamic( Array_obj<Dynamic>::__new().Add(handler));		HX_STACK_VAR(handler1,"handler1");
		HX_STACK_LINE(651)
		Array< ::String > id1 = Array_obj< ::String >::__new().Add(id);		HX_STACK_VAR(id1,"id1");
		HX_STACK_LINE(653)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(657)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->bitmapData->exists(id1->__get((int)0))) : bool(false) ))){
			HX_STACK_LINE(659)
			::flash::display::BitmapData bitmapData = ::openfl::Assets_obj::cache->bitmapData->get(id1->__get((int)0));		HX_STACK_VAR(bitmapData,"bitmapData");
			HX_STACK_LINE(661)
			if ((::openfl::Assets_obj::isValidBitmapData(bitmapData))){
				HX_STACK_LINE(663)
				handler1->__GetItem((int)0)(bitmapData).Cast< Void >();
				HX_STACK_LINE(664)
				return null();
			}
		}
		HX_STACK_LINE(670)
		int _g = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(670)
		::String libraryName = id1->__get((int)0).substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(671)
		int _g1 = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(671)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(671)
		::String symbolName = id1->__get((int)0).substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(672)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(674)
		if (((library != null()))){
			HX_STACK_LINE(676)
			if ((library->exists(symbolName,::openfl::AssetType_obj::IMAGE))){
				HX_STACK_LINE(678)
				if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){

					HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_4_1,Dynamic,handler1,Array< ::String >,id1)
					Void run(::flash::display::BitmapData bitmapData){
						HX_STACK_FRAME("*","_Function_4_1",0x520333fa,"*._Function_4_1","openfl/Assets.hx",680,0x989d477c)
						HX_STACK_ARG(bitmapData,"bitmapData")
						{
							HX_STACK_LINE(682)
							::openfl::Assets_obj::cache->bitmapData->set(id1->__get((int)0),bitmapData);
							HX_STACK_LINE(683)
							handler1->__GetItem((int)0)(bitmapData).Cast< Void >();
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(680)
					library->loadBitmapData(symbolName, Dynamic(new _Function_4_1(handler1,id1)));
				}
				else{
					HX_STACK_LINE(689)
					library->loadBitmapData(symbolName,handler1->__GetItem((int)0));
				}
				HX_STACK_LINE(693)
				return null();
			}
			else{
				HX_STACK_LINE(697)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no BitmapData asset with an ID of \"") + id1->__get((int)0)) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),697,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadBitmapData")));
			}
		}
		else{
			HX_STACK_LINE(703)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),703,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadBitmapData")));
		}
		HX_STACK_LINE(709)
		handler1->__GetItem((int)0)(null()).Cast< Void >();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assets_obj,loadBitmapData,(void))

Void Assets_obj::loadBytes( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.Assets","loadBytes",0xeb3c3b78,"openfl.Assets.loadBytes","openfl/Assets.hx",714,0x989d477c)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(716)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(720)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(720)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(721)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(721)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(721)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(722)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(724)
		if (((library != null()))){
			HX_STACK_LINE(726)
			if ((library->exists(symbolName,::openfl::AssetType_obj::BINARY))){
				HX_STACK_LINE(728)
				library->loadBytes(symbolName,handler);
				HX_STACK_LINE(729)
				return null();
			}
			else{
				HX_STACK_LINE(733)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no String or ByteArray asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),733,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadBytes")));
			}
		}
		else{
			HX_STACK_LINE(739)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),739,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadBytes")));
		}
		HX_STACK_LINE(745)
		handler(null()).Cast< Void >();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,loadBytes,(void))

Void Assets_obj::loadFont( ::String id,Dynamic handler,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","loadFont",0x37540b62,"openfl.Assets.loadFont","openfl/Assets.hx",750,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(handler,"handler")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(750)
		Dynamic handler1 = Dynamic( Array_obj<Dynamic>::__new().Add(handler));		HX_STACK_VAR(handler1,"handler1");
		HX_STACK_LINE(750)
		Array< ::String > id1 = Array_obj< ::String >::__new().Add(id);		HX_STACK_VAR(id1,"id1");
		HX_STACK_LINE(752)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(756)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->font->exists(id1->__get((int)0))) : bool(false) ))){
			HX_STACK_LINE(758)
			::flash::text::Font _g = ::openfl::Assets_obj::cache->font->get(id1->__get((int)0));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(758)
			handler1->__GetItem((int)0)(_g).Cast< Void >();
			HX_STACK_LINE(759)
			return null();
		}
		HX_STACK_LINE(763)
		int _g1 = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(763)
		::String libraryName = id1->__get((int)0).substring((int)0,_g1);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(764)
		int _g2 = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(764)
		int _g3 = (_g2 + (int)1);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(764)
		::String symbolName = id1->__get((int)0).substr(_g3,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(765)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(767)
		if (((library != null()))){
			HX_STACK_LINE(769)
			if ((library->exists(symbolName,::openfl::AssetType_obj::FONT))){
				HX_STACK_LINE(771)
				if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){

					HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_4_1,Dynamic,handler1,Array< ::String >,id1)
					Void run(::flash::text::Font font){
						HX_STACK_FRAME("*","_Function_4_1",0x520333fa,"*._Function_4_1","openfl/Assets.hx",773,0x989d477c)
						HX_STACK_ARG(font,"font")
						{
							HX_STACK_LINE(775)
							::openfl::Assets_obj::cache->font->set(id1->__get((int)0),font);
							HX_STACK_LINE(776)
							handler1->__GetItem((int)0)(font).Cast< Void >();
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(773)
					library->loadFont(symbolName, Dynamic(new _Function_4_1(handler1,id1)));
				}
				else{
					HX_STACK_LINE(782)
					library->loadFont(symbolName,handler1->__GetItem((int)0));
				}
				HX_STACK_LINE(786)
				return null();
			}
			else{
				HX_STACK_LINE(790)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no Font asset with an ID of \"") + id1->__get((int)0)) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),790,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadFont")));
			}
		}
		else{
			HX_STACK_LINE(796)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),796,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadFont")));
		}
		HX_STACK_LINE(802)
		handler1->__GetItem((int)0)(null()).Cast< Void >();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assets_obj,loadFont,(void))

Void Assets_obj::loadLibrary( ::String name,Dynamic handler){
{
		HX_STACK_FRAME("openfl.Assets","loadLibrary",0x44d0f748,"openfl.Assets.loadLibrary","openfl/Assets.hx",807,0x989d477c)
		HX_STACK_ARG(name,"name")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(809)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(813)
		::String data = ::openfl::Assets_obj::getText(((HX_CSTRING("libraries/") + name) + HX_CSTRING(".dat")));		HX_STACK_VAR(data,"data");
		HX_STACK_LINE(815)
		if (((bool((data != null())) && bool((data != HX_CSTRING("")))))){
			HX_STACK_LINE(817)
			::haxe::Unserializer unserializer = ::haxe::Unserializer_obj::__new(data);		HX_STACK_VAR(unserializer,"unserializer");
			struct _Function_2_1{
				inline static Dynamic Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","openfl/Assets.hx",818,0x989d477c)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("resolveEnum") , ::openfl::Assets_obj::resolveEnum_dyn(),false);
						__result->Add(HX_CSTRING("resolveClass") , ::openfl::Assets_obj::resolveClass_dyn(),false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(818)
			unserializer->setResolver(_Function_2_1::Block());
			HX_STACK_LINE(820)
			::openfl::AssetLibrary library = unserializer->unserialize();		HX_STACK_VAR(library,"library");
			HX_STACK_LINE(821)
			::openfl::Assets_obj::libraries->set(name,library);
			HX_STACK_LINE(822)
			library->load(handler);
		}
		else{
			HX_STACK_LINE(826)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + name) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),826,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadLibrary")));
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,loadLibrary,(void))

Void Assets_obj::loadMusic( ::String id,Dynamic handler,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","loadMusic",0x3dff03b2,"openfl.Assets.loadMusic","openfl/Assets.hx",835,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(handler,"handler")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(835)
		Dynamic handler1 = Dynamic( Array_obj<Dynamic>::__new().Add(handler));		HX_STACK_VAR(handler1,"handler1");
		HX_STACK_LINE(835)
		Array< ::String > id1 = Array_obj< ::String >::__new().Add(id);		HX_STACK_VAR(id1,"id1");
		HX_STACK_LINE(837)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(841)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->sound->exists(id1->__get((int)0))) : bool(false) ))){
			HX_STACK_LINE(843)
			::flash::media::Sound sound = ::openfl::Assets_obj::cache->sound->get(id1->__get((int)0));		HX_STACK_VAR(sound,"sound");
			HX_STACK_LINE(845)
			if ((::openfl::Assets_obj::isValidSound(sound))){
				HX_STACK_LINE(847)
				handler1->__GetItem((int)0)(sound).Cast< Void >();
				HX_STACK_LINE(848)
				return null();
			}
		}
		HX_STACK_LINE(854)
		int _g = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(854)
		::String libraryName = id1->__get((int)0).substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(855)
		int _g1 = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(855)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(855)
		::String symbolName = id1->__get((int)0).substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(856)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(858)
		if (((library != null()))){
			HX_STACK_LINE(860)
			if ((library->exists(symbolName,::openfl::AssetType_obj::MUSIC))){
				HX_STACK_LINE(862)
				if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){

					HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_4_1,Dynamic,handler1,Array< ::String >,id1)
					Void run(::flash::media::Sound sound){
						HX_STACK_FRAME("*","_Function_4_1",0x520333fa,"*._Function_4_1","openfl/Assets.hx",864,0x989d477c)
						HX_STACK_ARG(sound,"sound")
						{
							HX_STACK_LINE(866)
							::openfl::Assets_obj::cache->sound->set(id1->__get((int)0),sound);
							HX_STACK_LINE(867)
							handler1->__GetItem((int)0)(sound).Cast< Void >();
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(864)
					library->loadMusic(symbolName, Dynamic(new _Function_4_1(handler1,id1)));
				}
				else{
					HX_STACK_LINE(873)
					library->loadMusic(symbolName,handler1->__GetItem((int)0));
				}
				HX_STACK_LINE(877)
				return null();
			}
			else{
				HX_STACK_LINE(881)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no Sound asset with an ID of \"") + id1->__get((int)0)) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),881,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadMusic")));
			}
		}
		else{
			HX_STACK_LINE(887)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),887,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadMusic")));
		}
		HX_STACK_LINE(893)
		handler1->__GetItem((int)0)(null()).Cast< Void >();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assets_obj,loadMusic,(void))

Void Assets_obj::loadMovieClip( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.Assets","loadMovieClip",0xd38a402d,"openfl.Assets.loadMovieClip","openfl/Assets.hx",898,0x989d477c)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(900)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(904)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(904)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(905)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(905)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(905)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(906)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(908)
		if (((library != null()))){
			HX_STACK_LINE(910)
			if ((library->exists(symbolName,::openfl::AssetType_obj::MOVIE_CLIP))){
				HX_STACK_LINE(912)
				library->loadMovieClip(symbolName,handler);
				HX_STACK_LINE(913)
				return null();
			}
			else{
				HX_STACK_LINE(917)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no MovieClip asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),917,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadMovieClip")));
			}
		}
		else{
			HX_STACK_LINE(923)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),923,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadMovieClip")));
		}
		HX_STACK_LINE(929)
		handler(null()).Cast< Void >();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,loadMovieClip,(void))

Void Assets_obj::loadSound( ::String id,Dynamic handler,hx::Null< bool >  __o_useCache){
bool useCache = __o_useCache.Default(true);
	HX_STACK_FRAME("openfl.Assets","loadSound",0xae70bfdc,"openfl.Assets.loadSound","openfl/Assets.hx",934,0x989d477c)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(handler,"handler")
	HX_STACK_ARG(useCache,"useCache")
{
		HX_STACK_LINE(934)
		Dynamic handler1 = Dynamic( Array_obj<Dynamic>::__new().Add(handler));		HX_STACK_VAR(handler1,"handler1");
		HX_STACK_LINE(934)
		Array< ::String > id1 = Array_obj< ::String >::__new().Add(id);		HX_STACK_VAR(id1,"id1");
		HX_STACK_LINE(936)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(940)
		if (((  (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))) ? bool(::openfl::Assets_obj::cache->sound->exists(id1->__get((int)0))) : bool(false) ))){
			HX_STACK_LINE(942)
			::flash::media::Sound sound = ::openfl::Assets_obj::cache->sound->get(id1->__get((int)0));		HX_STACK_VAR(sound,"sound");
			HX_STACK_LINE(944)
			if ((::openfl::Assets_obj::isValidSound(sound))){
				HX_STACK_LINE(946)
				handler1->__GetItem((int)0)(sound).Cast< Void >();
				HX_STACK_LINE(947)
				return null();
			}
		}
		HX_STACK_LINE(953)
		int _g = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(953)
		::String libraryName = id1->__get((int)0).substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(954)
		int _g1 = id1->__get((int)0).indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(954)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(954)
		::String symbolName = id1->__get((int)0).substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(955)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(957)
		if (((library != null()))){
			HX_STACK_LINE(959)
			if ((library->exists(symbolName,::openfl::AssetType_obj::SOUND))){
				HX_STACK_LINE(961)
				if (((bool(useCache) && bool(::openfl::Assets_obj::cache->enabled)))){

					HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_4_1,Dynamic,handler1,Array< ::String >,id1)
					Void run(::flash::media::Sound sound){
						HX_STACK_FRAME("*","_Function_4_1",0x520333fa,"*._Function_4_1","openfl/Assets.hx",963,0x989d477c)
						HX_STACK_ARG(sound,"sound")
						{
							HX_STACK_LINE(965)
							::openfl::Assets_obj::cache->sound->set(id1->__get((int)0),sound);
							HX_STACK_LINE(966)
							handler1->__GetItem((int)0)(sound).Cast< Void >();
						}
						return null();
					}
					HX_END_LOCAL_FUNC1((void))

					HX_STACK_LINE(963)
					library->loadSound(symbolName, Dynamic(new _Function_4_1(handler1,id1)));
				}
				else{
					HX_STACK_LINE(972)
					library->loadSound(symbolName,handler1->__GetItem((int)0));
				}
				HX_STACK_LINE(976)
				return null();
			}
			else{
				HX_STACK_LINE(980)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no Sound asset with an ID of \"") + id1->__get((int)0)) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),980,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadSound")));
			}
		}
		else{
			HX_STACK_LINE(986)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),986,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadSound")));
		}
		HX_STACK_LINE(992)
		handler1->__GetItem((int)0)(null()).Cast< Void >();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assets_obj,loadSound,(void))

Void Assets_obj::loadText( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.Assets","loadText",0x408d7a40,"openfl.Assets.loadText","openfl/Assets.hx",997,0x989d477c)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(999)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(1003)
		int _g = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1003)
		::String libraryName = id.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
		HX_STACK_LINE(1004)
		int _g1 = id.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1004)
		int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(1004)
		::String symbolName = id.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
		HX_STACK_LINE(1005)
		::openfl::AssetLibrary library = ::openfl::Assets_obj::getLibrary(libraryName);		HX_STACK_VAR(library,"library");
		HX_STACK_LINE(1007)
		if (((library != null()))){
			HX_STACK_LINE(1009)
			if ((library->exists(symbolName,::openfl::AssetType_obj::TEXT))){
				HX_STACK_LINE(1011)
				library->loadText(symbolName,handler);
				HX_STACK_LINE(1012)
				return null();
			}
			else{
				HX_STACK_LINE(1016)
				::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no String asset with an ID of \"") + id) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),1016,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadText")));
			}
		}
		else{
			HX_STACK_LINE(1022)
			::haxe::Log_obj::trace(((HX_CSTRING("[openfl.Assets] There is no asset library named \"") + libraryName) + HX_CSTRING("\"")),hx::SourceInfo(HX_CSTRING("Assets.hx"),1022,HX_CSTRING("openfl.Assets"),HX_CSTRING("loadText")));
		}
		HX_STACK_LINE(1028)
		handler(null()).Cast< Void >();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,loadText,(void))

Void Assets_obj::registerLibrary( ::String name,::openfl::AssetLibrary library){
{
		HX_STACK_FRAME("openfl.Assets","registerLibrary",0x9230822b,"openfl.Assets.registerLibrary","openfl/Assets.hx",1033,0x989d477c)
		HX_STACK_ARG(name,"name")
		HX_STACK_ARG(library,"library")
		HX_STACK_LINE(1035)
		if ((::openfl::Assets_obj::libraries->exists(name))){
			HX_STACK_LINE(1037)
			::openfl::Assets_obj::unloadLibrary(name);
		}
		HX_STACK_LINE(1041)
		::openfl::Assets_obj::libraries->set(name,library);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assets_obj,registerLibrary,(void))

::Class Assets_obj::resolveClass( ::String name){
	HX_STACK_FRAME("openfl.Assets","resolveClass",0x76ca4479,"openfl.Assets.resolveClass","openfl/Assets.hx",1048,0x989d477c)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(1048)
	return ::Type_obj::resolveClass(name);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,resolveClass,return )

::Enum Assets_obj::resolveEnum( ::String name){
	HX_STACK_FRAME("openfl.Assets","resolveEnum",0x1314a1e0,"openfl.Assets.resolveEnum","openfl/Assets.hx",1053,0x989d477c)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(1055)
	::Enum value = ::Type_obj::resolveEnum(name);		HX_STACK_VAR(value,"value");
	HX_STACK_LINE(1067)
	return value;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,resolveEnum,return )

Void Assets_obj::unloadLibrary( ::String name){
{
		HX_STACK_FRAME("openfl.Assets","unloadLibrary",0x6a51c84f,"openfl.Assets.unloadLibrary","openfl/Assets.hx",1072,0x989d477c)
		HX_STACK_ARG(name,"name")
		HX_STACK_LINE(1074)
		::openfl::Assets_obj::initialize();
		HX_STACK_LINE(1078)
		Dynamic keys = ::openfl::Assets_obj::cache->bitmapData->keys();		HX_STACK_VAR(keys,"keys");
		HX_STACK_LINE(1080)
		for(::cpp::FastIterator_obj< ::String > *__it = ::cpp::CreateFastIterator< ::String >(keys);  __it->hasNext(); ){
			::String key = __it->next();
			{
				HX_STACK_LINE(1082)
				int _g = key.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(1082)
				::String libraryName = key.substring((int)0,_g);		HX_STACK_VAR(libraryName,"libraryName");
				HX_STACK_LINE(1083)
				int _g1 = key.indexOf(HX_CSTRING(":"),null());		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(1083)
				int _g2 = (_g1 + (int)1);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(1083)
				::String symbolName = key.substr(_g2,null());		HX_STACK_VAR(symbolName,"symbolName");
				HX_STACK_LINE(1085)
				if (((libraryName == name))){
					HX_STACK_LINE(1087)
					::openfl::Assets_obj::cache->bitmapData->remove(key);
				}
			}
;
		}
		HX_STACK_LINE(1093)
		::openfl::Assets_obj::libraries->remove(name);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assets_obj,unloadLibrary,(void))


Assets_obj::Assets_obj()
{
}

Dynamic Assets_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"cache") ) { return cache; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getFont") ) { return getFont_dyn(); }
		if (HX_FIELD_EQ(inName,"getPath") ) { return getPath_dyn(); }
		if (HX_FIELD_EQ(inName,"getText") ) { return getText_dyn(); }
		if (HX_FIELD_EQ(inName,"isLocal") ) { return isLocal_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"getMusic") ) { return getMusic_dyn(); }
		if (HX_FIELD_EQ(inName,"getSound") ) { return getSound_dyn(); }
		if (HX_FIELD_EQ(inName,"loadFont") ) { return loadFont_dyn(); }
		if (HX_FIELD_EQ(inName,"loadText") ) { return loadText_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"libraries") ) { return libraries; }
		if (HX_FIELD_EQ(inName,"loadBytes") ) { return loadBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"loadMusic") ) { return loadMusic_dyn(); }
		if (HX_FIELD_EQ(inName,"loadSound") ) { return loadSound_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getLibrary") ) { return getLibrary_dyn(); }
		if (HX_FIELD_EQ(inName,"initialize") ) { return initialize_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"initialized") ) { return initialized; }
		if (HX_FIELD_EQ(inName,"loadLibrary") ) { return loadLibrary_dyn(); }
		if (HX_FIELD_EQ(inName,"resolveEnum") ) { return resolveEnum_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getMovieClip") ) { return getMovieClip_dyn(); }
		if (HX_FIELD_EQ(inName,"isValidSound") ) { return isValidSound_dyn(); }
		if (HX_FIELD_EQ(inName,"resolveClass") ) { return resolveClass_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getBitmapData") ) { return getBitmapData_dyn(); }
		if (HX_FIELD_EQ(inName,"loadMovieClip") ) { return loadMovieClip_dyn(); }
		if (HX_FIELD_EQ(inName,"unloadLibrary") ) { return unloadLibrary_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"loadBitmapData") ) { return loadBitmapData_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"registerLibrary") ) { return registerLibrary_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"isValidBitmapData") ) { return isValidBitmapData_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Assets_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"cache") ) { cache=inValue.Cast< ::openfl::AssetCache >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"libraries") ) { libraries=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"initialized") ) { initialized=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Assets_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("cache"),
	HX_CSTRING("libraries"),
	HX_CSTRING("initialized"),
	HX_CSTRING("exists"),
	HX_CSTRING("getBitmapData"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("getFont"),
	HX_CSTRING("getLibrary"),
	HX_CSTRING("getMovieClip"),
	HX_CSTRING("getMusic"),
	HX_CSTRING("getPath"),
	HX_CSTRING("getSound"),
	HX_CSTRING("getText"),
	HX_CSTRING("initialize"),
	HX_CSTRING("isLocal"),
	HX_CSTRING("isValidBitmapData"),
	HX_CSTRING("isValidSound"),
	HX_CSTRING("loadBitmapData"),
	HX_CSTRING("loadBytes"),
	HX_CSTRING("loadFont"),
	HX_CSTRING("loadLibrary"),
	HX_CSTRING("loadMusic"),
	HX_CSTRING("loadMovieClip"),
	HX_CSTRING("loadSound"),
	HX_CSTRING("loadText"),
	HX_CSTRING("registerLibrary"),
	HX_CSTRING("resolveClass"),
	HX_CSTRING("resolveEnum"),
	HX_CSTRING("unloadLibrary"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Assets_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Assets_obj::cache,"cache");
	HX_MARK_MEMBER_NAME(Assets_obj::libraries,"libraries");
	HX_MARK_MEMBER_NAME(Assets_obj::initialized,"initialized");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Assets_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Assets_obj::cache,"cache");
	HX_VISIT_MEMBER_NAME(Assets_obj::libraries,"libraries");
	HX_VISIT_MEMBER_NAME(Assets_obj::initialized,"initialized");
};

#endif

Class Assets_obj::__mClass;

void Assets_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.Assets"), hx::TCanCast< Assets_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void Assets_obj::__boot()
{
	cache= ::openfl::AssetCache_obj::__new();
	libraries= ::haxe::ds::StringMap_obj::__new();
	initialized= false;
}

} // end namespace openfl
