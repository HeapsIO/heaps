#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h2d_Matrix
#include <h2d/Matrix.h>
#endif
#ifndef INCLUDED_h2d_col_Bounds
#include <h2d/col/Bounds.h>
#endif
#ifndef INCLUDED_h2d_col_Point
#include <h2d/col/Point.h>
#endif
namespace h2d{
namespace col{

Void Bounds_obj::__construct()
{
HX_STACK_FRAME("h2d.col.Bounds","new",0x6a1d0b09,"h2d.col.Bounds.new","h2d/col/Bounds.hx",18,0x3d6ab3c5)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(18)
	this->xMin = 1e20;
	HX_STACK_LINE(18)
	this->yMin = 1e20;
	HX_STACK_LINE(18)
	this->xMax = -1e20;
	HX_STACK_LINE(18)
	this->yMax = -1e20;
}
;
	return null();
}

//Bounds_obj::~Bounds_obj() { }

Dynamic Bounds_obj::__CreateEmpty() { return  new Bounds_obj; }
hx::ObjectPtr< Bounds_obj > Bounds_obj::__new()
{  hx::ObjectPtr< Bounds_obj > result = new Bounds_obj();
	result->__construct();
	return result;}

Dynamic Bounds_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Bounds_obj > result = new Bounds_obj();
	result->__construct();
	return result;}

