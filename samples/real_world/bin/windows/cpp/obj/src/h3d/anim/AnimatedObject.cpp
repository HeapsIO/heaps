#include <hxcpp.h>

#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
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

Void AnimatedObject_obj::__construct(::String name)
{
HX_STACK_FRAME("h3d.anim.AnimatedObject","new",0x03ac9bdc,"h3d.anim.AnimatedObject.new","h3d/anim/Animation.hx",14,0x61b45cc2)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
{
	HX_STACK_LINE(14)
	this->objectName = name;
}
;
	return null();
}

//AnimatedObject_obj::~AnimatedObject_obj() { }

Dynamic AnimatedObject_obj::__CreateEmpty() { return  new AnimatedObject_obj; }
hx::ObjectPtr< AnimatedObject_obj > AnimatedObject_obj::__new(::String name)
{  hx::ObjectPtr< AnimatedObject_obj > result = new AnimatedObject_obj();
	result->__construct(name);
	return result;}

Dynamic AnimatedObject_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AnimatedObject_obj > result = new AnimatedObject_obj();
	result->__construct(inArgs[0]);
	return result;}

::h3d::anim::AnimatedObject AnimatedObject_obj::clone( ){
	HX_STACK_FRAME("h3d.anim.AnimatedObject","clone",0x6c22b5d9,"h3d.anim.AnimatedObject.clone","h3d/anim/Animation.hx",18,0x61b45cc2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(18)
	return ::h3d::anim::AnimatedObject_obj::__new(this->objectName);
}


HX_DEFINE_DYNAMIC_FUNC0(AnimatedObject_obj,clone,return )


AnimatedObject_obj::AnimatedObject_obj()
{
}

void AnimatedObject_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AnimatedObject);
	HX_MARK_MEMBER_NAME(objectName,"objectName");
	HX_MARK_MEMBER_NAME(targetObject,"targetObject");
	HX_MARK_MEMBER_NAME(targetSkin,"targetSkin");
	HX_MARK_MEMBER_NAME(targetJoint,"targetJoint");
	HX_MARK_END_CLASS();
}

void AnimatedObject_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(objectName,"objectName");
	HX_VISIT_MEMBER_NAME(targetObject,"targetObject");
	HX_VISIT_MEMBER_NAME(targetSkin,"targetSkin");
	HX_VISIT_MEMBER_NAME(targetJoint,"targetJoint");
}

Dynamic AnimatedObject_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"objectName") ) { return objectName; }
		if (HX_FIELD_EQ(inName,"targetSkin") ) { return targetSkin; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"targetJoint") ) { return targetJoint; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"targetObject") ) { return targetObject; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic AnimatedObject_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"objectName") ) { objectName=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"targetSkin") ) { targetSkin=inValue.Cast< ::h3d::scene::Skin >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"targetJoint") ) { targetJoint=inValue.Cast< int >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"targetObject") ) { targetObject=inValue.Cast< ::h3d::scene::Object >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void AnimatedObject_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("objectName"));
	outFields->push(HX_CSTRING("targetObject"));
	outFields->push(HX_CSTRING("targetSkin"));
	outFields->push(HX_CSTRING("targetJoint"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(AnimatedObject_obj,objectName),HX_CSTRING("objectName")},
	{hx::fsObject /*::h3d::scene::Object*/ ,(int)offsetof(AnimatedObject_obj,targetObject),HX_CSTRING("targetObject")},
	{hx::fsObject /*::h3d::scene::Skin*/ ,(int)offsetof(AnimatedObject_obj,targetSkin),HX_CSTRING("targetSkin")},
	{hx::fsInt,(int)offsetof(AnimatedObject_obj,targetJoint),HX_CSTRING("targetJoint")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("objectName"),
	HX_CSTRING("targetObject"),
	HX_CSTRING("targetSkin"),
	HX_CSTRING("targetJoint"),
	HX_CSTRING("clone"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AnimatedObject_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(AnimatedObject_obj::__mClass,"__mClass");
};

#endif

Class AnimatedObject_obj::__mClass;

void AnimatedObject_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.AnimatedObject"), hx::TCanCast< AnimatedObject_obj> ,sStaticFields,sMemberFields,
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

void AnimatedObject_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
