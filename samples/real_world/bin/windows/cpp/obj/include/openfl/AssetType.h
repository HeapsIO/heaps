#ifndef INCLUDED_openfl_AssetType
#define INCLUDED_openfl_AssetType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(openfl,AssetType)
namespace openfl{


class AssetType_obj : public hx::EnumBase_obj
{
	typedef hx::EnumBase_obj super;
		typedef AssetType_obj OBJ_;

	public:
		AssetType_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		::String GetEnumName( ) const { return HX_CSTRING("openfl.AssetType"); }
		::String __ToString() const { return HX_CSTRING("AssetType.") + tag; }

		static ::openfl::AssetType BINARY;
		static inline ::openfl::AssetType BINARY_dyn() { return BINARY; }
		static ::openfl::AssetType FONT;
		static inline ::openfl::AssetType FONT_dyn() { return FONT; }
		static ::openfl::AssetType IMAGE;
		static inline ::openfl::AssetType IMAGE_dyn() { return IMAGE; }
		static ::openfl::AssetType MOVIE_CLIP;
		static inline ::openfl::AssetType MOVIE_CLIP_dyn() { return MOVIE_CLIP; }
		static ::openfl::AssetType MUSIC;
		static inline ::openfl::AssetType MUSIC_dyn() { return MUSIC; }
		static ::openfl::AssetType SOUND;
		static inline ::openfl::AssetType SOUND_dyn() { return SOUND; }
		static ::openfl::AssetType TEMPLATE;
		static inline ::openfl::AssetType TEMPLATE_dyn() { return TEMPLATE; }
		static ::openfl::AssetType TEXT;
		static inline ::openfl::AssetType TEXT_dyn() { return TEXT; }
};

} // end namespace openfl

#endif /* INCLUDED_openfl_AssetType */ 
