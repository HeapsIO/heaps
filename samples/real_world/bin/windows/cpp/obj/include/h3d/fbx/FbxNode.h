#ifndef INCLUDED_h3d_fbx_FbxNode
#define INCLUDED_h3d_fbx_FbxNode

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,fbx,FbxNode)
HX_DECLARE_CLASS2(h3d,fbx,FbxProp)
namespace h3d{
namespace fbx{


class HXCPP_CLASS_ATTRIBUTES  FbxNode_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef FbxNode_obj OBJ_;
		FbxNode_obj();
		Void __construct(::String n,Array< ::Dynamic > p,Array< ::Dynamic > c);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< FbxNode_obj > __new(::String n,Array< ::Dynamic > p,Array< ::Dynamic > c);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~FbxNode_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("FbxNode"); }

		::String name;
		Array< ::Dynamic > props;
		Array< ::Dynamic > childs;
		virtual ::String toString( );
		Dynamic toString_dyn();

		virtual ::h3d::fbx::FbxNode get( ::String path,hx::Null< bool >  opt);
		Dynamic get_dyn();

		virtual Array< ::Dynamic > getAll( ::String path);
		Dynamic getAll_dyn();

		virtual Array< int > getInts( );
		Dynamic getInts_dyn();

		virtual Array< Float > getFloats( );
		Dynamic getFloats_dyn();

		virtual bool hasProp( ::h3d::fbx::FbxProp p);
		Dynamic hasProp_dyn();

		virtual int getId( );
		Dynamic getId_dyn();

		virtual ::String getName( );
		Dynamic getName_dyn();

		virtual ::String getType( );
		Dynamic getType_dyn();

		virtual ::String getStringProp( int idx);
		Dynamic getStringProp_dyn();

};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_FbxNode */ 
