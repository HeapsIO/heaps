#ifndef INCLUDED_h3d_impl_BigBuffer
#define INCLUDED_h3d_impl_BigBuffer

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,BigBuffer)
HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(h3d,impl,FreeCell)
HX_DECLARE_CLASS2(h3d,impl,GLVB)
HX_DECLARE_CLASS2(h3d,impl,MemoryManager)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  BigBuffer_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BigBuffer_obj OBJ_;
		BigBuffer_obj();
		Void __construct(::h3d::impl::MemoryManager mem,::h3d::impl::GLVB v,int stride,int size,hx::Null< bool >  __o_isDynamic);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BigBuffer_obj > __new(::h3d::impl::MemoryManager mem,::h3d::impl::GLVB v,int stride,int size,hx::Null< bool >  __o_isDynamic);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BigBuffer_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BigBuffer"); }

		::h3d::impl::MemoryManager mem;
		int stride;
		int size;
		::h3d::impl::GLVB vbuf;
		::h3d::impl::FreeCell free;
		::h3d::impl::BigBuffer next;
		int flags;
		::h3d::impl::Buffer allocHead;
		virtual bool isDynamic( );
		Dynamic isDynamic_dyn();

		virtual Void freeCursor( int pos,int nvect);
		Dynamic freeCursor_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		virtual bool isDisposed( );
		Dynamic isDisposed_dyn();

};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_BigBuffer */ 
