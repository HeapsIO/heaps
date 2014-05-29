#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_h3d_Camera
#include <h3d/Camera.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_col_Bounds
#include <h3d/col/Bounds.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Profiler
#include <hxd/Profiler.h>
#endif
namespace h3d{

Void Camera_obj::__construct(hx::Null< Float >  __o_fovX,hx::Null< Float >  __o_zoom,hx::Null< Float >  __o_screenRatio,hx::Null< Float >  __o_zNear,hx::Null< Float >  __o_zFar,hx::Null< bool >  __o_rightHanded)
{
HX_STACK_FRAME("h3d.Camera","new",0x6332994c,"h3d.Camera.new","h3d/Camera.hx",39,0xefcd8b83)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_fovX,"fovX")
HX_STACK_ARG(__o_zoom,"zoom")
HX_STACK_ARG(__o_screenRatio,"screenRatio")
HX_STACK_ARG(__o_zNear,"zNear")
HX_STACK_ARG(__o_zFar,"zFar")
HX_STACK_ARG(__o_rightHanded,"rightHanded")
Float fovX = __o_fovX.Default(60.);
Float zoom = __o_zoom.Default(1.);
Float screenRatio = __o_screenRatio.Default(1.333333);
Float zNear = __o_zNear.Default(0.02);
Float zFar = __o_zFar.Default(1000.);
bool rightHanded = __o_rightHanded.Default(false);
{
	HX_STACK_LINE(40)
	this->fovX = fovX;
	HX_STACK_LINE(41)
	this->zoom = zoom;
	HX_STACK_LINE(42)
	this->screenRatio = screenRatio;
	HX_STACK_LINE(43)
	this->zNear = zNear;
	HX_STACK_LINE(44)
	this->zFar = zFar;
	HX_STACK_LINE(45)
	this->rightHanded = rightHanded;
	HX_STACK_LINE(46)
	::h3d::Vector _g = ::h3d::Vector_obj::__new((int)2,(int)3,(int)4,null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(46)
	this->pos = _g;
	HX_STACK_LINE(47)
	::h3d::Vector _g1 = ::h3d::Vector_obj::__new((int)0,(int)0,(int)1,null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(47)
	this->up = _g1;
	HX_STACK_LINE(48)
	::h3d::Vector _g2 = ::h3d::Vector_obj::__new((int)0,(int)0,(int)0,null());		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(48)
	this->target = _g2;
	HX_STACK_LINE(49)
	::h3d::Matrix _g3 = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(49)
	this->m = _g3;
	HX_STACK_LINE(50)
	::h3d::Matrix _g4 = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(50)
	this->mcam = _g4;
	HX_STACK_LINE(51)
	::h3d::Matrix _g5 = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(51)
	this->mproj = _g5;
	HX_STACK_LINE(52)
	this->update();
}
;
	return null();
}

//Camera_obj::~Camera_obj() { }

Dynamic Camera_obj::__CreateEmpty() { return  new Camera_obj; }
hx::ObjectPtr< Camera_obj > Camera_obj::__new(hx::Null< Float >  __o_fovX,hx::Null< Float >  __o_zoom,hx::Null< Float >  __o_screenRatio,hx::Null< Float >  __o_zNear,hx::Null< Float >  __o_zFar,hx::Null< bool >  __o_rightHanded)
{  hx::ObjectPtr< Camera_obj > result = new Camera_obj();
	result->__construct(__o_fovX,__o_zoom,__o_screenRatio,__o_zNear,__o_zFar,__o_rightHanded);
	return result;}

Dynamic Camera_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Camera_obj > result = new Camera_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}

Void Camera_obj::setFovY( Float value){
{
		HX_STACK_FRAME("h3d.Camera","setFovY",0x39b8545a,"h3d.Camera.setFovY","h3d/Camera.hx",58,0xefcd8b83)
		HX_STACK_THIS(this)
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(59)
		Float _g = ::Math_obj::tan((Float((value * ::Math_obj::PI)) / Float((int)180)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(59)
		Float _g1 = (Float(_g) / Float(this->screenRatio));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(59)
		Float _g2 = ::Math_obj::atan(_g1);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(59)
		Float _g3 = (_g2 * (int)180);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(59)
		Float _g4 = (Float(_g3) / Float(::Math_obj::PI));		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(59)
		this->fovX = _g4;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Camera_obj,setFovY,(void))

::h3d::Camera Camera_obj::clone( ){
	HX_STACK_FRAME("h3d.Camera","clone",0x3736ef49,"h3d.Camera.clone","h3d/Camera.hx",62,0xefcd8b83)
	HX_STACK_THIS(this)
	HX_STACK_LINE(63)
	::h3d::Camera c = ::h3d::Camera_obj::__new(this->fovX,this->zoom,this->screenRatio,this->zNear,this->zFar,this->rightHanded);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(64)
	::h3d::Vector _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(64)
	{
		HX_STACK_LINE(64)
		::h3d::Vector _this = this->pos;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(64)
		_g = ::h3d::Vector_obj::__new(_this->x,_this->y,_this->z,_this->w);
	}
	HX_STACK_LINE(64)
	c->pos = _g;
	HX_STACK_LINE(65)
	::h3d::Vector _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(65)
	{
		HX_STACK_LINE(65)
		::h3d::Vector _this = this->up;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(65)
		_g1 = ::h3d::Vector_obj::__new(_this->x,_this->y,_this->z,_this->w);
	}
	HX_STACK_LINE(65)
	c->up = _g1;
	HX_STACK_LINE(66)
	::h3d::Vector _g2;		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(66)
	{
		HX_STACK_LINE(66)
		::h3d::Vector _this = this->target;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(66)
		_g2 = ::h3d::Vector_obj::__new(_this->x,_this->y,_this->z,_this->w);
	}
	HX_STACK_LINE(66)
	c->target = _g2;
	HX_STACK_LINE(67)
	c->update();
	HX_STACK_LINE(68)
	return c;
}


HX_DEFINE_DYNAMIC_FUNC0(Camera_obj,clone,return )

::h3d::Matrix Camera_obj::getInverseViewProj( ){
	HX_STACK_FRAME("h3d.Camera","getInverseViewProj",0xb20cb510,"h3d.Camera.getInverseViewProj","h3d/Camera.hx",74,0xefcd8b83)
	HX_STACK_THIS(this)
	HX_STACK_LINE(75)
	if (((this->minv == null()))){
		HX_STACK_LINE(75)
		::h3d::Matrix _g = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(75)
		this->minv = _g;
	}
	HX_STACK_LINE(76)
	if ((this->needInv)){
		HX_STACK_LINE(77)
		this->minv->inverse(this->m);
		HX_STACK_LINE(78)
		this->needInv = false;
	}
	HX_STACK_LINE(80)
	return this->minv;
}


HX_DEFINE_DYNAMIC_FUNC0(Camera_obj,getInverseViewProj,return )

::h3d::Vector Camera_obj::unproject( Float screenX,Float screenY,Float camZ){
	HX_STACK_FRAME("h3d.Camera","unproject",0xe9db5b8c,"h3d.Camera.unproject","h3d/Camera.hx",90,0xefcd8b83)
	HX_STACK_THIS(this)
	HX_STACK_ARG(screenX,"screenX")
	HX_STACK_ARG(screenY,"screenY")
	HX_STACK_ARG(camZ,"camZ")
	HX_STACK_LINE(91)
	::h3d::Vector p = ::h3d::Vector_obj::__new(screenX,screenY,camZ,null());		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(92)
	{
		HX_STACK_LINE(92)
		::h3d::Matrix m = this->getInverseViewProj();		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(92)
		Float px = ((((p->x * m->_11) + (p->y * m->_21)) + (p->z * m->_31)) + (p->w * m->_41));		HX_STACK_VAR(px,"px");
		HX_STACK_LINE(92)
		Float py = ((((p->x * m->_12) + (p->y * m->_22)) + (p->z * m->_32)) + (p->w * m->_42));		HX_STACK_VAR(py,"py");
		HX_STACK_LINE(92)
		Float pz = ((((p->x * m->_13) + (p->y * m->_23)) + (p->z * m->_33)) + (p->w * m->_43));		HX_STACK_VAR(pz,"pz");
		HX_STACK_LINE(92)
		Float iw = (Float((int)1) / Float((((((p->x * m->_14) + (p->y * m->_24)) + (p->z * m->_34)) + (p->w * m->_44)))));		HX_STACK_VAR(iw,"iw");
		HX_STACK_LINE(92)
		p->x = (px * iw);
		HX_STACK_LINE(92)
		p->y = (py * iw);
		HX_STACK_LINE(92)
		p->z = (pz * iw);
		HX_STACK_LINE(92)
		p->w = (int)1;
	}
	HX_STACK_LINE(93)
	return p;
}


HX_DEFINE_DYNAMIC_FUNC3(Camera_obj,unproject,return )

Void Camera_obj::update( ){
{
		HX_STACK_FRAME("h3d.Camera","update",0x9192189d,"h3d.Camera.update","h3d/Camera.hx",96,0xefcd8b83)
		HX_STACK_THIS(this)
		HX_STACK_LINE(97)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(97)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(97)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Camera.update"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(97)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Camera.hx",97,0xefcd8b83)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("start") , null(),false);
							__result->Add(HX_CSTRING("total") , 0.0,false);
							__result->Add(HX_CSTRING("hit") , (int)0,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(97)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(97)
				::hxd::Profiler_obj::h->set(HX_CSTRING("Camera.update"),ent);
			}
			HX_STACK_LINE(97)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(97)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
		HX_STACK_LINE(98)
		this->makeCameraMatrix(this->mcam);
		HX_STACK_LINE(99)
		this->makeFrustumMatrix(this->mproj);
		HX_STACK_LINE(100)
		this->m->multiply(this->mcam,this->mproj);
		HX_STACK_LINE(101)
		this->needInv = true;
		HX_STACK_LINE(102)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(102)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(102)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("Camera.update"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(102)
			if (((null() != ent))){
				HX_STACK_LINE(102)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(102)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Camera_obj,update,(void))

bool Camera_obj::lostUp( ){
	HX_STACK_FRAME("h3d.Camera","lostUp",0x6eedc7f3,"h3d.Camera.lostUp","h3d/Camera.hx",105,0xefcd8b83)
	HX_STACK_THIS(this)
	HX_STACK_LINE(106)
	::h3d::Vector p2;		HX_STACK_VAR(p2,"p2");
	HX_STACK_LINE(106)
	{
		HX_STACK_LINE(106)
		::h3d::Vector _this = this->pos;		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(106)
		p2 = ::h3d::Vector_obj::__new(_this->x,_this->y,_this->z,_this->w);
	}
	HX_STACK_LINE(107)
	p2->normalize();
	struct _Function_1_1{
		inline static Float Block( hx::ObjectPtr< ::h3d::Camera_obj > __this,::h3d::Vector &p2){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Camera.hx",108,0xefcd8b83)
			{
				HX_STACK_LINE(108)
				::h3d::Vector v = __this->up;		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(108)
				return (((p2->x * v->x) + (p2->y * v->y)) + (p2->z * v->z));
			}
			return null();
		}
	};
	HX_STACK_LINE(108)
	Float _g = ::Math_obj::abs(_Function_1_1::Block(this,p2));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(108)
	return (_g > 0.999);
}


HX_DEFINE_DYNAMIC_FUNC0(Camera_obj,lostUp,return )

Void Camera_obj::movePosAxis( Float dx,Float dy,hx::Null< Float >  __o_dz){
Float dz = __o_dz.Default(0.);
	HX_STACK_FRAME("h3d.Camera","movePosAxis",0x4f57ce30,"h3d.Camera.movePosAxis","h3d/Camera.hx",111,0xefcd8b83)
	HX_STACK_THIS(this)
	HX_STACK_ARG(dx,"dx")
	HX_STACK_ARG(dy,"dy")
	HX_STACK_ARG(dz,"dz")
{
		HX_STACK_LINE(112)
		::h3d::Vector p = ::h3d::Vector_obj::__new(dx,dy,dz,null());		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(113)
		{
			HX_STACK_LINE(113)
			::h3d::Matrix m = this->mcam;		HX_STACK_VAR(m,"m");
			HX_STACK_LINE(113)
			Float px = ((((p->x * m->_11) + (p->y * m->_21)) + (p->z * m->_31)) + (p->w * m->_41));		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(113)
			Float py = ((((p->x * m->_12) + (p->y * m->_22)) + (p->z * m->_32)) + (p->w * m->_42));		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(113)
			Float pz = ((((p->x * m->_13) + (p->y * m->_23)) + (p->z * m->_33)) + (p->w * m->_43));		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(113)
			Float iw = (Float((int)1) / Float((((((p->x * m->_14) + (p->y * m->_24)) + (p->z * m->_34)) + (p->w * m->_44)))));		HX_STACK_VAR(iw,"iw");
			HX_STACK_LINE(113)
			p->x = (px * iw);
			HX_STACK_LINE(113)
			p->y = (py * iw);
			HX_STACK_LINE(113)
			p->z = (pz * iw);
			HX_STACK_LINE(113)
			p->w = (int)1;
		}
		HX_STACK_LINE(114)
		hx::AddEq(this->pos->x,p->x);
		HX_STACK_LINE(115)
		hx::AddEq(this->pos->y,p->y);
		HX_STACK_LINE(116)
		hx::AddEq(this->pos->z,p->z);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Camera_obj,movePosAxis,(void))

Void Camera_obj::moveTargetAxis( Float dx,Float dy,hx::Null< Float >  __o_dz){
Float dz = __o_dz.Default(0.);
	HX_STACK_FRAME("h3d.Camera","moveTargetAxis",0xf199c597,"h3d.Camera.moveTargetAxis","h3d/Camera.hx",119,0xefcd8b83)
	HX_STACK_THIS(this)
	HX_STACK_ARG(dx,"dx")
	HX_STACK_ARG(dy,"dy")
	HX_STACK_ARG(dz,"dz")
{
		HX_STACK_LINE(120)
		::h3d::Vector p = ::h3d::Vector_obj::__new(dx,dy,dz,null());		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(121)
		{
			HX_STACK_LINE(121)
			::h3d::Matrix m = this->mcam;		HX_STACK_VAR(m,"m");
			HX_STACK_LINE(121)
			Float px = ((((p->x * m->_11) + (p->y * m->_21)) + (p->z * m->_31)) + (p->w * m->_41));		HX_STACK_VAR(px,"px");
			HX_STACK_LINE(121)
			Float py = ((((p->x * m->_12) + (p->y * m->_22)) + (p->z * m->_32)) + (p->w * m->_42));		HX_STACK_VAR(py,"py");
			HX_STACK_LINE(121)
			Float pz = ((((p->x * m->_13) + (p->y * m->_23)) + (p->z * m->_33)) + (p->w * m->_43));		HX_STACK_VAR(pz,"pz");
			HX_STACK_LINE(121)
			Float iw = (Float((int)1) / Float((((((p->x * m->_14) + (p->y * m->_24)) + (p->z * m->_34)) + (p->w * m->_44)))));		HX_STACK_VAR(iw,"iw");
			HX_STACK_LINE(121)
			p->x = (px * iw);
			HX_STACK_LINE(121)
			p->y = (py * iw);
			HX_STACK_LINE(121)
			p->z = (pz * iw);
			HX_STACK_LINE(121)
			p->w = (int)1;
		}
		HX_STACK_LINE(122)
		hx::AddEq(this->target->x,p->x);
		HX_STACK_LINE(123)
		hx::AddEq(this->target->y,p->y);
		HX_STACK_LINE(124)
		hx::AddEq(this->target->z,p->z);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Camera_obj,moveTargetAxis,(void))

Void Camera_obj::makeCameraMatrix( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Camera","makeCameraMatrix",0xfe52c168,"h3d.Camera.makeCameraMatrix","h3d/Camera.hx",127,0xefcd8b83)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(130)
		::h3d::Vector az;		HX_STACK_VAR(az,"az");
		HX_STACK_LINE(130)
		if ((this->rightHanded)){
			HX_STACK_LINE(130)
			::h3d::Vector _this = this->pos;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(130)
			::h3d::Vector v = this->target;		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(130)
			az = ::h3d::Vector_obj::__new((_this->x - v->x),(_this->y - v->y),(_this->z - v->z),(_this->w - v->w));
		}
		else{
			HX_STACK_LINE(130)
			::h3d::Vector _this = this->target;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(130)
			::h3d::Vector v = this->pos;		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(130)
			az = ::h3d::Vector_obj::__new((_this->x - v->x),(_this->y - v->y),(_this->z - v->z),(_this->w - v->w));
		}
		HX_STACK_LINE(131)
		az->normalize();
		HX_STACK_LINE(132)
		::h3d::Vector ax;		HX_STACK_VAR(ax,"ax");
		HX_STACK_LINE(132)
		{
			HX_STACK_LINE(132)
			::h3d::Vector _this = this->up;		HX_STACK_VAR(_this,"_this");
			HX_STACK_LINE(132)
			ax = ::h3d::Vector_obj::__new(((_this->y * az->z) - (_this->z * az->y)),((_this->z * az->x) - (_this->x * az->z)),((_this->x * az->y) - (_this->y * az->x)),(int)1);
		}
		HX_STACK_LINE(133)
		ax->normalize();
		HX_STACK_LINE(134)
		Float _g = ::Math_obj::sqrt((((ax->x * ax->x) + (ax->y * ax->y)) + (ax->z * ax->z)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(134)
		if (((_g == (int)0))){
			HX_STACK_LINE(135)
			ax->x = az->y;
			HX_STACK_LINE(136)
			ax->y = az->z;
			HX_STACK_LINE(137)
			ax->z = az->x;
		}
		HX_STACK_LINE(139)
		Float ay_x = ((az->y * ax->z) - (az->z * ax->y));		HX_STACK_VAR(ay_x,"ay_x");
		HX_STACK_LINE(139)
		Float ay_y = ((az->z * ax->x) - (az->x * ax->z));		HX_STACK_VAR(ay_y,"ay_y");
		HX_STACK_LINE(139)
		Float ay_z = ((az->x * ax->y) - (az->y * ax->x));		HX_STACK_VAR(ay_z,"ay_z");
		HX_STACK_LINE(139)
		Float ay_w = (int)1;		HX_STACK_VAR(ay_w,"ay_w");
		HX_STACK_LINE(140)
		m->_11 = ax->x;
		HX_STACK_LINE(141)
		m->_12 = ay_x;
		HX_STACK_LINE(142)
		m->_13 = az->x;
		HX_STACK_LINE(143)
		m->_14 = (int)0;
		HX_STACK_LINE(144)
		m->_21 = ax->y;
		HX_STACK_LINE(145)
		m->_22 = ay_y;
		HX_STACK_LINE(146)
		m->_23 = az->y;
		HX_STACK_LINE(147)
		m->_24 = (int)0;
		HX_STACK_LINE(148)
		m->_31 = ax->z;
		HX_STACK_LINE(149)
		m->_32 = ay_z;
		HX_STACK_LINE(150)
		m->_33 = az->z;
		HX_STACK_LINE(151)
		m->_34 = (int)0;
		struct _Function_1_1{
			inline static Float Block( hx::ObjectPtr< ::h3d::Camera_obj > __this,::h3d::Vector &ax){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Camera.hx",152,0xefcd8b83)
				{
					HX_STACK_LINE(152)
					::h3d::Vector v = __this->pos;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(152)
					return (((ax->x * v->x) + (ax->y * v->y)) + (ax->z * v->z));
				}
				return null();
			}
		};
		HX_STACK_LINE(152)
		m->_41 = -(_Function_1_1::Block(this,ax));
		struct _Function_1_2{
			inline static Float Block( Float &ay_y,hx::ObjectPtr< ::h3d::Camera_obj > __this,Float &ay_z,Float &ay_x){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Camera.hx",153,0xefcd8b83)
				{
					HX_STACK_LINE(153)
					::h3d::Vector v = __this->pos;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(153)
					return (((ay_x * v->x) + (ay_y * v->y)) + (ay_z * v->z));
				}
				return null();
			}
		};
		HX_STACK_LINE(153)
		m->_42 = -(_Function_1_2::Block(ay_y,this,ay_z,ay_x));
		struct _Function_1_3{
			inline static Float Block( hx::ObjectPtr< ::h3d::Camera_obj > __this,::h3d::Vector &az){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/Camera.hx",154,0xefcd8b83)
				{
					HX_STACK_LINE(154)
					::h3d::Vector v = __this->pos;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(154)
					return (((az->x * v->x) + (az->y * v->y)) + (az->z * v->z));
				}
				return null();
			}
		};
		HX_STACK_LINE(154)
		m->_43 = -(_Function_1_3::Block(this,az));
		HX_STACK_LINE(155)
		m->_44 = (int)1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Camera_obj,makeCameraMatrix,(void))

Void Camera_obj::makeFrustumMatrix( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.Camera","makeFrustumMatrix",0xa62fae61,"h3d.Camera.makeFrustumMatrix","h3d/Camera.hx",158,0xefcd8b83)
		HX_STACK_THIS(this)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(159)
		m->zero();
		HX_STACK_LINE(170)
		::h3d::col::Bounds bounds = this->orthoBounds;		HX_STACK_VAR(bounds,"bounds");
		HX_STACK_LINE(171)
		if (((bounds != null()))){
			HX_STACK_LINE(173)
			Float w = (Float((int)1) / Float(((bounds->xMax - bounds->xMin))));		HX_STACK_VAR(w,"w");
			HX_STACK_LINE(174)
			Float h = (Float((int)1) / Float(((bounds->yMax - bounds->yMin))));		HX_STACK_VAR(h,"h");
			HX_STACK_LINE(175)
			Float d = (Float((int)1) / Float(((bounds->zMax - bounds->zMin))));		HX_STACK_VAR(d,"d");
			HX_STACK_LINE(177)
			m->_11 = ((int)2 * w);
			HX_STACK_LINE(178)
			m->_22 = ((int)2 * h);
			HX_STACK_LINE(179)
			m->_33 = d;
			HX_STACK_LINE(180)
			m->_41 = (-(((bounds->xMin + bounds->xMax))) * w);
			HX_STACK_LINE(181)
			m->_42 = (-(((bounds->yMin + bounds->yMax))) * h);
			HX_STACK_LINE(182)
			m->_43 = (-(bounds->zMin) * d);
			HX_STACK_LINE(183)
			m->_44 = (int)1;
		}
		else{
			HX_STACK_LINE(187)
			Float _g = ::Math_obj::tan((Float((this->fovX * ::Math_obj::PI)) / Float(360.0)));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(187)
			Float scale = (Float(this->zoom) / Float(_g));		HX_STACK_VAR(scale,"scale");
			HX_STACK_LINE(188)
			m->_11 = scale;
			HX_STACK_LINE(189)
			m->_22 = (scale * this->screenRatio);
			HX_STACK_LINE(190)
			m->_33 = (Float(this->zFar) / Float(((this->zFar - this->zNear))));
			HX_STACK_LINE(191)
			m->_34 = (int)1;
			HX_STACK_LINE(192)
			m->_43 = (Float(-(((this->zNear * this->zFar)))) / Float(((this->zFar - this->zNear))));
		}
		HX_STACK_LINE(197)
		if ((this->rightHanded)){
			HX_STACK_LINE(198)
			hx::MultEq(m->_33,(int)-1);
			HX_STACK_LINE(199)
			hx::MultEq(m->_34,(int)-1);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Camera_obj,makeFrustumMatrix,(void))


Camera_obj::Camera_obj()
{
}

void Camera_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Camera);
	HX_MARK_MEMBER_NAME(zoom,"zoom");
	HX_MARK_MEMBER_NAME(screenRatio,"screenRatio");
	HX_MARK_MEMBER_NAME(fovX,"fovX");
	HX_MARK_MEMBER_NAME(zNear,"zNear");
	HX_MARK_MEMBER_NAME(zFar,"zFar");
	HX_MARK_MEMBER_NAME(orthoBounds,"orthoBounds");
	HX_MARK_MEMBER_NAME(rightHanded,"rightHanded");
	HX_MARK_MEMBER_NAME(mproj,"mproj");
	HX_MARK_MEMBER_NAME(mcam,"mcam");
	HX_MARK_MEMBER_NAME(m,"m");
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_MEMBER_NAME(up,"up");
	HX_MARK_MEMBER_NAME(target,"target");
	HX_MARK_MEMBER_NAME(minv,"minv");
	HX_MARK_MEMBER_NAME(needInv,"needInv");
	HX_MARK_END_CLASS();
}

void Camera_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(zoom,"zoom");
	HX_VISIT_MEMBER_NAME(screenRatio,"screenRatio");
	HX_VISIT_MEMBER_NAME(fovX,"fovX");
	HX_VISIT_MEMBER_NAME(zNear,"zNear");
	HX_VISIT_MEMBER_NAME(zFar,"zFar");
	HX_VISIT_MEMBER_NAME(orthoBounds,"orthoBounds");
	HX_VISIT_MEMBER_NAME(rightHanded,"rightHanded");
	HX_VISIT_MEMBER_NAME(mproj,"mproj");
	HX_VISIT_MEMBER_NAME(mcam,"mcam");
	HX_VISIT_MEMBER_NAME(m,"m");
	HX_VISIT_MEMBER_NAME(pos,"pos");
	HX_VISIT_MEMBER_NAME(up,"up");
	HX_VISIT_MEMBER_NAME(target,"target");
	HX_VISIT_MEMBER_NAME(minv,"minv");
	HX_VISIT_MEMBER_NAME(needInv,"needInv");
}

Dynamic Camera_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"m") ) { return m; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"up") ) { return up; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"zoom") ) { return zoom; }
		if (HX_FIELD_EQ(inName,"fovX") ) { return fovX; }
		if (HX_FIELD_EQ(inName,"zFar") ) { return zFar; }
		if (HX_FIELD_EQ(inName,"mcam") ) { return mcam; }
		if (HX_FIELD_EQ(inName,"minv") ) { return minv; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"zNear") ) { return zNear; }
		if (HX_FIELD_EQ(inName,"mproj") ) { return mproj; }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"target") ) { return target; }
		if (HX_FIELD_EQ(inName,"update") ) { return update_dyn(); }
		if (HX_FIELD_EQ(inName,"lostUp") ) { return lostUp_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"needInv") ) { return needInv; }
		if (HX_FIELD_EQ(inName,"setFovY") ) { return setFovY_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"unproject") ) { return unproject_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"screenRatio") ) { return screenRatio; }
		if (HX_FIELD_EQ(inName,"orthoBounds") ) { return orthoBounds; }
		if (HX_FIELD_EQ(inName,"rightHanded") ) { return rightHanded; }
		if (HX_FIELD_EQ(inName,"movePosAxis") ) { return movePosAxis_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"moveTargetAxis") ) { return moveTargetAxis_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"makeCameraMatrix") ) { return makeCameraMatrix_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"makeFrustumMatrix") ) { return makeFrustumMatrix_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"getInverseViewProj") ) { return getInverseViewProj_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Camera_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"m") ) { m=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"up") ) { up=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"zoom") ) { zoom=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"fovX") ) { fovX=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"zFar") ) { zFar=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mcam") ) { mcam=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"minv") ) { minv=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"zNear") ) { zNear=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mproj") ) { mproj=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"target") ) { target=inValue.Cast< ::h3d::Vector >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"needInv") ) { needInv=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"screenRatio") ) { screenRatio=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"orthoBounds") ) { orthoBounds=inValue.Cast< ::h3d::col::Bounds >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rightHanded") ) { rightHanded=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Camera_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("zoom"));
	outFields->push(HX_CSTRING("screenRatio"));
	outFields->push(HX_CSTRING("fovX"));
	outFields->push(HX_CSTRING("zNear"));
	outFields->push(HX_CSTRING("zFar"));
	outFields->push(HX_CSTRING("orthoBounds"));
	outFields->push(HX_CSTRING("rightHanded"));
	outFields->push(HX_CSTRING("mproj"));
	outFields->push(HX_CSTRING("mcam"));
	outFields->push(HX_CSTRING("m"));
	outFields->push(HX_CSTRING("pos"));
	outFields->push(HX_CSTRING("up"));
	outFields->push(HX_CSTRING("target"));
	outFields->push(HX_CSTRING("minv"));
	outFields->push(HX_CSTRING("needInv"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Camera_obj,zoom),HX_CSTRING("zoom")},
	{hx::fsFloat,(int)offsetof(Camera_obj,screenRatio),HX_CSTRING("screenRatio")},
	{hx::fsFloat,(int)offsetof(Camera_obj,fovX),HX_CSTRING("fovX")},
	{hx::fsFloat,(int)offsetof(Camera_obj,zNear),HX_CSTRING("zNear")},
	{hx::fsFloat,(int)offsetof(Camera_obj,zFar),HX_CSTRING("zFar")},
	{hx::fsObject /*::h3d::col::Bounds*/ ,(int)offsetof(Camera_obj,orthoBounds),HX_CSTRING("orthoBounds")},
	{hx::fsBool,(int)offsetof(Camera_obj,rightHanded),HX_CSTRING("rightHanded")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Camera_obj,mproj),HX_CSTRING("mproj")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Camera_obj,mcam),HX_CSTRING("mcam")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Camera_obj,m),HX_CSTRING("m")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(Camera_obj,pos),HX_CSTRING("pos")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(Camera_obj,up),HX_CSTRING("up")},
	{hx::fsObject /*::h3d::Vector*/ ,(int)offsetof(Camera_obj,target),HX_CSTRING("target")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Camera_obj,minv),HX_CSTRING("minv")},
	{hx::fsBool,(int)offsetof(Camera_obj,needInv),HX_CSTRING("needInv")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("zoom"),
	HX_CSTRING("screenRatio"),
	HX_CSTRING("fovX"),
	HX_CSTRING("zNear"),
	HX_CSTRING("zFar"),
	HX_CSTRING("orthoBounds"),
	HX_CSTRING("rightHanded"),
	HX_CSTRING("mproj"),
	HX_CSTRING("mcam"),
	HX_CSTRING("m"),
	HX_CSTRING("pos"),
	HX_CSTRING("up"),
	HX_CSTRING("target"),
	HX_CSTRING("minv"),
	HX_CSTRING("needInv"),
	HX_CSTRING("setFovY"),
	HX_CSTRING("clone"),
	HX_CSTRING("getInverseViewProj"),
	HX_CSTRING("unproject"),
	HX_CSTRING("update"),
	HX_CSTRING("lostUp"),
	HX_CSTRING("movePosAxis"),
	HX_CSTRING("moveTargetAxis"),
	HX_CSTRING("makeCameraMatrix"),
	HX_CSTRING("makeFrustumMatrix"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Camera_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Camera_obj::__mClass,"__mClass");
};

#endif

Class Camera_obj::__mClass;

void Camera_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.Camera"), hx::TCanCast< Camera_obj> ,sStaticFields,sMemberFields,
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

void Camera_obj::__boot()
{
}

} // end namespace h3d
