#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_AdvancingFront
#include <hxd/poly2tri/AdvancingFront.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Basin
#include <hxd/poly2tri/Basin.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Constants
#include <hxd/poly2tri/Constants.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Edge
#include <hxd/poly2tri/Edge.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_EdgeEvent
#include <hxd/poly2tri/EdgeEvent.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Node
#include <hxd/poly2tri/Node.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_SweepContext
#include <hxd/poly2tri/SweepContext.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Triangle
#include <hxd/poly2tri/Triangle.h>
#endif
namespace hxd{
namespace poly2tri{

Void SweepContext_obj::__construct()
{
HX_STACK_FRAME("hxd.poly2tri.SweepContext","new",0xebc59064,"hxd.poly2tri.SweepContext.new","hxd/poly2tri/SweepContext.hx",25,0x174cebac)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(26)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(26)
	this->triangles = _g;
	HX_STACK_LINE(27)
	Array< ::Dynamic > _g1 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(27)
	this->points = _g1;
	HX_STACK_LINE(28)
	Array< ::Dynamic > _g2 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(28)
	this->edge_list = _g2;
	HX_STACK_LINE(30)
	::haxe::ds::StringMap _g3 = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(30)
	this->map = _g3;
	HX_STACK_LINE(36)
	::hxd::poly2tri::Basin _g4 = ::hxd::poly2tri::Basin_obj::__new();		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(36)
	this->basin = _g4;
	HX_STACK_LINE(37)
	::hxd::poly2tri::EdgeEvent _g5 = ::hxd::poly2tri::EdgeEvent_obj::__new();		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(37)
	this->edge_event = _g5;
}
;
	return null();
}

//SweepContext_obj::~SweepContext_obj() { }

Dynamic SweepContext_obj::__CreateEmpty() { return  new SweepContext_obj; }
hx::ObjectPtr< SweepContext_obj > SweepContext_obj::__new()
{  hx::ObjectPtr< SweepContext_obj > result = new SweepContext_obj();
	result->__construct();
	return result;}

Dynamic SweepContext_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SweepContext_obj > result = new SweepContext_obj();
	result->__construct();
	return result;}

