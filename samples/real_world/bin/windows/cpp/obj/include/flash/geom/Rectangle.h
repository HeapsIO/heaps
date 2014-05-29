#ifndef INCLUDED_flash_geom_Rectangle
#define INCLUDED_flash_geom_Rectangle

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,geom,Matrix)
HX_DECLARE_CLASS2(flash,geom,Point)
HX_DECLARE_CLASS2(flash,geom,Rectangle)
namespace flash{
namespace geom{


class HXCPP_CLASS_ATTRIBUTES  Rectangle_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Rectangle_obj OBJ_;
		Rectangle_obj();
		Void __construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Rectangle_obj > __new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Rectangle_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Rectangle"); }

		Float height;
		Float width;
		Float x;
		Float y;
		virtual ::flash::geom::Rectangle clone( );
		Dynamic clone_dyn();

		virtual bool contains( Float x,Float y);
		Dynamic contains_dyn();

		virtual bool containsPoint( ::flash::geom::Point point);
		Dynamic containsPoint_dyn();

		virtual bool containsRect( ::flash::geom::Rectangle rect);
		Dynamic containsRect_dyn();

		virtual Void copyFrom( ::flash::geom::Rectangle sourceRect);
		Dynamic copyFrom_dyn();

		virtual bool equals( ::flash::geom::Rectangle toCompare);
		Dynamic equals_dyn();

		virtual Void extendBounds( ::flash::geom::Rectangle r);
		Dynamic extendBounds_dyn();

		virtual Void inflate( Float dx,Float dy);
		Dynamic inflate_dyn();

		virtual Void inflatePoint( ::flash::geom::Point point);
		Dynamic inflatePoint_dyn();

		virtual ::flash::geom::Rectangle intersection( ::flash::geom::Rectangle toIntersect);
		Dynamic intersection_dyn();

		virtual bool intersects( ::flash::geom::Rectangle toIntersect);
		Dynamic intersects_dyn();

		virtual bool isEmpty( );
		Dynamic isEmpty_dyn();

		virtual Void offset( Float dx,Float dy);
		Dynamic offset_dyn();

		virtual Void offsetPoint( ::flash::geom::Point point);
		Dynamic offsetPoint_dyn();

		virtual Void setEmpty( );
		Dynamic setEmpty_dyn();

		virtual Void setTo( Float xa,Float ya,Float widtha,Float heighta);
		Dynamic setTo_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::flash::geom::Rectangle transform( ::flash::geom::Matrix m);
		Dynamic transform_dyn();

		virtual ::flash::geom::Rectangle _union( ::flash::geom::Rectangle toUnion);
		Dynamic _union_dyn();

		virtual Float get_bottom( );
		Dynamic get_bottom_dyn();

		virtual Float set_bottom( Float value);
		Dynamic set_bottom_dyn();

		virtual ::flash::geom::Point get_bottomRight( );
		Dynamic get_bottomRight_dyn();

		virtual ::flash::geom::Point set_bottomRight( ::flash::geom::Point value);
		Dynamic set_bottomRight_dyn();

		virtual Float get_left( );
		Dynamic get_left_dyn();

		virtual Float set_left( Float value);
		Dynamic set_left_dyn();

		virtual Float get_right( );
		Dynamic get_right_dyn();

		virtual Float set_right( Float value);
		Dynamic set_right_dyn();

		virtual ::flash::geom::Point get_size( );
		Dynamic get_size_dyn();

		virtual ::flash::geom::Point set_size( ::flash::geom::Point value);
		Dynamic set_size_dyn();

		virtual Float get_top( );
		Dynamic get_top_dyn();

		virtual Float set_top( Float value);
		Dynamic set_top_dyn();

		virtual ::flash::geom::Point get_topLeft( );
		Dynamic get_topLeft_dyn();

		virtual ::flash::geom::Point set_topLeft( ::flash::geom::Point value);
		Dynamic set_topLeft_dyn();

};

} // end namespace flash
} // end namespace geom

#endif /* INCLUDED_flash_geom_Rectangle */ 
