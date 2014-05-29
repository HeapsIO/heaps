#ifndef INCLUDED_h3d_scene_Joint
#define INCLUDED_h3d_scene_Joint

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h3d/scene/Object.h>
HX_DECLARE_CLASS2(h3d,scene,Joint)
HX_DECLARE_CLASS2(h3d,scene,Mesh)
HX_DECLARE_CLASS2(h3d,scene,Object)
HX_DECLARE_CLASS2(h3d,scene,Skin)
namespace h3d{
namespace scene{


class HXCPP_CLASS_ATTRIBUTES  Joint_obj : public ::h3d::scene::Object_obj{
	public:
		typedef ::h3d::scene::Object_obj super;
		typedef Joint_obj OBJ_;
		Joint_obj();
		Void __construct(::h3d::scene::Skin skin,int index);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Joint_obj > __new(::h3d::scene::Skin skin,int index);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Joint_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Joint"); }

		::h3d::scene::Skin skin;
		int index;
		virtual Void syncPos( );

};

} // end namespace h3d
} // end namespace scene

#endif /* INCLUDED_h3d_scene_Joint */ 
