#ifndef INCLUDED_flash_text_AntiAliasType
#define INCLUDED_flash_text_AntiAliasType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,text,AntiAliasType)
namespace flash{
namespace text{


class AntiAliasType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef AntiAliasType_obj OBJ_;

	public:
		AntiAliasType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.text.AntiAliasType"); }
		::String __ToString() const { return HX_CSTRING("AntiAliasType.") + tag; }

		static ::flash::text::AntiAliasType ADVANCED;
		static inline ::flash::text::AntiAliasType ADVANCED_dyn() { return ADVANCED; }
		static ::flash::text::AntiAliasType NORMAL;
		static inline ::flash::text::AntiAliasType NORMAL_dyn() { return NORMAL; }
};

} // end namespace flash
} // end namespace text

#endif /* INCLUDED_flash_text_AntiAliasType */ 
