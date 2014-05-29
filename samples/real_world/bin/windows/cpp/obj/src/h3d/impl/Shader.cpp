#include <hxcpp.h>

#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_GlDriver
#include <h3d/impl/GlDriver.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_impl_ShaderInstance
#include <h3d/impl/ShaderInstance.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace h3d{
namespace impl{

Void Shader_obj::__construct()
{
HX_STACK_FRAME("h3d.impl.Shader","new",0x2a3c0a50,"h3d.impl.Shader.new","h3d/impl/Shader.hx",86,0x8487c6c0)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//Shader_obj::~Shader_obj() { }

Dynamic Shader_obj::__CreateEmpty() { return  new Shader_obj; }
hx::ObjectPtr< Shader_obj > Shader_obj::__new()
{  hx::ObjectPtr< Shader_obj > result = new Shader_obj();
	result->__construct();
	return result;}

Dynamic Shader_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Shader_obj > result = new Shader_obj();
	result->__construct();
	return result;}

Void Shader_obj::customSetup( ::h3d::impl::GlDriver driver){
{
		HX_STACK_FRAME("h3d.impl.Shader","customSetup",0xe407befc,"h3d.impl.Shader.customSetup","h3d/impl/Shader.hx",89,0x8487c6c0)
		HX_STACK_THIS(this)
		HX_STACK_ARG(driver,"driver")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Shader_obj,customSetup,(void))

::String Shader_obj::getConstants( bool vertex){
	HX_STACK_FRAME("h3d.impl.Shader","getConstants",0x875b1b29,"h3d.impl.Shader.getConstants","h3d/impl/Shader.hx",93,0x8487c6c0)
	HX_STACK_THIS(this)
	HX_STACK_ARG(vertex,"vertex")
	HX_STACK_LINE(93)
	return HX_CSTRING("");
}


HX_DEFINE_DYNAMIC_FUNC1(Shader_obj,getConstants,return )

Void Shader_obj::_delete( ){
{
		HX_STACK_FRAME("h3d.impl.Shader","delete",0xadbd5c3b,"h3d.impl.Shader.delete","h3d/impl/Shader.hx",98,0x8487c6c0)
		HX_STACK_THIS(this)
		HX_STACK_LINE(98)
		if (((this->instance != null()))){
			struct _Function_2_1{
				inline static ::h3d::impl::Driver Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/Shader.hx",99,0x8487c6c0)
					{
						HX_STACK_LINE(99)
						::h3d::Engine _this;		HX_STACK_VAR(_this,"_this");
						HX_STACK_LINE(99)
						{
							HX_STACK_LINE(99)
							if (((::hxd::System_obj::debugLevel >= (int)1))){
								HX_STACK_LINE(99)
								if (((::h3d::Engine_obj::CURRENT == null()))){
									HX_STACK_LINE(99)
									HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
								}
							}
							HX_STACK_LINE(99)
							_this = ::h3d::Engine_obj::CURRENT;
						}
						HX_STACK_LINE(99)
						return _this->driver;
					}
					return null();
				}
			};
			HX_STACK_LINE(99)
			(_Function_2_1::Block())->deleteShader(hx::ObjectPtr<OBJ_>(this));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Shader_obj,_delete,(void))


Shader_obj::Shader_obj()
{
}

void Shader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Shader);
	HX_MARK_MEMBER_NAME(instance,"instance");
	HX_MARK_END_CLASS();
}

void Shader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(instance,"instance");
}

Dynamic Shader_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"delete") ) { return _delete_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"instance") ) { return instance; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"customSetup") ) { return customSetup_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"getConstants") ) { return getConstants_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Shader_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"instance") ) { instance=inValue.Cast< ::h3d::impl::ShaderInstance >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Shader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("instance"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::impl::ShaderInstance*/ ,(int)offsetof(Shader_obj,instance),HX_CSTRING("instance")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("instance"),
	HX_CSTRING("customSetup"),
	HX_CSTRING("getConstants"),
	HX_CSTRING("delete"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Shader_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Shader_obj::__mClass,"__mClass");
};

#endif

Class Shader_obj::__mClass;

void Shader_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.Shader"), hx::TCanCast< Shader_obj> ,sStaticFields,sMemberFields,
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

void Shader_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
