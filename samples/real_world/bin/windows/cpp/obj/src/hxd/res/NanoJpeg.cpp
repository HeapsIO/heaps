#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_impl_Tmp
#include <hxd/impl/Tmp.h>
#endif
#ifndef INCLUDED_hxd_res_Filter
#include <hxd/res/Filter.h>
#endif
#ifndef INCLUDED_hxd_res_NanoJpeg
#include <hxd/res/NanoJpeg.h>
#endif
#ifndef INCLUDED_hxd_res__NanoJpeg_Component
#include <hxd/res/_NanoJpeg/Component.h>
#endif
namespace hxd{
namespace res{

Void NanoJpeg_obj::__construct()
{
{
	Array< ::Dynamic > _g4;
	{
		::hxd::res::_NanoJpeg::Component _g = ::hxd::res::_NanoJpeg::Component_obj::__new();
		::hxd::res::_NanoJpeg::Component _g1 = ::hxd::res::_NanoJpeg::Component_obj::__new();
		::hxd::res::_NanoJpeg::Component _g2 = ::hxd::res::_NanoJpeg::Component_obj::__new();
		Array< ::Dynamic > array = Array_obj< ::Dynamic >::__new().Add(_g).Add(_g1).Add(_g2);
		Array< ::Dynamic > vec;
		struct _Function_2_1{
			inline static Array< ::Dynamic > Block( Array< ::Dynamic > &array){
				{
					Array< ::Dynamic > this1;
					Array< ::Dynamic > _g3 = Array_obj< ::Dynamic >::__new()->__SetSizeExact(array->length);
					this1 = _g3;
					return this1;
				}
				return null();
			}
		};
		vec = _Function_2_1::Block(array);
		{
			int _g11 = (int)0;
			int _g3 = array->length;
			while((true)){
				if ((!(((_g11 < _g3))))){
					break;
				}
				int i = (_g11)++;
				vec->__unsafe_set(i,array->__get(i).StaticCast< ::hxd::res::_NanoJpeg::Component >());
			}
		}
		_g4 = vec;
	}
	this->comps = _g4;
	Array< ::Dynamic > _g14;
	{
		Array< int > _g6;
		struct _Function_2_1{
			inline static Array< int > Block( ){
				{
					Array< int > this1;
					Array< int > _g5 = Array_obj< int >::__new()->__SetSizeExact((int)64);
					this1 = _g5;
					return this1;
				}
				return null();
			}
		};
		_g6 = _Function_2_1::Block();
		Array< int > _g8;
		struct _Function_2_2{
			inline static Array< int > Block( ){
				{
					Array< int > this1;
					Array< int > _g7 = Array_obj< int >::__new()->__SetSizeExact((int)64);
					this1 = _g7;
					return this1;
				}
				return null();
			}
		};
		_g8 = _Function_2_2::Block();
		Array< int > _g10;
		struct _Function_2_3{
			inline static Array< int > Block( ){
				{
					Array< int > this1;
					Array< int > _g9 = Array_obj< int >::__new()->__SetSizeExact((int)64);
					this1 = _g9;
					return this1;
				}
				return null();
			}
		};
		_g10 = _Function_2_3::Block();
		Array< int > _g12;
		struct _Function_2_4{
			inline static Array< int > Block( ){
				{
					Array< int > this1;
					Array< int > _g11 = Array_obj< int >::__new()->__SetSizeExact((int)64);
					this1 = _g11;
					return this1;
				}
				return null();
			}
		};
		_g12 = _Function_2_4::Block();
		Array< ::Dynamic > array = Array_obj< ::Dynamic >::__new().Add(_g6).Add(_g8).Add(_g10).Add(_g12);
		Array< ::Dynamic > vec;
		struct _Function_2_5{
			inline static Array< ::Dynamic > Block( Array< ::Dynamic > &array){
				{
					Array< ::Dynamic > this1;
					Array< ::Dynamic > _g13 = Array_obj< ::Dynamic >::__new()->__SetSizeExact(array->length);
					this1 = _g13;
					return this1;
				}
				return null();
			}
		};
		vec = _Function_2_5::Block(array);
		{
			int _g1 = (int)0;
			int _g = array->length;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int i = (_g1)++;
				vec->__unsafe_set(i,array->__get(i).StaticCast< Array< int > >());
			}
		}
		_g14 = vec;
	}
	this->qtab = _g14;
	Array< int > _g16;
	struct _Function_1_1{
		inline static Array< int > Block( ){
			{
				Array< int > this1;
				Array< int > _g15 = Array_obj< int >::__new()->__SetSizeExact((int)16);
				this1 = _g15;
				return this1;
			}
			return null();
		}
	};
	_g16 = _Function_1_1::Block();
	this->counts = _g16;
	Array< int > _g18;
	struct _Function_1_2{
		inline static Array< int > Block( ){
			{
				Array< int > this1;
				Array< int > _g17 = Array_obj< int >::__new()->__SetSizeExact((int)64);
				this1 = _g17;
				return this1;
			}
			return null();
		}
	};
	_g18 = _Function_1_2::Block();
	this->block = _g18;
	Array< int > _g20;
	{
		Array< int > array = Array_obj< int >::__new().Add((int)0).Add((int)1).Add((int)8).Add((int)16).Add((int)9).Add((int)2).Add((int)3).Add((int)10).Add((int)17).Add((int)24).Add((int)32).Add((int)25).Add((int)18).Add((int)11).Add((int)4).Add((int)5).Add((int)12).Add((int)19).Add((int)26).Add((int)33).Add((int)40).Add((int)48).Add((int)41).Add((int)34).Add((int)27).Add((int)20).Add((int)13).Add((int)6).Add((int)7).Add((int)14).Add((int)21).Add((int)28).Add((int)35).Add((int)42).Add((int)49).Add((int)56).Add((int)57).Add((int)50).Add((int)43).Add((int)36).Add((int)29).Add((int)22).Add((int)15).Add((int)23).Add((int)30).Add((int)37).Add((int)44).Add((int)51).Add((int)58).Add((int)59).Add((int)52).Add((int)45).Add((int)38).Add((int)31).Add((int)39).Add((int)46).Add((int)53).Add((int)60).Add((int)61).Add((int)54).Add((int)47).Add((int)55).Add((int)62).Add((int)63);
		Array< int > vec;
		struct _Function_2_1{
			inline static Array< int > Block( Array< int > &array){
				{
					Array< int > this1;
					Array< int > _g19 = Array_obj< int >::__new()->__SetSizeExact(array->length);
					this1 = _g19;
					return this1;
				}
				return null();
			}
		};
		vec = _Function_2_1::Block(array);
		{
			int _g1 = (int)0;
			int _g = array->length;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int i = (_g1)++;
				vec->__unsafe_set(i,array->__get(i));
			}
		}
		_g20 = vec;
	}
	this->njZZ = _g20;
	Array< ::Dynamic > _g22;
	{
		Array< ::Dynamic > array = Array_obj< ::Dynamic >::__new().Add(null()).Add(null()).Add(null()).Add(null());
		Array< ::Dynamic > vec;
		struct _Function_2_1{
			inline static Array< ::Dynamic > Block( Array< ::Dynamic > &array){
				{
					Array< ::Dynamic > this1;
					Array< ::Dynamic > _g21 = Array_obj< ::Dynamic >::__new()->__SetSizeExact(array->length);
					this1 = _g21;
					return this1;
				}
				return null();
			}
		};
		vec = _Function_2_1::Block(array);
		{
			int _g1 = (int)0;
			int _g = array->length;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int i = (_g1)++;
				vec->__unsafe_set(i,array->__get(i).StaticCast< ::haxe::io::Bytes >());
			}
		}
		_g22 = vec;
	}
	this->vlctab = _g22;
}
;
	return null();
}

//NanoJpeg_obj::~NanoJpeg_obj() { }

Dynamic NanoJpeg_obj::__CreateEmpty() { return  new NanoJpeg_obj; }
hx::ObjectPtr< NanoJpeg_obj > NanoJpeg_obj::__new()
{  hx::ObjectPtr< NanoJpeg_obj > result = new NanoJpeg_obj();
	result->__construct();
	return result;}

Dynamic NanoJpeg_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< NanoJpeg_obj > result = new NanoJpeg_obj();
	result->__construct();
	return result;}

::haxe::io::Bytes NanoJpeg_obj::alloc( int nbytes){
	return ::hxd::impl::Tmp_obj::getBytes(nbytes);
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,alloc,return )

