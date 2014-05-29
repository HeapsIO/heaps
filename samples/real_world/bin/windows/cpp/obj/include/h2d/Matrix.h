#ifndef INCLUDED_h2d_Matrix
#define INCLUDED_h2d_Matrix

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,Matrix)
HX_DECLARE_CLASS2(h2d,col,Point)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Matrix_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Matrix_obj OBJ_;
		Matrix_obj();
		Void __construct(hx::Null< Float >  __o_a,hx::Null< Float >  __o_b,hx::Null< Float >  __o_c,hx::Null< Float >  __o_d,hx::Null< Float >  __o_tx,hx::Null< Float >  __o_ty);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Matrix_obj > __new(hx::Null< Float >  __o_a,hx::Null< Float >  __o_b,hx::Null< Float >  __o_c,hx::Null< Float >  __o_d,hx::Null< Float >  __o_tx,hx::Null< Float >  __o_ty);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Matrix_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Matrix"); }

		Float a;
		Float b;
		Float c;
		Float d;
		Float tx;
		Float ty;
		virtual Void zero( );
		Dynamic zero_dyn();

		virtual Void identity( );
		Dynamic identity_dyn();

		virtual Void setTo( hx::Null< Float >  a,hx::Null< Float >  b,hx::Null< Float >  c,hx::Null< Float >  d,hx::Null< Float >  tx,hx::Null< Float >  ty);
		Dynamic setTo_dyn();

		virtual ::h2d::Matrix invert( );
		Dynamic invert_dyn();

		virtual Void rotate( Float angle);
		Dynamic rotate_dyn();

		virtual Void scale( Float x,Float y);
		Dynamic scale_dyn();

		virtual Void skew( Float x,Float y);
		Dynamic skew_dyn();

		virtual Void makeSkew( Float x,Float y);
		Dynamic makeSkew_dyn();

		virtual Void setRotation( Float angle,hx::Null< Float >  scale);
		Dynamic setRotation_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::h2d::col::Point transformPoint( ::h2d::col::Point point);
		Dynamic transformPoint_dyn();

		virtual Void concat( ::h2d::Matrix m);
		Dynamic concat_dyn();

		virtual Void concat22( ::h2d::Matrix m);
		Dynamic concat22_dyn();

		virtual Void concat32( Float ma,Float mb,Float mc,Float md,Float mtx,Float mty);
		Dynamic concat32_dyn();

		virtual ::h2d::col::Point transformPoint2( Float pointx,Float pointy,::h2d::col::Point res);
		Dynamic transformPoint2_dyn();

		virtual Float transformX( Float px,Float py);
		Dynamic transformX_dyn();

		virtual Float transformY( Float px,Float py);
		Dynamic transformY_dyn();

		virtual Void translate( Float x,Float y);
		Dynamic translate_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Matrix */ 
