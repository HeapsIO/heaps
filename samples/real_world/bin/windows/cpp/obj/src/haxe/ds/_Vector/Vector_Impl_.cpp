#include <hxcpp.h>

#ifndef INCLUDED_haxe_ds__Vector_Vector_Impl_
#include <haxe/ds/_Vector/Vector_Impl_.h>
#endif
namespace haxe{
namespace ds{
namespace _Vector{

Void Vector_Impl__obj::__construct()
{
	return null();
}

//Vector_Impl__obj::~Vector_Impl__obj() { }

Dynamic Vector_Impl__obj::__CreateEmpty() { return  new Vector_Impl__obj; }
hx::ObjectPtr< Vector_Impl__obj > Vector_Impl__obj::__new()
{  hx::ObjectPtr< Vector_Impl__obj > result = new Vector_Impl__obj();
	result->__construct();
	return result;}

Dynamic Vector_Impl__obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Vector_Impl__obj > result = new Vector_Impl__obj();
	result->__construct();
	return result;}

Dynamic Vector_Impl__obj::_new( int length){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","_new",0x3159a4a9,"haxe.ds._Vector.Vector_Impl_._new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",56,0xa043f565)
	HX_STACK_ARG(length,"length")
	HX_STACK_LINE(56)
	Dynamic this1;		HX_STACK_VAR(this1,"this1");
	HX_STACK_LINE(68)
	Dynamic _g = Dynamic( Array_obj<Dynamic>::__new() )->__Field(HX_CSTRING("__SetSizeExact"),true)(length);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(68)
	this1 = _g;
	HX_STACK_LINE(56)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Vector_Impl__obj,_new,return )

Dynamic Vector_Impl__obj::get( Dynamic this1,int index){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","get",0x33e7724e,"haxe.ds._Vector.Vector_Impl_.get","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",83,0xa043f565)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(83)
	return this1->__Field(HX_CSTRING("__unsafe_get"),true)(index);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Vector_Impl__obj,get,return )

Dynamic Vector_Impl__obj::set( Dynamic this1,int index,Dynamic val){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","set",0x33f08d5a,"haxe.ds._Vector.Vector_Impl_.set","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",97,0xa043f565)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_ARG(index,"index")
	HX_STACK_ARG(val,"val")
	HX_STACK_LINE(97)
	return this1->__Field(HX_CSTRING("__unsafe_set"),true)(index,val);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Vector_Impl__obj,set,return )

int Vector_Impl__obj::get_length( Dynamic this1){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","get_length",0x18a839f7,"haxe.ds._Vector.Vector_Impl_.get_length","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",116,0xa043f565)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(116)
	return this1->__Field(HX_CSTRING("length"),true);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Vector_Impl__obj,get_length,return )

Void Vector_Impl__obj::blit( Dynamic src,int srcPos,Dynamic dest,int destPos,int len){
{
		HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","blit",0x3353c77d,"haxe.ds._Vector.Vector_Impl_.blit","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",136,0xa043f565)
		HX_STACK_ARG(src,"src")
		HX_STACK_ARG(srcPos,"srcPos")
		HX_STACK_ARG(dest,"dest")
		HX_STACK_ARG(destPos,"destPos")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(136)
		dest->__Field(HX_CSTRING("blit"),true)(destPos,src,srcPos,len);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(Vector_Impl__obj,blit,(void))

Dynamic Vector_Impl__obj::toArray( Dynamic this1){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","toArray",0x5533e7d6,"haxe.ds._Vector.Vector_Impl_.toArray","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",150,0xa043f565)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(150)
	return this1->__Field(HX_CSTRING("copy"),true)();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Vector_Impl__obj,toArray,return )

Dynamic Vector_Impl__obj::toData( Dynamic this1){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","toData",0x598fb28d,"haxe.ds._Vector.Vector_Impl_.toData","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",170,0xa043f565)
	HX_STACK_ARG(this1,"this1")
	HX_STACK_LINE(170)
	return this1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Vector_Impl__obj,toData,return )

Dynamic Vector_Impl__obj::fromData( Dynamic data){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","fromData",0xf936f7fc,"haxe.ds._Vector.Vector_Impl_.fromData","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",180,0xa043f565)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(180)
	return data;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Vector_Impl__obj,fromData,return )

Dynamic Vector_Impl__obj::fromArrayCopy( Dynamic array){
	HX_STACK_FRAME("haxe.ds._Vector.Vector_Impl_","fromArrayCopy",0xa38d1adc,"haxe.ds._Vector.Vector_Impl_.fromArrayCopy","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",194,0xa043f565)
	HX_STACK_ARG(array,"array")
	HX_STACK_LINE(196)
	Dynamic vec;		HX_STACK_VAR(vec,"vec");
	struct _Function_1_1{
		inline static Dynamic Block( Dynamic &array){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/ds/Vector.hx",196,0xa043f565)
			{
				HX_STACK_LINE(196)
				Dynamic this1;		HX_STACK_VAR(this1,"this1");
				HX_STACK_LINE(196)
				Dynamic _g = Dynamic( Array_obj<Dynamic>::__new() )->__Field(HX_CSTRING("__SetSizeExact"),true)(array->__Field(HX_CSTRING("length"),true));		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(196)
				this1 = _g;
				HX_STACK_LINE(196)
				return this1;
			}
			return null();
		}
	};
	HX_STACK_LINE(196)
	vec = _Function_1_1::Block(array);
	HX_STACK_LINE(197)
	{
		HX_STACK_LINE(197)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(197)
		int _g = array->__Field(HX_CSTRING("length"),true);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(197)
		while((true)){
			HX_STACK_LINE(197)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(197)
				break;
			}
			HX_STACK_LINE(197)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(198)
			vec->__Field(HX_CSTRING("__unsafe_set"),true)(i,array->__GetItem(i));
		}
	}
	HX_STACK_LINE(199)
	return vec;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Vector_Impl__obj,fromArrayCopy,return )


Vector_Impl__obj::Vector_Impl__obj()
{
}

Dynamic Vector_Impl__obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"_new") ) { return _new_dyn(); }
		if (HX_FIELD_EQ(inName,"blit") ) { return blit_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"toData") ) { return toData_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"toArray") ) { return toArray_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fromData") ) { return fromData_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"fromArrayCopy") ) { return fromArrayCopy_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Vector_Impl__obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Vector_Impl__obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_new"),
	HX_CSTRING("get"),
	HX_CSTRING("set"),
	HX_CSTRING("get_length"),
	HX_CSTRING("blit"),
	HX_CSTRING("toArray"),
	HX_CSTRING("toData"),
	HX_CSTRING("fromData"),
	HX_CSTRING("fromArrayCopy"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Vector_Impl__obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Vector_Impl__obj::__mClass,"__mClass");
};

#endif

Class Vector_Impl__obj::__mClass;

void Vector_Impl__obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.ds._Vector.Vector_Impl_"), hx::TCanCast< Vector_Impl__obj> ,sStaticFields,sMemberFields,
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

void Vector_Impl__obj::__boot()
{
}

} // end namespace haxe
} // end namespace ds
} // end namespace _Vector
