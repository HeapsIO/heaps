#include <hxcpp.h>

#ifndef INCLUDED_h2d_Matrix
#include <h2d/Matrix.h>
#endif
#ifndef INCLUDED_h2d_col_Point
#include <h2d/col/Point.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace h2d{

Void Matrix_obj::__construct(hx::Null< Float >  __o_a,hx::Null< Float >  __o_b,hx::Null< Float >  __o_c,hx::Null< Float >  __o_d,hx::Null< Float >  __o_tx,hx::Null< Float >  __o_ty)
{
HX_STACK_FRAME("h2d.Matrix","new",0xf2540967,"h2d.Matrix.new","h2d/Matrix.hx",32,0x21ced7c8)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_a,"a")
HX_STACK_ARG(__o_b,"b")
HX_STACK_ARG(__o_c,"c")
HX_STACK_ARG(__o_d,"d")
HX_STACK_ARG(__o_tx,"tx")
HX_STACK_ARG(__o_ty,"ty")
Float a = __o_a.Default(1.);
Float b = __o_b.Default(0.);
Float c = __o_c.Default(0.);
Float d = __o_d.Default(1.);
Float tx = __o_tx.Default(0.);
Float ty = __o_ty.Default(0.);
{
	HX_STACK_LINE(32)
	this->a = a;
	HX_STACK_LINE(32)
	this->b = b;
	HX_STACK_LINE(32)
	this->c = c;
	HX_STACK_LINE(32)
	this->d = d;
	HX_STACK_LINE(32)
	this->tx = tx;
	HX_STACK_LINE(32)
	this->ty = ty;
}
;
	return null();
}

//Matrix_obj::~Matrix_obj() { }

Dynamic Matrix_obj::__CreateEmpty() { return  new Matrix_obj; }
hx::ObjectPtr< Matrix_obj > Matrix_obj::__new(hx::Null< Float >  __o_a,hx::Null< Float >  __o_b,hx::Null< Float >  __o_c,hx::Null< Float >  __o_d,hx::Null< Float >  __o_tx,hx::Null< Float >  __o_ty)
{  hx::ObjectPtr< Matrix_obj > result = new Matrix_obj();
	result->__construct(__o_a,__o_b,__o_c,__o_d,__o_tx,__o_ty);
	return result;}

Dynamic Matrix_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Matrix_obj > result = new Matrix_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}

