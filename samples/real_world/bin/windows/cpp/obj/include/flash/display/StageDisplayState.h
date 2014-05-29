#ifndef INCLUDED_flash_display_StageDisplayState
#define INCLUDED_flash_display_StageDisplayState

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,StageDisplayState)
namespace flash{
namespace display{


class StageDisplayState_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef StageDisplayState_obj OBJ_;

	public:
		StageDisplayState_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.StageDisplayState"); }
		::String __ToString() const { return HX_CSTRING("StageDisplayState.") + tag; }

		static ::flash::display::StageDisplayState FULL_SCREEN;
		static inline ::flash::display::StageDisplayState FULL_SCREEN_dyn() { return FULL_SCREEN; }
		static ::flash::display::StageDisplayState FULL_SCREEN_INTERACTIVE;
		static inline ::flash::display::StageDisplayState FULL_SCREEN_INTERACTIVE_dyn() { return FULL_SCREEN_INTERACTIVE; }
		static ::flash::display::StageDisplayState NORMAL;
		static inline ::flash::display::StageDisplayState NORMAL_dyn() { return NORMAL; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_StageDisplayState */ 
