#ifndef INCLUDED_h3d_mat_Filter
#define INCLUDED_h3d_mat_Filter

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,mat,Filter)
namespace h3d{
namespace mat{


class Filter_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Filter_obj OBJ_;

	public:
		Filter_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.mat.Filter"); }
		::String __ToString() const { return HX_CSTRING("Filter.") + tag; }

		static ::h3d::mat::Filter Linear;
		static inline ::h3d::mat::Filter Linear_dyn() { return Linear; }
		static ::h3d::mat::Filter Nearest;
		static inline ::h3d::mat::Filter Nearest_dyn() { return Nearest; }
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_Filter */ 
