#ifndef INCLUDED_flash_display_SpreadMethod
#define INCLUDED_flash_display_SpreadMethod

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,SpreadMethod)
namespace flash{
namespace display{


class SpreadMethod_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef SpreadMethod_obj OBJ_;

	public:
		SpreadMethod_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.SpreadMethod"); }
		::String __ToString() const { return HX_CSTRING("SpreadMethod.") + tag; }

		static ::flash::display::SpreadMethod PAD;
		static inline ::flash::display::SpreadMethod PAD_dyn() { return PAD; }
		static ::flash::display::SpreadMethod REFLECT;
		static inline ::flash::display::SpreadMethod REFLECT_dyn() { return REFLECT; }
		static ::flash::display::SpreadMethod REPEAT;
		static inline ::flash::display::SpreadMethod REPEAT_dyn() { return REPEAT; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_SpreadMethod */ 
