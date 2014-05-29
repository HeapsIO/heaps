#include <hxcpp.h>

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
#ifndef INCLUDED_hxd_poly2tri_Sweep
#include <hxd/poly2tri/Sweep.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_SweepContext
#include <hxd/poly2tri/SweepContext.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Triangle
#include <hxd/poly2tri/Triangle.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Utils
#include <hxd/poly2tri/Utils.h>
#endif
namespace hxd{
namespace poly2tri{

Void Sweep_obj::__construct(::hxd::poly2tri::SweepContext context)
{
HX_STACK_FRAME("hxd.poly2tri.Sweep","new",0xe7c61c6f,"hxd.poly2tri.Sweep.new","hxd/poly2tri/Sweep.hx",9,0x26a8ddc1)
HX_STACK_THIS(this)
HX_STACK_ARG(context,"context")
{
	HX_STACK_LINE(9)
	this->context = context;
}
;
	return null();
}

//Sweep_obj::~Sweep_obj() { }

Dynamic Sweep_obj::__CreateEmpty() { return  new Sweep_obj; }
hx::ObjectPtr< Sweep_obj > Sweep_obj::__new(::hxd::poly2tri::SweepContext context)
{  hx::ObjectPtr< Sweep_obj > result = new Sweep_obj();
	result->__construct(context);
	return result;}

Dynamic Sweep_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Sweep_obj > result = new Sweep_obj();
	result->__construct(inArgs[0]);
	return result;}

Void Sweep_obj::triangulate( ){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","triangulate",0x9a60d83b,"hxd.poly2tri.Sweep.triangulate","hxd/poly2tri/Sweep.hx",13,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_LINE(14)
		this->context->initTriangulation();
		HX_STACK_LINE(15)
		this->context->createAdvancingFront();
		HX_STACK_LINE(16)
		this->sweepPoints();
		HX_STACK_LINE(17)
		this->finalizationPolygon();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sweep_obj,triangulate,(void))

Void Sweep_obj::sweepPoints( ){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","sweepPoints",0x1e97483e,"hxd.poly2tri.Sweep.sweepPoints","hxd/poly2tri/Sweep.hx",22,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_LINE(22)
		int _g1 = (int)1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(22)
		int _g = this->context->points->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(22)
		while((true)){
			HX_STACK_LINE(22)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(22)
				break;
			}
			HX_STACK_LINE(22)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(25)
			::hxd::poly2tri::Point point = this->context->points->__get(i).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(point,"point");
			HX_STACK_LINE(26)
			::hxd::poly2tri::Node node = this->pointEvent(point);		HX_STACK_VAR(node,"node");
			HX_STACK_LINE(27)
			{
				HX_STACK_LINE(27)
				int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(27)
				int _g2 = point->get_edge_list()->length;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(27)
				while((true)){
					HX_STACK_LINE(27)
					if ((!(((_g3 < _g2))))){
						HX_STACK_LINE(27)
						break;
					}
					HX_STACK_LINE(27)
					int j = (_g3)++;		HX_STACK_VAR(j,"j");
					HX_STACK_LINE(30)
					Array< ::Dynamic > _g4 = point->get_edge_list();		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(30)
					::hxd::poly2tri::Edge _g11 = _g4->__get(j).StaticCast< ::hxd::poly2tri::Edge >();		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(30)
					this->edgeEventByEdge(_g11,node);
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sweep_obj,sweepPoints,(void))

Void Sweep_obj::finalizationPolygon( ){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","finalizationPolygon",0xce5ce5bb,"hxd.poly2tri.Sweep.finalizationPolygon","hxd/poly2tri/Sweep.hx",36,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_LINE(38)
		::hxd::poly2tri::Triangle t = this->context->front->head->next->triangle;		HX_STACK_VAR(t,"t");
		HX_STACK_LINE(39)
		::hxd::poly2tri::Point p = this->context->front->head->next->point;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(40)
		while((true)){
			HX_STACK_LINE(40)
			int _g = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(40)
			if ((!((!(t->constrained_edge->__get(_g)))))){
				HX_STACK_LINE(40)
				break;
			}
			HX_STACK_LINE(40)
			int _g1 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(40)
			::hxd::poly2tri::Triangle _g2 = t->neighbors->__get(_g1).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(40)
			t = _g2;
		}
		HX_STACK_LINE(43)
		this->context->meshClean(t);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Sweep_obj,finalizationPolygon,(void))

::hxd::poly2tri::Node Sweep_obj::pointEvent( ::hxd::poly2tri::Point point){
	HX_STACK_FRAME("hxd.poly2tri.Sweep","pointEvent",0x7426c57b,"hxd.poly2tri.Sweep.pointEvent","hxd/poly2tri/Sweep.hx",52,0x26a8ddc1)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_LINE(54)
	::hxd::poly2tri::Node node = this->context->locateNode(point);		HX_STACK_VAR(node,"node");
	HX_STACK_LINE(55)
	::hxd::poly2tri::Node new_node = this->newFrontTriangle(point,node);		HX_STACK_VAR(new_node,"new_node");
	HX_STACK_LINE(59)
	if (((point->x <= (node->point->x + ::hxd::poly2tri::Constants_obj::EPSILON)))){
		HX_STACK_LINE(59)
		this->fill(node);
	}
	HX_STACK_LINE(61)
	this->fillAdvancingFront(new_node);
	HX_STACK_LINE(62)
	return new_node;
}


HX_DEFINE_DYNAMIC_FUNC1(Sweep_obj,pointEvent,return )

Void Sweep_obj::edgeEventByEdge( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","edgeEventByEdge",0x99cc62c0,"hxd.poly2tri.Sweep.edgeEventByEdge","hxd/poly2tri/Sweep.hx",67,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(68)
		this->context->edge_event->constrained_edge = edge;
		HX_STACK_LINE(69)
		this->context->edge_event->right = (edge->p->x > edge->q->x);
		HX_STACK_LINE(71)
		if ((node->triangle->isEdgeSide(edge->p,edge->q))){
			HX_STACK_LINE(71)
			return null();
		}
		HX_STACK_LINE(76)
		this->fillEdgeEvent(edge,node);
		HX_STACK_LINE(78)
		this->edgeEventByPoints(edge->p,edge->q,node->triangle,edge->q);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,edgeEventByEdge,(void))

Void Sweep_obj::edgeEventByPoints( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle triangle,::hxd::poly2tri::Point point){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","edgeEventByPoints",0xac699366,"hxd.poly2tri.Sweep.edgeEventByPoints","hxd/poly2tri/Sweep.hx",82,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ep,"ep")
		HX_STACK_ARG(eq,"eq")
		HX_STACK_ARG(triangle,"triangle")
		HX_STACK_ARG(point,"point")
		HX_STACK_LINE(83)
		if ((triangle->isEdgeSide(ep,eq))){
			HX_STACK_LINE(83)
			return null();
		}
		HX_STACK_LINE(85)
		int _g = triangle->getPointIndexOffset(point,(int)1);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(85)
		::hxd::poly2tri::Point p1 = triangle->points->__get(_g).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p1,"p1");
		HX_STACK_LINE(86)
		int o1;		HX_STACK_VAR(o1,"o1");
		HX_STACK_LINE(86)
		{
			HX_STACK_LINE(86)
			Float detleft = (((eq->x - ep->x)) * ((p1->y - ep->y)));		HX_STACK_VAR(detleft,"detleft");
			HX_STACK_LINE(86)
			Float detright = (((eq->y - ep->y)) * ((p1->x - ep->x)));		HX_STACK_VAR(detright,"detright");
			HX_STACK_LINE(86)
			Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
			HX_STACK_LINE(86)
			if (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))){
				HX_STACK_LINE(86)
				o1 = (int)0;
			}
			else{
				HX_STACK_LINE(86)
				if (((val > (int)0))){
					HX_STACK_LINE(86)
					o1 = (int)-1;
				}
				else{
					HX_STACK_LINE(86)
					o1 = (int)1;
				}
			}
		}
		HX_STACK_LINE(87)
		if (((o1 == (int)0))){
			HX_STACK_LINE(87)
			HX_STACK_DO_THROW(HX_CSTRING("Sweep.edgeEvent: Collinear not supported!"));
		}
		HX_STACK_LINE(89)
		int _g1 = triangle->getPointIndexOffset(point,(int)-1);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(89)
		::hxd::poly2tri::Point p2 = triangle->points->__get(_g1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p2,"p2");
		HX_STACK_LINE(90)
		int o2;		HX_STACK_VAR(o2,"o2");
		HX_STACK_LINE(90)
		{
			HX_STACK_LINE(90)
			Float detleft = (((eq->x - ep->x)) * ((p2->y - ep->y)));		HX_STACK_VAR(detleft,"detleft");
			HX_STACK_LINE(90)
			Float detright = (((eq->y - ep->y)) * ((p2->x - ep->x)));		HX_STACK_VAR(detright,"detright");
			HX_STACK_LINE(90)
			Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
			HX_STACK_LINE(90)
			if (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))){
				HX_STACK_LINE(90)
				o2 = (int)0;
			}
			else{
				HX_STACK_LINE(90)
				if (((val > (int)0))){
					HX_STACK_LINE(90)
					o2 = (int)-1;
				}
				else{
					HX_STACK_LINE(90)
					o2 = (int)1;
				}
			}
		}
		HX_STACK_LINE(91)
		if (((o2 == (int)0))){
			HX_STACK_LINE(91)
			HX_STACK_DO_THROW(HX_CSTRING("Sweep.edgeEvent: Collinear not supported!"));
		}
		HX_STACK_LINE(93)
		if (((o1 == o2))){
			HX_STACK_LINE(97)
			::hxd::poly2tri::Triangle _g4;		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(97)
			if (((o1 == (int)1))){
				HX_STACK_LINE(98)
				int _g2 = triangle->getPointIndexOffset(point,(int)-1);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(98)
				_g4 = triangle->neighbors->__get(_g2).StaticCast< ::hxd::poly2tri::Triangle >();
			}
			else{
				HX_STACK_LINE(99)
				int _g3 = triangle->getPointIndexOffset(point,(int)1);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(99)
				_g4 = triangle->neighbors->__get(_g3).StaticCast< ::hxd::poly2tri::Triangle >();
			}
			HX_STACK_LINE(97)
			triangle = _g4;
			HX_STACK_LINE(101)
			this->edgeEventByPoints(ep,eq,triangle,point);
		}
		else{
			HX_STACK_LINE(106)
			this->flipEdgeEvent(ep,eq,triangle,point);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Sweep_obj,edgeEventByPoints,(void))

