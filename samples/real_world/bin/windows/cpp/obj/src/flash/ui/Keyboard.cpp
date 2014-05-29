#include <hxcpp.h>

#ifndef INCLUDED_flash_ui_Keyboard
#include <flash/ui/Keyboard.h>
#endif
namespace flash{
namespace ui{

Void Keyboard_obj::__construct()
{
	return null();
}

//Keyboard_obj::~Keyboard_obj() { }

Dynamic Keyboard_obj::__CreateEmpty() { return  new Keyboard_obj; }
hx::ObjectPtr< Keyboard_obj > Keyboard_obj::__new()
{  hx::ObjectPtr< Keyboard_obj > result = new Keyboard_obj();
	result->__construct();
	return result;}

Dynamic Keyboard_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Keyboard_obj > result = new Keyboard_obj();
	result->__construct();
	return result;}

int Keyboard_obj::A;

int Keyboard_obj::B;

int Keyboard_obj::C;

int Keyboard_obj::D;

int Keyboard_obj::E;

int Keyboard_obj::F;

int Keyboard_obj::G;

int Keyboard_obj::H;

int Keyboard_obj::I;

int Keyboard_obj::J;

int Keyboard_obj::K;

int Keyboard_obj::L;

int Keyboard_obj::M;

int Keyboard_obj::N;

int Keyboard_obj::O;

int Keyboard_obj::P;

int Keyboard_obj::Q;

int Keyboard_obj::R;

int Keyboard_obj::S;

int Keyboard_obj::T;

int Keyboard_obj::U;

int Keyboard_obj::V;

int Keyboard_obj::W;

int Keyboard_obj::X;

int Keyboard_obj::Y;

int Keyboard_obj::Z;

int Keyboard_obj::ALTERNATE;

int Keyboard_obj::BACKQUOTE;

int Keyboard_obj::BACKSLASH;

int Keyboard_obj::BACKSPACE;

int Keyboard_obj::CAPS_LOCK;

int Keyboard_obj::COMMA;

int Keyboard_obj::COMMAND;

int Keyboard_obj::CONTROL;

int Keyboard_obj::DELETE;

int Keyboard_obj::DOWN;

int Keyboard_obj::END;

int Keyboard_obj::ENTER;

int Keyboard_obj::EQUAL;

int Keyboard_obj::ESCAPE;

int Keyboard_obj::F1;

int Keyboard_obj::F2;

int Keyboard_obj::F3;

int Keyboard_obj::F4;

int Keyboard_obj::F5;

int Keyboard_obj::F6;

int Keyboard_obj::F7;

int Keyboard_obj::F8;

int Keyboard_obj::F9;

int Keyboard_obj::F10;

int Keyboard_obj::F11;

int Keyboard_obj::F12;

int Keyboard_obj::F13;

int Keyboard_obj::F14;

int Keyboard_obj::F15;

int Keyboard_obj::HOME;

int Keyboard_obj::INSERT;

int Keyboard_obj::LEFT;

int Keyboard_obj::LEFTBRACKET;

int Keyboard_obj::MINUS;

int Keyboard_obj::NUMBER_0;

int Keyboard_obj::NUMBER_1;

int Keyboard_obj::NUMBER_2;

int Keyboard_obj::NUMBER_3;

int Keyboard_obj::NUMBER_4;

int Keyboard_obj::NUMBER_5;

int Keyboard_obj::NUMBER_6;

int Keyboard_obj::NUMBER_7;

int Keyboard_obj::NUMBER_8;

int Keyboard_obj::NUMBER_9;

int Keyboard_obj::NUMPAD;

int Keyboard_obj::NUMPAD_0;

int Keyboard_obj::NUMPAD_1;

int Keyboard_obj::NUMPAD_2;

int Keyboard_obj::NUMPAD_3;

int Keyboard_obj::NUMPAD_4;

int Keyboard_obj::NUMPAD_5;

int Keyboard_obj::NUMPAD_6;

int Keyboard_obj::NUMPAD_7;

int Keyboard_obj::NUMPAD_8;

int Keyboard_obj::NUMPAD_9;

int Keyboard_obj::NUMPAD_ADD;

int Keyboard_obj::NUMPAD_DECIMAL;

int Keyboard_obj::NUMPAD_DIVIDE;

int Keyboard_obj::NUMPAD_ENTER;

int Keyboard_obj::NUMPAD_MULTIPLY;

int Keyboard_obj::NUMPAD_SUBTRACT;

int Keyboard_obj::PAGE_DOWN;

int Keyboard_obj::PAGE_UP;

int Keyboard_obj::PERIOD;

int Keyboard_obj::QUOTE;

int Keyboard_obj::RIGHT;

int Keyboard_obj::RIGHTBRACKET;

int Keyboard_obj::SEMICOLON;

int Keyboard_obj::SHIFT;

int Keyboard_obj::SLASH;

int Keyboard_obj::SPACE;

int Keyboard_obj::TAB;

int Keyboard_obj::UP;


Keyboard_obj::Keyboard_obj()
{
}

Dynamic Keyboard_obj::__Field(const ::String &inName,bool inCallProp)
{
	return super::__Field(inName,inCallProp);
}

Dynamic Keyboard_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Keyboard_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("A"),
	HX_CSTRING("B"),
	HX_CSTRING("C"),
	HX_CSTRING("D"),
	HX_CSTRING("E"),
	HX_CSTRING("F"),
	HX_CSTRING("G"),
	HX_CSTRING("H"),
	HX_CSTRING("I"),
	HX_CSTRING("J"),
	HX_CSTRING("K"),
	HX_CSTRING("L"),
	HX_CSTRING("M"),
	HX_CSTRING("N"),
	HX_CSTRING("O"),
	HX_CSTRING("P"),
	HX_CSTRING("Q"),
	HX_CSTRING("R"),
	HX_CSTRING("S"),
	HX_CSTRING("T"),
	HX_CSTRING("U"),
	HX_CSTRING("V"),
	HX_CSTRING("W"),
	HX_CSTRING("X"),
	HX_CSTRING("Y"),
	HX_CSTRING("Z"),
	HX_CSTRING("ALTERNATE"),
	HX_CSTRING("BACKQUOTE"),
	HX_CSTRING("BACKSLASH"),
	HX_CSTRING("BACKSPACE"),
	HX_CSTRING("CAPS_LOCK"),
	HX_CSTRING("COMMA"),
	HX_CSTRING("COMMAND"),
	HX_CSTRING("CONTROL"),
	HX_CSTRING("DELETE"),
	HX_CSTRING("DOWN"),
	HX_CSTRING("END"),
	HX_CSTRING("ENTER"),
	HX_CSTRING("EQUAL"),
	HX_CSTRING("ESCAPE"),
	HX_CSTRING("F1"),
	HX_CSTRING("F2"),
	HX_CSTRING("F3"),
	HX_CSTRING("F4"),
	HX_CSTRING("F5"),
	HX_CSTRING("F6"),
	HX_CSTRING("F7"),
	HX_CSTRING("F8"),
	HX_CSTRING("F9"),
	HX_CSTRING("F10"),
	HX_CSTRING("F11"),
	HX_CSTRING("F12"),
	HX_CSTRING("F13"),
	HX_CSTRING("F14"),
	HX_CSTRING("F15"),
	HX_CSTRING("HOME"),
	HX_CSTRING("INSERT"),
	HX_CSTRING("LEFT"),
	HX_CSTRING("LEFTBRACKET"),
	HX_CSTRING("MINUS"),
	HX_CSTRING("NUMBER_0"),
	HX_CSTRING("NUMBER_1"),
	HX_CSTRING("NUMBER_2"),
	HX_CSTRING("NUMBER_3"),
	HX_CSTRING("NUMBER_4"),
	HX_CSTRING("NUMBER_5"),
	HX_CSTRING("NUMBER_6"),
	HX_CSTRING("NUMBER_7"),
	HX_CSTRING("NUMBER_8"),
	HX_CSTRING("NUMBER_9"),
	HX_CSTRING("NUMPAD"),
	HX_CSTRING("NUMPAD_0"),
	HX_CSTRING("NUMPAD_1"),
	HX_CSTRING("NUMPAD_2"),
	HX_CSTRING("NUMPAD_3"),
	HX_CSTRING("NUMPAD_4"),
	HX_CSTRING("NUMPAD_5"),
	HX_CSTRING("NUMPAD_6"),
	HX_CSTRING("NUMPAD_7"),
	HX_CSTRING("NUMPAD_8"),
	HX_CSTRING("NUMPAD_9"),
	HX_CSTRING("NUMPAD_ADD"),
	HX_CSTRING("NUMPAD_DECIMAL"),
	HX_CSTRING("NUMPAD_DIVIDE"),
	HX_CSTRING("NUMPAD_ENTER"),
	HX_CSTRING("NUMPAD_MULTIPLY"),
	HX_CSTRING("NUMPAD_SUBTRACT"),
	HX_CSTRING("PAGE_DOWN"),
	HX_CSTRING("PAGE_UP"),
	HX_CSTRING("PERIOD"),
	HX_CSTRING("QUOTE"),
	HX_CSTRING("RIGHT"),
	HX_CSTRING("RIGHTBRACKET"),
	HX_CSTRING("SEMICOLON"),
	HX_CSTRING("SHIFT"),
	HX_CSTRING("SLASH"),
	HX_CSTRING("SPACE"),
	HX_CSTRING("TAB"),
	HX_CSTRING("UP"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Keyboard_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Keyboard_obj::A,"A");
	HX_MARK_MEMBER_NAME(Keyboard_obj::B,"B");
	HX_MARK_MEMBER_NAME(Keyboard_obj::C,"C");
	HX_MARK_MEMBER_NAME(Keyboard_obj::D,"D");
	HX_MARK_MEMBER_NAME(Keyboard_obj::E,"E");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F,"F");
	HX_MARK_MEMBER_NAME(Keyboard_obj::G,"G");
	HX_MARK_MEMBER_NAME(Keyboard_obj::H,"H");
	HX_MARK_MEMBER_NAME(Keyboard_obj::I,"I");
	HX_MARK_MEMBER_NAME(Keyboard_obj::J,"J");
	HX_MARK_MEMBER_NAME(Keyboard_obj::K,"K");
	HX_MARK_MEMBER_NAME(Keyboard_obj::L,"L");
	HX_MARK_MEMBER_NAME(Keyboard_obj::M,"M");
	HX_MARK_MEMBER_NAME(Keyboard_obj::N,"N");
	HX_MARK_MEMBER_NAME(Keyboard_obj::O,"O");
	HX_MARK_MEMBER_NAME(Keyboard_obj::P,"P");
	HX_MARK_MEMBER_NAME(Keyboard_obj::Q,"Q");
	HX_MARK_MEMBER_NAME(Keyboard_obj::R,"R");
	HX_MARK_MEMBER_NAME(Keyboard_obj::S,"S");
	HX_MARK_MEMBER_NAME(Keyboard_obj::T,"T");
	HX_MARK_MEMBER_NAME(Keyboard_obj::U,"U");
	HX_MARK_MEMBER_NAME(Keyboard_obj::V,"V");
	HX_MARK_MEMBER_NAME(Keyboard_obj::W,"W");
	HX_MARK_MEMBER_NAME(Keyboard_obj::X,"X");
	HX_MARK_MEMBER_NAME(Keyboard_obj::Y,"Y");
	HX_MARK_MEMBER_NAME(Keyboard_obj::Z,"Z");
	HX_MARK_MEMBER_NAME(Keyboard_obj::ALTERNATE,"ALTERNATE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::BACKQUOTE,"BACKQUOTE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::BACKSLASH,"BACKSLASH");
	HX_MARK_MEMBER_NAME(Keyboard_obj::BACKSPACE,"BACKSPACE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::CAPS_LOCK,"CAPS_LOCK");
	HX_MARK_MEMBER_NAME(Keyboard_obj::COMMA,"COMMA");
	HX_MARK_MEMBER_NAME(Keyboard_obj::COMMAND,"COMMAND");
	HX_MARK_MEMBER_NAME(Keyboard_obj::CONTROL,"CONTROL");
	HX_MARK_MEMBER_NAME(Keyboard_obj::DELETE,"DELETE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::DOWN,"DOWN");
	HX_MARK_MEMBER_NAME(Keyboard_obj::END,"END");
	HX_MARK_MEMBER_NAME(Keyboard_obj::ENTER,"ENTER");
	HX_MARK_MEMBER_NAME(Keyboard_obj::EQUAL,"EQUAL");
	HX_MARK_MEMBER_NAME(Keyboard_obj::ESCAPE,"ESCAPE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F1,"F1");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F2,"F2");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F3,"F3");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F4,"F4");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F5,"F5");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F6,"F6");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F7,"F7");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F8,"F8");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F9,"F9");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F10,"F10");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F11,"F11");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F12,"F12");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F13,"F13");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F14,"F14");
	HX_MARK_MEMBER_NAME(Keyboard_obj::F15,"F15");
	HX_MARK_MEMBER_NAME(Keyboard_obj::HOME,"HOME");
	HX_MARK_MEMBER_NAME(Keyboard_obj::INSERT,"INSERT");
	HX_MARK_MEMBER_NAME(Keyboard_obj::LEFT,"LEFT");
	HX_MARK_MEMBER_NAME(Keyboard_obj::LEFTBRACKET,"LEFTBRACKET");
	HX_MARK_MEMBER_NAME(Keyboard_obj::MINUS,"MINUS");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_0,"NUMBER_0");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_1,"NUMBER_1");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_2,"NUMBER_2");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_3,"NUMBER_3");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_4,"NUMBER_4");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_5,"NUMBER_5");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_6,"NUMBER_6");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_7,"NUMBER_7");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_8,"NUMBER_8");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMBER_9,"NUMBER_9");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD,"NUMPAD");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_0,"NUMPAD_0");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_1,"NUMPAD_1");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_2,"NUMPAD_2");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_3,"NUMPAD_3");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_4,"NUMPAD_4");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_5,"NUMPAD_5");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_6,"NUMPAD_6");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_7,"NUMPAD_7");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_8,"NUMPAD_8");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_9,"NUMPAD_9");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_ADD,"NUMPAD_ADD");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_DECIMAL,"NUMPAD_DECIMAL");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_DIVIDE,"NUMPAD_DIVIDE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_ENTER,"NUMPAD_ENTER");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_MULTIPLY,"NUMPAD_MULTIPLY");
	HX_MARK_MEMBER_NAME(Keyboard_obj::NUMPAD_SUBTRACT,"NUMPAD_SUBTRACT");
	HX_MARK_MEMBER_NAME(Keyboard_obj::PAGE_DOWN,"PAGE_DOWN");
	HX_MARK_MEMBER_NAME(Keyboard_obj::PAGE_UP,"PAGE_UP");
	HX_MARK_MEMBER_NAME(Keyboard_obj::PERIOD,"PERIOD");
	HX_MARK_MEMBER_NAME(Keyboard_obj::QUOTE,"QUOTE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::RIGHT,"RIGHT");
	HX_MARK_MEMBER_NAME(Keyboard_obj::RIGHTBRACKET,"RIGHTBRACKET");
	HX_MARK_MEMBER_NAME(Keyboard_obj::SEMICOLON,"SEMICOLON");
	HX_MARK_MEMBER_NAME(Keyboard_obj::SHIFT,"SHIFT");
	HX_MARK_MEMBER_NAME(Keyboard_obj::SLASH,"SLASH");
	HX_MARK_MEMBER_NAME(Keyboard_obj::SPACE,"SPACE");
	HX_MARK_MEMBER_NAME(Keyboard_obj::TAB,"TAB");
	HX_MARK_MEMBER_NAME(Keyboard_obj::UP,"UP");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Keyboard_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::A,"A");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::B,"B");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::C,"C");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::D,"D");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::E,"E");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F,"F");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::G,"G");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::H,"H");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::I,"I");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::J,"J");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::K,"K");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::L,"L");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::M,"M");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::N,"N");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::O,"O");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::P,"P");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::Q,"Q");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::R,"R");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::S,"S");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::T,"T");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::U,"U");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::V,"V");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::W,"W");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::X,"X");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::Y,"Y");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::Z,"Z");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::ALTERNATE,"ALTERNATE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::BACKQUOTE,"BACKQUOTE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::BACKSLASH,"BACKSLASH");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::BACKSPACE,"BACKSPACE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::CAPS_LOCK,"CAPS_LOCK");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::COMMA,"COMMA");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::COMMAND,"COMMAND");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::CONTROL,"CONTROL");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::DELETE,"DELETE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::DOWN,"DOWN");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::END,"END");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::ENTER,"ENTER");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::EQUAL,"EQUAL");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::ESCAPE,"ESCAPE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F1,"F1");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F2,"F2");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F3,"F3");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F4,"F4");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F5,"F5");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F6,"F6");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F7,"F7");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F8,"F8");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F9,"F9");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F10,"F10");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F11,"F11");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F12,"F12");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F13,"F13");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F14,"F14");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::F15,"F15");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::HOME,"HOME");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::INSERT,"INSERT");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::LEFT,"LEFT");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::LEFTBRACKET,"LEFTBRACKET");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::MINUS,"MINUS");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_0,"NUMBER_0");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_1,"NUMBER_1");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_2,"NUMBER_2");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_3,"NUMBER_3");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_4,"NUMBER_4");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_5,"NUMBER_5");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_6,"NUMBER_6");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_7,"NUMBER_7");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_8,"NUMBER_8");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMBER_9,"NUMBER_9");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD,"NUMPAD");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_0,"NUMPAD_0");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_1,"NUMPAD_1");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_2,"NUMPAD_2");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_3,"NUMPAD_3");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_4,"NUMPAD_4");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_5,"NUMPAD_5");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_6,"NUMPAD_6");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_7,"NUMPAD_7");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_8,"NUMPAD_8");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_9,"NUMPAD_9");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_ADD,"NUMPAD_ADD");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_DECIMAL,"NUMPAD_DECIMAL");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_DIVIDE,"NUMPAD_DIVIDE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_ENTER,"NUMPAD_ENTER");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_MULTIPLY,"NUMPAD_MULTIPLY");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::NUMPAD_SUBTRACT,"NUMPAD_SUBTRACT");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::PAGE_DOWN,"PAGE_DOWN");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::PAGE_UP,"PAGE_UP");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::PERIOD,"PERIOD");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::QUOTE,"QUOTE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::RIGHT,"RIGHT");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::RIGHTBRACKET,"RIGHTBRACKET");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::SEMICOLON,"SEMICOLON");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::SHIFT,"SHIFT");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::SLASH,"SLASH");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::SPACE,"SPACE");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::TAB,"TAB");
	HX_VISIT_MEMBER_NAME(Keyboard_obj::UP,"UP");
};

