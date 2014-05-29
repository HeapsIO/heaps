#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_format_png_Reader
#include <format/png/Reader.h>
#endif
#ifndef INCLUDED_format_png_Tools
#include <format/png/Tools.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesInput
#include <haxe/io/BytesInput.h>
#endif
#ifndef INCLUDED_haxe_io_Input
#include <haxe/io/Input.h>
#endif
#ifndef INCLUDED_hxd_PixelFormat
#include <hxd/PixelFormat.h>
#endif
#ifndef INCLUDED_hxd_Pixels
#include <hxd/Pixels.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_hxd__BitmapData_BitmapData_Impl_
#include <hxd/_BitmapData/BitmapData_Impl_.h>
#endif
#ifndef INCLUDED_hxd_impl_Tmp
#include <hxd/impl/Tmp.h>
#endif
#ifndef INCLUDED_hxd_res_FileEntry
#include <hxd/res/FileEntry.h>
#endif
#ifndef INCLUDED_hxd_res_FileInput
#include <hxd/res/FileInput.h>
#endif
#ifndef INCLUDED_hxd_res_Filter
#include <hxd/res/Filter.h>
#endif
#ifndef INCLUDED_hxd_res_NanoJpeg
#include <hxd/res/NanoJpeg.h>
#endif
#ifndef INCLUDED_hxd_res_Resource
#include <hxd/res/Resource.h>
#endif
#ifndef INCLUDED_hxd_res_Texture
#include <hxd/res/Texture.h>
#endif
namespace hxd{
namespace res{

Void Texture_obj::__construct(::hxd::res::FileEntry entry)
{
HX_STACK_FRAME("hxd.res.Texture","new",0xb8eec605,"hxd.res.Texture.new","hxd/res/Texture.hx",3,0x133cac0d)
HX_STACK_THIS(this)
HX_STACK_ARG(entry,"entry")
{
	HX_STACK_LINE(3)
	super::__construct(entry);
}
;
	return null();
}

//Texture_obj::~Texture_obj() { }

Dynamic Texture_obj::__CreateEmpty() { return  new Texture_obj; }
hx::ObjectPtr< Texture_obj > Texture_obj::__new(::hxd::res::FileEntry entry)
{  hx::ObjectPtr< Texture_obj > result = new Texture_obj();
	result->__construct(entry);
	return result;}

Dynamic Texture_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Texture_obj > result = new Texture_obj();
	result->__construct(inArgs[0]);
	return result;}

bool Texture_obj::isPNG( ){
	HX_STACK_FRAME("hxd.res.Texture","isPNG",0x0ed2d3c4,"hxd.res.Texture.isPNG","hxd/res/Texture.hx",9,0x133cac0d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(10)
	this->getSize();
	HX_STACK_LINE(11)
	return this->inf->__Field(HX_CSTRING("isPNG"),true);
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,isPNG,return )

Void Texture_obj::checkResize( ){
{
		HX_STACK_FRAME("hxd.res.Texture","checkResize",0xcc3dcf81,"hxd.res.Texture.checkResize","hxd/res/Texture.hx",14,0x133cac0d)
		HX_STACK_THIS(this)
		HX_STACK_LINE(15)
		if ((!(this->needResize))){
			HX_STACK_LINE(15)
			return null();
		}
		HX_STACK_LINE(16)
		int tw = this->tex->width;		HX_STACK_VAR(tw,"tw");
		HX_STACK_LINE(16)
		int th = this->tex->height;		HX_STACK_VAR(th,"th");
		HX_STACK_LINE(17)
		{
			HX_STACK_LINE(18)
			this->tex->width = (int)1;
			HX_STACK_LINE(19)
			this->tex->height = (int)1;
		}
		HX_STACK_LINE(21)
		this->tex->resize(tw,th);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,checkResize,(void))

Dynamic Texture_obj::getSize( ){
	if (((this->inf != null()))){
		return this->inf;
	}
	::hxd::res::FileInput f = ::hxd::res::FileInput_obj::__new(this->entry);
	int width = (int)0;
	int height = (int)0;
	bool isPNG = false;
	{
		int _g = f->readUInt16();
		switch( (int)(_g)){
			case (int)55551: {
				f->set_bigEndian(true);
				while((true)){
					int _g1 = f->readUInt16();
					int _switch_1 = (_g1);
					if (  ( _switch_1==(int)65474) ||  ( _switch_1==(int)65472)){
						int len = f->readUInt16();
						int prec = f->readByte();
						int _g2 = f->readUInt16();
						height = _g2;
						int _g11 = f->readUInt16();
						width = _g11;
						break;
					}
					else  {
						int _g2 = f->readUInt16();
						int _g3 = (_g2 - (int)2);
						f->skip(_g3);
					}
;
;
				}
			}
			;break;
			case (int)20617: {
				isPNG = true;
				::haxe::io::Bytes TMP = ::hxd::impl::Tmp_obj::getBytes((int)256);
				f->set_bigEndian(true);
				f->readBytes(TMP,(int)0,(int)6);
				while((true)){
					int dataLen = f->readInt32();
					int _g4 = f->readInt32();
					if (((_g4 == (int)1229472850))){
						int _g5 = f->readInt32();
						width = _g5;
						int _g6 = f->readInt32();
						height = _g6;
						break;
					}
					while((true)){
						if ((!(((dataLen > (int)0))))){
							break;
						}
						int k;
						if (((dataLen > TMP->length))){
							k = TMP->length;
						}
						else{
							k = dataLen;
						}
						f->readBytes(TMP,(int)0,k);
						hx::SubEq(dataLen,k);
					}
					int crc = f->readInt32();
				}
				::hxd::impl::Tmp_obj::saveBytes(TMP);
			}
			;break;
			default: {
				::String _g7 = this->entry->get_path();
				HX_STACK_DO_THROW((HX_CSTRING("Unsupported texture format ") + _g7));
			}
		}
	}
	f->close();
	struct _Function_1_1{
		inline static Dynamic Block( int &width,bool &isPNG,int &height){
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , width,false);
				__result->Add(HX_CSTRING("height") , height,false);
				__result->Add(HX_CSTRING("isPNG") , isPNG,false);
				return __result;
			}
			return null();
		}
	};
	this->inf = _Function_1_1::Block(width,isPNG,height);
	return this->inf;
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,getSize,return )

::hxd::Pixels Texture_obj::getPixels( ){
	this->getSize();
	if ((this->inf->__Field(HX_CSTRING("isPNG"),true))){
		::haxe::io::Bytes _g = this->entry->getBytes();
		::haxe::io::BytesInput _g1 = ::haxe::io::BytesInput_obj::__new(_g,null(),null());
		::format::png::Reader png = ::format::png::Reader_obj::__new(_g1);
		png->checkCRC = false;
		::hxd::Pixels pixels = ::hxd::Pixels_obj::alloc(this->inf->__Field(HX_CSTRING("width"),true),this->inf->__Field(HX_CSTRING("height"),true),::hxd::PixelFormat_obj::BGRA);
		::List _g2 = png->read();
		::format::png::Tools_obj::extract32(_g2,pixels->bytes);
		return pixels;
	}
	else{
		::haxe::io::Bytes bytes = this->entry->getBytes();
		Dynamic p = ::hxd::res::NanoJpeg_obj::decode(bytes,null(),null(),null());
		return ::hxd::Pixels_obj::__new(p->__Field(HX_CSTRING("width"),true),p->__Field(HX_CSTRING("height"),true),p->__Field(HX_CSTRING("pixels"),true),::hxd::PixelFormat_obj::BGRA,null());
	}
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,getPixels,return )

::flash::display::BitmapData Texture_obj::toBitmap( ){
	this->getSize();
	::flash::display::BitmapData bmp = ::flash::display::BitmapData_obj::__new(this->inf->__Field(HX_CSTRING("width"),true),this->inf->__Field(HX_CSTRING("height"),true),true,(int)0,null());
	::hxd::Pixels pixels = this->getPixels();
	::hxd::_BitmapData::BitmapData_Impl__obj::nativeSetPixels(bmp,pixels);
	pixels->dispose();
	return bmp;
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,toBitmap,return )

Void Texture_obj::loadTexture( ){
{
		Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));
		int tw = this->tex->width;
		int th = this->tex->height;
		int w = this->inf->__Field(HX_CSTRING("width"),true);
		int h = this->inf->__Field(HX_CSTRING("height"),true);
		Array< bool > isSquare = Array_obj< bool >::__new().Add((bool((w == tw)) && bool((h == th))));
		if ((this->inf->__Field(HX_CSTRING("isPNG"),true))){

			HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_2_1,Array< ::Dynamic >,_g)
			Void run(){
				{
					_g->__get((int)0).StaticCast< ::hxd::res::Texture >()->checkResize();
					::hxd::Pixels pixels = _g->__get((int)0).StaticCast< ::hxd::res::Texture >()->getPixels();
					pixels->makeSquare(null());
					_g->__get((int)0).StaticCast< ::hxd::res::Texture >()->tex->uploadPixels(pixels,null(),null());
					pixels->dispose();
				}
				return null();
			}
			HX_END_LOCAL_FUNC0((void))

