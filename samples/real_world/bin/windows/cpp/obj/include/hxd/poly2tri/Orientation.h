#ifndef INCLUDED_hxd_poly2tri_Orientation
#define INCLUDED_hxd_poly2tri_Orientation

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Orientation)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Orientation_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Orientation_obj OBJ_;
		Orientation_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Orientation_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Orientation_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Orientation"); }

		static int CW;
		static int CCW;
		static int COLLINEAR;
		static int orient2d( ::hxd::poly2tri::Point pa,::hxd::poly2tri::Point pb,::hxd::poly2tri::Point pc);
		static Dynamic orient2d_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Orientation */ 
