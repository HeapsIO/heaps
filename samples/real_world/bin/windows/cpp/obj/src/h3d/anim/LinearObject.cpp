#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
#endif
#ifndef INCLUDED_h3d_anim_LinearFrame
#include <h3d/anim/LinearFrame.h>
#endif
#ifndef INCLUDED_h3d_anim_LinearObject
#include <h3d/anim/LinearObject.h>
#endif
namespace h3d{
namespace anim{

Void LinearObject_obj::__construct(::String name)
{
HX_STACK_FRAME("h3d.anim.LinearObject","new",0xf72f079e,"h3d.anim.LinearObject.new","h3d/anim/LinearAnimation.hx",19,0x1f025447)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
{
	HX_STACK_LINE(19)
	super::__construct(name);
}
;
	return null();
}

//LinearObject_obj::~LinearObject_obj() { }

Dynamic LinearObject_obj::__CreateEmpty() { return  new LinearObject_obj; }
hx::ObjectPtr< LinearObject_obj > LinearObject_obj::__new(::String name)
{  hx::ObjectPtr< LinearObject_obj > result = new LinearObject_obj();
	result->__construct(name);
	return result;}

Dynamic LinearObject_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< LinearObject_obj > result = new LinearObject_obj();
	result->__construct(inArgs[0]);
	return result;}

::h3d::anim::AnimatedObject LinearObject_obj::clone( ){
	HX_STACK_FRAME("h3d.anim.LinearObject","clone",0x15e9161b,"h3d.anim.LinearObject.clone","h3d/anim/LinearAnimation.hx",25,0x1f025447)
	HX_STACK_THIS(this)
	HX_STACK_LINE(26)
	::h3d::anim::LinearObject o = ::h3d::anim::LinearObject_obj::__new(this->objectName);		HX_STACK_VAR(o,"o");
	HX_STACK_LINE(27)
	o->hasRotation = this->hasRotation;
	HX_STACK_LINE(28)
	o->hasScale = this->hasScale;
	HX_STACK_LINE(29)
	o->frames = this->frames;
	HX_STACK_LINE(30)
	o->alphas = this->alphas;
	HX_STACK_LINE(31)
	return o;
}



LinearObject_obj::LinearObject_obj()
{
}

void LinearObject_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(LinearObject);
	HX_MARK_MEMBER_NAME(hasRotation,"hasRotation");
	HX_MARK_MEMBER_NAME(hasScale,"hasScale");
	HX_MARK_MEMBER_NAME(frames,"frames");
	HX_MARK_MEMBER_NAME(alphas,"alphas");
	HX_MARK_MEMBER_NAME(matrix,"matrix");
	::h3d::anim::AnimatedObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void LinearObject_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(hasRotation,"hasRotation");
	HX_VISIT_MEMBER_NAME(hasScale,"hasScale");
	HX_VISIT_MEMBER_NAME(frames,"frames");
	HX_VISIT_MEMBER_NAME(alphas,"alphas");
	HX_VISIT_MEMBER_NAME(matrix,"matrix");
	::h3d::anim::AnimatedObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic LinearObject_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { return frames; }
		if (HX_FIELD_EQ(inName,"alphas") ) { return alphas; }
		if (HX_FIELD_EQ(inName,"matrix") ) { return matrix; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"hasScale") ) { return hasScale; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"hasRotation") ) { return hasRotation; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic LinearObject_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"frames") ) { frames=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"alphas") ) { alphas=inValue.Cast< Array< Float > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"matrix") ) { matrix=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"hasScale") ) { hasScale=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"hasRotation") ) { hasRotation=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void LinearObject_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("hasRotation"));
	outFields->push(HX_CSTRING("hasScale"));
	outFields->push(HX_CSTRING("frames"));
	outFields->push(HX_CSTRING("alphas"));
	outFields->push(HX_CSTRING("matrix"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(LinearObject_obj,hasRotation),HX_CSTRING("hasRotation")},
	{hx::fsBool,(int)offsetof(LinearObject_obj,hasScale),HX_CSTRING("hasScale")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(LinearObject_obj,frames),HX_CSTRING("frames")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(LinearObject_obj,alphas),HX_CSTRING("alphas")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(LinearObject_obj,matrix),HX_CSTRING("matrix")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("hasRotation"),
	HX_CSTRING("hasScale"),
	HX_CSTRING("frames"),
	HX_CSTRING("alphas"),
	HX_CSTRING("matrix"),
	HX_CSTRING("clone"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(LinearObject_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(LinearObject_obj::__mClass,"__mClass");
};

#endif

Class LinearObject_obj::__mClass;

void LinearObject_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.LinearObject"), hx::TCanCast< LinearObject_obj> ,sStaticFields,sMemberFields,
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

void LinearObject_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
