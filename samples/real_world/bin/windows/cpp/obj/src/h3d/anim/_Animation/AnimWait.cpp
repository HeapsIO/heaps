#include <hxcpp.h>

#ifndef INCLUDED_h3d_anim__Animation_AnimWait
#include <h3d/anim/_Animation/AnimWait.h>
#endif
namespace h3d{
namespace anim{
namespace _Animation{

Void AnimWait_obj::__construct(Float f,Dynamic c,::h3d::anim::_Animation::AnimWait n)
{
HX_STACK_FRAME("h3d.anim._Animation.AnimWait","new",0x24513799,"h3d.anim._Animation.AnimWait.new","h3d/anim/Animation.hx",27,0x61b45cc2)
HX_STACK_THIS(this)
HX_STACK_ARG(f,"f")
HX_STACK_ARG(c,"c")
HX_STACK_ARG(n,"n")
{
	HX_STACK_LINE(28)
	this->frame = f;
	HX_STACK_LINE(29)
	this->callb = c;
	HX_STACK_LINE(30)
	this->next = n;
}
;
	return null();
}

//AnimWait_obj::~AnimWait_obj() { }

Dynamic AnimWait_obj::__CreateEmpty() { return  new AnimWait_obj; }
hx::ObjectPtr< AnimWait_obj > AnimWait_obj::__new(Float f,Dynamic c,::h3d::anim::_Animation::AnimWait n)
{  hx::ObjectPtr< AnimWait_obj > result = new AnimWait_obj();
	result->__construct(f,c,n);
	return result;}

Dynamic AnimWait_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< AnimWait_obj > result = new AnimWait_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}


AnimWait_obj::AnimWait_obj()
{
}

void AnimWait_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(AnimWait);
	HX_MARK_MEMBER_NAME(frame,"frame");
	HX_MARK_MEMBER_NAME(callb,"callb");
	HX_MARK_MEMBER_NAME(next,"next");
	HX_MARK_END_CLASS();
}

void AnimWait_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(frame,"frame");
	HX_VISIT_MEMBER_NAME(callb,"callb");
	HX_VISIT_MEMBER_NAME(next,"next");
}

Dynamic AnimWait_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return next; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { return frame; }
		if (HX_FIELD_EQ(inName,"callb") ) { return callb; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic AnimWait_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { next=inValue.Cast< ::h3d::anim::_Animation::AnimWait >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { frame=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"callb") ) { callb=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void AnimWait_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("frame"));
	outFields->push(HX_CSTRING("next"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(AnimWait_obj,frame),HX_CSTRING("frame")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(AnimWait_obj,callb),HX_CSTRING("callb")},
	{hx::fsObject /*::h3d::anim::_Animation::AnimWait*/ ,(int)offsetof(AnimWait_obj,next),HX_CSTRING("next")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("frame"),
	HX_CSTRING("callb"),
	HX_CSTRING("next"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(AnimWait_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(AnimWait_obj::__mClass,"__mClass");
};

#endif

Class AnimWait_obj::__mClass;

void AnimWait_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim._Animation.AnimWait"), hx::TCanCast< AnimWait_obj> ,sStaticFields,sMemberFields,
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

void AnimWait_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
} // end namespace _Animation
