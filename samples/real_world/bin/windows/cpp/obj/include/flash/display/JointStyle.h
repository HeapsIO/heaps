#ifndef INCLUDED_flash_display_JointStyle
#define INCLUDED_flash_display_JointStyle

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,JointStyle)
namespace flash{
namespace display{


class JointStyle_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef JointStyle_obj OBJ_;

	public:
		JointStyle_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.JointStyle"); }
		::String __ToString() const { return HX_CSTRING("JointStyle.") + tag; }

		static ::flash::display::JointStyle BEVEL;
		static inline ::flash::display::JointStyle BEVEL_dyn() { return BEVEL; }
		static ::flash::display::JointStyle MITER;
		static inline ::flash::display::JointStyle MITER_dyn() { return MITER; }
		static ::flash::display::JointStyle ROUND;
		static inline ::flash::display::JointStyle ROUND_dyn() { return ROUND; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_JointStyle */ 
