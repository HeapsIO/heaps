#include <hxcpp.h>

#ifndef INCLUDED_hxd_poly2tri_AdvancingFront
#include <hxd/poly2tri/AdvancingFront.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Node
#include <hxd/poly2tri/Node.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
namespace hxd{
namespace poly2tri{

Void AdvancingFront_obj::__construct(::hxd::poly2tri::Node head,::hxd::poly2tri::Node tail)
{
HX_STACK_FRAME("hxd.poly2tri.AdvancingFront","new",0x90b2522b,"hxd.poly2tri.AdvancingFront.new","hxd/poly2tri/AdvancingFront.hx",10,0xfd5307c5)
HX_STACK_THIS(this)
HX_STACK_ARG(head,"head")
HX_STACK_ARG(tail,"tail")
{
	HX_STACK_LINE(11)
	::hxd::poly2tri::Node _g = this->head = head;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(11)
	this->search_node = _g;
	HX_STACK_LINE(12)
	this->tail = tail;
}
;
	return null();
}

//AdvancingFront_obj::~AdvancingFront_obj() { }

Dynamic AdvancingFront_obj::__CreateEmpty() { return  new AdvancingFront_obj; }
hx::ObjectPtr< AdvancingFront_obj > AdvancingFront_obj::__new(::hxd::poly2tri::Node head,::hxd::poly2tri::Node tail)
{  hx::ObjectPtr< AdvancingFront_obj > result = new AdvancingFront_obj();
	result->__construct(head,tail);
	return result;}

Dynamic AdvancingFront_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AdvancingFront_obj > result = new AdvancingFront_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::hxd::poly2tri::Node AdvancingFront_obj::locateNode( Float x){
	HX_STACK_FRAME("hxd.poly2tri.AdvancingFront","locateNode",0x50e10049,"hxd.poly2tri.AdvancingFront.locateNode","hxd/poly2tri/AdvancingFront.hx",16,0xfd5307c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_LINE(17)
	::hxd::poly2tri::Node node = this->search_node;		HX_STACK_VAR(node,"node");
	HX_STACK_LINE(19)
	if (((x < node->value))){
		HX_STACK_LINE(21)
		while((true)){
			HX_STACK_LINE(21)
			::hxd::poly2tri::Node _g = node = node->prev;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(21)
			if ((!(((_g != null()))))){
				HX_STACK_LINE(21)
				break;
			}
			HX_STACK_LINE(23)
			if (((x >= node->value))){
				HX_STACK_LINE(25)
				this->search_node = node;
				HX_STACK_LINE(26)
				return node;
			}
		}
	}
	else{
		HX_STACK_LINE(32)
		while((true)){
			HX_STACK_LINE(32)
			::hxd::poly2tri::Node _g1 = node = node->next;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(32)
			if ((!(((_g1 != null()))))){
				HX_STACK_LINE(32)
				break;
			}
			HX_STACK_LINE(34)
			if (((x < node->value))){
				HX_STACK_LINE(36)
				this->search_node = node->prev;
				HX_STACK_LINE(37)
				return node->prev;
			}
		}
	}
	HX_STACK_LINE(42)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(AdvancingFront_obj,locateNode,return )

::hxd::poly2tri::Node AdvancingFront_obj::locatePoint( ::hxd::poly2tri::Point point){
	HX_STACK_FRAME("hxd.poly2tri.AdvancingFront","locatePoint",0x9ad03c29,"hxd.poly2tri.AdvancingFront.locatePoint","hxd/poly2tri/AdvancingFront.hx",46,0xfd5307c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_LINE(47)
	Float px = point->x;		HX_STACK_VAR(px,"px");
	HX_STACK_LINE(49)
	::hxd::poly2tri::Node node = this->search_node;		HX_STACK_VAR(node,"node");
	HX_STACK_LINE(50)
	Float nx = node->point->x;		HX_STACK_VAR(nx,"nx");
	HX_STACK_LINE(52)
	if (((px == nx))){
		struct _Function_2_1{
			inline static bool Block( ::hxd::poly2tri::Point &point,::hxd::poly2tri::Node &node){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/AdvancingFront.hx",54,0xfd5307c5)
				{
					HX_STACK_LINE(54)
					::hxd::poly2tri::Point that = node->point;		HX_STACK_VAR(that,"that");
					HX_STACK_LINE(54)
					return (bool((point->x == that->x)) && bool((point->y == that->y)));
				}
				return null();
			}
		};
		HX_STACK_LINE(54)
		if ((!(_Function_2_1::Block(point,node)))){
			struct _Function_3_1{
				inline static bool Block( ::hxd::poly2tri::Point &point,::hxd::poly2tri::Node &node){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/AdvancingFront.hx",57,0xfd5307c5)
					{
						HX_STACK_LINE(57)
						::hxd::poly2tri::Point that = node->prev->point;		HX_STACK_VAR(that,"that");
						HX_STACK_LINE(57)
						return (bool((point->x == that->x)) && bool((point->y == that->y)));
					}
					return null();
				}
			};
			HX_STACK_LINE(57)
			if ((_Function_3_1::Block(point,node))){
				HX_STACK_LINE(59)
				node = node->prev;
			}
			else{
				struct _Function_4_1{
					inline static bool Block( ::hxd::poly2tri::Point &point,::hxd::poly2tri::Node &node){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/AdvancingFront.hx",61,0xfd5307c5)
						{
							HX_STACK_LINE(61)
							::hxd::poly2tri::Point that = node->next->point;		HX_STACK_VAR(that,"that");
							HX_STACK_LINE(61)
							return (bool((point->x == that->x)) && bool((point->y == that->y)));
						}
						return null();
					}
				};
				HX_STACK_LINE(61)
				if ((_Function_4_1::Block(point,node))){
					HX_STACK_LINE(63)
					node = node->next;
				}
				else{
					HX_STACK_LINE(67)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid AdvancingFront.locatePoint call!"));
				}
			}
		}
	}
	else{
		HX_STACK_LINE(71)
		if (((px < nx))){
			HX_STACK_LINE(73)
			while((true)){
				HX_STACK_LINE(73)
				::hxd::poly2tri::Node _g = node = node->prev;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(73)
				if ((!(((_g != null()))))){
					HX_STACK_LINE(73)
					break;
				}
				struct _Function_4_1{
					inline static bool Block( ::hxd::poly2tri::Point &point,::hxd::poly2tri::Node &node){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/AdvancingFront.hx",74,0xfd5307c5)
						{
							HX_STACK_LINE(74)
							::hxd::poly2tri::Point that = node->point;		HX_STACK_VAR(that,"that");
							HX_STACK_LINE(74)
							return (bool((point->x == that->x)) && bool((point->y == that->y)));
						}
						return null();
					}
				};
				HX_STACK_LINE(74)
				if ((_Function_4_1::Block(point,node))){
					HX_STACK_LINE(74)
					break;
				}
			}
		}
		else{
			HX_STACK_LINE(78)
			while((true)){
				HX_STACK_LINE(78)
				::hxd::poly2tri::Node _g1 = node = node->next;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(78)
				if ((!(((_g1 != null()))))){
					HX_STACK_LINE(78)
					break;
				}
				struct _Function_4_1{
					inline static bool Block( ::hxd::poly2tri::Point &point,::hxd::poly2tri::Node &node){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/poly2tri/AdvancingFront.hx",79,0xfd5307c5)
						{
							HX_STACK_LINE(79)
							::hxd::poly2tri::Point that = node->point;		HX_STACK_VAR(that,"that");
							HX_STACK_LINE(79)
							return (bool((point->x == that->x)) && bool((point->y == that->y)));
						}
						return null();
					}
				};
				HX_STACK_LINE(79)
				if ((_Function_4_1::Block(point,node))){
					HX_STACK_LINE(79)
					break;
				}
			}
		}
	}
	HX_STACK_LINE(82)
	if (((node != null()))){
		HX_STACK_LINE(82)
		this->search_node = node;
	}
	HX_STACK_LINE(83)
	return node;
}


HX_DEFINE_DYNAMIC_FUNC1(AdvancingFront_obj,locatePoint,return )


AdvancingFront_obj::AdvancingFront_obj()
{
}

void AdvancingFront_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AdvancingFront);
	HX_MARK_MEMBER_NAME(head,"head");
	HX_MARK_MEMBER_NAME(tail,"tail");
	HX_MARK_MEMBER_NAME(search_node,"search_node");
	HX_MARK_END_CLASS();
}

void AdvancingFront_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(head,"head");
	HX_VISIT_MEMBER_NAME(tail,"tail");
	HX_VISIT_MEMBER_NAME(search_node,"search_node");
}

Dynamic AdvancingFront_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"head") ) { return head; }
		if (HX_FIELD_EQ(inName,"tail") ) { return tail; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"locateNode") ) { return locateNode_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"search_node") ) { return search_node; }
		if (HX_FIELD_EQ(inName,"locatePoint") ) { return locatePoint_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic AdvancingFront_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"head") ) { head=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tail") ) { tail=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"search_node") ) { search_node=inValue.Cast< ::hxd::poly2tri::Node >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void AdvancingFront_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("head"));
	outFields->push(HX_CSTRING("tail"));
	outFields->push(HX_CSTRING("search_node"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(AdvancingFront_obj,head),HX_CSTRING("head")},
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(AdvancingFront_obj,tail),HX_CSTRING("tail")},
	{hx::fsObject /*::hxd::poly2tri::Node*/ ,(int)offsetof(AdvancingFront_obj,search_node),HX_CSTRING("search_node")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("head"),
	HX_CSTRING("tail"),
	HX_CSTRING("search_node"),
	HX_CSTRING("locateNode"),
	HX_CSTRING("locatePoint"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AdvancingFront_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(AdvancingFront_obj::__mClass,"__mClass");
};

#endif

Class AdvancingFront_obj::__mClass;

void AdvancingFront_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.AdvancingFront"), hx::TCanCast< AdvancingFront_obj> ,sStaticFields,sMemberFields,
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

void AdvancingFront_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
