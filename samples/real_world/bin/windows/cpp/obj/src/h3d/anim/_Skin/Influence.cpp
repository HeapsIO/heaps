#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_anim_Joint
#include <h3d/anim/Joint.h>
#endif
#ifndef INCLUDED_h3d_anim__Skin_Influence
#include <h3d/anim/_Skin/Influence.h>
#endif
namespace h3d{
namespace anim{
namespace _Skin{

Void Influence_obj::__construct(::h3d::anim::Joint j,Float w)
{
HX_STACK_FRAME("h3d.anim._Skin.Influence","new",0xaeb1a2cd,"h3d.anim._Skin.Influence.new","h3d/anim/Skin.hx",30,0xee0056d9)
HX_STACK_THIS(this)
HX_STACK_ARG(j,"j")
HX_STACK_ARG(w,"w")
{
	HX_STACK_LINE(31)
	this->j = j;
	HX_STACK_LINE(32)
	this->w = w;
}
;
	return null();
}

//Influence_obj::~Influence_obj() { }

Dynamic Influence_obj::__CreateEmpty() { return  new Influence_obj; }
hx::ObjectPtr< Influence_obj > Influence_obj::__new(::h3d::anim::Joint j,Float w)
{  hx::ObjectPtr< Influence_obj > result = new Influence_obj();
	result->__construct(j,w);
	return result;}

Dynamic Influence_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Influence_obj > result = new Influence_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::String Influence_obj::toString( ){
	HX_STACK_FRAME("h3d.anim._Skin.Influence","toString",0xdf9e131f,"h3d.anim._Skin.Influence.toString","h3d/anim/Skin.hx",35,0xee0056d9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	::String _g = ::Std_obj::string(this->j);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(36)
	::String _g1 = (HX_CSTRING("") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(36)
	::String _g2 = (_g1 + HX_CSTRING(" "));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(36)
	return (_g2 + this->w);
}


HX_DEFINE_DYNAMIC_FUNC0(Influence_obj,toString,return )


Influence_obj::Influence_obj()
{
}

void Influence_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Influence);
	HX_MARK_MEMBER_NAME(j,"j");
	HX_MARK_MEMBER_NAME(w,"w");
	HX_MARK_END_CLASS();
}

void Influence_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(j,"j");
	HX_VISIT_MEMBER_NAME(w,"w");
}

Dynamic Influence_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"j") ) { return j; }
		if (HX_FIELD_EQ(inName,"w") ) { return w; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Influence_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"j") ) { j=inValue.Cast< ::h3d::anim::Joint >(); return inValue; }
		if (HX_FIELD_EQ(inName,"w") ) { w=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Influence_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("j"));
	outFields->push(HX_CSTRING("w"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::anim::Joint*/ ,(int)offsetof(Influence_obj,j),HX_CSTRING("j")},
	{hx::fsFloat,(int)offsetof(Influence_obj,w),HX_CSTRING("w")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("j"),
	HX_CSTRING("w"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Influence_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Influence_obj::__mClass,"__mClass");
};

#endif

Class Influence_obj::__mClass;

void Influence_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim._Skin.Influence"), hx::TCanCast< Influence_obj> ,sStaticFields,sMemberFields,
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

void Influence_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
} // end namespace _Skin
