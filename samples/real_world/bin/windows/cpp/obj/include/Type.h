#ifndef INCLUDED_Type
#define INCLUDED_Type

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Type)
HX_DECLARE_CLASS0(ValueType)


class HXCPP_CLASS_ATTRIBUTES  Type_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Type_obj OBJ_;
		Type_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Type_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Type_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Type"); }

		static ::Class getClass( Dynamic o);
		static Dynamic getClass_dyn();

		static ::Enum getEnum( Dynamic o);
		static Dynamic getEnum_dyn();

		static ::Class getSuperClass( ::Class c);
		static Dynamic getSuperClass_dyn();

		static ::String getClassName( ::Class c);
		static Dynamic getClassName_dyn();

		static ::String getEnumName( ::Enum e);
		static Dynamic getEnumName_dyn();

		static ::Class resolveClass( ::String name);
		static Dynamic resolveClass_dyn();

		static ::Enum resolveEnum( ::String name);
		static Dynamic resolveEnum_dyn();

		static Dynamic createInstance( ::Class cl,Dynamic args);
		static Dynamic createInstance_dyn();

		static Dynamic createEmptyInstance( ::Class cl);
		static Dynamic createEmptyInstance_dyn();

		static Dynamic createEnum( ::Enum e,::String constr,Dynamic params);
		static Dynamic createEnum_dyn();

		static Dynamic createEnumIndex( ::Enum e,int index,Dynamic params);
		static Dynamic createEnumIndex_dyn();

		static Array< ::String > getInstanceFields( ::Class c);
		static Dynamic getInstanceFields_dyn();

		static Array< ::String > getClassFields( ::Class c);
		static Dynamic getClassFields_dyn();

		static Array< ::String > getEnumConstructs( ::Enum e);
		static Dynamic getEnumConstructs_dyn();

		static ::ValueType _typeof( Dynamic v);
		static Dynamic _typeof_dyn();

		static bool enumEq( Dynamic a,Dynamic b);
		static Dynamic enumEq_dyn();

		static ::String enumConstructor( Dynamic e);
		static Dynamic enumConstructor_dyn();

		static Dynamic enumParameters( Dynamic e);
		static Dynamic enumParameters_dyn();

		static int enumIndex( Dynamic e);
		static Dynamic enumIndex_dyn();

		static Dynamic allEnums( ::Enum e);
		static Dynamic allEnums_dyn();

};


#endif /* INCLUDED_Type */ 