Void Matrix_obj::zero( ){
{
		HX_STACK_FRAME("h2d.Matrix","zero",0x1f22bc41,"h2d.Matrix.zero","h2d/Matrix.hx",35,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_LINE(36)
		Float _g = this->ty = 0.0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(36)
		Float _g1 = this->tx = _g;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(36)
		Float _g2 = this->d = _g1;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(36)
		Float _g3 = this->c = _g2;		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(36)
		Float _g4 = this->b = _g3;		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(36)
		this->a = _g4;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,zero,(void))

Void Matrix_obj::identity( ){
{
		HX_STACK_FRAME("h2d.Matrix","identity",0xab3ff2d7,"h2d.Matrix.identity","h2d/Matrix.hx",39,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_LINE(40)
		this->a = 1.;
		HX_STACK_LINE(40)
		this->b = 0.;
		HX_STACK_LINE(40)
		this->c = 0.;
		HX_STACK_LINE(40)
		this->d = 1.;
		HX_STACK_LINE(40)
		this->tx = 0.;
		HX_STACK_LINE(40)
		this->ty = 0.;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,identity,(void))

Void Matrix_obj::setTo( hx::Null< Float >  __o_a,hx::Null< Float >  __o_b,hx::Null< Float >  __o_c,hx::Null< Float >  __o_d,hx::Null< Float >  __o_tx,hx::Null< Float >  __o_ty){
Float a = __o_a.Default(1.);
Float b = __o_b.Default(0.);
Float c = __o_c.Default(0.);
Float d = __o_d.Default(1.);
Float tx = __o_tx.Default(0.);
Float ty = __o_ty.Default(0.);
	HX_STACK_FRAME("h2d.Matrix","setTo",0x17755a84,"h2d.Matrix.setTo","h2d/Matrix.hx",43,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(c,"c")
	HX_STACK_ARG(d,"d")
	HX_STACK_ARG(tx,"tx")
	HX_STACK_ARG(ty,"ty")
{
		HX_STACK_LINE(44)
		this->a = a;
		HX_STACK_LINE(45)
		this->b = b;
		HX_STACK_LINE(46)
		this->c = c;
		HX_STACK_LINE(47)
		this->d = d;
		HX_STACK_LINE(49)
		this->tx = tx;
		HX_STACK_LINE(50)
		this->ty = ty;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(Matrix_obj,setTo,(void))

::h2d::Matrix Matrix_obj::invert( ){
	HX_STACK_FRAME("h2d.Matrix","invert",0x9fa2cc6f,"h2d.Matrix.invert","h2d/Matrix.hx",53,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_LINE(55)
	Float norm = ((this->a * this->d) - (this->b * this->c));		HX_STACK_VAR(norm,"norm");
	HX_STACK_LINE(56)
	if (((norm == (int)0))){
		HX_STACK_LINE(58)
		Float _g = this->d = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(58)
		Float _g1 = this->c = _g;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(58)
		Float _g2 = this->b = _g1;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(58)
		this->a = _g2;
		HX_STACK_LINE(59)
		this->tx = -(this->tx);
		HX_STACK_LINE(60)
		this->ty = -(this->ty);
	}
	else{
		HX_STACK_LINE(62)
		norm = (Float(1.0) / Float(norm));
		HX_STACK_LINE(63)
		Float a1 = (this->d * norm);		HX_STACK_VAR(a1,"a1");
		HX_STACK_LINE(64)
		this->d = (this->a * norm);
		HX_STACK_LINE(65)
		this->a = a1;
		HX_STACK_LINE(66)
		hx::MultEq(this->b,-(norm));
		HX_STACK_LINE(67)
		hx::MultEq(this->c,-(norm));
		HX_STACK_LINE(69)
		Float tx1 = ((-(this->a) * this->tx) - (this->c * this->ty));		HX_STACK_VAR(tx1,"tx1");
		HX_STACK_LINE(70)
		this->ty = ((-(this->b) * this->tx) - (this->d * this->ty));
		HX_STACK_LINE(71)
		this->tx = tx1;
	}
	HX_STACK_LINE(74)
	return hx::ObjectPtr<OBJ_>(this);
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,invert,return )

Void Matrix_obj::rotate( Float angle){
{
		HX_STACK_FRAME("h2d.Matrix","rotate",0xcaea2bb4,"h2d.Matrix.rotate","h2d/Matrix.hx",78,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(angle,"angle")
		HX_STACK_LINE(79)
		Float c = ::Math_obj::cos(angle);		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(80)
		Float s = ::Math_obj::sin(angle);		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(81)
		this->concat32(c,-(s),s,c,0.0,0.0);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,rotate,(void))

Void Matrix_obj::scale( Float x,Float y){
{
		HX_STACK_FRAME("h2d.Matrix","scale",0x16149751,"h2d.Matrix.scale","h2d/Matrix.hx",86,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(87)
		hx::MultEq(this->a,x);
		HX_STACK_LINE(88)
		hx::MultEq(this->b,y);
		HX_STACK_LINE(90)
		hx::MultEq(this->c,x);
		HX_STACK_LINE(91)
		hx::MultEq(this->d,y);
		HX_STACK_LINE(93)
		hx::MultEq(this->tx,x);
		HX_STACK_LINE(94)
		hx::MultEq(this->ty,y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,scale,(void))

Void Matrix_obj::skew( Float x,Float y){
{
		HX_STACK_FRAME("h2d.Matrix","skew",0x1a86c023,"h2d.Matrix.skew","h2d/Matrix.hx",99,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(100)
		Float _g = ::Math_obj::tan(y);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(101)
		Float _g1 = ::Math_obj::tan(x);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(100)
		this->concat32(1.0,_g,_g1,1.0,0.0,0.0);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,skew,(void))

Void Matrix_obj::makeSkew( Float x,Float y){
{
		HX_STACK_FRAME("h2d.Matrix","makeSkew",0x3503b5b1,"h2d.Matrix.makeSkew","h2d/Matrix.hx",107,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(108)
		{
			HX_STACK_LINE(108)
			this->a = 1.;
			HX_STACK_LINE(108)
			this->b = 0.;
			HX_STACK_LINE(108)
			this->c = 0.;
			HX_STACK_LINE(108)
			this->d = 1.;
			HX_STACK_LINE(108)
			this->tx = 0.;
			HX_STACK_LINE(108)
			this->ty = 0.;
		}
		HX_STACK_LINE(109)
		Float _g = ::Math_obj::tan(y);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(109)
		this->b = _g;
		HX_STACK_LINE(110)
		Float _g1 = ::Math_obj::tan(x);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(110)
		this->c = _g1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,makeSkew,(void))

Void Matrix_obj::setRotation( Float angle,hx::Null< Float >  __o_scale){
Float scale = __o_scale.Default(1);
	HX_STACK_FRAME("h2d.Matrix","setRotation",0xafe21f07,"h2d.Matrix.setRotation","h2d/Matrix.hx",113,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(angle,"angle")
	HX_STACK_ARG(scale,"scale")
{
		HX_STACK_LINE(114)
		Float _g = ::Math_obj::cos(angle);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(114)
		Float _g1 = (_g * scale);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(114)
		this->a = _g1;
		HX_STACK_LINE(115)
		Float _g2 = -(::Math_obj::sin(angle));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(115)
		Float _g3 = (_g2 * scale);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(115)
		this->c = _g3;
		HX_STACK_LINE(116)
		this->b = -(this->c);
		HX_STACK_LINE(117)
		this->d = this->a;
		HX_STACK_LINE(118)
		Float _g4 = this->ty = (int)0;		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(118)
		this->tx = _g4;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,setRotation,(void))

::String Matrix_obj::toString( ){
	HX_STACK_FRAME("h2d.Matrix","toString",0x2a7f7e45,"h2d.Matrix.toString","h2d/Matrix.hx",122,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_LINE(122)
	return ((((((((((((HX_CSTRING("(a=") + this->a) + HX_CSTRING(", b=")) + this->b) + HX_CSTRING(", c=")) + this->c) + HX_CSTRING(", d=")) + this->d) + HX_CSTRING(", tx=")) + this->tx) + HX_CSTRING(", ty=")) + this->ty) + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix_obj,toString,return )

::h2d::col::Point Matrix_obj::transformPoint( ::h2d::col::Point point){
	HX_STACK_FRAME("h2d.Matrix","transformPoint",0xf6b6359d,"h2d.Matrix.transformPoint","h2d/Matrix.hx",126,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_LINE(126)
	return ::h2d::col::Point_obj::__new((((point->x * this->a) + (point->y * this->c)) + this->tx),(((point->x * this->b) + (point->y * this->d)) + this->ty));
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,transformPoint,return )

Void Matrix_obj::concat( ::h2d::Matrix m){
{
		HX_STACK_FRAME("h2d.Matrix","concat",0xc799ee6d,"h2d.Matrix.concat","h2d/Matrix.hx",129,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(130)
		Float a1 = ((this->a * m->a) + (this->b * m->c));		HX_STACK_VAR(a1,"a1");
		HX_STACK_LINE(131)
		this->b = ((this->a * m->b) + (this->b * m->d));
		HX_STACK_LINE(132)
		this->a = a1;
		HX_STACK_LINE(134)
		Float c1 = ((this->c * m->a) + (this->d * m->c));		HX_STACK_VAR(c1,"c1");
		HX_STACK_LINE(135)
		this->d = ((this->c * m->b) + (this->d * m->d));
		HX_STACK_LINE(137)
		this->c = c1;
		HX_STACK_LINE(139)
		Float tx1 = (((this->tx * m->a) + (this->ty * m->c)) + m->tx);		HX_STACK_VAR(tx1,"tx1");
		HX_STACK_LINE(140)
		this->ty = (((this->tx * m->b) + (this->ty * m->d)) + m->ty);
		HX_STACK_LINE(141)
		this->tx = tx1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,concat,(void))

Void Matrix_obj::concat22( ::h2d::Matrix m){
{
		HX_STACK_FRAME("h2d.Matrix","concat22",0x54c44f6d,"h2d.Matrix.concat22","h2d/Matrix.hx",147,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(148)
		Float a1 = ((this->a * m->a) + (this->b * m->c));		HX_STACK_VAR(a1,"a1");
		HX_STACK_LINE(149)
		this->b = ((this->a * m->b) + (this->b * m->d));
		HX_STACK_LINE(150)
		this->a = a1;
		HX_STACK_LINE(152)
		Float c1 = ((this->c * m->a) + (this->d * m->c));		HX_STACK_VAR(c1,"c1");
		HX_STACK_LINE(153)
		this->d = ((this->c * m->b) + (this->d * m->d));
		HX_STACK_LINE(155)
		this->c = c1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix_obj,concat22,(void))

Void Matrix_obj::concat32( Float ma,Float mb,Float mc,Float md,Float mtx,Float mty){
{
		HX_STACK_FRAME("h2d.Matrix","concat32",0x54c4504c,"h2d.Matrix.concat32","h2d/Matrix.hx",158,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ma,"ma")
		HX_STACK_ARG(mb,"mb")
		HX_STACK_ARG(mc,"mc")
		HX_STACK_ARG(md,"md")
		HX_STACK_ARG(mtx,"mtx")
		HX_STACK_ARG(mty,"mty")
		HX_STACK_LINE(159)
		Float a1 = ((this->a * ma) + (this->b * mc));		HX_STACK_VAR(a1,"a1");
		HX_STACK_LINE(160)
		this->b = ((this->a * mb) + (this->b * md));
		HX_STACK_LINE(161)
		this->a = a1;
		HX_STACK_LINE(163)
		Float c1 = ((this->c * ma) + (this->d * mc));		HX_STACK_VAR(c1,"c1");
		HX_STACK_LINE(164)
		this->d = ((this->c * mb) + (this->d * md));
		HX_STACK_LINE(166)
		this->c = c1;
		HX_STACK_LINE(168)
		Float tx1 = (((this->tx * ma) + (this->ty * mc)) + mtx);		HX_STACK_VAR(tx1,"tx1");
		HX_STACK_LINE(169)
		this->ty = (((this->tx * mb) + (this->ty * md)) + mty);
		HX_STACK_LINE(170)
		this->tx = tx1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC6(Matrix_obj,concat32,(void))

::h2d::col::Point Matrix_obj::transformPoint2( Float pointx,Float pointy,::h2d::col::Point res){
	HX_STACK_FRAME("h2d.Matrix","transformPoint2",0xe8b8b3f5,"h2d.Matrix.transformPoint2","h2d/Matrix.hx",177,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pointx,"pointx")
	HX_STACK_ARG(pointy,"pointy")
	HX_STACK_ARG(res,"res")
	HX_STACK_LINE(178)
	::h2d::col::Point p;		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(178)
	if (((res == null()))){
		HX_STACK_LINE(178)
		p = ::h2d::col::Point_obj::__new(null(),null());
	}
	else{
		HX_STACK_LINE(178)
		p = res;
	}
	HX_STACK_LINE(179)
	Float px = pointx;		HX_STACK_VAR(px,"px");
	HX_STACK_LINE(180)
	Float py = pointy;		HX_STACK_VAR(py,"py");
	HX_STACK_LINE(181)
	p->x = (((px * this->a) + (py * this->c)) + this->tx);
	HX_STACK_LINE(182)
	p->y = (((px * this->b) + (py * this->d)) + this->ty);
	HX_STACK_LINE(183)
	return p;
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix_obj,transformPoint2,return )

Float Matrix_obj::transformX( Float px,Float py){
	HX_STACK_FRAME("h2d.Matrix","transformX",0xb4fe9745,"h2d.Matrix.transformX","h2d/Matrix.hx",187,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(px,"px")
	HX_STACK_ARG(py,"py")
	HX_STACK_LINE(187)
	return (((px * this->a) + (py * this->c)) + this->tx);
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,transformX,return )

Float Matrix_obj::transformY( Float px,Float py){
	HX_STACK_FRAME("h2d.Matrix","transformY",0xb4fe9746,"h2d.Matrix.transformY","h2d/Matrix.hx",191,0x21ced7c8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(px,"px")
	HX_STACK_ARG(py,"py")
	HX_STACK_LINE(191)
	return (((px * this->b) + (py * this->d)) + this->ty);
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,transformY,return )

Void Matrix_obj::translate( Float x,Float y){
{
		HX_STACK_FRAME("h2d.Matrix","translate",0x26070f95,"h2d.Matrix.translate","h2d/Matrix.hx",194,0x21ced7c8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(195)
		hx::AddEq(this->tx,x);
		HX_STACK_LINE(196)
		hx::AddEq(this->ty,y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix_obj,translate,(void))


Matrix_obj::Matrix_obj()
{
}

Dynamic Matrix_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"a") ) { return a; }
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		if (HX_FIELD_EQ(inName,"c") ) { return c; }
		if (HX_FIELD_EQ(inName,"d") ) { return d; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"tx") ) { return tx; }
		if (HX_FIELD_EQ(inName,"ty") ) { return ty; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"zero") ) { return zero_dyn(); }
		if (HX_FIELD_EQ(inName,"skew") ) { return skew_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"setTo") ) { return setTo_dyn(); }
		if (HX_FIELD_EQ(inName,"scale") ) { return scale_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"invert") ) { return invert_dyn(); }
		if (HX_FIELD_EQ(inName,"rotate") ) { return rotate_dyn(); }
		if (HX_FIELD_EQ(inName,"concat") ) { return concat_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"identity") ) { return identity_dyn(); }
		if (HX_FIELD_EQ(inName,"makeSkew") ) { return makeSkew_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"concat22") ) { return concat22_dyn(); }
		if (HX_FIELD_EQ(inName,"concat32") ) { return concat32_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"translate") ) { return translate_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"transformX") ) { return transformX_dyn(); }
		if (HX_FIELD_EQ(inName,"transformY") ) { return transformY_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"setRotation") ) { return setRotation_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"transformPoint") ) { return transformPoint_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"transformPoint2") ) { return transformPoint2_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Matrix_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"a") ) { a=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"c") ) { c=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"d") ) { d=inValue.Cast< Float >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"tx") ) { tx=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ty") ) { ty=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Matrix_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("a"));
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("c"));
	outFields->push(HX_CSTRING("d"));
	outFields->push(HX_CSTRING("tx"));
	outFields->push(HX_CSTRING("ty"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Matrix_obj,a),HX_CSTRING("a")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,b),HX_CSTRING("b")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,c),HX_CSTRING("c")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,d),HX_CSTRING("d")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,tx),HX_CSTRING("tx")},
	{hx::fsFloat,(int)offsetof(Matrix_obj,ty),HX_CSTRING("ty")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("a"),
	HX_CSTRING("b"),
	HX_CSTRING("c"),
	HX_CSTRING("d"),
	HX_CSTRING("tx"),
	HX_CSTRING("ty"),
	HX_CSTRING("zero"),
	HX_CSTRING("identity"),
	HX_CSTRING("setTo"),
	HX_CSTRING("invert"),
	HX_CSTRING("rotate"),
	HX_CSTRING("scale"),
	HX_CSTRING("skew"),
	HX_CSTRING("makeSkew"),
	HX_CSTRING("setRotation"),
	HX_CSTRING("toString"),
	HX_CSTRING("transformPoint"),
	HX_CSTRING("concat"),
	HX_CSTRING("concat22"),
	HX_CSTRING("concat32"),
	HX_CSTRING("transformPoint2"),
	HX_CSTRING("transformX"),
	HX_CSTRING("transformY"),
	HX_CSTRING("translate"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Matrix_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Matrix_obj::__mClass,"__mClass");
};

#endif

Class Matrix_obj::__mClass;

void Matrix_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Matrix"), hx::TCanCast< Matrix_obj> ,sStaticFields,sMemberFields,
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
}

} // end namespace h2d
