#include <hxcpp.h>

#ifndef INCLUDED_flash_display_BlendMode
#include <flash/display/BlendMode.h>
#endif
namespace flash{
namespace display{

::flash::display::BlendMode BlendMode_obj::ADD;

::flash::display::BlendMode BlendMode_obj::ALPHA;

::flash::display::BlendMode BlendMode_obj::DARKEN;

::flash::display::BlendMode BlendMode_obj::DIFFERENCE;

::flash::display::BlendMode BlendMode_obj::ERASE;

::flash::display::BlendMode BlendMode_obj::HARDLIGHT;

::flash::display::BlendMode BlendMode_obj::INVERT;

::flash::display::BlendMode BlendMode_obj::LAYER;

::flash::display::BlendMode BlendMode_obj::LIGHTEN;

::flash::display::BlendMode BlendMode_obj::MULTIPLY;

::flash::display::BlendMode BlendMode_obj::NORMAL;

::flash::display::BlendMode BlendMode_obj::OVERLAY;

::flash::display::BlendMode BlendMode_obj::SCREEN;

::flash::display::BlendMode BlendMode_obj::SUBTRACT;

HX_DEFINE_CREATE_ENUM(BlendMode_obj)

int BlendMode_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("ADD")) return 7;
	if (inName==HX_CSTRING("ALPHA")) return 10;
	if (inName==HX_CSTRING("DARKEN")) return 5;
	if (inName==HX_CSTRING("DIFFERENCE")) return 6;
	if (inName==HX_CSTRING("ERASE")) return 11;
	if (inName==HX_CSTRING("HARDLIGHT")) return 13;
	if (inName==HX_CSTRING("INVERT")) return 9;
	if (inName==HX_CSTRING("LAYER")) return 1;
	if (inName==HX_CSTRING("LIGHTEN")) return 4;
	if (inName==HX_CSTRING("MULTIPLY")) return 2;
	if (inName==HX_CSTRING("NORMAL")) return 0;
	if (inName==HX_CSTRING("OVERLAY")) return 12;
	if (inName==HX_CSTRING("SCREEN")) return 3;
	if (inName==HX_CSTRING("SUBTRACT")) return 8;
	return super::__FindIndex(inName);
}