			Dynamic load =  Dynamic(new _Function_2_1(_g));
			if ((this->entry->get_isAvailable())){
				load().Cast< Void >();
			}
			else{
				this->entry->load(load);
			}
		}
		else{

			HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_2_1,Array< ::Dynamic >,_g,Array< bool >,isSquare)
			Void run(::flash::display::BitmapData bmp){
				{
					_g->__get((int)0).StaticCast< ::hxd::res::Texture >()->checkResize();
					if ((isSquare->__get((int)0))){
						_g->__get((int)0).StaticCast< ::hxd::res::Texture >()->tex->uploadBitmap(bmp,null(),null());
					}
					else{
						::hxd::Pixels pixels = ::hxd::_BitmapData::BitmapData_Impl__obj::nativeGetPixels(bmp);
						pixels->makeSquare(null());
						_g->__get((int)0).StaticCast< ::hxd::res::Texture >()->tex->uploadPixels(pixels,null(),null());
						pixels->dispose();
					}
					bmp->dispose();
				}
				return null();
			}
			HX_END_LOCAL_FUNC1((void))

			this->entry->loadBitmap( Dynamic(new _Function_2_1(_g,isSquare)));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,loadTexture,(void))

::h3d::mat::Texture Texture_obj::toTexture( ){
	HX_STACK_FRAME("hxd.res.Texture","toTexture",0xce8b4005,"hxd.res.Texture.toTexture","hxd/res/Texture.hx",137,0x133cac0d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(137)
	Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(138)
	if (((  (((this->tex != null()))) ? bool(!(this->tex->isDisposed())) : bool(false) ))){
		HX_STACK_LINE(139)
		return this->tex;
	}
	HX_STACK_LINE(140)
	if (((this->tex != null()))){
		HX_STACK_LINE(141)
		this->tex->dispose();
		HX_STACK_LINE(142)
		this->tex = null();
	}
	HX_STACK_LINE(144)
	this->getSize();
	HX_STACK_LINE(145)
	int w = this->inf->__Field(HX_CSTRING("width"),true);		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(145)
	int h = this->inf->__Field(HX_CSTRING("height"),true);		HX_STACK_VAR(h,"h");
	HX_STACK_LINE(146)
	int tw = (int)1;		HX_STACK_VAR(tw,"tw");
	HX_STACK_LINE(146)
	int th = (int)1;		HX_STACK_VAR(th,"th");
	HX_STACK_LINE(147)
	while((true)){
		HX_STACK_LINE(147)
		if ((!(((tw < w))))){
			HX_STACK_LINE(147)
			break;
		}
		HX_STACK_LINE(147)
		hx::ShlEq(tw,(int)1);
	}
	HX_STACK_LINE(148)
	while((true)){
		HX_STACK_LINE(148)
		if ((!(((th < h))))){
			HX_STACK_LINE(148)
			break;
		}
		HX_STACK_LINE(148)
		hx::ShlEq(th,(int)1);
	}
	HX_STACK_LINE(150)
	if (((  ((this->inf->__Field(HX_CSTRING("isPNG"),true))) ? bool(this->entry->get_isAvailable()) : bool(false) ))){
		HX_STACK_LINE(152)
		this->needResize = false;
		struct _Function_2_1{
			inline static ::h3d::Engine Block( ){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","hxd/res/Texture.hx",153,0x133cac0d)
				{
					HX_STACK_LINE(153)
					if (((::hxd::System_obj::debugLevel >= (int)1))){
						HX_STACK_LINE(153)
						if (((::h3d::Engine_obj::CURRENT == null()))){
							HX_STACK_LINE(153)
							HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
						}
					}
					HX_STACK_LINE(153)
					return ::h3d::Engine_obj::CURRENT;
				}
				return null();
			}
		};
		HX_STACK_LINE(153)
		::h3d::mat::Texture _g1 = (_Function_2_1::Block())->mem->allocTexture(tw,th,false,hx::SourceInfo(HX_CSTRING("Texture.hx"),153,HX_CSTRING("hxd.res.Texture"),HX_CSTRING("toTexture")));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(153)
		this->tex = _g1;
	}
	else{
		HX_STACK_LINE(156)
		::h3d::mat::Texture _g1 = ::h3d::mat::Texture_obj::fromColor((int)-16776961,hx::SourceInfo(HX_CSTRING("Texture.hx"),156,HX_CSTRING("hxd.res.Texture"),HX_CSTRING("toTexture")));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(156)
		this->tex = _g1;
		HX_STACK_LINE(157)
		this->needResize = true;
		HX_STACK_LINE(158)
		{
			HX_STACK_LINE(159)
			this->tex->width = tw;
			HX_STACK_LINE(160)
			this->tex->height = th;
		}
	}
	HX_STACK_LINE(164)
	this->loadTexture();

	HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Array< ::Dynamic >,_g)
	bool run(){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","hxd/res/Texture.hx",165,0x133cac0d)
		{
			HX_STACK_LINE(166)
			_g->__get((int)0).StaticCast< ::hxd::res::Texture >()->needResize = false;
			HX_STACK_LINE(167)
			_g->__get((int)0).StaticCast< ::hxd::res::Texture >()->loadTexture();
			HX_STACK_LINE(168)
			return true;
		}
		return null();
	}
	HX_END_LOCAL_FUNC0(return)

	HX_STACK_LINE(165)
	this->tex->onContextLost =  Dynamic(new _Function_1_1(_g));
	HX_STACK_LINE(170)
	return this->tex;
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,toTexture,return )

