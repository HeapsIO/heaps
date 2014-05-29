#include <hxcpp.h>

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
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
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
namespace openfl{

Void AssetLibrary_obj::__construct()
{
HX_STACK_FRAME("openfl.AssetLibrary","new",0x1b1e281b,"openfl.AssetLibrary.new","openfl/Assets.hx",1106,0x989d477c)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//AssetLibrary_obj::~AssetLibrary_obj() { }

Dynamic AssetLibrary_obj::__CreateEmpty() { return  new AssetLibrary_obj; }
hx::ObjectPtr< AssetLibrary_obj > AssetLibrary_obj::__new()
{  hx::ObjectPtr< AssetLibrary_obj > result = new AssetLibrary_obj();
	result->__construct();
	return result;}

Dynamic AssetLibrary_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AssetLibrary_obj > result = new AssetLibrary_obj();
	result->__construct();
	return result;}

bool AssetLibrary_obj::exists( ::String id,::openfl::AssetType type){
	HX_STACK_FRAME("openfl.AssetLibrary","exists",0xfc810d01,"openfl.AssetLibrary.exists","openfl/Assets.hx",1115,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(type,"type")
	HX_STACK_LINE(1115)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,exists,return )

::flash::display::BitmapData AssetLibrary_obj::getBitmapData( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getBitmapData",0x8468816a,"openfl.AssetLibrary.getBitmapData","openfl/Assets.hx",1122,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1122)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getBitmapData,return )

::flash::utils::ByteArray AssetLibrary_obj::getBytes( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getBytes",0x7785da5a,"openfl.AssetLibrary.getBytes","openfl/Assets.hx",1129,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1129)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getBytes,return )

::flash::text::Font AssetLibrary_obj::getFont( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getFont",0xe6735ec0,"openfl.AssetLibrary.getFont","openfl/Assets.hx",1136,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1136)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getFont,return )

::flash::display::MovieClip AssetLibrary_obj::getMovieClip( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getMovieClip",0x2889f80f,"openfl.AssetLibrary.getMovieClip","openfl/Assets.hx",1143,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1143)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getMovieClip,return )

::flash::media::Sound AssetLibrary_obj::getMusic( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getMusic",0xca48a294,"openfl.AssetLibrary.getMusic","openfl/Assets.hx",1150,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1150)
	return this->getSound(id);
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getMusic,return )

::String AssetLibrary_obj::getPath( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getPath",0xed04e696,"openfl.AssetLibrary.getPath","openfl/Assets.hx",1157,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1157)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getPath,return )

::flash::media::Sound AssetLibrary_obj::getSound( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getSound",0x3aba5ebe,"openfl.AssetLibrary.getSound","openfl/Assets.hx",1164,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1164)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getSound,return )

::String AssetLibrary_obj::getText( ::String id){
	HX_STACK_FRAME("openfl.AssetLibrary","getText",0xefaccd9e,"openfl.AssetLibrary.getText","openfl/Assets.hx",1169,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(1173)
	::flash::utils::ByteArray bytes = this->getBytes(id);		HX_STACK_VAR(bytes,"bytes");
	HX_STACK_LINE(1175)
	if (((bytes == null()))){
		HX_STACK_LINE(1177)
		return null();
	}
	else{
		HX_STACK_LINE(1181)
		return bytes->readUTFBytes(bytes->length);
	}
	HX_STACK_LINE(1175)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,getText,return )

bool AssetLibrary_obj::isLocal( ::String id,::openfl::AssetType type){
	HX_STACK_FRAME("openfl.AssetLibrary","isLocal",0xe5a6be5c,"openfl.AssetLibrary.isLocal","openfl/Assets.hx",1196,0x989d477c)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_ARG(type,"type")
	HX_STACK_LINE(1196)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,isLocal,return )

Void AssetLibrary_obj::load( Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","load",0x9dfa060b,"openfl.AssetLibrary.load","openfl/Assets.hx",1203,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1203)
		handler(hx::ObjectPtr<OBJ_>(this)).Cast< Void >();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AssetLibrary_obj,load,(void))

Void AssetLibrary_obj::loadBitmapData( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","loadBitmapData",0x84fddba4,"openfl.AssetLibrary.loadBitmapData","openfl/Assets.hx",1208,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1210)
		::flash::display::BitmapData _g = this->getBitmapData(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1210)
		handler(_g).Cast< Void >();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,loadBitmapData,(void))

Void AssetLibrary_obj::loadBytes( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","loadBytes",0x52a2aa60,"openfl.AssetLibrary.loadBytes","openfl/Assets.hx",1215,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1217)
		::flash::utils::ByteArray _g = this->getBytes(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1217)
		handler(_g).Cast< Void >();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,loadBytes,(void))

Void AssetLibrary_obj::loadFont( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","loadFont",0x0e76f17a,"openfl.AssetLibrary.loadFont","openfl/Assets.hx",1222,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1224)
		::flash::text::Font _g = this->getFont(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1224)
		handler(_g).Cast< Void >();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,loadFont,(void))

Void AssetLibrary_obj::loadMovieClip( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","loadMovieClip",0x8eb64315,"openfl.AssetLibrary.loadMovieClip","openfl/Assets.hx",1229,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1231)
		::flash::display::MovieClip _g = this->getMovieClip(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1231)
		handler(_g).Cast< Void >();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,loadMovieClip,(void))

Void AssetLibrary_obj::loadMusic( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","loadMusic",0xa565729a,"openfl.AssetLibrary.loadMusic","openfl/Assets.hx",1236,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1238)
		::flash::media::Sound _g = this->getMusic(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1238)
		handler(_g).Cast< Void >();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,loadMusic,(void))

Void AssetLibrary_obj::loadSound( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","loadSound",0x15d72ec4,"openfl.AssetLibrary.loadSound","openfl/Assets.hx",1243,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1245)
		::flash::media::Sound _g = this->getSound(id);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1245)
		handler(_g).Cast< Void >();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,loadSound,(void))

Void AssetLibrary_obj::loadText( ::String id,Dynamic handler){
{
		HX_STACK_FRAME("openfl.AssetLibrary","loadText",0x17b06058,"openfl.AssetLibrary.loadText","openfl/Assets.hx",1250,0x989d477c)
		HX_STACK_THIS(this)
		HX_STACK_ARG(id,"id")
		HX_STACK_ARG(handler,"handler")
		HX_STACK_LINE(1250)
		Dynamic handler1 = Dynamic( Array_obj<Dynamic>::__new().Add(handler));		HX_STACK_VAR(handler1,"handler1");

		HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Dynamic,handler1)
		Void run(::flash::utils::ByteArray bytes){
			HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","openfl/Assets.hx",1256,0x989d477c)
			HX_STACK_ARG(bytes,"bytes")
			{
				HX_STACK_LINE(1256)
				if (((bytes == null()))){
					HX_STACK_LINE(1258)
					handler1->__GetItem((int)0)(null()).Cast< Void >();
				}
				else{
					HX_STACK_LINE(1262)
					::String _g = bytes->readUTFBytes(bytes->length);		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(1262)
					handler1->__GetItem((int)0)(_g).Cast< Void >();
				}
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_STACK_LINE(1254)
		Dynamic callback =  Dynamic(new _Function_1_1(handler1));		HX_STACK_VAR(callback,"callback");
		HX_STACK_LINE(1268)
		this->loadBytes(id,callback);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(AssetLibrary_obj,loadText,(void))


AssetLibrary_obj::AssetLibrary_obj()
{
}

Dynamic AssetLibrary_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
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
		if (HX_FIELD_EQ(inName,"loadBytes") ) { return loadBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"loadMusic") ) { return loadMusic_dyn(); }
		if (HX_FIELD_EQ(inName,"loadSound") ) { return loadSound_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getMovieClip") ) { return getMovieClip_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getBitmapData") ) { return getBitmapData_dyn(); }
		if (HX_FIELD_EQ(inName,"loadMovieClip") ) { return loadMovieClip_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"loadBitmapData") ) { return loadBitmapData_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic AssetLibrary_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void AssetLibrary_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("exists"),
	HX_CSTRING("getBitmapData"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("getFont"),
	HX_CSTRING("getMovieClip"),
	HX_CSTRING("getMusic"),
	HX_CSTRING("getPath"),
	HX_CSTRING("getSound"),
	HX_CSTRING("getText"),
	HX_CSTRING("isLocal"),
	HX_CSTRING("load"),
	HX_CSTRING("loadBitmapData"),
	HX_CSTRING("loadBytes"),
	HX_CSTRING("loadFont"),
	HX_CSTRING("loadMovieClip"),
	HX_CSTRING("loadMusic"),
	HX_CSTRING("loadSound"),
	HX_CSTRING("loadText"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AssetLibrary_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(AssetLibrary_obj::__mClass,"__mClass");
};

#endif

Class AssetLibrary_obj::__mClass;

void AssetLibrary_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.AssetLibrary"), hx::TCanCast< AssetLibrary_obj> ,sStaticFields,sMemberFields,
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

void AssetLibrary_obj::__boot()
{
}

} // end namespace openfl
