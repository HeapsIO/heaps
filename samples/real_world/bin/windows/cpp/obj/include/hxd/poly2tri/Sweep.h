#ifndef INCLUDED_hxd_poly2tri_Sweep
#define INCLUDED_hxd_poly2tri_Sweep

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Edge)
HX_DECLARE_CLASS2(hxd,poly2tri,Node)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
HX_DECLARE_CLASS2(hxd,poly2tri,Sweep)
HX_DECLARE_CLASS2(hxd,poly2tri,SweepContext)
HX_DECLARE_CLASS2(hxd,poly2tri,Triangle)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Sweep_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Sweep_obj OBJ_;
		Sweep_obj();
		Void __construct(::hxd::poly2tri::SweepContext context);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Sweep_obj > __new(::hxd::poly2tri::SweepContext context);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Sweep_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Sweep"); }

		::hxd::poly2tri::SweepContext context;
		virtual Void triangulate( );
		Dynamic triangulate_dyn();

		virtual Void sweepPoints( );
		Dynamic sweepPoints_dyn();

		virtual Void finalizationPolygon( );
		Dynamic finalizationPolygon_dyn();

		virtual ::hxd::poly2tri::Node pointEvent( ::hxd::poly2tri::Point point);
		Dynamic pointEvent_dyn();

		virtual Void edgeEventByEdge( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic edgeEventByEdge_dyn();

		virtual Void edgeEventByPoints( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle triangle,::hxd::poly2tri::Point point);
		Dynamic edgeEventByPoints_dyn();

		virtual ::hxd::poly2tri::Node newFrontTriangle( ::hxd::poly2tri::Point point,::hxd::poly2tri::Node node);
		Dynamic newFrontTriangle_dyn();

		virtual Void fill( ::hxd::poly2tri::Node node);
		Dynamic fill_dyn();

		virtual Void fillAdvancingFront( ::hxd::poly2tri::Node n);
		Dynamic fillAdvancingFront_dyn();

		virtual bool legalize( ::hxd::poly2tri::Triangle t);
		Dynamic legalize_dyn();

		virtual Void fillBasin( ::hxd::poly2tri::Node node);
		Dynamic fillBasin_dyn();

		virtual Void fillBasinReq( ::hxd::poly2tri::Node node);
		Dynamic fillBasinReq_dyn();

		virtual bool isShallow( ::hxd::poly2tri::Node node);
		Dynamic isShallow_dyn();

		virtual Void fillEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillEdgeEvent_dyn();

		virtual Void fillRightAboveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillRightAboveEdgeEvent_dyn();

		virtual Void fillRightBelowEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillRightBelowEdgeEvent_dyn();

		virtual Void fillRightConcaveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillRightConcaveEdgeEvent_dyn();

		virtual Void fillRightConvexEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillRightConvexEdgeEvent_dyn();

		virtual Void fillLeftAboveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillLeftAboveEdgeEvent_dyn();

		virtual Void fillLeftBelowEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillLeftBelowEdgeEvent_dyn();

		virtual Void fillLeftConvexEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillLeftConvexEdgeEvent_dyn();

		virtual Void fillLeftConcaveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node);
		Dynamic fillLeftConcaveEdgeEvent_dyn();

		virtual Void flipEdgeEvent( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p);
		Dynamic flipEdgeEvent_dyn();

		virtual ::hxd::poly2tri::Triangle nextFlipTriangle( int o,::hxd::poly2tri::Triangle t,::hxd::poly2tri::Triangle ot,::hxd::poly2tri::Point p,::hxd::poly2tri::Point op);
		Dynamic nextFlipTriangle_dyn();

		virtual Void flipScanEdgeEvent( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle flip_triangle,::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p);
		Dynamic flipScanEdgeEvent_dyn();

		static ::hxd::poly2tri::Point nextFlipPoint( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle ot,::hxd::poly2tri::Point op);
		static Dynamic nextFlipPoint_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Sweep */ 
