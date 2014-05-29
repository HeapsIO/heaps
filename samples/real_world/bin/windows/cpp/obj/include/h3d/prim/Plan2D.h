#ifndef INCLUDED_h3d_prim_Plan2D
#define INCLUDED_h3d_prim_Plan2D

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/prim/Primitive.h>
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS2(h3d,prim,Plan2D)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
namespace h3d{
namespace prim{


class HXCPP_CLASS_ATTRIBUTES  Plan2D_obj : public ::h3d::prim::Primitive_obj{
	public:
		typedef ::h3d::prim::Primitive_obj super;
		typedef Plan2D_obj OBJ_;
		Plan2D_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Plan2D_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Plan2D_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Plan2D"); }

		virtual Void alloc( ::h3d::Engine engine);

		virtual Void render( ::h3d::Engine engine);

};

} // end namespace h3d
} // end namespace prim

#endif /* INCLUDED_h3d_prim_Plan2D */ 
