#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_format_tools_Inflate
#include <format/tools/Inflate.h>
#endif
#ifndef INCLUDED_haxe_crypto_BaseCode
#include <haxe/crypto/BaseCode.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesInput
#include <haxe/io/BytesInput.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_haxe_xml_Fast
#include <haxe/xml/Fast.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_AttribAccess
#include <haxe/xml/_Fast/AttribAccess.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_HasAttribAccess
#include <haxe/xml/_Fast/HasAttribAccess.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_NodeAccess
#include <haxe/xml/_Fast/NodeAccess.h>
#endif
#ifndef INCLUDED_haxe_xml__Fast_NodeListAccess
#include <haxe/xml/_Fast/NodeListAccess.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
#ifndef INCLUDED_hxd_res_TiledMap
#include <hxd/res/TiledMap.h>
#endif
namespace hxd{
namespace res{

Void TiledMap_obj::__construct(::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.TiledMap","new",0x299f9d00,"hxd.res.TiledMap.new","hxd/res/TiledMap.hx",16,0xd576992e)
HX_STACK_THIS(this)
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(16)
	super::__construct(entry);
}
;
	return null();
}

//TiledMap_obj::~TiledMap_obj() { }

Dynamic TiledMap_obj::__CreateEmpty() { return  new TiledMap_obj; }
hx::ObjectPtr< TiledMap_obj > TiledMap_obj::__new(::hxd::res::FileEntry entry)
{  hx::ObjectPtr< TiledMap_obj > result = new TiledMap_obj();
	result->__construct(entry);
	return result;}

Dynamic TiledMap_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TiledMap_obj > result = new TiledMap_obj();
	result->__construct(inArgs[0]);
	return result;}

