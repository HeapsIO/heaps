#include <hxcpp.h>

#ifndef INCLUDED_Type
#include <Type.h>
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
#ifndef INCLUDED_flash_display_Sprite
#include <flash/display/Sprite.h>
#endif
#ifndef INCLUDED_flash_display_Stage
#include <flash/display/Stage.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_Rectangle
#include <flash/geom/Rectangle.h>
#endif
namespace flash{
namespace display{

Void Sprite_obj::__construct()
{
HX_STACK_FRAME("flash.display.Sprite","new",0x90f8c241,"flash.display.Sprite.new","flash/display/Sprite.hx",14,0x9c3a670d)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(16)
	Dynamic _g = ::flash::display::DisplayObjectContainer_obj::lime_create_display_object_container();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(16)
	::String _g1 = this->__getType();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(16)
	super::__construct(_g,_g1);
}
;
	return null();
}

//Sprite_obj::~Sprite_obj() { }

Dynamic Sprite_obj::__CreateEmpty() { return  new Sprite_obj; }
hx::ObjectPtr< Sprite_obj > Sprite_obj::__new()
{  hx::ObjectPtr< Sprite_obj > result = new Sprite_obj();
	result->__construct();
	return result;}

Dynamic Sprite_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Sprite_obj > result = new Sprite_obj();
	result->__construct();
	return result;}

Void Sprite_obj::startDrag( hx::Null< bool >  __o_lockCenter,::flash::geom::Rectangle bounds){
bool lockCenter = __o_lockCenter.Default(false);
	HX_STACK_FRAME("flash.display.Sprite","startDrag",0xe030b617,"flash.display.Sprite.startDrag","flash/display/Sprite.hx",21,0x9c3a670d)
	HX_STACK_THIS(this)
	HX_STACK_ARG(lockCenter,"lockCenter")
	HX_STACK_ARG(bounds,"bounds")
{
		HX_STACK_LINE(23)
		::flash::display::Stage _g = this->get_stage();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(23)
		if (((_g != null()))){
			HX_STACK_LINE(25)
			this->get_stage()->__startDrag(hx::ObjectPtr<OBJ_>(this),lockCenter,bounds);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sprite_obj,startDrag,(void))

Void Sprite_obj::stopDrag( ){
{
		HX_STACK_FRAME("flash.display.Sprite","stopDrag",0x2a480f95,"flash.display.Sprite.stopDrag","flash/display/Sprite.hx",32,0x9c3a670d)
		HX_STACK_THIS(this)
		HX_STACK_LINE(34)
		::flash::display::Stage _g = this->get_stage();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(34)
		if (((_g != null()))){
			HX_STACK_LINE(36)
			this->get_stage()->__stopDrag(hx::ObjectPtr<OBJ_>(this));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,stopDrag,(void))

::String Sprite_obj::__getType( ){
	HX_STACK_FRAME("flash.display.Sprite","__getType",0x85a703f1,"flash.display.Sprite.__getType","flash/display/Sprite.hx",43,0x9c3a670d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(45)
	::Class _g = ::Type_obj::getClass(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(45)
	::String type = ::Type_obj::getClassName(_g);		HX_STACK_VAR(type,"type");
	HX_STACK_LINE(46)
	int position = type.lastIndexOf(HX_CSTRING("."),null());		HX_STACK_VAR(position,"position");
	HX_STACK_LINE(47)
	if (((position >= (int)0))){
		HX_STACK_LINE(47)
		return type.substr((position + (int)1),null());
	}
	else{
		HX_STACK_LINE(47)
		return type;
	}
	HX_STACK_LINE(47)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sprite_obj,__getType,return )


Sprite_obj::Sprite_obj()
{
}

Dynamic Sprite_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"stopDrag") ) { return stopDrag_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"startDrag") ) { return startDrag_dyn(); }
		if (HX_FIELD_EQ(inName,"__getType") ) { return __getType_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"buttonMode") ) { return buttonMode; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"useHandCursor") ) { return useHandCursor; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Sprite_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"buttonMode") ) { buttonMode=inValue.Cast< bool >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"useHandCursor") ) { useHandCursor=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Sprite_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("buttonMode"));
	outFields->push(HX_CSTRING("useHandCursor"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(Sprite_obj,buttonMode),HX_CSTRING("buttonMode")},
	{hx::fsBool,(int)offsetof(Sprite_obj,useHandCursor),HX_CSTRING("useHandCursor")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("buttonMode"),
	HX_CSTRING("useHandCursor"),
	HX_CSTRING("startDrag"),
	HX_CSTRING("stopDrag"),
	HX_CSTRING("__getType"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Sprite_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Sprite_obj::__mClass,"__mClass");
};

#endif

Class Sprite_obj::__mClass;

void Sprite_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.Sprite"), hx::TCanCast< Sprite_obj> ,sStaticFields,sMemberFields,
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

void Sprite_obj::__boot()
{
}

} // end namespace flash
} // end namespace display
