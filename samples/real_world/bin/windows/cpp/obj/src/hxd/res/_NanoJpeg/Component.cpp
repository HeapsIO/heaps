#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_res__NanoJpeg_Component
#include <hxd/res/_NanoJpeg/Component.h>
#endif
namespace hxd{
namespace res{
namespace _NanoJpeg{

Void Component_obj::__construct()
{
HX_STACK_FRAME("hxd.res._NanoJpeg.Component","new",0x5ae80eb4,"hxd.res._NanoJpeg.Component.new","hxd/res/NanoJpeg.hx",50,0xbcbe95b8)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//Component_obj::~Component_obj() { }

Dynamic Component_obj::__CreateEmpty() { return  new Component_obj; }
hx::ObjectPtr< Component_obj > Component_obj::__new()
{  hx::ObjectPtr< Component_obj > result = new Component_obj();
	result->__construct();
	return result;}

Dynamic Component_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Component_obj > result = new Component_obj();
	result->__construct();
	return result;}


Component_obj::Component_obj()
{
}

void Component_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Component);
	HX_MARK_MEMBER_NAME(cid,"cid");
	HX_MARK_MEMBER_NAME(ssx,"ssx");
	HX_MARK_MEMBER_NAME(ssy,"ssy");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(stride,"stride");
	HX_MARK_MEMBER_NAME(qtsel,"qtsel");
	HX_MARK_MEMBER_NAME(actabsel,"actabsel");
	HX_MARK_MEMBER_NAME(dctabsel,"dctabsel");
	HX_MARK_MEMBER_NAME(dcpred,"dcpred");
	HX_MARK_MEMBER_NAME(pixels,"pixels");
	HX_MARK_END_CLASS();
}

void Component_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(cid,"cid");
	HX_VISIT_MEMBER_NAME(ssx,"ssx");
	HX_VISIT_MEMBER_NAME(ssy,"ssy");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(stride,"stride");
	HX_VISIT_MEMBER_NAME(qtsel,"qtsel");
	HX_VISIT_MEMBER_NAME(actabsel,"actabsel");
	HX_VISIT_MEMBER_NAME(dctabsel,"dctabsel");
	HX_VISIT_MEMBER_NAME(dcpred,"dcpred");
	HX_VISIT_MEMBER_NAME(pixels,"pixels");
}

Dynamic Component_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"cid") ) { return cid; }
		if (HX_FIELD_EQ(inName,"ssx") ) { return ssx; }
		if (HX_FIELD_EQ(inName,"ssy") ) { return ssy; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"qtsel") ) { return qtsel; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		if (HX_FIELD_EQ(inName,"stride") ) { return stride; }
		if (HX_FIELD_EQ(inName,"dcpred") ) { return dcpred; }
		if (HX_FIELD_EQ(inName,"pixels") ) { return pixels; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"actabsel") ) { return actabsel; }
		if (HX_FIELD_EQ(inName,"dctabsel") ) { return dctabsel; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Component_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"cid") ) { cid=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ssx") ) { ssx=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ssy") ) { ssy=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qtsel") ) { qtsel=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"stride") ) { stride=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"dcpred") ) { dcpred=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pixels") ) { pixels=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"actabsel") ) { actabsel=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"dctabsel") ) { dctabsel=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Component_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("cid"));
	outFields->push(HX_CSTRING("ssx"));
	outFields->push(HX_CSTRING("ssy"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("stride"));
	outFields->push(HX_CSTRING("qtsel"));
	outFields->push(HX_CSTRING("actabsel"));
	outFields->push(HX_CSTRING("dctabsel"));
	outFields->push(HX_CSTRING("dcpred"));
	outFields->push(HX_CSTRING("pixels"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Component_obj,cid),HX_CSTRING("cid")},
	{hx::fsInt,(int)offsetof(Component_obj,ssx),HX_CSTRING("ssx")},
	{hx::fsInt,(int)offsetof(Component_obj,ssy),HX_CSTRING("ssy")},
	{hx::fsInt,(int)offsetof(Component_obj,width),HX_CSTRING("width")},
	{hx::fsInt,(int)offsetof(Component_obj,height),HX_CSTRING("height")},
	{hx::fsInt,(int)offsetof(Component_obj,stride),HX_CSTRING("stride")},
	{hx::fsInt,(int)offsetof(Component_obj,qtsel),HX_CSTRING("qtsel")},
	{hx::fsInt,(int)offsetof(Component_obj,actabsel),HX_CSTRING("actabsel")},
	{hx::fsInt,(int)offsetof(Component_obj,dctabsel),HX_CSTRING("dctabsel")},
	{hx::fsInt,(int)offsetof(Component_obj,dcpred),HX_CSTRING("dcpred")},
	{hx::fsObject /*::haxe::io::Bytes*/ ,(int)offsetof(Component_obj,pixels),HX_CSTRING("pixels")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("cid"),
	HX_CSTRING("ssx"),
	HX_CSTRING("ssy"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("stride"),
	HX_CSTRING("qtsel"),
	HX_CSTRING("actabsel"),
	HX_CSTRING("dctabsel"),
	HX_CSTRING("dcpred"),
	HX_CSTRING("pixels"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Component_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Component_obj::__mClass,"__mClass");
};

#endif

Class Component_obj::__mClass;

void Component_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res._NanoJpeg.Component"), hx::TCanCast< Component_obj> ,sStaticFields,sMemberFields,
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

void Component_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
} // end namespace _NanoJpeg
