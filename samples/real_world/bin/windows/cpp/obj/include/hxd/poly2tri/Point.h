#ifndef INCLUDED_hxd_poly2tri_Point
#define INCLUDED_hxd_poly2tri_Point

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Edge)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Point_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Point_obj OBJ_;
		Point_obj();
		Void __construct(Float x,Float y);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Point_obj > __new(Float x,Float y);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Point_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Point"); }

		int id;
		Float x;
		Float y;
		Array< ::Dynamic > edge_list;
		virtual Array< ::Dynamic > get_edge_list( );
		Dynamic get_edge_list_dyn();

		virtual bool equals( ::hxd::poly2tri::Point that);
		Dynamic equals_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static Void sortPoints( Array< ::Dynamic > points);
		static Dynamic sortPoints_dyn();

		static int cmpPoints( ::hxd::poly2tri::Point l,::hxd::poly2tri::Point r);
		static Dynamic cmpPoints_dyn();

		static int C_ID;
};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Point */ 
