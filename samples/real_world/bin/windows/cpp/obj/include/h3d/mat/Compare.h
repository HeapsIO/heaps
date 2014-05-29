#ifndef INCLUDED_h3d_mat_Compare
#define INCLUDED_h3d_mat_Compare

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,mat,Compare)
namespace h3d{
namespace mat{


class Compare_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Compare_obj OBJ_;

	public:
		Compare_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.mat.Compare"); }
		::String __ToString() const { return HX_CSTRING("Compare.") + tag; }

		static ::h3d::mat::Compare Always;
		static inline ::h3d::mat::Compare Always_dyn() { return Always; }
		static ::h3d::mat::Compare Equal;
		static inline ::h3d::mat::Compare Equal_dyn() { return Equal; }
		static ::h3d::mat::Compare Greater;
		static inline ::h3d::mat::Compare Greater_dyn() { return Greater; }
		static ::h3d::mat::Compare GreaterEqual;
		static inline ::h3d::mat::Compare GreaterEqual_dyn() { return GreaterEqual; }
		static ::h3d::mat::Compare Less;
		static inline ::h3d::mat::Compare Less_dyn() { return Less; }
		static ::h3d::mat::Compare LessEqual;
		static inline ::h3d::mat::Compare LessEqual_dyn() { return LessEqual; }
		static ::h3d::mat::Compare Never;
		static inline ::h3d::mat::Compare Never_dyn() { return Never; }
		static ::h3d::mat::Compare NotEqual;
		static inline ::h3d::mat::Compare NotEqual_dyn() { return NotEqual; }
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_Compare */ 
