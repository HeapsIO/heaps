#include <hxcpp.h>

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
namespace col{

Void Point_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z)
{
HX_STACK_FRAME("h3d.col.Point","new",0x20d35b7f,"h3d.col.Point.new","h3d/col/Point.hx",10,0x20e0bf53)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
HX_STACK_ARG(__o_z,"z")
Float x = __o_x.Default(0.);
Float y = __o_y.Default(0.);
Float z = __o_z.Default(0.);
{
	HX_STACK_LINE(11)
	this->x = x;
	HX_STACK_LINE(12)
	this->y = y;
	HX_STACK_LINE(13)
	this->z = z;
}
;
	return null();
}

//Point_obj::~Point_obj() { }

Dynamic Point_obj::__CreateEmpty() { return  new Point_obj; }
hx::ObjectPtr< Point_obj > Point_obj::__new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z)
{  hx::ObjectPtr< Point_obj > result = new Point_obj();
	result->__construct(__o_x,__o_y,__o_z);
	return result;}

Dynamic Point_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Point_obj > result = new Point_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

bool Point_obj::inFrustum( ::h3d::Matrix mvp){
	HX_STACK_FRAME("h3d.col.Point","inFrustum",0xf0cfb65c,"h3d.col.Point.inFrustum","h3d/col/Point.hx",16,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_ARG(mvp,"mvp")
	struct _Function_1_1{
		inline static bool Block( ::h3d::Matrix &mvp,hx::ObjectPtr< ::h3d::col::Point_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/col/Point.hx",18,0x20e0bf53)
			{
				HX_STACK_LINE(18)
				Float _this_nx = (mvp->_14 + mvp->_11);		HX_STACK_VAR(_this_nx,"_this_nx");
				HX_STACK_LINE(18)
				Float _this_ny = (mvp->_24 + mvp->_21);		HX_STACK_VAR(_this_ny,"_this_ny");
				HX_STACK_LINE(18)
				Float _this_nz = (mvp->_34 + mvp->_31);		HX_STACK_VAR(_this_nz,"_this_nz");
				HX_STACK_LINE(18)
				Float _this_d = -(((mvp->_44 + mvp->_41)));		HX_STACK_VAR(_this_d,"_this_d");
				HX_STACK_LINE(18)
				return (((((_this_nx * __this->x) + (_this_ny * __this->y)) + (_this_nz * __this->z)) - _this_d) >= (int)0);
			}
			return null();
		}
	};
	HX_STACK_LINE(18)
	if ((!(_Function_1_1::Block(mvp,this)))){
		HX_STACK_LINE(19)
		return false;
	}
	struct _Function_1_2{
		inline static bool Block( ::h3d::Matrix &mvp,hx::ObjectPtr< ::h3d::col::Point_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/col/Point.hx",22,0x20e0bf53)
			{
				HX_STACK_LINE(22)
				Float _this_nx = (mvp->_14 - mvp->_11);		HX_STACK_VAR(_this_nx,"_this_nx");
				HX_STACK_LINE(22)
				Float _this_ny = (mvp->_24 - mvp->_21);		HX_STACK_VAR(_this_ny,"_this_ny");
				HX_STACK_LINE(22)
				Float _this_nz = (mvp->_34 - mvp->_31);		HX_STACK_VAR(_this_nz,"_this_nz");
				HX_STACK_LINE(22)
				Float _this_d = (mvp->_41 - mvp->_44);		HX_STACK_VAR(_this_d,"_this_d");
				HX_STACK_LINE(22)
				return (((((_this_nx * __this->x) + (_this_ny * __this->y)) + (_this_nz * __this->z)) - _this_d) >= (int)0);
			}
			return null();
		}
	};
	HX_STACK_LINE(22)
	if ((!(_Function_1_2::Block(mvp,this)))){
		HX_STACK_LINE(23)
		return false;
	}
	struct _Function_1_3{
		inline static bool Block( ::h3d::Matrix &mvp,hx::ObjectPtr< ::h3d::col::Point_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/col/Point.hx",26,0x20e0bf53)
			{
				HX_STACK_LINE(26)
				Float _this_nx = (mvp->_14 + mvp->_12);		HX_STACK_VAR(_this_nx,"_this_nx");
				HX_STACK_LINE(26)
				Float _this_ny = (mvp->_24 + mvp->_22);		HX_STACK_VAR(_this_ny,"_this_ny");
				HX_STACK_LINE(26)
				Float _this_nz = (mvp->_34 + mvp->_32);		HX_STACK_VAR(_this_nz,"_this_nz");
				HX_STACK_LINE(26)
				Float _this_d = -(((mvp->_44 + mvp->_42)));		HX_STACK_VAR(_this_d,"_this_d");
				HX_STACK_LINE(26)
				return (((((_this_nx * __this->x) + (_this_ny * __this->y)) + (_this_nz * __this->z)) - _this_d) >= (int)0);
			}
			return null();
		}
	};
	HX_STACK_LINE(26)
	if ((!(_Function_1_3::Block(mvp,this)))){
		HX_STACK_LINE(27)
		return false;
	}
	struct _Function_1_4{
		inline static bool Block( ::h3d::Matrix &mvp,hx::ObjectPtr< ::h3d::col::Point_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/col/Point.hx",30,0x20e0bf53)
			{
				HX_STACK_LINE(30)
				Float _this_nx = (mvp->_14 - mvp->_12);		HX_STACK_VAR(_this_nx,"_this_nx");
				HX_STACK_LINE(30)
				Float _this_ny = (mvp->_24 - mvp->_22);		HX_STACK_VAR(_this_ny,"_this_ny");
				HX_STACK_LINE(30)
				Float _this_nz = (mvp->_34 - mvp->_32);		HX_STACK_VAR(_this_nz,"_this_nz");
				HX_STACK_LINE(30)
				Float _this_d = (mvp->_42 - mvp->_44);		HX_STACK_VAR(_this_d,"_this_d");
				HX_STACK_LINE(30)
				return (((((_this_nx * __this->x) + (_this_ny * __this->y)) + (_this_nz * __this->z)) - _this_d) >= (int)0);
			}
			return null();
		}
	};
	HX_STACK_LINE(30)
	if ((!(_Function_1_4::Block(mvp,this)))){
		HX_STACK_LINE(31)
		return false;
	}
	struct _Function_1_5{
		inline static bool Block( ::h3d::Matrix &mvp,hx::ObjectPtr< ::h3d::col::Point_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/col/Point.hx",34,0x20e0bf53)
			{
				HX_STACK_LINE(34)
				Float _this_nx = mvp->_13;		HX_STACK_VAR(_this_nx,"_this_nx");
				HX_STACK_LINE(34)
				Float _this_ny = mvp->_23;		HX_STACK_VAR(_this_ny,"_this_ny");
				HX_STACK_LINE(34)
				Float _this_nz = mvp->_33;		HX_STACK_VAR(_this_nz,"_this_nz");
				HX_STACK_LINE(34)
				Float _this_d = -(mvp->_43);		HX_STACK_VAR(_this_d,"_this_d");
				HX_STACK_LINE(34)
				return (((((_this_nx * __this->x) + (_this_ny * __this->y)) + (_this_nz * __this->z)) - _this_d) >= (int)0);
			}
			return null();
		}
	};
	HX_STACK_LINE(34)
	if ((!(_Function_1_5::Block(mvp,this)))){
		HX_STACK_LINE(35)
		return false;
	}
	struct _Function_1_6{
		inline static bool Block( ::h3d::Matrix &mvp,hx::ObjectPtr< ::h3d::col::Point_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/col/Point.hx",38,0x20e0bf53)
			{
				HX_STACK_LINE(38)
				Float _this_nx = (mvp->_14 - mvp->_13);		HX_STACK_VAR(_this_nx,"_this_nx");
				HX_STACK_LINE(38)
				Float _this_ny = (mvp->_24 - mvp->_23);		HX_STACK_VAR(_this_ny,"_this_ny");
				HX_STACK_LINE(38)
				Float _this_nz = (mvp->_34 - mvp->_33);		HX_STACK_VAR(_this_nz,"_this_nz");
				HX_STACK_LINE(38)
				Float _this_d = (mvp->_43 - mvp->_44);		HX_STACK_VAR(_this_d,"_this_d");
				HX_STACK_LINE(38)
				return (((((_this_nx * __this->x) + (_this_ny * __this->y)) + (_this_nz * __this->z)) - _this_d) >= (int)0);
			}
			return null();
		}
	};
	HX_STACK_LINE(38)
	if ((!(_Function_1_6::Block(mvp,this)))){
		HX_STACK_LINE(39)
		return false;
	}
	HX_STACK_LINE(41)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,inFrustum,return )

Void Point_obj::set( Float x,Float y,Float z){
{
		HX_STACK_FRAME("h3d.col.Point","set",0x20d726c1,"h3d.col.Point.set","h3d/col/Point.hx",44,0x20e0bf53)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(45)
		this->x = x;
		HX_STACK_LINE(46)
		this->y = y;
		HX_STACK_LINE(47)
		this->z = z;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Point_obj,set,(void))

::h3d::col::Point Point_obj::sub( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Point","sub",0x20d7349f,"h3d.col.Point.sub","h3d/col/Point.hx",51,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(51)
	return ::h3d::col::Point_obj::__new((this->x - p->x),(this->y - p->y),(this->z - p->z));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,sub,return )

::h3d::col::Point Point_obj::add( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Point","add",0x20c97d40,"h3d.col.Point.add","h3d/col/Point.hx",55,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(55)
	return ::h3d::col::Point_obj::__new((this->x + p->x),(this->y + p->y),(this->z + p->z));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,add,return )

::h3d::col::Point Point_obj::cross( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Point","cross",0x342a305f,"h3d.col.Point.cross","h3d/col/Point.hx",59,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(59)
	return ::h3d::col::Point_obj::__new(((this->y * p->z) - (this->z * p->y)),((this->z * p->x) - (this->x * p->z)),((this->x * p->y) - (this->y * p->x)));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,cross,return )

Float Point_obj::lengthSq( ){
	HX_STACK_FRAME("h3d.col.Point","lengthSq",0xd31c27a5,"h3d.col.Point.lengthSq","h3d/col/Point.hx",64,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_LINE(64)
	return (((this->x * this->x) + (this->y * this->y)) + (this->z * this->z));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,lengthSq,return )

Float Point_obj::length( ){
	HX_STACK_FRAME("h3d.col.Point","length",0x8d0e8727,"h3d.col.Point.length","h3d/col/Point.hx",68,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_LINE(68)
	return ::Math_obj::sqrt((((this->x * this->x) + (this->y * this->y)) + (this->z * this->z)));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,length,return )

Float Point_obj::dot( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Point","dot",0x20cbcda8,"h3d.col.Point.dot","h3d/col/Point.hx",72,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(72)
	return (((this->x * p->x) + (this->y * p->y)) + (this->z * p->z));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,dot,return )

Float Point_obj::distanceSq( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Point","distanceSq",0x5a6079f4,"h3d.col.Point.distanceSq","h3d/col/Point.hx",75,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(76)
	Float dx = (p->x - this->x);		HX_STACK_VAR(dx,"dx");
	HX_STACK_LINE(77)
	Float dy = (p->y - this->y);		HX_STACK_VAR(dy,"dy");
	HX_STACK_LINE(78)
	Float dz = (p->z - this->z);		HX_STACK_VAR(dz,"dz");
	HX_STACK_LINE(79)
	return (((dx * dx) + (dy * dy)) + (dz * dz));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,distanceSq,return )

Float Point_obj::distance( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Point","distance",0x1f5257b6,"h3d.col.Point.distance","h3d/col/Point.hx",83,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	struct _Function_1_1{
		inline static Float Block( hx::ObjectPtr< ::h3d::col::Point_obj > __this,::h3d::col::Point &p){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/col/Point.hx",83,0x20e0bf53)
			{
				HX_STACK_LINE(83)
				Float dx = (p->x - __this->x);		HX_STACK_VAR(dx,"dx");
				HX_STACK_LINE(83)
				Float dy = (p->y - __this->y);		HX_STACK_VAR(dy,"dy");
				HX_STACK_LINE(83)
				Float dz = (p->z - __this->z);		HX_STACK_VAR(dz,"dz");
				HX_STACK_LINE(83)
				return (((dx * dx) + (dy * dy)) + (dz * dz));
			}
			return null();
		}
	};
	HX_STACK_LINE(83)
	return ::Math_obj::sqrt(_Function_1_1::Block(this,p));
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,distance,return )

Void Point_obj::normalize( ){
{
		HX_STACK_FRAME("h3d.col.Point","normalize",0xe5f463ec,"h3d.col.Point.normalize","h3d/col/Point.hx",87,0x20e0bf53)
		HX_STACK_THIS(this)
		HX_STACK_LINE(88)
		Float k = (((this->x * this->x) + (this->y * this->y)) + (this->z * this->z));		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(89)
		if (((k < 1e-10))){
			HX_STACK_LINE(89)
			k = (int)0;
		}
		else{
			HX_STACK_LINE(89)
			Float _g = ::Math_obj::sqrt(k);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(89)
			Float _g1 = (Float(1.) / Float(_g));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(89)
			k = _g1;
		}
		HX_STACK_LINE(90)
		hx::MultEq(this->x,k);
		HX_STACK_LINE(91)
		hx::MultEq(this->y,k);
		HX_STACK_LINE(92)
		hx::MultEq(this->z,k);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,normalize,(void))

Void Point_obj::transform( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.col.Point","transform",0x7fe659cb,"h3d.col.Point.transform","h3d/col/Point.hx",95,0x20e0bf53)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(96)
		Float px = ((((this->x * m->_11) + (this->y * m->_21)) + (this->z * m->_31)) + m->_41);		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(97)
		Float py = ((((this->x * m->_12) + (this->y * m->_22)) + (this->z * m->_32)) + m->_42);		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(98)
		Float pz = ((((this->x * m->_13) + (this->y * m->_23)) + (this->z * m->_33)) + m->_43);		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(99)
		this->x = px;
		HX_STACK_LINE(100)
		this->y = py;
		HX_STACK_LINE(101)
		this->z = pz;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Point_obj,transform,(void))

::h3d::Vector Point_obj::toVector( ){
	HX_STACK_FRAME("h3d.col.Point","toVector",0x71f51d1f,"h3d.col.Point.toVector","h3d/col/Point.hx",105,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_LINE(105)
	return ::h3d::Vector_obj::__new(this->x,this->y,this->z,null());
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,toVector,return )

::h3d::col::Point Point_obj::clone( ){
	HX_STACK_FRAME("h3d.col.Point","clone",0x3032e43c,"h3d.col.Point.clone","h3d/col/Point.hx",109,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_LINE(109)
	return ::h3d::col::Point_obj::__new(this->x,this->y,this->z);
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,clone,return )

::String Point_obj::toString( ){
	HX_STACK_FRAME("h3d.col.Point","toString",0xebc7952d,"h3d.col.Point.toString","h3d/col/Point.hx",112,0x20e0bf53)
	HX_STACK_THIS(this)
	HX_STACK_LINE(113)
	Float _g = ::hxd::Math_obj::fmt(this->x);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(113)
	::String _g1 = (HX_CSTRING("{") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(113)
	::String _g2 = (_g1 + HX_CSTRING(","));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(113)
	Float _g3 = ::hxd::Math_obj::fmt(this->y);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(113)
	::String _g4 = (_g2 + _g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(113)
	::String _g5 = (_g4 + HX_CSTRING(","));		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(113)
	Float _g6 = ::hxd::Math_obj::fmt(this->z);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(113)
	::String _g7 = (_g5 + _g6);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(113)
	return (_g7 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Point_obj,toString,return )


Point_obj::Point_obj()
{
}

Dynamic Point_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"z") ) { return z; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"dot") ) { return dot_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"cross") ) { return cross_dyn(); }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return length_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"lengthSq") ) { return lengthSq_dyn(); }
		if (HX_FIELD_EQ(inName,"distance") ) { return distance_dyn(); }
		if (HX_FIELD_EQ(inName,"toVector") ) { return toVector_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"inFrustum") ) { return inFrustum_dyn(); }
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		if (HX_FIELD_EQ(inName,"transform") ) { return transform_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"distanceSq") ) { return distanceSq_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Point_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"z") ) { z=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Point_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("z"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Point_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Point_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Point_obj,z),HX_CSTRING("z")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("z"),
	HX_CSTRING("inFrustum"),
	HX_CSTRING("set"),
	HX_CSTRING("sub"),
	HX_CSTRING("add"),
	HX_CSTRING("cross"),
	HX_CSTRING("lengthSq"),
	HX_CSTRING("length"),
	HX_CSTRING("dot"),
	HX_CSTRING("distanceSq"),
	HX_CSTRING("distance"),
	HX_CSTRING("normalize"),
	HX_CSTRING("transform"),
	HX_CSTRING("toVector"),
	HX_CSTRING("clone"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Point_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Point_obj::__mClass,"__mClass");
};

#endif

Class Point_obj::__mClass;

void Point_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.col.Point"), hx::TCanCast< Point_obj> ,sStaticFields,sMemberFields,
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

void Point_obj::__boot()
{
}

} // end namespace h3d
} // end namespace col
