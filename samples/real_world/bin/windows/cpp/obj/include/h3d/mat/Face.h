#ifndef INCLUDED_h3d_mat_Face
#define INCLUDED_h3d_mat_Face

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,mat,Face)
namespace h3d{
namespace mat{


class Face_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef Face_obj OBJ_;

	public:
		Face_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.mat.Face"); }
		::String __ToString() const { return HX_CSTRING("Face.") + tag; }

		static ::h3d::mat::Face Back;
		static inline ::h3d::mat::Face Back_dyn() { return Back; }
		static ::h3d::mat::Face Both;
		static inline ::h3d::mat::Face Both_dyn() { return Both; }
		static ::h3d::mat::Face Front;
		static inline ::h3d::mat::Face Front_dyn() { return Front; }
		static ::h3d::mat::Face None;
		static inline ::h3d::mat::Face None_dyn() { return None; }
};

} // end namespace h3d
} // end namespace mat

#endif /* INCLUDED_h3d_mat_Face */ 
