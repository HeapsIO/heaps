#ifndef INCLUDED_haxe_xml_Fast
#define INCLUDED_haxe_xml_Fast

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Xml)
HX_DECLARE_CLASS2(haxe,xml,Fast)
HX_DECLARE_CLASS3(haxe,xml,_Fast,AttribAccess)
HX_DECLARE_CLASS3(haxe,xml,_Fast,HasAttribAccess)
HX_DECLARE_CLASS3(haxe,xml,_Fast,HasNodeAccess)
HX_DECLARE_CLASS3(haxe,xml,_Fast,NodeAccess)
HX_DECLARE_CLASS3(haxe,xml,_Fast,NodeListAccess)
namespace haxe{
namespace xml{


class HXCPP_CLASS_ATTRIBUTES  Fast_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Fast_obj OBJ_;
		Fast_obj();
		Void __construct(::Xml x);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Fast_obj > __new(::Xml x);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Fast_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Fast"); }

		::Xml x;
		::String name;
		::String innerData;
		::String innerHTML;
		::haxe::xml::_Fast::NodeAccess node;
		::haxe::xml::_Fast::NodeListAccess nodes;
		::haxe::xml::_Fast::AttribAccess att;
		::haxe::xml::_Fast::HasAttribAccess has;
		::haxe::xml::_Fast::HasNodeAccess hasNode;
		Dynamic elements;
		virtual ::String get_name( );
		Dynamic get_name_dyn();

		virtual ::String get_innerData( );
		Dynamic get_innerData_dyn();

		virtual ::String get_innerHTML( );
		Dynamic get_innerHTML_dyn();

		virtual Dynamic get_elements( );
		Dynamic get_elements_dyn();

};

} // end namespace haxe
} // end namespace xml

#endif /* INCLUDED_haxe_xml_Fast */ 
