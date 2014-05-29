#include <hxcpp.h>

#ifndef INCLUDED_h3d_fbx_FbxNode
#include <h3d/fbx/FbxNode.h>
#endif
#ifndef INCLUDED_h3d_fbx_Library
#include <h3d/fbx/Library.h>
#endif
#ifndef INCLUDED_h3d_fbx_Parser
#include <h3d/fbx/Parser.h>
#endif
#ifndef INCLUDED_h3d_fbx_XBXReader
#include <h3d/fbx/XBXReader.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesInput
#include <haxe/io/BytesInput.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_Model
#include <hxd/res/Model.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
namespace hxd{
namespace res{

Void Model_obj::__construct(::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.Model","new",0x5e8601d3,"hxd.res.Model.new","hxd/res/Model.hx",3,0x7cfe3f7f)
HX_STACK_THIS(this)
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(3)
	super::__construct(entry);
}
;
	return null();
}

//Model_obj::~Model_obj() { }

Dynamic Model_obj::__CreateEmpty() { return  new Model_obj; }
hx::ObjectPtr< Model_obj > Model_obj::__new(::hxd::res::FileEntry entry)
{  hx::ObjectPtr< Model_obj > result = new Model_obj();
	result->__construct(entry);
	return result;}

Dynamic Model_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Model_obj > result = new Model_obj();
	result->__construct(inArgs[0]);
	return result;}

::h3d::fbx::Library Model_obj::toFbx( ){
	HX_STACK_FRAME("hxd.res.Model","toFbx",0x08472134,"hxd.res.Model.toFbx","hxd/res/Model.hx",7,0x7cfe3f7f)
	HX_STACK_THIS(this)
	HX_STACK_LINE(8)
	::h3d::fbx::Library lib = ::h3d::fbx::Library_obj::__new();		HX_STACK_VAR(lib,"lib");
	HX_STACK_LINE(9)
	{
		HX_STACK_LINE(9)
		int _g = this->entry->getSign();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(9)
		int _g1 = (int(_g) & int((int)255));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(9)
		switch( (int)(_g1)){
			case (int)59: {
				HX_STACK_LINE(11)
				::String _g11 = this->entry->getBytes()->toString();		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(11)
				::h3d::fbx::FbxNode _g2 = ::h3d::fbx::Parser_obj::parse(_g11);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(11)
				lib->load(_g2);
			}
			;break;
			case (int)88: {
				HX_STACK_LINE(13)
				::haxe::io::Bytes _g3 = this->entry->getBytes();		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(13)
				::haxe::io::BytesInput f = ::haxe::io::BytesInput_obj::__new(_g3,null(),null());		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(14)
				::h3d::fbx::FbxNode xbx = ::h3d::fbx::XBXReader_obj::__new(f)->read();		HX_STACK_VAR(xbx,"xbx");
				HX_STACK_LINE(15)
				lib->load(xbx);
				HX_STACK_LINE(16)
				f->close();
			}
			;break;
			default: {
				HX_STACK_LINE(18)
				::String _g4 = this->entry->get_path();		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(18)
				HX_STACK_DO_THROW((HX_CSTRING("Unsupported model format ") + _g4));
			}
		}
	}
	HX_STACK_LINE(20)
	if ((::hxd::res::Model_obj::isLeftHanded)){
		HX_STACK_LINE(20)
		lib->leftHandConvert();
	}
	HX_STACK_LINE(21)
	return lib;
}


HX_DEFINE_DYNAMIC_FUNC0(Model_obj,toFbx,return )

bool Model_obj::isLeftHanded;


Model_obj::Model_obj()
{
}

Dynamic Model_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"toFbx") ) { return toFbx_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"isLeftHanded") ) { return isLeftHanded; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Model_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 12:
		if (HX_FIELD_EQ(inName,"isLeftHanded") ) { isLeftHanded=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Model_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("isLeftHanded"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("toFbx"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Model_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Model_obj::isLeftHanded,"isLeftHanded");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Model_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Model_obj::isLeftHanded,"isLeftHanded");
};

#endif

Class Model_obj::__mClass;

void Model_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Model"), hx::TCanCast< Model_obj> ,sStaticFields,sMemberFields,
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

void Model_obj::__boot()
{
	isLeftHanded= true;
}

} // end namespace hxd
} // end namespace res
