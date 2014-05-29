#ifndef INCLUDED_h2d_col_Point
#define INCLUDED_h2d_col_Point

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h2d,col,Point)
namespace h2d{
namespace col{


class HXCPP_CLASS_ATTRIBUTES  Point_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Point_obj OBJ_;
		Point_obj();
		Void __construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Point_obj > __new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Point_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Point"); }

		Float x;
		Float y;
		virtual Float distanceSq( ::h2d::col::Point p);
		Dynamic distanceSq_dyn();

		virtual Float distance( ::h2d::col::Point p);
		Dynamic distance_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::h2d::col::Point sub( ::h2d::col::Point p);
		Dynamic sub_dyn();

		virtual ::h2d::col::Point add( ::h2d::col::Point p);
		Dynamic add_dyn();

		virtual Float dot( ::h2d::col::Point p);
		Dynamic dot_dyn();

		virtual Float lengthSq( );
		Dynamic lengthSq_dyn();

		virtual Float length( );
		Dynamic length_dyn();

		virtual Void normalize( );
		Dynamic normalize_dyn();

		virtual Void set( Float x,Float y);
		Dynamic set_dyn();

		virtual Void scale( Float f);
		Dynamic scale_dyn();

		static ::h2d::col::Point ZERO;
};

} // end namespace h2d
} // end namespace col

#endif /* INCLUDED_h2d_col_Point */ 