Void SweepContext_obj::addPoints( Array< ::Dynamic > points){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","addPoints",0x04e9e228,"hxd.poly2tri.SweepContext.addPoints","hxd/poly2tri/SweepContext.hx",44,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(points,"points")
		HX_STACK_LINE(44)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(44)
		while((true)){
			HX_STACK_LINE(44)
			if ((!(((_g < points->length))))){
				HX_STACK_LINE(44)
				break;
			}
			HX_STACK_LINE(44)
			::hxd::poly2tri::Point point = points->__get(_g).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(point,"point");
			HX_STACK_LINE(44)
			++(_g);
			HX_STACK_LINE(47)
			this->points->push(point);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,addPoints,(void))

Void SweepContext_obj::addPolyline( Array< ::Dynamic > polyline){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","addPolyline",0xffee4785,"hxd.poly2tri.SweepContext.addPolyline","hxd/poly2tri/SweepContext.hx",53,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(polyline,"polyline")
		HX_STACK_LINE(54)
		this->initEdges(polyline);
		HX_STACK_LINE(55)
		this->addPoints(polyline);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,addPolyline,(void))

Void SweepContext_obj::initEdges( Array< ::Dynamic > polyline){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","initEdges",0xdb0a236a,"hxd.poly2tri.SweepContext.initEdges","hxd/poly2tri/SweepContext.hx",62,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(polyline,"polyline")
		HX_STACK_LINE(62)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(62)
		int _g = polyline->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(62)
		while((true)){
			HX_STACK_LINE(62)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(62)
				break;
			}
			HX_STACK_LINE(62)
			int n = (_g1)++;		HX_STACK_VAR(n,"n");
			HX_STACK_LINE(65)
			::hxd::poly2tri::Point nx = polyline->__get(hx::Mod(((n + (int)1)),polyline->length)).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(nx,"nx");
			HX_STACK_LINE(66)
			::hxd::poly2tri::Edge _g2 = ::hxd::poly2tri::Edge_obj::__new(polyline->__get(n).StaticCast< ::hxd::poly2tri::Point >(),nx);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(66)
			this->edge_list->push(_g2);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,initEdges,(void))

Void SweepContext_obj::addToMap( ::hxd::poly2tri::Triangle triangle){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","addToMap",0xa715937c,"hxd.poly2tri.SweepContext.addToMap","hxd/poly2tri/SweepContext.hx",74,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(triangle,"triangle")
		HX_STACK_LINE(74)
		::String key = triangle->toString();		HX_STACK_VAR(key,"key");
		HX_STACK_LINE(74)
		this->map->set(key,triangle);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,addToMap,(void))

Void SweepContext_obj::initTriangulation( ){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","initTriangulation",0x38f71c23,"hxd.poly2tri.SweepContext.initTriangulation","hxd/poly2tri/SweepContext.hx",79,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_LINE(81)
		Float xmin = this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >()->x;		HX_STACK_VAR(xmin,"xmin");
		HX_STACK_LINE(82)
		Float xmax = this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >()->x;		HX_STACK_VAR(xmax,"xmax");
		HX_STACK_LINE(83)
		Float ymin = this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >()->y;		HX_STACK_VAR(ymin,"ymin");
		HX_STACK_LINE(84)
		Float ymax = this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >()->y;		HX_STACK_VAR(ymax,"ymax");
		HX_STACK_LINE(87)
		{
			HX_STACK_LINE(87)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(87)
			Array< ::Dynamic > _g1 = this->points;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(87)
			while((true)){
				HX_STACK_LINE(87)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(87)
					break;
				}
				HX_STACK_LINE(87)
				::hxd::poly2tri::Point p = _g1->__get(_g).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(87)
				++(_g);
				HX_STACK_LINE(89)
				if (((p->x > xmax))){
					HX_STACK_LINE(89)
					xmax = p->x;
				}
				HX_STACK_LINE(90)
				if (((p->x < xmin))){
					HX_STACK_LINE(90)
					xmin = p->x;
				}
				HX_STACK_LINE(91)
				if (((p->y > ymax))){
					HX_STACK_LINE(91)
					ymax = p->y;
				}
				HX_STACK_LINE(92)
				if (((p->y < ymin))){
					HX_STACK_LINE(92)
					ymin = p->y;
				}
			}
		}
		HX_STACK_LINE(95)
		Float dx = (::hxd::poly2tri::Constants_obj::kAlpha * ((xmax - xmin)));		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(96)
		Float dy = (::hxd::poly2tri::Constants_obj::kAlpha * ((ymax - ymin)));		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(103)
		::hxd::poly2tri::Point _g = ::hxd::poly2tri::Point_obj::__new((xmax + dx),(ymin - dy));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(103)
		this->head = _g;
		HX_STACK_LINE(104)
		::hxd::poly2tri::Point _g1 = ::hxd::poly2tri::Point_obj::__new((xmin - dy),(ymin - dy));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(104)
		this->tail = _g1;
		HX_STACK_LINE(108)
		::hxd::poly2tri::Point_obj::sortPoints(this->points);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SweepContext_obj,initTriangulation,(void))

::hxd::poly2tri::Node SweepContext_obj::locateNode( ::hxd::poly2tri::Point point){
	HX_STACK_FRAME("hxd.poly2tri.SweepContext","locateNode",0xc20ceb30,"hxd.poly2tri.SweepContext.locateNode","hxd/poly2tri/SweepContext.hx",114,0x174cebac)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_LINE(114)
	return this->front->locateNode(point->x);
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,locateNode,return )

