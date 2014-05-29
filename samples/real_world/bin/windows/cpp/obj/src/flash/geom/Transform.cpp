#include <hxcpp.h>

#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_ColorTransform
#include <flash/geom/ColorTransform.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix
#include <flash/geom/Matrix.h>
#endif
#ifndef INCLUDED_flash_geom_Rectangle
#include <flash/geom/Rectangle.h>
#endif
#ifndef INCLUDED_flash_geom_Transform
#include <flash/geom/Transform.h>
#endif
namespace flash{
namespace geom{

Void Transform_obj::__construct(::flash::display::DisplayObject parent)
{
HX_STACK_FRAME("flash.geom.Transform","new",0xea44cb0a,"flash.geom.Transform.new","flash/geom/Transform.hx",21,0xbbeb5006)
HX_STACK_THIS(this)
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(21)
	this->__parent = parent;
}
;
	return null();
}

//Transform_obj::~Transform_obj() { }

Dynamic Transform_obj::__CreateEmpty() { return  new Transform_obj; }
hx::ObjectPtr< Transform_obj > Transform_obj::__new(::flash::display::DisplayObject parent)
{  hx::ObjectPtr< Transform_obj > result = new Transform_obj();
	result->__construct(parent);
	return result;}

Dynamic Transform_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Transform_obj > result = new Transform_obj();
	result->__construct(inArgs[0]);
	return result;}

::flash::geom::ColorTransform Transform_obj::get_colorTransform( ){
	HX_STACK_FRAME("flash.geom.Transform","get_colorTransform",0x5b0d4ce8,"flash.geom.Transform.get_colorTransform","flash/geom/Transform.hx",33,0xbbeb5006)
	HX_STACK_THIS(this)
	HX_STACK_LINE(33)
	return this->__parent->__getColorTransform();
}


HX_DEFINE_DYNAMIC_FUNC0(Transform_obj,get_colorTransform,return )

::flash::geom::ColorTransform Transform_obj::set_colorTransform( ::flash::geom::ColorTransform value){
	HX_STACK_FRAME("flash.geom.Transform","set_colorTransform",0x37bc7f5c,"flash.geom.Transform.set_colorTransform","flash/geom/Transform.hx",34,0xbbeb5006)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(34)
	this->__parent->__setColorTransform(value);
	HX_STACK_LINE(34)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Transform_obj,set_colorTransform,return )

::flash::geom::ColorTransform Transform_obj::get_concatenatedColorTransform( ){
	HX_STACK_FRAME("flash.geom.Transform","get_concatenatedColorTransform",0x007270d7,"flash.geom.Transform.get_concatenatedColorTransform","flash/geom/Transform.hx",35,0xbbeb5006)
	HX_STACK_THIS(this)
	HX_STACK_LINE(35)
	return this->__parent->__getConcatenatedColorTransform();
}


HX_DEFINE_DYNAMIC_FUNC0(Transform_obj,get_concatenatedColorTransform,return )

::flash::geom::Matrix Transform_obj::get_concatenatedMatrix( ){
	HX_STACK_FRAME("flash.geom.Transform","get_concatenatedMatrix",0xa5d9d18f,"flash.geom.Transform.get_concatenatedMatrix","flash/geom/Transform.hx",36,0xbbeb5006)
	HX_STACK_THIS(this)
	HX_STACK_LINE(36)
	return this->__parent->__getConcatenatedMatrix();
}


HX_DEFINE_DYNAMIC_FUNC0(Transform_obj,get_concatenatedMatrix,return )

::flash::geom::Matrix Transform_obj::get_matrix( ){
	HX_STACK_FRAME("flash.geom.Transform","get_matrix",0x1f51b4a0,"flash.geom.Transform.get_matrix","flash/geom/Transform.hx",37,0xbbeb5006)
	HX_STACK_THIS(this)
	HX_STACK_LINE(37)
	return this->__parent->__getMatrix();
}


HX_DEFINE_DYNAMIC_FUNC0(Transform_obj,get_matrix,return )

::flash::geom::Matrix Transform_obj::set_matrix( ::flash::geom::Matrix value){
	HX_STACK_FRAME("flash.geom.Transform","set_matrix",0x22cf5314,"flash.geom.Transform.set_matrix","flash/geom/Transform.hx",38,0xbbeb5006)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(38)
	this->__parent->__setMatrix(value);
	HX_STACK_LINE(38)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Transform_obj,set_matrix,return )

::flash::geom::Rectangle Transform_obj::get_pixelBounds( ){
	HX_STACK_FRAME("flash.geom.Transform","get_pixelBounds",0xf6df72dc,"flash.geom.Transform.get_pixelBounds","flash/geom/Transform.hx",39,0xbbeb5006)
	HX_STACK_THIS(this)
	HX_STACK_LINE(39)
	return this->__parent->__getPixelBounds();
}


