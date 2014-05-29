#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Constants
#include <hxd/poly2tri/Constants.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Edge
#include <hxd/poly2tri/Edge.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Triangle
#include <hxd/poly2tri/Triangle.h>
#endif
namespace hxd{
namespace poly2tri{

Void Triangle_obj::__construct(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2,::hxd::poly2tri::Point p3,hx::Null< bool >  __o_fixOrientation,hx::Null< bool >  __o_checkOrientation)
{
HX_STACK_FRAME("hxd.poly2tri.Triangle","new",0xc95cb4c9,"hxd.poly2tri.Triangle.new","hxd/poly2tri/Triangle.hx",3,0xe4d28ae7)
HX_STACK_THIS(this)
HX_STACK_ARG(p1,"p1")
HX_STACK_ARG(p2,"p2")
HX_STACK_ARG(p3,"p3")
HX_STACK_ARG(__o_fixOrientation,"fixOrientation")
HX_STACK_ARG(__o_checkOrientation,"checkOrientation")
bool fixOrientation = __o_fixOrientation.Default(false);
bool checkOrientation = __o_checkOrientation.Default(true);
{
	HX_STACK_LINE(11)
	this->id = (int)-1;
	HX_STACK_LINE(23)
	if ((fixOrientation)){
		struct _Function_2_1{
			inline static int Block( ::hxd::poly2tri::Point &p1,::hxd::poly2tri::Point &p3,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",25,0xe4d28ae7)
				{
					HX_STACK_LINE(25)
					Float detleft = (((p1->x - p3->x)) * ((p2->y - p3->y)));		HX_STACK_VAR(detleft,"detleft");
					HX_STACK_LINE(25)
					Float detright = (((p1->y - p3->y)) * ((p2->x - p3->x)));		HX_STACK_VAR(detright,"detright");
					HX_STACK_LINE(25)
					Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
					HX_STACK_LINE(25)
					return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
				}
				return null();
			}
		};
		HX_STACK_LINE(25)
		if (((_Function_2_1::Block(p1,p3,p2) == (int)1))){
			HX_STACK_LINE(27)
			::hxd::poly2tri::Point pt = p3;		HX_STACK_VAR(pt,"pt");
			HX_STACK_LINE(28)
			p3 = p2;
			HX_STACK_LINE(29)
			p2 = pt;
		}
	}
	struct _Function_1_1{
		inline static int Block( ::hxd::poly2tri::Point &p1,::hxd::poly2tri::Point &p3,::hxd::poly2tri::Point &p2){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",33,0xe4d28ae7)
			{
				HX_STACK_LINE(33)
				Float detleft = (((p3->x - p1->x)) * ((p2->y - p1->y)));		HX_STACK_VAR(detleft,"detleft");
				HX_STACK_LINE(33)
				Float detright = (((p3->y - p1->y)) * ((p2->x - p1->x)));		HX_STACK_VAR(detright,"detright");
				HX_STACK_LINE(33)
				Float val = (detleft - detright);		HX_STACK_VAR(val,"val");
				HX_STACK_LINE(33)
				return (  (((bool((val > -(::hxd::poly2tri::Constants_obj::EPSILON))) && bool((val < ::hxd::poly2tri::Constants_obj::EPSILON))))) ? int((int)0) : int((  (((val > (int)0))) ? int((int)-1) : int((int)1) )) );
			}
			return null();
		}
	};
	HX_STACK_LINE(33)
	if (((bool(checkOrientation) && bool((_Function_1_1::Block(p1,p3,p2) != (int)1))))){
		HX_STACK_LINE(34)
		HX_STACK_DO_THROW(HX_CSTRING("Triangle::Triangle must defined with Orientation.CW"));
	}
	HX_STACK_LINE(36)
	this->points = Array_obj< ::Dynamic >::__new().Add(p1).Add(p2).Add(p3);
	HX_STACK_LINE(40)
	this->neighbors = Array_obj< ::Dynamic >::__new().Add(null()).Add(null()).Add(null());
	HX_STACK_LINE(41)
	this->constrained_edge = Array_obj< bool >::__new().Add(false).Add(false).Add(false);
	HX_STACK_LINE(42)
	this->delaunay_edge = Array_obj< bool >::__new().Add(false).Add(false).Add(false);
}
;
	return null();
}

//Triangle_obj::~Triangle_obj() { }

Dynamic Triangle_obj::__CreateEmpty() { return  new Triangle_obj; }
hx::ObjectPtr< Triangle_obj > Triangle_obj::__new(::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2,::hxd::poly2tri::Point p3,hx::Null< bool >  __o_fixOrientation,hx::Null< bool >  __o_checkOrientation)
{  hx::ObjectPtr< Triangle_obj > result = new Triangle_obj();
	result->__construct(p1,p2,p3,__o_fixOrientation,__o_checkOrientation);
	return result;}

Dynamic Triangle_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Triangle_obj > result = new Triangle_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

bool Triangle_obj::containsPoint( ::hxd::poly2tri::Point point){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","containsPoint",0xe8b39b5a,"hxd.poly2tri.Triangle.containsPoint","hxd/poly2tri/Triangle.hx",54,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	struct _Function_1_1{
		inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &point){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",54,0xe4d28ae7)
			{
				HX_STACK_LINE(54)
				::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
				HX_STACK_LINE(54)
				return (bool((point->x == that->x)) && bool((point->y == that->y)));
			}
			return null();
		}
	};
	struct _Function_1_2{
		inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &point){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",54,0xe4d28ae7)
			{
				HX_STACK_LINE(54)
				::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
				HX_STACK_LINE(54)
				return (bool((point->x == that->x)) && bool((point->y == that->y)));
			}
			return null();
		}
	};
	struct _Function_1_3{
		inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &point){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",54,0xe4d28ae7)
			{
				HX_STACK_LINE(54)
				::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
				HX_STACK_LINE(54)
				return (bool((point->x == that->x)) && bool((point->y == that->y)));
			}
			return null();
		}
	};
	HX_STACK_LINE(54)
	return (bool((bool(_Function_1_1::Block(this,point)) || bool(_Function_1_2::Block(this,point)))) || bool(_Function_1_3::Block(this,point)));
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,containsPoint,return )

