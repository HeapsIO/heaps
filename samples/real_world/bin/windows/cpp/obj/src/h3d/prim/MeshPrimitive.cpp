#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_BufferOffset
#include <h3d/impl/BufferOffset.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_prim_MeshPrimitive
#include <h3d/prim/MeshPrimitive.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
namespace h3d{
namespace prim{

Void MeshPrimitive_obj::__construct()
{
HX_STACK_FRAME("h3d.prim.MeshPrimitive","new",0x36606159,"h3d.prim.MeshPrimitive.new","h3d/prim/MeshPrimitive.hx",10,0x74d8e897)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//MeshPrimitive_obj::~MeshPrimitive_obj() { }

Dynamic MeshPrimitive_obj::__CreateEmpty() { return  new MeshPrimitive_obj; }
hx::ObjectPtr< MeshPrimitive_obj > MeshPrimitive_obj::__new()
{  hx::ObjectPtr< MeshPrimitive_obj > result = new MeshPrimitive_obj();
	result->__construct();
	return result;}

Dynamic MeshPrimitive_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MeshPrimitive_obj > result = new MeshPrimitive_obj();
	result->__construct();
	return result;}

::h3d::impl::BufferOffset MeshPrimitive_obj::allocBuffer( ::h3d::Engine engine,::String name){
	HX_STACK_FRAME("h3d.prim.MeshPrimitive","allocBuffer",0xf24acd4e,"h3d.prim.MeshPrimitive.allocBuffer","h3d/prim/MeshPrimitive.hx",15,0x74d8e897)
	HX_STACK_THIS(this)
	HX_STACK_ARG(engine,"engine")
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(15)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC2(MeshPrimitive_obj,allocBuffer,return )

::h3d::impl::BufferOffset MeshPrimitive_obj::getBuffer( ::String name){
	HX_STACK_FRAME("h3d.prim.MeshPrimitive","getBuffer",0x192457ef,"h3d.prim.MeshPrimitive.getBuffer","h3d/prim/MeshPrimitive.hx",27,0x74d8e897)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(27)
	return this->bufferCache->get(name);
}


HX_DEFINE_DYNAMIC_FUNC1(MeshPrimitive_obj,getBuffer,return )

::h3d::impl::BufferOffset MeshPrimitive_obj::addBuffer( ::String name,::h3d::impl::Buffer buf,hx::Null< int >  __o_offset,hx::Null< bool >  __o_shared,Dynamic stride){
int offset = __o_offset.Default(0);
bool shared = __o_shared.Default(false);
	HX_STACK_FRAME("h3d.prim.MeshPrimitive","addBuffer",0x54f203ba,"h3d.prim.MeshPrimitive.addBuffer","h3d/prim/MeshPrimitive.hx",30,0x74d8e897)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_ARG(buf,"buf")
	HX_STACK_ARG(offset,"offset")
	HX_STACK_ARG(shared,"shared")
	HX_STACK_ARG(stride,"stride")
{
		HX_STACK_LINE(31)
		if (((this->bufferCache == null()))){
			HX_STACK_LINE(31)
			::haxe::ds::StringMap _g = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(31)
			this->bufferCache = _g;
		}
		HX_STACK_LINE(32)
		::h3d::impl::BufferOffset old = this->bufferCache->get(name);		HX_STACK_VAR(old,"old");
		HX_STACK_LINE(33)
		if (((old != null()))){
			HX_STACK_LINE(33)
			old->dispose();
		}
		HX_STACK_LINE(35)
		::h3d::impl::BufferOffset bo = ::h3d::impl::BufferOffset_obj::__new(buf,offset,shared,stride);		HX_STACK_VAR(bo,"bo");
		HX_STACK_LINE(36)
		this->bufferCache->set(name,bo);
		HX_STACK_LINE(37)
		return bo;
	}
}


HX_DEFINE_DYNAMIC_FUNC5(MeshPrimitive_obj,addBuffer,return )

Void MeshPrimitive_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.prim.MeshPrimitive","dispose",0xf9a78218,"h3d.prim.MeshPrimitive.dispose","h3d/prim/MeshPrimitive.hx",40,0x74d8e897)
		HX_STACK_THIS(this)
		HX_STACK_LINE(41)
		this->super::dispose();
		HX_STACK_LINE(42)
		if (((this->bufferCache != null()))){
			HX_STACK_LINE(43)
			for(::cpp::FastIterator_obj< ::h3d::impl::BufferOffset > *__it = ::cpp::CreateFastIterator< ::h3d::impl::BufferOffset >(this->bufferCache->iterator());  __it->hasNext(); ){
				::h3d::impl::BufferOffset b = __it->next();
				b->dispose();
			}
		}
		HX_STACK_LINE(45)
		this->bufferCache = null();
	}
return null();
}


Array< ::Dynamic > MeshPrimitive_obj::getBuffers( ::h3d::Engine engine){
	HX_STACK_FRAME("h3d.prim.MeshPrimitive","getBuffers",0xe6a899a4,"h3d.prim.MeshPrimitive.getBuffers","h3d/prim/MeshPrimitive.hx",49,0x74d8e897)
	HX_STACK_THIS(this)
	HX_STACK_ARG(engine,"engine")
	HX_STACK_LINE(50)
	if (((this->bufferCache == null()))){
		HX_STACK_LINE(50)
		::haxe::ds::StringMap _g = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(50)
		this->bufferCache = _g;
	}
	HX_STACK_LINE(51)
	Array< ::Dynamic > buffers = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(buffers,"buffers");
	HX_STACK_LINE(53)
	if (((engine->driver == null()))){
		HX_STACK_LINE(53)
		HX_STACK_DO_THROW(HX_CSTRING("no engine"));
	}
	HX_STACK_LINE(55)
	{
		HX_STACK_LINE(55)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(55)
		Array< ::String > _g1 = engine->driver->getShaderInputNames();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(55)
		while((true)){
			HX_STACK_LINE(55)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(55)
				break;
			}
			HX_STACK_LINE(55)
			::String name = _g1->__get(_g);		HX_STACK_VAR(name,"name");
			HX_STACK_LINE(55)
			++(_g);
			HX_STACK_LINE(56)
			::h3d::impl::BufferOffset b = this->bufferCache->get(name);		HX_STACK_VAR(b,"b");
			HX_STACK_LINE(57)
			if (((b == null()))){
				HX_STACK_LINE(58)
				::h3d::impl::BufferOffset _g11 = this->allocBuffer(engine,name);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(58)
				b = _g11;
				HX_STACK_LINE(59)
				if (((b == null()))){
					HX_STACK_LINE(59)
					HX_STACK_DO_THROW(((HX_CSTRING("Buffer ") + name) + HX_CSTRING(" is not available")));
				}
				HX_STACK_LINE(60)
				this->bufferCache->set(name,b);
			}
			HX_STACK_LINE(62)
			buffers->push(b);
		}
	}
	HX_STACK_LINE(64)
	return buffers;
}


