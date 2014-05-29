#ifndef INCLUDED_h2d_col_Bounds
#define INCLUDED_h2d_col_Bounds

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,Matrix)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h2d,col,Point)
namespace h2d{
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
		Float yMin;
		Float xMax;
		Float yMax;
		Float x;
		Float y;
		Float width;
		Float height;
		virtual Float get_x( );
		Dynamic get_x_dyn();

		virtual Float get_y( );
		Dynamic get_y_dyn();

		virtual Float get_width( );
		Dynamic get_width_dyn();

		virtual Float get_height( );
		Dynamic get_height_dyn();

		virtual bool collides( ::h2d::col::Bounds b);
		Dynamic collides_dyn();

		virtual bool includes( ::h2d::col::Point p);
		Dynamic includes_dyn();

		virtual bool includes2( Float px,Float py);
		Dynamic includes2_dyn();

		virtual bool testCircle( Float px,Float py,int r);
		Dynamic testCircle_dyn();

		virtual Void add( ::h2d::col::Bounds b);
		Dynamic add_dyn();

		virtual Void add4( Float x,Float y,Float w,Float h);
		Dynamic add4_dyn();

		virtual Void addPoint( ::h2d::col::Point p);
		Dynamic addPoint_dyn();

		virtual Void addPoint2( Float px,Float py);
		Dynamic addPoint2_dyn();

		virtual Void setMin( ::h2d::col::Point p);
		Dynamic setMin_dyn();

		virtual Void setMax( ::h2d::col::Point p);
		Dynamic setMax_dyn();

		virtual Void load( ::h2d::col::Bounds b);
		Dynamic load_dyn();

		virtual Void scaleCenter( Float v);
		Dynamic scaleCenter_dyn();

		virtual Void offset( Float dx,Float dy);
		Dynamic offset_dyn();

		virtual ::h2d::col::Point getMin( );
		Dynamic getMin_dyn();

		virtual ::h2d::col::Point getCenter( );
		Dynamic getCenter_dyn();

		virtual ::h2d::col::Point getSize( );
		Dynamic getSize_dyn();

		virtual ::h2d::col::Point getMax( );
		Dynamic getMax_dyn();

		virtual Void empty( );
		Dynamic empty_dyn();

		virtual Void all( );
		Dynamic all_dyn();

		virtual ::h2d::col::Bounds clone( );
		Dynamic clone_dyn();

		virtual Void translate( Float x,Float y);
		Dynamic translate_dyn();

		virtual ::h2d::col::Bounds transform( ::h2d::Matrix m);
		Dynamic transform_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static ::h2d::col::Bounds fromValues( Float x,Float y,Float width,Float height);
		static Dynamic fromValues_dyn();

		static ::h2d::col::Bounds fromPoints( ::h2d::col::Point min,::h2d::col::Point max);
		static Dynamic fromPoints_dyn();

};

} // end namespace h2d
} // end namespace col

#endif /* INCLUDED_h2d_col_Bounds */ 
