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
#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
#endif
#ifndef INCLUDED_h3d_anim_Animation
#include <h3d/anim/Animation.h>
#endif
#ifndef INCLUDED_h3d_anim_LinearAnimation
#include <h3d/anim/LinearAnimation.h>
#endif
#ifndef INCLUDED_h3d_anim_LinearFrame
#include <h3d/anim/LinearFrame.h>
#endif
#ifndef INCLUDED_h3d_anim_LinearObject
#include <h3d/anim/LinearObject.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Blend
#include <h3d/mat/Blend.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshMaterial
#include <h3d/mat/MeshMaterial.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshShader
#include <h3d/mat/MeshShader.h>
#endif
#ifndef INCLUDED_h3d_scene_Mesh
#include <h3d/scene/Mesh.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_h3d_scene_Skin
#include <h3d/scene/Skin.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace h3d{
namespace anim{

Void LinearAnimation_obj::__construct(::String name,int frame,Float sampling)
{
HX_STACK_FRAME("h3d.anim.LinearAnimation","new",0x93a007a9,"h3d.anim.LinearAnimation.new","h3d/anim/LinearAnimation.hx",39,0x1f025447)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
HX_STACK_ARG(frame,"frame")
HX_STACK_ARG(sampling,"sampling")
{
	HX_STACK_LINE(40)
	super::__construct(name,frame,sampling);
	HX_STACK_LINE(41)
	this->syncFrame = (int)-1;
}
;
	return null();
}

//LinearAnimation_obj::~LinearAnimation_obj() { }

Dynamic LinearAnimation_obj::__CreateEmpty() { return  new LinearAnimation_obj; }
hx::ObjectPtr< LinearAnimation_obj > LinearAnimation_obj::__new(::String name,int frame,Float sampling)
{  hx::ObjectPtr< LinearAnimation_obj > result = new LinearAnimation_obj();
	result->__construct(name,frame,sampling);
	return result;}

Dynamic LinearAnimation_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LinearAnimation_obj > result = new LinearAnimation_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void LinearAnimation_obj::addCurve( ::String objName,Array< ::Dynamic > frames,bool hasRot,bool hasScale){
{
		HX_STACK_FRAME("h3d.anim.LinearAnimation","addCurve",0x91cf32e5,"h3d.anim.LinearAnimation.addCurve","h3d/anim/LinearAnimation.hx",44,0x1f025447)
		HX_STACK_THIS(this)
		HX_STACK_ARG(objName,"objName")
		HX_STACK_ARG(frames,"frames")
		HX_STACK_ARG(hasRot,"hasRot")
		HX_STACK_ARG(hasScale,"hasScale")
		HX_STACK_LINE(45)
		::h3d::anim::LinearObject f = ::h3d::anim::LinearObject_obj::__new(objName);		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(46)
		f->frames = frames;
		HX_STACK_LINE(47)
		f->hasRotation = hasRot;
		HX_STACK_LINE(48)
		f->hasScale = hasScale;
		HX_STACK_LINE(49)
		this->objects->push(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(LinearAnimation_obj,addCurve,(void))

Void LinearAnimation_obj::addAlphaCurve( ::String objName,Array< Float > alphas){
{
		HX_STACK_FRAME("h3d.anim.LinearAnimation","addAlphaCurve",0x8c0a767b,"h3d.anim.LinearAnimation.addAlphaCurve","h3d/anim/LinearAnimation.hx",52,0x1f025447)
		HX_STACK_THIS(this)
		HX_STACK_ARG(objName,"objName")
		HX_STACK_ARG(alphas,"alphas")
		HX_STACK_LINE(53)
		::h3d::anim::LinearObject f = ::h3d::anim::LinearObject_obj::__new(objName);		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(54)
		f->alphas = alphas;
		HX_STACK_LINE(55)
		this->objects->push(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(LinearAnimation_obj,addAlphaCurve,(void))

Array< ::Dynamic > LinearAnimation_obj::getFrames( ){
	HX_STACK_FRAME("h3d.anim.LinearAnimation","getFrames",0x354a8ce5,"h3d.anim.LinearAnimation.getFrames","h3d/anim/LinearAnimation.hx",59,0x1f025447)
	HX_STACK_THIS(this)
	HX_STACK_LINE(59)
	return this->objects;
}


HX_DEFINE_DYNAMIC_FUNC0(LinearAnimation_obj,getFrames,return )

Void LinearAnimation_obj::initInstance( ){
{
		HX_STACK_FRAME("h3d.anim.LinearAnimation","initInstance",0x76c8be5c,"h3d.anim.LinearAnimation.initInstance","h3d/anim/LinearAnimation.hx",62,0x1f025447)
		HX_STACK_THIS(this)
		HX_STACK_LINE(63)
		this->super::initInstance();
		HX_STACK_LINE(64)
		{
			HX_STACK_LINE(64)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(64)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(64)
			while((true)){
				HX_STACK_LINE(64)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(64)
					break;
				}
				HX_STACK_LINE(64)
				::h3d::anim::LinearObject a = _g1->__get(_g).StaticCast< ::h3d::anim::LinearObject >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(64)
				++(_g);
				HX_STACK_LINE(65)
				::h3d::Matrix _g2 = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(65)
				a->matrix = _g2;
				HX_STACK_LINE(66)
				a->matrix->identity();
				struct _Function_3_1{
					inline static bool Block( ::h3d::anim::LinearObject &a){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/anim/LinearAnimation.hx",67,0x1f025447)
						{
							HX_STACK_LINE(67)
							return (  ((!(((a->targetObject == null()))))) ? bool(!(::Std_obj::is(a->targetObject,hx::ClassOf< ::h3d::scene::Mesh >()))) : bool(true) );
						}
						return null();
					}
				};
				HX_STACK_LINE(67)
				if (((  (((a->alphas != null()))) ? bool(_Function_3_1::Block(a)) : bool(false) ))){
					HX_STACK_LINE(68)
					HX_STACK_DO_THROW((a->objectName + HX_CSTRING(" should be a mesh")));
				}
			}
		}
	}
return null();
}


::h3d::anim::Animation LinearAnimation_obj::clone( ::h3d::anim::Animation a){
	HX_STACK_FRAME("h3d.anim.LinearAnimation","clone",0x70a26ee6,"h3d.anim.LinearAnimation.clone","h3d/anim/LinearAnimation.hx",72,0x1f025447)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(73)
	if (((a == null()))){
		HX_STACK_LINE(74)
		::h3d::anim::LinearAnimation _g = ::h3d::anim::LinearAnimation_obj::__new(this->name,this->frameCount,this->sampling);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(74)
		a = _g;
	}
	HX_STACK_LINE(75)
	this->super::clone(a);
	HX_STACK_LINE(76)
	return a;
}


int LinearAnimation_obj::endFrame( ){
	HX_STACK_FRAME("h3d.anim.LinearAnimation","endFrame",0xce9aca69,"h3d.anim.LinearAnimation.endFrame","h3d/anim/LinearAnimation.hx",80,0x1f025447)
	HX_STACK_THIS(this)
	HX_STACK_LINE(80)
	if ((this->loop)){
		HX_STACK_LINE(80)
		return this->frameCount;
	}
	else{
		HX_STACK_LINE(80)
		return (this->frameCount - (int)1);
	}
	HX_STACK_LINE(80)
	return (int)0;
}


Void LinearAnimation_obj::sync( hx::Null< bool >  __o_decompose){
bool decompose = __o_decompose.Default(false);
	HX_STACK_FRAME("h3d.anim.LinearAnimation","sync",0x9bc3e2f2,"h3d.anim.LinearAnimation.sync","h3d/anim/LinearAnimation.hx",84,0x1f025447)
	HX_STACK_THIS(this)
	HX_STACK_ARG(decompose,"decompose")
{
		HX_STACK_LINE(85)
		if (((bool((this->frame == this->syncFrame)) && bool(!(decompose))))){
			HX_STACK_LINE(86)
			return null();
		}
		HX_STACK_LINE(87)
		int frame1 = ::Std_obj::_int(this->frame);		HX_STACK_VAR(frame1,"frame1");
		HX_STACK_LINE(88)
		int frame2 = hx::Mod(((frame1 + (int)1)),this->frameCount);		HX_STACK_VAR(frame2,"frame2");
		HX_STACK_LINE(89)
		Float k2 = (this->frame - frame1);		HX_STACK_VAR(k2,"k2");
		HX_STACK_LINE(90)
		Float k1 = ((int)1 - k2);		HX_STACK_VAR(k1,"k1");
		HX_STACK_LINE(91)
		if (((frame1 < (int)0))){
			HX_STACK_LINE(91)
			int _g = frame2 = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(91)
			frame1 = _g;
		}
		else{
			HX_STACK_LINE(91)
			if (((this->frame >= this->frameCount))){
				HX_STACK_LINE(91)
				int _g1 = frame2 = (this->frameCount - (int)1);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(91)
				frame1 = _g1;
			}
		}
		HX_STACK_LINE(92)
		this->syncFrame = this->frame;
		HX_STACK_LINE(93)
		{
			HX_STACK_LINE(93)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(93)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(93)
			while((true)){
				HX_STACK_LINE(93)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(93)
					break;
				}
				HX_STACK_LINE(93)
				::h3d::anim::LinearObject o = _g1->__get(_g).StaticCast< ::h3d::anim::LinearObject >();		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(93)
				++(_g);
				HX_STACK_LINE(94)
				if (((o->alphas != null()))){
					HX_STACK_LINE(95)
					::h3d::mat::MeshMaterial mat = o->targetObject->toMesh()->material;		HX_STACK_VAR(mat,"mat");
					HX_STACK_LINE(96)
					if (((mat->get_mshader()->colorMul == null()))){
						HX_STACK_LINE(97)
						{
							HX_STACK_LINE(97)
							::h3d::Vector v = ::h3d::Vector_obj::__new((int)1,(int)1,(int)1,(int)1);		HX_STACK_VAR(v,"v");
							HX_STACK_LINE(97)
							mat->get_mshader()->colorMul = v;
						}
						HX_STACK_LINE(98)
						if (((mat->blendDst == ::h3d::mat::Blend_obj::Zero))){
							HX_STACK_LINE(99)
							mat->blend(::h3d::mat::Blend_obj::SrcAlpha,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
						}
					}
					HX_STACK_LINE(101)
					Float _g2 = o->alphas->__unsafe_get(frame1);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(101)
					Float _g3 = (_g2 * k1);		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(101)
					Float _g4 = o->alphas->__unsafe_get(frame2);		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(101)
					Float _g5 = (_g4 * k2);		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(101)
					Float _g6 = (_g3 + _g5);		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(101)
					mat->get_mshader()->colorMul->w = _g6;
					HX_STACK_LINE(102)
					continue;
				}
				HX_STACK_LINE(104)
				::h3d::anim::LinearFrame f1 = o->frames->__unsafe_get(frame1);		HX_STACK_VAR(f1,"f1");
				HX_STACK_LINE(104)
				::h3d::anim::LinearFrame f2 = o->frames->__unsafe_get(frame2);		HX_STACK_VAR(f2,"f2");
				HX_STACK_LINE(106)
				::h3d::Matrix m = o->matrix;		HX_STACK_VAR(m,"m");
				HX_STACK_LINE(108)
				m->_41 = ((f1->tx * k1) + (f2->tx * k2));
				HX_STACK_LINE(109)
				m->_42 = ((f1->ty * k1) + (f2->ty * k2));
				HX_STACK_LINE(110)
				m->_43 = ((f1->tz * k1) + (f2->tz * k2));
				HX_STACK_LINE(112)
				if ((o->hasRotation)){
					HX_STACK_LINE(114)
					Float dot = ((((f1->qx * f2->qx) + (f1->qy * f2->qy)) + (f1->qz * f2->qz)) + (f1->qw * f2->qw));		HX_STACK_VAR(dot,"dot");
					HX_STACK_LINE(115)
					Float q2;		HX_STACK_VAR(q2,"q2");
					HX_STACK_LINE(115)
					if (((dot < (int)0))){
						HX_STACK_LINE(115)
						q2 = -(k2);
					}
					else{
						HX_STACK_LINE(115)
						q2 = k2;
					}
					HX_STACK_LINE(116)
					Float qx = ((f1->qx * k1) + (f2->qx * q2));		HX_STACK_VAR(qx,"qx");
					HX_STACK_LINE(117)
					Float qy = ((f1->qy * k1) + (f2->qy * q2));		HX_STACK_VAR(qy,"qy");
					HX_STACK_LINE(118)
					Float qz = ((f1->qz * k1) + (f2->qz * q2));		HX_STACK_VAR(qz,"qz");
					HX_STACK_LINE(119)
					Float qw = ((f1->qw * k1) + (f2->qw * q2));		HX_STACK_VAR(qw,"qw");
					HX_STACK_LINE(121)
					Float _g7 = ::Math_obj::sqrt(((((qx * qx) + (qy * qy)) + (qz * qz)) + (qw * qw)));		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(121)
					Float ql = (Float((int)1) / Float(_g7));		HX_STACK_VAR(ql,"ql");
					HX_STACK_LINE(122)
					hx::MultEq(qx,ql);
					HX_STACK_LINE(123)
					hx::MultEq(qy,ql);
					HX_STACK_LINE(124)
					hx::MultEq(qz,ql);
					HX_STACK_LINE(125)
					hx::MultEq(qw,ql);
					HX_STACK_LINE(127)
					if ((decompose)){
						HX_STACK_LINE(128)
						m->_12 = qx;
						HX_STACK_LINE(129)
						m->_13 = qy;
						HX_STACK_LINE(130)
						m->_21 = qz;
						HX_STACK_LINE(131)
						m->_23 = qw;
						HX_STACK_LINE(132)
						if ((o->hasScale)){
							HX_STACK_LINE(133)
							m->_11 = ((f1->sx * k1) + (f2->sx * k2));
							HX_STACK_LINE(134)
							m->_22 = ((f1->sy * k1) + (f2->sy * k2));
							HX_STACK_LINE(135)
							m->_33 = ((f1->sz * k1) + (f2->sz * k2));
						}
					}
					else{
						HX_STACK_LINE(139)
						Float xx = (qx * qx);		HX_STACK_VAR(xx,"xx");
						HX_STACK_LINE(140)
						Float xy = (qx * qy);		HX_STACK_VAR(xy,"xy");
						HX_STACK_LINE(141)
						Float xz = (qx * qz);		HX_STACK_VAR(xz,"xz");
						HX_STACK_LINE(142)
						Float xw = (qx * qw);		HX_STACK_VAR(xw,"xw");
						HX_STACK_LINE(143)
						Float yy = (qy * qy);		HX_STACK_VAR(yy,"yy");
						HX_STACK_LINE(144)
						Float yz = (qy * qz);		HX_STACK_VAR(yz,"yz");
						HX_STACK_LINE(145)
						Float yw = (qy * qw);		HX_STACK_VAR(yw,"yw");
						HX_STACK_LINE(146)
						Float zz = (qz * qz);		HX_STACK_VAR(zz,"zz");
						HX_STACK_LINE(147)
						Float zw = (qz * qw);		HX_STACK_VAR(zw,"zw");
						HX_STACK_LINE(148)
						m->_11 = ((int)1 - ((int)2 * ((yy + zz))));
						HX_STACK_LINE(149)
						m->_12 = ((int)2 * ((xy + zw)));
						HX_STACK_LINE(150)
						m->_13 = ((int)2 * ((xz - yw)));
						HX_STACK_LINE(151)
						m->_21 = ((int)2 * ((xy - zw)));
						HX_STACK_LINE(152)
						m->_22 = ((int)1 - ((int)2 * ((xx + zz))));
						HX_STACK_LINE(153)
						m->_23 = ((int)2 * ((yz + xw)));
						HX_STACK_LINE(154)
						m->_31 = ((int)2 * ((xz + yw)));
						HX_STACK_LINE(155)
						m->_32 = ((int)2 * ((yz - xw)));
						HX_STACK_LINE(156)
						m->_33 = ((int)1 - ((int)2 * ((xx + yy))));
						HX_STACK_LINE(157)
						if ((o->hasScale)){
							HX_STACK_LINE(158)
							Float sx = ((f1->sx * k1) + (f2->sx * k2));		HX_STACK_VAR(sx,"sx");
							HX_STACK_LINE(159)
							Float sy = ((f1->sy * k1) + (f2->sy * k2));		HX_STACK_VAR(sy,"sy");
							HX_STACK_LINE(160)
							Float sz = ((f1->sz * k1) + (f2->sz * k2));		HX_STACK_VAR(sz,"sz");
							HX_STACK_LINE(161)
							hx::MultEq(m->_11,sx);
							HX_STACK_LINE(162)
							hx::MultEq(m->_12,sx);
							HX_STACK_LINE(163)
							hx::MultEq(m->_13,sx);
							HX_STACK_LINE(164)
							hx::MultEq(m->_21,sy);
							HX_STACK_LINE(165)
							hx::MultEq(m->_22,sy);
							HX_STACK_LINE(166)
							hx::MultEq(m->_23,sy);
							HX_STACK_LINE(167)
							hx::MultEq(m->_31,sz);
							HX_STACK_LINE(168)
							hx::MultEq(m->_32,sz);
							HX_STACK_LINE(169)
							hx::MultEq(m->_33,sz);
						}
					}
				}
				else{
					HX_STACK_LINE(173)
					if ((o->hasScale)){
						HX_STACK_LINE(174)
						m->_11 = ((f1->sx * k1) + (f2->sx * k2));
						HX_STACK_LINE(175)
						m->_22 = ((f1->sy * k1) + (f2->sy * k2));
						HX_STACK_LINE(176)
						m->_33 = ((f1->sz * k1) + (f2->sz * k2));
					}
				}
				HX_STACK_LINE(180)
				if (((o->targetSkin != null()))){
					HX_STACK_LINE(181)
					o->targetSkin->currentRelPose[o->targetJoint] = o->matrix;
					HX_STACK_LINE(182)
					o->targetSkin->jointsUpdated = true;
				}
				else{
					HX_STACK_LINE(184)
					::h3d::scene::Object _this = o->targetObject;		HX_STACK_VAR(_this,"_this");
					HX_STACK_LINE(184)
					::h3d::Matrix v = o->matrix;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(184)
					_this->defaultTransform = v;
					HX_STACK_LINE(184)
					_this->posChanged = true;
					HX_STACK_LINE(184)
					v;
				}
			}
		}
	}
return null();
}



LinearAnimation_obj::LinearAnimation_obj()
{
}

Dynamic LinearAnimation_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"addCurve") ) { return addCurve_dyn(); }
		if (HX_FIELD_EQ(inName,"endFrame") ) { return endFrame_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"syncFrame") ) { return syncFrame; }
		if (HX_FIELD_EQ(inName,"getFrames") ) { return getFrames_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"initInstance") ) { return initInstance_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"addAlphaCurve") ) { return addAlphaCurve_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic LinearAnimation_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"syncFrame") ) { syncFrame=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void LinearAnimation_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("syncFrame"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(LinearAnimation_obj,syncFrame),HX_CSTRING("syncFrame")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("syncFrame"),
	HX_CSTRING("addCurve"),
	HX_CSTRING("addAlphaCurve"),
	HX_CSTRING("getFrames"),
	HX_CSTRING("initInstance"),
	HX_CSTRING("clone"),
	HX_CSTRING("endFrame"),
	HX_CSTRING("sync"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(LinearAnimation_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(LinearAnimation_obj::__mClass,"__mClass");
};

#endif

Class LinearAnimation_obj::__mClass;

void LinearAnimation_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.LinearAnimation"), hx::TCanCast< LinearAnimation_obj> ,sStaticFields,sMemberFields,
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

void LinearAnimation_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
