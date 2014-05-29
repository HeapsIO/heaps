#ifndef INCLUDED_hxd_poly2tri_Triangle
#define INCLUDED_hxd_poly2tri_Triangle

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,poly2tri,Edge)
HX_DECLARE_CLASS2(hxd,poly2tri,Point)
HX_DECLARE_CLASS2(hxd,poly2tri,Triangle)
namespace hxd{
namespace poly2tri{


class HXCPP_CLASS_ATTRIBUTES  Triangle_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Triangle_obj OBJ_;
		Triangle_obj();
		Void __construct(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2,::hxd::poly2tri::Point p3,hx::Null< bool >  __o_fixOrientation,hx::Null< bool >  __o_checkOrientation);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Triangle_obj > __new(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2,::hxd::poly2tri::Point p3,hx::Null< bool >  __o_fixOrientation,hx::Null< bool >  __o_checkOrientation);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Triangle_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Triangle"); }

		Array< ::Dynamic > points;
		Array< ::Dynamic > neighbors;
		int id;
		Array< bool > constrained_edge;
		Array< bool > delaunay_edge;
		virtual bool containsPoint( ::hxd::poly2tri::Point point);
		Dynamic containsPoint_dyn();

		virtual bool containsEdgePoints( ::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2);
		Dynamic containsEdgePoints_dyn();

		virtual Void markNeighbor( ::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2);
		Dynamic markNeighbor_dyn();

		virtual Void markNeighborTriangle( ::hxd::poly2tri::Triangle that);
		Dynamic markNeighborTriangle_dyn();

		virtual int getPointIndexOffset( ::hxd::poly2tri::Point p,hx::Null< int >  offset);
		Dynamic getPointIndexOffset_dyn();

		virtual ::hxd::poly2tri::Point pointCW( ::hxd::poly2tri::Point p);
		Dynamic pointCW_dyn();

		virtual ::hxd::poly2tri::Point pointCCW( ::hxd::poly2tri::Point p);
		Dynamic pointCCW_dyn();

		virtual ::hxd::poly2tri::Triangle neighborCW( ::hxd::poly2tri::Point p);
		Dynamic neighborCW_dyn();

		virtual ::hxd::poly2tri::Triangle neighborCCW( ::hxd::poly2tri::Point p);
		Dynamic neighborCCW_dyn();

		virtual bool getConstrainedEdgeCW( ::hxd::poly2tri::Point p);
		Dynamic getConstrainedEdgeCW_dyn();

		virtual bool setConstrainedEdgeCW( ::hxd::poly2tri::Point p,bool ce);
		Dynamic setConstrainedEdgeCW_dyn();

		virtual bool getConstrainedEdgeCCW( ::hxd::poly2tri::Point p);
		Dynamic getConstrainedEdgeCCW_dyn();

		virtual bool setConstrainedEdgeCCW( ::hxd::poly2tri::Point p,bool ce);
		Dynamic setConstrainedEdgeCCW_dyn();

		virtual bool getDelaunayEdgeCW( ::hxd::poly2tri::Point p);
		Dynamic getDelaunayEdgeCW_dyn();

		virtual bool setDelaunayEdgeCW( ::hxd::poly2tri::Point p,bool e);
		Dynamic setDelaunayEdgeCW_dyn();

		virtual bool getDelaunayEdgeCCW( ::hxd::poly2tri::Point p);
		Dynamic getDelaunayEdgeCCW_dyn();

		virtual bool setDelaunayEdgeCCW( ::hxd::poly2tri::Point p,bool e);
		Dynamic setDelaunayEdgeCCW_dyn();

		virtual ::hxd::poly2tri::Triangle neighborAcross( ::hxd::poly2tri::Point p);
		Dynamic neighborAcross_dyn();

		virtual ::hxd::poly2tri::Point oppositePoint( ::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p);
		Dynamic oppositePoint_dyn();

		virtual Void legalize( ::hxd::poly2tri::Point opoint,::hxd::poly2tri::Point npoint);
		Dynamic legalize_dyn();

		virtual int index( ::hxd::poly2tri::Point p);
		Dynamic index_dyn();

		virtual int edgeIndex( ::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2);
		Dynamic edgeIndex_dyn();

		virtual Void markConstrainedEdgeByEdge( ::hxd::poly2tri::Edge edge);
		Dynamic markConstrainedEdgeByEdge_dyn();

		virtual Void markConstrainedEdgeByPoints( ::hxd::poly2tri::Point p,::hxd::poly2tri::Point q);
		Dynamic markConstrainedEdgeByPoints_dyn();

		virtual bool isEdgeSide( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq);
		Dynamic isEdgeSide_dyn();

		virtual Void clearNeigbors( );
		Dynamic clearNeigbors_dyn();

		virtual Void clearDelunayEdges( );
		Dynamic clearDelunayEdges_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static int CW_OFFSET;
		static int CCW_OFFSET;
		static Void rotateTrianglePair( ::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p,::hxd::poly2tri::Triangle ot,::hxd::poly2tri::Point op);
		static Dynamic rotateTrianglePair_dyn();

};

} // end namespace hxd
} // end namespace poly2tri

#endif /* INCLUDED_hxd_poly2tri_Triangle */ 
