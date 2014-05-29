#include <hxcpp.h>

#ifndef INCLUDED_h3d_fbx_AnimationMode
#include <h3d/fbx/AnimationMode.h>
#endif
namespace h3d{
namespace fbx{

::h3d::fbx::AnimationMode AnimationMode_obj::FrameAnim;

::h3d::fbx::AnimationMode AnimationMode_obj::LinearAnim;

HX_DEFINE_CREATE_ENUM(AnimationMode_obj)

int AnimationMode_obj::__FindIndex(::String inName)
{
	if (inName==HX_CSTRING("FrameAnim")) return 0;
	if (inName==HX_CSTRING("LinearAnim")) return 1;
	return super::__FindIndex(inName);
}

int AnimationMode_obj::__FindArgCount(::String inName)
{
	if (inName==HX_CSTRING("FrameAnim")) return 0;
	if (inName==HX_CSTRING("LinearAnim")) return 0;
	return super::__FindArgCount(inName);
}

Dynamic AnimationMode_obj::__Field(const ::String &inName,bool inCallProp)
{
	if (inName==HX_CSTRING("FrameAnim")) return FrameAnim;
	if (inName==HX_CSTRING("LinearAnim")) return LinearAnim;
	return super::__Field(inName,inCallProp);
}

static ::String sStaticFields[] = {
	HX_CSTRING("FrameAnim"),
	HX_CSTRING("LinearAnim"),
	::String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AnimationMode_obj::FrameAnim,"FrameAnim");
	HX_MARK_MEMBER_NAME(AnimationMode_obj::LinearAnim,"LinearAnim");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatic(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(AnimationMode_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(AnimationMode_obj::FrameAnim,"FrameAnim");
	HX_VISIT_MEMBER_NAME(AnimationMode_obj::LinearAnim,"LinearAnim");
};
#endif

static ::String sMemberFields[] = { ::String(null()) };
Class AnimationMode_obj::__mClass;

Dynamic __Create_AnimationMode_obj() { return new AnimationMode_obj; }

void AnimationMode_obj::__register()
{

hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.AnimationMode"), hx::TCanCast< AnimationMode_obj >,sStaticFields,sMemberFields,
	&__Create_AnimationMode_obj, &__Create,
	&super::__SGetClass(), &CreateAnimationMode_obj, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatic
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
}

void AnimationMode_obj::__boot()
{
hx::Static(FrameAnim) = hx::CreateEnum< AnimationMode_obj >(HX_CSTRING("FrameAnim"),0);
hx::Static(LinearAnim) = hx::CreateEnum< AnimationMode_obj >(HX_CSTRING("LinearAnim"),1);
}


} // end namespace h3d
} // end namespace fbx
