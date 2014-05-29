#ifndef INCLUDED_flash_text_FontType
#define INCLUDED_flash_text_FontType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,FontType)
namespace flash{
namespace text{


class FontType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef FontType_obj OBJ_;

	public:
		FontType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.text.FontType"); }
		::String __ToString() const { return HX_CSTRING("FontType.") + tag; }

		static ::flash::text::FontType DEVICE;
		static inline ::flash::text::FontType DEVICE_dyn() { return DEVICE; }
		static ::flash::text::FontType EMBEDDED;
		static inline ::flash::text::FontType EMBEDDED_dyn() { return EMBEDDED; }
		static ::flash::text::FontType EMBEDDED_CFF;
		static inline ::flash::text::FontType EMBEDDED_CFF_dyn() { return EMBEDDED_CFF; }
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_FontType */ 
