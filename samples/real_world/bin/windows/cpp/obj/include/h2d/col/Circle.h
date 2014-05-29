#ifndef INCLUDED_h2d_col_Circle
#define INCLUDED_h2d_col_Circle

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h2d,col,Circle)
HX_DECLARE_CLASS2(h2d,col,Point)
namespace h2d{
namespace col{


class HXCPP_CLASS_ATTRIBUTES  Circle_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Circle_obj OBJ_;
		Circle_obj();
		Void __construct(Float x,Float y,Float ray);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Circle_obj > __new(Float x,Float y,Float ray);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Circle_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Circle"); }

		Float x;
		Float y;
		Float ray;
		virtual Float distanceSq( ::h2d::col::Point p);
		Dynamic distanceSq_dyn();

		virtual Float side( ::h2d::col::Point p);
		Dynamic side_dyn();

		virtual bool collideCircle( ::h2d::col::Circle c);
		Dynamic collideCircle_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace h2d
} // end namespace col

#endif /* INCLUDED_h2d_col_Circle */ 
