#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Math
#include <hxd/Math.h>
#endif
namespace hxd{

Void Math_obj::__construct()
{
	return null();
}

//Math_obj::~Math_obj() { }

Dynamic Math_obj::__CreateEmpty() { return  new Math_obj; }
hx::ObjectPtr< Math_obj > Math_obj::__new()
{  hx::ObjectPtr< Math_obj > result = new Math_obj();
	result->__construct();
	return result;}

Dynamic Math_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Math_obj > result = new Math_obj();
	result->__construct();
	return result;}

Float Math_obj::PI;

Float Math_obj::EPSILON;

Float Math_obj::get_POSITIVE_INFINITY( ){
	HX_STACK_FRAME("hxd.Math","get_POSITIVE_INFINITY",0x3d846319,"hxd.Math.get_POSITIVE_INFINITY","hxd/Math.hx",14,0xbdc330db)
	HX_STACK_LINE(14)
	return ::Math_obj::POSITIVE_INFINITY;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Math_obj,get_POSITIVE_INFINITY,return )

Float Math_obj::get_NEGATIVE_INFINITY( ){
	HX_STACK_FRAME("hxd.Math","get_NEGATIVE_INFINITY",0x5e850bdd,"hxd.Math.get_NEGATIVE_INFINITY","hxd/Math.hx",18,0xbdc330db)
	HX_STACK_LINE(18)
	return ::Math_obj::NEGATIVE_INFINITY;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Math_obj,get_NEGATIVE_INFINITY,return )

Float Math_obj::get_NaN( ){
	HX_STACK_FRAME("hxd.Math","get_NaN",0x323b1a06,"hxd.Math.get_NaN","hxd/Math.hx",22,0xbdc330db)
	HX_STACK_LINE(22)
	return ::Math_obj::NaN;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Math_obj,get_NaN,return )

