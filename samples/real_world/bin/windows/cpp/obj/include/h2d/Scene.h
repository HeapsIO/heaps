#ifndef INCLUDED_h2d_Scene
#define INCLUDED_h2d_Scene

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Layers.h>
#include <h3d/IDrawable.h>
HX_DECLARE_CLASS1(h2d,Bitmap)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Interactive)
HX_DECLARE_CLASS1(h2d,Layers)
HX_DECLARE_CLASS1(h2d,Scene)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS1(h3d,IDrawable)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
HX_DECLARE_CLASS1(hxd,Event)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Scene_obj : public ::h2d::Layers_obj{
	public:
		typedef ::h2d::Layers_obj super;
		typedef Scene_obj OBJ_;
		Scene_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Scene_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Scene_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		inline operator ::h3d::IDrawable_obj *()
			{ return new ::h3d::IDrawable_delegate_< Scene_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		::String __ToString() const { return HX_CSTRING("Scene"); }

		bool fixedSize;
		Array< ::Dynamic > interactive;
		Array< ::Dynamic > pendingEvents;
		::h3d::scene::RenderContext ctx;
		::h2d::Interactive currentOver;
		::h2d::Interactive currentFocus;
		Array< ::Dynamic > pushList;
		Dynamic currentDrag;
		Dynamic eventListeners;
		virtual Void setFixedSize( Float w,Float h);
		Dynamic setFixedSize_dyn();

		virtual Void onAlloc( );

		virtual Void onDelete( );

		virtual Void onEvent( ::hxd::Event e);
		Dynamic onEvent_dyn();

		virtual Float screenXToLocal( Float mx);
		Dynamic screenXToLocal_dyn();

		virtual Float screenYToLocal( Float my);
		Dynamic screenYToLocal_dyn();

		virtual Float get_mouseX( );

		virtual Float get_mouseY( );

		virtual Float set_width( Float w);

		virtual Float set_height( Float h);

		virtual Float get_width( );

		virtual Float get_height( );

		virtual Void dispatchListeners( ::hxd::Event event);
		Dynamic dispatchListeners_dyn();

		virtual Void emitEvent( ::hxd::Event event);
		Dynamic emitEvent_dyn();

		virtual bool hasEvents( );
		Dynamic hasEvents_dyn();

		virtual Void checkEvents( );
		Dynamic checkEvents_dyn();

		virtual Void addEventListener( Dynamic f);
		Dynamic addEventListener_dyn();

		virtual bool removeEventListener( Dynamic f);
		Dynamic removeEventListener_dyn();

		virtual Void startDrag( Dynamic f,Dynamic onCancel,::hxd::Event refEvent);
		Dynamic startDrag_dyn();

		virtual Void stopDrag( );
		Dynamic stopDrag_dyn();

		virtual ::h2d::Interactive getFocus( );
		Dynamic getFocus_dyn();

		virtual Void addEventTarget( ::h2d::Interactive i);
		Dynamic addEventTarget_dyn();

		virtual Void removeEventTarget( ::h2d::Interactive i);
		Dynamic removeEventTarget_dyn();

		virtual Void calcAbsPos( );

		virtual Void dispose( );

		virtual Void setElapsedTime( Float v);
		Dynamic setElapsedTime_dyn();

		virtual Void render( ::h3d::Engine engine);
		Dynamic render_dyn();

		virtual Void sync( ::h3d::scene::RenderContext ctx);

		virtual ::h2d::Bitmap captureBitmap( ::h2d::Tile target,Dynamic bindDepth);
		Dynamic captureBitmap_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Scene */ 
