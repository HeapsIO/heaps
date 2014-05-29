#ifndef INCLUDED_hxd__FloatBuffer_InnerIterator
#define INCLUDED_hxd__FloatBuffer_InnerIterator

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(hxd,_FloatBuffer,InnerIterator)
namespace hxd{
namespace _FloatBuffer{


class HXCPP_CLASS_ATTRIBUTES  InnerIterator_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef InnerIterator_obj OBJ_;
		InnerIterator_obj();
		Void __construct(Array< Float > b);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< InnerIterator_obj > __new(Array< Float > b);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~InnerIterator_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("InnerIterator"); }

		Array< Float > b;
		int len;
		int pos;
		virtual bool hasNext( );
		Dynamic hasNext_dyn();

		virtual Float next( );
		Dynamic next_dyn();

};

} // end namespace hxd
} // end namespace _FloatBuffer

#endif /* INCLUDED_hxd__FloatBuffer_InnerIterator */ 
