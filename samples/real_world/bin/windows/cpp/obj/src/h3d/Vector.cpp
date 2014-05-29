#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Math
#include <hxd/Math.h>
#endif
namespace h3d{

Void Vector_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w)
{
HX_STACK_FRAME("h3d.Vector","new",0xbf066a6a,"h3d.Vector.new","h3d/Vector.hx",11,0x2d0ec825)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
HX_STACK_ARG(__o_z,"z")
HX_STACK_ARG(__o_w,"w")
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
Float z = __o_z.Default(0.);
Float w = __o_w.Default(1.);
{
	HX_STACK_LINE(12)
	this->x = x;
	HX_STACK_LINE(13)
	this->y = y;
	HX_STACK_LINE(14)
	this->z = z;
	HX_STACK_LINE(15)
	this->w = w;
}
;
	return null();
}

//Vector_obj::~Vector_obj() { }

Dynamic Vector_obj::__CreateEmpty() { return  new Vector_obj; }
hx::ObjectPtr< Vector_obj > Vector_obj::__new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w)
{  hx::ObjectPtr< Vector_obj > result = new Vector_obj();
	result->__construct(__o_x,__o_y,__o_z,__o_w);
	return result;}

Dynamic Vector_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Vector_obj > result = new Vector_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

Float Vector_obj::distance( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Vector","distance",0x1d2a54eb,"h3d.Vector.distance","h3d/Vector.hx",19,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	struct _Function_1_1{
		inline static Float Block( hx::ObjectPtr< ::h3d::Vector_obj > __this,::h3d::Vector &v){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Vector.hx",19,0x2d0ec825)
			{
				HX_STACK_LINE(19)
				Float dx = (v->x - __this->x);		HX_STACK_VAR(dx,"dx");
				HX_STACK_LINE(19)
				Float dy = (v->y - __this->y);		HX_STACK_VAR(dy,"dy");
				HX_STACK_LINE(19)
				Float dz = (v->z - __this->z);		HX_STACK_VAR(dz,"dz");
				HX_STACK_LINE(19)
				return (((dx * dx) + (dy * dy)) + (dz * dz));
			}
			return null();
		}
	};
	HX_STACK_LINE(19)
	return ::Math_obj::sqrt(_Function_1_1::Block(this,v));
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,distance,return )

Float Vector_obj::distanceSq( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Vector","distanceSq",0x7c19ee69,"h3d.Vector.distanceSq","h3d/Vector.hx",22,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(23)
	Float dx = (v->x - this->x);		HX_STACK_VAR(dx,"dx");
	HX_STACK_LINE(24)
	Float dy = (v->y - this->y);		HX_STACK_VAR(dy,"dy");
	HX_STACK_LINE(25)
	Float dz = (v->z - this->z);		HX_STACK_VAR(dz,"dz");
	HX_STACK_LINE(26)
	return (((dx * dx) + (dy * dy)) + (dz * dz));
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,distanceSq,return )

::h3d::Vector Vector_obj::sub( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Vector","sub",0xbf0a438a,"h3d.Vector.sub","h3d/Vector.hx",30,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(30)
	return ::h3d::Vector_obj::__new((this->x - v->x),(this->y - v->y),(this->z - v->z),(this->w - v->w));
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,sub,return )

::h3d::Vector Vector_obj::add( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Vector","add",0xbefc8c2b,"h3d.Vector.add","h3d/Vector.hx",34,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(34)
	return ::h3d::Vector_obj::__new((this->x + v->x),(this->y + v->y),(this->z + v->z),(this->w + v->w));
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,add,return )

::h3d::Vector Vector_obj::cross( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Vector","cross",0x106f100a,"h3d.Vector.cross","h3d/Vector.hx",38,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(38)
	return ::h3d::Vector_obj::__new(((this->y * v->z) - (this->z * v->y)),((this->z * v->x) - (this->x * v->z)),((this->x * v->y) - (this->y * v->x)),(int)1);
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,cross,return )

