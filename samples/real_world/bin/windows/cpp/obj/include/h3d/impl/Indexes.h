#ifndef INCLUDED_h3d_impl_Indexes
#define INCLUDED_h3d_impl_Indexes

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,Indexes)
HX_DECLARE_CLASS2(h3d,impl,MemoryManager)
HX_DECLARE_CLASS2(openfl,gl,GLBuffer)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  Indexes_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Indexes_obj OBJ_;
		Indexes_obj();
		Void __construct(::h3d::impl::MemoryManager mem,::openfl::gl::GLBuffer ibuf,int count);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Indexes_obj > __new(::h3d::impl::MemoryManager mem,::openfl::gl::GLBuffer ibuf,int count);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Indexes_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Indexes"); }

		::h3d::impl::MemoryManager mem;
		::openfl::gl::GLBuffer ibuf;
		int count;
		virtual bool isDisposed( );
		Dynamic isDisposed_dyn();

		virtual Void upload( Array< int > indexes,int pos,int count,hx::Null< int >  bufferPos);
		Dynamic upload_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_Indexes */ 
