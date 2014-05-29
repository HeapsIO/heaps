#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h3d_fbx_Library
#include <h3d/fbx/Library.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_impl_ArrayIterator
#include <hxd/impl/ArrayIterator.h>
#endif
#ifndef INCLUDED_hxd_res_Any
#include <hxd/res/Any.h>
#endif
#ifndef INCLUDED_hxd_res_BitmapFont
#include <hxd/res/BitmapFont.h>
#endif
#ifndef INCLUDED_hxd_res_BytesFileSystem
#include <hxd/res/BytesFileSystem.h>
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
#ifndef INCLUDED_hxd_res__Any_SingleFileSystem
#include <hxd/res/_Any/SingleFileSystem.h>
#endif
namespace hxd{
namespace res{

Void Any_obj::__construct(::hxd::res::Loader loader,::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.Any","new",0x756b1896,"hxd.res.Any.new","hxd/res/Any.hx",25,0xf2276d9c)
HX_STACK_THIS(this)
HX_STACK_ARG(loader,"loader")
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(26)
	super::__construct(entry);
	HX_STACK_LINE(27)
	this->loader = loader;
}
;
	return null();
}

//Any_obj::~Any_obj() { }

Dynamic Any_obj::__CreateEmpty() { return  new Any_obj; }
hx::ObjectPtr< Any_obj > Any_obj::__new(::hxd::res::Loader loader,::hxd::res::FileEntry entry)
{  hx::ObjectPtr< Any_obj > result = new Any_obj();
	result->__construct(loader,entry);
	return result;}

Dynamic Any_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Any_obj > result = new Any_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::hxd::res::Model Any_obj::toModel( ){
	HX_STACK_FRAME("hxd.res.Any","toModel",0x16db0b64,"hxd.res.Any.toModel","hxd/res/Any.hx",30,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(31)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(31)
	return this->loader->loadModel(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toModel,return )

::h3d::fbx::Library Any_obj::toFbx( ){
	HX_STACK_FRAME("hxd.res.Any","toFbx",0x73b1aeb7,"hxd.res.Any.toFbx","hxd/res/Any.hx",34,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(35)
	return this->loader->loadModel(_g)->toFbx();
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toFbx,return )

::h3d::mat::Texture Any_obj::toTexture( ){
	HX_STACK_FRAME("hxd.res.Any","toTexture",0x7db95556,"hxd.res.Any.toTexture","hxd/res/Any.hx",44,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(45)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(45)
	return this->loader->loadTexture(_g)->toTexture();
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toTexture,return )

::h2d::Tile Any_obj::toTile( ){
	HX_STACK_FRAME("hxd.res.Any","toTile",0xd10d73d3,"hxd.res.Any.toTile","hxd/res/Any.hx",48,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(49)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(49)
	return this->loader->loadTexture(_g)->toTile();
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toTile,return )

::String Any_obj::toString( ){
	HX_STACK_FRAME("hxd.res.Any","toString",0x393804b6,"hxd.res.Any.toString","hxd/res/Any.hx",53,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(53)
	return this->entry->getBytes()->toString();
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toString,return )

::hxd::res::Texture Any_obj::toImage( ){
	HX_STACK_FRAME("hxd.res.Any","toImage",0xc7ec0716,"hxd.res.Any.toImage","hxd/res/Any.hx",56,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(57)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(57)
	return this->loader->loadTexture(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toImage,return )

::hxd::res::Texture Any_obj::getTexture( ){
	HX_STACK_FRAME("hxd.res.Any","getTexture",0x9ac8196f,"hxd.res.Any.getTexture","hxd/res/Any.hx",60,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(61)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(61)
	return this->loader->loadTexture(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,getTexture,return )

::hxd::res::Sound Any_obj::toSound( ){
	HX_STACK_FRAME("hxd.res.Any","toSound",0x8b4f748a,"hxd.res.Any.toSound","hxd/res/Any.hx",64,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(65)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(65)
	return this->loader->loadSound(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toSound,return )

::hxd::res::Font Any_obj::toFont( ){
	HX_STACK_FRAME("hxd.res.Any","toFont",0xc7d10674,"hxd.res.Any.toFont","hxd/res/Any.hx",68,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(69)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(69)
	return this->loader->loadFont(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toFont,return )

::flash::display::BitmapData Any_obj::toBitmap( ){
	HX_STACK_FRAME("hxd.res.Any","toBitmap",0x1913ebd4,"hxd.res.Any.toBitmap","hxd/res/Any.hx",72,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(73)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(73)
	return this->loader->loadTexture(_g)->toBitmap();
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toBitmap,return )

::hxd::res::BitmapFont Any_obj::toBitmapFont( ){
	HX_STACK_FRAME("hxd.res.Any","toBitmapFont",0x0871efc3,"hxd.res.Any.toBitmapFont","hxd/res/Any.hx",76,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(77)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(77)
	return this->loader->loadBitmapFont(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toBitmapFont,return )

::hxd::res::TiledMap Any_obj::toTiledMap( ){
	HX_STACK_FRAME("hxd.res.Any","toTiledMap",0xb02371eb,"hxd.res.Any.toTiledMap","hxd/res/Any.hx",80,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(81)
	::String _g = this->entry->get_path();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(81)
	return this->loader->loadTiledMap(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,toTiledMap,return )

::hxd::impl::ArrayIterator Any_obj::iterator( ){
	HX_STACK_FRAME("hxd.res.Any","iterator",0x94637df8,"hxd.res.Any.iterator","hxd/res/Any.hx",84,0xf2276d9c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(85)
	Array< ::Dynamic > _g2;		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(85)
	{
		HX_STACK_LINE(85)
		Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(85)
		{
			HX_STACK_LINE(85)
			::hxd::impl::ArrayIterator _g1 = this->entry->iterator();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(85)
			while((true)){
				HX_STACK_LINE(85)
				if ((!(((_g1->i < _g1->l))))){
					HX_STACK_LINE(85)
					break;
				}
				HX_STACK_LINE(85)
				int _g3 = (_g1->i)++;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(85)
				::hxd::res::FileEntry f = _g1->a->__GetItem(_g3);		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(85)
				::hxd::res::Any _g11 = ::hxd::res::Any_obj::__new(this->loader,f);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(85)
				_g->push(_g11);
			}
		}
		HX_STACK_LINE(85)
		_g2 = _g;
	}
	HX_STACK_LINE(85)
	return ::hxd::impl::ArrayIterator_obj::__new(_g2);
}


HX_DEFINE_DYNAMIC_FUNC0(Any_obj,iterator,return )

::hxd::res::Any Any_obj::fromBytes( ::String path,::haxe::io::Bytes bytes){
	HX_STACK_FRAME("hxd.res.Any","fromBytes",0x21654757,"hxd.res.Any.fromBytes","hxd/res/Any.hx",88,0xf2276d9c)
	HX_STACK_ARG(path,"path")
	HX_STACK_ARG(bytes,"bytes")
	HX_STACK_LINE(89)
	::hxd::res::_Any::SingleFileSystem fs = ::hxd::res::_Any::SingleFileSystem_obj::__new(path,bytes);		HX_STACK_VAR(fs,"fs");
	HX_STACK_LINE(90)
	return ::hxd::res::Loader_obj::__new(fs)->load(path);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Any_obj,fromBytes,return )


Any_obj::Any_obj()
{
}

void Any_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Any);
	HX_MARK_MEMBER_NAME(loader,"loader");
	::hxd::res::Resource_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Any_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(loader,"loader");
	::hxd::res::Resource_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Any_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"toFbx") ) { return toFbx_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"loader") ) { return loader; }
		if (HX_FIELD_EQ(inName,"toTile") ) { return toTile_dyn(); }
		if (HX_FIELD_EQ(inName,"toFont") ) { return toFont_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"toModel") ) { return toModel_dyn(); }
		if (HX_FIELD_EQ(inName,"toImage") ) { return toImage_dyn(); }
		if (HX_FIELD_EQ(inName,"toSound") ) { return toSound_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"toBitmap") ) { return toBitmap_dyn(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromBytes") ) { return fromBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"toTexture") ) { return toTexture_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getTexture") ) { return getTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"toTiledMap") ) { return toTiledMap_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"toBitmapFont") ) { return toBitmapFont_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Any_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"loader") ) { loader=inValue.Cast< ::hxd::res::Loader >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Any_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("loader"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromBytes"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::res::Loader*/ ,(int)offsetof(Any_obj,loader),HX_CSTRING("loader")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("loader"),
	HX_CSTRING("toModel"),
	HX_CSTRING("toFbx"),
	HX_CSTRING("toTexture"),
	HX_CSTRING("toTile"),
	HX_CSTRING("toString"),
	HX_CSTRING("toImage"),
	HX_CSTRING("getTexture"),
	HX_CSTRING("toSound"),
	HX_CSTRING("toFont"),
	HX_CSTRING("toBitmap"),
	HX_CSTRING("toBitmapFont"),
	HX_CSTRING("toTiledMap"),
	HX_CSTRING("iterator"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Any_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Any_obj::__mClass,"__mClass");
};

#endif

Class Any_obj::__mClass;

void Any_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Any"), hx::TCanCast< Any_obj> ,sStaticFields,sMemberFields,
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

void Any_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
