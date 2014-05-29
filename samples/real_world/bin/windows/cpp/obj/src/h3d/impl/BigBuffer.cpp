#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_BigBuffer
#include <h3d/impl/BigBuffer.h>
#endif
#ifndef INCLUDED_h3d_impl_BigBufferFlag
#include <h3d/impl/BigBufferFlag.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_FreeCell
#include <h3d/impl/FreeCell.h>
#endif
#ifndef INCLUDED_h3d_impl_GLVB
#include <h3d/impl/GLVB.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
namespace h3d{
namespace impl{

Void BigBuffer_obj::__construct(::h3d::impl::MemoryManager mem,::h3d::impl::GLVB v,int stride,int size,hx::Null< bool >  __o_isDynamic)
{
HX_STACK_FRAME("h3d.impl.BigBuffer","new",0x1c0eb0b9,"h3d.impl.BigBuffer.new","h3d/impl/MemoryManager.hx",44,0x525e0dab)
HX_STACK_THIS(this)
HX_STACK_ARG(mem,"mem")
HX_STACK_ARG(v,"v")
HX_STACK_ARG(stride,"stride")
HX_STACK_ARG(size,"size")
HX_STACK_ARG(__o_isDynamic,"isDynamic")
bool isDynamic = __o_isDynamic.Default(false);
{
	HX_STACK_LINE(45)
	this->mem = mem;
	HX_STACK_LINE(46)
	this->size = size;
	HX_STACK_LINE(47)
	this->stride = stride;
	HX_STACK_LINE(48)
	this->vbuf = v;
	HX_STACK_LINE(49)
	::h3d::impl::FreeCell _g = ::h3d::impl::FreeCell_obj::__new((int)0,size,null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(49)
	this->free = _g;
	HX_STACK_LINE(50)
	this->flags = (int)0;
	HX_STACK_LINE(51)
	if ((isDynamic)){
		HX_STACK_LINE(51)
		int _g1 = ::h3d::impl::BigBufferFlag_obj::BBF_DYNAMIC->__Index();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(51)
		int _g2 = (int((int)1) << int(_g1));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(51)
		hx::OrEq(this->flags,_g2);
	}
}
;
	return null();
}

//BigBuffer_obj::~BigBuffer_obj() { }

Dynamic BigBuffer_obj::__CreateEmpty() { return  new BigBuffer_obj; }
hx::ObjectPtr< BigBuffer_obj > BigBuffer_obj::__new(::h3d::impl::MemoryManager mem,::h3d::impl::GLVB v,int stride,int size,hx::Null< bool >  __o_isDynamic)
{  hx::ObjectPtr< BigBuffer_obj > result = new BigBuffer_obj();
	result->__construct(mem,v,stride,size,__o_isDynamic);
	return result;}

Dynamic BigBuffer_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BigBuffer_obj > result = new BigBuffer_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

bool BigBuffer_obj::isDynamic( ){
	HX_STACK_FRAME("h3d.impl.BigBuffer","isDynamic",0x1a2d45ce,"h3d.impl.BigBuffer.isDynamic","h3d/impl/MemoryManager.hx",54,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(54)
	int _g = ::h3d::impl::BigBufferFlag_obj::BBF_DYNAMIC->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(54)
	int _g1 = (int((int)1) << int(_g));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(54)
	int _g2 = (int(this->flags) & int(_g1));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(54)
	return (_g2 != (int)0);
}


HX_DEFINE_DYNAMIC_FUNC0(BigBuffer_obj,isDynamic,return )

Void BigBuffer_obj::freeCursor( int pos,int nvect){
{
		HX_STACK_FRAME("h3d.impl.BigBuffer","freeCursor",0x2f733569,"h3d.impl.BigBuffer.freeCursor","h3d/impl/MemoryManager.hx",56,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(nvect,"nvect")
		HX_STACK_LINE(57)
		::h3d::impl::FreeCell prev = null();		HX_STACK_VAR(prev,"prev");
		HX_STACK_LINE(58)
		::h3d::impl::FreeCell f = this->free;		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(59)
		int end = (pos + nvect);		HX_STACK_VAR(end,"end");
		HX_STACK_LINE(60)
		while((true)){
			HX_STACK_LINE(60)
			if ((!(((f != null()))))){
				HX_STACK_LINE(60)
				break;
			}
			HX_STACK_LINE(61)
			if (((f->pos == end))){
				HX_STACK_LINE(62)
				hx::SubEq(f->pos,nvect);
				HX_STACK_LINE(63)
				hx::AddEq(f->count,nvect);
				HX_STACK_LINE(64)
				if (((bool((prev != null())) && bool(((prev->pos + prev->count) == f->pos))))){
					HX_STACK_LINE(65)
					hx::AddEq(prev->count,f->count);
					HX_STACK_LINE(66)
					prev->next = f->next;
				}
				HX_STACK_LINE(68)
				return null();
			}
			HX_STACK_LINE(70)
			if (((f->pos > end))){
				HX_STACK_LINE(71)
				if (((bool((prev != null())) && bool(((prev->pos + prev->count) == pos))))){
					HX_STACK_LINE(72)
					hx::AddEq(prev->count,nvect);
				}
				else{
					HX_STACK_LINE(74)
					::h3d::impl::FreeCell n = ::h3d::impl::FreeCell_obj::__new(pos,nvect,f);		HX_STACK_VAR(n,"n");
					HX_STACK_LINE(75)
					if (((prev == null()))){
						HX_STACK_LINE(75)
						this->free = n;
					}
					else{
						HX_STACK_LINE(75)
						prev->next = n;
					}
				}
				HX_STACK_LINE(77)
				return null();
			}
			HX_STACK_LINE(79)
			prev = f;
			HX_STACK_LINE(80)
			f = f->next;
		}
		HX_STACK_LINE(82)
		if (((nvect != (int)0))){
			HX_STACK_LINE(83)
			HX_STACK_DO_THROW(HX_CSTRING("assert"));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BigBuffer_obj,freeCursor,(void))

Void BigBuffer_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.impl.BigBuffer","dispose",0x3ca10178,"h3d.impl.BigBuffer.dispose","h3d/impl/MemoryManager.hx",86,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_LINE(87)
		this->mem->driver->disposeVertex(this->vbuf);
		HX_STACK_LINE(88)
		this->vbuf = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BigBuffer_obj,dispose,(void))

bool BigBuffer_obj::isDisposed( ){
	HX_STACK_FRAME("h3d.impl.BigBuffer","isDisposed",0xd83de9b6,"h3d.impl.BigBuffer.isDisposed","h3d/impl/MemoryManager.hx",92,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(92)
	return (this->vbuf == null());
}


HX_DEFINE_DYNAMIC_FUNC0(BigBuffer_obj,isDisposed,return )


BigBuffer_obj::BigBuffer_obj()
{
}

void BigBuffer_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BigBuffer);
	HX_MARK_MEMBER_NAME(mem,"mem");
	HX_MARK_MEMBER_NAME(stride,"stride");
	HX_MARK_MEMBER_NAME(size,"size");
	HX_MARK_MEMBER_NAME(vbuf,"vbuf");
	HX_MARK_MEMBER_NAME(free,"free");
	HX_MARK_MEMBER_NAME(next,"next");
	HX_MARK_MEMBER_NAME(flags,"flags");
	HX_MARK_MEMBER_NAME(allocHead,"allocHead");
	HX_MARK_END_CLASS();
}

void BigBuffer_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(mem,"mem");
	HX_VISIT_MEMBER_NAME(stride,"stride");
	HX_VISIT_MEMBER_NAME(size,"size");
	HX_VISIT_MEMBER_NAME(vbuf,"vbuf");
	HX_VISIT_MEMBER_NAME(free,"free");
	HX_VISIT_MEMBER_NAME(next,"next");
	HX_VISIT_MEMBER_NAME(flags,"flags");
	HX_VISIT_MEMBER_NAME(allocHead,"allocHead");
}

Dynamic BigBuffer_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"mem") ) { return mem; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { return size; }
		if (HX_FIELD_EQ(inName,"vbuf") ) { return vbuf; }
		if (HX_FIELD_EQ(inName,"free") ) { return free; }
		if (HX_FIELD_EQ(inName,"next") ) { return next; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"flags") ) { return flags; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"stride") ) { return stride; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocHead") ) { return allocHead; }
		if (HX_FIELD_EQ(inName,"isDynamic") ) { return isDynamic_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"freeCursor") ) { return freeCursor_dyn(); }
		if (HX_FIELD_EQ(inName,"isDisposed") ) { return isDisposed_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BigBuffer_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"mem") ) { mem=inValue.Cast< ::h3d::impl::MemoryManager >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"size") ) { size=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"vbuf") ) { vbuf=inValue.Cast< ::h3d::impl::GLVB >(); return inValue; }
		if (HX_FIELD_EQ(inName,"free") ) { free=inValue.Cast< ::h3d::impl::FreeCell >(); return inValue; }
		if (HX_FIELD_EQ(inName,"next") ) { next=inValue.Cast< ::h3d::impl::BigBuffer >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"flags") ) { flags=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"stride") ) { stride=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocHead") ) { allocHead=inValue.Cast< ::h3d::impl::Buffer >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BigBuffer_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("mem"));
	outFields->push(HX_CSTRING("stride"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("vbuf"));
	outFields->push(HX_CSTRING("free"));
	outFields->push(HX_CSTRING("next"));
	outFields->push(HX_CSTRING("flags"));
	outFields->push(HX_CSTRING("allocHead"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::impl::MemoryManager*/ ,(int)offsetof(BigBuffer_obj,mem),HX_CSTRING("mem")},
	{hx::fsInt,(int)offsetof(BigBuffer_obj,stride),HX_CSTRING("stride")},
	{hx::fsInt,(int)offsetof(BigBuffer_obj,size),HX_CSTRING("size")},
	{hx::fsObject /*::h3d::impl::GLVB*/ ,(int)offsetof(BigBuffer_obj,vbuf),HX_CSTRING("vbuf")},
	{hx::fsObject /*::h3d::impl::FreeCell*/ ,(int)offsetof(BigBuffer_obj,free),HX_CSTRING("free")},
	{hx::fsObject /*::h3d::impl::BigBuffer*/ ,(int)offsetof(BigBuffer_obj,next),HX_CSTRING("next")},
	{hx::fsInt,(int)offsetof(BigBuffer_obj,flags),HX_CSTRING("flags")},
	{hx::fsObject /*::h3d::impl::Buffer*/ ,(int)offsetof(BigBuffer_obj,allocHead),HX_CSTRING("allocHead")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("mem"),
	HX_CSTRING("stride"),
	HX_CSTRING("size"),
	HX_CSTRING("vbuf"),
	HX_CSTRING("free"),
	HX_CSTRING("next"),
	HX_CSTRING("flags"),
	HX_CSTRING("allocHead"),
	HX_CSTRING("isDynamic"),
	HX_CSTRING("freeCursor"),
	HX_CSTRING("dispose"),
	HX_CSTRING("isDisposed"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BigBuffer_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(BigBuffer_obj::__mClass,"__mClass");
};

#endif

Class BigBuffer_obj::__mClass;

void BigBuffer_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.BigBuffer"), hx::TCanCast< BigBuffer_obj> ,sStaticFields,sMemberFields,
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

void BigBuffer_obj::__boot()
{
}

} // end namespace h3d
} // end namespace impl