::h3d::Vector Vector_obj::reflect( ::h3d::Vector n){
	HX_STACK_FRAME("h3d.Vector","reflect",0x6032eb47,"h3d.Vector.reflect","h3d/Vector.hx",41,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(n,"n")
	HX_STACK_LINE(42)
	Float k = ((int)2 * ((((this->x * n->x) + (this->y * n->y)) + (this->z * n->z))));		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(43)
	return ::h3d::Vector_obj::__new((this->x - (k * n->x)),(this->y - (k * n->y)),(this->z - (k * n->z)),(int)1);
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,reflect,return )

Float Vector_obj::dot3( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Vector","dot3",0x60022440,"h3d.Vector.dot3","h3d/Vector.hx",47,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(47)
	return (((this->x * v->x) + (this->y * v->y)) + (this->z * v->z));
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,dot3,return )

Float Vector_obj::dot4( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Vector","dot4",0x60022441,"h3d.Vector.dot4","h3d/Vector.hx",51,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(51)
	return ((((this->x * v->x) + (this->y * v->y)) + (this->z * v->z)) + (this->w * v->w));
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,dot4,return )

Float Vector_obj::lengthSq( ){
	HX_STACK_FRAME("h3d.Vector","lengthSq",0xd0f424da,"h3d.Vector.lengthSq","h3d/Vector.hx",55,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_LINE(55)
	return (((this->x * this->x) + (this->y * this->y)) + (this->z * this->z));
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,lengthSq,return )

Float Vector_obj::length( ){
	HX_STACK_FRAME("h3d.Vector","length",0x6d0d5d1c,"h3d.Vector.length","h3d/Vector.hx",59,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_LINE(59)
	return ::Math_obj::sqrt((((this->x * this->x) + (this->y * this->y)) + (this->z * this->z)));
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,length,return )

::h3d::Vector Vector_obj::normalize( ){
	HX_STACK_FRAME("h3d.Vector","normalize",0x0519f517,"h3d.Vector.normalize","h3d/Vector.hx",62,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_LINE(63)
	Float k = (((this->x * this->x) + (this->y * this->y)) + (this->z * this->z));		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(64)
	if (((k < 1e-10))){
		HX_STACK_LINE(64)
		k = (int)0;
	}
	else{
		HX_STACK_LINE(64)
		Float _g = ::Math_obj::sqrt(k);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(64)
		Float _g1 = (Float(1.) / Float(_g));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(64)
		k = _g1;
	}
	HX_STACK_LINE(65)
	hx::MultEq(this->x,k);
	HX_STACK_LINE(66)
	hx::MultEq(this->y,k);
	HX_STACK_LINE(67)
	hx::MultEq(this->z,k);
	HX_STACK_LINE(68)
	return hx::ObjectPtr<OBJ_>(this);
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,normalize,return )

::h3d::Vector Vector_obj::safeNormalize( ){
	HX_STACK_FRAME("h3d.Vector","safeNormalize",0x68dc530a,"h3d.Vector.safeNormalize","h3d/Vector.hx",71,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_LINE(72)
	Float k = (((this->x * this->x) + (this->y * this->y)) + (this->z * this->z));		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(73)
	if (((k < 1e-10))){
		HX_STACK_LINE(75)
		this->x = (int)0;
		HX_STACK_LINE(75)
		this->y = (int)1;
		HX_STACK_LINE(75)
		this->z = (int)0;
		HX_STACK_LINE(76)
		return hx::ObjectPtr<OBJ_>(this);
	}
	else{
		HX_STACK_LINE(79)
		Float _g = ::Math_obj::sqrt(k);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(79)
		Float _g1 = (Float(1.) / Float(_g));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(79)
		k = _g1;
		HX_STACK_LINE(80)
		hx::MultEq(this->x,k);
		HX_STACK_LINE(81)
		hx::MultEq(this->y,k);
		HX_STACK_LINE(82)
		hx::MultEq(this->z,k);
		HX_STACK_LINE(83)
		return hx::ObjectPtr<OBJ_>(this);
	}
	HX_STACK_LINE(73)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,safeNormalize,return )

Void Vector_obj::set( Float x,Float y,Float z,hx::Null< Float >  __o_w){
Float w = __o_w.Default(1.);
	HX_STACK_FRAME("h3d.Vector","set",0xbf0a35ac,"h3d.Vector.set","h3d/Vector.hx",87,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
	HX_STACK_ARG(w,"w")
{
		HX_STACK_LINE(88)
		this->x = x;
		HX_STACK_LINE(89)
		this->y = y;
		HX_STACK_LINE(90)
		this->z = z;
		HX_STACK_LINE(91)
		this->w = w;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Vector_obj,set,(void))

Void Vector_obj::copy( Dynamic v){
{
		HX_STACK_FRAME("h3d.Vector","copy",0x5f58ea6b,"h3d.Vector.copy","h3d/Vector.hx",94,0x2d0ec825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(95)
		this->x = v->__Field(HX_CSTRING("x"),true);
		HX_STACK_LINE(96)
		this->y = v->__Field(HX_CSTRING("y"),true);
		HX_STACK_LINE(97)
		this->z = v->__Field(HX_CSTRING("z"),true);
		HX_STACK_LINE(98)
		this->w = v->__Field(HX_CSTRING("w"),true);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,copy,(void))

Void Vector_obj::scale3( Float f){
{
		HX_STACK_FRAME("h3d.Vector","scale3",0x0a2bb29f,"h3d.Vector.scale3","h3d/Vector.hx",101,0x2d0ec825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(102)
		hx::MultEq(this->x,f);
		HX_STACK_LINE(103)
		hx::MultEq(this->y,f);
		HX_STACK_LINE(104)
		hx::MultEq(this->z,f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,scale3,(void))

Void Vector_obj::project( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Vector","project",0x6cf479e3,"h3d.Vector.project","h3d/Vector.hx",107,0x2d0ec825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(108)
		Float px = ((((this->x * m->_11) + (this->y * m->_21)) + (this->z * m->_31)) + (this->w * m->_41));		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(109)
		Float py = ((((this->x * m->_12) + (this->y * m->_22)) + (this->z * m->_32)) + (this->w * m->_42));		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(110)
		Float pz = ((((this->x * m->_13) + (this->y * m->_23)) + (this->z * m->_33)) + (this->w * m->_43));		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(111)
		Float iw = (Float((int)1) / Float((((((this->x * m->_14) + (this->y * m->_24)) + (this->z * m->_34)) + (this->w * m->_44)))));		HX_STACK_VAR(iw,"iw");
		HX_STACK_LINE(112)
		this->x = (px * iw);
		HX_STACK_LINE(113)
		this->y = (py * iw);
		HX_STACK_LINE(114)
		this->z = (pz * iw);
		HX_STACK_LINE(115)
		this->w = (int)1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,project,(void))

Void Vector_obj::lerp( ::h3d::Vector v1,::h3d::Vector v2,Float k){
{
		HX_STACK_FRAME("h3d.Vector","lerp",0x6544412d,"h3d.Vector.lerp","h3d/Vector.hx",118,0x2d0ec825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v1,"v1")
		HX_STACK_ARG(v2,"v2")
		HX_STACK_ARG(k,"k")
		HX_STACK_LINE(119)
		Float x;		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(119)
		{
			HX_STACK_LINE(119)
			Float a = v1->x;		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(119)
			x = (a + (k * ((v2->x - a))));
		}
		HX_STACK_LINE(120)
		Float y;		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(120)
		{
			HX_STACK_LINE(120)
			Float a = v1->y;		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(120)
			y = (a + (k * ((v2->y - a))));
		}
		HX_STACK_LINE(121)
		Float z;		HX_STACK_VAR(z,"z");
		HX_STACK_LINE(121)
		{
			HX_STACK_LINE(121)
			Float a = v1->z;		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(121)
			z = (a + (k * ((v2->z - a))));
		}
		HX_STACK_LINE(122)
		Float w;		HX_STACK_VAR(w,"w");
		HX_STACK_LINE(122)
		{
			HX_STACK_LINE(122)
			Float a = v1->w;		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(122)
			w = (a + (k * ((v2->w - a))));
		}
		HX_STACK_LINE(123)
		this->x = x;
		HX_STACK_LINE(124)
		this->y = y;
		HX_STACK_LINE(125)
		this->z = z;
		HX_STACK_LINE(126)
		this->w = w;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Vector_obj,lerp,(void))

Void Vector_obj::transform3x4( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Vector","transform3x4",0x6883ee79,"h3d.Vector.transform3x4","h3d/Vector.hx",129,0x2d0ec825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(130)
		Float px = ((((this->x * m->_11) + (this->y * m->_21)) + (this->z * m->_31)) + (this->w * m->_41));		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(131)
		Float py = ((((this->x * m->_12) + (this->y * m->_22)) + (this->z * m->_32)) + (this->w * m->_42));		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(132)
		Float pz = ((((this->x * m->_13) + (this->y * m->_23)) + (this->z * m->_33)) + (this->w * m->_43));		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(133)
		this->x = px;
		HX_STACK_LINE(134)
		this->y = py;
		HX_STACK_LINE(135)
		this->z = pz;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,transform3x4,(void))

Void Vector_obj::transform3x3( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Vector","transform3x3",0x6883ee78,"h3d.Vector.transform3x3","h3d/Vector.hx",138,0x2d0ec825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(139)
		Float px = (((this->x * m->_11) + (this->y * m->_21)) + (this->z * m->_31));		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(140)
		Float py = (((this->x * m->_12) + (this->y * m->_22)) + (this->z * m->_32));		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(141)
		Float pz = (((this->x * m->_13) + (this->y * m->_23)) + (this->z * m->_33));		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(142)
		this->x = px;
		HX_STACK_LINE(143)
		this->y = py;
		HX_STACK_LINE(144)
		this->z = pz;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,transform3x3,(void))

Void Vector_obj::transform( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Vector","transform",0x9f0beaf6,"h3d.Vector.transform","h3d/Vector.hx",147,0x2d0ec825)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(148)
		Float px = ((((this->x * m->_11) + (this->y * m->_21)) + (this->z * m->_31)) + (this->w * m->_41));		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(149)
		Float py = ((((this->x * m->_12) + (this->y * m->_22)) + (this->z * m->_32)) + (this->w * m->_42));		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(150)
		Float pz = ((((this->x * m->_13) + (this->y * m->_23)) + (this->z * m->_33)) + (this->w * m->_43));		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(151)
		Float pw = ((((this->x * m->_14) + (this->y * m->_24)) + (this->z * m->_34)) + (this->w * m->_44));		HX_STACK_VAR(pw,"pw");
		HX_STACK_LINE(152)
		this->x = px;
		HX_STACK_LINE(153)
		this->y = py;
		HX_STACK_LINE(154)
		this->z = pz;
		HX_STACK_LINE(155)
		this->w = pw;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector_obj,transform,(void))

Void Vector_obj::loadColor( int c,hx::Null< Float >  __o_scale){
Float scale = __o_scale.Default(1.0);
	HX_STACK_FRAME("h3d.Vector","loadColor",0xbf0c7ae7,"h3d.Vector.loadColor","h3d/Vector.hx",158,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_ARG(c,"c")
	HX_STACK_ARG(scale,"scale")
{
		HX_STACK_LINE(159)
		Float s = (Float(scale) / Float((int)255));		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(160)
		this->x = (((int((int(c) >> int((int)16))) & int((int)255))) * s);
		HX_STACK_LINE(161)
		this->y = (((int((int(c) >> int((int)8))) & int((int)255))) * s);
		HX_STACK_LINE(162)
		this->z = (((int(c) & int((int)255))) * s);
		HX_STACK_LINE(163)
		this->w = ((hx::UShr(c,(int)24)) * s);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Vector_obj,loadColor,(void))

::h3d::col::Point Vector_obj::toPoint( ){
	HX_STACK_FRAME("h3d.Vector","toPoint",0x0a1d67df,"h3d.Vector.toPoint","h3d/Vector.hx",167,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_LINE(167)
	return ::h3d::col::Point_obj::__new(this->x,this->y,this->z);
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,toPoint,return )

int Vector_obj::toColor( ){
	HX_STACK_FRAME("h3d.Vector","toColor",0x8dea24f2,"h3d.Vector.toColor","h3d/Vector.hx",171,0x2d0ec825)
	HX_STACK_THIS(this)
	struct _Function_1_1{
		inline static Float Block( hx::ObjectPtr< ::h3d::Vector_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Vector.hx",172,0x2d0ec825)
			{
				HX_STACK_LINE(172)
				Float f = __this->w;		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(172)
				return (  (((f < (int)0))) ? Float((int)0) : Float((  (((f > (int)1))) ? Float((int)1) : Float(f) )) );
			}
			return null();
		}
	};
	HX_STACK_LINE(172)
	int _g = ::Std_obj::_int(((_Function_1_1::Block(this) * (int)255) + 0.499));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(172)
	int _g1 = (int(_g) << int((int)24));		HX_STACK_VAR(_g1,"_g1");
	struct _Function_1_2{
		inline static Float Block( hx::ObjectPtr< ::h3d::Vector_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Vector.hx",172,0x2d0ec825)
			{
				HX_STACK_LINE(172)
				Float f = __this->x;		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(172)
				return (  (((f < (int)0))) ? Float((int)0) : Float((  (((f > (int)1))) ? Float((int)1) : Float(f) )) );
			}
			return null();
		}
	};
	HX_STACK_LINE(172)
	int _g2 = ::Std_obj::_int(((_Function_1_2::Block(this) * (int)255) + 0.499));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(172)
	int _g3 = (int(_g2) << int((int)16));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(172)
	int _g4 = (int(_g1) | int(_g3));		HX_STACK_VAR(_g4,"_g4");
	struct _Function_1_3{
		inline static Float Block( hx::ObjectPtr< ::h3d::Vector_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Vector.hx",172,0x2d0ec825)
			{
				HX_STACK_LINE(172)
				Float f = __this->y;		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(172)
				return (  (((f < (int)0))) ? Float((int)0) : Float((  (((f > (int)1))) ? Float((int)1) : Float(f) )) );
			}
			return null();
		}
	};
	HX_STACK_LINE(172)
	int _g5 = ::Std_obj::_int(((_Function_1_3::Block(this) * (int)255) + 0.499));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(172)
	int _g6 = (int(_g5) << int((int)8));		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(172)
	int _g7 = (int(_g4) | int(_g6));		HX_STACK_VAR(_g7,"_g7");
	struct _Function_1_4{
		inline static Float Block( hx::ObjectPtr< ::h3d::Vector_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Vector.hx",172,0x2d0ec825)
			{
				HX_STACK_LINE(172)
				Float f = __this->z;		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(172)
				return (  (((f < (int)0))) ? Float((int)0) : Float((  (((f > (int)1))) ? Float((int)1) : Float(f) )) );
			}
			return null();
		}
	};
	HX_STACK_LINE(172)
	int _g8 = ::Std_obj::_int(((_Function_1_4::Block(this) * (int)255) + 0.499));		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(172)
	return (int(_g7) | int(_g8));
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,toColor,return )

::h3d::Vector Vector_obj::clone( ){
	HX_STACK_FRAME("h3d.Vector","clone",0x0c77c3e7,"h3d.Vector.clone","h3d/Vector.hx",181,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_LINE(181)
	return ::h3d::Vector_obj::__new(this->x,this->y,this->z,this->w);
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,clone,return )

::String Vector_obj::toString( ){
	HX_STACK_FRAME("h3d.Vector","toString",0xe99f9262,"h3d.Vector.toString","h3d/Vector.hx",184,0x2d0ec825)
	HX_STACK_THIS(this)
	HX_STACK_LINE(185)
	Float _g = ::hxd::Math_obj::fmt(this->x);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(185)
	::String _g1 = (HX_CSTRING("{") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(185)
	::String _g2 = (_g1 + HX_CSTRING(","));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(185)
	Float _g3 = ::hxd::Math_obj::fmt(this->y);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(185)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(185)
	::String _g5 = (_g4 + HX_CSTRING(","));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(185)
	Float _g6 = ::hxd::Math_obj::fmt(this->z);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(185)
	::String _g7 = (_g5 + _g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(185)
	::String _g8 = (_g7 + HX_CSTRING(","));		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(185)
	Float _g9 = ::hxd::Math_obj::fmt(this->w);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(185)
	::String _g10 = (_g8 + _g9);		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(185)
	return (_g10 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Vector_obj,toString,return )

::h3d::Vector Vector_obj::fromColor( int c,hx::Null< Float >  __o_scale){
Float scale = __o_scale.Default(1.0);
	HX_STACK_FRAME("h3d.Vector","fromColor",0x585e1923,"h3d.Vector.fromColor","h3d/Vector.hx",175,0x2d0ec825)
	HX_STACK_ARG(c,"c")
	HX_STACK_ARG(scale,"scale")
{
		HX_STACK_LINE(176)
		Float s = (Float(scale) / Float((int)255));		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(177)
		return ::h3d::Vector_obj::__new((((int((int(c) >> int((int)16))) & int((int)255))) * s),(((int((int(c) >> int((int)8))) & int((int)255))) * s),(((int(c) & int((int)255))) * s),((hx::UShr(c,(int)24)) * s));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Vector_obj,fromColor,return )


Vector_obj::Vector_obj()
{
}

Dynamic Vector_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"z") ) { return z; }
		if (HX_FIELD_EQ(inName,"w") ) { return w; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"dot3") ) { return dot3_dyn(); }
		if (HX_FIELD_EQ(inName,"dot4") ) { return dot4_dyn(); }
		if (HX_FIELD_EQ(inName,"copy") ) { return copy_dyn(); }
		if (HX_FIELD_EQ(inName,"lerp") ) { return lerp_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"cross") ) { return cross_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return length_dyn(); }
		if (HX_FIELD_EQ(inName,"scale3") ) { return scale3_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"reflect") ) { return reflect_dyn(); }
		if (HX_FIELD_EQ(inName,"project") ) { return project_dyn(); }
		if (HX_FIELD_EQ(inName,"toPoint") ) { return toPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"toColor") ) { return toColor_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"distance") ) { return distance_dyn(); }
		if (HX_FIELD_EQ(inName,"lengthSq") ) { return lengthSq_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromColor") ) { return fromColor_dyn(); }
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		if (HX_FIELD_EQ(inName,"transform") ) { return transform_dyn(); }
		if (HX_FIELD_EQ(inName,"loadColor") ) { return loadColor_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"distanceSq") ) { return distanceSq_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"transform3x4") ) { return transform3x4_dyn(); }
		if (HX_FIELD_EQ(inName,"transform3x3") ) { return transform3x3_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"safeNormalize") ) { return safeNormalize_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Vector_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"z") ) { z=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"w") ) { w=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Vector_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("z"));
	outFields->push(HX_CSTRING("w"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromColor"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Vector_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Vector_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Vector_obj,z),HX_CSTRING("z")},
	{hx::fsFloat,(int)offsetof(Vector_obj,w),HX_CSTRING("w")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("z"),
	HX_CSTRING("w"),
	HX_CSTRING("distance"),
	HX_CSTRING("distanceSq"),
	HX_CSTRING("sub"),
	HX_CSTRING("add"),
	HX_CSTRING("cross"),
	HX_CSTRING("reflect"),
	HX_CSTRING("dot3"),
	HX_CSTRING("dot4"),
	HX_CSTRING("lengthSq"),
	HX_CSTRING("length"),
	HX_CSTRING("normalize"),
	HX_CSTRING("safeNormalize"),
	HX_CSTRING("set"),
	HX_CSTRING("copy"),
	HX_CSTRING("scale3"),
	HX_CSTRING("project"),
	HX_CSTRING("lerp"),
	HX_CSTRING("transform3x4"),
	HX_CSTRING("transform3x3"),
	HX_CSTRING("transform"),
	HX_CSTRING("loadColor"),
	HX_CSTRING("toPoint"),
	HX_CSTRING("toColor"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Vector_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Vector_obj::__mClass,"__mClass");
};

#endif

Class Vector_obj::__mClass;

void Vector_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.Vector"), hx::TCanCast< Vector_obj> ,sStaticFields,sMemberFields,
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

void Vector_obj::__boot()
{
}

} // end namespace h3d
