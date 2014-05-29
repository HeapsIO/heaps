#ifndef INCLUDED_flash_display_DisplayObjectContainer
#define INCLUDED_flash_display_DisplayObjectContainer

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/display/InteractiveObject.h>
HX_DECLARE_CLASS2(flash,display,DisplayObject)
HX_DECLARE_CLASS2(flash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(flash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(flash,display,InteractiveObject)
HX_DECLARE_CLASS2(flash,events,Event)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,geom,Point)
namespace flash{
namespace display{


class HXCPP_CLASS_ATTRIBUTES  DisplayObjectContainer_obj : public ::flash::display::InteractiveObject_obj{
	public:
		typedef ::flash::display::InteractiveObject_obj super;
		typedef DisplayObjectContainer_obj OBJ_;
		DisplayObjectContainer_obj();
		Void __construct(Dynamic handle,::String type);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< DisplayObjectContainer_obj > __new(Dynamic handle,::String type);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~DisplayObjectContainer_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("DisplayObjectContainer"); }

		int numChildren;
		Array< ::Dynamic > __children;
		virtual ::flash::display::DisplayObject addChild( ::flash::display::DisplayObject child);
		Dynamic addChild_dyn();

		virtual ::flash::display::DisplayObject addChildAt( ::flash::display::DisplayObject child,int index);
		Dynamic addChildAt_dyn();

		virtual bool areInaccessibleObjectsUnderPoint( ::flash::geom::Point point);
		Dynamic areInaccessibleObjectsUnderPoint_dyn();

		virtual bool contains( ::flash::display::DisplayObject child);
		Dynamic contains_dyn();

		virtual ::flash::display::DisplayObject getChildAt( int index);
		Dynamic getChildAt_dyn();

		virtual ::flash::display::DisplayObject getChildByName( ::String name);
		Dynamic getChildByName_dyn();

		virtual int getChildIndex( ::flash::display::DisplayObject child);
		Dynamic getChildIndex_dyn();

		virtual Array< ::Dynamic > getObjectsUnderPoint( ::flash::geom::Point point);
		Dynamic getObjectsUnderPoint_dyn();

		virtual ::flash::display::DisplayObject removeChild( ::flash::display::DisplayObject child);
		Dynamic removeChild_dyn();

		virtual ::flash::display::DisplayObject removeChildAt( int index);
		Dynamic removeChildAt_dyn();

		virtual Void removeChildren( hx::Null< int >  beginIndex,hx::Null< int >  endIndex);
		Dynamic removeChildren_dyn();

		virtual Void setChildIndex( ::flash::display::DisplayObject child,int index);
		Dynamic setChildIndex_dyn();

		virtual Void swapChildren( ::flash::display::DisplayObject child1,::flash::display::DisplayObject child2);
		Dynamic swapChildren_dyn();

		virtual Void swapChildrenAt( int index1,int index2);
		Dynamic swapChildrenAt_dyn();

		virtual Void __addChild( ::flash::display::DisplayObject child);
		Dynamic __addChild_dyn();

		virtual Void __broadcast( ::flash::events::Event event);

		virtual bool __contains( ::flash::display::DisplayObject child);

		virtual ::flash::display::DisplayObject __findByID( int id);

		virtual int __getChildIndex( ::flash::display::DisplayObject child);
		Dynamic __getChildIndex_dyn();

		virtual Void __getObjectsUnderPoint( ::flash::geom::Point point,Array< ::Dynamic > result);

		virtual Void __onAdded( ::flash::display::DisplayObject object,bool isOnStage);

		virtual Void __onRemoved( ::flash::display::DisplayObject object,bool wasOnStage);

		virtual Void __removeChildFromArray( ::flash::display::DisplayObject child);
		Dynamic __removeChildFromArray_dyn();

		virtual Void __setChildIndex( ::flash::display::DisplayObject child,int index);
		Dynamic __setChildIndex_dyn();

		virtual Void __swapChildrenAt( int index1,int index2);
		Dynamic __swapChildrenAt_dyn();

		virtual bool get_mouseChildren( );
		Dynamic get_mouseChildren_dyn();

		virtual bool set_mouseChildren( bool value);
		Dynamic set_mouseChildren_dyn();

		virtual int get_numChildren( );
		Dynamic get_numChildren_dyn();

		virtual bool get_tabChildren( );
		Dynamic get_tabChildren_dyn();

		virtual bool set_tabChildren( bool value);
		Dynamic set_tabChildren_dyn();

		static Dynamic lime_create_display_object_container;
		static Dynamic &lime_create_display_object_container_dyn() { return lime_create_display_object_container;}
		static Dynamic lime_doc_add_child;
		static Dynamic &lime_doc_add_child_dyn() { return lime_doc_add_child;}
		static Dynamic lime_doc_remove_child;
		static Dynamic &lime_doc_remove_child_dyn() { return lime_doc_remove_child;}
		static Dynamic lime_doc_set_child_index;
		static Dynamic &lime_doc_set_child_index_dyn() { return lime_doc_set_child_index;}
		static Dynamic lime_doc_get_mouse_children;
		static Dynamic &lime_doc_get_mouse_children_dyn() { return lime_doc_get_mouse_children;}
		static Dynamic lime_doc_set_mouse_children;
		static Dynamic &lime_doc_set_mouse_children_dyn() { return lime_doc_set_mouse_children;}
		static Dynamic lime_doc_swap_children;
		static Dynamic &lime_doc_swap_children_dyn() { return lime_doc_swap_children;}
};

} // end namespace flash
} // end namespace display

#endif /* INCLUDED_flash_display_DisplayObjectContainer */ 
