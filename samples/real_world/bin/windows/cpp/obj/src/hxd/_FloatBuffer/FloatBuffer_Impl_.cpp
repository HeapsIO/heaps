#include <hxcpp.h>

#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_hxd__FloatBuffer_FloatBuffer_Impl_
#include <hxd/_FloatBuffer/FloatBuffer_Impl_.h>
#endif
#ifndef INCLUDED_hxd__FloatBuffer_InnerIterator
#include <hxd/_FloatBuffer/InnerIterator.h>
#endif
namespace hxd{
namespace _FloatBuffer{

Void FloatBuffer_Impl__obj::__construct()
{
	return null();
}

//FloatBuffer_Impl__obj::~FloatBuffer_Impl__obj() { }

Dynamic FloatBuffer_Impl__obj::__CreateEmpty() { return  new FloatBuffer_Impl__obj; }
hx::ObjectPtr< FloatBuffer_Impl__obj > FloatBuffer_Impl__obj::__new()
{  hx::ObjectPtr< FloatBuffer_Impl__obj > result = new FloatBuffer_Impl__obj();
	result->__construct();
	return result;}

Dynamic FloatBuffer_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FloatBuffer_Impl__obj > result = new FloatBuffer_Impl__obj();
	result->__construct();
	return result;}

Array< Float > FloatBuffer_Impl__obj::_new( hx::Null< int >  __o_length){
int length = __o_length.Default(0);
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","_new",0xd999c86a,"hxd._FloatBuffer.FloatBuffer_Impl_._new","hxd/FloatBuffer.hx",30,0x77baa03d)
	HX_STACK_ARG(length,"length")
{
		HX_STACK_LINE(30)
		return Array_obj< Float >::__new();
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,_new,return )

Void FloatBuffer_Impl__obj::push( Array< Float > this1,Float v){
{
		HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","push",0xe4dbc4e3,"hxd._FloatBuffer.FloatBuffer_Impl_.push","hxd/FloatBuffer.hx",40,0x77baa03d)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(40)
		this1->push(v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(FloatBuffer_Impl__obj,push,(void))

Array< Float > FloatBuffer_Impl__obj::fromArray( Array< Float > arr){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","fromArray",0x802b0426,"hxd._FloatBuffer.FloatBuffer_Impl_.fromArray","hxd/FloatBuffer.hx",48,0x77baa03d)
	HX_STACK_ARG(arr,"arr")
	HX_STACK_LINE(49)
	Array< Float > f = Array_obj< Float >::__new();		HX_STACK_VAR(f,"f");
	HX_STACK_LINE(50)
	{
		HX_STACK_LINE(50)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(50)
		int _g = arr->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(50)
		while((true)){
			HX_STACK_LINE(50)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(50)
				break;
			}
			HX_STACK_LINE(50)
			int v = (_g1)++;		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(51)
			if (((f->length <= v))){
				HX_STACK_LINE(51)
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + v));
			}
			HX_STACK_LINE(51)
			f[v] = arr->__get(v);
		}
	}
	HX_STACK_LINE(52)
	return f;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,fromArray,return )

Array< Float > FloatBuffer_Impl__obj::makeView( Array< Float > arr){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","makeView",0x8cd892fc,"hxd._FloatBuffer.FloatBuffer_Impl_.makeView","hxd/FloatBuffer.hx",62,0x77baa03d)
	HX_STACK_ARG(arr,"arr")
	HX_STACK_LINE(62)
	return arr;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,makeView,return )

Void FloatBuffer_Impl__obj::grow( Array< Float > this1,int v){
{
		HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","grow",0xdee68f1c,"hxd._FloatBuffer.FloatBuffer_Impl_.grow","hxd/FloatBuffer.hx",70,0x77baa03d)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(70)
		while((true)){
			HX_STACK_LINE(70)
			if ((!(((this1->length < v))))){
				HX_STACK_LINE(70)
				break;
			}
			HX_STACK_LINE(70)
			this1->push(0.);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(FloatBuffer_Impl__obj,grow,(void))

Void FloatBuffer_Impl__obj::resize( Array< Float > this1,int v){
{
		HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","resize",0x3d4fa13d,"hxd._FloatBuffer.FloatBuffer_Impl_.resize","hxd/FloatBuffer.hx",78,0x77baa03d)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(78)
		if (((this1->length < v))){
			HX_STACK_LINE(79)
			::haxe::Log_obj::trace((HX_CSTRING("regrowing to ") + v),hx::SourceInfo(HX_CSTRING("FloatBuffer.hx"),79,HX_CSTRING("hxd._FloatBuffer.FloatBuffer_Impl_"),HX_CSTRING("resize")));
			HX_STACK_LINE(80)
			this1[v] = 0.0;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(FloatBuffer_Impl__obj,resize,(void))

Float FloatBuffer_Impl__obj::arrayRead( Array< Float > this1,int key){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","arrayRead",0x3b2bd1e6,"hxd._FloatBuffer.FloatBuffer_Impl_.arrayRead","hxd/FloatBuffer.hx",87,0x77baa03d)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(key,"key")
	HX_STACK_LINE(87)
	return this1->__get(key);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(FloatBuffer_Impl__obj,arrayRead,return )

Float FloatBuffer_Impl__obj::arrayWrite( Array< Float > this1,int key,Float value){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","arrayWrite",0x74caa44f,"hxd._FloatBuffer.FloatBuffer_Impl_.arrayWrite","hxd/FloatBuffer.hx",90,0x77baa03d)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(key,"key")
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(92)
	if (((this1->length <= key))){
		HX_STACK_LINE(93)
		HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
	}
	HX_STACK_LINE(96)
	return this1[key] = value;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(FloatBuffer_Impl__obj,arrayWrite,return )

Array< Float > FloatBuffer_Impl__obj::getNative( Array< Float > this1){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","getNative",0x4485ff24,"hxd._FloatBuffer.FloatBuffer_Impl_.getNative","hxd/FloatBuffer.hx",100,0x77baa03d)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(100)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,getNative,return )

::hxd::_FloatBuffer::InnerIterator FloatBuffer_Impl__obj::iterator( Array< Float > this1){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","iterator",0xdb85b577,"hxd._FloatBuffer.FloatBuffer_Impl_.iterator","hxd/FloatBuffer.hx",104,0x77baa03d)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(104)
	return ::hxd::_FloatBuffer::InnerIterator_obj::__new(this1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,iterator,return )

int FloatBuffer_Impl__obj::get_length( Array< Float > this1){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","get_length",0x39d32478,"hxd._FloatBuffer.FloatBuffer_Impl_.get_length","hxd/FloatBuffer.hx",108,0x77baa03d)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(108)
	return this1->length;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,get_length,return )

Void FloatBuffer_Impl__obj::blit( Array< Float > this1,Array< Float > src,int count){
{
		HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","blit",0xdb93eb3e,"hxd._FloatBuffer.FloatBuffer_Impl_.blit","hxd/FloatBuffer.hx",112,0x77baa03d)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_ARG(src,"src")
		HX_STACK_ARG(count,"count")
		HX_STACK_LINE(112)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(112)
		while((true)){
			HX_STACK_LINE(112)
			if ((!(((_g < count))))){
				HX_STACK_LINE(112)
				break;
			}
			HX_STACK_LINE(112)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(112)
			if (((this1->length <= i))){
				HX_STACK_LINE(112)
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
			}
			HX_STACK_LINE(112)
			this1[i] = src->__get(i);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(FloatBuffer_Impl__obj,blit,(void))

Void FloatBuffer_Impl__obj::zero( Array< Float > this1){
{
		HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","zero",0xeb6bc231,"hxd._FloatBuffer.FloatBuffer_Impl_.zero","hxd/FloatBuffer.hx",116,0x77baa03d)
		HX_STACK_ARG(this1,"this1")
		HX_STACK_LINE(116)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(116)
		int _g = this1->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(116)
		while((true)){
			HX_STACK_LINE(116)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(116)
				break;
			}
			HX_STACK_LINE(116)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(116)
			if (((this1->length <= i))){
				HX_STACK_LINE(116)
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
			}
			HX_STACK_LINE(116)
			this1[i] = (int)0;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,zero,(void))

Array< Float > FloatBuffer_Impl__obj::clone( Array< Float > this1){
	HX_STACK_FRAME("hxd._FloatBuffer.FloatBuffer_Impl_","clone",0xd9450834,"hxd._FloatBuffer.FloatBuffer_Impl_.clone","hxd/FloatBuffer.hx",119,0x77baa03d)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(120)
	Array< Float > v = Array_obj< Float >::__new();		HX_STACK_VAR(v,"v");
	HX_STACK_LINE(121)
	{
		HX_STACK_LINE(121)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(121)
		int _g = this1->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(121)
		while((true)){
			HX_STACK_LINE(121)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(121)
				break;
			}
			HX_STACK_LINE(121)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(121)
			if (((v->length <= i))){
				HX_STACK_LINE(121)
				HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
			}
			HX_STACK_LINE(121)
			v[i] = this1->__get(i);
		}
	}
	HX_STACK_LINE(122)
	return v;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FloatBuffer_Impl__obj,clone,return )


FloatBuffer_Impl__obj::FloatBuffer_Impl__obj()
{
}

Dynamic FloatBuffer_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		if (HX_FIELD_EQ(inName,"push") ) { return push_dyn(); }
		if (HX_FIELD_EQ(inName,"grow") ) { return grow_dyn(); }
		if (HX_FIELD_EQ(inName,"blit") ) { return blit_dyn(); }
		if (HX_FIELD_EQ(inName,"zero") ) { return zero_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"resize") ) { return resize_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"makeView") ) { return makeView_dyn(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"fromArray") ) { return fromArray_dyn(); }
		if (HX_FIELD_EQ(inName,"arrayRead") ) { return arrayRead_dyn(); }
		if (HX_FIELD_EQ(inName,"getNative") ) { return getNative_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"arrayWrite") ) { return arrayWrite_dyn(); }
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FloatBuffer_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void FloatBuffer_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("push"),
	HX_CSTRING("fromArray"),
	HX_CSTRING("makeView"),
	HX_CSTRING("grow"),
	HX_CSTRING("resize"),
	HX_CSTRING("arrayRead"),
	HX_CSTRING("arrayWrite"),
	HX_CSTRING("getNative"),
	HX_CSTRING("iterator"),
	HX_CSTRING("get_length"),
	HX_CSTRING("blit"),
	HX_CSTRING("zero"),
	HX_CSTRING("clone"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FloatBuffer_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FloatBuffer_Impl__obj::__mClass,"__mClass");
};

#endif

Class FloatBuffer_Impl__obj::__mClass;

void FloatBuffer_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd._FloatBuffer.FloatBuffer_Impl_"), hx::TCanCast< FloatBuffer_Impl__obj> ,sStaticFields,sMemberFields,
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

void FloatBuffer_Impl__obj::__boot()
{
}

} // end namespace hxd
} // end namespace _FloatBuffer