::h2d::Tile Texture_obj::toTile( ){
	HX_STACK_FRAME("hxd.res.Texture","toTile",0x04b295c4,"hxd.res.Texture.toTile","hxd/res/Texture.hx",173,0x133cac0d)
	HX_STACK_THIS(this)
	HX_STACK_LINE(174)
	Dynamic size = this->getSize();		HX_STACK_VAR(size,"size");
	HX_STACK_LINE(175)
	::h3d::mat::Texture _g = this->toTexture();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(175)
	return ::h2d::Tile_obj::fromTexture(_g)->sub((int)0,(int)0,size->__Field(HX_CSTRING("width"),true),size->__Field(HX_CSTRING("height"),true),null(),null());
}


HX_DEFINE_DYNAMIC_FUNC0(Texture_obj,toTile,return )


Texture_obj::Texture_obj()
{
}

void Texture_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Texture);
	HX_MARK_MEMBER_NAME(needResize,"needResize");
	HX_MARK_MEMBER_NAME(tex,"tex");
	HX_MARK_MEMBER_NAME(inf,"inf");
	::hxd::res::Resource_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Texture_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(needResize,"needResize");
	HX_VISIT_MEMBER_NAME(tex,"tex");
	HX_VISIT_MEMBER_NAME(inf,"inf");
	::hxd::res::Resource_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Texture_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"tex") ) { return tex; }
		if (HX_FIELD_EQ(inName,"inf") ) { return inf; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"isPNG") ) { return isPNG_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"toTile") ) { return toTile_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getSize") ) { return getSize_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"toBitmap") ) { return toBitmap_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getPixels") ) { return getPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"toTexture") ) { return toTexture_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"needResize") ) { return needResize; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"checkResize") ) { return checkResize_dyn(); }
		if (HX_FIELD_EQ(inName,"loadTexture") ) { return loadTexture_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Texture_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"tex") ) { tex=inValue.Cast< ::h3d::mat::Texture >(); return inValue; }
		if (HX_FIELD_EQ(inName,"inf") ) { inf=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"needResize") ) { needResize=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Texture_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("needResize"));
	outFields->push(HX_CSTRING("tex"));
	outFields->push(HX_CSTRING("inf"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsBool,(int)offsetof(Texture_obj,needResize),HX_CSTRING("needResize")},
	{hx::fsObject /*::h3d::mat::Texture*/ ,(int)offsetof(Texture_obj,tex),HX_CSTRING("tex")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(Texture_obj,inf),HX_CSTRING("inf")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("needResize"),
	HX_CSTRING("tex"),
	HX_CSTRING("inf"),
	HX_CSTRING("isPNG"),
	HX_CSTRING("checkResize"),
	HX_CSTRING("getSize"),
	HX_CSTRING("getPixels"),
	HX_CSTRING("toBitmap"),
	HX_CSTRING("loadTexture"),
	HX_CSTRING("toTexture"),
	HX_CSTRING("toTile"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Texture_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Texture_obj::__mClass,"__mClass");
};

#endif

Class Texture_obj::__mClass;

void Texture_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.Texture"), hx::TCanCast< Texture_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics
#ifdef HXCPP_VISIT_ALLOCS
    , sVisitStatics
#endif
#ifdef HXCPP_SCRIPTABLE
    , sMemberStorageInfo
#endif
);
}

void Texture_obj::__boot()
{
}

} // end namespace hxd
} // end namespace res
