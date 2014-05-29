#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif

Void StringBuf_obj::__construct()
{
HX_STACK_FRAME("StringBuf","new",0xaaa8f4b4,"StringBuf.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/StringBuf.hx",29,0x7dda77bc)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(30)
	Array< ::String > _g = Array_obj< ::String >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(30)
	this->b = _g;
}
;
	return null();
}

//StringBuf_obj::~StringBuf_obj() { }

Dynamic StringBuf_obj::__CreateEmpty() { return  new StringBuf_obj; }
hx::ObjectPtr< StringBuf_obj > StringBuf_obj::__new()
{  hx::ObjectPtr< StringBuf_obj > result = new StringBuf_obj();
	result->__construct();
	return result;}

Dynamic StringBuf_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< StringBuf_obj > result = new StringBuf_obj();
	result->__construct();
	return result;}

int StringBuf_obj::get_length( ){
	HX_STACK_FRAME("StringBuf","get_length",0xe673d2db,"StringBuf.get_length","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/StringBuf.hx",33,0x7dda77bc)
	HX_STACK_THIS(this)
	HX_STACK_LINE(34)
	int len = (int)0;		HX_STACK_VAR(len,"len");
	HX_STACK_LINE(35)
	{
		HX_STACK_LINE(35)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(35)
		Array< ::String > _g1 = this->b;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(35)
		while((true)){
			HX_STACK_LINE(35)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(35)
				break;
			}
			HX_STACK_LINE(35)
			::String s = _g1->__get(_g);		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(35)
			++(_g);
			HX_STACK_LINE(36)
			if (((s == null()))){
				HX_STACK_LINE(36)
				hx::AddEq(len,(int)4);
			}
			else{
				HX_STACK_LINE(36)
				hx::AddEq(len,s.length);
			}
		}
	}
	HX_STACK_LINE(37)
	return len;
}


HX_DEFINE_DYNAMIC_FUNC0(StringBuf_obj,get_length,return )

Void StringBuf_obj::add( Dynamic x){
{
		HX_STACK_FRAME("StringBuf","add",0xaa9f1675,"StringBuf.add","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/StringBuf.hx",40,0x7dda77bc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(41)
		::String _g = ::Std_obj::string(x);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(41)
		this->b->push(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(StringBuf_obj,add,(void))

Void StringBuf_obj::addSub( ::String s,int pos,Dynamic len){
{
		HX_STACK_FRAME("StringBuf","addSub",0x5b08020b,"StringBuf.addSub","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/StringBuf.hx",44,0x7dda77bc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(45)
		::String _g = s.substr(pos,len);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(45)
		this->b->push(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(StringBuf_obj,addSub,(void))

Void StringBuf_obj::addChar( int c){
{
		HX_STACK_FRAME("StringBuf","addChar",0x415c7feb,"StringBuf.addChar","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/StringBuf.hx",48,0x7dda77bc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(c,"c")
		HX_STACK_LINE(49)
		::String _g = ::String::fromCharCode(c);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(49)
		this->b->push(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(StringBuf_obj,addChar,(void))

::String StringBuf_obj::toString( ){
	HX_STACK_FRAME("StringBuf","toString",0x68f17bd8,"StringBuf.toString","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/StringBuf.hx",53,0x7dda77bc)
	HX_STACK_THIS(this)
	HX_STACK_LINE(53)
	return this->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC0(StringBuf_obj,toString,return )


StringBuf_obj::StringBuf_obj()
{
}

void StringBuf_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(StringBuf);
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_END_CLASS();
}

void StringBuf_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(b,"b");
}

Dynamic StringBuf_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return get_length(); }
		if (HX_FIELD_EQ(inName,"addSub") ) { return addSub_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"addChar") ) { return addChar_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic StringBuf_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< Array< ::String > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void StringBuf_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("b"));
	outFields->push(HX_CSTRING("length"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< ::String >*/ ,(int)offsetof(StringBuf_obj,b),HX_CSTRING("b")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("b"),
	HX_CSTRING("get_length"),
	HX_CSTRING("add"),
	HX_CSTRING("addSub"),
	HX_CSTRING("addChar"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(StringBuf_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(StringBuf_obj::__mClass,"__mClass");
};

#endif

Class StringBuf_obj::__mClass;

void StringBuf_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("StringBuf"), hx::TCanCast< StringBuf_obj> ,sStaticFields,sMemberFields,
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

void StringBuf_obj::__boot()
{
}

