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
#ifndef INCLUDED_h3d_anim_FrameAnimation
#include <h3d/anim/FrameAnimation.h>
#endif
#ifndef INCLUDED_h3d_anim_FrameObject
#include <h3d/anim/FrameObject.h>
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
namespace h3d{
namespace anim{

Void FrameAnimation_obj::__construct(::String name,int frame,Float sampling)
{
HX_STACK_FRAME("h3d.anim.FrameAnimation","new",0x1b5551b1,"h3d.anim.FrameAnimation.new","h3d/anim/FrameAnimation.hx",20,0x146ee67f)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
HX_STACK_ARG(frame,"frame")
HX_STACK_ARG(sampling,"sampling")
{
	HX_STACK_LINE(21)
	super::__construct(name,frame,sampling);
	HX_STACK_LINE(22)
	this->syncFrame = (int)-1;
}
;
	return null();
}

//FrameAnimation_obj::~FrameAnimation_obj() { }

Dynamic FrameAnimation_obj::__CreateEmpty() { return  new FrameAnimation_obj; }
hx::ObjectPtr< FrameAnimation_obj > FrameAnimation_obj::__new(::String name,int frame,Float sampling)
{  hx::ObjectPtr< FrameAnimation_obj > result = new FrameAnimation_obj();
	result->__construct(name,frame,sampling);
	return result;}

Dynamic FrameAnimation_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FrameAnimation_obj > result = new FrameAnimation_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Void FrameAnimation_obj::addCurve( ::String objName,Array< ::Dynamic > frames){
{
		HX_STACK_FRAME("h3d.anim.FrameAnimation","addCurve",0x95888bdd,"h3d.anim.FrameAnimation.addCurve","h3d/anim/FrameAnimation.hx",25,0x146ee67f)
		HX_STACK_THIS(this)
		HX_STACK_ARG(objName,"objName")
		HX_STACK_ARG(frames,"frames")
		HX_STACK_LINE(26)
		::h3d::anim::FrameObject f = ::h3d::anim::FrameObject_obj::__new(objName);		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(27)
		f->frames = frames;
		HX_STACK_LINE(28)
		this->objects->push(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(FrameAnimation_obj,addCurve,(void))

Void FrameAnimation_obj::addAlphaCurve( ::String objName,Array< Float > alphas){
{
		HX_STACK_FRAME("h3d.anim.FrameAnimation","addAlphaCurve",0xf9f39a83,"h3d.anim.FrameAnimation.addAlphaCurve","h3d/anim/FrameAnimation.hx",31,0x146ee67f)
		HX_STACK_THIS(this)
		HX_STACK_ARG(objName,"objName")
		HX_STACK_ARG(alphas,"alphas")
		HX_STACK_LINE(32)
		::h3d::anim::FrameObject f = ::h3d::anim::FrameObject_obj::__new(objName);		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(33)
		f->alphas = alphas;
		HX_STACK_LINE(34)
		this->objects->push(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(FrameAnimation_obj,addAlphaCurve,(void))

Array< ::Dynamic > FrameAnimation_obj::getFrames( ){
	HX_STACK_FRAME("h3d.anim.FrameAnimation","getFrames",0x73bf0ced,"h3d.anim.FrameAnimation.getFrames","h3d/anim/FrameAnimation.hx",39,0x146ee67f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(39)
	return this->objects;
}


HX_DEFINE_DYNAMIC_FUNC0(FrameAnimation_obj,getFrames,return )

Void FrameAnimation_obj::initInstance( ){
{
		HX_STACK_FRAME("h3d.anim.FrameAnimation","initInstance",0x596df354,"h3d.anim.FrameAnimation.initInstance","h3d/anim/FrameAnimation.hx",42,0x146ee67f)
		HX_STACK_THIS(this)
		HX_STACK_LINE(43)
		this->super::initInstance();
		HX_STACK_LINE(44)
		{
			HX_STACK_LINE(44)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(44)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(44)
			while((true)){
				HX_STACK_LINE(44)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(44)
					break;
				}
				HX_STACK_LINE(44)
				::h3d::anim::FrameObject a = _g1->__get(_g).StaticCast< ::h3d::anim::FrameObject >();		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(44)
				++(_g);
				struct _Function_3_1{
					inline static bool Block( ::h3d::anim::FrameObject &a){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/anim/FrameAnimation.hx",45,0x146ee67f)
						{
							HX_STACK_LINE(45)
							return (  ((!(((a->targetObject == null()))))) ? bool(!(::Std_obj::is(a->targetObject,hx::ClassOf< ::h3d::scene::Mesh >()))) : bool(true) );
						}
						return null();
					}
				};
				HX_STACK_LINE(45)
				if (((  (((a->alphas != null()))) ? bool(_Function_3_1::Block(a)) : bool(false) ))){
					HX_STACK_LINE(46)
					HX_STACK_DO_THROW((a->objectName + HX_CSTRING(" should be a mesh")));
				}
			}
		}
	}
return null();
}


::h3d::anim::Animation FrameAnimation_obj::clone( ::h3d::anim::Animation a){
	HX_STACK_FRAME("h3d.anim.FrameAnimation","clone",0x47c44aee,"h3d.anim.FrameAnimation.clone","h3d/anim/FrameAnimation.hx",49,0x146ee67f)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(50)
	if (((a == null()))){
		HX_STACK_LINE(51)
		::h3d::anim::FrameAnimation _g = ::h3d::anim::FrameAnimation_obj::__new(this->name,this->frameCount,this->sampling);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(51)
		a = _g;
	}
	HX_STACK_LINE(52)
	this->super::clone(a);
	HX_STACK_LINE(53)
	return a;
}


Void FrameAnimation_obj::sync( hx::Null< bool >  __o_decompose){
bool decompose = __o_decompose.Default(false);
	HX_STACK_FRAME("h3d.anim.FrameAnimation","sync",0xd2af5fea,"h3d.anim.FrameAnimation.sync","h3d/anim/FrameAnimation.hx",57,0x146ee67f)
	HX_STACK_THIS(this)
	HX_STACK_ARG(decompose,"decompose")
{
		HX_STACK_LINE(60)
		if ((decompose)){
			HX_STACK_LINE(60)
			HX_STACK_DO_THROW(HX_CSTRING("Decompose not supported on Frame Animation"));
		}
		HX_STACK_LINE(61)
		int frame = ::Std_obj::_int(this->frame);		HX_STACK_VAR(frame,"frame");
		HX_STACK_LINE(62)
		if (((frame < (int)0))){
			HX_STACK_LINE(62)
			frame = (int)0;
		}
		else{
			HX_STACK_LINE(62)
			if (((frame >= this->frameCount))){
				HX_STACK_LINE(62)
				frame = (this->frameCount - (int)1);
			}
		}
		HX_STACK_LINE(63)
		if (((frame == this->syncFrame))){
			HX_STACK_LINE(64)
			return null();
		}
		HX_STACK_LINE(68)
		this->syncFrame = frame;
		HX_STACK_LINE(69)
		{
			HX_STACK_LINE(69)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(69)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(69)
			while((true)){
				HX_STACK_LINE(69)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(69)
					break;
				}
				HX_STACK_LINE(69)
				::h3d::anim::FrameObject o = _g1->__get(_g).StaticCast< ::h3d::anim::FrameObject >();		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(69)
				++(_g);
				HX_STACK_LINE(70)
				if (((o->alphas != null()))){
					HX_STACK_LINE(71)
					::h3d::mat::MeshMaterial mat = o->targetObject->toMesh()->material;		HX_STACK_VAR(mat,"mat");
					HX_STACK_LINE(72)
					if (((mat->get_mshader()->colorMul == null()))){
						HX_STACK_LINE(73)
						{
							HX_STACK_LINE(73)
							::h3d::Vector v = ::h3d::Vector_obj::__new((int)1,(int)1,(int)1,(int)1);		HX_STACK_VAR(v,"v");
							HX_STACK_LINE(73)
							mat->get_mshader()->colorMul = v;
						}
						HX_STACK_LINE(74)
						if (((mat->blendDst == ::h3d::mat::Blend_obj::Zero))){
							HX_STACK_LINE(75)
							mat->blend(::h3d::mat::Blend_obj::SrcAlpha,::h3d::mat::Blend_obj::OneMinusSrcAlpha);
						}
					}
					HX_STACK_LINE(77)
					Float _g2 = o->alphas->__unsafe_get(frame);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(77)
					mat->get_mshader()->colorMul->w = _g2;
				}
				else{
					HX_STACK_LINE(78)
					if (((o->targetSkin != null()))){
						HX_STACK_LINE(79)
						o->targetSkin->currentRelPose[o->targetJoint] = o->frames->__unsafe_get(frame);
						HX_STACK_LINE(80)
						o->targetSkin->jointsUpdated = true;
					}
					else{
						HX_STACK_LINE(82)
						::h3d::scene::Object _this = o->targetObject;		HX_STACK_VAR(_this,"_this");
						HX_STACK_LINE(82)
						::h3d::Matrix v = o->frames->__unsafe_get(frame);		HX_STACK_VAR(v,"v");
						HX_STACK_LINE(82)
						_this->defaultTransform = v;
						HX_STACK_LINE(82)
						_this->posChanged = true;
						HX_STACK_LINE(82)
						v;
					}
				}
			}
		}
	}
return null();
}



FrameAnimation_obj::FrameAnimation_obj()
{
}

Dynamic FrameAnimation_obj::__Field(const ::String &inName,bool inCallProp)
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

Dynamic FrameAnimation_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"syncFrame") ) { syncFrame=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FrameAnimation_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("syncFrame"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(FrameAnimation_obj,syncFrame),HX_CSTRING("syncFrame")},
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
	HX_CSTRING("sync"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FrameAnimation_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FrameAnimation_obj::__mClass,"__mClass");
};

#endif

Class FrameAnimation_obj::__mClass;

void FrameAnimation_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.FrameAnimation"), hx::TCanCast< FrameAnimation_obj> ,sStaticFields,sMemberFields,
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

void FrameAnimation_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
