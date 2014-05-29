#ifndef INCLUDED_h2d_BlendMode
#define INCLUDED_h2d_BlendMode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,BlendMode)
namespace h2d{


class BlendMode_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef BlendMode_obj OBJ_;

	public:
		BlendMode_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h2d.BlendMode"); }
		::String __ToString() const { return HX_CSTRING("BlendMode.") + tag; }

		static ::h2d::BlendMode Add;
		static inline ::h2d::BlendMode Add_dyn() { return Add; }
		static ::h2d::BlendMode Erase;
		static inline ::h2d::BlendMode Erase_dyn() { return Erase; }
		static ::h2d::BlendMode Hide;
		static inline ::h2d::BlendMode Hide_dyn() { return Hide; }
		static ::h2d::BlendMode Multiply;
		static inline ::h2d::BlendMode Multiply_dyn() { return Multiply; }
		static ::h2d::BlendMode None;
		static inline ::h2d::BlendMode None_dyn() { return None; }
		static ::h2d::BlendMode Normal;
		static inline ::h2d::BlendMode Normal_dyn() { return Normal; }
		static ::h2d::BlendMode Screen;
		static inline ::h2d::BlendMode Screen_dyn() { return Screen; }
		static ::h2d::BlendMode SoftAdd;
		static inline ::h2d::BlendMode SoftAdd_dyn() { return SoftAdd; }
};

} // end namespace h2d

#endif /* INCLUDED_h2d_BlendMode */ 
