#ifndef INCLUDED_h3d_impl_MemoryManager
#define INCLUDED_h3d_impl_MemoryManager

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(IMap)
HX_DECLARE_CLASS2(h3d,impl,BigBuffer)
HX_DECLARE_CLASS2(h3d,impl,Buffer)
HX_DECLARE_CLASS2(h3d,impl,Driver)
HX_DECLARE_CLASS2(h3d,impl,Indexes)
HX_DECLARE_CLASS2(h3d,impl,MemoryManager)
HX_DECLARE_CLASS2(h3d,mat,Texture)
HX_DECLARE_CLASS2(h3d,mat,TextureFormat)
HX_DECLARE_CLASS2(haxe,ds,ObjectMap)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(openfl,gl,GLObject)
HX_DECLARE_CLASS2(openfl,gl,GLTexture)
namespace h3d{
namespace impl{


class HXCPP_CLASS_ATTRIBUTES  MemoryManager_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef MemoryManager_obj OBJ_;
		MemoryManager_obj();
		Void __construct(::h3d::impl::Driver driver,int allocSize);

	public:
		inline void *operator new( size_t inSize, bool inContainer=true)
			{ return hx::Object::operator new(inSize,inContainer); }
		static hx::ObjectPtr< MemoryManager_obj > __new(::h3d::impl::Driver driver,int allocSize);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		//~MemoryManager_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("MemoryManager"); }

		::h3d::impl::Driver driver;
		Array< ::Dynamic > buffers;
		::haxe::ds::ObjectMap idict;
		::haxe::ds::ObjectMap tdict;
		Array< ::Dynamic > textures;
		::h3d::impl::Indexes indexes;
		::h3d::impl::Indexes quadIndexes;
		int usedMemory;
		int bufferCount;
		int allocSize;
		virtual Void initIndexes( );
		Dynamic initIndexes_dyn();

		Dynamic garbage;
		inline Dynamic &garbage_dyn() {return garbage; }

		virtual Void cleanBuffers( );
		Dynamic cleanBuffers_dyn();

		virtual Dynamic stats( );
		Dynamic stats_dyn();

		virtual Dynamic allocStats( );
		Dynamic allocStats_dyn();

		virtual ::h3d::mat::Texture newTexture( ::h3d::mat::TextureFormat fmt,int w,int h,bool cubic,bool target,int mm,Dynamic allocPos);
		Dynamic newTexture_dyn();

		virtual Void initTexture( ::h3d::mat::Texture t);
		Dynamic initTexture_dyn();

		virtual Void deleteIndexes( ::h3d::impl::Indexes i);
		Dynamic deleteIndexes_dyn();

		virtual Void deleteTexture( ::h3d::mat::Texture t);
		Dynamic deleteTexture_dyn();

		virtual Void resizeTexture( ::h3d::mat::Texture t,int width,int height);
		Dynamic resizeTexture_dyn();

		virtual Dynamic readAtfHeader( ::haxe::io::Bytes data);
		Dynamic readAtfHeader_dyn();

		virtual ::h3d::mat::Texture allocCustomTexture( ::h3d::mat::TextureFormat fmt,int width,int height,hx::Null< int >  mipLevels,hx::Null< bool >  cubic,hx::Null< bool >  target,Dynamic allocPos);
		Dynamic allocCustomTexture_dyn();

		virtual ::h3d::mat::Texture allocTexture( int width,int height,Dynamic mipMap,Dynamic allocPos);
		Dynamic allocTexture_dyn();

		virtual ::h3d::mat::Texture allocTargetTexture( int width,int height,Dynamic allocPos);
		Dynamic allocTargetTexture_dyn();

		virtual ::h3d::mat::Texture allocCubeTexture( int size,Dynamic mipMap,Dynamic allocPos);
		Dynamic allocCubeTexture_dyn();

		virtual ::h3d::impl::Indexes allocIndex( Array< int > indices,hx::Null< int >  pos,hx::Null< int >  count);
		Dynamic allocIndex_dyn();

		virtual ::h3d::impl::Buffer allocBytes( ::haxe::io::Bytes bytes,int stride,int align,Dynamic isDynamic,Dynamic allocPos);
		Dynamic allocBytes_dyn();

		virtual ::h3d::impl::Buffer allocVector( Array< Float > v,int stride,int align,Dynamic isDynamic,Dynamic allocPos);
		Dynamic allocVector_dyn();

		virtual int freeTextures( );
		Dynamic freeTextures_dyn();

		virtual int freeMemory( );
		Dynamic freeMemory_dyn();

		virtual ::h3d::impl::Buffer alloc( int nvect,int stride,int align,Dynamic isDynamic,Dynamic allocPos);
		Dynamic alloc_dyn();

		virtual Void onContextLost( );
		Dynamic onContextLost_dyn();

		virtual Void dispose( );
		Dynamic dispose_dyn();

		static int MAX_MEMORY;
		static int MAX_BUFFERS;
};

} // end namespace h3d
} // end namespace impl

#endif /* INCLUDED_h3d_impl_MemoryManager */ 
