#ifndef INCLUDED_flash_text_FontStyle
#define INCLUDED_flash_text_FontStyle

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,FontStyle)
namespace flash{
namespace text{


class FontStyle_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef FontStyle_obj OBJ_;

	public:
		FontStyle_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.text.FontStyle"); }
		::String __ToString() const { return HX_CSTRING("FontStyle.") + tag; }

		static ::flash::text::FontStyle BOLD;
		static inline ::flash::text::FontStyle BOLD_dyn() { return BOLD; }
		static ::flash::text::FontStyle BOLD_ITALIC;
		static inline ::flash::text::FontStyle BOLD_ITALIC_dyn() { return BOLD_ITALIC; }
		static ::flash::text::FontStyle ITALIC;
		static inline ::flash::text::FontStyle ITALIC_dyn() { return ITALIC; }
		static ::flash::text::FontStyle REGULAR;
		static inline ::flash::text::FontStyle REGULAR_dyn() { return REGULAR; }
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_FontStyle */ 
