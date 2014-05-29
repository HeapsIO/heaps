#ifndef INCLUDED_flash_geom_Vector3D
#define INCLUDED_flash_geom_Vector3D

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,geom,Vector3D)
namespace flash{
namespace geom{


class HXCPP_CLASS_ATTRIBUTES  Vector3D_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Vector3D_obj OBJ_;
		Vector3D_obj();
		Void __construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Vector3D_obj > __new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Vector3D_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Vector3D"); }

		Float length;
		Float lengthSquared;
		Float w;
		Float x;
		Float y;
		Float z;
		virtual ::flash::geom::Vector3D add( ::flash::geom::Vector3D a);
		Dynamic add_dyn();

		virtual ::flash::geom::Vector3D clone( );
		Dynamic clone_dyn();

		virtual Void copyFrom( ::flash::geom::Vector3D sourceVector3D);
		Dynamic copyFrom_dyn();

		virtual ::flash::geom::Vector3D crossProduct( ::flash::geom::Vector3D a);
		Dynamic crossProduct_dyn();

		virtual Void decrementBy( ::flash::geom::Vector3D a);
		Dynamic decrementBy_dyn();

		virtual Float dotProduct( ::flash::geom::Vector3D a);
		Dynamic dotProduct_dyn();

		virtual bool equals( ::flash::geom::Vector3D toCompare,hx::Null< bool >  allFour);
		Dynamic equals_dyn();

		virtual Void incrementBy( ::flash::geom::Vector3D a);
		Dynamic incrementBy_dyn();

		virtual bool nearEquals( ::flash::geom::Vector3D toCompare,Float tolerance,hx::Null< bool >  allFour);
		Dynamic nearEquals_dyn();

		virtual Void negate( );
		Dynamic negate_dyn();

		virtual Float normalize( );
		Dynamic normalize_dyn();

		virtual Void project( );
		Dynamic project_dyn();

		virtual Void setTo( Float xa,Float ya,Float za);
		Dynamic setTo_dyn();

		virtual Void scaleBy( Float s);
		Dynamic scaleBy_dyn();

		virtual ::flash::geom::Vector3D subtract( ::flash::geom::Vector3D a);
		Dynamic subtract_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual Float get_length( );
		Dynamic get_length_dyn();

		virtual Float get_lengthSquared( );
		Dynamic get_lengthSquared_dyn();

		static ::flash::geom::Vector3D X_AXIS;
		static ::flash::geom::Vector3D Y_AXIS;
		static ::flash::geom::Vector3D Z_AXIS;
		static Float angleBetween( ::flash::geom::Vector3D a,::flash::geom::Vector3D b);
		static Dynamic angleBetween_dyn();

		static Float distance( ::flash::geom::Vector3D pt1,::flash::geom::Vector3D pt2);
		static Dynamic distance_dyn();

		static ::flash::geom::Vector3D get_X_AXIS( );
		static Dynamic get_X_AXIS_dyn();

		static ::flash::geom::Vector3D get_Y_AXIS( );
		static Dynamic get_Y_AXIS_dyn();

		static ::flash::geom::Vector3D get_Z_AXIS( );
		static Dynamic get_Z_AXIS_dyn();

};

} // end namespace flash
} // end namespace geom

#endif /* INCLUDED_flash_geom_Vector3D */ 
