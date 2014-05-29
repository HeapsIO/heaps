#ifndef INCLUDED_haxe_StackItem
#define INCLUDED_haxe_StackItem

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(haxe,StackItem)
namespace haxe{


class StackItem_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef StackItem_obj OBJ_;

	public:
		StackItem_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("haxe.StackItem"); }
		::String __ToString() const { return HX_CSTRING("StackItem.") + tag; }

		static ::haxe::StackItem CFunction;
		static inline ::haxe::StackItem CFunction_dyn() { return CFunction; }
		static ::haxe::StackItem FilePos(::haxe::StackItem s,::String file,int line);
		static Dynamic FilePos_dyn();
		static ::haxe::StackItem LocalFunction(int v);
		static Dynamic LocalFunction_dyn();
		static ::haxe::StackItem Method(::String classname,::String method);
		static Dynamic Method_dyn();
		static ::haxe::StackItem Module(::String m);
		static Dynamic Module_dyn();
};

} // end namespace haxe

#endif /* INCLUDED_haxe_StackItem */ 