bool Triangle_obj::containsEdgePoints( ::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","containsEdgePoints",0x899ceef6,"hxd.poly2tri.Triangle.containsEdgePoints","hxd/poly2tri/Triangle.hx",60,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p1,"p1")
	HX_STACK_ARG(p2,"p2")
	HX_STACK_LINE(60)
	if ((this->containsPoint(p1))){
		HX_STACK_LINE(60)
		return this->containsPoint(p2);
	}
	else{
		HX_STACK_LINE(60)
		return false;
	}
	HX_STACK_LINE(60)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,containsEdgePoints,return )

Void Triangle_obj::markNeighbor( ::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","markNeighbor",0x0a3c8c96,"hxd.poly2tri.Triangle.markNeighbor","hxd/poly2tri/Triangle.hx",73,0xe4d28ae7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(p1,"p1")
		HX_STACK_ARG(p2,"p2")
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",74,0xe4d28ae7)
				{
					HX_STACK_LINE(74)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(74)
					return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_2{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",74,0xe4d28ae7)
				{
					HX_STACK_LINE(74)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(74)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_3{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",74,0xe4d28ae7)
				{
					HX_STACK_LINE(74)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(74)
					return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_4{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",74,0xe4d28ae7)
				{
					HX_STACK_LINE(74)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(74)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(74)
		if (((bool((bool(_Function_1_1::Block(this,p1)) && bool(_Function_1_2::Block(this,p2)))) || bool((bool(_Function_1_3::Block(this,p1)) && bool(_Function_1_4::Block(this,p2))))))){
			HX_STACK_LINE(76)
			this->neighbors[(int)0] = t;
			HX_STACK_LINE(76)
			return null();
		}
		struct _Function_1_5{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",78,0xe4d28ae7)
				{
					HX_STACK_LINE(78)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(78)
					return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_6{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",78,0xe4d28ae7)
				{
					HX_STACK_LINE(78)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(78)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_7{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",78,0xe4d28ae7)
				{
					HX_STACK_LINE(78)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(78)
					return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_8{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",78,0xe4d28ae7)
				{
					HX_STACK_LINE(78)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(78)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(78)
		if (((bool((bool(_Function_1_5::Block(this,p1)) && bool(_Function_1_6::Block(this,p2)))) || bool((bool(_Function_1_7::Block(this,p1)) && bool(_Function_1_8::Block(this,p2))))))){
			HX_STACK_LINE(80)
			this->neighbors[(int)1] = t;
			HX_STACK_LINE(80)
			return null();
		}
		struct _Function_1_9{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",82,0xe4d28ae7)
				{
					HX_STACK_LINE(82)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(82)
					return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_10{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",82,0xe4d28ae7)
				{
					HX_STACK_LINE(82)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(82)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_11{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",82,0xe4d28ae7)
				{
					HX_STACK_LINE(82)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(82)
					return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_12{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",82,0xe4d28ae7)
				{
					HX_STACK_LINE(82)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(82)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(82)
		if (((bool((bool(_Function_1_9::Block(this,p1)) && bool(_Function_1_10::Block(this,p2)))) || bool((bool(_Function_1_11::Block(this,p1)) && bool(_Function_1_12::Block(this,p2))))))){
			HX_STACK_LINE(84)
			this->neighbors[(int)2] = t;
			HX_STACK_LINE(84)
			return null();
		}
		HX_STACK_LINE(86)
		HX_STACK_DO_THROW(HX_CSTRING("Invalid markNeighbor call (1)!"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Triangle_obj,markNeighbor,(void))

Void Triangle_obj::markNeighborTriangle( ::hxd::poly2tri::Triangle that){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","markNeighborTriangle",0xac938d7e,"hxd.poly2tri.Triangle.markNeighborTriangle","hxd/poly2tri/Triangle.hx",91,0xe4d28ae7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(that,"that")
		HX_STACK_LINE(93)
		if ((that->containsEdgePoints(this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >(),this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >()))){
			HX_STACK_LINE(95)
			this->neighbors[(int)0] = that;
			HX_STACK_LINE(96)
			that->markNeighbor(hx::ObjectPtr<OBJ_>(this),this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >(),this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >());
			HX_STACK_LINE(97)
			return null();
		}
		HX_STACK_LINE(100)
		if ((that->containsEdgePoints(this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >(),this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >()))){
			HX_STACK_LINE(101)
			this->neighbors[(int)1] = that;
			HX_STACK_LINE(102)
			that->markNeighbor(hx::ObjectPtr<OBJ_>(this),this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >(),this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >());
			HX_STACK_LINE(103)
			return null();
		}
		HX_STACK_LINE(106)
		if ((that->containsEdgePoints(this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >(),this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >()))){
			HX_STACK_LINE(107)
			this->neighbors[(int)2] = that;
			HX_STACK_LINE(108)
			that->markNeighbor(hx::ObjectPtr<OBJ_>(this),this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >(),this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >());
			HX_STACK_LINE(109)
			return null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,markNeighborTriangle,(void))

int Triangle_obj::getPointIndexOffset( ::hxd::poly2tri::Point p,hx::Null< int >  __o_offset){
int offset = __o_offset.Default(0);
	HX_STACK_FRAME("hxd.poly2tri.Triangle","getPointIndexOffset",0xb47354f4,"hxd.poly2tri.Triangle.getPointIndexOffset","hxd/poly2tri/Triangle.hx",117,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(offset,"offset")
{
		HX_STACK_LINE(118)
		int no = offset;		HX_STACK_VAR(no,"no");
		HX_STACK_LINE(119)
		{
			HX_STACK_LINE(119)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(119)
			while((true)){
				HX_STACK_LINE(119)
				if ((!(((_g < (int)3))))){
					HX_STACK_LINE(119)
					break;
				}
				HX_STACK_LINE(119)
				int n = (_g)++;		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(121)
				while((true)){
					HX_STACK_LINE(121)
					if ((!(((no < (int)0))))){
						HX_STACK_LINE(121)
						break;
					}
					HX_STACK_LINE(121)
					hx::AddEq(no,(int)3);
				}
				HX_STACK_LINE(122)
				while((true)){
					HX_STACK_LINE(122)
					if ((!(((no > (int)2))))){
						HX_STACK_LINE(122)
						break;
					}
					HX_STACK_LINE(122)
					hx::SubEq(no,(int)3);
				}
				struct _Function_3_1{
					inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p,int &n){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",123,0xe4d28ae7)
						{
							HX_STACK_LINE(123)
							::hxd::poly2tri::Point that = __this->points->__get(n).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
							HX_STACK_LINE(123)
							return (bool((p->x == that->x)) && bool((p->y == that->y)));
						}
						return null();
					}
				};
				HX_STACK_LINE(123)
				if ((_Function_3_1::Block(this,p,n))){
					HX_STACK_LINE(123)
					return no;
				}
				HX_STACK_LINE(124)
				(no)++;
			}
		}
		HX_STACK_LINE(127)
		HX_STACK_DO_THROW(HX_CSTRING("Triangle::Point not in triangle"));
		HX_STACK_LINE(127)
		return (int)0;
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,getPointIndexOffset,return )

::hxd::poly2tri::Point Triangle_obj::pointCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","pointCW",0x0f7f6fed,"hxd.poly2tri.Triangle.pointCW","hxd/poly2tri/Triangle.hx",151,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(152)
	int _g = this->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(152)
	return this->points->__get(_g).StaticCast< ::hxd::poly2tri::Point >();
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,pointCW,return )

::hxd::poly2tri::Point Triangle_obj::pointCCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","pointCCW",0x80026e5e,"hxd.poly2tri.Triangle.pointCCW","hxd/poly2tri/Triangle.hx",156,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(157)
	int _g = this->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(157)
	return this->points->__get(_g).StaticCast< ::hxd::poly2tri::Point >();
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,pointCCW,return )

::hxd::poly2tri::Triangle Triangle_obj::neighborCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","neighborCW",0xa175badd,"hxd.poly2tri.Triangle.neighborCW","hxd/poly2tri/Triangle.hx",161,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(162)
	int _g = this->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(162)
	return this->neighbors->__get(_g).StaticCast< ::hxd::poly2tri::Triangle >();
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,neighborCW,return )

::hxd::poly2tri::Triangle Triangle_obj::neighborCCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","neighborCCW",0xa58db56e,"hxd.poly2tri.Triangle.neighborCCW","hxd/poly2tri/Triangle.hx",166,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(167)
	int _g = this->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(167)
	return this->neighbors->__get(_g).StaticCast< ::hxd::poly2tri::Triangle >();
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,neighborCCW,return )

bool Triangle_obj::getConstrainedEdgeCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","getConstrainedEdgeCW",0x32b1b528,"hxd.poly2tri.Triangle.getConstrainedEdgeCW","hxd/poly2tri/Triangle.hx",170,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(170)
	int _g = this->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(170)
	return this->constrained_edge->__get(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,getConstrainedEdgeCW,return )

bool Triangle_obj::setConstrainedEdgeCW( ::hxd::poly2tri::Point p,bool ce){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","setConstrainedEdgeCW",0xff696c9c,"hxd.poly2tri.Triangle.setConstrainedEdgeCW","hxd/poly2tri/Triangle.hx",171,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(ce,"ce")
	HX_STACK_LINE(171)
	int _g = this->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(171)
	return this->constrained_edge[_g] = ce;
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,setConstrainedEdgeCW,return )

bool Triangle_obj::getConstrainedEdgeCCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","getConstrainedEdgeCCW",0x28ccbcc3,"hxd.poly2tri.Triangle.getConstrainedEdgeCCW","hxd/poly2tri/Triangle.hx",173,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(173)
	int _g = this->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(173)
	return this->constrained_edge->__get(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,getConstrainedEdgeCCW,return )

bool Triangle_obj::setConstrainedEdgeCCW( ::hxd::poly2tri::Point p,bool ce){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","setConstrainedEdgeCCW",0x7cd58acf,"hxd.poly2tri.Triangle.setConstrainedEdgeCCW","hxd/poly2tri/Triangle.hx",174,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(ce,"ce")
	HX_STACK_LINE(174)
	int _g = this->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(174)
	return this->constrained_edge[_g] = ce;
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,setConstrainedEdgeCCW,return )

bool Triangle_obj::getDelaunayEdgeCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","getDelaunayEdgeCW",0x994117b7,"hxd.poly2tri.Triangle.getDelaunayEdgeCW","hxd/poly2tri/Triangle.hx",176,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(176)
	int _g = this->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(176)
	return this->delaunay_edge->__get(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,getDelaunayEdgeCW,return )

bool Triangle_obj::setDelaunayEdgeCW( ::hxd::poly2tri::Point p,bool e){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","setDelaunayEdgeCW",0xbcaeefc3,"hxd.poly2tri.Triangle.setDelaunayEdgeCW","hxd/poly2tri/Triangle.hx",177,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(177)
	int _g = this->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(177)
	return this->delaunay_edge[_g] = e;
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,setDelaunayEdgeCW,return )

bool Triangle_obj::getDelaunayEdgeCCW( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","getDelaunayEdgeCCW",0x7fb39754,"hxd.poly2tri.Triangle.getDelaunayEdgeCCW","hxd/poly2tri/Triangle.hx",179,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(179)
	int _g = this->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(179)
	return this->delaunay_edge->__get(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,getDelaunayEdgeCCW,return )

bool Triangle_obj::setDelaunayEdgeCCW( ::hxd::poly2tri::Point p,bool e){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","setDelaunayEdgeCCW",0x5c62c9c8,"hxd.poly2tri.Triangle.setDelaunayEdgeCCW","hxd/poly2tri/Triangle.hx",180,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(e,"e")
	HX_STACK_LINE(180)
	int _g = this->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(180)
	return this->delaunay_edge[_g] = e;
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,setDelaunayEdgeCCW,return )

::hxd::poly2tri::Triangle Triangle_obj::neighborAcross( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","neighborAcross",0x2f301c48,"hxd.poly2tri.Triangle.neighborAcross","hxd/poly2tri/Triangle.hx",186,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(186)
	int _g = this->getPointIndexOffset(p,(int)0);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(186)
	return this->neighbors->__get(_g).StaticCast< ::hxd::poly2tri::Triangle >();
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,neighborAcross,return )

::hxd::poly2tri::Point Triangle_obj::oppositePoint( ::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","oppositePoint",0xe53c8792,"hxd.poly2tri.Triangle.oppositePoint","hxd/poly2tri/Triangle.hx",190,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(t,"t")
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(190)
	int _g = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(190)
	::hxd::poly2tri::Point p1 = t->points->__get(_g).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(p1,"p1");
	HX_STACK_LINE(190)
	int _g1 = this->getPointIndexOffset(p1,(int)-1);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(190)
	return this->points->__get(_g1).StaticCast< ::hxd::poly2tri::Point >();
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,oppositePoint,return )

Void Triangle_obj::legalize( ::hxd::poly2tri::Point opoint,::hxd::poly2tri::Point npoint){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","legalize",0xad490fb2,"hxd.poly2tri.Triangle.legalize","hxd/poly2tri/Triangle.hx",200,0xe4d28ae7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(opoint,"opoint")
		HX_STACK_ARG(npoint,"npoint")
		HX_STACK_LINE(201)
		if (((npoint == null()))){
			HX_STACK_LINE(203)
			this->legalize(this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >(),opoint);
			HX_STACK_LINE(204)
			return null();
		}
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &opoint){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",207,0xe4d28ae7)
				{
					HX_STACK_LINE(207)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(207)
					return (bool((opoint->x == that->x)) && bool((opoint->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(207)
		if ((_Function_1_1::Block(this,opoint))){
			HX_STACK_LINE(208)
			this->points[(int)1] = this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();
			HX_STACK_LINE(209)
			this->points[(int)0] = this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();
			HX_STACK_LINE(210)
			this->points[(int)2] = npoint;
		}
		else{
			struct _Function_2_1{
				inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &opoint){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",211,0xe4d28ae7)
					{
						HX_STACK_LINE(211)
						::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
						HX_STACK_LINE(211)
						return (bool((opoint->x == that->x)) && bool((opoint->y == that->y)));
					}
					return null();
				}
			};
			HX_STACK_LINE(211)
			if ((_Function_2_1::Block(this,opoint))){
				HX_STACK_LINE(212)
				this->points[(int)2] = this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();
				HX_STACK_LINE(213)
				this->points[(int)1] = this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();
				HX_STACK_LINE(214)
				this->points[(int)0] = npoint;
			}
			else{
				struct _Function_3_1{
					inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &opoint){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",215,0xe4d28ae7)
						{
							HX_STACK_LINE(215)
							::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
							HX_STACK_LINE(215)
							return (bool((opoint->x == that->x)) && bool((opoint->y == that->y)));
						}
						return null();
					}
				};
				HX_STACK_LINE(215)
				if ((_Function_3_1::Block(this,opoint))){
					HX_STACK_LINE(216)
					this->points[(int)0] = this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();
					HX_STACK_LINE(217)
					this->points[(int)2] = this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();
					HX_STACK_LINE(218)
					this->points[(int)1] = npoint;
				}
				else{
					HX_STACK_LINE(220)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid js.poly2tri.Triangle.Legalize call!"));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,legalize,(void))

int Triangle_obj::index( ::hxd::poly2tri::Point p){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","index",0x866e2bbb,"hxd.poly2tri.Triangle.index","hxd/poly2tri/Triangle.hx",232,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(232)
	return this->getPointIndexOffset(p,(int)0);
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,index,return )

int Triangle_obj::edgeIndex( ::hxd::poly2tri::Point p1,::hxd::poly2tri::Point p2){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","edgeIndex",0x6a7cdebe,"hxd.poly2tri.Triangle.edgeIndex","hxd/poly2tri/Triangle.hx",237,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p1,"p1")
	HX_STACK_ARG(p2,"p2")
	struct _Function_1_1{
		inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",238,0xe4d28ae7)
			{
				HX_STACK_LINE(238)
				::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
				HX_STACK_LINE(238)
				return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
			}
			return null();
		}
	};
	HX_STACK_LINE(238)
	if ((_Function_1_1::Block(this,p1))){
		struct _Function_2_1{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",240,0xe4d28ae7)
				{
					HX_STACK_LINE(240)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(240)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(240)
		if ((_Function_2_1::Block(this,p2))){
			HX_STACK_LINE(240)
			return (int)2;
		}
		struct _Function_2_2{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",241,0xe4d28ae7)
				{
					HX_STACK_LINE(241)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(241)
					return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(241)
		if ((_Function_2_2::Block(this,p2))){
			HX_STACK_LINE(241)
			return (int)1;
		}
	}
	else{
		struct _Function_2_1{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",243,0xe4d28ae7)
				{
					HX_STACK_LINE(243)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(243)
					return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(243)
		if ((_Function_2_1::Block(this,p1))){
			struct _Function_3_1{
				inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",245,0xe4d28ae7)
					{
						HX_STACK_LINE(245)
						::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
						HX_STACK_LINE(245)
						return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
					}
					return null();
				}
			};
			HX_STACK_LINE(245)
			if ((_Function_3_1::Block(this,p2))){
				HX_STACK_LINE(245)
				return (int)0;
			}
			struct _Function_3_2{
				inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",246,0xe4d28ae7)
					{
						HX_STACK_LINE(246)
						::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
						HX_STACK_LINE(246)
						return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
					}
					return null();
				}
			};
			HX_STACK_LINE(246)
			if ((_Function_3_2::Block(this,p2))){
				HX_STACK_LINE(246)
				return (int)2;
			}
		}
		else{
			struct _Function_3_1{
				inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p1){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",248,0xe4d28ae7)
					{
						HX_STACK_LINE(248)
						::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
						HX_STACK_LINE(248)
						return (bool((p1->x == that->x)) && bool((p1->y == that->y)));
					}
					return null();
				}
			};
			HX_STACK_LINE(248)
			if ((_Function_3_1::Block(this,p1))){
				struct _Function_4_1{
					inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",250,0xe4d28ae7)
						{
							HX_STACK_LINE(250)
							::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
							HX_STACK_LINE(250)
							return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
						}
						return null();
					}
				};
				HX_STACK_LINE(250)
				if ((_Function_4_1::Block(this,p2))){
					HX_STACK_LINE(250)
					return (int)1;
				}
				struct _Function_4_2{
					inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p2){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",251,0xe4d28ae7)
						{
							HX_STACK_LINE(251)
							::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
							HX_STACK_LINE(251)
							return (bool((p2->x == that->x)) && bool((p2->y == that->y)));
						}
						return null();
					}
				};
				HX_STACK_LINE(251)
				if ((_Function_4_2::Block(this,p2))){
					HX_STACK_LINE(251)
					return (int)0;
				}
			}
		}
	}
	HX_STACK_LINE(253)
	return (int)-1;
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,edgeIndex,return )

Void Triangle_obj::markConstrainedEdgeByEdge( ::hxd::poly2tri::Edge edge){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","markConstrainedEdgeByEdge",0xaa354ba3,"hxd.poly2tri.Triangle.markConstrainedEdgeByEdge","hxd/poly2tri/Triangle.hx",259,0xe4d28ae7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(edge,"edge")
		HX_STACK_LINE(259)
		this->markConstrainedEdgeByPoints(edge->p,edge->q);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Triangle_obj,markConstrainedEdgeByEdge,(void))

Void Triangle_obj::markConstrainedEdgeByPoints( ::hxd::poly2tri::Point p,::hxd::poly2tri::Point q){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","markConstrainedEdgeByPoints",0x5788bb09,"hxd.poly2tri.Triangle.markConstrainedEdgeByPoints","hxd/poly2tri/Triangle.hx",263,0xe4d28ae7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_ARG(q,"q")
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &q){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",264,0xe4d28ae7)
				{
					HX_STACK_LINE(264)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(264)
					return (bool((q->x == that->x)) && bool((q->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_2{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",264,0xe4d28ae7)
				{
					HX_STACK_LINE(264)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(264)
					return (bool((p->x == that->x)) && bool((p->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_3{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &q){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",264,0xe4d28ae7)
				{
					HX_STACK_LINE(264)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(264)
					return (bool((q->x == that->x)) && bool((q->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_4{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",264,0xe4d28ae7)
				{
					HX_STACK_LINE(264)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(264)
					return (bool((p->x == that->x)) && bool((p->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(264)
		if (((bool((bool(_Function_1_1::Block(this,q)) && bool(_Function_1_2::Block(this,p)))) || bool((bool(_Function_1_3::Block(this,q)) && bool(_Function_1_4::Block(this,p))))))){
			HX_STACK_LINE(265)
			this->constrained_edge[(int)2] = true;
			HX_STACK_LINE(266)
			return null();
		}
		struct _Function_1_5{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &q){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",269,0xe4d28ae7)
				{
					HX_STACK_LINE(269)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(269)
					return (bool((q->x == that->x)) && bool((q->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_6{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",269,0xe4d28ae7)
				{
					HX_STACK_LINE(269)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(269)
					return (bool((p->x == that->x)) && bool((p->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_7{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &q){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",269,0xe4d28ae7)
				{
					HX_STACK_LINE(269)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(269)
					return (bool((q->x == that->x)) && bool((q->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_8{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",269,0xe4d28ae7)
				{
					HX_STACK_LINE(269)
					::hxd::poly2tri::Point that = __this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(269)
					return (bool((p->x == that->x)) && bool((p->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(269)
		if (((bool((bool(_Function_1_5::Block(this,q)) && bool(_Function_1_6::Block(this,p)))) || bool((bool(_Function_1_7::Block(this,q)) && bool(_Function_1_8::Block(this,p))))))){
			HX_STACK_LINE(270)
			this->constrained_edge[(int)1] = true;
			HX_STACK_LINE(271)
			return null();
		}
		struct _Function_1_9{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &q){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",274,0xe4d28ae7)
				{
					HX_STACK_LINE(274)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(274)
					return (bool((q->x == that->x)) && bool((q->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_10{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",274,0xe4d28ae7)
				{
					HX_STACK_LINE(274)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(274)
					return (bool((p->x == that->x)) && bool((p->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_11{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &q){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",274,0xe4d28ae7)
				{
					HX_STACK_LINE(274)
					::hxd::poly2tri::Point that = __this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(274)
					return (bool((q->x == that->x)) && bool((q->y == that->y)));
				}
				return null();
			}
		};
		struct _Function_1_12{
			inline static bool Block( hx::ObjectPtr< ::hxd::poly2tri::Triangle_obj > __this,::hxd::poly2tri::Point &p){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/Triangle.hx",274,0xe4d28ae7)
				{
					HX_STACK_LINE(274)
					::hxd::poly2tri::Point that = __this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >();		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(274)
					return (bool((p->x == that->x)) && bool((p->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(274)
		if (((bool((bool(_Function_1_9::Block(this,q)) && bool(_Function_1_10::Block(this,p)))) || bool((bool(_Function_1_11::Block(this,q)) && bool(_Function_1_12::Block(this,p))))))){
			HX_STACK_LINE(275)
			this->constrained_edge[(int)0] = true;
			HX_STACK_LINE(276)
			return null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,markConstrainedEdgeByPoints,(void))

bool Triangle_obj::isEdgeSide( ::hxd::poly2tri::Point ep,::hxd::poly2tri::Point eq){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","isEdgeSide",0x22ac6135,"hxd.poly2tri.Triangle.isEdgeSide","hxd/poly2tri/Triangle.hx",291,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(ep,"ep")
	HX_STACK_ARG(eq,"eq")
	HX_STACK_LINE(292)
	int index = this->edgeIndex(ep,eq);		HX_STACK_VAR(index,"index");
	HX_STACK_LINE(293)
	if (((index == (int)-1))){
		HX_STACK_LINE(293)
		return false;
	}
	HX_STACK_LINE(300)
	this->constrained_edge[index] = true;
	HX_STACK_LINE(302)
	::hxd::poly2tri::Triangle that = this->neighbors->__get(index).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(that,"that");
	HX_STACK_LINE(303)
	if (((that != null()))){
		HX_STACK_LINE(303)
		that->markConstrainedEdgeByPoints(ep,eq);
	}
	HX_STACK_LINE(304)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC2(Triangle_obj,isEdgeSide,return )

Void Triangle_obj::clearNeigbors( ){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","clearNeigbors",0x0fa3f179,"hxd.poly2tri.Triangle.clearNeigbors","hxd/poly2tri/Triangle.hx",369,0xe4d28ae7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(370)
		this->neighbors[(int)0] = null();
		HX_STACK_LINE(371)
		this->neighbors[(int)1] = null();
		HX_STACK_LINE(372)
		this->neighbors[(int)2] = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Triangle_obj,clearNeigbors,(void))

Void Triangle_obj::clearDelunayEdges( ){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","clearDelunayEdges",0x8daf0870,"hxd.poly2tri.Triangle.clearDelunayEdges","hxd/poly2tri/Triangle.hx",376,0xe4d28ae7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(377)
		this->delaunay_edge[(int)0] = false;
		HX_STACK_LINE(378)
		this->delaunay_edge[(int)1] = false;
		HX_STACK_LINE(379)
		this->delaunay_edge[(int)2] = false;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Triangle_obj,clearDelunayEdges,(void))

::String Triangle_obj::toString( ){
	HX_STACK_FRAME("hxd.poly2tri.Triangle","toString",0x0c244fa3,"hxd.poly2tri.Triangle.toString","hxd/poly2tri/Triangle.hx",384,0xe4d28ae7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(385)
	::String _g = ::Std_obj::string(this->points->__get((int)0).StaticCast< ::hxd::poly2tri::Point >());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(385)
	::String _g1 = (HX_CSTRING("Triangle(") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(385)
	::String _g2 = (_g1 + HX_CSTRING(", "));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(385)
	::String _g3 = ::Std_obj::string(this->points->__get((int)1).StaticCast< ::hxd::poly2tri::Point >());		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(385)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(385)
	::String _g5 = (_g4 + HX_CSTRING(", "));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(385)
	::String _g6 = ::Std_obj::string(this->points->__get((int)2).StaticCast< ::hxd::poly2tri::Point >());		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(385)
	::String _g7 = (_g5 + _g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(385)
	return (_g7 + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Triangle_obj,toString,return )

int Triangle_obj::CW_OFFSET;

int Triangle_obj::CCW_OFFSET;

Void Triangle_obj::rotateTrianglePair( ::hxd::poly2tri::Triangle t,::hxd::poly2tri::Point p,::hxd::poly2tri::Triangle ot,::hxd::poly2tri::Point op){
{
		HX_STACK_FRAME("hxd.poly2tri.Triangle","rotateTrianglePair",0x3c1473b4,"hxd.poly2tri.Triangle.rotateTrianglePair","hxd/poly2tri/Triangle.hx",323,0xe4d28ae7)
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(p,"p")
		HX_STACK_ARG(ot,"ot")
		HX_STACK_ARG(op,"op")
		HX_STACK_LINE(324)
		int _g = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(324)
		::hxd::poly2tri::Triangle n1 = t->neighbors->__get(_g).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(n1,"n1");
		HX_STACK_LINE(325)
		int _g1 = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(325)
		::hxd::poly2tri::Triangle n2 = t->neighbors->__get(_g1).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(n2,"n2");
		HX_STACK_LINE(326)
		int _g2 = ot->getPointIndexOffset(op,(int)-1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(326)
		::hxd::poly2tri::Triangle n3 = ot->neighbors->__get(_g2).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(n3,"n3");
		HX_STACK_LINE(327)
		int _g3 = ot->getPointIndexOffset(op,(int)1);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(327)
		::hxd::poly2tri::Triangle n4 = ot->neighbors->__get(_g3).StaticCast< ::hxd::poly2tri::Triangle >();		HX_STACK_VAR(n4,"n4");
		HX_STACK_LINE(329)
		int _g4 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(329)
		bool ce1 = t->constrained_edge->__get(_g4);		HX_STACK_VAR(ce1,"ce1");
		HX_STACK_LINE(330)
		int _g5 = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(330)
		bool ce2 = t->constrained_edge->__get(_g5);		HX_STACK_VAR(ce2,"ce2");
		HX_STACK_LINE(331)
		int _g6 = ot->getPointIndexOffset(op,(int)-1);		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(331)
		bool ce3 = ot->constrained_edge->__get(_g6);		HX_STACK_VAR(ce3,"ce3");
		HX_STACK_LINE(332)
		int _g7 = ot->getPointIndexOffset(op,(int)1);		HX_STACK_VAR(_g7,"_g7");
		HX_STACK_LINE(332)
		bool ce4 = ot->constrained_edge->__get(_g7);		HX_STACK_VAR(ce4,"ce4");
		HX_STACK_LINE(334)
		int _g8 = t->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g8,"_g8");
		HX_STACK_LINE(334)
		bool de1 = t->delaunay_edge->__get(_g8);		HX_STACK_VAR(de1,"de1");
		HX_STACK_LINE(335)
		int _g9 = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g9,"_g9");
		HX_STACK_LINE(335)
		bool de2 = t->delaunay_edge->__get(_g9);		HX_STACK_VAR(de2,"de2");
		HX_STACK_LINE(336)
		int _g10 = ot->getPointIndexOffset(op,(int)-1);		HX_STACK_VAR(_g10,"_g10");
		HX_STACK_LINE(336)
		bool de3 = ot->delaunay_edge->__get(_g10);		HX_STACK_VAR(de3,"de3");
		HX_STACK_LINE(337)
		int _g11 = ot->getPointIndexOffset(op,(int)1);		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(337)
		bool de4 = ot->delaunay_edge->__get(_g11);		HX_STACK_VAR(de4,"de4");
		HX_STACK_LINE(339)
		t->legalize(p,op);
		HX_STACK_LINE(340)
		ot->legalize(op,p);
		HX_STACK_LINE(343)
		int _g12 = ot->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g12,"_g12");
		HX_STACK_LINE(343)
		ot->delaunay_edge[_g12] = de1;
		HX_STACK_LINE(344)
		int _g13 = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g13,"_g13");
		HX_STACK_LINE(344)
		t->delaunay_edge[_g13] = de2;
		HX_STACK_LINE(345)
		int _g14 = t->getPointIndexOffset(op,(int)-1);		HX_STACK_VAR(_g14,"_g14");
		HX_STACK_LINE(345)
		t->delaunay_edge[_g14] = de3;
		HX_STACK_LINE(346)
		int _g15 = ot->getPointIndexOffset(op,(int)1);		HX_STACK_VAR(_g15,"_g15");
		HX_STACK_LINE(346)
		ot->delaunay_edge[_g15] = de4;
		HX_STACK_LINE(349)
		int _g16 = ot->getPointIndexOffset(p,(int)-1);		HX_STACK_VAR(_g16,"_g16");
		HX_STACK_LINE(349)
		ot->constrained_edge[_g16] = ce1;
		HX_STACK_LINE(350)
		int _g17 = t->getPointIndexOffset(p,(int)1);		HX_STACK_VAR(_g17,"_g17");
		HX_STACK_LINE(350)
		t->constrained_edge[_g17] = ce2;
		HX_STACK_LINE(351)
		int _g18 = t->getPointIndexOffset(op,(int)-1);		HX_STACK_VAR(_g18,"_g18");
		HX_STACK_LINE(351)
		t->constrained_edge[_g18] = ce3;
		HX_STACK_LINE(352)
		int _g19 = ot->getPointIndexOffset(op,(int)1);		HX_STACK_VAR(_g19,"_g19");
		HX_STACK_LINE(352)
		ot->constrained_edge[_g19] = ce4;
		HX_STACK_LINE(359)
		t->clearNeigbors();
		HX_STACK_LINE(360)
		ot->clearNeigbors();
		HX_STACK_LINE(361)
		if (((n1 != null()))){
			HX_STACK_LINE(361)
			ot->markNeighborTriangle(n1);
		}
		HX_STACK_LINE(362)
		if (((n2 != null()))){
			HX_STACK_LINE(362)
			t->markNeighborTriangle(n2);
		}
		HX_STACK_LINE(363)
		if (((n3 != null()))){
			HX_STACK_LINE(363)
			t->markNeighborTriangle(n3);
		}
		HX_STACK_LINE(364)
		if (((n4 != null()))){
			HX_STACK_LINE(364)
			ot->markNeighborTriangle(n4);
		}
		HX_STACK_LINE(365)
		t->markNeighborTriangle(ot);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Triangle_obj,rotateTrianglePair,(void))


Triangle_obj::Triangle_obj()
{
}

void Triangle_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Triangle);
	HX_MARK_MEMBER_NAME(points,"points");
	HX_MARK_MEMBER_NAME(neighbors,"neighbors");
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(constrained_edge,"constrained_edge");
	HX_MARK_MEMBER_NAME(delaunay_edge,"delaunay_edge");
	HX_MARK_END_CLASS();
}

void Triangle_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(points,"points");
	HX_VISIT_MEMBER_NAME(neighbors,"neighbors");
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(constrained_edge,"constrained_edge");
	HX_VISIT_MEMBER_NAME(delaunay_edge,"delaunay_edge");
}

Dynamic Triangle_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { return index_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"points") ) { return points; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"pointCW") ) { return pointCW_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"pointCCW") ) { return pointCCW_dyn(); }
		if (HX_FIELD_EQ(inName,"legalize") ) { return legalize_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"neighbors") ) { return neighbors; }
		if (HX_FIELD_EQ(inName,"edgeIndex") ) { return edgeIndex_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"neighborCW") ) { return neighborCW_dyn(); }
		if (HX_FIELD_EQ(inName,"isEdgeSide") ) { return isEdgeSide_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"neighborCCW") ) { return neighborCCW_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"markNeighbor") ) { return markNeighbor_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"delaunay_edge") ) { return delaunay_edge; }
		if (HX_FIELD_EQ(inName,"containsPoint") ) { return containsPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"oppositePoint") ) { return oppositePoint_dyn(); }
		if (HX_FIELD_EQ(inName,"clearNeigbors") ) { return clearNeigbors_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"neighborAcross") ) { return neighborAcross_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"constrained_edge") ) { return constrained_edge; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"getDelaunayEdgeCW") ) { return getDelaunayEdgeCW_dyn(); }
		if (HX_FIELD_EQ(inName,"setDelaunayEdgeCW") ) { return setDelaunayEdgeCW_dyn(); }
		if (HX_FIELD_EQ(inName,"clearDelunayEdges") ) { return clearDelunayEdges_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"rotateTrianglePair") ) { return rotateTrianglePair_dyn(); }
		if (HX_FIELD_EQ(inName,"containsEdgePoints") ) { return containsEdgePoints_dyn(); }
		if (HX_FIELD_EQ(inName,"getDelaunayEdgeCCW") ) { return getDelaunayEdgeCCW_dyn(); }
		if (HX_FIELD_EQ(inName,"setDelaunayEdgeCCW") ) { return setDelaunayEdgeCCW_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"getPointIndexOffset") ) { return getPointIndexOffset_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"markNeighborTriangle") ) { return markNeighborTriangle_dyn(); }
		if (HX_FIELD_EQ(inName,"getConstrainedEdgeCW") ) { return getConstrainedEdgeCW_dyn(); }
		if (HX_FIELD_EQ(inName,"setConstrainedEdgeCW") ) { return setConstrainedEdgeCW_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"getConstrainedEdgeCCW") ) { return getConstrainedEdgeCCW_dyn(); }
		if (HX_FIELD_EQ(inName,"setConstrainedEdgeCCW") ) { return setConstrainedEdgeCCW_dyn(); }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"markConstrainedEdgeByEdge") ) { return markConstrainedEdgeByEdge_dyn(); }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"markConstrainedEdgeByPoints") ) { return markConstrainedEdgeByPoints_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Triangle_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"points") ) { points=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"neighbors") ) { neighbors=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"delaunay_edge") ) { delaunay_edge=inValue.Cast< Array< bool > >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"constrained_edge") ) { constrained_edge=inValue.Cast< Array< bool > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Triangle_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("points"));
	outFields->push(HX_CSTRING("neighbors"));
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("constrained_edge"));
	outFields->push(HX_CSTRING("delaunay_edge"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("CW_OFFSET"),
	HX_CSTRING("CCW_OFFSET"),
	HX_CSTRING("rotateTrianglePair"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Triangle_obj,points),HX_CSTRING("points")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Triangle_obj,neighbors),HX_CSTRING("neighbors")},
	{hx::fsInt,(int)offsetof(Triangle_obj,id),HX_CSTRING("id")},
	{hx::fsObject /*Array< bool >*/ ,(int)offsetof(Triangle_obj,constrained_edge),HX_CSTRING("constrained_edge")},
	{hx::fsObject /*Array< bool >*/ ,(int)offsetof(Triangle_obj,delaunay_edge),HX_CSTRING("delaunay_edge")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("points"),
	HX_CSTRING("neighbors"),
	HX_CSTRING("id"),
	HX_CSTRING("constrained_edge"),
	HX_CSTRING("delaunay_edge"),
	HX_CSTRING("containsPoint"),
	HX_CSTRING("containsEdgePoints"),
	HX_CSTRING("markNeighbor"),
	HX_CSTRING("markNeighborTriangle"),
	HX_CSTRING("getPointIndexOffset"),
	HX_CSTRING("pointCW"),
	HX_CSTRING("pointCCW"),
	HX_CSTRING("neighborCW"),
	HX_CSTRING("neighborCCW"),
	HX_CSTRING("getConstrainedEdgeCW"),
	HX_CSTRING("setConstrainedEdgeCW"),
	HX_CSTRING("getConstrainedEdgeCCW"),
	HX_CSTRING("setConstrainedEdgeCCW"),
	HX_CSTRING("getDelaunayEdgeCW"),
	HX_CSTRING("setDelaunayEdgeCW"),
	HX_CSTRING("getDelaunayEdgeCCW"),
	HX_CSTRING("setDelaunayEdgeCCW"),
	HX_CSTRING("neighborAcross"),
	HX_CSTRING("oppositePoint"),
	HX_CSTRING("legalize"),
	HX_CSTRING("index"),
	HX_CSTRING("edgeIndex"),
	HX_CSTRING("markConstrainedEdgeByEdge"),
	HX_CSTRING("markConstrainedEdgeByPoints"),
	HX_CSTRING("isEdgeSide"),
	HX_CSTRING("clearNeigbors"),
	HX_CSTRING("clearDelunayEdges"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Triangle_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Triangle_obj::CW_OFFSET,"CW_OFFSET");
	HX_MARK_MEMBER_NAME(Triangle_obj::CCW_OFFSET,"CCW_OFFSET");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Triangle_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Triangle_obj::CW_OFFSET,"CW_OFFSET");
	HX_VISIT_MEMBER_NAME(Triangle_obj::CCW_OFFSET,"CCW_OFFSET");
};

#endif

Class Triangle_obj::__mClass;

void Triangle_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Triangle"), hx::TCanCast< Triangle_obj> ,sStaticFields,sMemberFields,
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

void Triangle_obj::__boot()
{
	CW_OFFSET= (int)1;
	CCW_OFFSET= (int)-1;
}

} // end namespace hxd
} // end namespace poly2tri
