#ifndef INCLUDED_flash_events_Event
#define INCLUDED_flash_events_Event

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,EventPhase)
namespace flash{
namespace events{


class HXCPP_CLASS_ATTRIBUTES  Event_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Event_obj OBJ_;
		Event_obj();
		Void __construct(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Event_obj > __new(::String type,hx::Null< bool >  __o_bubbles,hx::Null< bool >  __o_cancelable);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Event_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Event"); }

		bool __bubbles;
		bool __cancelable;
		Dynamic __currentTarget;
		::flash::events::EventPhase __eventPhase;
		bool __isCancelled;
		bool __isCancelledNow;
		Dynamic __target;
		::String __type;
		virtual ::flash::events::Event clone( );
		Dynamic clone_dyn();

		virtual bool isDefaultPrevented( );
		Dynamic isDefaultPrevented_dyn();

		virtual Void stopImmediatePropagation( );
		Dynamic stopImmediatePropagation_dyn();

		virtual Void stopPropagation( );
		Dynamic stopPropagation_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual bool __getIsCancelled( );
		Dynamic __getIsCancelled_dyn();

		virtual bool __getIsCancelledNow( );
		Dynamic __getIsCancelledNow_dyn();

		virtual Void __setPhase( ::flash::events::EventPhase value);
		Dynamic __setPhase_dyn();

		virtual bool get_bubbles( );
		Dynamic get_bubbles_dyn();

		virtual bool get_cancelable( );
		Dynamic get_cancelable_dyn();

		virtual Dynamic get_currentTarget( );
		Dynamic get_currentTarget_dyn();

		virtual Dynamic set_currentTarget( Dynamic value);
		Dynamic set_currentTarget_dyn();

		virtual ::flash::events::EventPhase get_eventPhase( );
		Dynamic get_eventPhase_dyn();

		virtual Dynamic get_target( );
		Dynamic get_target_dyn();

		virtual Dynamic set_target( Dynamic value);
		Dynamic set_target_dyn();

		virtual ::String get_type( );
		Dynamic get_type_dyn();

		static ::String ACTIVATE;
		static ::String ADDED;
		static ::String ADDED_TO_STAGE;
		static ::String CANCEL;
		static ::String CHANGE;
		static ::String CLOSE;
		static ::String COMPLETE;
		static ::String CONNECT;
		static ::String CONTEXT3D_CREATE;
		static ::String DEACTIVATE;
		static ::String ENTER_FRAME;
		static ::String ID3;
		static ::String INIT;
		static ::String MOUSE_LEAVE;
		static ::String OPEN;
		static ::String REMOVED;
		static ::String REMOVED_FROM_STAGE;
		static ::String RENDER;
		static ::String RESIZE;
		static ::String SCROLL;
		static ::String SELECT;
		static ::String SOUND_COMPLETE;
		static ::String TAB_CHILDREN_CHANGE;
		static ::String TAB_ENABLED_CHANGE;
		static ::String TAB_INDEX_CHANGE;
		static ::String UNLOAD;
};

} // end namespace flash
} // end namespace events

#endif /* INCLUDED_flash_events_Event */ 
