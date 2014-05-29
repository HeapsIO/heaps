#ifndef INCLUDED_hxd_Flags
#define INCLUDED_hxd_Flags

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,Flags)
namespace hxd{


class Flags_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Flags_obj OBJ_;

	public:
		Flags_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("hxd.Flags"); }
		::String __ToString() const { return HX_CSTRING("Flags.") + tag; }

		static ::hxd::Flags ALPHA_PREMULTIPLIED;
		static inline ::hxd::Flags ALPHA_PREMULTIPLIED_dyn() { return ALPHA_PREMULTIPLIED; }
		static ::hxd::Flags NO_CONVERSION;
		static inline ::hxd::Flags NO_CONVERSION_dyn() { return NO_CONVERSION; }
		static ::hxd::Flags NO_REUSE;
		static inline ::hxd::Flags NO_REUSE_dyn() { return NO_REUSE; }
};

} // end namespace hxd

#endif /* INCLUDED_hxd_Flags */ 
