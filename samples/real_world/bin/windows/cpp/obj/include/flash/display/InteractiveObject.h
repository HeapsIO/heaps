#ifndef INCLUDED_flash_display_InteractiveObject
#define INCLUDED_flash_display_InteractiveObject

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/display/DisplayObject.h>
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
namespace flash{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  InteractiveObject_obj : public ::flash::display::DisplayObject_obj{
	public:
		typedef ::flash::display::DisplayObject_obj super;
		typedef InteractiveObject_obj OBJ_;
		InteractiveObject_obj();
		Void __construct(Dynamic handle,::String type);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< InteractiveObject_obj > __new(Dynamic handle,::String type);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~InteractiveObject_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("InteractiveObject"); }

		bool doubleClickEnabled;
		bool __mouseEnabled;
		virtual bool __dismissSoftKeyboard( );
		Dynamic __dismissSoftKeyboard_dyn();

		virtual bool requestSoftKeyboard( );
		Dynamic requestSoftKeyboard_dyn();

		virtual ::flash::display::InteractiveObject __asInteractiveObject( );

		virtual bool get_mouseEnabled( );
		Dynamic get_mouseEnabled_dyn();

		virtual bool set_mouseEnabled( bool value);
		Dynamic set_mouseEnabled_dyn();

		virtual bool set_moveForSoftKeyboard( bool value);
		Dynamic set_moveForSoftKeyboard_dyn();

		virtual bool get_moveForSoftKeyboard( );
		Dynamic get_moveForSoftKeyboard_dyn();

		virtual bool set_needsSoftKeyboard( bool value);
		Dynamic set_needsSoftKeyboard_dyn();

		virtual bool get_needsSoftKeyboard( );
		Dynamic get_needsSoftKeyboard_dyn();

		static Dynamic lime_display_object_set_mouse_enabled;
		static Dynamic &lime_display_object_set_mouse_enabled_dyn() { return lime_display_object_set_mouse_enabled;}
		static Dynamic lime_display_object_set_needs_soft_keyboard;
		static Dynamic &lime_display_object_set_needs_soft_keyboard_dyn() { return lime_display_object_set_needs_soft_keyboard;}
		static Dynamic lime_display_object_get_needs_soft_keyboard;
		static Dynamic &lime_display_object_get_needs_soft_keyboard_dyn() { return lime_display_object_get_needs_soft_keyboard;}
		static Dynamic lime_display_object_set_moves_for_soft_keyboard;
		static Dynamic &lime_display_object_set_moves_for_soft_keyboard_dyn() { return lime_display_object_set_moves_for_soft_keyboard;}
		static Dynamic lime_display_object_get_moves_for_soft_keyboard;
		static Dynamic &lime_display_object_get_moves_for_soft_keyboard_dyn() { return lime_display_object_get_moves_for_soft_keyboard;}
		static Dynamic lime_display_object_dismiss_soft_keyboard;
		static Dynamic &lime_display_object_dismiss_soft_keyboard_dyn() { return lime_display_object_dismiss_soft_keyboard;}
		static Dynamic lime_display_object_request_soft_keyboard;
		static Dynamic &lime_display_object_request_soft_keyboard_dyn() { return lime_display_object_request_soft_keyboard;}
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_InteractiveObject */ 
