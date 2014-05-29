#include <hxcpp.h>

#ifndef INCLUDED_Lambda
#include <Lambda.h>
#endif
#ifndef INCLUDED_List
#include <List.h>
#endif

Void Lambda_obj::__construct()
{
	return null();
}

//Lambda_obj::~Lambda_obj() { }

Dynamic Lambda_obj::__CreateEmpty() { return  new Lambda_obj; }
hx::ObjectPtr< Lambda_obj > Lambda_obj::__new()
{  hx::ObjectPtr< Lambda_obj > result = new Lambda_obj();
	result->__construct();
	return result;}

Dynamic Lambda_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Lambda_obj > result = new Lambda_obj();
	result->__construct();
	return result;}

Dynamic Lambda_obj::array( Dynamic it){
	HX_STACK_FRAME("Lambda","array",0x9c8b0512,"Lambda.array","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",42,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_LINE(43)
	Dynamic a = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(a,"a");
	HX_STACK_LINE(44)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic i = __it->next();
		a->__Field(HX_CSTRING("push"),true)(i);
	}
	HX_STACK_LINE(46)
	return a;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lambda_obj,array,return )

::List Lambda_obj::list( Dynamic it){
	HX_STACK_FRAME("Lambda","list",0x9f7ad705,"Lambda.list","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",54,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_LINE(55)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(56)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic i = __it->next();
		l->add(i);
	}
	HX_STACK_LINE(58)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lambda_obj,list,return )

::List Lambda_obj::map( Dynamic it,Dynamic f){
	HX_STACK_FRAME("Lambda","map",0x3d8fa1d5,"Lambda.map","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",68,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(69)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(70)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		{
			HX_STACK_LINE(71)
			Dynamic _g = f(x);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(71)
			l->add(_g);
		}
;
	}
	HX_STACK_LINE(72)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,map,return )

::List Lambda_obj::mapi( Dynamic it,Dynamic f){
	HX_STACK_FRAME("Lambda","mapi",0xa01df8f4,"Lambda.mapi","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",82,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(83)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(84)
	int i = (int)0;		HX_STACK_VAR(i,"i");
	HX_STACK_LINE(85)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		{
			HX_STACK_LINE(86)
			int _g = (i)++;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(86)
			Dynamic _g1 = f(_g,x);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(86)
			l->add(_g1);
		}
;
	}
	HX_STACK_LINE(87)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,mapi,return )

bool Lambda_obj::has( Dynamic it,Dynamic elt){
	HX_STACK_FRAME("Lambda","has",0x3d8bd693,"Lambda.has","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",98,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(elt,"elt")
	HX_STACK_LINE(99)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		if (((x == elt))){
			HX_STACK_LINE(101)
			return true;
		}
;
	}
	HX_STACK_LINE(102)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,has,return )

bool Lambda_obj::exists( Dynamic it,Dynamic f){
	HX_STACK_FRAME("Lambda","exists",0x65091043,"Lambda.exists","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",115,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(116)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		if ((f(x).Cast< bool >())){
			HX_STACK_LINE(118)
			return true;
		}
;
	}
	HX_STACK_LINE(119)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,exists,return )

bool Lambda_obj::foreach( Dynamic it,Dynamic f){
	HX_STACK_FRAME("Lambda","foreach",0xb8902543,"Lambda.foreach","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",134,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(135)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		if ((!(f(x).Cast< bool >()))){
			HX_STACK_LINE(137)
			return false;
		}
;
	}
	HX_STACK_LINE(138)
	return true;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,foreach,return )

Void Lambda_obj::iter( Dynamic it,Dynamic f){
{
		HX_STACK_FRAME("Lambda","iter",0x9d877fbf,"Lambda.iter","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",147,0x027b7398)
		HX_STACK_ARG(it,"it")
		HX_STACK_ARG(f,"f")
		HX_STACK_LINE(147)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
			Dynamic x = __it->next();
			f(x).Cast< Void >();
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,iter,(void))

::List Lambda_obj::filter( Dynamic it,Dynamic f){
	HX_STACK_FRAME("Lambda","filter",0x2a5e121f,"Lambda.filter","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",159,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(160)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(161)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		if ((f(x).Cast< bool >())){
			HX_STACK_LINE(163)
			l->add(x);
		}
;
	}
	HX_STACK_LINE(164)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,filter,return )

Dynamic Lambda_obj::fold( Dynamic it,Dynamic f,Dynamic first){
	HX_STACK_FRAME("Lambda","fold",0x9b8816a8,"Lambda.fold","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",179,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(f,"f")
	HX_STACK_ARG(first,"first")
	HX_STACK_LINE(180)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		{
			HX_STACK_LINE(181)
			Dynamic _g = f(x,first);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(181)
			first = _g;
		}
;
	}
	HX_STACK_LINE(182)
	return first;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Lambda_obj,fold,return )

int Lambda_obj::count( Dynamic it,Dynamic pred){
	HX_STACK_FRAME("Lambda","count",0xc15edc48,"Lambda.count","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",191,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(pred,"pred")
	HX_STACK_LINE(192)
	int n = (int)0;		HX_STACK_VAR(n,"n");
	HX_STACK_LINE(193)
	if (((pred == null()))){
		HX_STACK_LINE(194)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
			Dynamic _ = __it->next();
			(n)++;
		}
	}
	else{
		HX_STACK_LINE(197)
		for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
			Dynamic x = __it->next();
			if ((pred(x).Cast< bool >())){
				HX_STACK_LINE(199)
				(n)++;
			}
;
		}
	}
	HX_STACK_LINE(200)
	return n;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,count,return )

