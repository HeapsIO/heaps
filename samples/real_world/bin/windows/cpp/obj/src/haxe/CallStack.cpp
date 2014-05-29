#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif
#ifndef INCLUDED_haxe_CallStack
#include <haxe/CallStack.h>
#endif
#ifndef INCLUDED_haxe_StackItem
#include <haxe/StackItem.h>
#endif
namespace haxe{

Void CallStack_obj::__construct()
{
	return null();
}

//CallStack_obj::~CallStack_obj() { }

Dynamic CallStack_obj::__CreateEmpty() { return  new CallStack_obj; }
hx::ObjectPtr< CallStack_obj > CallStack_obj::__new()
{  hx::ObjectPtr< CallStack_obj > result = new CallStack_obj();
	result->__construct();
	return result;}

Dynamic CallStack_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< CallStack_obj > result = new CallStack_obj();
	result->__construct();
	return result;}

Array< ::Dynamic > CallStack_obj::callStack( ){
	HX_STACK_FRAME("haxe.CallStack","callStack",0xfa9165be,"haxe.CallStack.callStack","D:\\Workspace\\motionTools\\haxe3\\std/haxe/CallStack.hx",43,0x409a6cbe)
	HX_STACK_LINE(57)
	Array< ::String > s = ::__hxcpp_get_call_stack(true);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(58)
	return ::haxe::CallStack_obj::makeStack(s);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(CallStack_obj,callStack,return )

Array< ::Dynamic > CallStack_obj::exceptionStack( ){
	Array< ::String > s = ::__hxcpp_get_exception_stack();
	return ::haxe::CallStack_obj::makeStack(s);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(CallStack_obj,exceptionStack,return )

::String CallStack_obj::toString( Array< ::Dynamic > stack){
	HX_STACK_FRAME("haxe.CallStack","toString",0xd59be738,"haxe.CallStack.toString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/CallStack.hx",170,0x409a6cbe)
	HX_STACK_ARG(stack,"stack")
	HX_STACK_LINE(171)
	::StringBuf b = ::StringBuf_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(172)
	{
		HX_STACK_LINE(172)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(172)
		while((true)){
			HX_STACK_LINE(172)
			if ((!(((_g < stack->length))))){
				HX_STACK_LINE(172)
				break;
			}
			HX_STACK_LINE(172)
			::haxe::StackItem s = stack->__get(_g).StaticCast< ::haxe::StackItem >();		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(172)
			++(_g);
			HX_STACK_LINE(173)
			b->add(HX_CSTRING("\nCalled from "));
			HX_STACK_LINE(174)
			::haxe::CallStack_obj::itemToString(b,s);
		}
	}
	HX_STACK_LINE(176)
	return b->b->join(HX_CSTRING(""));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(CallStack_obj,toString,return )

Void CallStack_obj::itemToString( ::StringBuf b,::haxe::StackItem s){
{
		HX_STACK_FRAME("haxe.CallStack","itemToString",0xc121696b,"haxe.CallStack.itemToString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/CallStack.hx",180,0x409a6cbe)
		HX_STACK_ARG(b,"b")
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(180)
		switch( (int)(s->__Index())){
			case (int)0: {
				HX_STACK_LINE(182)
				b->add(HX_CSTRING("a C function"));
			}
			;break;
			case (int)1: {
				HX_STACK_LINE(180)
				::String m = (::haxe::StackItem(s))->__Param(0);		HX_STACK_VAR(m,"m");
				HX_STACK_LINE(183)
				{
					HX_STACK_LINE(184)
					b->add(HX_CSTRING("module "));
					HX_STACK_LINE(185)
					b->add(m);
				}
			}
			;break;
			case (int)2: {
				HX_STACK_LINE(180)
				int line = (::haxe::StackItem(s))->__Param(2);		HX_STACK_VAR(line,"line");
				HX_STACK_LINE(180)
				::String file = (::haxe::StackItem(s))->__Param(1);		HX_STACK_VAR(file,"file");
				HX_STACK_LINE(180)
				::haxe::StackItem s1 = (::haxe::StackItem(s))->__Param(0);		HX_STACK_VAR(s1,"s1");
				HX_STACK_LINE(186)
				{
					HX_STACK_LINE(187)
					if (((s1 != null()))){
						HX_STACK_LINE(188)
						::haxe::CallStack_obj::itemToString(b,s1);
						HX_STACK_LINE(189)
						b->add(HX_CSTRING(" ("));
					}
					HX_STACK_LINE(191)
					b->add(file);
					HX_STACK_LINE(192)
					b->add(HX_CSTRING(" line "));
					HX_STACK_LINE(193)
					b->add(line);
					HX_STACK_LINE(194)
					if (((s1 != null()))){
						HX_STACK_LINE(194)
						b->add(HX_CSTRING(")"));
					}
				}
			}
			;break;
			case (int)3: {
				HX_STACK_LINE(180)
				::String meth = (::haxe::StackItem(s))->__Param(1);		HX_STACK_VAR(meth,"meth");
				HX_STACK_LINE(180)
				::String cname = (::haxe::StackItem(s))->__Param(0);		HX_STACK_VAR(cname,"cname");
				HX_STACK_LINE(195)
				{
					HX_STACK_LINE(196)
					b->add(cname);
					HX_STACK_LINE(197)
					b->add(HX_CSTRING("."));
					HX_STACK_LINE(198)
					b->add(meth);
				}
			}
			;break;
			case (int)4: {
				HX_STACK_LINE(180)
				int n = (::haxe::StackItem(s))->__Param(0);		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(199)
				{
					HX_STACK_LINE(200)
					b->add(HX_CSTRING("local function #"));
					HX_STACK_LINE(201)
					b->add(n);
				}
			}
			;break;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(CallStack_obj,itemToString,(void))

Array< ::Dynamic > CallStack_obj::makeStack( Array< ::String > s){
	Array< ::String > stack = s;
	Array< ::Dynamic > m = Array_obj< ::Dynamic >::__new();
	{
		int _g = (int)0;
		while((true)){
			if ((!(((_g < stack->length))))){
				break;
			}
			::String func = stack->__get(_g);
			++(_g);
			Array< ::String > words = func.split(HX_CSTRING("::"));
			if (((words->length == (int)0))){
				m->unshift(::haxe::StackItem_obj::CFunction);
			}
			else{
				if (((words->length == (int)2))){
					::haxe::StackItem _g1 = ::haxe::StackItem_obj::Method(words->__get((int)0),words->__get((int)1));
					m->unshift(_g1);
				}
				else{
					if (((words->length == (int)4))){
						::haxe::StackItem _g1 = ::haxe::StackItem_obj::Method(words->__get((int)0),words->__get((int)1));
						Dynamic _g2 = ::Std_obj::parseInt(words->__get((int)3));
						::haxe::StackItem _g3 = ::haxe::StackItem_obj::FilePos(_g1,words->__get((int)2),_g2);
						m->unshift(_g3);
					}
				}
			}
		}
	}
	return m;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(CallStack_obj,makeStack,return )


CallStack_obj::CallStack_obj()
{
}

Dynamic CallStack_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"callStack") ) { return callStack_dyn(); }
		if (HX_FIELD_EQ(inName,"makeStack") ) { return makeStack_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"itemToString") ) { return itemToString_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"exceptionStack") ) { return exceptionStack_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic CallStack_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void CallStack_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("callStack"),
	HX_CSTRING("exceptionStack"),
	HX_CSTRING("toString"),
	HX_CSTRING("itemToString"),
	HX_CSTRING("makeStack"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(CallStack_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(CallStack_obj::__mClass,"__mClass");
};

#endif

Class CallStack_obj::__mClass;

void CallStack_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.CallStack"), hx::TCanCast< CallStack_obj> ,sStaticFields,sMemberFields,
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

void CallStack_obj::__boot()
{
}

} // end namespace haxe
