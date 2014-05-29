#ifndef INCLUDED_flash_display_StageQuality
#define INCLUDED_flash_display_StageQuality

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,StageQuality)
namespace flash{
namespace display{


class StageQuality_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef StageQuality_obj OBJ_;

	public:
		StageQuality_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.StageQuality"); }
		::String __ToString() const { return HX_CSTRING("StageQuality.") + tag; }

		static ::flash::display::StageQuality BEST;
		static inline ::flash::display::StageQuality BEST_dyn() { return BEST; }
		static ::flash::display::StageQuality HIGH;
		static inline ::flash::display::StageQuality HIGH_dyn() { return HIGH; }
		static ::flash::display::StageQuality LOW;
		static inline ::flash::display::StageQuality LOW_dyn() { return LOW; }
		static ::flash::display::StageQuality MEDIUM;
		static inline ::flash::display::StageQuality MEDIUM_dyn() { return MEDIUM; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_StageQuality */ 