Void SweepContext_obj::createAdvancingFront( ){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","createAdvancingFront",0x43462582,"hxd.poly2tri.SweepContext.createAdvancingFront","hxd/poly2tri/SweepContext.hx",118,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_LINE(120)
		::hxd::poly2tri::Triangle triangle = ::hxd::poly2tri::Triangle_obj::__new(this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >(),this->tail,this->head,null(),null());		HX_STACK_VAR(triangle,"triangle");
		HX_STACK_LINE(122)
		this->addToMap(triangle);
		HX_STACK_LINE(124)
		::hxd::poly2tri::Node head = ::hxd::poly2tri::Node_obj::__new(triangle->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >(),triangle);		HX_STACK_VAR(head,"head");
		HX_STACK_LINE(125)
		::hxd::poly2tri::Node middle = ::hxd::poly2tri::Node_obj::__new(triangle->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >(),triangle);		HX_STACK_VAR(middle,"middle");
		HX_STACK_LINE(126)
		::hxd::poly2tri::Node tail = ::hxd::poly2tri::Node_obj::__new(triangle->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >(),null());		HX_STACK_VAR(tail,"tail");
		HX_STACK_LINE(128)
		::hxd::poly2tri::AdvancingFront _g = ::hxd::poly2tri::AdvancingFront_obj::__new(head,tail);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(128)
		this->front = _g;
		HX_STACK_LINE(130)
		head->next = middle;
		HX_STACK_LINE(131)
		middle->next = tail;
		HX_STACK_LINE(132)
		middle->prev = head;
		HX_STACK_LINE(133)
		tail->prev = middle;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(SweepContext_obj,createAdvancingFront,(void))

Void SweepContext_obj::removeNode( ::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","removeNode",0x55394ce2,"hxd.poly2tri.SweepContext.removeNode","hxd/poly2tri/SweepContext.hx",138,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(node,"node")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,removeNode,(void))

Void SweepContext_obj::mapTriangleToNodes( ::hxd::poly2tri::Triangle triangle){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","mapTriangleToNodes",0x0e5f880e,"hxd.poly2tri.SweepContext.mapTriangleToNodes","hxd/poly2tri/SweepContext.hx",144,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(triangle,"triangle")
		HX_STACK_LINE(144)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(144)
		while((true)){
			HX_STACK_LINE(144)
			if ((!(((_g < (int)3))))){
				HX_STACK_LINE(144)
				break;
			}
			HX_STACK_LINE(144)
			int n = (_g)++;		HX_STACK_VAR(n,"n");
			HX_STACK_LINE(146)
			if (((triangle->neighbors->__get(n).StaticCast< ::hxd::poly2tri::Triangle >() == null()))){
				HX_STACK_LINE(148)
				int _g1 = triangle->getPointIndexOffset(triangle->points->__get(n).StaticCast< ::hxd::poly2tri::Point >(),(int)-1);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(148)
				::hxd::poly2tri::Point _g11 = triangle->points->__get(_g1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(148)
				::hxd::poly2tri::Node neighbor = this->front->locatePoint(_g11);		HX_STACK_VAR(neighbor,"neighbor");
				HX_STACK_LINE(149)
				if (((neighbor != null()))){
					HX_STACK_LINE(149)
					neighbor->triangle = triangle;
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,mapTriangleToNodes,(void))

Void SweepContext_obj::meshClean( ::hxd::poly2tri::Triangle t){
{
		HX_STACK_FRAME("hxd.poly2tri.SweepContext","meshClean",0xd6131760,"hxd.poly2tri.SweepContext.meshClean","hxd/poly2tri/SweepContext.hx",155,0x174cebac)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(156)
		Array< ::Dynamic > tmp = Array_obj< ::Dynamic >::__new().Add(t);		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(157)
		while((true)){
			HX_STACK_LINE(158)
			::hxd::poly2tri::Triangle t1 = tmp->pop().StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(t1,"t1");
			HX_STACK_LINE(159)
			if (((t1 == null()))){
				HX_STACK_LINE(159)
				break;
			}
			HX_STACK_LINE(160)
			if (((t1->id >= (int)0))){
				HX_STACK_LINE(160)
				continue;
			}
			HX_STACK_LINE(161)
			t1->id = this->triangles->length;
			HX_STACK_LINE(162)
			this->triangles->push(t1);
			HX_STACK_LINE(163)
			{
				HX_STACK_LINE(163)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(163)
				while((true)){
					HX_STACK_LINE(163)
					if ((!(((_g < (int)3))))){
						HX_STACK_LINE(163)
						break;
					}
					HX_STACK_LINE(163)
					int n = (_g)++;		HX_STACK_VAR(n,"n");
					HX_STACK_LINE(164)
					if ((!(t1->constrained_edge->__get(n)))){
						HX_STACK_LINE(165)
						tmp->push(t1->neighbors->__get(n).StaticCast< ::hxd::poly2tri::Triangle >());
					}
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(SweepContext_obj,meshClean,(void))


SweepContext_obj::SweepContext_obj()
{
}

void SweepContext_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SweepContext);
	HX_MARK_MEMBER_NAME(triangles,"triangles");
	HX_MARK_MEMBER_NAME(points,"points");
	HX_MARK_MEMBER_NAME(edge_list,"edge_list");
	HX_MARK_MEMBER_NAME(map,"map");
	HX_MARK_MEMBER_NAME(front,"front");
	HX_MARK_MEMBER_NAME(head,"head");
	HX_MARK_MEMBER_NAME(tail,"tail");
	HX_MARK_MEMBER_NAME(basin,"basin");
	HX_MARK_MEMBER_NAME(edge_event,"edge_event");
	HX_MARK_END_CLASS();
}

void SweepContext_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(triangles,"triangles");
	HX_VISIT_MEMBER_NAME(points,"points");
	HX_VISIT_MEMBER_NAME(edge_list,"edge_list");
	HX_VISIT_MEMBER_NAME(map,"map");
	HX_VISIT_MEMBER_NAME(front,"front");
	HX_VISIT_MEMBER_NAME(head,"head");
	HX_VISIT_MEMBER_NAME(tail,"tail");
	HX_VISIT_MEMBER_NAME(basin,"basin");
	HX_VISIT_MEMBER_NAME(edge_event,"edge_event");
}

Dynamic SweepContext_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"map") ) { return map; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"head") ) { return head; }
		if (HX_FIELD_EQ(inName,"tail") ) { return tail; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"front") ) { return front; }
		if (HX_FIELD_EQ(inName,"basin") ) { return basin; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"points") ) { return points; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"addToMap") ) { return addToMap_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"triangles") ) { return triangles; }
		if (HX_FIELD_EQ(inName,"edge_list") ) { return edge_list; }
		if (HX_FIELD_EQ(inName,"addPoints") ) { return addPoints_dyn(); }
		if (HX_FIELD_EQ(inName,"initEdges") ) { return initEdges_dyn(); }
		if (HX_FIELD_EQ(inName,"meshClean") ) { return meshClean_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"edge_event") ) { return edge_event; }
		if (HX_FIELD_EQ(inName,"locateNode") ) { return locateNode_dyn(); }
		if (HX_FIELD_EQ(inName,"removeNode") ) { return removeNode_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"addPolyline") ) { return addPolyline_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"initTriangulation") ) { return initTriangulation_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"mapTriangleToNodes") ) { return mapTriangleToNodes_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"createAdvancingFront") ) { return createAdvancingFront_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SweepContext_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"map") ) { map=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"head") ) { head=inValue.Cast< ::hxd::poly2tri::Point >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tail") ) { tail=inValue.Cast< ::hxd::poly2tri::Point >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"front") ) { front=inValue.Cast< ::hxd::poly2tri::AdvancingFront >(); return inValue; }
		if (HX_FIELD_EQ(inName,"basin") ) { basin=inValue.Cast< ::hxd::poly2tri::Basin >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"points") ) { points=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"triangles") ) { triangles=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"edge_list") ) { edge_list=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"edge_event") ) { edge_event=inValue.Cast< ::hxd::poly2tri::EdgeEvent >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SweepContext_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("triangles"));
	outFields->push(HX_CSTRING("points"));
	outFields->push(HX_CSTRING("edge_list"));
	outFields->push(HX_CSTRING("map"));
	outFields->push(HX_CSTRING("front"));
	outFields->push(HX_CSTRING("head"));
	outFields->push(HX_CSTRING("tail"));
	outFields->push(HX_CSTRING("basin"));
	outFields->push(HX_CSTRING("edge_event"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(SweepContext_obj,triangles),HX_CSTRING("triangles")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(SweepContext_obj,points),HX_CSTRING("points")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(SweepContext_obj,edge_list),HX_CSTRING("edge_list")},
	{hx::fsObject /*::haxe::ds::StringMap*/ ,(int)offsetof(SweepContext_obj,map),HX_CSTRING("map")},
	{hx::fsObject /*::hxd::poly2tri::AdvancingFront*/ ,(int)offsetof(SweepContext_obj,front),HX_CSTRING("front")},
	{hx::fsObject /*::hxd::poly2tri::Point*/ ,(int)offsetof(SweepContext_obj,head),HX_CSTRING("head")},
	{hx::fsObject /*::hxd::poly2tri::Point*/ ,(int)offsetof(SweepContext_obj,tail),HX_CSTRING("tail")},
	{hx::fsObject /*::hxd::poly2tri::Basin*/ ,(int)offsetof(SweepContext_obj,basin),HX_CSTRING("basin")},
	{hx::fsObject /*::hxd::poly2tri::EdgeEvent*/ ,(int)offsetof(SweepContext_obj,edge_event),HX_CSTRING("edge_event")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("triangles"),
	HX_CSTRING("points"),
	HX_CSTRING("edge_list"),
	HX_CSTRING("map"),
	HX_CSTRING("front"),
	HX_CSTRING("head"),
	HX_CSTRING("tail"),
	HX_CSTRING("basin"),
	HX_CSTRING("edge_event"),
	HX_CSTRING("addPoints"),
	HX_CSTRING("addPolyline"),
	HX_CSTRING("initEdges"),
	HX_CSTRING("addToMap"),
	HX_CSTRING("initTriangulation"),
	HX_CSTRING("locateNode"),
	HX_CSTRING("createAdvancingFront"),
	HX_CSTRING("removeNode"),
	HX_CSTRING("mapTriangleToNodes"),
	HX_CSTRING("meshClean"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SweepContext_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(SweepContext_obj::__mClass,"__mClass");
};

#endif

Class SweepContext_obj::__mClass;

void SweepContext_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.SweepContext"), hx::TCanCast< SweepContext_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void SweepContext_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
