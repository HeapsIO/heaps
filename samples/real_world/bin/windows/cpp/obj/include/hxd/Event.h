#ifndef INCLUDED_hxd_Event
#define INCLUDED_hxd_Event

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,Event)
HX_DECLARE_CLASS1(hxd,EventKind)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Event_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Event_obj OBJ_;
		Event_obj();
		Void __construct(::hxd::EventKind k,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Event_obj > __new(::hxd::EventKind k,hx::Null< Float >  __o_x,hx::Null< Float >  __o_y);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Event_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Event"); }

		::hxd::EventKind kind;
		Float relX;
		Float relY;
		bool propagate;
		bool cancel;
		int button;
		int touchId;
		int keyCode;
		int charCode;
		Float wheelDelta;
		virtual ::String toString( );
		Dynamic toString_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Event */ 
