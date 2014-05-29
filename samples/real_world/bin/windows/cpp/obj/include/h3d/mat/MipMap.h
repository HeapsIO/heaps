#ifndef INCLUDED_h3d_mat_MipMap
#define INCLUDED_h3d_mat_MipMap

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,mat,MipMap)
namespace h3d{
namespace mat{


class MipMap_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef MipMap_obj OBJ_;

	public:
		MipMap_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.mat.MipMap"); }
		::String __ToString() const { return HX_CSTRING("MipMap.") + tag; }

		static ::h3d::mat::MipMap Linear;
		static inline ::h3d::mat::MipMap Linear_dyn() { return Linear; }
		static ::h3d::mat::MipMap Nearest;
		static inline ::h3d::mat::MipMap Nearest_dyn() { return Nearest; }
		static ::h3d::mat::MipMap None;
		static inline ::h3d::mat::MipMap None_dyn() { return None; }
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_MipMap */ 
