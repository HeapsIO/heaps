#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_FreeCell
#include <h3d/impl/FreeCell.h>
#endif
namespace h3d{
namespace impl{

Void FreeCell_obj::__construct(int pos,int count,::h3d::impl::FreeCell next)
{
HX_STACK_FRAME("h3d.impl.FreeCell","new",0x88c9f459,"h3d.impl.FreeCell.new","h3d/impl/MemoryManager.hx",17,0x525e0dab)
HX_STACK_THIS(this)
HX_STACK_ARG(pos,"pos")
HX_STACK_ARG(count,"count")
HX_STACK_ARG(next,"next")
{
	HX_STACK_LINE(18)
	this->pos = pos;
	HX_STACK_LINE(19)
	this->count = count;
	HX_STACK_LINE(20)
	this->next = next;
}
;
	return null();
}

//FreeCell_obj::~FreeCell_obj() { }

Dynamic FreeCell_obj::__CreateEmpty() { return  new FreeCell_obj; }
hx::ObjectPtr< FreeCell_obj > FreeCell_obj::__new(int pos,int count,::h3d::impl::FreeCell next)
{  hx::ObjectPtr< FreeCell_obj > result = new FreeCell_obj();
	result->__construct(pos,count,next);
	return result;}

Dynamic FreeCell_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FreeCell_obj > result = new FreeCell_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}


FreeCell_obj::FreeCell_obj()
{
}

void FreeCell_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FreeCell);
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_MEMBER_NAME(count,"count");
	HX_MARK_MEMBER_NAME(next,"next");
	HX_MARK_END_CLASS();
}

void FreeCell_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(pos,"pos");
	HX_VISIT_MEMBER_NAME(count,"count");
	HX_VISIT_MEMBER_NAME(next,"next");
}

Dynamic FreeCell_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return next; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"count") ) { return count; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FreeCell_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { next=inValue.Cast< ::h3d::impl::FreeCell >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"count") ) { count=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FreeCell_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("pos"));
	outFields->push(HX_CSTRING("count"));
	outFields->push(HX_CSTRING("next"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(FreeCell_obj,pos),HX_CSTRING("pos")},
	{hx::fsInt,(int)offsetof(FreeCell_obj,count),HX_CSTRING("count")},
	{hx::fsObject /*::h3d::impl::FreeCell*/ ,(int)offsetof(FreeCell_obj,next),HX_CSTRING("next")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("pos"),
	HX_CSTRING("count"),
	HX_CSTRING("next"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FreeCell_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FreeCell_obj::__mClass,"__mClass");
};

#endif

Class FreeCell_obj::__mClass;

void FreeCell_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.FreeCell"), hx::TCanCast< FreeCell_obj> ,sStaticFields,sMemberFields,
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

void FreeCell_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
