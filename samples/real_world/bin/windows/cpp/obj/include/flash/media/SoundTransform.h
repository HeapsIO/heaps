#ifndef INCLUDED_flash_media_SoundTransform
#define INCLUDED_flash_media_SoundTransform

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,media,SoundTransform)
namespace flash{
namespace media{


class HXCPP_CLASS_ATTRIBUTES  SoundTransform_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef SoundTransform_obj OBJ_;
		SoundTransform_obj();
		Void __construct(hx::Null< Float >  __o_volume,hx::Null< Float >  __o_pan);

	public:
		inline void *operator new( size_t inSize, bool inContainer=false)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< SoundTransform_obj > __new(hx::Null< Float >  __o_volume,hx::Null< Float >  __o_pan);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~SoundTransform_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		::String __ToString() const { return HX_CSTRING("SoundTransform"); }

		Float pan;
		Float volume;
		virtual ::flash::media::SoundTransform clone( );
		Dynamic clone_dyn();

};

} // end namespace flash
} // end namespace media

#endif /* INCLUDED_flash_media_SoundTransform */ 
