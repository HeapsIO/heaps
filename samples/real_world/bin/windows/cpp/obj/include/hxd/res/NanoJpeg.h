#ifndef INCLUDED_hxd_res_NanoJpeg
#define INCLUDED_hxd_res_NanoJpeg

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(hxd,res,Filter)
HX_DECLARE_CLASS2(hxd,res,NanoJpeg)
HX_DECLARE_CLASS3(hxd,res,_NanoJpeg,Component)
namespace hxd{
namespace res{


class HXCPP_CLASS_ATTRIBUTES  NanoJpeg_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef NanoJpeg_obj OBJ_;
		NanoJpeg_obj();
		Void __construct();

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< NanoJpeg_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~NanoJpeg_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("NanoJpeg"); }

		::haxe::io::Bytes bytes;
		int pos;
		int size;
		int length;
		int width;
		int height;
		int ncomp;
		Array< ::Dynamic > comps;
		Array< int > counts;
		Array< ::Dynamic > qtab;
		int qtused;
		int qtavail;
		Array< ::Dynamic > vlctab;
		Array< int > block;
		Array< int > njZZ;
		int mbsizex;
		int mbsizey;
		int mbwidth;
		int mbheight;
		int rstinterval;
		int buf;
		int bufbits;
		::haxe::io::Bytes pixels;
		::hxd::res::Filter filter;
		virtual ::haxe::io::Bytes alloc( int nbytes);
		Dynamic alloc_dyn();

		virtual Void free( ::haxe::io::Bytes bytes);
		Dynamic free_dyn();

		virtual Void njInit( ::haxe::io::Bytes bytes,int pos,int size,::hxd::res::Filter filter);
		Dynamic njInit_dyn();

		virtual Void cleanup( );
		Dynamic cleanup_dyn();

		virtual Void njSkip( int count);
		Dynamic njSkip_dyn();

		virtual Void syntax( bool flag);
		Dynamic syntax_dyn();

		virtual int get( int p);
		Dynamic get_dyn();

		virtual int njDecode16( int p);
		Dynamic njDecode16_dyn();

		virtual Void njByteAlign( );
		Dynamic njByteAlign_dyn();

		virtual int njShowBits( int bits);
		Dynamic njShowBits_dyn();

		virtual Void njSkipBits( int bits);
		Dynamic njSkipBits_dyn();

		virtual int njGetBits( int bits);
		Dynamic njGetBits_dyn();

		virtual Void njDecodeLength( );
		Dynamic njDecodeLength_dyn();

		virtual Void njSkipMarker( );
		Dynamic njSkipMarker_dyn();

		virtual Void njDecodeSOF( );
		Dynamic njDecodeSOF_dyn();

		virtual Void njDecodeDQT( );
		Dynamic njDecodeDQT_dyn();

		virtual Void njDecodeDHT( );
		Dynamic njDecodeDHT_dyn();

		virtual Void njDecodeDRI( );
		Dynamic njDecodeDRI_dyn();

		int vlcCode;
		virtual int njGetVLC( ::haxe::io::Bytes vlc);
		Dynamic njGetVLC_dyn();

		virtual Void njRowIDCT( int bp);
		Dynamic njRowIDCT_dyn();

		virtual Void njColIDCT( int bp,::haxe::io::Bytes out,int po,int stride);
		Dynamic njColIDCT_dyn();

		virtual Void njDecodeBlock( ::hxd::res::_NanoJpeg::Component c,int po);
		Dynamic njDecodeBlock_dyn();

		virtual Void notSupported( );
		Dynamic notSupported_dyn();

		virtual Void njDecodeScan( );
		Dynamic njDecodeScan_dyn();

		virtual Void njUpsampleH( ::hxd::res::_NanoJpeg::Component c);
		Dynamic njUpsampleH_dyn();

		virtual Void njUpsampleV( ::hxd::res::_NanoJpeg::Component c);
		Dynamic njUpsampleV_dyn();

		virtual Void njUpsample( ::hxd::res::_NanoJpeg::Component c);
		Dynamic njUpsample_dyn();

		virtual ::haxe::io::Bytes njConvert( );
		Dynamic njConvert_dyn();

		virtual Dynamic njDecode( );
		Dynamic njDecode_dyn();

		static int BLOCKSIZE;
		static int W1;
		static int W2;
		static int W3;
		static int W5;
		static int W6;
		static int W7;
		static int K;
		static int CF4A;
		static int CF4B;
		static int CF4C;
		static int CF4D;
		static int CF3A;
		static int CF3B;
		static int CF3C;
		static int CF3X;
		static int CF3Y;
		static int CF3Z;
		static int CF2A;
		static int CF2B;
		static int CF( int x);
		static Dynamic CF_dyn();

		static int njClip( int x);
		static Dynamic njClip_dyn();

		static ::hxd::res::NanoJpeg inst;
		static Dynamic decode( ::haxe::io::Bytes bytes,::hxd::res::Filter filter,hx::Null< int >  position,hx::Null< int >  size);
		static Dynamic decode_dyn();

};

} // end namespace hxd
} // end namespace res

#endif /* INCLUDED_hxd_res_NanoJpeg */ 
