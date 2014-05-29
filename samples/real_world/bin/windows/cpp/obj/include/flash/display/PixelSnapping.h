#ifndef INCLUDED_flash_display_PixelSnapping
#define INCLUDED_flash_display_PixelSnapping

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,PixelSnapping)
namespace flash{
namespace display{


class PixelSnapping_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef PixelSnapping_obj OBJ_;

	public:
		PixelSnapping_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.PixelSnapping"); }
		::String __ToString() const { return HX_CSTRING("PixelSnapping.") + tag; }

		static ::flash::display::PixelSnapping ALWAYS;
		static inline ::flash::display::PixelSnapping ALWAYS_dyn() { return ALWAYS; }
		static ::flash::display::PixelSnapping AUTO;
		static inline ::flash::display::PixelSnapping AUTO_dyn() { return AUTO; }
		static ::flash::display::PixelSnapping NEVER;
		static inline ::flash::display::PixelSnapping NEVER_dyn() { return NEVER; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_PixelSnapping */ 
