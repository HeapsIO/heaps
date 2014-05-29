#include <hxcpp.h>

#ifndef INCLUDED_Reflect
#include <Reflect.h>
#endif
#ifndef INCLUDED_StringBuf
#include <StringBuf.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_Xml
#include <Xml.h>
#endif
#ifndef INCLUDED_XmlType
#include <XmlType.h>
#endif
#ifndef INCLUDED_cpp_Lib
#include <cpp/Lib.h>
#endif

Void Xml_obj::__construct()
{
HX_STACK_FRAME("Xml","new",0x2e496e29,"Xml.new","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",41,0x10cdc3e7)
HX_STACK_THIS(this)
{
}
;
	return null();
}

//Xml_obj::~Xml_obj() { }

Dynamic Xml_obj::__CreateEmpty() { return  new Xml_obj; }
hx::ObjectPtr< Xml_obj > Xml_obj::__new()
{  hx::ObjectPtr< Xml_obj > result = new Xml_obj();
	result->__construct();
	return result;}

Dynamic Xml_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Xml_obj > result = new Xml_obj();
	result->__construct();
	return result;}

void Xml_obj::__init__() {
HX_STACK_FRAME("Xml","__init__",0xbec8a6e7,"Xml.__init__","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",403,0x10cdc3e7)
{
	HX_STACK_LINE(404)
	::XmlType _g = ::Type_obj::createEnum(hx::ClassOf< ::XmlType >(),HX_CSTRING("__"),null());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(404)
	::Xml_obj::PCData = _g;
	HX_STACK_LINE(405)
	::XmlType _g1 = ::Type_obj::createEnum(hx::ClassOf< ::XmlType >(),HX_CSTRING("__"),null());		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(405)
	::Xml_obj::Element = _g1;
	HX_STACK_LINE(406)
	::XmlType _g2 = ::Type_obj::createEnum(hx::ClassOf< ::XmlType >(),HX_CSTRING("__"),null());		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(406)
	::Xml_obj::CData = _g2;
	HX_STACK_LINE(407)
	::XmlType _g3 = ::Type_obj::createEnum(hx::ClassOf< ::XmlType >(),HX_CSTRING("__"),null());		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(407)
	::Xml_obj::Comment = _g3;
	HX_STACK_LINE(408)
	::XmlType _g4 = ::Type_obj::createEnum(hx::ClassOf< ::XmlType >(),HX_CSTRING("__"),null());		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(408)
	::Xml_obj::DocType = _g4;
	HX_STACK_LINE(409)
	::XmlType _g5 = ::Type_obj::createEnum(hx::ClassOf< ::XmlType >(),HX_CSTRING("__"),null());		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(409)
	::Xml_obj::ProcessingInstruction = _g5;
	HX_STACK_LINE(410)
	::XmlType _g6 = ::Type_obj::createEnum(hx::ClassOf< ::XmlType >(),HX_CSTRING("__"),null());		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(410)
	::Xml_obj::Document = _g6;
	HX_STACK_LINE(411)
	::__hxcpp_enum_force(::Xml_obj::PCData,HX_CSTRING("pcdata"),(int)0);
	HX_STACK_LINE(412)
	::__hxcpp_enum_force(::Xml_obj::Element,HX_CSTRING("element"),(int)1);
	HX_STACK_LINE(413)
	::__hxcpp_enum_force(::Xml_obj::CData,HX_CSTRING("cdata"),(int)2);
	HX_STACK_LINE(414)
	::__hxcpp_enum_force(::Xml_obj::Comment,HX_CSTRING("comment"),(int)3);
	HX_STACK_LINE(415)
	::__hxcpp_enum_force(::Xml_obj::DocType,HX_CSTRING("doctype"),(int)4);
	HX_STACK_LINE(416)
	::__hxcpp_enum_force(::Xml_obj::ProcessingInstruction,HX_CSTRING("processingInstruction"),(int)5);
	HX_STACK_LINE(417)
	::__hxcpp_enum_force(::Xml_obj::Document,HX_CSTRING("document"),(int)6);
}
}

