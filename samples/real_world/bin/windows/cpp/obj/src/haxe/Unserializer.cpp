#include <hxcpp.h>

#ifndef INCLUDED_Date
#include <Date.h>
#endif
#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_haxe_Unserializer
#include <haxe/Unserializer.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_ObjectMap
#include <haxe/ds/ObjectMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace haxe{

Void Unserializer_obj::__construct(::String buf)
{
HX_STACK_FRAME("haxe.Unserializer","new",0xa8f5e205,"haxe.Unserializer.new","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",99,0xa13c1a29)
HX_STACK_THIS(this)
HX_STACK_ARG(buf,"buf")
{
	HX_STACK_LINE(100)
	this->buf = buf;
	HX_STACK_LINE(101)
	this->length = buf.length;
	HX_STACK_LINE(102)
	this->pos = (int)0;
	HX_STACK_LINE(106)
	Array< ::String > _g = Array_obj< ::String >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(106)
	this->scache = _g;
	HX_STACK_LINE(107)
	Dynamic _g1 = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(107)
	this->cache = _g1;
	HX_STACK_LINE(108)
	Dynamic r = ::haxe::Unserializer_obj::DEFAULT_RESOLVER;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(109)
	if (((r == null()))){
		HX_STACK_LINE(110)
		r = hx::ClassOf< ::Type >();
		HX_STACK_LINE(111)
		::haxe::Unserializer_obj::DEFAULT_RESOLVER = r;
	}
	HX_STACK_LINE(113)
	this->setResolver(r);
}
;
	return null();
}

//Unserializer_obj::~Unserializer_obj() { }

Dynamic Unserializer_obj::__CreateEmpty() { return  new Unserializer_obj; }
hx::ObjectPtr< Unserializer_obj > Unserializer_obj::__new(::String buf)
{  hx::ObjectPtr< Unserializer_obj > result = new Unserializer_obj();
	result->__construct(buf);
	return result;}

Dynamic Unserializer_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Unserializer_obj > result = new Unserializer_obj();
	result->__construct(inArgs[0]);
	return result;}

