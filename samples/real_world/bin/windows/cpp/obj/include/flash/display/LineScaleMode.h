#ifndef INCLUDED_flash_display_LineScaleMode
#define INCLUDED_flash_display_LineScaleMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,LineScaleMode)
namespace flash{
namespace display{


class LineScaleMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef LineScaleMode_obj OBJ_;

	public:
		LineScaleMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.display.LineScaleMode"); }
		::String __ToString() const { return HX_CSTRING("LineScaleMode.") + tag; }

		static ::flash::display::LineScaleMode HORIZONTAL;
		static inline ::flash::display::LineScaleMode HORIZONTAL_dyn() { return HORIZONTAL; }
		static ::flash::display::LineScaleMode NONE;
		static inline ::flash::display::LineScaleMode NONE_dyn() { return NONE; }
		static ::flash::display::LineScaleMode NORMAL;
		static inline ::flash::display::LineScaleMode NORMAL_dyn() { return NORMAL; }
		static ::flash::display::LineScaleMode OPENGL;
		static inline ::flash::display::LineScaleMode OPENGL_dyn() { return OPENGL; }
		static ::flash::display::LineScaleMode VERTICAL;
		static inline ::flash::display::LineScaleMode VERTICAL_dyn() { return VERTICAL; }
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_LineScaleMode */ 
