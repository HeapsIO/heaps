#ifndef INCLUDED_flash_display_BlendMode
#define INCLUDED_flash_display_BlendMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,BlendMode)
namespace flash{
namespace display{


class BlendMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef BlendMode_obj OBJ_;

	public:
		BlendMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.BlendMode"); }
		::String __ToString() const { return HX_CSTRING("BlendMode.") + tag; }

		static ::flash::display::BlendMode ADD;
		static inline ::flash::display::BlendMode ADD_dyn() { return ADD; }
		static ::flash::display::BlendMode ALPHA;
		static inline ::flash::display::BlendMode ALPHA_dyn() { return ALPHA; }
		static ::flash::display::BlendMode DARKEN;
		static inline ::flash::display::BlendMode DARKEN_dyn() { return DARKEN; }
		static ::flash::display::BlendMode DIFFERENCE;
		static inline ::flash::display::BlendMode DIFFERENCE_dyn() { return DIFFERENCE; }
		static ::flash::display::BlendMode ERASE;
		static inline ::flash::display::BlendMode ERASE_dyn() { return ERASE; }
		static ::flash::display::BlendMode HARDLIGHT;
		static inline ::flash::display::BlendMode HARDLIGHT_dyn() { return HARDLIGHT; }
		static ::flash::display::BlendMode INVERT;
		static inline ::flash::display::BlendMode INVERT_dyn() { return INVERT; }
		static ::flash::display::BlendMode LAYER;
		static inline ::flash::display::BlendMode LAYER_dyn() { return LAYER; }
		static ::flash::display::BlendMode LIGHTEN;
		static inline ::flash::display::BlendMode LIGHTEN_dyn() { return LIGHTEN; }
		static ::flash::display::BlendMode MULTIPLY;
		static inline ::flash::display::BlendMode MULTIPLY_dyn() { return MULTIPLY; }
		static ::flash::display::BlendMode NORMAL;
		static inline ::flash::display::BlendMode NORMAL_dyn() { return NORMAL; }
		static ::flash::display::BlendMode OVERLAY;
		static inline ::flash::display::BlendMode OVERLAY_dyn() { return OVERLAY; }
		static ::flash::display::BlendMode SCREEN;
		static inline ::flash::display::BlendMode SCREEN_dyn() { return SCREEN; }
		static ::flash::display::BlendMode SUBTRACT;
		static inline ::flash::display::BlendMode SUBTRACT_dyn() { return SUBTRACT; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_BlendMode */ 
