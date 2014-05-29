#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_system_Capabilities
#include <flash/system/Capabilities.h>
#endif
#ifndef INCLUDED_flash_system_PixelFormat
#include <flash/system/PixelFormat.h>
#endif
#ifndef INCLUDED_flash_system_ScreenMode
#include <flash/system/ScreenMode.h>
#endif
namespace flash{
namespace system{

Void Capabilities_obj::__construct()
{
	return null();
}

//Capabilities_obj::~Capabilities_obj() { }

Dynamic Capabilities_obj::__CreateEmpty() { return  new Capabilities_obj; }
hx::ObjectPtr< Capabilities_obj > Capabilities_obj::__new()
{  hx::ObjectPtr< Capabilities_obj > result = new Capabilities_obj();
	result->__construct();
	return result;}

Dynamic Capabilities_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Capabilities_obj > result = new Capabilities_obj();
	result->__construct();
	return result;}

::String Capabilities_obj::language;

Float Capabilities_obj::pixelAspectRatio;

Float Capabilities_obj::screenDPI;

Array< ::Dynamic > Capabilities_obj::screenResolutions;

Float Capabilities_obj::screenResolutionX;

Float Capabilities_obj::screenResolutionY;

Array< ::Dynamic > Capabilities_obj::screenModes;

::String Capabilities_obj::get_language( ){
	HX_STACK_FRAME("flash.system.Capabilities","get_language",0x34f079b8,"flash.system.Capabilities.get_language","flash/system/Capabilities.hx",25,0x8140cf87)
	HX_STACK_LINE(27)
	::String locale = ::flash::system::Capabilities_obj::lime_capabilities_get_language();		HX_STACK_VAR(locale,"locale");
	HX_STACK_LINE(29)
	if (((bool((bool((bool((locale == null())) || bool((locale == HX_CSTRING(""))))) || bool((locale == HX_CSTRING("C"))))) || bool((locale == HX_CSTRING("POSIX")))))){
		HX_STACK_LINE(31)
		return HX_CSTRING("en-US");
	}
	else{
		HX_STACK_LINE(35)
		::String formattedLocale = HX_CSTRING("");		HX_STACK_VAR(formattedLocale,"formattedLocale");
		HX_STACK_LINE(36)
		int length = locale.length;		HX_STACK_VAR(length,"length");
		HX_STACK_LINE(38)
		if (((length > (int)5))){
			HX_STACK_LINE(40)
			length = (int)5;
		}
		HX_STACK_LINE(44)
		{
			HX_STACK_LINE(44)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(44)
			while((true)){
				HX_STACK_LINE(44)
				if ((!(((_g < length))))){
					HX_STACK_LINE(44)
					break;
				}
				HX_STACK_LINE(44)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(46)
				::String _char = locale.charAt(i);		HX_STACK_VAR(_char,"char");
				HX_STACK_LINE(48)
				if (((i < (int)2))){
					HX_STACK_LINE(50)
					::String _g1 = _char.toLowerCase();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(50)
					hx::AddEq(formattedLocale,_g1);
				}
				else{
					HX_STACK_LINE(52)
					if (((i == (int)2))){
						HX_STACK_LINE(54)
						hx::AddEq(formattedLocale,HX_CSTRING("-"));
					}
					else{
						HX_STACK_LINE(58)
						::String _g1 = _char.toUpperCase();		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(58)
						hx::AddEq(formattedLocale,_g1);
					}
				}
			}
		}
		HX_STACK_LINE(64)
		return formattedLocale;
	}
	HX_STACK_LINE(29)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Capabilities_obj,get_language,return )

Float Capabilities_obj::get_pixelAspectRatio( ){
	HX_STACK_FRAME("flash.system.Capabilities","get_pixelAspectRatio",0x57b72c8d,"flash.system.Capabilities.get_pixelAspectRatio","flash/system/Capabilities.hx",71,0x8140cf87)
	HX_STACK_LINE(71)
	return ::flash::system::Capabilities_obj::lime_capabilities_get_pixel_aspect_ratio();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Capabilities_obj,get_pixelAspectRatio,return )

Float Capabilities_obj::get_screenDPI( ){
	HX_STACK_FRAME("flash.system.Capabilities","get_screenDPI",0x002bc9f1,"flash.system.Capabilities.get_screenDPI","flash/system/Capabilities.hx",72,0x8140cf87)
	HX_STACK_LINE(72)
	return ::flash::system::Capabilities_obj::lime_capabilities_get_screen_dpi();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Capabilities_obj,get_screenDPI,return )

Array< ::Dynamic > Capabilities_obj::get_screenResolutions( ){
	HX_STACK_FRAME("flash.system.Capabilities","get_screenResolutions",0x61a7a85b,"flash.system.Capabilities.get_screenResolutions","flash/system/Capabilities.hx",75,0x8140cf87)
	HX_STACK_LINE(77)
	Array< int > res = ::flash::system::Capabilities_obj::lime_capabilities_get_screen_resolutions();		HX_STACK_VAR(res,"res");
	HX_STACK_LINE(79)
	if (((res == null()))){
		HX_STACK_LINE(81)
		return Array_obj< ::Dynamic >::__new();
	}
	HX_STACK_LINE(85)
	Array< ::Dynamic > out = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(out,"out");
	HX_STACK_LINE(87)
	{
		HX_STACK_LINE(87)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(87)
		int _g = ::Std_obj::_int((Float(res->length) / Float((int)2)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(87)
		while((true)){
			HX_STACK_LINE(87)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(87)
				break;
			}
			HX_STACK_LINE(87)
			int c = (_g1)++;		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(89)
			out->push(Array_obj< int >::__new().Add(res->__get((c * (int)2))).Add(res->__get(((c * (int)2) + (int)1))));
		}
	}
	HX_STACK_LINE(93)
	return out;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Capabilities_obj,get_screenResolutions,return )

Float Capabilities_obj::get_screenResolutionX( ){
	HX_STACK_FRAME("flash.system.Capabilities","get_screenResolutionX",0x61a7a840,"flash.system.Capabilities.get_screenResolutionX","flash/system/Capabilities.hx",98,0x8140cf87)
	HX_STACK_LINE(98)
	return ::flash::system::Capabilities_obj::lime_capabilities_get_screen_resolution_x();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Capabilities_obj,get_screenResolutionX,return )

Float Capabilities_obj::get_screenResolutionY( ){
	HX_STACK_FRAME("flash.system.Capabilities","get_screenResolutionY",0x61a7a841,"flash.system.Capabilities.get_screenResolutionY","flash/system/Capabilities.hx",99,0x8140cf87)
	HX_STACK_LINE(99)
	return ::flash::system::Capabilities_obj::lime_capabilities_get_screen_resolution_y();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Capabilities_obj,get_screenResolutionY,return )

Array< ::Dynamic > Capabilities_obj::get_screenModes( ){
	HX_STACK_FRAME("flash.system.Capabilities","get_screenModes",0x7d549344,"flash.system.Capabilities.get_screenModes","flash/system/Capabilities.hx",101,0x8140cf87)
	HX_STACK_LINE(102)
	Array< int > modes = ::flash::system::Capabilities_obj::lime_capabilities_get_screen_modes();		HX_STACK_VAR(modes,"modes");
	HX_STACK_LINE(103)
	Array< ::Dynamic > out = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(out,"out");
	HX_STACK_LINE(105)
	if (((modes == null()))){
		HX_STACK_LINE(106)
		return out;
	}
	HX_STACK_LINE(109)
	{
		HX_STACK_LINE(109)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(109)
		int _g = ::Std_obj::_int((Float(modes->length) / Float((int)4)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(109)
		while((true)){
			HX_STACK_LINE(109)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(109)
				break;
			}
			HX_STACK_LINE(109)
			int c = (_g1)++;		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(110)
			::flash::system::ScreenMode mode = ::flash::system::ScreenMode_obj::__new();		HX_STACK_VAR(mode,"mode");
			HX_STACK_LINE(111)
			mode->width = modes->__get((c * (int)4));
			HX_STACK_LINE(112)
			mode->height = modes->__get(((c * (int)4) + (int)1));
			HX_STACK_LINE(113)
			mode->refreshRate = modes->__get(((c * (int)4) + (int)2));
			HX_STACK_LINE(114)
			::flash::system::PixelFormat _g2 = ::Type_obj::createEnumIndex(hx::ClassOf< ::flash::system::PixelFormat >(),modes->__get(((c * (int)4) + (int)3)),null());		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(114)
			mode->format = _g2;
			HX_STACK_LINE(115)
			out->push(mode);
		}
	}
	HX_STACK_LINE(118)
	return out;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Capabilities_obj,get_screenModes,return )

Dynamic Capabilities_obj::lime_capabilities_get_pixel_aspect_ratio;

Dynamic Capabilities_obj::lime_capabilities_get_screen_dpi;

Dynamic Capabilities_obj::lime_capabilities_get_screen_resolution_x;

Dynamic Capabilities_obj::lime_capabilities_get_screen_resolution_y;

Dynamic Capabilities_obj::lime_capabilities_get_screen_resolutions;

Dynamic Capabilities_obj::lime_capabilities_get_screen_modes;

Dynamic Capabilities_obj::lime_capabilities_get_language;


Capabilities_obj::Capabilities_obj()
{
}

Dynamic Capabilities_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"language") ) { return inCallProp ? get_language() : language; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"screenDPI") ) { return inCallProp ? get_screenDPI() : screenDPI; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"screenModes") ) { return inCallProp ? get_screenModes() : screenModes; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"get_language") ) { return get_language_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"get_screenDPI") ) { return get_screenDPI_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_screenModes") ) { return get_screenModes_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"pixelAspectRatio") ) { return inCallProp ? get_pixelAspectRatio() : pixelAspectRatio; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"screenResolutions") ) { return inCallProp ? get_screenResolutions() : screenResolutions; }
		if (HX_FIELD_EQ(inName,"screenResolutionX") ) { return inCallProp ? get_screenResolutionX() : screenResolutionX; }
		if (HX_FIELD_EQ(inName,"screenResolutionY") ) { return inCallProp ? get_screenResolutionY() : screenResolutionY; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"get_pixelAspectRatio") ) { return get_pixelAspectRatio_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"get_screenResolutions") ) { return get_screenResolutions_dyn(); }
		if (HX_FIELD_EQ(inName,"get_screenResolutionX") ) { return get_screenResolutionX_dyn(); }
		if (HX_FIELD_EQ(inName,"get_screenResolutionY") ) { return get_screenResolutionY_dyn(); }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_language") ) { return lime_capabilities_get_language; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_dpi") ) { return lime_capabilities_get_screen_dpi; }
		break;
	case 34:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_modes") ) { return lime_capabilities_get_screen_modes; }
		break;
	case 40:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_pixel_aspect_ratio") ) { return lime_capabilities_get_pixel_aspect_ratio; }
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_resolutions") ) { return lime_capabilities_get_screen_resolutions; }
		break;
	case 41:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_resolution_x") ) { return lime_capabilities_get_screen_resolution_x; }
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_resolution_y") ) { return lime_capabilities_get_screen_resolution_y; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Capabilities_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"language") ) { language=inValue.Cast< ::String >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"screenDPI") ) { screenDPI=inValue.Cast< Float >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"screenModes") ) { screenModes=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"pixelAspectRatio") ) { pixelAspectRatio=inValue.Cast< Float >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"screenResolutions") ) { screenResolutions=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"screenResolutionX") ) { screenResolutionX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"screenResolutionY") ) { screenResolutionY=inValue.Cast< Float >(); return inValue; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_language") ) { lime_capabilities_get_language=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_dpi") ) { lime_capabilities_get_screen_dpi=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 34:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_modes") ) { lime_capabilities_get_screen_modes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 40:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_pixel_aspect_ratio") ) { lime_capabilities_get_pixel_aspect_ratio=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_resolutions") ) { lime_capabilities_get_screen_resolutions=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 41:
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_resolution_x") ) { lime_capabilities_get_screen_resolution_x=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_capabilities_get_screen_resolution_y") ) { lime_capabilities_get_screen_resolution_y=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Capabilities_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("language"),
	HX_CSTRING("pixelAspectRatio"),
	HX_CSTRING("screenDPI"),
	HX_CSTRING("screenResolutions"),
	HX_CSTRING("screenResolutionX"),
	HX_CSTRING("screenResolutionY"),
	HX_CSTRING("screenModes"),
	HX_CSTRING("get_language"),
	HX_CSTRING("get_pixelAspectRatio"),
	HX_CSTRING("get_screenDPI"),
	HX_CSTRING("get_screenResolutions"),
	HX_CSTRING("get_screenResolutionX"),
	HX_CSTRING("get_screenResolutionY"),
	HX_CSTRING("get_screenModes"),
	HX_CSTRING("lime_capabilities_get_pixel_aspect_ratio"),
	HX_CSTRING("lime_capabilities_get_screen_dpi"),
	HX_CSTRING("lime_capabilities_get_screen_resolution_x"),
	HX_CSTRING("lime_capabilities_get_screen_resolution_y"),
	HX_CSTRING("lime_capabilities_get_screen_resolutions"),
	HX_CSTRING("lime_capabilities_get_screen_modes"),
	HX_CSTRING("lime_capabilities_get_language"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Capabilities_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Capabilities_obj::language,"language");
	HX_MARK_MEMBER_NAME(Capabilities_obj::pixelAspectRatio,"pixelAspectRatio");
	HX_MARK_MEMBER_NAME(Capabilities_obj::screenDPI,"screenDPI");
	HX_MARK_MEMBER_NAME(Capabilities_obj::screenResolutions,"screenResolutions");
	HX_MARK_MEMBER_NAME(Capabilities_obj::screenResolutionX,"screenResolutionX");
	HX_MARK_MEMBER_NAME(Capabilities_obj::screenResolutionY,"screenResolutionY");
	HX_MARK_MEMBER_NAME(Capabilities_obj::screenModes,"screenModes");
	HX_MARK_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_pixel_aspect_ratio,"lime_capabilities_get_pixel_aspect_ratio");
	HX_MARK_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_dpi,"lime_capabilities_get_screen_dpi");
	HX_MARK_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_resolution_x,"lime_capabilities_get_screen_resolution_x");
	HX_MARK_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_resolution_y,"lime_capabilities_get_screen_resolution_y");
	HX_MARK_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_resolutions,"lime_capabilities_get_screen_resolutions");
	HX_MARK_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_modes,"lime_capabilities_get_screen_modes");
	HX_MARK_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_language,"lime_capabilities_get_language");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Capabilities_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::language,"language");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::pixelAspectRatio,"pixelAspectRatio");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::screenDPI,"screenDPI");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::screenResolutions,"screenResolutions");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::screenResolutionX,"screenResolutionX");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::screenResolutionY,"screenResolutionY");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::screenModes,"screenModes");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_pixel_aspect_ratio,"lime_capabilities_get_pixel_aspect_ratio");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_dpi,"lime_capabilities_get_screen_dpi");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_resolution_x,"lime_capabilities_get_screen_resolution_x");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_resolution_y,"lime_capabilities_get_screen_resolution_y");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_resolutions,"lime_capabilities_get_screen_resolutions");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_screen_modes,"lime_capabilities_get_screen_modes");
	HX_VISIT_MEMBER_NAME(Capabilities_obj::lime_capabilities_get_language,"lime_capabilities_get_language");
};

#endif

Class Capabilities_obj::__mClass;

void Capabilities_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.system.Capabilities"), hx::TCanCast< Capabilities_obj> ,sStaticFields,sMemberFields,
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

void Capabilities_obj::__boot()
{
	lime_capabilities_get_pixel_aspect_ratio= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_capabilities_get_pixel_aspect_ratio"),(int)0);
	lime_capabilities_get_screen_dpi= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_capabilities_get_screen_dpi"),(int)0);
	lime_capabilities_get_screen_resolution_x= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_capabilities_get_screen_resolution_x"),(int)0);
	lime_capabilities_get_screen_resolution_y= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_capabilities_get_screen_resolution_y"),(int)0);
	lime_capabilities_get_screen_resolutions= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_capabilities_get_screen_resolutions"),(int)0);
	lime_capabilities_get_screen_modes= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_capabilities_get_screen_modes"),(int)0);
	lime_capabilities_get_language= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_capabilities_get_language"),(int)0);
}

} // end namespace flash
} // end namespace system
