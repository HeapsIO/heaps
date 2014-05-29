#ifndef INCLUDED_flash_system_PixelFormat
#define INCLUDED_flash_system_PixelFormat

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,system,PixelFormat)
namespace flash{
namespace system{


class PixelFormat_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef PixelFormat_obj OBJ_;

	public:
		PixelFormat_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.system.PixelFormat"); }
		::String __ToString() const { return HX_CSTRING("PixelFormat.") + tag; }

		static ::flash::system::PixelFormat ABGR1555;
		static inline ::flash::system::PixelFormat ABGR1555_dyn() { return ABGR1555; }
		static ::flash::system::PixelFormat ABGR4444;
		static inline ::flash::system::PixelFormat ABGR4444_dyn() { return ABGR4444; }
		static ::flash::system::PixelFormat ABGR8888;
		static inline ::flash::system::PixelFormat ABGR8888_dyn() { return ABGR8888; }
		static ::flash::system::PixelFormat ARGB1555;
		static inline ::flash::system::PixelFormat ARGB1555_dyn() { return ARGB1555; }
		static ::flash::system::PixelFormat ARGB2101010;
		static inline ::flash::system::PixelFormat ARGB2101010_dyn() { return ARGB2101010; }
		static ::flash::system::PixelFormat ARGB4444;
		static inline ::flash::system::PixelFormat ARGB4444_dyn() { return ARGB4444; }
		static ::flash::system::PixelFormat ARGB8888;
		static inline ::flash::system::PixelFormat ARGB8888_dyn() { return ARGB8888; }
		static ::flash::system::PixelFormat BGR24;
		static inline ::flash::system::PixelFormat BGR24_dyn() { return BGR24; }
		static ::flash::system::PixelFormat BGR555;
		static inline ::flash::system::PixelFormat BGR555_dyn() { return BGR555; }
		static ::flash::system::PixelFormat BGR565;
		static inline ::flash::system::PixelFormat BGR565_dyn() { return BGR565; }
		static ::flash::system::PixelFormat BGR888;
		static inline ::flash::system::PixelFormat BGR888_dyn() { return BGR888; }
		static ::flash::system::PixelFormat BGRA4444;
		static inline ::flash::system::PixelFormat BGRA4444_dyn() { return BGRA4444; }
		static ::flash::system::PixelFormat BGRA5551;
		static inline ::flash::system::PixelFormat BGRA5551_dyn() { return BGRA5551; }
		static ::flash::system::PixelFormat BGRA8888;
		static inline ::flash::system::PixelFormat BGRA8888_dyn() { return BGRA8888; }
		static ::flash::system::PixelFormat BGRX8888;
		static inline ::flash::system::PixelFormat BGRX8888_dyn() { return BGRX8888; }
		static ::flash::system::PixelFormat INDEX1LSB;
		static inline ::flash::system::PixelFormat INDEX1LSB_dyn() { return INDEX1LSB; }
		static ::flash::system::PixelFormat INDEX1MSB;
		static inline ::flash::system::PixelFormat INDEX1MSB_dyn() { return INDEX1MSB; }
		static ::flash::system::PixelFormat INDEX4LSB;
		static inline ::flash::system::PixelFormat INDEX4LSB_dyn() { return INDEX4LSB; }
		static ::flash::system::PixelFormat INDEX4MSB;
		static inline ::flash::system::PixelFormat INDEX4MSB_dyn() { return INDEX4MSB; }
		static ::flash::system::PixelFormat INDEX8;
		static inline ::flash::system::PixelFormat INDEX8_dyn() { return INDEX8; }
		static ::flash::system::PixelFormat IYUV;
		static inline ::flash::system::PixelFormat IYUV_dyn() { return IYUV; }
		static ::flash::system::PixelFormat RGB24;
		static inline ::flash::system::PixelFormat RGB24_dyn() { return RGB24; }
		static ::flash::system::PixelFormat RGB332;
		static inline ::flash::system::PixelFormat RGB332_dyn() { return RGB332; }
		static ::flash::system::PixelFormat RGB444;
		static inline ::flash::system::PixelFormat RGB444_dyn() { return RGB444; }
		static ::flash::system::PixelFormat RGB555;
		static inline ::flash::system::PixelFormat RGB555_dyn() { return RGB555; }
		static ::flash::system::PixelFormat RGB565;
		static inline ::flash::system::PixelFormat RGB565_dyn() { return RGB565; }
		static ::flash::system::PixelFormat RGB888;
		static inline ::flash::system::PixelFormat RGB888_dyn() { return RGB888; }
		static ::flash::system::PixelFormat RGBA4444;
		static inline ::flash::system::PixelFormat RGBA4444_dyn() { return RGBA4444; }
		static ::flash::system::PixelFormat RGBA5551;
		static inline ::flash::system::PixelFormat RGBA5551_dyn() { return RGBA5551; }
		static ::flash::system::PixelFormat RGBA8888;
		static inline ::flash::system::PixelFormat RGBA8888_dyn() { return RGBA8888; }
		static ::flash::system::PixelFormat RGBX8888;
		static inline ::flash::system::PixelFormat RGBX8888_dyn() { return RGBX8888; }
		static ::flash::system::PixelFormat UNKNOWN;
		static inline ::flash::system::PixelFormat UNKNOWN_dyn() { return UNKNOWN; }
		static ::flash::system::PixelFormat UYVY;
		static inline ::flash::system::PixelFormat UYVY_dyn() { return UYVY; }
		static ::flash::system::PixelFormat YUY2;
		static inline ::flash::system::PixelFormat YUY2_dyn() { return YUY2; }
		static ::flash::system::PixelFormat YV12;
		static inline ::flash::system::PixelFormat YV12_dyn() { return YV12; }
		static ::flash::system::PixelFormat YVYU;
		static inline ::flash::system::PixelFormat YVYU_dyn() { return YVYU; }
};

} // end namespace flash
} // end namespace system

#endif /* INCLUDED_flash_system_PixelFormat */ 
