#include <hxcpp.h>

#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
#endif
#ifndef INCLUDED_h3d_anim_MorphObject
#include <h3d/anim/MorphObject.h>
#endif
#ifndef INCLUDED_h3d_prim_FBXModel
#include <h3d/prim/FBXModel.h>
#endif
#ifndef INCLUDED_h3d_prim_MeshPrimitive
#include <h3d/prim/MeshPrimitive.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
namespace h3d{
namespace anim{

Void MorphObject_obj::__construct(::String name)
{
HX_STACK_FRAME("h3d.anim.MorphObject","new",0x40e5ecf1,"h3d.anim.MorphObject.new","h3d/anim/MorphFrameAnimation.hx",42,0x117abca7)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
{
	HX_STACK_LINE(42)
	super::__construct(name);
}
;
	return null();
}

//MorphObject_obj::~MorphObject_obj() { }

Dynamic MorphObject_obj::__CreateEmpty() { return  new MorphObject_obj; }
hx::ObjectPtr< MorphObject_obj > MorphObject_obj::__new(::String name)
{  hx::ObjectPtr< MorphObject_obj > result = new MorphObject_obj();
	result->__construct(name);
	return result;}

Dynamic MorphObject_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MorphObject_obj > result = new MorphObject_obj();
	result->__construct(inArgs[0]);
	return result;}

::h3d::anim::AnimatedObject MorphObject_obj::clone( ){
	HX_STACK_FRAME("h3d.anim.MorphObject","clone",0x6722362e,"h3d.anim.MorphObject.clone","h3d/anim/MorphFrameAnimation.hx",46,0x117abca7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(47)
	::h3d::anim::MorphObject o = ::h3d::anim::MorphObject_obj::__new(this->objectName);		HX_STACK_VAR(o,"o");
	HX_STACK_LINE(48)
	o->ratio = this->ratio;
	HX_STACK_LINE(50)
	return o;
}



MorphObject_obj::MorphObject_obj()
{
}

void MorphObject_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MorphObject);
	HX_MARK_MEMBER_NAME(ratio,"ratio");
	HX_MARK_MEMBER_NAME(targetFbxPrim,"targetFbxPrim");
	HX_MARK_MEMBER_NAME(workBuf,"workBuf");
	::h3d::anim::AnimatedObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void MorphObject_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(ratio,"ratio");
	HX_VISIT_MEMBER_NAME(targetFbxPrim,"targetFbxPrim");
	HX_VISIT_MEMBER_NAME(workBuf,"workBuf");
	::h3d::anim::AnimatedObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic MorphObject_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"ratio") ) { return ratio; }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"workBuf") ) { return workBuf; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"targetFbxPrim") ) { return targetFbxPrim; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MorphObject_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"ratio") ) { ratio=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"workBuf") ) { workBuf=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"targetFbxPrim") ) { targetFbxPrim=inValue.Cast< ::h3d::prim::FBXModel >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MorphObject_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("ratio"));
	outFields->push(HX_CSTRING("targetFbxPrim"));
	outFields->push(HX_CSTRING("workBuf"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(MorphObject_obj,ratio),HX_CSTRING("ratio")},
	{hx::fsObject /*::h3d::prim::FBXModel*/ ,(int)offsetof(MorphObject_obj,targetFbxPrim),HX_CSTRING("targetFbxPrim")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(MorphObject_obj,workBuf),HX_CSTRING("workBuf")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("ratio"),
	HX_CSTRING("targetFbxPrim"),
	HX_CSTRING("workBuf"),
	HX_CSTRING("clone"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MorphObject_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MorphObject_obj::__mClass,"__mClass");
};

#endif

Class MorphObject_obj::__mClass;

void MorphObject_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.MorphObject"), hx::TCanCast< MorphObject_obj> ,sStaticFields,sMemberFields,
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

void MorphObject_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
