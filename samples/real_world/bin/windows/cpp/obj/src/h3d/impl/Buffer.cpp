#include <hxcpp.h>

#ifndef INCLUDED_h3d_impl_BigBuffer
#include <h3d/impl/BigBuffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_GLVB
#include <h3d/impl/GLVB.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_Assert
#include <hxd/Assert.h>
#endif
namespace h3d{
namespace impl{

Void Buffer_obj::__construct(::h3d::impl::BigBuffer b,int pos,int nvert)
{
HX_STACK_FRAME("h3d.impl.Buffer","new",0x8cb391ab,"h3d.impl.Buffer.new","h3d/impl/Buffer.hx",9,0x06b1a3c5)
HX_STACK_THIS(this)
HX_STACK_ARG(b,"b")
HX_STACK_ARG(pos,"pos")
HX_STACK_ARG(nvert,"nvert")
{
	HX_STACK_LINE(13)
	this->id = (int)0;
	HX_STACK_LINE(26)
	this->b = b;
	HX_STACK_LINE(27)
	this->pos = pos;
	HX_STACK_LINE(28)
	this->nvert = nvert;
	HX_STACK_LINE(29)
	int _g = (::h3d::impl::Buffer_obj::GUID)++;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(29)
	this->id = _g;
}
;
	return null();
}

//Buffer_obj::~Buffer_obj() { }

Dynamic Buffer_obj::__CreateEmpty() { return  new Buffer_obj; }
hx::ObjectPtr< Buffer_obj > Buffer_obj::__new(::h3d::impl::BigBuffer b,int pos,int nvert)
{  hx::ObjectPtr< Buffer_obj > result = new Buffer_obj();
	result->__construct(b,pos,nvert);
	return result;}

Dynamic Buffer_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Buffer_obj > result = new Buffer_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::String Buffer_obj::toString( ){
	HX_STACK_FRAME("h3d.impl.Buffer","toString",0x51177f81,"h3d.impl.Buffer.toString","h3d/impl/Buffer.hx",33,0x06b1a3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(33)
	return (((((((HX_CSTRING("id:") + this->id) + HX_CSTRING(" pos:")) + this->pos) + HX_CSTRING(" nvert:")) + this->nvert) + HX_CSTRING(" ")) + ((  (((this->next == null()))) ? ::String(HX_CSTRING("")) : ::String((HX_CSTRING("next:") + this->next->id)) )));
}


HX_DEFINE_DYNAMIC_FUNC0(Buffer_obj,toString,return )

bool Buffer_obj::isDisposed( ){
	HX_STACK_FRAME("h3d.impl.Buffer","isDisposed",0xb9a4eb04,"h3d.impl.Buffer.isDisposed","h3d/impl/Buffer.hx",37,0x06b1a3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(37)
	if ((!(((this->b == null()))))){
		HX_STACK_LINE(37)
		return this->b->isDisposed();
	}
	else{
		HX_STACK_LINE(37)
		return true;
	}
	HX_STACK_LINE(37)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(Buffer_obj,isDisposed,return )

int Buffer_obj::getDepth( ){
	HX_STACK_FRAME("h3d.impl.Buffer","getDepth",0x4fa9af62,"h3d.impl.Buffer.getDepth","h3d/impl/Buffer.hx",40,0x06b1a3c5)
	HX_STACK_THIS(this)
	HX_STACK_LINE(41)
	int _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(41)
	if (((this->next == null()))){
		HX_STACK_LINE(41)
		_g = (int)0;
	}
	else{
		HX_STACK_LINE(41)
		_g = this->next->getDepth();
	}
	HX_STACK_LINE(41)
	return ((int)1 + _g);
}


HX_DEFINE_DYNAMIC_FUNC0(Buffer_obj,getDepth,return )

Void Buffer_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.impl.Buffer","dispose",0xe82e436a,"h3d.impl.Buffer.dispose","h3d/impl/Buffer.hx",45,0x06b1a3c5)
		HX_STACK_THIS(this)
		HX_STACK_LINE(45)
		if (((this->b != null()))){
			HX_STACK_LINE(46)
			this->b->freeCursor(this->pos,this->nvert);
			HX_STACK_LINE(48)
			if (((this->allocNext != null()))){
				HX_STACK_LINE(49)
				this->allocNext->allocPrev = this->allocPrev;
			}
			HX_STACK_LINE(50)
			if (((this->allocPrev != null()))){
				HX_STACK_LINE(51)
				this->allocPrev->allocNext = this->allocNext;
			}
			HX_STACK_LINE(52)
			if (((this->b->allocHead == hx::ObjectPtr<OBJ_>(this)))){
				HX_STACK_LINE(53)
				this->b->allocHead = this->allocNext;
			}
			HX_STACK_LINE(55)
			this->b = null();
			HX_STACK_LINE(56)
			if (((this->next != null()))){
				HX_STACK_LINE(56)
				this->next->dispose();
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Buffer_obj,dispose,(void))

Void Buffer_obj::uploadVector( Array< Float > data,int dataPos,int nverts){
{
		HX_STACK_FRAME("h3d.impl.Buffer","uploadVector",0xa44622f9,"h3d.impl.Buffer.uploadVector","h3d/impl/Buffer.hx",60,0x06b1a3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(data,"data")
		HX_STACK_ARG(dataPos,"dataPos")
		HX_STACK_ARG(nverts,"nverts")
		HX_STACK_LINE(61)
		::h3d::impl::Buffer cur = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(cur,"cur");
		HX_STACK_LINE(62)
		while((true)){
			HX_STACK_LINE(62)
			if ((!(((nverts > (int)0))))){
				HX_STACK_LINE(62)
				break;
			}
			HX_STACK_LINE(63)
			if (((cur == null()))){
				HX_STACK_LINE(63)
				HX_STACK_DO_THROW(HX_CSTRING("Too many vertexes"));
			}
			HX_STACK_LINE(64)
			int count;		HX_STACK_VAR(count,"count");
			HX_STACK_LINE(64)
			if (((nverts > cur->nvert))){
				HX_STACK_LINE(64)
				count = cur->nvert;
			}
			else{
				HX_STACK_LINE(64)
				count = nverts;
			}
			HX_STACK_LINE(66)
			::hxd::Assert_obj::notNull((cur->b->vbuf != null()),null());
			HX_STACK_LINE(67)
			cur->b->mem->driver->uploadVertexBuffer(cur->b->vbuf,cur->pos,count,data,dataPos);
			HX_STACK_LINE(68)
			hx::AddEq(dataPos,(count * this->b->stride));
			HX_STACK_LINE(69)
			hx::SubEq(nverts,count);
			HX_STACK_LINE(70)
			cur = cur->next;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Buffer_obj,uploadVector,(void))

Void Buffer_obj::uploadBytes( ::haxe::io::Bytes data,int dataPos,int nverts){
{
		HX_STACK_FRAME("h3d.impl.Buffer","uploadBytes",0x2f4d4ef5,"h3d.impl.Buffer.uploadBytes","h3d/impl/Buffer.hx",74,0x06b1a3c5)
		HX_STACK_THIS(this)
		HX_STACK_ARG(data,"data")
		HX_STACK_ARG(dataPos,"dataPos")
		HX_STACK_ARG(nverts,"nverts")
		HX_STACK_LINE(75)
		::h3d::impl::Buffer cur = hx::ObjectPtr<OBJ_>(this);		HX_STACK_VAR(cur,"cur");
		HX_STACK_LINE(76)
		while((true)){
			HX_STACK_LINE(76)
			if ((!(((nverts > (int)0))))){
				HX_STACK_LINE(76)
				break;
			}
			HX_STACK_LINE(77)
			if (((cur == null()))){
				HX_STACK_LINE(77)
				HX_STACK_DO_THROW(HX_CSTRING("Too many vertexes"));
			}
			HX_STACK_LINE(78)
			int count;		HX_STACK_VAR(count,"count");
			HX_STACK_LINE(78)
			if (((nverts > cur->nvert))){
				HX_STACK_LINE(78)
				count = cur->nvert;
			}
			else{
				HX_STACK_LINE(78)
				count = nverts;
			}
			HX_STACK_LINE(79)
			cur->b->mem->driver->uploadVertexBytes(cur->b->vbuf,cur->pos,count,data,dataPos);
			HX_STACK_LINE(80)
			hx::AddEq(dataPos,((count * this->b->stride) * (int)4));
			HX_STACK_LINE(81)
			hx::SubEq(nverts,count);
			HX_STACK_LINE(82)
			cur = cur->next;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Buffer_obj,uploadBytes,(void))

int Buffer_obj::GUID;


Buffer_obj::Buffer_obj()
{
}

void Buffer_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Buffer);
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_MEMBER_NAME(nvert,"nvert");
	HX_MARK_MEMBER_NAME(next,"next");
	HX_MARK_MEMBER_NAME(allocPos,"allocPos");
	HX_MARK_MEMBER_NAME(allocNext,"allocNext");
	HX_MARK_MEMBER_NAME(allocPrev,"allocPrev");
	HX_MARK_END_CLASS();
}

void Buffer_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(b,"b");
	HX_VISIT_MEMBER_NAME(pos,"pos");
	HX_VISIT_MEMBER_NAME(nvert,"nvert");
	HX_VISIT_MEMBER_NAME(next,"next");
	HX_VISIT_MEMBER_NAME(allocPos,"allocPos");
	HX_VISIT_MEMBER_NAME(allocNext,"allocNext");
	HX_VISIT_MEMBER_NAME(allocPrev,"allocPrev");
}

Dynamic Buffer_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"GUID") ) { return GUID; }
		if (HX_FIELD_EQ(inName,"next") ) { return next; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"nvert") ) { return nvert; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"allocPos") ) { return allocPos; }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"getDepth") ) { return getDepth_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocNext") ) { return allocNext; }
		if (HX_FIELD_EQ(inName,"allocPrev") ) { return allocPrev; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"isDisposed") ) { return isDisposed_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"uploadBytes") ) { return uploadBytes_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"uploadVector") ) { return uploadVector_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Buffer_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< ::h3d::impl::BigBuffer >(); return inValue; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"GUID") ) { GUID=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"next") ) { next=inValue.Cast< ::h3d::impl::Buffer >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"nvert") ) { nvert=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"allocPos") ) { allocPos=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocNext") ) { allocNext=inValue.Cast< ::h3d::impl::Buffer >(); return inValue; }
		if (HX_FIELD_EQ(inName,"allocPrev") ) { allocPrev=inValue.Cast< ::h3d::impl::Buffer >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Buffer_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("pos"));
	outFields->push(HX_CSTRING("nvert"));
	outFields->push(HX_CSTRING("next"));
	outFields->push(HX_CSTRING("allocPos"));
	outFields->push(HX_CSTRING("allocNext"));
	outFields->push(HX_CSTRING("allocPrev"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("GUID"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Buffer_obj,id),HX_CSTRING("id")},
	{hx::fsObject /*::h3d::impl::BigBuffer*/ ,(int)offsetof(Buffer_obj,b),HX_CSTRING("b")},
	{hx::fsInt,(int)offsetof(Buffer_obj,pos),HX_CSTRING("pos")},
	{hx::fsInt,(int)offsetof(Buffer_obj,nvert),HX_CSTRING("nvert")},
	{hx::fsObject /*::h3d::impl::Buffer*/ ,(int)offsetof(Buffer_obj,next),HX_CSTRING("next")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Buffer_obj,allocPos),HX_CSTRING("allocPos")},
	{hx::fsObject /*::h3d::impl::Buffer*/ ,(int)offsetof(Buffer_obj,allocNext),HX_CSTRING("allocNext")},
	{hx::fsObject /*::h3d::impl::Buffer*/ ,(int)offsetof(Buffer_obj,allocPrev),HX_CSTRING("allocPrev")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("id"),
	HX_CSTRING("b"),
	HX_CSTRING("pos"),
	HX_CSTRING("nvert"),
	HX_CSTRING("next"),
	HX_CSTRING("allocPos"),
	HX_CSTRING("allocNext"),
	HX_CSTRING("allocPrev"),
	HX_CSTRING("toString"),
	HX_CSTRING("isDisposed"),
	HX_CSTRING("getDepth"),
	HX_CSTRING("dispose"),
	HX_CSTRING("uploadVector"),
	HX_CSTRING("uploadBytes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Buffer_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Buffer_obj::GUID,"GUID");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Buffer_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Buffer_obj::GUID,"GUID");
};

#endif

Class Buffer_obj::__mClass;

void Buffer_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.Buffer"), hx::TCanCast< Buffer_obj> ,sStaticFields,sMemberFields,
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

void Buffer_obj::__boot()
{
	GUID= (int)0;
}

} // end namespace h3d
} // end namespace impl
