#ifndef INCLUDED_flash_ui_Keyboard
#define INCLUDED_flash_ui_Keyboard

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,ui,Keyboard)
namespace flash{
namespace ui{


class HXCPP_CLASS_ATTRIBUTES  Keyboard_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Keyboard_obj OBJ_;
		Keyboard_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Keyboard_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Keyboard_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Keyboard"); }

		static int A;
		static int B;
		static int C;
		static int D;
		static int E;
		static int F;
		static int G;
		static int H;
		static int I;
		static int J;
		static int K;
		static int L;
		static int M;
		static int N;
		static int O;
		static int P;
		static int Q;
		static int R;
		static int S;
		static int T;
		static int U;
		static int V;
		static int W;
		static int X;
		static int Y;
		static int Z;
		static int ALTERNATE;
		static int BACKQUOTE;
		static int BACKSLASH;
		static int BACKSPACE;
		static int CAPS_LOCK;
		static int COMMA;
		static int COMMAND;
		static int CONTROL;
		static int DELETE;
		static int DOWN;
		static int END;
		static int ENTER;
		static int EQUAL;
		static int ESCAPE;
		static int F1;
		static int F2;
		static int F3;
		static int F4;
		static int F5;
		static int F6;
		static int F7;
		static int F8;
		static int F9;
		static int F10;
		static int F11;
		static int F12;
		static int F13;
		static int F14;
		static int F15;
		static int HOME;
		static int INSERT;
		static int LEFT;
		static int LEFTBRACKET;
		static int MINUS;
		static int NUMBER_0;
		static int NUMBER_1;
		static int NUMBER_2;
		static int NUMBER_3;
		static int NUMBER_4;
		static int NUMBER_5;
		static int NUMBER_6;
		static int NUMBER_7;
		static int NUMBER_8;
		static int NUMBER_9;
		static int NUMPAD;
		static int NUMPAD_0;
		static int NUMPAD_1;
		static int NUMPAD_2;
		static int NUMPAD_3;
		static int NUMPAD_4;
		static int NUMPAD_5;
		static int NUMPAD_6;
		static int NUMPAD_7;
		static int NUMPAD_8;
		static int NUMPAD_9;
		static int NUMPAD_ADD;
		static int NUMPAD_DECIMAL;
		static int NUMPAD_DIVIDE;
		static int NUMPAD_ENTER;
		static int NUMPAD_MULTIPLY;
		static int NUMPAD_SUBTRACT;
		static int PAGE_DOWN;
		static int PAGE_UP;
		static int PERIOD;
		static int QUOTE;
		static int RIGHT;
		static int RIGHTBRACKET;
		static int SEMICOLON;
		static int SHIFT;
		static int SLASH;
		static int SPACE;
		static int TAB;
		static int UP;
};

} // end namespace flash
} // end namespace ui

#endif /* INCLUDED_flash_ui_Keyboard */ 
