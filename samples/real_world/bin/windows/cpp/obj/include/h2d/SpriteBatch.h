#ifndef INCLUDED_h2d_SpriteBatch
#define INCLUDED_h2d_SpriteBatch

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Drawable.h>
HX_DECLARE_CLASS1(h2d,BatchElement)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Matrix)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,SpriteBatch)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  SpriteBatch_obj : public ::h2d::Drawable_obj{
	public:
		typedef ::h2d::Drawable_obj super;
		typedef SpriteBatch_obj OBJ_;
		SpriteBatch_obj();
		Void __construct(::h2d::Tile masterTile,::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< SpriteBatch_obj > __new(::h2d::Tile masterTile,::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~SpriteBatch_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("SpriteBatch"); }

		::h2d::Tile tile;
		bool hasRotationScale;
		bool hasVertexColor;
		bool hasVertexAlpha;
		::h2d::BatchElement first;
		::h2d::BatchElement last;
		int length;
		Array< Float > tmpBuf;
		virtual Void dispose( );

		virtual bool set_hasVertexColor( bool b);
		Dynamic set_hasVertexColor_dyn();

		virtual bool set_hasVertexAlpha( bool b);
		Dynamic set_hasVertexAlpha_dyn();

		virtual ::h2d::BatchElement add( ::h2d::BatchElement e,Dynamic prio);
		Dynamic add_dyn();

		virtual ::h2d::BatchElement alloc( ::h2d::Tile t,Dynamic prio);
		Dynamic alloc_dyn();

		virtual Void _delete( ::h2d::BatchElement e);
		Dynamic _delete_dyn();

		virtual ::h2d::col::Bounds getMyBounds( );

		virtual int pushElemSRT( Array< Float > tmp,::h2d::BatchElement e,int pos);
		Dynamic pushElemSRT_dyn();

		virtual int pushElem( Array< Float > tmp,::h2d::BatchElement e,int pos);
		Dynamic pushElem_dyn();

		::h2d::Matrix tmpMatrix;
		virtual Void draw( ::h3d::scene::RenderContext ctx);

		virtual Dynamic getElements( );
		Dynamic getElements_dyn();

		virtual bool isEmpty( );
		Dynamic isEmpty_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_SpriteBatch */ 
