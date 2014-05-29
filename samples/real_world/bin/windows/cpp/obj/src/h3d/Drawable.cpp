#include <hxcpp.h>

#ifndef INCLUDED_h3d_Drawable
#include <h3d/Drawable.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_IDrawable
#include <h3d/IDrawable.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
namespace h3d{

Void Drawable_obj::__construct(::h3d::prim::Primitive prim,Dynamic shader)
{
HX_STACK_FRAME("h3d.Drawable","new",0xfe64a605,"h3d.Drawable.new","h3d/Drawable.hx",13,0x63082eaa)
HX_STACK_THIS(this)
HX_STACK_ARG(prim,"prim")
HX_STACK_ARG(shader,"shader")
{
	HX_STACK_LINE(14)
	this->primitive = prim;
	HX_STACK_LINE(15)
	this->shader = shader;
	HX_STACK_LINE(16)
	::h3d::mat::Material _g = ::h3d::mat::Material_obj::__new(shader);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(16)
	this->material = _g;
}
;
	return null();
}

//Drawable_obj::~Drawable_obj() { }

Dynamic Drawable_obj::__CreateEmpty() { return  new Drawable_obj; }
hx::ObjectPtr< Drawable_obj > Drawable_obj::__new(::h3d::prim::Primitive prim,Dynamic shader)
{  hx::ObjectPtr< Drawable_obj > result = new Drawable_obj();
	result->__construct(prim,shader);
	return result;}

Dynamic Drawable_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Drawable_obj > result = new Drawable_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

hx::Object *Drawable_obj::__ToInterface(const hx::type_info &inType) {
	if (inType==typeid( ::h3d::IDrawable_obj)) return operator ::h3d::IDrawable_obj *();
	return super::__ToInterface(inType);
}

Void Drawable_obj::render( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.Drawable","render",0x689bead1,"h3d.Drawable.render","h3d/Drawable.hx",19,0x63082eaa)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(20)
		engine->selectMaterial(this->material);
		HX_STACK_LINE(21)
		this->primitive->render(engine);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Drawable_obj,render,(void))


Drawable_obj::Drawable_obj()
{
}

void Drawable_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Drawable);
	HX_MARK_MEMBER_NAME(shader,"shader");
	HX_MARK_MEMBER_NAME(primitive,"primitive");
	HX_MARK_MEMBER_NAME(material,"material");
	HX_MARK_END_CLASS();
}

void Drawable_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(shader,"shader");
	HX_VISIT_MEMBER_NAME(primitive,"primitive");
	HX_VISIT_MEMBER_NAME(material,"material");
}

Dynamic Drawable_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { return shader; }
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"material") ) { return material; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"primitive") ) { return primitive; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Drawable_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { shader=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"material") ) { material=inValue.Cast< ::h3d::mat::Material >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"primitive") ) { primitive=inValue.Cast< ::h3d::prim::Primitive >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Drawable_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("shader"));
	outFields->push(HX_CSTRING("primitive"));
	outFields->push(HX_CSTRING("material"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Drawable_obj,shader),HX_CSTRING("shader")},
	{hx::fsObject /*::h3d::prim::Primitive*/ ,(int)offsetof(Drawable_obj,primitive),HX_CSTRING("primitive")},
	{hx::fsObject /*::h3d::mat::Material*/ ,(int)offsetof(Drawable_obj,material),HX_CSTRING("material")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("shader"),
	HX_CSTRING("primitive"),
	HX_CSTRING("material"),
	HX_CSTRING("render"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Drawable_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Drawable_obj::__mClass,"__mClass");
};

#endif

Class Drawable_obj::__mClass;

void Drawable_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.Drawable"), hx::TCanCast< Drawable_obj> ,sStaticFields,sMemberFields,
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

void Drawable_obj::__boot()
{
}

} // end namespace h3d
