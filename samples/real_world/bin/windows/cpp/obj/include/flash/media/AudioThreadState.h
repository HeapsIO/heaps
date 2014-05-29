#ifndef INCLUDED_flash_media_AudioThreadState
#define INCLUDED_flash_media_AudioThreadState

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(cpp,vm,Mutex)
HX_DECLARE_CLASS2(cpp,vm,Thread)
HX_DECLARE_CLASS2(flash,events,EventDispatcher)
HX_DECLARE_CLASS2(flash,events,IEventDispatcher)
HX_DECLARE_CLASS2(flash,media,AudioThreadState)
HX_DECLARE_CLASS2(flash,media,SoundChannel)
namespace flash{
namespace media{


class HXCPP_CLASS_ATTRIBUTES  AudioThreadState_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef AudioThreadState_obj OBJ_;
		AudioThreadState_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< AudioThreadState_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~AudioThreadState_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("AudioThreadState"); }

		::cpp::vm::Thread audioThread;
		Array< ::Dynamic > channelList;
		::cpp::vm::Thread mainThread;
		::cpp::vm::Mutex mutex;
		virtual Void add( ::flash::media::SoundChannel channel);
		Dynamic add_dyn();

		virtual Void remove( ::flash::media::SoundChannel channel);
		Dynamic remove_dyn();

		virtual Void updateComplete( );
		Dynamic updateComplete_dyn();

};

} // end namespace flash
} // end namespace media

#endif /* INCLUDED_flash_media_AudioThreadState */ 
