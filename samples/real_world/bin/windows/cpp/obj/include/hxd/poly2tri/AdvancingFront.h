#ifndef INCLUDED_hxd_poly2tri_AdvancingFront
#define INCLUDED_hxd_poly2tri_AdvancingFront

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,AdvancingFront)
HX_DECLARE_CLASS2(hxd,poly2tri,Node)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  AdvancingFront_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AdvancingFront_obj OBJ_;
		AdvancingFront_obj();
		Void __construct(::hxd::poly2tri::Node head,::hxd::poly2tri::Node tail);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< AdvancingFront_obj > __new(::hxd::poly2tri::Node head,::hxd::poly2tri::Node tail);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~AdvancingFront_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("AdvancingFront"); }

		::hxd::poly2tri::Node head;
		::hxd::poly2tri::Node tail;
		::hxd::poly2tri::Node search_node;
		virtual ::hxd::poly2tri::Node locateNode( Float x);
		Dynamic locateNode_dyn();

		virtual ::hxd::poly2tri::Node locatePoint( ::hxd::poly2tri::Point point);
		Dynamic locatePoint_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_AdvancingFront */ 
