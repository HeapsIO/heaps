#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxd_res_Any
#include <hxd/res/Any.h>
#endif
#ifndef INCLUDED_hxd_res_BitmapFont
#include <hxd/res/BitmapFont.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_FileSystem
#include <hxd/res/FileSystem.h>
#endif
#ifndef INCLUDED_hxd_res_Font
#include <hxd/res/Font.h>
#endif
#ifndef INCLUDED_hxd_res_Loader
#include <hxd/res/Loader.h>
#endif
#ifndef INCLUDED_hxd_res_Model
#include <hxd/res/Model.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
#ifndef INCLUDED_hxd_res_Sound
#include <hxd/res/Sound.h>
#endif
#ifndef INCLUDED_hxd_res_Texture
#include <hxd/res/Texture.h>
#endif
#ifndef INCLUDED_hxd_res_TiledMap
#include <hxd/res/TiledMap.h>
#endif
namespace hxd{
namespace res{

Void Loader_obj::__construct(::hxd::res::FileSystem fs)
{
HX_STACK_FRAME("hxd.res.Loader","new",0xf1bd5acd,"hxd.res.Loader.new","hxd/res/Loader.hx",8,0x50648881)
HX_STACK_THIS(this)
HX_STACK_ARG(fs,"fs")
{
	HX_STACK_LINE(9)
	this->fs = fs;
	HX_STACK_LINE(10)
	::haxe::ds::StringMap _g = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(10)
	this->cache = _g;
}
;
	return null();
}

//Loader_obj::~Loader_obj() { }

Dynamic Loader_obj::__CreateEmpty() { return  new Loader_obj; }
hx::ObjectPtr< Loader_obj > Loader_obj::__new(::hxd::res::FileSystem fs)
{  hx::ObjectPtr< Loader_obj > result = new Loader_obj();
	result->__construct(fs);
	return result;}

Dynamic Loader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Loader_obj > result = new Loader_obj();
	result->__construct(inArgs[0]);
	return result;}

bool Loader_obj::exists( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","exists",0x5595158f,"hxd.res.Loader.exists","hxd/res/Loader.hx",14,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(14)
	return this->fs->exists(path);
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,exists,return )

::hxd::res::Any Loader_obj::load( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","load",0x92a72f19,"hxd.res.Loader.load","hxd/res/Loader.hx",17,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(18)
	::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(18)
	return ::hxd::res::Any_obj::__new(hx::ObjectPtr<OBJ_>(this),_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,load,return )

::hxd::res::Texture Loader_obj::loadTexture( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","loadTexture",0x654bc6c2,"hxd.res.Loader.loadTexture","hxd/res/Loader.hx",21,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(22)
	Dynamic t = this->cache->get(path);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(23)
	if (((t == null()))){
		HX_STACK_LINE(24)
		::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(24)
		::hxd::res::Texture _g1 = ::hxd::res::Texture_obj::__new(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(24)
		t = _g1;
		HX_STACK_LINE(25)
		{
			HX_STACK_LINE(25)
			Dynamic value = t;		HX_STACK_VAR(value,"value");
			HX_STACK_LINE(25)
			this->cache->set(path,value);
		}
	}
	HX_STACK_LINE(27)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,loadTexture,return )

::hxd::res::Model Loader_obj::loadModel( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","loadModel",0xd46009d0,"hxd.res.Loader.loadModel","hxd/res/Loader.hx",30,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(31)
	Dynamic m = this->cache->get(path);		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(32)
	if (((m == null()))){
		HX_STACK_LINE(33)
		::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(33)
		::hxd::res::Model _g1 = ::hxd::res::Model_obj::__new(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(33)
		m = _g1;
		HX_STACK_LINE(34)
		{
			HX_STACK_LINE(34)
			Dynamic value = m;		HX_STACK_VAR(value,"value");
			HX_STACK_LINE(34)
			this->cache->set(path,value);
		}
	}
	HX_STACK_LINE(36)
	return m;
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,loadModel,return )

::hxd::res::Sound Loader_obj::loadSound( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","loadSound",0x48d472f6,"hxd.res.Loader.loadSound","hxd/res/Loader.hx",59,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(60)
	::hxd::res::Sound s = this->cache->get(path);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(61)
	if (((s == null()))){
		HX_STACK_LINE(62)
		::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(62)
		::hxd::res::Sound _g1 = ::hxd::res::Sound_obj::__new(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(62)
		s = _g1;
		HX_STACK_LINE(63)
		this->cache->set(path,s);
	}
	HX_STACK_LINE(65)
	return s;
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,loadSound,return )

::hxd::res::Font Loader_obj::loadFont( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","loadFont",0xdb08b988,"hxd.res.Loader.loadFont","hxd/res/Loader.hx",68,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(70)
	::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(70)
	return ::hxd::res::Font_obj::__new(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,loadFont,return )

::hxd::res::BitmapFont Loader_obj::loadBitmapFont( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","loadBitmapFont",0xa09f29d7,"hxd.res.Loader.loadBitmapFont","hxd/res/Loader.hx",73,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(74)
	::hxd::res::BitmapFont f = this->cache->get(path);		HX_STACK_VAR(f,"f");
	HX_STACK_LINE(75)
	if (((f == null()))){
		HX_STACK_LINE(76)
		::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(76)
		::hxd::res::BitmapFont _g1 = ::hxd::res::BitmapFont_obj::__new(hx::ObjectPtr<OBJ_>(this),_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(76)
		f = _g1;
		HX_STACK_LINE(77)
		this->cache->set(path,f);
	}
	HX_STACK_LINE(79)
	return f;
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,loadBitmapFont,return )

::hxd::res::Resource Loader_obj::loadData( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","loadData",0xd9abb1e3,"hxd.res.Loader.loadData","hxd/res/Loader.hx",82,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(83)
	::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(83)
	return ::hxd::res::Resource_obj::__new(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,loadData,return )

::hxd::res::TiledMap Loader_obj::loadTiledMap( ::String path){
	HX_STACK_FRAME("hxd.res.Loader","loadTiledMap",0x68b43eff,"hxd.res.Loader.loadTiledMap","hxd/res/Loader.hx",86,0x50648881)
	HX_STACK_THIS(this)
	HX_STACK_ARG(path,"path")
	HX_STACK_LINE(87)
	::hxd::res::FileEntry _g = this->fs->get(path);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(87)
	return ::hxd::res::TiledMap_obj::__new(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Loader_obj,loadTiledMap,return )


Loader_obj::Loader_obj()
{
}

void Loader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Loader);
	HX_MARK_MEMBER_NAME(fs,"fs");
	HX_MARK_MEMBER_NAME(cache,"cache");
	HX_MARK_END_CLASS();
}

void Loader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(fs,"fs");
	HX_VISIT_MEMBER_NAME(cache,"cache");
}

Dynamic Loader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"fs") ) { return fs; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"cache") ) { return cache; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"loadFont") ) { return loadFont_dyn(); }
		if (HX_FIELD_EQ(inName,"loadData") ) { return loadData_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"loadModel") ) { return loadModel_dyn(); }
		if (HX_FIELD_EQ(inName,"loadSound") ) { return loadSound_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"loadTexture") ) { return loadTexture_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"loadTiledMap") ) { return loadTiledMap_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"loadBitmapFont") ) { return loadBitmapFont_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Loader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"fs") ) { fs=inValue.Cast< ::hxd::res::FileSystem >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"cache") ) { cache=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Loader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("fs"));
	outFields->push(HX_CSTRING("cache"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::res::FileSystem*/ ,(int)offsetof(Loader_obj,fs),HX_CSTRING("fs")},
	{hx::fsObject /*::haxe::ds::StringMap*/ ,(int)offsetof(Loader_obj,cache),HX_CSTRING("cache")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("fs"),
	HX_CSTRING("cache"),
	HX_CSTRING("exists"),
	HX_CSTRING("load"),
	HX_CSTRING("loadTexture"),
	HX_CSTRING("loadModel"),
	HX_CSTRING("loadSound"),
	HX_CSTRING("loadFont"),
	HX_CSTRING("loadBitmapFont"),
	HX_CSTRING("loadData"),
	HX_CSTRING("loadTiledMap"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Loader_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Loader_obj::__mClass,"__mClass");
};

#endif

Class Loader_obj::__mClass;

void Loader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Loader"), hx::TCanCast< Loader_obj> ,sStaticFields,sMemberFields,
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

void Loader_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
