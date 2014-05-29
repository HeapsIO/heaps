#ifndef INCLUDED_flash_display_InterpolationMethod
#define INCLUDED_flash_display_InterpolationMethod

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,InterpolationMethod)
namespace flash{
namespace display{


class InterpolationMethod_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef InterpolationMethod_obj OBJ_;

	public:
		InterpolationMethod_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.InterpolationMethod"); }
		::String __ToString() const { return HX_CSTRING("InterpolationMethod.") + tag; }

		static ::flash::display::InterpolationMethod LINEAR_RGB;
		static inline ::flash::display::InterpolationMethod LINEAR_RGB_dyn() { return LINEAR_RGB; }
		static ::flash::display::InterpolationMethod RGB;
		static inline ::flash::display::InterpolationMethod RGB_dyn() { return RGB; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_InterpolationMethod */ 
