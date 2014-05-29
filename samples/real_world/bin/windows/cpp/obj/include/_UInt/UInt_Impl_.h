#ifndef INCLUDED__UInt_UInt_Impl_
#define INCLUDED__UInt_UInt_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(_UInt,UInt_Impl_)
namespace _UInt{


class HXCPP_CLASS_ATTRIBUTES  UInt_Impl__obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef UInt_Impl__obj OBJ_;
		UInt_Impl__obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< UInt_Impl__obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~UInt_Impl__obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("UInt_Impl_"); }

		static int add( int a,int b);
		static Dynamic add_dyn();

		static Float div( int a,int b);
		static Dynamic div_dyn();

		static int mul( int a,int b);
		static Dynamic mul_dyn();

		static int sub( int a,int b);
		static Dynamic sub_dyn();

		static bool gt( int a,int b);
		static Dynamic gt_dyn();

		static bool gte( int a,int b);
		static Dynamic gte_dyn();

		static bool lt( int a,int b);
		static Dynamic lt_dyn();

		static bool lte( int a,int b);
		static Dynamic lte_dyn();

		static int _and( int a,int b);
		static Dynamic _and_dyn();

		static int _or( int a,int b);
		static Dynamic _or_dyn();

		static int _xor( int a,int b);
		static Dynamic _xor_dyn();

		static int shl( int a,int b);
		static Dynamic shl_dyn();

		static int shr( int a,int b);
		static Dynamic shr_dyn();

		static int ushr( int a,int b);
		static Dynamic ushr_dyn();

		static int mod( int a,int b);
		static Dynamic mod_dyn();

		static Float addWithFloat( int a,Float b);
		static Dynamic addWithFloat_dyn();

		static Float mulWithFloat( int a,Float b);
		static Dynamic mulWithFloat_dyn();

		static Float divFloat( int a,Float b);
		static Dynamic divFloat_dyn();

		static Float floatDiv( Float a,int b);
		static Dynamic floatDiv_dyn();

		static Float subFloat( int a,Float b);
		static Dynamic subFloat_dyn();

		static Float floatSub( Float a,int b);
		static Dynamic floatSub_dyn();

		static bool gtFloat( int a,Float b);
		static Dynamic gtFloat_dyn();

		static bool equalsFloat( int a,Float b);
		static Dynamic equalsFloat_dyn();

		static bool notEqualsFloat( int a,Float b);
		static Dynamic notEqualsFloat_dyn();

		static bool gteFloat( int a,Float b);
		static Dynamic gteFloat_dyn();

		static bool floatGt( Float a,int b);
		static Dynamic floatGt_dyn();

		static bool floatGte( Float a,int b);
		static Dynamic floatGte_dyn();

		static bool ltFloat( int a,Float b);
		static Dynamic ltFloat_dyn();

		static bool lteFloat( int a,Float b);
		static Dynamic lteFloat_dyn();

		static bool floatLt( Float a,int b);
		static Dynamic floatLt_dyn();

		static bool floatLte( Float a,int b);
		static Dynamic floatLte_dyn();

		static Float modFloat( int a,Float b);
		static Dynamic modFloat_dyn();

		static Float floatMod( Float a,int b);
		static Dynamic floatMod_dyn();

		static int negBits( int this1);
		static Dynamic negBits_dyn();

		static int prefixIncrement( int this1);
		static Dynamic prefixIncrement_dyn();

		static int postfixIncrement( int this1);
		static Dynamic postfixIncrement_dyn();

		static int prefixDecrement( int this1);
		static Dynamic prefixDecrement_dyn();

		static int postfixDecrement( int this1);
		static Dynamic postfixDecrement_dyn();

		static ::String toString( int this1,Dynamic radix);
		static Dynamic toString_dyn();

		static int toInt( int this1);
		static Dynamic toInt_dyn();

		static Float toFloat( int this1);
		static Dynamic toFloat_dyn();

};

} // end namespace _UInt

#endif /* INCLUDED__UInt_UInt_Impl_ */ 
