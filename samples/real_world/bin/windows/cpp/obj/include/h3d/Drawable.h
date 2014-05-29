#ifndef INCLUDED_h3d_Drawable
#define INCLUDED_h3d_Drawable

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/IDrawable.h>
HX_DECLARE_CLASS1(h3d,Drawable)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS1(h3d,IDrawable)
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,prim,Primitive)
namespace h3d{


class HXCPP_CLASS_ATTRIBUTES  Drawable_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Drawable_obj OBJ_;
		Drawable_obj();
		Void __construct(::h3d::prim::Primitive prim,Dynamic shader);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Drawable_obj > __new(::h3d::prim::Primitive prim,Dynamic shader);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Drawable_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		inline operator ::h3d::IDrawable_obj *()
			{ return new ::h3d::IDrawable_delegate_< Drawable_obj >(this); }
		hx::Object *__ToInterface(const hx::type_info &inType);
		::String __ToString() const { return HX_CSTRING("Drawable"); }

		Dynamic shader;
		::h3d::prim::Primitive primitive;
		::h3d::mat::Material material;
		virtual Void render( ::h3d::Engine engine);
		Dynamic render_dyn();

};

} // end namespace h3d

#endif /* INCLUDED_h3d_Drawable */ 
