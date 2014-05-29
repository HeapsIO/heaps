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
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
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
#ifndef INCLUDED_flash_media_SoundLoaderContext
#include <flash/media/SoundLoaderContext.h>
#endif
#ifndef INCLUDED_flash_net_URLRequest
#include <flash/net/URLRequest.h>
#endif
#ifndef INCLUDED_flash_text_Font
#include <flash/text/Font.h>
#endif
#ifndef INCLUDED_flash_text_FontStyle
#include <flash/text/FontStyle.h>
#endif
#ifndef INCLUDED_flash_text_FontType
#include <flash/text/FontType.h>
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
#ifndef INCLUDED_openfl_AssetData
#include <openfl/AssetData.h>
#endif
#ifndef INCLUDED_openfl_AssetLibrary
#include <openfl/AssetLibrary.h>
#endif
#ifndef INCLUDED_openfl_AssetType
#include <openfl/AssetType.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif

Void DefaultAssetLibrary_obj::__construct()
{
HX_STACK_FRAME("DefaultAssetLibrary","new",0xbc37e41e,"DefaultAssetLibrary.new","DefaultAssetLibrary.hx",33,0x0fc48912)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(35)
	super::__construct();
	HX_STACK_LINE(73)
	bool loadManifest = false;		HX_STACK_VAR(loadManifest,"loadManifest");
	HX_STACK_LINE(74)
	loadManifest = true;
	HX_STACK_LINE(75)
	loadManifest = true;
	HX_STACK_LINE(76)
	loadManifest = true;
	HX_STACK_LINE(77)
	loadManifest = true;
	HX_STACK_LINE(78)
	loadManifest = true;
	HX_STACK_LINE(79)
	loadManifest = true;
	HX_STACK_LINE(80)
	loadManifest = true;
	HX_STACK_LINE(81)
	loadManifest = true;
	HX_STACK_LINE(90)
	if ((loadManifest)){
		HX_STACK_LINE(91)
		try
		{
		HX_STACK_CATCHABLE(Dynamic, 0);
		{
			HX_STACK_LINE(100)
			::flash::utils::ByteArray bytes = ::flash::utils::ByteArray_obj::readFile(HX_CSTRING("manifest"));		HX_STACK_VAR(bytes,"bytes");
			HX_STACK_LINE(103)
			if (((bytes != null()))){
				HX_STACK_LINE(105)
				bytes->position = (int)0;
				HX_STACK_LINE(107)
				if (((bytes->length > (int)0))){
					HX_STACK_LINE(109)
					::String data = bytes->readUTFBytes(bytes->length);		HX_STACK_VAR(data,"data");
					HX_STACK_LINE(111)
					if (((bool((data != null())) && bool((data.length > (int)0))))){
						HX_STACK_LINE(113)
						Array< ::Dynamic > manifest = ::haxe::Unserializer_obj::run(data);		HX_STACK_VAR(manifest,"manifest");
						HX_STACK_LINE(115)
						{
							HX_STACK_LINE(115)
							int _g = (int)0;		HX_STACK_VAR(_g,"_g");
							HX_STACK_LINE(115)
							while((true)){
								HX_STACK_LINE(115)
								if ((!(((_g < manifest->length))))){
									HX_STACK_LINE(115)
									break;
								}
								HX_STACK_LINE(115)
								::openfl::AssetData asset = manifest->__get(_g).StaticCast< ::openfl::AssetData >();		HX_STACK_VAR(asset,"asset");
								HX_STACK_LINE(115)
								++(_g);
								HX_STACK_LINE(117)
								if ((!(::DefaultAssetLibrary_obj::className->exists(asset->id)))){
									HX_STACK_LINE(119)
									::DefaultAssetLibrary_obj::path->set(asset->id,asset->path);
									HX_STACK_LINE(120)
									::DefaultAssetLibrary_obj::type->set(asset->id,asset->type);
								}
							}
						}
					}
				}
			}
			else{
				HX_STACK_LINE(131)
				::haxe::Log_obj::trace(HX_CSTRING("Warning: Could not load asset manifest"),hx::SourceInfo(HX_CSTRING("DefaultAssetLibrary.hx"),131,HX_CSTRING("DefaultAssetLibrary"),HX_CSTRING("new")));
			}
		}
		}
		catch(Dynamic __e){
			{
				HX_STACK_BEGIN_CATCH
				Dynamic e = __e;{
					HX_STACK_LINE(137)
					::haxe::Log_obj::trace(HX_CSTRING("Warning: Could not load asset manifest"),hx::SourceInfo(HX_CSTRING("DefaultAssetLibrary.hx"),137,HX_CSTRING("DefaultAssetLibrary"),HX_CSTRING("new")));
				}
			}
		}
	}
}
;
	return null();
}

