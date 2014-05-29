#ifndef INCLUDED_flash_geom_Point
#define INCLUDED_flash_geom_Point

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,geom,Point)
namespace flash{
namespace geom{


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

		Float length;
		Float x;
		Float y;
		virtual ::flash::geom::Point add( ::flash::geom::Point v);
		Dynamic add_dyn();

		virtual ::flash::geom::Point clone( );
		Dynamic clone_dyn();

		virtual Void copyFrom( ::flash::geom::Point sourcePoint);
		Dynamic copyFrom_dyn();

		virtual bool equals( ::flash::geom::Point toCompare);
		Dynamic equals_dyn();

		virtual Void normalize( Float thickness);
		Dynamic normalize_dyn();

		virtual Void offset( Float dx,Float dy);
		Dynamic offset_dyn();

		virtual Void setTo( Float x,Float y);
		Dynamic setTo_dyn();

		virtual ::flash::geom::Point subtract( ::flash::geom::Point v);
		Dynamic subtract_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual Float get_length( );
		Dynamic get_length_dyn();

		static Float distance( ::flash::geom::Point pt1,::flash::geom::Point pt2);
		static Dynamic distance_dyn();

		static ::flash::geom::Point interpolate( ::flash::geom::Point pt1,::flash::geom::Point pt2,Float f);
		static Dynamic interpolate_dyn();

		static ::flash::geom::Point polar( Float len,Float angle);
		static Dynamic polar_dyn();

};

} // end namespace flash
} // end namespace geom

#endif /* INCLUDED_flash_geom_Point */ 
