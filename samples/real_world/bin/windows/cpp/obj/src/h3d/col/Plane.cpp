#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_col_Plane
#include <h3d/col/Plane.h>
#endif
#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace h3d{
namespace col{

Void Plane_obj::__construct(Float nx,Float ny,Float nz,Float d)
{
HX_STACK_FRAME("h3d.col.Plane","new",0x858d9b8b,"h3d.col.Plane.new","h3d/col/Plane.hx",13,0x675b44c7)
HX_STACK_THIS(this)
HX_STACK_ARG(nx,"nx")
HX_STACK_ARG(ny,"ny")
HX_STACK_ARG(nz,"nz")
HX_STACK_ARG(d,"d")
{
	HX_STACK_LINE(14)
	this->nx = nx;
	HX_STACK_LINE(15)
	this->ny = ny;
	HX_STACK_LINE(16)
	this->nz = nz;
	HX_STACK_LINE(17)
	this->d = d;
}
;
	return null();
}

//Plane_obj::~Plane_obj() { }

Dynamic Plane_obj::__CreateEmpty() { return  new Plane_obj; }
hx::ObjectPtr< Plane_obj > Plane_obj::__new(Float nx,Float ny,Float nz,Float d)
{  hx::ObjectPtr< Plane_obj > result = new Plane_obj();
	result->__construct(nx,ny,nz,d);
	return result;}

Dynamic Plane_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Plane_obj > result = new Plane_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

::h3d::col::Point Plane_obj::getNormal( ){
	HX_STACK_FRAME("h3d.col.Plane","getNormal",0xe3fef8c8,"h3d.col.Plane.getNormal","h3d/col/Plane.hx",24,0x675b44c7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(24)
	return ::h3d::col::Point_obj::__new(this->nx,this->ny,this->nz);
}


HX_DEFINE_DYNAMIC_FUNC0(Plane_obj,getNormal,return )

Float Plane_obj::getNormalDistance( ){
	HX_STACK_FRAME("h3d.col.Plane","getNormalDistance",0x01fc501d,"h3d.col.Plane.getNormalDistance","h3d/col/Plane.hx",28,0x675b44c7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(28)
	return this->d;
}


HX_DEFINE_DYNAMIC_FUNC0(Plane_obj,getNormalDistance,return )

Void Plane_obj::normalize( ){
{
		HX_STACK_FRAME("h3d.col.Plane","normalize",0xe2e034f8,"h3d.col.Plane.normalize","h3d/col/Plane.hx",34,0x675b44c7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(35)
		Float _g = ::Math_obj::sqrt((((this->nx * this->nx) + (this->ny * this->ny)) + (this->nz * this->nz)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(35)
		Float len = (Float(1.) / Float(_g));		HX_STACK_VAR(len,"len");
		HX_STACK_LINE(36)
		hx::MultEq(this->nx,len);
		HX_STACK_LINE(37)
		hx::MultEq(this->ny,len);
		HX_STACK_LINE(38)
		hx::MultEq(this->nz,len);
		HX_STACK_LINE(39)
		hx::MultEq(this->d,len);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Plane_obj,normalize,(void))

::String Plane_obj::toString( ){
	HX_STACK_FRAME("h3d.col.Plane","toString",0xc82da9a1,"h3d.col.Plane.toString","h3d/col/Plane.hx",42,0x675b44c7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(43)
	::h3d::col::Point _g = ::h3d::col::Point_obj::__new(this->nx,this->ny,this->nz);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(43)
	::String _g1 = ::Std_obj::string(_g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(43)
	::String _g2 = (HX_CSTRING("{") + _g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(43)
	::String _g3 = (_g2 + HX_CSTRING(","));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(43)
	::String _g4 = (_g3 + this->d);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(43)
	return (_g4 + HX_CSTRING("}"));
}


HX_DEFINE_DYNAMIC_FUNC0(Plane_obj,toString,return )

Float Plane_obj::distance( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Plane","distance",0xfbb86c2a,"h3d.col.Plane.distance","h3d/col/Plane.hx",50,0x675b44c7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(50)
	return ((((this->nx * p->x) + (this->ny * p->y)) + (this->nz * p->z)) - this->d);
}


HX_DEFINE_DYNAMIC_FUNC1(Plane_obj,distance,return )

bool Plane_obj::side( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Plane","side",0x59ab880c,"h3d.col.Plane.side","h3d/col/Plane.hx",54,0x675b44c7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(54)
	return (((((this->nx * p->x) + (this->ny * p->y)) + (this->nz * p->z)) - this->d) >= (int)0);
}


HX_DEFINE_DYNAMIC_FUNC1(Plane_obj,side,return )

::h3d::col::Point Plane_obj::project( ::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Plane","project",0x25a14f84,"h3d.col.Plane.project","h3d/col/Plane.hx",57,0x675b44c7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(58)
	Float d = ((((this->nx * p->x) + (this->ny * p->y)) + (this->nz * p->z)) - this->d);		HX_STACK_VAR(d,"d");
	HX_STACK_LINE(59)
	return ::h3d::col::Point_obj::__new((p->x - (d * this->nx)),(p->y - (d * this->ny)),(p->z - (d * this->nz)));
}


HX_DEFINE_DYNAMIC_FUNC1(Plane_obj,project,return )

Void Plane_obj::projectTo( ::h3d::col::Point p,::h3d::col::Point out){
{
		HX_STACK_FRAME("h3d.col.Plane","projectTo",0xcc37821f,"h3d.col.Plane.projectTo","h3d/col/Plane.hx",62,0x675b44c7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_ARG(out,"out")
		HX_STACK_LINE(63)
		Float d = ((((this->nx * p->x) + (this->ny * p->y)) + (this->nz * p->z)) - this->d);		HX_STACK_VAR(d,"d");
		HX_STACK_LINE(64)
		out->x = (p->x - (d * this->nx));
		HX_STACK_LINE(65)
		out->y = (p->y - (d * this->ny));
		HX_STACK_LINE(66)
		out->z = (p->z - (d * this->nz));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Plane_obj,projectTo,(void))

::h3d::col::Plane Plane_obj::fromPoints( ::h3d::col::Point p0,::h3d::col::Point p1,::h3d::col::Point p2){
	HX_STACK_FRAME("h3d.col.Plane","fromPoints",0x5a50d762,"h3d.col.Plane.fromPoints","h3d/col/Plane.hx",69,0x675b44c7)
	HX_STACK_ARG(p0,"p0")
	HX_STACK_ARG(p1,"p1")
	HX_STACK_ARG(p2,"p2")
	HX_STACK_LINE(70)
	Float d1_x = (p1->x - p0->x);		HX_STACK_VAR(d1_x,"d1_x");
	HX_STACK_LINE(70)
	Float d1_y = (p1->y - p0->y);		HX_STACK_VAR(d1_y,"d1_y");
	HX_STACK_LINE(70)
	Float d1_z = (p1->z - p0->z);		HX_STACK_VAR(d1_z,"d1_z");
	HX_STACK_LINE(71)
	Float d2_x = (p2->x - p0->x);		HX_STACK_VAR(d2_x,"d2_x");
	HX_STACK_LINE(71)
	Float d2_y = (p2->y - p0->y);		HX_STACK_VAR(d2_y,"d2_y");
	HX_STACK_LINE(71)
	Float d2_z = (p2->z - p0->z);		HX_STACK_VAR(d2_z,"d2_z");
	HX_STACK_LINE(72)
	Float n_x = ((d1_y * d2_z) - (d1_z * d2_y));		HX_STACK_VAR(n_x,"n_x");
	HX_STACK_LINE(72)
	Float n_y = ((d1_z * d2_x) - (d1_x * d2_z));		HX_STACK_VAR(n_y,"n_y");
	HX_STACK_LINE(72)
	Float n_z = ((d1_x * d2_y) - (d1_y * d2_x));		HX_STACK_VAR(n_z,"n_z");
	HX_STACK_LINE(73)
	return ::h3d::col::Plane_obj::__new(n_x,n_y,n_z,(((n_x * p0->x) + (n_y * p0->y)) + (n_z * p0->z)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Plane_obj,fromPoints,return )

::h3d::col::Plane Plane_obj::fromNormalPoint( ::h3d::col::Point n,::h3d::col::Point p){
	HX_STACK_FRAME("h3d.col.Plane","fromNormalPoint",0xd3f05b0a,"h3d.col.Plane.fromNormalPoint","h3d/col/Plane.hx",77,0x675b44c7)
	HX_STACK_ARG(n,"n")
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(77)
	return ::h3d::col::Plane_obj::__new(n->x,n->y,n->z,(((n->x * p->x) + (n->y * p->y)) + (n->z * p->z)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Plane_obj,fromNormalPoint,return )

::h3d::col::Plane Plane_obj::X( Float v){
	HX_STACK_FRAME("h3d.col.Plane","X",0x29ae1ac3,"h3d.col.Plane.X","h3d/col/Plane.hx",81,0x675b44c7)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(81)
	return ::h3d::col::Plane_obj::__new((int)1,(int)0,(int)0,v);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Plane_obj,X,return )

::h3d::col::Plane Plane_obj::Y( Float v){
	HX_STACK_FRAME("h3d.col.Plane","Y",0x29ae1ac4,"h3d.col.Plane.Y","h3d/col/Plane.hx",85,0x675b44c7)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(85)
	return ::h3d::col::Plane_obj::__new((int)0,(int)1,(int)0,v);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Plane_obj,Y,return )

::h3d::col::Plane Plane_obj::Z( Float v){
	HX_STACK_FRAME("h3d.col.Plane","Z",0x29ae1ac5,"h3d.col.Plane.Z","h3d/col/Plane.hx",89,0x675b44c7)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(89)
	return ::h3d::col::Plane_obj::__new((int)0,(int)0,(int)1,v);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Plane_obj,Z,return )


Plane_obj::Plane_obj()
{
}

Dynamic Plane_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"X") ) { return X_dyn(); }
		if (HX_FIELD_EQ(inName,"Y") ) { return Y_dyn(); }
		if (HX_FIELD_EQ(inName,"Z") ) { return Z_dyn(); }
		if (HX_FIELD_EQ(inName,"d") ) { return d; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"nx") ) { return nx; }
		if (HX_FIELD_EQ(inName,"ny") ) { return ny; }
		if (HX_FIELD_EQ(inName,"nz") ) { return nz; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"side") ) { return side_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"project") ) { return project_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"distance") ) { return distance_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getNormal") ) { return getNormal_dyn(); }
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		if (HX_FIELD_EQ(inName,"projectTo") ) { return projectTo_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromPoints") ) { return fromPoints_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"fromNormalPoint") ) { return fromNormalPoint_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"getNormalDistance") ) { return getNormalDistance_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Plane_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"d") ) { d=inValue.Cast< Float >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"nx") ) { nx=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ny") ) { ny=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nz") ) { nz=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Plane_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("nx"));
	outFields->push(HX_CSTRING("ny"));
	outFields->push(HX_CSTRING("nz"));
	outFields->push(HX_CSTRING("d"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("fromPoints"),
	HX_CSTRING("fromNormalPoint"),
	HX_CSTRING("X"),
	HX_CSTRING("Y"),
	HX_CSTRING("Z"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Plane_obj,nx),HX_CSTRING("nx")},
	{hx::fsFloat,(int)offsetof(Plane_obj,ny),HX_CSTRING("ny")},
	{hx::fsFloat,(int)offsetof(Plane_obj,nz),HX_CSTRING("nz")},
	{hx::fsFloat,(int)offsetof(Plane_obj,d),HX_CSTRING("d")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("nx"),
	HX_CSTRING("ny"),
	HX_CSTRING("nz"),
	HX_CSTRING("d"),
	HX_CSTRING("getNormal"),
	HX_CSTRING("getNormalDistance"),
	HX_CSTRING("normalize"),
	HX_CSTRING("toString"),
	HX_CSTRING("distance"),
	HX_CSTRING("side"),
	HX_CSTRING("project"),
	HX_CSTRING("projectTo"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Plane_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Plane_obj::__mClass,"__mClass");
};

#endif

Class Plane_obj::__mClass;

void Plane_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.col.Plane"), hx::TCanCast< Plane_obj> ,sStaticFields,sMemberFields,
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

void Plane_obj::__boot()
{
}

} // end namespace h3d
} // end namespace col
