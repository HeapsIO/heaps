#include <hxcpp.h>

#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_col_Bounds
#include <h3d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshMaterial
#include <h3d/mat/MeshMaterial.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshShader
#include <h3d/mat/MeshShader.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_h3d_scene_Mesh
#include <h3d/scene/Mesh.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
namespace h3d{
namespace scene{

Void Mesh_obj::__construct(::h3d::prim::Primitive prim,::h3d::mat::MeshMaterial mat,::h3d::scene::Object parent)
{
HX_STACK_FRAME("h3d.scene.Mesh","new",0x3cf0c276,"h3d.scene.Mesh.new","h3d/scene/Mesh.hx",12,0x25798338)
HX_STACK_THIS(this)
HX_STACK_ARG(prim,"prim")
HX_STACK_ARG(mat,"mat")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(13)
	super::__construct(parent);
	HX_STACK_LINE(14)
	this->primitive = prim;
	HX_STACK_LINE(15)
	if (((mat == null()))){
		HX_STACK_LINE(15)
		::h3d::mat::MeshMaterial _g = ::h3d::mat::MeshMaterial_obj::__new(null(),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(15)
		mat = _g;
	}
	HX_STACK_LINE(16)
	this->material = mat;
}
;
	return null();
}

//Mesh_obj::~Mesh_obj() { }

Dynamic Mesh_obj::__CreateEmpty() { return  new Mesh_obj; }
hx::ObjectPtr< Mesh_obj > Mesh_obj::__new(::h3d::prim::Primitive prim,::h3d::mat::MeshMaterial mat,::h3d::scene::Object parent)
{  hx::ObjectPtr< Mesh_obj > result = new Mesh_obj();
	result->__construct(prim,mat,parent);
	return result;}

Dynamic Mesh_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Mesh_obj > result = new Mesh_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::h3d::col::Bounds Mesh_obj::getBounds( ::h3d::col::Bounds b){
	HX_STACK_FRAME("h3d.scene.Mesh","getBounds",0x592ab641,"h3d.scene.Mesh.getBounds","h3d/scene/Mesh.hx",19,0x25798338)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(20)
	::h3d::col::Bounds _g = this->super::getBounds(b);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(20)
	b = _g;
	HX_STACK_LINE(21)
	::h3d::col::Bounds tmp;		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(21)
	{
		HX_STACK_LINE(21)
		::h3d::col::Bounds _this = this->primitive->getBounds();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(21)
		::h3d::col::Bounds b1 = ::h3d::col::Bounds_obj::__new();		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(21)
		b1->xMin = _this->xMin;
		HX_STACK_LINE(21)
		b1->xMax = _this->xMax;
		HX_STACK_LINE(21)
		b1->yMin = _this->yMin;
		HX_STACK_LINE(21)
		b1->yMax = _this->yMax;
		HX_STACK_LINE(21)
		b1->zMin = _this->zMin;
		HX_STACK_LINE(21)
		b1->zMax = _this->zMax;
		HX_STACK_LINE(21)
		tmp = b1;
	}
	HX_STACK_LINE(22)
	tmp->transform3x4(this->absPos);
	HX_STACK_LINE(23)
	{
		HX_STACK_LINE(23)
		if (((tmp->xMin < b->xMin))){
			HX_STACK_LINE(23)
			b->xMin = tmp->xMin;
		}
		HX_STACK_LINE(23)
		if (((tmp->xMax > b->xMax))){
			HX_STACK_LINE(23)
			b->xMax = tmp->xMax;
		}
		HX_STACK_LINE(23)
		if (((tmp->yMin < b->yMin))){
			HX_STACK_LINE(23)
			b->yMin = tmp->yMin;
		}
		HX_STACK_LINE(23)
		if (((tmp->yMax > b->yMax))){
			HX_STACK_LINE(23)
			b->yMax = tmp->yMax;
		}
		HX_STACK_LINE(23)
		if (((tmp->zMin < b->zMin))){
			HX_STACK_LINE(23)
			b->zMin = tmp->zMin;
		}
		HX_STACK_LINE(23)
		if (((tmp->zMax > b->zMax))){
			HX_STACK_LINE(23)
			b->zMax = tmp->zMax;
		}
	}
	HX_STACK_LINE(24)
	return b;
}


::h3d::scene::Object Mesh_obj::clone( ::h3d::scene::Object o){
	HX_STACK_FRAME("h3d.scene.Mesh","clone",0x9bb136f3,"h3d.scene.Mesh.clone","h3d/scene/Mesh.hx",27,0x25798338)
	HX_STACK_THIS(this)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(28)
	::h3d::scene::Mesh m;		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(28)
	if (((o == null()))){
		HX_STACK_LINE(28)
		m = ::h3d::scene::Mesh_obj::__new(null(),this->material,null());
	}
	else{
		HX_STACK_LINE(28)
		m = o;
	}
	HX_STACK_LINE(29)
	m->primitive = this->primitive;
	HX_STACK_LINE(30)
	::h3d::mat::MeshMaterial _g = hx::TCast< ::h3d::mat::MeshMaterial >::cast(this->material->clone(null()));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(30)
	m->material = _g;
	HX_STACK_LINE(31)
	this->super::clone(m);
	HX_STACK_LINE(32)
	return m;
}


Void Mesh_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.Mesh","draw",0x0f270d2e,"h3d.scene.Mesh.draw","h3d/scene/Mesh.hx",36,0x25798338)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(37)
		if (((this->material->renderPass > ctx->currentPass))){
			HX_STACK_LINE(38)
			ctx->addPass(this->draw_dyn());
			HX_STACK_LINE(39)
			return null();
		}
		HX_STACK_LINE(41)
		ctx->localPos = this->absPos;
		HX_STACK_LINE(42)
		this->material->setup(ctx);
		HX_STACK_LINE(43)
		ctx->engine->selectMaterial(this->material);
		HX_STACK_LINE(44)
		this->primitive->render(ctx->engine);
	}
return null();
}


