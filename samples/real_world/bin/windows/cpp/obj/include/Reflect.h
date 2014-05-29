#ifndef INCLUDED_Reflect
#define INCLUDED_Reflect

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Reflect)


class HXCPP_CLASS_ATTRIBUTES  Reflect_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Reflect_obj OBJ_;
		Reflect_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Reflect_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Reflect_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Reflect"); }

		static bool hasField( Dynamic o,::String field);
		static Dynamic hasField_dyn();

		static Dynamic field( Dynamic o,::String field);
		static Dynamic field_dyn();

		static Void setField( Dynamic o,::String field,Dynamic value);
		static Dynamic setField_dyn();

		static Dynamic getProperty( Dynamic o,::String field);
		static Dynamic getProperty_dyn();

		static Void setProperty( Dynamic o,::String field,Dynamic value);
		static Dynamic setProperty_dyn();

		static Dynamic callMethod( Dynamic o,Dynamic func,Dynamic args);
		static Dynamic callMethod_dyn();

		static Array< ::String > fields( Dynamic o);
		static Dynamic fields_dyn();

		static bool isFunction( Dynamic f);
		static Dynamic isFunction_dyn();

		static int compare( Dynamic a,Dynamic b);
		static Dynamic compare_dyn();

		static bool compareMethods( Dynamic f1,Dynamic f2);
		static Dynamic compareMethods_dyn();

		static bool isObject( Dynamic v);
		static Dynamic isObject_dyn();

		static bool isEnumValue( Dynamic v);
		static Dynamic isEnumValue_dyn();

		static bool deleteField( Dynamic o,::String field);
		static Dynamic deleteField_dyn();

		static Dynamic copy( Dynamic o);
		static Dynamic copy_dyn();

		static Dynamic makeVarArgs( Dynamic f);
		static Dynamic makeVarArgs_dyn();

};


#endif /* INCLUDED_Reflect */ 
