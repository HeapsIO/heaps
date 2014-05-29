#ifndef INCLUDED_h2d_BatchElement
#define INCLUDED_h2d_BatchElement

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(h2d,BatchElement)
HX_DECLARE_CLASS1(h2d,Drawable)
HX_DECLARE_CLASS1(h2d,Sprite)
HX_DECLARE_CLASS1(h2d,SpriteBatch)
HX_DECLARE_CLASS1(h2d,Tile)
HX_DECLARE_CLASS1(h3d,Vector)
namespace h2d{


class HXCPP_CLASS_ATTRIBUTES  BatchElement_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BatchElement_obj OBJ_;
		BatchElement_obj();
		Void __construct(::h2d::Tile t);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< BatchElement_obj > __new(::h2d::Tile t);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~BatchElement_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("BatchElement"); }

		int priority;
		Float x;
		Float y;
		Float scaleX;
		Float scaleY;
		Float skewX;
		Float skewY;
		Float rotation;
		bool visible;
		Float alpha;
		::h2d::Tile t;
		::h3d::Vector color;
		::h2d::SpriteBatch batch;
		::h2d::BatchElement prev;
		::h2d::BatchElement next;
		virtual Void remove( );
		Dynamic remove_dyn();

		virtual Float get_width( );
		Dynamic get_width_dyn();

		virtual Float get_height( );
		Dynamic get_height_dyn();

		virtual Float set_width( Float w);
		Dynamic set_width_dyn();

		virtual Float set_height( Float h);
		Dynamic set_height_dyn();

		virtual int changePriority( int v);
		Dynamic changePriority_dyn();

};

} // end namespace h2d

#endif /* INCLUDED_h2d_BatchElement */ 
