#ifndef INCLUDED_h2d_Layers
#define INCLUDED_h2d_Layers

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <h2d/Sprite.h>
HX_DECLARE_CLASS1(h2d,Layers)
HX_DECLARE_CLASS1(h2d,Sprite)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  Layers_obj : public ::h2d::Sprite_obj{
	public:
		typedef ::h2d::Sprite_obj super;
		typedef Layers_obj OBJ_;
		Layers_obj();
		Void __construct(::h2d::Sprite parent);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Layers_obj > __new(::h2d::Sprite parent);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Layers_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Layers"); }

		Array< int > layers;
		int layerCount;
		virtual int getLayer( ::h2d::Sprite s);
		Dynamic getLayer_dyn();

		virtual int getLayerStart( int layer);
		Dynamic getLayerStart_dyn();

		virtual int getLayerCount( int layer);
		Dynamic getLayerCount_dyn();

		virtual Void addChild( ::h2d::Sprite s);

		virtual Void add( ::h2d::Sprite s,int layer);
		Dynamic add_dyn();

		virtual Void clearLayer( int layer);
		Dynamic clearLayer_dyn();

		virtual Void addChildAt( ::h2d::Sprite s,int layer);

		virtual Void removeChildAt( int i);
		Dynamic removeChildAt_dyn();

		virtual Void removeChild( ::h2d::Sprite s);

		virtual Void under( ::h2d::Sprite s);
		Dynamic under_dyn();

		virtual Void over( ::h2d::Sprite s);
		Dynamic over_dyn();

		virtual Void ysort( hx::Null< int >  layer);
		Dynamic ysort_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_Layers */ 