::hxd::poly2tri::Node Sweep_obj::newFrontTriangle( ::hxd::poly2tri::Point point,::hxd::poly2tri::Node node){
	HX_STACK_FRAME("hxd.poly2tri.Sweep","newFrontTriangle",0x69ebbea2,"hxd.poly2tri.Sweep.newFrontTriangle","hxd/poly2tri/Sweep.hx",113,0x26a8ddc1)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_ARG(node,"node")
	HX_STACK_LINE(114)
	::hxd::poly2tri::Triangle triangle = ::hxd::poly2tri::Triangle_obj::__new(point,node->point,node->next->point,true,null());		HX_STACK_VAR(triangle,"triangle");
	HX_STACK_LINE(118)
	triangle->markNeighborTriangle(node->triangle);
	HX_STACK_LINE(119)
	this->context->addToMap(triangle);
	HX_STACK_LINE(121)
	::hxd::poly2tri::Node new_node = ::hxd::poly2tri::Node_obj::__new(point,null());		HX_STACK_VAR(new_node,"new_node");
	HX_STACK_LINE(122)
	new_node->next = node->next;
	HX_STACK_LINE(123)
	new_node->prev = node;
	HX_STACK_LINE(124)
	node->next->prev = new_node;
	HX_STACK_LINE(125)
	node->next = new_node;
	HX_STACK_LINE(127)
	if ((!(this->legalize(triangle)))){
		HX_STACK_LINE(127)
		this->context->mapTriangleToNodes(triangle);
	}
	HX_STACK_LINE(129)
	return new_node;
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,newFrontTriangle,return )

Void Sweep_obj::fill( ::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fill",0xe04c0f94,"hxd.poly2tri.Sweep.fill","hxd/poly2tri/Sweep.hx",140,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(141)
		::hxd::poly2tri::Triangle triangle = ::hxd::poly2tri::Triangle_obj::__new(node->prev->point,node->point,node->next->point,true,null());		HX_STACK_VAR(triangle,"triangle");
		HX_STACK_LINE(145)
		triangle->markNeighborTriangle(node->prev->triangle);
		HX_STACK_LINE(146)
		triangle->markNeighborTriangle(node->triangle);
		HX_STACK_LINE(148)
		this->context->addToMap(triangle);
		HX_STACK_LINE(151)
		node->prev->next = node->next;
		HX_STACK_LINE(152)
		node->next->prev = node->prev;
		HX_STACK_LINE(155)
		if ((!(this->legalize(triangle)))){
			HX_STACK_LINE(157)
			this->context->mapTriangleToNodes(triangle);
		}
		HX_STACK_LINE(160)
		this->context->removeNode(node);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sweep_obj,fill,(void))