Void Unserializer_obj::setResolver( Dynamic r){
{
		HX_STACK_FRAME("haxe.Unserializer","setResolver",0x5545046d,"haxe.Unserializer.setResolver","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",125,0xa13c1a29)
		HX_STACK_THIS(this)
		HX_STACK_ARG(r,"r")
		HX_STACK_LINE(125)
		if (((r == null()))){
			struct _Function_2_1{
				inline static Dynamic Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",126,0xa13c1a29)
					{
						hx::Anon __result = hx::Anon_obj::Create();

						HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_3_1)
						::Class run(::String _){
							HX_STACK_FRAME("*","_Function_3_1",0x520271b9,"*._Function_3_1","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",127,0xa13c1a29)
							HX_STACK_ARG(_,"_")
							{
								HX_STACK_LINE(127)
								return null();
							}
							return null();
						}
						HX_END_LOCAL_FUNC1(return)

						__result->Add(HX_CSTRING("resolveClass") ,  Dynamic(new _Function_3_1()),true);

						HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_3_2)
						::Enum run(::String _){
							HX_STACK_FRAME("*","_Function_3_2",0x520271ba,"*._Function_3_2","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",128,0xa13c1a29)
							HX_STACK_ARG(_,"_")
							{
								HX_STACK_LINE(128)
								return null();
							}
							return null();
						}
						HX_END_LOCAL_FUNC1(return)

						__result->Add(HX_CSTRING("resolveEnum") ,  Dynamic(new _Function_3_2()),true);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(126)
			this->resolver = _Function_2_1::Block();
		}
		else{
			HX_STACK_LINE(131)
			this->resolver = r;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Unserializer_obj,setResolver,(void))

Dynamic Unserializer_obj::getResolver( ){
	HX_STACK_FRAME("haxe.Unserializer","getResolver",0x4ad7fd61,"haxe.Unserializer.getResolver","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",140,0xa13c1a29)
	HX_STACK_THIS(this)
	HX_STACK_LINE(140)
	return this->resolver;
}


HX_DEFINE_DYNAMIC_FUNC0(Unserializer_obj,getResolver,return )

int Unserializer_obj::get( int p){
	HX_STACK_FRAME("haxe.Unserializer","get",0xa8f0923b,"haxe.Unserializer.get","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",144,0xa13c1a29)
	HX_STACK_THIS(this)
	HX_STACK_ARG(p,"p")
	HX_STACK_LINE(144)
	return this->buf.cca(p);
}


HX_DEFINE_DYNAMIC_FUNC1(Unserializer_obj,get,return )

int Unserializer_obj::readDigits( ){
	HX_STACK_FRAME("haxe.Unserializer","readDigits",0x75598b17,"haxe.Unserializer.readDigits","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",147,0xa13c1a29)
	HX_STACK_THIS(this)
	HX_STACK_LINE(148)
	int k = (int)0;		HX_STACK_VAR(k,"k");
	HX_STACK_LINE(149)
	bool s = false;		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(150)
	int fpos = this->pos;		HX_STACK_VAR(fpos,"fpos");
	HX_STACK_LINE(151)
	while((true)){
		HX_STACK_LINE(152)
		int c = this->buf.cca(this->pos);		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(153)
		if (((c == (int)0))){
			HX_STACK_LINE(154)
			break;
		}
		HX_STACK_LINE(155)
		if (((c == (int)45))){
			HX_STACK_LINE(156)
			if (((this->pos != fpos))){
				HX_STACK_LINE(157)
				break;
			}
			HX_STACK_LINE(158)
			s = true;
			HX_STACK_LINE(159)
			(this->pos)++;
			HX_STACK_LINE(160)
			continue;
		}
		HX_STACK_LINE(162)
		if (((bool((c < (int)48)) || bool((c > (int)57))))){
			HX_STACK_LINE(163)
			break;
		}
		HX_STACK_LINE(164)
		k = ((k * (int)10) + ((c - (int)48)));
		HX_STACK_LINE(165)
		(this->pos)++;
	}
	HX_STACK_LINE(167)
	if ((s)){
		HX_STACK_LINE(168)
		hx::MultEq(k,(int)-1);
	}
	HX_STACK_LINE(169)
	return k;
}


HX_DEFINE_DYNAMIC_FUNC0(Unserializer_obj,readDigits,return )

Void Unserializer_obj::unserializeObject( Dynamic o){
{
		HX_STACK_FRAME("haxe.Unserializer","unserializeObject",0x1b3e66eb,"haxe.Unserializer.unserializeObject","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",172,0xa13c1a29)
		HX_STACK_THIS(this)
		HX_STACK_ARG(o,"o")
		HX_STACK_LINE(173)
		while((true)){
			HX_STACK_LINE(174)
			if (((this->pos >= this->length))){
				HX_STACK_LINE(175)
				HX_STACK_DO_THROW(HX_CSTRING("Invalid object"));
			}
			HX_STACK_LINE(176)
			int _g = this->buf.cca(this->pos);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(176)
			if (((_g == (int)103))){
				HX_STACK_LINE(177)
				break;
			}
			HX_STACK_LINE(178)
			::String k = this->unserialize();		HX_STACK_VAR(k,"k");
			HX_STACK_LINE(179)
			if ((!(::Std_obj::is(k,hx::ClassOf< ::String >())))){
				HX_STACK_LINE(180)
				HX_STACK_DO_THROW(HX_CSTRING("Invalid object key"));
			}
			HX_STACK_LINE(181)
			Dynamic v = this->unserialize();		HX_STACK_VAR(v,"v");
			HX_STACK_LINE(182)
			if (((o != null()))){
				HX_STACK_LINE(182)
				o->__SetField(k,v,false);
			}
		}
		HX_STACK_LINE(184)
		(this->pos)++;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Unserializer_obj,unserializeObject,(void))

Dynamic Unserializer_obj::unserializeEnum( ::Enum edecl,::String tag){
	HX_STACK_FRAME("haxe.Unserializer","unserializeEnum",0x5018b02d,"haxe.Unserializer.unserializeEnum","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",187,0xa13c1a29)
	HX_STACK_THIS(this)
	HX_STACK_ARG(edecl,"edecl")
	HX_STACK_ARG(tag,"tag")
	HX_STACK_LINE(188)
	int _g;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(188)
	{
		HX_STACK_LINE(188)
		int p = (this->pos)++;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(188)
		_g = this->buf.cca(p);
	}
	HX_STACK_LINE(188)
	if (((_g != (int)58))){
		HX_STACK_LINE(189)
		HX_STACK_DO_THROW(HX_CSTRING("Invalid enum format"));
	}
	HX_STACK_LINE(190)
	int nargs = this->readDigits();		HX_STACK_VAR(nargs,"nargs");
	HX_STACK_LINE(191)
	if (((nargs == (int)0))){
		HX_STACK_LINE(192)
		return ::Type_obj::createEnum(edecl,tag,null());
	}
	HX_STACK_LINE(193)
	Dynamic args = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(args,"args");
	HX_STACK_LINE(194)
	while((true)){
		HX_STACK_LINE(194)
		int _g1 = (nargs)--;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(194)
		if ((!(((_g1 > (int)0))))){
			HX_STACK_LINE(194)
			break;
		}
		HX_STACK_LINE(195)
		Dynamic _g2 = this->unserialize();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(195)
		args->__Field(HX_CSTRING("push"),true)(_g2);
	}
	HX_STACK_LINE(196)
	return ::Type_obj::createEnum(edecl,tag,args);
}


HX_DEFINE_DYNAMIC_FUNC2(Unserializer_obj,unserializeEnum,return )

Dynamic Unserializer_obj::unserialize( ){
	HX_STACK_FRAME("haxe.Unserializer","unserialize",0x92cca30c,"haxe.Unserializer.unserialize","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",219,0xa13c1a29)
	HX_STACK_THIS(this)
	HX_STACK_LINE(220)
	{
		HX_STACK_LINE(220)
		int _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(220)
		{
			HX_STACK_LINE(220)
			int p = (this->pos)++;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(220)
			_g = this->buf.cca(p);
		}
		HX_STACK_LINE(220)
		switch( (int)(_g)){
			case (int)110: {
				HX_STACK_LINE(222)
				return null();
			}
			;break;
			case (int)116: {
				HX_STACK_LINE(224)
				return true;
			}
			;break;
			case (int)102: {
				HX_STACK_LINE(226)
				return false;
			}
			;break;
			case (int)122: {
				HX_STACK_LINE(228)
				return (int)0;
			}
			;break;
			case (int)105: {
				HX_STACK_LINE(230)
				return this->readDigits();
			}
			;break;
			case (int)100: {
				HX_STACK_LINE(232)
				int p1 = this->pos;		HX_STACK_VAR(p1,"p1");
				HX_STACK_LINE(233)
				while((true)){
					HX_STACK_LINE(234)
					int c = this->buf.cca(this->pos);		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(236)
					if (((bool((bool((bool((c >= (int)43)) && bool((c < (int)58)))) || bool((c == (int)101)))) || bool((c == (int)69))))){
						HX_STACK_LINE(237)
						(this->pos)++;
					}
					else{
						HX_STACK_LINE(239)
						break;
					}
				}
				HX_STACK_LINE(241)
				::String _g1 = this->buf.substr(p1,(this->pos - p1));		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(241)
				return ::Std_obj::parseFloat(_g1);
			}
			;break;
			case (int)121: {
				HX_STACK_LINE(243)
				int len = this->readDigits();		HX_STACK_VAR(len,"len");
				HX_STACK_LINE(244)
				int _g1;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(244)
				{
					HX_STACK_LINE(244)
					int p = (this->pos)++;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(244)
					_g1 = this->buf.cca(p);
				}
				HX_STACK_LINE(244)
				if (((  ((!(((_g1 != (int)58))))) ? bool(((this->length - this->pos) < len)) : bool(true) ))){
					HX_STACK_LINE(245)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid string length"));
				}
				HX_STACK_LINE(246)
				::String s = this->buf.substr(this->pos,len);		HX_STACK_VAR(s,"s");
				HX_STACK_LINE(247)
				hx::AddEq(this->pos,len);
				HX_STACK_LINE(248)
				::String _g2 = ::StringTools_obj::urlDecode(s);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(248)
				s = _g2;
				HX_STACK_LINE(249)
				this->scache->push(s);
				HX_STACK_LINE(250)
				return s;
			}
			;break;
			case (int)107: {
				HX_STACK_LINE(252)
				return ::Math_obj::NaN;
			}
			;break;
			case (int)109: {
				HX_STACK_LINE(254)
				return ::Math_obj::NEGATIVE_INFINITY;
			}
			;break;
			case (int)112: {
				HX_STACK_LINE(256)
				return ::Math_obj::POSITIVE_INFINITY;
			}
			;break;
			case (int)97: {
				HX_STACK_LINE(258)
				::String buf = this->buf;		HX_STACK_VAR(buf,"buf");
				HX_STACK_LINE(259)
				Dynamic a = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(260)
				this->cache->__Field(HX_CSTRING("push"),true)(a);
				HX_STACK_LINE(261)
				while((true)){
					HX_STACK_LINE(262)
					int c = this->buf.cca(this->pos);		HX_STACK_VAR(c,"c");
					HX_STACK_LINE(263)
					if (((c == (int)104))){
						HX_STACK_LINE(264)
						(this->pos)++;
						HX_STACK_LINE(265)
						break;
					}
					HX_STACK_LINE(267)
					if (((c == (int)117))){
						HX_STACK_LINE(268)
						(this->pos)++;
						HX_STACK_LINE(269)
						int n = this->readDigits();		HX_STACK_VAR(n,"n");
						HX_STACK_LINE(270)
						hx::IndexRef((a).mPtr,((a->__Field(HX_CSTRING("length"),true) + n) - (int)1)) = null();
					}
					else{
						HX_STACK_LINE(272)
						Dynamic _g3 = this->unserialize();		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(272)
						a->__Field(HX_CSTRING("push"),true)(_g3);
					}
				}
				HX_STACK_LINE(274)
				return a;
			}
			;break;
			case (int)111: {
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",276,0xa13c1a29)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(276)
				Dynamic o = _Function_3_1::Block();		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(277)
				this->cache->__Field(HX_CSTRING("push"),true)(o);
				HX_STACK_LINE(278)
				this->unserializeObject(o);
				HX_STACK_LINE(279)
				return o;
			}
			;break;
			case (int)114: {
				HX_STACK_LINE(281)
				int n = this->readDigits();		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(282)
				if (((bool((n < (int)0)) || bool((n >= this->cache->__Field(HX_CSTRING("length"),true)))))){
					HX_STACK_LINE(283)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid reference"));
				}
				HX_STACK_LINE(284)
				return this->cache->__GetItem(n);
			}
			;break;
			case (int)82: {
				HX_STACK_LINE(286)
				int n = this->readDigits();		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(287)
				if (((bool((n < (int)0)) || bool((n >= this->scache->length))))){
					HX_STACK_LINE(288)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid string reference"));
				}
				HX_STACK_LINE(289)
				return this->scache->__get(n);
			}
			;break;
			case (int)120: {
				HX_STACK_LINE(291)
				HX_STACK_DO_THROW(this->unserialize());
			}
			;break;
			case (int)99: {
				HX_STACK_LINE(293)
				::String name = this->unserialize();		HX_STACK_VAR(name,"name");
				HX_STACK_LINE(294)
				::Class cl = this->resolver->__Field(HX_CSTRING("resolveClass"),true)(name);		HX_STACK_VAR(cl,"cl");
				HX_STACK_LINE(295)
				if (((cl == null()))){
					HX_STACK_LINE(296)
					HX_STACK_DO_THROW((HX_CSTRING("Class not found ") + name));
				}
				HX_STACK_LINE(297)
				Dynamic o = ::Type_obj::createEmptyInstance(cl);		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(298)
				this->cache->__Field(HX_CSTRING("push"),true)(o);
				HX_STACK_LINE(299)
				this->unserializeObject(o);
				HX_STACK_LINE(300)
				return o;
			}
			;break;
			case (int)119: {
				HX_STACK_LINE(302)
				::String name = this->unserialize();		HX_STACK_VAR(name,"name");
				HX_STACK_LINE(303)
				::Enum edecl = this->resolver->__Field(HX_CSTRING("resolveEnum"),true)(name);		HX_STACK_VAR(edecl,"edecl");
				HX_STACK_LINE(304)
				if (((edecl == null()))){
					HX_STACK_LINE(305)
					HX_STACK_DO_THROW((HX_CSTRING("Enum not found ") + name));
				}
				HX_STACK_LINE(306)
				Dynamic _g4 = this->unserialize();		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(306)
				Dynamic e = this->unserializeEnum(edecl,_g4);		HX_STACK_VAR(e,"e");
				HX_STACK_LINE(307)
				this->cache->__Field(HX_CSTRING("push"),true)(e);
				HX_STACK_LINE(308)
				return e;
			}
			;break;
			case (int)106: {
				HX_STACK_LINE(310)
				::String name = this->unserialize();		HX_STACK_VAR(name,"name");
				HX_STACK_LINE(311)
				::Enum edecl = this->resolver->__Field(HX_CSTRING("resolveEnum"),true)(name);		HX_STACK_VAR(edecl,"edecl");
				HX_STACK_LINE(312)
				if (((edecl == null()))){
					HX_STACK_LINE(313)
					HX_STACK_DO_THROW((HX_CSTRING("Enum not found ") + name));
				}
				HX_STACK_LINE(314)
				(this->pos)++;
				HX_STACK_LINE(315)
				int index = this->readDigits();		HX_STACK_VAR(index,"index");
				HX_STACK_LINE(316)
				Array< ::String > _g5 = ::Type_obj::getEnumConstructs(edecl);		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(316)
				::String tag = _g5->__get(index);		HX_STACK_VAR(tag,"tag");
				HX_STACK_LINE(317)
				if (((tag == null()))){
					HX_STACK_LINE(318)
					HX_STACK_DO_THROW((((HX_CSTRING("Unknown enum index ") + name) + HX_CSTRING("@")) + index));
				}
				HX_STACK_LINE(319)
				Dynamic e = this->unserializeEnum(edecl,tag);		HX_STACK_VAR(e,"e");
				HX_STACK_LINE(320)
				this->cache->__Field(HX_CSTRING("push"),true)(e);
				HX_STACK_LINE(321)
				return e;
			}
			;break;
			case (int)108: {
				HX_STACK_LINE(323)
				::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
				HX_STACK_LINE(324)
				this->cache->__Field(HX_CSTRING("push"),true)(l);
				HX_STACK_LINE(325)
				::String buf = this->buf;		HX_STACK_VAR(buf,"buf");
				HX_STACK_LINE(326)
				while((true)){
					HX_STACK_LINE(326)
					int _g6 = this->buf.cca(this->pos);		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(326)
					if ((!(((_g6 != (int)104))))){
						HX_STACK_LINE(326)
						break;
					}
					HX_STACK_LINE(327)
					Dynamic _g7 = this->unserialize();		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(327)
					l->add(_g7);
				}
				HX_STACK_LINE(328)
				(this->pos)++;
				HX_STACK_LINE(329)
				return l;
			}
			;break;
			case (int)98: {
				HX_STACK_LINE(331)
				::haxe::ds::StringMap h = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(h,"h");
				HX_STACK_LINE(332)
				this->cache->__Field(HX_CSTRING("push"),true)(h);
				HX_STACK_LINE(333)
				::String buf = this->buf;		HX_STACK_VAR(buf,"buf");
				HX_STACK_LINE(334)
				while((true)){
					HX_STACK_LINE(334)
					int _g8 = this->buf.cca(this->pos);		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(334)
					if ((!(((_g8 != (int)104))))){
						HX_STACK_LINE(334)
						break;
					}
					HX_STACK_LINE(335)
					::String s = this->unserialize();		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(336)
					Dynamic _g9 = this->unserialize();		HX_STACK_VAR(_g9,"_g9");
					HX_STACK_LINE(336)
					h->set(s,_g9);
				}
				HX_STACK_LINE(338)
				(this->pos)++;
				HX_STACK_LINE(339)
				return h;
			}
			;break;
			case (int)113: {
				HX_STACK_LINE(341)
				::haxe::ds::IntMap h = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(h,"h");
				HX_STACK_LINE(342)
				this->cache->__Field(HX_CSTRING("push"),true)(h);
				HX_STACK_LINE(343)
				::String buf = this->buf;		HX_STACK_VAR(buf,"buf");
				HX_STACK_LINE(344)
				int c;		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(344)
				{
					HX_STACK_LINE(344)
					int p = (this->pos)++;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(344)
					c = this->buf.cca(p);
				}
				HX_STACK_LINE(345)
				while((true)){
					HX_STACK_LINE(345)
					if ((!(((c == (int)58))))){
						HX_STACK_LINE(345)
						break;
					}
					HX_STACK_LINE(346)
					int i = this->readDigits();		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(347)
					Dynamic _g10 = this->unserialize();		HX_STACK_VAR(_g10,"_g10");
					HX_STACK_LINE(347)
					h->set(i,_g10);
					HX_STACK_LINE(348)
					int _g11;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(348)
					{
						HX_STACK_LINE(348)
						int p = (this->pos)++;		HX_STACK_VAR(p,"p");
						HX_STACK_LINE(348)
						_g11 = this->buf.cca(p);
					}
					HX_STACK_LINE(348)
					c = _g11;
				}
				HX_STACK_LINE(350)
				if (((c != (int)104))){
					HX_STACK_LINE(351)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid IntMap format"));
				}
				HX_STACK_LINE(352)
				return h;
			}
			;break;
			case (int)77: {
				HX_STACK_LINE(354)
				::haxe::ds::ObjectMap h = ::haxe::ds::ObjectMap_obj::__new();		HX_STACK_VAR(h,"h");
				HX_STACK_LINE(355)
				this->cache->__Field(HX_CSTRING("push"),true)(h);
				HX_STACK_LINE(356)
				::String buf = this->buf;		HX_STACK_VAR(buf,"buf");
				HX_STACK_LINE(357)
				while((true)){
					HX_STACK_LINE(357)
					int _g12 = this->buf.cca(this->pos);		HX_STACK_VAR(_g12,"_g12");
					HX_STACK_LINE(357)
					if ((!(((_g12 != (int)104))))){
						HX_STACK_LINE(357)
						break;
					}
					HX_STACK_LINE(358)
					Dynamic s = this->unserialize();		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(359)
					Dynamic _g13 = this->unserialize();		HX_STACK_VAR(_g13,"_g13");
					HX_STACK_LINE(359)
					h->set(s,_g13);
				}
				HX_STACK_LINE(361)
				(this->pos)++;
				HX_STACK_LINE(362)
				return h;
			}
			;break;
			case (int)118: {
				HX_STACK_LINE(364)
				::String _g14 = this->buf.substr(this->pos,(int)19);		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(364)
				::Date d = ::Date_obj::fromString(_g14);		HX_STACK_VAR(d,"d");
				HX_STACK_LINE(365)
				this->cache->__Field(HX_CSTRING("push"),true)(d);
				HX_STACK_LINE(366)
				hx::AddEq(this->pos,(int)19);
				HX_STACK_LINE(367)
				return d;
			}
			;break;
			case (int)115: {
				HX_STACK_LINE(369)
				int len = this->readDigits();		HX_STACK_VAR(len,"len");
				HX_STACK_LINE(370)
				::String buf = this->buf;		HX_STACK_VAR(buf,"buf");
				HX_STACK_LINE(371)
				int _g15;		HX_STACK_VAR(_g15,"_g15");
				HX_STACK_LINE(371)
				{
					HX_STACK_LINE(371)
					int p = (this->pos)++;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(371)
					_g15 = this->buf.cca(p);
				}
				HX_STACK_LINE(371)
				if (((  ((!(((_g15 != (int)58))))) ? bool(((this->length - this->pos) < len)) : bool(true) ))){
					HX_STACK_LINE(372)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid bytes length"));
				}
				HX_STACK_LINE(376)
				Array< int > codes = ::haxe::Unserializer_obj::CODES;		HX_STACK_VAR(codes,"codes");
				HX_STACK_LINE(377)
				if (((codes == null()))){
					HX_STACK_LINE(378)
					Array< int > _g16 = ::haxe::Unserializer_obj::initCodes();		HX_STACK_VAR(_g16,"_g16");
					HX_STACK_LINE(378)
					codes = _g16;
					HX_STACK_LINE(379)
					::haxe::Unserializer_obj::CODES = codes;
				}
				HX_STACK_LINE(381)
				int i = this->pos;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(382)
				int rest = (int(len) & int((int)3));		HX_STACK_VAR(rest,"rest");
				HX_STACK_LINE(383)
				int size;		HX_STACK_VAR(size,"size");
				HX_STACK_LINE(383)
				size = ((((int(len) >> int((int)2))) * (int)3) + ((  (((rest >= (int)2))) ? int((rest - (int)1)) : int((int)0) )));
				HX_STACK_LINE(384)
				int max = (i + ((len - rest)));		HX_STACK_VAR(max,"max");
				HX_STACK_LINE(385)
				::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::alloc(size);		HX_STACK_VAR(bytes,"bytes");
				HX_STACK_LINE(386)
				int bpos = (int)0;		HX_STACK_VAR(bpos,"bpos");
				HX_STACK_LINE(387)
				while((true)){
					HX_STACK_LINE(387)
					if ((!(((i < max))))){
						HX_STACK_LINE(387)
						break;
					}
					HX_STACK_LINE(388)
					int _g17;		HX_STACK_VAR(_g17,"_g17");
					HX_STACK_LINE(388)
					{
						HX_STACK_LINE(388)
						int index = (i)++;		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(388)
						_g17 = buf.cca(index);
					}
					HX_STACK_LINE(388)
					int c1 = codes->__get(_g17);		HX_STACK_VAR(c1,"c1");
					HX_STACK_LINE(389)
					int _g18;		HX_STACK_VAR(_g18,"_g18");
					HX_STACK_LINE(389)
					{
						HX_STACK_LINE(389)
						int index = (i)++;		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(389)
						_g18 = buf.cca(index);
					}
					HX_STACK_LINE(389)
					int c2 = codes->__get(_g18);		HX_STACK_VAR(c2,"c2");
					HX_STACK_LINE(390)
					{
						HX_STACK_LINE(390)
						int pos = (bpos)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(390)
						bytes->b[pos] = (int((int(c1) << int((int)2))) | int((int(c2) >> int((int)4))));
					}
					HX_STACK_LINE(391)
					int _g19;		HX_STACK_VAR(_g19,"_g19");
					HX_STACK_LINE(391)
					{
						HX_STACK_LINE(391)
						int index = (i)++;		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(391)
						_g19 = buf.cca(index);
					}
					HX_STACK_LINE(391)
					int c3 = codes->__get(_g19);		HX_STACK_VAR(c3,"c3");
					HX_STACK_LINE(392)
					{
						HX_STACK_LINE(392)
						int pos = (bpos)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(392)
						bytes->b[pos] = (int((int(c2) << int((int)4))) | int((int(c3) >> int((int)2))));
					}
					HX_STACK_LINE(393)
					int _g20;		HX_STACK_VAR(_g20,"_g20");
					HX_STACK_LINE(393)
					{
						HX_STACK_LINE(393)
						int index = (i)++;		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(393)
						_g20 = buf.cca(index);
					}
					HX_STACK_LINE(393)
					int c4 = codes->__get(_g20);		HX_STACK_VAR(c4,"c4");
					HX_STACK_LINE(394)
					{
						HX_STACK_LINE(394)
						int pos = (bpos)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(394)
						bytes->b[pos] = (int((int(c3) << int((int)6))) | int(c4));
					}
				}
				HX_STACK_LINE(396)
				if (((rest >= (int)2))){
					HX_STACK_LINE(397)
					int _g21;		HX_STACK_VAR(_g21,"_g21");
					HX_STACK_LINE(397)
					{
						HX_STACK_LINE(397)
						int index = (i)++;		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(397)
						_g21 = buf.cca(index);
					}
					HX_STACK_LINE(397)
					int c1 = codes->__get(_g21);		HX_STACK_VAR(c1,"c1");
					HX_STACK_LINE(398)
					int _g22;		HX_STACK_VAR(_g22,"_g22");
					HX_STACK_LINE(398)
					{
						HX_STACK_LINE(398)
						int index = (i)++;		HX_STACK_VAR(index,"index");
						HX_STACK_LINE(398)
						_g22 = buf.cca(index);
					}
					HX_STACK_LINE(398)
					int c2 = codes->__get(_g22);		HX_STACK_VAR(c2,"c2");
					HX_STACK_LINE(399)
					{
						HX_STACK_LINE(399)
						int pos = (bpos)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(399)
						bytes->b[pos] = (int((int(c1) << int((int)2))) | int((int(c2) >> int((int)4))));
					}
					HX_STACK_LINE(400)
					if (((rest == (int)3))){
						HX_STACK_LINE(401)
						int _g23;		HX_STACK_VAR(_g23,"_g23");
						HX_STACK_LINE(401)
						{
							HX_STACK_LINE(401)
							int index = (i)++;		HX_STACK_VAR(index,"index");
							HX_STACK_LINE(401)
							_g23 = buf.cca(index);
						}
						HX_STACK_LINE(401)
						int c3 = codes->__get(_g23);		HX_STACK_VAR(c3,"c3");
						HX_STACK_LINE(402)
						{
							HX_STACK_LINE(402)
							int pos = (bpos)++;		HX_STACK_VAR(pos,"pos");
							HX_STACK_LINE(402)
							bytes->b[pos] = (int((int(c2) << int((int)4))) | int((int(c3) >> int((int)2))));
						}
					}
				}
				HX_STACK_LINE(406)
				hx::AddEq(this->pos,len);
				HX_STACK_LINE(407)
				this->cache->__Field(HX_CSTRING("push"),true)(bytes);
				HX_STACK_LINE(408)
				return bytes;
			}
			;break;
			case (int)67: {
				HX_STACK_LINE(410)
				::String name = this->unserialize();		HX_STACK_VAR(name,"name");
				HX_STACK_LINE(411)
				::Class cl = this->resolver->__Field(HX_CSTRING("resolveClass"),true)(name);		HX_STACK_VAR(cl,"cl");
				HX_STACK_LINE(412)
				if (((cl == null()))){
					HX_STACK_LINE(413)
					HX_STACK_DO_THROW((HX_CSTRING("Class not found ") + name));
				}
				HX_STACK_LINE(414)
				Dynamic o = ::Type_obj::createEmptyInstance(cl);		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(415)
				this->cache->__Field(HX_CSTRING("push"),true)(o);
				HX_STACK_LINE(416)
				o->__Field(HX_CSTRING("hxUnserialize"),true)(hx::ObjectPtr<OBJ_>(this));
				HX_STACK_LINE(417)
				int _g24;		HX_STACK_VAR(_g24,"_g24");
				HX_STACK_LINE(417)
				{
					HX_STACK_LINE(417)
					int p = (this->pos)++;		HX_STACK_VAR(p,"p");
					HX_STACK_LINE(417)
					_g24 = this->buf.cca(p);
				}
				HX_STACK_LINE(417)
				if (((_g24 != (int)103))){
					HX_STACK_LINE(418)
					HX_STACK_DO_THROW(HX_CSTRING("Invalid custom data"));
				}
				HX_STACK_LINE(419)
				return o;
			}
			;break;
			default: {
			}
		}
	}
	HX_STACK_LINE(422)
	(this->pos)--;
	HX_STACK_LINE(423)
	::String _g25 = this->buf.charAt(this->pos);		HX_STACK_VAR(_g25,"_g25");
	HX_STACK_LINE(423)
	::String _g26 = (HX_CSTRING("Invalid char ") + _g25);		HX_STACK_VAR(_g26,"_g26");
	HX_STACK_LINE(423)
	::String _g27 = (_g26 + HX_CSTRING(" at position "));		HX_STACK_VAR(_g27,"_g27");
	HX_STACK_LINE(423)
	HX_STACK_DO_THROW((_g27 + this->pos));
	HX_STACK_LINE(423)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Unserializer_obj,unserialize,return )

Dynamic Unserializer_obj::DEFAULT_RESOLVER;

::String Unserializer_obj::BASE64;

Array< int > Unserializer_obj::CODES;

Array< int > Unserializer_obj::initCodes( ){
	HX_STACK_FRAME("haxe.Unserializer","initCodes",0xee42ccdb,"haxe.Unserializer.initCodes","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",67,0xa13c1a29)
	HX_STACK_LINE(72)
	Array< int > codes = Array_obj< int >::__new();		HX_STACK_VAR(codes,"codes");
	HX_STACK_LINE(74)
	{
		HX_STACK_LINE(74)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(74)
		int _g = ::haxe::Unserializer_obj::BASE64.length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(74)
		while((true)){
			HX_STACK_LINE(74)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(74)
				break;
			}
			HX_STACK_LINE(74)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(75)
			int _g2 = ::haxe::Unserializer_obj::BASE64.cca(i);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(75)
			codes[_g2] = i;
		}
	}
	HX_STACK_LINE(76)
	return codes;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Unserializer_obj,initCodes,return )

Dynamic Unserializer_obj::run( ::String v){
	HX_STACK_FRAME("haxe.Unserializer","run",0xa8f8f8f0,"haxe.Unserializer.run","D:\\Workspace\\motionTools\\haxe3\\std/haxe/Unserializer.hx",434,0xa13c1a29)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(434)
	return ::haxe::Unserializer_obj::__new(v)->unserialize();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Unserializer_obj,run,return )


Unserializer_obj::Unserializer_obj()
{
}

void Unserializer_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Unserializer);
	HX_MARK_MEMBER_NAME(buf,"buf");
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_MEMBER_NAME(length,"length");
	HX_MARK_MEMBER_NAME(cache,"cache");
	HX_MARK_MEMBER_NAME(scache,"scache");
	HX_MARK_MEMBER_NAME(resolver,"resolver");
	HX_MARK_END_CLASS();
}

