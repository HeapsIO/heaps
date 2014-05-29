#ifndef INCLUDED_h2d__TileGroup_TileLayerContent
#define INCLUDED_h2d__TileGroup_TileLayerContent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/prim/Primitive.h>
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h2d,_TileGroup,TileLayerContent)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
namespace h2d{
namespace _TileGroup{


class HXCPP_CLASS_ATTRIBUTES  TileLayerContent_obj : public ::h3d::prim::Primitive_obj{
	public:
		typedef ::h3d::prim::Primitive_obj super;
		typedef TileLayerContent_obj OBJ_;
		TileLayerContent_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< TileLayerContent_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~TileLayerContent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("TileLayerContent"); }

		Array< Float > tmp;
		Array< ::Dynamic > tiles;
		virtual bool isEmpty( );
		Dynamic isEmpty_dyn();

		virtual Void reset( );
		Dynamic reset_dyn();

		virtual Float getX( int idx);
		Dynamic getX_dyn();

		virtual Float getY( int idx);
		Dynamic getY_dyn();

		virtual Float getWidth( int idx);
		Dynamic getWidth_dyn();

		virtual Float getHeight( int idx);
		Dynamic getHeight_dyn();

		virtual ::h2d::Tile getTile( int idx);
		Dynamic getTile_dyn();

		virtual ::h2d::col::Bounds get2DBounds( int idx);
		Dynamic get2DBounds_dyn();

		virtual Void add( int x,int y,::h2d::Tile t);
		Dynamic add_dyn();

		virtual int triCount( );

		virtual Void alloc( ::h3d::Engine engine);

		virtual Void doRender( ::h3d::Engine engine,int min,int len);
		Dynamic doRender_dyn();

};

} // end namespace h2d
} // end namespace _TileGroup

#endif /* INCLUDED_h2d__TileGroup_TileLayerContent */ 
