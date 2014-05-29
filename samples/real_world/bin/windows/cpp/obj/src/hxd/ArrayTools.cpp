#include <hxcpp.h>

#ifndef INCLUDED_hxd_ArrayTools
#include <hxd/ArrayTools.h>
#endif
namespace hxd{

Void ArrayTools_obj::__construct()
{
	return null();
}

//ArrayTools_obj::~ArrayTools_obj() { }

Dynamic ArrayTools_obj::__CreateEmpty() { return  new ArrayTools_obj; }
hx::ObjectPtr< ArrayTools_obj > ArrayTools_obj::__new()
{  hx::ObjectPtr< ArrayTools_obj > result = new ArrayTools_obj();
	result->__construct();
	return result;}

Dynamic ArrayTools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ArrayTools_obj > result = new ArrayTools_obj();
	result->__construct();
	return result;}

Void ArrayTools_obj::zeroF( Array< Float > t){
{
		HX_STACK_FRAME("hxd.ArrayTools","zeroF",0xa1837aec,"hxd.ArrayTools.zeroF","hxd/ArrayTools.hx",16,0x1ba03ae1)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(16)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(16)
		int _g = t->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(16)
		while((true)){
			HX_STACK_LINE(16)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(16)
				break;
			}
			HX_STACK_LINE(16)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(16)
			t[i] = 0.0;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ArrayTools_obj,zeroF,(void))

Void ArrayTools_obj::zeroI( Array< int > t){
{
		HX_STACK_FRAME("hxd.ArrayTools","zeroI",0xa1837aef,"hxd.ArrayTools.zeroI","hxd/ArrayTools.hx",20,0x1ba03ae1)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(20)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(20)
		int _g = t->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(20)
		while((true)){
			HX_STACK_LINE(20)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(20)
				break;
			}
			HX_STACK_LINE(20)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(20)
			t[i] = (int)0;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ArrayTools_obj,zeroI,(void))

Void ArrayTools_obj::zeroNull( Dynamic t){
{
		HX_STACK_FRAME("hxd.ArrayTools","zeroNull",0x3805fbc1,"hxd.ArrayTools.zeroNull","hxd/ArrayTools.hx",24,0x1ba03ae1)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(24)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(24)
		int _g = t->__Field(HX_CSTRING("length"),true);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(24)
		while((true)){
			HX_STACK_LINE(24)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(24)
				break;
			}
			HX_STACK_LINE(24)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(24)
			hx::IndexRef((t).mPtr,i) = null();
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(ArrayTools_obj,zeroNull,(void))

Void ArrayTools_obj::blit( Array< Float > d,Dynamic __o_dstPos,Array< Float > src,Dynamic __o_srcPos,Dynamic __o_nb){
Dynamic dstPos = __o_dstPos.Default(0);
Dynamic srcPos = __o_srcPos.Default(0);
Dynamic nb = __o_nb.Default(-1);
	HX_STACK_FRAME("hxd.ArrayTools","blit",0xa51d4527,"hxd.ArrayTools.blit","hxd/ArrayTools.hx",27,0x1ba03ae1)
	HX_STACK_ARG(d,"d")
	HX_STACK_ARG(dstPos,"dstPos")
	HX_STACK_ARG(src,"src")
	HX_STACK_ARG(srcPos,"srcPos")
	HX_STACK_ARG(nb,"nb")
{
		HX_STACK_LINE(28)
		if (((nb < (int)0))){
			HX_STACK_LINE(28)
			nb = src->length;
		}
		HX_STACK_LINE(30)
		{
			HX_STACK_LINE(30)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(30)
			while((true)){
				HX_STACK_LINE(30)
				if ((!(((_g < nb))))){
					HX_STACK_LINE(30)
					break;
				}
				HX_STACK_LINE(30)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(31)
				d[(i + dstPos)] = src->__get((i + srcPos));
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(ArrayTools_obj,blit,(void))


ArrayTools_obj::ArrayTools_obj()
{
}

Dynamic ArrayTools_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"blit") ) { return blit_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"zeroF") ) { return zeroF_dyn(); }
		if (HX_FIELD_EQ(inName,"zeroI") ) { return zeroI_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"zeroNull") ) { return zeroNull_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ArrayTools_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void ArrayTools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("zeroF"),
	HX_CSTRING("zeroI"),
	HX_CSTRING("zeroNull"),
	HX_CSTRING("blit"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ArrayTools_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ArrayTools_obj::__mClass,"__mClass");
};

#endif

Class ArrayTools_obj::__mClass;

void ArrayTools_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.ArrayTools"), hx::TCanCast< ArrayTools_obj> ,sStaticFields,sMemberFields,
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

void ArrayTools_obj::__boot()
{
}

} // end namespace hxd
