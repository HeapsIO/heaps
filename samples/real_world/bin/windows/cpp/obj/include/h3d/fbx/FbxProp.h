#ifndef INCLUDED_h3d_fbx_FbxProp
#define INCLUDED_h3d_fbx_FbxProp

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,fbx,FbxProp)
namespace h3d{
namespace fbx{


class FbxProp_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef FbxProp_obj OBJ_;

	public:
		FbxProp_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("h3d.fbx.FbxProp"); }
		::String __ToString() const { return HX_CSTRING("FbxProp.") + tag; }

		static ::h3d::fbx::FbxProp PFloat(Float v);
		static Dynamic PFloat_dyn();
		static ::h3d::fbx::FbxProp PFloats(Array< Float > v);
		static Dynamic PFloats_dyn();
		static ::h3d::fbx::FbxProp PIdent(::String i);
		static Dynamic PIdent_dyn();
		static ::h3d::fbx::FbxProp PInt(int v);
		static Dynamic PInt_dyn();
		static ::h3d::fbx::FbxProp PInts(Array< int > v);
		static Dynamic PInts_dyn();
		static ::h3d::fbx::FbxProp PString(::String v);
		static Dynamic PString_dyn();
};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_FbxProp */ 
