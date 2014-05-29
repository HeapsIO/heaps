#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_anim_Joint
#include <h3d/anim/Joint.h>
#endif
namespace h3d{
namespace anim{

Void Joint_obj::__construct()
{
HX_STACK_FRAME("h3d.anim.Joint","new",0xfc9c7c14,"h3d.anim.Joint.new","h3d/anim/Skin.hx",14,0xee0056d9)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(15)
	this->bindIndex = (int)-1;
	HX_STACK_LINE(16)
	this->subs = Array_obj< ::Dynamic >::__new();
}
;
	return null();
}

//Joint_obj::~Joint_obj() { }

Dynamic Joint_obj::__CreateEmpty() { return  new Joint_obj; }
hx::ObjectPtr< Joint_obj > Joint_obj::__new()
{  hx::ObjectPtr< Joint_obj > result = new Joint_obj();
	result->__construct();
	return result;}

Dynamic Joint_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Joint_obj > result = new Joint_obj();
	result->__construct();
	return result;}

::String Joint_obj::toString( ){
	HX_STACK_FRAME("h3d.anim.Joint","toString",0xb6173878,"h3d.anim.Joint.toString","h3d/anim/Skin.hx",19,0xee0056d9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(20)
	::String _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(20)
	if (((this->parent != null()))){
		HX_STACK_LINE(20)
		_g = ::Std_obj::string(this->parent->index);
	}
	else{
		HX_STACK_LINE(20)
		_g = HX_CSTRING("");
	}
	HX_STACK_LINE(20)
	return (((((((((HX_CSTRING("") + this->index) + HX_CSTRING(" ")) + this->name) + HX_CSTRING(" ")) + this->bindIndex) + HX_CSTRING(" ")) + this->splitIndex) + HX_CSTRING(" ")) + _g);
}


HX_DEFINE_DYNAMIC_FUNC0(Joint_obj,toString,return )


Joint_obj::Joint_obj()
{
}

void Joint_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Joint);
	HX_MARK_MEMBER_NAME(index,"index");
	HX_MARK_MEMBER_NAME(name,"name");
	HX_MARK_MEMBER_NAME(bindIndex,"bindIndex");
	HX_MARK_MEMBER_NAME(splitIndex,"splitIndex");
	HX_MARK_MEMBER_NAME(defMat,"defMat");
	HX_MARK_MEMBER_NAME(transPos,"transPos");
	HX_MARK_MEMBER_NAME(parent,"parent");
	HX_MARK_MEMBER_NAME(subs,"subs");
	HX_MARK_END_CLASS();
}

void Joint_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(index,"index");
	HX_VISIT_MEMBER_NAME(name,"name");
	HX_VISIT_MEMBER_NAME(bindIndex,"bindIndex");
	HX_VISIT_MEMBER_NAME(splitIndex,"splitIndex");
	HX_VISIT_MEMBER_NAME(defMat,"defMat");
	HX_VISIT_MEMBER_NAME(transPos,"transPos");
	HX_VISIT_MEMBER_NAME(parent,"parent");
	HX_VISIT_MEMBER_NAME(subs,"subs");
}

Dynamic Joint_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return name; }
		if (HX_FIELD_EQ(inName,"subs") ) { return subs; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { return index; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"defMat") ) { return defMat; }
		if (HX_FIELD_EQ(inName,"parent") ) { return parent; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"transPos") ) { return transPos; }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"bindIndex") ) { return bindIndex; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"splitIndex") ) { return splitIndex; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Joint_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { name=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"subs") ) { subs=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"index") ) { index=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"defMat") ) { defMat=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		if (HX_FIELD_EQ(inName,"parent") ) { parent=inValue.Cast< ::h3d::anim::Joint >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"transPos") ) { transPos=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"bindIndex") ) { bindIndex=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"splitIndex") ) { splitIndex=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Joint_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("index"));
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("bindIndex"));
	outFields->push(HX_CSTRING("splitIndex"));
	outFields->push(HX_CSTRING("defMat"));
	outFields->push(HX_CSTRING("transPos"));
	outFields->push(HX_CSTRING("parent"));
	outFields->push(HX_CSTRING("subs"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Joint_obj,index),HX_CSTRING("index")},
	{hx::fsString,(int)offsetof(Joint_obj,name),HX_CSTRING("name")},
	{hx::fsInt,(int)offsetof(Joint_obj,bindIndex),HX_CSTRING("bindIndex")},
	{hx::fsInt,(int)offsetof(Joint_obj,splitIndex),HX_CSTRING("splitIndex")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Joint_obj,defMat),HX_CSTRING("defMat")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Joint_obj,transPos),HX_CSTRING("transPos")},
	{hx::fsObject /*::h3d::anim::Joint*/ ,(int)offsetof(Joint_obj,parent),HX_CSTRING("parent")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Joint_obj,subs),HX_CSTRING("subs")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("index"),
	HX_CSTRING("name"),
	HX_CSTRING("bindIndex"),
	HX_CSTRING("splitIndex"),
	HX_CSTRING("defMat"),
	HX_CSTRING("transPos"),
	HX_CSTRING("parent"),
	HX_CSTRING("subs"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Joint_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Joint_obj::__mClass,"__mClass");
};

#endif

Class Joint_obj::__mClass;

void Joint_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.Joint"), hx::TCanCast< Joint_obj> ,sStaticFields,sMemberFields,
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

void Joint_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
