#ifndef INCLUDED_h2d__Graphics_GraphicsContent
#define INCLUDED_h2d__Graphics_GraphicsContent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/prim/Primitive.h>
HX_DECLARE_CLASS2(h2d,_Graphics,GraphicsContent)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
namespace h2d{
namespace _Graphics{


class HXCPP_CLASS_ATTRIBUTES  GraphicsContent_obj : public ::h3d::prim::Primitive_obj{
	public:
		typedef ::h3d::prim::Primitive_obj super;
		typedef GraphicsContent_obj OBJ_;
		GraphicsContent_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GraphicsContent_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GraphicsContent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("GraphicsContent"); }

		Array< Float > tmp;
		Array< int > index;
		Dynamic buffers;
		virtual Void addIndex( int i);
		Dynamic addIndex_dyn();

		virtual Void add( Float x,Float y,Float u,Float v,Float r,Float g,Float b,Float a);
		Dynamic add_dyn();

		virtual bool next( );
		Dynamic next_dyn();

		virtual Void alloc( ::h3d::Engine engine);

		virtual Void render( ::h3d::Engine engine);

		virtual Void dispose( );

		virtual Void reset( );
		Dynamic reset_dyn();

};

} // end namespace h2d
} // end namespace _Graphics

#endif /* INCLUDED_h2d__Graphics_GraphicsContent */ 