bool Lambda_obj::empty( Dynamic it){
	HX_STACK_FRAME("Lambda","empty",0xe6d5d206,"Lambda.empty","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",207,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_LINE(207)
	return !(it->__Field(HX_CSTRING("iterator"),true)()->__Field(HX_CSTRING("hasNext"),true)());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Lambda_obj,empty,return )

int Lambda_obj::indexOf( Dynamic it,Dynamic v){
	HX_STACK_FRAME("Lambda","indexOf",0xbf6a7082,"Lambda.indexOf","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",217,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(218)
	int i = (int)0;		HX_STACK_VAR(i,"i");
	HX_STACK_LINE(219)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic v2 = __it->next();
		{
			HX_STACK_LINE(220)
			if (((v == v2))){
				HX_STACK_LINE(221)
				return i;
			}
			HX_STACK_LINE(222)
			(i)++;
		}
;
	}
	HX_STACK_LINE(224)
	return (int)-1;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,indexOf,return )

Dynamic Lambda_obj::find( Dynamic it,Dynamic f){
	HX_STACK_FRAME("Lambda","find",0x9b838ae0,"Lambda.find","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",237,0x027b7398)
	HX_STACK_ARG(it,"it")
	HX_STACK_ARG(f,"f")
	HX_STACK_LINE(238)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(it->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic v = __it->next();
		if ((f(v).Cast< bool >())){
			HX_STACK_LINE(239)
			return v;
		}
;
	}
	HX_STACK_LINE(241)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,find,return )

::List Lambda_obj::concat( Dynamic a,Dynamic b){
	HX_STACK_FRAME("Lambda","concat",0x6cf8fb7b,"Lambda.concat","D:\\Workspace\\motionTools\\haxe3\\std/Lambda.hx",250,0x027b7398)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(251)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(252)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(a->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		l->add(x);
	}
	HX_STACK_LINE(254)
	for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(b->__Field(HX_CSTRING("iterator"),true)());  __it->hasNext(); ){
		Dynamic x = __it->next();
		l->add(x);
	}
	HX_STACK_LINE(256)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Lambda_obj,concat,return )


Lambda_obj::Lambda_obj()
{
}

Dynamic Lambda_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"map") ) { return map_dyn(); }
		if (HX_FIELD_EQ(inName,"has") ) { return has_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"list") ) { return list_dyn(); }
		if (HX_FIELD_EQ(inName,"mapi") ) { return mapi_dyn(); }
		if (HX_FIELD_EQ(inName,"iter") ) { return iter_dyn(); }
		if (HX_FIELD_EQ(inName,"fold") ) { return fold_dyn(); }
		if (HX_FIELD_EQ(inName,"find") ) { return find_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"array") ) { return array_dyn(); }
		if (HX_FIELD_EQ(inName,"count") ) { return count_dyn(); }
		if (HX_FIELD_EQ(inName,"empty") ) { return empty_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		if (HX_FIELD_EQ(inName,"filter") ) { return filter_dyn(); }
		if (HX_FIELD_EQ(inName,"concat") ) { return concat_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"foreach") ) { return foreach_dyn(); }
		if (HX_FIELD_EQ(inName,"indexOf") ) { return indexOf_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Lambda_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Lambda_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("array"),
	HX_CSTRING("list"),
	HX_CSTRING("map"),
	HX_CSTRING("mapi"),
	HX_CSTRING("has"),
	HX_CSTRING("exists"),
	HX_CSTRING("foreach"),
	HX_CSTRING("iter"),
	HX_CSTRING("filter"),
	HX_CSTRING("fold"),
	HX_CSTRING("count"),
	HX_CSTRING("empty"),
	HX_CSTRING("indexOf"),
	HX_CSTRING("find"),
	HX_CSTRING("concat"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Lambda_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Lambda_obj::__mClass,"__mClass");
};

#endif

Class Lambda_obj::__mClass;

void Lambda_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("Lambda"), hx::TCanCast< Lambda_obj> ,sStaticFields,sMemberFields,
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

void Lambda_obj::__boot()
{
}

