#ifndef INCLUDED_h3d_col_Plane
#define INCLUDED_h3d_col_Plane

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,col,Plane)
HX_DECLARE_CLASS2(h3d,col,Point)
namespace h3d{
namespace col{


class HXCPP_CLASS_ATTRIBUTES  Plane_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Plane_obj OBJ_;
		Plane_obj();
		Void __construct(Float nx,Float ny,Float nz,Float d);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Plane_obj > __new(Float nx,Float ny,Float nz,Float d);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Plane_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Plane"); }

		Float nx;
		Float ny;
		Float nz;
		Float d;
		virtual ::h3d::col::Point getNormal( );
		Dynamic getNormal_dyn();

		virtual Float getNormalDistance( );
		Dynamic getNormalDistance_dyn();

		virtual Void normalize( );
		Dynamic normalize_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual Float distance( ::h3d::col::Point p);
		Dynamic distance_dyn();

		virtual bool side( ::h3d::col::Point p);
		Dynamic side_dyn();

		virtual ::h3d::col::Point project( ::h3d::col::Point p);
		Dynamic project_dyn();

		virtual Void projectTo( ::h3d::col::Point p,::h3d::col::Point out);
		Dynamic projectTo_dyn();

		static ::h3d::col::Plane fromPoints( ::h3d::col::Point p0,::h3d::col::Point p1,::h3d::col::Point p2);
		static Dynamic fromPoints_dyn();

		static ::h3d::col::Plane fromNormalPoint( ::h3d::col::Point n,::h3d::col::Point p);
		static Dynamic fromNormalPoint_dyn();

		static ::h3d::col::Plane X( Float v);
		static Dynamic X_dyn();

		static ::h3d::col::Plane Y( Float v);
		static Dynamic Y_dyn();

		static ::h3d::col::Plane Z( Float v);
		static Dynamic Z_dyn();

};

} // end namespace h3d
} // end namespace col

#endif /* INCLUDED_h3d_col_Plane */ 
