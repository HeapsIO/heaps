#ifndef INCLUDED_hxd_poly2tri_Constants
#define INCLUDED_hxd_poly2tri_Constants

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Constants)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Constants_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Constants_obj OBJ_;
		Constants_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Constants_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Constants_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Constants"); }

		static Float kAlpha;
		static Float EPSILON;
		static Float PI_2;
		static Float PI_3div4;
};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Constants */ 
