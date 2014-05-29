#ifndef INCLUDED_h3d_col_Bounds
#define INCLUDED_h3d_col_Bounds

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS2(h3d,col,Bounds)
HX_DECLARE_CLASS2(h3d,col,Plane)
HX_DECLARE_CLASS2(h3d,col,Point)
namespace h3d{
namespace col{


class HXCPP_CLASS_ATTRIBUTES  Bounds_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Bounds_obj OBJ_;
		Bounds_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Bounds_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Bounds_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Bounds"); }

		Float xMin;
		Float xMax;
		Float yMin;
		Float yMax;
		Float zMin;
		Float zMax;
		virtual bool inFrustum( ::h3d::Matrix mvp);
		Dynamic inFrustum_dyn();

		virtual Float testPlane( ::h3d::col::Plane p);
		Dynamic testPlane_dyn();

		virtual int inFrustumDetails( ::h3d::Matrix mvp,hx::Null< bool >  checkZ);
		Dynamic inFrustumDetails_dyn();

		virtual Void transform3x4( ::h3d::Matrix m);
		Dynamic transform3x4_dyn();

		virtual bool collide( ::h3d::col::Bounds b);
		Dynamic collide_dyn();

		virtual bool include( ::h3d::col::Point p);
		Dynamic include_dyn();

		virtual Void add( ::h3d::col::Bounds b);
		Dynamic add_dyn();

		virtual Void addPoint( ::h3d::col::Point p);
		Dynamic addPoint_dyn();

		virtual Void addPos( Float x,Float y,Float z);
		Dynamic addPos_dyn();

		virtual Void intersection( ::h3d::col::Bounds a,::h3d::col::Bounds b);
		Dynamic intersection_dyn();

		virtual Void offset( Float dx,Float dy,Float dz);
		Dynamic offset_dyn();

		virtual Void setMin( ::h3d::col::Point p);
		Dynamic setMin_dyn();

		virtual Void setMax( ::h3d::col::Point p);
		Dynamic setMax_dyn();

		virtual Void load( ::h3d::col::Bounds b);
		Dynamic load_dyn();

		virtual Void scaleCenter( Float v);
		Dynamic scaleCenter_dyn();

		virtual ::h3d::col::Point getMin( );
		Dynamic getMin_dyn();

		virtual ::h3d::col::Point getCenter( );
		Dynamic getCenter_dyn();

		virtual ::h3d::col::Point getSize( );
		Dynamic getSize_dyn();

		virtual ::h3d::col::Point getMax( );
		Dynamic getMax_dyn();

		virtual Void empty( );
		Dynamic empty_dyn();

		virtual Void all( );
		Dynamic all_dyn();

		virtual ::h3d::col::Bounds clone( );
		Dynamic clone_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static ::h3d::col::Bounds fromPoints( ::h3d::col::Point min,::h3d::col::Point max);
		static Dynamic fromPoints_dyn();

};

} // end namespace h3d
} // end namespace col

#endif /* INCLUDED_h3d_col_Bounds */ 
