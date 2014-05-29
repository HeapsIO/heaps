#ifndef INCLUDED_hxd_Profiler
#define INCLUDED_hxd_Profiler

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS1(hxd,Profiler)
namespace hxd{


class HXCPP_CLASS_ATTRIBUTES  Profiler_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef Profiler_obj OBJ_;
		Profiler_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Profiler_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Profiler_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Profiler"); }

		static bool enable;
		static ::hxd::Profiler inst;
		static Float minLimit;
		static ::haxe::ds::StringMap h;
		static Void begin( ::String tag);
		static Dynamic begin_dyn();

		static Void end( ::String tag);
		static Dynamic end_dyn();

		static Void clear( ::String tag);
		static Dynamic clear_dyn();

		static Void clean( );
		static Dynamic clean_dyn();

		static Float spent( ::String tag);
		static Dynamic spent_dyn();

		static Float hit( ::String tag);
		static Dynamic hit_dyn();

		static ::String dump( Dynamic trunkValues);
		static Dynamic dump_dyn();

};

} // end namespace hxd

#endif /* INCLUDED_hxd_Profiler */ 
