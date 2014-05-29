#ifndef INCLUDED_flash_display_StageAlign
#define INCLUDED_flash_display_StageAlign

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,StageAlign)
namespace flash{
namespace display{


class StageAlign_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef StageAlign_obj OBJ_;

	public:
		StageAlign_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.StageAlign"); }
		::String __ToString() const { return HX_CSTRING("StageAlign.") + tag; }

		static ::flash::display::StageAlign BOTTOM;
		static inline ::flash::display::StageAlign BOTTOM_dyn() { return BOTTOM; }
		static ::flash::display::StageAlign BOTTOM_LEFT;
		static inline ::flash::display::StageAlign BOTTOM_LEFT_dyn() { return BOTTOM_LEFT; }
		static ::flash::display::StageAlign BOTTOM_RIGHT;
		static inline ::flash::display::StageAlign BOTTOM_RIGHT_dyn() { return BOTTOM_RIGHT; }
		static ::flash::display::StageAlign LEFT;
		static inline ::flash::display::StageAlign LEFT_dyn() { return LEFT; }
		static ::flash::display::StageAlign RIGHT;
		static inline ::flash::display::StageAlign RIGHT_dyn() { return RIGHT; }
		static ::flash::display::StageAlign TOP;
		static inline ::flash::display::StageAlign TOP_dyn() { return TOP; }
		static ::flash::display::StageAlign TOP_LEFT;
		static inline ::flash::display::StageAlign TOP_LEFT_dyn() { return TOP_LEFT; }
		static ::flash::display::StageAlign TOP_RIGHT;
		static inline ::flash::display::StageAlign TOP_RIGHT_dyn() { return TOP_RIGHT; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_StageAlign */ 
