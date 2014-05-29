#include <hxcpp.h>

#ifndef INCLUDED_h3d_anim_MorphShape
#include <h3d/anim/MorphShape.h>
#endif
namespace h3d{
namespace anim{

Void MorphShape_obj::__construct(Array< int > i,Array< Float > v,Array< Float > n)
{
HX_STACK_FRAME("h3d.anim.MorphShape","new",0x9cdb9ed3,"h3d.anim.MorphShape.new","h3d/anim/MorphFrameAnimation.hx",14,0x117abca7)
HX_STACK_THIS(this)
HX_STACK_ARG(i,"i")
HX_STACK_ARG(v,"v")
HX_STACK_ARG(n,"n")
{
	HX_STACK_LINE(15)
	this->index = i;
	HX_STACK_LINE(16)
	this->vertex = v;
	HX_STACK_LINE(17)
	this->normal = n;
}
;
	return null();
}

//MorphShape_obj::~MorphShape_obj() { }

Dynamic MorphShape_obj::__CreateEmpty() { return  new MorphShape_obj; }
hx::ObjectPtr< MorphShape_obj > MorphShape_obj::__new(Array< int > i,Array< Float > v,Array< Float > n)
{  hx::ObjectPtr< MorphShape_obj > result = new MorphShape_obj();
	result->__construct(i,v,n);
	return result;}

Dynamic MorphShape_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MorphShape_obj > result = new MorphShape_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}


MorphShape_obj::MorphShape_obj()
{
}

void MorphShape_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MorphShape);
	HX_MARK_MEMBER_NAME(index,"index");
	HX_MARK_MEMBER_NAME(vertex,"vertex");
	HX_MARK_MEMBER_NAME(normal,"normal");
	HX_MARK_END_CLASS();
}

void MorphShape_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(index,"index");
	HX_VISIT_MEMBER_NAME(vertex,"vertex");
	HX_VISIT_MEMBER_NAME(normal,"normal");
}

Dynamic MorphShape_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { return index; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"vertex") ) { return vertex; }
		if (HX_FIELD_EQ(inName,"normal") ) { return normal; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MorphShape_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { index=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"vertex") ) { vertex=inValue.Cast< Array< Float > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"normal") ) { normal=inValue.Cast< Array< Float > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MorphShape_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("index"));
	outFields->push(HX_CSTRING("vertex"));
	outFields->push(HX_CSTRING("normal"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(MorphShape_obj,index),HX_CSTRING("index")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(MorphShape_obj,vertex),HX_CSTRING("vertex")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(MorphShape_obj,normal),HX_CSTRING("normal")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("index"),
	HX_CSTRING("vertex"),
	HX_CSTRING("normal"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MorphShape_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MorphShape_obj::__mClass,"__mClass");
};

#endif

Class MorphShape_obj::__mClass;

void MorphShape_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.MorphShape"), hx::TCanCast< MorphShape_obj> ,sStaticFields,sMemberFields,
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

void MorphShape_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
