#ifndef INCLUDED_h3d_impl_GLActiveInfo
#define INCLUDED_h3d_impl_GLActiveInfo

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,impl,GLActiveInfo)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  GLActiveInfo_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef GLActiveInfo_obj OBJ_;
		GLActiveInfo_obj();
		Void __construct(Dynamic g);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GLActiveInfo_obj > __new(Dynamic g);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GLActiveInfo_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("GLActiveInfo"); }

		int size;
		int type;
		::String name;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_GLActiveInfo */ 