#endif

Class Keyboard_obj::__mClass;

void Keyboard_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.ui.Keyboard"), hx::TCanCast< Keyboard_obj> ,sStaticFields,sMemberFields,
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

void Keyboard_obj::__boot()
{
	A= (int)65;
	B= (int)66;
	C= (int)67;
	D= (int)68;
	E= (int)69;
	F= (int)70;
	G= (int)71;
	H= (int)72;
	I= (int)73;
	J= (int)74;
	K= (int)75;
	L= (int)76;
	M= (int)77;
	N= (int)78;
	O= (int)79;
	P= (int)80;
	Q= (int)81;
	R= (int)82;
	S= (int)83;
	T= (int)84;
	U= (int)85;
	V= (int)86;
	W= (int)87;
	X= (int)88;
	Y= (int)89;
	Z= (int)90;
	ALTERNATE= (int)18;
	BACKQUOTE= (int)192;
	BACKSLASH= (int)220;
	BACKSPACE= (int)8;
	CAPS_LOCK= (int)20;
	COMMA= (int)188;
	COMMAND= (int)15;
	CONTROL= (int)17;
	DELETE= (int)46;
	DOWN= (int)40;
	END= (int)35;
	ENTER= (int)13;
	EQUAL= (int)187;
	ESCAPE= (int)27;
	F1= (int)112;
	F2= (int)113;
	F3= (int)114;
	F4= (int)115;
	F5= (int)116;
	F6= (int)117;
	F7= (int)118;
	F8= (int)119;
	F9= (int)120;
	F10= (int)121;
	F11= (int)122;
	F12= (int)123;
	F13= (int)124;
	F14= (int)125;
	F15= (int)126;
	HOME= (int)36;
	INSERT= (int)45;
	LEFT= (int)37;
	LEFTBRACKET= (int)219;
	MINUS= (int)189;
	NUMBER_0= (int)48;
	NUMBER_1= (int)49;
	NUMBER_2= (int)50;
	NUMBER_3= (int)51;
	NUMBER_4= (int)52;
	NUMBER_5= (int)53;
	NUMBER_6= (int)54;
	NUMBER_7= (int)55;
	NUMBER_8= (int)56;
	NUMBER_9= (int)57;
	NUMPAD= (int)21;
	NUMPAD_0= (int)96;
	NUMPAD_1= (int)97;
	NUMPAD_2= (int)98;
	NUMPAD_3= (int)99;
	NUMPAD_4= (int)100;
	NUMPAD_5= (int)101;
	NUMPAD_6= (int)102;
	NUMPAD_7= (int)103;
	NUMPAD_8= (int)104;
	NUMPAD_9= (int)105;
	NUMPAD_ADD= (int)107;
	NUMPAD_DECIMAL= (int)110;
	NUMPAD_DIVIDE= (int)111;
	NUMPAD_ENTER= (int)108;
	NUMPAD_MULTIPLY= (int)106;
	NUMPAD_SUBTRACT= (int)109;
	PAGE_DOWN= (int)34;
	PAGE_UP= (int)33;
	PERIOD= (int)190;
	QUOTE= (int)222;
	RIGHT= (int)39;
	RIGHTBRACKET= (int)221;
	SEMICOLON= (int)186;
	SHIFT= (int)16;
	SLASH= (int)191;
	SPACE= (int)32;
	TAB= (int)9;
	UP= (int)38;
}

} // end namespace flash
} // end namespace ui
