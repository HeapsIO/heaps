#ifndef INCLUDED_hxd_poly2tri_Edge
#define INCLUDED_hxd_poly2tri_Edge

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Edge)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Edge_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Edge_obj OBJ_;
		Edge_obj();
		Void __construct(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Edge_obj > __new(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Edge_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Edge"); }

		::hxd::poly2tri::Point p;
		::hxd::poly2tri::Point q;
		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Edge */ 