::String Xml_obj::get_nodeName( ){
	HX_STACK_FRAME("Xml","get_nodeName",0x38fd668d,"Xml.get_nodeName","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",168,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(169)
	if (((this->nodeType != ::Xml_obj::Element))){
		HX_STACK_LINE(170)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
	}
	HX_STACK_LINE(171)
	return this->_nodeName;
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,get_nodeName,return )

::String Xml_obj::set_nodeName( ::String n){
	HX_STACK_FRAME("Xml","set_nodeName",0x4df68a01,"Xml.set_nodeName","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",174,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(n,"n")
	HX_STACK_LINE(175)
	if (((this->nodeType != ::Xml_obj::Element))){
		HX_STACK_LINE(176)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
	}
	HX_STACK_LINE(177)
	return this->_nodeName = n;
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,set_nodeName,return )

::String Xml_obj::get_nodeValue( ){
	HX_STACK_FRAME("Xml","get_nodeValue",0x3ff044ef,"Xml.get_nodeValue","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",180,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(181)
	if (((bool((this->nodeType == ::Xml_obj::Element)) || bool((this->nodeType == ::Xml_obj::Document))))){
		HX_STACK_LINE(182)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
	}
	HX_STACK_LINE(183)
	return this->_nodeValue;
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,get_nodeValue,return )

::String Xml_obj::set_nodeValue( ::String v){
	HX_STACK_FRAME("Xml","set_nodeValue",0x84f626fb,"Xml.set_nodeValue","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",186,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(187)
	if (((bool((this->nodeType == ::Xml_obj::Element)) || bool((this->nodeType == ::Xml_obj::Document))))){
		HX_STACK_LINE(188)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
	}
	HX_STACK_LINE(189)
	return this->_nodeValue = v;
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,set_nodeValue,return )

::Xml Xml_obj::get_parent( ){
	HX_STACK_FRAME("Xml","get_parent",0x6149124a,"Xml.get_parent","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",194,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(194)
	return this->_parent;
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,get_parent,return )

::String Xml_obj::get( ::String att){
	HX_STACK_FRAME("Xml","get",0x2e441e5f,"Xml.get","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",197,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(att,"att")
	HX_STACK_LINE(198)
	if (((this->nodeType != ::Xml_obj::Element))){
		HX_STACK_LINE(199)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
	}
	HX_STACK_LINE(200)
	return ::Reflect_obj::field(this->_attributes,att);
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,get,return )

Void Xml_obj::set( ::String att,::String value){
{
		HX_STACK_FRAME("Xml","set",0x2e4d396b,"Xml.set","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",203,0x10cdc3e7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(att,"att")
		HX_STACK_ARG(value,"value")
		HX_STACK_LINE(204)
		if (((this->nodeType != ::Xml_obj::Element))){
			HX_STACK_LINE(205)
			HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
		}
		HX_STACK_LINE(206)
		if (((this->_attributes == null()))){
			struct _Function_2_1{
				inline static Dynamic Block( ){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",207,0x10cdc3e7)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(207)
			this->_attributes = _Function_2_1::Block();
		}
		HX_STACK_LINE(208)
		{
			HX_STACK_LINE(208)
			Dynamic o = this->_attributes;		HX_STACK_VAR(o,"o");
			HX_STACK_LINE(208)
			if (((o != null()))){
				HX_STACK_LINE(208)
				o->__SetField(att,value,false);
			}
		}
		HX_STACK_LINE(209)
		return null(null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Xml_obj,set,(void))

Void Xml_obj::remove( ::String att){
{
		HX_STACK_FRAME("Xml","remove",0x890f021b,"Xml.remove","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",212,0x10cdc3e7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(att,"att")
		HX_STACK_LINE(213)
		if (((this->nodeType != ::Xml_obj::Element))){
			HX_STACK_LINE(214)
			HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
		}
		HX_STACK_LINE(215)
		::Reflect_obj::deleteField(this->_attributes,att);
		HX_STACK_LINE(216)
		return null(null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,remove,(void))

bool Xml_obj::exists( ::String att){
	HX_STACK_FRAME("Xml","exists",0x446683b3,"Xml.exists","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",219,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(att,"att")
	HX_STACK_LINE(220)
	if (((this->nodeType != ::Xml_obj::Element))){
		HX_STACK_LINE(221)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
	}
	HX_STACK_LINE(222)
	return ::Reflect_obj::hasField(this->_attributes,att);
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,exists,return )

Dynamic Xml_obj::attributes( ){
	HX_STACK_FRAME("Xml","attributes",0x1ab5462e,"Xml.attributes","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",225,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(226)
	if (((this->nodeType != ::Xml_obj::Element))){
		HX_STACK_LINE(227)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodeType"));
	}
	HX_STACK_LINE(228)
	return ::Reflect_obj::fields(this->_attributes)->iterator();
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,attributes,return )

Dynamic Xml_obj::iterator( ){
	HX_STACK_FRAME("Xml","iterator",0x12e71385,"Xml.iterator","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",231,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(232)
	if (((this->_children == null()))){
		HX_STACK_LINE(233)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
	}
	HX_STACK_LINE(234)
	return this->_children->iteratorFast< ::Xml >();
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,iterator,return )

Dynamic Xml_obj::elements( ){
	HX_STACK_FRAME("Xml","elements",0x0310ffce,"Xml.elements","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",238,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(239)
	if (((this->_children == null()))){
		HX_STACK_LINE(240)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
	}
	HX_STACK_LINE(241)
	Array< ::Dynamic > children = Array_obj< ::Dynamic >::__new().Add(this->_children);		HX_STACK_VAR(children,"children");
	struct _Function_1_1{
		inline static Dynamic Block( Array< ::Dynamic > &children){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",242,0x10cdc3e7)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("cur") , (int)0,false);

				HX_BEGIN_LOCAL_FUNC_S1(hx::LocalThisFunc,_Function_2_1,Array< ::Dynamic >,children)
				bool run(){
					HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",244,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					{
						HX_STACK_LINE(245)
						int k = __this->__Field(HX_CSTRING("cur"),true);		HX_STACK_VAR(k,"k");
						HX_STACK_LINE(246)
						int l = children->__get((int)0).StaticCast< Array< ::Dynamic > >()->length;		HX_STACK_VAR(l,"l");
						HX_STACK_LINE(247)
						while(((k < l))){
							HX_STACK_LINE(248)
							if (((children->__get((int)0).StaticCast< Array< ::Dynamic > >()->__get(k).StaticCast< ::Xml >()->nodeType == ::Xml_obj::Element))){
								HX_STACK_LINE(249)
								break;
							}
							HX_STACK_LINE(250)
							hx::AddEq(k,(int)1);
						}
						HX_STACK_LINE(252)
						__this->__FieldRef(HX_CSTRING("cur")) = k;
						HX_STACK_LINE(253)
						return (k < l);
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("hasNext") ,  Dynamic(new _Function_2_1(children)),true);

				HX_BEGIN_LOCAL_FUNC_S1(hx::LocalThisFunc,_Function_2_2,Array< ::Dynamic >,children)
				::Xml run(){
					HX_STACK_FRAME("*","_Function_2_2",0x5201af79,"*._Function_2_2","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",255,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					{
						HX_STACK_LINE(256)
						int k = __this->__Field(HX_CSTRING("cur"),true);		HX_STACK_VAR(k,"k");
						HX_STACK_LINE(257)
						int l = children->__get((int)0).StaticCast< Array< ::Dynamic > >()->length;		HX_STACK_VAR(l,"l");
						HX_STACK_LINE(258)
						while(((k < l))){
							HX_STACK_LINE(259)
							::Xml n = children->__get((int)0).StaticCast< Array< ::Dynamic > >()->__get(k).StaticCast< ::Xml >();		HX_STACK_VAR(n,"n");
							HX_STACK_LINE(260)
							hx::AddEq(k,(int)1);
							HX_STACK_LINE(261)
							if (((n->nodeType == ::Xml_obj::Element))){
								HX_STACK_LINE(262)
								__this->__FieldRef(HX_CSTRING("cur")) = k;
								HX_STACK_LINE(263)
								return n;
							}
						}
						HX_STACK_LINE(266)
						return null();
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("next") ,  Dynamic(new _Function_2_2(children)),true);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(242)
	return _Function_1_1::Block(children);
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,elements,return )

Dynamic Xml_obj::elementsNamed( ::String name){
	HX_STACK_FRAME("Xml","elementsNamed",0x6b28f50b,"Xml.elementsNamed","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",271,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(271)
	Array< ::String > name1 = Array_obj< ::String >::__new().Add(name);		HX_STACK_VAR(name1,"name1");
	HX_STACK_LINE(272)
	if (((this->_children == null()))){
		HX_STACK_LINE(273)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
	}
	HX_STACK_LINE(274)
	Array< ::Dynamic > children = Array_obj< ::Dynamic >::__new().Add(this->_children);		HX_STACK_VAR(children,"children");
	struct _Function_1_1{
		inline static Dynamic Block( Array< ::Dynamic > &children,Array< ::String > &name1){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",275,0x10cdc3e7)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("cur") , (int)0,false);

				HX_BEGIN_LOCAL_FUNC_S2(hx::LocalThisFunc,_Function_2_1,Array< ::Dynamic >,children,Array< ::String >,name1)
				bool run(){
					HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",277,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					{
						HX_STACK_LINE(278)
						int k = __this->__Field(HX_CSTRING("cur"),true);		HX_STACK_VAR(k,"k");
						HX_STACK_LINE(279)
						int l = children->__get((int)0).StaticCast< Array< ::Dynamic > >()->length;		HX_STACK_VAR(l,"l");
						HX_STACK_LINE(280)
						while(((k < l))){
							HX_STACK_LINE(281)
							::Xml n = children->__get((int)0).StaticCast< Array< ::Dynamic > >()->__get(k).StaticCast< ::Xml >();		HX_STACK_VAR(n,"n");
							HX_STACK_LINE(282)
							if (((bool((n->nodeType == ::Xml_obj::Element)) && bool((n->_nodeName == name1->__get((int)0)))))){
								HX_STACK_LINE(283)
								break;
							}
							HX_STACK_LINE(284)
							(k)++;
						}
						HX_STACK_LINE(286)
						__this->__FieldRef(HX_CSTRING("cur")) = k;
						HX_STACK_LINE(287)
						return (k < l);
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("hasNext") ,  Dynamic(new _Function_2_1(children,name1)),true);

				HX_BEGIN_LOCAL_FUNC_S2(hx::LocalThisFunc,_Function_2_2,Array< ::Dynamic >,children,Array< ::String >,name1)
				::Xml run(){
					HX_STACK_FRAME("*","_Function_2_2",0x5201af79,"*._Function_2_2","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",289,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					{
						HX_STACK_LINE(290)
						int k = __this->__Field(HX_CSTRING("cur"),true);		HX_STACK_VAR(k,"k");
						HX_STACK_LINE(291)
						int l = children->__get((int)0).StaticCast< Array< ::Dynamic > >()->length;		HX_STACK_VAR(l,"l");
						HX_STACK_LINE(292)
						while(((k < l))){
							HX_STACK_LINE(293)
							::Xml n = children->__get((int)0).StaticCast< Array< ::Dynamic > >()->__get(k).StaticCast< ::Xml >();		HX_STACK_VAR(n,"n");
							HX_STACK_LINE(294)
							(k)++;
							HX_STACK_LINE(295)
							if (((bool((n->nodeType == ::Xml_obj::Element)) && bool((n->_nodeName == name1->__get((int)0)))))){
								HX_STACK_LINE(296)
								__this->__FieldRef(HX_CSTRING("cur")) = k;
								HX_STACK_LINE(297)
								return n;
							}
						}
						HX_STACK_LINE(300)
						return null();
					}
					return null();
				}
				HX_END_LOCAL_FUNC0(return)

				__result->Add(HX_CSTRING("next") ,  Dynamic(new _Function_2_2(children,name1)),true);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(275)
	return _Function_1_1::Block(children,name1);
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,elementsNamed,return )

::Xml Xml_obj::firstChild( ){
	HX_STACK_FRAME("Xml","firstChild",0x06db90a3,"Xml.firstChild","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",305,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(306)
	if (((this->_children == null()))){
		HX_STACK_LINE(307)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
	}
	HX_STACK_LINE(308)
	return this->_children->__get((int)0).StaticCast< ::Xml >();
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,firstChild,return )

::Xml Xml_obj::firstElement( ){
	HX_STACK_FRAME("Xml","firstElement",0xc103a583,"Xml.firstElement","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",311,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(312)
	if (((this->_children == null()))){
		HX_STACK_LINE(313)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
	}
	HX_STACK_LINE(314)
	{
		HX_STACK_LINE(314)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(314)
		int _g = this->_children->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(314)
		while((true)){
			HX_STACK_LINE(314)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(314)
				break;
			}
			HX_STACK_LINE(314)
			int cur = (_g1)++;		HX_STACK_VAR(cur,"cur");
			HX_STACK_LINE(315)
			::Xml n = this->_children->__get(cur).StaticCast< ::Xml >();		HX_STACK_VAR(n,"n");
			HX_STACK_LINE(316)
			if (((n->nodeType == ::Xml_obj::Element))){
				HX_STACK_LINE(317)
				return n;
			}
		}
	}
	HX_STACK_LINE(319)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,firstElement,return )

Void Xml_obj::addChild( ::Xml x){
{
		HX_STACK_FRAME("Xml","addChild",0x3e639952,"Xml.addChild","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",322,0x10cdc3e7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(323)
		if (((this->_children == null()))){
			HX_STACK_LINE(324)
			HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
		}
		HX_STACK_LINE(325)
		if (((x->_parent != null()))){
			HX_STACK_LINE(325)
			x->_parent->_children->remove(x);
		}
		HX_STACK_LINE(326)
		x->_parent = hx::ObjectPtr<OBJ_>(this);
		HX_STACK_LINE(327)
		this->_children->push(x);
		HX_STACK_LINE(328)
		return null(null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,addChild,(void))

bool Xml_obj::removeChild( ::Xml x){
	HX_STACK_FRAME("Xml","removeChild",0x9bd39581,"Xml.removeChild","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",331,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_LINE(332)
	if (((this->_children == null()))){
		HX_STACK_LINE(333)
		HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
	}
	HX_STACK_LINE(334)
	bool b = this->_children->remove(x);		HX_STACK_VAR(b,"b");
	HX_STACK_LINE(335)
	if ((b)){
		HX_STACK_LINE(335)
		x->_parent = null();
	}
	HX_STACK_LINE(336)
	return b;
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,removeChild,return )

Void Xml_obj::insertChild( ::Xml x,int pos){
{
		HX_STACK_FRAME("Xml","insertChild",0xe554966c,"Xml.insertChild","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",339,0x10cdc3e7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(pos,"pos")
		HX_STACK_LINE(340)
		if (((this->_children == null()))){
			HX_STACK_LINE(341)
			HX_STACK_DO_THROW(HX_CSTRING("bad nodetype"));
		}
		HX_STACK_LINE(342)
		if (((x->_parent != null()))){
			HX_STACK_LINE(342)
			x->_parent->_children->remove(x);
		}
		HX_STACK_LINE(343)
		x->_parent = hx::ObjectPtr<OBJ_>(this);
		HX_STACK_LINE(344)
		this->_children->insert(pos,x);
		HX_STACK_LINE(345)
		return null(null());
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Xml_obj,insertChild,(void))

::String Xml_obj::toString( ){
	HX_STACK_FRAME("Xml","toString",0xb7bb9a43,"Xml.toString","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",348,0x10cdc3e7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(349)
	::StringBuf s = ::StringBuf_obj::__new();		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(350)
	this->toStringRec(s);
	HX_STACK_LINE(351)
	return s->b->join(HX_CSTRING(""));
}


HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,toString,return )

Void Xml_obj::toStringRec( ::StringBuf s){
{
		HX_STACK_FRAME("Xml","toStringRec",0x868882cd,"Xml.toStringRec","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",355,0x10cdc3e7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(355)
		::XmlType _switch_1 = (this->nodeType);
		if (  ( _switch_1==::Xml_obj::Document)){
			HX_STACK_LINE(357)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(357)
			Array< ::Dynamic > _g1 = this->_children;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(357)
			while((true)){
				HX_STACK_LINE(357)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(357)
					break;
				}
				HX_STACK_LINE(357)
				::Xml x = _g1->__get(_g).StaticCast< ::Xml >();		HX_STACK_VAR(x,"x");
				HX_STACK_LINE(357)
				++(_g);
				HX_STACK_LINE(358)
				x->toStringRec(s);
			}
		}
		else if (  ( _switch_1==::Xml_obj::Element)){
			HX_STACK_LINE(360)
			{
				HX_STACK_LINE(360)
				::String _g = HX_CSTRING("<");		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(360)
				s->b->push(_g);
			}
			HX_STACK_LINE(361)
			s->add(this->_nodeName);
			HX_STACK_LINE(362)
			{
				HX_STACK_LINE(362)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(362)
				Array< ::String > _g1 = ::Reflect_obj::fields(this->_attributes);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(362)
				while((true)){
					HX_STACK_LINE(362)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(362)
						break;
					}
					HX_STACK_LINE(362)
					::String k = _g1->__get(_g);		HX_STACK_VAR(k,"k");
					HX_STACK_LINE(362)
					++(_g);
					HX_STACK_LINE(363)
					{
						HX_STACK_LINE(363)
						::String _g11 = HX_CSTRING(" ");		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(363)
						s->b->push(_g11);
					}
					HX_STACK_LINE(364)
					s->add(k);
					HX_STACK_LINE(365)
					{
						HX_STACK_LINE(365)
						::String _g2 = HX_CSTRING("=");		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(365)
						s->b->push(_g2);
					}
					HX_STACK_LINE(366)
					{
						HX_STACK_LINE(366)
						::String _g3 = HX_CSTRING("\"");		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(366)
						s->b->push(_g3);
					}
					HX_STACK_LINE(367)
					Dynamic _g4 = ::Reflect_obj::field(this->_attributes,k);		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(367)
					s->add(_g4);
					HX_STACK_LINE(368)
					{
						HX_STACK_LINE(368)
						::String _g5 = HX_CSTRING("\"");		HX_STACK_VAR(_g5,"_g5");
						HX_STACK_LINE(368)
						s->b->push(_g5);
					}
				}
			}
			HX_STACK_LINE(370)
			if (((this->_children->length == (int)0))){
				HX_STACK_LINE(371)
				{
					HX_STACK_LINE(371)
					::String _g6 = HX_CSTRING("/");		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(371)
					s->b->push(_g6);
				}
				HX_STACK_LINE(372)
				{
					HX_STACK_LINE(372)
					::String _g7 = HX_CSTRING(">");		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(372)
					s->b->push(_g7);
				}
				HX_STACK_LINE(373)
				return null();
			}
			HX_STACK_LINE(375)
			{
				HX_STACK_LINE(375)
				::String _g8 = HX_CSTRING(">");		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(375)
				s->b->push(_g8);
			}
			HX_STACK_LINE(376)
			{
				HX_STACK_LINE(376)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(376)
				Array< ::Dynamic > _g1 = this->_children;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(376)
				while((true)){
					HX_STACK_LINE(376)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(376)
						break;
					}
					HX_STACK_LINE(376)
					::Xml x = _g1->__get(_g).StaticCast< ::Xml >();		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(376)
					++(_g);
					HX_STACK_LINE(377)
					x->toStringRec(s);
				}
			}
			HX_STACK_LINE(378)
			{
				HX_STACK_LINE(378)
				::String _g9 = HX_CSTRING("<");		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(378)
				s->b->push(_g9);
			}
			HX_STACK_LINE(379)
			{
				HX_STACK_LINE(379)
				::String _g10 = HX_CSTRING("/");		HX_STACK_VAR(_g10,"_g10");
				HX_STACK_LINE(379)
				s->b->push(_g10);
			}
			HX_STACK_LINE(380)
			s->add(this->_nodeName);
			HX_STACK_LINE(381)
			{
				HX_STACK_LINE(381)
				::String _g11 = HX_CSTRING(">");		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(381)
				s->b->push(_g11);
			}
		}
		else if (  ( _switch_1==::Xml_obj::PCData)){
			HX_STACK_LINE(383)
			::String _g12 = ::StringTools_obj::htmlEscape(this->_nodeValue,null());		HX_STACK_VAR(_g12,"_g12");
			HX_STACK_LINE(383)
			s->add(_g12);
		}
		else if (  ( _switch_1==::Xml_obj::CData)){
			HX_STACK_LINE(385)
			s->add(HX_CSTRING("<![CDATA["));
			HX_STACK_LINE(386)
			s->add(this->_nodeValue);
			HX_STACK_LINE(387)
			s->add(HX_CSTRING("]]>"));
		}
		else if (  ( _switch_1==::Xml_obj::Comment)){
			HX_STACK_LINE(389)
			s->add(HX_CSTRING("<!--"));
			HX_STACK_LINE(390)
			s->add(this->_nodeValue);
			HX_STACK_LINE(391)
			s->add(HX_CSTRING("-->"));
		}
		else if (  ( _switch_1==::Xml_obj::DocType)){
			HX_STACK_LINE(393)
			s->add(HX_CSTRING("<!DOCTYPE "));
			HX_STACK_LINE(394)
			s->add(this->_nodeValue);
			HX_STACK_LINE(395)
			s->add(HX_CSTRING(">"));
		}
		else if (  ( _switch_1==::Xml_obj::ProcessingInstruction)){
			HX_STACK_LINE(397)
			s->add(HX_CSTRING("<?"));
			HX_STACK_LINE(398)
			s->add(this->_nodeValue);
			HX_STACK_LINE(399)
			s->add(HX_CSTRING("?>"));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,toStringRec,(void))

::XmlType Xml_obj::Element;

::XmlType Xml_obj::PCData;

::XmlType Xml_obj::CData;

::XmlType Xml_obj::Comment;

::XmlType Xml_obj::DocType;

::XmlType Xml_obj::ProcessingInstruction;

::XmlType Xml_obj::Document;

Dynamic Xml_obj::_parse;

::Xml Xml_obj::parse( ::String str){
	HX_STACK_FRAME("Xml","parse",0x8a44f23c,"Xml.parse","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",46,0x10cdc3e7)
	HX_STACK_ARG(str,"str")
	HX_STACK_LINE(47)
	::Xml x = ::Xml_obj::__new();		HX_STACK_VAR(x,"x");
	HX_STACK_LINE(48)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(48)
	x->_children = _g;
	struct _Function_1_1{
		inline static Dynamic Block( ::Xml &x){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",49,0x10cdc3e7)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("cur") , x,false);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_1)
				Void run(::String name,Dynamic att){
					HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",51,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					HX_STACK_ARG(name,"name")
					HX_STACK_ARG(att,"att")
					{
						HX_STACK_LINE(52)
						::Xml x1 = ::Xml_obj::__new();		HX_STACK_VAR(x1,"x1");
						HX_STACK_LINE(53)
						x1->_parent = __this->__Field(HX_CSTRING("cur"),true);
						HX_STACK_LINE(54)
						x1->nodeType = ::Xml_obj::Element;
						HX_STACK_LINE(55)
						x1->_nodeName = ::String(name);
						HX_STACK_LINE(56)
						x1->_attributes = att;
						HX_STACK_LINE(57)
						x1->_children = Array_obj< ::Dynamic >::__new();
						HX_STACK_LINE(58)
						{
							HX_STACK_LINE(59)
							int i = (int)0;		HX_STACK_VAR(i,"i");
							HX_STACK_LINE(60)
							__this->__Field(HX_CSTRING("cur"),true)->__Field(HX_CSTRING("addChild"),true)(x1);
							HX_STACK_LINE(61)
							__this->__FieldRef(HX_CSTRING("cur")) = x1;
						}
					}
					return null();
				}
				HX_END_LOCAL_FUNC2((void))

				__result->Add(HX_CSTRING("xml") ,  Dynamic(new _Function_2_1()),true);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_2)
				Void run(::String text){
					HX_STACK_FRAME("*","_Function_2_2",0x5201af79,"*._Function_2_2","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",64,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					HX_STACK_ARG(text,"text")
					{
						HX_STACK_LINE(65)
						::Xml x1 = ::Xml_obj::__new();		HX_STACK_VAR(x1,"x1");
						HX_STACK_LINE(66)
						x1->_parent = __this->__Field(HX_CSTRING("cur"),true);
						HX_STACK_LINE(67)
						x1->nodeType = ::Xml_obj::CData;
						HX_STACK_LINE(68)
						x1->_nodeValue = ::String(text);
						HX_STACK_LINE(69)
						__this->__Field(HX_CSTRING("cur"),true)->__Field(HX_CSTRING("addChild"),true)(x1);
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				__result->Add(HX_CSTRING("cdata") ,  Dynamic(new _Function_2_2()),true);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_3)
				Void run(::String text){
					HX_STACK_FRAME("*","_Function_2_3",0x5201af7a,"*._Function_2_3","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",71,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					HX_STACK_ARG(text,"text")
					{
						HX_STACK_LINE(72)
						::Xml x1 = ::Xml_obj::__new();		HX_STACK_VAR(x1,"x1");
						HX_STACK_LINE(73)
						x1->_parent = __this->__Field(HX_CSTRING("cur"),true);
						HX_STACK_LINE(74)
						x1->nodeType = ::Xml_obj::PCData;
						HX_STACK_LINE(75)
						x1->_nodeValue = ::String(text);
						HX_STACK_LINE(76)
						__this->__Field(HX_CSTRING("cur"),true)->__Field(HX_CSTRING("addChild"),true)(x1);
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				__result->Add(HX_CSTRING("pcdata") ,  Dynamic(new _Function_2_3()),true);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_4)
				Void run(::String text){
					HX_STACK_FRAME("*","_Function_2_4",0x5201af7b,"*._Function_2_4","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",78,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					HX_STACK_ARG(text,"text")
					{
						HX_STACK_LINE(79)
						::Xml x1 = ::Xml_obj::__new();		HX_STACK_VAR(x1,"x1");
						HX_STACK_LINE(80)
						x1->_parent = __this->__Field(HX_CSTRING("cur"),true);
						HX_STACK_LINE(81)
						if (((text.cca((int)0) == (int)63))){
							HX_STACK_LINE(82)
							x1->nodeType = ::Xml_obj::ProcessingInstruction;
							HX_STACK_LINE(83)
							text = ::String(text);
							HX_STACK_LINE(84)
							text = text.substr((int)1,(text.length - (int)2));
						}
						else{
							HX_STACK_LINE(86)
							x1->nodeType = ::Xml_obj::Comment;
							HX_STACK_LINE(87)
							text = ::String(text);
						}
						HX_STACK_LINE(89)
						x1->_nodeValue = text;
						HX_STACK_LINE(90)
						__this->__Field(HX_CSTRING("cur"),true)->__Field(HX_CSTRING("addChild"),true)(x1);
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				__result->Add(HX_CSTRING("comment") ,  Dynamic(new _Function_2_4()),true);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_5)
				Void run(::String text){
					HX_STACK_FRAME("*","_Function_2_5",0x5201af7c,"*._Function_2_5","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",92,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					HX_STACK_ARG(text,"text")
					{
						HX_STACK_LINE(93)
						::Xml x1 = ::Xml_obj::__new();		HX_STACK_VAR(x1,"x1");
						HX_STACK_LINE(94)
						x1->_parent = __this->__Field(HX_CSTRING("cur"),true);
						HX_STACK_LINE(95)
						x1->nodeType = ::Xml_obj::DocType;
						HX_STACK_LINE(96)
						x1->_nodeValue = ::String(text).substr((int)1,null());
						HX_STACK_LINE(97)
						::Xml p = __this->__Field(HX_CSTRING("cur"),true);		HX_STACK_VAR(p,"p");
						HX_STACK_LINE(98)
						p->addChild(x1);
					}
					return null();
				}
				HX_END_LOCAL_FUNC1((void))

				__result->Add(HX_CSTRING("doctype") ,  Dynamic(new _Function_2_5()),true);

				HX_BEGIN_LOCAL_FUNC_S0(hx::LocalThisFunc,_Function_2_6)
				Void run(){
					HX_STACK_FRAME("*","_Function_2_6",0x5201af7d,"*._Function_2_6","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",101,0x10cdc3e7)
					HX_STACK_THIS(__this.mPtr)
					{
						HX_STACK_LINE(101)
						__this->__FieldRef(HX_CSTRING("cur")) = __this->__Field(HX_CSTRING("cur"),true)->__Field(HX_CSTRING("_parent"),true);
					}
					return null();
				}
				HX_END_LOCAL_FUNC0((void))

				__result->Add(HX_CSTRING("done") ,  Dynamic(new _Function_2_6()),true);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(49)
	Dynamic parser = _Function_1_1::Block(x);		HX_STACK_VAR(parser,"parser");
	HX_STACK_LINE(104)
	::Xml_obj::_parse(str,parser);
	HX_STACK_LINE(105)
	x->nodeType = ::Xml_obj::Document;
	HX_STACK_LINE(106)
	return x;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,parse,return )

::Xml Xml_obj::createElement( ::String name){
	HX_STACK_FRAME("Xml","createElement",0x97359a29,"Xml.createElement","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",110,0x10cdc3e7)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(111)
	::Xml r = ::Xml_obj::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(112)
	r->nodeType = ::Xml_obj::Element;
	HX_STACK_LINE(113)
	r->_nodeName = name;
	HX_STACK_LINE(114)
	r->_attributes = null();
	HX_STACK_LINE(115)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(115)
	r->_children = _g;
	HX_STACK_LINE(116)
	return r;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,createElement,return )

::Xml Xml_obj::createPCData( ::String data){
	HX_STACK_FRAME("Xml","createPCData",0x3cc9ead0,"Xml.createPCData","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",119,0x10cdc3e7)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(120)
	::Xml r = ::Xml_obj::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(121)
	r->nodeType = ::Xml_obj::PCData;
	HX_STACK_LINE(122)
	r->_nodeValue = data;
	HX_STACK_LINE(123)
	return r;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,createPCData,return )

::Xml Xml_obj::createCData( ::String data){
	HX_STACK_FRAME("Xml","createCData",0xaf49365a,"Xml.createCData","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",126,0x10cdc3e7)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(127)
	::Xml r = ::Xml_obj::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(128)
	r->nodeType = ::Xml_obj::CData;
	HX_STACK_LINE(129)
	r->_nodeValue = data;
	HX_STACK_LINE(130)
	return r;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,createCData,return )

::Xml Xml_obj::createComment( ::String data){
	HX_STACK_FRAME("Xml","createComment",0x125165cc,"Xml.createComment","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",133,0x10cdc3e7)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(134)
	::Xml r = ::Xml_obj::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(135)
	r->nodeType = ::Xml_obj::Comment;
	HX_STACK_LINE(136)
	r->_nodeValue = data;
	HX_STACK_LINE(137)
	return r;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,createComment,return )

::Xml Xml_obj::createDocType( ::String data){
	HX_STACK_FRAME("Xml","createDocType",0x696de8bf,"Xml.createDocType","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",140,0x10cdc3e7)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(141)
	::Xml r = ::Xml_obj::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(142)
	r->nodeType = ::Xml_obj::DocType;
	HX_STACK_LINE(143)
	r->_nodeValue = data;
	HX_STACK_LINE(144)
	return r;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,createDocType,return )

::Xml Xml_obj::createProcessingInstruction( ::String data){
	HX_STACK_FRAME("Xml","createProcessingInstruction",0x632a1f28,"Xml.createProcessingInstruction","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",147,0x10cdc3e7)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(148)
	::Xml r = ::Xml_obj::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(149)
	r->nodeType = ::Xml_obj::ProcessingInstruction;
	HX_STACK_LINE(150)
	r->_nodeValue = data;
	HX_STACK_LINE(151)
	return r;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Xml_obj,createProcessingInstruction,return )

::Xml Xml_obj::createDocument( ){
	HX_STACK_FRAME("Xml","createDocument",0xcf00030e,"Xml.createDocument","D:\\Workspace\\motionTools\\haxe3\\std/cpp/_std/Xml.hx",154,0x10cdc3e7)
	HX_STACK_LINE(155)
	::Xml r = ::Xml_obj::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(156)
	r->nodeType = ::Xml_obj::Document;
	HX_STACK_LINE(157)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(157)
	r->_children = _g;
	HX_STACK_LINE(158)
	return r;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Xml_obj,createDocument,return )


Xml_obj::Xml_obj()
{
}

void Xml_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Xml);
	HX_MARK_MEMBER_NAME(_nodeName,"_nodeName");
	HX_MARK_MEMBER_NAME(_nodeValue,"_nodeValue");
	HX_MARK_MEMBER_NAME(_attributes,"_attributes");
	HX_MARK_MEMBER_NAME(_children,"_children");
	HX_MARK_MEMBER_NAME(_parent,"_parent");
	HX_MARK_MEMBER_NAME(nodeType,"nodeType");
	HX_MARK_MEMBER_NAME(parent,"parent");
	HX_MARK_END_CLASS();
}

void Xml_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(_nodeName,"_nodeName");
	HX_VISIT_MEMBER_NAME(_nodeValue,"_nodeValue");
	HX_VISIT_MEMBER_NAME(_attributes,"_attributes");
	HX_VISIT_MEMBER_NAME(_children,"_children");
	HX_VISIT_MEMBER_NAME(_parent,"_parent");
	HX_VISIT_MEMBER_NAME(nodeType,"nodeType");
	HX_VISIT_MEMBER_NAME(parent,"parent");
}

Dynamic Xml_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		if (HX_FIELD_EQ(inName,"set") ) { return set_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"CData") ) { return CData; }
		if (HX_FIELD_EQ(inName,"parse") ) { return parse_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"PCData") ) { return PCData; }
		if (HX_FIELD_EQ(inName,"_parse") ) { return _parse; }
		if (HX_FIELD_EQ(inName,"parent") ) { return inCallProp ? get_parent() : parent; }
		if (HX_FIELD_EQ(inName,"remove") ) { return remove_dyn(); }
		if (HX_FIELD_EQ(inName,"exists") ) { return exists_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"Element") ) { return Element; }
		if (HX_FIELD_EQ(inName,"Comment") ) { return Comment; }
		if (HX_FIELD_EQ(inName,"DocType") ) { return DocType; }
		if (HX_FIELD_EQ(inName,"_parent") ) { return _parent; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"Document") ) { return Document; }
		if (HX_FIELD_EQ(inName,"nodeType") ) { return nodeType; }
		if (HX_FIELD_EQ(inName,"nodeName") ) { return get_nodeName(); }
		if (HX_FIELD_EQ(inName,"iterator") ) { return iterator_dyn(); }
		if (HX_FIELD_EQ(inName,"elements") ) { return elements_dyn(); }
		if (HX_FIELD_EQ(inName,"addChild") ) { return addChild_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"_nodeName") ) { return _nodeName; }
		if (HX_FIELD_EQ(inName,"_children") ) { return _children; }
		if (HX_FIELD_EQ(inName,"nodeValue") ) { return get_nodeValue(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"_nodeValue") ) { return _nodeValue; }
		if (HX_FIELD_EQ(inName,"get_parent") ) { return get_parent_dyn(); }
		if (HX_FIELD_EQ(inName,"attributes") ) { return attributes_dyn(); }
		if (HX_FIELD_EQ(inName,"firstChild") ) { return firstChild_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"createCData") ) { return createCData_dyn(); }
		if (HX_FIELD_EQ(inName,"_attributes") ) { return _attributes; }
		if (HX_FIELD_EQ(inName,"removeChild") ) { return removeChild_dyn(); }
		if (HX_FIELD_EQ(inName,"insertChild") ) { return insertChild_dyn(); }
		if (HX_FIELD_EQ(inName,"toStringRec") ) { return toStringRec_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"createPCData") ) { return createPCData_dyn(); }
		if (HX_FIELD_EQ(inName,"get_nodeName") ) { return get_nodeName_dyn(); }
		if (HX_FIELD_EQ(inName,"set_nodeName") ) { return set_nodeName_dyn(); }
		if (HX_FIELD_EQ(inName,"firstElement") ) { return firstElement_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"createElement") ) { return createElement_dyn(); }
		if (HX_FIELD_EQ(inName,"createComment") ) { return createComment_dyn(); }
		if (HX_FIELD_EQ(inName,"createDocType") ) { return createDocType_dyn(); }
		if (HX_FIELD_EQ(inName,"get_nodeValue") ) { return get_nodeValue_dyn(); }
		if (HX_FIELD_EQ(inName,"set_nodeValue") ) { return set_nodeValue_dyn(); }
		if (HX_FIELD_EQ(inName,"elementsNamed") ) { return elementsNamed_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"createDocument") ) { return createDocument_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"ProcessingInstruction") ) { return ProcessingInstruction; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"createProcessingInstruction") ) { return createProcessingInstruction_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Xml_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"CData") ) { CData=inValue.Cast< ::XmlType >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"PCData") ) { PCData=inValue.Cast< ::XmlType >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_parse") ) { _parse=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"parent") ) { parent=inValue.Cast< ::Xml >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"Element") ) { Element=inValue.Cast< ::XmlType >(); return inValue; }
		if (HX_FIELD_EQ(inName,"Comment") ) { Comment=inValue.Cast< ::XmlType >(); return inValue; }
		if (HX_FIELD_EQ(inName,"DocType") ) { DocType=inValue.Cast< ::XmlType >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_parent") ) { _parent=inValue.Cast< ::Xml >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"Document") ) { Document=inValue.Cast< ::XmlType >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nodeType") ) { nodeType=inValue.Cast< ::XmlType >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nodeName") ) { return set_nodeName(inValue); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"_nodeName") ) { _nodeName=inValue.Cast< ::String >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_children") ) { _children=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"nodeValue") ) { return set_nodeValue(inValue); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"_nodeValue") ) { _nodeValue=inValue.Cast< ::String >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"_attributes") ) { _attributes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"ProcessingInstruction") ) { ProcessingInstruction=inValue.Cast< ::XmlType >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Xml_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("_nodeName"));
	outFields->push(HX_CSTRING("_nodeValue"));
	outFields->push(HX_CSTRING("_attributes"));
	outFields->push(HX_CSTRING("_children"));
	outFields->push(HX_CSTRING("_parent"));
	outFields->push(HX_CSTRING("nodeType"));
	outFields->push(HX_CSTRING("nodeName"));
	outFields->push(HX_CSTRING("nodeValue"));
	outFields->push(HX_CSTRING("parent"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("Element"),
	HX_CSTRING("PCData"),
	HX_CSTRING("CData"),
	HX_CSTRING("Comment"),
	HX_CSTRING("DocType"),
	HX_CSTRING("ProcessingInstruction"),
	HX_CSTRING("Document"),
	HX_CSTRING("_parse"),
	HX_CSTRING("parse"),
	HX_CSTRING("createElement"),
	HX_CSTRING("createPCData"),
	HX_CSTRING("createCData"),
	HX_CSTRING("createComment"),
	HX_CSTRING("createDocType"),
	HX_CSTRING("createProcessingInstruction"),
	HX_CSTRING("createDocument"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsString,(int)offsetof(Xml_obj,_nodeName),HX_CSTRING("_nodeName")},
	{hx::fsString,(int)offsetof(Xml_obj,_nodeValue),HX_CSTRING("_nodeValue")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Xml_obj,_attributes),HX_CSTRING("_attributes")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Xml_obj,_children),HX_CSTRING("_children")},
	{hx::fsObject /*::Xml*/ ,(int)offsetof(Xml_obj,_parent),HX_CSTRING("_parent")},
	{hx::fsObject /*::XmlType*/ ,(int)offsetof(Xml_obj,nodeType),HX_CSTRING("nodeType")},
	{hx::fsObject /*::Xml*/ ,(int)offsetof(Xml_obj,parent),HX_CSTRING("parent")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("_nodeName"),
	HX_CSTRING("_nodeValue"),
	HX_CSTRING("_attributes"),
	HX_CSTRING("_children"),
	HX_CSTRING("_parent"),
	HX_CSTRING("nodeType"),
	HX_CSTRING("get_nodeName"),
	HX_CSTRING("set_nodeName"),
	HX_CSTRING("get_nodeValue"),
	HX_CSTRING("set_nodeValue"),
	HX_CSTRING("parent"),
	HX_CSTRING("get_parent"),
	HX_CSTRING("get"),
	HX_CSTRING("set"),
	HX_CSTRING("remove"),
	HX_CSTRING("exists"),
	HX_CSTRING("attributes"),
	HX_CSTRING("iterator"),
	HX_CSTRING("elements"),
	HX_CSTRING("elementsNamed"),
	HX_CSTRING("firstChild"),
	HX_CSTRING("firstElement"),
	HX_CSTRING("addChild"),
	HX_CSTRING("removeChild"),
	HX_CSTRING("insertChild"),
	HX_CSTRING("toString"),
	HX_CSTRING("toStringRec"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Xml_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Xml_obj::Element,"Element");
	HX_MARK_MEMBER_NAME(Xml_obj::PCData,"PCData");
	HX_MARK_MEMBER_NAME(Xml_obj::CData,"CData");
	HX_MARK_MEMBER_NAME(Xml_obj::Comment,"Comment");
	HX_MARK_MEMBER_NAME(Xml_obj::DocType,"DocType");
	HX_MARK_MEMBER_NAME(Xml_obj::ProcessingInstruction,"ProcessingInstruction");
	HX_MARK_MEMBER_NAME(Xml_obj::Document,"Document");
	HX_MARK_MEMBER_NAME(Xml_obj::_parse,"_parse");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Xml_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Xml_obj::Element,"Element");
	HX_VISIT_MEMBER_NAME(Xml_obj::PCData,"PCData");
	HX_VISIT_MEMBER_NAME(Xml_obj::CData,"CData");
	HX_VISIT_MEMBER_NAME(Xml_obj::Comment,"Comment");
	HX_VISIT_MEMBER_NAME(Xml_obj::DocType,"DocType");
	HX_VISIT_MEMBER_NAME(Xml_obj::ProcessingInstruction,"ProcessingInstruction");
	HX_VISIT_MEMBER_NAME(Xml_obj::Document,"Document");
	HX_VISIT_MEMBER_NAME(Xml_obj::_parse,"_parse");
};

#endif

Class Xml_obj::__mClass;

void Xml_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("Xml"), hx::TCanCast< Xml_obj> ,sStaticFields,sMemberFields,
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

void Xml_obj::__boot()
{
	_parse= ::cpp::Lib_obj::load(HX_CSTRING("std"),HX_CSTRING("parse_xml"),(int)2);
}

