#ifndef INCLUDED_hxd_poly2tri_Utils
#define INCLUDED_hxd_poly2tri_Utils

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Point)
HX_DECLARE_CLASS2(hxd,poly2tri,Utils)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Utils_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Utils_obj OBJ_;
		Utils_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Utils_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Utils_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Utils"); }

		static bool insideIncircle( ::hxd::poly2tri::Point pa,::hxd::poly2tri::Point pb,::hxd::poly2tri::Point pc,::hxd::poly2tri::Point pd);
		static Dynamic insideIncircle_dyn();

		static bool inScanArea( ::hxd::poly2tri::Point pa,::hxd::poly2tri::Point pb,::hxd::poly2tri::Point pc,::hxd::poly2tri::Point pd);
		static Dynamic inScanArea_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Utils */ 
