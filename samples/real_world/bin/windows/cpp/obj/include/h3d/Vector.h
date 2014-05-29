#ifndef INCLUDED_h3d_Vector
#define INCLUDED_h3d_Vector

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,col,Point)
namespace h3d{


class HXCPP_CLASS_ATTRIBUTES  Vector_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Vector_obj OBJ_;
		Vector_obj();
		Void __construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Vector_obj > __new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Vector_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Vector"); }

		Float x;
		Float y;
		Float z;
		Float w;
		virtual Float distance( ::h3d::Vector v);
		Dynamic distance_dyn();

		virtual Float distanceSq( ::h3d::Vector v);
		Dynamic distanceSq_dyn();

		virtual ::h3d::Vector sub( ::h3d::Vector v);
		Dynamic sub_dyn();

		virtual ::h3d::Vector add( ::h3d::Vector v);
		Dynamic add_dyn();

		virtual ::h3d::Vector cross( ::h3d::Vector v);
		Dynamic cross_dyn();

		virtual ::h3d::Vector reflect( ::h3d::Vector n);
		Dynamic reflect_dyn();

		virtual Float dot3( ::h3d::Vector v);
		Dynamic dot3_dyn();

		virtual Float dot4( ::h3d::Vector v);
		Dynamic dot4_dyn();

		virtual Float lengthSq( );
		Dynamic lengthSq_dyn();

		virtual Float length( );
		Dynamic length_dyn();

		virtual ::h3d::Vector normalize( );
		Dynamic normalize_dyn();

		virtual ::h3d::Vector safeNormalize( );
		Dynamic safeNormalize_dyn();

		virtual Void set( Float x,Float y,Float z,hx::Null< Float >  w);
		Dynamic set_dyn();

		virtual Void copy( Dynamic v);
		Dynamic copy_dyn();

		virtual Void scale3( Float f);
		Dynamic scale3_dyn();

		virtual Void project( ::h3d::Matrix m);
		Dynamic project_dyn();

		virtual Void lerp( ::h3d::Vector v1,::h3d::Vector v2,Float k);
		Dynamic lerp_dyn();

		virtual Void transform3x4( ::h3d::Matrix m);
		Dynamic transform3x4_dyn();

		virtual Void transform3x3( ::h3d::Matrix m);
		Dynamic transform3x3_dyn();

		virtual Void transform( ::h3d::Matrix m);
		Dynamic transform_dyn();

		virtual Void loadColor( int c,hx::Null< Float >  scale);
		Dynamic loadColor_dyn();

		virtual ::h3d::col::Point toPoint( );
		Dynamic toPoint_dyn();

		virtual int toColor( );
		Dynamic toColor_dyn();

		virtual ::h3d::Vector clone( );
		Dynamic clone_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static ::h3d::Vector fromColor( int c,hx::Null< Float >  scale);
		static Dynamic fromColor_dyn();

};

} // end namespace h3d

#endif /* INCLUDED_h3d_Vector */ 
