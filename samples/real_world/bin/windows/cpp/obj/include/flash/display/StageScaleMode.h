#ifndef INCLUDED_flash_display_StageScaleMode
#define INCLUDED_flash_display_StageScaleMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,StageScaleMode)
namespace flash{
namespace display{


class StageScaleMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef StageScaleMode_obj OBJ_;

	public:
		StageScaleMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.StageScaleMode"); }
		::String __ToString() const { return HX_CSTRING("StageScaleMode.") + tag; }

		static ::flash::display::StageScaleMode EXACT_FIT;
		static inline ::flash::display::StageScaleMode EXACT_FIT_dyn() { return EXACT_FIT; }
		static ::flash::display::StageScaleMode NO_BORDER;
		static inline ::flash::display::StageScaleMode NO_BORDER_dyn() { return NO_BORDER; }
		static ::flash::display::StageScaleMode NO_SCALE;
		static inline ::flash::display::StageScaleMode NO_SCALE_dyn() { return NO_SCALE; }
		static ::flash::display::StageScaleMode SHOW_ALL;
		static inline ::flash::display::StageScaleMode SHOW_ALL_dyn() { return SHOW_ALL; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_StageScaleMode */ 