//DefaultAssetLibrary_obj::~DefaultAssetLibrary_obj() { }

Dynamic DefaultAssetLibrary_obj::__CreateEmpty() { return  new DefaultAssetLibrary_obj; }
hx::ObjectPtr< DefaultAssetLibrary_obj > DefaultAssetLibrary_obj::__new()
{  hx::ObjectPtr< DefaultAssetLibrary_obj > result = new DefaultAssetLibrary_obj();
	result->__construct();
	return result;}

Dynamic DefaultAssetLibrary_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DefaultAssetLibrary_obj > result = new DefaultAssetLibrary_obj();
	result->__construct();
	return result;}

bool DefaultAssetLibrary_obj::exists( ::String id,::openfl::AssetType type){
	HX_STACK_FRAME("DefaultAssetLibrary","exists",0x972074de,"DefaultAssetLibrary.exists","DefaultAssetLibrary.hx",162,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(type,"type")
	HX_STACK_LINE(164)
	::openfl::AssetType assetType = ::DefaultAssetLibrary_obj::type->get(id);		HX_STACK_VAR(assetType,"assetType");
	HX_STACK_LINE(180)
	if (((assetType != null()))){
		HX_STACK_LINE(182)
		if (((bool((assetType == type)) || bool((bool(((bool((type == ::openfl::AssetType_obj::SOUND)) || bool((type == ::openfl::AssetType_obj::MUSIC))))) && bool(((bool((assetType == ::openfl::AssetType_obj::MUSIC)) || bool((assetType == ::openfl::AssetType_obj::SOUND)))))))))){
			HX_STACK_LINE(184)
			return true;
		}
		HX_STACK_LINE(202)
		if (((bool((type == ::openfl::AssetType_obj::BINARY)) || bool((type == null()))))){
			HX_STACK_LINE(204)
			return true;
		}
	}
	HX_STACK_LINE(212)
	return false;
}


::flash::display::BitmapData DefaultAssetLibrary_obj::getBitmapData( ::String id){
	HX_STACK_FRAME("DefaultAssetLibrary","getBitmapData",0xb8207f2d,"DefaultAssetLibrary.getBitmapData","DefaultAssetLibrary.hx",237,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(237)
	if ((::DefaultAssetLibrary_obj::className->exists(id))){
		HX_STACK_LINE(237)
		Dynamic _g = ::DefaultAssetLibrary_obj::className->get(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(237)
		return hx::TCast< flash::display::BitmapData >::cast(::Type_obj::createInstance(_g,Dynamic( Array_obj<Dynamic>::__new())));
	}
	else{
		HX_STACK_LINE(238)
		::String _g1 = ::DefaultAssetLibrary_obj::path->get(id);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(238)
		return ::flash::display::BitmapData_obj::load(_g1,null());
	}
	HX_STACK_LINE(237)
	return null();
}


::flash::utils::ByteArray DefaultAssetLibrary_obj::getBytes( ::String id){
	HX_STACK_FRAME("DefaultAssetLibrary","getBytes",0x86b4b377,"DefaultAssetLibrary.getBytes","DefaultAssetLibrary.hx",291,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(291)
	if ((::DefaultAssetLibrary_obj::className->exists(id))){
		HX_STACK_LINE(291)
		Dynamic _g = ::DefaultAssetLibrary_obj::className->get(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(291)
		return hx::TCast< flash::utils::ByteArray >::cast(::Type_obj::createInstance(_g,Dynamic( Array_obj<Dynamic>::__new())));
	}
	else{
		HX_STACK_LINE(292)
		::String _g1 = ::DefaultAssetLibrary_obj::path->get(id);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(292)
		return ::flash::utils::ByteArray_obj::readFile(_g1);
	}
	HX_STACK_LINE(291)
	return null();
}


::flash::text::Font DefaultAssetLibrary_obj::getFont( ::String id){
	HX_STACK_FRAME("DefaultAssetLibrary","getFont",0x974ed843,"DefaultAssetLibrary.getFont","DefaultAssetLibrary.hx",311,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(311)
	if ((::DefaultAssetLibrary_obj::className->exists(id))){
		HX_STACK_LINE(312)
		Dynamic fontClass = ::DefaultAssetLibrary_obj::className->get(id);		HX_STACK_VAR(fontClass,"fontClass");
		HX_STACK_LINE(313)
		::flash::text::Font_obj::registerFont(fontClass);
		HX_STACK_LINE(314)
		return hx::TCast< flash::text::Font >::cast(::Type_obj::createInstance(fontClass,Dynamic( Array_obj<Dynamic>::__new())));
	}
	else{
		HX_STACK_LINE(315)
		::String _g = ::DefaultAssetLibrary_obj::path->get(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(315)
		return ::flash::text::Font_obj::__new(_g,null(),null());
	}
	HX_STACK_LINE(311)
	return null();
}


::flash::media::Sound DefaultAssetLibrary_obj::getMusic( ::String id){
	HX_STACK_FRAME("DefaultAssetLibrary","getMusic",0xd9777bb1,"DefaultAssetLibrary.getMusic","DefaultAssetLibrary.hx",345,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(345)
	if ((::DefaultAssetLibrary_obj::className->exists(id))){
		HX_STACK_LINE(345)
		Dynamic _g = ::DefaultAssetLibrary_obj::className->get(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(345)
		return hx::TCast< flash::media::Sound >::cast(::Type_obj::createInstance(_g,Dynamic( Array_obj<Dynamic>::__new())));
	}
	else{
		HX_STACK_LINE(346)
		::String _g1 = ::DefaultAssetLibrary_obj::path->get(id);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(346)
		::flash::net::URLRequest _g2 = ::flash::net::URLRequest_obj::__new(_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(346)
		return ::flash::media::Sound_obj::__new(_g2,null(),true);
	}
	HX_STACK_LINE(345)
	return null();
}


::String DefaultAssetLibrary_obj::getPath( ::String id){
	HX_STACK_FRAME("DefaultAssetLibrary","getPath",0x9de06019,"DefaultAssetLibrary.getPath","DefaultAssetLibrary.hx",361,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(361)
	return ::DefaultAssetLibrary_obj::path->get(id);
}


::flash::media::Sound DefaultAssetLibrary_obj::getSound( ::String id){
	HX_STACK_FRAME("DefaultAssetLibrary","getSound",0x49e937db,"DefaultAssetLibrary.getSound","DefaultAssetLibrary.hx",384,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(384)
	if ((::DefaultAssetLibrary_obj::className->exists(id))){
		HX_STACK_LINE(384)
		Dynamic _g = ::DefaultAssetLibrary_obj::className->get(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(384)
		return hx::TCast< flash::media::Sound >::cast(::Type_obj::createInstance(_g,Dynamic( Array_obj<Dynamic>::__new())));
	}
	else{
		HX_STACK_LINE(385)
		::String _g1 = ::DefaultAssetLibrary_obj::path->get(id);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(385)
		::flash::net::URLRequest _g2 = ::flash::net::URLRequest_obj::__new(_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(385)
		::openfl::AssetType _g3 = ::DefaultAssetLibrary_obj::type->get(id);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(385)
		bool _g4 = (_g3 == ::openfl::AssetType_obj::MUSIC);		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(385)
		return ::flash::media::Sound_obj::__new(_g2,null(),_g4);
	}
	HX_STACK_LINE(384)
	return null();
}


::String DefaultAssetLibrary_obj::getText( ::String id){
	HX_STACK_FRAME("DefaultAssetLibrary","getText",0xa0884721,"DefaultAssetLibrary.getText","DefaultAssetLibrary.hx",392,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(425)
	::flash::utils::ByteArray bytes = this->getBytes(id);		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(427)
	if (((bytes == null()))){
		HX_STACK_LINE(429)
		return null();
	}
	else{
		HX_STACK_LINE(433)
		return bytes->readUTFBytes(bytes->length);
	}
	HX_STACK_LINE(427)
	return null();
}


bool DefaultAssetLibrary_obj::isLocal( ::String id,::openfl::AssetType type){
	HX_STACK_FRAME("DefaultAssetLibrary","isLocal",0x968237df,"DefaultAssetLibrary.isLocal","DefaultAssetLibrary.hx",454,0x0fc48912)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(type,"type")
	HX_STACK_LINE(454)
	return true;
}


Void DefaultAssetLibrary_obj::loadBitmapData( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("DefaultAssetLibrary","loadBitmapData",0x9243e881,"DefaultAssetLibrary.loadBitmapData","DefaultAssetLibrary.hx",459,0x0fc48912)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(485)
		::flash::display::BitmapData _g = this->getBitmapData(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(485)
		handler(_g).Cast< Void >();
	}
return null();
}


Void DefaultAssetLibrary_obj::loadBytes( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("DefaultAssetLibrary","loadBytes",0x8c71caa3,"DefaultAssetLibrary.loadBytes","DefaultAssetLibrary.hx",492,0x0fc48912)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(522)
		::flash::utils::ByteArray _g = this->getBytes(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(522)
		handler(_g).Cast< Void >();
	}
return null();
}


Void DefaultAssetLibrary_obj::loadFont( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("DefaultAssetLibrary","loadFont",0x1da5ca97,"DefaultAssetLibrary.loadFont","DefaultAssetLibrary.hx",529,0x0fc48912)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(551)
		::flash::text::Font _g = this->getFont(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(551)
		handler(_g).Cast< Void >();
	}
return null();
}


Void DefaultAssetLibrary_obj::loadMusic( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("DefaultAssetLibrary","loadMusic",0xdf3492dd,"DefaultAssetLibrary.loadMusic","DefaultAssetLibrary.hx",558,0x0fc48912)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(580)
		::flash::media::Sound _g = this->getMusic(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(580)
		handler(_g).Cast< Void >();
	}
return null();
}


Void DefaultAssetLibrary_obj::loadSound( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("DefaultAssetLibrary","loadSound",0x4fa64f07,"DefaultAssetLibrary.loadSound","DefaultAssetLibrary.hx",587,0x0fc48912)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(609)
		::flash::media::Sound _g = this->getSound(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(609)
		handler(_g).Cast< Void >();
	}
return null();
}


Void DefaultAssetLibrary_obj::loadText( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("DefaultAssetLibrary","loadText",0x26df3975,"DefaultAssetLibrary.loadText","DefaultAssetLibrary.hx",616,0x0fc48912)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(616)
		Dynamic handler1 = Dynamic( Array_obj<Dynamic>::__new().Add(handler));		HX_STACK_VAR(handler1,"handler1");

		HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Dynamic,handler1)
		Void run(::flash::utils::ByteArray bytes){
			HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","DefaultAssetLibrary.hx",640,0x0fc48912)
			HX_STACK_ARG(bytes,"bytes")
			{
				HX_STACK_LINE(640)
				if (((bytes == null()))){
					HX_STACK_LINE(642)
					handler1->__GetItem((int)0)(null()).Cast< Void >();
				}
				else{
					HX_STACK_LINE(646)
					::String _g = bytes->readUTFBytes(bytes->length);		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(646)
					handler1->__GetItem((int)0)(_g).Cast< Void >();
				}
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_STACK_LINE(638)
		Dynamic callback =  Dynamic(new _Function_1_1(handler1));		HX_STACK_VAR(callback,"callback");
		HX_STACK_LINE(652)
		this->loadBytes(id,callback);
	}
return null();
}


::haxe::ds::StringMap DefaultAssetLibrary_obj::className;

::haxe::ds::StringMap DefaultAssetLibrary_obj::path;

::haxe::ds::StringMap DefaultAssetLibrary_obj::type;


DefaultAssetLibrary_obj::DefaultAssetLibrary_obj()
{
}

Dynamic DefaultAssetLibrary_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"path") ) { return path; }
		if (HX_FIELD_EQ(inName,"type") ) { return type; }
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
		if (HX_FIELD_EQ(inName,"className") ) { return className; }
		if (HX_FIELD_EQ(inName,"loadBytes") ) { return loadBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"loadMusic") ) { return loadMusic_dyn(); }
		if (HX_FIELD_EQ(inName,"loadSound") ) { return loadSound_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getBitmapData") ) { return getBitmapData_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"loadBitmapData") ) { return loadBitmapData_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DefaultAssetLibrary_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"path") ) { path=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		if (HX_FIELD_EQ(inName,"type") ) { type=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"className") ) { className=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DefaultAssetLibrary_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("className"),
	HX_CSTRING("path"),
	HX_CSTRING("type"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("exists"),
	HX_CSTRING("getBitmapData"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("getFont"),
	HX_CSTRING("getMusic"),
	HX_CSTRING("getPath"),
	HX_CSTRING("getSound"),
	HX_CSTRING("getText"),
	HX_CSTRING("isLocal"),
	HX_CSTRING("loadBitmapData"),
	HX_CSTRING("loadBytes"),
	HX_CSTRING("loadFont"),
	HX_CSTRING("loadMusic"),
	HX_CSTRING("loadSound"),
	HX_CSTRING("loadText"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DefaultAssetLibrary_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(DefaultAssetLibrary_obj::className,"className");
	HX_MARK_MEMBER_NAME(DefaultAssetLibrary_obj::path,"path");
	HX_MARK_MEMBER_NAME(DefaultAssetLibrary_obj::type,"type");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DefaultAssetLibrary_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(DefaultAssetLibrary_obj::className,"className");
	HX_VISIT_MEMBER_NAME(DefaultAssetLibrary_obj::path,"path");
	HX_VISIT_MEMBER_NAME(DefaultAssetLibrary_obj::type,"type");
};

#endif

Class DefaultAssetLibrary_obj::__mClass;

void DefaultAssetLibrary_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("DefaultAssetLibrary"), hx::TCanCast< DefaultAssetLibrary_obj> ,sStaticFields,sMemberFields,
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

void DefaultAssetLibrary_obj::__boot()
{
	className= ::haxe::ds::StringMap_obj::__new();
	path= ::haxe::ds::StringMap_obj::__new();
	type= ::haxe::ds::StringMap_obj::__new();
}

