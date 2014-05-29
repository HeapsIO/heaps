#ifndef INCLUDED_hxd_res_Filter
#define INCLUDED_hxd_res_Filter

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,res,Filter)
namespace hxd{
namespace res{


class Filter_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Filter_obj OBJ_;

	public:
		Filter_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("hxd.res.Filter"); }
		::String __ToString() const { return HX_CSTRING("Filter.") + tag; }

		static ::hxd::res::Filter Chromatic;
		static inline ::hxd::res::Filter Chromatic_dyn() { return Chromatic; }
		static ::hxd::res::Filter Fast;
		static inline ::hxd::res::Filter Fast_dyn() { return Fast; }
};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Filter */ 
