#ifndef INCLUDED_h3d_col_Point
#define INCLUDED_h3d_col_Point

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,col,Point)
namespace h3d{
namespace col{


class HXCPP_CLASS_ATTRIBUTES  Point_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Point_obj OBJ_;
		Point_obj();
		Void __construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Point_obj > __new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Point_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Point"); }

		Float x;
		Float y;
		Float z;
		virtual bool inFrustum( ::h3d::Matrix mvp);
		Dynamic inFrustum_dyn();

		virtual Void set( Float x,Float y,Float z);
		Dynamic set_dyn();

		virtual ::h3d::col::Point sub( ::h3d::col::Point p);
		Dynamic sub_dyn();

		virtual ::h3d::col::Point add( ::h3d::col::Point p);
		Dynamic add_dyn();

		virtual ::h3d::col::Point cross( ::h3d::col::Point p);
		Dynamic cross_dyn();

		virtual Float lengthSq( );
		Dynamic lengthSq_dyn();

		virtual Float length( );
		Dynamic length_dyn();

		virtual Float dot( ::h3d::col::Point p);
		Dynamic dot_dyn();

		virtual Float distanceSq( ::h3d::col::Point p);
		Dynamic distanceSq_dyn();

		virtual Float distance( ::h3d::col::Point p);
		Dynamic distance_dyn();

		virtual Void normalize( );
		Dynamic normalize_dyn();

		virtual Void transform( ::h3d::Matrix m);
		Dynamic transform_dyn();

		virtual ::h3d::Vector toVector( );
		Dynamic toVector_dyn();

		virtual ::h3d::col::Point clone( );
		Dynamic clone_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace h3d
} // end namespace col

#endif /* INCLUDED_h3d_col_Point */ 