HX_DEFINE_DYNAMIC_FUNC0(Transform_obj,get_pixelBounds,return )


Transform_obj::Transform_obj()
{
}

void Transform_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Transform);
	HX_MARK_MEMBER_NAME(concatenatedColorTransform,"concatenatedColorTransform");
	HX_MARK_MEMBER_NAME(concatenatedMatrix,"concatenatedMatrix");
	HX_MARK_MEMBER_NAME(pixelBounds,"pixelBounds");
	HX_MARK_MEMBER_NAME(__parent,"__parent");
	HX_MARK_END_CLASS();
}

void Transform_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(concatenatedColorTransform,"concatenatedColorTransform");
	HX_VISIT_MEMBER_NAME(concatenatedMatrix,"concatenatedMatrix");
	HX_VISIT_MEMBER_NAME(pixelBounds,"pixelBounds");
	HX_VISIT_MEMBER_NAME(__parent,"__parent");
}

Dynamic Transform_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"matrix") ) { return get_matrix(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"__parent") ) { return __parent; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_matrix") ) { return get_matrix_dyn(); }
		if (HX_FIELD_EQ(inName,"set_matrix") ) { return set_matrix_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"pixelBounds") ) { return inCallProp ? get_pixelBounds() : pixelBounds; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"colorTransform") ) { return get_colorTransform(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_pixelBounds") ) { return get_pixelBounds_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"concatenatedMatrix") ) { return inCallProp ? get_concatenatedMatrix() : concatenatedMatrix; }
		if (HX_FIELD_EQ(inName,"get_colorTransform") ) { return get_colorTransform_dyn(); }
		if (HX_FIELD_EQ(inName,"set_colorTransform") ) { return set_colorTransform_dyn(); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"get_concatenatedMatrix") ) { return get_concatenatedMatrix_dyn(); }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"concatenatedColorTransform") ) { return inCallProp ? get_concatenatedColorTransform() : concatenatedColorTransform; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"get_concatenatedColorTransform") ) { return get_concatenatedColorTransform_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Transform_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"matrix") ) { return set_matrix(inValue); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"__parent") ) { __parent=inValue.Cast< ::flash::display::DisplayObject >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"pixelBounds") ) { pixelBounds=inValue.Cast< ::flash::geom::Rectangle >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"colorTransform") ) { return set_colorTransform(inValue); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"concatenatedMatrix") ) { concatenatedMatrix=inValue.Cast< ::flash::geom::Matrix >(); return inValue; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"concatenatedColorTransform") ) { concatenatedColorTransform=inValue.Cast< ::flash::geom::ColorTransform >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Transform_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("colorTransform"));
	outFields->push(HX_CSTRING("concatenatedColorTransform"));
	outFields->push(HX_CSTRING("concatenatedMatrix"));
	outFields->push(HX_CSTRING("matrix"));
	outFields->push(HX_CSTRING("pixelBounds"));
	outFields->push(HX_CSTRING("__parent"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::flash::geom::ColorTransform*/ ,(int)offsetof(Transform_obj,concatenatedColorTransform),HX_CSTRING("concatenatedColorTransform")},
	{hx::fsObject /*::flash::geom::Matrix*/ ,(int)offsetof(Transform_obj,concatenatedMatrix),HX_CSTRING("concatenatedMatrix")},
	{hx::fsObject /*::flash::geom::Rectangle*/ ,(int)offsetof(Transform_obj,pixelBounds),HX_CSTRING("pixelBounds")},
	{hx::fsObject /*::flash::display::DisplayObject*/ ,(int)offsetof(Transform_obj,__parent),HX_CSTRING("__parent")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("concatenatedColorTransform"),
	HX_CSTRING("concatenatedMatrix"),
	HX_CSTRING("pixelBounds"),
	HX_CSTRING("__parent"),
	HX_CSTRING("get_colorTransform"),
	HX_CSTRING("set_colorTransform"),
	HX_CSTRING("get_concatenatedColorTransform"),
	HX_CSTRING("get_concatenatedMatrix"),
	HX_CSTRING("get_matrix"),
	HX_CSTRING("set_matrix"),
	HX_CSTRING("get_pixelBounds"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Transform_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Transform_obj::__mClass,"__mClass");
};

#endif

Class Transform_obj::__mClass;

void Transform_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.geom.Transform"), hx::TCanCast< Transform_obj> ,sStaticFields,sMemberFields,
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

void Transform_obj::__boot()
{
}

} // end namespace flash
} // end namespace geom
