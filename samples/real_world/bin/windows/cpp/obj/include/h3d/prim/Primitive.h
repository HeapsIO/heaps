#ifndef INCLUDED_h3d_prim_Primitive
#define INCLUDED_h3d_prim_Primitive

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS2(h3d,col,Bounds)
HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(h3d,impl,Indexes)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
namespace h3d{
namespace prim{


class HXCPP_CLASS_ATTRIBUTES  Primitive_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Primitive_obj OBJ_;
		Primitive_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Primitive_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Primitive_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Primitive"); }

		::h3d::impl::Buffer buffer;
		::h3d::impl::Indexes indexes;
		virtual int triCount( );
		Dynamic triCount_dyn();

		virtual ::h3d::col::Bounds getBounds( );
		Dynamic getBounds_dyn();

		virtual Void alloc( ::h3d::Engine engine);
		Dynamic alloc_dyn();

		virtual Void selectMaterial( int material);
		Dynamic selectMaterial_dyn();

		virtual Void render( ::h3d::Engine engine);
		Dynamic render_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

};

} // end namespace h3d
} // end namespace prim

#endif /* INCLUDED_h3d_prim_Primitive */ 
