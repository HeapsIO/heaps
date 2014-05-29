#ifndef INCLUDED_h3d_fbx_DefaultMatrixes
#define INCLUDED_h3d_fbx_DefaultMatrixes

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS2(h3d,col,Point)
HX_DECLARE_CLASS2(h3d,fbx,DefaultMatrixes)
namespace h3d{
namespace fbx{


class HXCPP_CLASS_ATTRIBUTES  DefaultMatrixes_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef DefaultMatrixes_obj OBJ_;
		DefaultMatrixes_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< DefaultMatrixes_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~DefaultMatrixes_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("DefaultMatrixes"); }

		::h3d::col::Point trans;
		::h3d::col::Point scale;
		::h3d::col::Point rotate;
		::h3d::col::Point preRot;
		Dynamic wasRemoved;
		virtual ::h3d::Matrix toMatrix( bool leftHand);
		Dynamic toMatrix_dyn();

		static Void rightHandToLeft( ::h3d::Matrix m);
		static Dynamic rightHandToLeft_dyn();

};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_DefaultMatrixes */ 
