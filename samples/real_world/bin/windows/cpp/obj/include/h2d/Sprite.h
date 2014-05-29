#ifndef INCLUDED_h2d_Sprite
#define INCLUDED_h2d_Sprite

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,display,Stage)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS1(h2d,Bitmap)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Layers)
HX_DECLARE_CLASS1(h2d,Matrix)
HX_DECLARE_CLASS1(h2d,Scene)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS2(h2d,col,Bounds)
HX_DECLARE_CLASS2(h2d,col,Point)
HX_DECLARE_CLASS1(h3d,IDrawable)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
HX_DECLARE_CLASS1(hxd,Stage)
HX_DECLARE_CLASS2(hxd,impl,ArrayIterator)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Sprite_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Sprite_obj OBJ_;
		Sprite_obj();
		Void __construct(::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Sprite_obj > __new(::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Sprite_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Sprite"); }

		::String name;
		Array< ::Dynamic > childs;
		::h2d::Sprite parent;
		Float x;
		Float y;
		Float scaleX;
		Float scaleY;
		Float skewX;
		Float skewY;
		Float rotation;
		bool visible;
		Float matA;
		Float matB;
		Float matC;
		Float matD;
		Float absX;
		Float absY;
		bool posChanged;
		bool allocated;
		int lastFrame;
		::h2d::Matrix pixSpaceMatrix;
		Float mouseX;
		Float mouseY;
		Float width;
		Float height;
		::hxd::Stage stage;
		virtual int getSpritesCount( );
		Dynamic getSpritesCount_dyn();

		virtual bool set_posChanged( bool v);
		Dynamic set_posChanged_dyn();

		virtual ::h2d::col::Point localToGlobal( ::h2d::col::Point pt);
		Dynamic localToGlobal_dyn();

		virtual ::h2d::col::Point globalToLocal( ::h2d::col::Point pt);
		Dynamic globalToLocal_dyn();

		virtual ::h2d::Scene getScene( );
		Dynamic getScene_dyn();

		virtual Void addChild( ::h2d::Sprite s);
		Dynamic addChild_dyn();

		virtual Void addChildAt( ::h2d::Sprite s,int pos);
		Dynamic addChildAt_dyn();

		virtual Void onParentChanged( );
		Dynamic onParentChanged_dyn();

		virtual Void onAlloc( );
		Dynamic onAlloc_dyn();

		virtual Void onDelete( );
		Dynamic onDelete_dyn();

		virtual Void removeChild( ::h2d::Sprite s);
		Dynamic removeChild_dyn();

		virtual Void removeAllChildren( );
		Dynamic removeAllChildren_dyn();

		virtual Void remove( );
		Dynamic remove_dyn();

		virtual Void draw( ::h3d::scene::RenderContext ctx);
		Dynamic draw_dyn();

		virtual Void cachePixSpaceMatrix( );
		Dynamic cachePixSpaceMatrix_dyn();

		virtual Void sync( ::h3d::scene::RenderContext ctx);
		Dynamic sync_dyn();

		virtual Void syncPos( );
		Dynamic syncPos_dyn();

		virtual ::h2d::Matrix getPixSpaceMatrix( ::h2d::Matrix m,::h2d::Tile tile);
		Dynamic getPixSpaceMatrix_dyn();

		virtual Void calcAbsPos( );
		Dynamic calcAbsPos_dyn();

		virtual Void drawRec( ::h3d::scene::RenderContext ctx);
		Dynamic drawRec_dyn();

		virtual Float set_x( Float v);
		Dynamic set_x_dyn();

		virtual Float set_y( Float v);
		Dynamic set_y_dyn();

		virtual Float set_scaleX( Float v);
		Dynamic set_scaleX_dyn();

		virtual Float set_scaleY( Float v);
		Dynamic set_scaleY_dyn();

		virtual Float set_skewX( Float v);
		Dynamic set_skewX_dyn();

		virtual Float set_skewY( Float v);
		Dynamic set_skewY_dyn();

		virtual Float set_rotation( Float v);
		Dynamic set_rotation_dyn();

		virtual Void move( Float dx,Float dy);
		Dynamic move_dyn();

		virtual Void setPos( Float x,Float y);
		Dynamic setPos_dyn();

		virtual Void rotate( Float v);
		Dynamic rotate_dyn();

		virtual Void scale( Float v);
		Dynamic scale_dyn();

		virtual Void setScale( Float v);
		Dynamic setScale_dyn();

		virtual ::h2d::Sprite getChildAt( int n);
		Dynamic getChildAt_dyn();

		virtual int getChildIndex( ::h2d::Sprite s);
		Dynamic getChildIndex_dyn();

		virtual Void toBack( );
		Dynamic toBack_dyn();

		virtual Void toFront( );
		Dynamic toFront_dyn();

		virtual Void setChildIndex( ::h2d::Sprite c,int idx);
		Dynamic setChildIndex_dyn();

		virtual int get_numChildren( );
		Dynamic get_numChildren_dyn();

		virtual ::hxd::impl::ArrayIterator iterator( );
		Dynamic iterator_dyn();

		virtual ::h2d::col::Bounds getMyBounds( );
		Dynamic getMyBounds_dyn();

		virtual Array< ::Dynamic > getChildrenBounds( );
		Dynamic getChildrenBounds_dyn();

		virtual Float set_width( Float v);
		Dynamic set_width_dyn();

		virtual Float set_height( Float h);
		Dynamic set_height_dyn();

		virtual Float get_width( );
		Dynamic get_width_dyn();

		virtual Float get_height( );
		Dynamic get_height_dyn();

		virtual ::h2d::col::Bounds getBounds( );
		Dynamic getBounds_dyn();

		::flash::display::Stage flashStage;
		virtual ::flash::display::Stage get_flashStage( );
		Dynamic get_flashStage_dyn();

		virtual ::hxd::Stage get_stage( );
		Dynamic get_stage_dyn();

		virtual int detach( );
		Dynamic detach_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		virtual Float get_mouseX( );
		Dynamic get_mouseX_dyn();

		virtual Float get_mouseY( );
		Dynamic get_mouseY_dyn();

		static ::h2d::Bitmap fromSprite( ::flash::display::DisplayObject v,::h2d::Sprite parent);
		static Dynamic fromSprite_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Sprite */ 
