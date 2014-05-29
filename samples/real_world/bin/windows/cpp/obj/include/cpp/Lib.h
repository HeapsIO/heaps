#ifndef INCLUDED_cpp_Lib
#define INCLUDED_cpp_Lib

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(cpp,Lib)
namespace cpp{


class HXCPP_CLASS_ATTRIBUTES  Lib_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Lib_obj OBJ_;
		Lib_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Lib_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Lib_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Lib"); }

		static Dynamic load( ::String lib,::String prim,int nargs);
		static Dynamic load_dyn();

		static Dynamic loadLazy( ::String lib,::String prim,int nargs);
		static Dynamic loadLazy_dyn();

		static Void rethrow( Dynamic inExp);
		static Dynamic rethrow_dyn();

		static Void stringReference( Dynamic inExp);
		static Dynamic stringReference_dyn();

		static Void print( Dynamic v);
		static Dynamic print_dyn();

		static Dynamic haxeToNeko( Dynamic v);
		static Dynamic haxeToNeko_dyn();

		static Dynamic nekoToHaxe( Dynamic v);
		static Dynamic nekoToHaxe_dyn();

		static Void println( Dynamic v);
		static Dynamic println_dyn();

};

} // end namespace cpp

#endif /* INCLUDED_cpp_Lib */ 
