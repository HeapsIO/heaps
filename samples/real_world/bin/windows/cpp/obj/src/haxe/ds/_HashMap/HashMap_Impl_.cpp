#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds__HashMap_HashMap_Impl_
#include <haxe/ds/_HashMap/HashMap_Impl_.h>
#endif
namespace haxe{
namespace ds{
namespace _HashMap{

Void HashMap_Impl__obj::__construct()
{
	return null();
}

//HashMap_Impl__obj::~HashMap_Impl__obj() { }

Dynamic HashMap_Impl__obj::__CreateEmpty() { return  new HashMap_Impl__obj; }
hx::ObjectPtr< HashMap_Impl__obj > HashMap_Impl__obj::__new()
{  hx::ObjectPtr< HashMap_Impl__obj > result = new HashMap_Impl__obj();
	result->__construct();
	return result;}

Dynamic HashMap_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< HashMap_Impl__obj > result = new HashMap_Impl__obj();
	result->__construct();
	return result;}

Dynamic HashMap_Impl__obj::_new( ){
	HX_STACK_FRAME("haxe.ds._HashMap.HashMap_Impl_","_new",0x2a77b589,"haxe.ds._HashMap.HashMap_Impl_._new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",26,0x35020546)
	HX_STACK_LINE(26)
	::haxe::ds::IntMap _g = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(26)
	::haxe::ds::IntMap _g1 = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	struct _Function_1_1{
		inline static Dynamic Block( ::haxe::ds::IntMap &_g1,::haxe::ds::IntMap &_g){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",26,0x35020546)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("keys") , _g,false);
				__result->Add(HX_CSTRING("values") , _g1,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(26)
	return _Function_1_1::Block(_g1,_g);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(HashMap_Impl__obj,_new,return )

Void HashMap_Impl__obj::set( Dynamic this1,Dynamic k,Dynamic v){
{
		HX_STACK_FRAME("haxe.ds._HashMap.HashMap_Impl_","set",0x5f88387a,"haxe.ds._HashMap.HashMap_Impl_.set","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",28,0x35020546)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(k,"k")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(29)
		int _g = k->__Field(HX_CSTRING("hashCode"),true)();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(29)
		this1->__Field(HX_CSTRING("keys"),true)->__Field(HX_CSTRING("set"),true)(_g,k);
		HX_STACK_LINE(30)
		int _g1 = k->__Field(HX_CSTRING("hashCode"),true)();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(30)
		this1->__Field(HX_CSTRING("values"),true)->__Field(HX_CSTRING("set"),true)(_g1,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(HashMap_Impl__obj,set,(void))

Dynamic HashMap_Impl__obj::get( Dynamic this1,Dynamic k){
	HX_STACK_FRAME("haxe.ds._HashMap.HashMap_Impl_","get",0x5f7f1d6e,"haxe.ds._HashMap.HashMap_Impl_.get","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",32,0x35020546)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(k,"k")
	HX_STACK_LINE(33)
	int _g = k->__Field(HX_CSTRING("hashCode"),true)();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(33)
	return this1->__Field(HX_CSTRING("values"),true)->__Field(HX_CSTRING("get"),true)(_g);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(HashMap_Impl__obj,get,return )

bool HashMap_Impl__obj::exists( Dynamic this1,Dynamic k){
	HX_STACK_FRAME("haxe.ds._HashMap.HashMap_Impl_","exists",0xaabf1804,"haxe.ds._HashMap.HashMap_Impl_.exists","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",35,0x35020546)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(k,"k")
	HX_STACK_LINE(36)
	int _g = k->__Field(HX_CSTRING("hashCode"),true)();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(36)
	return this1->__Field(HX_CSTRING("values"),true)->__Field(HX_CSTRING("exists"),true)(_g);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(HashMap_Impl__obj,exists,return )

bool HashMap_Impl__obj::remove( Dynamic this1,Dynamic k){
	HX_STACK_FRAME("haxe.ds._HashMap.HashMap_Impl_","remove",0xef67966c,"haxe.ds._HashMap.HashMap_Impl_.remove","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",38,0x35020546)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(k,"k")
	HX_STACK_LINE(39)
	int _g = k->__Field(HX_CSTRING("hashCode"),true)();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(39)
	this1->__Field(HX_CSTRING("values"),true)->__Field(HX_CSTRING("remove"),true)(_g);
	HX_STACK_LINE(40)
	int _g1 = k->__Field(HX_CSTRING("hashCode"),true)();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(40)
	return this1->__Field(HX_CSTRING("keys"),true)->__Field(HX_CSTRING("remove"),true)(_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(HashMap_Impl__obj,remove,return )

Dynamic HashMap_Impl__obj::keys( Dynamic this1){
	HX_STACK_FRAME("haxe.ds._HashMap.HashMap_Impl_","keys",0x325f821c,"haxe.ds._HashMap.HashMap_Impl_.keys","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",43,0x35020546)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(43)
	return this1->__Field(HX_CSTRING("keys"),true)->__Field(HX_CSTRING("iterator"),true)();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(HashMap_Impl__obj,keys,return )

Dynamic HashMap_Impl__obj::iterator( Dynamic this1){
	HX_STACK_FRAME("haxe.ds._HashMap.HashMap_Impl_","iterator",0x2fca1e16,"haxe.ds._HashMap.HashMap_Impl_.iterator","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/HashMap.hx",46,0x35020546)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(46)
	return this1->__Field(HX_CSTRING("values"),true)->__Field(HX_CSTRING("iterator"),true)();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(HashMap_Impl__obj,iterator,return )


HashMap_Impl__obj::HashMap_Impl__obj()
{
}

Dynamic HashMap_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		if (HX_FIELD_EQ(inName,"keys") ) { return keys_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic HashMap_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void HashMap_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("set"),
	HX_CSTRING("get"),
	HX_CSTRING("exists"),
	HX_CSTRING("remove"),
	HX_CSTRING("keys"),
	HX_CSTRING("iterator"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(HashMap_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(HashMap_Impl__obj::__mClass,"__mClass");
};

#endif

Class HashMap_Impl__obj::__mClass;

void HashMap_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds._HashMap.HashMap_Impl_"), hx::TCanCast< HashMap_Impl__obj> ,sStaticFields,sMemberFields,
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

void HashMap_Impl__obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
} // end namespace _HashMap
