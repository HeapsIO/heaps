#ifndef INCLUDED_flash_media_InternalAudioType
#define INCLUDED_flash_media_InternalAudioType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,media,InternalAudioType)
namespace flash{
namespace media{


class InternalAudioType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef InternalAudioType_obj OBJ_;

	public:
		InternalAudioType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("flash.media.InternalAudioType"); }
		::String __ToString() const { return HX_CSTRING("InternalAudioType.") + tag; }

		static ::flash::media::InternalAudioType MUSIC;
		static inline ::flash::media::InternalAudioType MUSIC_dyn() { return MUSIC; }
		static ::flash::media::InternalAudioType SOUND;
		static inline ::flash::media::InternalAudioType SOUND_dyn() { return SOUND; }
		static ::flash::media::InternalAudioType UNKNOWN;
		static inline ::flash::media::InternalAudioType UNKNOWN_dyn() { return UNKNOWN; }
};

} // end namespace flash
} // end namespace media

#endif /* INCLUDED_flash_media_InternalAudioType */ 
