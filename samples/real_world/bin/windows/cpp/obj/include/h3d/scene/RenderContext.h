#ifndef INCLUDED_h3d_scene_RenderContext
#define INCLUDED_h3d_scene_RenderContext

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h3d,Camera)
HX_DECLARE_CLASS1(h3d,Engine)
HX_DECLARE_CLASS1(h3d,Matrix)
HX_DECLARE_CLASS2(h3d,scene,RenderContext)
namespace h3d{
namespace scene{


class HXCPP_CLASS_ATTRIBUTES  RenderContext_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef RenderContext_obj OBJ_;
		RenderContext_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< RenderContext_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~RenderContext_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("RenderContext"); }

		::h3d::Engine engine;
		::h3d::Camera camera;
		Float time;
		Float elapsedTime;
		int currentPass;
		int frame;
		::h3d::Matrix localPos;
		Dynamic passes;
		virtual Void addPass( Dynamic p);
		Dynamic addPass_dyn();

		virtual Void finalize( );
		Dynamic finalize_dyn();

};

} // end namespace h3d
} // end namespace scene

#endif /* INCLUDED_h3d_scene_RenderContext */ 
