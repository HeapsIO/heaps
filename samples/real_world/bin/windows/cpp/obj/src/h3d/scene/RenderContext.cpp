#include <hxcpp.h>

#ifndef INCLUDED_h3d_Camera
#include <h3d/Camera.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_hxd_Stage
#include <hxd/Stage.h>
#endif
namespace h3d{
namespace scene{

Void RenderContext_obj::__construct()
{
HX_STACK_FRAME("h3d.scene.RenderContext","new",0x0f7182b4,"h3d.scene.RenderContext.new","h3d/scene/RenderContext.hx",13,0x10fee9fe)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(14)
	this->time = 0.;
	HX_STACK_LINE(15)
	Float _g = ::hxd::Stage_obj::getInstance()->getFrameRate();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(15)
	Float _g1 = (Float(1.) / Float(_g));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(15)
	this->elapsedTime = _g1;
}
;
	return null();
}

//RenderContext_obj::~RenderContext_obj() { }

Dynamic RenderContext_obj::__CreateEmpty() { return  new RenderContext_obj; }
hx::ObjectPtr< RenderContext_obj > RenderContext_obj::__new()
{  hx::ObjectPtr< RenderContext_obj > result = new RenderContext_obj();
	result->__construct();
	return result;}

Dynamic RenderContext_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< RenderContext_obj > result = new RenderContext_obj();
	result->__construct();
	return result;}

