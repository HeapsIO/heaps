#ifndef INCLUDED_IntIterator
#define INCLUDED_IntIterator

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IntIterator)


class HXCPP_CLASS_ATTRIBUTES  IntIterator_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef IntIterator_obj OBJ_;
		IntIterator_obj();
		Void __construct(int min,int max);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< IntIterator_obj > __new(int min,int max);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~IntIterator_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("IntIterator"); }

		int min;
		int max;
		virtual bool hasNext( );
		Dynamic hasNext_dyn();

		virtual int next( );
		Dynamic next_dyn();

};


#endif /* INCLUDED_IntIterator */ 
