#ifndef INCLUDED_flash_media_SoundLoaderContext
#define INCLUDED_flash_media_SoundLoaderContext

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,media,SoundLoaderContext)
namespace flash{
namespace media{


class HXCPP_CLASS_ATTRIBUTES  SoundLoaderContext_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef SoundLoaderContext_obj OBJ_;
		SoundLoaderContext_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< SoundLoaderContext_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~SoundLoaderContext_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("SoundLoaderContext"); }

};

} // end namespace flash
} // end namespace media

#endif /* INCLUDED_flash_media_SoundLoaderContext */ 
