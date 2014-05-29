#ifndef INCLUDED_flash_text_GridFitType
#define INCLUDED_flash_text_GridFitType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,GridFitType)
namespace flash{
namespace text{


class GridFitType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef GridFitType_obj OBJ_;

	public:
		GridFitType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.text.GridFitType"); }
		::String __ToString() const { return HX_CSTRING("GridFitType.") + tag; }

		static ::flash::text::GridFitType NONE;
		static inline ::flash::text::GridFitType NONE_dyn() { return NONE; }
		static ::flash::text::GridFitType PIXEL;
		static inline ::flash::text::GridFitType PIXEL_dyn() { return PIXEL; }
		static ::flash::text::GridFitType SUBPIXEL;
		static inline ::flash::text::GridFitType SUBPIXEL_dyn() { return SUBPIXEL; }
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_GridFitType */ 
