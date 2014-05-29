#ifndef INCLUDED_h3d_fbx_FBxTools
#define INCLUDED_h3d_fbx_FBxTools

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,fbx,FBxTools)
HX_DECLARE_CLASS2(h3d,fbx,FbxProp)
namespace h3d{
namespace fbx{


class HXCPP_CLASS_ATTRIBUTES  FBxTools_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FBxTools_obj OBJ_;
		FBxTools_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FBxTools_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FBxTools_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("FBxTools"); }

		static ::String toString( ::h3d::fbx::FbxProp n);
		static Dynamic toString_dyn();

		static int toInt( ::h3d::fbx::FbxProp n);
		static Dynamic toInt_dyn();

		static Float toFloat( ::h3d::fbx::FbxProp n);
		static Dynamic toFloat_dyn();

};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_FBxTools */ 
