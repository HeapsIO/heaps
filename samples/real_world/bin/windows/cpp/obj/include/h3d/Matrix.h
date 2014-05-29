#ifndef INCLUDED_h3d_Matrix
#define INCLUDED_h3d_Matrix

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
namespace h3d{


class HXCPP_CLASS_ATTRIBUTES  Matrix_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Matrix_obj OBJ_;
		Matrix_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Matrix_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Matrix_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Matrix"); }

		Float _11;
		Float _12;
		Float _13;
		Float _14;
		Float _21;
		Float _22;
		Float _23;
		Float _24;
		Float _31;
		Float _32;
		Float _33;
		Float _34;
		Float _41;
		Float _42;
		Float _43;
		Float _44;
		virtual Void set( Float _11,Float _12,Float _13,Float _14,Float _21,Float _22,Float _23,Float _24,Float _31,Float _32,Float _33,Float _34,Float _41,Float _42,Float _43,Float _44);
		Dynamic set_dyn();

		virtual Void zero( );
		Dynamic zero_dyn();

		virtual Void identity( );
		Dynamic identity_dyn();

		virtual Void initRotateX( Float a);
		Dynamic initRotateX_dyn();

		virtual Void initRotateY( Float a);
		Dynamic initRotateY_dyn();

		virtual Void initRotateZ( Float a);
		Dynamic initRotateZ_dyn();

		virtual Void initTranslate( hx::Null< Float >  x,hx::Null< Float >  y,hx::Null< Float >  z);
		Dynamic initTranslate_dyn();

		virtual Void initScale( hx::Null< Float >  x,hx::Null< Float >  y,hx::Null< Float >  z);
		Dynamic initScale_dyn();

		virtual Void initRotateAxis( ::h3d::Vector axis,Float angle);
		Dynamic initRotateAxis_dyn();

		virtual Void initRotate( Float x,Float y,Float z);
		Dynamic initRotate_dyn();

		virtual Void translate( hx::Null< Float >  x,hx::Null< Float >  y,hx::Null< Float >  z);
		Dynamic translate_dyn();

		virtual Void scale( hx::Null< Float >  x,hx::Null< Float >  y,hx::Null< Float >  z);
		Dynamic scale_dyn();

		virtual Void rotate( Float x,Float y,Float z);
		Dynamic rotate_dyn();

		virtual Void rotateAxis( ::h3d::Vector axis,Float angle);
		Dynamic rotateAxis_dyn();

		virtual Void add( ::h3d::Matrix m);
		Dynamic add_dyn();

		virtual Void prependTranslate( hx::Null< Float >  x,hx::Null< Float >  y,hx::Null< Float >  z);
		Dynamic prependTranslate_dyn();

		virtual Void prependRotate( Float x,Float y,Float z);
		Dynamic prependRotate_dyn();

		virtual Void prependRotateAxis( ::h3d::Vector axis,Float angle);
		Dynamic prependRotateAxis_dyn();

		virtual Void prependScale( hx::Null< Float >  sx,hx::Null< Float >  sy,hx::Null< Float >  sz);
		Dynamic prependScale_dyn();

		virtual Void multiply3x4( ::h3d::Matrix a,::h3d::Matrix b);
		Dynamic multiply3x4_dyn();

		virtual Void multiply( ::h3d::Matrix a,::h3d::Matrix b);
		Dynamic multiply_dyn();

		virtual Void invert( );
		Dynamic invert_dyn();

		virtual Void inverse3x4( ::h3d::Matrix m);
		Dynamic inverse3x4_dyn();

		virtual Void inverse( ::h3d::Matrix m);
		Dynamic inverse_dyn();

		virtual Void transpose( );
		Dynamic transpose_dyn();

		virtual ::h3d::Matrix clone( );
		Dynamic clone_dyn();

		virtual Void loadFrom( ::h3d::Matrix m);
		Dynamic loadFrom_dyn();

		virtual Void load( Array< Float > a);
		Dynamic load_dyn();

		virtual Array< Float > getFloats( );
		Dynamic getFloats_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual Void colorHue( Float hue);
		Dynamic colorHue_dyn();

		virtual Void colorSaturation( Float sat);
		Dynamic colorSaturation_dyn();

		virtual Void colorContrast( Float contrast);
		Dynamic colorContrast_dyn();

		virtual Void colorBrightness( Float brightness);
		Dynamic colorBrightness_dyn();

		virtual ::h3d::Vector pos( ::h3d::Vector v);
		Dynamic pos_dyn();

		virtual ::h3d::Vector at( ::h3d::Vector v);
		Dynamic at_dyn();

		virtual ::h3d::Vector up( ::h3d::Vector v);
		Dynamic up_dyn();

		virtual ::h3d::Vector right( ::h3d::Vector v);
		Dynamic right_dyn();

		virtual Void makeOrtho( hx::Null< Float >  width,hx::Null< Float >  height,hx::Null< int >  znear,hx::Null< Float >  zfar);
		Dynamic makeOrtho_dyn();

		static ::h3d::Matrix tmp;
		static Float lumR;
		static Float lumG;
		static Float lumB;
		static ::h3d::Matrix I( );
		static Dynamic I_dyn();

		static ::h3d::Matrix L( Array< Float > a);
		static Dynamic L_dyn();

		static ::h3d::Matrix T( hx::Null< Float >  x,hx::Null< Float >  y,hx::Null< Float >  z);
		static Dynamic T_dyn();

		static ::h3d::Matrix R( Float x,Float y,Float z);
		static Dynamic R_dyn();

		static ::h3d::Matrix S( hx::Null< Float >  x,hx::Null< Float >  y,hx::Null< Float >  z);
		static Dynamic S_dyn();

};

} // end namespace h3d

#endif /* INCLUDED_h3d_Matrix */ 
