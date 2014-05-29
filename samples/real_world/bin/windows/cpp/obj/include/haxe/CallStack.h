#ifndef INCLUDED_haxe_CallStack
#define INCLUDED_haxe_CallStack

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(StringBuf)
HX_DECLARE_CLASS1(haxe,CallStack)
HX_DECLARE_CLASS1(haxe,StackItem)
namespace haxe{


class HXCPP_CLASS_ATTRIBUTES  CallStack_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef CallStack_obj OBJ_;
		CallStack_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< CallStack_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~CallStack_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("CallStack"); }

		static Array< ::Dynamic > callStack( );
		static Dynamic callStack_dyn();

		static Array< ::Dynamic > exceptionStack( );
		static Dynamic exceptionStack_dyn();

		static ::String toString( Array< ::Dynamic > stack);
		static Dynamic toString_dyn();

		static Void itemToString( ::StringBuf b,::haxe::StackItem s);
		static Dynamic itemToString_dyn();

		static Array< ::Dynamic > makeStack( Array< ::String > s);
		static Dynamic makeStack_dyn();

};

} // end namespace haxe

#endif /* INCLUDED_haxe_CallStack */ 
