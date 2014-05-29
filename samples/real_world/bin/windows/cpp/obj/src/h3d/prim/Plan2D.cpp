#include <hxcpp.h>

#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_prim_Plan2D
#include <h3d/prim/Plan2D.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
namespace h3d{
namespace prim{

Void Plan2D_obj::__construct()
{
HX_STACK_FRAME("h3d.prim.Plan2D","new",0x2e16d260,"h3d.prim.Plan2D.new","h3d/prim/Plan2D.hx",5,0xd859b0b0)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//Plan2D_obj::~Plan2D_obj() { }

Dynamic Plan2D_obj::__CreateEmpty() { return  new Plan2D_obj; }
hx::ObjectPtr< Plan2D_obj > Plan2D_obj::__new()
{  hx::ObjectPtr< Plan2D_obj > result = new Plan2D_obj();
	result->__construct();
	return result;}

Dynamic Plan2D_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Plan2D_obj > result = new Plan2D_obj();
	result->__construct();
	return result;}

Void Plan2D_obj::alloc( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.prim.Plan2D","alloc",0x879b2675,"h3d.prim.Plan2D.alloc","h3d/prim/Plan2D.hx",8,0xd859b0b0)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(9)
		Array< Float > v;		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(9)
		{
			HX_STACK_LINE(9)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(9)
			v = Array_obj< Float >::__new();
		}
		HX_STACK_LINE(10)
		v->push((int)-1);
		HX_STACK_LINE(11)
		v->push((int)-1);
		HX_STACK_LINE(12)
		v->push((int)0);
		HX_STACK_LINE(13)
		v->push((int)1);
		HX_STACK_LINE(15)
		v->push((int)-1);
		HX_STACK_LINE(16)
		v->push((int)1);
		HX_STACK_LINE(17)
		v->push((int)0);
		HX_STACK_LINE(18)
		v->push((int)0);
		HX_STACK_LINE(20)
		v->push((int)1);
		HX_STACK_LINE(21)
		v->push((int)-1);
		HX_STACK_LINE(22)
		v->push((int)1);
		HX_STACK_LINE(23)
		v->push((int)1);
		HX_STACK_LINE(25)
		v->push((int)1);
		HX_STACK_LINE(26)
		v->push((int)1);
		HX_STACK_LINE(27)
		v->push((int)1);
		HX_STACK_LINE(28)
		v->push((int)0);
		HX_STACK_LINE(30)
		::h3d::impl::Buffer _g = engine->mem->allocVector(v,(int)4,(int)4,null(),hx::SourceInfo(HX_CSTRING("Plan2D.hx"),30,HX_CSTRING("h3d.prim.Plan2D"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(30)
		this->buffer = _g;
	}
return null();
}


Void Plan2D_obj::render( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.prim.Plan2D","render",0xe5b3a956,"h3d.prim.Plan2D.render","h3d/prim/Plan2D.hx",33,0xd859b0b0)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(34)
		if (((this->buffer == null()))){
			HX_STACK_LINE(34)
			this->alloc(engine);
		}
		HX_STACK_LINE(35)
		{
			HX_STACK_LINE(35)
			int start = (int)0;		HX_STACK_VAR(start,"start");
			HX_STACK_LINE(35)
			int max = (int)-1;		HX_STACK_VAR(max,"max");
			HX_STACK_LINE(35)
			bool v = engine->renderBuffer(this->buffer,engine->mem->quadIndexes,(int)2,start,max);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(35)
			v;
		}
	}
return null();
}



Plan2D_obj::Plan2D_obj()
{
}

Dynamic Plan2D_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Plan2D_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Plan2D_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("alloc"),
	HX_CSTRING("render"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Plan2D_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Plan2D_obj::__mClass,"__mClass");
};

#endif

Class Plan2D_obj::__mClass;

void Plan2D_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.prim.Plan2D"), hx::TCanCast< Plan2D_obj> ,sStaticFields,sMemberFields,
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

void Plan2D_obj::__boot()
{
}

} // end namespace h3d
} // end namespace prim
