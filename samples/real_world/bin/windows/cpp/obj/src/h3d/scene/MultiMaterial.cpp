#include <hxcpp.h>

#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshMaterial
#include <h3d/mat/MeshMaterial.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_h3d_scene_Mesh
#include <h3d/scene/Mesh.h>
#endif
#ifndef INCLUDED_h3d_scene_MultiMaterial
#include <h3d/scene/MultiMaterial.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
namespace h3d{
namespace scene{

Void MultiMaterial_obj::__construct(::h3d::prim::Primitive prim,Array< ::Dynamic > mats,::h3d::scene::Object parent)
{
HX_STACK_FRAME("h3d.scene.MultiMaterial","new",0x62754d3b,"h3d.scene.MultiMaterial.new","h3d/scene/MultiMaterial.hx",7,0x61ba0d57)
HX_STACK_THIS(this)
HX_STACK_ARG(prim,"prim")
HX_STACK_ARG(mats,"mats")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(8)
	super::__construct(prim,mats->__get((int)0).StaticCast< ::h3d::mat::MeshMaterial >(),parent);
	HX_STACK_LINE(9)
	this->materials = mats;
}
;
	return null();
}

//MultiMaterial_obj::~MultiMaterial_obj() { }

Dynamic MultiMaterial_obj::__CreateEmpty() { return  new MultiMaterial_obj; }
hx::ObjectPtr< MultiMaterial_obj > MultiMaterial_obj::__new(::h3d::prim::Primitive prim,Array< ::Dynamic > mats,::h3d::scene::Object parent)
{  hx::ObjectPtr< MultiMaterial_obj > result = new MultiMaterial_obj();
	result->__construct(prim,mats,parent);
	return result;}

Dynamic MultiMaterial_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MultiMaterial_obj > result = new MultiMaterial_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::h3d::scene::Object MultiMaterial_obj::clone( ::h3d::scene::Object o){
	HX_STACK_FRAME("h3d.scene.MultiMaterial","clone",0x9381bcf8,"h3d.scene.MultiMaterial.clone","h3d/scene/MultiMaterial.hx",12,0x61ba0d57)
	HX_STACK_THIS(this)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(13)
	::h3d::scene::MultiMaterial m;		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(13)
	if (((o == null()))){
		HX_STACK_LINE(13)
		m = ::h3d::scene::MultiMaterial_obj::__new(null(),this->materials,null());
	}
	else{
		HX_STACK_LINE(13)
		m = o;
	}
	HX_STACK_LINE(14)
	Array< ::Dynamic > _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(14)
	{
		HX_STACK_LINE(14)
		Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(14)
		{
			HX_STACK_LINE(14)
			int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(14)
			Array< ::Dynamic > _g2 = this->materials;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(14)
			while((true)){
				HX_STACK_LINE(14)
				if ((!(((_g11 < _g2->length))))){
					HX_STACK_LINE(14)
					break;
				}
				HX_STACK_LINE(14)
				::h3d::mat::MeshMaterial m1 = _g2->__get(_g11).StaticCast< ::h3d::mat::MeshMaterial >();		HX_STACK_VAR(m1,"m1");
				HX_STACK_LINE(14)
				++(_g11);
				HX_STACK_LINE(14)
				::h3d::mat::MeshMaterial _g3 = hx::TCast< ::h3d::mat::MeshMaterial >::cast(m1->clone(null()));		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(14)
				_g->push(_g3);
			}
		}
		HX_STACK_LINE(14)
		_g1 = _g;
	}
	HX_STACK_LINE(14)
	m->materials = _g1;
	HX_STACK_LINE(15)
	hx::TCast< ::h3d::scene::Mesh >::cast(this->super::clone(m));
	HX_STACK_LINE(16)
	m->material = m->materials->__get((int)0).StaticCast< ::h3d::mat::MeshMaterial >();
	HX_STACK_LINE(17)
	return m;
}


Void MultiMaterial_obj::drawMaterial( ::h3d::scene::RenderContext ctx,int mid){
{
		HX_STACK_FRAME("h3d.scene.MultiMaterial","drawMaterial",0x2a1c7890,"h3d.scene.MultiMaterial.drawMaterial","h3d/scene/MultiMaterial.hx",21,0x61ba0d57)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_ARG(mid,"mid")
		HX_STACK_LINE(22)
		::h3d::mat::MeshMaterial m = this->materials->__get(mid).StaticCast< ::h3d::mat::MeshMaterial >();		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(23)
		if (((m == null()))){
			HX_STACK_LINE(24)
			return null();
		}
		HX_STACK_LINE(25)
		if (((m->renderPass > ctx->currentPass))){
			HX_STACK_LINE(26)
			Dynamic _g;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(26)
			{
				HX_STACK_LINE(26)
				Dynamic f = Dynamic( Array_obj<Dynamic>::__new().Add(this->drawMaterial_dyn()));		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(26)
				Array< int > a2 = Array_obj< int >::__new().Add(mid);		HX_STACK_VAR(a2,"a2");

				HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_3_1,Dynamic,f,Array< int >,a2)
				Void run(::h3d::scene::RenderContext a1){
					HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","h3d/scene/MultiMaterial.hx",26,0x61ba0d57)
					HX_STACK_ARG(a1,"a1")
					{
						HX_STACK_LINE(26)
						return null(f->__GetItem((int)0)(a1,a2->__get((int)0)).Cast< Void >());
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				HX_STACK_LINE(26)
				_g =  Dynamic(new _Function_3_1(f,a2));
			}
			HX_STACK_LINE(26)
			ctx->addPass(_g);
			HX_STACK_LINE(27)
			return null();
		}
		HX_STACK_LINE(29)
		ctx->localPos = this->absPos;
		HX_STACK_LINE(30)
		m->setup(ctx);
		HX_STACK_LINE(31)
		ctx->engine->selectMaterial(m);
		HX_STACK_LINE(32)
		this->primitive->selectMaterial(mid);
		HX_STACK_LINE(33)
		this->primitive->render(ctx->engine);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(MultiMaterial_obj,drawMaterial,(void))

Void MultiMaterial_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.MultiMaterial","draw",0xbd9beec9,"h3d.scene.MultiMaterial.draw","h3d/scene/MultiMaterial.hx",37,0x61ba0d57)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(37)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(37)
		int _g = this->materials->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(37)
		while((true)){
			HX_STACK_LINE(37)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(37)
				break;
			}
			HX_STACK_LINE(37)
			int mid = (_g1)++;		HX_STACK_VAR(mid,"mid");
			HX_STACK_LINE(38)
			this->drawMaterial(ctx,mid);
		}
	}
return null();
}



MultiMaterial_obj::MultiMaterial_obj()
{
}

void MultiMaterial_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MultiMaterial);
	HX_MARK_MEMBER_NAME(materials,"materials");
	::h3d::scene::Mesh_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void MultiMaterial_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(materials,"materials");
	::h3d::scene::Mesh_obj::__Visit(HX_VISIT_ARG);
}

Dynamic MultiMaterial_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"materials") ) { return materials; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"drawMaterial") ) { return drawMaterial_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MultiMaterial_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 9:
		if (HX_FIELD_EQ(inName,"materials") ) { materials=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MultiMaterial_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("materials"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(MultiMaterial_obj,materials),HX_CSTRING("materials")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("materials"),
	HX_CSTRING("clone"),
	HX_CSTRING("drawMaterial"),
	HX_CSTRING("draw"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MultiMaterial_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MultiMaterial_obj::__mClass,"__mClass");
};

#endif

Class MultiMaterial_obj::__mClass;

void MultiMaterial_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.scene.MultiMaterial"), hx::TCanCast< MultiMaterial_obj> ,sStaticFields,sMemberFields,
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

void MultiMaterial_obj::__boot()
{
}

} // end namespace h3d
} // end namespace scene
