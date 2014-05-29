#ifndef INCLUDED_flash_media_ID3Info
#define INCLUDED_flash_media_ID3Info

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(flash,media,ID3Info)
namespace flash{
namespace media{


class HXCPP_CLASS_ATTRIBUTES  ID3Info_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef ID3Info_obj OBJ_;
		ID3Info_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< ID3Info_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~ID3Info_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("ID3Info"); }

		::String album;
		::String artist;
		::String comment;
		::String genre;
		::String songName;
		::String track;
		::String year;
};

} // end namespace flash
} // end namespace media

#endif /* INCLUDED_flash_media_ID3Info */ 