bool Math_obj::isNaN( Float v){
	HX_STACK_FRAME("hxd.Math","isNaN",0x589226c5,"hxd.Math.isNaN","hxd/Math.hx",26,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(26)
	return ::Math_obj::isNaN(v);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,isNaN,return )

Float Math_obj::fmt( Float v){
	HX_STACK_FRAME("hxd.Math","fmt",0x7a149821,"hxd.Math.fmt","hxd/Math.hx",30,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(31)
	Float neg;		HX_STACK_VAR(neg,"neg");
	HX_STACK_LINE(32)
	if (((v < (int)0))){
		HX_STACK_LINE(33)
		neg = -1.0;
		HX_STACK_LINE(34)
		v = -(v);
	}
	else{
		HX_STACK_LINE(36)
		neg = 1.0;
	}
	HX_STACK_LINE(37)
	if ((::Math_obj::isNaN(v))){
		HX_STACK_LINE(38)
		return v;
	}
	HX_STACK_LINE(39)
	Float _g = ::Math_obj::log(v);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(39)
	Float _g1 = ::Math_obj::log((int)10);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(39)
	Float _g2 = (Float(_g) / Float(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(39)
	Float _g3 = ((int)4 - _g2);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(39)
	int digits = ::Std_obj::_int(_g3);		HX_STACK_VAR(digits,"digits");
	HX_STACK_LINE(40)
	if (((digits < (int)1))){
		HX_STACK_LINE(41)
		digits = (int)1;
	}
	else{
		HX_STACK_LINE(42)
		if (((digits >= (int)10))){
			HX_STACK_LINE(43)
			return 0.;
		}
	}
	HX_STACK_LINE(44)
	Float exp = ::Math_obj::pow((int)10,digits);		HX_STACK_VAR(exp,"exp");
	HX_STACK_LINE(45)
	int _g4 = ::Math_obj::floor(((v * exp) + .49999));		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(45)
	Float _g5 = (_g4 * neg);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(45)
	return (Float(_g5) / Float(exp));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,fmt,return )

int Math_obj::floor( Float f){
	HX_STACK_FRAME("hxd.Math","floor",0x99d701a0,"hxd.Math.floor","hxd/Math.hx",49,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(49)
	return ::Math_obj::floor(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,floor,return )

int Math_obj::ceil( Float f){
	HX_STACK_FRAME("hxd.Math","ceil",0x55eec5b1,"hxd.Math.ceil","hxd/Math.hx",53,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(53)
	return ::Math_obj::ceil(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,ceil,return )

int Math_obj::round( Float f){
	HX_STACK_FRAME("hxd.Math","round",0x84a62822,"hxd.Math.round","hxd/Math.hx",57,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(57)
	return ::Math_obj::round(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,round,return )

Dynamic Math_obj::sel( Float f,Dynamic then,Dynamic els){
	HX_STACK_FRAME("hxd.Math","sel",0x7a1e6e6e,"hxd.Math.sel","hxd/Math.hx",61,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_ARG(then,"then")
	HX_STACK_ARG(els,"els")
	HX_STACK_LINE(61)
	if (((f >= (int)0))){
		HX_STACK_LINE(61)
		return then;
	}
	else{
		HX_STACK_LINE(61)
		return els;
	}
	HX_STACK_LINE(61)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,sel,return )

Float Math_obj::clamp( Float f,Float min,Float max){
	HX_STACK_FRAME("hxd.Math","clamp",0xdf98a2cf,"hxd.Math.clamp","hxd/Math.hx",68,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_ARG(min,"min")
	HX_STACK_ARG(max,"max")
	HX_STACK_LINE(68)
	if (((f < min))){
		HX_STACK_LINE(68)
		return min;
	}
	else{
		HX_STACK_LINE(68)
		if (((f > max))){
			HX_STACK_LINE(68)
			return max;
		}
		else{
			HX_STACK_LINE(68)
			return f;
		}
	}
	HX_STACK_LINE(68)
	return 0.;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,clamp,return )

Float Math_obj::pow( Float v,Float p){
	HX_STACK_FRAME("hxd.Math","pow",0x7a1c306c,"hxd.Math.pow","hxd/Math.hx",72,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(72)
	return ::Math_obj::pow(v,p);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Math_obj,pow,return )

Float Math_obj::cos( Float f){
	HX_STACK_FRAME("hxd.Math","cos",0x7a12531b,"hxd.Math.cos","hxd/Math.hx",76,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(76)
	return ::Math_obj::cos(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,cos,return )

Float Math_obj::sin( Float f){
	HX_STACK_FRAME("hxd.Math","sin",0x7a1e71ec,"hxd.Math.sin","hxd/Math.hx",80,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(80)
	return ::Math_obj::sin(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,sin,return )

Float Math_obj::tan( Float f){
	HX_STACK_FRAME("hxd.Math","tan",0x7a1f2d35,"hxd.Math.tan","hxd/Math.hx",84,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(84)
	return ::Math_obj::tan(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,tan,return )

Float Math_obj::acos( Float f){
	HX_STACK_FRAME("hxd.Math","acos",0x549ad932,"hxd.Math.acos","hxd/Math.hx",88,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(88)
	return ::Math_obj::acos(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,acos,return )

Float Math_obj::asin( Float f){
	HX_STACK_FRAME("hxd.Math","asin",0x54a6f803,"hxd.Math.asin","hxd/Math.hx",92,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(92)
	return ::Math_obj::asin(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,asin,return )

Float Math_obj::atan( Float f){
	HX_STACK_FRAME("hxd.Math","atan",0x54a7b34c,"hxd.Math.atan","hxd/Math.hx",96,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(96)
	return ::Math_obj::atan(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,atan,return )

Float Math_obj::sqrt( Float f){
	HX_STACK_FRAME("hxd.Math","sqrt",0x608b528c,"hxd.Math.sqrt","hxd/Math.hx",100,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(100)
	return ::Math_obj::sqrt(f);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,sqrt,return )

Float Math_obj::invSqrt( Float f){
	HX_STACK_FRAME("hxd.Math","invSqrt",0x3d957e45,"hxd.Math.invSqrt","hxd/Math.hx",103,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(104)
	Float _g = ::Math_obj::sqrt(f);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(104)
	return (Float(1.) / Float(_g));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,invSqrt,return )

Float Math_obj::atan2( Float dy,Float dx){
	HX_STACK_FRAME("hxd.Math","atan2",0xbe152f66,"hxd.Math.atan2","hxd/Math.hx",108,0xbdc330db)
	HX_STACK_ARG(dy,"dy")
	HX_STACK_ARG(dx,"dx")
	HX_STACK_LINE(108)
	return ::Math_obj::atan2(dy,dx);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Math_obj,atan2,return )

Float Math_obj::abs( Float f){
	HX_STACK_FRAME("hxd.Math","abs",0x7a10c346,"hxd.Math.abs","hxd/Math.hx",112,0xbdc330db)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(112)
	if (((f < (int)0))){
		HX_STACK_LINE(112)
		return -(f);
	}
	else{
		HX_STACK_LINE(112)
		return f;
	}
	HX_STACK_LINE(112)
	return 0.;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,abs,return )

Float Math_obj::max( Float a,Float b){
	HX_STACK_FRAME("hxd.Math","max",0x7a19dd78,"hxd.Math.max","hxd/Math.hx",116,0xbdc330db)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(116)
	if (((a < b))){
		HX_STACK_LINE(116)
		return b;
	}
	else{
		HX_STACK_LINE(116)
		return a;
	}
	HX_STACK_LINE(116)
	return 0.;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Math_obj,max,return )

Float Math_obj::min( Float a,Float b){
	HX_STACK_FRAME("hxd.Math","min",0x7a19e466,"hxd.Math.min","hxd/Math.hx",120,0xbdc330db)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(120)
	if (((a > b))){
		HX_STACK_LINE(120)
		return b;
	}
	else{
		HX_STACK_LINE(120)
		return a;
	}
	HX_STACK_LINE(120)
	return 0.;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Math_obj,min,return )

int Math_obj::iabs( int i){
	HX_STACK_FRAME("hxd.Math","iabs",0x59e2fe55,"hxd.Math.iabs","hxd/Math.hx",124,0xbdc330db)
	HX_STACK_ARG(i,"i")
	HX_STACK_LINE(124)
	if (((i < (int)0))){
		HX_STACK_LINE(124)
		return -(i);
	}
	else{
		HX_STACK_LINE(124)
		return i;
	}
	HX_STACK_LINE(124)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,iabs,return )

int Math_obj::imax( int a,int b){
	HX_STACK_FRAME("hxd.Math","imax",0x59ec1887,"hxd.Math.imax","hxd/Math.hx",128,0xbdc330db)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(128)
	if (((a < b))){
		HX_STACK_LINE(128)
		return b;
	}
	else{
		HX_STACK_LINE(128)
		return a;
	}
	HX_STACK_LINE(128)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Math_obj,imax,return )

int Math_obj::imin( int a,int b){
	HX_STACK_FRAME("hxd.Math","imin",0x59ec1f75,"hxd.Math.imin","hxd/Math.hx",132,0xbdc330db)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(132)
	if (((a > b))){
		HX_STACK_LINE(132)
		return b;
	}
	else{
		HX_STACK_LINE(132)
		return a;
	}
	HX_STACK_LINE(132)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Math_obj,imin,return )

int Math_obj::iclamp( int v,int min,int max){
	HX_STACK_FRAME("hxd.Math","iclamp",0x04baff9e,"hxd.Math.iclamp","hxd/Math.hx",136,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(min,"min")
	HX_STACK_ARG(max,"max")
	HX_STACK_LINE(136)
	if (((v < min))){
		HX_STACK_LINE(136)
		return min;
	}
	else{
		HX_STACK_LINE(136)
		if (((v > max))){
			HX_STACK_LINE(136)
			return max;
		}
		else{
			HX_STACK_LINE(136)
			return v;
		}
	}
	HX_STACK_LINE(136)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,iclamp,return )

Float Math_obj::lerp( Float a,Float b,Float k){
	HX_STACK_FRAME("hxd.Math","lerp",0x5be1b923,"hxd.Math.lerp","hxd/Math.hx",143,0xbdc330db)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(k,"k")
	HX_STACK_LINE(143)
	return (a + (k * ((b - a))));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,lerp,return )

int Math_obj::bitCount( int v){
	HX_STACK_FRAME("hxd.Math","bitCount",0x407c616e,"hxd.Math.bitCount","hxd/Math.hx",146,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(147)
	v = (v - ((int((int(v) >> int((int)1))) & int((int)1431655765))));
	HX_STACK_LINE(148)
	v = (((int(v) & int((int)858993459))) + ((int((int(v) >> int((int)2))) & int((int)858993459))));
	HX_STACK_LINE(149)
	return (int((((int((v + ((int(v) >> int((int)4))))) & int((int)252645135))) * (int)16843009)) >> int((int)24));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,bitCount,return )

Float Math_obj::distanceSq( Float dx,Float dy,hx::Null< Float >  __o_dz){
Float dz = __o_dz.Default(0.);
	HX_STACK_FRAME("hxd.Math","distanceSq",0x364ac2df,"hxd.Math.distanceSq","hxd/Math.hx",153,0xbdc330db)
	HX_STACK_ARG(dx,"dx")
	HX_STACK_ARG(dy,"dy")
	HX_STACK_ARG(dz,"dz")
{
		HX_STACK_LINE(153)
		return (((dx * dx) + (dy * dy)) + (dz * dz));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,distanceSq,return )

Float Math_obj::distance( Float dx,Float dy,hx::Null< Float >  __o_dz){
Float dz = __o_dz.Default(0.);
	HX_STACK_FRAME("hxd.Math","distance",0x79e1ffe1,"hxd.Math.distance","hxd/Math.hx",157,0xbdc330db)
	HX_STACK_ARG(dx,"dx")
	HX_STACK_ARG(dy,"dy")
	HX_STACK_ARG(dz,"dz")
{
		HX_STACK_LINE(157)
		return ::Math_obj::sqrt((((dx * dx) + (dy * dy)) + (dz * dz)));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,distance,return )

int Math_obj::colorLerp( int c1,int c2,Float k){
	HX_STACK_FRAME("hxd.Math","colorLerp",0x4094474e,"hxd.Math.colorLerp","hxd/Math.hx",163,0xbdc330db)
	HX_STACK_ARG(c1,"c1")
	HX_STACK_ARG(c2,"c2")
	HX_STACK_ARG(k,"k")
	HX_STACK_LINE(164)
	int a1 = hx::UShr(c1,(int)24);		HX_STACK_VAR(a1,"a1");
	HX_STACK_LINE(165)
	int r1 = (int((int(c1) >> int((int)16))) & int((int)255));		HX_STACK_VAR(r1,"r1");
	HX_STACK_LINE(166)
	int g1 = (int((int(c1) >> int((int)8))) & int((int)255));		HX_STACK_VAR(g1,"g1");
	HX_STACK_LINE(167)
	int b1 = (int(c1) & int((int)255));		HX_STACK_VAR(b1,"b1");
	HX_STACK_LINE(168)
	int a2 = hx::UShr(c2,(int)24);		HX_STACK_VAR(a2,"a2");
	HX_STACK_LINE(169)
	int r2 = (int((int(c2) >> int((int)16))) & int((int)255));		HX_STACK_VAR(r2,"r2");
	HX_STACK_LINE(170)
	int g2 = (int((int(c2) >> int((int)8))) & int((int)255));		HX_STACK_VAR(g2,"g2");
	HX_STACK_LINE(171)
	int b2 = (int(c2) & int((int)255));		HX_STACK_VAR(b2,"b2");
	HX_STACK_LINE(172)
	int a = ::Std_obj::_int(((a1 * (((int)1 - k))) + (a2 * k)));		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(173)
	int r = ::Std_obj::_int(((r1 * (((int)1 - k))) + (r2 * k)));		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(174)
	int g = ::Std_obj::_int(((g1 * (((int)1 - k))) + (g2 * k)));		HX_STACK_VAR(g,"g");
	HX_STACK_LINE(175)
	int b = ::Std_obj::_int(((b1 * (((int)1 - k))) + (b2 * k)));		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(176)
	return (int((int((int((int(a) << int((int)24))) | int((int(r) << int((int)16))))) | int((int(g) << int((int)8))))) | int(b));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,colorLerp,return )

Float Math_obj::angle( Float da){
	HX_STACK_FRAME("hxd.Math","angle",0xba2273a7,"hxd.Math.angle","hxd/Math.hx",182,0xbdc330db)
	HX_STACK_ARG(da,"da")
	HX_STACK_LINE(183)
	hx::ModEq(da,6.2831853071795862);
	HX_STACK_LINE(184)
	if (((da > 3.14159265358979323))){
		HX_STACK_LINE(184)
		hx::SubEq(da,6.2831853071795862);
	}
	else{
		HX_STACK_LINE(184)
		if (((da <= -3.1415926535897931))){
			HX_STACK_LINE(184)
			hx::AddEq(da,6.2831853071795862);
		}
	}
	HX_STACK_LINE(185)
	return da;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,angle,return )

Float Math_obj::angleLerp( Float a,Float b,Float k){
	HX_STACK_FRAME("hxd.Math","angleLerp",0xe24c11be,"hxd.Math.angleLerp","hxd/Math.hx",188,0xbdc330db)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(k,"k")
	HX_STACK_LINE(189)
	Float _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(189)
	{
		HX_STACK_LINE(189)
		Float da = (b - a);		HX_STACK_VAR(da,"da");
		HX_STACK_LINE(189)
		hx::ModEq(da,6.2831853071795862);
		HX_STACK_LINE(189)
		if (((da > 3.14159265358979323))){
			HX_STACK_LINE(189)
			hx::SubEq(da,6.2831853071795862);
		}
		else{
			HX_STACK_LINE(189)
			if (((da <= -3.1415926535897931))){
				HX_STACK_LINE(189)
				hx::AddEq(da,6.2831853071795862);
			}
		}
		HX_STACK_LINE(189)
		_g = da;
	}
	HX_STACK_LINE(189)
	Float _g1 = (_g * k);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(189)
	return (a + _g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,angleLerp,return )

Float Math_obj::angleMove( Float a,Float b,Float max){
	HX_STACK_FRAME("hxd.Math","angleMove",0xe2fce258,"hxd.Math.angleMove","hxd/Math.hx",195,0xbdc330db)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(max,"max")
	HX_STACK_LINE(196)
	Float da;		HX_STACK_VAR(da,"da");
	HX_STACK_LINE(196)
	{
		HX_STACK_LINE(196)
		Float da1 = (b - a);		HX_STACK_VAR(da1,"da1");
		HX_STACK_LINE(196)
		hx::ModEq(da1,6.2831853071795862);
		HX_STACK_LINE(196)
		if (((da1 > 3.14159265358979323))){
			HX_STACK_LINE(196)
			hx::SubEq(da1,6.2831853071795862);
		}
		else{
			HX_STACK_LINE(196)
			if (((da1 <= -3.1415926535897931))){
				HX_STACK_LINE(196)
				hx::AddEq(da1,6.2831853071795862);
			}
		}
		HX_STACK_LINE(196)
		da = da1;
	}
	HX_STACK_LINE(197)
	if (((bool((da > -(max))) && bool((da < max))))){
		HX_STACK_LINE(197)
		return b;
	}
	else{
		HX_STACK_LINE(197)
		return (a + ((  (((da < (int)0))) ? Float(-(max)) : Float(max) )));
	}
	HX_STACK_LINE(197)
	return 0.;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Math_obj,angleMove,return )

Float Math_obj::random( hx::Null< Float >  __o_max){
Float max = __o_max.Default(1.0);
	HX_STACK_FRAME("hxd.Math","random",0x7878cbaf,"hxd.Math.random","hxd/Math.hx",201,0xbdc330db)
	HX_STACK_ARG(max,"max")
{
		HX_STACK_LINE(202)
		Float _g = ::Math_obj::random();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(202)
		return (_g * max);
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,random,return )

Float Math_obj::srand( hx::Null< Float >  __o_max){
Float max = __o_max.Default(1.0);
	HX_STACK_FRAME("hxd.Math","srand",0x19f9336c,"hxd.Math.srand","hxd/Math.hx",208,0xbdc330db)
	HX_STACK_ARG(max,"max")
{
		HX_STACK_LINE(209)
		Float _g = ::Math_obj::random();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(209)
		Float _g1 = (_g - 0.5);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(209)
		return (_g1 * ((max * (int)2)));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,srand,return )

Float Math_obj::b2f( int v){
	HX_STACK_FRAME("hxd.Math","b2f",0x7a115baa,"hxd.Math.b2f","hxd/Math.hx",219,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(219)
	return (((int(v) & int((int)255))) * 0.0039215686274509803921568627451);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,b2f,return )

int Math_obj::f2b( Float v){
	HX_STACK_FRAME("hxd.Math","f2b",0x7a1464aa,"hxd.Math.f2b","hxd/Math.hx",227,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(228)
	Float f;		HX_STACK_VAR(f,"f");
	HX_STACK_LINE(228)
	if (((v < 0.0))){
		HX_STACK_LINE(228)
		f = 0.0;
	}
	else{
		HX_STACK_LINE(228)
		if (((v > 1.0))){
			HX_STACK_LINE(228)
			f = 1.0;
		}
		else{
			HX_STACK_LINE(228)
			f = v;
		}
	}
	HX_STACK_LINE(229)
	return ::Std_obj::_int((f * 255.0));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,f2b,return )

int Math_obj::posMod( int i,int m){
	HX_STACK_FRAME("hxd.Math","posMod",0xbe9acf3a,"hxd.Math.posMod","hxd/Math.hx",237,0xbdc330db)
	HX_STACK_ARG(i,"i")
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(238)
	int mod = hx::Mod(i,m);		HX_STACK_VAR(mod,"mod");
	HX_STACK_LINE(239)
	if (((mod >= (int)0))){
		HX_STACK_LINE(239)
		return mod;
	}
	else{
		HX_STACK_LINE(239)
		return (mod + m);
	}
	HX_STACK_LINE(239)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Math_obj,posMod,return )

::h3d::Vector Math_obj::getColorVector( int v){
	HX_STACK_FRAME("hxd.Math","getColorVector",0x4391cb3c,"hxd.Math.getColorVector","hxd/Math.hx",243,0xbdc330db)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(243)
	return ::h3d::Vector_obj::__new((((int((int(v) >> int((int)16))) & int((int)255))) * 0.0039215686274509803921568627451),(((int((int(v) >> int((int)8))) & int((int)255))) * 0.0039215686274509803921568627451),(((int(v) & int((int)255))) * 0.0039215686274509803921568627451),(((int((int(v) >> int((int)24))) & int((int)255))) * 0.0039215686274509803921568627451));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Math_obj,getColorVector,return )


Math_obj::Math_obj()
{
}

Dynamic Math_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"NaN") ) { return get_NaN(); }
		if (HX_FIELD_EQ(inName,"fmt") ) { return fmt_dyn(); }
		if (HX_FIELD_EQ(inName,"sel") ) { return sel_dyn(); }
		if (HX_FIELD_EQ(inName,"pow") ) { return pow_dyn(); }
		if (HX_FIELD_EQ(inName,"cos") ) { return cos_dyn(); }
		if (HX_FIELD_EQ(inName,"sin") ) { return sin_dyn(); }
		if (HX_FIELD_EQ(inName,"tan") ) { return tan_dyn(); }
		if (HX_FIELD_EQ(inName,"abs") ) { return abs_dyn(); }
		if (HX_FIELD_EQ(inName,"max") ) { return max_dyn(); }
		if (HX_FIELD_EQ(inName,"min") ) { return min_dyn(); }
		if (HX_FIELD_EQ(inName,"b2f") ) { return b2f_dyn(); }
		if (HX_FIELD_EQ(inName,"f2b") ) { return f2b_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"ceil") ) { return ceil_dyn(); }
		if (HX_FIELD_EQ(inName,"acos") ) { return acos_dyn(); }
		if (HX_FIELD_EQ(inName,"asin") ) { return asin_dyn(); }
		if (HX_FIELD_EQ(inName,"atan") ) { return atan_dyn(); }
		if (HX_FIELD_EQ(inName,"sqrt") ) { return sqrt_dyn(); }
		if (HX_FIELD_EQ(inName,"iabs") ) { return iabs_dyn(); }
		if (HX_FIELD_EQ(inName,"imax") ) { return imax_dyn(); }
		if (HX_FIELD_EQ(inName,"imin") ) { return imin_dyn(); }
		if (HX_FIELD_EQ(inName,"lerp") ) { return lerp_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"isNaN") ) { return isNaN_dyn(); }
		if (HX_FIELD_EQ(inName,"floor") ) { return floor_dyn(); }
		if (HX_FIELD_EQ(inName,"round") ) { return round_dyn(); }
		if (HX_FIELD_EQ(inName,"clamp") ) { return clamp_dyn(); }
		if (HX_FIELD_EQ(inName,"atan2") ) { return atan2_dyn(); }
		if (HX_FIELD_EQ(inName,"angle") ) { return angle_dyn(); }
		if (HX_FIELD_EQ(inName,"srand") ) { return srand_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"iclamp") ) { return iclamp_dyn(); }
		if (HX_FIELD_EQ(inName,"random") ) { return random_dyn(); }
		if (HX_FIELD_EQ(inName,"posMod") ) { return posMod_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"get_NaN") ) { return get_NaN_dyn(); }
		if (HX_FIELD_EQ(inName,"invSqrt") ) { return invSqrt_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"bitCount") ) { return bitCount_dyn(); }
		if (HX_FIELD_EQ(inName,"distance") ) { return distance_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"colorLerp") ) { return colorLerp_dyn(); }
		if (HX_FIELD_EQ(inName,"angleLerp") ) { return angleLerp_dyn(); }
		if (HX_FIELD_EQ(inName,"angleMove") ) { return angleMove_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"distanceSq") ) { return distanceSq_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"getColorVector") ) { return getColorVector_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"POSITIVE_INFINITY") ) { return get_POSITIVE_INFINITY(); }
		if (HX_FIELD_EQ(inName,"NEGATIVE_INFINITY") ) { return get_NEGATIVE_INFINITY(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"get_POSITIVE_INFINITY") ) { return get_POSITIVE_INFINITY_dyn(); }
		if (HX_FIELD_EQ(inName,"get_NEGATIVE_INFINITY") ) { return get_NEGATIVE_INFINITY_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Math_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Math_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("PI"),
	HX_CSTRING("EPSILON"),
	HX_CSTRING("get_POSITIVE_INFINITY"),
	HX_CSTRING("get_NEGATIVE_INFINITY"),
	HX_CSTRING("get_NaN"),
	HX_CSTRING("isNaN"),
	HX_CSTRING("fmt"),
	HX_CSTRING("floor"),
	HX_CSTRING("ceil"),
	HX_CSTRING("round"),
	HX_CSTRING("sel"),
	HX_CSTRING("clamp"),
	HX_CSTRING("pow"),
	HX_CSTRING("cos"),
	HX_CSTRING("sin"),
	HX_CSTRING("tan"),
	HX_CSTRING("acos"),
	HX_CSTRING("asin"),
	HX_CSTRING("atan"),
	HX_CSTRING("sqrt"),
	HX_CSTRING("invSqrt"),
	HX_CSTRING("atan2"),
	HX_CSTRING("abs"),
	HX_CSTRING("max"),
	HX_CSTRING("min"),
	HX_CSTRING("iabs"),
	HX_CSTRING("imax"),
	HX_CSTRING("imin"),
	HX_CSTRING("iclamp"),
	HX_CSTRING("lerp"),
	HX_CSTRING("bitCount"),
	HX_CSTRING("distanceSq"),
	HX_CSTRING("distance"),
	HX_CSTRING("colorLerp"),
	HX_CSTRING("angle"),
	HX_CSTRING("angleLerp"),
	HX_CSTRING("angleMove"),
	HX_CSTRING("random"),
	HX_CSTRING("srand"),
	HX_CSTRING("b2f"),
	HX_CSTRING("f2b"),
	HX_CSTRING("posMod"),
	HX_CSTRING("getColorVector"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Math_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Math_obj::PI,"PI");
	HX_MARK_MEMBER_NAME(Math_obj::EPSILON,"EPSILON");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Math_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Math_obj::PI,"PI");
	HX_VISIT_MEMBER_NAME(Math_obj::EPSILON,"EPSILON");
};

#endif

Class Math_obj::__mClass;

void Math_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Math"), hx::TCanCast< Math_obj> ,sStaticFields,sMemberFields,
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

void Math_obj::__boot()
{
	PI= 3.14159265358979323;
	EPSILON= 1e-10;
}

} // end namespace hxd
