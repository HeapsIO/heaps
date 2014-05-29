#ifndef INCLUDED_openfl_gl_GLObject
#define INCLUDED_openfl_gl_GLObject

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(openfl,gl,GLObject)
namespace openfl{
namespace gl{


class HXCPP_CLASS_ATTRIBUTES  GLObject_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef GLObject_obj OBJ_;
		GLObject_obj();
		Void __construct(int version,Dynamic id);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< GLObject_obj > __new(int version,Dynamic id);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~GLObject_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("GLObject"); }

		Dynamic id;
		bool invalidated;
		bool valid;
		int version;
		virtual ::String getType( );
		Dynamic getType_dyn();

		virtual Void invalidate( );
		Dynamic invalidate_dyn();

		virtual bool isValid( );
		Dynamic isValid_dyn();

		virtual bool isInvalid( );
		Dynamic isInvalid_dyn();

		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual bool get_invalidated( );
		Dynamic get_invalidated_dyn();

		virtual bool get_valid( );
		Dynamic get_valid_dyn();

};

} // end namespace openfl
} // end namespace gl

#endif /* INCLUDED_openfl_gl_GLObject */ 
