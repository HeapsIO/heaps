#ifndef INCLUDED_hxd_poly2tri_EdgeEvent
#define INCLUDED_hxd_poly2tri_EdgeEvent

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Edge)
HX_DECLARE_CLASS2(hxd,poly2tri,EdgeEvent)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  EdgeEvent_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef EdgeEvent_obj OBJ_;
		EdgeEvent_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< EdgeEvent_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~EdgeEvent_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("EdgeEvent"); }

		::hxd::poly2tri::Edge constrained_edge;
		bool right;
};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_EdgeEvent */ 
