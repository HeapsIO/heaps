#ifndef INCLUDED_openfl_display_ManagedStage
#define INCLUDED_openfl_display_ManagedStage

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/display/Stage.h>
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,display,Stage)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(openfl,display,ManagedStage)
namespace openfl{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  ManagedStage_obj : public ::flash::display::Stage_obj{
	public:
		typedef ::flash::display::Stage_obj super;
		typedef ManagedStage_obj OBJ_;
		ManagedStage_obj();
		Void __construct(int width,int height,hx::Null< int >  __o_flags);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ManagedStage_obj > __new(int width,int height,hx::Null< int >  __o_flags);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ManagedStage_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("ManagedStage"); }

		Dynamic beginRender;
		inline Dynamic &beginRender_dyn() {return beginRender; }

		Dynamic endRender;
		inline Dynamic &endRender_dyn() {return endRender; }

		virtual Void pumpEvent( Dynamic event);
		Dynamic pumpEvent_dyn();

		virtual Void resize( int width,int height);

		virtual Void sendQuit( );
		Dynamic sendQuit_dyn();

		Dynamic setNextWake;
		inline Dynamic &setNextWake_dyn() {return setNextWake; }

		virtual Float __doProcessStageEvent( Dynamic event);

		virtual Void __render( bool sendEnterFrame);

		static int etUnknown;
		static int etKeyDown;
		static int etChar;
		static int etKeyUp;
		static int etMouseMove;
		static int etMouseDown;
		static int etMouseClick;
		static int etMouseUp;
		static int etResize;
		static int etPoll;
		static int etQuit;
		static int etFocus;
		static int etShouldRotate;
		static int etDestroyHandler;
		static int etRedraw;
		static int etTouchBegin;
		static int etTouchMove;
		static int etTouchEnd;
		static int etTouchTap;
		static int etChange;
		static int efLeftDown;
		static int efShiftDown;
		static int efCtrlDown;
		static int efAltDown;
		static int efCommandDown;
		static int efMiddleDown;
		static int efRightDown;
		static int efLocationRight;
		static int efPrimaryTouch;
		static Dynamic lime_managed_stage_create;
		static Dynamic &lime_managed_stage_create_dyn() { return lime_managed_stage_create;}
		static Dynamic lime_managed_stage_pump_event;
		static Dynamic &lime_managed_stage_pump_event_dyn() { return lime_managed_stage_pump_event;}
};

} // end namespace openfl
} // end namespace display

#endif /* INCLUDED_openfl_display_ManagedStage */ 