Void Sweep_obj::fillAdvancingFront( ::hxd::poly2tri::Node n){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillAdvancingFront",0x4c99ac9e,"hxd.poly2tri.Sweep.fillAdvancingFront","hxd/poly2tri/Sweep.hx",167,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(n,"n")
		HX_STACK_LINE(168)
		::hxd::poly2tri::Node node;		HX_STACK_VAR(node,"node");
		HX_STACK_LINE(169)
		Float angle;		HX_STACK_VAR(angle,"angle");
		HX_STACK_LINE(172)
		node = n->next;
		HX_STACK_LINE(173)
		while((true)){
			HX_STACK_LINE(173)
			if ((!(((node->next != null()))))){
				HX_STACK_LINE(173)
				break;
			}
			HX_STACK_LINE(175)
			Float _g = node->getHoleAngle();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(175)
			angle = _g;
			HX_STACK_LINE(176)
			if (((bool((angle > ::hxd::poly2tri::Constants_obj::PI_2)) || bool((angle < -(::hxd::poly2tri::Constants_obj::PI_2)))))){
				HX_STACK_LINE(176)
				break;
			}
			HX_STACK_LINE(177)
			this->fill(node);
			HX_STACK_LINE(178)
			node = node->next;
		}
		HX_STACK_LINE(182)
		node = n->prev;
		HX_STACK_LINE(183)
		while((true)){
			HX_STACK_LINE(183)
			if ((!(((node->prev != null()))))){
				HX_STACK_LINE(183)
				break;
			}
			HX_STACK_LINE(185)
			Float _g1 = node->getHoleAngle();		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(185)
			angle = _g1;
			HX_STACK_LINE(186)
			if (((bool((angle > ::hxd::poly2tri::Constants_obj::PI_2)) || bool((angle < -(::hxd::poly2tri::Constants_obj::PI_2)))))){
				HX_STACK_LINE(186)
				break;
			}
			HX_STACK_LINE(187)
			this->fill(node);
			HX_STACK_LINE(188)
			node = node->prev;
		}
		HX_STACK_LINE(192)
		if (((bool((n->next != null())) && bool((n->next->next != null()))))){
			HX_STACK_LINE(194)
			Float _g2 = n->getBasinAngle();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(194)
			angle = _g2;
			HX_STACK_LINE(195)
			if (((angle < ::hxd::poly2tri::Constants_obj::PI_3div4))){
				HX_STACK_LINE(195)
				this->fillBasin(n);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sweep_obj,fillAdvancingFront,(void))

bool Sweep_obj::legalize( ::hxd::poly2tri::Triangle t){
	HX_STACK_FRAME("hxd.poly2tri.Sweep","legalize",0xd3a82e4c,"hxd.poly2tri.Sweep.legalize","hxd/poly2tri/Sweep.hx",204,0x26a8ddc1)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_LINE(205)
	{
		HX_STACK_LINE(205)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(205)
		while((true)){
			HX_STACK_LINE(205)
			if ((!(((_g < (int)3))))){
				HX_STACK_LINE(205)
				break;
			}
			HX_STACK_LINE(205)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(207)
			if ((t->delaunay_edge->__get(i))){
				HX_STACK_LINE(207)
				continue;
			}
			HX_STACK_LINE(209)
			::hxd::poly2tri::Triangle ot = t->neighbors->__get(i).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(ot,"ot");
			HX_STACK_LINE(210)
			if (((ot != null()))){
				HX_STACK_LINE(212)
				::hxd::poly2tri::Point p = t->points->__get(i).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(213)
				::hxd::poly2tri::Point op;		HX_STACK_VAR(op,"op");
				HX_STACK_LINE(213)
				{
					HX_STACK_LINE(213)
					int _g1 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(213)
					::hxd::poly2tri::Point p1 = t->points->__get(_g1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p1,"p1");
					HX_STACK_LINE(213)
					int _g11 = ot->getPointIndexOffset(p1,(int)-1);		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(213)
					op = ot->points->__get(_g11).StaticCast< ::hxd::poly2tri::Point >();
				}
				HX_STACK_LINE(214)
				int oi = ot->getPointIndexOffset(op,(int)0);		HX_STACK_VAR(oi,"oi");
				HX_STACK_LINE(218)
				if (((bool(ot->constrained_edge->__get(oi)) || bool(ot->delaunay_edge->__get(oi))))){
					HX_STACK_LINE(220)
					t->constrained_edge[i] = ot->constrained_edge->__get(oi);
					HX_STACK_LINE(221)
					continue;
				}
				HX_STACK_LINE(225)
				int _g2 = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(225)
				::hxd::poly2tri::Point _g3 = t->points->__get(_g2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(225)
				int _g4 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(225)
				::hxd::poly2tri::Point _g5 = t->points->__get(_g4).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(225)
				if ((::hxd::poly2tri::Utils_obj::insideIncircle(p,_g3,_g5,op))){
					HX_STACK_LINE(228)
					t->delaunay_edge[i] = true;
					HX_STACK_LINE(229)
					ot->delaunay_edge[oi] = true;
					HX_STACK_LINE(232)
					::hxd::poly2tri::Triangle_obj::rotateTrianglePair(t,p,ot,op);
					HX_STACK_LINE(237)
					bool not_legalized;		HX_STACK_VAR(not_legalized,"not_legalized");
					HX_STACK_LINE(240)
					bool _g6 = !(this->legalize(t));		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(240)
					not_legalized = _g6;
					HX_STACK_LINE(241)
					if ((not_legalized)){
						HX_STACK_LINE(241)
						this->context->mapTriangleToNodes(t);
					}
					HX_STACK_LINE(243)
					bool _g7 = !(this->legalize(ot));		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(243)
					not_legalized = _g7;
					HX_STACK_LINE(244)
					if ((not_legalized)){
						HX_STACK_LINE(244)
						this->context->mapTriangleToNodes(ot);
					}
					HX_STACK_LINE(250)
					t->delaunay_edge[i] = false;
					HX_STACK_LINE(251)
					ot->delaunay_edge[oi] = false;
					HX_STACK_LINE(255)
					return true;
				}
			}
		}
	}
	HX_STACK_LINE(261)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(Sweep_obj,legalize,return )

Void Sweep_obj::fillBasin( ::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillBasin",0x54569285,"hxd.poly2tri.Sweep.fillBasin","hxd/poly2tri/Sweep.hx",274,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(node,"node")
		struct _Function_1_1{
			inline static int Block( ::hxd::poly2tri::Node &node){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",275,0x26a8ddc1)
				{
					HX_STACK_LINE(275)
					::hxd::poly2tri::Point pa = node->point;		HX_STACK_VAR(pa,"pa");
					HX_STACK_LINE(275)
					::hxd::poly2tri::Point pb = node->next->point;		HX_STACK_VAR(pb,"pb");
					HX_STACK_LINE(275)
					::hxd::poly2tri::Point pc = node->next->next->point;		HX_STACK_VAR(pc,"pc");
					HX_STACK_LINE(275)
					Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
					HX_STACK_LINE(275)
					Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
					HX_STACK_LINE(275)
					Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
					HX_STACK_LINE(275)
					return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
				}
				return null();
			}
		};
		HX_STACK_LINE(275)
		if (((_Function_1_1::Block(node) == (int)-1))){
			HX_STACK_LINE(275)
			this->context->basin->left_node = node->next->next;
		}
		else{
			HX_STACK_LINE(275)
			this->context->basin->left_node = node->next;
		}
		HX_STACK_LINE(281)
		this->context->basin->bottom_node = this->context->basin->left_node;
		HX_STACK_LINE(282)
		while((true)){
			HX_STACK_LINE(282)
			if ((!(((bool((this->context->basin->bottom_node->next != null())) && bool((this->context->basin->bottom_node->point->y >= this->context->basin->bottom_node->next->point->y))))))){
				HX_STACK_LINE(282)
				break;
			}
			HX_STACK_LINE(284)
			this->context->basin->bottom_node = this->context->basin->bottom_node->next;
		}
		HX_STACK_LINE(288)
		if (((this->context->basin->bottom_node == this->context->basin->left_node))){
			HX_STACK_LINE(288)
			return null();
		}
		HX_STACK_LINE(290)
		this->context->basin->right_node = this->context->basin->bottom_node;
		HX_STACK_LINE(291)
		while((true)){
			HX_STACK_LINE(291)
			if ((!(((bool((this->context->basin->right_node->next != null())) && bool((this->context->basin->right_node->point->y < this->context->basin->right_node->next->point->y))))))){
				HX_STACK_LINE(291)
				break;
			}
			HX_STACK_LINE(293)
			this->context->basin->right_node = this->context->basin->right_node->next;
		}
		HX_STACK_LINE(297)
		if (((this->context->basin->right_node == this->context->basin->bottom_node))){
			HX_STACK_LINE(297)
			return null();
		}
		HX_STACK_LINE(299)
		this->context->basin->width = (this->context->basin->right_node->point->x - this->context->basin->left_node->point->x);
		HX_STACK_LINE(300)
		this->context->basin->left_highest = (this->context->basin->left_node->point->y > this->context->basin->right_node->point->y);
		HX_STACK_LINE(302)
		this->fillBasinReq(this->context->basin->bottom_node);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sweep_obj,fillBasin,(void))

Void Sweep_obj::fillBasinReq( ::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillBasinReq",0x5eb89fd9,"hxd.poly2tri.Sweep.fillBasinReq","hxd/poly2tri/Sweep.hx",312,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(node,"node")
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Sweep_obj > __this,::hxd::poly2tri::Node &node){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",314,0x26a8ddc1)
				{
					HX_STACK_LINE(314)
					Float height;		HX_STACK_VAR(height,"height");
					HX_STACK_LINE(314)
					if ((__this->context->basin->left_highest)){
						HX_STACK_LINE(314)
						height = (__this->context->basin->left_node->point->y - node->point->y);
					}
					else{
						HX_STACK_LINE(314)
						height = (__this->context->basin->right_node->point->y - node->point->y);
					}
					HX_STACK_LINE(314)
					return (__this->context->basin->width > height);
				}
				return null();
			}
		};
		HX_STACK_LINE(314)
		if ((_Function_1_1::Block(this,node))){
			HX_STACK_LINE(314)
			return null();
		}
		HX_STACK_LINE(316)
		this->fill(node);
		HX_STACK_LINE(318)
		if (((bool((node->prev == this->context->basin->left_node)) && bool((node->next == this->context->basin->right_node))))){
			HX_STACK_LINE(320)
			return null();
		}
		else{
			HX_STACK_LINE(322)
			if (((node->prev == this->context->basin->left_node))){
				struct _Function_3_1{
					inline static int Block( ::hxd::poly2tri::Node &node){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",324,0x26a8ddc1)
						{
							HX_STACK_LINE(324)
							::hxd::poly2tri::Point pa = node->point;		HX_STACK_VAR(pa,"pa");
							HX_STACK_LINE(324)
							::hxd::poly2tri::Point pb = node->next->point;		HX_STACK_VAR(pb,"pb");
							HX_STACK_LINE(324)
							::hxd::poly2tri::Point pc = node->next->next->point;		HX_STACK_VAR(pc,"pc");
							HX_STACK_LINE(324)
							Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
							HX_STACK_LINE(324)
							Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
							HX_STACK_LINE(324)
							Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
							HX_STACK_LINE(324)
							return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
						}
						return null();
					}
				};
				HX_STACK_LINE(324)
				if (((_Function_3_1::Block(node) == (int)1))){
					HX_STACK_LINE(324)
					return null();
				}
				HX_STACK_LINE(325)
				node = node->next;
			}
			else{
				HX_STACK_LINE(327)
				if (((node->next == this->context->basin->right_node))){
					struct _Function_4_1{
						inline static int Block( ::hxd::poly2tri::Node &node){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",329,0x26a8ddc1)
							{
								HX_STACK_LINE(329)
								::hxd::poly2tri::Point pa = node->point;		HX_STACK_VAR(pa,"pa");
								HX_STACK_LINE(329)
								::hxd::poly2tri::Point pb = node->prev->point;		HX_STACK_VAR(pb,"pb");
								HX_STACK_LINE(329)
								::hxd::poly2tri::Point pc = node->prev->prev->point;		HX_STACK_VAR(pc,"pc");
								HX_STACK_LINE(329)
								Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
								HX_STACK_LINE(329)
								Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
								HX_STACK_LINE(329)
								Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
								HX_STACK_LINE(329)
								return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
							}
							return null();
						}
					};
					HX_STACK_LINE(329)
					if (((_Function_4_1::Block(node) == (int)-1))){
						HX_STACK_LINE(329)
						return null();
					}
					HX_STACK_LINE(330)
					node = node->prev;
				}
				else{
					HX_STACK_LINE(335)
					if (((node->prev->point->y < node->next->point->y))){
						HX_STACK_LINE(335)
						node = node->prev;
					}
					else{
						HX_STACK_LINE(335)
						node = node->next;
					}
				}
			}
		}
		HX_STACK_LINE(341)
		this->fillBasinReq(node);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Sweep_obj,fillBasinReq,(void))

bool Sweep_obj::isShallow( ::hxd::poly2tri::Node node){
	HX_STACK_FRAME("hxd.poly2tri.Sweep","isShallow",0x40c94259,"hxd.poly2tri.Sweep.isShallow","hxd/poly2tri/Sweep.hx",346,0x26a8ddc1)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_LINE(347)
	Float height;		HX_STACK_VAR(height,"height");
	HX_STACK_LINE(347)
	if ((this->context->basin->left_highest)){
		HX_STACK_LINE(348)
		height = (this->context->basin->left_node->point->y - node->point->y);
	}
	else{
		HX_STACK_LINE(349)
		height = (this->context->basin->right_node->point->y - node->point->y);
	}
	HX_STACK_LINE(353)
	return (this->context->basin->width > height);
}


HX_DEFINE_DYNAMIC_FUNC1(Sweep_obj,isShallow,return )

Void Sweep_obj::fillEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillEdgeEvent",0x972db069,"hxd.poly2tri.Sweep.fillEdgeEvent","hxd/poly2tri/Sweep.hx",358,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(358)
		if ((this->context->edge_event->right)){
			HX_STACK_LINE(360)
			this->fillRightAboveEdgeEvent(edge,node);
		}
		else{
			HX_STACK_LINE(364)
			this->fillLeftAboveEdgeEvent(edge,node);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillEdgeEvent,(void))

Void Sweep_obj::fillRightAboveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillRightAboveEdgeEvent",0x9e645588,"hxd.poly2tri.Sweep.fillRightAboveEdgeEvent","hxd/poly2tri/Sweep.hx",370,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(370)
		while((true)){
			HX_STACK_LINE(370)
			if ((!(((node->next->point->x < edge->p->x))))){
				HX_STACK_LINE(370)
				break;
			}
			struct _Function_2_1{
				inline static int Block( ::hxd::poly2tri::Edge &edge,::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",373,0x26a8ddc1)
					{
						HX_STACK_LINE(373)
						::hxd::poly2tri::Point pa = edge->q;		HX_STACK_VAR(pa,"pa");
						HX_STACK_LINE(373)
						::hxd::poly2tri::Point pb = node->next->point;		HX_STACK_VAR(pb,"pb");
						HX_STACK_LINE(373)
						::hxd::poly2tri::Point pc = edge->p;		HX_STACK_VAR(pc,"pc");
						HX_STACK_LINE(373)
						Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
						HX_STACK_LINE(373)
						Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
						HX_STACK_LINE(373)
						Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
						HX_STACK_LINE(373)
						return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
					}
					return null();
				}
			};
			HX_STACK_LINE(373)
			if (((_Function_2_1::Block(edge,node) == (int)-1))){
				HX_STACK_LINE(375)
				this->fillRightBelowEdgeEvent(edge,node);
			}
			else{
				HX_STACK_LINE(379)
				node = node->next;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillRightAboveEdgeEvent,(void))

Void Sweep_obj::fillRightBelowEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillRightBelowEdgeEvent",0x6c3c5774,"hxd.poly2tri.Sweep.fillRightBelowEdgeEvent","hxd/poly2tri/Sweep.hx",385,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(386)
		if (((node->point->x >= edge->p->x))){
			HX_STACK_LINE(386)
			return null();
		}
		struct _Function_1_1{
			inline static int Block( ::hxd::poly2tri::Node &node){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",387,0x26a8ddc1)
				{
					HX_STACK_LINE(387)
					::hxd::poly2tri::Point pa = node->point;		HX_STACK_VAR(pa,"pa");
					HX_STACK_LINE(387)
					::hxd::poly2tri::Point pb = node->next->point;		HX_STACK_VAR(pb,"pb");
					HX_STACK_LINE(387)
					::hxd::poly2tri::Point pc = node->next->next->point;		HX_STACK_VAR(pc,"pc");
					HX_STACK_LINE(387)
					Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
					HX_STACK_LINE(387)
					Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
					HX_STACK_LINE(387)
					Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
					HX_STACK_LINE(387)
					return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
				}
				return null();
			}
		};
		HX_STACK_LINE(387)
		if (((_Function_1_1::Block(node) == (int)-1))){
			HX_STACK_LINE(390)
			this->fillRightConcaveEdgeEvent(edge,node);
		}
		else{
			HX_STACK_LINE(394)
			this->fillRightConvexEdgeEvent(edge,node);
			HX_STACK_LINE(395)
			this->fillRightBelowEdgeEvent(edge,node);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillRightBelowEdgeEvent,(void))

Void Sweep_obj::fillRightConcaveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillRightConcaveEdgeEvent",0xe84d3dd6,"hxd.poly2tri.Sweep.fillRightConcaveEdgeEvent","hxd/poly2tri/Sweep.hx",400,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(401)
		this->fill(node->next);
		HX_STACK_LINE(402)
		if (((node->next->point != edge->p))){
			struct _Function_2_1{
				inline static int Block( ::hxd::poly2tri::Edge &edge,::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",405,0x26a8ddc1)
					{
						HX_STACK_LINE(405)
						::hxd::poly2tri::Point pa = edge->q;		HX_STACK_VAR(pa,"pa");
						HX_STACK_LINE(405)
						::hxd::poly2tri::Point pb = node->next->point;		HX_STACK_VAR(pb,"pb");
						HX_STACK_LINE(405)
						::hxd::poly2tri::Point pc = edge->p;		HX_STACK_VAR(pc,"pc");
						HX_STACK_LINE(405)
						Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
						HX_STACK_LINE(405)
						Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
						HX_STACK_LINE(405)
						Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
						HX_STACK_LINE(405)
						return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
					}
					return null();
				}
			};
			HX_STACK_LINE(405)
			if (((_Function_2_1::Block(edge,node) == (int)-1))){
				struct _Function_3_1{
					inline static int Block( ::hxd::poly2tri::Node &node){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",408,0x26a8ddc1)
						{
							HX_STACK_LINE(408)
							::hxd::poly2tri::Point pa = node->point;		HX_STACK_VAR(pa,"pa");
							HX_STACK_LINE(408)
							::hxd::poly2tri::Point pb = node->next->point;		HX_STACK_VAR(pb,"pb");
							HX_STACK_LINE(408)
							::hxd::poly2tri::Point pc = node->next->next->point;		HX_STACK_VAR(pc,"pc");
							HX_STACK_LINE(408)
							Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
							HX_STACK_LINE(408)
							Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
							HX_STACK_LINE(408)
							Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
							HX_STACK_LINE(408)
							return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
						}
						return null();
					}
				};
				HX_STACK_LINE(408)
				if (((_Function_3_1::Block(node) == (int)-1))){
					HX_STACK_LINE(411)
					this->fillRightConcaveEdgeEvent(edge,node);
				}
				else{
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillRightConcaveEdgeEvent,(void))

Void Sweep_obj::fillRightConvexEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillRightConvexEdgeEvent",0xcb97276e,"hxd.poly2tri.Sweep.fillRightConvexEdgeEvent","hxd/poly2tri/Sweep.hx",424,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		struct _Function_1_1{
			inline static int Block( ::hxd::poly2tri::Node &node){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",424,0x26a8ddc1)
				{
					HX_STACK_LINE(424)
					::hxd::poly2tri::Point pa = node->next->point;		HX_STACK_VAR(pa,"pa");
					HX_STACK_LINE(424)
					::hxd::poly2tri::Point pb = node->next->next->point;		HX_STACK_VAR(pb,"pb");
					HX_STACK_LINE(424)
					::hxd::poly2tri::Point pc = node->next->next->next->point;		HX_STACK_VAR(pc,"pc");
					HX_STACK_LINE(424)
					Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
					HX_STACK_LINE(424)
					Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
					HX_STACK_LINE(424)
					Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
					HX_STACK_LINE(424)
					return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
				}
				return null();
			}
		};
		HX_STACK_LINE(424)
		if (((_Function_1_1::Block(node) == (int)-1))){
			HX_STACK_LINE(427)
			this->fillRightConcaveEdgeEvent(edge,node->next);
		}
		else{
			struct _Function_2_1{
				inline static int Block( ::hxd::poly2tri::Edge &edge,::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",433,0x26a8ddc1)
					{
						HX_STACK_LINE(433)
						::hxd::poly2tri::Point pa = edge->q;		HX_STACK_VAR(pa,"pa");
						HX_STACK_LINE(433)
						::hxd::poly2tri::Point pb = node->next->next->point;		HX_STACK_VAR(pb,"pb");
						HX_STACK_LINE(433)
						::hxd::poly2tri::Point pc = edge->p;		HX_STACK_VAR(pc,"pc");
						HX_STACK_LINE(433)
						Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
						HX_STACK_LINE(433)
						Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
						HX_STACK_LINE(433)
						Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
						HX_STACK_LINE(433)
						return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
					}
					return null();
				}
			};
			HX_STACK_LINE(433)
			if (((_Function_2_1::Block(edge,node) == (int)-1))){
				HX_STACK_LINE(436)
				this->fillRightConvexEdgeEvent(edge,node->next);
			}
			else{
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillRightConvexEdgeEvent,(void))

Void Sweep_obj::fillLeftAboveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillLeftAboveEdgeEvent",0xd29cdadb,"hxd.poly2tri.Sweep.fillLeftAboveEdgeEvent","hxd/poly2tri/Sweep.hx",447,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(447)
		while((true)){
			HX_STACK_LINE(447)
			if ((!(((node->prev->point->x > edge->p->x))))){
				HX_STACK_LINE(447)
				break;
			}
			struct _Function_2_1{
				inline static int Block( ::hxd::poly2tri::Edge &edge,::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",450,0x26a8ddc1)
					{
						HX_STACK_LINE(450)
						::hxd::poly2tri::Point pa = edge->q;		HX_STACK_VAR(pa,"pa");
						HX_STACK_LINE(450)
						::hxd::poly2tri::Point pb = node->prev->point;		HX_STACK_VAR(pb,"pb");
						HX_STACK_LINE(450)
						::hxd::poly2tri::Point pc = edge->p;		HX_STACK_VAR(pc,"pc");
						HX_STACK_LINE(450)
						Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
						HX_STACK_LINE(450)
						Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
						HX_STACK_LINE(450)
						Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
						HX_STACK_LINE(450)
						return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
					}
					return null();
				}
			};
			HX_STACK_LINE(450)
			if (((_Function_2_1::Block(edge,node) == (int)1))){
				HX_STACK_LINE(452)
				this->fillLeftBelowEdgeEvent(edge,node);
			}
			else{
				HX_STACK_LINE(456)
				node = node->prev;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillLeftAboveEdgeEvent,(void))

Void Sweep_obj::fillLeftBelowEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillLeftBelowEdgeEvent",0xa074dcc7,"hxd.poly2tri.Sweep.fillLeftBelowEdgeEvent","hxd/poly2tri/Sweep.hx",463,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(463)
		if (((node->point->x > edge->p->x))){
			struct _Function_2_1{
				inline static int Block( ::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",465,0x26a8ddc1)
					{
						HX_STACK_LINE(465)
						::hxd::poly2tri::Point pa = node->point;		HX_STACK_VAR(pa,"pa");
						HX_STACK_LINE(465)
						::hxd::poly2tri::Point pb = node->prev->point;		HX_STACK_VAR(pb,"pb");
						HX_STACK_LINE(465)
						::hxd::poly2tri::Point pc = node->prev->prev->point;		HX_STACK_VAR(pc,"pc");
						HX_STACK_LINE(465)
						Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
						HX_STACK_LINE(465)
						Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
						HX_STACK_LINE(465)
						Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
						HX_STACK_LINE(465)
						return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
					}
					return null();
				}
			};
			HX_STACK_LINE(465)
			if (((_Function_2_1::Block(node) == (int)1))){
				HX_STACK_LINE(468)
				this->fillLeftConcaveEdgeEvent(edge,node);
			}
			else{
				HX_STACK_LINE(473)
				this->fillLeftConvexEdgeEvent(edge,node);
				HX_STACK_LINE(475)
				this->fillLeftBelowEdgeEvent(edge,node);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillLeftBelowEdgeEvent,(void))

Void Sweep_obj::fillLeftConvexEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillLeftConvexEdgeEvent",0x48d34abb,"hxd.poly2tri.Sweep.fillLeftConvexEdgeEvent","hxd/poly2tri/Sweep.hx",483,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		struct _Function_1_1{
			inline static int Block( ::hxd::poly2tri::Node &node){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",483,0x26a8ddc1)
				{
					HX_STACK_LINE(483)
					::hxd::poly2tri::Point pa = node->prev->point;		HX_STACK_VAR(pa,"pa");
					HX_STACK_LINE(483)
					::hxd::poly2tri::Point pb = node->prev->prev->point;		HX_STACK_VAR(pb,"pb");
					HX_STACK_LINE(483)
					::hxd::poly2tri::Point pc = node->prev->prev->prev->point;		HX_STACK_VAR(pc,"pc");
					HX_STACK_LINE(483)
					Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
					HX_STACK_LINE(483)
					Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
					HX_STACK_LINE(483)
					Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
					HX_STACK_LINE(483)
					return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
				}
				return null();
			}
		};
		HX_STACK_LINE(483)
		if (((_Function_1_1::Block(node) == (int)1))){
			HX_STACK_LINE(486)
			this->fillLeftConcaveEdgeEvent(edge,node->prev);
		}
		else{
			struct _Function_2_1{
				inline static int Block( ::hxd::poly2tri::Edge &edge,::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",492,0x26a8ddc1)
					{
						HX_STACK_LINE(492)
						::hxd::poly2tri::Point pa = edge->q;		HX_STACK_VAR(pa,"pa");
						HX_STACK_LINE(492)
						::hxd::poly2tri::Point pb = node->prev->prev->point;		HX_STACK_VAR(pb,"pb");
						HX_STACK_LINE(492)
						::hxd::poly2tri::Point pc = edge->p;		HX_STACK_VAR(pc,"pc");
						HX_STACK_LINE(492)
						Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
						HX_STACK_LINE(492)
						Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
						HX_STACK_LINE(492)
						Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
						HX_STACK_LINE(492)
						return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
					}
					return null();
				}
			};
			HX_STACK_LINE(492)
			if (((_Function_2_1::Block(edge,node) == (int)1))){
				HX_STACK_LINE(495)
				this->fillLeftConvexEdgeEvent(edge,node->prev);
			}
			else{
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillLeftConvexEdgeEvent,(void))

Void Sweep_obj::fillLeftConcaveEdgeEvent( ::hxd::poly2tri::Edge edge,::hxd::poly2tri::Node node){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","fillLeftConcaveEdgeEvent",0xffaffde9,"hxd.poly2tri.Sweep.fillLeftConcaveEdgeEvent","hxd/poly2tri/Sweep.hx",505,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_ARG(node,"node")
		HX_STACK_LINE(506)
		this->fill(node->prev);
		HX_STACK_LINE(507)
		if (((node->prev->point != edge->p))){
			struct _Function_2_1{
				inline static int Block( ::hxd::poly2tri::Edge &edge,::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",510,0x26a8ddc1)
					{
						HX_STACK_LINE(510)
						::hxd::poly2tri::Point pa = edge->q;		HX_STACK_VAR(pa,"pa");
						HX_STACK_LINE(510)
						::hxd::poly2tri::Point pb = node->prev->point;		HX_STACK_VAR(pb,"pb");
						HX_STACK_LINE(510)
						::hxd::poly2tri::Point pc = edge->p;		HX_STACK_VAR(pc,"pc");
						HX_STACK_LINE(510)
						Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
						HX_STACK_LINE(510)
						Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
						HX_STACK_LINE(510)
						Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
						HX_STACK_LINE(510)
						return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
					}
					return null();
				}
			};
			HX_STACK_LINE(510)
			if (((_Function_2_1::Block(edge,node) == (int)1))){
				struct _Function_3_1{
					inline static int Block( ::hxd::poly2tri::Node &node){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Sweep.hx",513,0x26a8ddc1)
						{
							HX_STACK_LINE(513)
							::hxd::poly2tri::Point pa = node->point;		HX_STACK_VAR(pa,"pa");
							HX_STACK_LINE(513)
							::hxd::poly2tri::Point pb = node->prev->point;		HX_STACK_VAR(pb,"pb");
							HX_STACK_LINE(513)
							::hxd::poly2tri::Point pc = node->prev->prev->point;		HX_STACK_VAR(pc,"pc");
							HX_STACK_LINE(513)
							Float detleft = (((pa->x - pc->x)) * ((pb->y - pc->y)));		HX_STACK_VAR(detleft,"detleft");
							HX_STACK_LINE(513)
							Float detright = (((pa->y - pc->y)) * ((pb->x - pc->x)));		HX_STACK_VAR(detright,"detright");
							HX_STACK_LINE(513)
							Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
							HX_STACK_LINE(513)
							return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
						}
						return null();
					}
				};
				HX_STACK_LINE(513)
				if (((_Function_3_1::Block(node) == (int)1))){
					HX_STACK_LINE(516)
					this->fillLeftConcaveEdgeEvent(edge,node);
				}
				else{
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Sweep_obj,fillLeftConcaveEdgeEvent,(void))

Void Sweep_obj::flipEdgeEvent( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","flipEdgeEvent",0xdafa96ff,"hxd.poly2tri.Sweep.flipEdgeEvent","hxd/poly2tri/Sweep.hx",529,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ep,"ep")
		HX_STACK_ARG(eq,"eq")
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(530)
		int _g = t->getPointIndexOffset(p,(int)0);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(530)
		::hxd::poly2tri::Triangle ot = t->neighbors->__get(_g).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(ot,"ot");
		HX_STACK_LINE(531)
		if (((ot == null()))){
			HX_STACK_LINE(535)
			HX_STACK_DO_THROW(HX_CSTRING("Sweep::[BUG:FIXME] FLIP failed due to missing triangle!"));
		}
		HX_STACK_LINE(537)
		::hxd::poly2tri::Point op;		HX_STACK_VAR(op,"op");
		HX_STACK_LINE(537)
		{
			HX_STACK_LINE(537)
			int _g1 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(537)
			::hxd::poly2tri::Point p1 = t->points->__get(_g1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p1,"p1");
			HX_STACK_LINE(537)
			int _g2 = ot->getPointIndexOffset(p1,(int)-1);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(537)
			op = ot->points->__get(_g2).StaticCast< ::hxd::poly2tri::Point >();
		}
		HX_STACK_LINE(539)
		int _g3 = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(539)
		::hxd::poly2tri::Point _g4 = t->points->__get(_g3).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(539)
		int _g5 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(539)
		::hxd::poly2tri::Point _g6 = t->points->__get(_g5).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(539)
		if ((::hxd::poly2tri::Utils_obj::inScanArea(p,_g4,_g6,op))){
			HX_STACK_LINE(542)
			::hxd::poly2tri::Triangle_obj::rotateTrianglePair(t,p,ot,op);
			HX_STACK_LINE(543)
			this->context->mapTriangleToNodes(t);
			HX_STACK_LINE(544)
			this->context->mapTriangleToNodes(ot);
			HX_STACK_LINE(547)
			if (((bool((p == eq)) && bool((op == ep))))){
				HX_STACK_LINE(549)
				if (((bool((eq == this->context->edge_event->constrained_edge->q)) && bool((ep == this->context->edge_event->constrained_edge->p))))){
					HX_STACK_LINE(550)
					t->markConstrainedEdgeByPoints(ep,eq);
					HX_STACK_LINE(551)
					ot->markConstrainedEdgeByPoints(ep,eq);
					HX_STACK_LINE(552)
					this->legalize(t);
					HX_STACK_LINE(553)
					this->legalize(ot);
				}
				else{
				}
			}
			else{
				HX_STACK_LINE(562)
				int o;		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(562)
				{
					HX_STACK_LINE(562)
					Float detleft = (((eq->x - ep->x)) * ((op->y - ep->y)));		HX_STACK_VAR(detleft,"detleft");
					HX_STACK_LINE(562)
					Float detright = (((eq->y - ep->y)) * ((op->x - ep->x)));		HX_STACK_VAR(detright,"detright");
					HX_STACK_LINE(562)
					Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
					HX_STACK_LINE(562)
					if (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))){
						HX_STACK_LINE(562)
						o = (int)0;
					}
					else{
						HX_STACK_LINE(562)
						if (((val > (int)0))){
							HX_STACK_LINE(562)
							o = (int)-1;
						}
						else{
							HX_STACK_LINE(562)
							o = (int)1;
						}
					}
				}
				HX_STACK_LINE(563)
				::hxd::poly2tri::Triangle _g7 = this->nextFlipTriangle(o,t,ot,p,op);		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(563)
				t = _g7;
				HX_STACK_LINE(564)
				this->flipEdgeEvent(ep,eq,t,p);
			}
		}
		else{
			HX_STACK_LINE(569)
			::hxd::poly2tri::Point newP = ::hxd::poly2tri::Sweep_obj::nextFlipPoint(ep,eq,ot,op);		HX_STACK_VAR(newP,"newP");
			HX_STACK_LINE(570)
			this->flipScanEdgeEvent(ep,eq,t,ot,newP);
			HX_STACK_LINE(571)
			this->edgeEventByPoints(ep,eq,t,p);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Sweep_obj,flipEdgeEvent,(void))

::hxd::poly2tri::Triangle Sweep_obj::nextFlipTriangle( int o,::hxd::poly2tri::Triangle t,::hxd::poly2tri::Triangle ot,::hxd::poly2tri::Point p,::hxd::poly2tri::Point op){
	HX_STACK_FRAME("hxd.poly2tri.Sweep","nextFlipTriangle",0xd8738ab9,"hxd.poly2tri.Sweep.nextFlipTriangle","hxd/poly2tri/Sweep.hx",577,0x26a8ddc1)
	HX_STACK_THIS(this)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(t,"t")
	HX_STACK_ARG(ot,"ot")
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(op,"op")
	HX_STACK_LINE(578)
	int edge_index;		HX_STACK_VAR(edge_index,"edge_index");
	HX_STACK_LINE(579)
	if (((o == (int)-1))){
		HX_STACK_LINE(582)
		int _g = ot->edgeIndex(p,op);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(582)
		edge_index = _g;
		HX_STACK_LINE(583)
		ot->delaunay_edge[edge_index] = true;
		HX_STACK_LINE(584)
		this->legalize(ot);
		HX_STACK_LINE(585)
		ot->clearDelunayEdges();
		HX_STACK_LINE(586)
		return t;
	}
	HX_STACK_LINE(590)
	int _g1 = t->edgeIndex(p,op);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(590)
	edge_index = _g1;
	HX_STACK_LINE(592)
	t->delaunay_edge[edge_index] = true;
	HX_STACK_LINE(593)
	this->legalize(t);
	HX_STACK_LINE(594)
	t->clearDelunayEdges();
	HX_STACK_LINE(595)
	return ot;
}


HX_DEFINE_DYNAMIC_FUNC5(Sweep_obj,nextFlipTriangle,return )

Void Sweep_obj::flipScanEdgeEvent( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle flip_triangle,::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p){
{
		HX_STACK_FRAME("hxd.poly2tri.Sweep","flipScanEdgeEvent",0x0d3a3ac2,"hxd.poly2tri.Sweep.flipScanEdgeEvent","hxd/poly2tri/Sweep.hx",618,0x26a8ddc1)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ep,"ep")
		HX_STACK_ARG(eq,"eq")
		HX_STACK_ARG(flip_triangle,"flip_triangle")
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(619)
		int _g = t->getPointIndexOffset(p,(int)0);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(619)
		::hxd::poly2tri::Triangle ot = t->neighbors->__get(_g).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(ot,"ot");
		HX_STACK_LINE(623)
		if (((ot == null()))){
			HX_STACK_LINE(623)
			HX_STACK_DO_THROW(HX_CSTRING("Sweep::[BUG:FIXME] FLIP failed due to missing triangle"));
		}
		HX_STACK_LINE(624)
		::hxd::poly2tri::Point op;		HX_STACK_VAR(op,"op");
		HX_STACK_LINE(624)
		{
			HX_STACK_LINE(624)
			int _g1 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(624)
			::hxd::poly2tri::Point p1 = t->points->__get(_g1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p1,"p1");
			HX_STACK_LINE(624)
			int _g2 = ot->getPointIndexOffset(p1,(int)-1);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(624)
			op = ot->points->__get(_g2).StaticCast< ::hxd::poly2tri::Point >();
		}
		HX_STACK_LINE(626)
		int _g3 = flip_triangle->getPointIndexOffset(eq,(int)1);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(626)
		::hxd::poly2tri::Point _g4 = flip_triangle->points->__get(_g3).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(626)
		int _g5 = flip_triangle->getPointIndexOffset(eq,(int)-1);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(626)
		::hxd::poly2tri::Point _g6 = flip_triangle->points->__get(_g5).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(626)
		if ((::hxd::poly2tri::Utils_obj::inScanArea(eq,_g4,_g6,op))){
			HX_STACK_LINE(629)
			this->flipEdgeEvent(eq,op,ot,op);
		}
		else{
			HX_STACK_LINE(640)
			::hxd::poly2tri::Point newP = ::hxd::poly2tri::Sweep_obj::nextFlipPoint(ep,eq,ot,op);		HX_STACK_VAR(newP,"newP");
			HX_STACK_LINE(641)
			this->flipScanEdgeEvent(ep,eq,flip_triangle,ot,newP);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC5(Sweep_obj,flipScanEdgeEvent,(void))

::hxd::poly2tri::Point Sweep_obj::nextFlipPoint( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq,::hxd::poly2tri::Triangle ot,::hxd::poly2tri::Point op){
	HX_STACK_FRAME("hxd.poly2tri.Sweep","nextFlipPoint",0x715c77bf,"hxd.poly2tri.Sweep.nextFlipPoint","hxd/poly2tri/Sweep.hx",599,0x26a8ddc1)
	HX_STACK_ARG(ep,"ep")
	HX_STACK_ARG(eq,"eq")
	HX_STACK_ARG(ot,"ot")
	HX_STACK_ARG(op,"op")
	HX_STACK_LINE(600)
	int o2d;		HX_STACK_VAR(o2d,"o2d");
	HX_STACK_LINE(600)
	{
		HX_STACK_LINE(600)
		Float detleft = (((eq->x - ep->x)) * ((op->y - ep->y)));		HX_STACK_VAR(detleft,"detleft");
		HX_STACK_LINE(600)
		Float detright = (((eq->y - ep->y)) * ((op->x - ep->x)));		HX_STACK_VAR(detright,"detright");
		HX_STACK_LINE(600)
		Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
		HX_STACK_LINE(600)
		if (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))){
			HX_STACK_LINE(600)
			o2d = (int)0;
		}
		else{
			HX_STACK_LINE(600)
			if (((val > (int)0))){
				HX_STACK_LINE(600)
				o2d = (int)-1;
			}
			else{
				HX_STACK_LINE(600)
				o2d = (int)1;
			}
		}
	}
	HX_STACK_LINE(601)
	if (((o2d == (int)1))){
		HX_STACK_LINE(604)
		int _g = ot->getPointIndexOffset(op,(int)1);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(604)
		return ot->points->__get(_g).StaticCast< ::hxd::poly2tri::Point >();
	}
	else{
		HX_STACK_LINE(606)
		if (((o2d == (int)-1))){
			HX_STACK_LINE(609)
			int _g1 = ot->getPointIndexOffset(op,(int)-1);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(609)
			return ot->points->__get(_g1).StaticCast< ::hxd::poly2tri::Point >();
		}
		else{
			HX_STACK_LINE(613)
			HX_STACK_DO_THROW(HX_CSTRING("Sweep:: [Unsupported] Sweep.NextFlipPoint: opposing point on constrained edge!"));
		}
	}
	HX_STACK_LINE(601)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Sweep_obj,nextFlipPoint,return )


Sweep_obj::Sweep_obj()
{
}

void Sweep_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Sweep);
	HX_MARK_MEMBER_NAME(context,"context");
	HX_MARK_END_CLASS();
}

void Sweep_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(context,"context");
}

Dynamic Sweep_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"fill") ) { return fill_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"context") ) { return context; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"legalize") ) { return legalize_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fillBasin") ) { return fillBasin_dyn(); }
		if (HX_FIELD_EQ(inName,"isShallow") ) { return isShallow_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"pointEvent") ) { return pointEvent_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"triangulate") ) { return triangulate_dyn(); }
		if (HX_FIELD_EQ(inName,"sweepPoints") ) { return sweepPoints_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"fillBasinReq") ) { return fillBasinReq_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"nextFlipPoint") ) { return nextFlipPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"fillEdgeEvent") ) { return fillEdgeEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"flipEdgeEvent") ) { return flipEdgeEvent_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"edgeEventByEdge") ) { return edgeEventByEdge_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"newFrontTriangle") ) { return newFrontTriangle_dyn(); }
		if (HX_FIELD_EQ(inName,"nextFlipTriangle") ) { return nextFlipTriangle_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"edgeEventByPoints") ) { return edgeEventByPoints_dyn(); }
		if (HX_FIELD_EQ(inName,"flipScanEdgeEvent") ) { return flipScanEdgeEvent_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"fillAdvancingFront") ) { return fillAdvancingFront_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"finalizationPolygon") ) { return finalizationPolygon_dyn(); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"fillLeftAboveEdgeEvent") ) { return fillLeftAboveEdgeEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"fillLeftBelowEdgeEvent") ) { return fillLeftBelowEdgeEvent_dyn(); }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"fillRightAboveEdgeEvent") ) { return fillRightAboveEdgeEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"fillRightBelowEdgeEvent") ) { return fillRightBelowEdgeEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"fillLeftConvexEdgeEvent") ) { return fillLeftConvexEdgeEvent_dyn(); }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"fillRightConvexEdgeEvent") ) { return fillRightConvexEdgeEvent_dyn(); }
		if (HX_FIELD_EQ(inName,"fillLeftConcaveEdgeEvent") ) { return fillLeftConcaveEdgeEvent_dyn(); }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"fillRightConcaveEdgeEvent") ) { return fillRightConcaveEdgeEvent_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Sweep_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"context") ) { context=inValue.Cast< ::hxd::poly2tri::SweepContext >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Sweep_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("context"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("nextFlipPoint"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::poly2tri::SweepContext*/ ,(int)offsetof(Sweep_obj,context),HX_CSTRING("context")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("context"),
	HX_CSTRING("triangulate"),
	HX_CSTRING("sweepPoints"),
	HX_CSTRING("finalizationPolygon"),
	HX_CSTRING("pointEvent"),
	HX_CSTRING("edgeEventByEdge"),
	HX_CSTRING("edgeEventByPoints"),
	HX_CSTRING("newFrontTriangle"),
	HX_CSTRING("fill"),
	HX_CSTRING("fillAdvancingFront"),
	HX_CSTRING("legalize"),
	HX_CSTRING("fillBasin"),
	HX_CSTRING("fillBasinReq"),
	HX_CSTRING("isShallow"),
	HX_CSTRING("fillEdgeEvent"),
	HX_CSTRING("fillRightAboveEdgeEvent"),
	HX_CSTRING("fillRightBelowEdgeEvent"),
	HX_CSTRING("fillRightConcaveEdgeEvent"),
	HX_CSTRING("fillRightConvexEdgeEvent"),
	HX_CSTRING("fillLeftAboveEdgeEvent"),
	HX_CSTRING("fillLeftBelowEdgeEvent"),
	HX_CSTRING("fillLeftConvexEdgeEvent"),
	HX_CSTRING("fillLeftConcaveEdgeEvent"),
	HX_CSTRING("flipEdgeEvent"),
	HX_CSTRING("nextFlipTriangle"),
	HX_CSTRING("flipScanEdgeEvent"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Sweep_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Sweep_obj::__mClass,"__mClass");
};

#endif

Class Sweep_obj::__mClass;

void Sweep_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Sweep"), hx::TCanCast< Sweep_obj> ,sStaticFields,sMemberFields,
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

void Sweep_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
