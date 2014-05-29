#ifndef INCLUDED_h3d_Quat
#define INCLUDED_h3d_Quat

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Quat)
HX_DECLARE_CLASS1(h3d,Vector)
namespace h3d{


class HXCPP_CLASS_ATTRIBUTES  Quat_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Quat_obj OBJ_;
		Quat_obj();
		Void __construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Quat_obj > __new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Quat_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Quat"); }

		Float x;
		Float y;
		Float z;
		Float w;
		virtual Void set( Float x,Float y,Float z,Float w);
		Dynamic set_dyn();

		virtual Void identity( );
		Dynamic identity_dyn();

		virtual Float lengthSq( );
		Dynamic lengthSq_dyn();

		virtual Float length( );
		Dynamic length_dyn();

		virtual ::h3d::Quat clone( );
		Dynamic clone_dyn();

		virtual Void initDirection( ::h3d::Vector dir,::h3d::Vector up);
		Dynamic initDirection_dyn();

		virtual Void initRotateAxis( Float x,Float y,Float z,Float a);
		Dynamic initRotateAxis_dyn();

		virtual Void initRotateMatrix( ::h3d::Matrix m);
		Dynamic initRotateMatrix_dyn();

		virtual Void normalize( );
		Dynamic normalize_dyn();

		virtual Void initRotate( Float ax,Float ay,Float az);
		Dynamic initRotate_dyn();

		virtual Void add( ::h3d::Quat q);
		Dynamic add_dyn();

		virtual Void multiply( ::h3d::Quat q1,::h3d::Quat q2);
		Dynamic multiply_dyn();

		virtual ::h3d::Matrix toMatrix( );
		Dynamic toMatrix_dyn();

		virtual ::h3d::Vector toEuler( );
		Dynamic toEuler_dyn();

		virtual Void lerp( ::h3d::Quat q1,::h3d::Quat q2,Float v,hx::Null< bool >  nearest);
		Dynamic lerp_dyn();

		virtual Void slerp( ::h3d::Quat q1,::h3d::Quat q2,Float v);
		Dynamic slerp_dyn();

		virtual Void conjugate( );
		Dynamic conjugate_dyn();

		virtual Void negate( );
		Dynamic negate_dyn();

		virtual Float dot( ::h3d::Quat q);
		Dynamic dot_dyn();

		virtual ::h3d::Matrix saveToMatrix( ::h3d::Matrix m);
		Dynamic saveToMatrix_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace h3d

#endif /* INCLUDED_h3d_Quat */ 