void Unserializer_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(buf,"buf");
	HX_VISIT_MEMBER_NAME(pos,"pos");
	HX_VISIT_MEMBER_NAME(length,"length");
	HX_VISIT_MEMBER_NAME(cache,"cache");
	HX_VISIT_MEMBER_NAME(scache,"scache");
	HX_VISIT_MEMBER_NAME(resolver,"resolver");
}

Dynamic Unserializer_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"run") ) { return run_dyn(); }
		if (HX_FIELD_EQ(inName,"buf") ) { return buf; }
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"CODES") ) { return CODES; }
		if (HX_FIELD_EQ(inName,"cache") ) { return cache; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"BASE64") ) { return BASE64; }
		if (HX_FIELD_EQ(inName,"length") ) { return length; }
		if (HX_FIELD_EQ(inName,"scache") ) { return scache; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"resolver") ) { return resolver; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"initCodes") ) { return initCodes_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"readDigits") ) { return readDigits_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"setResolver") ) { return setResolver_dyn(); }
		if (HX_FIELD_EQ(inName,"getResolver") ) { return getResolver_dyn(); }
		if (HX_FIELD_EQ(inName,"unserialize") ) { return unserialize_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"unserializeEnum") ) { return unserializeEnum_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"DEFAULT_RESOLVER") ) { return DEFAULT_RESOLVER; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"unserializeObject") ) { return unserializeObject_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Unserializer_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"buf") ) { buf=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"CODES") ) { CODES=inValue.Cast< Array< int > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"cache") ) { cache=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"BASE64") ) { BASE64=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"scache") ) { scache=inValue.Cast< Array< ::String > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"resolver") ) { resolver=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"DEFAULT_RESOLVER") ) { DEFAULT_RESOLVER=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Unserializer_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("buf"));
	outFields->push(HX_CSTRING("pos"));
	outFields->push(HX_CSTRING("length"));
	outFields->push(HX_CSTRING("cache"));
	outFields->push(HX_CSTRING("scache"));
	outFields->push(HX_CSTRING("resolver"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("DEFAULT_RESOLVER"),
	HX_CSTRING("BASE64"),
	HX_CSTRING("CODES"),
	HX_CSTRING("initCodes"),
	HX_CSTRING("run"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(Unserializer_obj,buf),HX_CSTRING("buf")},
	{hx::fsInt,(int)offsetof(Unserializer_obj,pos),HX_CSTRING("pos")},
	{hx::fsInt,(int)offsetof(Unserializer_obj,length),HX_CSTRING("length")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Unserializer_obj,cache),HX_CSTRING("cache")},
	{hx::fsObject /*Array< ::String >*/ ,(int)offsetof(Unserializer_obj,scache),HX_CSTRING("scache")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Unserializer_obj,resolver),HX_CSTRING("resolver")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("buf"),
	HX_CSTRING("pos"),
	HX_CSTRING("length"),
	HX_CSTRING("cache"),
	HX_CSTRING("scache"),
	HX_CSTRING("resolver"),
	HX_CSTRING("setResolver"),
	HX_CSTRING("getResolver"),
	HX_CSTRING("get"),
	HX_CSTRING("readDigits"),
	HX_CSTRING("unserializeObject"),
	HX_CSTRING("unserializeEnum"),
	HX_CSTRING("unserialize"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Unserializer_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Unserializer_obj::DEFAULT_RESOLVER,"DEFAULT_RESOLVER");
	HX_MARK_MEMBER_NAME(Unserializer_obj::BASE64,"BASE64");
	HX_MARK_MEMBER_NAME(Unserializer_obj::CODES,"CODES");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Unserializer_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Unserializer_obj::DEFAULT_RESOLVER,"DEFAULT_RESOLVER");
	HX_VISIT_MEMBER_NAME(Unserializer_obj::BASE64,"BASE64");
	HX_VISIT_MEMBER_NAME(Unserializer_obj::CODES,"CODES");
};

#endif

Class Unserializer_obj::__mClass;

void Unserializer_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("haxe.Unserializer"), hx::TCanCast< Unserializer_obj> ,sStaticFields,sMemberFields,
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

void Unserializer_obj::__boot()
{
	DEFAULT_RESOLVER= hx::ClassOf< ::Type >();
	BASE64= HX_CSTRING("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:");
	CODES= null();
}

} // end namespace haxe
