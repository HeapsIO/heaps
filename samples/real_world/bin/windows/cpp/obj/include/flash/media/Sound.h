#ifndef INCLUDED_flash_media_Sound
#define INCLUDED_flash_media_Sound

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <flash/events/EventDispatcher.h>
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,media,ID3Info)
HX_DECLARE_CLASS2(flash,media,InternalAudioType)
HX_DECLARE_CLASS2(flash,media,Sound)
HX_DECLARE_CLASS2(flash,media,SoundChannel)
HX_DECLARE_CLASS2(flash,media,SoundLoaderContext)
HX_DECLARE_CLASS2(flash,media,SoundTransform)
HX_DECLARE_CLASS2(flash,net,URLRequest)
HX_DECLARE_CLASS2(flash,utils,ByteArray)
HX_DECLARE_CLASS2(flash,utils,IDataInput)
HX_DECLARE_CLASS2(flash,utils,IDataOutput)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,utils,IMemoryRange)
namespace flash{
namespace media{


class HXCPP_CLASS_ATTRIBUTES  Sound_obj : public ::flash::events::EventDispatcher_obj{
	public:
		typedef ::flash::events::EventDispatcher_obj super;
		typedef Sound_obj OBJ_;
		Sound_obj();
		Void __construct(::flash::net::URLRequest stream,::flash::media::SoundLoaderContext context,hx::Null< bool >  __o_forcePlayAsMusic);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< Sound_obj > __new(::flash::net::URLRequest stream,::flash::media::SoundLoaderContext context,hx::Null< bool >  __o_forcePlayAsMusic);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~Sound_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Sound"); }

		int bytesLoaded;
		int bytesTotal;
		::flash::media::ID3Info id3;
		bool isBuffering;
		Float length;
		::String url;
		::flash::media::InternalAudioType __audioType;
		Dynamic __handle;
		bool __loading;
		bool __dynamicSound;
		virtual Void addEventListener( ::String type,Dynamic listener,hx::Null< bool >  useCapture,hx::Null< int >  priority,hx::Null< bool >  useWeakReference);

		virtual Void close( );
		Dynamic close_dyn();

		virtual Void load( ::flash::net::URLRequest stream,::flash::media::SoundLoaderContext context,hx::Null< bool >  forcePlayAsMusic);
		Dynamic load_dyn();

		virtual Void loadCompressedDataFromByteArray( ::flash::utils::ByteArray bytes,int length,hx::Null< bool >  forcePlayAsMusic);
		Dynamic loadCompressedDataFromByteArray_dyn();

		virtual Void loadPCMFromByteArray( ::flash::utils::ByteArray bytes,int samples,::String format,hx::Null< bool >  stereo,hx::Null< Float >  sampleRate);
		Dynamic loadPCMFromByteArray_dyn();

		virtual ::flash::media::SoundChannel play( hx::Null< Float >  startTime,hx::Null< int >  loops,::flash::media::SoundTransform soundTransform);
		Dynamic play_dyn();

		virtual Void __checkLoading( );
		Dynamic __checkLoading_dyn();

		virtual Void __onError( ::String msg);
		Dynamic __onError_dyn();

		virtual ::flash::media::ID3Info get_id3( );
		Dynamic get_id3_dyn();

		virtual bool get_isBuffering( );
		Dynamic get_isBuffering_dyn();

		virtual Float get_length( );
		Dynamic get_length_dyn();

		static Dynamic lime_sound_from_file;
		static Dynamic &lime_sound_from_file_dyn() { return lime_sound_from_file;}
		static Dynamic lime_sound_from_data;
		static Dynamic &lime_sound_from_data_dyn() { return lime_sound_from_data;}
		static Dynamic lime_sound_get_id3;
		static Dynamic &lime_sound_get_id3_dyn() { return lime_sound_get_id3;}
		static Dynamic lime_sound_get_length;
		static Dynamic &lime_sound_get_length_dyn() { return lime_sound_get_length;}
		static Dynamic lime_sound_close;
		static Dynamic &lime_sound_close_dyn() { return lime_sound_close;}
		static Dynamic lime_sound_get_status;
		static Dynamic &lime_sound_get_status_dyn() { return lime_sound_get_status;}
		static Dynamic lime_sound_channel_create_dynamic;
		static Dynamic &lime_sound_channel_create_dynamic_dyn() { return lime_sound_channel_create_dynamic;}
};

} // end namespace flash
} // end namespace media

#endif /* INCLUDED_flash_media_Sound */ 
