#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
namespace haxe{
namespace ds{

Void StringMap_obj::__construct()
{
HX_STACK_FRAME("haxe.ds.StringMap","new",0x0f13f0c6,"haxe.ds.StringMap.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",28,0x9d354a8a)
HX_STACK_THIS(this)
{
	struct _Function_1_1{
		inline static Dynamic Block( ){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",28,0x9d354a8a)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(28)
	this->__Internal = _Function_1_1::Block();
}
;
	return null();
}

//StringMap_obj::~StringMap_obj() { }

Dynamic StringMap_obj::__CreateEmpty() { return  new StringMap_obj; }
hx::ObjectPtr< StringMap_obj > StringMap_obj::__new()
{  hx::ObjectPtr< StringMap_obj > result = new StringMap_obj();
	result->__construct();
	return result;}

Dynamic StringMap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< StringMap_obj > result = new StringMap_obj();
	result->__construct();
	return result;}

hx::Object *StringMap_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::IMap_obj)) return operator ::IMap_obj *();
	return super::__ToInterface(inType);
}

Void StringMap_obj::set( Dynamic _tmp_key,Dynamic value){
{
		HX_STACK_FRAME("haxe.ds.StringMap","set",0x0f17bc08,"haxe.ds.StringMap.set","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",32,0x9d354a8a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(_tmp_key,"_tmp_key")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(32)
		::String key = _tmp_key;		HX_STACK_VAR(key,"key");
		HX_STACK_LINE(32)
		this->__Internal->__SetField(key,value,true);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(StringMap_obj,set,(void))

Dynamic StringMap_obj::get( Dynamic _tmp_key){
	HX_STACK_FRAME("haxe.ds.StringMap","get",0x0f0ea0fc,"haxe.ds.StringMap.get","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",36,0x9d354a8a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(_tmp_key,"_tmp_key")
	HX_STACK_LINE(36)
	::String key = _tmp_key;		HX_STACK_VAR(key,"key");
	HX_STACK_LINE(36)
	return this->__Internal->__Field(key,true);
}


HX_DEFINE_DYNAMIC_FUNC1(StringMap_obj,get,return )

bool StringMap_obj::exists( Dynamic _tmp_key){
	HX_STACK_FRAME("haxe.ds.StringMap","exists",0xd35fc136,"haxe.ds.StringMap.exists","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",40,0x9d354a8a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(_tmp_key,"_tmp_key")
	HX_STACK_LINE(40)
	::String key = _tmp_key;		HX_STACK_VAR(key,"key");
	HX_STACK_LINE(40)
	return this->__Internal->__HasField(key);
}


HX_DEFINE_DYNAMIC_FUNC1(StringMap_obj,exists,return )

bool StringMap_obj::remove( Dynamic _tmp_key){
	HX_STACK_FRAME("haxe.ds.StringMap","remove",0x18083f9e,"haxe.ds.StringMap.remove","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",44,0x9d354a8a)
	HX_STACK_THIS(this)
	HX_STACK_ARG(_tmp_key,"_tmp_key")
	HX_STACK_LINE(44)
	::String key = _tmp_key;		HX_STACK_VAR(key,"key");
	HX_STACK_LINE(44)
	return ::__hxcpp_anon_remove(this->__Internal,key);
}


HX_DEFINE_DYNAMIC_FUNC1(StringMap_obj,remove,return )

Dynamic StringMap_obj::keys( ){
	HX_STACK_FRAME("haxe.ds.StringMap","keys",0x20631ace,"haxe.ds.StringMap.keys","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",47,0x9d354a8a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(48)
	Array< ::String > a = Array_obj< ::String >::__new();		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(49)
	this->__Internal->__GetFields(a);
	HX_STACK_LINE(50)
	return a->iterator();
}


HX_DEFINE_DYNAMIC_FUNC0(StringMap_obj,keys,return )

Dynamic StringMap_obj::iterator( ){
	HX_STACK_FRAME("haxe.ds.StringMap","iterator",0x40ccf7c8,"haxe.ds.StringMap.iterator","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",53,0x9d354a8a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(54)
	Array< ::String > a = Array_obj< ::String >::__new();		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(55)
	this->__Internal->__GetFields(a);
	HX_STACK_LINE(56)
	Dynamic it = Dynamic( Array_obj<Dynamic>::__new().Add(a->iterator()));		HX_STACK_VAR(it,"it");
	HX_STACK_LINE(57)
	Array< ::Dynamic > me = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(me,"me");
	struct _Function_1_1{
		inline static Dynamic Block( Array< ::Dynamic > &me,Dynamic &it){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",58,0x9d354a8a)
			{
				hx::Anon __result = hx::Anon_obj::Create();

				HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_2_1,Dynamic,it)
				bool run(){
					HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",59,0x9d354a8a)
					{
						HX_STACK_LINE(59)
						return it->__GetItem((int)0)->__Field(HX_CSTRING("hasNext"),true)();
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("hasNext") ,  Dynamic(new _Function_2_1(it)),true);

				HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_2_2,Array< ::Dynamic >,me,Dynamic,it)
				Dynamic run(){
					HX_STACK_FRAME("*","_Function_2_2",0x5201af79,"*._Function_2_2","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",60,0x9d354a8a)
					{
						HX_STACK_LINE(60)
						return me->__get((int)0).StaticCast< ::haxe::ds::StringMap >()->__Internal->__Field(it->__GetItem((int)0)->__Field(HX_CSTRING("next"),true)(),true);
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("next") ,  Dynamic(new _Function_2_2(me,it)),true);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(58)
	return _Function_1_1::Block(me,it);
}


HX_DEFINE_DYNAMIC_FUNC0(StringMap_obj,iterator,return )

::String StringMap_obj::toString( ){
	HX_STACK_FRAME("haxe.ds.StringMap","toString",0xe5a17e86,"haxe.ds.StringMap.toString","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/StringMap.hx",64,0x9d354a8a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(65)
	::StringBuf s = ::StringBuf_obj::__new();		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(66)
	s->add(HX_CSTRING("{"));
	HX_STACK_LINE(67)
	Dynamic it = this->keys();		HX_STACK_VAR(it,"it");
	HX_STACK_LINE(68)
	for(::cpp::FastIterator_obj< ::String > *__it = ::cpp::CreateFastIterator< ::String >(it);  __it->hasNext(); ){
		::String i = __it->next();
		{
			HX_STACK_LINE(69)
			s->add(i);
			HX_STACK_LINE(70)
			s->add(HX_CSTRING(" => "));
			HX_STACK_LINE(71)
			Dynamic _g = this->get(i);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(71)
			::String _g1 = ::Std_obj::string(_g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(71)
			s->add(_g1);
			HX_STACK_LINE(72)
			if ((it->__Field(HX_CSTRING("hasNext"),true)())){
				HX_STACK_LINE(73)
				s->add(HX_CSTRING(", "));
			}
		}
;
	}
	HX_STACK_LINE(75)
	s->add(HX_CSTRING("}"));
	HX_STACK_LINE(76)
	return s->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC0(StringMap_obj,toString,return )


StringMap_obj::StringMap_obj()
{
}

void StringMap_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(StringMap);
	HX_MARK_MEMBER_NAME(__Internal,"__Internal");
	HX_MARK_END_CLASS();
}

void StringMap_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(__Internal,"__Internal");
}

Dynamic StringMap_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"keys") ) { return keys_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"__Internal") ) { return __Internal; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic StringMap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"__Internal") ) { __Internal=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void StringMap_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__Internal"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(StringMap_obj,__Internal),HX_CSTRING("__Internal")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__Internal"),
	HX_CSTRING("set"),
	HX_CSTRING("get"),
	HX_CSTRING("exists"),
	HX_CSTRING("remove"),
	HX_CSTRING("keys"),
	HX_CSTRING("iterator"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StringMap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StringMap_obj::__mClass,"__mClass");
};

#endif

Class StringMap_obj::__mClass;

void StringMap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds.StringMap"), hx::TCanCast< StringMap_obj> ,sStaticFields,sMemberFields,
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

void StringMap_obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