Void Mesh_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.scene.Mesh","dispose",0x191b35b5,"h3d.scene.Mesh.dispose","h3d/scene/Mesh.hx",47,0x25798338)
		HX_STACK_THIS(this)
		HX_STACK_LINE(48)
		this->primitive->dispose();
		HX_STACK_LINE(49)
		this->super::dispose();
	}
return null();
}



Mesh_obj::Mesh_obj()
{
}

void Mesh_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Mesh);
	HX_MARK_MEMBER_NAME(primitive,"primitive");
	HX_MARK_MEMBER_NAME(material,"material");
	::h3d::scene::Object_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Mesh_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(primitive,"primitive");
	HX_VISIT_MEMBER_NAME(material,"material");
	::h3d::scene::Object_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Mesh_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"material") ) { return material; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"primitive") ) { return primitive; }
		if (HX_FIELD_EQ(inName,"getBounds") ) { return getBounds_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Mesh_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"material") ) { material=inValue.Cast< ::h3d::mat::MeshMaterial >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"primitive") ) { primitive=inValue.Cast< ::h3d::prim::Primitive >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Mesh_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("primitive"));
	outFields->push(HX_CSTRING("material"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::prim::Primitive*/ ,(int)offsetof(Mesh_obj,primitive),HX_CSTRING("primitive")},
	{hx::fsObject /*::h3d::mat::MeshMaterial*/ ,(int)offsetof(Mesh_obj,material),HX_CSTRING("material")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("primitive"),
	HX_CSTRING("material"),
	HX_CSTRING("getBounds"),
	HX_CSTRING("clone"),
	HX_CSTRING("draw"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Mesh_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Mesh_obj::__mClass,"__mClass");
};

#endif

Class Mesh_obj::__mClass;

void Mesh_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.scene.Mesh"), hx::TCanCast< Mesh_obj> ,sStaticFields,sMemberFields,
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

void Mesh_obj::__boot()
{
}

} // end namespace h3d
} // end namespace scene