Float Bounds_obj::get_x( ){
	HX_STACK_FRAME("h2d.col.Bounds","get_x",0xebec9c38,"h2d.col.Bounds.get_x","h2d/col/Bounds.hx",21,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(21)
	return this->xMin;
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,get_x,return )

Float Bounds_obj::get_y( ){
	HX_STACK_FRAME("h2d.col.Bounds","get_y",0xebec9c39,"h2d.col.Bounds.get_y","h2d/col/Bounds.hx",22,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(22)
	return this->yMin;
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,get_y,return )

Float Bounds_obj::get_width( ){
	HX_STACK_FRAME("h2d.col.Bounds","get_width",0xc52831c6,"h2d.col.Bounds.get_width","h2d/col/Bounds.hx",24,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(24)
	return (this->xMax - this->xMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,get_width,return )

Float Bounds_obj::get_height( ){
	HX_STACK_FRAME("h2d.col.Bounds","get_height",0x7452d427,"h2d.col.Bounds.get_height","h2d/col/Bounds.hx",25,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(25)
	return (this->yMax - this->yMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,get_height,return )

bool Bounds_obj::collides( ::h2d::col::Bounds b){
	HX_STACK_FRAME("h2d.col.Bounds","collides",0x8caa5fec,"h2d.col.Bounds.collides","h2d/col/Bounds.hx",28,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(28)
	return !(((bool((bool((bool((this->xMin > b->xMax)) || bool((this->yMin > b->yMax)))) || bool((this->xMax < b->xMin)))) || bool((this->yMax < b->yMin)))));
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,collides,return )

bool Bounds_obj::includes( ::h2d::col::Point p){
	HX_STACK_FRAME("h2d.col.Bounds","includes",0x28fbe602,"h2d.col.Bounds.includes","h2d/col/Bounds.hx",32,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(32)
	return (bool((bool((bool((p->x >= this->xMin)) && bool((p->x < this->xMax)))) && bool((p->y >= this->yMin)))) && bool((p->y < this->yMax)));
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,includes,return )

bool Bounds_obj::includes2( Float px,Float py){
	HX_STACK_FRAME("h2d.col.Bounds","includes2",0xb36d5bf0,"h2d.col.Bounds.includes2","h2d/col/Bounds.hx",36,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(px,"px")
	HX_STACK_ARG(py,"py")
	HX_STACK_LINE(36)
	return (bool((bool((bool((px >= this->xMin)) && bool((px < this->xMax)))) && bool((py >= this->yMin)))) && bool((py < this->yMax)));
}


HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,includes2,return )

bool Bounds_obj::testCircle( Float px,Float py,int r){
	HX_STACK_FRAME("h2d.col.Bounds","testCircle",0xf0811479,"h2d.col.Bounds.testCircle","h2d/col/Bounds.hx",42,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(px,"px")
	HX_STACK_ARG(py,"py")
	HX_STACK_ARG(r,"r")
	HX_STACK_LINE(43)
	Float closestX;		HX_STACK_VAR(closestX,"closestX");
	HX_STACK_LINE(43)
	{
		HX_STACK_LINE(43)
		Float min = this->xMin;		HX_STACK_VAR(min,"min");
		HX_STACK_LINE(43)
		Float max = this->xMax;		HX_STACK_VAR(max,"max");
		HX_STACK_LINE(43)
		if (((px < min))){
			HX_STACK_LINE(43)
			closestX = min;
		}
		else{
			HX_STACK_LINE(43)
			if (((px > max))){
				HX_STACK_LINE(43)
				closestX = max;
			}
			else{
				HX_STACK_LINE(43)
				closestX = px;
			}
		}
	}
	HX_STACK_LINE(44)
	Float closestY;		HX_STACK_VAR(closestY,"closestY");
	HX_STACK_LINE(44)
	{
		HX_STACK_LINE(44)
		Float min = this->yMin;		HX_STACK_VAR(min,"min");
		HX_STACK_LINE(44)
		Float max = this->yMax;		HX_STACK_VAR(max,"max");
		HX_STACK_LINE(44)
		if (((py < min))){
			HX_STACK_LINE(44)
			closestY = min;
		}
		else{
			HX_STACK_LINE(44)
			if (((py > max))){
				HX_STACK_LINE(44)
				closestY = max;
			}
			else{
				HX_STACK_LINE(44)
				closestY = py;
			}
		}
	}
	HX_STACK_LINE(46)
	Float distX = (px - closestX);		HX_STACK_VAR(distX,"distX");
	HX_STACK_LINE(47)
	Float distY = (py - closestY);		HX_STACK_VAR(distY,"distY");
	HX_STACK_LINE(49)
	Float distSq = ((distX * distX) + (distY * distY));		HX_STACK_VAR(distSq,"distSq");
	HX_STACK_LINE(50)
	return (distSq < (r * r));
}


HX_DEFINE_DYNAMIC_FUNC3(Bounds_obj,testCircle,return )

Void Bounds_obj::add( ::h2d::col::Bounds b){
{
		HX_STACK_FRAME("h2d.col.Bounds","add",0x6a132cca,"h2d.col.Bounds.add","h2d/col/Bounds.hx",53,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(54)
		if (((b->xMin < this->xMin))){
			HX_STACK_LINE(54)
			this->xMin = b->xMin;
		}
		HX_STACK_LINE(55)
		if (((b->xMax > this->xMax))){
			HX_STACK_LINE(55)
			this->xMax = b->xMax;
		}
		HX_STACK_LINE(56)
		if (((b->yMin < this->yMin))){
			HX_STACK_LINE(56)
			this->yMin = b->yMin;
		}
		HX_STACK_LINE(57)
		if (((b->yMax > this->yMax))){
			HX_STACK_LINE(57)
			this->yMax = b->yMax;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,add,(void))

Void Bounds_obj::add4( Float x,Float y,Float w,Float h){
{
		HX_STACK_FRAME("h2d.col.Bounds","add4",0x66b4042a,"h2d.col.Bounds.add4","h2d/col/Bounds.hx",63,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(w,"w")
		HX_STACK_ARG(h,"h")
		HX_STACK_LINE(64)
		Float ixMin = x;		HX_STACK_VAR(ixMin,"ixMin");
		HX_STACK_LINE(65)
		Float iyMin = y;		HX_STACK_VAR(iyMin,"iyMin");
		HX_STACK_LINE(67)
		Float ixMax = (x + w);		HX_STACK_VAR(ixMax,"ixMax");
		HX_STACK_LINE(68)
		Float iyMax = (y + h);		HX_STACK_VAR(iyMax,"iyMax");
		HX_STACK_LINE(70)
		if (((ixMin < this->xMin))){
			HX_STACK_LINE(70)
			this->xMin = ixMin;
		}
		HX_STACK_LINE(71)
		if (((ixMax > this->xMax))){
			HX_STACK_LINE(71)
			this->xMax = ixMax;
		}
		HX_STACK_LINE(72)
		if (((iyMin < this->yMin))){
			HX_STACK_LINE(72)
			this->yMin = iyMin;
		}
		HX_STACK_LINE(73)
		if (((iyMax > this->yMax))){
			HX_STACK_LINE(73)
			this->yMax = iyMax;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Bounds_obj,add4,(void))

Void Bounds_obj::addPoint( ::h2d::col::Point p){
{
		HX_STACK_FRAME("h2d.col.Bounds","addPoint",0x02c15b26,"h2d.col.Bounds.addPoint","h2d/col/Bounds.hx",76,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(77)
		if (((p->x < this->xMin))){
			HX_STACK_LINE(77)
			this->xMin = p->x;
		}
		HX_STACK_LINE(78)
		if (((p->x > this->xMax))){
			HX_STACK_LINE(78)
			this->xMax = p->x;
		}
		HX_STACK_LINE(79)
		if (((p->y < this->yMin))){
			HX_STACK_LINE(79)
			this->yMin = p->y;
		}
		HX_STACK_LINE(80)
		if (((p->y > this->yMax))){
			HX_STACK_LINE(80)
			this->yMax = p->y;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,addPoint,(void))

Void Bounds_obj::addPoint2( Float px,Float py){
{
		HX_STACK_FRAME("h2d.col.Bounds","addPoint2",0x666e664c,"h2d.col.Bounds.addPoint2","h2d/col/Bounds.hx",83,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(px,"px")
		HX_STACK_ARG(py,"py")
		HX_STACK_LINE(84)
		if (((px < this->xMin))){
			HX_STACK_LINE(84)
			this->xMin = px;
		}
		HX_STACK_LINE(85)
		if (((px > this->xMax))){
			HX_STACK_LINE(85)
			this->xMax = px;
		}
		HX_STACK_LINE(86)
		if (((py < this->yMin))){
			HX_STACK_LINE(86)
			this->yMin = py;
		}
		HX_STACK_LINE(87)
		if (((py > this->yMax))){
			HX_STACK_LINE(87)
			this->yMax = py;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,addPoint2,(void))

Void Bounds_obj::setMin( ::h2d::col::Point p){
{
		HX_STACK_FRAME("h2d.col.Bounds","setMin",0x4f56b407,"h2d.col.Bounds.setMin","h2d/col/Bounds.hx",90,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(91)
		this->xMin = p->x;
		HX_STACK_LINE(92)
		this->yMin = p->y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,setMin,(void))

Void Bounds_obj::setMax( ::h2d::col::Point p){
{
		HX_STACK_FRAME("h2d.col.Bounds","setMax",0x4f56ad19,"h2d.col.Bounds.setMax","h2d/col/Bounds.hx",95,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(96)
		this->xMax = p->x;
		HX_STACK_LINE(97)
		this->yMax = p->y;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,setMax,(void))

Void Bounds_obj::load( ::h2d::col::Bounds b){
{
		HX_STACK_FRAME("h2d.col.Bounds","load",0x6e01b35d,"h2d.col.Bounds.load","h2d/col/Bounds.hx",100,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(101)
		this->xMin = b->xMin;
		HX_STACK_LINE(102)
		this->yMin = b->yMin;
		HX_STACK_LINE(103)
		this->xMax = b->xMax;
		HX_STACK_LINE(104)
		this->yMax = b->yMax;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,load,(void))

Void Bounds_obj::scaleCenter( Float v){
{
		HX_STACK_FRAME("h2d.col.Bounds","scaleCenter",0xbfd077a8,"h2d.col.Bounds.scaleCenter","h2d/col/Bounds.hx",107,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(108)
		Float dx = ((((this->xMax - this->xMin)) * 0.5) * v);		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(109)
		Float dy = ((((this->yMax - this->yMin)) * 0.5) * v);		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(110)
		Float mx = (((this->xMax + this->xMin)) * 0.5);		HX_STACK_VAR(mx,"mx");
		HX_STACK_LINE(111)
		Float my = (((this->yMax + this->yMin)) * 0.5);		HX_STACK_VAR(my,"my");
		HX_STACK_LINE(112)
		this->xMin = (mx - (dx * v));
		HX_STACK_LINE(113)
		this->yMin = (my - (dy * v));
		HX_STACK_LINE(114)
		this->xMax = (mx + (dx * v));
		HX_STACK_LINE(115)
		this->yMax = (my + (dy * v));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,scaleCenter,(void))

Void Bounds_obj::offset( Float dx,Float dy){
{
		HX_STACK_FRAME("h2d.col.Bounds","offset",0x402bac8a,"h2d.col.Bounds.offset","h2d/col/Bounds.hx",118,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_LINE(119)
		hx::AddEq(this->xMin,dx);
		HX_STACK_LINE(120)
		hx::AddEq(this->xMax,dx);
		HX_STACK_LINE(121)
		hx::AddEq(this->yMin,dy);
		HX_STACK_LINE(122)
		hx::AddEq(this->yMax,dy);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,offset,(void))

::h2d::col::Point Bounds_obj::getMin( ){
	HX_STACK_FRAME("h2d.col.Bounds","getMin",0x830e5f93,"h2d.col.Bounds.getMin","h2d/col/Bounds.hx",126,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(126)
	return ::h2d::col::Point_obj::__new(this->xMin,this->yMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getMin,return )

::h2d::col::Point Bounds_obj::getCenter( ){
	HX_STACK_FRAME("h2d.col.Bounds","getCenter",0x394dce74,"h2d.col.Bounds.getCenter","h2d/col/Bounds.hx",130,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(130)
	return ::h2d::col::Point_obj::__new((((this->xMin + this->xMax)) * 0.5),(((this->yMin + this->yMax)) * 0.5));
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getCenter,return )

::h2d::col::Point Bounds_obj::getSize( ){
	HX_STACK_FRAME("h2d.col.Bounds","getSize",0x2d7c93a0,"h2d.col.Bounds.getSize","h2d/col/Bounds.hx",134,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(134)
	return ::h2d::col::Point_obj::__new((this->xMax - this->xMin),(this->yMax - this->yMin));
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getSize,return )

::h2d::col::Point Bounds_obj::getMax( ){
	HX_STACK_FRAME("h2d.col.Bounds","getMax",0x830e58a5,"h2d.col.Bounds.getMax","h2d/col/Bounds.hx",138,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(138)
	return ::h2d::col::Point_obj::__new(this->xMax,this->yMax);
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getMax,return )

Void Bounds_obj::empty( ){
{
		HX_STACK_FRAME("h2d.col.Bounds","empty",0xca663176,"h2d.col.Bounds.empty","h2d/col/Bounds.hx",141,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_LINE(142)
		this->xMin = 1e20;
		HX_STACK_LINE(143)
		this->yMin = 1e20;
		HX_STACK_LINE(144)
		this->xMax = -1e20;
		HX_STACK_LINE(145)
		this->yMax = -1e20;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,empty,(void))

Void Bounds_obj::all( ){
{
		HX_STACK_FRAME("h2d.col.Bounds","all",0x6a1333ca,"h2d.col.Bounds.all","h2d/col/Bounds.hx",148,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_LINE(149)
		this->xMin = -1e20;
		HX_STACK_LINE(150)
		this->yMin = -1e20;
		HX_STACK_LINE(151)
		this->xMax = 1e20;
		HX_STACK_LINE(152)
		this->yMax = 1e20;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,all,(void))

::h2d::col::Bounds Bounds_obj::clone( ){
	HX_STACK_FRAME("h2d.col.Bounds","clone",0xa2ef0a46,"h2d.col.Bounds.clone","h2d/col/Bounds.hx",155,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(156)
	::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(157)
	b->xMin = this->xMin;
	HX_STACK_LINE(158)
	b->yMin = this->yMin;
	HX_STACK_LINE(159)
	b->xMax = this->xMax;
	HX_STACK_LINE(160)
	b->yMax = this->yMax;
	HX_STACK_LINE(161)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,clone,return )

Void Bounds_obj::translate( Float x,Float y){
{
		HX_STACK_FRAME("h2d.col.Bounds","translate",0x009bf6b7,"h2d.col.Bounds.translate","h2d/col/Bounds.hx",164,0x3d6ab3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(165)
		hx::AddEq(this->xMin,x);
		HX_STACK_LINE(166)
		hx::AddEq(this->xMax,x);
		HX_STACK_LINE(168)
		hx::AddEq(this->yMin,y);
		HX_STACK_LINE(169)
		hx::AddEq(this->yMax,y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,translate,(void))

::h2d::col::Bounds Bounds_obj::transform( ::h2d::Matrix m){
	HX_STACK_FRAME("h2d.col.Bounds","transform",0xfcaf4cd5,"h2d.col.Bounds.transform","h2d/col/Bounds.hx",175,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(177)
	::h2d::col::Point p0 = ::h2d::col::Point_obj::__new(this->xMin,this->yMin);		HX_STACK_VAR(p0,"p0");
	HX_STACK_LINE(178)
	::h2d::col::Point p1 = ::h2d::col::Point_obj::__new(this->xMin,this->yMax);		HX_STACK_VAR(p1,"p1");
	HX_STACK_LINE(179)
	::h2d::col::Point p2 = ::h2d::col::Point_obj::__new(this->xMax,this->yMin);		HX_STACK_VAR(p2,"p2");
	HX_STACK_LINE(180)
	::h2d::col::Point p3 = ::h2d::col::Point_obj::__new(this->xMax,this->yMax);		HX_STACK_VAR(p3,"p3");
	HX_STACK_LINE(182)
	{
		HX_STACK_LINE(182)
		::h2d::col::Point p;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(182)
		if (((p0 == null()))){
			HX_STACK_LINE(182)
			p = ::h2d::col::Point_obj::__new(null(),null());
		}
		else{
			HX_STACK_LINE(182)
			p = p0;
		}
		HX_STACK_LINE(182)
		Float px = p0->x;		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(182)
		Float py = p0->y;		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(182)
		p->x = (((px * m->a) + (py * m->c)) + m->tx);
		HX_STACK_LINE(182)
		p->y = (((px * m->b) + (py * m->d)) + m->ty);
		HX_STACK_LINE(182)
		p;
	}
	HX_STACK_LINE(183)
	{
		HX_STACK_LINE(183)
		::h2d::col::Point p;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(183)
		if (((p1 == null()))){
			HX_STACK_LINE(183)
			p = ::h2d::col::Point_obj::__new(null(),null());
		}
		else{
			HX_STACK_LINE(183)
			p = p1;
		}
		HX_STACK_LINE(183)
		Float px = p1->x;		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(183)
		Float py = p1->y;		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(183)
		p->x = (((px * m->a) + (py * m->c)) + m->tx);
		HX_STACK_LINE(183)
		p->y = (((px * m->b) + (py * m->d)) + m->ty);
		HX_STACK_LINE(183)
		p;
	}
	HX_STACK_LINE(184)
	{
		HX_STACK_LINE(184)
		::h2d::col::Point p;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(184)
		if (((p2 == null()))){
			HX_STACK_LINE(184)
			p = ::h2d::col::Point_obj::__new(null(),null());
		}
		else{
			HX_STACK_LINE(184)
			p = p2;
		}
		HX_STACK_LINE(184)
		Float px = p2->x;		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(184)
		Float py = p2->y;		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(184)
		p->x = (((px * m->a) + (py * m->c)) + m->tx);
		HX_STACK_LINE(184)
		p->y = (((px * m->b) + (py * m->d)) + m->ty);
		HX_STACK_LINE(184)
		p;
	}
	HX_STACK_LINE(185)
	{
		HX_STACK_LINE(185)
		::h2d::col::Point p;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(185)
		if (((p3 == null()))){
			HX_STACK_LINE(185)
			p = ::h2d::col::Point_obj::__new(null(),null());
		}
		else{
			HX_STACK_LINE(185)
			p = p3;
		}
		HX_STACK_LINE(185)
		Float px = p3->x;		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(185)
		Float py = p3->y;		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(185)
		p->x = (((px * m->a) + (py * m->c)) + m->tx);
		HX_STACK_LINE(185)
		p->y = (((px * m->b) + (py * m->d)) + m->ty);
		HX_STACK_LINE(185)
		p;
	}
	HX_STACK_LINE(187)
	{
		HX_STACK_LINE(187)
		this->xMin = p0->x;
		HX_STACK_LINE(187)
		this->yMin = p0->y;
	}
	HX_STACK_LINE(187)
	{
		HX_STACK_LINE(187)
		this->xMax = p0->x;
		HX_STACK_LINE(187)
		this->yMax = p0->y;
	}
	HX_STACK_LINE(189)
	{
		HX_STACK_LINE(189)
		if (((p1->x < this->xMin))){
			HX_STACK_LINE(189)
			this->xMin = p1->x;
		}
		HX_STACK_LINE(189)
		if (((p1->x > this->xMax))){
			HX_STACK_LINE(189)
			this->xMax = p1->x;
		}
		HX_STACK_LINE(189)
		if (((p1->y < this->yMin))){
			HX_STACK_LINE(189)
			this->yMin = p1->y;
		}
		HX_STACK_LINE(189)
		if (((p1->y > this->yMax))){
			HX_STACK_LINE(189)
			this->yMax = p1->y;
		}
	}
	HX_STACK_LINE(190)
	{
		HX_STACK_LINE(190)
		if (((p2->x < this->xMin))){
			HX_STACK_LINE(190)
			this->xMin = p2->x;
		}
		HX_STACK_LINE(190)
		if (((p2->x > this->xMax))){
			HX_STACK_LINE(190)
			this->xMax = p2->x;
		}
		HX_STACK_LINE(190)
		if (((p2->y < this->yMin))){
			HX_STACK_LINE(190)
			this->yMin = p2->y;
		}
		HX_STACK_LINE(190)
		if (((p2->y > this->yMax))){
			HX_STACK_LINE(190)
			this->yMax = p2->y;
		}
	}
	HX_STACK_LINE(191)
	{
		HX_STACK_LINE(191)
		if (((p3->x < this->xMin))){
			HX_STACK_LINE(191)
			this->xMin = p3->x;
		}
		HX_STACK_LINE(191)
		if (((p3->x > this->xMax))){
			HX_STACK_LINE(191)
			this->xMax = p3->x;
		}
		HX_STACK_LINE(191)
		if (((p3->y < this->yMin))){
			HX_STACK_LINE(191)
			this->yMin = p3->y;
		}
		HX_STACK_LINE(191)
		if (((p3->y > this->yMax))){
			HX_STACK_LINE(191)
			this->yMax = p3->y;
		}
	}
	HX_STACK_LINE(193)
	p0 = null();
	HX_STACK_LINE(193)
	p1 = null();
	HX_STACK_LINE(193)
	p2 = null();
	HX_STACK_LINE(193)
	p3 = null();
	HX_STACK_LINE(194)
	return hx::ObjectPtr<OBJ_>(this);
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,transform,return )

::String Bounds_obj::toString( ){
	HX_STACK_FRAME("h2d.col.Bounds","toString",0xfb435163,"h2d.col.Bounds.toString","h2d/col/Bounds.hx",197,0x3d6ab3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(198)
	::h2d::col::Point _g = ::h2d::col::Point_obj::__new(this->xMin,this->yMin);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(198)
	::String _g1 = ::Std_obj::string(_g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(198)
	::String _g2 = (HX_CSTRING("{") + _g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(198)
	::String _g3 = (_g2 + HX_CSTRING(","));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(198)
	::h2d::col::Point _g4 = ::h2d::col::Point_obj::__new(this->xMax,this->yMax);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(198)
	::String _g5 = ::Std_obj::string(_g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(198)
	::String _g6 = (_g3 + _g5);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(198)
	return (_g6 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,toString,return )

::h2d::col::Bounds Bounds_obj::fromValues( Float x,Float y,Float width,Float height){
	HX_STACK_FRAME("h2d.col.Bounds","fromValues",0x147a6563,"h2d.col.Bounds.fromValues","h2d/col/Bounds.hx",201,0x3d6ab3c5)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_LINE(202)
	::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(203)
	b->xMin = x;
	HX_STACK_LINE(204)
	b->yMin = y;
	HX_STACK_LINE(205)
	b->xMax = (x + width);
	HX_STACK_LINE(206)
	b->yMax = (y + height);
	HX_STACK_LINE(207)
	return b;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Bounds_obj,fromValues,return )

::h2d::col::Bounds Bounds_obj::fromPoints( ::h2d::col::Point min,::h2d::col::Point max){
	HX_STACK_FRAME("h2d.col.Bounds","fromPoints",0xbbf173a4,"h2d.col.Bounds.fromPoints","h2d/col/Bounds.hx",210,0x3d6ab3c5)
	HX_STACK_ARG(min,"min")
	HX_STACK_ARG(max,"max")
	HX_STACK_LINE(211)
	::h2d::col::Bounds b = ::h2d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(212)
	{
		HX_STACK_LINE(212)
		b->xMin = min->x;
		HX_STACK_LINE(212)
		b->yMin = min->y;
	}
	HX_STACK_LINE(213)
	{
		HX_STACK_LINE(213)
		b->xMax = max->x;
		HX_STACK_LINE(213)
		b->yMax = max->y;
	}
	HX_STACK_LINE(214)
	return b;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,fromPoints,return )


Bounds_obj::Bounds_obj()
{
}

Dynamic Bounds_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return inCallProp ? get_x() : x; }
		if (HX_FIELD_EQ(inName,"y") ) { return inCallProp ? get_y() : y; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"all") ) { return all_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"xMin") ) { return xMin; }
		if (HX_FIELD_EQ(inName,"yMin") ) { return yMin; }
		if (HX_FIELD_EQ(inName,"xMax") ) { return xMax; }
		if (HX_FIELD_EQ(inName,"yMax") ) { return yMax; }
		if (HX_FIELD_EQ(inName,"add4") ) { return add4_dyn(); }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return inCallProp ? get_width() : width; }
		if (HX_FIELD_EQ(inName,"get_x") ) { return get_x_dyn(); }
		if (HX_FIELD_EQ(inName,"get_y") ) { return get_y_dyn(); }
		if (HX_FIELD_EQ(inName,"empty") ) { return empty_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return inCallProp ? get_height() : height; }
		if (HX_FIELD_EQ(inName,"setMin") ) { return setMin_dyn(); }
		if (HX_FIELD_EQ(inName,"setMax") ) { return setMax_dyn(); }
		if (HX_FIELD_EQ(inName,"offset") ) { return offset_dyn(); }
		if (HX_FIELD_EQ(inName,"getMin") ) { return getMin_dyn(); }
		if (HX_FIELD_EQ(inName,"getMax") ) { return getMax_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getSize") ) { return getSize_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"collides") ) { return collides_dyn(); }
		if (HX_FIELD_EQ(inName,"includes") ) { return includes_dyn(); }
		if (HX_FIELD_EQ(inName,"addPoint") ) { return addPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"get_width") ) { return get_width_dyn(); }
		if (HX_FIELD_EQ(inName,"includes2") ) { return includes2_dyn(); }
		if (HX_FIELD_EQ(inName,"addPoint2") ) { return addPoint2_dyn(); }
		if (HX_FIELD_EQ(inName,"getCenter") ) { return getCenter_dyn(); }
		if (HX_FIELD_EQ(inName,"translate") ) { return translate_dyn(); }
		if (HX_FIELD_EQ(inName,"transform") ) { return transform_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromValues") ) { return fromValues_dyn(); }
		if (HX_FIELD_EQ(inName,"fromPoints") ) { return fromPoints_dyn(); }
		if (HX_FIELD_EQ(inName,"get_height") ) { return get_height_dyn(); }
		if (HX_FIELD_EQ(inName,"testCircle") ) { return testCircle_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"scaleCenter") ) { return scaleCenter_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Bounds_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"xMin") ) { xMin=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"yMin") ) { yMin=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"xMax") ) { xMax=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"yMax") ) { yMax=inValue.Cast< Float >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Bounds_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("xMin"));
	outFields->push(HX_CSTRING("yMin"));
	outFields->push(HX_CSTRING("xMax"));
	outFields->push(HX_CSTRING("yMax"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromValues"),
	HX_CSTRING("fromPoints"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Bounds_obj,xMin),HX_CSTRING("xMin")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,yMin),HX_CSTRING("yMin")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,xMax),HX_CSTRING("xMax")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,yMax),HX_CSTRING("yMax")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,width),HX_CSTRING("width")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,height),HX_CSTRING("height")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("xMin"),
	HX_CSTRING("yMin"),
	HX_CSTRING("xMax"),
	HX_CSTRING("yMax"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("get_x"),
	HX_CSTRING("get_y"),
	HX_CSTRING("get_width"),
	HX_CSTRING("get_height"),
	HX_CSTRING("collides"),
	HX_CSTRING("includes"),
	HX_CSTRING("includes2"),
	HX_CSTRING("testCircle"),
	HX_CSTRING("add"),
	HX_CSTRING("add4"),
	HX_CSTRING("addPoint"),
	HX_CSTRING("addPoint2"),
	HX_CSTRING("setMin"),
	HX_CSTRING("setMax"),
	HX_CSTRING("load"),
	HX_CSTRING("scaleCenter"),
	HX_CSTRING("offset"),
	HX_CSTRING("getMin"),
	HX_CSTRING("getCenter"),
	HX_CSTRING("getSize"),
	HX_CSTRING("getMax"),
	HX_CSTRING("empty"),
	HX_CSTRING("all"),
	HX_CSTRING("clone"),
	HX_CSTRING("translate"),
	HX_CSTRING("transform"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Bounds_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Bounds_obj::__mClass,"__mClass");
};

#endif

Class Bounds_obj::__mClass;

void Bounds_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.col.Bounds"), hx::TCanCast< Bounds_obj> ,sStaticFields,sMemberFields,
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

void Bounds_obj::__boot()
{
}

} // end namespace h2d
} // end namespace col
