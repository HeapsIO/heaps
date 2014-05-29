#ifndef INCLUDED_h3d_mat_Wrap
#define INCLUDED_h3d_mat_Wrap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,mat,Wrap)
namespace h3d{
namespace mat{


class Wrap_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Wrap_obj OBJ_;

	public:
		Wrap_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.mat.Wrap"); }
		::String __ToString() const { return HX_CSTRING("Wrap.") + tag; }

		static ::h3d::mat::Wrap Clamp;
		static inline ::h3d::mat::Wrap Clamp_dyn() { return Clamp; }
		static ::h3d::mat::Wrap Repeat;
		static inline ::h3d::mat::Wrap Repeat_dyn() { return Repeat; }
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_Wrap */ 
