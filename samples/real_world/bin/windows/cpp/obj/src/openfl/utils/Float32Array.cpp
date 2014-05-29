#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix3D
#include <flash/geom/Matrix3D.h>
#endif
#ifndef INCLUDED_openfl_utils_ArrayBufferView
#include <openfl/utils/ArrayBufferView.h>
#endif
#ifndef INCLUDED_openfl_utils_Float32Array
#include <openfl/utils/Float32Array.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace openfl{
namespace utils{

Void Float32Array_obj::__construct(Dynamic bufferOrArray,hx::Null< int >  __o_start,Dynamic length)
{
HX_STACK_FRAME("openfl.utils.Float32Array","new",0xf911a66b,"openfl.utils.Float32Array.new","openfl/utils/Float32Array.hx",16,0x43b6c2e3)
HX_STACK_THIS(this)
HX_STACK_ARG(bufferOrArray,"bufferOrArray")
HX_STACK_ARG(__o_start,"start")
HX_STACK_ARG(length,"length")
int start = __o_start.Default(0);
{
	HX_STACK_LINE(18)
	this->BYTES_PER_ELEMENT = (int)4;
	HX_STACK_LINE(20)
	if ((::Std_obj::is(bufferOrArray,hx::ClassOf< ::Int >()))){
		HX_STACK_LINE(22)
		int _g = ::Std_obj::_int(bufferOrArray);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(22)
		int _g1 = (_g * this->BYTES_PER_ELEMENT);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(22)
		super::__construct(_g1,null(),null());
		HX_STACK_LINE(23)
		int _g2 = ::Std_obj::_int(bufferOrArray);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(23)
		this->length = _g2;
	}
	else{
		HX_STACK_LINE(25)
		if ((::Std_obj::is(bufferOrArray,hx::ClassOf< Array<int> >()))){
			HX_STACK_LINE(27)
			Array< Float > floats = bufferOrArray;		HX_STACK_VAR(floats,"floats");
			HX_STACK_LINE(29)
			if (((length != null()))){
				HX_STACK_LINE(31)
				this->length = length;
			}
			else{
				HX_STACK_LINE(35)
				this->length = (floats->length - start);
			}
			HX_STACK_LINE(39)
			super::__construct((int(this->length) << int((int)2)),null(),null());
			HX_STACK_LINE(45)
			{
				HX_STACK_LINE(45)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(45)
				int _g = this->length;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(45)
				while((true)){
					HX_STACK_LINE(45)
					if ((!(((_g1 < _g))))){
						HX_STACK_LINE(45)
						break;
					}
					HX_STACK_LINE(45)
					int i = (_g1)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(48)
					::__hxcpp_memory_set_float(this->bytes,(int(i) << int((int)2)),floats->__get(i));
				}
			}
		}
		else{
			HX_STACK_LINE(57)
			super::__construct(bufferOrArray,start,length);
			HX_STACK_LINE(59)
			if (((((int(this->byteLength) & int((int)3))) > (int)0))){
				HX_STACK_LINE(61)
				HX_STACK_DO_THROW(HX_CSTRING("Invalid array size"));
			}
			HX_STACK_LINE(65)
			this->length = (int(this->byteLength) >> int((int)2));
			HX_STACK_LINE(67)
			if ((((int(this->length) << int((int)2)) != this->byteLength))){
				HX_STACK_LINE(69)
				HX_STACK_DO_THROW(HX_CSTRING("Invalid length multiple"));
			}
		}
	}
}
;
	return null();
}

//Float32Array_obj::~Float32Array_obj() { }

Dynamic Float32Array_obj::__CreateEmpty() { return  new Float32Array_obj; }
hx::ObjectPtr< Float32Array_obj > Float32Array_obj::__new(Dynamic bufferOrArray,hx::Null< int >  __o_start,Dynamic length)
{  hx::ObjectPtr< Float32Array_obj > result = new Float32Array_obj();
	result->__construct(bufferOrArray,__o_start,length);
	return result;}

Dynamic Float32Array_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Float32Array_obj > result = new Float32Array_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Float Float32Array_obj::__get( int index){
	HX_STACK_FRAME("openfl.utils.Float32Array","__get",0xf6929041,"openfl.utils.Float32Array.__get","openfl/utils/Float32Array.hx",85,0x43b6c2e3)
	HX_STACK_THIS(this)
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(85)
	return ::__hxcpp_memory_get_float(this->bytes,(((int(index) << int((int)2))) + this->byteOffset));
}


HX_DEFINE_DYNAMIC_FUNC1(Float32Array_obj,__get,return )

Void Float32Array_obj::__set( int index,Float value){
{
		HX_STACK_FRAME("openfl.utils.Float32Array","__set",0xf69bab4d,"openfl.utils.Float32Array.__set","openfl/utils/Float32Array.hx",86,0x43b6c2e3)
		HX_STACK_THIS(this)
		HX_STACK_ARG(index,"index")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(86)
		::__hxcpp_memory_set_float(this->bytes,(((int(index) << int((int)2))) + this->byteOffset),value);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Float32Array_obj,__set,(void))

int Float32Array_obj::SBYTES_PER_ELEMENT;

::openfl::utils::Float32Array Float32Array_obj::fromMatrix( ::flash::geom::Matrix3D matrix){
	HX_STACK_FRAME("openfl.utils.Float32Array","fromMatrix",0xe8800ca0,"openfl.utils.Float32Array.fromMatrix","openfl/utils/Float32Array.hx",80,0x43b6c2e3)
	HX_STACK_ARG(matrix,"matrix")
	HX_STACK_LINE(80)
	return ::openfl::utils::Float32Array_obj::__new(matrix->rawData,null(),null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Float32Array_obj,fromMatrix,return )


Float32Array_obj::Float32Array_obj()
{
}

Dynamic Float32Array_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"__get") ) { return __get_dyn(); }
		if (HX_FIELD_EQ(inName,"__set") ) { return __set_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return length; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"fromMatrix") ) { return fromMatrix_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"BYTES_PER_ELEMENT") ) { return BYTES_PER_ELEMENT; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Float32Array_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< int >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"BYTES_PER_ELEMENT") ) { BYTES_PER_ELEMENT=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Float32Array_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("BYTES_PER_ELEMENT"));
	outFields->push(HX_CSTRING("length"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("SBYTES_PER_ELEMENT"),
	HX_CSTRING("fromMatrix"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Float32Array_obj,BYTES_PER_ELEMENT),HX_CSTRING("BYTES_PER_ELEMENT")},
	{hx::fsInt,(int)offsetof(Float32Array_obj,length),HX_CSTRING("length")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("BYTES_PER_ELEMENT"),
	HX_CSTRING("length"),
	HX_CSTRING("__get"),
	HX_CSTRING("__set"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Float32Array_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Float32Array_obj::SBYTES_PER_ELEMENT,"SBYTES_PER_ELEMENT");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Float32Array_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Float32Array_obj::SBYTES_PER_ELEMENT,"SBYTES_PER_ELEMENT");
};

#endif

Class Float32Array_obj::__mClass;

void Float32Array_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.utils.Float32Array"), hx::TCanCast< Float32Array_obj> ,sStaticFields,sMemberFields,
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

void Float32Array_obj::__boot()
{
	SBYTES_PER_ELEMENT= (int)4;
}

} // end namespace openfl
} // end namespace utils
