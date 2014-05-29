#ifndef INCLUDED_h3d_fbx_XBXReader
#define INCLUDED_h3d_fbx_XBXReader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(h3d,fbx,FbxNode)
HX_DECLARE_CLASS2(h3d,fbx,FbxProp)
HX_DECLARE_CLASS2(h3d,fbx,XBXReader)
HX_DECLARE_CLASS2(haxe,io,Input)
namespace h3d{
namespace fbx{


class HXCPP_CLASS_ATTRIBUTES  XBXReader_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef XBXReader_obj OBJ_;
		XBXReader_obj();
		Void __construct(::haxe::io::Input i);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< XBXReader_obj > __new(::haxe::io::Input i);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~XBXReader_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("XBXReader"); }

		::haxe::io::Input i;
		int version;
		virtual Void error( ::String msg);
		Dynamic error_dyn();

		virtual ::String readString( );
		Dynamic readString_dyn();

		virtual ::h3d::fbx::FbxNode read( );
		Dynamic read_dyn();

		virtual ::h3d::fbx::FbxNode readNode( );
		Dynamic readNode_dyn();

		virtual int readInt( );
		Dynamic readInt_dyn();

		virtual ::h3d::fbx::FbxProp readProp( );
		Dynamic readProp_dyn();

};

} // end namespace h3d
} // end namespace fbx

#endif /* INCLUDED_h3d_fbx_XBXReader */ 
