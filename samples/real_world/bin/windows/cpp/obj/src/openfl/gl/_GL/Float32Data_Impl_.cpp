#include <hxcpp.h>

#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_openfl_gl__GL_Float32Data_Impl_
#include <openfl/gl/_GL/Float32Data_Impl_.h>
#endif
#ifndef INCLUDED_openfl_utils_ArrayBufferView
#include <openfl/utils/ArrayBufferView.h>
#endif
#ifndef INCLUDED_openfl_utils_Float32Array
#include <openfl/utils/Float32Array.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace openfl{
namespace gl{
namespace _GL{

Void Float32Data_Impl__obj::__construct()
{
	return null();
}

//Float32Data_Impl__obj::~Float32Data_Impl__obj() { }

Dynamic Float32Data_Impl__obj::__CreateEmpty() { return  new Float32Data_Impl__obj; }
hx::ObjectPtr< Float32Data_Impl__obj > Float32Data_Impl__obj::__new()
{  hx::ObjectPtr< Float32Data_Impl__obj > result = new Float32Data_Impl__obj();
	result->__construct();
	return result;}

Dynamic Float32Data_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Float32Data_Impl__obj > result = new Float32Data_Impl__obj();
	result->__construct();
	return result;}

Dynamic Float32Data_Impl__obj::_new( Dynamic data){
	HX_STACK_FRAME("openfl.gl._GL.Float32Data_Impl_","_new",0xa08aba5f,"openfl.gl._GL.Float32Data_Impl_._new","openfl/gl/GL.hx",1331,0x296f94ae)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(1331)
	return data;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Float32Data_Impl__obj,_new,return )

Array< Float > Float32Data_Impl__obj::toDynamic( Dynamic this1){
	HX_STACK_FRAME("openfl.gl._GL.Float32Data_Impl_","toDynamic",0x16315986,"openfl.gl._GL.Float32Data_Impl_.toDynamic","openfl/gl/GL.hx",1332,0x296f94ae)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(1332)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Float32Data_Impl__obj,toDynamic,return )

Dynamic Float32Data_Impl__obj::fromFloat32Array( ::openfl::utils::Float32Array f){
	HX_STACK_FRAME("openfl.gl._GL.Float32Data_Impl_","fromFloat32Array",0x3ccf88e6,"openfl.gl._GL.Float32Data_Impl_.fromFloat32Array","openfl/gl/GL.hx",1334,0x296f94ae)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(1334)
	Dynamic data = f->getByteBuffer();		HX_STACK_VAR(data,"data");
	HX_STACK_LINE(1334)
	return data;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Float32Data_Impl__obj,fromFloat32Array,return )

Dynamic Float32Data_Impl__obj::fromArrayFloat( Array< Float > f){
	HX_STACK_FRAME("openfl.gl._GL.Float32Data_Impl_","fromArrayFloat",0xc37f3dcb,"openfl.gl._GL.Float32Data_Impl_.fromArrayFloat","openfl/gl/GL.hx",1336,0x296f94ae)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(1336)
	return f;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Float32Data_Impl__obj,fromArrayFloat,return )


Float32Data_Impl__obj::Float32Data_Impl__obj()
{
}

Dynamic Float32Data_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"toDynamic") ) { return toDynamic_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"fromArrayFloat") ) { return fromArrayFloat_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"fromFloat32Array") ) { return fromFloat32Array_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Float32Data_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Float32Data_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("toDynamic"),
	HX_CSTRING("fromFloat32Array"),
	HX_CSTRING("fromArrayFloat"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Float32Data_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Float32Data_Impl__obj::__mClass,"__mClass");
};

#endif

Class Float32Data_Impl__obj::__mClass;

void Float32Data_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.gl._GL.Float32Data_Impl_"), hx::TCanCast< Float32Data_Impl__obj> ,sStaticFields,sMemberFields,
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

void Float32Data_Impl__obj::__boot()
{
}

} // end namespace openfl
} // end namespace gl
} // end namespace _GL
