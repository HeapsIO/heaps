#ifndef INCLUDED_hxd_Assert
#define INCLUDED_hxd_Assert

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(hxd,Assert)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Assert_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Assert_obj OBJ_;
		Assert_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Assert_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Assert_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Assert"); }

		static ::String ASSERT_HEADER;
		static Void throwError( ::String msg);
		static Dynamic throwError_dyn();

		static Void fail( ::String msg);
		static Dynamic fail_dyn();

		static Void isTrue( bool o,::String msg);
		static Dynamic isTrue_dyn();

		static Void isFalse( bool o,::String msg);
		static Dynamic isFalse_dyn();

		static Void equals( Dynamic value,Dynamic expected,::String msg);
		static Dynamic equals_dyn();

		static Void isNull( Dynamic o,::String msg);
		static Dynamic isNull_dyn();

		static Void isZero( Float o,::String msg);
		static Dynamic isZero_dyn();

		static Void notZero( Float o,::String msg);
		static Dynamic notZero_dyn();

		static Void notNan( Float o,::String msg);
		static Dynamic notNan_dyn();

		static Void notNull( Dynamic o,::String msg);
		static Dynamic notNull_dyn();

		static Void arrayContains( Dynamic a,Dynamic o,::String msg);
		static Dynamic arrayContains_dyn();

		static Void contains( Dynamic a,Dynamic o,::String msg);
		static Dynamic contains_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Assert */ 