HX_DEFINE_DYNAMIC_FUNC1(MeshPrimitive_obj,getBuffers,return )

Void MeshPrimitive_obj::render( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.prim.MeshPrimitive","render",0xf1ecfbfd,"h3d.prim.MeshPrimitive.render","h3d/prim/MeshPrimitive.hx",67,0x74d8e897)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(69)
		if (((  ((!(((this->indexes == null()))))) ? bool(this->indexes->isDisposed()) : bool(true) ))){
			HX_STACK_LINE(70)
			this->alloc(engine);
		}
		HX_STACK_LINE(71)
		Array< ::Dynamic > _g = this->getBuffers(engine);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(71)
		engine->renderMultiBuffers(_g,this->indexes,null(),null());
	}
return null();
}


int MeshPrimitive_obj::hash( ::String name){
	HX_STACK_FRAME("h3d.prim.MeshPrimitive","hash",0x59fa78b5,"h3d.prim.MeshPrimitive.hash","h3d/prim/MeshPrimitive.hx",19,0x74d8e897)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(20)
	int id = (int)0;		HX_STACK_VAR(id,"id");
	HX_STACK_LINE(21)
	{
		HX_STACK_LINE(21)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(21)
		int _g = name.length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(21)
		while((true)){
			HX_STACK_LINE(21)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(21)
				break;
			}
			HX_STACK_LINE(21)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(22)
			Dynamic _g2 = name.charCodeAt(i);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(22)
			int _g11 = ((id * (int)223) + _g2);		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(22)
			id = _g11;
		}
	}
	HX_STACK_LINE(23)
	return (int(id) & int((int)268435455));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(MeshPrimitive_obj,hash,return )


MeshPrimitive_obj::MeshPrimitive_obj()
{
}

void MeshPrimitive_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MeshPrimitive);
	HX_MARK_MEMBER_NAME(bufferCache,"bufferCache");
	::h3d::prim::Primitive_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void MeshPrimitive_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(bufferCache,"bufferCache");
	::h3d::prim::Primitive_obj::__Visit(HX_VISIT_ARG);
}

Dynamic MeshPrimitive_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"hash") ) { return hash_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getBuffer") ) { return getBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"addBuffer") ) { return addBuffer_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getBuffers") ) { return getBuffers_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bufferCache") ) { return bufferCache; }
		if (HX_FIELD_EQ(inName,"allocBuffer") ) { return allocBuffer_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MeshPrimitive_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 11:
		if (HX_FIELD_EQ(inName,"bufferCache") ) { bufferCache=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MeshPrimitive_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bufferCache"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("hash"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::ds::StringMap*/ ,(int)offsetof(MeshPrimitive_obj,bufferCache),HX_CSTRING("bufferCache")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bufferCache"),
	HX_CSTRING("allocBuffer"),
	HX_CSTRING("getBuffer"),
	HX_CSTRING("addBuffer"),
	HX_CSTRING("dispose"),
	HX_CSTRING("getBuffers"),
	HX_CSTRING("render"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MeshPrimitive_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MeshPrimitive_obj::__mClass,"__mClass");
};

#endif

Class MeshPrimitive_obj::__mClass;

void MeshPrimitive_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.prim.MeshPrimitive"), hx::TCanCast< MeshPrimitive_obj> ,sStaticFields,sMemberFields,
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

void MeshPrimitive_obj::__boot()
{
}

} // end namespace h3d
} // end namespace prim
