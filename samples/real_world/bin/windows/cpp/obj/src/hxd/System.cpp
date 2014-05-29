#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_Sys
#include <Sys.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
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
#ifndef INCLUDED_flash_system_Capabilities
#include <flash/system/Capabilities.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_hxd_Cursor
#include <hxd/Cursor.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_openfl_display_DirectRenderer
#include <openfl/display/DirectRenderer.h>
#endif
#ifndef INCLUDED_openfl_display_OpenGLView
#include <openfl/display/OpenGLView.h>
#endif
#ifndef INCLUDED_sys_io_File
#include <sys/io/File.h>
#endif
namespace hxd{

Void System_obj::__construct()
{
	return null();
}

//System_obj::~System_obj() { }

Dynamic System_obj::__CreateEmpty() { return  new System_obj; }
hx::ObjectPtr< System_obj > System_obj::__new()
{  hx::ObjectPtr< System_obj > result = new System_obj();
	result->__construct();
	return result;}

Dynamic System_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< System_obj > result = new System_obj();
	result->__construct();
	return result;}

int System_obj::debugLevel;

Void System_obj::ensureViewBelow( ){
{
		HX_STACK_FRAME("hxd.System","ensureViewBelow",0xcca5d2e9,"hxd.System.ensureViewBelow","hxd/System.hx",34,0xb8cb9154)
		HX_STACK_LINE(34)
		if (((::hxd::System_obj::VIEW == null()))){
			HX_STACK_LINE(35)
			::openfl::display::OpenGLView _g = ::openfl::display::OpenGLView_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(35)
			::hxd::System_obj::VIEW = _g;
			HX_STACK_LINE(36)
			::hxd::System_obj::VIEW->set_name(HX_CSTRING("glView"));
			HX_STACK_LINE(37)
			::flash::Lib_obj::get_current()->addChildAt(::hxd::System_obj::VIEW,(int)0);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,ensureViewBelow,(void))

::openfl::display::OpenGLView System_obj::VIEW;

int System_obj::spin;

Void System_obj::setLoop( Dynamic f){
{
		HX_STACK_FRAME("hxd.System","setLoop",0x7555daa1,"hxd.System.setLoop","hxd/System.hx",214,0xb8cb9154)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(214)
		Dynamic f1 = Dynamic( Array_obj<Dynamic>::__new().Add(f));		HX_STACK_VAR(f1,"f1");
		HX_STACK_LINE(215)
		::hxd::System_obj::ensureViewBelow();

		HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Dynamic,f1)
		Void run(::flash::geom::Rectangle _){
			HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","hxd/System.hx",216,0xb8cb9154)
			HX_STACK_ARG(_,"_")
			{
				HX_STACK_LINE(218)
				(::hxd::System_obj::spin)++;
				HX_STACK_LINE(219)
				if (((::hxd::System_obj::spin >= (int)200))){
					HX_STACK_LINE(221)
					(::hxd::System_obj::spin)++;
					HX_STACK_LINE(222)
					::hxd::System_obj::spin = (int)0;
				}
				HX_STACK_LINE(225)
				if (((f1->__GetItem((int)0) != null()))){
					HX_STACK_LINE(226)
					f1->__GetItem((int)0)().Cast< Void >();
				}
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_STACK_LINE(216)
		::hxd::System_obj::VIEW->render =  Dynamic(new _Function_1_1(f1));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(System_obj,setLoop,(void))

Dynamic System_obj::setCursor;

Void System_obj::setNativeCursor( ::hxd::Cursor c){
{
		HX_STACK_FRAME("hxd.System","setNativeCursor",0x3c77d10a,"hxd.System.setNativeCursor","hxd/System.hx",232,0xb8cb9154)
		HX_STACK_ARG(c,"c")
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(System_obj,setNativeCursor,(void))

::String System_obj::get_lang( ){
	HX_STACK_FRAME("hxd.System","get_lang",0x7602d99c,"hxd.System.get_lang","hxd/System.hx",242,0xb8cb9154)
	HX_STACK_LINE(243)
	Array< ::String > _g = ::flash::system::Capabilities_obj::get_language().split(HX_CSTRING("-"));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(243)
	return _g->__get((int)0);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,get_lang,return )

Float System_obj::get_screenDPI( ){
	HX_STACK_FRAME("hxd.System","get_screenDPI",0xd4b6a4e3,"hxd.System.get_screenDPI","hxd/System.hx",247,0xb8cb9154)
	HX_STACK_LINE(247)
	return ::flash::system::Capabilities_obj::get_screenDPI();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,get_screenDPI,return )

bool System_obj::get_isAndroid( ){
	HX_STACK_FRAME("hxd.System","get_isAndroid",0x3d692df7,"hxd.System.get_isAndroid","hxd/System.hx",254,0xb8cb9154)
	HX_STACK_LINE(254)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,get_isAndroid,return )

::String System_obj::CACHED_NAME;

::String System_obj::getDeviceName( ){
	HX_STACK_FRAME("hxd.System","getDeviceName",0xea5e1bf2,"hxd.System.getDeviceName","hxd/System.hx",259,0xb8cb9154)
	HX_STACK_LINE(260)
	if (((::hxd::System_obj::CACHED_NAME != null()))){
		HX_STACK_LINE(261)
		return ::hxd::System_obj::CACHED_NAME;
	}
	HX_STACK_LINE(262)
	::String name;		HX_STACK_VAR(name,"name");
	HX_STACK_LINE(263)
	if ((::hxd::System_obj::get_isAndroid())){
		HX_STACK_LINE(264)
		try
		{
		HX_STACK_CATCHABLE(Dynamic, 0);
		{
			HX_STACK_LINE(265)
			::String content = ::sys::io::File_obj::getContent(HX_CSTRING("/system/build.prop"));		HX_STACK_VAR(content,"content");
			HX_STACK_LINE(266)
			Array< ::String > _g = content.split(HX_CSTRING("ro.product.model="));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(266)
			Array< ::String > _g1 = _g->__get((int)1).split(HX_CSTRING("\n"));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(266)
			::String _g2 = _g1->__get((int)0);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(266)
			::String _g3 = ::StringTools_obj::trim(_g2);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(266)
			name = _g3;
		}
		}
		catch(Dynamic __e){
			{
				HX_STACK_BEGIN_CATCH
				Dynamic e = __e;{
					HX_STACK_LINE(268)
					name = HX_CSTRING("Android");
				}
			}
		}
	}
	else{
		HX_STACK_LINE(271)
		name = HX_CSTRING("PC");
	}
	HX_STACK_LINE(272)
	::hxd::System_obj::CACHED_NAME = name;
	HX_STACK_LINE(273)
	return name;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,getDeviceName,return )

Void System_obj::exit( ){
{
		HX_STACK_FRAME("hxd.System","exit",0xec16d8c3,"hxd.System.exit","hxd/System.hx",277,0xb8cb9154)
		HX_STACK_LINE(277)
		::Sys_obj::exit((int)0);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,exit,(void))

bool System_obj::get_isWindowed( ){
	HX_STACK_FRAME("hxd.System","get_isWindowed",0x8909a487,"hxd.System.get_isWindowed","hxd/System.hx",281,0xb8cb9154)
	HX_STACK_LINE(281)
	return true;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,get_isWindowed,return )

bool System_obj::get_isTouch( ){
	HX_STACK_FRAME("hxd.System","get_isTouch",0x508be887,"hxd.System.get_isTouch","hxd/System.hx",285,0xb8cb9154)
	HX_STACK_LINE(285)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,get_isTouch,return )

int System_obj::get_width( ){
	HX_STACK_FRAME("hxd.System","get_width",0x27261a98,"hxd.System.get_width","hxd/System.hx",288,0xb8cb9154)
	HX_STACK_LINE(289)
	Dynamic Cap = hx::ClassOf< ::flash::system::Capabilities >();		HX_STACK_VAR(Cap,"Cap");
	HX_STACK_LINE(290)
	if ((::hxd::System_obj::get_isWindowed())){
		HX_STACK_LINE(290)
		return ::flash::Lib_obj::get_current()->get_stage()->get_stageWidth();
	}
	else{
		HX_STACK_LINE(290)
		Float _g = Cap->__Field(HX_CSTRING("get_screenResolutionX"),true)();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(290)
		Float _g1 = Cap->__Field(HX_CSTRING("get_screenResolutionY"),true)();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(290)
		Float _g2;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(290)
		if (((_g > _g1))){
			HX_STACK_LINE(290)
			_g2 = Cap->__Field(HX_CSTRING("get_screenResolutionX"),true)();
		}
		else{
			HX_STACK_LINE(290)
			_g2 = Cap->__Field(HX_CSTRING("get_screenResolutionY"),true)();
		}
		HX_STACK_LINE(290)
		return ::Std_obj::_int(_g2);
	}
	HX_STACK_LINE(290)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,get_width,return )

int System_obj::get_height( ){
	HX_STACK_FRAME("hxd.System","get_height",0xd080a315,"hxd.System.get_height","hxd/System.hx",293,0xb8cb9154)
	HX_STACK_LINE(294)
	Dynamic Cap = hx::ClassOf< ::flash::system::Capabilities >();		HX_STACK_VAR(Cap,"Cap");
	HX_STACK_LINE(295)
	if ((::hxd::System_obj::get_isWindowed())){
		HX_STACK_LINE(295)
		return ::flash::Lib_obj::get_current()->get_stage()->get_stageHeight();
	}
	else{
		HX_STACK_LINE(295)
		Float _g = Cap->__Field(HX_CSTRING("get_screenResolutionX"),true)();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(295)
		Float _g1 = Cap->__Field(HX_CSTRING("get_screenResolutionY"),true)();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(295)
		Float _g2;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(295)
		if (((_g > _g1))){
			HX_STACK_LINE(295)
			_g2 = Cap->__Field(HX_CSTRING("get_screenResolutionY"),true)();
		}
		else{
			HX_STACK_LINE(295)
			_g2 = Cap->__Field(HX_CSTRING("get_screenResolutionX"),true)();
		}
		HX_STACK_LINE(295)
		return ::Std_obj::_int(_g2);
	}
	HX_STACK_LINE(295)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(System_obj,get_height,return )

Dynamic System_obj::trace1( Dynamic msg,Dynamic pos){
	HX_STACK_FRAME("hxd.System","trace1",0xc7ad7af1,"hxd.System.trace1","hxd/System.hx",303,0xb8cb9154)
	HX_STACK_ARG(msg,"msg")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(305)
	if (((::hxd::System_obj::debugLevel >= (int)1))){
		HX_STACK_LINE(305)
		::String _g = ::Std_obj::string(msg);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(305)
		::String _g1 = ((((((pos->__Field(HX_CSTRING("fileName"),true) + HX_CSTRING(":")) + pos->__Field(HX_CSTRING("methodName"),true)) + HX_CSTRING(":")) + pos->__Field(HX_CSTRING("lineNumber"),true)) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(305)
		::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),305,HX_CSTRING("hxd.System"),HX_CSTRING("trace1")));
	}
	HX_STACK_LINE(306)
	return msg;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(System_obj,trace1,return )

Dynamic System_obj::trace2( Dynamic msg,Dynamic pos){
	HX_STACK_FRAME("hxd.System","trace2",0xc7ad7af2,"hxd.System.trace2","hxd/System.hx",313,0xb8cb9154)
	HX_STACK_ARG(msg,"msg")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(315)
	if (((::hxd::System_obj::debugLevel >= (int)2))){
		HX_STACK_LINE(315)
		::String _g = ::Std_obj::string(msg);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(315)
		::String _g1 = ((((((pos->__Field(HX_CSTRING("fileName"),true) + HX_CSTRING(":")) + pos->__Field(HX_CSTRING("methodName"),true)) + HX_CSTRING(":")) + pos->__Field(HX_CSTRING("lineNumber"),true)) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(315)
		::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),315,HX_CSTRING("hxd.System"),HX_CSTRING("trace2")));
	}
	HX_STACK_LINE(316)
	return msg;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(System_obj,trace2,return )

Dynamic System_obj::trace3( Dynamic msg,Dynamic pos){
	HX_STACK_FRAME("hxd.System","trace3",0xc7ad7af3,"hxd.System.trace3","hxd/System.hx",323,0xb8cb9154)
	HX_STACK_ARG(msg,"msg")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(325)
	if (((::hxd::System_obj::debugLevel >= (int)3))){
		HX_STACK_LINE(325)
		::String _g = ::Std_obj::string(msg);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(325)
		::String _g1 = ((((((pos->__Field(HX_CSTRING("fileName"),true) + HX_CSTRING(":")) + pos->__Field(HX_CSTRING("methodName"),true)) + HX_CSTRING(":")) + pos->__Field(HX_CSTRING("lineNumber"),true)) + HX_CSTRING(" ")) + _g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(325)
		::haxe::Log_obj::trace(_g1,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
	}
	HX_STACK_LINE(326)
	return msg;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(System_obj,trace3,return )

Void System_obj::trace4( ::String _){
{
		HX_STACK_FRAME("hxd.System","trace4",0xc7ad7af4,"hxd.System.trace4","hxd/System.hx",330,0xb8cb9154)
		HX_STACK_ARG(_,"_")
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(System_obj,trace4,(void))


System_obj::System_obj()
{
}

Dynamic System_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"lang") ) { return get_lang(); }
		if (HX_FIELD_EQ(inName,"VIEW") ) { return VIEW; }
		if (HX_FIELD_EQ(inName,"spin") ) { return spin; }
		if (HX_FIELD_EQ(inName,"exit") ) { return exit_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return get_width(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return get_height(); }
		if (HX_FIELD_EQ(inName,"trace1") ) { return trace1_dyn(); }
		if (HX_FIELD_EQ(inName,"trace2") ) { return trace2_dyn(); }
		if (HX_FIELD_EQ(inName,"trace3") ) { return trace3_dyn(); }
		if (HX_FIELD_EQ(inName,"trace4") ) { return trace4_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"isTouch") ) { return get_isTouch(); }
		if (HX_FIELD_EQ(inName,"setLoop") ) { return setLoop_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"get_lang") ) { return get_lang_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"isAndroid") ) { return get_isAndroid(); }
		if (HX_FIELD_EQ(inName,"screenDPI") ) { return get_screenDPI(); }
		if (HX_FIELD_EQ(inName,"setCursor") ) { return setCursor; }
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"isWindowed") ) { return get_isWindowed(); }
		if (HX_FIELD_EQ(inName,"debugLevel") ) { return debugLevel; }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"CACHED_NAME") ) { return CACHED_NAME; }
		if (HX_FIELD_EQ(inName,"get_isTouch") ) { return get_isTouch_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"get_screenDPI") ) { return get_screenDPI_dyn(); }
		if (HX_FIELD_EQ(inName,"get_isAndroid") ) { return get_isAndroid_dyn(); }
		if (HX_FIELD_EQ(inName,"getDeviceName") ) { return getDeviceName_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"get_isWindowed") ) { return get_isWindowed_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"ensureViewBelow") ) { return ensureViewBelow_dyn(); }
		if (HX_FIELD_EQ(inName,"setNativeCursor") ) { return setNativeCursor_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic System_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"VIEW") ) { VIEW=inValue.Cast< ::openfl::display::OpenGLView >(); return inValue; }
		if (HX_FIELD_EQ(inName,"spin") ) { spin=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"setCursor") ) { setCursor=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"debugLevel") ) { debugLevel=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"CACHED_NAME") ) { CACHED_NAME=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void System_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("debugLevel"),
	HX_CSTRING("ensureViewBelow"),
	HX_CSTRING("VIEW"),
	HX_CSTRING("spin"),
	HX_CSTRING("setLoop"),
	HX_CSTRING("setCursor"),
	HX_CSTRING("setNativeCursor"),
	HX_CSTRING("get_lang"),
	HX_CSTRING("get_screenDPI"),
	HX_CSTRING("get_isAndroid"),
	HX_CSTRING("CACHED_NAME"),
	HX_CSTRING("getDeviceName"),
	HX_CSTRING("exit"),
	HX_CSTRING("get_isWindowed"),
	HX_CSTRING("get_isTouch"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("trace1"),
	HX_CSTRING("trace2"),
	HX_CSTRING("trace3"),
	HX_CSTRING("trace4"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(System_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(System_obj::debugLevel,"debugLevel");
	HX_MARK_MEMBER_NAME(System_obj::VIEW,"VIEW");
	HX_MARK_MEMBER_NAME(System_obj::spin,"spin");
	HX_MARK_MEMBER_NAME(System_obj::setCursor,"setCursor");
	HX_MARK_MEMBER_NAME(System_obj::CACHED_NAME,"CACHED_NAME");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(System_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(System_obj::debugLevel,"debugLevel");
	HX_VISIT_MEMBER_NAME(System_obj::VIEW,"VIEW");
	HX_VISIT_MEMBER_NAME(System_obj::spin,"spin");
	HX_VISIT_MEMBER_NAME(System_obj::setCursor,"setCursor");
	HX_VISIT_MEMBER_NAME(System_obj::CACHED_NAME,"CACHED_NAME");
};

#endif

Class System_obj::__mClass;

void System_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.System"), hx::TCanCast< System_obj> ,sStaticFields,sMemberFields,
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

void System_obj::__boot()
{
	debugLevel= (int)1;
	VIEW= null();
	spin= (int)0;
	setCursor= ::hxd::System_obj::setNativeCursor_dyn();
	CACHED_NAME= null();
}

} // end namespace hxd
