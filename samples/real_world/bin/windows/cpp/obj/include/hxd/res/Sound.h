#ifndef INCLUDED_hxd_res_Sound
#define INCLUDED_hxd_res_Sound

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <hxd/res/Resource.h>
HX_DECLARE_CLASS2(hxd,res,FileEntry)
HX_DECLARE_CLASS2(hxd,res,Resource)
HX_DECLARE_CLASS2(hxd,res,Sound)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  Sound_obj : public ::hxd::res::Resource_obj{
	public:
		typedef ::hxd::res::Resource_obj super;
		typedef Sound_obj OBJ_;
		Sound_obj();
		Void __construct(::hxd::res::FileEntry entry);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Sound_obj > __new(::hxd::res::FileEntry entry);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Sound_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("Sound"); }

		Float volume;
		bool loop;
		virtual Float getPosition( );
		Dynamic getPosition_dyn();

		virtual Void play( );
		Dynamic play_dyn();

		virtual Void playAt( Float startPosition);
		Dynamic playAt_dyn();

		virtual Void stop( );
		Dynamic stop_dyn();

		virtual Float set_volume( Float v);
		Dynamic set_volume_dyn();

		static int BUFFER_SIZE;
		static Dynamic getGlobalVolume;
		static inline Dynamic &getGlobalVolume_dyn() {return getGlobalVolume; }

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_Sound */ 
