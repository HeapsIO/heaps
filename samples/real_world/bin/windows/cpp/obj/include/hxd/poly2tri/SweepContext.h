#ifndef INCLUDED_hxd_poly2tri_SweepContext
#define INCLUDED_hxd_poly2tri_SweepContext

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(hxd,poly2tri,AdvancingFront)
HX_DECLARE_CLASS2(hxd,poly2tri,Basin)
HX_DECLARE_CLASS2(hxd,poly2tri,Edge)
HX_DECLARE_CLASS2(hxd,poly2tri,EdgeEvent)
HX_DECLARE_CLASS2(hxd,poly2tri,Node)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
HX_DECLARE_CLASS2(hxd,poly2tri,SweepContext)
HX_DECLARE_CLASS2(hxd,poly2tri,Triangle)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  SweepContext_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef SweepContext_obj OBJ_;
		SweepContext_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< SweepContext_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~SweepContext_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("SweepContext"); }

		Array< ::Dynamic > triangles;
		Array< ::Dynamic > points;
		Array< ::Dynamic > edge_list;
		::haxe::ds::StringMap map;
		::hxd::poly2tri::AdvancingFront front;
		::hxd::poly2tri::Point head;
		::hxd::poly2tri::Point tail;
		::hxd::poly2tri::Basin basin;
		::hxd::poly2tri::EdgeEvent edge_event;
		virtual Void addPoints( Array< ::Dynamic > points);
		Dynamic addPoints_dyn();

		virtual Void addPolyline( Array< ::Dynamic > polyline);
		Dynamic addPolyline_dyn();

		virtual Void initEdges( Array< ::Dynamic > polyline);
		Dynamic initEdges_dyn();

		virtual Void addToMap( ::hxd::poly2tri::Triangle triangle);
		Dynamic addToMap_dyn();

		virtual Void initTriangulation( );
		Dynamic initTriangulation_dyn();

		virtual ::hxd::poly2tri::Node locateNode( ::hxd::poly2tri::Point point);
		Dynamic locateNode_dyn();

		virtual Void createAdvancingFront( );
		Dynamic createAdvancingFront_dyn();

		virtual Void removeNode( ::hxd::poly2tri::Node node);
		Dynamic removeNode_dyn();

		virtual Void mapTriangleToNodes( ::hxd::poly2tri::Triangle triangle);
		Dynamic mapTriangleToNodes_dyn();

		virtual Void meshClean( ::hxd::poly2tri::Triangle t);
		Dynamic meshClean_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_SweepContext */ 
