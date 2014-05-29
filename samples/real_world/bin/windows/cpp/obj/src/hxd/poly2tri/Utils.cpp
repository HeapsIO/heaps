#include <hxcpp.h>

#ifndef INCLUDED_hxd_poly2tri_Constants
#include <hxd/poly2tri/Constants.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Point
#include <hxd/poly2tri/Point.h>
#endif
#ifndef INCLUDED_hxd_poly2tri_Utils
#include <hxd/poly2tri/Utils.h>
#endif
namespace hxd{
namespace poly2tri{

Void Utils_obj::__construct()
{
	return null();
}

//Utils_obj::~Utils_obj() { }

Dynamic Utils_obj::__CreateEmpty() { return  new Utils_obj; }
hx::ObjectPtr< Utils_obj > Utils_obj::__new()
{  hx::ObjectPtr< Utils_obj > result = new Utils_obj();
	result->__construct();
	return result;}

Dynamic Utils_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Utils_obj > result = new Utils_obj();
	result->__construct();
	return result;}

bool Utils_obj::insideIncircle( ::hxd::poly2tri::Point pa,::hxd::poly2tri::Point pb,::hxd::poly2tri::Point pc,::hxd::poly2tri::Point pd){
	HX_STACK_FRAME("hxd.poly2tri.Utils","insideIncircle",0xfa01417d,"hxd.poly2tri.Utils.insideIncircle","hxd/poly2tri/Utils.hx",30,0xbf84829c)
	HX_STACK_ARG(pa,"pa")
	HX_STACK_ARG(pb,"pb")
	HX_STACK_ARG(pc,"pc")
	HX_STACK_ARG(pd,"pd")
	HX_STACK_LINE(31)
	Float adx = (pa->x - pd->x);		HX_STACK_VAR(adx,"adx");
	HX_STACK_LINE(32)
	Float ady = (pa->y - pd->y);		HX_STACK_VAR(ady,"ady");
	HX_STACK_LINE(33)
	Float bdx = (pb->x - pd->x);		HX_STACK_VAR(bdx,"bdx");
	HX_STACK_LINE(34)
	Float bdy = (pb->y - pd->y);		HX_STACK_VAR(bdy,"bdy");
	HX_STACK_LINE(36)
	Float adxbdy = (adx * bdy);		HX_STACK_VAR(adxbdy,"adxbdy");
	HX_STACK_LINE(37)
	Float bdxady = (bdx * ady);		HX_STACK_VAR(bdxady,"bdxady");
	HX_STACK_LINE(38)
	Float oabd = (adxbdy - bdxady);		HX_STACK_VAR(oabd,"oabd");
	HX_STACK_LINE(40)
	if (((oabd <= (int)0))){
		HX_STACK_LINE(40)
		return false;
	}
	HX_STACK_LINE(42)
	Float cdx = (pc->x - pd->x);		HX_STACK_VAR(cdx,"cdx");
	HX_STACK_LINE(43)
	Float cdy = (pc->y - pd->y);		HX_STACK_VAR(cdy,"cdy");
	HX_STACK_LINE(45)
	Float cdxady = (cdx * ady);		HX_STACK_VAR(cdxady,"cdxady");
	HX_STACK_LINE(46)
	Float adxcdy = (adx * cdy);		HX_STACK_VAR(adxcdy,"adxcdy");
	HX_STACK_LINE(47)
	Float ocad = (cdxady - adxcdy);		HX_STACK_VAR(ocad,"ocad");
	HX_STACK_LINE(49)
	if (((ocad <= (int)0))){
		HX_STACK_LINE(49)
		return false;
	}
	HX_STACK_LINE(51)
	Float bdxcdy = (bdx * cdy);		HX_STACK_VAR(bdxcdy,"bdxcdy");
	HX_STACK_LINE(52)
	Float cdxbdy = (cdx * bdy);		HX_STACK_VAR(cdxbdy,"cdxbdy");
	HX_STACK_LINE(54)
	Float alift = ((adx * adx) + (ady * ady));		HX_STACK_VAR(alift,"alift");
	HX_STACK_LINE(55)
	Float blift = ((bdx * bdx) + (bdy * bdy));		HX_STACK_VAR(blift,"blift");
	HX_STACK_LINE(56)
	Float clift = ((cdx * cdx) + (cdy * cdy));		HX_STACK_VAR(clift,"clift");
	HX_STACK_LINE(58)
	Float det = (((alift * ((bdxcdy - cdxbdy))) + (blift * ocad)) + (clift * oabd));		HX_STACK_VAR(det,"det");
	HX_STACK_LINE(59)
	return (det > (int)0);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Utils_obj,insideIncircle,return )

bool Utils_obj::inScanArea( ::hxd::poly2tri::Point pa,::hxd::poly2tri::Point pb,::hxd::poly2tri::Point pc,::hxd::poly2tri::Point pd){
	HX_STACK_FRAME("hxd.poly2tri.Utils","inScanArea",0x12b6185b,"hxd.poly2tri.Utils.inScanArea","hxd/poly2tri/Utils.hx",63,0xbf84829c)
	HX_STACK_ARG(pa,"pa")
	HX_STACK_ARG(pb,"pb")
	HX_STACK_ARG(pc,"pc")
	HX_STACK_ARG(pd,"pd")
	HX_STACK_LINE(64)
	Float pdx = pd->x;		HX_STACK_VAR(pdx,"pdx");
	HX_STACK_LINE(65)
	Float pdy = pd->y;		HX_STACK_VAR(pdy,"pdy");
	HX_STACK_LINE(66)
	Float adx = (pa->x - pdx);		HX_STACK_VAR(adx,"adx");
	HX_STACK_LINE(67)
	Float ady = (pa->y - pdy);		HX_STACK_VAR(ady,"ady");
	HX_STACK_LINE(68)
	Float bdx = (pb->x - pdx);		HX_STACK_VAR(bdx,"bdx");
	HX_STACK_LINE(69)
	Float bdy = (pb->y - pdy);		HX_STACK_VAR(bdy,"bdy");
	HX_STACK_LINE(71)
	Float adxbdy = (adx * bdy);		HX_STACK_VAR(adxbdy,"adxbdy");
	HX_STACK_LINE(72)
	Float bdxady = (bdx * ady);		HX_STACK_VAR(bdxady,"bdxady");
	HX_STACK_LINE(73)
	Float oabd = (adxbdy - bdxady);		HX_STACK_VAR(oabd,"oabd");
	HX_STACK_LINE(75)
	if (((oabd <= ::hxd::poly2tri::Constants_obj::EPSILON))){
		HX_STACK_LINE(75)
		return false;
	}
	HX_STACK_LINE(77)
	Float cdx = (pc->x - pdx);		HX_STACK_VAR(cdx,"cdx");
	HX_STACK_LINE(78)
	Float cdy = (pc->y - pdy);		HX_STACK_VAR(cdy,"cdy");
	HX_STACK_LINE(80)
	Float cdxady = (cdx * ady);		HX_STACK_VAR(cdxady,"cdxady");
	HX_STACK_LINE(81)
	Float adxcdy = (adx * cdy);		HX_STACK_VAR(adxcdy,"adxcdy");
	HX_STACK_LINE(82)
	Float ocad = (cdxady - adxcdy);		HX_STACK_VAR(ocad,"ocad");
	HX_STACK_LINE(84)
	if (((ocad <= ::hxd::poly2tri::Constants_obj::EPSILON))){
		HX_STACK_LINE(84)
		return false;
	}
	HX_STACK_LINE(86)
	return true;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Utils_obj,inScanArea,return )


Utils_obj::Utils_obj()
{
}

Dynamic Utils_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"inScanArea") ) { return inScanArea_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"insideIncircle") ) { return insideIncircle_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Utils_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Utils_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("insideIncircle"),
	HX_CSTRING("inScanArea"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Utils_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Utils_obj::__mClass,"__mClass");
};

#endif

Class Utils_obj::__mClass;

void Utils_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.poly2tri.Utils"), hx::TCanCast< Utils_obj> ,sStaticFields,sMemberFields,
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

void Utils_obj::__boot()
{
}

} // end namespace hxd
} // end namespace poly2tri
