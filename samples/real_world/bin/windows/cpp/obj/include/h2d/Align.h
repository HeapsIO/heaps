#ifndef INCLUDED_h2d_Align
#define INCLUDED_h2d_Align

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,Align)
namespace h2d{


class Align_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Align_obj OBJ_;

	public:
		Align_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h2d.Align"); }
		::String __ToString() const { return HX_CSTRING("Align.") + tag; }

		static ::h2d::Align Center;
		static inline ::h2d::Align Center_dyn() { return Center; }
		static ::h2d::Align Left;
		static inline ::h2d::Align Left_dyn() { return Left; }
		static ::h2d::Align Right;
		static inline ::h2d::Align Right_dyn() { return Right; }
};

} // end namespace h2d

#endif /* INCLUDED_h2d_Align */ 
