#ifndef INCLUDED_flash_display_GradientType
#define INCLUDED_flash_display_GradientType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,GradientType)
namespace flash{
namespace display{


class GradientType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef GradientType_obj OBJ_;

	public:
		GradientType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.GradientType"); }
		::String __ToString() const { return HX_CSTRING("GradientType.") + tag; }

		static ::flash::display::GradientType LINEAR;
		static inline ::flash::display::GradientType LINEAR_dyn() { return LINEAR; }
		static ::flash::display::GradientType RADIAL;
		static inline ::flash::display::GradientType RADIAL_dyn() { return RADIAL; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_GradientType */ 
