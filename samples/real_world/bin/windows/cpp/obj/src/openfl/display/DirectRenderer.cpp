#include <hxcpp.h>

#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_Rectangle
#include <flash/geom/Rectangle.h>
#endif
#ifndef INCLUDED_openfl_display_DirectRenderer
#include <openfl/display/DirectRenderer.h>
#endif
namespace openfl{
namespace display{

Void DirectRenderer_obj::__construct(::String __o_type)
{
HX_STACK_FRAME("openfl.display.DirectRenderer","new",0xe4324b68,"openfl.display.DirectRenderer.new","openfl/display/DirectRenderer.hx",13,0x16986dc6)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_type,"type")
::String type = __o_type.Default(HX_CSTRING("DirectRenderer"));
{
	HX_STACK_LINE(13)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(15)
	Dynamic _g1 = ::openfl::display::DirectRenderer_obj::lime_direct_renderer_create();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(15)
	super::__construct(_g1,type);

	HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Array< ::Dynamic >,_g)
	Void run(Dynamic _){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","openfl/display/DirectRenderer.hx",17,0x16986dc6)
		HX_STACK_ARG(_,"_")
		{
			HX_STACK_LINE(17)
			::openfl::display::DirectRenderer_obj::lime_direct_renderer_set(_g->__get((int)0).StaticCast< ::openfl::display::DirectRenderer >()->__handle,_g->__get((int)0).StaticCast< ::openfl::display::DirectRenderer >()->__onRender_dyn());
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_STACK_LINE(17)
	this->addEventListener(::flash::events::Event_obj::ADDED_TO_STAGE, Dynamic(new _Function_1_1(_g)),null(),null(),null());

	HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_2,Array< ::Dynamic >,_g)
	Void run(Dynamic _){
		HX_STACK_FRAME("*","_Function_1_2",0x5200ed38,"*._Function_1_2","openfl/display/DirectRenderer.hx",18,0x16986dc6)
		HX_STACK_ARG(_,"_")
		{
			HX_STACK_LINE(18)
			::openfl::display::DirectRenderer_obj::lime_direct_renderer_set(_g->__get((int)0).StaticCast< ::openfl::display::DirectRenderer >()->__handle,null());
		}
		return null();
	}
	HX_END_LOCAL_FUNC1((void))

	HX_STACK_LINE(18)
	this->addEventListener(::flash::events::Event_obj::REMOVED_FROM_STAGE, Dynamic(new _Function_1_2(_g)),null(),null(),null());
}
;
	return null();
}

//DirectRenderer_obj::~DirectRenderer_obj() { }

Dynamic DirectRenderer_obj::__CreateEmpty() { return  new DirectRenderer_obj; }
hx::ObjectPtr< DirectRenderer_obj > DirectRenderer_obj::__new(::String __o_type)
{  hx::ObjectPtr< DirectRenderer_obj > result = new DirectRenderer_obj();
	result->__construct(__o_type);
	return result;}

Dynamic DirectRenderer_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DirectRenderer_obj > result = new DirectRenderer_obj();
	result->__construct(inArgs[0]);
	return result;}

HX_BEGIN_DEFAULT_FUNC(__default_render,DirectRenderer_obj)
Void run(::flash::geom::Rectangle rect){
{
		HX_STACK_FRAME("openfl.display.DirectRenderer","render",0xb293854e,"openfl.display.DirectRenderer.render","openfl/display/DirectRenderer.hx",23,0x16986dc6)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rect,"rect")
	}
return null();
}
HX_END_LOCAL_FUNC1((void))
HX_END_DEFAULT_FUNC

Void DirectRenderer_obj::__onRender( Dynamic rect){
{
		HX_STACK_FRAME("openfl.display.DirectRenderer","__onRender",0x02594aed,"openfl.display.DirectRenderer.__onRender","openfl/display/DirectRenderer.hx",32,0x16986dc6)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rect,"rect")
		HX_STACK_LINE(32)
		if (((this->render_dyn() != null()))){
			HX_STACK_LINE(32)
			::flash::geom::Rectangle _g = ::flash::geom::Rectangle_obj::__new(rect->__Field(HX_CSTRING("x"),true),rect->__Field(HX_CSTRING("y"),true),rect->__Field(HX_CSTRING("width"),true),rect->__Field(HX_CSTRING("height"),true));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(32)
			this->render(_g);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(DirectRenderer_obj,__onRender,(void))

Dynamic DirectRenderer_obj::lime_direct_renderer_create;

Dynamic DirectRenderer_obj::lime_direct_renderer_set;


DirectRenderer_obj::DirectRenderer_obj()
{
	render = new __default_render(this);
}

void DirectRenderer_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DirectRenderer);
	HX_MARK_MEMBER_NAME(render,"render");
	::flash::display::DisplayObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void DirectRenderer_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(render,"render");
	::flash::display::DisplayObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic DirectRenderer_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"__onRender") ) { return __onRender_dyn(); }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_direct_renderer_set") ) { return lime_direct_renderer_set; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_direct_renderer_create") ) { return lime_direct_renderer_create; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DirectRenderer_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { render=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_direct_renderer_set") ) { lime_direct_renderer_set=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_direct_renderer_create") ) { lime_direct_renderer_create=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DirectRenderer_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("lime_direct_renderer_create"),
	HX_CSTRING("lime_direct_renderer_set"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(DirectRenderer_obj,render),HX_CSTRING("render")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("render"),
	HX_CSTRING("__onRender"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DirectRenderer_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(DirectRenderer_obj::lime_direct_renderer_create,"lime_direct_renderer_create");
	HX_MARK_MEMBER_NAME(DirectRenderer_obj::lime_direct_renderer_set,"lime_direct_renderer_set");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DirectRenderer_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(DirectRenderer_obj::lime_direct_renderer_create,"lime_direct_renderer_create");
	HX_VISIT_MEMBER_NAME(DirectRenderer_obj::lime_direct_renderer_set,"lime_direct_renderer_set");
};

#endif

Class DirectRenderer_obj::__mClass;

void DirectRenderer_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.display.DirectRenderer"), hx::TCanCast< DirectRenderer_obj> ,sStaticFields,sMemberFields,
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

void DirectRenderer_obj::__boot()
{
	lime_direct_renderer_create= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_direct_renderer_create"),(int)0);
	lime_direct_renderer_set= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_direct_renderer_set"),(int)2);
}

} // end namespace openfl
} // end namespace display
