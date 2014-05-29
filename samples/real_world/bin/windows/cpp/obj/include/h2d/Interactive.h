#ifndef INCLUDED_h2d_Interactive
#define INCLUDED_h2d_Interactive

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Drawable.h>
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Interactive)
HX_DECLARE_CLASS1(h2d,Layers)
HX_DECLARE_CLASS1(h2d,Scene)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h3d,IDrawable)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
HX_DECLARE_CLASS1(hxd,Cursor)
HX_DECLARE_CLASS1(hxd,Event)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Interactive_obj : public ::h2d::Drawable_obj{
	public:
		typedef ::h2d::Drawable_obj super;
		typedef Interactive_obj OBJ_;
		Interactive_obj();
		Void __construct(Float width,Float height,::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Interactive_obj > __new(Float width,Float height,::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Interactive_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Interactive"); }

		::hxd::Cursor cursor;
		bool isEllipse;
		bool blockEvents;
		bool propagateEvents;
		Dynamic backgroundColor;
		bool enableRightButton;
		::h2d::Scene scene;
		int isMouseDown;
		virtual Float set_width( Float w);

		virtual Float set_height( Float h);

		virtual Float get_width( );

		virtual Float get_height( );

		virtual Void onAlloc( );

		virtual Void draw( ::h3d::scene::RenderContext ctx);

		virtual Void onParentChanged( );

		virtual Void calcAbsPos( );

		virtual Void onDelete( );

		virtual bool checkBounds( ::hxd::Event e);
		Dynamic checkBounds_dyn();

		virtual Void handleEvent( ::hxd::Event e);
		Dynamic handleEvent_dyn();

		virtual ::hxd::Cursor set_cursor( ::hxd::Cursor c);
		Dynamic set_cursor_dyn();

		virtual Void eventToLocal( ::hxd::Event e);
		Dynamic eventToLocal_dyn();

		virtual Void startDrag( Dynamic callb,Dynamic onCancel);
		Dynamic startDrag_dyn();

		virtual Void stopDrag( );
		Dynamic stopDrag_dyn();

		virtual Void focus( );
		Dynamic focus_dyn();

		virtual Void blur( );
		Dynamic blur_dyn();

		virtual bool hasFocus( );
		Dynamic hasFocus_dyn();

		Dynamic onOver;
		inline Dynamic &onOver_dyn() {return onOver; }

		Dynamic onOut;
		inline Dynamic &onOut_dyn() {return onOut; }

		Dynamic onPush;
		inline Dynamic &onPush_dyn() {return onPush; }

		Dynamic onRelease;
		inline Dynamic &onRelease_dyn() {return onRelease; }

		Dynamic onClick;
		inline Dynamic &onClick_dyn() {return onClick; }

		Dynamic onMove;
		inline Dynamic &onMove_dyn() {return onMove; }

		Dynamic onWheel;
		inline Dynamic &onWheel_dyn() {return onWheel; }

		Dynamic onFocus;
		inline Dynamic &onFocus_dyn() {return onFocus; }

		Dynamic onFocusLost;
		inline Dynamic &onFocusLost_dyn() {return onFocusLost; }

		Dynamic onKeyUp;
		inline Dynamic &onKeyUp_dyn() {return onKeyUp; }

		Dynamic onKeyDown;
		inline Dynamic &onKeyDown_dyn() {return onKeyDown; }

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Interactive */ 
