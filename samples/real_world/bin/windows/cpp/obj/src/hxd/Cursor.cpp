#include <hxcpp.h>

#ifndef INCLUDED_hxd_Cursor
#include <hxd/Cursor.h>
#endif
namespace hxd{

::hxd::Cursor Cursor_obj::Button;

::hxd::Cursor Cursor_obj::Default;

::hxd::Cursor Cursor_obj::Hide;

::hxd::Cursor Cursor_obj::Move;

::hxd::Cursor Cursor_obj::TextInput;

HX_DEFINE_CREATE_ENUM(Cursor_obj)

int Cursor_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("Button")) return 1;
	if (inName==HX_CSTRING("Default")) return 0;
	if (inName==HX_CSTRING("Hide")) return 4;
	if (inName==HX_CSTRING("Move")) return 2;
	if (inName==HX_CSTRING("TextInput")) return 3;
	return super::__FindIndex(inName);
}

int Cursor_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("Button")) return 0;
	if (inName==HX_CSTRING("Default")) return 0;
	if (inName==HX_CSTRING("Hide")) return 0;
	if (inName==HX_CSTRING("Move")) return 0;
	if (inName==HX_CSTRING("TextInput")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic Cursor_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("Button")) return Button;
	if (inName==HX_CSTRING("Default")) return Default;
	if (inName==HX_CSTRING("Hide")) return Hide;
	if (inName==HX_CSTRING("Move")) return Move;
	if (inName==HX_CSTRING("TextInput")) return TextInput;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("Default"),
	HX_CSTRING("Button"),
	HX_CSTRING("Move"),
	HX_CSTRING("TextInput"),
	HX_CSTRING("Hide"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Cursor_obj::Button,"Button");
	HX_MARK_MEMBER_NAME(Cursor_obj::Default,"Default");
	HX_MARK_MEMBER_NAME(Cursor_obj::Hide,"Hide");
	HX_MARK_MEMBER_NAME(Cursor_obj::Move,"Move");
	HX_MARK_MEMBER_NAME(Cursor_obj::TextInput,"TextInput");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Cursor_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Cursor_obj::Button,"Button");
	HX_VISIT_MEMBER_NAME(Cursor_obj::Default,"Default");
	HX_VISIT_MEMBER_NAME(Cursor_obj::Hide,"Hide");
	HX_VISIT_MEMBER_NAME(Cursor_obj::Move,"Move");
	HX_VISIT_MEMBER_NAME(Cursor_obj::TextInput,"TextInput");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class Cursor_obj::__mClass;

Dynamic __Create_Cursor_obj() { return new Cursor_obj; }

void Cursor_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Cursor"), hx::TCanCast< Cursor_obj >,sStaticFields,sMemberFields,
	&__Create_Cursor_obj, &__Create,
	&super::__SGetClass(), &CreateCursor_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void Cursor_obj::__boot()
{
hx::Static(Button) = hx::CreateEnum< Cursor_obj >(HX_CSTRING("Button"),1);
hx::Static(Default) = hx::CreateEnum< Cursor_obj >(HX_CSTRING("Default"),0);
hx::Static(Hide) = hx::CreateEnum< Cursor_obj >(HX_CSTRING("Hide"),4);
hx::Static(Move) = hx::CreateEnum< Cursor_obj >(HX_CSTRING("Move"),2);
hx::Static(TextInput) = hx::CreateEnum< Cursor_obj >(HX_CSTRING("TextInput"),3);
}


} // end namespace hxd
