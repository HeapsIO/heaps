#include <hxcpp.h>

#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
namespace hxd{
namespace res{

Void Resource_obj::__construct(::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.Resource","new",0x68608b08,"hxd.res.Resource.new","hxd/res/Resource.hx",9,0x80cb4426)
HX_STACK_THIS(this)
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(9)
	this->entry = entry;
}
;
	return null();
}

//Resource_obj::~Resource_obj() { }

Dynamic Resource_obj::__CreateEmpty() { return  new Resource_obj; }
hx::ObjectPtr< Resource_obj > Resource_obj::__new(::hxd::res::FileEntry entry)
{  hx::ObjectPtr< Resource_obj > result = new Resource_obj();
	result->__construct(entry);
	return result;}

Dynamic Resource_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Resource_obj > result = new Resource_obj();
	result->__construct(inArgs[0]);
	return result;}

::String Resource_obj::get_name( ){
	HX_STACK_FRAME("hxd.res.Resource","get_name",0x423fd22c,"hxd.res.Resource.get_name","hxd/res/Resource.hx",13,0x80cb4426)
	HX_STACK_THIS(this)
	HX_STACK_LINE(13)
	return this->entry->name;
}


HX_DEFINE_DYNAMIC_FUNC0(Resource_obj,get_name,return )


Resource_obj::Resource_obj()
{
}

void Resource_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Resource);
	HX_MARK_MEMBER_NAME(entry,"entry");
	HX_MARK_END_CLASS();
}

void Resource_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(entry,"entry");
}

Dynamic Resource_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"name") ) { return get_name(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"entry") ) { return entry; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"get_name") ) { return get_name_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Resource_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"entry") ) { entry=inValue.Cast< ::hxd::res::FileEntry >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Resource_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("name"));
	outFields->push(HX_CSTRING("entry"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::hxd::res::FileEntry*/ ,(int)offsetof(Resource_obj,entry),HX_CSTRING("entry")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("entry"),
	HX_CSTRING("get_name"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Resource_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Resource_obj::__mClass,"__mClass");
};

#endif

Class Resource_obj::__mClass;

void Resource_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Resource"), hx::TCanCast< Resource_obj> ,sStaticFields,sMemberFields,
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

void Resource_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
