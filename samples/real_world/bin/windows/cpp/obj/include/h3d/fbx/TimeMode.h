#ifndef INCLUDED_h3d_fbx_TimeMode
#define INCLUDED_h3d_fbx_TimeMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,fbx,TimeMode)
namespace h3d{
namespace fbx{


class TimeMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef TimeMode_obj OBJ_;

	public:
		TimeMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.fbx.TimeMode"); }
		::String __ToString() const { return HX_CSTRING("TimeMode.") + tag; }

		static ::h3d::fbx::TimeMode TM_CINEMA;
		static inline ::h3d::fbx::TimeMode TM_CINEMA_dyn() { return TM_CINEMA; }
		static ::h3d::fbx::TimeMode TM_CINEMA_ND;
		static inline ::h3d::fbx::TimeMode TM_CINEMA_ND_dyn() { return TM_CINEMA_ND; }
		static ::h3d::fbx::TimeMode TM_CUSTOM;
		static inline ::h3d::fbx::TimeMode TM_CUSTOM_dyn() { return TM_CUSTOM; }
		static ::h3d::fbx::TimeMode TM_DEFAULT_MODE;
		static inline ::h3d::fbx::TimeMode TM_DEFAULT_MODE_dyn() { return TM_DEFAULT_MODE; }
		static ::h3d::fbx::TimeMode TM_FRAMES100;
		static inline ::h3d::fbx::TimeMode TM_FRAMES100_dyn() { return TM_FRAMES100; }
		static ::h3d::fbx::TimeMode TM_FRAMES1000;
		static inline ::h3d::fbx::TimeMode TM_FRAMES1000_dyn() { return TM_FRAMES1000; }
		static ::h3d::fbx::TimeMode TM_FRAMES120;
		static inline ::h3d::fbx::TimeMode TM_FRAMES120_dyn() { return TM_FRAMES120; }
		static ::h3d::fbx::TimeMode TM_FRAMES30;
		static inline ::h3d::fbx::TimeMode TM_FRAMES30_dyn() { return TM_FRAMES30; }
		static ::h3d::fbx::TimeMode TM_FRAMES30_DROP;
		static inline ::h3d::fbx::TimeMode TM_FRAMES30_DROP_dyn() { return TM_FRAMES30_DROP; }
		static ::h3d::fbx::TimeMode TM_FRAMES48;
		static inline ::h3d::fbx::TimeMode TM_FRAMES48_dyn() { return TM_FRAMES48; }
		static ::h3d::fbx::TimeMode TM_FRAMES50;
		static inline ::h3d::fbx::TimeMode TM_FRAMES50_dyn() { return TM_FRAMES50; }
		static ::h3d::fbx::TimeMode TM_FRAMES60;
		static inline ::h3d::fbx::TimeMode TM_FRAMES60_dyn() { return TM_FRAMES60; }
		static ::h3d::fbx::TimeMode TM_NTSC_DROP_FRAME;
		static inline ::h3d::fbx::TimeMode TM_NTSC_DROP_FRAME_dyn() { return TM_NTSC_DROP_FRAME; }
		static ::h3d::fbx::TimeMode TM_NTSC_FULL_FRAME;
		static inline ::h3d::fbx::TimeMode TM_NTSC_FULL_FRAME_dyn() { return TM_NTSC_FULL_FRAME; }
		static ::h3d::fbx::TimeMode TM_PAL;
		static inline ::h3d::fbx::TimeMode TM_PAL_dyn() { return TM_PAL; }
};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_TimeMode */ 
