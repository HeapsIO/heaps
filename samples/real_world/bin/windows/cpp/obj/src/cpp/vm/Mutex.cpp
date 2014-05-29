#include <hxcpp.h>

#ifndef INCLUDED_cpp_vm_Mutex
#include <cpp/vm/Mutex.h>
#endif
namespace cpp{
namespace vm{

Void Mutex_obj::__construct()
{
HX_STACK_FRAME("cpp.vm.Mutex","new",0xabb3ca05,"cpp.vm.Mutex.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/vm/Mutex.hx",27,0x2207880c)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(28)
	Dynamic _g = ::__hxcpp_mutex_create();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(28)
	this->m = _g;
}
;
	return null();
}

//Mutex_obj::~Mutex_obj() { }

Dynamic Mutex_obj::__CreateEmpty() { return  new Mutex_obj; }
hx::ObjectPtr< Mutex_obj > Mutex_obj::__new()
{  hx::ObjectPtr< Mutex_obj > result = new Mutex_obj();
	result->__construct();
	return result;}

Dynamic Mutex_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Mutex_obj > result = new Mutex_obj();
	result->__construct();
	return result;}

Void Mutex_obj::acquire( ){
{
		HX_STACK_FRAME("cpp.vm.Mutex","acquire",0xc3527bfb,"cpp.vm.Mutex.acquire","D:\\Workspace\\motionTools\\haxe3\\std/cpp/vm/Mutex.hx",31,0x2207880c)
		HX_STACK_THIS(this)
		HX_STACK_LINE(31)
		::__hxcpp_mutex_acquire(this->m);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Mutex_obj,acquire,(void))

bool Mutex_obj::tryAcquire( ){
	HX_STACK_FRAME("cpp.vm.Mutex","tryAcquire",0x99512cd6,"cpp.vm.Mutex.tryAcquire","D:\\Workspace\\motionTools\\haxe3\\std/cpp/vm/Mutex.hx",34,0x2207880c)
	HX_STACK_THIS(this)
	HX_STACK_LINE(34)
	return ::__hxcpp_mutex_try(this->m);
}


HX_DEFINE_DYNAMIC_FUNC0(Mutex_obj,tryAcquire,return )

Void Mutex_obj::release( ){
{
		HX_STACK_FRAME("cpp.vm.Mutex","release",0x675bb5ec,"cpp.vm.Mutex.release","D:\\Workspace\\motionTools\\haxe3\\std/cpp/vm/Mutex.hx",37,0x2207880c)
		HX_STACK_THIS(this)
		HX_STACK_LINE(37)
		::__hxcpp_mutex_release(this->m);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Mutex_obj,release,(void))


Mutex_obj::Mutex_obj()
{
}

void Mutex_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Mutex);
	HX_MARK_MEMBER_NAME(m,"m");
	HX_MARK_END_CLASS();
}

void Mutex_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(m,"m");
}

Dynamic Mutex_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"m") ) { return m; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"acquire") ) { return acquire_dyn(); }
		if (HX_FIELD_EQ(inName,"release") ) { return release_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"tryAcquire") ) { return tryAcquire_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Mutex_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"m") ) { m=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Mutex_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("m"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Mutex_obj,m),HX_CSTRING("m")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("m"),
	HX_CSTRING("acquire"),
	HX_CSTRING("tryAcquire"),
	HX_CSTRING("release"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Mutex_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Mutex_obj::__mClass,"__mClass");
};

#endif

Class Mutex_obj::__mClass;

void Mutex_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("cpp.vm.Mutex"), hx::TCanCast< Mutex_obj> ,sStaticFields,sMemberFields,
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

void Mutex_obj::__boot()
{
}

} // end namespace cpp
} // end namespace vm
