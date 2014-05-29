#include <hxcpp.h>

#ifndef INCLUDED_IntIterator
#include <IntIterator.h>
#endif

Void IntIterator_obj::__construct(int min,int max)
{
HX_STACK_FRAME("IntIterator","new",0x5692054f,"IntIterator.new","D:\\Workspace\\motionTools\\haxe3\\std/IntIterator.hx",44,0x63ec2bc0)
HX_STACK_THIS(this)
HX_STACK_ARG(min,"min")
HX_STACK_ARG(max,"max")
{
	HX_STACK_LINE(45)
	this->min = min;
	HX_STACK_LINE(46)
	this->max = max;
}
;
	return null();
}

//IntIterator_obj::~IntIterator_obj() { }

Dynamic IntIterator_obj::__CreateEmpty() { return  new IntIterator_obj; }
hx::ObjectPtr< IntIterator_obj > IntIterator_obj::__new(int min,int max)
{  hx::ObjectPtr< IntIterator_obj > result = new IntIterator_obj();
	result->__construct(min,max);
	return result;}

Dynamic IntIterator_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< IntIterator_obj > result = new IntIterator_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

bool IntIterator_obj::hasNext( ){
	HX_STACK_FRAME("IntIterator","hasNext",0xd8737ddc,"IntIterator.hasNext","D:\\Workspace\\motionTools\\haxe3\\std/IntIterator.hx",53,0x63ec2bc0)
	HX_STACK_THIS(this)
	HX_STACK_LINE(53)
	return (this->min < this->max);
}


HX_DEFINE_DYNAMIC_FUNC0(IntIterator_obj,hasNext,return )

int IntIterator_obj::next( ){
	HX_STACK_FRAME("IntIterator","next",0x6932a124,"IntIterator.next","D:\\Workspace\\motionTools\\haxe3\\std/IntIterator.hx",62,0x63ec2bc0)
	HX_STACK_THIS(this)
	HX_STACK_LINE(62)
	return (this->min)++;
}


HX_DEFINE_DYNAMIC_FUNC0(IntIterator_obj,next,return )


IntIterator_obj::IntIterator_obj()
{
}

Dynamic IntIterator_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"min") ) { return min; }
		if (HX_FIELD_EQ(inName,"max") ) { return max; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return next_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hasNext") ) { return hasNext_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic IntIterator_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"min") ) { min=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"max") ) { max=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void IntIterator_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("min"));
	outFields->push(HX_CSTRING("max"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(IntIterator_obj,min),HX_CSTRING("min")},
	{hx::fsInt,(int)offsetof(IntIterator_obj,max),HX_CSTRING("max")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("min"),
	HX_CSTRING("max"),
	HX_CSTRING("hasNext"),
	HX_CSTRING("next"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(IntIterator_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(IntIterator_obj::__mClass,"__mClass");
};

#endif

Class IntIterator_obj::__mClass;

void IntIterator_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("IntIterator"), hx::TCanCast< IntIterator_obj> ,sStaticFields,sMemberFields,
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

void IntIterator_obj::__boot()
{
}

