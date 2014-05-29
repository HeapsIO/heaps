#ifndef INCLUDED_Xml
#define INCLUDED_Xml

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(StringBuf)
HX_DECLARE_CLASS0(Type)
HX_DECLARE_CLASS0(Xml)
HX_DECLARE_CLASS0(XmlType)


class HXCPP_CLASS_ATTRIBUTES  Xml_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Xml_obj OBJ_;
		Xml_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Xml_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Xml_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		static void __init__();

		::String __ToString() const { return HX_CSTRING("Xml"); }

		::String _nodeName;
		::String _nodeValue;
		Dynamic _attributes;
		Array< ::Dynamic > _children;
		::Xml _parent;
		::XmlType nodeType;
		virtual ::String get_nodeName( );
		Dynamic get_nodeName_dyn();

		virtual ::String set_nodeName( ::String n);
		Dynamic set_nodeName_dyn();

		virtual ::String get_nodeValue( );
		Dynamic get_nodeValue_dyn();

		virtual ::String set_nodeValue( ::String v);
		Dynamic set_nodeValue_dyn();

		::Xml parent;
		virtual ::Xml get_parent( );
		Dynamic get_parent_dyn();

		virtual ::String get( ::String att);
		Dynamic get_dyn();

		virtual Void set( ::String att,::String value);
		Dynamic set_dyn();

		virtual Void remove( ::String att);
		Dynamic remove_dyn();

		virtual bool exists( ::String att);
		Dynamic exists_dyn();

		virtual Dynamic attributes( );
		Dynamic attributes_dyn();

		virtual Dynamic iterator( );
		Dynamic iterator_dyn();

		virtual Dynamic elements( );
		Dynamic elements_dyn();

		virtual Dynamic elementsNamed( ::String name);
		Dynamic elementsNamed_dyn();

		virtual ::Xml firstChild( );
		Dynamic firstChild_dyn();

		virtual ::Xml firstElement( );
		Dynamic firstElement_dyn();

		virtual Void addChild( ::Xml x);
		Dynamic addChild_dyn();

		virtual bool removeChild( ::Xml x);
		Dynamic removeChild_dyn();

		virtual Void insertChild( ::Xml x,int pos);
		Dynamic insertChild_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual Void toStringRec( ::StringBuf s);
		Dynamic toStringRec_dyn();

		static ::XmlType Element;
		static ::XmlType PCData;
		static ::XmlType CData;
		static ::XmlType Comment;
		static ::XmlType DocType;
		static ::XmlType ProcessingInstruction;
		static ::XmlType Document;
		static Dynamic _parse;
		static Dynamic &_parse_dyn() { return _parse;}
		static ::Xml parse( ::String str);
		static Dynamic parse_dyn();

		static ::Xml createElement( ::String name);
		static Dynamic createElement_dyn();

		static ::Xml createPCData( ::String data);
		static Dynamic createPCData_dyn();

		static ::Xml createCData( ::String data);
		static Dynamic createCData_dyn();

		static ::Xml createComment( ::String data);
		static Dynamic createComment_dyn();

		static ::Xml createDocType( ::String data);
		static Dynamic createDocType_dyn();

		static ::Xml createProcessingInstruction( ::String data);
		static Dynamic createProcessingInstruction_dyn();

		static ::Xml createDocument( );
		static Dynamic createDocument_dyn();

};


#endif /* INCLUDED_Xml */ 