Dynamic TiledMap_obj::toMap( ){
	HX_STACK_FRAME("hxd.res.TiledMap","toMap",0x0164f081,"hxd.res.TiledMap.toMap","hxd/res/TiledMap.hx",18,0xd576992e)
	HX_STACK_THIS(this)
	HX_STACK_LINE(19)
	::String data = this->entry->getBytes()->toString();		HX_STACK_VAR(data,"data");
	HX_STACK_LINE(20)
	::haxe::io::Bytes _g = ::haxe::io::Bytes_obj::ofString(HX_CSTRING("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(20)
	::haxe::crypto::BaseCode base = ::haxe::crypto::BaseCode_obj::__new(_g);		HX_STACK_VAR(base,"base");
	HX_STACK_LINE(21)
	::Xml _g1 = ::Xml_obj::parse(data)->firstElement();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(21)
	::haxe::xml::Fast x = ::haxe::xml::Fast_obj::__new(_g1);		HX_STACK_VAR(x,"x");
	HX_STACK_LINE(22)
	Dynamic layers = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(layers,"layers");
	HX_STACK_LINE(23)
	for(::cpp::FastIterator_obj< ::haxe::xml::Fast > *__it = ::cpp::CreateFastIterator< ::haxe::xml::Fast >(x->nodes->resolve(HX_CSTRING("layer"))->iterator());  __it->hasNext(); ){
		::haxe::xml::Fast l = __it->next();
		{
			HX_STACK_LINE(24)
			::String _g2 = l->node->resolve(HX_CSTRING("data"))->get_innerData();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(24)
			::String data1 = ::StringTools_obj::trim(_g2);		HX_STACK_VAR(data1,"data1");
			HX_STACK_LINE(25)
			while((true)){
				HX_STACK_LINE(25)
				Dynamic _g3 = data1.charCodeAt((data1.length - (int)1));		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(25)
				if ((!(((_g3 == (int)61))))){
					HX_STACK_LINE(25)
					break;
				}
				HX_STACK_LINE(26)
				::String _g4 = data1.substr((int)0,(data1.length - (int)1));		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(26)
				data1 = _g4;
			}
			HX_STACK_LINE(27)
			::haxe::io::Bytes bytes = ::haxe::io::Bytes_obj::ofString(data1);		HX_STACK_VAR(bytes,"bytes");
			HX_STACK_LINE(28)
			::haxe::io::Bytes bytes1 = base->decodeBytes(bytes);		HX_STACK_VAR(bytes1,"bytes1");
			HX_STACK_LINE(29)
			::haxe::io::Bytes _g5 = ::format::tools::Inflate_obj::run(bytes1);		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(29)
			bytes1 = _g5;
			HX_STACK_LINE(30)
			::haxe::io::BytesInput input = ::haxe::io::BytesInput_obj::__new(bytes1,null(),null());		HX_STACK_VAR(input,"input");
			HX_STACK_LINE(31)
			Array< int > data2 = Array_obj< int >::__new();		HX_STACK_VAR(data2,"data2");
			HX_STACK_LINE(32)
			{
				HX_STACK_LINE(32)
				int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(32)
				int _g3 = (int(bytes1->length) >> int((int)2));		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(32)
				while((true)){
					HX_STACK_LINE(32)
					if ((!(((_g11 < _g3))))){
						HX_STACK_LINE(32)
						break;
					}
					HX_STACK_LINE(32)
					int i = (_g11)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(33)
					int _g6 = input->readInt32();		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(33)
					data2->push(_g6);
				}
			}
			HX_STACK_LINE(35)
			::String _g7 = l->att->resolve(HX_CSTRING("name"));		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(36)
			Float _g9;		HX_STACK_VAR(_g9,"_g9");
			HX_STACK_LINE(36)
			if ((l->has->resolve(HX_CSTRING("opacity")))){
				HX_STACK_LINE(36)
				::String _g8 = l->att->resolve(HX_CSTRING("opacity"));		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(36)
				_g9 = ::Std_obj::parseFloat(_g8);
			}
			else{
				HX_STACK_LINE(36)
				_g9 = 1.;
			}
			struct _Function_2_1{
				inline static Dynamic Block( ::String &_g7,Array< int > &data2,Float &_g9){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/TiledMap.hx",34,0xd576992e)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("name") , _g7,false);
						__result->Add(HX_CSTRING("opacity") , _g9,false);
						__result->Add(HX_CSTRING("objects") , Dynamic( Array_obj<Dynamic>::__new()),false);
						__result->Add(HX_CSTRING("data") , data2,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(34)
			Dynamic _g10 = _Function_2_1::Block(_g7,data2,_g9);		HX_STACK_VAR(_g10,"_g10");
			HX_STACK_LINE(34)
			layers->__Field(HX_CSTRING("push"),true)(_g10);
		}
;
	}
	HX_STACK_LINE(41)
	for(::cpp::FastIterator_obj< ::haxe::xml::Fast > *__it = ::cpp::CreateFastIterator< ::haxe::xml::Fast >(x->nodes->resolve(HX_CSTRING("objectgroup"))->iterator());  __it->hasNext(); ){
		::haxe::xml::Fast l = __it->next();
		{
			HX_STACK_LINE(42)
			Dynamic objs = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(objs,"objs");
			HX_STACK_LINE(43)
			for(::cpp::FastIterator_obj< ::haxe::xml::Fast > *__it = ::cpp::CreateFastIterator< ::haxe::xml::Fast >(l->nodes->resolve(HX_CSTRING("object"))->iterator());  __it->hasNext(); ){
				::haxe::xml::Fast o = __it->next();
				if ((o->has->resolve(HX_CSTRING("name")))){
					HX_STACK_LINE(45)
					::String _g11 = o->att->resolve(HX_CSTRING("name"));		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(45)
					::String _g12;		HX_STACK_VAR(_g12,"_g12");
					HX_STACK_LINE(45)
					if ((o->has->resolve(HX_CSTRING("type")))){
						HX_STACK_LINE(45)
						_g12 = o->att->resolve(HX_CSTRING("type"));
					}
					else{
						HX_STACK_LINE(45)
						_g12 = null();
					}
					HX_STACK_LINE(45)
					::String _g13 = o->att->resolve(HX_CSTRING("x"));		HX_STACK_VAR(_g13,"_g13");
					HX_STACK_LINE(45)
					Dynamic _g14 = ::Std_obj::parseInt(_g13);		HX_STACK_VAR(_g14,"_g14");
					HX_STACK_LINE(45)
					::String _g15 = o->att->resolve(HX_CSTRING("y"));		HX_STACK_VAR(_g15,"_g15");
					HX_STACK_LINE(45)
					Dynamic _g16 = ::Std_obj::parseInt(_g15);		HX_STACK_VAR(_g16,"_g16");
					struct _Function_3_1{
						inline static Dynamic Block( ::String &_g11,Dynamic &_g16,::String &_g12,Dynamic &_g14){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/TiledMap.hx",45,0xd576992e)
							{
								hx::Anon __result = hx::Anon_obj::Create();
								__result->Add(HX_CSTRING("name") , _g11,false);
								__result->Add(HX_CSTRING("type") , _g12,false);
								__result->Add(HX_CSTRING("x") , _g14,false);
								__result->Add(HX_CSTRING("y") , _g16,false);
								return __result;
							}
							return null();
						}
					};
					HX_STACK_LINE(45)
					Dynamic _g17 = _Function_3_1::Block(_g11,_g16,_g12,_g14);		HX_STACK_VAR(_g17,"_g17");
					HX_STACK_LINE(45)
					objs->__Field(HX_CSTRING("push"),true)(_g17);
				}
;
			}
			HX_STACK_LINE(47)
			::String _g18 = l->att->resolve(HX_CSTRING("name"));		HX_STACK_VAR(_g18,"_g18");
			struct _Function_2_1{
				inline static Dynamic Block( ::String &_g18,Dynamic &objs){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/TiledMap.hx",46,0xd576992e)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("name") , _g18,false);
						__result->Add(HX_CSTRING("opacity") , 1.,false);
						__result->Add(HX_CSTRING("objects") , objs,false);
						__result->Add(HX_CSTRING("data") , null(),false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(46)
			Dynamic _g19 = _Function_2_1::Block(_g18,objs);		HX_STACK_VAR(_g19,"_g19");
			HX_STACK_LINE(46)
			layers->__Field(HX_CSTRING("push"),true)(_g19);
		}
;
	}
	HX_STACK_LINE(54)
	::String _g20 = x->att->resolve(HX_CSTRING("width"));		HX_STACK_VAR(_g20,"_g20");
	HX_STACK_LINE(54)
	Dynamic _g21 = ::Std_obj::parseInt(_g20);		HX_STACK_VAR(_g21,"_g21");
	HX_STACK_LINE(55)
	::String _g22 = x->att->resolve(HX_CSTRING("height"));		HX_STACK_VAR(_g22,"_g22");
	HX_STACK_LINE(55)
	Dynamic _g23 = ::Std_obj::parseInt(_g22);		HX_STACK_VAR(_g23,"_g23");
	struct _Function_1_1{
		inline static Dynamic Block( Dynamic &layers,Dynamic &_g21,Dynamic &_g23){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/TiledMap.hx",53,0xd576992e)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , _g21,false);
				__result->Add(HX_CSTRING("height") , _g23,false);
				__result->Add(HX_CSTRING("layers") , layers,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(53)
	return _Function_1_1::Block(layers,_g21,_g23);
}


HX_DEFINE_DYNAMIC_FUNC0(TiledMap_obj,toMap,return )


TiledMap_obj::TiledMap_obj()
{
}

Dynamic TiledMap_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"toMap") ) { return toMap_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TiledMap_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void TiledMap_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("toMap"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TiledMap_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TiledMap_obj::__mClass,"__mClass");
};

#endif

Class TiledMap_obj::__mClass;

void TiledMap_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.TiledMap"), hx::TCanCast< TiledMap_obj> ,sStaticFields,sMemberFields,
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

void TiledMap_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
