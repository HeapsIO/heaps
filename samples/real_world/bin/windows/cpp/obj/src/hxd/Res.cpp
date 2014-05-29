#include <hxcpp.h>

#ifndef INCLUDED_hxd_Res
#include <hxd/Res.h>
#endif
#ifndef INCLUDED_hxd_res_Any
#include <hxd/res/Any.h>
#endif
#ifndef INCLUDED_hxd_res_Font
#include <hxd/res/Font.h>
#endif
#ifndef INCLUDED_hxd_res_Loader
#include <hxd/res/Loader.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
#ifndef INCLUDED_hxd_res_Texture
#include <hxd/res/Texture.h>
#endif
namespace hxd{

Void Res_obj::__construct()
{
	return null();
}

//Res_obj::~Res_obj() { }

Dynamic Res_obj::__CreateEmpty() { return  new Res_obj; }
hx::ObjectPtr< Res_obj > Res_obj::__new()
{  hx::ObjectPtr< Res_obj > result = new Res_obj();
	result->__construct();
	return result;}

Dynamic Res_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Res_obj > result = new Res_obj();
	result->__construct();
	return result;}

::hxd::res::Any Res_obj::load( ::String name){
	HX_STACK_FRAME("hxd.Res","load",0x9bcfb06e,"hxd.Res.load","hxd/Res.hx",10,0x36724619)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(10)
	return ::hxd::Res_obj::loader->load(name);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Res_obj,load,return )

::hxd::res::Loader Res_obj::loader;

::hxd::res::Texture Res_obj::get_char( ){
	HX_STACK_FRAME("hxd.Res","get_char",0x472ef4a7,"hxd.Res.get_char","hxd/Res.hx",4,0x36724619)
	HX_STACK_LINE(343)
	return ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("char.png"));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Res_obj,get_char,return )

::hxd::res::Texture Res_obj::get_haxe( ){
	HX_STACK_FRAME("hxd.Res","get_haxe",0x4a77c9f7,"hxd.Res.get_haxe","hxd/Res.hx",4,0x36724619)
	HX_STACK_LINE(343)
	return ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("haxe.png"));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Res_obj,get_haxe,return )

::hxd::res::Texture Res_obj::get_haxe2k( ){
	HX_STACK_FRAME("hxd.Res","get_haxe2k",0xaf77a1b0,"hxd.Res.get_haxe2k","hxd/Res.hx",4,0x36724619)
	HX_STACK_LINE(343)
	return ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("haxe2k.png"));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Res_obj,get_haxe2k,return )

::hxd::res::Texture Res_obj::get_nme( ){
	HX_STACK_FRAME("hxd.Res","get_nme",0x2bf9a695,"hxd.Res.get_nme","hxd/Res.hx",4,0x36724619)
	HX_STACK_LINE(343)
	return ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("nme.png"));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Res_obj,get_nme,return )

::hxd::res::Texture Res_obj::get_openfl( ){
	HX_STACK_FRAME("hxd.Res","get_openfl",0x1271cfa1,"hxd.Res.get_openfl","hxd/Res.hx",4,0x36724619)
	HX_STACK_LINE(343)
	return ::hxd::Res_obj::loader->loadTexture(HX_CSTRING("openfl.png"));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Res_obj,get_openfl,return )

::hxd::res::Font Res_obj::get_Roboto( ){
	HX_STACK_FRAME("hxd.Res","get_Roboto",0xe4b6eef6,"hxd.Res.get_Roboto","hxd/Res.hx",4,0x36724619)
	HX_STACK_LINE(347)
	return ::hxd::Res_obj::loader->loadFont(HX_CSTRING("Roboto.ttf"));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Res_obj,get_Roboto,return )


Res_obj::Res_obj()
{
}

Dynamic Res_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"nme") ) { return get_nme(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		if (HX_FIELD_EQ(inName,"char") ) { return get_char(); }
		if (HX_FIELD_EQ(inName,"haxe") ) { return get_haxe(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"loader") ) { return loader; }
		if (HX_FIELD_EQ(inName,"haxe2k") ) { return get_haxe2k(); }
		if (HX_FIELD_EQ(inName,"openfl") ) { return get_openfl(); }
		if (HX_FIELD_EQ(inName,"Roboto") ) { return get_Roboto(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"get_nme") ) { return get_nme_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"get_char") ) { return get_char_dyn(); }
		if (HX_FIELD_EQ(inName,"get_haxe") ) { return get_haxe_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_haxe2k") ) { return get_haxe2k_dyn(); }
		if (HX_FIELD_EQ(inName,"get_openfl") ) { return get_openfl_dyn(); }
		if (HX_FIELD_EQ(inName,"get_Roboto") ) { return get_Roboto_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Res_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"loader") ) { loader=inValue.Cast< ::hxd::res::Loader >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Res_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("load"),
	HX_CSTRING("loader"),
	HX_CSTRING("get_char"),
	HX_CSTRING("get_haxe"),
	HX_CSTRING("get_haxe2k"),
	HX_CSTRING("get_nme"),
	HX_CSTRING("get_openfl"),
	HX_CSTRING("get_Roboto"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Res_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Res_obj::loader,"loader");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Res_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Res_obj::loader,"loader");
};

#endif

Class Res_obj::__mClass;

void Res_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Res"), hx::TCanCast< Res_obj> ,sStaticFields,sMemberFields,
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

void Res_obj::__boot()
{
}

} // end namespace hxd
