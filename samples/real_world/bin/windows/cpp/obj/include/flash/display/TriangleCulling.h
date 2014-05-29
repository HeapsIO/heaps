#ifndef INCLUDED_flash_display_TriangleCulling
#define INCLUDED_flash_display_TriangleCulling

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,TriangleCulling)
namespace flash{
namespace display{


class TriangleCulling_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef TriangleCulling_obj OBJ_;

	public:
		TriangleCulling_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.TriangleCulling"); }
		::String __ToString() const { return HX_CSTRING("TriangleCulling.") + tag; }

		static ::flash::display::TriangleCulling NEGATIVE;
		static inline ::flash::display::TriangleCulling NEGATIVE_dyn() { return NEGATIVE; }
		static ::flash::display::TriangleCulling NONE;
		static inline ::flash::display::TriangleCulling NONE_dyn() { return NONE; }
		static ::flash::display::TriangleCulling POSITIVE;
		static inline ::flash::display::TriangleCulling POSITIVE_dyn() { return POSITIVE; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_TriangleCulling */ 
