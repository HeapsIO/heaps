#include <hxcpp.h>

#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
#ifndef INCLUDED_h3d_fbx_DefaultMatrixes
#include <h3d/fbx/DefaultMatrixes.h>
#endif
namespace h3d{
namespace fbx{

Void DefaultMatrixes_obj::__construct()
{
HX_STACK_FRAME("h3d.fbx.DefaultMatrixes","new",0x242475bb,"h3d.fbx.DefaultMatrixes.new","h3d/fbx/Library.hx",25,0x38e70acc)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//DefaultMatrixes_obj::~DefaultMatrixes_obj() { }

Dynamic DefaultMatrixes_obj::__CreateEmpty() { return  new DefaultMatrixes_obj; }
hx::ObjectPtr< DefaultMatrixes_obj > DefaultMatrixes_obj::__new()
{  hx::ObjectPtr< DefaultMatrixes_obj > result = new DefaultMatrixes_obj();
	result->__construct();
	return result;}

Dynamic DefaultMatrixes_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DefaultMatrixes_obj > result = new DefaultMatrixes_obj();
	result->__construct();
	return result;}

::h3d::Matrix DefaultMatrixes_obj::toMatrix( bool leftHand){
	HX_STACK_FRAME("h3d.fbx.DefaultMatrixes","toMatrix",0x3239eee1,"h3d.fbx.DefaultMatrixes.toMatrix","h3d/fbx/Library.hx",40,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(leftHand,"leftHand")
	HX_STACK_LINE(41)
	::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(42)
	m->identity();
	HX_STACK_LINE(43)
	if (((this->scale != null()))){
		HX_STACK_LINE(43)
		m->scale(this->scale->x,this->scale->y,this->scale->z);
	}
	HX_STACK_LINE(44)
	if (((this->rotate != null()))){
		HX_STACK_LINE(44)
		m->rotate(this->rotate->x,this->rotate->y,this->rotate->z);
	}
	HX_STACK_LINE(45)
	if (((this->preRot != null()))){
		HX_STACK_LINE(45)
		m->rotate(this->preRot->x,this->preRot->y,this->preRot->z);
	}
	HX_STACK_LINE(46)
	if (((this->trans != null()))){
		HX_STACK_LINE(46)
		m->translate(this->trans->x,this->trans->y,this->trans->z);
	}
	HX_STACK_LINE(47)
	if ((leftHand)){
		HX_STACK_LINE(47)
		hx::MultEq(m->_12,(int)-1);
		HX_STACK_LINE(47)
		hx::MultEq(m->_13,(int)-1);
		HX_STACK_LINE(47)
		hx::MultEq(m->_21,(int)-1);
		HX_STACK_LINE(47)
		hx::MultEq(m->_31,(int)-1);
		HX_STACK_LINE(47)
		hx::MultEq(m->_41,(int)-1);
	}
	HX_STACK_LINE(48)
	return m;
}


HX_DEFINE_DYNAMIC_FUNC1(DefaultMatrixes_obj,toMatrix,return )

Void DefaultMatrixes_obj::rightHandToLeft( ::h3d::Matrix m){
{
		HX_STACK_FRAME("h3d.fbx.DefaultMatrixes","rightHandToLeft",0x5abc8cc8,"h3d.fbx.DefaultMatrixes.rightHandToLeft","h3d/fbx/Library.hx",28,0x38e70acc)
		HX_STACK_ARG(m,"m")
		HX_STACK_LINE(33)
		hx::MultEq(m->_12,(int)-1);
		HX_STACK_LINE(34)
		hx::MultEq(m->_13,(int)-1);
		HX_STACK_LINE(35)
		hx::MultEq(m->_21,(int)-1);
		HX_STACK_LINE(36)
		hx::MultEq(m->_31,(int)-1);
		HX_STACK_LINE(37)
		hx::MultEq(m->_41,(int)-1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(DefaultMatrixes_obj,rightHandToLeft,(void))


DefaultMatrixes_obj::DefaultMatrixes_obj()
{
}

void DefaultMatrixes_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DefaultMatrixes);
	HX_MARK_MEMBER_NAME(trans,"trans");
	HX_MARK_MEMBER_NAME(scale,"scale");
	HX_MARK_MEMBER_NAME(rotate,"rotate");
	HX_MARK_MEMBER_NAME(preRot,"preRot");
	HX_MARK_MEMBER_NAME(wasRemoved,"wasRemoved");
	HX_MARK_END_CLASS();
}

void DefaultMatrixes_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(trans,"trans");
	HX_VISIT_MEMBER_NAME(scale,"scale");
	HX_VISIT_MEMBER_NAME(rotate,"rotate");
	HX_VISIT_MEMBER_NAME(preRot,"preRot");
	HX_VISIT_MEMBER_NAME(wasRemoved,"wasRemoved");
}

Dynamic DefaultMatrixes_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"trans") ) { return trans; }
		if (HX_FIELD_EQ(inName,"scale") ) { return scale; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"rotate") ) { return rotate; }
		if (HX_FIELD_EQ(inName,"preRot") ) { return preRot; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toMatrix") ) { return toMatrix_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"wasRemoved") ) { return wasRemoved; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"rightHandToLeft") ) { return rightHandToLeft_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DefaultMatrixes_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"trans") ) { trans=inValue.Cast< ::h3d::col::Point >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scale") ) { scale=inValue.Cast< ::h3d::col::Point >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"rotate") ) { rotate=inValue.Cast< ::h3d::col::Point >(); return inValue; }
		if (HX_FIELD_EQ(inName,"preRot") ) { preRot=inValue.Cast< ::h3d::col::Point >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"wasRemoved") ) { wasRemoved=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DefaultMatrixes_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("trans"));
	outFields->push(HX_CSTRING("scale"));
	outFields->push(HX_CSTRING("rotate"));
	outFields->push(HX_CSTRING("preRot"));
	outFields->push(HX_CSTRING("wasRemoved"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("rightHandToLeft"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::col::Point*/ ,(int)offsetof(DefaultMatrixes_obj,trans),HX_CSTRING("trans")},
	{hx::fsObject /*::h3d::col::Point*/ ,(int)offsetof(DefaultMatrixes_obj,scale),HX_CSTRING("scale")},
	{hx::fsObject /*::h3d::col::Point*/ ,(int)offsetof(DefaultMatrixes_obj,rotate),HX_CSTRING("rotate")},
	{hx::fsObject /*::h3d::col::Point*/ ,(int)offsetof(DefaultMatrixes_obj,preRot),HX_CSTRING("preRot")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(DefaultMatrixes_obj,wasRemoved),HX_CSTRING("wasRemoved")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("trans"),
	HX_CSTRING("scale"),
	HX_CSTRING("rotate"),
	HX_CSTRING("preRot"),
	HX_CSTRING("wasRemoved"),
	HX_CSTRING("toMatrix"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DefaultMatrixes_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DefaultMatrixes_obj::__mClass,"__mClass");
};

#endif

Class DefaultMatrixes_obj::__mClass;

void DefaultMatrixes_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.DefaultMatrixes"), hx::TCanCast< DefaultMatrixes_obj> ,sStaticFields,sMemberFields,
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

void DefaultMatrixes_obj::__boot()
{
}

} // end namespace h3d
} // end namespace fbx
