#ifndef INCLUDED_flash_display_CapsStyle
#define INCLUDED_flash_display_CapsStyle

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,CapsStyle)
namespace flash{
namespace display{


class CapsStyle_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef CapsStyle_obj OBJ_;

	public:
		CapsStyle_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.CapsStyle"); }
		::String __ToString() const { return HX_CSTRING("CapsStyle.") + tag; }

		static ::flash::display::CapsStyle NONE;
		static inline ::flash::display::CapsStyle NONE_dyn() { return NONE; }
		static ::flash::display::CapsStyle ROUND;
		static inline ::flash::display::CapsStyle ROUND_dyn() { return ROUND; }
		static ::flash::display::CapsStyle SQUARE;
		static inline ::flash::display::CapsStyle SQUARE_dyn() { return SQUARE; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_CapsStyle */ 