int BlendMode_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("ADD")) return 0;
	if (inName==HX_CSTRING("ALPHA")) return 0;
	if (inName==HX_CSTRING("DARKEN")) return 0;
	if (inName==HX_CSTRING("DIFFERENCE")) return 0;
	if (inName==HX_CSTRING("ERASE")) return 0;
	if (inName==HX_CSTRING("HARDLIGHT")) return 0;
	if (inName==HX_CSTRING("INVERT")) return 0;
	if (inName==HX_CSTRING("LAYER")) return 0;
	if (inName==HX_CSTRING("LIGHTEN")) return 0;
	if (inName==HX_CSTRING("MULTIPLY")) return 0;
	if (inName==HX_CSTRING("NORMAL")) return 0;
	if (inName==HX_CSTRING("OVERLAY")) return 0;
	if (inName==HX_CSTRING("SCREEN")) return 0;
	if (inName==HX_CSTRING("SUBTRACT")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic BlendMode_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("ADD")) return ADD;
	if (inName==HX_CSTRING("ALPHA")) return ALPHA;
	if (inName==HX_CSTRING("DARKEN")) return DARKEN;
	if (inName==HX_CSTRING("DIFFERENCE")) return DIFFERENCE;
	if (inName==HX_CSTRING("ERASE")) return ERASE;
	if (inName==HX_CSTRING("HARDLIGHT")) return HARDLIGHT;
	if (inName==HX_CSTRING("INVERT")) return INVERT;
	if (inName==HX_CSTRING("LAYER")) return LAYER;
	if (inName==HX_CSTRING("LIGHTEN")) return LIGHTEN;
	if (inName==HX_CSTRING("MULTIPLY")) return MULTIPLY;
	if (inName==HX_CSTRING("NORMAL")) return NORMAL;
	if (inName==HX_CSTRING("OVERLAY")) return OVERLAY;
	if (inName==HX_CSTRING("SCREEN")) return SCREEN;
	if (inName==HX_CSTRING("SUBTRACT")) return SUBTRACT;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("NORMAL"),
	HX_CSTRING("LAYER"),
	HX_CSTRING("MULTIPLY"),
	HX_CSTRING("SCREEN"),
	HX_CSTRING("LIGHTEN"),
	HX_CSTRING("DARKEN"),
	HX_CSTRING("DIFFERENCE"),
	HX_CSTRING("ADD"),
	HX_CSTRING("SUBTRACT"),
	HX_CSTRING("INVERT"),
	HX_CSTRING("ALPHA"),
	HX_CSTRING("ERASE"),
	HX_CSTRING("OVERLAY"),
	HX_CSTRING("HARDLIGHT"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BlendMode_obj::ADD,"ADD");
	HX_MARK_MEMBER_NAME(BlendMode_obj::ALPHA,"ALPHA");
	HX_MARK_MEMBER_NAME(BlendMode_obj::DARKEN,"DARKEN");
	HX_MARK_MEMBER_NAME(BlendMode_obj::DIFFERENCE,"DIFFERENCE");
	HX_MARK_MEMBER_NAME(BlendMode_obj::ERASE,"ERASE");
	HX_MARK_MEMBER_NAME(BlendMode_obj::HARDLIGHT,"HARDLIGHT");
	HX_MARK_MEMBER_NAME(BlendMode_obj::INVERT,"INVERT");
	HX_MARK_MEMBER_NAME(BlendMode_obj::LAYER,"LAYER");
	HX_MARK_MEMBER_NAME(BlendMode_obj::LIGHTEN,"LIGHTEN");
	HX_MARK_MEMBER_NAME(BlendMode_obj::MULTIPLY,"MULTIPLY");
	HX_MARK_MEMBER_NAME(BlendMode_obj::NORMAL,"NORMAL");
	HX_MARK_MEMBER_NAME(BlendMode_obj::OVERLAY,"OVERLAY");
	HX_MARK_MEMBER_NAME(BlendMode_obj::SCREEN,"SCREEN");
	HX_MARK_MEMBER_NAME(BlendMode_obj::SUBTRACT,"SUBTRACT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BlendMode_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::ADD,"ADD");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::ALPHA,"ALPHA");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::DARKEN,"DARKEN");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::DIFFERENCE,"DIFFERENCE");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::ERASE,"ERASE");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::HARDLIGHT,"HARDLIGHT");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::INVERT,"INVERT");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::LAYER,"LAYER");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::LIGHTEN,"LIGHTEN");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::MULTIPLY,"MULTIPLY");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::NORMAL,"NORMAL");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::OVERLAY,"OVERLAY");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::SCREEN,"SCREEN");
	HX_VISIT_MEMBER_NAME(BlendMode_obj::SUBTRACT,"SUBTRACT");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class BlendMode_obj::__mClass;

Dynamic __Create_BlendMode_obj() { return new BlendMode_obj; }

void BlendMode_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.BlendMode"), hx::TCanCast< BlendMode_obj >,sStaticFields,sMemberFields,
	&__Create_BlendMode_obj, &__Create,
	&super::__SGetClass(), &CreateBlendMode_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void BlendMode_obj::__boot()
{
hx::Static(ADD) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("ADD"),7);
hx::Static(ALPHA) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("ALPHA"),10);
hx::Static(DARKEN) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("DARKEN"),5);
hx::Static(DIFFERENCE) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("DIFFERENCE"),6);
hx::Static(ERASE) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("ERASE"),11);
hx::Static(HARDLIGHT) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("HARDLIGHT"),13);
hx::Static(INVERT) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("INVERT"),9);
hx::Static(LAYER) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("LAYER"),1);
hx::Static(LIGHTEN) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("LIGHTEN"),4);
hx::Static(MULTIPLY) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("MULTIPLY"),2);
hx::Static(NORMAL) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("NORMAL"),0);
hx::Static(OVERLAY) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("OVERLAY"),12);
hx::Static(SCREEN) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("SCREEN"),3);
hx::Static(SUBTRACT) = hx::CreateEnum< BlendMode_obj >(HX_CSTRING("SUBTRACT"),8);
}


} // end namespace flash
} // end namespace display
