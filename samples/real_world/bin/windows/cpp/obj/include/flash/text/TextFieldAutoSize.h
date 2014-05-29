#ifndef INCLUDED_flash_text_TextFieldAutoSize
#define INCLUDED_flash_text_TextFieldAutoSize

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,TextFieldAutoSize)
namespace flash{
namespace text{


class TextFieldAutoSize_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef TextFieldAutoSize_obj OBJ_;

	public:
		TextFieldAutoSize_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.text.TextFieldAutoSize"); }
		::String __ToString() const { return HX_CSTRING("TextFieldAutoSize.") + tag; }

		static ::flash::text::TextFieldAutoSize CENTER;
		static inline ::flash::text::TextFieldAutoSize CENTER_dyn() { return CENTER; }
		static ::flash::text::TextFieldAutoSize LEFT;
		static inline ::flash::text::TextFieldAutoSize LEFT_dyn() { return LEFT; }
		static ::flash::text::TextFieldAutoSize NONE;
		static inline ::flash::text::TextFieldAutoSize NONE_dyn() { return NONE; }
		static ::flash::text::TextFieldAutoSize RIGHT;
		static inline ::flash::text::TextFieldAutoSize RIGHT_dyn() { return RIGHT; }
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_TextFieldAutoSize */ 
