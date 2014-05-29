#ifndef INCLUDED_flash_text_TextFieldType
#define INCLUDED_flash_text_TextFieldType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,TextFieldType)
namespace flash{
namespace text{


class TextFieldType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef TextFieldType_obj OBJ_;

	public:
		TextFieldType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.text.TextFieldType"); }
		::String __ToString() const { return HX_CSTRING("TextFieldType.") + tag; }

		static ::flash::text::TextFieldType DYNAMIC;
		static inline ::flash::text::TextFieldType DYNAMIC_dyn() { return DYNAMIC; }
		static ::flash::text::TextFieldType INPUT;
		static inline ::flash::text::TextFieldType INPUT_dyn() { return INPUT; }
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_TextFieldType */ 
