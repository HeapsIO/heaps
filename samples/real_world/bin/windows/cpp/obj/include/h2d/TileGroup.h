#ifndef INCLUDED_h2d_TileGroup
#define INCLUDED_h2d_TileGroup

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Drawable.h>
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS1(h2d,TileGroup)
HX_DECLARE_CLASS2(h2d,_TileGroup,TileLayerContent)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  TileGroup_obj : public ::h2d::Drawable_obj{
	public:
		typedef ::h2d::Drawable_obj super;
		typedef TileGroup_obj OBJ_;
		TileGroup_obj();
		Void __construct(::h2d::Tile t,::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< TileGroup_obj > __new(::h2d::Tile t,::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~TileGroup_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("TileGroup"); }

		::h2d::_TileGroup::TileLayerContent content;
		::h2d::Tile tile;
		int rangeMin;
		int rangeMax;
		virtual Void reset( );
		Dynamic reset_dyn();

		virtual Void onDelete( );

		virtual Void add( int x,int y,::h2d::Tile t);
		Dynamic add_dyn();

		virtual ::h2d::col::Bounds getMyBounds( );

		virtual int count( );
		Dynamic count_dyn();

		virtual Void draw( ::h3d::scene::RenderContext ctx);

};

} // end namespace h2d

#endif /* INCLUDED_h2d_TileGroup */ 
