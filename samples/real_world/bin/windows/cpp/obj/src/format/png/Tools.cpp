#include <hxcpp.h>

#ifndef INCLUDED_List
#include <List.h>
#endif
#ifndef INCLUDED_format_png_Chunk
#include <format/png/Chunk.h>
#endif
#ifndef INCLUDED_format_png_Color
#include <format/png/Color.h>
#endif
#ifndef INCLUDED_format_png_Tools
#include <format/png/Tools.h>
#endif
#ifndef INCLUDED_format_tools_Deflate
#include <format/tools/Deflate.h>
#endif
#ifndef INCLUDED_format_tools_Inflate
#include <format/tools/Inflate.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesBuffer
#include <haxe/io/BytesBuffer.h>
#endif
namespace format{
namespace png{

Void Tools_obj::__construct()
{
	return null();
}

//Tools_obj::~Tools_obj() { }

Dynamic Tools_obj::__CreateEmpty() { return  new Tools_obj; }
hx::ObjectPtr< Tools_obj > Tools_obj::__new()
{  hx::ObjectPtr< Tools_obj > result = new Tools_obj();
	result->__construct();
	return result;}

Dynamic Tools_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Tools_obj > result = new Tools_obj();
	result->__construct();
	return result;}

Dynamic Tools_obj::getHeader( ::List d){
	HX_STACK_FRAME("format.png.Tools","getHeader",0xf1b59214,"format.png.Tools.getHeader","format/png/Tools.hx",35,0x79d90221)
	HX_STACK_ARG(d,"d")
	HX_STACK_LINE(36)
	for(::cpp::FastIterator_obj< ::format::png::Chunk > *__it = ::cpp::CreateFastIterator< ::format::png::Chunk >(d->iterator());  __it->hasNext(); ){
		::format::png::Chunk c = __it->next();
		switch( (int)(c->__Index())){
			case (int)1: {
				HX_STACK_LINE(37)
				Dynamic h = (::format::png::Chunk(c))->__Param(0);		HX_STACK_VAR(h,"h");
				HX_STACK_LINE(38)
				return h;
			}
			;break;
			default: {
			}
		}
;
	}
	HX_STACK_LINE(41)
	HX_STACK_DO_THROW(HX_CSTRING("Header not found"));
	HX_STACK_LINE(41)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tools_obj,getHeader,return )

::haxe::io::Bytes Tools_obj::getPalette( ::List d){
	HX_STACK_FRAME("format.png.Tools","getPalette",0x96858014,"format.png.Tools.getPalette","format/png/Tools.hx",47,0x79d90221)
	HX_STACK_ARG(d,"d")
	HX_STACK_LINE(48)
	for(::cpp::FastIterator_obj< ::format::png::Chunk > *__it = ::cpp::CreateFastIterator< ::format::png::Chunk >(d->iterator());  __it->hasNext(); ){
		::format::png::Chunk c = __it->next();
		switch( (int)(c->__Index())){
			case (int)3: {
				HX_STACK_LINE(49)
				::haxe::io::Bytes b = (::format::png::Chunk(c))->__Param(0);		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(50)
				return b;
			}
			;break;
			default: {
			}
		}
;
	}
	HX_STACK_LINE(53)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tools_obj,getPalette,return )

int Tools_obj::filter( ::haxe::io::Bytes data,int x,int y,int stride,int prev,int p,hx::Null< int >  __o_numChannels){
int numChannels = __o_numChannels.Default(4);
	HX_STACK_FRAME("format.png.Tools","filter",0xb708d3c7,"format.png.Tools.filter","format/png/Tools.hx",56,0x79d90221)
	HX_STACK_ARG(data,"data")
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(stride,"stride")
	HX_STACK_ARG(prev,"prev")
	HX_STACK_ARG(p,"p")
	HX_STACK_ARG(numChannels,"numChannels")
{
		HX_STACK_LINE(57)
		int b;		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(57)
		if (((y == (int)0))){
			HX_STACK_LINE(57)
			b = (int)0;
		}
		else{
			HX_STACK_LINE(57)
			b = data->b->__get((p - stride));
		}
		HX_STACK_LINE(58)
		int c;		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(58)
		if (((bool((x == (int)0)) || bool((y == (int)0))))){
			HX_STACK_LINE(58)
			c = (int)0;
		}
		else{
			HX_STACK_LINE(58)
			c = data->b->__get(((p - stride) - numChannels));
		}
		HX_STACK_LINE(59)
		int k = ((prev + b) - c);		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(60)
		int pa = (k - prev);		HX_STACK_VAR(pa,"pa");
		HX_STACK_LINE(60)
		if (((pa < (int)0))){
			HX_STACK_LINE(60)
			pa = -(pa);
		}
		HX_STACK_LINE(61)
		int pb = (k - b);		HX_STACK_VAR(pb,"pb");
		HX_STACK_LINE(61)
		if (((pb < (int)0))){
			HX_STACK_LINE(61)
			pb = -(pb);
		}
		HX_STACK_LINE(62)
		int pc = (k - c);		HX_STACK_VAR(pc,"pc");
		HX_STACK_LINE(62)
		if (((pc < (int)0))){
			HX_STACK_LINE(62)
			pc = -(pc);
		}
		HX_STACK_LINE(63)
		if (((bool((pa <= pb)) && bool((pa <= pc))))){
			HX_STACK_LINE(63)
			return prev;
		}
		else{
			HX_STACK_LINE(63)
			if (((pb <= pc))){
				HX_STACK_LINE(63)
				return b;
			}
			else{
				HX_STACK_LINE(63)
				return c;
			}
		}
		HX_STACK_LINE(63)
		return (int)0;
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(Tools_obj,filter,return )

Void Tools_obj::reverseBytes( ::haxe::io::Bytes b){
{
		HX_STACK_FRAME("format.png.Tools","reverseBytes",0x2d518d38,"format.png.Tools.reverseBytes","format/png/Tools.hx",69,0x79d90221)
		HX_STACK_ARG(b,"b")
		HX_STACK_LINE(89)
		int p = (int)0;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(90)
		{
			HX_STACK_LINE(90)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(90)
			int _g = (int(b->length) >> int((int)2));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(90)
			while((true)){
				HX_STACK_LINE(90)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(90)
					break;
				}
				HX_STACK_LINE(90)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(91)
				int b1 = b->b->__get(p);		HX_STACK_VAR(b1,"b1");
				HX_STACK_LINE(92)
				int g = b->b->__get((p + (int)1));		HX_STACK_VAR(g,"g");
				HX_STACK_LINE(93)
				int r = b->b->__get((p + (int)2));		HX_STACK_VAR(r,"r");
				HX_STACK_LINE(94)
				int a = b->b->__get((p + (int)3));		HX_STACK_VAR(a,"a");
				HX_STACK_LINE(95)
				{
					HX_STACK_LINE(95)
					int p1 = (p)++;		HX_STACK_VAR(p1,"p1");
					HX_STACK_LINE(95)
					b->b[p1] = a;
				}
				HX_STACK_LINE(96)
				{
					HX_STACK_LINE(96)
					int p1 = (p)++;		HX_STACK_VAR(p1,"p1");
					HX_STACK_LINE(96)
					b->b[p1] = r;
				}
				HX_STACK_LINE(97)
				{
					HX_STACK_LINE(97)
					int p1 = (p)++;		HX_STACK_VAR(p1,"p1");
					HX_STACK_LINE(97)
					b->b[p1] = g;
				}
				HX_STACK_LINE(98)
				{
					HX_STACK_LINE(98)
					int p1 = (p)++;		HX_STACK_VAR(p1,"p1");
					HX_STACK_LINE(98)
					b->b[p1] = b1;
				}
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tools_obj,reverseBytes,(void))

::haxe::io::Bytes Tools_obj::extractGrey( ::List d){
	Dynamic h = ::format::png::Tools_obj::getHeader(d);
	::haxe::io::Bytes grey = ::haxe::io::Bytes_obj::alloc((h->__Field(HX_CSTRING("width"),true) * h->__Field(HX_CSTRING("height"),true)));
	::haxe::io::Bytes data = null();
	::haxe::io::BytesBuffer fullData = null();
	for(::cpp::FastIterator_obj< ::format::png::Chunk > *__it = ::cpp::CreateFastIterator< ::format::png::Chunk >(d->iterator());  __it->hasNext(); ){
		::format::png::Chunk c = __it->next();
		switch( (int)(c->__Index())){
			case (int)2: {
				::haxe::io::Bytes b = (::format::png::Chunk(c))->__Param(0);
				if (((fullData != null()))){
					Array< unsigned char > b1 = fullData->b;
					Array< unsigned char > b2 = b->b;
					{
						int _g1 = (int)0;
						int _g = b->length;
						while((true)){
							if ((!(((_g1 < _g))))){
								break;
							}
							int i = (_g1)++;
							fullData->b->push(b2->__get(i));
						}
					}
				}
				else{
					if (((data == null()))){
						data = b;
					}
					else{
						::haxe::io::BytesBuffer _g = ::haxe::io::BytesBuffer_obj::__new();
						fullData = _g;
						{
							Array< unsigned char > b1 = fullData->b;
							Array< unsigned char > b2 = data->b;
							{
								int _g1 = (int)0;
								int _g2 = data->length;
								while((true)){
									if ((!(((_g1 < _g2))))){
										break;
									}
									int i = (_g1)++;
									fullData->b->push(b2->__get(i));
								}
							}
						}
						{
							Array< unsigned char > b1 = fullData->b;
							Array< unsigned char > b2 = b->b;
							{
								int _g1 = (int)0;
								int _g2 = b->length;
								while((true)){
									if ((!(((_g1 < _g2))))){
										break;
									}
									int i = (_g1)++;
									fullData->b->push(b2->__get(i));
								}
							}
						}
						data = null();
					}
				}
			}
			;break;
			default: {
			}
		}
;
	}
	if (((fullData != null()))){
		::haxe::io::Bytes _g1 = fullData->getBytes();
		data = _g1;
	}
	if (((data == null()))){
		HX_STACK_DO_THROW(HX_CSTRING("Data not found"));
	}
	::haxe::io::Bytes _g2 = ::format::tools::Inflate_obj::run(data);
	data = _g2;
	int r = (int)0;
	int w = (int)0;
	{
		::format::png::Color _g = h->__Field(HX_CSTRING("color"),true);
		switch( (int)(_g->__Index())){
			case (int)0: {
				bool alpha = (::format::png::Color(_g))->__Param(0);
				{
					if (((h->__Field(HX_CSTRING("colbits"),true) != (int)8))){
						HX_STACK_DO_THROW(HX_CSTRING("Unsupported color mode"));
					}
					int width = h->__Field(HX_CSTRING("width"),true);
					int stride;
					stride = ((((  ((alpha)) ? int((int)2) : int((int)1) )) * width) + (int)1);
					if (((data->length < (h->__Field(HX_CSTRING("height"),true) * stride)))){
						HX_STACK_DO_THROW(HX_CSTRING("Not enough data"));
					}
					int rinc;
					if ((alpha)){
						rinc = (int)2;
					}
					else{
						rinc = (int)1;
					}
					{
						int _g21 = (int)0;
						int _g1 = h->__Field(HX_CSTRING("height"),true);
						while((true)){
							if ((!(((_g21 < _g1))))){
								break;
							}
							int y = (_g21)++;
							int f;
							{
								int pos = (r)++;
								f = data->b->__get(pos);
							}
							switch( (int)(f)){
								case (int)0: {
									int _g3 = (int)0;
									while((true)){
										if ((!(((_g3 < width))))){
											break;
										}
										int x = (_g3)++;
										int v = data->b->__get(r);
										hx::AddEq(r,rinc);
										{
											int pos = (w)++;
											grey->b[pos] = v;
										}
									}
								}
								;break;
								case (int)1: {
									int cv = (int)0;
									{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											hx::AddEq(cv,data->b->__get(r));
											hx::AddEq(r,rinc);
											{
												int pos = (w)++;
												grey->b[pos] = cv;
											}
										}
									}
								}
								;break;
								case (int)2: {
									int stride1;
									if (((y == (int)0))){
										stride1 = (int)0;
									}
									else{
										stride1 = width;
									}
									{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int v = (data->b->__get(r) + grey->b->__get((w - stride1)));
											hx::AddEq(r,rinc);
											{
												int pos = (w)++;
												grey->b[pos] = v;
											}
										}
									}
								}
								;break;
								case (int)3: {
									int cv = (int)0;
									int stride1;
									if (((y == (int)0))){
										stride1 = (int)0;
									}
									else{
										stride1 = width;
									}
									{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											cv = (int((data->b->__get(r) + ((int((cv + grey->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											hx::AddEq(r,rinc);
											{
												int pos = (w)++;
												grey->b[pos] = cv;
											}
										}
									}
								}
								;break;
								case (int)4: {
									int stride1 = width;
									int cv = (int)0;
									{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g31;
											{
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = grey->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = grey->b->__get(((w - stride1) - (int)1));
												}
												int k = ((cv + b) - c);
												int pa = (k - cv);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g31 = cv;
												}
												else{
													if (((pb <= pc))){
														_g31 = b;
													}
													else{
														_g31 = c;
													}
												}
											}
											int _g4 = (_g31 + data->b->__get(r));
											int _g5 = (int(_g4) & int((int)255));
											cv = _g5;
											hx::AddEq(r,rinc);
											{
												int pos = (w)++;
												grey->b[pos] = cv;
											}
										}
									}
								}
								;break;
								default: {
									HX_STACK_DO_THROW((HX_CSTRING("Invalid filter ") + f));
								}
							}
						}
					}
				}
			}
			;break;
			default: {
				HX_STACK_DO_THROW(HX_CSTRING("Unsupported color mode"));
			}
		}
	}
	return grey;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Tools_obj,extractGrey,return )

::haxe::io::Bytes Tools_obj::extract32( ::List d,::haxe::io::Bytes bytes){
	Dynamic h = ::format::png::Tools_obj::getHeader(d);
	::haxe::io::Bytes bgra;
	if (((bytes == null()))){
		bgra = ::haxe::io::Bytes_obj::alloc(((h->__Field(HX_CSTRING("width"),true) * h->__Field(HX_CSTRING("height"),true)) * (int)4));
	}
	else{
		bgra = bytes;
	}
	::haxe::io::Bytes data = null();
	::haxe::io::BytesBuffer fullData = null();
	for(::cpp::FastIterator_obj< ::format::png::Chunk > *__it = ::cpp::CreateFastIterator< ::format::png::Chunk >(d->iterator());  __it->hasNext(); ){
		::format::png::Chunk c = __it->next();
		switch( (int)(c->__Index())){
			case (int)2: {
				::haxe::io::Bytes b = (::format::png::Chunk(c))->__Param(0);
				if (((fullData != null()))){
					Array< unsigned char > b1 = fullData->b;
					Array< unsigned char > b2 = b->b;
					{
						int _g1 = (int)0;
						int _g = b->length;
						while((true)){
							if ((!(((_g1 < _g))))){
								break;
							}
							int i = (_g1)++;
							fullData->b->push(b2->__get(i));
						}
					}
				}
				else{
					if (((data == null()))){
						data = b;
					}
					else{
						::haxe::io::BytesBuffer _g = ::haxe::io::BytesBuffer_obj::__new();
						fullData = _g;
						{
							Array< unsigned char > b1 = fullData->b;
							Array< unsigned char > b2 = data->b;
							{
								int _g1 = (int)0;
								int _g2 = data->length;
								while((true)){
									if ((!(((_g1 < _g2))))){
										break;
									}
									int i = (_g1)++;
									fullData->b->push(b2->__get(i));
								}
							}
						}
						{
							Array< unsigned char > b1 = fullData->b;
							Array< unsigned char > b2 = b->b;
							{
								int _g1 = (int)0;
								int _g2 = b->length;
								while((true)){
									if ((!(((_g1 < _g2))))){
										break;
									}
									int i = (_g1)++;
									fullData->b->push(b2->__get(i));
								}
							}
						}
						data = null();
					}
				}
			}
			;break;
			default: {
			}
		}
;
	}
	if (((fullData != null()))){
		::haxe::io::Bytes _g1 = fullData->getBytes();
		data = _g1;
	}
	if (((data == null()))){
		HX_STACK_DO_THROW(HX_CSTRING("Data not found"));
	}
	::haxe::io::Bytes _g2 = ::format::tools::Inflate_obj::run(data);
	data = _g2;
	int r = (int)0;
	int w = (int)0;
	{
		::format::png::Color _g = h->__Field(HX_CSTRING("color"),true);
		switch( (int)(_g->__Index())){
			case (int)2: {
				::haxe::io::Bytes pal = ::format::png::Tools_obj::getPalette(d);
				if (((pal == null()))){
					HX_STACK_DO_THROW(HX_CSTRING("PNG Palette is missing"));
				}
				::haxe::io::Bytes alpha = null();
				for(::cpp::FastIterator_obj< ::format::png::Chunk > *__it = ::cpp::CreateFastIterator< ::format::png::Chunk >(d->iterator());  __it->hasNext(); ){
					::format::png::Chunk t = __it->next();
					int _switch_1 = (t->__Index());
					if (  ( _switch_1==(int)4)){
						::String _switch_2 = ((::format::png::Chunk(t))->__Param(0));
						if (  ( _switch_2==HX_CSTRING("tRNS"))){
							::haxe::io::Bytes data1 = (::format::png::Chunk(t))->__Param(1);
							{
								alpha = data1;
								break;
							}
						}
						else  {
						}
;
;
					}
					else  {
					}
;
;
				}
				int width = h->__Field(HX_CSTRING("width"),true);
				int stride = (width + (int)1);
				if (((data->length < (h->__Field(HX_CSTRING("height"),true) * stride)))){
					HX_STACK_DO_THROW(HX_CSTRING("Not enough data"));
				}
				int vr;
				int vg;
				int vb;
				int va = (int)255;
				{
					int _g21 = (int)0;
					int _g1 = h->__Field(HX_CSTRING("height"),true);
					while((true)){
						if ((!(((_g21 < _g1))))){
							break;
						}
						int y = (_g21)++;
						int f;
						{
							int pos = (r)++;
							f = data->b->__get(pos);
						}
						switch( (int)(f)){
							case (int)0: {
								int _g3 = (int)0;
								while((true)){
									if ((!(((_g3 < width))))){
										break;
									}
									int x = (_g3)++;
									{
										int c;
										{
											int pos = (r)++;
											c = data->b->__get(pos);
										}
										vr = pal->b->__get((c * (int)3));
										vg = pal->b->__get(((c * (int)3) + (int)1));
										vb = pal->b->__get(((c * (int)3) + (int)2));
										if (((alpha != null()))){
											va = alpha->b->__get(c);
										}
									}
									{
										int pos = (w)++;
										bgra->b[pos] = vb;
									}
									{
										int pos = (w)++;
										bgra->b[pos] = vg;
									}
									{
										int pos = (w)++;
										bgra->b[pos] = vr;
									}
									{
										int pos = (w)++;
										bgra->b[pos] = va;
									}
								}
							}
							;break;
							case (int)1: {
								int cr = (int)0;
								int cg = (int)0;
								int cb = (int)0;
								int ca = (int)0;
								{
									int _g3 = (int)0;
									while((true)){
										if ((!(((_g3 < width))))){
											break;
										}
										int x = (_g3)++;
										{
											int c;
											{
												int pos = (r)++;
												c = data->b->__get(pos);
											}
											vr = pal->b->__get((c * (int)3));
											vg = pal->b->__get(((c * (int)3) + (int)1));
											vb = pal->b->__get(((c * (int)3) + (int)2));
											if (((alpha != null()))){
												va = alpha->b->__get(c);
											}
										}
										hx::AddEq(cb,vb);
										{
											int pos = (w)++;
											bgra->b[pos] = cb;
										}
										hx::AddEq(cg,vg);
										{
											int pos = (w)++;
											bgra->b[pos] = cg;
										}
										hx::AddEq(cr,vr);
										{
											int pos = (w)++;
											bgra->b[pos] = cr;
										}
										hx::AddEq(ca,va);
										{
											int pos = (w)++;
											bgra->b[pos] = ca;
										}
										{
											int pos = (w)++;
											bgra->b[pos] = va;
										}
									}
								}
							}
							;break;
							case (int)2: {
								int stride1;
								if (((y == (int)0))){
									stride1 = (int)0;
								}
								else{
									stride1 = (width * (int)4);
								}
								{
									int _g3 = (int)0;
									while((true)){
										if ((!(((_g3 < width))))){
											break;
										}
										int x = (_g3)++;
										{
											int c;
											{
												int pos = (r)++;
												c = data->b->__get(pos);
											}
											vr = pal->b->__get((c * (int)3));
											vg = pal->b->__get(((c * (int)3) + (int)1));
											vb = pal->b->__get(((c * (int)3) + (int)2));
											if (((alpha != null()))){
												va = alpha->b->__get(c);
											}
										}
										bgra->b[w] = (vb + bgra->b->__get((w - stride1)));
										(w)++;
										bgra->b[w] = (vg + bgra->b->__get((w - stride1)));
										(w)++;
										bgra->b[w] = (vr + bgra->b->__get((w - stride1)));
										(w)++;
										bgra->b[w] = (va + bgra->b->__get((w - stride1)));
										(w)++;
									}
								}
							}
							;break;
							case (int)3: {
								int cr = (int)0;
								int cg = (int)0;
								int cb = (int)0;
								int ca = (int)0;
								int stride1;
								if (((y == (int)0))){
									stride1 = (int)0;
								}
								else{
									stride1 = (width * (int)4);
								}
								{
									int _g3 = (int)0;
									while((true)){
										if ((!(((_g3 < width))))){
											break;
										}
										int x = (_g3)++;
										{
											int c;
											{
												int pos = (r)++;
												c = data->b->__get(pos);
											}
											vr = pal->b->__get((c * (int)3));
											vg = pal->b->__get(((c * (int)3) + (int)1));
											vb = pal->b->__get(((c * (int)3) + (int)2));
											if (((alpha != null()))){
												va = alpha->b->__get(c);
											}
										}
										cb = (int((vb + ((int((cb + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
										{
											int pos = (w)++;
											bgra->b[pos] = cb;
										}
										cg = (int((vg + ((int((cg + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
										{
											int pos = (w)++;
											bgra->b[pos] = cg;
										}
										cr = (int((vr + ((int((cr + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
										{
											int pos = (w)++;
											bgra->b[pos] = cr;
										}
										cr = (int((va + ((int((ca + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
										{
											int pos = (w)++;
											bgra->b[pos] = ca;
										}
									}
								}
							}
							;break;
							case (int)4: {
								int stride1 = (width * (int)4);
								int cr = (int)0;
								int cg = (int)0;
								int cb = (int)0;
								int ca = (int)0;
								{
									int _g3 = (int)0;
									while((true)){
										if ((!(((_g3 < width))))){
											break;
										}
										int x = (_g3)++;
										{
											int c;
											{
												int pos = (r)++;
												c = data->b->__get(pos);
											}
											vr = pal->b->__get((c * (int)3));
											vg = pal->b->__get(((c * (int)3) + (int)1));
											vb = pal->b->__get(((c * (int)3) + (int)2));
											if (((alpha != null()))){
												va = alpha->b->__get(c);
											}
										}
										int _g31;
										{
											int numChannels = (int)4;
											int b;
											if (((y == (int)0))){
												b = (int)0;
											}
											else{
												b = bgra->b->__get((w - stride1));
											}
											int c;
											if (((bool((x == (int)0)) || bool((y == (int)0))))){
												c = (int)0;
											}
											else{
												c = bgra->b->__get(((w - stride1) - numChannels));
											}
											int k = ((cb + b) - c);
											int pa = (k - cb);
											if (((pa < (int)0))){
												pa = -(pa);
											}
											int pb = (k - b);
											if (((pb < (int)0))){
												pb = -(pb);
											}
											int pc = (k - c);
											if (((pc < (int)0))){
												pc = -(pc);
											}
											if (((bool((pa <= pb)) && bool((pa <= pc))))){
												_g31 = cb;
											}
											else{
												if (((pb <= pc))){
													_g31 = b;
												}
												else{
													_g31 = c;
												}
											}
										}
										int _g4 = (_g31 + vb);
										int _g5 = (int(_g4) & int((int)255));
										cb = _g5;
										{
											int pos = (w)++;
											bgra->b[pos] = cb;
										}
										int _g6;
										{
											int numChannels = (int)4;
											int b;
											if (((y == (int)0))){
												b = (int)0;
											}
											else{
												b = bgra->b->__get((w - stride1));
											}
											int c;
											if (((bool((x == (int)0)) || bool((y == (int)0))))){
												c = (int)0;
											}
											else{
												c = bgra->b->__get(((w - stride1) - numChannels));
											}
											int k = ((cg + b) - c);
											int pa = (k - cg);
											if (((pa < (int)0))){
												pa = -(pa);
											}
											int pb = (k - b);
											if (((pb < (int)0))){
												pb = -(pb);
											}
											int pc = (k - c);
											if (((pc < (int)0))){
												pc = -(pc);
											}
											if (((bool((pa <= pb)) && bool((pa <= pc))))){
												_g6 = cg;
											}
											else{
												if (((pb <= pc))){
													_g6 = b;
												}
												else{
													_g6 = c;
												}
											}
										}
										int _g7 = (_g6 + vg);
										int _g8 = (int(_g7) & int((int)255));
										cg = _g8;
										{
											int pos = (w)++;
											bgra->b[pos] = cg;
										}
										int _g9;
										{
											int numChannels = (int)4;
											int b;
											if (((y == (int)0))){
												b = (int)0;
											}
											else{
												b = bgra->b->__get((w - stride1));
											}
											int c;
											if (((bool((x == (int)0)) || bool((y == (int)0))))){
												c = (int)0;
											}
											else{
												c = bgra->b->__get(((w - stride1) - numChannels));
											}
											int k = ((cr + b) - c);
											int pa = (k - cr);
											if (((pa < (int)0))){
												pa = -(pa);
											}
											int pb = (k - b);
											if (((pb < (int)0))){
												pb = -(pb);
											}
											int pc = (k - c);
											if (((pc < (int)0))){
												pc = -(pc);
											}
											if (((bool((pa <= pb)) && bool((pa <= pc))))){
												_g9 = cr;
											}
											else{
												if (((pb <= pc))){
													_g9 = b;
												}
												else{
													_g9 = c;
												}
											}
										}
										int _g10 = (_g9 + vr);
										int _g11 = (int(_g10) & int((int)255));
										cr = _g11;
										{
											int pos = (w)++;
											bgra->b[pos] = cr;
										}
										int _g12;
										{
											int numChannels = (int)4;
											int b;
											if (((y == (int)0))){
												b = (int)0;
											}
											else{
												b = bgra->b->__get((w - stride1));
											}
											int c;
											if (((bool((x == (int)0)) || bool((y == (int)0))))){
												c = (int)0;
											}
											else{
												c = bgra->b->__get(((w - stride1) - numChannels));
											}
											int k = ((ca + b) - c);
											int pa = (k - ca);
											if (((pa < (int)0))){
												pa = -(pa);
											}
											int pb = (k - b);
											if (((pb < (int)0))){
												pb = -(pb);
											}
											int pc = (k - c);
											if (((pc < (int)0))){
												pc = -(pc);
											}
											if (((bool((pa <= pb)) && bool((pa <= pc))))){
												_g12 = ca;
											}
											else{
												if (((pb <= pc))){
													_g12 = b;
												}
												else{
													_g12 = c;
												}
											}
										}
										int _g13 = (_g12 + va);
										int _g14 = (int(_g13) & int((int)255));
										ca = _g14;
										{
											int pos = (w)++;
											bgra->b[pos] = ca;
										}
									}
								}
							}
							;break;
							default: {
								HX_STACK_DO_THROW((HX_CSTRING("Invalid filter ") + f));
							}
						}
					}
				}
			}
			;break;
			case (int)0: {
				bool alpha = (::format::png::Color(_g))->__Param(0);
				{
					if (((h->__Field(HX_CSTRING("colbits"),true) != (int)8))){
						HX_STACK_DO_THROW(HX_CSTRING("Unsupported color mode"));
					}
					int width = h->__Field(HX_CSTRING("width"),true);
					int stride;
					stride = ((((  ((alpha)) ? int((int)2) : int((int)1) )) * width) + (int)1);
					if (((data->length < (h->__Field(HX_CSTRING("height"),true) * stride)))){
						HX_STACK_DO_THROW(HX_CSTRING("Not enough data"));
					}
					{
						int _g21 = (int)0;
						int _g1 = h->__Field(HX_CSTRING("height"),true);
						while((true)){
							if ((!(((_g21 < _g1))))){
								break;
							}
							int y = (_g21)++;
							int f;
							{
								int pos = (r)++;
								f = data->b->__get(pos);
							}
							switch( (int)(f)){
								case (int)0: {
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int v;
											{
												int pos = (r)++;
												v = data->b->__get(pos);
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												int v1;
												{
													int pos1 = (r)++;
													v1 = data->b->__get(pos1);
												}
												bgra->b[pos] = v1;
											}
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int v;
											{
												int pos = (r)++;
												v = data->b->__get(pos);
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
										}
									}
								}
								;break;
								case (int)1: {
									int cv = (int)0;
									int ca = (int)0;
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g15;
											{
												int pos = (r)++;
												_g15 = data->b->__get(pos);
											}
											hx::AddEq(cv,_g15);
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											int _g16;
											{
												int pos = (r)++;
												_g16 = data->b->__get(pos);
											}
											hx::AddEq(ca,_g16);
											{
												int pos = (w)++;
												bgra->b[pos] = ca;
											}
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g17;
											{
												int pos = (r)++;
												_g17 = data->b->__get(pos);
											}
											hx::AddEq(cv,_g17);
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
										}
									}
								}
								;break;
								case (int)2: {
									int stride1;
									if (((y == (int)0))){
										stride1 = (int)0;
									}
									else{
										stride1 = (width * (int)4);
									}
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g18;
											{
												int pos = (r)++;
												_g18 = data->b->__get(pos);
											}
											int v = (_g18 + bgra->b->__get((w - stride1)));
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												int _g19;
												{
													int pos1 = (r)++;
													_g19 = data->b->__get(pos1);
												}
												int v1 = (_g19 + bgra->b->__get((w - stride1)));
												bgra->b[pos] = v1;
											}
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g20;
											{
												int pos = (r)++;
												_g20 = data->b->__get(pos);
											}
											int v = (_g20 + bgra->b->__get((w - stride1)));
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = v;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
										}
									}
								}
								;break;
								case (int)3: {
									int cv = (int)0;
									int ca = (int)0;
									int stride1;
									if (((y == (int)0))){
										stride1 = (int)0;
									}
									else{
										stride1 = (width * (int)4);
									}
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g211;
											{
												int pos = (r)++;
												_g211 = data->b->__get(pos);
											}
											int _g22 = (_g211 + ((int((cv + bgra->b->__get((w - stride1)))) >> int((int)1))));
											int _g23 = (int(_g22) & int((int)255));
											cv = _g23;
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											int _g24;
											{
												int pos = (r)++;
												_g24 = data->b->__get(pos);
											}
											int _g25 = (_g24 + ((int((ca + bgra->b->__get((w - stride1)))) >> int((int)1))));
											int _g26 = (int(_g25) & int((int)255));
											ca = _g26;
											{
												int pos = (w)++;
												bgra->b[pos] = ca;
											}
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g27;
											{
												int pos = (r)++;
												_g27 = data->b->__get(pos);
											}
											int _g28 = (_g27 + ((int((cv + bgra->b->__get((w - stride1)))) >> int((int)1))));
											int _g29 = (int(_g28) & int((int)255));
											cv = _g29;
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
										}
									}
								}
								;break;
								case (int)4: {
									int stride1 = (width * (int)4);
									int cv = (int)0;
									int ca = (int)0;
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g30;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cv + b) - c);
												int pa = (k - cv);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g30 = cv;
												}
												else{
													if (((pb <= pc))){
														_g30 = b;
													}
													else{
														_g30 = c;
													}
												}
											}
											int _g31;
											{
												int pos = (r)++;
												_g31 = data->b->__get(pos);
											}
											int _g32 = (_g30 + _g31);
											int _g33 = (int(_g32) & int((int)255));
											cv = _g33;
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											int _g34;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((ca + b) - c);
												int pa = (k - ca);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g34 = ca;
												}
												else{
													if (((pb <= pc))){
														_g34 = b;
													}
													else{
														_g34 = c;
													}
												}
											}
											int _g35;
											{
												int pos = (r)++;
												_g35 = data->b->__get(pos);
											}
											int _g36 = (_g34 + _g35);
											int _g37 = (int(_g36) & int((int)255));
											ca = _g37;
											{
												int pos = (w)++;
												bgra->b[pos] = ca;
											}
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g38;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cv + b) - c);
												int pa = (k - cv);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g38 = cv;
												}
												else{
													if (((pb <= pc))){
														_g38 = b;
													}
													else{
														_g38 = c;
													}
												}
											}
											int _g39;
											{
												int pos = (r)++;
												_g39 = data->b->__get(pos);
											}
											int _g40 = (_g38 + _g39);
											int _g41 = (int(_g40) & int((int)255));
											cv = _g41;
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = cv;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
										}
									}
								}
								;break;
								default: {
									HX_STACK_DO_THROW((HX_CSTRING("Invalid filter ") + f));
								}
							}
						}
					}
				}
			}
			;break;
			case (int)1: {
				bool alpha = (::format::png::Color(_g))->__Param(0);
				{
					if (((h->__Field(HX_CSTRING("colbits"),true) != (int)8))){
						HX_STACK_DO_THROW(HX_CSTRING("Unsupported color mode"));
					}
					int width = h->__Field(HX_CSTRING("width"),true);
					int stride;
					stride = ((((  ((alpha)) ? int((int)4) : int((int)3) )) * width) + (int)1);
					if (((data->length < (h->__Field(HX_CSTRING("height"),true) * stride)))){
						HX_STACK_DO_THROW(HX_CSTRING("Not enough data"));
					}
					{
						int _g21 = (int)0;
						int _g1 = h->__Field(HX_CSTRING("height"),true);
						while((true)){
							if ((!(((_g21 < _g1))))){
								break;
							}
							int y = (_g21)++;
							int f;
							{
								int pos = (r)++;
								f = data->b->__get(pos);
							}
							switch( (int)(f)){
								case (int)0: {
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											{
												int pos = (w)++;
												bgra->b[pos] = data->b->__get((r + (int)2));
											}
											{
												int pos = (w)++;
												bgra->b[pos] = data->b->__get((r + (int)1));
											}
											{
												int pos = (w)++;
												bgra->b[pos] = data->b->__get(r);
											}
											{
												int pos = (w)++;
												bgra->b[pos] = data->b->__get((r + (int)3));
											}
											hx::AddEq(r,(int)4);
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											{
												int pos = (w)++;
												bgra->b[pos] = data->b->__get((r + (int)2));
											}
											{
												int pos = (w)++;
												bgra->b[pos] = data->b->__get((r + (int)1));
											}
											{
												int pos = (w)++;
												bgra->b[pos] = data->b->__get(r);
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
											hx::AddEq(r,(int)3);
										}
									}
								}
								;break;
								case (int)1: {
									int cr = (int)0;
									int cg = (int)0;
									int cb = (int)0;
									int ca = (int)0;
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											hx::AddEq(cb,data->b->__get((r + (int)2)));
											{
												int pos = (w)++;
												bgra->b[pos] = cb;
											}
											hx::AddEq(cg,data->b->__get((r + (int)1)));
											{
												int pos = (w)++;
												bgra->b[pos] = cg;
											}
											hx::AddEq(cr,data->b->__get(r));
											{
												int pos = (w)++;
												bgra->b[pos] = cr;
											}
											hx::AddEq(ca,data->b->__get((r + (int)3)));
											{
												int pos = (w)++;
												bgra->b[pos] = ca;
											}
											hx::AddEq(r,(int)4);
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											hx::AddEq(cb,data->b->__get((r + (int)2)));
											{
												int pos = (w)++;
												bgra->b[pos] = cb;
											}
											hx::AddEq(cg,data->b->__get((r + (int)1)));
											{
												int pos = (w)++;
												bgra->b[pos] = cg;
											}
											hx::AddEq(cr,data->b->__get(r));
											{
												int pos = (w)++;
												bgra->b[pos] = cr;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
											hx::AddEq(r,(int)3);
										}
									}
								}
								;break;
								case (int)2: {
									int stride1;
									if (((y == (int)0))){
										stride1 = (int)0;
									}
									else{
										stride1 = (width * (int)4);
									}
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											bgra->b[w] = (data->b->__get((r + (int)2)) + bgra->b->__get((w - stride1)));
											(w)++;
											bgra->b[w] = (data->b->__get((r + (int)1)) + bgra->b->__get((w - stride1)));
											(w)++;
											bgra->b[w] = (data->b->__get(r) + bgra->b->__get((w - stride1)));
											(w)++;
											bgra->b[w] = (data->b->__get((r + (int)3)) + bgra->b->__get((w - stride1)));
											(w)++;
											hx::AddEq(r,(int)4);
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											bgra->b[w] = (data->b->__get((r + (int)2)) + bgra->b->__get((w - stride1)));
											(w)++;
											bgra->b[w] = (data->b->__get((r + (int)1)) + bgra->b->__get((w - stride1)));
											(w)++;
											bgra->b[w] = (data->b->__get(r) + bgra->b->__get((w - stride1)));
											(w)++;
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
											hx::AddEq(r,(int)3);
										}
									}
								}
								;break;
								case (int)3: {
									int cr = (int)0;
									int cg = (int)0;
									int cb = (int)0;
									int ca = (int)0;
									int stride1;
									if (((y == (int)0))){
										stride1 = (int)0;
									}
									else{
										stride1 = (width * (int)4);
									}
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											cb = (int((data->b->__get((r + (int)2)) + ((int((cb + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											{
												int pos = (w)++;
												bgra->b[pos] = cb;
											}
											cg = (int((data->b->__get((r + (int)1)) + ((int((cg + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											{
												int pos = (w)++;
												bgra->b[pos] = cg;
											}
											cr = (int((data->b->__get(r) + ((int((cr + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											{
												int pos = (w)++;
												bgra->b[pos] = cr;
											}
											ca = (int((data->b->__get((r + (int)3)) + ((int((ca + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											{
												int pos = (w)++;
												bgra->b[pos] = ca;
											}
											hx::AddEq(r,(int)4);
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											cb = (int((data->b->__get((r + (int)2)) + ((int((cb + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											{
												int pos = (w)++;
												bgra->b[pos] = cb;
											}
											cg = (int((data->b->__get((r + (int)1)) + ((int((cg + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											{
												int pos = (w)++;
												bgra->b[pos] = cg;
											}
											cr = (int((data->b->__get(r) + ((int((cr + bgra->b->__get((w - stride1)))) >> int((int)1))))) & int((int)255));
											{
												int pos = (w)++;
												bgra->b[pos] = cr;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
											hx::AddEq(r,(int)3);
										}
									}
								}
								;break;
								case (int)4: {
									int stride1 = (width * (int)4);
									int cr = (int)0;
									int cg = (int)0;
									int cb = (int)0;
									int ca = (int)0;
									if ((alpha)){
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g42;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cb + b) - c);
												int pa = (k - cb);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g42 = cb;
												}
												else{
													if (((pb <= pc))){
														_g42 = b;
													}
													else{
														_g42 = c;
													}
												}
											}
											int _g43 = (_g42 + data->b->__get((r + (int)2)));
											int _g44 = (int(_g43) & int((int)255));
											cb = _g44;
											{
												int pos = (w)++;
												bgra->b[pos] = cb;
											}
											int _g45;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cg + b) - c);
												int pa = (k - cg);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g45 = cg;
												}
												else{
													if (((pb <= pc))){
														_g45 = b;
													}
													else{
														_g45 = c;
													}
												}
											}
											int _g46 = (_g45 + data->b->__get((r + (int)1)));
											int _g47 = (int(_g46) & int((int)255));
											cg = _g47;
											{
												int pos = (w)++;
												bgra->b[pos] = cg;
											}
											int _g48;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cr + b) - c);
												int pa = (k - cr);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g48 = cr;
												}
												else{
													if (((pb <= pc))){
														_g48 = b;
													}
													else{
														_g48 = c;
													}
												}
											}
											int _g49 = (_g48 + data->b->__get(r));
											int _g50 = (int(_g49) & int((int)255));
											cr = _g50;
											{
												int pos = (w)++;
												bgra->b[pos] = cr;
											}
											int _g51;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((ca + b) - c);
												int pa = (k - ca);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g51 = ca;
												}
												else{
													if (((pb <= pc))){
														_g51 = b;
													}
													else{
														_g51 = c;
													}
												}
											}
											int _g52 = (_g51 + data->b->__get((r + (int)3)));
											int _g53 = (int(_g52) & int((int)255));
											ca = _g53;
											{
												int pos = (w)++;
												bgra->b[pos] = ca;
											}
											hx::AddEq(r,(int)4);
										}
									}
									else{
										int _g3 = (int)0;
										while((true)){
											if ((!(((_g3 < width))))){
												break;
											}
											int x = (_g3)++;
											int _g54;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cb + b) - c);
												int pa = (k - cb);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g54 = cb;
												}
												else{
													if (((pb <= pc))){
														_g54 = b;
													}
													else{
														_g54 = c;
													}
												}
											}
											int _g55 = (_g54 + data->b->__get((r + (int)2)));
											int _g56 = (int(_g55) & int((int)255));
											cb = _g56;
											{
												int pos = (w)++;
												bgra->b[pos] = cb;
											}
											int _g57;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cg + b) - c);
												int pa = (k - cg);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g57 = cg;
												}
												else{
													if (((pb <= pc))){
														_g57 = b;
													}
													else{
														_g57 = c;
													}
												}
											}
											int _g58 = (_g57 + data->b->__get((r + (int)1)));
											int _g59 = (int(_g58) & int((int)255));
											cg = _g59;
											{
												int pos = (w)++;
												bgra->b[pos] = cg;
											}
											int _g60;
											{
												int numChannels = (int)4;
												int b;
												if (((y == (int)0))){
													b = (int)0;
												}
												else{
													b = bgra->b->__get((w - stride1));
												}
												int c;
												if (((bool((x == (int)0)) || bool((y == (int)0))))){
													c = (int)0;
												}
												else{
													c = bgra->b->__get(((w - stride1) - numChannels));
												}
												int k = ((cr + b) - c);
												int pa = (k - cr);
												if (((pa < (int)0))){
													pa = -(pa);
												}
												int pb = (k - b);
												if (((pb < (int)0))){
													pb = -(pb);
												}
												int pc = (k - c);
												if (((pc < (int)0))){
													pc = -(pc);
												}
												if (((bool((pa <= pb)) && bool((pa <= pc))))){
													_g60 = cr;
												}
												else{
													if (((pb <= pc))){
														_g60 = b;
													}
													else{
														_g60 = c;
													}
												}
											}
											int _g61 = (_g60 + data->b->__get(r));
											int _g62 = (int(_g61) & int((int)255));
											cr = _g62;
											{
												int pos = (w)++;
												bgra->b[pos] = cr;
											}
											{
												int pos = (w)++;
												bgra->b[pos] = (int)255;
											}
											hx::AddEq(r,(int)3);
										}
									}
								}
								;break;
								default: {
									HX_STACK_DO_THROW((HX_CSTRING("Invalid filter ") + f));
								}
							}
						}
					}
				}
			}
			;break;
		}
	}
	return bgra;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Tools_obj,extract32,return )

::List Tools_obj::buildGrey( int width,int height,::haxe::io::Bytes data){
	HX_STACK_FRAME("format.png.Tools","buildGrey",0x5d0708fe,"format.png.Tools.buildGrey","format/png/Tools.hx",584,0x79d90221)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(585)
	::haxe::io::Bytes rgb = ::haxe::io::Bytes_obj::alloc(((width * height) + height));		HX_STACK_VAR(rgb,"rgb");
	HX_STACK_LINE(587)
	int w = (int)0;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(587)
	int r = (int)0;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(588)
	{
		HX_STACK_LINE(588)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(588)
		while((true)){
			HX_STACK_LINE(588)
			if ((!(((_g < height))))){
				HX_STACK_LINE(588)
				break;
			}
			HX_STACK_LINE(588)
			int y = (_g)++;		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(589)
			{
				HX_STACK_LINE(589)
				int pos = (w)++;		HX_STACK_VAR(pos,"pos");
				HX_STACK_LINE(589)
				rgb->b[pos] = (int)0;
			}
			HX_STACK_LINE(590)
			{
				HX_STACK_LINE(590)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(590)
				while((true)){
					HX_STACK_LINE(590)
					if ((!(((_g1 < width))))){
						HX_STACK_LINE(590)
						break;
					}
					HX_STACK_LINE(590)
					int x = (_g1)++;		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(591)
					int pos = (w)++;		HX_STACK_VAR(pos,"pos");
					HX_STACK_LINE(591)
					int v;		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(591)
					{
						HX_STACK_LINE(591)
						int pos1 = (r)++;		HX_STACK_VAR(pos1,"pos1");
						HX_STACK_LINE(591)
						v = data->b->__get(pos1);
					}
					HX_STACK_LINE(591)
					rgb->b[pos] = v;
				}
			}
		}
	}
	HX_STACK_LINE(593)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(594)
	::format::png::Color _g = ::format::png::Color_obj::ColGrey(false);		HX_STACK_VAR(_g,"_g");
	struct _Function_1_1{
		inline static Dynamic Block( int &width,::format::png::Color &_g,int &height){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","format/png/Tools.hx",594,0x79d90221)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , width,false);
				__result->Add(HX_CSTRING("height") , height,false);
				__result->Add(HX_CSTRING("colbits") , (int)8,false);
				__result->Add(HX_CSTRING("color") , _g,false);
				__result->Add(HX_CSTRING("interlaced") , false,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(594)
	Dynamic _g1 = _Function_1_1::Block(width,_g,height);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(594)
	::format::png::Chunk _g2 = ::format::png::Chunk_obj::CHeader(_g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(594)
	l->add(_g2);
	HX_STACK_LINE(595)
	::haxe::io::Bytes _g3 = ::format::tools::Deflate_obj::run(rgb);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(595)
	::format::png::Chunk _g4 = ::format::png::Chunk_obj::CData(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(595)
	l->add(_g4);
	HX_STACK_LINE(596)
	l->add(::format::png::Chunk_obj::CEnd);
	HX_STACK_LINE(597)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Tools_obj,buildGrey,return )

::List Tools_obj::buildRGB( int width,int height,::haxe::io::Bytes data){
	HX_STACK_FRAME("format.png.Tools","buildRGB",0x68ea624e,"format.png.Tools.buildRGB","format/png/Tools.hx",603,0x79d90221)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(604)
	::haxe::io::Bytes rgb = ::haxe::io::Bytes_obj::alloc((((width * height) * (int)3) + height));		HX_STACK_VAR(rgb,"rgb");
	HX_STACK_LINE(606)
	int w = (int)0;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(606)
	int r = (int)0;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(607)
	{
		HX_STACK_LINE(607)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(607)
		while((true)){
			HX_STACK_LINE(607)
			if ((!(((_g < height))))){
				HX_STACK_LINE(607)
				break;
			}
			HX_STACK_LINE(607)
			int y = (_g)++;		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(608)
			{
				HX_STACK_LINE(608)
				int pos = (w)++;		HX_STACK_VAR(pos,"pos");
				HX_STACK_LINE(608)
				rgb->b[pos] = (int)0;
			}
			HX_STACK_LINE(609)
			{
				HX_STACK_LINE(609)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(609)
				while((true)){
					HX_STACK_LINE(609)
					if ((!(((_g1 < width))))){
						HX_STACK_LINE(609)
						break;
					}
					HX_STACK_LINE(609)
					int x = (_g1)++;		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(610)
					{
						HX_STACK_LINE(610)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(610)
						rgb->b[pos] = data->b->__get((r + (int)2));
					}
					HX_STACK_LINE(611)
					{
						HX_STACK_LINE(611)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(611)
						rgb->b[pos] = data->b->__get((r + (int)1));
					}
					HX_STACK_LINE(612)
					{
						HX_STACK_LINE(612)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(612)
						rgb->b[pos] = data->b->__get(r);
					}
					HX_STACK_LINE(613)
					hx::AddEq(r,(int)3);
				}
			}
		}
	}
	HX_STACK_LINE(616)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(617)
	::format::png::Color _g = ::format::png::Color_obj::ColTrue(false);		HX_STACK_VAR(_g,"_g");
	struct _Function_1_1{
		inline static Dynamic Block( int &width,::format::png::Color &_g,int &height){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","format/png/Tools.hx",617,0x79d90221)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , width,false);
				__result->Add(HX_CSTRING("height") , height,false);
				__result->Add(HX_CSTRING("colbits") , (int)8,false);
				__result->Add(HX_CSTRING("color") , _g,false);
				__result->Add(HX_CSTRING("interlaced") , false,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(617)
	Dynamic _g1 = _Function_1_1::Block(width,_g,height);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(617)
	::format::png::Chunk _g2 = ::format::png::Chunk_obj::CHeader(_g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(617)
	l->add(_g2);
	HX_STACK_LINE(618)
	::haxe::io::Bytes _g3 = ::format::tools::Deflate_obj::run(rgb);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(618)
	::format::png::Chunk _g4 = ::format::png::Chunk_obj::CData(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(618)
	l->add(_g4);
	HX_STACK_LINE(619)
	l->add(::format::png::Chunk_obj::CEnd);
	HX_STACK_LINE(620)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Tools_obj,buildRGB,return )

::List Tools_obj::build32ARGB( int width,int height,::haxe::io::Bytes data){
	HX_STACK_FRAME("format.png.Tools","build32ARGB",0x02e864aa,"format.png.Tools.build32ARGB","format/png/Tools.hx",626,0x79d90221)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(627)
	::haxe::io::Bytes rgba = ::haxe::io::Bytes_obj::alloc((((width * height) * (int)4) + height));		HX_STACK_VAR(rgba,"rgba");
	HX_STACK_LINE(629)
	int w = (int)0;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(629)
	int r = (int)0;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(630)
	{
		HX_STACK_LINE(630)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(630)
		while((true)){
			HX_STACK_LINE(630)
			if ((!(((_g < height))))){
				HX_STACK_LINE(630)
				break;
			}
			HX_STACK_LINE(630)
			int y = (_g)++;		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(631)
			{
				HX_STACK_LINE(631)
				int pos = (w)++;		HX_STACK_VAR(pos,"pos");
				HX_STACK_LINE(631)
				rgba->b[pos] = (int)0;
			}
			HX_STACK_LINE(632)
			{
				HX_STACK_LINE(632)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(632)
				while((true)){
					HX_STACK_LINE(632)
					if ((!(((_g1 < width))))){
						HX_STACK_LINE(632)
						break;
					}
					HX_STACK_LINE(632)
					int x = (_g1)++;		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(633)
					{
						HX_STACK_LINE(633)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(633)
						rgba->b[pos] = data->b->__get((r + (int)1));
					}
					HX_STACK_LINE(634)
					{
						HX_STACK_LINE(634)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(634)
						rgba->b[pos] = data->b->__get((r + (int)2));
					}
					HX_STACK_LINE(635)
					{
						HX_STACK_LINE(635)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(635)
						rgba->b[pos] = data->b->__get((r + (int)3));
					}
					HX_STACK_LINE(636)
					{
						HX_STACK_LINE(636)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(636)
						rgba->b[pos] = data->b->__get(r);
					}
					HX_STACK_LINE(637)
					hx::AddEq(r,(int)4);
				}
			}
		}
	}
	HX_STACK_LINE(640)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(641)
	::format::png::Color _g = ::format::png::Color_obj::ColTrue(true);		HX_STACK_VAR(_g,"_g");
	struct _Function_1_1{
		inline static Dynamic Block( int &width,::format::png::Color &_g,int &height){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","format/png/Tools.hx",641,0x79d90221)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , width,false);
				__result->Add(HX_CSTRING("height") , height,false);
				__result->Add(HX_CSTRING("colbits") , (int)8,false);
				__result->Add(HX_CSTRING("color") , _g,false);
				__result->Add(HX_CSTRING("interlaced") , false,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(641)
	Dynamic _g1 = _Function_1_1::Block(width,_g,height);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(641)
	::format::png::Chunk _g2 = ::format::png::Chunk_obj::CHeader(_g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(641)
	l->add(_g2);
	HX_STACK_LINE(642)
	::haxe::io::Bytes _g3 = ::format::tools::Deflate_obj::run(rgba);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(642)
	::format::png::Chunk _g4 = ::format::png::Chunk_obj::CData(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(642)
	l->add(_g4);
	HX_STACK_LINE(643)
	l->add(::format::png::Chunk_obj::CEnd);
	HX_STACK_LINE(644)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Tools_obj,build32ARGB,return )

::List Tools_obj::build32BGRA( int width,int height,::haxe::io::Bytes data){
	HX_STACK_FRAME("format.png.Tools","build32BGRA",0x03894c12,"format.png.Tools.build32BGRA","format/png/Tools.hx",650,0x79d90221)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(651)
	::haxe::io::Bytes rgba = ::haxe::io::Bytes_obj::alloc((((width * height) * (int)4) + height));		HX_STACK_VAR(rgba,"rgba");
	HX_STACK_LINE(653)
	int w = (int)0;		HX_STACK_VAR(w,"w");
	HX_STACK_LINE(653)
	int r = (int)0;		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(654)
	{
		HX_STACK_LINE(654)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(654)
		while((true)){
			HX_STACK_LINE(654)
			if ((!(((_g < height))))){
				HX_STACK_LINE(654)
				break;
			}
			HX_STACK_LINE(654)
			int y = (_g)++;		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(655)
			{
				HX_STACK_LINE(655)
				int pos = (w)++;		HX_STACK_VAR(pos,"pos");
				HX_STACK_LINE(655)
				rgba->b[pos] = (int)0;
			}
			HX_STACK_LINE(656)
			{
				HX_STACK_LINE(656)
				int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(656)
				while((true)){
					HX_STACK_LINE(656)
					if ((!(((_g1 < width))))){
						HX_STACK_LINE(656)
						break;
					}
					HX_STACK_LINE(656)
					int x = (_g1)++;		HX_STACK_VAR(x,"x");
					HX_STACK_LINE(657)
					{
						HX_STACK_LINE(657)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(657)
						rgba->b[pos] = data->b->__get((r + (int)2));
					}
					HX_STACK_LINE(658)
					{
						HX_STACK_LINE(658)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(658)
						rgba->b[pos] = data->b->__get((r + (int)1));
					}
					HX_STACK_LINE(659)
					{
						HX_STACK_LINE(659)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(659)
						rgba->b[pos] = data->b->__get(r);
					}
					HX_STACK_LINE(660)
					{
						HX_STACK_LINE(660)
						int pos = (w)++;		HX_STACK_VAR(pos,"pos");
						HX_STACK_LINE(660)
						rgba->b[pos] = data->b->__get((r + (int)3));
					}
					HX_STACK_LINE(661)
					hx::AddEq(r,(int)4);
				}
			}
		}
	}
	HX_STACK_LINE(664)
	::List l = ::List_obj::__new();		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(665)
	::format::png::Color _g = ::format::png::Color_obj::ColTrue(true);		HX_STACK_VAR(_g,"_g");
	struct _Function_1_1{
		inline static Dynamic Block( int &width,::format::png::Color &_g,int &height){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","format/png/Tools.hx",665,0x79d90221)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , width,false);
				__result->Add(HX_CSTRING("height") , height,false);
				__result->Add(HX_CSTRING("colbits") , (int)8,false);
				__result->Add(HX_CSTRING("color") , _g,false);
				__result->Add(HX_CSTRING("interlaced") , false,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(665)
	Dynamic _g1 = _Function_1_1::Block(width,_g,height);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(665)
	::format::png::Chunk _g2 = ::format::png::Chunk_obj::CHeader(_g1);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(665)
	l->add(_g2);
	HX_STACK_LINE(666)
	::haxe::io::Bytes _g3 = ::format::tools::Deflate_obj::run(rgba);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(666)
	::format::png::Chunk _g4 = ::format::png::Chunk_obj::CData(_g3);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(666)
	l->add(_g4);
	HX_STACK_LINE(667)
	l->add(::format::png::Chunk_obj::CEnd);
	HX_STACK_LINE(668)
	return l;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Tools_obj,build32BGRA,return )


Tools_obj::Tools_obj()
{
}

Dynamic Tools_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"filter") ) { return filter_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"buildRGB") ) { return buildRGB_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getHeader") ) { return getHeader_dyn(); }
		if (HX_FIELD_EQ(inName,"extract32") ) { return extract32_dyn(); }
		if (HX_FIELD_EQ(inName,"buildGrey") ) { return buildGrey_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getPalette") ) { return getPalette_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"extractGrey") ) { return extractGrey_dyn(); }
		if (HX_FIELD_EQ(inName,"build32ARGB") ) { return build32ARGB_dyn(); }
		if (HX_FIELD_EQ(inName,"build32BGRA") ) { return build32BGRA_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"reverseBytes") ) { return reverseBytes_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Tools_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	return super::__SetField(inName,inValue,inCallProp);
}

void Tools_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("getHeader"),
	HX_CSTRING("getPalette"),
	HX_CSTRING("filter"),
	HX_CSTRING("reverseBytes"),
	HX_CSTRING("extractGrey"),
	HX_CSTRING("extract32"),
	HX_CSTRING("buildGrey"),
	HX_CSTRING("buildRGB"),
	HX_CSTRING("build32ARGB"),
	HX_CSTRING("build32BGRA"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Tools_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Tools_obj::__mClass,"__mClass");
};

#endif

Class Tools_obj::__mClass;

void Tools_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("format.png.Tools"), hx::TCanCast< Tools_obj> ,sStaticFields,sMemberFields,
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

void Tools_obj::__boot()
{
}

} // end namespace format
} // end namespace png
