#ifndef INCLUDED_flash_ui_MultitouchInputMode
#define INCLUDED_flash_ui_MultitouchInputMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,ui,MultitouchInputMode)
namespace flash{
namespace ui{


class MultitouchInputMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef MultitouchInputMode_obj OBJ_;

	public:
		MultitouchInputMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.ui.MultitouchInputMode"); }
		::String __ToString() const { return HX_CSTRING("MultitouchInputMode.") + tag; }

		static ::flash::ui::MultitouchInputMode GESTURE;
		static inline ::flash::ui::MultitouchInputMode GESTURE_dyn() { return GESTURE; }
		static ::flash::ui::MultitouchInputMode NONE;
		static inline ::flash::ui::MultitouchInputMode NONE_dyn() { return NONE; }
		static ::flash::ui::MultitouchInputMode TOUCH_POINT;
		static inline ::flash::ui::MultitouchInputMode TOUCH_POINT_dyn() { return TOUCH_POINT; }
};

} // end namespace flash
} // end namespace ui

#endif /* INCLUDED_flash_ui_MultitouchInputMode */ 
