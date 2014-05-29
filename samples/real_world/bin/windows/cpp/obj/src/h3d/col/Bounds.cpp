#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_col_Bounds
#include <h3d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_col_Plane
#include <h3d/col/Plane.h>
#endif
#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
namespace h3d{
namespace col{

Void Bounds_obj::__construct()
{
HX_STACK_FRAME("h3d.col.Bounds","new",0xed10dd0a,"h3d.col.Bounds.new","h3d/col/Bounds.hx",14,0x049adce4)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(14)
	this->xMin = 1e20;
	HX_STACK_LINE(14)
	this->xMax = -1e20;
	HX_STACK_LINE(14)
	this->yMin = 1e20;
	HX_STACK_LINE(14)
	this->yMax = -1e20;
	HX_STACK_LINE(14)
	this->zMin = 1e20;
	HX_STACK_LINE(14)
	this->zMax = -1e20;
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

bool Bounds_obj::inFrustum( ::h3d::Matrix mvp){
	HX_STACK_FRAME("h3d.col.Bounds","inFrustum",0xedcb7227,"h3d.col.Bounds.inFrustum","h3d/col/Bounds.hx",17,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(mvp,"mvp")
	HX_STACK_LINE(20)
	Float _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(20)
	{
		HX_STACK_LINE(20)
		Float p_nx = (mvp->_14 + mvp->_11);		HX_STACK_VAR(p_nx,"p_nx");
		HX_STACK_LINE(20)
		Float p_ny = (mvp->_24 + mvp->_21);		HX_STACK_VAR(p_ny,"p_ny");
		HX_STACK_LINE(20)
		Float p_nz = (mvp->_34 + mvp->_31);		HX_STACK_VAR(p_nz,"p_nz");
		HX_STACK_LINE(20)
		Float p_d = -(((mvp->_44 + mvp->_41)));		HX_STACK_VAR(p_d,"p_d");
		HX_STACK_LINE(20)
		Float a = p_nx;		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(20)
		Float b = p_ny;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(20)
		Float c = p_nz;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(20)
		Float dd = (((a * ((this->xMax + this->xMin))) + (b * ((this->yMax + this->yMin)))) + (c * ((this->zMax + this->zMin))));		HX_STACK_VAR(dd,"dd");
		HX_STACK_LINE(20)
		if (((a < (int)0))){
			HX_STACK_LINE(20)
			a = -(a);
		}
		HX_STACK_LINE(20)
		if (((b < (int)0))){
			HX_STACK_LINE(20)
			b = -(b);
		}
		HX_STACK_LINE(20)
		if (((c < (int)0))){
			HX_STACK_LINE(20)
			c = -(c);
		}
		HX_STACK_LINE(20)
		Float rr = (((a * ((this->xMax - this->xMin))) + (b * ((this->yMax - this->yMin)))) + (c * ((this->zMax - this->zMin))));		HX_STACK_VAR(rr,"rr");
		HX_STACK_LINE(20)
		_g = ((dd + rr) - (p_d * (int)2));
	}
	HX_STACK_LINE(20)
	if (((_g < (int)0))){
		HX_STACK_LINE(21)
		return false;
	}
	HX_STACK_LINE(24)
	Float _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(24)
	{
		HX_STACK_LINE(24)
		Float p_nx = (mvp->_14 - mvp->_11);		HX_STACK_VAR(p_nx,"p_nx");
		HX_STACK_LINE(24)
		Float p_ny = (mvp->_24 - mvp->_21);		HX_STACK_VAR(p_ny,"p_ny");
		HX_STACK_LINE(24)
		Float p_nz = (mvp->_34 - mvp->_31);		HX_STACK_VAR(p_nz,"p_nz");
		HX_STACK_LINE(24)
		Float p_d = (mvp->_41 - mvp->_44);		HX_STACK_VAR(p_d,"p_d");
		HX_STACK_LINE(24)
		Float a = p_nx;		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(24)
		Float b = p_ny;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(24)
		Float c = p_nz;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(24)
		Float dd = (((a * ((this->xMax + this->xMin))) + (b * ((this->yMax + this->yMin)))) + (c * ((this->zMax + this->zMin))));		HX_STACK_VAR(dd,"dd");
		HX_STACK_LINE(24)
		if (((a < (int)0))){
			HX_STACK_LINE(24)
			a = -(a);
		}
		HX_STACK_LINE(24)
		if (((b < (int)0))){
			HX_STACK_LINE(24)
			b = -(b);
		}
		HX_STACK_LINE(24)
		if (((c < (int)0))){
			HX_STACK_LINE(24)
			c = -(c);
		}
		HX_STACK_LINE(24)
		Float rr = (((a * ((this->xMax - this->xMin))) + (b * ((this->yMax - this->yMin)))) + (c * ((this->zMax - this->zMin))));		HX_STACK_VAR(rr,"rr");
		HX_STACK_LINE(24)
		_g1 = ((dd + rr) - (p_d * (int)2));
	}
	HX_STACK_LINE(24)
	if (((_g1 < (int)0))){
		HX_STACK_LINE(25)
		return false;
	}
	HX_STACK_LINE(28)
	Float _g2;		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(28)
	{
		HX_STACK_LINE(28)
		Float p_nx = (mvp->_14 + mvp->_12);		HX_STACK_VAR(p_nx,"p_nx");
		HX_STACK_LINE(28)
		Float p_ny = (mvp->_24 + mvp->_22);		HX_STACK_VAR(p_ny,"p_ny");
		HX_STACK_LINE(28)
		Float p_nz = (mvp->_34 + mvp->_32);		HX_STACK_VAR(p_nz,"p_nz");
		HX_STACK_LINE(28)
		Float p_d = -(((mvp->_44 + mvp->_42)));		HX_STACK_VAR(p_d,"p_d");
		HX_STACK_LINE(28)
		Float a = p_nx;		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(28)
		Float b = p_ny;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(28)
		Float c = p_nz;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(28)
		Float dd = (((a * ((this->xMax + this->xMin))) + (b * ((this->yMax + this->yMin)))) + (c * ((this->zMax + this->zMin))));		HX_STACK_VAR(dd,"dd");
		HX_STACK_LINE(28)
		if (((a < (int)0))){
			HX_STACK_LINE(28)
			a = -(a);
		}
		HX_STACK_LINE(28)
		if (((b < (int)0))){
			HX_STACK_LINE(28)
			b = -(b);
		}
		HX_STACK_LINE(28)
		if (((c < (int)0))){
			HX_STACK_LINE(28)
			c = -(c);
		}
		HX_STACK_LINE(28)
		Float rr = (((a * ((this->xMax - this->xMin))) + (b * ((this->yMax - this->yMin)))) + (c * ((this->zMax - this->zMin))));		HX_STACK_VAR(rr,"rr");
		HX_STACK_LINE(28)
		_g2 = ((dd + rr) - (p_d * (int)2));
	}
	HX_STACK_LINE(28)
	if (((_g2 < (int)0))){
		HX_STACK_LINE(29)
		return false;
	}
	HX_STACK_LINE(32)
	Float _g3;		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(32)
	{
		HX_STACK_LINE(32)
		Float p_nx = (mvp->_14 - mvp->_12);		HX_STACK_VAR(p_nx,"p_nx");
		HX_STACK_LINE(32)
		Float p_ny = (mvp->_24 - mvp->_22);		HX_STACK_VAR(p_ny,"p_ny");
		HX_STACK_LINE(32)
		Float p_nz = (mvp->_34 - mvp->_32);		HX_STACK_VAR(p_nz,"p_nz");
		HX_STACK_LINE(32)
		Float p_d = (mvp->_42 - mvp->_44);		HX_STACK_VAR(p_d,"p_d");
		HX_STACK_LINE(32)
		Float a = p_nx;		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(32)
		Float b = p_ny;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(32)
		Float c = p_nz;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(32)
		Float dd = (((a * ((this->xMax + this->xMin))) + (b * ((this->yMax + this->yMin)))) + (c * ((this->zMax + this->zMin))));		HX_STACK_VAR(dd,"dd");
		HX_STACK_LINE(32)
		if (((a < (int)0))){
			HX_STACK_LINE(32)
			a = -(a);
		}
		HX_STACK_LINE(32)
		if (((b < (int)0))){
			HX_STACK_LINE(32)
			b = -(b);
		}
		HX_STACK_LINE(32)
		if (((c < (int)0))){
			HX_STACK_LINE(32)
			c = -(c);
		}
		HX_STACK_LINE(32)
		Float rr = (((a * ((this->xMax - this->xMin))) + (b * ((this->yMax - this->yMin)))) + (c * ((this->zMax - this->zMin))));		HX_STACK_VAR(rr,"rr");
		HX_STACK_LINE(32)
		_g3 = ((dd + rr) - (p_d * (int)2));
	}
	HX_STACK_LINE(32)
	if (((_g3 < (int)0))){
		HX_STACK_LINE(33)
		return false;
	}
	HX_STACK_LINE(36)
	Float _g4;		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(36)
	{
		HX_STACK_LINE(36)
		Float p_nx = mvp->_13;		HX_STACK_VAR(p_nx,"p_nx");
		HX_STACK_LINE(36)
		Float p_ny = mvp->_23;		HX_STACK_VAR(p_ny,"p_ny");
		HX_STACK_LINE(36)
		Float p_nz = mvp->_33;		HX_STACK_VAR(p_nz,"p_nz");
		HX_STACK_LINE(36)
		Float p_d = -(mvp->_43);		HX_STACK_VAR(p_d,"p_d");
		HX_STACK_LINE(36)
		Float a = p_nx;		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(36)
		Float b = p_ny;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(36)
		Float c = p_nz;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(36)
		Float dd = (((a * ((this->xMax + this->xMin))) + (b * ((this->yMax + this->yMin)))) + (c * ((this->zMax + this->zMin))));		HX_STACK_VAR(dd,"dd");
		HX_STACK_LINE(36)
		if (((a < (int)0))){
			HX_STACK_LINE(36)
			a = -(a);
		}
		HX_STACK_LINE(36)
		if (((b < (int)0))){
			HX_STACK_LINE(36)
			b = -(b);
		}
		HX_STACK_LINE(36)
		if (((c < (int)0))){
			HX_STACK_LINE(36)
			c = -(c);
		}
		HX_STACK_LINE(36)
		Float rr = (((a * ((this->xMax - this->xMin))) + (b * ((this->yMax - this->yMin)))) + (c * ((this->zMax - this->zMin))));		HX_STACK_VAR(rr,"rr");
		HX_STACK_LINE(36)
		_g4 = ((dd + rr) - (p_d * (int)2));
	}
	HX_STACK_LINE(36)
	if (((_g4 < (int)0))){
		HX_STACK_LINE(37)
		return false;
	}
	HX_STACK_LINE(40)
	Float _g5;		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(40)
	{
		HX_STACK_LINE(40)
		Float p_nx = (mvp->_14 - mvp->_13);		HX_STACK_VAR(p_nx,"p_nx");
		HX_STACK_LINE(40)
		Float p_ny = (mvp->_24 - mvp->_23);		HX_STACK_VAR(p_ny,"p_ny");
		HX_STACK_LINE(40)
		Float p_nz = (mvp->_34 - mvp->_33);		HX_STACK_VAR(p_nz,"p_nz");
		HX_STACK_LINE(40)
		Float p_d = (mvp->_43 - mvp->_44);		HX_STACK_VAR(p_d,"p_d");
		HX_STACK_LINE(40)
		Float a = p_nx;		HX_STACK_VAR(a,"a");
		HX_STACK_LINE(40)
		Float b = p_ny;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(40)
		Float c = p_nz;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(40)
		Float dd = (((a * ((this->xMax + this->xMin))) + (b * ((this->yMax + this->yMin)))) + (c * ((this->zMax + this->zMin))));		HX_STACK_VAR(dd,"dd");
		HX_STACK_LINE(40)
		if (((a < (int)0))){
			HX_STACK_LINE(40)
			a = -(a);
		}
		HX_STACK_LINE(40)
		if (((b < (int)0))){
			HX_STACK_LINE(40)
			b = -(b);
		}
		HX_STACK_LINE(40)
		if (((c < (int)0))){
			HX_STACK_LINE(40)
			c = -(c);
		}
		HX_STACK_LINE(40)
		Float rr = (((a * ((this->xMax - this->xMin))) + (b * ((this->yMax - this->yMin)))) + (c * ((this->zMax - this->zMin))));		HX_STACK_VAR(rr,"rr");
		HX_STACK_LINE(40)
		_g5 = ((dd + rr) - (p_d * (int)2));
	}
	HX_STACK_LINE(40)
	if (((_g5 < (int)0))){
		HX_STACK_LINE(41)
		return false;
	}
	HX_STACK_LINE(43)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,inFrustum,return )

Float Bounds_obj::testPlane( ::h3d::col::Plane p){
	HX_STACK_FRAME("h3d.col.Bounds","testPlane",0xc4df24d4,"h3d.col.Bounds.testPlane","h3d/col/Bounds.hx",46,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(47)
	Float a = p->nx;		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(48)
	Float b = p->ny;		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(49)
	Float c = p->nz;		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(50)
	Float dd = (((a * ((this->xMax + this->xMin))) + (b * ((this->yMax + this->yMin)))) + (c * ((this->zMax + this->zMin))));		HX_STACK_VAR(dd,"dd");
	HX_STACK_LINE(51)
	if (((a < (int)0))){
		HX_STACK_LINE(51)
		a = -(a);
	}
	HX_STACK_LINE(52)
	if (((b < (int)0))){
		HX_STACK_LINE(52)
		b = -(b);
	}
	HX_STACK_LINE(53)
	if (((c < (int)0))){
		HX_STACK_LINE(53)
		c = -(c);
	}
	HX_STACK_LINE(54)
	Float rr = (((a * ((this->xMax - this->xMin))) + (b * ((this->yMax - this->yMin)))) + (c * ((this->zMax - this->zMin))));		HX_STACK_VAR(rr,"rr");
	HX_STACK_LINE(55)
	return ((dd + rr) - (p->d * (int)2));
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,testPlane,return )

int Bounds_obj::inFrustumDetails( ::h3d::Matrix mvp,hx::Null< bool >  __o_checkZ){
bool checkZ = __o_checkZ.Default(true);
	HX_STACK_FRAME("h3d.col.Bounds","inFrustumDetails",0xd7be355b,"h3d.col.Bounds.inFrustumDetails","h3d/col/Bounds.hx",63,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(mvp,"mvp")
	HX_STACK_ARG(checkZ,"checkZ")
{
		HX_STACK_LINE(64)
		int ret = (int)1;		HX_STACK_VAR(ret,"ret");
		HX_STACK_LINE(67)
		Float p_nx = (mvp->_14 + mvp->_11);		HX_STACK_VAR(p_nx,"p_nx");
		HX_STACK_LINE(67)
		Float p_ny = (mvp->_24 + mvp->_21);		HX_STACK_VAR(p_ny,"p_ny");
		HX_STACK_LINE(67)
		Float p_nz = (mvp->_34 + mvp->_31);		HX_STACK_VAR(p_nz,"p_nz");
		HX_STACK_LINE(67)
		Float p_d = (mvp->_44 + mvp->_41);		HX_STACK_VAR(p_d,"p_d");
		HX_STACK_LINE(68)
		Float m;		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(68)
		m = (((p_nx * ((  (((p_nx > (int)0))) ? Float(this->xMax) : Float(this->xMin) ))) + (p_ny * ((  (((p_ny > (int)0))) ? Float(this->yMax) : Float(this->yMin) )))) + (p_nz * ((  (((p_nz > (int)0))) ? Float(this->zMax) : Float(this->zMin) ))));
		HX_STACK_LINE(69)
		if ((((m + p_d) < (int)0))){
			HX_STACK_LINE(70)
			return (int)-1;
		}
		HX_STACK_LINE(71)
		Float n;		HX_STACK_VAR(n,"n");
		HX_STACK_LINE(71)
		n = (((p_nx * ((  (((p_nx > (int)0))) ? Float(this->xMin) : Float(this->xMax) ))) + (p_ny * ((  (((p_ny > (int)0))) ? Float(this->yMin) : Float(this->yMax) )))) + (p_nz * ((  (((p_nz > (int)0))) ? Float(this->zMin) : Float(this->zMax) ))));
		HX_STACK_LINE(72)
		if ((((n + p_d) < (int)0))){
			HX_STACK_LINE(72)
			ret = (int)0;
		}
		HX_STACK_LINE(74)
		Float p_nx1 = (mvp->_14 - mvp->_11);		HX_STACK_VAR(p_nx1,"p_nx1");
		HX_STACK_LINE(74)
		Float p_ny1 = (mvp->_24 - mvp->_21);		HX_STACK_VAR(p_ny1,"p_ny1");
		HX_STACK_LINE(74)
		Float p_nz1 = (mvp->_34 - mvp->_31);		HX_STACK_VAR(p_nz1,"p_nz1");
		HX_STACK_LINE(74)
		Float p_d1 = (mvp->_44 - mvp->_41);		HX_STACK_VAR(p_d1,"p_d1");
		HX_STACK_LINE(75)
		Float m1;		HX_STACK_VAR(m1,"m1");
		HX_STACK_LINE(75)
		m1 = (((p_nx1 * ((  (((p_nx1 > (int)0))) ? Float(this->xMax) : Float(this->xMin) ))) + (p_ny1 * ((  (((p_ny1 > (int)0))) ? Float(this->yMax) : Float(this->yMin) )))) + (p_nz1 * ((  (((p_nz1 > (int)0))) ? Float(this->zMax) : Float(this->zMin) ))));
		HX_STACK_LINE(76)
		if ((((m1 + p_d1) < (int)0))){
			HX_STACK_LINE(77)
			return (int)-1;
		}
		HX_STACK_LINE(78)
		Float n1;		HX_STACK_VAR(n1,"n1");
		HX_STACK_LINE(78)
		n1 = (((p_nx1 * ((  (((p_nx1 > (int)0))) ? Float(this->xMin) : Float(this->xMax) ))) + (p_ny1 * ((  (((p_ny1 > (int)0))) ? Float(this->yMin) : Float(this->yMax) )))) + (p_nz1 * ((  (((p_nz1 > (int)0))) ? Float(this->zMin) : Float(this->zMax) ))));
		HX_STACK_LINE(79)
		if ((((n1 + p_d1) < (int)0))){
			HX_STACK_LINE(79)
			ret = (int)0;
		}
		HX_STACK_LINE(81)
		Float p_nx2 = (mvp->_14 + mvp->_12);		HX_STACK_VAR(p_nx2,"p_nx2");
		HX_STACK_LINE(81)
		Float p_ny2 = (mvp->_24 + mvp->_22);		HX_STACK_VAR(p_ny2,"p_ny2");
		HX_STACK_LINE(81)
		Float p_nz2 = (mvp->_34 + mvp->_32);		HX_STACK_VAR(p_nz2,"p_nz2");
		HX_STACK_LINE(81)
		Float p_d2 = (mvp->_44 + mvp->_42);		HX_STACK_VAR(p_d2,"p_d2");
		HX_STACK_LINE(82)
		Float m2;		HX_STACK_VAR(m2,"m2");
		HX_STACK_LINE(82)
		m2 = (((p_nx2 * ((  (((p_nx2 > (int)0))) ? Float(this->xMax) : Float(this->xMin) ))) + (p_ny2 * ((  (((p_ny2 > (int)0))) ? Float(this->yMax) : Float(this->yMin) )))) + (p_nz2 * ((  (((p_nz2 > (int)0))) ? Float(this->zMax) : Float(this->zMin) ))));
		HX_STACK_LINE(83)
		if ((((m2 + p_d2) < (int)0))){
			HX_STACK_LINE(84)
			return (int)-1;
		}
		HX_STACK_LINE(85)
		Float n2;		HX_STACK_VAR(n2,"n2");
		HX_STACK_LINE(85)
		n2 = (((p_nx2 * ((  (((p_nx2 > (int)0))) ? Float(this->xMin) : Float(this->xMax) ))) + (p_ny2 * ((  (((p_ny2 > (int)0))) ? Float(this->yMin) : Float(this->yMax) )))) + (p_nz2 * ((  (((p_nz2 > (int)0))) ? Float(this->zMin) : Float(this->zMax) ))));
		HX_STACK_LINE(86)
		if ((((n2 + p_d2) < (int)0))){
			HX_STACK_LINE(86)
			ret = (int)0;
		}
		HX_STACK_LINE(89)
		Float p_nx3 = (mvp->_14 - mvp->_12);		HX_STACK_VAR(p_nx3,"p_nx3");
		HX_STACK_LINE(89)
		Float p_ny3 = (mvp->_24 - mvp->_22);		HX_STACK_VAR(p_ny3,"p_ny3");
		HX_STACK_LINE(89)
		Float p_nz3 = (mvp->_34 - mvp->_32);		HX_STACK_VAR(p_nz3,"p_nz3");
		HX_STACK_LINE(89)
		Float p_d3 = (mvp->_44 - mvp->_42);		HX_STACK_VAR(p_d3,"p_d3");
		HX_STACK_LINE(90)
		Float m3;		HX_STACK_VAR(m3,"m3");
		HX_STACK_LINE(90)
		m3 = (((p_nx3 * ((  (((p_nx3 > (int)0))) ? Float(this->xMax) : Float(this->xMin) ))) + (p_ny3 * ((  (((p_ny3 > (int)0))) ? Float(this->yMax) : Float(this->yMin) )))) + (p_nz3 * ((  (((p_nz3 > (int)0))) ? Float(this->zMax) : Float(this->zMin) ))));
		HX_STACK_LINE(91)
		if ((((m3 + p_d3) < (int)0))){
			HX_STACK_LINE(92)
			return (int)-1;
		}
		HX_STACK_LINE(93)
		Float n3;		HX_STACK_VAR(n3,"n3");
		HX_STACK_LINE(93)
		n3 = (((p_nx3 * ((  (((p_nx3 > (int)0))) ? Float(this->xMin) : Float(this->xMax) ))) + (p_ny3 * ((  (((p_ny3 > (int)0))) ? Float(this->yMin) : Float(this->yMax) )))) + (p_nz3 * ((  (((p_nz3 > (int)0))) ? Float(this->zMin) : Float(this->zMax) ))));
		HX_STACK_LINE(94)
		if ((((n3 + p_d3) < (int)0))){
			HX_STACK_LINE(94)
			ret = (int)0;
		}
		HX_STACK_LINE(96)
		if ((checkZ)){
			HX_STACK_LINE(98)
			Float p_nx4 = mvp->_13;		HX_STACK_VAR(p_nx4,"p_nx4");
			HX_STACK_LINE(98)
			Float p_ny4 = mvp->_23;		HX_STACK_VAR(p_ny4,"p_ny4");
			HX_STACK_LINE(98)
			Float p_nz4 = mvp->_33;		HX_STACK_VAR(p_nz4,"p_nz4");
			HX_STACK_LINE(98)
			Float p_d4 = mvp->_43;		HX_STACK_VAR(p_d4,"p_d4");
			HX_STACK_LINE(99)
			Float m4;		HX_STACK_VAR(m4,"m4");
			HX_STACK_LINE(99)
			m4 = (((p_nx4 * ((  (((p_nx4 > (int)0))) ? Float(this->xMax) : Float(this->xMin) ))) + (p_ny4 * ((  (((p_ny4 > (int)0))) ? Float(this->yMax) : Float(this->yMin) )))) + (p_nz4 * ((  (((p_nz4 > (int)0))) ? Float(this->zMax) : Float(this->zMin) ))));
			HX_STACK_LINE(100)
			if ((((m4 + p_d4) < (int)0))){
				HX_STACK_LINE(101)
				return (int)-1;
			}
			HX_STACK_LINE(102)
			Float n4;		HX_STACK_VAR(n4,"n4");
			HX_STACK_LINE(102)
			n4 = (((p_nx4 * ((  (((p_nx4 > (int)0))) ? Float(this->xMin) : Float(this->xMax) ))) + (p_ny4 * ((  (((p_ny4 > (int)0))) ? Float(this->yMin) : Float(this->yMax) )))) + (p_nz4 * ((  (((p_nz4 > (int)0))) ? Float(this->zMin) : Float(this->zMax) ))));
			HX_STACK_LINE(103)
			if ((((n4 + p_d4) < (int)0))){
				HX_STACK_LINE(103)
				ret = (int)0;
			}
			HX_STACK_LINE(105)
			Float p_nx5 = (mvp->_14 - mvp->_13);		HX_STACK_VAR(p_nx5,"p_nx5");
			HX_STACK_LINE(105)
			Float p_ny5 = (mvp->_24 - mvp->_23);		HX_STACK_VAR(p_ny5,"p_ny5");
			HX_STACK_LINE(105)
			Float p_nz5 = (mvp->_34 - mvp->_33);		HX_STACK_VAR(p_nz5,"p_nz5");
			HX_STACK_LINE(105)
			Float p_d5 = (mvp->_44 - mvp->_43);		HX_STACK_VAR(p_d5,"p_d5");
			HX_STACK_LINE(106)
			Float m5;		HX_STACK_VAR(m5,"m5");
			HX_STACK_LINE(106)
			m5 = (((p_nx5 * ((  (((p_nx5 > (int)0))) ? Float(this->xMax) : Float(this->xMin) ))) + (p_ny5 * ((  (((p_ny5 > (int)0))) ? Float(this->yMax) : Float(this->yMin) )))) + (p_nz5 * ((  (((p_nz5 > (int)0))) ? Float(this->zMax) : Float(this->zMin) ))));
			HX_STACK_LINE(107)
			if ((((m5 + p_d5) < (int)0))){
				HX_STACK_LINE(108)
				return (int)-1;
			}
			HX_STACK_LINE(109)
			Float n5;		HX_STACK_VAR(n5,"n5");
			HX_STACK_LINE(109)
			n5 = (((p_nx5 * ((  (((p_nx5 > (int)0))) ? Float(this->xMin) : Float(this->xMax) ))) + (p_ny5 * ((  (((p_ny5 > (int)0))) ? Float(this->yMin) : Float(this->yMax) )))) + (p_nz5 * ((  (((p_nz5 > (int)0))) ? Float(this->zMin) : Float(this->zMax) ))));
			HX_STACK_LINE(110)
			if ((((n5 + p_d5) < (int)0))){
				HX_STACK_LINE(110)
				ret = (int)0;
			}
		}
		HX_STACK_LINE(113)
		return ret;
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,inFrustumDetails,return )

Void Bounds_obj::transform3x4( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.col.Bounds","transform3x4",0x812627d9,"h3d.col.Bounds.transform3x4","h3d/col/Bounds.hx",116,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(117)
		Float xMin = this->xMin;		HX_STACK_VAR(xMin,"xMin");
		HX_STACK_LINE(117)
		Float yMin = this->yMin;		HX_STACK_VAR(yMin,"yMin");
		HX_STACK_LINE(117)
		Float zMin = this->zMin;		HX_STACK_VAR(zMin,"zMin");
		HX_STACK_LINE(117)
		Float xMax = this->xMax;		HX_STACK_VAR(xMax,"xMax");
		HX_STACK_LINE(117)
		Float yMax = this->yMax;		HX_STACK_VAR(yMax,"yMax");
		HX_STACK_LINE(117)
		Float zMax = this->zMax;		HX_STACK_VAR(zMax,"zMax");
		HX_STACK_LINE(118)
		{
			HX_STACK_LINE(118)
			this->xMin = 1e20;
			HX_STACK_LINE(118)
			this->xMax = -1e20;
			HX_STACK_LINE(118)
			this->yMin = 1e20;
			HX_STACK_LINE(118)
			this->yMax = -1e20;
			HX_STACK_LINE(118)
			this->zMin = 1e20;
			HX_STACK_LINE(118)
			this->zMax = -1e20;
		}
		HX_STACK_LINE(119)
		::h3d::col::Point v = ::h3d::col::Point_obj::__new(null(),null(),null());		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(120)
		{
			HX_STACK_LINE(120)
			v->x = xMin;
			HX_STACK_LINE(120)
			v->y = yMin;
			HX_STACK_LINE(120)
			v->z = zMin;
		}
		HX_STACK_LINE(121)
		{
			HX_STACK_LINE(121)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(121)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(121)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(121)
			v->x = px;
			HX_STACK_LINE(121)
			v->y = py;
			HX_STACK_LINE(121)
			v->z = pz;
		}
		HX_STACK_LINE(122)
		{
			HX_STACK_LINE(122)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(122)
				this->xMin = v->x;
			}
			HX_STACK_LINE(122)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(122)
				this->xMax = v->x;
			}
			HX_STACK_LINE(122)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(122)
				this->yMin = v->y;
			}
			HX_STACK_LINE(122)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(122)
				this->yMax = v->y;
			}
			HX_STACK_LINE(122)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(122)
				this->zMin = v->z;
			}
			HX_STACK_LINE(122)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(122)
				this->zMax = v->z;
			}
		}
		HX_STACK_LINE(123)
		{
			HX_STACK_LINE(123)
			v->x = xMin;
			HX_STACK_LINE(123)
			v->y = yMin;
			HX_STACK_LINE(123)
			v->z = zMax;
		}
		HX_STACK_LINE(124)
		{
			HX_STACK_LINE(124)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(124)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(124)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(124)
			v->x = px;
			HX_STACK_LINE(124)
			v->y = py;
			HX_STACK_LINE(124)
			v->z = pz;
		}
		HX_STACK_LINE(125)
		{
			HX_STACK_LINE(125)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(125)
				this->xMin = v->x;
			}
			HX_STACK_LINE(125)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(125)
				this->xMax = v->x;
			}
			HX_STACK_LINE(125)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(125)
				this->yMin = v->y;
			}
			HX_STACK_LINE(125)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(125)
				this->yMax = v->y;
			}
			HX_STACK_LINE(125)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(125)
				this->zMin = v->z;
			}
			HX_STACK_LINE(125)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(125)
				this->zMax = v->z;
			}
		}
		HX_STACK_LINE(126)
		{
			HX_STACK_LINE(126)
			v->x = xMin;
			HX_STACK_LINE(126)
			v->y = yMax;
			HX_STACK_LINE(126)
			v->z = zMin;
		}
		HX_STACK_LINE(127)
		{
			HX_STACK_LINE(127)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(127)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(127)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(127)
			v->x = px;
			HX_STACK_LINE(127)
			v->y = py;
			HX_STACK_LINE(127)
			v->z = pz;
		}
		HX_STACK_LINE(128)
		{
			HX_STACK_LINE(128)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(128)
				this->xMin = v->x;
			}
			HX_STACK_LINE(128)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(128)
				this->xMax = v->x;
			}
			HX_STACK_LINE(128)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(128)
				this->yMin = v->y;
			}
			HX_STACK_LINE(128)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(128)
				this->yMax = v->y;
			}
			HX_STACK_LINE(128)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(128)
				this->zMin = v->z;
			}
			HX_STACK_LINE(128)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(128)
				this->zMax = v->z;
			}
		}
		HX_STACK_LINE(129)
		{
			HX_STACK_LINE(129)
			v->x = xMin;
			HX_STACK_LINE(129)
			v->y = yMax;
			HX_STACK_LINE(129)
			v->z = zMax;
		}
		HX_STACK_LINE(130)
		{
			HX_STACK_LINE(130)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(130)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(130)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(130)
			v->x = px;
			HX_STACK_LINE(130)
			v->y = py;
			HX_STACK_LINE(130)
			v->z = pz;
		}
		HX_STACK_LINE(131)
		{
			HX_STACK_LINE(131)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(131)
				this->xMin = v->x;
			}
			HX_STACK_LINE(131)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(131)
				this->xMax = v->x;
			}
			HX_STACK_LINE(131)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(131)
				this->yMin = v->y;
			}
			HX_STACK_LINE(131)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(131)
				this->yMax = v->y;
			}
			HX_STACK_LINE(131)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(131)
				this->zMin = v->z;
			}
			HX_STACK_LINE(131)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(131)
				this->zMax = v->z;
			}
		}
		HX_STACK_LINE(132)
		{
			HX_STACK_LINE(132)
			v->x = xMax;
			HX_STACK_LINE(132)
			v->y = yMin;
			HX_STACK_LINE(132)
			v->z = zMin;
		}
		HX_STACK_LINE(133)
		{
			HX_STACK_LINE(133)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(133)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(133)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(133)
			v->x = px;
			HX_STACK_LINE(133)
			v->y = py;
			HX_STACK_LINE(133)
			v->z = pz;
		}
		HX_STACK_LINE(134)
		{
			HX_STACK_LINE(134)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(134)
				this->xMin = v->x;
			}
			HX_STACK_LINE(134)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(134)
				this->xMax = v->x;
			}
			HX_STACK_LINE(134)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(134)
				this->yMin = v->y;
			}
			HX_STACK_LINE(134)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(134)
				this->yMax = v->y;
			}
			HX_STACK_LINE(134)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(134)
				this->zMin = v->z;
			}
			HX_STACK_LINE(134)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(134)
				this->zMax = v->z;
			}
		}
		HX_STACK_LINE(135)
		{
			HX_STACK_LINE(135)
			v->x = xMax;
			HX_STACK_LINE(135)
			v->y = yMin;
			HX_STACK_LINE(135)
			v->z = zMax;
		}
		HX_STACK_LINE(136)
		{
			HX_STACK_LINE(136)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(136)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(136)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(136)
			v->x = px;
			HX_STACK_LINE(136)
			v->y = py;
			HX_STACK_LINE(136)
			v->z = pz;
		}
		HX_STACK_LINE(137)
		{
			HX_STACK_LINE(137)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(137)
				this->xMin = v->x;
			}
			HX_STACK_LINE(137)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(137)
				this->xMax = v->x;
			}
			HX_STACK_LINE(137)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(137)
				this->yMin = v->y;
			}
			HX_STACK_LINE(137)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(137)
				this->yMax = v->y;
			}
			HX_STACK_LINE(137)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(137)
				this->zMin = v->z;
			}
			HX_STACK_LINE(137)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(137)
				this->zMax = v->z;
			}
		}
		HX_STACK_LINE(138)
		{
			HX_STACK_LINE(138)
			v->x = xMax;
			HX_STACK_LINE(138)
			v->y = yMax;
			HX_STACK_LINE(138)
			v->z = zMin;
		}
		HX_STACK_LINE(139)
		{
			HX_STACK_LINE(139)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(139)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(139)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(139)
			v->x = px;
			HX_STACK_LINE(139)
			v->y = py;
			HX_STACK_LINE(139)
			v->z = pz;
		}
		HX_STACK_LINE(140)
		{
			HX_STACK_LINE(140)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(140)
				this->xMin = v->x;
			}
			HX_STACK_LINE(140)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(140)
				this->xMax = v->x;
			}
			HX_STACK_LINE(140)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(140)
				this->yMin = v->y;
			}
			HX_STACK_LINE(140)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(140)
				this->yMax = v->y;
			}
			HX_STACK_LINE(140)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(140)
				this->zMin = v->z;
			}
			HX_STACK_LINE(140)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(140)
				this->zMax = v->z;
			}
		}
		HX_STACK_LINE(141)
		{
			HX_STACK_LINE(141)
			v->x = xMax;
			HX_STACK_LINE(141)
			v->y = yMax;
			HX_STACK_LINE(141)
			v->z = zMax;
		}
		HX_STACK_LINE(142)
		{
			HX_STACK_LINE(142)
			Float px = ((((v->x * m->_11) + (v->y * m->_21)) + (v->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(142)
			Float py = ((((v->x * m->_12) + (v->y * m->_22)) + (v->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(142)
			Float pz = ((((v->x * m->_13) + (v->y * m->_23)) + (v->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(142)
			v->x = px;
			HX_STACK_LINE(142)
			v->y = py;
			HX_STACK_LINE(142)
			v->z = pz;
		}
		HX_STACK_LINE(143)
		{
			HX_STACK_LINE(143)
			if (((v->x < this->xMin))){
				HX_STACK_LINE(143)
				this->xMin = v->x;
			}
			HX_STACK_LINE(143)
			if (((v->x > this->xMax))){
				HX_STACK_LINE(143)
				this->xMax = v->x;
			}
			HX_STACK_LINE(143)
			if (((v->y < this->yMin))){
				HX_STACK_LINE(143)
				this->yMin = v->y;
			}
			HX_STACK_LINE(143)
			if (((v->y > this->yMax))){
				HX_STACK_LINE(143)
				this->yMax = v->y;
			}
			HX_STACK_LINE(143)
			if (((v->z < this->zMin))){
				HX_STACK_LINE(143)
				this->zMin = v->z;
			}
			HX_STACK_LINE(143)
			if (((v->z > this->zMax))){
				HX_STACK_LINE(143)
				this->zMax = v->z;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,transform3x4,(void))

bool Bounds_obj::collide( ::h3d::col::Bounds b){
	HX_STACK_FRAME("h3d.col.Bounds","collide",0x2db55928,"h3d.col.Bounds.collide","h3d/col/Bounds.hx",147,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(147)
	return !(((bool((bool((bool((bool((bool((this->xMin > b->xMax)) || bool((this->yMin > b->yMax)))) || bool((this->zMin > b->zMax)))) || bool((this->xMax < b->xMin)))) || bool((this->yMax < b->yMin)))) || bool((this->zMax < b->zMin)))));
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,collide,return )

bool Bounds_obj::include( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Bounds","include",0x9248a7d2,"h3d.col.Bounds.include","h3d/col/Bounds.hx",151,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(151)
	return (bool((bool((bool((bool((bool((p->x >= this->xMin)) && bool((p->x < this->xMax)))) && bool((p->y >= this->yMin)))) && bool((p->y < this->yMax)))) && bool((p->z >= this->zMin)))) && bool((p->z < this->zMax)));
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,include,return )

Void Bounds_obj::add( ::h3d::col::Bounds b){
{
		HX_STACK_FRAME("h3d.col.Bounds","add",0xed06fecb,"h3d.col.Bounds.add","h3d/col/Bounds.hx",154,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(155)
		if (((b->xMin < this->xMin))){
			HX_STACK_LINE(155)
			this->xMin = b->xMin;
		}
		HX_STACK_LINE(156)
		if (((b->xMax > this->xMax))){
			HX_STACK_LINE(156)
			this->xMax = b->xMax;
		}
		HX_STACK_LINE(157)
		if (((b->yMin < this->yMin))){
			HX_STACK_LINE(157)
			this->yMin = b->yMin;
		}
		HX_STACK_LINE(158)
		if (((b->yMax > this->yMax))){
			HX_STACK_LINE(158)
			this->yMax = b->yMax;
		}
		HX_STACK_LINE(159)
		if (((b->zMin < this->zMin))){
			HX_STACK_LINE(159)
			this->zMin = b->zMin;
		}
		HX_STACK_LINE(160)
		if (((b->zMax > this->zMax))){
			HX_STACK_LINE(160)
			this->zMax = b->zMax;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,add,(void))

Void Bounds_obj::addPoint( ::h3d::col::Point p){
{
		HX_STACK_FRAME("h3d.col.Bounds","addPoint",0x470fa585,"h3d.col.Bounds.addPoint","h3d/col/Bounds.hx",163,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(164)
		if (((p->x < this->xMin))){
			HX_STACK_LINE(164)
			this->xMin = p->x;
		}
		HX_STACK_LINE(165)
		if (((p->x > this->xMax))){
			HX_STACK_LINE(165)
			this->xMax = p->x;
		}
		HX_STACK_LINE(166)
		if (((p->y < this->yMin))){
			HX_STACK_LINE(166)
			this->yMin = p->y;
		}
		HX_STACK_LINE(167)
		if (((p->y > this->yMax))){
			HX_STACK_LINE(167)
			this->yMax = p->y;
		}
		HX_STACK_LINE(168)
		if (((p->z < this->zMin))){
			HX_STACK_LINE(168)
			this->zMin = p->z;
		}
		HX_STACK_LINE(169)
		if (((p->z > this->zMax))){
			HX_STACK_LINE(169)
			this->zMax = p->z;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,addPoint,(void))

Void Bounds_obj::addPos( Float x,Float y,Float z){
{
		HX_STACK_FRAME("h3d.col.Bounds","addPos",0xe5572789,"h3d.col.Bounds.addPos","h3d/col/Bounds.hx",172,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(173)
		if (((x < this->xMin))){
			HX_STACK_LINE(173)
			this->xMin = x;
		}
		HX_STACK_LINE(174)
		if (((x > this->xMax))){
			HX_STACK_LINE(174)
			this->xMax = x;
		}
		HX_STACK_LINE(175)
		if (((y < this->yMin))){
			HX_STACK_LINE(175)
			this->yMin = y;
		}
		HX_STACK_LINE(176)
		if (((y > this->yMax))){
			HX_STACK_LINE(176)
			this->yMax = y;
		}
		HX_STACK_LINE(177)
		if (((z < this->zMin))){
			HX_STACK_LINE(177)
			this->zMin = z;
		}
		HX_STACK_LINE(178)
		if (((z > this->zMax))){
			HX_STACK_LINE(178)
			this->zMax = z;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Bounds_obj,addPos,(void))

Void Bounds_obj::intersection( ::h3d::col::Bounds a,::h3d::col::Bounds b){
{
		HX_STACK_FRAME("h3d.col.Bounds","intersection",0xcb16b05f,"h3d.col.Bounds.intersection","h3d/col/Bounds.hx",181,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(182)
		Float xMin;		HX_STACK_VAR(xMin,"xMin");
		HX_STACK_LINE(182)
		{
			HX_STACK_LINE(182)
			Float a1 = a->xMin;		HX_STACK_VAR(a1,"a1");
			HX_STACK_LINE(182)
			Float b1 = b->xMin;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(182)
			if (((a1 < b1))){
				HX_STACK_LINE(182)
				xMin = b1;
			}
			else{
				HX_STACK_LINE(182)
				xMin = a1;
			}
		}
		HX_STACK_LINE(183)
		Float yMin;		HX_STACK_VAR(yMin,"yMin");
		HX_STACK_LINE(183)
		{
			HX_STACK_LINE(183)
			Float a1 = a->yMin;		HX_STACK_VAR(a1,"a1");
			HX_STACK_LINE(183)
			Float b1 = b->yMin;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(183)
			if (((a1 < b1))){
				HX_STACK_LINE(183)
				yMin = b1;
			}
			else{
				HX_STACK_LINE(183)
				yMin = a1;
			}
		}
		HX_STACK_LINE(184)
		Float zMin;		HX_STACK_VAR(zMin,"zMin");
		HX_STACK_LINE(184)
		{
			HX_STACK_LINE(184)
			Float a1 = a->zMin;		HX_STACK_VAR(a1,"a1");
			HX_STACK_LINE(184)
			Float b1 = b->zMin;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(184)
			if (((a1 < b1))){
				HX_STACK_LINE(184)
				zMin = b1;
			}
			else{
				HX_STACK_LINE(184)
				zMin = a1;
			}
		}
		HX_STACK_LINE(185)
		Float xMax;		HX_STACK_VAR(xMax,"xMax");
		HX_STACK_LINE(185)
		{
			HX_STACK_LINE(185)
			Float a1 = a->xMax;		HX_STACK_VAR(a1,"a1");
			HX_STACK_LINE(185)
			Float b1 = b->xMax;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(185)
			if (((a1 < b1))){
				HX_STACK_LINE(185)
				xMax = b1;
			}
			else{
				HX_STACK_LINE(185)
				xMax = a1;
			}
		}
		HX_STACK_LINE(186)
		Float yMax;		HX_STACK_VAR(yMax,"yMax");
		HX_STACK_LINE(186)
		{
			HX_STACK_LINE(186)
			Float a1 = a->yMax;		HX_STACK_VAR(a1,"a1");
			HX_STACK_LINE(186)
			Float b1 = b->yMax;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(186)
			if (((a1 < b1))){
				HX_STACK_LINE(186)
				yMax = b1;
			}
			else{
				HX_STACK_LINE(186)
				yMax = a1;
			}
		}
		HX_STACK_LINE(187)
		Float zMax;		HX_STACK_VAR(zMax,"zMax");
		HX_STACK_LINE(187)
		{
			HX_STACK_LINE(187)
			Float a1 = a->zMax;		HX_STACK_VAR(a1,"a1");
			HX_STACK_LINE(187)
			Float b1 = b->zMax;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(187)
			if (((a1 < b1))){
				HX_STACK_LINE(187)
				zMax = b1;
			}
			else{
				HX_STACK_LINE(187)
				zMax = a1;
			}
		}
		HX_STACK_LINE(188)
		this->xMin = xMin;
		HX_STACK_LINE(189)
		this->xMax = xMax;
		HX_STACK_LINE(190)
		this->yMin = yMin;
		HX_STACK_LINE(191)
		this->yMax = yMax;
		HX_STACK_LINE(192)
		this->zMin = zMin;
		HX_STACK_LINE(193)
		this->zMax = zMax;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,intersection,(void))

Void Bounds_obj::offset( Float dx,Float dy,Float dz){
{
		HX_STACK_FRAME("h3d.col.Bounds","offset",0xa6905129,"h3d.col.Bounds.offset","h3d/col/Bounds.hx",196,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_ARG(dz,"dz")
		HX_STACK_LINE(197)
		hx::AddEq(this->xMin,dx);
		HX_STACK_LINE(198)
		hx::AddEq(this->xMax,dx);
		HX_STACK_LINE(199)
		hx::AddEq(this->yMin,dy);
		HX_STACK_LINE(200)
		hx::AddEq(this->yMax,dy);
		HX_STACK_LINE(201)
		hx::AddEq(this->zMin,dz);
		HX_STACK_LINE(202)
		hx::AddEq(this->zMax,dz);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Bounds_obj,offset,(void))

Void Bounds_obj::setMin( ::h3d::col::Point p){
{
		HX_STACK_FRAME("h3d.col.Bounds","setMin",0xb5bb58a6,"h3d.col.Bounds.setMin","h3d/col/Bounds.hx",205,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(206)
		this->xMin = p->x;
		HX_STACK_LINE(207)
		this->yMin = p->y;
		HX_STACK_LINE(208)
		this->zMin = p->z;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,setMin,(void))

Void Bounds_obj::setMax( ::h3d::col::Point p){
{
		HX_STACK_FRAME("h3d.col.Bounds","setMax",0xb5bb51b8,"h3d.col.Bounds.setMax","h3d/col/Bounds.hx",211,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(212)
		this->xMax = p->x;
		HX_STACK_LINE(213)
		this->yMax = p->y;
		HX_STACK_LINE(214)
		this->zMax = p->z;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,setMax,(void))

Void Bounds_obj::load( ::h3d::col::Bounds b){
{
		HX_STACK_FRAME("h3d.col.Bounds","load",0x8065a23c,"h3d.col.Bounds.load","h3d/col/Bounds.hx",217,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(218)
		this->xMin = b->xMin;
		HX_STACK_LINE(219)
		this->xMax = b->xMax;
		HX_STACK_LINE(220)
		this->yMin = b->yMin;
		HX_STACK_LINE(221)
		this->yMax = b->yMax;
		HX_STACK_LINE(222)
		this->zMin = b->zMin;
		HX_STACK_LINE(223)
		this->zMax = b->zMax;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,load,(void))

Void Bounds_obj::scaleCenter( Float v){
{
		HX_STACK_FRAME("h3d.col.Bounds","scaleCenter",0xc8d7b2a9,"h3d.col.Bounds.scaleCenter","h3d/col/Bounds.hx",226,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(227)
		Float dx = ((((this->xMax - this->xMin)) * 0.5) * v);		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(228)
		Float dy = ((((this->yMax - this->yMin)) * 0.5) * v);		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(229)
		Float dz = ((((this->zMax - this->zMin)) * 0.5) * v);		HX_STACK_VAR(dz,"dz");
		HX_STACK_LINE(230)
		Float mx = (((this->xMax + this->xMin)) * 0.5);		HX_STACK_VAR(mx,"mx");
		HX_STACK_LINE(231)
		Float my = (((this->yMax + this->yMin)) * 0.5);		HX_STACK_VAR(my,"my");
		HX_STACK_LINE(232)
		Float mz = (((this->zMax + this->zMin)) * 0.5);		HX_STACK_VAR(mz,"mz");
		HX_STACK_LINE(233)
		this->xMin = (mx - (dx * v));
		HX_STACK_LINE(234)
		this->yMin = (my - (dy * v));
		HX_STACK_LINE(235)
		this->zMin = (mz - (dz * v));
		HX_STACK_LINE(236)
		this->xMax = (mx + (dx * v));
		HX_STACK_LINE(237)
		this->yMax = (my + (dy * v));
		HX_STACK_LINE(238)
		this->zMax = (mz + (dz * v));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Bounds_obj,scaleCenter,(void))

::h3d::col::Point Bounds_obj::getMin( ){
	HX_STACK_FRAME("h3d.col.Bounds","getMin",0xe9730432,"h3d.col.Bounds.getMin","h3d/col/Bounds.hx",242,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(242)
	return ::h3d::col::Point_obj::__new(this->xMin,this->yMin,this->zMin);
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getMin,return )

::h3d::col::Point Bounds_obj::getCenter( ){
	HX_STACK_FRAME("h3d.col.Bounds","getCenter",0xb9809735,"h3d.col.Bounds.getCenter","h3d/col/Bounds.hx",246,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(246)
	return ::h3d::col::Point_obj::__new((((this->xMin + this->xMax)) * 0.5),(((this->yMin + this->yMax)) * 0.5),(((this->zMin + this->zMax)) * 0.5));
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getCenter,return )

::h3d::col::Point Bounds_obj::getSize( ){
	HX_STACK_FRAME("h3d.col.Bounds","getSize",0x5f27fa21,"h3d.col.Bounds.getSize","h3d/col/Bounds.hx",250,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(250)
	return ::h3d::col::Point_obj::__new((this->xMax - this->xMin),(this->yMax - this->yMin),(this->zMax - this->zMin));
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getSize,return )

::h3d::col::Point Bounds_obj::getMax( ){
	HX_STACK_FRAME("h3d.col.Bounds","getMax",0xe972fd44,"h3d.col.Bounds.getMax","h3d/col/Bounds.hx",254,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(254)
	return ::h3d::col::Point_obj::__new(this->xMax,this->yMax,this->zMax);
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,getMax,return )

Void Bounds_obj::empty( ){
{
		HX_STACK_FRAME("h3d.col.Bounds","empty",0xcf7345b7,"h3d.col.Bounds.empty","h3d/col/Bounds.hx",257,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_LINE(258)
		this->xMin = 1e20;
		HX_STACK_LINE(259)
		this->xMax = -1e20;
		HX_STACK_LINE(260)
		this->yMin = 1e20;
		HX_STACK_LINE(261)
		this->yMax = -1e20;
		HX_STACK_LINE(262)
		this->zMin = 1e20;
		HX_STACK_LINE(263)
		this->zMax = -1e20;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,empty,(void))

Void Bounds_obj::all( ){
{
		HX_STACK_FRAME("h3d.col.Bounds","all",0xed0705cb,"h3d.col.Bounds.all","h3d/col/Bounds.hx",266,0x049adce4)
		HX_STACK_THIS(this)
		HX_STACK_LINE(267)
		this->xMin = -1e20;
		HX_STACK_LINE(268)
		this->xMax = 1e20;
		HX_STACK_LINE(269)
		this->yMin = -1e20;
		HX_STACK_LINE(270)
		this->yMax = 1e20;
		HX_STACK_LINE(271)
		this->zMin = -1e20;
		HX_STACK_LINE(272)
		this->zMax = 1e20;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,all,(void))

::h3d::col::Bounds Bounds_obj::clone( ){
	HX_STACK_FRAME("h3d.col.Bounds","clone",0xa7fc1e87,"h3d.col.Bounds.clone","h3d/col/Bounds.hx",275,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(276)
	::h3d::col::Bounds b = ::h3d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(277)
	b->xMin = this->xMin;
	HX_STACK_LINE(278)
	b->xMax = this->xMax;
	HX_STACK_LINE(279)
	b->yMin = this->yMin;
	HX_STACK_LINE(280)
	b->yMax = this->yMax;
	HX_STACK_LINE(281)
	b->zMin = this->zMin;
	HX_STACK_LINE(282)
	b->zMax = this->zMax;
	HX_STACK_LINE(283)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,clone,return )

::String Bounds_obj::toString( ){
	HX_STACK_FRAME("h3d.col.Bounds","toString",0x3f919bc2,"h3d.col.Bounds.toString","h3d/col/Bounds.hx",286,0x049adce4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(287)
	::h3d::col::Point _g = ::h3d::col::Point_obj::__new(this->xMin,this->yMin,this->zMin);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(287)
	::String _g1 = ::Std_obj::string(_g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(287)
	::String _g2 = (HX_CSTRING("{") + _g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(287)
	::String _g3 = (_g2 + HX_CSTRING(","));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(287)
	::h3d::col::Point _g4 = ::h3d::col::Point_obj::__new(this->xMax,this->yMax,this->zMax);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(287)
	::String _g5 = ::Std_obj::string(_g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(287)
	::String _g6 = (_g3 + _g5);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(287)
	return (_g6 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Bounds_obj,toString,return )

::h3d::col::Bounds Bounds_obj::fromPoints( ::h3d::col::Point min,::h3d::col::Point max){
	HX_STACK_FRAME("h3d.col.Bounds","fromPoints",0x682e53c3,"h3d.col.Bounds.fromPoints","h3d/col/Bounds.hx",290,0x049adce4)
	HX_STACK_ARG(min,"min")
	HX_STACK_ARG(max,"max")
	HX_STACK_LINE(291)
	::h3d::col::Bounds b = ::h3d::col::Bounds_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(292)
	{
		HX_STACK_LINE(292)
		b->xMin = min->x;
		HX_STACK_LINE(292)
		b->yMin = min->y;
		HX_STACK_LINE(292)
		b->zMin = min->z;
	}
	HX_STACK_LINE(293)
	{
		HX_STACK_LINE(293)
		b->xMax = max->x;
		HX_STACK_LINE(293)
		b->yMax = max->y;
		HX_STACK_LINE(293)
		b->zMax = max->z;
	}
	HX_STACK_LINE(294)
	return b;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Bounds_obj,fromPoints,return )


Bounds_obj::Bounds_obj()
{
}

Dynamic Bounds_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"all") ) { return all_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"xMin") ) { return xMin; }
		if (HX_FIELD_EQ(inName,"xMax") ) { return xMax; }
		if (HX_FIELD_EQ(inName,"yMin") ) { return yMin; }
		if (HX_FIELD_EQ(inName,"yMax") ) { return yMax; }
		if (HX_FIELD_EQ(inName,"zMin") ) { return zMin; }
		if (HX_FIELD_EQ(inName,"zMax") ) { return zMax; }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"empty") ) { return empty_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"addPos") ) { return addPos_dyn(); }
		if (HX_FIELD_EQ(inName,"offset") ) { return offset_dyn(); }
		if (HX_FIELD_EQ(inName,"setMin") ) { return setMin_dyn(); }
		if (HX_FIELD_EQ(inName,"setMax") ) { return setMax_dyn(); }
		if (HX_FIELD_EQ(inName,"getMin") ) { return getMin_dyn(); }
		if (HX_FIELD_EQ(inName,"getMax") ) { return getMax_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"collide") ) { return collide_dyn(); }
		if (HX_FIELD_EQ(inName,"include") ) { return include_dyn(); }
		if (HX_FIELD_EQ(inName,"getSize") ) { return getSize_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"addPoint") ) { return addPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"inFrustum") ) { return inFrustum_dyn(); }
		if (HX_FIELD_EQ(inName,"testPlane") ) { return testPlane_dyn(); }
		if (HX_FIELD_EQ(inName,"getCenter") ) { return getCenter_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromPoints") ) { return fromPoints_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"scaleCenter") ) { return scaleCenter_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"transform3x4") ) { return transform3x4_dyn(); }
		if (HX_FIELD_EQ(inName,"intersection") ) { return intersection_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"inFrustumDetails") ) { return inFrustumDetails_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Bounds_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"xMin") ) { xMin=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"xMax") ) { xMax=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"yMin") ) { yMin=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"yMax") ) { yMax=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"zMin") ) { zMin=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"zMax") ) { zMax=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Bounds_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("xMin"));
	outFields->push(HX_CSTRING("xMax"));
	outFields->push(HX_CSTRING("yMin"));
	outFields->push(HX_CSTRING("yMax"));
	outFields->push(HX_CSTRING("zMin"));
	outFields->push(HX_CSTRING("zMax"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromPoints"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Bounds_obj,xMin),HX_CSTRING("xMin")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,xMax),HX_CSTRING("xMax")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,yMin),HX_CSTRING("yMin")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,yMax),HX_CSTRING("yMax")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,zMin),HX_CSTRING("zMin")},
	{hx::fsFloat,(int)offsetof(Bounds_obj,zMax),HX_CSTRING("zMax")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("xMin"),
	HX_CSTRING("xMax"),
	HX_CSTRING("yMin"),
	HX_CSTRING("yMax"),
	HX_CSTRING("zMin"),
	HX_CSTRING("zMax"),
	HX_CSTRING("inFrustum"),
	HX_CSTRING("testPlane"),
	HX_CSTRING("inFrustumDetails"),
	HX_CSTRING("transform3x4"),
	HX_CSTRING("collide"),
	HX_CSTRING("include"),
	HX_CSTRING("add"),
	HX_CSTRING("addPoint"),
	HX_CSTRING("addPos"),
	HX_CSTRING("intersection"),
	HX_CSTRING("offset"),
	HX_CSTRING("setMin"),
	HX_CSTRING("setMax"),
	HX_CSTRING("load"),
	HX_CSTRING("scaleCenter"),
	HX_CSTRING("getMin"),
	HX_CSTRING("getCenter"),
	HX_CSTRING("getSize"),
	HX_CSTRING("getMax"),
	HX_CSTRING("empty"),
	HX_CSTRING("all"),
	HX_CSTRING("clone"),
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
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.col.Bounds"), hx::TCanCast< Bounds_obj> ,sStaticFields,sMemberFields,
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

} // end namespace h3d
} // end namespace col
