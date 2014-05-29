#ifndef INCLUDED_Date
#define INCLUDED_Date

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Date)


class HXCPP_CLASS_ATTRIBUTES  Date_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Date_obj OBJ_;
		Date_obj();
		Void __construct(int year,int month,int day,int hour,int min,int sec);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Date_obj > __new(int year,int month,int day,int hour,int min,int sec);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Date_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Date"); }

		Float mSeconds;
		virtual Float getTime( );
		Dynamic getTime_dyn();

		virtual int getHours( );
		Dynamic getHours_dyn();

		virtual int getMinutes( );
		Dynamic getMinutes_dyn();

		virtual int getSeconds( );
		Dynamic getSeconds_dyn();

		virtual int getFullYear( );
		Dynamic getFullYear_dyn();

		virtual int getMonth( );
		Dynamic getMonth_dyn();

		virtual int getDate( );
		Dynamic getDate_dyn();

		virtual int getDay( );
		Dynamic getDay_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		static ::Date now( );
		static Dynamic now_dyn();

		static ::Date new1( Dynamic t);
		static Dynamic new1_dyn();

		static ::Date fromTime( Float t);
		static Dynamic fromTime_dyn();

		static ::Date fromString( ::String s);
		static Dynamic fromString_dyn();

};


#endif /* INCLUDED_Date */ 
