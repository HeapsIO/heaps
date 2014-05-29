#include <hxcpp.h>

#ifndef INCLUDED_Lambda
#include <Lambda.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_haxe_CallStack
#include <haxe/CallStack.h>
#endif
#ifndef INCLUDED_haxe_StackItem
#include <haxe/StackItem.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Assert
#include <hxd/Assert.h>
#endif
namespace hxd{

Void Assert_obj::__construct()
{
	return null();
}

//Assert_obj::~Assert_obj() { }

Dynamic Assert_obj::__CreateEmpty() { return  new Assert_obj; }
hx::ObjectPtr< Assert_obj > Assert_obj::__new()
{  hx::ObjectPtr< Assert_obj > result = new Assert_obj();
	result->__construct();
	return result;}

Dynamic Assert_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Assert_obj > result = new Assert_obj();
	result->__construct();
	return result;}

::String Assert_obj::ASSERT_HEADER;

Void Assert_obj::throwError( ::String msg){
{
		HX_STACK_FRAME("hxd.Assert","throwError",0xdb2761b0,"hxd.Assert.throwError","hxd/Assert.hx",8,0x0e1f21dd)
		HX_STACK_ARG(msg,"msg")
		HX_STACK_LINE(9)
		::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(9)
		::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + msg) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
		HX_STACK_LINE(10)
		HX_STACK_DO_THROW(msg1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assert_obj,throwError,(void))

Void Assert_obj::fail( ::String msg){
{
		HX_STACK_FRAME("hxd.Assert","fail",0xea6e204c,"hxd.Assert.fail","hxd/Assert.hx",14,0x0e1f21dd)
		HX_STACK_ARG(msg,"msg")
		HX_STACK_LINE(14)
		::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(14)
		::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + msg) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
		HX_STACK_LINE(14)
		HX_STACK_DO_THROW(msg1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Assert_obj,fail,(void))

Void Assert_obj::isTrue( bool o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","isTrue",0x7cdbca46,"hxd.Assert.isTrue","hxd/Assert.hx",17,0x0e1f21dd)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(17)
		if (((false == o))){
			HX_STACK_LINE(18)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(18)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((HX_CSTRING("value should be true\n") + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(18)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assert_obj,isTrue,(void))

Void Assert_obj::isFalse( bool o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","isFalse",0xa895abab,"hxd.Assert.isFalse","hxd/Assert.hx",21,0x0e1f21dd)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(21)
		if (((false == !(o)))){
			HX_STACK_LINE(21)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(21)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((HX_CSTRING("value should be true\n") + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(21)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assert_obj,isFalse,(void))

Void Assert_obj::equals( Dynamic value,Dynamic expected,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","equals",0xd2644c2d,"hxd.Assert.equals","hxd/Assert.hx",24,0x0e1f21dd)
	HX_STACK_ARG(value,"value")
	HX_STACK_ARG(expected,"expected")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(24)
		if (((value != expected))){
			HX_STACK_LINE(25)
			::String _g = ::Std_obj::string(value);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(25)
			::String _g1 = (_g + HX_CSTRING(" should be "));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(25)
			::String _g2 = ::Std_obj::string(expected);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(25)
			::String _g3 = (_g1 + _g2);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(25)
			::String _g4 = (_g3 + HX_CSTRING("\n  msg: "));		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(25)
			::String msg1 = (_g4 + msg);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(25)
			::String _g5 = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(25)
			::String msg2 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + msg1) + HX_CSTRING("\nstatck:\n")) + _g5);		HX_STACK_VAR(msg2,"msg2");
			HX_STACK_LINE(25)
			HX_STACK_DO_THROW(msg2);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assert_obj,equals,(void))

Void Assert_obj::isNull( Dynamic o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","isNull",0x78e6c17f,"hxd.Assert.isNull","hxd/Assert.hx",28,0x0e1f21dd)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(28)
		if (((o != null()))){
			HX_STACK_LINE(29)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(29)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((HX_CSTRING("Object is null\n msg: ") + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(29)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assert_obj,isNull,(void))

Void Assert_obj::isZero( Float o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","isZero",0x80c93220,"hxd.Assert.isZero","hxd/Assert.hx",32,0x0e1f21dd)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(32)
		if (((o != 0.0))){
			HX_STACK_LINE(33)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(33)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((((HX_CSTRING("") + o) + HX_CSTRING(" does not equal 0 \n msg: ")) + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(33)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assert_obj,isZero,(void))

Void Assert_obj::notZero( Float o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","notZero",0x56dc6c2d,"hxd.Assert.notZero","hxd/Assert.hx",36,0x0e1f21dd)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(36)
		if (((o == 0.0))){
			HX_STACK_LINE(37)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(37)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((((HX_CSTRING("") + o) + HX_CSTRING(" equals 0 \n msg: ")) + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(37)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assert_obj,notZero,(void))

Void Assert_obj::notNan( Float o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","notNan",0x4415b776,"hxd.Assert.notNan","hxd/Assert.hx",40,0x0e1f21dd)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(40)
		if ((::Math_obj::isNaN(o))){
			HX_STACK_LINE(40)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(40)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((((HX_CSTRING("") + o) + HX_CSTRING(" is Nan \n msg: ")) + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(40)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assert_obj,notNan,(void))

Void Assert_obj::notNull( Dynamic o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","notNull",0x4ef9fb8c,"hxd.Assert.notNull","hxd/Assert.hx",43,0x0e1f21dd)
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(43)
		if (((o == null()))){
			HX_STACK_LINE(44)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(44)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((HX_CSTRING("Object should be null\n  msg: ") + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(44)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Assert_obj,notNull,(void))

Void Assert_obj::arrayContains( Dynamic a,Dynamic o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","arrayContains",0xbcc3a0aa,"hxd.Assert.arrayContains","hxd/Assert.hx",47,0x0e1f21dd)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(47)
		int _g = a->__Field(HX_CSTRING("indexOf"),true)(o,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(47)
		if (((_g == (int)-1))){
			HX_STACK_LINE(48)
			::String _g1 = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(48)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((HX_CSTRING("Array does not contain expected object\n  msg: ") + msg))) + HX_CSTRING("\nstatck:\n")) + _g1);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(48)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assert_obj,arrayContains,(void))

Void Assert_obj::contains( Dynamic a,Dynamic o,::String __o_msg){
::String msg = __o_msg.Default(HX_CSTRING(""));
	HX_STACK_FRAME("hxd.Assert","contains",0xc4728f8d,"hxd.Assert.contains","hxd/Assert.hx",51,0x0e1f21dd)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(o,"o")
	HX_STACK_ARG(msg,"msg")
{
		HX_STACK_LINE(51)
		if ((!(::Lambda_obj::has(a,o)))){
			HX_STACK_LINE(52)
			::String _g = ::haxe::CallStack_obj::callStack()->join(HX_CSTRING(",\n"));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(52)
			::String msg1 = ((((::hxd::Assert_obj::ASSERT_HEADER + HX_CSTRING("\n msg: ")) + ((HX_CSTRING("Iterable does not contain expected object\n  msg: ") + msg))) + HX_CSTRING("\nstatck:\n")) + _g);		HX_STACK_VAR(msg1,"msg1");
			HX_STACK_LINE(52)
			HX_STACK_DO_THROW(msg1);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Assert_obj,contains,(void))


Assert_obj::Assert_obj()
{
}

Dynamic Assert_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"fail") ) { return fail_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"isTrue") ) { return isTrue_dyn(); }
		if (HX_FIELD_EQ(inName,"equals") ) { return equals_dyn(); }
		if (HX_FIELD_EQ(inName,"isNull") ) { return isNull_dyn(); }
		if (HX_FIELD_EQ(inName,"isZero") ) { return isZero_dyn(); }
		if (HX_FIELD_EQ(inName,"notNan") ) { return notNan_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"isFalse") ) { return isFalse_dyn(); }
		if (HX_FIELD_EQ(inName,"notZero") ) { return notZero_dyn(); }
		if (HX_FIELD_EQ(inName,"notNull") ) { return notNull_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"contains") ) { return contains_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"throwError") ) { return throwError_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"ASSERT_HEADER") ) { return ASSERT_HEADER; }
		if (HX_FIELD_EQ(inName,"arrayContains") ) { return arrayContains_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Assert_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 13:
		if (HX_FIELD_EQ(inName,"ASSERT_HEADER") ) { ASSERT_HEADER=inValue.Cast< ::String >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Assert_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("ASSERT_HEADER"),
	HX_CSTRING("throwError"),
	HX_CSTRING("fail"),
	HX_CSTRING("isTrue"),
	HX_CSTRING("isFalse"),
	HX_CSTRING("equals"),
	HX_CSTRING("isNull"),
	HX_CSTRING("isZero"),
	HX_CSTRING("notZero"),
	HX_CSTRING("notNan"),
	HX_CSTRING("notNull"),
	HX_CSTRING("arrayContains"),
	HX_CSTRING("contains"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Assert_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Assert_obj::ASSERT_HEADER,"ASSERT_HEADER");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Assert_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Assert_obj::ASSERT_HEADER,"ASSERT_HEADER");
};

#endif

Class Assert_obj::__mClass;

void Assert_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Assert"), hx::TCanCast< Assert_obj> ,sStaticFields,sMemberFields,
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

void Assert_obj::__boot()
{
	ASSERT_HEADER= HX_CSTRING("[Assertion failed]");
}

} // end namespace hxd
