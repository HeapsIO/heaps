#ifndef INCLUDED_hxd_poly2tri_Node
#define INCLUDED_hxd_poly2tri_Node

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Node)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
HX_DECLARE_CLASS2(hxd,poly2tri,Triangle)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Node_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Node_obj OBJ_;
		Node_obj();
		Void __construct(::hxd::poly2tri::Point point,::hxd::poly2tri::Triangle triangle);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Node_obj > __new(::hxd::poly2tri::Point point,::hxd::poly2tri::Triangle triangle);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Node_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Node"); }

		::hxd::poly2tri::Point point;
		::hxd::poly2tri::Triangle triangle;
		::hxd::poly2tri::Node prev;
		::hxd::poly2tri::Node next;
		Float value;
		virtual Float getHoleAngle( );
		Dynamic getHoleAngle_dyn();

		virtual Float getBasinAngle( );
		Dynamic getBasinAngle_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Node */ 
