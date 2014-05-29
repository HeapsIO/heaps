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
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_ObjectMap
#include <haxe/ds/ObjectMap.h>
#endif
namespace haxe{
namespace ds{

Void ObjectMap_obj::__construct()
{
HX_STACK_FRAME("haxe.ds.ObjectMap","new",0x27af5498,"haxe.ds.ObjectMap.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",29,0xdfe6c6f8)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(30)
	::haxe::ds::IntMap _g = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(30)
	this->__Internal = _g;
	HX_STACK_LINE(31)
	::haxe::ds::IntMap _g1 = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(31)
	this->__KeyRefs = _g1;
}
;
	return null();
}

//ObjectMap_obj::~ObjectMap_obj() { }

Dynamic ObjectMap_obj::__CreateEmpty() { return  new ObjectMap_obj; }
hx::ObjectPtr< ObjectMap_obj > ObjectMap_obj::__new()
{  hx::ObjectPtr< ObjectMap_obj > result = new ObjectMap_obj();
	result->__construct();
	return result;}

Dynamic ObjectMap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< ObjectMap_obj > result = new ObjectMap_obj();
	result->__construct();
	return result;}

hx::Object *ObjectMap_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::IMap_obj)) return operator ::IMap_obj *();
	return super::__ToInterface(inType);
}

Void ObjectMap_obj::set( Dynamic key,Dynamic value){
{
		HX_STACK_FRAME("haxe.ds.ObjectMap","set",0x27b31fda,"haxe.ds.ObjectMap.set","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",34,0xdfe6c6f8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(key,"key")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(35)
		int id = ::__hxcpp_obj_id(key);		HX_STACK_VAR(id,"id");
		HX_STACK_LINE(36)
		this->__Internal->set(id,value);
		HX_STACK_LINE(37)
		this->__KeyRefs->set(id,key);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(ObjectMap_obj,set,(void))

Dynamic ObjectMap_obj::get( Dynamic key){
	HX_STACK_FRAME("haxe.ds.ObjectMap","get",0x27aa04ce,"haxe.ds.ObjectMap.get","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",40,0xdfe6c6f8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(41)
	int _g = ::__hxcpp_obj_id(key);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(41)
	return this->__Internal->get(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(ObjectMap_obj,get,return )

bool ObjectMap_obj::exists( Dynamic key){
	HX_STACK_FRAME("haxe.ds.ObjectMap","exists",0xc8930ca4,"haxe.ds.ObjectMap.exists","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",44,0xdfe6c6f8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(45)
	int _g = ::__hxcpp_obj_id(key);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(45)
	return this->__Internal->exists(_g);
}


HX_DEFINE_DYNAMIC_FUNC1(ObjectMap_obj,exists,return )

bool ObjectMap_obj::remove( Dynamic key){
	HX_STACK_FRAME("haxe.ds.ObjectMap","remove",0x0d3b8b0c,"haxe.ds.ObjectMap.remove","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",48,0xdfe6c6f8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(49)
	int id = ::__hxcpp_obj_id(key);		HX_STACK_VAR(id,"id");
	HX_STACK_LINE(50)
	this->__Internal->remove(id);
	HX_STACK_LINE(51)
	return this->__KeyRefs->remove(id);
}


HX_DEFINE_DYNAMIC_FUNC1(ObjectMap_obj,remove,return )

Dynamic ObjectMap_obj::keys( ){
	HX_STACK_FRAME("haxe.ds.ObjectMap","keys",0x8fbf0ebc,"haxe.ds.ObjectMap.keys","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",55,0xdfe6c6f8)
	HX_STACK_THIS(this)
	HX_STACK_LINE(55)
	return this->__KeyRefs->iterator();
}


HX_DEFINE_DYNAMIC_FUNC0(ObjectMap_obj,keys,return )

Dynamic ObjectMap_obj::iterator( ){
	HX_STACK_FRAME("haxe.ds.ObjectMap","iterator",0x61fc7ab6,"haxe.ds.ObjectMap.iterator","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",59,0xdfe6c6f8)
	HX_STACK_THIS(this)
	HX_STACK_LINE(59)
	return this->__Internal->iterator();
}


HX_DEFINE_DYNAMIC_FUNC0(ObjectMap_obj,iterator,return )

::String ObjectMap_obj::toString( ){
	HX_STACK_FRAME("haxe.ds.ObjectMap","toString",0x06d10174,"haxe.ds.ObjectMap.toString","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/haxe/ds/ObjectMap.hx",62,0xdfe6c6f8)
	HX_STACK_THIS(this)
	HX_STACK_LINE(63)
	::StringBuf s = ::StringBuf_obj::__new();		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(64)
	s->add(HX_CSTRING("{"));
	HX_STACK_LINE(65)
	Dynamic it = this->__Internal->keys();		HX_STACK_VAR(it,"it");
	HX_STACK_LINE(66)
	for(::cpp::FastIterator_obj< int > *__it = ::cpp::CreateFastIterator< int >(it);  __it->hasNext(); ){
		int i = __it->next();
		{
			HX_STACK_LINE(67)
			Dynamic _g = this->__KeyRefs->get(i);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(67)
			::String _g1 = ::Std_obj::string(_g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(67)
			s->add(_g1);
			HX_STACK_LINE(68)
			s->add(HX_CSTRING(" => "));
			HX_STACK_LINE(69)
			Dynamic _g2 = this->__Internal->get(i);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(69)
			::String _g3 = ::Std_obj::string(_g2);		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(69)
			s->add(_g3);
			HX_STACK_LINE(70)
			if ((it->__Field(HX_CSTRING("hasNext"),true)())){
				HX_STACK_LINE(71)
				s->add(HX_CSTRING(", "));
			}
		}
;
	}
	HX_STACK_LINE(73)
	s->add(HX_CSTRING("}"));
	HX_STACK_LINE(74)
	return s->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC0(ObjectMap_obj,toString,return )


ObjectMap_obj::ObjectMap_obj()
{
}

void ObjectMap_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ObjectMap);
	HX_MARK_MEMBER_NAME(__Internal,"__Internal");
	HX_MARK_MEMBER_NAME(__KeyRefs,"__KeyRefs");
	HX_MARK_END_CLASS();
}

void ObjectMap_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(__Internal,"__Internal");
	HX_VISIT_MEMBER_NAME(__KeyRefs,"__KeyRefs");
}

Dynamic ObjectMap_obj::__Field(const ::String &inName,bool inCallProp)
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
	case 9:
		if (HX_FIELD_EQ(inName,"__KeyRefs") ) { return __KeyRefs; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"__Internal") ) { return __Internal; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic ObjectMap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"__KeyRefs") ) { __KeyRefs=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"__Internal") ) { __Internal=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ObjectMap_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("__Internal"));
	outFields->push(HX_CSTRING("__KeyRefs"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(ObjectMap_obj,__Internal),HX_CSTRING("__Internal")},
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(ObjectMap_obj,__KeyRefs),HX_CSTRING("__KeyRefs")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("__Internal"),
	HX_CSTRING("__KeyRefs"),
	HX_CSTRING("set"),
	HX_CSTRING("get"),
	HX_CSTRING("exists"),
	HX_CSTRING("remove"),
	HX_CSTRING("keys"),
	HX_CSTRING("iterator"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(ObjectMap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(ObjectMap_obj::__mClass,"__mClass");
};

#endif

Class ObjectMap_obj::__mClass;

void ObjectMap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds.ObjectMap"), hx::TCanCast< ObjectMap_obj> ,sStaticFields,sMemberFields,
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

void ObjectMap_obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
