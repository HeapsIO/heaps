#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxd_Profiler
#include <hxd/Profiler.h>
#endif
namespace hxd{

Void Profiler_obj::__construct()
{
	return null();
}

//Profiler_obj::~Profiler_obj() { }

Dynamic Profiler_obj::__CreateEmpty() { return  new Profiler_obj; }
hx::ObjectPtr< Profiler_obj > Profiler_obj::__new()
{  hx::ObjectPtr< Profiler_obj > result = new Profiler_obj();
	result->__construct();
	return result;}

Dynamic Profiler_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Profiler_obj > result = new Profiler_obj();
	result->__construct();
	return result;}

bool Profiler_obj::enable;

::hxd::Profiler Profiler_obj::inst;

Float Profiler_obj::minLimit;

::haxe::ds::StringMap Profiler_obj::h;

Void Profiler_obj::begin( ::String tag){
{
		HX_STACK_FRAME("hxd.Profiler","begin",0x3605571e,"hxd.Profiler.begin","hxd/Profiler.hx",19,0xf00de09a)
		HX_STACK_ARG(tag,"tag")
		HX_STACK_LINE(19)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(21)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(23)
			Dynamic ent = ::hxd::Profiler_obj::h->get(tag);		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(24)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/Profiler.hx",26,0xf00de09a)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("start") , null(),false);
							__result->Add(HX_CSTRING("total") , 0.0,false);
							__result->Add(HX_CSTRING("hit") , (int)0,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(26)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(27)
				::hxd::Profiler_obj::h->set(tag,ent);
			}
			HX_STACK_LINE(30)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(31)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Profiler_obj,begin,(void))

Void Profiler_obj::end( ::String tag){
{
		HX_STACK_FRAME("hxd.Profiler","end",0xd653d990,"hxd.Profiler.end","hxd/Profiler.hx",38,0xf00de09a)
		HX_STACK_ARG(tag,"tag")
		HX_STACK_LINE(38)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(40)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(41)
			Dynamic ent = ::hxd::Profiler_obj::h->get(tag);		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(43)
			if (((null() != ent))){
				HX_STACK_LINE(44)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(45)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Profiler_obj,end,(void))

Void Profiler_obj::clear( ::String tag){
{
		HX_STACK_FRAME("hxd.Profiler","clear",0xce0ade82,"hxd.Profiler.clear","hxd/Profiler.hx",55,0xf00de09a)
		HX_STACK_ARG(tag,"tag")
		HX_STACK_LINE(55)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(57)
			::hxd::Profiler_obj::h->remove(tag);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Profiler_obj,clear,(void))

Void Profiler_obj::clean( ){
{
		HX_STACK_FRAME("hxd.Profiler","clean",0xce0ade7e,"hxd.Profiler.clean","hxd/Profiler.hx",67,0xf00de09a)
		HX_STACK_LINE(67)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(69)
			::haxe::ds::StringMap _g = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(69)
			::hxd::Profiler_obj::h = _g;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Profiler_obj,clean,(void))

Float Profiler_obj::spent( ::String tag){
	HX_STACK_FRAME("hxd.Profiler","spent",0x07190c63,"hxd.Profiler.spent","hxd/Profiler.hx",75,0xf00de09a)
	HX_STACK_ARG(tag,"tag")
	HX_STACK_LINE(76)
	if ((!(::hxd::Profiler_obj::enable))){
		HX_STACK_LINE(76)
		return 0.0;
	}
	HX_STACK_LINE(77)
	return ::hxd::Profiler_obj::h->get(tag)->__Field(HX_CSTRING("total"),true);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Profiler_obj,spent,return )

Float Profiler_obj::hit( ::String tag){
	HX_STACK_FRAME("hxd.Profiler","hit",0xd6561c08,"hxd.Profiler.hit","hxd/Profiler.hx",82,0xf00de09a)
	HX_STACK_ARG(tag,"tag")
	HX_STACK_LINE(83)
	if ((!(::hxd::Profiler_obj::enable))){
		HX_STACK_LINE(83)
		return 0.0;
	}
	HX_STACK_LINE(84)
	return ::hxd::Profiler_obj::h->get(tag)->__Field(HX_CSTRING("hit"),true);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Profiler_obj,hit,return )

::String Profiler_obj::dump( Dynamic __o_trunkValues){
Dynamic trunkValues = __o_trunkValues.Default(true);
	HX_STACK_FRAME("hxd.Profiler","dump",0xb266a5df,"hxd.Profiler.dump","hxd/Profiler.hx",88,0xf00de09a)
	HX_STACK_ARG(trunkValues,"trunkValues")
{
		HX_STACK_LINE(88)
		Array< ::Dynamic > trunkValues1 = Array_obj< ::Dynamic >::__new().Add(trunkValues);		HX_STACK_VAR(trunkValues1,"trunkValues1");
		HX_STACK_LINE(90)
		::String s = HX_CSTRING("");		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(92)
		Array< Float > k = Array_obj< Float >::__new().Add(10000.0);		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(95)
		hx::MultEq(k[(int)0],10.0);

		HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_1_1,Array< ::Dynamic >,trunkValues1,Array< Float >,k)
		Float run(Float v){
			HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","hxd/Profiler.hx",98,0xf00de09a)
			HX_STACK_ARG(v,"v")
			{
				HX_STACK_LINE(98)
				if ((trunkValues1->__get((int)0))){
					HX_STACK_LINE(98)
					int _g = ::Std_obj::_int((v * k->__get((int)0)));		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(98)
					return (Float(_g) / Float(k->__get((int)0)));
				}
				else{
					HX_STACK_LINE(98)
					return v;
				}
				HX_STACK_LINE(98)
				return 0.;
			}
			return null();
		}
		HX_END_LOCAL_FUNC1(return)

		HX_STACK_LINE(98)
		Dynamic trunk =  Dynamic(new _Function_1_1(trunkValues1,k));		HX_STACK_VAR(trunk,"trunk");
		HX_STACK_LINE(99)
		for(::cpp::FastIterator_obj< ::String > *__it = ::cpp::CreateFastIterator< ::String >(::hxd::Profiler_obj::h->keys());  __it->hasNext(); ){
			::String k1 = __it->next();
			{
				HX_STACK_LINE(101)
				Float sp;		HX_STACK_VAR(sp,"sp");
				HX_STACK_LINE(101)
				if ((!(::hxd::Profiler_obj::enable))){
					HX_STACK_LINE(101)
					sp = 0.0;
				}
				else{
					HX_STACK_LINE(101)
					sp = ::hxd::Profiler_obj::h->get(k1)->__Field(HX_CSTRING("total"),true);
				}
				HX_STACK_LINE(102)
				Float ht;		HX_STACK_VAR(ht,"ht");
				HX_STACK_LINE(102)
				if ((!(::hxd::Profiler_obj::enable))){
					HX_STACK_LINE(102)
					ht = 0.0;
				}
				else{
					HX_STACK_LINE(102)
					ht = ::hxd::Profiler_obj::h->get(k1)->__Field(HX_CSTRING("hit"),true);
				}
				HX_STACK_LINE(104)
				if (((sp <= ::hxd::Profiler_obj::minLimit))){
					HX_STACK_LINE(104)
					continue;
				}
				HX_STACK_LINE(106)
				Float _g1 = trunk(sp).Cast< Float >();		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(106)
				::String _g2 = (((HX_CSTRING("tag: ") + k1) + HX_CSTRING(" spent: ")) + _g1);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(106)
				::String _g3 = (_g2 + HX_CSTRING(" hit:"));		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(106)
				::String _g4 = (_g3 + ht);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(106)
				::String _g5 = (_g4 + HX_CSTRING(" avg time: "));		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(106)
				Float _g6 = trunk((Float(sp) / Float(ht))).Cast< Float >();		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(106)
				::String _g7 = (_g5 + _g6);		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(106)
				::String _g8 = (_g7 + HX_CSTRING("<br/>\n"));		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(106)
				hx::AddEq(s,_g8);
			}
;
		}
		HX_STACK_LINE(108)
		return s;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Profiler_obj,dump,return )


Profiler_obj::Profiler_obj()
{
}

Dynamic Profiler_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"h") ) { return h; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"end") ) { return end_dyn(); }
		if (HX_FIELD_EQ(inName,"hit") ) { return hit_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { return inst; }
		if (HX_FIELD_EQ(inName,"dump") ) { return dump_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"begin") ) { return begin_dyn(); }
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"clean") ) { return clean_dyn(); }
		if (HX_FIELD_EQ(inName,"spent") ) { return spent_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"enable") ) { return enable; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"minLimit") ) { return minLimit; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Profiler_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"h") ) { h=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { inst=inValue.Cast< ::hxd::Profiler >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"enable") ) { enable=inValue.Cast< bool >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"minLimit") ) { minLimit=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Profiler_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("enable"),
	HX_CSTRING("inst"),
	HX_CSTRING("minLimit"),
	HX_CSTRING("h"),
	HX_CSTRING("begin"),
	HX_CSTRING("end"),
	HX_CSTRING("clear"),
	HX_CSTRING("clean"),
	HX_CSTRING("spent"),
	HX_CSTRING("hit"),
	HX_CSTRING("dump"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Profiler_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Profiler_obj::enable,"enable");
	HX_MARK_MEMBER_NAME(Profiler_obj::inst,"inst");
	HX_MARK_MEMBER_NAME(Profiler_obj::minLimit,"minLimit");
	HX_MARK_MEMBER_NAME(Profiler_obj::h,"h");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Profiler_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Profiler_obj::enable,"enable");
	HX_VISIT_MEMBER_NAME(Profiler_obj::inst,"inst");
	HX_VISIT_MEMBER_NAME(Profiler_obj::minLimit,"minLimit");
	HX_VISIT_MEMBER_NAME(Profiler_obj::h,"h");
};

#endif

Class Profiler_obj::__mClass;

void Profiler_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.Profiler"), hx::TCanCast< Profiler_obj> ,sStaticFields,sMemberFields,
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

void Profiler_obj::__boot()
{
	enable= true;
	minLimit= 0.0001;
	h= ::haxe::ds::StringMap_obj::__new();
}

} // end namespace hxd
