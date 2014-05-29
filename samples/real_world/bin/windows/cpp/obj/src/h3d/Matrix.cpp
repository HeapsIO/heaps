#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
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
namespace h3d{

Void Matrix_obj::__construct()
{
HX_STACK_FRAME("h3d.Matrix","new",0x381486e8,"h3d.Matrix.new","h3d/Matrix.hx",27,0x638e4567)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(27)
	this->identity();
}
;
	return null();
}

//Matrix_obj::~Matrix_obj() { }

Dynamic Matrix_obj::__CreateEmpty() { return  new Matrix_obj; }
hx::ObjectPtr< Matrix_obj > Matrix_obj::__new()
{  hx::ObjectPtr< Matrix_obj > result = new Matrix_obj();
	result->__construct();
	return result;}

Dynamic Matrix_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Matrix_obj > result = new Matrix_obj();
	result->__construct();
	return result;}

Void Matrix_obj::set( Float _11,Float _12,Float _13,Float _14,Float _21,Float _22,Float _23,Float _24,Float _31,Float _32,Float _33,Float _34,Float _41,Float _42,Float _43,Float _44){
{
		HX_STACK_FRAME("h3d.Matrix","set",0x3818522a,"h3d.Matrix.set","h3d/Matrix.hx",33,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(_11,"_11")
		HX_STACK_ARG(_12,"_12")
		HX_STACK_ARG(_13,"_13")
		HX_STACK_ARG(_14,"_14")
		HX_STACK_ARG(_21,"_21")
		HX_STACK_ARG(_22,"_22")
		HX_STACK_ARG(_23,"_23")
		HX_STACK_ARG(_24,"_24")
		HX_STACK_ARG(_31,"_31")
		HX_STACK_ARG(_32,"_32")
		HX_STACK_ARG(_33,"_33")
		HX_STACK_ARG(_34,"_34")
		HX_STACK_ARG(_41,"_41")
		HX_STACK_ARG(_42,"_42")
		HX_STACK_ARG(_43,"_43")
		HX_STACK_ARG(_44,"_44")
		HX_STACK_LINE(35)
		this->_11 = _11;
		HX_STACK_LINE(36)
		this->_12 = _12;
		HX_STACK_LINE(37)
		this->_13 = _13;
		HX_STACK_LINE(38)
		this->_14 = _14;
		HX_STACK_LINE(40)
		this->_21 = _21;
		HX_STACK_LINE(41)
		this->_22 = _22;
		HX_STACK_LINE(42)
		this->_23 = _23;
		HX_STACK_LINE(43)
		this->_24 = _24;
		HX_STACK_LINE(45)
		this->_31 = _31;
		HX_STACK_LINE(46)
		this->_32 = _32;
		HX_STACK_LINE(47)
		this->_33 = _33;
		HX_STACK_LINE(48)
		this->_34 = _34;
		HX_STACK_LINE(50)
		this->_41 = _41;
		HX_STACK_LINE(51)
		this->_42 = _42;
		HX_STACK_LINE(52)
		this->_43 = _43;
		HX_STACK_LINE(53)
		this->_44 = _44;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC16(Matrix_obj,set,(void))

Void Matrix_obj::zero( ){
{
		HX_STACK_FRAME("h3d.Matrix","zero",0xe1d00fa0,"h3d.Matrix.zero","h3d/Matrix.hx",56,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_LINE(57)
		this->_11 = 0.0;
		HX_STACK_LINE(57)
		this->_12 = 0.0;
		HX_STACK_LINE(57)
		this->_13 = 0.0;
		HX_STACK_LINE(57)
		this->_14 = 0.0;
		HX_STACK_LINE(58)
		this->_21 = 0.0;
		HX_STACK_LINE(58)
		this->_22 = 0.0;
		HX_STACK_LINE(58)
		this->_23 = 0.0;
		HX_STACK_LINE(58)
		this->_24 = 0.0;
		HX_STACK_LINE(59)
		this->_31 = 0.0;
		HX_STACK_LINE(59)
		this->_32 = 0.0;
		HX_STACK_LINE(59)
		this->_33 = 0.0;
		HX_STACK_LINE(59)
		this->_34 = 0.0;
		HX_STACK_LINE(60)
		this->_41 = 0.0;
		HX_STACK_LINE(60)
		this->_42 = 0.0;
		HX_STACK_LINE(60)
		this->_43 = 0.0;
		HX_STACK_LINE(60)
		this->_44 = 0.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,zero,(void))

Void Matrix_obj::identity( ){
{
		HX_STACK_FRAME("h3d.Matrix","identity",0xbda3e1b6,"h3d.Matrix.identity","h3d/Matrix.hx",63,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_LINE(64)
		this->_11 = 1.0;
		HX_STACK_LINE(64)
		this->_12 = 0.0;
		HX_STACK_LINE(64)
		this->_13 = 0.0;
		HX_STACK_LINE(64)
		this->_14 = 0.0;
		HX_STACK_LINE(65)
		this->_21 = 0.0;
		HX_STACK_LINE(65)
		this->_22 = 1.0;
		HX_STACK_LINE(65)
		this->_23 = 0.0;
		HX_STACK_LINE(65)
		this->_24 = 0.0;
		HX_STACK_LINE(66)
		this->_31 = 0.0;
		HX_STACK_LINE(66)
		this->_32 = 0.0;
		HX_STACK_LINE(66)
		this->_33 = 1.0;
		HX_STACK_LINE(66)
		this->_34 = 0.0;
		HX_STACK_LINE(67)
		this->_41 = 0.0;
		HX_STACK_LINE(67)
		this->_42 = 0.0;
		HX_STACK_LINE(67)
		this->_43 = 0.0;
		HX_STACK_LINE(67)
		this->_44 = 1.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,identity,(void))

Void Matrix_obj::initRotateX( Float a){
{
		HX_STACK_FRAME("h3d.Matrix","initRotateX",0x522e36f5,"h3d.Matrix.initRotateX","h3d/Matrix.hx",70,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(71)
		Float cos = ::Math_obj::cos(a);		HX_STACK_VAR(cos,"cos");
		HX_STACK_LINE(72)
		Float sin = ::Math_obj::sin(a);		HX_STACK_VAR(sin,"sin");
		HX_STACK_LINE(73)
		this->_11 = 1.0;
		HX_STACK_LINE(73)
		this->_12 = 0.0;
		HX_STACK_LINE(73)
		this->_13 = 0.0;
		HX_STACK_LINE(73)
		this->_14 = 0.0;
		HX_STACK_LINE(74)
		this->_21 = 0.0;
		HX_STACK_LINE(74)
		this->_22 = cos;
		HX_STACK_LINE(74)
		this->_23 = sin;
		HX_STACK_LINE(74)
		this->_24 = 0.0;
		HX_STACK_LINE(75)
		this->_31 = 0.0;
		HX_STACK_LINE(75)
		this->_32 = -(sin);
		HX_STACK_LINE(75)
		this->_33 = cos;
		HX_STACK_LINE(75)
		this->_34 = 0.0;
		HX_STACK_LINE(76)
		this->_41 = 0.0;
		HX_STACK_LINE(76)
		this->_42 = 0.0;
		HX_STACK_LINE(76)
		this->_43 = 0.0;
		HX_STACK_LINE(76)
		this->_44 = 1.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,initRotateX,(void))

Void Matrix_obj::initRotateY( Float a){
{
		HX_STACK_FRAME("h3d.Matrix","initRotateY",0x522e36f6,"h3d.Matrix.initRotateY","h3d/Matrix.hx",79,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(80)
		Float cos = ::Math_obj::cos(a);		HX_STACK_VAR(cos,"cos");
		HX_STACK_LINE(81)
		Float sin = ::Math_obj::sin(a);		HX_STACK_VAR(sin,"sin");
		HX_STACK_LINE(82)
		this->_11 = cos;
		HX_STACK_LINE(82)
		this->_12 = 0.0;
		HX_STACK_LINE(82)
		this->_13 = -(sin);
		HX_STACK_LINE(82)
		this->_14 = 0.0;
		HX_STACK_LINE(83)
		this->_21 = 0.0;
		HX_STACK_LINE(83)
		this->_22 = 1.0;
		HX_STACK_LINE(83)
		this->_23 = 0.0;
		HX_STACK_LINE(83)
		this->_24 = 0.0;
		HX_STACK_LINE(84)
		this->_31 = sin;
		HX_STACK_LINE(84)
		this->_32 = 0.0;
		HX_STACK_LINE(84)
		this->_33 = cos;
		HX_STACK_LINE(84)
		this->_34 = 0.0;
		HX_STACK_LINE(85)
		this->_41 = 0.0;
		HX_STACK_LINE(85)
		this->_42 = 0.0;
		HX_STACK_LINE(85)
		this->_43 = 0.0;
		HX_STACK_LINE(85)
		this->_44 = 1.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,initRotateY,(void))

Void Matrix_obj::initRotateZ( Float a){
{
		HX_STACK_FRAME("h3d.Matrix","initRotateZ",0x522e36f7,"h3d.Matrix.initRotateZ","h3d/Matrix.hx",88,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(89)
		Float cos = ::Math_obj::cos(a);		HX_STACK_VAR(cos,"cos");
		HX_STACK_LINE(90)
		Float sin = ::Math_obj::sin(a);		HX_STACK_VAR(sin,"sin");
		HX_STACK_LINE(91)
		this->_11 = cos;
		HX_STACK_LINE(91)
		this->_12 = sin;
		HX_STACK_LINE(91)
		this->_13 = 0.0;
		HX_STACK_LINE(91)
		this->_14 = 0.0;
		HX_STACK_LINE(92)
		this->_21 = -(sin);
		HX_STACK_LINE(92)
		this->_22 = cos;
		HX_STACK_LINE(92)
		this->_23 = 0.0;
		HX_STACK_LINE(92)
		this->_24 = 0.0;
		HX_STACK_LINE(93)
		this->_31 = 0.0;
		HX_STACK_LINE(93)
		this->_32 = 0.0;
		HX_STACK_LINE(93)
		this->_33 = 1.0;
		HX_STACK_LINE(93)
		this->_34 = 0.0;
		HX_STACK_LINE(94)
		this->_41 = 0.0;
		HX_STACK_LINE(94)
		this->_42 = 0.0;
		HX_STACK_LINE(94)
		this->_43 = 0.0;
		HX_STACK_LINE(94)
		this->_44 = 1.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,initRotateZ,(void))

Void Matrix_obj::initTranslate( hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z){
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
Float z = __o_z.Default(0.);
	HX_STACK_FRAME("h3d.Matrix","initTranslate",0xc2a8caa6,"h3d.Matrix.initTranslate","h3d/Matrix.hx",97,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
{
		HX_STACK_LINE(98)
		this->_11 = 1.0;
		HX_STACK_LINE(98)
		this->_12 = 0.0;
		HX_STACK_LINE(98)
		this->_13 = 0.0;
		HX_STACK_LINE(98)
		this->_14 = 0.0;
		HX_STACK_LINE(99)
		this->_21 = 0.0;
		HX_STACK_LINE(99)
		this->_22 = 1.0;
		HX_STACK_LINE(99)
		this->_23 = 0.0;
		HX_STACK_LINE(99)
		this->_24 = 0.0;
		HX_STACK_LINE(100)
		this->_31 = 0.0;
		HX_STACK_LINE(100)
		this->_32 = 0.0;
		HX_STACK_LINE(100)
		this->_33 = 1.0;
		HX_STACK_LINE(100)
		this->_34 = 0.0;
		HX_STACK_LINE(101)
		this->_41 = x;
		HX_STACK_LINE(101)
		this->_42 = y;
		HX_STACK_LINE(101)
		this->_43 = z;
		HX_STACK_LINE(101)
		this->_44 = 1.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,initTranslate,(void))

Void Matrix_obj::initScale( hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z){
Float x = __o_x.Default(1.);
Float y = __o_y.Default(1.);
Float z = __o_z.Default(1.);
	HX_STACK_FRAME("h3d.Matrix","initScale",0x75f535e2,"h3d.Matrix.initScale","h3d/Matrix.hx",104,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
{
		HX_STACK_LINE(105)
		this->_11 = x;
		HX_STACK_LINE(105)
		this->_12 = 0.0;
		HX_STACK_LINE(105)
		this->_13 = 0.0;
		HX_STACK_LINE(105)
		this->_14 = 0.0;
		HX_STACK_LINE(106)
		this->_21 = 0.0;
		HX_STACK_LINE(106)
		this->_22 = y;
		HX_STACK_LINE(106)
		this->_23 = 0.0;
		HX_STACK_LINE(106)
		this->_24 = 0.0;
		HX_STACK_LINE(107)
		this->_31 = 0.0;
		HX_STACK_LINE(107)
		this->_32 = 0.0;
		HX_STACK_LINE(107)
		this->_33 = z;
		HX_STACK_LINE(107)
		this->_34 = 0.0;
		HX_STACK_LINE(108)
		this->_41 = 0.0;
		HX_STACK_LINE(108)
		this->_42 = 0.0;
		HX_STACK_LINE(108)
		this->_43 = 0.0;
		HX_STACK_LINE(108)
		this->_44 = 1.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,initScale,(void))

Void Matrix_obj::initRotateAxis( ::h3d::Vector axis,Float angle){
{
		HX_STACK_FRAME("h3d.Matrix","initRotateAxis",0x03305244,"h3d.Matrix.initRotateAxis","h3d/Matrix.hx",111,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(axis,"axis")
		HX_STACK_ARG(angle,"angle")
		HX_STACK_LINE(112)
		Float cos = ::Math_obj::cos(angle);		HX_STACK_VAR(cos,"cos");
		HX_STACK_LINE(112)
		Float sin = ::Math_obj::sin(angle);		HX_STACK_VAR(sin,"sin");
		HX_STACK_LINE(113)
		Float cos1 = ((int)1 - cos);		HX_STACK_VAR(cos1,"cos1");
		HX_STACK_LINE(114)
		Float x = -(axis->x);		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(114)
		Float y = -(axis->y);		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(114)
		Float z = -(axis->z);		HX_STACK_VAR(z,"z");
		HX_STACK_LINE(115)
		Float xx = (x * x);		HX_STACK_VAR(xx,"xx");
		HX_STACK_LINE(115)
		Float yy = (y * y);		HX_STACK_VAR(yy,"yy");
		HX_STACK_LINE(115)
		Float zz = (z * z);		HX_STACK_VAR(zz,"zz");
		HX_STACK_LINE(116)
		Float _g = ::Math_obj::sqrt(((xx + yy) + zz));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(116)
		Float len = (Float(1.) / Float(_g));		HX_STACK_VAR(len,"len");
		HX_STACK_LINE(117)
		hx::MultEq(x,len);
		HX_STACK_LINE(118)
		hx::MultEq(y,len);
		HX_STACK_LINE(119)
		hx::MultEq(z,len);
		HX_STACK_LINE(120)
		Float xcos1 = (x * cos1);		HX_STACK_VAR(xcos1,"xcos1");
		HX_STACK_LINE(120)
		Float zcos1 = (z * cos1);		HX_STACK_VAR(zcos1,"zcos1");
		HX_STACK_LINE(121)
		this->_11 = (cos + (x * xcos1));
		HX_STACK_LINE(122)
		this->_12 = ((y * xcos1) - (z * sin));
		HX_STACK_LINE(123)
		this->_13 = ((x * zcos1) + (y * sin));
		HX_STACK_LINE(124)
		this->_14 = 0.;
		HX_STACK_LINE(125)
		this->_21 = ((y * xcos1) + (z * sin));
		HX_STACK_LINE(126)
		this->_22 = (cos + ((y * y) * cos1));
		HX_STACK_LINE(127)
		this->_23 = ((y * zcos1) - (x * sin));
		HX_STACK_LINE(128)
		this->_24 = 0.;
		HX_STACK_LINE(129)
		this->_31 = ((x * zcos1) - (y * sin));
		HX_STACK_LINE(130)
		this->_32 = ((y * zcos1) + (x * sin));
		HX_STACK_LINE(131)
		this->_33 = (cos + (z * zcos1));
		HX_STACK_LINE(132)
		this->_34 = 0.;
		HX_STACK_LINE(133)
		this->_41 = 0.;
		HX_STACK_LINE(133)
		this->_42 = 0.;
		HX_STACK_LINE(133)
		this->_43 = 0.;
		HX_STACK_LINE(133)
		this->_44 = 1.;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,initRotateAxis,(void))

Void Matrix_obj::initRotate( Float x,Float y,Float z){
{
		HX_STACK_FRAME("h3d.Matrix","initRotate",0x4f944c03,"h3d.Matrix.initRotate","h3d/Matrix.hx",136,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(137)
		Float cx = ::Math_obj::cos(x);		HX_STACK_VAR(cx,"cx");
		HX_STACK_LINE(138)
		Float sx = ::Math_obj::sin(x);		HX_STACK_VAR(sx,"sx");
		HX_STACK_LINE(139)
		Float cy = ::Math_obj::cos(y);		HX_STACK_VAR(cy,"cy");
		HX_STACK_LINE(140)
		Float sy = ::Math_obj::sin(y);		HX_STACK_VAR(sy,"sy");
		HX_STACK_LINE(141)
		Float cz = ::Math_obj::cos(z);		HX_STACK_VAR(cz,"cz");
		HX_STACK_LINE(142)
		Float sz = ::Math_obj::sin(z);		HX_STACK_VAR(sz,"sz");
		HX_STACK_LINE(143)
		Float cxsy = (cx * sy);		HX_STACK_VAR(cxsy,"cxsy");
		HX_STACK_LINE(144)
		Float sxsy = (sx * sy);		HX_STACK_VAR(sxsy,"sxsy");
		HX_STACK_LINE(145)
		this->_11 = (cy * cz);
		HX_STACK_LINE(146)
		this->_12 = (cy * sz);
		HX_STACK_LINE(147)
		this->_13 = -(sy);
		HX_STACK_LINE(148)
		this->_14 = (int)0;
		HX_STACK_LINE(149)
		this->_21 = ((sxsy * cz) - (cx * sz));
		HX_STACK_LINE(150)
		this->_22 = ((sxsy * sz) + (cx * cz));
		HX_STACK_LINE(151)
		this->_23 = (sx * cy);
		HX_STACK_LINE(152)
		this->_24 = (int)0;
		HX_STACK_LINE(153)
		this->_31 = ((cxsy * cz) + (sx * sz));
		HX_STACK_LINE(154)
		this->_32 = ((cxsy * sz) - (sx * cz));
		HX_STACK_LINE(155)
		this->_33 = (cx * cy);
		HX_STACK_LINE(156)
		this->_34 = (int)0;
		HX_STACK_LINE(157)
		this->_41 = (int)0;
		HX_STACK_LINE(158)
		this->_42 = (int)0;
		HX_STACK_LINE(159)
		this->_43 = (int)0;
		HX_STACK_LINE(160)
		this->_44 = (int)1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,initRotate,(void))

Void Matrix_obj::translate( hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z){
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
Float z = __o_z.Default(0.);
	HX_STACK_FRAME("h3d.Matrix","translate",0x2b1423d6,"h3d.Matrix.translate","h3d/Matrix.hx",163,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
{
		HX_STACK_LINE(164)
		hx::AddEq(this->_11,(x * this->_14));
		HX_STACK_LINE(165)
		hx::AddEq(this->_12,(y * this->_14));
		HX_STACK_LINE(166)
		hx::AddEq(this->_13,(z * this->_14));
		HX_STACK_LINE(167)
		hx::AddEq(this->_21,(x * this->_24));
		HX_STACK_LINE(168)
		hx::AddEq(this->_22,(y * this->_24));
		HX_STACK_LINE(169)
		hx::AddEq(this->_23,(z * this->_24));
		HX_STACK_LINE(170)
		hx::AddEq(this->_31,(x * this->_34));
		HX_STACK_LINE(171)
		hx::AddEq(this->_32,(y * this->_34));
		HX_STACK_LINE(172)
		hx::AddEq(this->_33,(z * this->_34));
		HX_STACK_LINE(173)
		hx::AddEq(this->_41,(x * this->_44));
		HX_STACK_LINE(174)
		hx::AddEq(this->_42,(y * this->_44));
		HX_STACK_LINE(175)
		hx::AddEq(this->_43,(z * this->_44));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,translate,(void))

Void Matrix_obj::scale( hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z){
Float x = __o_x.Default(1.);
Float y = __o_y.Default(1.);
Float z = __o_z.Default(1.);
	HX_STACK_FRAME("h3d.Matrix","scale",0xab103712,"h3d.Matrix.scale","h3d/Matrix.hx",178,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
{
		HX_STACK_LINE(179)
		hx::MultEq(this->_11,x);
		HX_STACK_LINE(180)
		hx::MultEq(this->_21,x);
		HX_STACK_LINE(181)
		hx::MultEq(this->_31,x);
		HX_STACK_LINE(182)
		hx::MultEq(this->_41,x);
		HX_STACK_LINE(183)
		hx::MultEq(this->_12,y);
		HX_STACK_LINE(184)
		hx::MultEq(this->_22,y);
		HX_STACK_LINE(185)
		hx::MultEq(this->_32,y);
		HX_STACK_LINE(186)
		hx::MultEq(this->_42,y);
		HX_STACK_LINE(187)
		hx::MultEq(this->_13,z);
		HX_STACK_LINE(188)
		hx::MultEq(this->_23,z);
		HX_STACK_LINE(189)
		hx::MultEq(this->_33,z);
		HX_STACK_LINE(190)
		hx::MultEq(this->_43,z);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,scale,(void))

Void Matrix_obj::rotate( Float x,Float y,Float z){
{
		HX_STACK_FRAME("h3d.Matrix","rotate",0x921a54d3,"h3d.Matrix.rotate","h3d/Matrix.hx",193,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(194)
		::h3d::Matrix tmp = ::h3d::Matrix_obj::tmp;		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(195)
		tmp->initRotate(x,y,z);
		HX_STACK_LINE(196)
		this->multiply(hx::ObjectPtr<OBJ_>(this),tmp);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,rotate,(void))

Void Matrix_obj::rotateAxis( ::h3d::Vector axis,Float angle){
{
		HX_STACK_FRAME("h3d.Matrix","rotateAxis",0xf8b30314,"h3d.Matrix.rotateAxis","h3d/Matrix.hx",199,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(axis,"axis")
		HX_STACK_ARG(angle,"angle")
		HX_STACK_LINE(200)
		::h3d::Matrix tmp = ::h3d::Matrix_obj::tmp;		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(201)
		tmp->initRotateAxis(axis,angle);
		HX_STACK_LINE(202)
		this->multiply(hx::ObjectPtr<OBJ_>(this),tmp);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,rotateAxis,(void))

Void Matrix_obj::add( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Matrix","add",0x380aa8a9,"h3d.Matrix.add","h3d/Matrix.hx",206,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(206)
		this->multiply(hx::ObjectPtr<OBJ_>(this),m);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,add,(void))

Void Matrix_obj::prependTranslate( hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z){
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
Float z = __o_z.Default(0.);
	HX_STACK_FRAME("h3d.Matrix","prependTranslate",0xbdd3a2d8,"h3d.Matrix.prependTranslate","h3d/Matrix.hx",209,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
{
		HX_STACK_LINE(210)
		Float vx = ((((this->_11 * x) + (this->_21 * y)) + (this->_31 * z)) + this->_41);		HX_STACK_VAR(vx,"vx");
		HX_STACK_LINE(211)
		Float vy = ((((this->_12 * x) + (this->_22 * y)) + (this->_32 * z)) + this->_42);		HX_STACK_VAR(vy,"vy");
		HX_STACK_LINE(212)
		Float vz = ((((this->_13 * x) + (this->_23 * y)) + (this->_33 * z)) + this->_43);		HX_STACK_VAR(vz,"vz");
		HX_STACK_LINE(213)
		Float vw = ((((this->_14 * x) + (this->_24 * y)) + (this->_34 * z)) + this->_44);		HX_STACK_VAR(vw,"vw");
		HX_STACK_LINE(214)
		this->_41 = vx;
		HX_STACK_LINE(215)
		this->_42 = vy;
		HX_STACK_LINE(216)
		this->_43 = vz;
		HX_STACK_LINE(217)
		this->_44 = vw;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,prependTranslate,(void))

Void Matrix_obj::prependRotate( Float x,Float y,Float z){
{
		HX_STACK_FRAME("h3d.Matrix","prependRotate",0xccf64091,"h3d.Matrix.prependRotate","h3d/Matrix.hx",220,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(221)
		::h3d::Matrix tmp = ::h3d::Matrix_obj::tmp;		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(222)
		tmp->initRotate(x,y,z);
		HX_STACK_LINE(223)
		this->multiply(tmp,hx::ObjectPtr<OBJ_>(this));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,prependRotate,(void))

Void Matrix_obj::prependRotateAxis( ::h3d::Vector axis,Float angle){
{
		HX_STACK_FRAME("h3d.Matrix","prependRotateAxis",0xcd82a5d2,"h3d.Matrix.prependRotateAxis","h3d/Matrix.hx",226,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(axis,"axis")
		HX_STACK_ARG(angle,"angle")
		HX_STACK_LINE(227)
		::h3d::Matrix tmp = ::h3d::Matrix_obj::tmp;		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(228)
		tmp->initRotateAxis(axis,angle);
		HX_STACK_LINE(229)
		this->multiply(tmp,hx::ObjectPtr<OBJ_>(this));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,prependRotateAxis,(void))

Void Matrix_obj::prependScale( hx::Null< Float >  __o_sx,hx::Null< Float >  __o_sy,hx::Null< Float >  __o_sz){
Float sx = __o_sx.Default(1.);
Float sy = __o_sy.Default(1.);
Float sz = __o_sz.Default(1.);
	HX_STACK_FRAME("h3d.Matrix","prependScale",0xad9f8d14,"h3d.Matrix.prependScale","h3d/Matrix.hx",232,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(sx,"sx")
	HX_STACK_ARG(sy,"sy")
	HX_STACK_ARG(sz,"sz")
{
		HX_STACK_LINE(233)
		::h3d::Matrix tmp = ::h3d::Matrix_obj::tmp;		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(234)
		tmp->initScale(sx,sy,sz);
		HX_STACK_LINE(235)
		this->multiply(tmp,hx::ObjectPtr<OBJ_>(this));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,prependScale,(void))

Void Matrix_obj::multiply3x4( ::h3d::Matrix a,::h3d::Matrix b){
{
		HX_STACK_FRAME("h3d.Matrix","multiply3x4",0xa7c5a693,"h3d.Matrix.multiply3x4","h3d/Matrix.hx",238,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(239)
		Float m11 = a->_11;		HX_STACK_VAR(m11,"m11");
		HX_STACK_LINE(239)
		Float m12 = a->_12;		HX_STACK_VAR(m12,"m12");
		HX_STACK_LINE(239)
		Float m13 = a->_13;		HX_STACK_VAR(m13,"m13");
		HX_STACK_LINE(240)
		Float m21 = a->_21;		HX_STACK_VAR(m21,"m21");
		HX_STACK_LINE(240)
		Float m22 = a->_22;		HX_STACK_VAR(m22,"m22");
		HX_STACK_LINE(240)
		Float m23 = a->_23;		HX_STACK_VAR(m23,"m23");
		HX_STACK_LINE(241)
		Float a31 = a->_31;		HX_STACK_VAR(a31,"a31");
		HX_STACK_LINE(241)
		Float a32 = a->_32;		HX_STACK_VAR(a32,"a32");
		HX_STACK_LINE(241)
		Float a33 = a->_33;		HX_STACK_VAR(a33,"a33");
		HX_STACK_LINE(242)
		Float a41 = a->_41;		HX_STACK_VAR(a41,"a41");
		HX_STACK_LINE(242)
		Float a42 = a->_42;		HX_STACK_VAR(a42,"a42");
		HX_STACK_LINE(242)
		Float a43 = a->_43;		HX_STACK_VAR(a43,"a43");
		HX_STACK_LINE(243)
		Float b11 = b->_11;		HX_STACK_VAR(b11,"b11");
		HX_STACK_LINE(243)
		Float b12 = b->_12;		HX_STACK_VAR(b12,"b12");
		HX_STACK_LINE(243)
		Float b13 = b->_13;		HX_STACK_VAR(b13,"b13");
		HX_STACK_LINE(244)
		Float b21 = b->_21;		HX_STACK_VAR(b21,"b21");
		HX_STACK_LINE(244)
		Float b22 = b->_22;		HX_STACK_VAR(b22,"b22");
		HX_STACK_LINE(244)
		Float b23 = b->_23;		HX_STACK_VAR(b23,"b23");
		HX_STACK_LINE(245)
		Float b31 = b->_31;		HX_STACK_VAR(b31,"b31");
		HX_STACK_LINE(245)
		Float b32 = b->_32;		HX_STACK_VAR(b32,"b32");
		HX_STACK_LINE(245)
		Float b33 = b->_33;		HX_STACK_VAR(b33,"b33");
		HX_STACK_LINE(246)
		Float b41 = b->_41;		HX_STACK_VAR(b41,"b41");
		HX_STACK_LINE(246)
		Float b42 = b->_42;		HX_STACK_VAR(b42,"b42");
		HX_STACK_LINE(246)
		Float b43 = b->_43;		HX_STACK_VAR(b43,"b43");
		HX_STACK_LINE(248)
		this->_11 = (((m11 * b11) + (m12 * b21)) + (m13 * b31));
		HX_STACK_LINE(249)
		this->_12 = (((m11 * b12) + (m12 * b22)) + (m13 * b32));
		HX_STACK_LINE(250)
		this->_13 = (((m11 * b13) + (m12 * b23)) + (m13 * b33));
		HX_STACK_LINE(251)
		this->_14 = (int)0;
		HX_STACK_LINE(253)
		this->_21 = (((m21 * b11) + (m22 * b21)) + (m23 * b31));
		HX_STACK_LINE(254)
		this->_22 = (((m21 * b12) + (m22 * b22)) + (m23 * b32));
		HX_STACK_LINE(255)
		this->_23 = (((m21 * b13) + (m22 * b23)) + (m23 * b33));
		HX_STACK_LINE(256)
		this->_24 = (int)0;
		HX_STACK_LINE(258)
		this->_31 = (((a31 * b11) + (a32 * b21)) + (a33 * b31));
		HX_STACK_LINE(259)
		this->_32 = (((a31 * b12) + (a32 * b22)) + (a33 * b32));
		HX_STACK_LINE(260)
		this->_33 = (((a31 * b13) + (a32 * b23)) + (a33 * b33));
		HX_STACK_LINE(261)
		this->_34 = (int)0;
		HX_STACK_LINE(263)
		this->_41 = ((((a41 * b11) + (a42 * b21)) + (a43 * b31)) + b41);
		HX_STACK_LINE(264)
		this->_42 = ((((a41 * b12) + (a42 * b22)) + (a43 * b32)) + b42);
		HX_STACK_LINE(265)
		this->_43 = ((((a41 * b13) + (a42 * b23)) + (a43 * b33)) + b43);
		HX_STACK_LINE(266)
		this->_44 = (int)1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,multiply3x4,(void))

Void Matrix_obj::multiply( ::h3d::Matrix a,::h3d::Matrix b){
{
		HX_STACK_FRAME("h3d.Matrix","multiply",0x9f017e9c,"h3d.Matrix.multiply","h3d/Matrix.hx",269,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(270)
		Float a11 = a->_11;		HX_STACK_VAR(a11,"a11");
		HX_STACK_LINE(270)
		Float a12 = a->_12;		HX_STACK_VAR(a12,"a12");
		HX_STACK_LINE(270)
		Float a13 = a->_13;		HX_STACK_VAR(a13,"a13");
		HX_STACK_LINE(270)
		Float a14 = a->_14;		HX_STACK_VAR(a14,"a14");
		HX_STACK_LINE(271)
		Float a21 = a->_21;		HX_STACK_VAR(a21,"a21");
		HX_STACK_LINE(271)
		Float a22 = a->_22;		HX_STACK_VAR(a22,"a22");
		HX_STACK_LINE(271)
		Float a23 = a->_23;		HX_STACK_VAR(a23,"a23");
		HX_STACK_LINE(271)
		Float a24 = a->_24;		HX_STACK_VAR(a24,"a24");
		HX_STACK_LINE(272)
		Float a31 = a->_31;		HX_STACK_VAR(a31,"a31");
		HX_STACK_LINE(272)
		Float a32 = a->_32;		HX_STACK_VAR(a32,"a32");
		HX_STACK_LINE(272)
		Float a33 = a->_33;		HX_STACK_VAR(a33,"a33");
		HX_STACK_LINE(272)
		Float a34 = a->_34;		HX_STACK_VAR(a34,"a34");
		HX_STACK_LINE(273)
		Float a41 = a->_41;		HX_STACK_VAR(a41,"a41");
		HX_STACK_LINE(273)
		Float a42 = a->_42;		HX_STACK_VAR(a42,"a42");
		HX_STACK_LINE(273)
		Float a43 = a->_43;		HX_STACK_VAR(a43,"a43");
		HX_STACK_LINE(273)
		Float a44 = a->_44;		HX_STACK_VAR(a44,"a44");
		HX_STACK_LINE(274)
		Float b11 = b->_11;		HX_STACK_VAR(b11,"b11");
		HX_STACK_LINE(274)
		Float b12 = b->_12;		HX_STACK_VAR(b12,"b12");
		HX_STACK_LINE(274)
		Float b13 = b->_13;		HX_STACK_VAR(b13,"b13");
		HX_STACK_LINE(274)
		Float b14 = b->_14;		HX_STACK_VAR(b14,"b14");
		HX_STACK_LINE(275)
		Float b21 = b->_21;		HX_STACK_VAR(b21,"b21");
		HX_STACK_LINE(275)
		Float b22 = b->_22;		HX_STACK_VAR(b22,"b22");
		HX_STACK_LINE(275)
		Float b23 = b->_23;		HX_STACK_VAR(b23,"b23");
		HX_STACK_LINE(275)
		Float b24 = b->_24;		HX_STACK_VAR(b24,"b24");
		HX_STACK_LINE(276)
		Float b31 = b->_31;		HX_STACK_VAR(b31,"b31");
		HX_STACK_LINE(276)
		Float b32 = b->_32;		HX_STACK_VAR(b32,"b32");
		HX_STACK_LINE(276)
		Float b33 = b->_33;		HX_STACK_VAR(b33,"b33");
		HX_STACK_LINE(276)
		Float b34 = b->_34;		HX_STACK_VAR(b34,"b34");
		HX_STACK_LINE(277)
		Float b41 = b->_41;		HX_STACK_VAR(b41,"b41");
		HX_STACK_LINE(277)
		Float b42 = b->_42;		HX_STACK_VAR(b42,"b42");
		HX_STACK_LINE(277)
		Float b43 = b->_43;		HX_STACK_VAR(b43,"b43");
		HX_STACK_LINE(277)
		Float b44 = b->_44;		HX_STACK_VAR(b44,"b44");
		HX_STACK_LINE(279)
		this->_11 = ((((a11 * b11) + (a12 * b21)) + (a13 * b31)) + (a14 * b41));
		HX_STACK_LINE(280)
		this->_12 = ((((a11 * b12) + (a12 * b22)) + (a13 * b32)) + (a14 * b42));
		HX_STACK_LINE(281)
		this->_13 = ((((a11 * b13) + (a12 * b23)) + (a13 * b33)) + (a14 * b43));
		HX_STACK_LINE(282)
		this->_14 = ((((a11 * b14) + (a12 * b24)) + (a13 * b34)) + (a14 * b44));
		HX_STACK_LINE(284)
		this->_21 = ((((a21 * b11) + (a22 * b21)) + (a23 * b31)) + (a24 * b41));
		HX_STACK_LINE(285)
		this->_22 = ((((a21 * b12) + (a22 * b22)) + (a23 * b32)) + (a24 * b42));
		HX_STACK_LINE(286)
		this->_23 = ((((a21 * b13) + (a22 * b23)) + (a23 * b33)) + (a24 * b43));
		HX_STACK_LINE(287)
		this->_24 = ((((a21 * b14) + (a22 * b24)) + (a23 * b34)) + (a24 * b44));
		HX_STACK_LINE(289)
		this->_31 = ((((a31 * b11) + (a32 * b21)) + (a33 * b31)) + (a34 * b41));
		HX_STACK_LINE(290)
		this->_32 = ((((a31 * b12) + (a32 * b22)) + (a33 * b32)) + (a34 * b42));
		HX_STACK_LINE(291)
		this->_33 = ((((a31 * b13) + (a32 * b23)) + (a33 * b33)) + (a34 * b43));
		HX_STACK_LINE(292)
		this->_34 = ((((a31 * b14) + (a32 * b24)) + (a33 * b34)) + (a34 * b44));
		HX_STACK_LINE(294)
		this->_41 = ((((a41 * b11) + (a42 * b21)) + (a43 * b31)) + (a44 * b41));
		HX_STACK_LINE(295)
		this->_42 = ((((a41 * b12) + (a42 * b22)) + (a43 * b32)) + (a44 * b42));
		HX_STACK_LINE(296)
		this->_43 = ((((a41 * b13) + (a42 * b23)) + (a43 * b33)) + (a44 * b43));
		HX_STACK_LINE(297)
		this->_44 = ((((a41 * b14) + (a42 * b24)) + (a43 * b34)) + (a44 * b44));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,multiply,(void))

Void Matrix_obj::invert( ){
{
		HX_STACK_FRAME("h3d.Matrix","invert",0x66d2f58e,"h3d.Matrix.invert","h3d/Matrix.hx",301,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_LINE(301)
		this->inverse(hx::ObjectPtr<OBJ_>(this));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,invert,(void))

Void Matrix_obj::inverse3x4( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Matrix","inverse3x4",0xd65ae877,"h3d.Matrix.inverse3x4","h3d/Matrix.hx",304,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(305)
		Float m11 = m->_11;		HX_STACK_VAR(m11,"m11");
		HX_STACK_LINE(305)
		Float m12 = m->_12;		HX_STACK_VAR(m12,"m12");
		HX_STACK_LINE(305)
		Float m13 = m->_13;		HX_STACK_VAR(m13,"m13");
		HX_STACK_LINE(306)
		Float m21 = m->_21;		HX_STACK_VAR(m21,"m21");
		HX_STACK_LINE(306)
		Float m22 = m->_22;		HX_STACK_VAR(m22,"m22");
		HX_STACK_LINE(306)
		Float m23 = m->_23;		HX_STACK_VAR(m23,"m23");
		HX_STACK_LINE(307)
		Float m31 = m->_31;		HX_STACK_VAR(m31,"m31");
		HX_STACK_LINE(307)
		Float m32 = m->_32;		HX_STACK_VAR(m32,"m32");
		HX_STACK_LINE(307)
		Float m33 = m->_33;		HX_STACK_VAR(m33,"m33");
		HX_STACK_LINE(308)
		Float m41 = m->_41;		HX_STACK_VAR(m41,"m41");
		HX_STACK_LINE(308)
		Float m42 = m->_42;		HX_STACK_VAR(m42,"m42");
		HX_STACK_LINE(308)
		Float m43 = m->_43;		HX_STACK_VAR(m43,"m43");
		HX_STACK_LINE(309)
		this->_11 = ((m22 * m33) - (m23 * m32));
		HX_STACK_LINE(310)
		this->_12 = ((m13 * m32) - (m12 * m33));
		HX_STACK_LINE(311)
		this->_13 = ((m12 * m23) - (m13 * m22));
		HX_STACK_LINE(312)
		this->_14 = (int)0;
		HX_STACK_LINE(313)
		this->_21 = ((m23 * m31) - (m21 * m33));
		HX_STACK_LINE(314)
		this->_22 = ((m11 * m33) - (m13 * m31));
		HX_STACK_LINE(315)
		this->_23 = ((m13 * m21) - (m11 * m23));
		HX_STACK_LINE(316)
		this->_24 = (int)0;
		HX_STACK_LINE(317)
		this->_31 = ((m21 * m32) - (m22 * m31));
		HX_STACK_LINE(318)
		this->_32 = ((m12 * m31) - (m11 * m32));
		HX_STACK_LINE(319)
		this->_33 = ((m11 * m22) - (m12 * m21));
		HX_STACK_LINE(320)
		this->_34 = (int)0;
		HX_STACK_LINE(321)
		this->_41 = (((((((-(m21) * m32) * m43) + ((m21 * m33) * m42)) + ((m31 * m22) * m43)) - ((m31 * m23) * m42)) - ((m41 * m22) * m33)) + ((m41 * m23) * m32));
		HX_STACK_LINE(322)
		this->_42 = (((((((m11 * m32) * m43) - ((m11 * m33) * m42)) - ((m31 * m12) * m43)) + ((m31 * m13) * m42)) + ((m41 * m12) * m33)) - ((m41 * m13) * m32));
		HX_STACK_LINE(323)
		this->_43 = (((((((-(m11) * m22) * m43) + ((m11 * m23) * m42)) + ((m21 * m12) * m43)) - ((m21 * m13) * m42)) - ((m41 * m12) * m23)) + ((m41 * m13) * m22));
		HX_STACK_LINE(324)
		this->_44 = (((((((m11 * m22) * m33) - ((m11 * m23) * m32)) - ((m21 * m12) * m33)) + ((m21 * m13) * m32)) + ((m31 * m12) * m23)) - ((m31 * m13) * m22));
		HX_STACK_LINE(325)
		this->_44 = (int)1;
		HX_STACK_LINE(326)
		Float det = (((m11 * this->_11) + (m12 * this->_21)) + (m13 * this->_31));		HX_STACK_VAR(det,"det");
		HX_STACK_LINE(327)
		if (((((  (((det < (int)0))) ? Float(-(det)) : Float(det) )) < 1e-10))){
			HX_STACK_LINE(328)
			this->zero();
			HX_STACK_LINE(329)
			return null();
		}
		HX_STACK_LINE(331)
		Float invDet = (Float(1.0) / Float(det));		HX_STACK_VAR(invDet,"invDet");
		HX_STACK_LINE(332)
		hx::MultEq(this->_11,invDet);
		HX_STACK_LINE(332)
		hx::MultEq(this->_12,invDet);
		HX_STACK_LINE(332)
		hx::MultEq(this->_13,invDet);
		HX_STACK_LINE(333)
		hx::MultEq(this->_21,invDet);
		HX_STACK_LINE(333)
		hx::MultEq(this->_22,invDet);
		HX_STACK_LINE(333)
		hx::MultEq(this->_23,invDet);
		HX_STACK_LINE(334)
		hx::MultEq(this->_31,invDet);
		HX_STACK_LINE(334)
		hx::MultEq(this->_32,invDet);
		HX_STACK_LINE(334)
		hx::MultEq(this->_33,invDet);
		HX_STACK_LINE(335)
		hx::MultEq(this->_41,invDet);
		HX_STACK_LINE(335)
		hx::MultEq(this->_42,invDet);
		HX_STACK_LINE(335)
		hx::MultEq(this->_43,invDet);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,inverse3x4,(void))

Void Matrix_obj::inverse( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Matrix","inverse",0x91c3e638,"h3d.Matrix.inverse","h3d/Matrix.hx",338,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(339)
		Float m11 = m->_11;		HX_STACK_VAR(m11,"m11");
		HX_STACK_LINE(339)
		Float m12 = m->_12;		HX_STACK_VAR(m12,"m12");
		HX_STACK_LINE(339)
		Float m13 = m->_13;		HX_STACK_VAR(m13,"m13");
		HX_STACK_LINE(339)
		Float m14 = m->_14;		HX_STACK_VAR(m14,"m14");
		HX_STACK_LINE(340)
		Float m21 = m->_21;		HX_STACK_VAR(m21,"m21");
		HX_STACK_LINE(340)
		Float m22 = m->_22;		HX_STACK_VAR(m22,"m22");
		HX_STACK_LINE(340)
		Float m23 = m->_23;		HX_STACK_VAR(m23,"m23");
		HX_STACK_LINE(340)
		Float m24 = m->_24;		HX_STACK_VAR(m24,"m24");
		HX_STACK_LINE(341)
		Float m31 = m->_31;		HX_STACK_VAR(m31,"m31");
		HX_STACK_LINE(341)
		Float m32 = m->_32;		HX_STACK_VAR(m32,"m32");
		HX_STACK_LINE(341)
		Float m33 = m->_33;		HX_STACK_VAR(m33,"m33");
		HX_STACK_LINE(341)
		Float m34 = m->_34;		HX_STACK_VAR(m34,"m34");
		HX_STACK_LINE(342)
		Float m41 = m->_41;		HX_STACK_VAR(m41,"m41");
		HX_STACK_LINE(342)
		Float m42 = m->_42;		HX_STACK_VAR(m42,"m42");
		HX_STACK_LINE(342)
		Float m43 = m->_43;		HX_STACK_VAR(m43,"m43");
		HX_STACK_LINE(342)
		Float m44 = m->_44;		HX_STACK_VAR(m44,"m44");
		HX_STACK_LINE(344)
		this->_11 = (((((((m22 * m33) * m44) - ((m22 * m34) * m43)) - ((m32 * m23) * m44)) + ((m32 * m24) * m43)) + ((m42 * m23) * m34)) - ((m42 * m24) * m33));
		HX_STACK_LINE(345)
		this->_12 = (((((((-(m12) * m33) * m44) + ((m12 * m34) * m43)) + ((m32 * m13) * m44)) - ((m32 * m14) * m43)) - ((m42 * m13) * m34)) + ((m42 * m14) * m33));
		HX_STACK_LINE(346)
		this->_13 = (((((((m12 * m23) * m44) - ((m12 * m24) * m43)) - ((m22 * m13) * m44)) + ((m22 * m14) * m43)) + ((m42 * m13) * m24)) - ((m42 * m14) * m23));
		HX_STACK_LINE(347)
		this->_14 = (((((((-(m12) * m23) * m34) + ((m12 * m24) * m33)) + ((m22 * m13) * m34)) - ((m22 * m14) * m33)) - ((m32 * m13) * m24)) + ((m32 * m14) * m23));
		HX_STACK_LINE(348)
		this->_21 = (((((((-(m21) * m33) * m44) + ((m21 * m34) * m43)) + ((m31 * m23) * m44)) - ((m31 * m24) * m43)) - ((m41 * m23) * m34)) + ((m41 * m24) * m33));
		HX_STACK_LINE(349)
		this->_22 = (((((((m11 * m33) * m44) - ((m11 * m34) * m43)) - ((m31 * m13) * m44)) + ((m31 * m14) * m43)) + ((m41 * m13) * m34)) - ((m41 * m14) * m33));
		HX_STACK_LINE(350)
		this->_23 = (((((((-(m11) * m23) * m44) + ((m11 * m24) * m43)) + ((m21 * m13) * m44)) - ((m21 * m14) * m43)) - ((m41 * m13) * m24)) + ((m41 * m14) * m23));
		HX_STACK_LINE(351)
		this->_24 = (((((((m11 * m23) * m34) - ((m11 * m24) * m33)) - ((m21 * m13) * m34)) + ((m21 * m14) * m33)) + ((m31 * m13) * m24)) - ((m31 * m14) * m23));
		HX_STACK_LINE(352)
		this->_31 = (((((((m21 * m32) * m44) - ((m21 * m34) * m42)) - ((m31 * m22) * m44)) + ((m31 * m24) * m42)) + ((m41 * m22) * m34)) - ((m41 * m24) * m32));
		HX_STACK_LINE(353)
		this->_32 = (((((((-(m11) * m32) * m44) + ((m11 * m34) * m42)) + ((m31 * m12) * m44)) - ((m31 * m14) * m42)) - ((m41 * m12) * m34)) + ((m41 * m14) * m32));
		HX_STACK_LINE(354)
		this->_33 = (((((((m11 * m22) * m44) - ((m11 * m24) * m42)) - ((m21 * m12) * m44)) + ((m21 * m14) * m42)) + ((m41 * m12) * m24)) - ((m41 * m14) * m22));
		HX_STACK_LINE(355)
		this->_34 = (((((((-(m11) * m22) * m34) + ((m11 * m24) * m32)) + ((m21 * m12) * m34)) - ((m21 * m14) * m32)) - ((m31 * m12) * m24)) + ((m31 * m14) * m22));
		HX_STACK_LINE(356)
		this->_41 = (((((((-(m21) * m32) * m43) + ((m21 * m33) * m42)) + ((m31 * m22) * m43)) - ((m31 * m23) * m42)) - ((m41 * m22) * m33)) + ((m41 * m23) * m32));
		HX_STACK_LINE(357)
		this->_42 = (((((((m11 * m32) * m43) - ((m11 * m33) * m42)) - ((m31 * m12) * m43)) + ((m31 * m13) * m42)) + ((m41 * m12) * m33)) - ((m41 * m13) * m32));
		HX_STACK_LINE(358)
		this->_43 = (((((((-(m11) * m22) * m43) + ((m11 * m23) * m42)) + ((m21 * m12) * m43)) - ((m21 * m13) * m42)) - ((m41 * m12) * m23)) + ((m41 * m13) * m22));
		HX_STACK_LINE(359)
		this->_44 = (((((((m11 * m22) * m33) - ((m11 * m23) * m32)) - ((m21 * m12) * m33)) + ((m21 * m13) * m32)) + ((m31 * m12) * m23)) - ((m31 * m13) * m22));
		HX_STACK_LINE(361)
		Float det = ((((m11 * this->_11) + (m12 * this->_21)) + (m13 * this->_31)) + (m14 * this->_41));		HX_STACK_VAR(det,"det");
		HX_STACK_LINE(362)
		if (((((  (((det < (int)0))) ? Float(-(det)) : Float(det) )) < 1e-10))){
			HX_STACK_LINE(363)
			this->zero();
			HX_STACK_LINE(364)
			return null();
		}
		HX_STACK_LINE(367)
		det = (Float(1.0) / Float(det));
		HX_STACK_LINE(368)
		hx::MultEq(this->_11,det);
		HX_STACK_LINE(369)
		hx::MultEq(this->_12,det);
		HX_STACK_LINE(370)
		hx::MultEq(this->_13,det);
		HX_STACK_LINE(371)
		hx::MultEq(this->_14,det);
		HX_STACK_LINE(372)
		hx::MultEq(this->_21,det);
		HX_STACK_LINE(373)
		hx::MultEq(this->_22,det);
		HX_STACK_LINE(374)
		hx::MultEq(this->_23,det);
		HX_STACK_LINE(375)
		hx::MultEq(this->_24,det);
		HX_STACK_LINE(376)
		hx::MultEq(this->_31,det);
		HX_STACK_LINE(377)
		hx::MultEq(this->_32,det);
		HX_STACK_LINE(378)
		hx::MultEq(this->_33,det);
		HX_STACK_LINE(379)
		hx::MultEq(this->_34,det);
		HX_STACK_LINE(380)
		hx::MultEq(this->_41,det);
		HX_STACK_LINE(381)
		hx::MultEq(this->_42,det);
		HX_STACK_LINE(382)
		hx::MultEq(this->_43,det);
		HX_STACK_LINE(383)
		hx::MultEq(this->_44,det);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,inverse,(void))

Void Matrix_obj::transpose( ){
{
		HX_STACK_FRAME("h3d.Matrix","transpose",0x2dc39d01,"h3d.Matrix.transpose","h3d/Matrix.hx",386,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_LINE(387)
		Float tmp;		HX_STACK_VAR(tmp,"tmp");
		HX_STACK_LINE(388)
		tmp = this->_12;
		HX_STACK_LINE(388)
		this->_12 = this->_21;
		HX_STACK_LINE(388)
		this->_21 = tmp;
		HX_STACK_LINE(389)
		tmp = this->_13;
		HX_STACK_LINE(389)
		this->_13 = this->_31;
		HX_STACK_LINE(389)
		this->_31 = tmp;
		HX_STACK_LINE(390)
		tmp = this->_14;
		HX_STACK_LINE(390)
		this->_14 = this->_41;
		HX_STACK_LINE(390)
		this->_41 = tmp;
		HX_STACK_LINE(391)
		tmp = this->_23;
		HX_STACK_LINE(391)
		this->_23 = this->_32;
		HX_STACK_LINE(391)
		this->_32 = tmp;
		HX_STACK_LINE(392)
		tmp = this->_24;
		HX_STACK_LINE(392)
		this->_24 = this->_42;
		HX_STACK_LINE(392)
		this->_42 = tmp;
		HX_STACK_LINE(393)
		tmp = this->_34;
		HX_STACK_LINE(393)
		this->_34 = this->_43;
		HX_STACK_LINE(393)
		this->_43 = tmp;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,transpose,(void))

::h3d::Matrix Matrix_obj::clone( ){
	HX_STACK_FRAME("h3d.Matrix","clone",0x7aa47be5,"h3d.Matrix.clone","h3d/Matrix.hx",396,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_LINE(397)
	::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(398)
	m->_11 = this->_11;
	HX_STACK_LINE(398)
	m->_12 = this->_12;
	HX_STACK_LINE(398)
	m->_13 = this->_13;
	HX_STACK_LINE(398)
	m->_14 = this->_14;
	HX_STACK_LINE(399)
	m->_21 = this->_21;
	HX_STACK_LINE(399)
	m->_22 = this->_22;
	HX_STACK_LINE(399)
	m->_23 = this->_23;
	HX_STACK_LINE(399)
	m->_24 = this->_24;
	HX_STACK_LINE(400)
	m->_31 = this->_31;
	HX_STACK_LINE(400)
	m->_32 = this->_32;
	HX_STACK_LINE(400)
	m->_33 = this->_33;
	HX_STACK_LINE(400)
	m->_34 = this->_34;
	HX_STACK_LINE(401)
	m->_41 = this->_41;
	HX_STACK_LINE(401)
	m->_42 = this->_42;
	HX_STACK_LINE(401)
	m->_43 = this->_43;
	HX_STACK_LINE(401)
	m->_44 = this->_44;
	HX_STACK_LINE(402)
	return m;
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,clone,return )

Void Matrix_obj::loadFrom( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Matrix","loadFrom",0xb8d71328,"h3d.Matrix.loadFrom","h3d/Matrix.hx",405,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(406)
		this->_11 = m->_11;
		HX_STACK_LINE(406)
		this->_12 = m->_12;
		HX_STACK_LINE(406)
		this->_13 = m->_13;
		HX_STACK_LINE(406)
		this->_14 = m->_14;
		HX_STACK_LINE(407)
		this->_21 = m->_21;
		HX_STACK_LINE(407)
		this->_22 = m->_22;
		HX_STACK_LINE(407)
		this->_23 = m->_23;
		HX_STACK_LINE(407)
		this->_24 = m->_24;
		HX_STACK_LINE(408)
		this->_31 = m->_31;
		HX_STACK_LINE(408)
		this->_32 = m->_32;
		HX_STACK_LINE(408)
		this->_33 = m->_33;
		HX_STACK_LINE(408)
		this->_34 = m->_34;
		HX_STACK_LINE(409)
		this->_41 = m->_41;
		HX_STACK_LINE(409)
		this->_42 = m->_42;
		HX_STACK_LINE(409)
		this->_43 = m->_43;
		HX_STACK_LINE(409)
		this->_44 = m->_44;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,loadFrom,(void))

Void Matrix_obj::load( Array< Float > a){
{
		HX_STACK_FRAME("h3d.Matrix","load",0xd8969a9e,"h3d.Matrix.load","h3d/Matrix.hx",412,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(413)
		this->_11 = a->__get((int)0);
		HX_STACK_LINE(413)
		this->_12 = a->__get((int)1);
		HX_STACK_LINE(413)
		this->_13 = a->__get((int)2);
		HX_STACK_LINE(413)
		this->_14 = a->__get((int)3);
		HX_STACK_LINE(414)
		this->_21 = a->__get((int)4);
		HX_STACK_LINE(414)
		this->_22 = a->__get((int)5);
		HX_STACK_LINE(414)
		this->_23 = a->__get((int)6);
		HX_STACK_LINE(414)
		this->_24 = a->__get((int)7);
		HX_STACK_LINE(415)
		this->_31 = a->__get((int)8);
		HX_STACK_LINE(415)
		this->_32 = a->__get((int)9);
		HX_STACK_LINE(415)
		this->_33 = a->__get((int)10);
		HX_STACK_LINE(415)
		this->_34 = a->__get((int)11);
		HX_STACK_LINE(416)
		this->_41 = a->__get((int)12);
		HX_STACK_LINE(416)
		this->_42 = a->__get((int)13);
		HX_STACK_LINE(416)
		this->_43 = a->__get((int)14);
		HX_STACK_LINE(416)
		this->_44 = a->__get((int)15);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,load,(void))

Array< Float > Matrix_obj::getFloats( ){
	HX_STACK_FRAME("h3d.Matrix","getFloats",0x9f40f915,"h3d.Matrix.getFloats","h3d/Matrix.hx",420,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_LINE(420)
	return Array_obj< Float >::__new().Add(this->_11).Add(this->_12).Add(this->_13).Add(this->_14).Add(this->_21).Add(this->_22).Add(this->_23).Add(this->_24).Add(this->_31).Add(this->_32).Add(this->_33).Add(this->_34).Add(this->_41).Add(this->_42).Add(this->_43).Add(this->_44);
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,getFloats,return )

::String Matrix_obj::toString( ){
	HX_STACK_FRAME("h3d.Matrix","toString",0x3ce36d24,"h3d.Matrix.toString","h3d/Matrix.hx",423,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_LINE(425)
	Float _g = ::hxd::Math_obj::fmt(this->_11);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(424)
	::String _g1 = (HX_CSTRING("MAT=[\n  [ ") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(424)
	::String _g2 = (_g1 + HX_CSTRING(", "));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(425)
	Float _g3 = ::hxd::Math_obj::fmt(this->_12);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(424)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(424)
	::String _g5 = (_g4 + HX_CSTRING(", "));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(425)
	Float _g6 = ::hxd::Math_obj::fmt(this->_13);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(424)
	::String _g7 = (_g5 + _g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(424)
	::String _g8 = (_g7 + HX_CSTRING(", "));		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(425)
	Float _g9 = ::hxd::Math_obj::fmt(this->_14);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(424)
	::String _g10 = (_g8 + _g9);		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(424)
	::String _g11 = (_g10 + HX_CSTRING(" ]\n"));		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(424)
	::String _g12 = (_g11 + HX_CSTRING("  [ "));		HX_STACK_VAR(_g12,"_g12");
	HX_STACK_LINE(426)
	Float _g13 = ::hxd::Math_obj::fmt(this->_21);		HX_STACK_VAR(_g13,"_g13");
	HX_STACK_LINE(424)
	::String _g14 = (_g12 + _g13);		HX_STACK_VAR(_g14,"_g14");
	HX_STACK_LINE(424)
	::String _g15 = (_g14 + HX_CSTRING(", "));		HX_STACK_VAR(_g15,"_g15");
	HX_STACK_LINE(426)
	Float _g16 = ::hxd::Math_obj::fmt(this->_22);		HX_STACK_VAR(_g16,"_g16");
	HX_STACK_LINE(424)
	::String _g17 = (_g15 + _g16);		HX_STACK_VAR(_g17,"_g17");
	HX_STACK_LINE(424)
	::String _g18 = (_g17 + HX_CSTRING(", "));		HX_STACK_VAR(_g18,"_g18");
	HX_STACK_LINE(426)
	Float _g19 = ::hxd::Math_obj::fmt(this->_23);		HX_STACK_VAR(_g19,"_g19");
	HX_STACK_LINE(424)
	::String _g20 = (_g18 + _g19);		HX_STACK_VAR(_g20,"_g20");
	HX_STACK_LINE(424)
	::String _g21 = (_g20 + HX_CSTRING(", "));		HX_STACK_VAR(_g21,"_g21");
	HX_STACK_LINE(426)
	Float _g22 = ::hxd::Math_obj::fmt(this->_24);		HX_STACK_VAR(_g22,"_g22");
	HX_STACK_LINE(424)
	::String _g23 = (_g21 + _g22);		HX_STACK_VAR(_g23,"_g23");
	HX_STACK_LINE(424)
	::String _g24 = (_g23 + HX_CSTRING(" ]\n"));		HX_STACK_VAR(_g24,"_g24");
	HX_STACK_LINE(424)
	::String _g25 = (_g24 + HX_CSTRING("  [ "));		HX_STACK_VAR(_g25,"_g25");
	HX_STACK_LINE(427)
	Float _g26 = ::hxd::Math_obj::fmt(this->_31);		HX_STACK_VAR(_g26,"_g26");
	HX_STACK_LINE(424)
	::String _g27 = (_g25 + _g26);		HX_STACK_VAR(_g27,"_g27");
	HX_STACK_LINE(424)
	::String _g28 = (_g27 + HX_CSTRING(", "));		HX_STACK_VAR(_g28,"_g28");
	HX_STACK_LINE(427)
	Float _g29 = ::hxd::Math_obj::fmt(this->_32);		HX_STACK_VAR(_g29,"_g29");
	HX_STACK_LINE(424)
	::String _g30 = (_g28 + _g29);		HX_STACK_VAR(_g30,"_g30");
	HX_STACK_LINE(424)
	::String _g31 = (_g30 + HX_CSTRING(", "));		HX_STACK_VAR(_g31,"_g31");
	HX_STACK_LINE(427)
	Float _g32 = ::hxd::Math_obj::fmt(this->_33);		HX_STACK_VAR(_g32,"_g32");
	HX_STACK_LINE(424)
	::String _g33 = (_g31 + _g32);		HX_STACK_VAR(_g33,"_g33");
	HX_STACK_LINE(424)
	::String _g34 = (_g33 + HX_CSTRING(", "));		HX_STACK_VAR(_g34,"_g34");
	HX_STACK_LINE(427)
	Float _g35 = ::hxd::Math_obj::fmt(this->_34);		HX_STACK_VAR(_g35,"_g35");
	HX_STACK_LINE(424)
	::String _g36 = (_g34 + _g35);		HX_STACK_VAR(_g36,"_g36");
	HX_STACK_LINE(424)
	::String _g37 = (_g36 + HX_CSTRING(" ]\n"));		HX_STACK_VAR(_g37,"_g37");
	HX_STACK_LINE(424)
	::String _g38 = (_g37 + HX_CSTRING("  [ "));		HX_STACK_VAR(_g38,"_g38");
	HX_STACK_LINE(428)
	Float _g39 = ::hxd::Math_obj::fmt(this->_41);		HX_STACK_VAR(_g39,"_g39");
	HX_STACK_LINE(424)
	::String _g40 = (_g38 + _g39);		HX_STACK_VAR(_g40,"_g40");
	HX_STACK_LINE(424)
	::String _g41 = (_g40 + HX_CSTRING(", "));		HX_STACK_VAR(_g41,"_g41");
	HX_STACK_LINE(428)
	Float _g42 = ::hxd::Math_obj::fmt(this->_42);		HX_STACK_VAR(_g42,"_g42");
	HX_STACK_LINE(424)
	::String _g43 = (_g41 + _g42);		HX_STACK_VAR(_g43,"_g43");
	HX_STACK_LINE(424)
	::String _g44 = (_g43 + HX_CSTRING(", "));		HX_STACK_VAR(_g44,"_g44");
	HX_STACK_LINE(428)
	Float _g45 = ::hxd::Math_obj::fmt(this->_43);		HX_STACK_VAR(_g45,"_g45");
	HX_STACK_LINE(424)
	::String _g46 = (_g44 + _g45);		HX_STACK_VAR(_g46,"_g46");
	HX_STACK_LINE(424)
	::String _g47 = (_g46 + HX_CSTRING(", "));		HX_STACK_VAR(_g47,"_g47");
	HX_STACK_LINE(428)
	Float _g48 = ::hxd::Math_obj::fmt(this->_44);		HX_STACK_VAR(_g48,"_g48");
	HX_STACK_LINE(424)
	::String _g49 = (_g47 + _g48);		HX_STACK_VAR(_g49,"_g49");
	HX_STACK_LINE(424)
	::String _g50 = (_g49 + HX_CSTRING(" ]\n"));		HX_STACK_VAR(_g50,"_g50");
	HX_STACK_LINE(424)
	return (_g50 + HX_CSTRING("]"));
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,toString,return )

Void Matrix_obj::colorHue( Float hue){
{
		HX_STACK_FRAME("h3d.Matrix","colorHue",0x8e5bf38d,"h3d.Matrix.colorHue","h3d/Matrix.hx",438,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(hue,"hue")
		HX_STACK_LINE(439)
		if (((hue == 0.))){
			HX_STACK_LINE(440)
			return null();
		}
		HX_STACK_LINE(441)
		Float cv = ::Math_obj::cos(hue);		HX_STACK_VAR(cv,"cv");
		HX_STACK_LINE(442)
		Float sv = ::Math_obj::sin(hue);		HX_STACK_VAR(sv,"sv");
		HX_STACK_LINE(443)
		::h3d::Matrix_obj::tmp->_11 = ((0.212671 + (cv * 0.787329)) - (sv * 0.212671));
		HX_STACK_LINE(444)
		::h3d::Matrix_obj::tmp->_12 = ((0.212671 - (cv * 0.212671)) + (sv * 0.143));
		HX_STACK_LINE(445)
		::h3d::Matrix_obj::tmp->_13 = ((0.212671 - (cv * 0.212671)) - (sv * 0.787329));
		HX_STACK_LINE(446)
		::h3d::Matrix_obj::tmp->_21 = ((0.71516 - (cv * 0.71516)) - (sv * 0.71516));
		HX_STACK_LINE(447)
		::h3d::Matrix_obj::tmp->_22 = ((0.71516 + (cv * 0.28484)) + (sv * 0.140));
		HX_STACK_LINE(448)
		::h3d::Matrix_obj::tmp->_23 = ((0.71516 - (cv * 0.71516)) + (sv * 0.71516));
		HX_STACK_LINE(449)
		::h3d::Matrix_obj::tmp->_31 = ((0.072169 - (cv * 0.072169)) - (sv * 0.072169));
		HX_STACK_LINE(450)
		::h3d::Matrix_obj::tmp->_32 = ((0.072169 - (cv * 0.072169)) - (sv * 0.283));
		HX_STACK_LINE(451)
		::h3d::Matrix_obj::tmp->_33 = ((0.072169 + (cv * 0.927831)) + (sv * 0.072169));
		HX_STACK_LINE(452)
		::h3d::Matrix_obj::tmp->_34 = (int)0;
		HX_STACK_LINE(453)
		::h3d::Matrix_obj::tmp->_41 = (int)0;
		HX_STACK_LINE(454)
		::h3d::Matrix_obj::tmp->_42 = (int)0;
		HX_STACK_LINE(455)
		::h3d::Matrix_obj::tmp->_43 = (int)0;
		HX_STACK_LINE(456)
		this->multiply3x4(hx::ObjectPtr<OBJ_>(this),::h3d::Matrix_obj::tmp);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,colorHue,(void))

Void Matrix_obj::colorSaturation( Float sat){
{
		HX_STACK_FRAME("h3d.Matrix","colorSaturation",0x0546659d,"h3d.Matrix.colorSaturation","h3d/Matrix.hx",459,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sat,"sat")
		HX_STACK_LINE(460)
		Float is = ((int)1 - sat);		HX_STACK_VAR(is,"is");
		HX_STACK_LINE(461)
		Float r = (is * 0.212671);		HX_STACK_VAR(r,"r");
		HX_STACK_LINE(462)
		Float g = (is * 0.71516);		HX_STACK_VAR(g,"g");
		HX_STACK_LINE(463)
		Float b = (is * 0.072169);		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(464)
		::h3d::Matrix_obj::tmp->_11 = (r + sat);
		HX_STACK_LINE(465)
		::h3d::Matrix_obj::tmp->_12 = r;
		HX_STACK_LINE(466)
		::h3d::Matrix_obj::tmp->_13 = r;
		HX_STACK_LINE(467)
		::h3d::Matrix_obj::tmp->_21 = g;
		HX_STACK_LINE(468)
		::h3d::Matrix_obj::tmp->_22 = (g + sat);
		HX_STACK_LINE(469)
		::h3d::Matrix_obj::tmp->_23 = g;
		HX_STACK_LINE(470)
		::h3d::Matrix_obj::tmp->_31 = b;
		HX_STACK_LINE(471)
		::h3d::Matrix_obj::tmp->_32 = b;
		HX_STACK_LINE(472)
		::h3d::Matrix_obj::tmp->_33 = (b + sat);
		HX_STACK_LINE(473)
		::h3d::Matrix_obj::tmp->_41 = (int)0;
		HX_STACK_LINE(474)
		::h3d::Matrix_obj::tmp->_42 = (int)0;
		HX_STACK_LINE(475)
		::h3d::Matrix_obj::tmp->_43 = (int)0;
		HX_STACK_LINE(476)
		this->multiply3x4(hx::ObjectPtr<OBJ_>(this),::h3d::Matrix_obj::tmp);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,colorSaturation,(void))

Void Matrix_obj::colorContrast( Float contrast){
{
		HX_STACK_FRAME("h3d.Matrix","colorContrast",0x389de60d,"h3d.Matrix.colorContrast","h3d/Matrix.hx",479,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(contrast,"contrast")
		HX_STACK_LINE(480)
		Float v = (contrast + (int)1);		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(481)
		::h3d::Matrix_obj::tmp->_11 = v;
		HX_STACK_LINE(482)
		::h3d::Matrix_obj::tmp->_12 = (int)0;
		HX_STACK_LINE(483)
		::h3d::Matrix_obj::tmp->_13 = (int)0;
		HX_STACK_LINE(484)
		::h3d::Matrix_obj::tmp->_21 = (int)0;
		HX_STACK_LINE(485)
		::h3d::Matrix_obj::tmp->_22 = v;
		HX_STACK_LINE(486)
		::h3d::Matrix_obj::tmp->_23 = (int)0;
		HX_STACK_LINE(487)
		::h3d::Matrix_obj::tmp->_31 = (int)0;
		HX_STACK_LINE(488)
		::h3d::Matrix_obj::tmp->_32 = (int)0;
		HX_STACK_LINE(489)
		::h3d::Matrix_obj::tmp->_33 = v;
		HX_STACK_LINE(490)
		::h3d::Matrix_obj::tmp->_41 = (-(contrast) * 0.5);
		HX_STACK_LINE(491)
		::h3d::Matrix_obj::tmp->_42 = (-(contrast) * 0.5);
		HX_STACK_LINE(492)
		::h3d::Matrix_obj::tmp->_43 = (-(contrast) * 0.5);
		HX_STACK_LINE(493)
		this->multiply3x4(hx::ObjectPtr<OBJ_>(this),::h3d::Matrix_obj::tmp);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,colorContrast,(void))

Void Matrix_obj::colorBrightness( Float brightness){
{
		HX_STACK_FRAME("h3d.Matrix","colorBrightness",0x74161f9c,"h3d.Matrix.colorBrightness","h3d/Matrix.hx",496,0x638e4567)
		HX_STACK_THIS(this)
		HX_STACK_ARG(brightness,"brightness")
		HX_STACK_LINE(497)
		hx::AddEq(this->_41,brightness);
		HX_STACK_LINE(498)
		hx::AddEq(this->_42,brightness);
		HX_STACK_LINE(499)
		hx::AddEq(this->_43,brightness);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,colorBrightness,(void))

::h3d::Vector Matrix_obj::pos( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Matrix","pos",0x3816141c,"h3d.Matrix.pos","h3d/Matrix.hx",535,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(535)
	if (((v == null()))){
		HX_STACK_LINE(536)
		return ::h3d::Vector_obj::__new(this->_41,this->_42,this->_43,this->_44);
	}
	else{
		HX_STACK_LINE(539)
		v->x = this->_41;
		HX_STACK_LINE(540)
		v->y = this->_42;
		HX_STACK_LINE(541)
		v->z = this->_43;
		HX_STACK_LINE(542)
		v->w = this->_44;
		HX_STACK_LINE(543)
		return v;
	}
	HX_STACK_LINE(535)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,pos,return )

::h3d::Vector Matrix_obj::at( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Matrix","at",0xa343c76b,"h3d.Matrix.at","h3d/Matrix.hx",550,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(550)
	if (((v == null()))){
		HX_STACK_LINE(551)
		return ::h3d::Vector_obj::__new(this->_31,this->_32,this->_33,this->_34);
	}
	else{
		HX_STACK_LINE(554)
		v->x = this->_31;
		HX_STACK_LINE(555)
		v->y = this->_32;
		HX_STACK_LINE(556)
		v->z = this->_33;
		HX_STACK_LINE(557)
		v->w = this->_34;
		HX_STACK_LINE(558)
		return v;
	}
	HX_STACK_LINE(550)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,at,return )

::h3d::Vector Matrix_obj::up( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Matrix","up",0xa343d8d3,"h3d.Matrix.up","h3d/Matrix.hx",565,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(565)
	if (((v == null()))){
		HX_STACK_LINE(566)
		return ::h3d::Vector_obj::__new(this->_21,this->_22,this->_23,this->_24);
	}
	else{
		HX_STACK_LINE(569)
		v->x = this->_21;
		HX_STACK_LINE(570)
		v->y = this->_22;
		HX_STACK_LINE(571)
		v->z = this->_23;
		HX_STACK_LINE(572)
		v->w = this->_24;
		HX_STACK_LINE(573)
		return v;
	}
	HX_STACK_LINE(565)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,up,return )

::h3d::Vector Matrix_obj::right( ::h3d::Vector v){
	HX_STACK_FRAME("h3d.Matrix","right",0x1ba57464,"h3d.Matrix.right","h3d/Matrix.hx",580,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(580)
	if (((v == null()))){
		HX_STACK_LINE(581)
		return ::h3d::Vector_obj::__new(this->_11,this->_12,this->_13,this->_14);
	}
	else{
		HX_STACK_LINE(584)
		v->x = this->_11;
		HX_STACK_LINE(585)
		v->y = this->_12;
		HX_STACK_LINE(586)
		v->z = this->_13;
		HX_STACK_LINE(587)
		v->w = this->_14;
		HX_STACK_LINE(588)
		return v;
	}
	HX_STACK_LINE(580)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,right,return )

Void Matrix_obj::makeOrtho( hx::Null< Float >  __o_width,hx::Null< Float >  __o_height,hx::Null< int >  __o_znear,hx::Null< Float >  __o_zfar){
Float width = __o_width.Default(1.0);
Float height = __o_height.Default(1.0);
int znear = __o_znear.Default(0);
Float zfar = __o_zfar.Default(1.0);
	HX_STACK_FRAME("h3d.Matrix","makeOrtho",0xea59daf2,"h3d.Matrix.makeOrtho","h3d/Matrix.hx",593,0x638e4567)
	HX_STACK_THIS(this)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(znear,"znear")
	HX_STACK_ARG(zfar,"zfar")
{
		HX_STACK_LINE(594)
		this->_11 = (Float(2.0) / Float(width));
		HX_STACK_LINE(595)
		this->_12 = (int)0;
		HX_STACK_LINE(596)
		this->_13 = (int)0;
		HX_STACK_LINE(597)
		this->_14 = (int)0;
		HX_STACK_LINE(599)
		this->_21 = (int)0;
		HX_STACK_LINE(600)
		this->_22 = (Float(-2.) / Float(height));
		HX_STACK_LINE(601)
		this->_23 = (int)0;
		HX_STACK_LINE(602)
		this->_24 = (int)0;
		HX_STACK_LINE(604)
		this->_31 = (int)0;
		HX_STACK_LINE(605)
		this->_32 = (int)0;
		HX_STACK_LINE(606)
		this->_33 = (Float(2.0) / Float(((zfar - znear))));
		HX_STACK_LINE(607)
		this->_34 = (int)0;
		HX_STACK_LINE(609)
		this->_41 = (int)-1;
		HX_STACK_LINE(610)
		this->_42 = (int)1;
		HX_STACK_LINE(611)
		this->_43 = (Float(((znear + zfar))) / Float(((znear - zfar))));
		HX_STACK_LINE(612)
		this->_44 = (int)1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Matrix_obj,makeOrtho,(void))

::h3d::Matrix Matrix_obj::tmp;

Float Matrix_obj::lumR;

Float Matrix_obj::lumG;

Float Matrix_obj::lumB;

::h3d::Matrix Matrix_obj::I( ){
	HX_STACK_FRAME("h3d.Matrix","I",0xa73084d1,"h3d.Matrix.I","h3d/Matrix.hx",502,0x638e4567)
	HX_STACK_LINE(503)
	::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(504)
	m->identity();
	HX_STACK_LINE(505)
	return m;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,I,return )

::h3d::Matrix Matrix_obj::L( Array< Float > a){
	HX_STACK_FRAME("h3d.Matrix","L",0xa73084d4,"h3d.Matrix.L","h3d/Matrix.hx",508,0x638e4567)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(509)
	::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(510)
	m->load(a);
	HX_STACK_LINE(511)
	return m;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,L,return )

::h3d::Matrix Matrix_obj::T( hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z){
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
Float z = __o_z.Default(0.);
	HX_STACK_FRAME("h3d.Matrix","T",0xa73084dc,"h3d.Matrix.T","h3d/Matrix.hx",514,0x638e4567)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
{
		HX_STACK_LINE(515)
		::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(516)
		m->initTranslate(x,y,z);
		HX_STACK_LINE(517)
		return m;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,T,return )

::h3d::Matrix Matrix_obj::R( Float x,Float y,Float z){
	HX_STACK_FRAME("h3d.Matrix","R",0xa73084da,"h3d.Matrix.R","h3d/Matrix.hx",520,0x638e4567)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
	HX_STACK_LINE(521)
	::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(522)
	m->initRotate(x,y,z);
	HX_STACK_LINE(523)
	return m;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,R,return )

::h3d::Matrix Matrix_obj::S( hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z){
Float x = __o_x.Default(1.);
Float y = __o_y.Default(1.);
Float z = __o_z.Default(1.0);
	HX_STACK_FRAME("h3d.Matrix","S",0xa73084db,"h3d.Matrix.S","h3d/Matrix.hx",526,0x638e4567)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
{
		HX_STACK_LINE(527)
		::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(528)
		m->initScale(x,y,z);
		HX_STACK_LINE(529)
		return m;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,S,return )


Matrix_obj::Matrix_obj()
{
}

Dynamic Matrix_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"I") ) { return I_dyn(); }
		if (HX_FIELD_EQ(inName,"L") ) { return L_dyn(); }
		if (HX_FIELD_EQ(inName,"T") ) { return T_dyn(); }
		if (HX_FIELD_EQ(inName,"R") ) { return R_dyn(); }
		if (HX_FIELD_EQ(inName,"S") ) { return S_dyn(); }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"at") ) { return at_dyn(); }
		if (HX_FIELD_EQ(inName,"up") ) { return up_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"tmp") ) { return tmp; }
		if (HX_FIELD_EQ(inName,"_11") ) { return _11; }
		if (HX_FIELD_EQ(inName,"_12") ) { return _12; }
		if (HX_FIELD_EQ(inName,"_13") ) { return _13; }
		if (HX_FIELD_EQ(inName,"_14") ) { return _14; }
		if (HX_FIELD_EQ(inName,"_21") ) { return _21; }
		if (HX_FIELD_EQ(inName,"_22") ) { return _22; }
		if (HX_FIELD_EQ(inName,"_23") ) { return _23; }
		if (HX_FIELD_EQ(inName,"_24") ) { return _24; }
		if (HX_FIELD_EQ(inName,"_31") ) { return _31; }
		if (HX_FIELD_EQ(inName,"_32") ) { return _32; }
		if (HX_FIELD_EQ(inName,"_33") ) { return _33; }
		if (HX_FIELD_EQ(inName,"_34") ) { return _34; }
		if (HX_FIELD_EQ(inName,"_41") ) { return _41; }
		if (HX_FIELD_EQ(inName,"_42") ) { return _42; }
		if (HX_FIELD_EQ(inName,"_43") ) { return _43; }
		if (HX_FIELD_EQ(inName,"_44") ) { return _44; }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"pos") ) { return pos_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"zero") ) { return zero_dyn(); }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"scale") ) { return scale_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"right") ) { return right_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"rotate") ) { return rotate_dyn(); }
		if (HX_FIELD_EQ(inName,"invert") ) { return invert_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"inverse") ) { return inverse_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"identity") ) { return identity_dyn(); }
		if (HX_FIELD_EQ(inName,"multiply") ) { return multiply_dyn(); }
		if (HX_FIELD_EQ(inName,"loadFrom") ) { return loadFrom_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"colorHue") ) { return colorHue_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"initScale") ) { return initScale_dyn(); }
		if (HX_FIELD_EQ(inName,"translate") ) { return translate_dyn(); }
		if (HX_FIELD_EQ(inName,"transpose") ) { return transpose_dyn(); }
		if (HX_FIELD_EQ(inName,"getFloats") ) { return getFloats_dyn(); }
		if (HX_FIELD_EQ(inName,"makeOrtho") ) { return makeOrtho_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"initRotate") ) { return initRotate_dyn(); }
		if (HX_FIELD_EQ(inName,"rotateAxis") ) { return rotateAxis_dyn(); }
		if (HX_FIELD_EQ(inName,"inverse3x4") ) { return inverse3x4_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"initRotateX") ) { return initRotateX_dyn(); }
		if (HX_FIELD_EQ(inName,"initRotateY") ) { return initRotateY_dyn(); }
		if (HX_FIELD_EQ(inName,"initRotateZ") ) { return initRotateZ_dyn(); }
		if (HX_FIELD_EQ(inName,"multiply3x4") ) { return multiply3x4_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"prependScale") ) { return prependScale_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"initTranslate") ) { return initTranslate_dyn(); }
		if (HX_FIELD_EQ(inName,"prependRotate") ) { return prependRotate_dyn(); }
		if (HX_FIELD_EQ(inName,"colorContrast") ) { return colorContrast_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"initRotateAxis") ) { return initRotateAxis_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"colorSaturation") ) { return colorSaturation_dyn(); }
		if (HX_FIELD_EQ(inName,"colorBrightness") ) { return colorBrightness_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"prependTranslate") ) { return prependTranslate_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"prependRotateAxis") ) { return prependRotateAxis_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Matrix_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"tmp") ) { tmp=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_11") ) { _11=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_12") ) { _12=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_13") ) { _13=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_14") ) { _14=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_21") ) { _21=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_22") ) { _22=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_23") ) { _23=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_24") ) { _24=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_31") ) { _31=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_32") ) { _32=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_33") ) { _33=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_34") ) { _34=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_41") ) { _41=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_42") ) { _42=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_43") ) { _43=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_44") ) { _44=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Matrix_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("_11"));
	outFields->push(HX_CSTRING("_12"));
	outFields->push(HX_CSTRING("_13"));
	outFields->push(HX_CSTRING("_14"));
	outFields->push(HX_CSTRING("_21"));
	outFields->push(HX_CSTRING("_22"));
	outFields->push(HX_CSTRING("_23"));
	outFields->push(HX_CSTRING("_24"));
	outFields->push(HX_CSTRING("_31"));
	outFields->push(HX_CSTRING("_32"));
	outFields->push(HX_CSTRING("_33"));
	outFields->push(HX_CSTRING("_34"));
	outFields->push(HX_CSTRING("_41"));
	outFields->push(HX_CSTRING("_42"));
	outFields->push(HX_CSTRING("_43"));
	outFields->push(HX_CSTRING("_44"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("tmp"),
	HX_CSTRING("lumR"),
	HX_CSTRING("lumG"),
	HX_CSTRING("lumB"),
	HX_CSTRING("I"),
	HX_CSTRING("L"),
	HX_CSTRING("T"),
	HX_CSTRING("R"),
	HX_CSTRING("S"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Matrix_obj,_11),HX_CSTRING("_11")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_12),HX_CSTRING("_12")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_13),HX_CSTRING("_13")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_14),HX_CSTRING("_14")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_21),HX_CSTRING("_21")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_22),HX_CSTRING("_22")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_23),HX_CSTRING("_23")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_24),HX_CSTRING("_24")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_31),HX_CSTRING("_31")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_32),HX_CSTRING("_32")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_33),HX_CSTRING("_33")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_34),HX_CSTRING("_34")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_41),HX_CSTRING("_41")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_42),HX_CSTRING("_42")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_43),HX_CSTRING("_43")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,_44),HX_CSTRING("_44")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("_11"),
	HX_CSTRING("_12"),
	HX_CSTRING("_13"),
	HX_CSTRING("_14"),
	HX_CSTRING("_21"),
	HX_CSTRING("_22"),
	HX_CSTRING("_23"),
	HX_CSTRING("_24"),
	HX_CSTRING("_31"),
	HX_CSTRING("_32"),
	HX_CSTRING("_33"),
	HX_CSTRING("_34"),
	HX_CSTRING("_41"),
	HX_CSTRING("_42"),
	HX_CSTRING("_43"),
	HX_CSTRING("_44"),
	HX_CSTRING("set"),
	HX_CSTRING("zero"),
	HX_CSTRING("identity"),
	HX_CSTRING("initRotateX"),
	HX_CSTRING("initRotateY"),
	HX_CSTRING("initRotateZ"),
	HX_CSTRING("initTranslate"),
	HX_CSTRING("initScale"),
	HX_CSTRING("initRotateAxis"),
	HX_CSTRING("initRotate"),
	HX_CSTRING("translate"),
	HX_CSTRING("scale"),
	HX_CSTRING("rotate"),
	HX_CSTRING("rotateAxis"),
	HX_CSTRING("add"),
	HX_CSTRING("prependTranslate"),
	HX_CSTRING("prependRotate"),
	HX_CSTRING("prependRotateAxis"),
	HX_CSTRING("prependScale"),
	HX_CSTRING("multiply3x4"),
	HX_CSTRING("multiply"),
	HX_CSTRING("invert"),
	HX_CSTRING("inverse3x4"),
	HX_CSTRING("inverse"),
	HX_CSTRING("transpose"),
	HX_CSTRING("clone"),
	HX_CSTRING("loadFrom"),
	HX_CSTRING("load"),
	HX_CSTRING("getFloats"),
	HX_CSTRING("toString"),
	HX_CSTRING("colorHue"),
	HX_CSTRING("colorSaturation"),
	HX_CSTRING("colorContrast"),
	HX_CSTRING("colorBrightness"),
	HX_CSTRING("pos"),
	HX_CSTRING("at"),
	HX_CSTRING("up"),
	HX_CSTRING("right"),
	HX_CSTRING("makeOrtho"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Matrix_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Matrix_obj::tmp,"tmp");
	HX_MARK_MEMBER_NAME(Matrix_obj::lumR,"lumR");
	HX_MARK_MEMBER_NAME(Matrix_obj::lumG,"lumG");
	HX_MARK_MEMBER_NAME(Matrix_obj::lumB,"lumB");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Matrix_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Matrix_obj::tmp,"tmp");
	HX_VISIT_MEMBER_NAME(Matrix_obj::lumR,"lumR");
	HX_VISIT_MEMBER_NAME(Matrix_obj::lumG,"lumG");
	HX_VISIT_MEMBER_NAME(Matrix_obj::lumB,"lumB");
};

#endif

Class Matrix_obj::__mClass;

void Matrix_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.Matrix"), hx::TCanCast< Matrix_obj> ,sStaticFields,sMemberFields,
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

void Matrix_obj::__boot()
{
	tmp= ::h3d::Matrix_obj::__new();
	lumR= 0.212671;
	lumG= 0.71516;
	lumB= 0.072169;
}

} // end namespace h3d