Void NanoJpeg_obj::free( ::haxe::io::Bytes bytes){
{
		::hxd::impl::Tmp_obj::saveBytes(bytes);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,free,(void))

Void NanoJpeg_obj::njInit( ::haxe::io::Bytes bytes,int pos,int size,::hxd::res::Filter filter){
{
		this->bytes = bytes;
		this->pos = pos;
		if (((filter == null()))){
			this->filter = ::hxd::res::Filter_obj::Chromatic;
		}
		else{
			this->filter = filter;
		}
		if (((size < (int)0))){
			size = (bytes->length - pos);
		}
		{
			int _g = (int)0;
			while((true)){
				if ((!(((_g < (int)4))))){
					break;
				}
				int i = (_g)++;
				::haxe::io::Bytes _g1 = this->vlctab->__unsafe_get(i);
				if (((_g1 == null()))){
					::haxe::io::Bytes val = ::hxd::impl::Tmp_obj::getBytes((int)131072);
					this->vlctab->__unsafe_set(i,val);
				}
			}
		}
		this->size = size;
		this->qtused = (int)0;
		this->qtavail = (int)0;
		this->rstinterval = (int)0;
		this->buf = (int)0;
		this->bufbits = (int)0;
		{
			int _g = (int)0;
			while((true)){
				if ((!(((_g < (int)3))))){
					break;
				}
				int i = (_g)++;
				this->comps->__unsafe_get(i)->__FieldRef(HX_CSTRING("dcpred")) = (int)0;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(NanoJpeg_obj,njInit,(void))

Void NanoJpeg_obj::cleanup( ){
{
		this->bytes = null();
		{
			int _g = (int)0;
			Array< ::Dynamic > _g1 = this->comps;
			while((true)){
				if ((!(((_g < _g1->length))))){
					break;
				}
				::hxd::res::_NanoJpeg::Component c = _g1->__unsafe_get(_g);
				++(_g);
				if (((c->pixels != null()))){
					::hxd::impl::Tmp_obj::saveBytes(c->pixels);
					c->pixels = null();
				}
			}
		}
		{
			int _g = (int)0;
			while((true)){
				if ((!(((_g < (int)4))))){
					break;
				}
				int i = (_g)++;
				::haxe::io::Bytes _g1 = this->vlctab->__unsafe_get(i);
				if (((_g1 != null()))){
					{
						::haxe::io::Bytes bytes = this->vlctab->__unsafe_get(i);
						::hxd::impl::Tmp_obj::saveBytes(bytes);
					}
					this->vlctab->__unsafe_set(i,null());
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,cleanup,(void))

Void NanoJpeg_obj::njSkip( int count){
{
		hx::AddEq(this->pos,count);
		hx::SubEq(this->size,count);
		hx::SubEq(this->length,count);
		if (((this->size < (int)0))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njSkip,(void))

Void NanoJpeg_obj::syntax( bool flag){
{
		if ((flag)){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,syntax,(void))

int NanoJpeg_obj::get( int p){
	return this->bytes->b->__get((this->pos + p));
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,get,return )

int NanoJpeg_obj::njDecode16( int p){
	return (int((int(this->bytes->b->__get((this->pos + p))) << int((int)8))) | int(this->bytes->b->__get((this->pos + ((p + (int)1))))));
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njDecode16,return )

Void NanoJpeg_obj::njByteAlign( ){
{
		hx::AndEq(this->bufbits,(int)248);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njByteAlign,(void))

int NanoJpeg_obj::njShowBits( int bits){
	if (((bits == (int)0))){
		return (int)0;
	}
	while((true)){
		if ((!(((this->bufbits < bits))))){
			break;
		}
		if (((this->size <= (int)0))){
			this->buf = (int((int(this->buf) << int((int)8))) | int((int)255));
			hx::AddEq(this->bufbits,(int)8);
			continue;
		}
		int newbyte = this->bytes->b->__get(this->pos);
		(this->pos)++;
		(this->size)--;
		hx::AddEq(this->bufbits,(int)8);
		this->buf = (int((int(this->buf) << int((int)8))) | int(newbyte));
		if (((newbyte == (int)255))){
			if (((this->size == (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			int marker = this->bytes->b->__get(this->pos);
			(this->pos)++;
			(this->size)--;
			switch( (int)(marker)){
				case (int)0: case (int)255: {
				}
				;break;
				case (int)217: {
					this->size = (int)0;
				}
				;break;
				default: {
					if (((((int(marker) & int((int)248))) != (int)208))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
					this->buf = (int((int(this->buf) << int((int)8))) | int(marker));
					hx::AddEq(this->bufbits,(int)8);
				}
			}
		}
	}
	return (int((int(this->buf) >> int((this->bufbits - bits)))) & int((((int((int)1) << int(bits))) - (int)1)));
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njShowBits,return )

Void NanoJpeg_obj::njSkipBits( int bits){
{
		if (((this->bufbits < bits))){
			this->njShowBits(bits);
		}
		hx::SubEq(this->bufbits,bits);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njSkipBits,(void))

int NanoJpeg_obj::njGetBits( int bits){
	int r = this->njShowBits(bits);
	hx::SubEq(this->bufbits,bits);
	return r;
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njGetBits,return )

Void NanoJpeg_obj::njDecodeLength( ){
{
		if (((this->size < (int)2))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
		this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
		if (((this->length > this->size))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
		{
			hx::AddEq(this->pos,(int)2);
			hx::SubEq(this->size,(int)2);
			hx::SubEq(this->length,(int)2);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njDecodeLength,(void))

Void NanoJpeg_obj::njSkipMarker( ){
{
		{
			if (((this->size < (int)2))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
			if (((this->length > this->size))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				hx::AddEq(this->pos,(int)2);
				hx::SubEq(this->size,(int)2);
				hx::SubEq(this->length,(int)2);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
		}
		{
			int count = this->length;
			hx::AddEq(this->pos,count);
			hx::SubEq(this->size,count);
			hx::SubEq(this->length,count);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njSkipMarker,(void))

Void NanoJpeg_obj::njDecodeSOF( ){
{
		{
			if (((this->size < (int)2))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
			if (((this->length > this->size))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				hx::AddEq(this->pos,(int)2);
				hx::SubEq(this->size,(int)2);
				hx::SubEq(this->length,(int)2);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
		}
		if (((this->length < (int)9))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
		if (((this->bytes->b->__get(this->pos) != (int)8))){
			this->notSupported();
		}
		this->height = (int((int(this->bytes->b->__get((this->pos + (int)1))) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)2))));
		this->width = (int((int(this->bytes->b->__get((this->pos + (int)3))) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)4))));
		this->ncomp = this->bytes->b->__get((this->pos + (int)5));
		{
			hx::AddEq(this->pos,(int)6);
			hx::SubEq(this->size,(int)6);
			hx::SubEq(this->length,(int)6);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
		{
			int _g = this->ncomp;
			switch( (int)(_g)){
				case (int)1: case (int)3: {
				}
				;break;
				default: {
					this->notSupported();
				}
			}
		}
		if (((this->length < (this->ncomp * (int)3)))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
		int ssxmax = (int)0;
		int ssymax = (int)0;
		{
			int _g1 = (int)0;
			int _g = this->ncomp;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int i = (_g1)++;
				::hxd::res::_NanoJpeg::Component c = this->comps->__unsafe_get(i);
				c->cid = this->bytes->b->__get(this->pos);
				c->ssx = (int(this->bytes->b->__get((this->pos + (int)1))) >> int((int)4));
				if (((c->ssx == (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
				if (((((int(c->ssx) & int((c->ssx - (int)1)))) != (int)0))){
					this->notSupported();
				}
				c->ssy = (int(this->bytes->b->__get((this->pos + (int)1))) & int((int)15));
				if (((c->ssy == (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
				if (((((int(c->ssy) & int((c->ssy - (int)1)))) != (int)0))){
					this->notSupported();
				}
				c->qtsel = this->bytes->b->__get((this->pos + (int)2));
				if (((((int(c->qtsel) & int((int)252))) != (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
				{
					hx::AddEq(this->pos,(int)3);
					hx::SubEq(this->size,(int)3);
					hx::SubEq(this->length,(int)3);
					if (((this->size < (int)0))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
				}
				hx::OrEq(this->qtused,(int((int)1) << int(c->qtsel)));
				if (((c->ssx > ssxmax))){
					ssxmax = c->ssx;
				}
				if (((c->ssy > ssymax))){
					ssymax = c->ssy;
				}
			}
		}
		if (((this->ncomp == (int)1))){
			::hxd::res::_NanoJpeg::Component c = this->comps->__unsafe_get((int)0);
			int _g = ssymax = (int)1;
			int _g1 = ssxmax = _g;
			int _g2 = c->ssy = _g1;
			c->ssx = _g2;
		}
		this->mbsizex = (int(ssxmax) << int((int)3));
		this->mbsizey = (int(ssymax) << int((int)3));
		int _g3 = ::Std_obj::_int((Float((((this->width + this->mbsizex) - (int)1))) / Float(this->mbsizex)));
		this->mbwidth = _g3;
		int _g4 = ::Std_obj::_int((Float((((this->height + this->mbsizey) - (int)1))) / Float(this->mbsizey)));
		this->mbheight = _g4;
		{
			int _g1 = (int)0;
			int _g = this->ncomp;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int i = (_g1)++;
				::hxd::res::_NanoJpeg::Component c = this->comps->__unsafe_get(i);
				int _g5 = ::Std_obj::_int((Float(((((this->width * c->ssx) + ssxmax) - (int)1))) / Float(ssxmax)));
				c->width = _g5;
				c->stride = (int((c->width + (int)7)) & int((int)2147483640));
				int _g6 = ::Std_obj::_int((Float(((((this->height * c->ssy) + ssymax) - (int)1))) / Float(ssymax)));
				c->height = _g6;
				int _g7 = ::Std_obj::_int((Float(((this->mbwidth * this->mbsizex) * c->ssx)) / Float(ssxmax)));
				c->stride = _g7;
				if (((bool((bool((c->width < (int)3)) && bool((c->ssx != ssxmax)))) || bool((bool((c->height < (int)3)) && bool((c->ssy != ssymax))))))){
					this->notSupported();
				}
				::haxe::io::Bytes _g9;
				{
					int _g8 = ::Std_obj::_int((Float(((this->mbheight * this->mbsizey) * c->ssy)) / Float(ssymax)));
					int nbytes = (c->stride * _g8);
					_g9 = ::hxd::impl::Tmp_obj::getBytes(nbytes);
				}
				c->pixels = _g9;
			}
		}
		{
			int count = this->length;
			hx::AddEq(this->pos,count);
			hx::SubEq(this->size,count);
			hx::SubEq(this->length,count);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njDecodeSOF,(void))

Void NanoJpeg_obj::njDecodeDQT( ){
{
		{
			if (((this->size < (int)2))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
			if (((this->length > this->size))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				hx::AddEq(this->pos,(int)2);
				hx::SubEq(this->size,(int)2);
				hx::SubEq(this->length,(int)2);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
		}
		while((true)){
			if ((!(((this->length >= (int)65))))){
				break;
			}
			int i = this->bytes->b->__get(this->pos);
			if (((((int(i) & int((int)252))) != (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			hx::OrEq(this->qtavail,(int((int)1) << int(i)));
			Array< int > t = this->qtab->__unsafe_get(i);
			{
				int _g = (int)0;
				while((true)){
					if ((!(((_g < (int)64))))){
						break;
					}
					int k = (_g)++;
					t->__unsafe_set(k,this->bytes->b->__get((this->pos + ((k + (int)1)))));
				}
			}
			{
				hx::AddEq(this->pos,(int)65);
				hx::SubEq(this->size,(int)65);
				hx::SubEq(this->length,(int)65);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
		}
		if (((this->length != (int)0))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njDecodeDQT,(void))

Void NanoJpeg_obj::njDecodeDHT( ){
{
		{
			if (((this->size < (int)2))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
			if (((this->length > this->size))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				hx::AddEq(this->pos,(int)2);
				hx::SubEq(this->size,(int)2);
				hx::SubEq(this->length,(int)2);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
		}
		while((true)){
			if ((!(((this->length >= (int)17))))){
				break;
			}
			int i = this->bytes->b->__get(this->pos);
			if (((((int(i) & int((int)236))) != (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			if (((((int(i) & int((int)2))) != (int)0))){
				this->notSupported();
			}
			i = (int(((int(i) | int((int(i) >> int((int)3)))))) & int((int)3));
			{
				int _g = (int)0;
				while((true)){
					if ((!(((_g < (int)16))))){
						break;
					}
					int codelen = (_g)++;
					this->counts->__unsafe_set(codelen,this->bytes->b->__get((this->pos + ((codelen + (int)1)))));
				}
			}
			{
				hx::AddEq(this->pos,(int)17);
				hx::SubEq(this->size,(int)17);
				hx::SubEq(this->length,(int)17);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
			::haxe::io::Bytes vlc = this->vlctab->__unsafe_get(i);
			int vpos = (int)0;
			int remain = (int)65536;
			int spread = (int)65536;
			{
				int _g = (int)1;
				while((true)){
					if ((!(((_g < (int)17))))){
						break;
					}
					int codelen = (_g)++;
					hx::ShrEq(spread,(int)1);
					int currcnt = this->counts->__unsafe_get((codelen - (int)1));
					if (((currcnt == (int)0))){
						continue;
					}
					if (((this->length < currcnt))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
					hx::SubEq(remain,(int(currcnt) << int(((int)16 - codelen))));
					if (((remain < (int)0))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
					{
						int _g1 = (int)0;
						while((true)){
							if ((!(((_g1 < currcnt))))){
								break;
							}
							int i1 = (_g1)++;
							int code = this->bytes->b->__get((this->pos + i1));
							{
								int _g2 = (int)0;
								while((true)){
									if ((!(((_g2 < spread))))){
										break;
									}
									int j = (_g2)++;
									{
										int pos = (vpos)++;
										vlc->b[pos] = codelen;
									}
									{
										int pos = (vpos)++;
										vlc->b[pos] = code;
									}
								}
							}
						}
					}
					{
						hx::AddEq(this->pos,currcnt);
						hx::SubEq(this->size,currcnt);
						hx::SubEq(this->length,currcnt);
						if (((this->size < (int)0))){
							HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
						}
					}
				}
			}
			while((true)){
				int _g = (remain)--;
				if ((!(((_g != (int)0))))){
					break;
				}
				vlc->b[vpos] = (int)0;
				hx::AddEq(vpos,(int)2);
			}
		}
		if (((this->length != (int)0))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njDecodeDHT,(void))

Void NanoJpeg_obj::njDecodeDRI( ){
{
		{
			if (((this->size < (int)2))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
			if (((this->length > this->size))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				hx::AddEq(this->pos,(int)2);
				hx::SubEq(this->size,(int)2);
				hx::SubEq(this->length,(int)2);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
		}
		if (((this->length < (int)2))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
		this->rstinterval = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
		{
			int count = this->length;
			hx::AddEq(this->pos,count);
			hx::SubEq(this->size,count);
			hx::SubEq(this->length,count);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njDecodeDRI,(void))

int NanoJpeg_obj::njGetVLC( ::haxe::io::Bytes vlc){
	int value = this->njShowBits((int)16);
	int bits = vlc->b->__get((int(value) << int((int)1)));
	if (((bits == (int)0))){
		HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
	}
	{
		if (((this->bufbits < bits))){
			this->njShowBits(bits);
		}
		hx::SubEq(this->bufbits,bits);
	}
	value = vlc->b->__get((int((int(value) << int((int)1))) | int((int)1)));
	this->vlcCode = value;
	bits = (int(value) & int((int)15));
	if (((bits == (int)0))){
		return (int)0;
	}
	int _g;
	{
		int r = this->njShowBits(bits);
		hx::SubEq(this->bufbits,bits);
		_g = r;
	}
	value = _g;
	if (((value < (int((int)1) << int((bits - (int)1)))))){
		hx::AddEq(value,(((int((int)-1) << int(bits))) + (int)1));
	}
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njGetVLC,return )

Void NanoJpeg_obj::njRowIDCT( int bp){
{
		int x0;
		int x1;
		int x2;
		int x3;
		int x4;
		int x5;
		int x6;
		int x7;
		int x8;
		int _g = this->block->__unsafe_get((bp + (int)4));
		int _g1 = (int(_g) << int((int)11));
		int _g2 = x1 = _g1;
		int _g3 = this->block->__unsafe_get((bp + (int)6));
		int _g4 = x2 = _g3;
		int _g5 = (int(_g2) | int(_g4));
		int _g6 = this->block->__unsafe_get((bp + (int)2));
		int _g7 = x3 = _g6;
		int _g8 = (int(_g5) | int(_g7));
		int _g9 = this->block->__unsafe_get((bp + (int)1));
		int _g10 = x4 = _g9;
		int _g11 = (int(_g8) | int(_g10));
		int _g12 = this->block->__unsafe_get((bp + (int)7));
		int _g13 = x5 = _g12;
		int _g14 = (int(_g11) | int(_g13));
		int _g15 = this->block->__unsafe_get((bp + (int)5));
		int _g16 = x6 = _g15;
		int _g17 = (int(_g14) | int(_g16));
		int _g18 = this->block->__unsafe_get((bp + (int)3));
		int _g19 = x7 = _g18;
		int _g20 = (int(_g17) | int(_g19));
		if (((_g20 == (int)0))){
			{
				int val;
				{
					int val1;
					{
						int val2;
						{
							int val3;
							{
								int val4;
								{
									int val5;
									{
										int val6;
										{
											int _g21 = this->block->__unsafe_get(bp);
											int val7 = (int(_g21) << int((int)3));
											val6 = this->block->__unsafe_set((bp + (int)7),val7);
										}
										val5 = this->block->__unsafe_set((bp + (int)6),val6);
									}
									val4 = this->block->__unsafe_set((bp + (int)5),val5);
								}
								val3 = this->block->__unsafe_set((bp + (int)4),val4);
							}
							val2 = this->block->__unsafe_set((bp + (int)3),val3);
						}
						val1 = this->block->__unsafe_set((bp + (int)2),val2);
					}
					val = this->block->__unsafe_set((bp + (int)1),val1);
				}
				this->block->__unsafe_set(bp,val);
			}
			return null();
		}
		int _g22 = this->block->__unsafe_get(bp);
		int _g23 = (int(_g22) << int((int)11));
		int _g24 = (_g23 + (int)128);
		x0 = _g24;
		x8 = ((int)565 * ((x4 + x5)));
		x4 = (x8 + ((int)2276 * x4));
		x5 = (x8 - ((int)3406 * x5));
		x8 = ((int)2408 * ((x6 + x7)));
		x6 = (x8 - ((int)799 * x6));
		x7 = (x8 - ((int)4017 * x7));
		x8 = (x0 + x1);
		hx::SubEq(x0,x1);
		x1 = ((int)1108 * ((x3 + x2)));
		x2 = (x1 - ((int)3784 * x2));
		x3 = (x1 + ((int)1568 * x3));
		x1 = (x4 + x6);
		hx::SubEq(x4,x6);
		x6 = (x5 + x7);
		hx::SubEq(x5,x7);
		x7 = (x8 + x3);
		hx::SubEq(x8,x3);
		x3 = (x0 + x2);
		hx::SubEq(x0,x2);
		x2 = (int((((int)181 * ((x4 + x5))) + (int)128)) >> int((int)8));
		x4 = (int((((int)181 * ((x4 - x5))) + (int)128)) >> int((int)8));
		this->block->__unsafe_set(bp,(int((x7 + x1)) >> int((int)8)));
		this->block->__unsafe_set((bp + (int)1),(int((x3 + x2)) >> int((int)8)));
		this->block->__unsafe_set((bp + (int)2),(int((x0 + x4)) >> int((int)8)));
		this->block->__unsafe_set((bp + (int)3),(int((x8 + x6)) >> int((int)8)));
		this->block->__unsafe_set((bp + (int)4),(int((x8 - x6)) >> int((int)8)));
		this->block->__unsafe_set((bp + (int)5),(int((x0 - x4)) >> int((int)8)));
		this->block->__unsafe_set((bp + (int)6),(int((x3 - x2)) >> int((int)8)));
		this->block->__unsafe_set((bp + (int)7),(int((x7 - x1)) >> int((int)8)));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njRowIDCT,(void))

Void NanoJpeg_obj::njColIDCT( int bp,::haxe::io::Bytes out,int po,int stride){
{
		int x0;
		int x1;
		int x2;
		int x3;
		int x4;
		int x5;
		int x6;
		int x7;
		int x8;
		int _g = this->block->__unsafe_get((bp + (int)32));
		int _g1 = (int(_g) << int((int)8));
		int _g2 = x1 = _g1;
		int _g3 = this->block->__unsafe_get((bp + (int)48));
		int _g4 = x2 = _g3;
		int _g5 = (int(_g2) | int(_g4));
		int _g6 = this->block->__unsafe_get((bp + (int)16));
		int _g7 = x3 = _g6;
		int _g8 = (int(_g5) | int(_g7));
		int _g9 = this->block->__unsafe_get((bp + (int)8));
		int _g10 = x4 = _g9;
		int _g11 = (int(_g8) | int(_g10));
		int _g12 = this->block->__unsafe_get((bp + (int)56));
		int _g13 = x5 = _g12;
		int _g14 = (int(_g11) | int(_g13));
		int _g15 = this->block->__unsafe_get((bp + (int)40));
		int _g16 = x6 = _g15;
		int _g17 = (int(_g14) | int(_g16));
		int _g18 = this->block->__unsafe_get((bp + (int)24));
		int _g19 = x7 = _g18;
		int _g20 = (int(_g17) | int(_g19));
		if (((_g20 == (int)0))){
			int _g24;
			{
				int _g21 = this->block->__unsafe_get(bp);
				int _g22 = (_g21 + (int)32);
				int _g23 = (int(_g22) >> int((int)6));
				int x = (_g23 + (int)128);
				if (((x < (int)0))){
					_g24 = (int)0;
				}
				else{
					if (((x > (int)255))){
						_g24 = (int)255;
					}
					else{
						_g24 = x;
					}
				}
			}
			x1 = _g24;
			{
				int _g21 = (int)0;
				while((true)){
					if ((!(((_g21 < (int)8))))){
						break;
					}
					int i = (_g21)++;
					out->b[po] = x1;
					hx::AddEq(po,stride);
				}
			}
			return null();
		}
		int _g25 = this->block->__unsafe_get(bp);
		int _g26 = (int(_g25) << int((int)8));
		int _g27 = (_g26 + (int)8192);
		x0 = _g27;
		x8 = (((int)565 * ((x4 + x5))) + (int)4);
		x4 = (int((x8 + ((int)2276 * x4))) >> int((int)3));
		x5 = (int((x8 - ((int)3406 * x5))) >> int((int)3));
		x8 = (((int)2408 * ((x6 + x7))) + (int)4);
		x6 = (int((x8 - ((int)799 * x6))) >> int((int)3));
		x7 = (int((x8 - ((int)4017 * x7))) >> int((int)3));
		x8 = (x0 + x1);
		hx::SubEq(x0,x1);
		x1 = (((int)1108 * ((x3 + x2))) + (int)4);
		x2 = (int((x1 - ((int)3784 * x2))) >> int((int)3));
		x3 = (int((x1 + ((int)1568 * x3))) >> int((int)3));
		x1 = (x4 + x6);
		hx::SubEq(x4,x6);
		x6 = (x5 + x7);
		hx::SubEq(x5,x7);
		x7 = (x8 + x3);
		hx::SubEq(x8,x3);
		x3 = (x0 + x2);
		hx::SubEq(x0,x2);
		x2 = (int((((int)181 * ((x4 + x5))) + (int)128)) >> int((int)8));
		x4 = (int((((int)181 * ((x4 - x5))) + (int)128)) >> int((int)8));
		{
			int x = (((int((x7 + x1)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
		hx::AddEq(po,stride);
		{
			int x = (((int((x3 + x2)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
		hx::AddEq(po,stride);
		{
			int x = (((int((x0 + x4)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
		hx::AddEq(po,stride);
		{
			int x = (((int((x8 + x6)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
		hx::AddEq(po,stride);
		{
			int x = (((int((x8 - x6)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
		hx::AddEq(po,stride);
		{
			int x = (((int((x0 - x4)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
		hx::AddEq(po,stride);
		{
			int x = (((int((x3 - x2)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
		hx::AddEq(po,stride);
		{
			int x = (((int((x7 - x1)) >> int((int)14))) + (int)128);
			if (((x < (int)0))){
				out->b[po] = (int)0;
			}
			else{
				if (((x > (int)255))){
					out->b[po] = (int)255;
				}
				else{
					out->b[po] = x;
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(NanoJpeg_obj,njColIDCT,(void))

Void NanoJpeg_obj::njDecodeBlock( ::hxd::res::_NanoJpeg::Component c,int po){
{
		::haxe::io::Bytes out = c->pixels;
		int value;
		int coef = (int)0;
		{
			int _g = (int)0;
			while((true)){
				if ((!(((_g < (int)64))))){
					break;
				}
				int i = (_g)++;
				this->block->__unsafe_set(i,(int)0);
			}
		}
		int _g1;
		{
			::haxe::io::Bytes vlc = this->vlctab->__unsafe_get(c->dctabsel);
			int value1 = this->njShowBits((int)16);
			int bits = vlc->b->__get((int(value1) << int((int)1)));
			if (((bits == (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				if (((this->bufbits < bits))){
					this->njShowBits(bits);
				}
				hx::SubEq(this->bufbits,bits);
			}
			value1 = vlc->b->__get((int((int(value1) << int((int)1))) | int((int)1)));
			this->vlcCode = value1;
			bits = (int(value1) & int((int)15));
			if (((bits == (int)0))){
				_g1 = (int)0;
			}
			else{
				int _g;
				{
					int r = this->njShowBits(bits);
					hx::SubEq(this->bufbits,bits);
					_g = r;
				}
				value1 = _g;
				if (((value1 < (int((int)1) << int((bits - (int)1)))))){
					hx::AddEq(value1,(((int((int)-1) << int(bits))) + (int)1));
				}
				_g1 = value1;
			}
		}
		hx::AddEq(c->dcpred,_g1);
		Array< int > qt = this->qtab->__unsafe_get(c->qtsel);
		::haxe::io::Bytes at = this->vlctab->__unsafe_get(c->actabsel);
		{
			int _g2 = qt->__unsafe_get((int)0);
			int val = (c->dcpred * _g2);
			this->block->__unsafe_set((int)0,val);
		}
		while((true)){
			int _g4;
			{
				int value1 = this->njShowBits((int)16);
				int bits = at->b->__get((int(value1) << int((int)1)));
				if (((bits == (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
				{
					if (((this->bufbits < bits))){
						this->njShowBits(bits);
					}
					hx::SubEq(this->bufbits,bits);
				}
				value1 = at->b->__get((int((int(value1) << int((int)1))) | int((int)1)));
				this->vlcCode = value1;
				bits = (int(value1) & int((int)15));
				if (((bits == (int)0))){
					_g4 = (int)0;
				}
				else{
					int _g3;
					{
						int r = this->njShowBits(bits);
						hx::SubEq(this->bufbits,bits);
						_g3 = r;
					}
					value1 = _g3;
					if (((value1 < (int((int)1) << int((bits - (int)1)))))){
						hx::AddEq(value1,(((int((int)-1) << int(bits))) + (int)1));
					}
					_g4 = value1;
				}
			}
			value = _g4;
			if (((this->vlcCode == (int)0))){
				break;
			}
			if (((bool((((int(this->vlcCode) & int((int)15))) == (int)0)) && bool((this->vlcCode != (int)240))))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			hx::AddEq(coef,(((int(this->vlcCode) >> int((int)4))) + (int)1));
			if (((coef > (int)63))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				int index = this->njZZ->__unsafe_get(coef);
				int _g5 = qt->__unsafe_get(coef);
				int val = (value * _g5);
				this->block->__unsafe_set(index,val);
			}
			if ((!(((coef < (int)63))))){
				break;
			}
		}
		{
			int _g = (int)0;
			while((true)){
				if ((!(((_g < (int)8))))){
					break;
				}
				int coef1 = (_g)++;
				int bp = (coef1 * (int)8);
				int x0;
				int x1;
				int x2;
				int x3;
				int x4;
				int x5;
				int x6;
				int x7;
				int x8;
				int _g6 = this->block->__unsafe_get((bp + (int)4));
				int _g7 = (int(_g6) << int((int)11));
				int _g8 = x1 = _g7;
				int _g9 = this->block->__unsafe_get((bp + (int)6));
				int _g10 = x2 = _g9;
				int _g11 = (int(_g8) | int(_g10));
				int _g12 = this->block->__unsafe_get((bp + (int)2));
				int _g13 = x3 = _g12;
				int _g14 = (int(_g11) | int(_g13));
				int _g15 = this->block->__unsafe_get((bp + (int)1));
				int _g16 = x4 = _g15;
				int _g17 = (int(_g14) | int(_g16));
				int _g18 = this->block->__unsafe_get((bp + (int)7));
				int _g19 = x5 = _g18;
				int _g20 = (int(_g17) | int(_g19));
				int _g21 = this->block->__unsafe_get((bp + (int)5));
				int _g22 = x6 = _g21;
				int _g23 = (int(_g20) | int(_g22));
				int _g24 = this->block->__unsafe_get((bp + (int)3));
				int _g25 = x7 = _g24;
				int _g26 = (int(_g23) | int(_g25));
				if (((_g26 == (int)0))){
					{
						int val;
						{
							int val1;
							{
								int val2;
								{
									int val3;
									{
										int val4;
										{
											int val5;
											{
												int val6;
												{
													int _g27 = this->block->__unsafe_get(bp);
													int val7 = (int(_g27) << int((int)3));
													val6 = this->block->__unsafe_set((bp + (int)7),val7);
												}
												val5 = this->block->__unsafe_set((bp + (int)6),val6);
											}
											val4 = this->block->__unsafe_set((bp + (int)5),val5);
										}
										val3 = this->block->__unsafe_set((bp + (int)4),val4);
									}
									val2 = this->block->__unsafe_set((bp + (int)3),val3);
								}
								val1 = this->block->__unsafe_set((bp + (int)2),val2);
							}
							val = this->block->__unsafe_set((bp + (int)1),val1);
						}
						this->block->__unsafe_set(bp,val);
					}
					Dynamic();
				}
				else{
					int _g28 = this->block->__unsafe_get(bp);
					int _g29 = (int(_g28) << int((int)11));
					int _g30 = (_g29 + (int)128);
					x0 = _g30;
					x8 = ((int)565 * ((x4 + x5)));
					x4 = (x8 + ((int)2276 * x4));
					x5 = (x8 - ((int)3406 * x5));
					x8 = ((int)2408 * ((x6 + x7)));
					x6 = (x8 - ((int)799 * x6));
					x7 = (x8 - ((int)4017 * x7));
					x8 = (x0 + x1);
					hx::SubEq(x0,x1);
					x1 = ((int)1108 * ((x3 + x2)));
					x2 = (x1 - ((int)3784 * x2));
					x3 = (x1 + ((int)1568 * x3));
					x1 = (x4 + x6);
					hx::SubEq(x4,x6);
					x6 = (x5 + x7);
					hx::SubEq(x5,x7);
					x7 = (x8 + x3);
					hx::SubEq(x8,x3);
					x3 = (x0 + x2);
					hx::SubEq(x0,x2);
					x2 = (int((((int)181 * ((x4 + x5))) + (int)128)) >> int((int)8));
					x4 = (int((((int)181 * ((x4 - x5))) + (int)128)) >> int((int)8));
					this->block->__unsafe_set(bp,(int((x7 + x1)) >> int((int)8)));
					this->block->__unsafe_set((bp + (int)1),(int((x3 + x2)) >> int((int)8)));
					this->block->__unsafe_set((bp + (int)2),(int((x0 + x4)) >> int((int)8)));
					this->block->__unsafe_set((bp + (int)3),(int((x8 + x6)) >> int((int)8)));
					this->block->__unsafe_set((bp + (int)4),(int((x8 - x6)) >> int((int)8)));
					this->block->__unsafe_set((bp + (int)5),(int((x0 - x4)) >> int((int)8)));
					this->block->__unsafe_set((bp + (int)6),(int((x3 - x2)) >> int((int)8)));
					this->block->__unsafe_set((bp + (int)7),(int((x7 - x1)) >> int((int)8)));
				}
			}
		}
		{
			int _g = (int)0;
			while((true)){
				if ((!(((_g < (int)8))))){
					break;
				}
				int coef1 = (_g)++;
				int po1 = (coef1 + po);
				int stride = c->stride;
				int x0;
				int x1;
				int x2;
				int x3;
				int x4;
				int x5;
				int x6;
				int x7;
				int x8;
				int _g31 = this->block->__unsafe_get((coef1 + (int)32));
				int _g32 = (int(_g31) << int((int)8));
				int _g33 = x1 = _g32;
				int _g34 = this->block->__unsafe_get((coef1 + (int)48));
				int _g35 = x2 = _g34;
				int _g36 = (int(_g33) | int(_g35));
				int _g37 = this->block->__unsafe_get((coef1 + (int)16));
				int _g38 = x3 = _g37;
				int _g39 = (int(_g36) | int(_g38));
				int _g40 = this->block->__unsafe_get((coef1 + (int)8));
				int _g41 = x4 = _g40;
				int _g42 = (int(_g39) | int(_g41));
				int _g43 = this->block->__unsafe_get((coef1 + (int)56));
				int _g44 = x5 = _g43;
				int _g45 = (int(_g42) | int(_g44));
				int _g46 = this->block->__unsafe_get((coef1 + (int)40));
				int _g47 = x6 = _g46;
				int _g48 = (int(_g45) | int(_g47));
				int _g49 = this->block->__unsafe_get((coef1 + (int)24));
				int _g50 = x7 = _g49;
				int _g51 = (int(_g48) | int(_g50));
				if (((_g51 == (int)0))){
					int _g55;
					{
						int _g52 = this->block->__unsafe_get(coef1);
						int _g53 = (_g52 + (int)32);
						int _g54 = (int(_g53) >> int((int)6));
						int x = (_g54 + (int)128);
						if (((x < (int)0))){
							_g55 = (int)0;
						}
						else{
							if (((x > (int)255))){
								_g55 = (int)255;
							}
							else{
								_g55 = x;
							}
						}
					}
					x1 = _g55;
					{
						int _g2 = (int)0;
						while((true)){
							if ((!(((_g2 < (int)8))))){
								break;
							}
							int i = (_g2)++;
							out->b[po1] = x1;
							hx::AddEq(po1,stride);
						}
					}
					Dynamic();
				}
				else{
					int _g56 = this->block->__unsafe_get(coef1);
					int _g57 = (int(_g56) << int((int)8));
					int _g58 = (_g57 + (int)8192);
					x0 = _g58;
					x8 = (((int)565 * ((x4 + x5))) + (int)4);
					x4 = (int((x8 + ((int)2276 * x4))) >> int((int)3));
					x5 = (int((x8 - ((int)3406 * x5))) >> int((int)3));
					x8 = (((int)2408 * ((x6 + x7))) + (int)4);
					x6 = (int((x8 - ((int)799 * x6))) >> int((int)3));
					x7 = (int((x8 - ((int)4017 * x7))) >> int((int)3));
					x8 = (x0 + x1);
					hx::SubEq(x0,x1);
					x1 = (((int)1108 * ((x3 + x2))) + (int)4);
					x2 = (int((x1 - ((int)3784 * x2))) >> int((int)3));
					x3 = (int((x1 + ((int)1568 * x3))) >> int((int)3));
					x1 = (x4 + x6);
					hx::SubEq(x4,x6);
					x6 = (x5 + x7);
					hx::SubEq(x5,x7);
					x7 = (x8 + x3);
					hx::SubEq(x8,x3);
					x3 = (x0 + x2);
					hx::SubEq(x0,x2);
					x2 = (int((((int)181 * ((x4 + x5))) + (int)128)) >> int((int)8));
					x4 = (int((((int)181 * ((x4 - x5))) + (int)128)) >> int((int)8));
					{
						int x = (((int((x7 + x1)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
					hx::AddEq(po1,stride);
					{
						int x = (((int((x3 + x2)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
					hx::AddEq(po1,stride);
					{
						int x = (((int((x0 + x4)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
					hx::AddEq(po1,stride);
					{
						int x = (((int((x8 + x6)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
					hx::AddEq(po1,stride);
					{
						int x = (((int((x8 - x6)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
					hx::AddEq(po1,stride);
					{
						int x = (((int((x0 - x4)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
					hx::AddEq(po1,stride);
					{
						int x = (((int((x3 - x2)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
					hx::AddEq(po1,stride);
					{
						int x = (((int((x7 - x1)) >> int((int)14))) + (int)128);
						if (((x < (int)0))){
							out->b[po1] = (int)0;
						}
						else{
							if (((x > (int)255))){
								out->b[po1] = (int)255;
							}
							else{
								out->b[po1] = x;
							}
						}
					}
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(NanoJpeg_obj,njDecodeBlock,(void))

Void NanoJpeg_obj::notSupported( ){
{
		HX_STACK_DO_THROW(HX_CSTRING("This JPG file is not supported"));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,notSupported,(void))

Void NanoJpeg_obj::njDecodeScan( ){
{
		{
			if (((this->size < (int)2))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
			if (((this->length > this->size))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
			{
				hx::AddEq(this->pos,(int)2);
				hx::SubEq(this->size,(int)2);
				hx::SubEq(this->length,(int)2);
				if (((this->size < (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
			}
		}
		if (((this->length < ((int)4 + ((int)2 * this->ncomp))))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
		if (((this->bytes->b->__get(this->pos) != this->ncomp))){
			this->notSupported();
		}
		{
			hx::AddEq(this->pos,(int)1);
			hx::SubEq(this->size,(int)1);
			hx::SubEq(this->length,(int)1);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
		{
			int _g1 = (int)0;
			int _g = this->ncomp;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int i = (_g1)++;
				::hxd::res::_NanoJpeg::Component c = this->comps->__unsafe_get(i);
				if (((this->bytes->b->__get(this->pos) != c->cid))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
				if (((((int(this->bytes->b->__get((this->pos + (int)1))) & int((int)238))) != (int)0))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
				c->dctabsel = (int(this->bytes->b->__get((this->pos + (int)1))) >> int((int)4));
				c->actabsel = (int((int(this->bytes->b->__get((this->pos + (int)1))) & int((int)1))) | int((int)2));
				{
					hx::AddEq(this->pos,(int)2);
					hx::SubEq(this->size,(int)2);
					hx::SubEq(this->length,(int)2);
					if (((this->size < (int)0))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
				}
			}
		}
		if (((bool((bool((this->bytes->b->__get(this->pos) != (int)0)) || bool((this->bytes->b->__get((this->pos + (int)1)) != (int)63)))) || bool((this->bytes->b->__get((this->pos + (int)2)) != (int)0))))){
			this->notSupported();
		}
		{
			int count = this->length;
			hx::AddEq(this->pos,count);
			hx::SubEq(this->size,count);
			hx::SubEq(this->length,count);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
		int mbx = (int)0;
		int mby = (int)0;
		int rstcount = this->rstinterval;
		int nextrst = (int)0;
		while((true)){
			{
				int _g1 = (int)0;
				int _g = this->ncomp;
				while((true)){
					if ((!(((_g1 < _g))))){
						break;
					}
					int i = (_g1)++;
					::hxd::res::_NanoJpeg::Component c = this->comps->__unsafe_get(i);
					{
						int _g3 = (int)0;
						int _g2 = c->ssy;
						while((true)){
							if ((!(((_g3 < _g2))))){
								break;
							}
							int sby = (_g3)++;
							int _g5 = (int)0;
							int _g4 = c->ssx;
							while((true)){
								if ((!(((_g5 < _g4))))){
									break;
								}
								int sbx = (_g5)++;
								this->njDecodeBlock(c,(int(((((((mby * c->ssy) + sby)) * c->stride) + (mbx * c->ssx)) + sbx)) << int((int)3)));
							}
						}
					}
				}
			}
			int _g = ++(mbx);
			if (((_g >= this->mbwidth))){
				mbx = (int)0;
				int _g1 = ++(mby);
				if (((_g1 >= this->mbheight))){
					break;
				}
			}
			struct _Function_2_1{
				inline static bool Block( int &rstcount){
					{
						int _g2 = --(rstcount);
						return (_g2 == (int)0);
					}
					return null();
				}
			};
			if (((  (((this->rstinterval != (int)0))) ? bool(_Function_2_1::Block(rstcount)) : bool(false) ))){
				hx::AndEq(this->bufbits,(int)248);
				int i;
				{
					int r = this->njShowBits((int)16);
					hx::SubEq(this->bufbits,(int)16);
					i = r;
				}
				if (((bool((((int(i) & int((int)65528))) != (int)65488)) || bool((((int(i) & int((int)7))) != nextrst))))){
					HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
				}
				nextrst = (int((nextrst + (int)1)) & int((int)7));
				rstcount = this->rstinterval;
				{
					int _g1 = (int)0;
					while((true)){
						if ((!(((_g1 < (int)3))))){
							break;
						}
						int i1 = (_g1)++;
						this->comps->__unsafe_get(i1)->__FieldRef(HX_CSTRING("dcpred")) = (int)0;
					}
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njDecodeScan,(void))

Void NanoJpeg_obj::njUpsampleH( ::hxd::res::_NanoJpeg::Component c){
{
		int xmax = (c->width - (int)3);
		::haxe::io::Bytes cout = ::hxd::impl::Tmp_obj::getBytes((int((c->width * c->height)) << int((int)1)));
		::haxe::io::Bytes lout = cout;
		::haxe::io::Bytes lin = c->pixels;
		int pi = (int)0;
		int po = (int)0;
		{
			int _g1 = (int)0;
			int _g = c->height;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int y = (_g1)++;
				{
					int x = (int(((((int)139 * lin->b->__get(pi)) + ((int)-11 * lin->b->__get((pi + (int)1)))) + (int)64)) >> int((int)7));
					if (((x < (int)0))){
						lout->b[po] = (int)0;
					}
					else{
						if (((x > (int)255))){
							lout->b[po] = (int)255;
						}
						else{
							lout->b[po] = x;
						}
					}
				}
				{
					int x = (int((((((int)104 * lin->b->__get(pi)) + ((int)27 * lin->b->__get((pi + (int)1)))) + ((int)-3 * lin->b->__get((pi + (int)2)))) + (int)64)) >> int((int)7));
					if (((x < (int)0))){
						lout->b[(po + (int)1)] = (int)0;
					}
					else{
						if (((x > (int)255))){
							lout->b[(po + (int)1)] = (int)255;
						}
						else{
							lout->b[(po + (int)1)] = x;
						}
					}
				}
				{
					int x = (int((((((int)28 * lin->b->__get(pi)) + ((int)109 * lin->b->__get((pi + (int)1)))) + ((int)-9 * lin->b->__get((pi + (int)2)))) + (int)64)) >> int((int)7));
					if (((x < (int)0))){
						lout->b[(po + (int)2)] = (int)0;
					}
					else{
						if (((x > (int)255))){
							lout->b[(po + (int)2)] = (int)255;
						}
						else{
							lout->b[(po + (int)2)] = x;
						}
					}
				}
				{
					int _g2 = (int)0;
					while((true)){
						if ((!(((_g2 < xmax))))){
							break;
						}
						int x = (_g2)++;
						{
							int x1 = (int(((((((int)-9 * lin->b->__get((pi + x))) + ((int)111 * lin->b->__get(((pi + x) + (int)1)))) + ((int)29 * lin->b->__get(((pi + x) + (int)2)))) + ((int)-3 * lin->b->__get(((pi + x) + (int)3)))) + (int)64)) >> int((int)7));
							if (((x1 < (int)0))){
								lout->b[((po + ((int(x) << int((int)1)))) + (int)3)] = (int)0;
							}
							else{
								if (((x1 > (int)255))){
									lout->b[((po + ((int(x) << int((int)1)))) + (int)3)] = (int)255;
								}
								else{
									lout->b[((po + ((int(x) << int((int)1)))) + (int)3)] = x1;
								}
							}
						}
						{
							int x1 = (int(((((((int)-3 * lin->b->__get((pi + x))) + ((int)29 * lin->b->__get(((pi + x) + (int)1)))) + ((int)111 * lin->b->__get(((pi + x) + (int)2)))) + ((int)-9 * lin->b->__get(((pi + x) + (int)3)))) + (int)64)) >> int((int)7));
							if (((x1 < (int)0))){
								lout->b[((po + ((int(x) << int((int)1)))) + (int)4)] = (int)0;
							}
							else{
								if (((x1 > (int)255))){
									lout->b[((po + ((int(x) << int((int)1)))) + (int)4)] = (int)255;
								}
								else{
									lout->b[((po + ((int(x) << int((int)1)))) + (int)4)] = x1;
								}
							}
						}
					}
				}
				hx::AddEq(pi,c->stride);
				hx::AddEq(po,(int(c->width) << int((int)1)));
				{
					int x = (int((((((int)28 * lin->b->__get((pi - (int)1))) + ((int)109 * lin->b->__get((pi - (int)2)))) + ((int)-9 * lin->b->__get((pi - (int)3)))) + (int)64)) >> int((int)7));
					if (((x < (int)0))){
						lout->b[(po - (int)3)] = (int)0;
					}
					else{
						if (((x > (int)255))){
							lout->b[(po - (int)3)] = (int)255;
						}
						else{
							lout->b[(po - (int)3)] = x;
						}
					}
				}
				{
					int x = (int((((((int)104 * lin->b->__get((pi - (int)1))) + ((int)27 * lin->b->__get((pi - (int)2)))) + ((int)-3 * lin->b->__get((pi - (int)3)))) + (int)64)) >> int((int)7));
					if (((x < (int)0))){
						lout->b[(po - (int)2)] = (int)0;
					}
					else{
						if (((x > (int)255))){
							lout->b[(po - (int)2)] = (int)255;
						}
						else{
							lout->b[(po - (int)2)] = x;
						}
					}
				}
				{
					int x = (int(((((int)139 * lin->b->__get((pi - (int)1))) + ((int)-11 * lin->b->__get((pi - (int)2)))) + (int)64)) >> int((int)7));
					if (((x < (int)0))){
						lout->b[(po - (int)1)] = (int)0;
					}
					else{
						if (((x > (int)255))){
							lout->b[(po - (int)1)] = (int)255;
						}
						else{
							lout->b[(po - (int)1)] = x;
						}
					}
				}
			}
		}
		hx::ShlEq(c->width,(int)1);
		c->stride = c->width;
		::hxd::impl::Tmp_obj::saveBytes(c->pixels);
		c->pixels = cout;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njUpsampleH,(void))

Void NanoJpeg_obj::njUpsampleV( ::hxd::res::_NanoJpeg::Component c){
{
		int w = c->width;
		int s1 = c->stride;
		int s2 = (s1 + s1);
		::haxe::io::Bytes out = ::hxd::impl::Tmp_obj::getBytes((int((c->width * c->height)) << int((int)1)));
		int pi = (int)0;
		int po = (int)0;
		::haxe::io::Bytes cout = out;
		::haxe::io::Bytes cin = c->pixels;
		{
			int _g = (int)0;
			while((true)){
				if ((!(((_g < w))))){
					break;
				}
				int x = (_g)++;
				int _g1 = po = x;
				pi = _g1;
				{
					int x1 = (int(((((int)139 * cin->b->__get(pi)) + ((int)-11 * cin->b->__get((pi + s1)))) + (int)64)) >> int((int)7));
					if (((x1 < (int)0))){
						cout->b[po] = (int)0;
					}
					else{
						if (((x1 > (int)255))){
							cout->b[po] = (int)255;
						}
						else{
							cout->b[po] = x1;
						}
					}
				}
				hx::AddEq(po,w);
				{
					int x1 = (int((((((int)104 * cin->b->__get(pi)) + ((int)27 * cin->b->__get((pi + s1)))) + ((int)-3 * cin->b->__get((pi + s2)))) + (int)64)) >> int((int)7));
					if (((x1 < (int)0))){
						cout->b[po] = (int)0;
					}
					else{
						if (((x1 > (int)255))){
							cout->b[po] = (int)255;
						}
						else{
							cout->b[po] = x1;
						}
					}
				}
				hx::AddEq(po,w);
				{
					int x1 = (int((((((int)28 * cin->b->__get(pi)) + ((int)109 * cin->b->__get((pi + s1)))) + ((int)-9 * cin->b->__get((pi + s2)))) + (int)64)) >> int((int)7));
					if (((x1 < (int)0))){
						cout->b[po] = (int)0;
					}
					else{
						if (((x1 > (int)255))){
							cout->b[po] = (int)255;
						}
						else{
							cout->b[po] = x1;
						}
					}
				}
				hx::AddEq(po,w);
				hx::AddEq(pi,s1);
				{
					int _g2 = (int)0;
					int _g11 = (c->height - (int)2);
					while((true)){
						if ((!(((_g2 < _g11))))){
							break;
						}
						int y = (_g2)++;
						{
							int x1 = (int(((((((int)-9 * cin->b->__get((pi - s1))) + ((int)111 * cin->b->__get(pi))) + ((int)29 * cin->b->__get((pi + s1)))) + ((int)-3 * cin->b->__get((pi + s2)))) + (int)64)) >> int((int)7));
							if (((x1 < (int)0))){
								cout->b[po] = (int)0;
							}
							else{
								if (((x1 > (int)255))){
									cout->b[po] = (int)255;
								}
								else{
									cout->b[po] = x1;
								}
							}
						}
						hx::AddEq(po,w);
						{
							int x1 = (int(((((((int)-3 * cin->b->__get((pi - s1))) + ((int)29 * cin->b->__get(pi))) + ((int)111 * cin->b->__get((pi + s1)))) + ((int)-9 * cin->b->__get((pi + s2)))) + (int)64)) >> int((int)7));
							if (((x1 < (int)0))){
								cout->b[po] = (int)0;
							}
							else{
								if (((x1 > (int)255))){
									cout->b[po] = (int)255;
								}
								else{
									cout->b[po] = x1;
								}
							}
						}
						hx::AddEq(po,w);
						hx::AddEq(pi,s1);
					}
				}
				hx::AddEq(pi,s1);
				{
					int x1 = (int((((((int)28 * cin->b->__get(pi)) + ((int)109 * cin->b->__get((pi - s1)))) + ((int)-9 * cin->b->__get((pi - s2)))) + (int)64)) >> int((int)7));
					if (((x1 < (int)0))){
						cout->b[po] = (int)0;
					}
					else{
						if (((x1 > (int)255))){
							cout->b[po] = (int)255;
						}
						else{
							cout->b[po] = x1;
						}
					}
				}
				hx::AddEq(po,w);
				{
					int x1 = (int((((((int)104 * cin->b->__get(pi)) + ((int)27 * cin->b->__get((pi - s1)))) + ((int)-3 * cin->b->__get((pi - s2)))) + (int)64)) >> int((int)7));
					if (((x1 < (int)0))){
						cout->b[po] = (int)0;
					}
					else{
						if (((x1 > (int)255))){
							cout->b[po] = (int)255;
						}
						else{
							cout->b[po] = x1;
						}
					}
				}
				hx::AddEq(po,w);
				{
					int x1 = (int(((((int)139 * cin->b->__get(pi)) + ((int)-11 * cin->b->__get((pi - s1)))) + (int)64)) >> int((int)7));
					if (((x1 < (int)0))){
						cout->b[po] = (int)0;
					}
					else{
						if (((x1 > (int)255))){
							cout->b[po] = (int)255;
						}
						else{
							cout->b[po] = x1;
						}
					}
				}
			}
		}
		hx::ShlEq(c->height,(int)1);
		c->stride = c->width;
		::hxd::impl::Tmp_obj::saveBytes(c->pixels);
		c->pixels = out;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njUpsampleV,(void))

Void NanoJpeg_obj::njUpsample( ::hxd::res::_NanoJpeg::Component c){
{
		int xshift = (int)0;
		int yshift = (int)0;
		while((true)){
			if ((!(((c->width < this->width))))){
				break;
			}
			hx::ShlEq(c->width,(int)1);
			++(xshift);
		}
		while((true)){
			if ((!(((c->height < this->height))))){
				break;
			}
			hx::ShlEq(c->height,(int)1);
			++(yshift);
		}
		::haxe::io::Bytes out = ::hxd::impl::Tmp_obj::getBytes((c->width * c->height));
		::haxe::io::Bytes lin = c->pixels;
		int pout = (int)0;
		::haxe::io::Bytes lout = out;
		{
			int _g1 = (int)0;
			int _g = c->height;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int y = (_g1)++;
				int pin = (((int(y) >> int(yshift))) * c->stride);
				{
					int _g3 = (int)0;
					int _g2 = c->width;
					while((true)){
						if ((!(((_g3 < _g2))))){
							break;
						}
						int x = (_g3)++;
						int pos = (pout)++;
						lout->b[pos] = lin->b->__get((((int(x) >> int(xshift))) + pin));
					}
				}
			}
		}
		c->stride = c->width;
		::hxd::impl::Tmp_obj::saveBytes(c->pixels);
		c->pixels = out;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njUpsample,(void))

::haxe::io::Bytes NanoJpeg_obj::njConvert( ){
	{
		int _g1 = (int)0;
		int _g = this->ncomp;
		while((true)){
			if ((!(((_g1 < _g))))){
				break;
			}
			int i = (_g1)++;
			::hxd::res::_NanoJpeg::Component c = this->comps->__unsafe_get(i);
			{
				::hxd::res::Filter _g2 = this->filter;
				switch( (int)(_g2->__Index())){
					case (int)0: {
						if (((bool((c->width < this->width)) || bool((c->height < this->height))))){
							this->njUpsample(c);
						}
					}
					;break;
					case (int)1: {
						while((true)){
							if ((!(((bool((c->width < this->width)) || bool((c->height < this->height))))))){
								break;
							}
							if (((c->width < this->width))){
								this->njUpsampleH(c);
							}
							if (((c->height < this->height))){
								this->njUpsampleV(c);
							}
						}
					}
					;break;
				}
			}
			if (((bool((c->width < this->width)) || bool((c->height < this->height))))){
				HX_STACK_DO_THROW(HX_CSTRING("assert"));
			}
		}
	}
	::haxe::io::Bytes pixels = ::hxd::impl::Tmp_obj::getBytes(((this->width * this->height) * (int)4));
	if (((this->ncomp == (int)3))){
		::haxe::io::Bytes py = this->comps->__unsafe_get((int)0)->__Field(HX_CSTRING("pixels"),true);
		::haxe::io::Bytes pcb = this->comps->__unsafe_get((int)1)->__Field(HX_CSTRING("pixels"),true);
		::haxe::io::Bytes pcr = this->comps->__unsafe_get((int)2)->__Field(HX_CSTRING("pixels"),true);
		::haxe::io::Bytes pix = pixels;
		int k1 = (int)0;
		int k2 = (int)0;
		int k3 = (int)0;
		int out = (int)0;
		{
			int _g1 = (int)0;
			int _g = this->height;
			while((true)){
				if ((!(((_g1 < _g))))){
					break;
				}
				int yy = (_g1)++;
				{
					int _g3 = (int)0;
					int _g2 = this->width;
					while((true)){
						if ((!(((_g3 < _g2))))){
							break;
						}
						int x = (_g3)++;
						int _g4;
						{
							int i = (k1)++;
							_g4 = py->b->__get(i);
						}
						int y = (int(_g4) << int((int)8));
						int _g11;
						{
							int i = (k2)++;
							_g11 = pcb->b->__get(i);
						}
						int cb = (_g11 - (int)128);
						int _g21;
						{
							int i = (k3)++;
							_g21 = pcr->b->__get(i);
						}
						int cr = (_g21 - (int)128);
						int r;
						{
							int x1 = (int(((y + ((int)359 * cr)) + (int)128)) >> int((int)8));
							if (((x1 < (int)0))){
								r = (int)0;
							}
							else{
								if (((x1 > (int)255))){
									r = (int)255;
								}
								else{
									r = x1;
								}
							}
						}
						int g;
						{
							int x1 = (int((((y - ((int)88 * cb)) - ((int)183 * cr)) + (int)128)) >> int((int)8));
							if (((x1 < (int)0))){
								g = (int)0;
							}
							else{
								if (((x1 > (int)255))){
									g = (int)255;
								}
								else{
									g = x1;
								}
							}
						}
						int b;
						{
							int x1 = (int(((y + ((int)454 * cb)) + (int)128)) >> int((int)8));
							if (((x1 < (int)0))){
								b = (int)0;
							}
							else{
								if (((x1 > (int)255))){
									b = (int)255;
								}
								else{
									b = x1;
								}
							}
						}
						{
							int out1 = (out)++;
							pix->b[out1] = b;
						}
						{
							int out1 = (out)++;
							pix->b[out1] = g;
						}
						{
							int out1 = (out)++;
							pix->b[out1] = r;
						}
						{
							int out1 = (out)++;
							pix->b[out1] = (int)255;
						}
					}
				}
				hx::AddEq(k1,(this->comps->__unsafe_get((int)0)->__Field(HX_CSTRING("stride"),true) - this->width));
				hx::AddEq(k2,(this->comps->__unsafe_get((int)1)->__Field(HX_CSTRING("stride"),true) - this->width));
				hx::AddEq(k3,(this->comps->__unsafe_get((int)2)->__Field(HX_CSTRING("stride"),true) - this->width));
			}
		}
	}
	else{
		HX_STACK_DO_THROW(HX_CSTRING("TODO"));
	}
	return pixels;
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njConvert,return )

Dynamic NanoJpeg_obj::njDecode( ){
	if (((bool((bool((this->size < (int)2)) || bool((this->bytes->b->__get(this->pos) != (int)255)))) || bool((this->bytes->b->__get((this->pos + (int)1)) != (int)216))))){
		HX_STACK_DO_THROW(HX_CSTRING("This file is not a JPEG"));
	}
	{
		hx::AddEq(this->pos,(int)2);
		hx::SubEq(this->size,(int)2);
		hx::SubEq(this->length,(int)2);
		if (((this->size < (int)0))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
	}
	while((true)){
		if (((bool((this->size < (int)2)) || bool((this->bytes->b->__get(this->pos) != (int)255))))){
			HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
		}
		{
			hx::AddEq(this->pos,(int)2);
			hx::SubEq(this->size,(int)2);
			hx::SubEq(this->length,(int)2);
			if (((this->size < (int)0))){
				HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
			}
		}
		{
			int _g = this->bytes->b->__get((this->pos + (int)-1));
			int _switch_1 = (_g);
			if (  ( _switch_1==(int)192)){
				this->njDecodeSOF();
			}
			else if (  ( _switch_1==(int)219)){
				this->njDecodeDQT();
			}
			else if (  ( _switch_1==(int)196)){
				this->njDecodeDHT();
			}
			else if (  ( _switch_1==(int)221)){
				this->njDecodeDRI();
			}
			else if (  ( _switch_1==(int)218)){
				this->njDecodeScan();
				break;
			}
			else if (  ( _switch_1==(int)254)){
				{
					if (((this->size < (int)2))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
					this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
					if (((this->length > this->size))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
					{
						hx::AddEq(this->pos,(int)2);
						hx::SubEq(this->size,(int)2);
						hx::SubEq(this->length,(int)2);
						if (((this->size < (int)0))){
							HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
						}
					}
				}
				{
					int count = this->length;
					hx::AddEq(this->pos,count);
					hx::SubEq(this->size,count);
					hx::SubEq(this->length,count);
					if (((this->size < (int)0))){
						HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
					}
				}
			}
			else if (  ( _switch_1==(int)194)){
				HX_STACK_DO_THROW(HX_CSTRING("Unsupported progressive JPG"));
			}
			else if (  ( _switch_1==(int)195)){
				HX_STACK_DO_THROW(HX_CSTRING("Unsupported lossless JPG"));
			}
			else  {
				int _g1 = (int(this->bytes->b->__get((this->pos + (int)-1))) & int((int)240));
				switch( (int)(_g1)){
					case (int)224: {
						{
							if (((this->size < (int)2))){
								HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
							}
							this->length = (int((int(this->bytes->b->__get(this->pos)) << int((int)8))) | int(this->bytes->b->__get((this->pos + (int)1))));
							if (((this->length > this->size))){
								HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
							}
							{
								hx::AddEq(this->pos,(int)2);
								hx::SubEq(this->size,(int)2);
								hx::SubEq(this->length,(int)2);
								if (((this->size < (int)0))){
									HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
								}
							}
						}
						{
							int count = this->length;
							hx::AddEq(this->pos,count);
							hx::SubEq(this->size,count);
							hx::SubEq(this->length,count);
							if (((this->size < (int)0))){
								HX_STACK_DO_THROW(HX_CSTRING("Invalid JPEG file"));
							}
						}
					}
					;break;
					case (int)192: {
						HX_STACK_DO_THROW((HX_CSTRING("Unsupported jpeg type ") + ((int(this->bytes->b->__get((this->pos + (int)-1))) & int((int)15)))));
					}
					;break;
					default: {
						::String _g2 = ::StringTools_obj::hex(this->bytes->b->__get((this->pos + (int)-1)),(int)2);
						HX_STACK_DO_THROW((HX_CSTRING("Unsupported jpeg tag 0x") + _g2));
					}
				}
			}
;
;
		}
	}
	::haxe::io::Bytes pixels = this->njConvert();
	this->cleanup();
	struct _Function_1_1{
		inline static Dynamic Block( hx::ObjectPtr< ::hxd::res::NanoJpeg_obj > __this,::haxe::io::Bytes &pixels){
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("pixels") , pixels,false);
				__result->Add(HX_CSTRING("width") , __this->width,false);
				__result->Add(HX_CSTRING("height") , __this->height,false);
				return __result;
			}
			return null();
		}
	};
	return _Function_1_1::Block(this,pixels);
}


HX_DEFINE_DYNAMIC_FUNC0(NanoJpeg_obj,njDecode,return )

int NanoJpeg_obj::BLOCKSIZE;

int NanoJpeg_obj::W1;

int NanoJpeg_obj::W2;

int NanoJpeg_obj::W3;

int NanoJpeg_obj::W5;

int NanoJpeg_obj::W6;

int NanoJpeg_obj::W7;

int NanoJpeg_obj::K;

int NanoJpeg_obj::CF4A;

int NanoJpeg_obj::CF4B;

int NanoJpeg_obj::CF4C;

int NanoJpeg_obj::CF4D;

int NanoJpeg_obj::CF3A;

int NanoJpeg_obj::CF3B;

int NanoJpeg_obj::CF3C;

int NanoJpeg_obj::CF3X;

int NanoJpeg_obj::CF3Y;

int NanoJpeg_obj::CF3Z;

int NanoJpeg_obj::CF2A;

int NanoJpeg_obj::CF2B;

int NanoJpeg_obj::CF( int x){
	int x1 = (int((x + (int)64)) >> int((int)7));
	if (((x1 < (int)0))){
		return (int)0;
	}
	else{
		if (((x1 > (int)255))){
			return (int)255;
		}
		else{
			return x1;
		}
	}
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,CF,return )

int NanoJpeg_obj::njClip( int x){
	if (((x < (int)0))){
		return (int)0;
	}
	else{
		if (((x > (int)255))){
			return (int)255;
		}
		else{
			return x;
		}
	}
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(NanoJpeg_obj,njClip,return )

::hxd::res::NanoJpeg NanoJpeg_obj::inst;

Dynamic NanoJpeg_obj::decode( ::haxe::io::Bytes bytes,::hxd::res::Filter filter,hx::Null< int >  __o_position,hx::Null< int >  __o_size){
int position = __o_position.Default(0);
int size = __o_size.Default(-1);
{
		if (((::hxd::res::NanoJpeg_obj::inst == null()))){
			::hxd::res::NanoJpeg _g = ::hxd::res::NanoJpeg_obj::__new();
			::hxd::res::NanoJpeg_obj::inst = _g;
		}
		::hxd::res::NanoJpeg_obj::inst->njInit(bytes,position,size,filter);
		return ::hxd::res::NanoJpeg_obj::inst->njDecode();
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(NanoJpeg_obj,decode,return )


NanoJpeg_obj::NanoJpeg_obj()
{
}

void NanoJpeg_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(NanoJpeg);
	HX_MARK_MEMBER_NAME(bytes,"bytes");
	HX_MARK_MEMBER_NAME(pos,"pos");
	HX_MARK_MEMBER_NAME(size,"size");
	HX_MARK_MEMBER_NAME(length,"length");
	HX_MARK_MEMBER_NAME(width,"width");
	HX_MARK_MEMBER_NAME(height,"height");
	HX_MARK_MEMBER_NAME(ncomp,"ncomp");
	HX_MARK_MEMBER_NAME(comps,"comps");
	HX_MARK_MEMBER_NAME(counts,"counts");
	HX_MARK_MEMBER_NAME(qtab,"qtab");
	HX_MARK_MEMBER_NAME(qtused,"qtused");
	HX_MARK_MEMBER_NAME(qtavail,"qtavail");
	HX_MARK_MEMBER_NAME(vlctab,"vlctab");
	HX_MARK_MEMBER_NAME(block,"block");
	HX_MARK_MEMBER_NAME(njZZ,"njZZ");
	HX_MARK_MEMBER_NAME(mbsizex,"mbsizex");
	HX_MARK_MEMBER_NAME(mbsizey,"mbsizey");
	HX_MARK_MEMBER_NAME(mbwidth,"mbwidth");
	HX_MARK_MEMBER_NAME(mbheight,"mbheight");
	HX_MARK_MEMBER_NAME(rstinterval,"rstinterval");
	HX_MARK_MEMBER_NAME(buf,"buf");
	HX_MARK_MEMBER_NAME(bufbits,"bufbits");
	HX_MARK_MEMBER_NAME(pixels,"pixels");
	HX_MARK_MEMBER_NAME(filter,"filter");
	HX_MARK_MEMBER_NAME(vlcCode,"vlcCode");
	HX_MARK_END_CLASS();
}

void NanoJpeg_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(bytes,"bytes");
	HX_VISIT_MEMBER_NAME(pos,"pos");
	HX_VISIT_MEMBER_NAME(size,"size");
	HX_VISIT_MEMBER_NAME(length,"length");
	HX_VISIT_MEMBER_NAME(width,"width");
	HX_VISIT_MEMBER_NAME(height,"height");
	HX_VISIT_MEMBER_NAME(ncomp,"ncomp");
	HX_VISIT_MEMBER_NAME(comps,"comps");
	HX_VISIT_MEMBER_NAME(counts,"counts");
	HX_VISIT_MEMBER_NAME(qtab,"qtab");
	HX_VISIT_MEMBER_NAME(qtused,"qtused");
	HX_VISIT_MEMBER_NAME(qtavail,"qtavail");
	HX_VISIT_MEMBER_NAME(vlctab,"vlctab");
	HX_VISIT_MEMBER_NAME(block,"block");
	HX_VISIT_MEMBER_NAME(njZZ,"njZZ");
	HX_VISIT_MEMBER_NAME(mbsizex,"mbsizex");
	HX_VISIT_MEMBER_NAME(mbsizey,"mbsizey");
	HX_VISIT_MEMBER_NAME(mbwidth,"mbwidth");
	HX_VISIT_MEMBER_NAME(mbheight,"mbheight");
	HX_VISIT_MEMBER_NAME(rstinterval,"rstinterval");
	HX_VISIT_MEMBER_NAME(buf,"buf");
	HX_VISIT_MEMBER_NAME(bufbits,"bufbits");
	HX_VISIT_MEMBER_NAME(pixels,"pixels");
	HX_VISIT_MEMBER_NAME(filter,"filter");
	HX_VISIT_MEMBER_NAME(vlcCode,"vlcCode");
}

Dynamic NanoJpeg_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"K") ) { return K; }
		break;
	case 2:
		if (HX_FIELD_EQ(inName,"CF") ) { return CF_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { return pos; }
		if (HX_FIELD_EQ(inName,"buf") ) { return buf; }
		if (HX_FIELD_EQ(inName,"get") ) { return get_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { return inst; }
		if (HX_FIELD_EQ(inName,"size") ) { return size; }
		if (HX_FIELD_EQ(inName,"qtab") ) { return qtab; }
		if (HX_FIELD_EQ(inName,"njZZ") ) { return njZZ; }
		if (HX_FIELD_EQ(inName,"free") ) { return free_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { return bytes; }
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"ncomp") ) { return ncomp; }
		if (HX_FIELD_EQ(inName,"comps") ) { return comps; }
		if (HX_FIELD_EQ(inName,"block") ) { return block; }
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"njClip") ) { return njClip_dyn(); }
		if (HX_FIELD_EQ(inName,"decode") ) { return decode_dyn(); }
		if (HX_FIELD_EQ(inName,"length") ) { return length; }
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		if (HX_FIELD_EQ(inName,"counts") ) { return counts; }
		if (HX_FIELD_EQ(inName,"qtused") ) { return qtused; }
		if (HX_FIELD_EQ(inName,"vlctab") ) { return vlctab; }
		if (HX_FIELD_EQ(inName,"pixels") ) { return pixels; }
		if (HX_FIELD_EQ(inName,"filter") ) { return filter; }
		if (HX_FIELD_EQ(inName,"njInit") ) { return njInit_dyn(); }
		if (HX_FIELD_EQ(inName,"njSkip") ) { return njSkip_dyn(); }
		if (HX_FIELD_EQ(inName,"syntax") ) { return syntax_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"qtavail") ) { return qtavail; }
		if (HX_FIELD_EQ(inName,"mbsizex") ) { return mbsizex; }
		if (HX_FIELD_EQ(inName,"mbsizey") ) { return mbsizey; }
		if (HX_FIELD_EQ(inName,"mbwidth") ) { return mbwidth; }
		if (HX_FIELD_EQ(inName,"bufbits") ) { return bufbits; }
		if (HX_FIELD_EQ(inName,"cleanup") ) { return cleanup_dyn(); }
		if (HX_FIELD_EQ(inName,"vlcCode") ) { return vlcCode; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"mbheight") ) { return mbheight; }
		if (HX_FIELD_EQ(inName,"njGetVLC") ) { return njGetVLC_dyn(); }
		if (HX_FIELD_EQ(inName,"njDecode") ) { return njDecode_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"njGetBits") ) { return njGetBits_dyn(); }
		if (HX_FIELD_EQ(inName,"njRowIDCT") ) { return njRowIDCT_dyn(); }
		if (HX_FIELD_EQ(inName,"njColIDCT") ) { return njColIDCT_dyn(); }
		if (HX_FIELD_EQ(inName,"njConvert") ) { return njConvert_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"njDecode16") ) { return njDecode16_dyn(); }
		if (HX_FIELD_EQ(inName,"njShowBits") ) { return njShowBits_dyn(); }
		if (HX_FIELD_EQ(inName,"njSkipBits") ) { return njSkipBits_dyn(); }
		if (HX_FIELD_EQ(inName,"njUpsample") ) { return njUpsample_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"rstinterval") ) { return rstinterval; }
		if (HX_FIELD_EQ(inName,"njByteAlign") ) { return njByteAlign_dyn(); }
		if (HX_FIELD_EQ(inName,"njDecodeSOF") ) { return njDecodeSOF_dyn(); }
		if (HX_FIELD_EQ(inName,"njDecodeDQT") ) { return njDecodeDQT_dyn(); }
		if (HX_FIELD_EQ(inName,"njDecodeDHT") ) { return njDecodeDHT_dyn(); }
		if (HX_FIELD_EQ(inName,"njDecodeDRI") ) { return njDecodeDRI_dyn(); }
		if (HX_FIELD_EQ(inName,"njUpsampleH") ) { return njUpsampleH_dyn(); }
		if (HX_FIELD_EQ(inName,"njUpsampleV") ) { return njUpsampleV_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"njSkipMarker") ) { return njSkipMarker_dyn(); }
		if (HX_FIELD_EQ(inName,"notSupported") ) { return notSupported_dyn(); }
		if (HX_FIELD_EQ(inName,"njDecodeScan") ) { return njDecodeScan_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"njDecodeBlock") ) { return njDecodeBlock_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"njDecodeLength") ) { return njDecodeLength_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic NanoJpeg_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"K") ) { K=inValue.Cast< int >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"pos") ) { pos=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"buf") ) { buf=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"inst") ) { inst=inValue.Cast< ::hxd::res::NanoJpeg >(); return inValue; }
		if (HX_FIELD_EQ(inName,"size") ) { size=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qtab") ) { qtab=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"njZZ") ) { njZZ=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"bytes") ) { bytes=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"ncomp") ) { ncomp=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"comps") ) { comps=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"block") ) { block=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"counts") ) { counts=inValue.Cast< Array< int > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"qtused") ) { qtused=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"vlctab") ) { vlctab=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pixels") ) { pixels=inValue.Cast< ::haxe::io::Bytes >(); return inValue; }
		if (HX_FIELD_EQ(inName,"filter") ) { filter=inValue.Cast< ::hxd::res::Filter >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"qtavail") ) { qtavail=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mbsizex") ) { mbsizex=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mbsizey") ) { mbsizey=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"mbwidth") ) { mbwidth=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bufbits") ) { bufbits=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"vlcCode") ) { vlcCode=inValue.Cast< int >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"mbheight") ) { mbheight=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"rstinterval") ) { rstinterval=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void NanoJpeg_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bytes"));
	outFields->push(HX_CSTRING("pos"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("length"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("ncomp"));
	outFields->push(HX_CSTRING("comps"));
	outFields->push(HX_CSTRING("counts"));
	outFields->push(HX_CSTRING("qtab"));
	outFields->push(HX_CSTRING("qtused"));
	outFields->push(HX_CSTRING("qtavail"));
	outFields->push(HX_CSTRING("vlctab"));
	outFields->push(HX_CSTRING("block"));
	outFields->push(HX_CSTRING("njZZ"));
	outFields->push(HX_CSTRING("mbsizex"));
	outFields->push(HX_CSTRING("mbsizey"));
	outFields->push(HX_CSTRING("mbwidth"));
	outFields->push(HX_CSTRING("mbheight"));
	outFields->push(HX_CSTRING("rstinterval"));
	outFields->push(HX_CSTRING("buf"));
	outFields->push(HX_CSTRING("bufbits"));
	outFields->push(HX_CSTRING("pixels"));
	outFields->push(HX_CSTRING("filter"));
	outFields->push(HX_CSTRING("vlcCode"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("BLOCKSIZE"),
	HX_CSTRING("W1"),
	HX_CSTRING("W2"),
	HX_CSTRING("W3"),
	HX_CSTRING("W5"),
	HX_CSTRING("W6"),
	HX_CSTRING("W7"),
	HX_CSTRING("K"),
	HX_CSTRING("CF4A"),
	HX_CSTRING("CF4B"),
	HX_CSTRING("CF4C"),
	HX_CSTRING("CF4D"),
	HX_CSTRING("CF3A"),
	HX_CSTRING("CF3B"),
	HX_CSTRING("CF3C"),
	HX_CSTRING("CF3X"),
	HX_CSTRING("CF3Y"),
	HX_CSTRING("CF3Z"),
	HX_CSTRING("CF2A"),
	HX_CSTRING("CF2B"),
	HX_CSTRING("CF"),
	HX_CSTRING("njClip"),
	HX_CSTRING("inst"),
	HX_CSTRING("decode"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::haxe::io::Bytes*/ ,(int)offsetof(NanoJpeg_obj,bytes),HX_CSTRING("bytes")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,pos),HX_CSTRING("pos")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,size),HX_CSTRING("size")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,length),HX_CSTRING("length")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,width),HX_CSTRING("width")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,height),HX_CSTRING("height")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,ncomp),HX_CSTRING("ncomp")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(NanoJpeg_obj,comps),HX_CSTRING("comps")},
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(NanoJpeg_obj,counts),HX_CSTRING("counts")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(NanoJpeg_obj,qtab),HX_CSTRING("qtab")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,qtused),HX_CSTRING("qtused")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,qtavail),HX_CSTRING("qtavail")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(NanoJpeg_obj,vlctab),HX_CSTRING("vlctab")},
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(NanoJpeg_obj,block),HX_CSTRING("block")},
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(NanoJpeg_obj,njZZ),HX_CSTRING("njZZ")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,mbsizex),HX_CSTRING("mbsizex")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,mbsizey),HX_CSTRING("mbsizey")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,mbwidth),HX_CSTRING("mbwidth")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,mbheight),HX_CSTRING("mbheight")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,rstinterval),HX_CSTRING("rstinterval")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,buf),HX_CSTRING("buf")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,bufbits),HX_CSTRING("bufbits")},
	{hx::fsObject /*::haxe::io::Bytes*/ ,(int)offsetof(NanoJpeg_obj,pixels),HX_CSTRING("pixels")},
	{hx::fsObject /*::hxd::res::Filter*/ ,(int)offsetof(NanoJpeg_obj,filter),HX_CSTRING("filter")},
	{hx::fsInt,(int)offsetof(NanoJpeg_obj,vlcCode),HX_CSTRING("vlcCode")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("bytes"),
	HX_CSTRING("pos"),
	HX_CSTRING("size"),
	HX_CSTRING("length"),
	HX_CSTRING("width"),
	HX_CSTRING("height"),
	HX_CSTRING("ncomp"),
	HX_CSTRING("comps"),
	HX_CSTRING("counts"),
	HX_CSTRING("qtab"),
	HX_CSTRING("qtused"),
	HX_CSTRING("qtavail"),
	HX_CSTRING("vlctab"),
	HX_CSTRING("block"),
	HX_CSTRING("njZZ"),
	HX_CSTRING("mbsizex"),
	HX_CSTRING("mbsizey"),
	HX_CSTRING("mbwidth"),
	HX_CSTRING("mbheight"),
	HX_CSTRING("rstinterval"),
	HX_CSTRING("buf"),
	HX_CSTRING("bufbits"),
	HX_CSTRING("pixels"),
	HX_CSTRING("filter"),
	HX_CSTRING("alloc"),
	HX_CSTRING("free"),
	HX_CSTRING("njInit"),
	HX_CSTRING("cleanup"),
	HX_CSTRING("njSkip"),
	HX_CSTRING("syntax"),
	HX_CSTRING("get"),
	HX_CSTRING("njDecode16"),
	HX_CSTRING("njByteAlign"),
	HX_CSTRING("njShowBits"),
	HX_CSTRING("njSkipBits"),
	HX_CSTRING("njGetBits"),
	HX_CSTRING("njDecodeLength"),
	HX_CSTRING("njSkipMarker"),
	HX_CSTRING("njDecodeSOF"),
	HX_CSTRING("njDecodeDQT"),
	HX_CSTRING("njDecodeDHT"),
	HX_CSTRING("njDecodeDRI"),
	HX_CSTRING("vlcCode"),
	HX_CSTRING("njGetVLC"),
	HX_CSTRING("njRowIDCT"),
	HX_CSTRING("njColIDCT"),
	HX_CSTRING("njDecodeBlock"),
	HX_CSTRING("notSupported"),
	HX_CSTRING("njDecodeScan"),
	HX_CSTRING("njUpsampleH"),
	HX_CSTRING("njUpsampleV"),
	HX_CSTRING("njUpsample"),
	HX_CSTRING("njConvert"),
	HX_CSTRING("njDecode"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::BLOCKSIZE,"BLOCKSIZE");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::W1,"W1");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::W2,"W2");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::W3,"W3");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::W5,"W5");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::W6,"W6");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::W7,"W7");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::K,"K");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF4A,"CF4A");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF4B,"CF4B");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF4C,"CF4C");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF4D,"CF4D");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF3A,"CF3A");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF3B,"CF3B");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF3C,"CF3C");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF3X,"CF3X");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF3Y,"CF3Y");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF3Z,"CF3Z");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF2A,"CF2A");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::CF2B,"CF2B");
	HX_MARK_MEMBER_NAME(NanoJpeg_obj::inst,"inst");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::BLOCKSIZE,"BLOCKSIZE");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::W1,"W1");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::W2,"W2");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::W3,"W3");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::W5,"W5");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::W6,"W6");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::W7,"W7");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::K,"K");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF4A,"CF4A");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF4B,"CF4B");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF4C,"CF4C");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF4D,"CF4D");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF3A,"CF3A");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF3B,"CF3B");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF3C,"CF3C");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF3X,"CF3X");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF3Y,"CF3Y");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF3Z,"CF3Z");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF2A,"CF2A");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::CF2B,"CF2B");
	HX_VISIT_MEMBER_NAME(NanoJpeg_obj::inst,"inst");
};

#endif

Class NanoJpeg_obj::__mClass;

void NanoJpeg_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("hxd.res.NanoJpeg"), hx::TCanCast< NanoJpeg_obj> ,sStaticFields,sMemberFields,
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

void NanoJpeg_obj::__boot()
{
	BLOCKSIZE= (int)64;
	W1= (int)2841;
	W2= (int)2676;
	W3= (int)2408;
	W5= (int)1609;
	W6= (int)1108;
	W7= (int)565;
	K= (int)0;
	CF4A= (int)-9;
	CF4B= (int)111;
	CF4C= (int)29;
	CF4D= (int)-3;
	CF3A= (int)28;
	CF3B= (int)109;
	CF3C= (int)-9;
	CF3X= (int)104;
	CF3Y= (int)27;
	CF3Z= (int)-3;
	CF2A= (int)139;
	CF2B= (int)-11;
	inst= null();
}

} // end namespace hxd
} // end namespace res
