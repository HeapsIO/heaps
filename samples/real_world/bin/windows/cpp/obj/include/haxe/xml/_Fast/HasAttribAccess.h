#ifndef INCLUDED_haxe_xml__Fast_HasAttribAccess
#define INCLUDED_haxe_xml__Fast_HasAttribAccess

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Xml)
HX_DECLARE_CLASS3(haxe,xml,_Fast,HasAttribAccess)
namespace haxe{
namespace xml{
namespace _Fast{


class HXCPP_CLASS_ATTRIBUTES  HasAttribAccess_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef HasAttribAccess_obj OBJ_;
		HasAttribAccess_obj();
		Void __construct(::Xml x);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< HasAttribAccess_obj > __new(::Xml x);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~HasAttribAccess_obj();

		HX_DO_RTTI;
		HX_DECLARE_IMPLEMENT_DYNAMIC;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("HasAttribAccess"); }

		::Xml __x;
		virtual bool resolve( ::String name);
		Dynamic resolve_dyn();

};

} // end namespace haxe
} // end namespace xml
} // end namespace _Fast

#endif /* INCLUDED_haxe_xml__Fast_HasAttribAccess */ 
