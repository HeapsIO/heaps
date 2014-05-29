#ifndef INCLUDED_hxd_PixelFormat
#define INCLUDED_hxd_PixelFormat

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,PixelFormat)
namespace hxd{


class PixelFormat_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef PixelFormat_obj OBJ_;

	public:
		PixelFormat_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("hxd.PixelFormat"); }
		::String __ToString() const { return HX_CSTRING("PixelFormat.") + tag; }

		static ::hxd::PixelFormat ARGB;
		static inline ::hxd::PixelFormat ARGB_dyn() { return ARGB; }
		static ::hxd::PixelFormat BGRA;
		static inline ::hxd::PixelFormat BGRA_dyn() { return BGRA; }
		static ::hxd::PixelFormat RGBA;
		static inline ::hxd::PixelFormat RGBA_dyn() { return RGBA; }
};

} // end namespace hxd

#endif /* INCLUDED_hxd_PixelFormat */ 
