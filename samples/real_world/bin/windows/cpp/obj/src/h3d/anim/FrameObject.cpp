#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
#endif
#ifndef INCLUDED_h3d_anim_FrameObject
#include <h3d/anim/FrameObject.h>
#endif
namespace h3d{
namespace anim{

Void FrameObject_obj::__construct(::String name)
{
HX_STACK_FRAME("h3d.anim.FrameObject","new",0x8c6aa896,"h3d.anim.FrameObject.new","h3d/anim/FrameAnimation.hx",4,0x146ee67f)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
{
	HX_STACK_LINE(4)
	super::__construct(name);
}
;
	return null();
}

//FrameObject_obj::~FrameObject_obj() { }

Dynamic FrameObject_obj::__CreateEmpty() { return  new FrameObject_obj; }
hx::ObjectPtr< FrameObject_obj > FrameObject_obj::__new(::String name)
{  hx::ObjectPtr< FrameObject_obj > result = new FrameObject_obj();
	result->__construct(name);
	return result;}

Dynamic FrameObject_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FrameObject_obj > result = new FrameObject_obj();
	result->__construct(inArgs[0]);
	return result;}

::h3d::anim::AnimatedObject FrameObject_obj::clone( ){
	HX_STACK_FRAME("h3d.anim.FrameObject","clone",0x2a08e513,"h3d.anim.FrameObject.clone","h3d/anim/FrameAnimation.hx",8,0x146ee67f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(9)
	::h3d::anim::FrameObject o = ::h3d::anim::FrameObject_obj::__new(this->objectName);		HX_STACK_VAR(o,"o");
	HX_STACK_LINE(10)
	o->frames = this->frames;
	HX_STACK_LINE(11)
	o->alphas = this->alphas;
	HX_STACK_LINE(12)
	return o;
}



FrameObject_obj::FrameObject_obj()
{
}

void FrameObject_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FrameObject);
	HX_MARK_MEMBER_NAME(frames,"frames");
	HX_MARK_MEMBER_NAME(alphas,"alphas");
	::h3d::anim::AnimatedObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void FrameObject_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(frames,"frames");
	HX_VISIT_MEMBER_NAME(alphas,"alphas");
	::h3d::anim::AnimatedObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic FrameObject_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { return frames; }
		if (HX_FIELD_EQ(inName,"alphas") ) { return alphas; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FrameObject_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { frames=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alphas") ) { alphas=inValue.Cast< Array< Float > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FrameObject_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("frames"));
	outFields->push(HX_CSTRING("alphas"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(FrameObject_obj,frames),HX_CSTRING("frames")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FrameObject_obj,alphas),HX_CSTRING("alphas")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("frames"),
	HX_CSTRING("alphas"),
	HX_CSTRING("clone"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FrameObject_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FrameObject_obj::__mClass,"__mClass");
};

#endif

Class FrameObject_obj::__mClass;

void FrameObject_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.FrameObject"), hx::TCanCast< FrameObject_obj> ,sStaticFields,sMemberFields,
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

void FrameObject_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
