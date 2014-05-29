#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Quat
#include <h3d/Quat.h>
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

Void Quat_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w)
{
HX_STACK_FRAME("h3d.Quat","new",0x32a5e53e,"h3d.Quat.new","h3d/Quat.hx",11,0xa67b7e11)
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

//Quat_obj::~Quat_obj() { }

Dynamic Quat_obj::__CreateEmpty() { return  new Quat_obj; }
hx::ObjectPtr< Quat_obj > Quat_obj::__new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w)
{  hx::ObjectPtr< Quat_obj > result = new Quat_obj();
	result->__construct(__o_x,__o_y,__o_z,__o_w);
	return result;}

Dynamic Quat_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Quat_obj > result = new Quat_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

Void Quat_obj::set( Float x,Float y,Float z,Float w){
{
		HX_STACK_FRAME("h3d.Quat","set",0x32a9b080,"h3d.Quat.set","h3d/Quat.hx",18,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_ARG(w,"w")
		HX_STACK_LINE(19)
		this->x = x;
		HX_STACK_LINE(20)
		this->y = y;
		HX_STACK_LINE(21)
		this->z = z;
		HX_STACK_LINE(22)
		this->w = w;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Quat_obj,set,(void))

Void Quat_obj::identity( ){
{
		HX_STACK_FRAME("h3d.Quat","identity",0xc40ecba0,"h3d.Quat.identity","h3d/Quat.hx",25,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_LINE(26)
		Float _g = this->z = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(26)
		Float _g1 = this->y = _g;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(26)
		this->x = _g1;
		HX_STACK_LINE(27)
		this->w = (int)1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,identity,(void))

Float Quat_obj::lengthSq( ){
	HX_STACK_FRAME("h3d.Quat","lengthSq",0x2aa2e986,"h3d.Quat.lengthSq","h3d/Quat.hx",31,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_LINE(31)
	return ((((this->x * this->x) + (this->y * this->y)) + (this->z * this->z)) + (this->w * this->w));
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,lengthSq,return )

Float Quat_obj::length( ){
	HX_STACK_FRAME("h3d.Quat","length",0xf6f75ec8,"h3d.Quat.length","h3d/Quat.hx",35,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	return ::Math_obj::sqrt(((((this->x * this->x) + (this->y * this->y)) + (this->z * this->z)) + (this->w * this->w)));
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,length,return )

::h3d::Quat Quat_obj::clone( ){
	HX_STACK_FRAME("h3d.Quat","clone",0x430a9bbb,"h3d.Quat.clone","h3d/Quat.hx",39,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_LINE(39)
	return ::h3d::Quat_obj::__new(this->x,this->y,this->z,this->w);
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,clone,return )

Void Quat_obj::initDirection( ::h3d::Vector dir,::h3d::Vector up){
{
		HX_STACK_FRAME("h3d.Quat","initDirection",0xb9543b6d,"h3d.Quat.initDirection","h3d/Quat.hx",43,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dir,"dir")
		HX_STACK_ARG(up,"up")
		HX_STACK_LINE(43)
		if (((up == null()))){
			HX_STACK_LINE(45)
			this->x = -(dir->y);
			HX_STACK_LINE(46)
			this->y = dir->x;
			HX_STACK_LINE(47)
			this->z = (int)0;
			HX_STACK_LINE(48)
			Float _g = ::Math_obj::sqrt((((dir->x * dir->x) + (dir->y * dir->y)) + (dir->z * dir->z)));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(48)
			Float _g1 = (dir->z + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(48)
			this->w = _g1;
			HX_STACK_LINE(49)
			this->normalize();
		}
		else{
			HX_STACK_LINE(52)
			Float tmp_x = ((up->y * dir->z) - (up->z * dir->y));		HX_STACK_VAR(tmp_x,"tmp_x");
			HX_STACK_LINE(52)
			Float tmp_y = ((up->z * dir->x) - (up->x * dir->z));		HX_STACK_VAR(tmp_y,"tmp_y");
			HX_STACK_LINE(52)
			Float tmp_z = ((up->x * dir->y) - (up->y * dir->x));		HX_STACK_VAR(tmp_z,"tmp_z");
			HX_STACK_LINE(52)
			Float tmp_w = (int)1;		HX_STACK_VAR(tmp_w,"tmp_w");
			HX_STACK_LINE(53)
			this->x = tmp_x;
			HX_STACK_LINE(54)
			this->y = tmp_y;
			HX_STACK_LINE(55)
			this->z = tmp_z;
			HX_STACK_LINE(56)
			Float _g2 = ::Math_obj::sqrt((((dir->x * dir->x) + (dir->y * dir->y)) + (dir->z * dir->z)));		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(56)
			Float _g3 = (_g2 + ((((dir->x * up->x) + (dir->y * up->y)) + (dir->z * up->z))));		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(56)
			this->w = _g3;
			HX_STACK_LINE(57)
			this->normalize();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Quat_obj,initDirection,(void))

Void Quat_obj::initRotateAxis( Float x,Float y,Float z,Float a){
{
		HX_STACK_FRAME("h3d.Quat","initRotateAxis",0xc0ce87ae,"h3d.Quat.initRotateAxis","h3d/Quat.hx",61,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(62)
		Float sin = ::Math_obj::sin((Float(a) / Float((int)2)));		HX_STACK_VAR(sin,"sin");
		HX_STACK_LINE(63)
		Float cos = ::Math_obj::cos((Float(a) / Float((int)2)));		HX_STACK_VAR(cos,"cos");
		HX_STACK_LINE(64)
		this->x = (x * sin);
		HX_STACK_LINE(65)
		this->y = (y * sin);
		HX_STACK_LINE(66)
		this->z = (z * sin);
		HX_STACK_LINE(67)
		Float _g = ::Math_obj::sqrt((((x * x) + (y * y)) + (z * z)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(67)
		Float _g1 = (cos * _g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(67)
		this->w = _g1;
		HX_STACK_LINE(68)
		this->normalize();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Quat_obj,initRotateAxis,(void))

Void Quat_obj::initRotateMatrix( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Quat","initRotateMatrix",0x0c983e8e,"h3d.Quat.initRotateMatrix","h3d/Quat.hx",71,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(72)
		Float tr = ((m->_11 + m->_22) + m->_33);		HX_STACK_VAR(tr,"tr");
		HX_STACK_LINE(73)
		if (((tr > (int)0))){
			HX_STACK_LINE(74)
			Float _g = ::Math_obj::sqrt((tr + 1.0));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(74)
			Float s = (_g * (int)2);		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(75)
			Float is = (Float((int)1) / Float(s));		HX_STACK_VAR(is,"is");
			HX_STACK_LINE(76)
			this->x = (((m->_23 - m->_32)) * is);
			HX_STACK_LINE(77)
			this->y = (((m->_31 - m->_13)) * is);
			HX_STACK_LINE(78)
			this->z = (((m->_12 - m->_21)) * is);
			HX_STACK_LINE(79)
			this->w = (0.25 * s);
		}
		else{
			HX_STACK_LINE(80)
			if (((bool((m->_11 > m->_22)) && bool((m->_11 > m->_33))))){
				HX_STACK_LINE(81)
				Float _g1 = ::Math_obj::sqrt((((1.0 + m->_11) - m->_22) - m->_33));		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(81)
				Float s = (_g1 * (int)2);		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(82)
				Float is = (Float((int)1) / Float(s));		HX_STACK_VAR(is,"is");
				HX_STACK_LINE(83)
				this->x = (0.25 * s);
				HX_STACK_LINE(84)
				this->y = (((m->_21 + m->_12)) * is);
				HX_STACK_LINE(85)
				this->z = (((m->_31 + m->_13)) * is);
				HX_STACK_LINE(86)
				this->w = (((m->_23 - m->_32)) * is);
			}
			else{
				HX_STACK_LINE(87)
				if (((m->_22 > m->_33))){
					HX_STACK_LINE(88)
					Float _g2 = ::Math_obj::sqrt((((1.0 + m->_22) - m->_11) - m->_33));		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(88)
					Float s = (_g2 * (int)2);		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(89)
					Float is = (Float((int)1) / Float(s));		HX_STACK_VAR(is,"is");
					HX_STACK_LINE(90)
					this->x = (((m->_21 + m->_12)) * is);
					HX_STACK_LINE(91)
					this->y = (0.25 * s);
					HX_STACK_LINE(92)
					this->z = (((m->_32 + m->_23)) * is);
					HX_STACK_LINE(93)
					this->w = (((m->_31 - m->_13)) * is);
				}
				else{
					HX_STACK_LINE(95)
					Float _g3 = ::Math_obj::sqrt((((1.0 + m->_33) - m->_11) - m->_22));		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(95)
					Float s = (_g3 * (int)2);		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(96)
					Float is = (Float((int)1) / Float(s));		HX_STACK_VAR(is,"is");
					HX_STACK_LINE(97)
					this->x = (((m->_31 + m->_13)) * is);
					HX_STACK_LINE(98)
					this->y = (((m->_32 + m->_23)) * is);
					HX_STACK_LINE(99)
					this->z = (0.25 * s);
					HX_STACK_LINE(100)
					this->w = (((m->_12 - m->_21)) * is);
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Quat_obj,initRotateMatrix,(void))

Void Quat_obj::normalize( ){
{
		HX_STACK_FRAME("h3d.Quat","normalize",0x245746eb,"h3d.Quat.normalize","h3d/Quat.hx",104,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_LINE(105)
		Float len = ((((this->x * this->x) + (this->y * this->y)) + (this->z * this->z)) + (this->w * this->w));		HX_STACK_VAR(len,"len");
		HX_STACK_LINE(106)
		if (((len < 1e-10))){
			HX_STACK_LINE(107)
			Float _g = this->z = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(107)
			Float _g1 = this->y = _g;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(107)
			this->x = _g1;
			HX_STACK_LINE(108)
			this->w = (int)1;
		}
		else{
			HX_STACK_LINE(110)
			Float _g2 = ::Math_obj::sqrt(len);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(110)
			Float m = (Float(1.) / Float(_g2));		HX_STACK_VAR(m,"m");
			HX_STACK_LINE(111)
			hx::MultEq(this->x,m);
			HX_STACK_LINE(112)
			hx::MultEq(this->y,m);
			HX_STACK_LINE(113)
			hx::MultEq(this->z,m);
			HX_STACK_LINE(114)
			hx::MultEq(this->w,m);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,normalize,(void))

Void Quat_obj::initRotate( Float ax,Float ay,Float az){
{
		HX_STACK_FRAME("h3d.Quat","initRotate",0xf5fd046d,"h3d.Quat.initRotate","h3d/Quat.hx",118,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ax,"ax")
		HX_STACK_ARG(ay,"ay")
		HX_STACK_ARG(az,"az")
		HX_STACK_LINE(119)
		Float sinX = ::Math_obj::sin((ax * 0.5));		HX_STACK_VAR(sinX,"sinX");
		HX_STACK_LINE(120)
		Float cosX = ::Math_obj::cos((ax * 0.5));		HX_STACK_VAR(cosX,"cosX");
		HX_STACK_LINE(121)
		Float sinY = ::Math_obj::sin((ay * 0.5));		HX_STACK_VAR(sinY,"sinY");
		HX_STACK_LINE(122)
		Float cosY = ::Math_obj::cos((ay * 0.5));		HX_STACK_VAR(cosY,"cosY");
		HX_STACK_LINE(123)
		Float sinZ = ::Math_obj::sin((az * 0.5));		HX_STACK_VAR(sinZ,"sinZ");
		HX_STACK_LINE(124)
		Float cosZ = ::Math_obj::cos((az * 0.5));		HX_STACK_VAR(cosZ,"cosZ");
		HX_STACK_LINE(125)
		Float cosYZ = (cosY * cosZ);		HX_STACK_VAR(cosYZ,"cosYZ");
		HX_STACK_LINE(126)
		Float sinYZ = (sinY * sinZ);		HX_STACK_VAR(sinYZ,"sinYZ");
		HX_STACK_LINE(127)
		this->x = ((sinX * cosYZ) - (cosX * sinYZ));
		HX_STACK_LINE(128)
		this->y = (((cosX * sinY) * cosZ) + ((sinX * cosY) * sinZ));
		HX_STACK_LINE(129)
		this->z = (((cosX * cosY) * sinZ) - ((sinX * sinY) * cosZ));
		HX_STACK_LINE(130)
		this->w = ((cosX * cosYZ) + (sinX * sinYZ));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Quat_obj,initRotate,(void))

Void Quat_obj::add( ::h3d::Quat q){
{
		HX_STACK_FRAME("h3d.Quat","add",0x329c06ff,"h3d.Quat.add","h3d/Quat.hx",134,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(q,"q")
		HX_STACK_LINE(134)
		this->multiply(hx::ObjectPtr<OBJ_>(this),q);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Quat_obj,add,(void))

Void Quat_obj::multiply( ::h3d::Quat q1,::h3d::Quat q2){
{
		HX_STACK_FRAME("h3d.Quat","multiply",0xa56c6886,"h3d.Quat.multiply","h3d/Quat.hx",137,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(q1,"q1")
		HX_STACK_ARG(q2,"q2")
		HX_STACK_LINE(138)
		Float x2 = ((((q1->x * q2->w) + (q1->w * q2->x)) + (q1->y * q2->z)) - (q1->z * q2->y));		HX_STACK_VAR(x2,"x2");
		HX_STACK_LINE(139)
		Float y2 = ((((q1->w * q2->y) - (q1->x * q2->z)) + (q1->y * q2->w)) + (q1->z * q2->x));		HX_STACK_VAR(y2,"y2");
		HX_STACK_LINE(140)
		Float z2 = ((((q1->w * q2->z) + (q1->x * q2->y)) - (q1->y * q2->x)) + (q1->z * q2->w));		HX_STACK_VAR(z2,"z2");
		HX_STACK_LINE(141)
		Float w2 = ((((q1->w * q2->w) - (q1->x * q2->x)) - (q1->y * q2->y)) - (q1->z * q2->z));		HX_STACK_VAR(w2,"w2");
		HX_STACK_LINE(142)
		this->x = x2;
		HX_STACK_LINE(143)
		this->y = y2;
		HX_STACK_LINE(144)
		this->z = z2;
		HX_STACK_LINE(145)
		this->w = w2;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Quat_obj,multiply,(void))

::h3d::Matrix Quat_obj::toMatrix( ){
	HX_STACK_FRAME("h3d.Quat","toMatrix",0xede6647e,"h3d.Quat.toMatrix","h3d/Quat.hx",148,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_LINE(149)
	::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(150)
	this->saveToMatrix(m);
	HX_STACK_LINE(151)
	return m;
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,toMatrix,return )

::h3d::Vector Quat_obj::toEuler( ){
	HX_STACK_FRAME("h3d.Quat","toEuler",0xdb8601cc,"h3d.Quat.toEuler","h3d/Quat.hx",154,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_LINE(156)
	Float _g = ::Math_obj::atan2(((int)2 * (((this->y * this->w) + (this->x * this->z)))),((int)1 - ((int)2 * (((this->y * this->y) + (this->z * this->z))))));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(157)
	Float _g1 = ::Math_obj::asin(((int)2 * (((this->x * this->y) + (this->z * this->w)))));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(158)
	Float _g2 = ::Math_obj::atan2(((int)2 * (((this->x * this->w) - (this->y * this->z)))),((int)1 - ((int)2 * (((this->x * this->x) + (this->z * this->z))))));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(155)
	return ::h3d::Vector_obj::__new(_g,_g1,_g2,null());
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,toEuler,return )

Void Quat_obj::lerp( ::h3d::Quat q1,::h3d::Quat q2,Float v,hx::Null< bool >  __o_nearest){
bool nearest = __o_nearest.Default(false);
	HX_STACK_FRAME("h3d.Quat","lerp",0x1d303fd9,"h3d.Quat.lerp","h3d/Quat.hx",162,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_ARG(q1,"q1")
	HX_STACK_ARG(q2,"q2")
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(nearest,"nearest")
{
		HX_STACK_LINE(163)
		Float v2;		HX_STACK_VAR(v2,"v2");
		HX_STACK_LINE(164)
		if (((bool(nearest) && bool((((((q1->x * q2->x) + (q1->y * q2->y)) + (q1->z * q2->z)) + (q1->w * q2->w)) < (int)0))))){
			HX_STACK_LINE(165)
			v2 = (v - (int)1);
		}
		else{
			HX_STACK_LINE(167)
			v2 = ((int)1 - v);
		}
		HX_STACK_LINE(168)
		Float x = ((q1->x * v) + (q2->x * v2));		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(169)
		Float y = ((q1->y * v) + (q2->y * v2));		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(170)
		Float z = ((q1->z * v) + (q2->z * v2));		HX_STACK_VAR(z,"z");
		HX_STACK_LINE(171)
		Float w = ((q1->w * v) + (q2->w * v2));		HX_STACK_VAR(w,"w");
		HX_STACK_LINE(172)
		this->x = x;
		HX_STACK_LINE(173)
		this->y = y;
		HX_STACK_LINE(174)
		this->z = z;
		HX_STACK_LINE(175)
		this->w = w;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Quat_obj,lerp,(void))

Void Quat_obj::slerp( ::h3d::Quat q1,::h3d::Quat q2,Float v){
{
		HX_STACK_FRAME("h3d.Quat","slerp",0x796c50c8,"h3d.Quat.slerp","h3d/Quat.hx",178,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_ARG(q1,"q1")
		HX_STACK_ARG(q2,"q2")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(179)
		Float cosHalfTheta = ((((q1->x * q2->x) + (q1->y * q2->y)) + (q1->z * q2->z)) + (q1->w * q2->w));		HX_STACK_VAR(cosHalfTheta,"cosHalfTheta");
		HX_STACK_LINE(180)
		if (((((  (((cosHalfTheta < (int)0))) ? Float(-(cosHalfTheta)) : Float(cosHalfTheta) )) >= (int)1))){
			HX_STACK_LINE(181)
			this->x = q1->x;
			HX_STACK_LINE(182)
			this->y = q1->y;
			HX_STACK_LINE(183)
			this->z = q1->z;
			HX_STACK_LINE(184)
			this->w = q1->w;
			HX_STACK_LINE(185)
			return null();
		}
		HX_STACK_LINE(187)
		Float halfTheta = ::Math_obj::acos(cosHalfTheta);		HX_STACK_VAR(halfTheta,"halfTheta");
		HX_STACK_LINE(188)
		Float _g = ::Math_obj::sqrt(((int)1 - (cosHalfTheta * cosHalfTheta)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(188)
		Float invSinHalfTheta = (Float(1.) / Float(_g));		HX_STACK_VAR(invSinHalfTheta,"invSinHalfTheta");
		HX_STACK_LINE(189)
		if (((((  (((invSinHalfTheta < (int)0))) ? Float(-(invSinHalfTheta)) : Float(invSinHalfTheta) )) > 1e3))){
			HX_STACK_LINE(190)
			{
				HX_STACK_LINE(190)
				Float v2;		HX_STACK_VAR(v2,"v2");
				HX_STACK_LINE(190)
				if (((((((q1->x * q2->x) + (q1->y * q2->y)) + (q1->z * q2->z)) + (q1->w * q2->w)) < (int)0))){
					HX_STACK_LINE(190)
					v2 = -0.5;
				}
				else{
					HX_STACK_LINE(190)
					v2 = 0.5;
				}
				HX_STACK_LINE(190)
				Float x = ((q1->x * 0.5) + (q2->x * v2));		HX_STACK_VAR(x,"x");
				HX_STACK_LINE(190)
				Float y = ((q1->y * 0.5) + (q2->y * v2));		HX_STACK_VAR(y,"y");
				HX_STACK_LINE(190)
				Float z = ((q1->z * 0.5) + (q2->z * v2));		HX_STACK_VAR(z,"z");
				HX_STACK_LINE(190)
				Float w = ((q1->w * 0.5) + (q2->w * v2));		HX_STACK_VAR(w,"w");
				HX_STACK_LINE(190)
				this->x = x;
				HX_STACK_LINE(190)
				this->y = y;
				HX_STACK_LINE(190)
				this->z = z;
				HX_STACK_LINE(190)
				this->w = w;
			}
			HX_STACK_LINE(191)
			return null();
		}
		HX_STACK_LINE(193)
		Float _g1 = ::Math_obj::sin(((((int)1 - v)) * halfTheta));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(193)
		Float a = (_g1 * invSinHalfTheta);		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(194)
		Float _g2 = ::Math_obj::sin((v * halfTheta));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(194)
		Float _g3 = (_g2 * invSinHalfTheta);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(194)
		Float b;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(194)
		b = (_g3 * ((  (((cosHalfTheta < (int)0))) ? int((int)-1) : int((int)1) )));
		HX_STACK_LINE(195)
		this->x = ((q1->x * a) + (q2->x * b));
		HX_STACK_LINE(196)
		this->y = ((q1->y * a) + (q2->y * b));
		HX_STACK_LINE(197)
		this->z = ((q1->z * a) + (q2->z * b));
		HX_STACK_LINE(198)
		this->w = ((q1->w * a) + (q2->w * b));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Quat_obj,slerp,(void))

Void Quat_obj::conjugate( ){
{
		HX_STACK_FRAME("h3d.Quat","conjugate",0xbb3f4576,"h3d.Quat.conjugate","h3d/Quat.hx",201,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_LINE(202)
		hx::MultEq(this->x,(int)-1);
		HX_STACK_LINE(203)
		hx::MultEq(this->y,(int)-1);
		HX_STACK_LINE(204)
		hx::MultEq(this->z,(int)-1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,conjugate,(void))

Void Quat_obj::negate( ){
{
		HX_STACK_FRAME("h3d.Quat","negate",0xbf090ba4,"h3d.Quat.negate","h3d/Quat.hx",210,0xa67b7e11)
		HX_STACK_THIS(this)
		HX_STACK_LINE(211)
		hx::MultEq(this->x,(int)-1);
		HX_STACK_LINE(212)
		hx::MultEq(this->y,(int)-1);
		HX_STACK_LINE(213)
		hx::MultEq(this->z,(int)-1);
		HX_STACK_LINE(214)
		hx::MultEq(this->w,(int)-1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,negate,(void))

Float Quat_obj::dot( ::h3d::Quat q){
	HX_STACK_FRAME("h3d.Quat","dot",0x329e5767,"h3d.Quat.dot","h3d/Quat.hx",218,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_ARG(q,"q")
	HX_STACK_LINE(218)
	return ((((this->x * q->x) + (this->y * q->y)) + (this->z * q->z)) + (this->w * q->w));
}


HX_DEFINE_DYNAMIC_FUNC1(Quat_obj,dot,return )

::h3d::Matrix Quat_obj::saveToMatrix( ::h3d::Matrix m){
	HX_STACK_FRAME("h3d.Quat","saveToMatrix",0x7aee89db,"h3d.Quat.saveToMatrix","h3d/Quat.hx",224,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(225)
	Float xx = (this->x * this->x);		HX_STACK_VAR(xx,"xx");
	HX_STACK_LINE(226)
	Float xy = (this->x * this->y);		HX_STACK_VAR(xy,"xy");
	HX_STACK_LINE(227)
	Float xz = (this->x * this->z);		HX_STACK_VAR(xz,"xz");
	HX_STACK_LINE(228)
	Float xw = (this->x * this->w);		HX_STACK_VAR(xw,"xw");
	HX_STACK_LINE(229)
	Float yy = (this->y * this->y);		HX_STACK_VAR(yy,"yy");
	HX_STACK_LINE(230)
	Float yz = (this->y * this->z);		HX_STACK_VAR(yz,"yz");
	HX_STACK_LINE(231)
	Float yw = (this->y * this->w);		HX_STACK_VAR(yw,"yw");
	HX_STACK_LINE(232)
	Float zz = (this->z * this->z);		HX_STACK_VAR(zz,"zz");
	HX_STACK_LINE(233)
	Float zw = (this->z * this->w);		HX_STACK_VAR(zw,"zw");
	HX_STACK_LINE(234)
	m->_11 = ((int)1 - ((int)2 * ((yy + zz))));
	HX_STACK_LINE(235)
	m->_12 = ((int)2 * ((xy + zw)));
	HX_STACK_LINE(236)
	m->_13 = ((int)2 * ((xz - yw)));
	HX_STACK_LINE(237)
	m->_14 = (int)0;
	HX_STACK_LINE(238)
	m->_21 = ((int)2 * ((xy - zw)));
	HX_STACK_LINE(239)
	m->_22 = ((int)1 - ((int)2 * ((xx + zz))));
	HX_STACK_LINE(240)
	m->_23 = ((int)2 * ((yz + xw)));
	HX_STACK_LINE(241)
	m->_24 = (int)0;
	HX_STACK_LINE(242)
	m->_31 = ((int)2 * ((xz + yw)));
	HX_STACK_LINE(243)
	m->_32 = ((int)2 * ((yz - xw)));
	HX_STACK_LINE(244)
	m->_33 = ((int)1 - ((int)2 * ((xx + yy))));
	HX_STACK_LINE(245)
	m->_34 = (int)0;
	HX_STACK_LINE(246)
	m->_41 = (int)0;
	HX_STACK_LINE(247)
	m->_42 = (int)0;
	HX_STACK_LINE(248)
	m->_43 = (int)0;
	HX_STACK_LINE(249)
	m->_44 = (int)1;
	HX_STACK_LINE(250)
	return m;
}


HX_DEFINE_DYNAMIC_FUNC1(Quat_obj,saveToMatrix,return )

::String Quat_obj::toString( ){
	HX_STACK_FRAME("h3d.Quat","toString",0x434e570e,"h3d.Quat.toString","h3d/Quat.hx",253,0xa67b7e11)
	HX_STACK_THIS(this)
	HX_STACK_LINE(254)
	Float _g = ::hxd::Math_obj::fmt(this->x);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(254)
	::String _g1 = (HX_CSTRING("{") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(254)
	::String _g2 = (_g1 + HX_CSTRING(","));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(254)
	Float _g3 = ::hxd::Math_obj::fmt(this->y);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(254)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(254)
	::String _g5 = (_g4 + HX_CSTRING(","));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(254)
	Float _g6 = ::hxd::Math_obj::fmt(this->z);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(254)
	::String _g7 = (_g5 + _g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(254)
	::String _g8 = (_g7 + HX_CSTRING(","));		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(254)
	Float _g9 = ::hxd::Math_obj::fmt(this->w);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(254)
	::String _g10 = (_g8 + _g9);		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(254)
	return (_g10 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Quat_obj,toString,return )


Quat_obj::Quat_obj()
{
}

Dynamic Quat_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"z") ) { return z; }
		if (HX_FIELD_EQ(inName,"w") ) { return w; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"dot") ) { return dot_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"lerp") ) { return lerp_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"slerp") ) { return slerp_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return length_dyn(); }
		if (HX_FIELD_EQ(inName,"negate") ) { return negate_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"toEuler") ) { return toEuler_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"identity") ) { return identity_dyn(); }
		if (HX_FIELD_EQ(inName,"lengthSq") ) { return lengthSq_dyn(); }
		if (HX_FIELD_EQ(inName,"multiply") ) { return multiply_dyn(); }
		if (HX_FIELD_EQ(inName,"toMatrix") ) { return toMatrix_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		if (HX_FIELD_EQ(inName,"conjugate") ) { return conjugate_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"initRotate") ) { return initRotate_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"saveToMatrix") ) { return saveToMatrix_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"initDirection") ) { return initDirection_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"initRotateAxis") ) { return initRotateAxis_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"initRotateMatrix") ) { return initRotateMatrix_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Quat_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
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

void Quat_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("z"));
	outFields->push(HX_CSTRING("w"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Quat_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Quat_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Quat_obj,z),HX_CSTRING("z")},
	{hx::fsFloat,(int)offsetof(Quat_obj,w),HX_CSTRING("w")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("z"),
	HX_CSTRING("w"),
	HX_CSTRING("set"),
	HX_CSTRING("identity"),
	HX_CSTRING("lengthSq"),
	HX_CSTRING("length"),
	HX_CSTRING("clone"),
	HX_CSTRING("initDirection"),
	HX_CSTRING("initRotateAxis"),
	HX_CSTRING("initRotateMatrix"),
	HX_CSTRING("normalize"),
	HX_CSTRING("initRotate"),
	HX_CSTRING("add"),
	HX_CSTRING("multiply"),
	HX_CSTRING("toMatrix"),
	HX_CSTRING("toEuler"),
	HX_CSTRING("lerp"),
	HX_CSTRING("slerp"),
	HX_CSTRING("conjugate"),
	HX_CSTRING("negate"),
	HX_CSTRING("dot"),
	HX_CSTRING("saveToMatrix"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Quat_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Quat_obj::__mClass,"__mClass");
};

#endif

Class Quat_obj::__mClass;

void Quat_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.Quat"), hx::TCanCast< Quat_obj> ,sStaticFields,sMemberFields,
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

void Quat_obj::__boot()
{
}

} // end namespace h3d
