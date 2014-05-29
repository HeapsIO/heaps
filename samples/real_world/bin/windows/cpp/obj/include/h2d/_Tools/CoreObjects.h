#ifndef INCLUDED_h2d__Tools_CoreObjects
#define INCLUDED_h2d__Tools_CoreObjects

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,Matrix)
HX_DECLARE_CLASS2(h2d,_Tools,CoreObjects)
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS1(h3d,Vector)
HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(h3d,mat,Material)
HX_DECLARE_CLASS2(h3d,mat,Texture)
namespace h2d{
namespace _Tools{


class HXCPP_CLASS_ATTRIBUTES  CoreObjects_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef CoreObjects_obj OBJ_;
		CoreObjects_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< CoreObjects_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~CoreObjects_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("CoreObjects"); }

		::h3d::Vector tmpMatA;
		::h3d::Vector tmpMatB;
		::h3d::Vector tmpSize;
		::h3d::Vector tmpUVPos;
		::h3d::Vector tmpUVScale;
		::h3d::Vector tmpColor;
		::h3d::Matrix tmpMatrix;
		::h2d::Matrix tmpMatrix2D;
		::h2d::Matrix tmpMatrix2D_2;
		::h3d::mat::Material tmpMaterial;
		::h3d::impl::Buffer planBuffer;
		::h3d::mat::Texture emptyTexture;
		virtual ::h3d::mat::Texture getEmptyTexture( );
		Dynamic getEmptyTexture_dyn();

};

} // end namespace h2d
} // end namespace _Tools

#endif /* INCLUDED_h2d__Tools_CoreObjects */ 
