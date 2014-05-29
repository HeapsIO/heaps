#include <hxcpp.h>

#ifndef INCLUDED_flash_display_Bitmap
#include <flash/display/Bitmap.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_Graphics
#include <flash/display/Graphics.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_PixelSnapping
#include <flash/display/PixelSnapping.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix
#include <flash/geom/Matrix.h>
#endif
namespace flash{
namespace display{

Void Bitmap_obj::__construct(::flash::display::BitmapData bitmapData,::flash::display::PixelSnapping pixelSnapping,hx::Null< bool >  __o_smoothing)
{
HX_STACK_FRAME("flash.display.Bitmap","new",0xdcc8332b,"flash.display.Bitmap.new","flash/display/Bitmap.hx",15,0x0d120163)
HX_STACK_THIS(this)
HX_STACK_ARG(bitmapData,"bitmapData")
HX_STACK_ARG(pixelSnapping,"pixelSnapping")
HX_STACK_ARG(__o_smoothing,"smoothing")
bool smoothing = __o_smoothing.Default(false);
{
	HX_STACK_LINE(17)
	Dynamic _g = ::flash::display::DisplayObject_obj::lime_create_display_object();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(17)
	super::__construct(_g,HX_CSTRING("Bitmap"));
	HX_STACK_LINE(19)
	this->set_pixelSnapping((  (((pixelSnapping == null()))) ? ::flash::display::PixelSnapping(::flash::display::PixelSnapping_obj::AUTO) : ::flash::display::PixelSnapping(pixelSnapping) ));
	HX_STACK_LINE(20)
	this->set_smoothing(smoothing);
	HX_STACK_LINE(22)
	if (((bitmapData != null()))){
		HX_STACK_LINE(24)
		this->set_bitmapData(bitmapData);
	}
	else{
		HX_STACK_LINE(26)
		if (((this->bitmapData != null()))){
			HX_STACK_LINE(28)
			this->__rebuild();
		}
	}
}
;
	return null();
}

//Bitmap_obj::~Bitmap_obj() { }

Dynamic Bitmap_obj::__CreateEmpty() { return  new Bitmap_obj; }
hx::ObjectPtr< Bitmap_obj > Bitmap_obj::__new(::flash::display::BitmapData bitmapData,::flash::display::PixelSnapping pixelSnapping,hx::Null< bool >  __o_smoothing)
{  hx::ObjectPtr< Bitmap_obj > result = new Bitmap_obj();
	result->__construct(bitmapData,pixelSnapping,__o_smoothing);
	return result;}

Dynamic Bitmap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Bitmap_obj > result = new Bitmap_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void Bitmap_obj::__rebuild( ){
{
		HX_STACK_FRAME("flash.display.Bitmap","__rebuild",0xff428c86,"flash.display.Bitmap.__rebuild","flash/display/Bitmap.hx",37,0x0d120163)
		HX_STACK_THIS(this)
		HX_STACK_LINE(37)
		if (((this->__handle != null()))){
			HX_STACK_LINE(39)
			::flash::display::Graphics gfx = this->get_graphics();		HX_STACK_VAR(gfx,"gfx");
			HX_STACK_LINE(40)
			gfx->clear();
			HX_STACK_LINE(42)
			if (((this->bitmapData != null()))){
				HX_STACK_LINE(44)
				gfx->beginBitmapFill(this->bitmapData,null(),false,this->smoothing);
				HX_STACK_LINE(45)
				int _g = this->bitmapData->get_width();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(45)
				int _g1 = this->bitmapData->get_height();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(45)
				gfx->drawRect((int)0,(int)0,_g,_g1);
				HX_STACK_LINE(46)
				gfx->endFill();
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Bitmap_obj,__rebuild,(void))

::flash::display::BitmapData Bitmap_obj::set_bitmapData( ::flash::display::BitmapData value){
	HX_STACK_FRAME("flash.display.Bitmap","set_bitmapData",0x84a4f18b,"flash.display.Bitmap.set_bitmapData","flash/display/Bitmap.hx",62,0x0d120163)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(64)
	this->bitmapData = value;
	HX_STACK_LINE(65)
	this->__rebuild();
	HX_STACK_LINE(67)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Bitmap_obj,set_bitmapData,return )

bool Bitmap_obj::set_smoothing( bool value){
	HX_STACK_FRAME("flash.display.Bitmap","set_smoothing",0x672d79e2,"flash.display.Bitmap.set_smoothing","flash/display/Bitmap.hx",72,0x0d120163)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(74)
	this->smoothing = value;
	HX_STACK_LINE(75)
	this->__rebuild();
	HX_STACK_LINE(77)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Bitmap_obj,set_smoothing,return )


Bitmap_obj::Bitmap_obj()
{
}

void Bitmap_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Bitmap);
	HX_MARK_MEMBER_NAME(bitmapData,"bitmapData");
	HX_MARK_MEMBER_NAME(smoothing,"smoothing");
	::flash::display::DisplayObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Bitmap_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(bitmapData,"bitmapData");
	HX_VISIT_MEMBER_NAME(smoothing,"smoothing");
	::flash::display::DisplayObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Bitmap_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"smoothing") ) { return smoothing; }
		if (HX_FIELD_EQ(inName,"__rebuild") ) { return __rebuild_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bitmapData") ) { return bitmapData; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"set_smoothing") ) { return set_smoothing_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"set_bitmapData") ) { return set_bitmapData_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Bitmap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"smoothing") ) { if (inCallProp) return set_smoothing(inValue);smoothing=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bitmapData") ) { if (inCallProp) return set_bitmapData(inValue);bitmapData=inValue.Cast< ::flash::display::BitmapData >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Bitmap_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bitmapData"));
	outFields->push(HX_CSTRING("smoothing"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::flash::display::BitmapData*/ ,(int)offsetof(Bitmap_obj,bitmapData),HX_CSTRING("bitmapData")},
	{hx::fsBool,(int)offsetof(Bitmap_obj,smoothing),HX_CSTRING("smoothing")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bitmapData"),
	HX_CSTRING("smoothing"),
	HX_CSTRING("__rebuild"),
	HX_CSTRING("set_bitmapData"),
	HX_CSTRING("set_smoothing"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Bitmap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Bitmap_obj::__mClass,"__mClass");
};

#endif

Class Bitmap_obj::__mClass;

void Bitmap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.Bitmap"), hx::TCanCast< Bitmap_obj> ,sStaticFields,sMemberFields,
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

void Bitmap_obj::__boot()
{
}

} // end namespace flash
} // end namespace display
