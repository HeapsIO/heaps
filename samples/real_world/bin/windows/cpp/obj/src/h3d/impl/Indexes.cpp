#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_openfl_gl_GLBuffer
#include <openfl/gl/GLBuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
namespace h3d{
namespace impl{

Void Indexes_obj::__construct(::h3d::impl::MemoryManager mem,::openfl::gl::GLBuffer ibuf,int count)
{
HX_STACK_FRAME("h3d.impl.Indexes","new",0x69358b19,"h3d.impl.Indexes.new","h3d/impl/Indexes.hx",11,0x0034aed7)
HX_STACK_THIS(this)
HX_STACK_ARG(mem,"mem")
HX_STACK_ARG(ibuf,"ibuf")
HX_STACK_ARG(count,"count")
{
	HX_STACK_LINE(12)
	this->mem = mem;
	HX_STACK_LINE(13)
	this->ibuf = ibuf;
	HX_STACK_LINE(14)
	this->count = count;
}
;
	return null();
}

//Indexes_obj::~Indexes_obj() { }

Dynamic Indexes_obj::__CreateEmpty() { return  new Indexes_obj; }
hx::ObjectPtr< Indexes_obj > Indexes_obj::__new(::h3d::impl::MemoryManager mem,::openfl::gl::GLBuffer ibuf,int count)
{  hx::ObjectPtr< Indexes_obj > result = new Indexes_obj();
	result->__construct(mem,ibuf,count);
	return result;}

Dynamic Indexes_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Indexes_obj > result = new Indexes_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

bool Indexes_obj::isDisposed( ){
	HX_STACK_FRAME("h3d.impl.Indexes","isDisposed",0x83f11b56,"h3d.impl.Indexes.isDisposed","h3d/impl/Indexes.hx",18,0x0034aed7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(18)
	return (this->ibuf == null());
}


HX_DEFINE_DYNAMIC_FUNC0(Indexes_obj,isDisposed,return )

Void Indexes_obj::upload( Array< int > indexes,int pos,int count,hx::Null< int >  __o_bufferPos){
int bufferPos = __o_bufferPos.Default(0);
	HX_STACK_FRAME("h3d.impl.Indexes","upload",0x9210c8e8,"h3d.impl.Indexes.upload","h3d/impl/Indexes.hx",22,0x0034aed7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(indexes,"indexes")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(count,"count")
	HX_STACK_ARG(bufferPos,"bufferPos")
{
		HX_STACK_LINE(22)
		this->mem->driver->uploadIndexesBuffer(this->ibuf,pos,count,indexes,bufferPos);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Indexes_obj,upload,(void))

Void Indexes_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.impl.Indexes","dispose",0xb5b48bd8,"h3d.impl.Indexes.dispose","h3d/impl/Indexes.hx",26,0x0034aed7)
		HX_STACK_THIS(this)
		HX_STACK_LINE(26)
		if (((this->ibuf != null()))){
			HX_STACK_LINE(27)
			this->mem->deleteIndexes(hx::ObjectPtr<OBJ_>(this));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Indexes_obj,dispose,(void))


Indexes_obj::Indexes_obj()
{
}

void Indexes_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Indexes);
	HX_MARK_MEMBER_NAME(mem,"mem");
	HX_MARK_MEMBER_NAME(ibuf,"ibuf");
	HX_MARK_MEMBER_NAME(count,"count");
	HX_MARK_END_CLASS();
}

void Indexes_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(mem,"mem");
	HX_VISIT_MEMBER_NAME(ibuf,"ibuf");
	HX_VISIT_MEMBER_NAME(count,"count");
}

Dynamic Indexes_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"mem") ) { return mem; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"ibuf") ) { return ibuf; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"count") ) { return count; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"upload") ) { return upload_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"isDisposed") ) { return isDisposed_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Indexes_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"mem") ) { mem=inValue.Cast< ::h3d::impl::MemoryManager >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"ibuf") ) { ibuf=inValue.Cast< ::openfl::gl::GLBuffer >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"count") ) { count=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Indexes_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("mem"));
	outFields->push(HX_CSTRING("ibuf"));
	outFields->push(HX_CSTRING("count"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::impl::MemoryManager*/ ,(int)offsetof(Indexes_obj,mem),HX_CSTRING("mem")},
	{hx::fsObject /*::openfl::gl::GLBuffer*/ ,(int)offsetof(Indexes_obj,ibuf),HX_CSTRING("ibuf")},
	{hx::fsInt,(int)offsetof(Indexes_obj,count),HX_CSTRING("count")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("mem"),
	HX_CSTRING("ibuf"),
	HX_CSTRING("count"),
	HX_CSTRING("isDisposed"),
	HX_CSTRING("upload"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Indexes_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Indexes_obj::__mClass,"__mClass");
};

#endif

Class Indexes_obj::__mClass;

void Indexes_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.Indexes"), hx::TCanCast< Indexes_obj> ,sStaticFields,sMemberFields,
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

void Indexes_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
