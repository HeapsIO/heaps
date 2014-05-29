#ifndef INCLUDED_StringBuf
#define INCLUDED_StringBuf

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(StringBuf)


class HXCPP_CLASS_ATTRIBUTES  StringBuf_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef StringBuf_obj OBJ_;
		StringBuf_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< StringBuf_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~StringBuf_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("StringBuf"); }

		Array< ::String > b;
		virtual int get_length( );
		Dynamic get_length_dyn();

		virtual Void add( Dynamic x);
		Dynamic add_dyn();

		virtual Void addSub( ::String s,int pos,Dynamic len);
		Dynamic addSub_dyn();

		virtual Void addChar( int c);
		Dynamic addChar_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

};


#endif /* INCLUDED_StringBuf */ 