Void RenderContext_obj::addPass( Dynamic p){
{
		HX_STACK_FRAME("h3d.scene.RenderContext","addPass",0x991693e6,"h3d.scene.RenderContext.addPass","h3d/scene/RenderContext.hx",18,0x10fee9fe)
		HX_STACK_THIS(this)
		HX_STACK_ARG(p,"p")
		HX_STACK_LINE(19)
		if (((this->passes == null()))){
			HX_STACK_LINE(19)
			this->passes = Dynamic( Array_obj<Dynamic>::__new());
		}
		HX_STACK_LINE(20)
		this->passes->__Field(HX_CSTRING("push"),true)(p);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(RenderContext_obj,addPass,(void))

Void RenderContext_obj::finalize( ){
{
		HX_STACK_FRAME("h3d.scene.RenderContext","finalize",0x1931a2ca,"h3d.scene.RenderContext.finalize","h3d/scene/RenderContext.hx",23,0x10fee9fe)
		HX_STACK_THIS(this)
		HX_STACK_LINE(24)
		Dynamic old = this->passes;		HX_STACK_VAR(old,"old");
		HX_STACK_LINE(25)
		while((true)){
			HX_STACK_LINE(25)
			if ((!(((old != null()))))){
				HX_STACK_LINE(25)
				break;
			}
			HX_STACK_LINE(26)
			this->passes = null();
			HX_STACK_LINE(27)
			(this->currentPass)++;
			HX_STACK_LINE(28)
			{
				HX_STACK_LINE(28)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(28)
				while((true)){
					HX_STACK_LINE(28)
					if ((!(((_g < old->__Field(HX_CSTRING("length"),true)))))){
						HX_STACK_LINE(28)
						break;
					}
					HX_STACK_LINE(28)
					Dynamic p = old->__GetItem(_g);		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(28)
					++(_g);
					HX_STACK_LINE(29)
					p(hx::ObjectPtr<OBJ_>(this)).Cast< Void >();
				}
			}
			HX_STACK_LINE(30)
			old = this->passes;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(RenderContext_obj,finalize,(void))


RenderContext_obj::RenderContext_obj()
{
}

void RenderContext_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(RenderContext);
	HX_MARK_MEMBER_NAME(engine,"engine");
	HX_MARK_MEMBER_NAME(camera,"camera");
	HX_MARK_MEMBER_NAME(time,"time");
	HX_MARK_MEMBER_NAME(elapsedTime,"elapsedTime");
	HX_MARK_MEMBER_NAME(currentPass,"currentPass");
	HX_MARK_MEMBER_NAME(frame,"frame");
	HX_MARK_MEMBER_NAME(localPos,"localPos");
	HX_MARK_MEMBER_NAME(passes,"passes");
	HX_MARK_END_CLASS();
}

void RenderContext_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(engine,"engine");
	HX_VISIT_MEMBER_NAME(camera,"camera");
	HX_VISIT_MEMBER_NAME(time,"time");
	HX_VISIT_MEMBER_NAME(elapsedTime,"elapsedTime");
	HX_VISIT_MEMBER_NAME(currentPass,"currentPass");
	HX_VISIT_MEMBER_NAME(frame,"frame");
	HX_VISIT_MEMBER_NAME(localPos,"localPos");
	HX_VISIT_MEMBER_NAME(passes,"passes");
}

Dynamic RenderContext_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"time") ) { return time; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { return frame; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"engine") ) { return engine; }
		if (HX_FIELD_EQ(inName,"camera") ) { return camera; }
		if (HX_FIELD_EQ(inName,"passes") ) { return passes; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"addPass") ) { return addPass_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"localPos") ) { return localPos; }
		if (HX_FIELD_EQ(inName,"finalize") ) { return finalize_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"elapsedTime") ) { return elapsedTime; }
		if (HX_FIELD_EQ(inName,"currentPass") ) { return currentPass; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic RenderContext_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"time") ) { time=inValue.Cast< Float >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"frame") ) { frame=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"engine") ) { engine=inValue.Cast< ::h3d::Engine >(); return inValue; }
		if (HX_FIELD_EQ(inName,"camera") ) { camera=inValue.Cast< ::h3d::Camera >(); return inValue; }
		if (HX_FIELD_EQ(inName,"passes") ) { passes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"localPos") ) { localPos=inValue.Cast< ::h3d::Matrix >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"elapsedTime") ) { elapsedTime=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"currentPass") ) { currentPass=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void RenderContext_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("engine"));
	outFields->push(HX_CSTRING("camera"));
	outFields->push(HX_CSTRING("time"));
	outFields->push(HX_CSTRING("elapsedTime"));
	outFields->push(HX_CSTRING("currentPass"));
	outFields->push(HX_CSTRING("frame"));
	outFields->push(HX_CSTRING("localPos"));
	outFields->push(HX_CSTRING("passes"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::Engine*/ ,(int)offsetof(RenderContext_obj,engine),HX_CSTRING("engine")},
	{hx::fsObject /*::h3d::Camera*/ ,(int)offsetof(RenderContext_obj,camera),HX_CSTRING("camera")},
	{hx::fsFloat,(int)offsetof(RenderContext_obj,time),HX_CSTRING("time")},
	{hx::fsFloat,(int)offsetof(RenderContext_obj,elapsedTime),HX_CSTRING("elapsedTime")},
	{hx::fsInt,(int)offsetof(RenderContext_obj,currentPass),HX_CSTRING("currentPass")},
	{hx::fsInt,(int)offsetof(RenderContext_obj,frame),HX_CSTRING("frame")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(RenderContext_obj,localPos),HX_CSTRING("localPos")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(RenderContext_obj,passes),HX_CSTRING("passes")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("engine"),
	HX_CSTRING("camera"),
	HX_CSTRING("time"),
	HX_CSTRING("elapsedTime"),
	HX_CSTRING("currentPass"),
	HX_CSTRING("frame"),
	HX_CSTRING("localPos"),
	HX_CSTRING("passes"),
	HX_CSTRING("addPass"),
	HX_CSTRING("finalize"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(RenderContext_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(RenderContext_obj::__mClass,"__mClass");
};

#endif

Class RenderContext_obj::__mClass;

void RenderContext_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.scene.RenderContext"), hx::TCanCast< RenderContext_obj> ,sStaticFields,sMemberFields,
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

void RenderContext_obj::__boot()
{
}

} // end namespace h3d
} // end namespace scene
