#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_col_Bounds
#include <h3d/col/Bounds.h>
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
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
namespace h3d{
namespace prim{

Void Primitive_obj::__construct()
{
	return null();
}

//Primitive_obj::~Primitive_obj() { }

Dynamic Primitive_obj::__CreateEmpty() { return  new Primitive_obj; }
hx::ObjectPtr< Primitive_obj > Primitive_obj::__new()
{  hx::ObjectPtr< Primitive_obj > result = new Primitive_obj();
	result->__construct();
	return result;}

Dynamic Primitive_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Primitive_obj > result = new Primitive_obj();
	result->__construct();
	return result;}

int Primitive_obj::triCount( ){
	HX_STACK_FRAME("h3d.prim.Primitive","triCount",0x4400153e,"h3d.prim.Primitive.triCount","h3d/prim/Primitive.hx",8,0xd3de1d8a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(9)
	if (((this->indexes != null()))){
		HX_STACK_LINE(10)
		return ::Std_obj::_int((Float(this->indexes->count) / Float((int)3)));
	}
	HX_STACK_LINE(11)
	int count = (int)0;		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(12)
	::h3d::impl::Buffer b = this->buffer;		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(13)
	while((true)){
		HX_STACK_LINE(13)
		if ((!(((b != null()))))){
			HX_STACK_LINE(13)
			break;
		}
		HX_STACK_LINE(14)
		int _g = ::Std_obj::_int((Float(b->nvert) / Float((int)3)));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(14)
		hx::AddEq(count,_g);
		HX_STACK_LINE(15)
		b = b->next;
	}
	HX_STACK_LINE(17)
	return count;
}


HX_DEFINE_DYNAMIC_FUNC0(Primitive_obj,triCount,return )

::h3d::col::Bounds Primitive_obj::getBounds( ){
	HX_STACK_FRAME("h3d.prim.Primitive","getBounds",0x015110d1,"h3d.prim.Primitive.getBounds","h3d/prim/Primitive.hx",20,0xd3de1d8a)
	HX_STACK_THIS(this)
	HX_STACK_LINE(21)
	HX_STACK_DO_THROW(HX_CSTRING("not implemented"));
	HX_STACK_LINE(22)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Primitive_obj,getBounds,return )

Void Primitive_obj::alloc( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.prim.Primitive","alloc",0xe9039a9b,"h3d.prim.Primitive.alloc","h3d/prim/Primitive.hx",29,0xd3de1d8a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(29)
		HX_STACK_DO_THROW(HX_CSTRING("not implemented"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Primitive_obj,alloc,(void))

Void Primitive_obj::selectMaterial( int material){
{
		HX_STACK_FRAME("h3d.prim.Primitive","selectMaterial",0xb6c6a4dd,"h3d.prim.Primitive.selectMaterial","h3d/prim/Primitive.hx",32,0xd3de1d8a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(material,"material")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Primitive_obj,selectMaterial,(void))

Void Primitive_obj::render( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.prim.Primitive","render",0xbfb0d670,"h3d.prim.Primitive.render","h3d/prim/Primitive.hx",35,0xd3de1d8a)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(36)
		if (((  ((!(((this->buffer == null()))))) ? bool(this->buffer->isDisposed()) : bool(true) ))){
			HX_STACK_LINE(36)
			this->alloc(engine);
		}
		HX_STACK_LINE(38)
		if (((this->indexes == null()))){
			HX_STACK_LINE(38)
			int start = (int)0;		HX_STACK_VAR(start,"start");
			HX_STACK_LINE(38)
			int max = (int)-1;		HX_STACK_VAR(max,"max");
			HX_STACK_LINE(38)
			bool v = engine->renderBuffer(this->buffer,engine->mem->indexes,(int)3,start,max);		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(38)
			v;
		}
		else{
			HX_STACK_LINE(39)
			engine->renderIndexed(this->buffer,this->indexes,null(),null());
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Primitive_obj,render,(void))

Void Primitive_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.prim.Primitive","dispose",0x3742cc45,"h3d.prim.Primitive.dispose","h3d/prim/Primitive.hx",42,0xd3de1d8a)
		HX_STACK_THIS(this)
		HX_STACK_LINE(43)
		if (((this->buffer != null()))){
			HX_STACK_LINE(44)
			this->buffer->dispose();
			HX_STACK_LINE(45)
			this->buffer = null();
		}
		HX_STACK_LINE(47)
		if (((this->indexes != null()))){
			HX_STACK_LINE(48)
			this->indexes->dispose();
			HX_STACK_LINE(49)
			this->indexes = null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Primitive_obj,dispose,(void))


Primitive_obj::Primitive_obj()
{
}

void Primitive_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Primitive);
	HX_MARK_MEMBER_NAME(buffer,"buffer");
	HX_MARK_MEMBER_NAME(indexes,"indexes");
	HX_MARK_END_CLASS();
}

void Primitive_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(buffer,"buffer");
	HX_VISIT_MEMBER_NAME(indexes,"indexes");
}

Dynamic Primitive_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"buffer") ) { return buffer; }
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"indexes") ) { return indexes; }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"triCount") ) { return triCount_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getBounds") ) { return getBounds_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"selectMaterial") ) { return selectMaterial_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Primitive_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"buffer") ) { buffer=inValue.Cast< ::h3d::impl::Buffer >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"indexes") ) { indexes=inValue.Cast< ::h3d::impl::Indexes >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Primitive_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("buffer"));
	outFields->push(HX_CSTRING("indexes"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::impl::Buffer*/ ,(int)offsetof(Primitive_obj,buffer),HX_CSTRING("buffer")},
	{hx::fsObject /*::h3d::impl::Indexes*/ ,(int)offsetof(Primitive_obj,indexes),HX_CSTRING("indexes")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("buffer"),
	HX_CSTRING("indexes"),
	HX_CSTRING("triCount"),
	HX_CSTRING("getBounds"),
	HX_CSTRING("alloc"),
	HX_CSTRING("selectMaterial"),
	HX_CSTRING("render"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Primitive_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Primitive_obj::__mClass,"__mClass");
};

#endif

Class Primitive_obj::__mClass;

void Primitive_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.prim.Primitive"), hx::TCanCast< Primitive_obj> ,sStaticFields,sMemberFields,
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

void Primitive_obj::__boot()
{
}

} // end namespace h3d
} // end namespace prim
