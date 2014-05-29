#ifndef INCLUDED_XmlType
#define INCLUDED_XmlType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(XmlType)


class XmlType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef XmlType_obj OBJ_;

	public:
		XmlType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("XmlType"); }
		::String __ToString() const { return HX_CSTRING("XmlType.") + tag; }

};


#endif /* INCLUDED_XmlType */ 
