#ifndef INCLUDED_flash_geom_Matrix
#define INCLUDED_flash_geom_Matrix

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,geom,Matrix)
HX_DECLARE_CLASS2(flash,geom,Point)
HX_DECLARE_CLASS2(flash,geom,Vector3D)
namespace flash{
namespace geom{


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
		double __INumField(int inFieldID);
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Matrix"); }

		Float a;
		Float b;
		Float c;
		Float d;
		Float tx;
		Float ty;
		virtual ::flash::geom::Matrix clone( );
		Dynamic clone_dyn();

		virtual Void concat( ::flash::geom::Matrix m);
		Dynamic concat_dyn();

		virtual Void copyColumnFrom( int column,::flash::geom::Vector3D vector3D);
		Dynamic copyColumnFrom_dyn();

		virtual Void copyColumnTo( int column,::flash::geom::Vector3D vector3D);
		Dynamic copyColumnTo_dyn();

		virtual Void copyFrom( ::flash::geom::Matrix other);
		Dynamic copyFrom_dyn();

		virtual Void copyRowFrom( int row,::flash::geom::Vector3D vector3D);
		Dynamic copyRowFrom_dyn();

		virtual Void copyRowTo( int row,::flash::geom::Vector3D vector3D);
		Dynamic copyRowTo_dyn();

		virtual Void createBox( Float scaleX,Float scaleY,hx::Null< Float >  rotation,hx::Null< Float >  tx,hx::Null< Float >  ty);
		Dynamic createBox_dyn();

		virtual Void createGradientBox( Float width,Float height,hx::Null< Float >  rotation,hx::Null< Float >  tx,hx::Null< Float >  ty);
		Dynamic createGradientBox_dyn();

		virtual ::flash::geom::Point deltaTransformPoint( ::flash::geom::Point point);
		Dynamic deltaTransformPoint_dyn();

		virtual Void identity( );
		Dynamic identity_dyn();

		virtual ::flash::geom::Matrix invert( );
		Dynamic invert_dyn();

		virtual ::flash::geom::Matrix mult( ::flash::geom::Matrix m);
		Dynamic mult_dyn();

		virtual Void rotate( Float angle);
		Dynamic rotate_dyn();

		virtual Void scale( Float x,Float y);
		Dynamic scale_dyn();

		virtual Void setRotation( Float angle,hx::Null< Float >  scale);
		Dynamic setRotation_dyn();

		virtual Void setTo( Float a,Float b,Float c,Float d,Float tx,Float ty);
		Dynamic setTo_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::flash::geom::Point transformPoint( ::flash::geom::Point point);
		Dynamic transformPoint_dyn();

		virtual Void translate( Float x,Float y);
		Dynamic translate_dyn();

};

} // end namespace flash
} // end namespace geom

#endif /* INCLUDED_flash_geom_Matrix */ 
