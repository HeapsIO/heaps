#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif

Void List_obj::__construct()
{
HX_STACK_FRAME("List","new",0xed890070,"List.new","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",41,0x402da861)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(41)
	this->length = (int)0;
}
;
	return null();
}

//List_obj::~List_obj() { }

Dynamic List_obj::__CreateEmpty() { return  new List_obj; }
hx::ObjectPtr< List_obj > List_obj::__new()
{  hx::ObjectPtr< List_obj > result = new List_obj();
	result->__construct();
	return result;}

Dynamic List_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< List_obj > result = new List_obj();
	result->__construct();
	return result;}

Void List_obj::add( Dynamic item){
{
		HX_STACK_FRAME("List","add",0xed7f2231,"List.add","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",49,0x402da861)
		HX_STACK_THIS(this)
		HX_STACK_ARG(item,"item")
		HX_STACK_LINE(50)
		Dynamic x = Dynamic( Array_obj<Dynamic>::__new().Add(item));		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(51)
		if (((this->h == null()))){
			HX_STACK_LINE(52)
			this->h = x;
		}
		else{
			HX_STACK_LINE(54)
			hx::IndexRef((this->q).mPtr,(int)1) = x;
		}
		HX_STACK_LINE(55)
		this->q = x;
		HX_STACK_LINE(56)
		(this->length)++;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(List_obj,add,(void))

Void List_obj::push( Dynamic item){
{
		HX_STACK_FRAME("List","push",0xebb5efca,"List.push","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",64,0x402da861)
		HX_STACK_THIS(this)
		HX_STACK_ARG(item,"item")
		HX_STACK_LINE(68)
		Dynamic x = Dynamic( Array_obj<Dynamic>::__new().Add(item).Add(this->h));		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(70)
		this->h = x;
		HX_STACK_LINE(71)
		if (((this->q == null()))){
			HX_STACK_LINE(72)
			this->q = x;
		}
		HX_STACK_LINE(73)
		(this->length)++;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(List_obj,push,(void))

Dynamic List_obj::first( ){
	HX_STACK_FRAME("List","first",0x898acc40,"List.first","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",82,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_LINE(82)
	if (((this->h == null()))){
		HX_STACK_LINE(82)
		return null();
	}
	else{
		HX_STACK_LINE(82)
		return this->h->__GetItem((int)0);
	}
	HX_STACK_LINE(82)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(List_obj,first,return )

Dynamic List_obj::last( ){
	HX_STACK_FRAME("List","last",0xe901e846,"List.last","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",91,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_LINE(91)
	if (((this->q == null()))){
		HX_STACK_LINE(91)
		return null();
	}
	else{
		HX_STACK_LINE(91)
		return this->q->__GetItem((int)0);
	}
	HX_STACK_LINE(91)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(List_obj,last,return )

Dynamic List_obj::pop( ){
	HX_STACK_FRAME("List","pop",0xed8a8da1,"List.pop","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",100,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_LINE(101)
	if (((this->h == null()))){
		HX_STACK_LINE(102)
		return null();
	}
	HX_STACK_LINE(103)
	Dynamic x = this->h->__GetItem((int)0);		HX_STACK_VAR(x,"x");
	HX_STACK_LINE(104)
	this->h = this->h->__GetItem((int)1);
	HX_STACK_LINE(105)
	if (((this->h == null()))){
		HX_STACK_LINE(106)
		this->q = null();
	}
	HX_STACK_LINE(107)
	(this->length)--;
	HX_STACK_LINE(108)
	return x;
}


HX_DEFINE_DYNAMIC_FUNC0(List_obj,pop,return )

bool List_obj::isEmpty( ){
	HX_STACK_FRAME("List","isEmpty",0xaa565653,"List.isEmpty","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",115,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_LINE(115)
	return (this->h == null());
}


HX_DEFINE_DYNAMIC_FUNC0(List_obj,isEmpty,return )

Void List_obj::clear( ){
{
		HX_STACK_FRAME("List","clear",0xd148c59d,"List.clear","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",124,0x402da861)
		HX_STACK_THIS(this)
		HX_STACK_LINE(125)
		this->h = null();
		HX_STACK_LINE(126)
		this->q = null();
		HX_STACK_LINE(127)
		this->length = (int)0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(List_obj,clear,(void))

bool List_obj::remove( Dynamic v){
	HX_STACK_FRAME("List","remove",0x4b44d634,"List.remove","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",138,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(139)
	Dynamic prev = null();		HX_STACK_VAR(prev,"prev");
	HX_STACK_LINE(140)
	Dynamic l = this->h;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(141)
	while((true)){
		HX_STACK_LINE(141)
		if ((!(((l != null()))))){
			HX_STACK_LINE(141)
			break;
		}
		HX_STACK_LINE(142)
		if (((l->__GetItem((int)0) == v))){
			HX_STACK_LINE(143)
			if (((prev == null()))){
				HX_STACK_LINE(144)
				this->h = l->__GetItem((int)1);
			}
			else{
				HX_STACK_LINE(146)
				hx::IndexRef((prev).mPtr,(int)1) = l->__GetItem((int)1);
			}
			HX_STACK_LINE(147)
			if (((this->q == l))){
				HX_STACK_LINE(148)
				this->q = prev;
			}
			HX_STACK_LINE(149)
			(this->length)--;
			HX_STACK_LINE(150)
			return true;
		}
		HX_STACK_LINE(152)
		prev = l;
		HX_STACK_LINE(153)
		l = l->__GetItem((int)1);
	}
	HX_STACK_LINE(155)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(List_obj,remove,return )

Dynamic List_obj::iterator( ){
	HX_STACK_FRAME("List","iterator",0x2d4cdfde,"List.iterator","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",179,0x402da861)
	HX_STACK_THIS(this)
	struct _Function_1_1{
		inline static Dynamic Block( hx::ObjectPtr< ::List_obj > __this){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",179,0x402da861)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("h") , __this->h,false);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_1)
				Dynamic run(){
					HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",182,0x402da861)
					HX_STACK_THIS(__this.mPtr)
					{
						HX_STACK_LINE(182)
						return (__this->__Field(HX_CSTRING("h"),true) != null());
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("hasNext") ,  Dynamic(new _Function_2_1()),true);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_2)
				Dynamic run(){
					HX_STACK_FRAME("*","_Function_2_2",0x5201af79,"*._Function_2_2","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",185,0x402da861)
					HX_STACK_THIS(__this.mPtr)
					{
						HX_STACK_LINE(186)
						if (((__this->__Field(HX_CSTRING("h"),true) == null()))){
							HX_STACK_LINE(187)
							return null();
						}
						HX_STACK_LINE(188)
						Dynamic x = __this->__Field(HX_CSTRING("h"),true)->__GetItem((int)0);		HX_STACK_VAR(x,"x");
						HX_STACK_LINE(189)
						__this->__FieldRef(HX_CSTRING("h")) = __this->__Field(HX_CSTRING("h"),true)->__GetItem((int)1);
						HX_STACK_LINE(190)
						return x;
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("next") ,  Dynamic(new _Function_2_2()),true);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(179)
	return _Function_1_1::Block(this);
}


HX_DEFINE_DYNAMIC_FUNC0(List_obj,iterator,return )

::String List_obj::toString( ){
	HX_STACK_FRAME("List","toString",0xd221669c,"List.toString","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",203,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_LINE(204)
	::StringBuf s = ::StringBuf_obj::__new();		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(205)
	bool first = true;		HX_STACK_VAR(first,"first");
	HX_STACK_LINE(206)
	Dynamic l = this->h;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(207)
	s->add(HX_CSTRING("{"));
	HX_STACK_LINE(208)
	while((true)){
		HX_STACK_LINE(208)
		if ((!(((l != null()))))){
			HX_STACK_LINE(208)
			break;
		}
		HX_STACK_LINE(209)
		if ((first)){
			HX_STACK_LINE(210)
			first = false;
		}
		else{
			HX_STACK_LINE(212)
			s->add(HX_CSTRING(", "));
		}
		HX_STACK_LINE(213)
		::String _g = ::Std_obj::string(l->__GetItem((int)0));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(213)
		s->add(_g);
		HX_STACK_LINE(214)
		l = l->__GetItem((int)1);
	}
	HX_STACK_LINE(216)
	s->add(HX_CSTRING("}"));
	HX_STACK_LINE(217)
	return s->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC0(List_obj,toString,return )

::String List_obj::join( ::String sep){
	HX_STACK_FRAME("List","join",0xe7ba11da,"List.join","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",224,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_ARG(sep,"sep")
	HX_STACK_LINE(225)
	::StringBuf s = ::StringBuf_obj::__new();		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(226)
	bool first = true;		HX_STACK_VAR(first,"first");
	HX_STACK_LINE(227)
	Dynamic l = this->h;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(228)
	while((true)){
		HX_STACK_LINE(228)
		if ((!(((l != null()))))){
			HX_STACK_LINE(228)
			break;
		}
		HX_STACK_LINE(229)
		if ((first)){
			HX_STACK_LINE(230)
			first = false;
		}
		else{
			HX_STACK_LINE(232)
			s->add(sep);
		}
		HX_STACK_LINE(233)
		s->add(l->__GetItem((int)0));
		HX_STACK_LINE(234)
		l = l->__GetItem((int)1);
	}
	HX_STACK_LINE(236)
	return s->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC1(List_obj,join,return )

::List List_obj::filter( Dynamic f){
	HX_STACK_FRAME("List","filter",0xcbf159a8,"List.filter","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",243,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(244)
	::List l2 = ::List_obj::__new();		HX_STACK_VAR(l2,"l2");
	HX_STACK_LINE(245)
	Dynamic l = this->h;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(246)
	while((true)){
		HX_STACK_LINE(246)
		if ((!(((l != null()))))){
			HX_STACK_LINE(246)
			break;
		}
		HX_STACK_LINE(247)
		Dynamic v = l->__GetItem((int)0);		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(248)
		l = l->__GetItem((int)1);
		HX_STACK_LINE(249)
		if ((f(v).Cast< bool >())){
			HX_STACK_LINE(250)
			l2->add(v);
		}
	}
	HX_STACK_LINE(252)
	return l2;
}


HX_DEFINE_DYNAMIC_FUNC1(List_obj,filter,return )

::List List_obj::map( Dynamic f){
	HX_STACK_FRAME("List","map",0xed883aac,"List.map","D:\\Workspace\\motionTools\\haxe3\\std/List.hx",259,0x402da861)
	HX_STACK_THIS(this)
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(260)
	::List b = ::List_obj::__new();		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(261)
	Dynamic l = this->h;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(262)
	while((true)){
		HX_STACK_LINE(262)
		if ((!(((l != null()))))){
			HX_STACK_LINE(262)
			break;
		}
		HX_STACK_LINE(263)
		Dynamic v = l->__GetItem((int)0);		HX_STACK_VAR(v,"v");
		HX_STACK_LINE(264)
		l = l->__GetItem((int)1);
		HX_STACK_LINE(265)
		Dynamic _g = f(v);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(265)
		b->add(_g);
	}
	HX_STACK_LINE(267)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(List_obj,map,return )


List_obj::List_obj()
{
}

void List_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(List);
	HX_MARK_MEMBER_NAME(h,"h");
	HX_MARK_MEMBER_NAME(q,"q");
	HX_MARK_MEMBER_NAME(length,"length");
	HX_MARK_END_CLASS();
}

void List_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(h,"h");
	HX_VISIT_MEMBER_NAME(q,"q");
	HX_VISIT_MEMBER_NAME(length,"length");
}

Dynamic List_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"h") ) { return h; }
		if (HX_FIELD_EQ(inName,"q") ) { return q; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		if (HX_FIELD_EQ(inName,"pop") ) { return pop_dyn(); }
		if (HX_FIELD_EQ(inName,"map") ) { return map_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"push") ) { return push_dyn(); }
		if (HX_FIELD_EQ(inName,"last") ) { return last_dyn(); }
		if (HX_FIELD_EQ(inName,"join") ) { return join_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"first") ) { return first_dyn(); }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { return length; }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		if (HX_FIELD_EQ(inName,"filter") ) { return filter_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"isEmpty") ) { return isEmpty_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic List_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"h") ) { h=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"q") ) { q=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void List_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("h"));
	outFields->push(HX_CSTRING("q"));
	outFields->push(HX_CSTRING("length"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(List_obj,h),HX_CSTRING("h")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(List_obj,q),HX_CSTRING("q")},
	{hx::fsInt,(int)offsetof(List_obj,length),HX_CSTRING("length")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("h"),
	HX_CSTRING("q"),
	HX_CSTRING("length"),
	HX_CSTRING("add"),
	HX_CSTRING("push"),
	HX_CSTRING("first"),
	HX_CSTRING("last"),
	HX_CSTRING("pop"),
	HX_CSTRING("isEmpty"),
	HX_CSTRING("clear"),
	HX_CSTRING("remove"),
	HX_CSTRING("iterator"),
	HX_CSTRING("toString"),
	HX_CSTRING("join"),
	HX_CSTRING("filter"),
	HX_CSTRING("map"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(List_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(List_obj::__mClass,"__mClass");
};

#endif

Class List_obj::__mClass;

void List_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("List"), hx::TCanCast< List_obj> ,sStaticFields,sMemberFields,
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

void List_obj::__boot()
{
}

