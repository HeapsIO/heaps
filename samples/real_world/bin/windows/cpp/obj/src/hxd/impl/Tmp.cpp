#include <hxcpp.h>

#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_impl_Tmp
#include <hxd/impl/Tmp.h>
#endif
namespace hxd{
namespace impl{

Void Tmp_obj::__construct()
{
	return null();
}

//Tmp_obj::~Tmp_obj() { }

Dynamic Tmp_obj::__CreateEmpty() { return  new Tmp_obj; }
hx::ObjectPtr< Tmp_obj > Tmp_obj::__new()
{  hx::ObjectPtr< Tmp_obj > result = new Tmp_obj();
	result->__construct();
	return result;}

Dynamic Tmp_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Tmp_obj > result = new Tmp_obj();
	result->__construct();
	return result;}

Array< ::Dynamic > Tmp_obj::bytes;

::haxe::io::Bytes Tmp_obj::getBytes( int size){
	HX_STACK_FRAME("hxd.impl.Tmp","getBytes",0x6815f140,"hxd.impl.Tmp.getBytes","hxd/impl/Tmp.hx",7,0x83e6be7b)
	HX_STACK_ARG(size,"size")
	HX_STACK_LINE(8)
	{
		HX_STACK_LINE(8)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(8)
		int _g = ::hxd::impl::Tmp_obj::bytes->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(8)
		while((true)){
			HX_STACK_LINE(8)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(8)
				break;
			}
			HX_STACK_LINE(8)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(9)
			::haxe::io::Bytes b = ::hxd::impl::Tmp_obj::bytes->__get(i).StaticCast< ::haxe::io::Bytes >();		HX_STACK_VAR(b,"b");
			HX_STACK_LINE(10)
			if (((b->length >= size))){
				HX_STACK_LINE(11)
				::hxd::impl::Tmp_obj::bytes->splice(i,(int)1);
				HX_STACK_LINE(12)
				return b;
			}
		}
	}
	HX_STACK_LINE(15)
	int sz = (int)1024;		HX_STACK_VAR(sz,"sz");
	HX_STACK_LINE(16)
	while((true)){
		HX_STACK_LINE(16)
		if ((!(((sz < size))))){
			HX_STACK_LINE(16)
			break;
		}
		HX_STACK_LINE(17)
		sz = (int((sz * (int)3)) >> int((int)1));
	}
	HX_STACK_LINE(18)
	return ::haxe::io::Bytes_obj::alloc(sz);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tmp_obj,getBytes,return )

Void Tmp_obj::saveBytes( ::haxe::io::Bytes b){
{
		HX_STACK_FRAME("hxd.impl.Tmp","saveBytes",0x539c5843,"hxd.impl.Tmp.saveBytes","hxd/impl/Tmp.hx",21,0x83e6be7b)
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(22)
		{
			HX_STACK_LINE(22)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(22)
			int _g = ::hxd::impl::Tmp_obj::bytes->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(22)
			while((true)){
				HX_STACK_LINE(22)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(22)
					break;
				}
				HX_STACK_LINE(22)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(23)
				if (((::hxd::impl::Tmp_obj::bytes->__get(i).StaticCast< ::haxe::io::Bytes >()->length <= b->length))){
					HX_STACK_LINE(24)
					::hxd::impl::Tmp_obj::bytes->insert(i,b);
					HX_STACK_LINE(25)
					if (((::hxd::impl::Tmp_obj::bytes->length > (int)8))){
						HX_STACK_LINE(26)
						::hxd::impl::Tmp_obj::bytes->pop().StaticCast< ::haxe::io::Bytes >();
					}
					HX_STACK_LINE(27)
					return null();
				}
			}
		}
		HX_STACK_LINE(30)
		::hxd::impl::Tmp_obj::bytes->push(b);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tmp_obj,saveBytes,(void))


Tmp_obj::Tmp_obj()
{
}

Dynamic Tmp_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { return bytes; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getBytes") ) { return getBytes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"saveBytes") ) { return saveBytes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Tmp_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { bytes=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Tmp_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("bytes"),
	HX_CSTRING("getBytes"),
	HX_CSTRING("saveBytes"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Tmp_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Tmp_obj::bytes,"bytes");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Tmp_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Tmp_obj::bytes,"bytes");
};

#endif

Class Tmp_obj::__mClass;

void Tmp_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.impl.Tmp"), hx::TCanCast< Tmp_obj> ,sStaticFields,sMemberFields,
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

void Tmp_obj::__boot()
{
	bytes= Array_obj< ::Dynamic >::__new();
}

} // end namespace hxd
} // end namespace impl
