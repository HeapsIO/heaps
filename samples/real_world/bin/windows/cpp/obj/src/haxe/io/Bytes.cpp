#include <hxcpp.h>

#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_Error
#include <haxe/io/Error.h>
#endif
namespace haxe{
namespace io{

Void Bytes_obj::__construct(int length,Array< unsigned char > b)
{
HX_STACK_FRAME("haxe.io.Bytes","new",0x3938d57d,"haxe.io.Bytes.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",33,0x5b953fb2)
HX_STACK_THIS(this)
HX_STACK_ARG(length,"length")
HX_STACK_ARG(b,"b")
{
	HX_STACK_LINE(34)
	this->length = length;
	HX_STACK_LINE(35)
	this->b = b;
}
;
	return null();
}

//Bytes_obj::~Bytes_obj() { }

Dynamic Bytes_obj::__CreateEmpty() { return  new Bytes_obj; }
hx::ObjectPtr< Bytes_obj > Bytes_obj::__new(int length,Array< unsigned char > b)
{  hx::ObjectPtr< Bytes_obj > result = new Bytes_obj();
	result->__construct(length,b);
	return result;}

Dynamic Bytes_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Bytes_obj > result = new Bytes_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

int Bytes_obj::get( int pos){
	HX_STACK_FRAME("haxe.io.Bytes","get",0x393385b3,"haxe.io.Bytes.get","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",49,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(49)
	return this->b->__get(pos);
}


HX_DEFINE_DYNAMIC_FUNC1(Bytes_obj,get,return )

Void Bytes_obj::set( int pos,int v){
{
		HX_STACK_FRAME("haxe.io.Bytes","set",0x393ca0bf,"haxe.io.Bytes.set","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",65,0x5b953fb2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(65)
		this->b[pos] = v;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Bytes_obj,set,(void))

Void Bytes_obj::blit( int pos,::haxe::io::Bytes src,int srcpos,int len){
{
		HX_STACK_FRAME("haxe.io.Bytes","blit",0xd098ac78,"haxe.io.Bytes.blit","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",75,0x5b953fb2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(src,"src")
		HX_STACK_ARG(srcpos,"srcpos")
		HX_STACK_ARG(len,"len")
		HX_STACK_LINE(77)
		if (((bool((bool((bool((bool((pos < (int)0)) || bool((srcpos < (int)0)))) || bool((len < (int)0)))) || bool(((pos + len) > this->length)))) || bool(((srcpos + len) > src->length))))){
			HX_STACK_LINE(77)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
		}
		HX_STACK_LINE(91)
		this->b->blit(pos,src->b,srcpos,len);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Bytes_obj,blit,(void))

Void Bytes_obj::fill( int pos,int len,int value){
{
		HX_STACK_FRAME("haxe.io.Bytes","fill",0xd33b42c6,"haxe.io.Bytes.fill","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",120,0x5b953fb2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(len,"len")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(120)
		::__hxcpp_memory_memset(this->b,pos,len,value);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Bytes_obj,fill,(void))

::haxe::io::Bytes Bytes_obj::sub( int pos,int len){
	HX_STACK_FRAME("haxe.io.Bytes","sub",0x393cae9d,"haxe.io.Bytes.sub","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",127,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(129)
	if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > this->length))))){
		HX_STACK_LINE(129)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(149)
	Array< unsigned char > _g = this->b->slice(pos,(pos + len));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(149)
	return ::haxe::io::Bytes_obj::__new(len,_g);
}


HX_DEFINE_DYNAMIC_FUNC2(Bytes_obj,sub,return )

int Bytes_obj::compare( ::haxe::io::Bytes other){
	HX_STACK_FRAME("haxe.io.Bytes","compare",0x46537042,"haxe.io.Bytes.compare","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",187,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(other,"other")
	HX_STACK_LINE(187)
	return this->b->memcmp(other->b);
}


HX_DEFINE_DYNAMIC_FUNC1(Bytes_obj,compare,return )

Float Bytes_obj::getDouble( int pos){
	HX_STACK_FRAME("haxe.io.Bytes","getDouble",0xc306ed24,"haxe.io.Bytes.getDouble","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",203,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(210)
	if (((bool((pos < (int)0)) || bool(((pos + (int)8) > this->length))))){
		HX_STACK_LINE(210)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(211)
	return ::__hxcpp_memory_get_double(this->b,pos);
}


HX_DEFINE_DYNAMIC_FUNC1(Bytes_obj,getDouble,return )

Float Bytes_obj::getFloat( int pos){
	HX_STACK_FRAME("haxe.io.Bytes","getFloat",0x2c9026e9,"haxe.io.Bytes.getFloat","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",218,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(225)
	if (((bool((pos < (int)0)) || bool(((pos + (int)4) > this->length))))){
		HX_STACK_LINE(225)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(226)
	return ::__hxcpp_memory_get_float(this->b,pos);
}


HX_DEFINE_DYNAMIC_FUNC1(Bytes_obj,getFloat,return )

Void Bytes_obj::setDouble( int pos,Float v){
{
		HX_STACK_FRAME("haxe.io.Bytes","setDouble",0xa657d930,"haxe.io.Bytes.setDouble","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",233,0x5b953fb2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(240)
		if (((bool((pos < (int)0)) || bool(((pos + (int)8) > this->length))))){
			HX_STACK_LINE(240)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
		}
		HX_STACK_LINE(241)
		::__hxcpp_memory_set_double(this->b,pos,v);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Bytes_obj,setDouble,(void))

Void Bytes_obj::setFloat( int pos,Float v){
{
		HX_STACK_FRAME("haxe.io.Bytes","setFloat",0xdaed805d,"haxe.io.Bytes.setFloat","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",247,0x5b953fb2)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(254)
		if (((bool((pos < (int)0)) || bool(((pos + (int)4) > this->length))))){
			HX_STACK_LINE(254)
			HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
		}
		HX_STACK_LINE(255)
		::__hxcpp_memory_set_float(this->b,pos,v);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Bytes_obj,setFloat,(void))

::String Bytes_obj::getString( int pos,int len){
	HX_STACK_FRAME("haxe.io.Bytes","getString",0xa16beae4,"haxe.io.Bytes.getString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",261,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(263)
	if (((bool((bool((pos < (int)0)) || bool((len < (int)0)))) || bool(((pos + len) > this->length))))){
		HX_STACK_LINE(263)
		HX_STACK_DO_THROW(::haxe::io::Error_obj::OutsideBounds);
	}
	HX_STACK_LINE(273)
	::String result = HX_CSTRING("");		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(274)
	::__hxcpp_string_of_bytes(this->b,result,pos,len);
	HX_STACK_LINE(275)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC2(Bytes_obj,getString,return )

::String Bytes_obj::readString( int pos,int len){
	HX_STACK_FRAME("haxe.io.Bytes","readString",0x5f58954a,"haxe.io.Bytes.readString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",315,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(len,"len")
	HX_STACK_LINE(315)
	return this->getString(pos,len);
}


HX_DEFINE_DYNAMIC_FUNC2(Bytes_obj,readString,return )

::String Bytes_obj::toString( ){
	HX_STACK_FRAME("haxe.io.Bytes","toString",0x0291226f,"haxe.io.Bytes.toString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",335,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(335)
	return this->getString((int)0,this->length);
}


HX_DEFINE_DYNAMIC_FUNC0(Bytes_obj,toString,return )

::String Bytes_obj::toHex( ){
	HX_STACK_FRAME("haxe.io.Bytes","toHex",0x14173a7d,"haxe.io.Bytes.toHex","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",339,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(340)
	::StringBuf s = ::StringBuf_obj::__new();		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(341)
	Array< ::Dynamic > chars = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(chars,"chars");
	HX_STACK_LINE(342)
	::String str = HX_CSTRING("0123456789abcdef");		HX_STACK_VAR(str,"str");
	HX_STACK_LINE(343)
	{
		HX_STACK_LINE(343)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(343)
		int _g = str.length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(343)
		while((true)){
			HX_STACK_LINE(343)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(343)
				break;
			}
			HX_STACK_LINE(343)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(344)
			Dynamic _g2 = str.charCodeAt(i);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(344)
			chars->push(_g2);
		}
	}
	HX_STACK_LINE(345)
	{
		HX_STACK_LINE(345)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(345)
		int _g = this->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(345)
		while((true)){
			HX_STACK_LINE(345)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(345)
				break;
			}
			HX_STACK_LINE(345)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(346)
			int c = this->b->__get(i);		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(347)
			{
				HX_STACK_LINE(347)
				int c1 = chars->__get((int(c) >> int((int)4)));		HX_STACK_VAR(c1,"c1");
				HX_STACK_LINE(347)
				::String _g11 = ::String::fromCharCode(c1);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(347)
				s->b->push(_g11);
			}
			HX_STACK_LINE(348)
			{
				HX_STACK_LINE(348)
				int c1 = chars->__get((int(c) & int((int)15)));		HX_STACK_VAR(c1,"c1");
				HX_STACK_LINE(348)
				::String _g2 = ::String::fromCharCode(c1);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(348)
				s->b->push(_g2);
			}
		}
	}
	HX_STACK_LINE(350)
	return s->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC0(Bytes_obj,toHex,return )

Array< unsigned char > Bytes_obj::getData( ){
	HX_STACK_FRAME("haxe.io.Bytes","getData",0xd7d05d7d,"haxe.io.Bytes.getData","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",354,0x5b953fb2)
	HX_STACK_THIS(this)
	HX_STACK_LINE(354)
	return this->b;
}


HX_DEFINE_DYNAMIC_FUNC0(Bytes_obj,getData,return )

::haxe::io::Bytes Bytes_obj::alloc( int length){
	HX_STACK_FRAME("haxe.io.Bytes","alloc",0x2199ead2,"haxe.io.Bytes.alloc","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",357,0x5b953fb2)
	HX_STACK_ARG(length,"length")
	HX_STACK_LINE(367)
	Array< unsigned char > a = Array_obj< unsigned char >::__new();		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(368)
	if (((length > (int)0))){
		HX_STACK_LINE(368)
		a[(length - (int)1)] = (int)0;
	}
	HX_STACK_LINE(369)
	return ::haxe::io::Bytes_obj::__new(length,a);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Bytes_obj,alloc,return )

::haxe::io::Bytes Bytes_obj::ofString( ::String s){
	HX_STACK_FRAME("haxe.io.Bytes","ofString",0x6e53bb0b,"haxe.io.Bytes.ofString","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",382,0x5b953fb2)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(393)
	Array< unsigned char > a = Array_obj< unsigned char >::__new();		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(394)
	::__hxcpp_bytes_of_string(a,s);
	HX_STACK_LINE(395)
	return ::haxe::io::Bytes_obj::__new(a->length,a);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Bytes_obj,ofString,return )

::haxe::io::Bytes Bytes_obj::ofData( Array< unsigned char > b){
	HX_STACK_FRAME("haxe.io.Bytes","ofData",0x4f3005e4,"haxe.io.Bytes.ofData","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",445,0x5b953fb2)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(445)
	return ::haxe::io::Bytes_obj::__new(b->length,b);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Bytes_obj,ofData,return )

int Bytes_obj::fastGet( Array< unsigned char > b,int pos){
	HX_STACK_FRAME("haxe.io.Bytes","fastGet",0xa10d56f7,"haxe.io.Bytes.fastGet","D:\\Workspace\\motionTools\\haxe3\\std/haxe/io/Bytes.hx",461,0x5b953fb2)
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_LINE(461)
	return b->__unsafe_get(pos);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Bytes_obj,fastGet,return )


Bytes_obj::Bytes_obj()
{
}

void Bytes_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Bytes);
	HX_MARK_MEMBER_NAME(length,"length");
	HX_MARK_MEMBER_NAME(b,"b");
	HX_MARK_END_CLASS();
}

void Bytes_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(length,"length");
	HX_VISIT_MEMBER_NAME(b,"b");
}

Dynamic Bytes_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { return b; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		if (HX_FIELD_EQ(inName,"sub") ) { return sub_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"blit") ) { return blit_dyn(); }
		if (HX_FIELD_EQ(inName,"fill") ) { return fill_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		if (HX_FIELD_EQ(inName,"toHex") ) { return toHex_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"ofData") ) { return ofData_dyn(); }
		if (HX_FIELD_EQ(inName,"length") ) { return length; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"fastGet") ) { return fastGet_dyn(); }
		if (HX_FIELD_EQ(inName,"compare") ) { return compare_dyn(); }
		if (HX_FIELD_EQ(inName,"getData") ) { return getData_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"ofString") ) { return ofString_dyn(); }
		if (HX_FIELD_EQ(inName,"getFloat") ) { return getFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"setFloat") ) { return setFloat_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getDouble") ) { return getDouble_dyn(); }
		if (HX_FIELD_EQ(inName,"setDouble") ) { return setDouble_dyn(); }
		if (HX_FIELD_EQ(inName,"getString") ) { return getString_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"readString") ) { return readString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Bytes_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"b") ) { b=inValue.Cast< Array< unsigned char > >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Bytes_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("length"));
	outFields->push(HX_CSTRING("b"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("alloc"),
	HX_CSTRING("ofString"),
	HX_CSTRING("ofData"),
	HX_CSTRING("fastGet"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Bytes_obj,length),HX_CSTRING("length")},
	{hx::fsObject /*Array< unsigned char >*/ ,(int)offsetof(Bytes_obj,b),HX_CSTRING("b")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("length"),
	HX_CSTRING("b"),
	HX_CSTRING("get"),
	HX_CSTRING("set"),
	HX_CSTRING("blit"),
	HX_CSTRING("fill"),
	HX_CSTRING("sub"),
	HX_CSTRING("compare"),
	HX_CSTRING("getDouble"),
	HX_CSTRING("getFloat"),
	HX_CSTRING("setDouble"),
	HX_CSTRING("setFloat"),
	HX_CSTRING("getString"),
	HX_CSTRING("readString"),
	HX_CSTRING("toString"),
	HX_CSTRING("toHex"),
	HX_CSTRING("getData"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Bytes_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Bytes_obj::__mClass,"__mClass");
};

#endif

Class Bytes_obj::__mClass;

void Bytes_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.io.Bytes"), hx::TCanCast< Bytes_obj> ,sStaticFields,sMemberFields,
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

void Bytes_obj::__boot()
{
}

} // end namespace haxe
} // end namespace io
