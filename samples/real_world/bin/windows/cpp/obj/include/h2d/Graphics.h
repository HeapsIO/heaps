#ifndef INCLUDED_h2d_Graphics
#define INCLUDED_h2d_Graphics

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Drawable.h>
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Graphics)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h2d,_Graphics,GraphicsContent)
HX_DECLARE_CLASS2(h2d,_Graphics,LinePoint)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Graphics_obj : public ::h2d::Drawable_obj{
	public:
		typedef ::h2d::Drawable_obj super;
		typedef Graphics_obj OBJ_;
		Graphics_obj();
		Void __construct(::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Graphics_obj > __new(::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Graphics_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Graphics"); }

		::h2d::_Graphics::GraphicsContent content;
		Array< ::Dynamic > pts;
		Array< ::Dynamic > linePts;
		int pindex;
		Array< ::Dynamic > prev;
		Float curR;
		Float curG;
		Float curB;
		Float curA;
		Float lineSize;
		Float lineR;
		Float lineG;
		Float lineB;
		Float lineA;
		bool doFill;
		::h2d::col::Bounds curBounds;
		::h2d::Tile tile;
		virtual Void onDelete( );

		virtual Void clear( );
		Dynamic clear_dyn();

		virtual bool isConvex( Array< ::Dynamic > points);
		Dynamic isConvex_dyn();

		virtual Void flushLine( );
		Dynamic flushLine_dyn();

		virtual Void flushFill( );
		Dynamic flushFill_dyn();

		virtual Void flush( );
		Dynamic flush_dyn();

		virtual Void beginFill( hx::Null< int >  color,Dynamic alpha);
		Dynamic beginFill_dyn();

		virtual Void lineStyle( hx::Null< Float >  size,hx::Null< int >  color,Dynamic alpha);
		Dynamic lineStyle_dyn();

		virtual Void endFill( );
		Dynamic endFill_dyn();

		virtual Void setColor( int color,Dynamic alpha);
		Dynamic setColor_dyn();

		virtual Void drawRect( Float x,Float y,Float w,Float h);
		Dynamic drawRect_dyn();

		virtual Void drawCircle( Float cx,Float cy,Float ray,hx::Null< int >  nsegments);
		Dynamic drawCircle_dyn();

		virtual Void addHole( );
		Dynamic addHole_dyn();

		virtual Void addPoint( Float x,Float y);
		Dynamic addPoint_dyn();

		virtual Void addPointFull( Float x,Float y,Float r,Float g,Float b,Float a,hx::Null< Float >  u,hx::Null< Float >  v);
		Dynamic addPointFull_dyn();

		virtual ::h2d::col::Bounds getMyBounds( );

		virtual Void draw( ::h3d::scene::RenderContext ctx);

		static Void fromBounds( ::h2d::col::Bounds b,::h2d::Sprite parent,Dynamic col,Dynamic alpha);
		static Dynamic fromBounds_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Graphics */ 
