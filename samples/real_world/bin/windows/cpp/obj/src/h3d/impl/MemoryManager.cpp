#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Lambda
#include <Lambda.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_impl_BigBuffer
#include <h3d/impl/BigBuffer.h>
#endif
#ifndef INCLUDED_h3d_impl_BigBufferFlag
#include <h3d/impl/BigBufferFlag.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_Driver
#include <h3d/impl/Driver.h>
#endif
#ifndef INCLUDED_h3d_impl_FreeCell
#include <h3d/impl/FreeCell.h>
#endif
#ifndef INCLUDED_h3d_impl_GLVB
#include <h3d/impl/GLVB.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
#endif
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
#endif
#ifndef INCLUDED_h3d_mat_TextureFormat
#include <h3d/mat/TextureFormat.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_ObjectMap
#include <haxe/ds/ObjectMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
#ifndef INCLUDED_openfl_gl_GLBuffer
#include <openfl/gl/GLBuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLTexture
#include <openfl/gl/GLTexture.h>
#endif
namespace h3d{
namespace impl{

Void MemoryManager_obj::__construct(::h3d::impl::Driver driver,int allocSize)
{
HX_STACK_FRAME("h3d.impl.MemoryManager","new",0x2d5badc5,"h3d.impl.MemoryManager.new","h3d/impl/MemoryManager.hx",123,0x525e0dab)
HX_STACK_THIS(this)
HX_STACK_ARG(driver,"driver")
HX_STACK_ARG(allocSize,"allocSize")
{
	HX_STACK_LINE(124)
	this->driver = driver;
	HX_STACK_LINE(125)
	this->allocSize = allocSize;
	HX_STACK_LINE(127)
	::haxe::ds::ObjectMap _g = ::haxe::ds::ObjectMap_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(127)
	this->idict = _g;
	HX_STACK_LINE(128)
	::haxe::ds::ObjectMap _g1 = ::haxe::ds::ObjectMap_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(128)
	this->tdict = _g1;
	HX_STACK_LINE(129)
	Array< ::Dynamic > _g2 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(129)
	this->textures = _g2;
	HX_STACK_LINE(130)
	Array< ::Dynamic > _g3 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(130)
	this->buffers = _g3;
	HX_STACK_LINE(132)
	this->initIndexes();
}
;
	return null();
}

//MemoryManager_obj::~MemoryManager_obj() { }

Dynamic MemoryManager_obj::__CreateEmpty() { return  new MemoryManager_obj; }
hx::ObjectPtr< MemoryManager_obj > MemoryManager_obj::__new(::h3d::impl::Driver driver,int allocSize)
{  hx::ObjectPtr< MemoryManager_obj > result = new MemoryManager_obj();
	result->__construct(driver,allocSize);
	return result;}

Dynamic MemoryManager_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MemoryManager_obj > result = new MemoryManager_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void MemoryManager_obj::initIndexes( ){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","initIndexes",0x46151535,"h3d.impl.MemoryManager.initIndexes","h3d/impl/MemoryManager.hx",135,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_LINE(136)
		Array< int > indices;		HX_STACK_VAR(indices,"indices");
		HX_STACK_LINE(136)
		{
			HX_STACK_LINE(136)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(136)
			indices = Array_obj< int >::__new();
		}
		HX_STACK_LINE(137)
		{
			HX_STACK_LINE(137)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(137)
			int _g = this->allocSize;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(137)
			while((true)){
				HX_STACK_LINE(137)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(137)
					break;
				}
				HX_STACK_LINE(137)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(137)
				indices->push(i);
			}
		}
		HX_STACK_LINE(138)
		::h3d::impl::Indexes _g = this->allocIndex(indices,null(),null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(138)
		this->indexes = _g;
		HX_STACK_LINE(140)
		Array< int > indices1;		HX_STACK_VAR(indices1,"indices1");
		HX_STACK_LINE(140)
		{
			HX_STACK_LINE(140)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(140)
			indices1 = Array_obj< int >::__new();
		}
		HX_STACK_LINE(141)
		int p = (int)0;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(142)
		{
			HX_STACK_LINE(142)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(142)
			int _g2 = (int(this->allocSize) >> int((int)2));		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(142)
			while((true)){
				HX_STACK_LINE(142)
				if ((!(((_g1 < _g2))))){
					HX_STACK_LINE(142)
					break;
				}
				HX_STACK_LINE(142)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(143)
				int k = (int(i) << int((int)2));		HX_STACK_VAR(k,"k");
				HX_STACK_LINE(144)
				indices1->push(k);
				HX_STACK_LINE(145)
				indices1->push((k + (int)1));
				HX_STACK_LINE(146)
				indices1->push((k + (int)2));
				HX_STACK_LINE(147)
				indices1->push((k + (int)2));
				HX_STACK_LINE(148)
				indices1->push((k + (int)1));
				HX_STACK_LINE(149)
				indices1->push((k + (int)3));
			}
		}
		HX_STACK_LINE(151)
		::h3d::impl::Indexes _g1 = this->allocIndex(indices1,null(),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(151)
		this->quadIndexes = _g1;
		HX_STACK_LINE(152)
		{
			HX_STACK_LINE(152)
			::String _g2 = ::Std_obj::string(this->quadIndexes);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(152)
			Dynamic msg = (((HX_CSTRING("allocating ") + this->quadIndexes->count) + HX_CSTRING(" quad indexes ")) + _g2);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(152)
			::String pos_fileName = HX_CSTRING("MemoryManager.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(152)
			int pos_lineNumber = (int)152;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(152)
			::String pos_className = HX_CSTRING("h3d.impl.MemoryManager");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(152)
			::String pos_methodName = HX_CSTRING("initIndexes");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(152)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(152)
				::String _g3 = ::Std_obj::string(msg);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(152)
				::String _g4 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g3);		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(152)
				::haxe::Log_obj::trace(_g4,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(152)
			msg;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,initIndexes,(void))

HX_BEGIN_DEFAULT_FUNC(__default_garbage,MemoryManager_obj)
Void run(){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","garbage",0xdab2ba9a,"h3d.impl.MemoryManager.garbage","h3d/impl/MemoryManager.hx",159,0x525e0dab)
		HX_STACK_THIS(this)
	}
return null();
}
HX_END_LOCAL_FUNC0((void))
HX_END_DEFAULT_FUNC

Void MemoryManager_obj::cleanBuffers( ){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","cleanBuffers",0x493b5ae5,"h3d.impl.MemoryManager.cleanBuffers","h3d/impl/MemoryManager.hx",166,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_LINE(166)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(166)
		int _g = this->buffers->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(166)
		while((true)){
			HX_STACK_LINE(166)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(166)
				break;
			}
			HX_STACK_LINE(166)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(167)
			::h3d::impl::BigBuffer b = this->buffers->__get(i).StaticCast< ::h3d::impl::BigBuffer >();		HX_STACK_VAR(b,"b");
			HX_STACK_LINE(167)
			::h3d::impl::BigBuffer prev = null();		HX_STACK_VAR(prev,"prev");
			HX_STACK_LINE(168)
			while((true)){
				HX_STACK_LINE(168)
				if ((!(((b != null()))))){
					HX_STACK_LINE(168)
					break;
				}
				HX_STACK_LINE(169)
				if (((b->free->count == b->size))){
					HX_STACK_LINE(170)
					b->dispose();
					HX_STACK_LINE(171)
					(this->bufferCount)--;
					HX_STACK_LINE(172)
					hx::SubEq(this->usedMemory,((b->size * b->stride) * (int)4));
					HX_STACK_LINE(173)
					if (((prev == null()))){
						HX_STACK_LINE(174)
						this->buffers[i] = b->next;
					}
					else{
						HX_STACK_LINE(176)
						prev->next = b->next;
					}
				}
				else{
					HX_STACK_LINE(178)
					prev = b;
				}
				HX_STACK_LINE(179)
				b = b->next;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,cleanBuffers,(void))

Dynamic MemoryManager_obj::stats( ){
	HX_STACK_FRAME("h3d.impl.MemoryManager","stats",0xe8d136c4,"h3d.impl.MemoryManager.stats","h3d/impl/MemoryManager.hx",184,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(185)
	int total = (int)0;		HX_STACK_VAR(total,"total");
	HX_STACK_LINE(185)
	int free = (int)0;		HX_STACK_VAR(free,"free");
	HX_STACK_LINE(185)
	int count = (int)0;		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(186)
	{
		HX_STACK_LINE(186)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(186)
		Array< ::Dynamic > _g1 = this->buffers;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(186)
		while((true)){
			HX_STACK_LINE(186)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(186)
				break;
			}
			HX_STACK_LINE(186)
			::h3d::impl::BigBuffer b = _g1->__get(_g).StaticCast< ::h3d::impl::BigBuffer >();		HX_STACK_VAR(b,"b");
			HX_STACK_LINE(186)
			++(_g);
			HX_STACK_LINE(187)
			::h3d::impl::BigBuffer b1 = b;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(188)
			while((true)){
				HX_STACK_LINE(188)
				if ((!(((b1 != null()))))){
					HX_STACK_LINE(188)
					break;
				}
				HX_STACK_LINE(189)
				hx::AddEq(total,((b1->stride * b1->size) * (int)4));
				HX_STACK_LINE(190)
				::h3d::impl::FreeCell f = b1->free;		HX_STACK_VAR(f,"f");
				HX_STACK_LINE(191)
				while((true)){
					HX_STACK_LINE(191)
					if ((!(((f != null()))))){
						HX_STACK_LINE(191)
						break;
					}
					HX_STACK_LINE(192)
					hx::AddEq(free,((f->count * b1->stride) * (int)4));
					HX_STACK_LINE(193)
					f = f->next;
				}
				HX_STACK_LINE(195)
				(count)++;
				HX_STACK_LINE(196)
				b1 = b1->next;
			}
		}
	}
	HX_STACK_LINE(199)
	this->freeTextures();
	HX_STACK_LINE(200)
	int tcount = (int)0;		HX_STACK_VAR(tcount,"tcount");
	HX_STACK_LINE(200)
	int tmem = (int)0;		HX_STACK_VAR(tmem,"tmem");
	HX_STACK_LINE(201)
	for(::cpp::FastIterator_obj< ::h3d::mat::Texture > *__it = ::cpp::CreateFastIterator< ::h3d::mat::Texture >(this->tdict->keys());  __it->hasNext(); ){
		::h3d::mat::Texture t = __it->next();
		{
			HX_STACK_LINE(202)
			(tcount)++;
			HX_STACK_LINE(203)
			hx::AddEq(tmem,((t->width * t->height) * (int)4));
		}
;
	}
	struct _Function_1_1{
		inline static Dynamic Block( int &free,int &tcount,int &count,int &total,int &tmem){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",205,0x525e0dab)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("bufferCount") , count,false);
				__result->Add(HX_CSTRING("freeMemory") , free,false);
				__result->Add(HX_CSTRING("totalMemory") , total,false);
				__result->Add(HX_CSTRING("textureCount") , tcount,false);
				__result->Add(HX_CSTRING("textureMemory") , tmem,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(205)
	return _Function_1_1::Block(free,tcount,count,total,tmem);
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,stats,return )

Dynamic MemoryManager_obj::allocStats( ){
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocStats",0x5ef8c2a5,"h3d.impl.MemoryManager.allocStats","h3d/impl/MemoryManager.hx",214,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(218)
	::haxe::ds::StringMap h = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(h,"h");
	HX_STACK_LINE(219)
	Dynamic all = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(all,"all");
	HX_STACK_LINE(220)
	{
		HX_STACK_LINE(220)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(220)
		Array< ::Dynamic > _g1 = this->buffers;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(220)
		while((true)){
			HX_STACK_LINE(220)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(220)
				break;
			}
			HX_STACK_LINE(220)
			::h3d::impl::BigBuffer buf = _g1->__get(_g).StaticCast< ::h3d::impl::BigBuffer >();		HX_STACK_VAR(buf,"buf");
			HX_STACK_LINE(220)
			++(_g);
			HX_STACK_LINE(221)
			::h3d::impl::BigBuffer buf1 = buf;		HX_STACK_VAR(buf1,"buf1");
			HX_STACK_LINE(222)
			while((true)){
				HX_STACK_LINE(222)
				if ((!(((buf1 != null()))))){
					HX_STACK_LINE(222)
					break;
				}
				HX_STACK_LINE(223)
				::h3d::impl::Buffer b = buf1->allocHead;		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(224)
				while((true)){
					HX_STACK_LINE(224)
					if ((!(((b != null()))))){
						HX_STACK_LINE(224)
						break;
					}
					HX_STACK_LINE(225)
					::String key = ((b->allocPos->__Field(HX_CSTRING("fileName"),true) + HX_CSTRING(":")) + b->allocPos->__Field(HX_CSTRING("lineNumber"),true));		HX_STACK_VAR(key,"key");
					HX_STACK_LINE(226)
					Dynamic inf = h->get(key);		HX_STACK_VAR(inf,"inf");
					HX_STACK_LINE(227)
					if (((inf == null()))){
						struct _Function_6_1{
							inline static Dynamic Block( ::h3d::impl::Buffer &b){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",228,0x525e0dab)
								{
									hx::Anon __result = hx::Anon_obj::Create();
									__result->Add(HX_CSTRING("file") , b->allocPos->__Field(HX_CSTRING("fileName"),true),false);
									__result->Add(HX_CSTRING("line") , b->allocPos->__Field(HX_CSTRING("lineNumber"),true),false);
									__result->Add(HX_CSTRING("count") , (int)0,false);
									__result->Add(HX_CSTRING("size") , (int)0,false);
									__result->Add(HX_CSTRING("tex") , false,false);
									return __result;
								}
								return null();
							}
						};
						HX_STACK_LINE(228)
						inf = _Function_6_1::Block(b);
						HX_STACK_LINE(229)
						h->set(key,inf);
						HX_STACK_LINE(230)
						all->__Field(HX_CSTRING("push"),true)(inf);
					}
					HX_STACK_LINE(232)
					(inf->__FieldRef(HX_CSTRING("count")))++;
					HX_STACK_LINE(233)
					hx::AddEq(inf->__FieldRef(HX_CSTRING("size")),((b->nvert * b->b->stride) * (int)4));
					HX_STACK_LINE(234)
					b = b->allocNext;
				}
				HX_STACK_LINE(236)
				buf1 = buf1->next;
			}
		}
	}
	HX_STACK_LINE(239)
	for(::cpp::FastIterator_obj< ::h3d::mat::Texture > *__it = ::cpp::CreateFastIterator< ::h3d::mat::Texture >(this->tdict->keys());  __it->hasNext(); ){
		::h3d::mat::Texture t = __it->next();
		{
			HX_STACK_LINE(240)
			::String key = (((HX_CSTRING("$") + t->allocPos->__Field(HX_CSTRING("fileName"),true)) + HX_CSTRING(":")) + t->allocPos->__Field(HX_CSTRING("lineNumber"),true));		HX_STACK_VAR(key,"key");
			HX_STACK_LINE(241)
			Dynamic inf = h->get(key);		HX_STACK_VAR(inf,"inf");
			HX_STACK_LINE(242)
			if (((inf == null()))){
				struct _Function_3_1{
					inline static Dynamic Block( ::h3d::mat::Texture &t){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",243,0x525e0dab)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("file") , t->allocPos->__Field(HX_CSTRING("fileName"),true),false);
							__result->Add(HX_CSTRING("line") , t->allocPos->__Field(HX_CSTRING("lineNumber"),true),false);
							__result->Add(HX_CSTRING("count") , (int)0,false);
							__result->Add(HX_CSTRING("size") , (int)0,false);
							__result->Add(HX_CSTRING("tex") , true,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(243)
				inf = _Function_3_1::Block(t);
				HX_STACK_LINE(244)
				h->set(key,inf);
				HX_STACK_LINE(245)
				all->__Field(HX_CSTRING("push"),true)(inf);
			}
			HX_STACK_LINE(247)
			(inf->__FieldRef(HX_CSTRING("count")))++;
			HX_STACK_LINE(248)
			hx::AddEq(inf->__FieldRef(HX_CSTRING("size")),((t->width * t->height) * (int)4));
		}
;
	}

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	int run(Dynamic a,Dynamic b){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h3d/impl/MemoryManager.hx",250,0x525e0dab)
		HX_STACK_ARG(a,"a")
		HX_STACK_ARG(b,"b")
		{
			HX_STACK_LINE(250)
			if (((a->__Field(HX_CSTRING("size"),true) == b->__Field(HX_CSTRING("size"),true)))){
				HX_STACK_LINE(250)
				return (a->__Field(HX_CSTRING("line"),true) - b->__Field(HX_CSTRING("line"),true));
			}
			else{
				HX_STACK_LINE(250)
				return (b->__Field(HX_CSTRING("size"),true) - a->__Field(HX_CSTRING("size"),true));
			}
			HX_STACK_LINE(250)
			return (int)0;
		}
		return null();
	}
	HX_END_LOCAL_FUNC2(return)

	HX_STACK_LINE(250)
	all->__Field(HX_CSTRING("sort"),true)( Dynamic(new _Function_1_1()));
	HX_STACK_LINE(251)
	return all;
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,allocStats,return )

::h3d::mat::Texture MemoryManager_obj::newTexture( ::h3d::mat::TextureFormat fmt,int w,int h,bool cubic,bool target,int mm,Dynamic allocPos){
	HX_STACK_FRAME("h3d.impl.MemoryManager","newTexture",0x8b27b596,"h3d.impl.MemoryManager.newTexture","h3d/impl/MemoryManager.hx",255,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(fmt,"fmt")
	HX_STACK_ARG(w,"w")
	HX_STACK_ARG(h,"h")
	HX_STACK_ARG(cubic,"cubic")
	HX_STACK_ARG(target,"target")
	HX_STACK_ARG(mm,"mm")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(256)
	::h3d::mat::Texture t = ::h3d::mat::Texture_obj::__new(hx::ObjectPtr<OBJ_>(this),fmt,w,h,cubic,target,mm);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(258)
	t->allocPos = allocPos;
	HX_STACK_LINE(260)
	this->initTexture(t);
	HX_STACK_LINE(261)
	return t;
}


HX_DEFINE_DYNAMIC_FUNC7(MemoryManager_obj,newTexture,return )

Void MemoryManager_obj::initTexture( ::h3d::mat::Texture t){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","initTexture",0x04368210,"h3d.impl.MemoryManager.initTexture","h3d/impl/MemoryManager.hx",264,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(265)
		::openfl::gl::GLTexture _g = this->driver->allocTexture(t);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(265)
		t->t = _g;
		HX_STACK_LINE(266)
		this->tdict->set(t,t->t);
		HX_STACK_LINE(267)
		this->textures->push(t->t);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(MemoryManager_obj,initTexture,(void))

Void MemoryManager_obj::deleteIndexes( ::h3d::impl::Indexes i){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","deleteIndexes",0x75675cba,"h3d.impl.MemoryManager.deleteIndexes","h3d/impl/MemoryManager.hx",271,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_LINE(272)
		this->idict->remove(i);
		HX_STACK_LINE(273)
		this->driver->disposeIndexes(i->ibuf);
		HX_STACK_LINE(274)
		i->ibuf = null();
		HX_STACK_LINE(275)
		hx::SubEq(this->usedMemory,(i->count * (int)2));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(MemoryManager_obj,deleteIndexes,(void))

Void MemoryManager_obj::deleteTexture( ::h3d::mat::Texture t){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","deleteTexture",0x3388c995,"h3d.impl.MemoryManager.deleteTexture","h3d/impl/MemoryManager.hx",279,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(280)
		this->textures->remove(t->t);
		HX_STACK_LINE(281)
		this->tdict->remove(t);
		HX_STACK_LINE(282)
		this->driver->disposeTexture(t->t);
		HX_STACK_LINE(283)
		t->t = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(MemoryManager_obj,deleteTexture,(void))

Void MemoryManager_obj::resizeTexture( ::h3d::mat::Texture t,int width,int height){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","resizeTexture",0x7cf6eaec,"h3d.impl.MemoryManager.resizeTexture","h3d/impl/MemoryManager.hx",287,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_ARG(t,"t")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(288)
		t->dispose();
		HX_STACK_LINE(289)
		t->width = width;
		HX_STACK_LINE(290)
		t->height = height;
		HX_STACK_LINE(291)
		this->initTexture(t);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(MemoryManager_obj,resizeTexture,(void))

Dynamic MemoryManager_obj::readAtfHeader( ::haxe::io::Bytes data){
	HX_STACK_FRAME("h3d.impl.MemoryManager","readAtfHeader",0x6503356f,"h3d.impl.MemoryManager.readAtfHeader","h3d/impl/MemoryManager.hx",294,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(data,"data")
	HX_STACK_LINE(295)
	bool cubic = (((int(data->b->__get((int)6)) & int((int)128))) != (int)0);		HX_STACK_VAR(cubic,"cubic");
	HX_STACK_LINE(296)
	bool alpha = false;		HX_STACK_VAR(alpha,"alpha");
	HX_STACK_LINE(296)
	bool compress = false;		HX_STACK_VAR(compress,"compress");
	HX_STACK_LINE(297)
	{
		HX_STACK_LINE(297)
		int _g = (int(data->b->__get((int)6)) & int((int)127));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(297)
		{
			HX_STACK_LINE(297)
			int f = _g;		HX_STACK_VAR(f,"f");
			HX_STACK_LINE(297)
			switch( (int)(_g)){
				case (int)0: {
				}
				;break;
				case (int)1: {
					HX_STACK_LINE(299)
					alpha = true;
				}
				;break;
				case (int)2: {
					HX_STACK_LINE(300)
					compress = true;
				}
				;break;
				case (int)3: case (int)4: {
					HX_STACK_LINE(301)
					alpha = true;
					HX_STACK_LINE(301)
					compress = true;
				}
				;break;
				default: {
					HX_STACK_LINE(302)
					HX_STACK_DO_THROW((HX_CSTRING("Invalid ATF format ") + f));
				}
			}
		}
	}
	HX_STACK_LINE(304)
	int width = (int((int)1) << int(data->b->__get((int)7)));		HX_STACK_VAR(width,"width");
	HX_STACK_LINE(305)
	int height = (int((int)1) << int(data->b->__get((int)8)));		HX_STACK_VAR(height,"height");
	HX_STACK_LINE(306)
	int mips = (data->b->__get((int)9) - (int)1);		HX_STACK_VAR(mips,"mips");
	struct _Function_1_1{
		inline static Dynamic Block( int &width,bool &compress,bool &cubic,int &mips,int &height,bool &alpha){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",307,0x525e0dab)
			{
				hx::Anon __result = hx::Anon_obj::Create();
				__result->Add(HX_CSTRING("width") , width,false);
				__result->Add(HX_CSTRING("height") , height,false);
				__result->Add(HX_CSTRING("cubic") , cubic,false);
				__result->Add(HX_CSTRING("alpha") , alpha,false);
				__result->Add(HX_CSTRING("compress") , compress,false);
				__result->Add(HX_CSTRING("mips") , mips,false);
				return __result;
			}
			return null();
		}
	};
	HX_STACK_LINE(307)
	return _Function_1_1::Block(width,compress,cubic,mips,height,alpha);
}


HX_DEFINE_DYNAMIC_FUNC1(MemoryManager_obj,readAtfHeader,return )

::h3d::mat::Texture MemoryManager_obj::allocCustomTexture( ::h3d::mat::TextureFormat fmt,int width,int height,hx::Null< int >  __o_mipLevels,hx::Null< bool >  __o_cubic,hx::Null< bool >  __o_target,Dynamic allocPos){
int mipLevels = __o_mipLevels.Default(0);
bool cubic = __o_cubic.Default(false);
bool target = __o_target.Default(false);
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocCustomTexture",0x6e6573b0,"h3d.impl.MemoryManager.allocCustomTexture","h3d/impl/MemoryManager.hx",317,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(fmt,"fmt")
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(mipLevels,"mipLevels")
	HX_STACK_ARG(cubic,"cubic")
	HX_STACK_ARG(target,"target")
	HX_STACK_ARG(allocPos,"allocPos")
{
		HX_STACK_LINE(318)
		this->freeTextures();
		HX_STACK_LINE(319)
		return this->newTexture(fmt,width,height,cubic,target,mipLevels,allocPos);
	}
}


HX_DEFINE_DYNAMIC_FUNC7(MemoryManager_obj,allocCustomTexture,return )

::h3d::mat::Texture MemoryManager_obj::allocTexture( int width,int height,Dynamic __o_mipMap,Dynamic allocPos){
Dynamic mipMap = __o_mipMap.Default(false);
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocTexture",0x091ec2e1,"h3d.impl.MemoryManager.allocTexture","h3d/impl/MemoryManager.hx",322,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(mipMap,"mipMap")
	HX_STACK_ARG(allocPos,"allocPos")
{
		HX_STACK_LINE(323)
		this->freeTextures();
		HX_STACK_LINE(324)
		int levels = (int)0;		HX_STACK_VAR(levels,"levels");
		HX_STACK_LINE(325)
		if ((mipMap)){
			HX_STACK_LINE(326)
			while((true)){
				HX_STACK_LINE(326)
				if ((!(((bool((width > (int((int)1) << int(levels)))) && bool((height > (int((int)1) << int(levels))))))))){
					HX_STACK_LINE(326)
					break;
				}
				HX_STACK_LINE(327)
				(levels)++;
			}
		}
		HX_STACK_LINE(329)
		return this->newTexture(::h3d::mat::TextureFormat_obj::Rgba,width,height,false,false,levels,allocPos);
	}
}


HX_DEFINE_DYNAMIC_FUNC4(MemoryManager_obj,allocTexture,return )

::h3d::mat::Texture MemoryManager_obj::allocTargetTexture( int width,int height,Dynamic allocPos){
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocTargetTexture",0xfb85bc10,"h3d.impl.MemoryManager.allocTargetTexture","h3d/impl/MemoryManager.hx",332,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(width,"width")
	HX_STACK_ARG(height,"height")
	HX_STACK_ARG(allocPos,"allocPos")
	HX_STACK_LINE(334)
	this->freeTextures();
	HX_STACK_LINE(335)
	return this->newTexture(::h3d::mat::TextureFormat_obj::Rgba,width,height,false,true,(int)0,allocPos);
}


HX_DEFINE_DYNAMIC_FUNC3(MemoryManager_obj,allocTargetTexture,return )

::h3d::mat::Texture MemoryManager_obj::allocCubeTexture( int size,Dynamic __o_mipMap,Dynamic allocPos){
Dynamic mipMap = __o_mipMap.Default(false);
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocCubeTexture",0xe3b9e16c,"h3d.impl.MemoryManager.allocCubeTexture","h3d/impl/MemoryManager.hx",338,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(size,"size")
	HX_STACK_ARG(mipMap,"mipMap")
	HX_STACK_ARG(allocPos,"allocPos")
{
		HX_STACK_LINE(339)
		this->freeTextures();
		HX_STACK_LINE(340)
		int levels = (int)0;		HX_STACK_VAR(levels,"levels");
		HX_STACK_LINE(341)
		if ((mipMap)){
			HX_STACK_LINE(342)
			while((true)){
				HX_STACK_LINE(342)
				if ((!(((size > (int((int)1) << int(levels))))))){
					HX_STACK_LINE(342)
					break;
				}
				HX_STACK_LINE(343)
				(levels)++;
			}
		}
		HX_STACK_LINE(345)
		return this->newTexture(::h3d::mat::TextureFormat_obj::Rgba,size,size,true,false,levels,allocPos);
	}
}


HX_DEFINE_DYNAMIC_FUNC3(MemoryManager_obj,allocCubeTexture,return )

::h3d::impl::Indexes MemoryManager_obj::allocIndex( Array< int > indices,hx::Null< int >  __o_pos,hx::Null< int >  __o_count){
int pos = __o_pos.Default(0);
int count = __o_count.Default(-1);
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocIndex",0x9901e798,"h3d.impl.MemoryManager.allocIndex","h3d/impl/MemoryManager.hx",349,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(indices,"indices")
	HX_STACK_ARG(pos,"pos")
	HX_STACK_ARG(count,"count")
{
		HX_STACK_LINE(350)
		if (((count < (int)0))){
			HX_STACK_LINE(350)
			count = indices->length;
		}
		HX_STACK_LINE(351)
		::openfl::gl::GLBuffer ibuf = this->driver->allocIndexes(count);		HX_STACK_VAR(ibuf,"ibuf");
		HX_STACK_LINE(352)
		::h3d::impl::Indexes idx = ::h3d::impl::Indexes_obj::__new(hx::ObjectPtr<OBJ_>(this),ibuf,count);		HX_STACK_VAR(idx,"idx");
		HX_STACK_LINE(353)
		idx->upload(indices,(int)0,count,null());
		HX_STACK_LINE(354)
		this->idict->set(idx,true);
		HX_STACK_LINE(355)
		hx::AddEq(this->usedMemory,(idx->count * (int)2));
		HX_STACK_LINE(356)
		return idx;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(MemoryManager_obj,allocIndex,return )

::h3d::impl::Buffer MemoryManager_obj::allocBytes( ::haxe::io::Bytes bytes,int stride,int align,Dynamic __o_isDynamic,Dynamic allocPos){
Dynamic isDynamic = __o_isDynamic.Default(false);
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocBytes",0x988554f1,"h3d.impl.MemoryManager.allocBytes","h3d/impl/MemoryManager.hx",359,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(bytes,"bytes")
	HX_STACK_ARG(stride,"stride")
	HX_STACK_ARG(align,"align")
	HX_STACK_ARG(isDynamic,"isDynamic")
	HX_STACK_ARG(allocPos,"allocPos")
{
		HX_STACK_LINE(360)
		int count = ::Std_obj::_int((Float(bytes->length) / Float(((stride * (int)4)))));		HX_STACK_VAR(count,"count");
		HX_STACK_LINE(361)
		::h3d::impl::Buffer b = this->alloc(count,stride,align,isDynamic,allocPos);		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(362)
		b->uploadBytes(bytes,(int)0,count);
		HX_STACK_LINE(363)
		return b;
	}
}


HX_DEFINE_DYNAMIC_FUNC5(MemoryManager_obj,allocBytes,return )

::h3d::impl::Buffer MemoryManager_obj::allocVector( Array< Float > v,int stride,int align,Dynamic __o_isDynamic,Dynamic allocPos){
Dynamic isDynamic = __o_isDynamic.Default(false);
	HX_STACK_FRAME("h3d.impl.MemoryManager","allocVector",0x4c13597d,"h3d.impl.MemoryManager.allocVector","h3d/impl/MemoryManager.hx",366,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_ARG(stride,"stride")
	HX_STACK_ARG(align,"align")
	HX_STACK_ARG(isDynamic,"isDynamic")
	HX_STACK_ARG(allocPos,"allocPos")
{
		HX_STACK_LINE(367)
		int nvert = ::Std_obj::_int((Float(v->length) / Float(stride)));		HX_STACK_VAR(nvert,"nvert");
		HX_STACK_LINE(368)
		::h3d::impl::Buffer b = this->alloc(nvert,stride,align,isDynamic,allocPos);		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(369)
		b->uploadVector(v,(int)0,nvert);
		HX_STACK_LINE(370)
		return b;
	}
}


HX_DEFINE_DYNAMIC_FUNC5(MemoryManager_obj,allocVector,return )

int MemoryManager_obj::freeTextures( ){
	HX_STACK_FRAME("h3d.impl.MemoryManager","freeTextures",0x8c67a9ff,"h3d.impl.MemoryManager.freeTextures","h3d/impl/MemoryManager.hx",378,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(379)
	::haxe::ds::ObjectMap tall = ::haxe::ds::ObjectMap_obj::__new();		HX_STACK_VAR(tall,"tall");
	HX_STACK_LINE(380)
	{
		HX_STACK_LINE(380)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(380)
		Array< ::Dynamic > _g1 = this->textures;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(380)
		while((true)){
			HX_STACK_LINE(380)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(380)
				break;
			}
			HX_STACK_LINE(380)
			::openfl::gl::GLTexture t = _g1->__get(_g).StaticCast< ::openfl::gl::GLTexture >();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(380)
			++(_g);
			HX_STACK_LINE(381)
			tall->set(t,true);
		}
	}
	HX_STACK_LINE(382)
	for(::cpp::FastIterator_obj< ::openfl::gl::GLTexture > *__it = ::cpp::CreateFastIterator< ::openfl::gl::GLTexture >(this->tdict->iterator());  __it->hasNext(); ){
		::openfl::gl::GLTexture t = __it->next();
		tall->remove(t);
	}
	HX_STACK_LINE(384)
	int count = (int)0;		HX_STACK_VAR(count,"count");
	HX_STACK_LINE(385)
	for(::cpp::FastIterator_obj< ::openfl::gl::GLTexture > *__it = ::cpp::CreateFastIterator< ::openfl::gl::GLTexture >(tall->keys());  __it->hasNext(); ){
		::openfl::gl::GLTexture t = __it->next();
		{
			HX_STACK_LINE(386)
			this->driver->disposeTexture(t);
			HX_STACK_LINE(387)
			this->textures->remove(t);
			HX_STACK_LINE(388)
			(count)++;
		}
;
	}
	HX_STACK_LINE(390)
	return count;
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,freeTextures,return )

int MemoryManager_obj::freeMemory( ){
	HX_STACK_FRAME("h3d.impl.MemoryManager","freeMemory",0x6ea46e08,"h3d.impl.MemoryManager.freeMemory","h3d/impl/MemoryManager.hx",396,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_LINE(397)
	int size = (int)0;		HX_STACK_VAR(size,"size");
	HX_STACK_LINE(398)
	{
		HX_STACK_LINE(398)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(398)
		Array< ::Dynamic > _g1 = this->buffers;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(398)
		while((true)){
			HX_STACK_LINE(398)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(398)
				break;
			}
			HX_STACK_LINE(398)
			::h3d::impl::BigBuffer b = _g1->__get(_g).StaticCast< ::h3d::impl::BigBuffer >();		HX_STACK_VAR(b,"b");
			HX_STACK_LINE(398)
			++(_g);
			HX_STACK_LINE(399)
			::h3d::impl::BigBuffer b1 = b;		HX_STACK_VAR(b1,"b1");
			HX_STACK_LINE(400)
			while((true)){
				HX_STACK_LINE(400)
				if ((!(((b1 != null()))))){
					HX_STACK_LINE(400)
					break;
				}
				HX_STACK_LINE(401)
				::h3d::impl::FreeCell free = b1->free;		HX_STACK_VAR(free,"free");
				HX_STACK_LINE(402)
				while((true)){
					HX_STACK_LINE(402)
					if ((!(((free != null()))))){
						HX_STACK_LINE(402)
						break;
					}
					HX_STACK_LINE(403)
					hx::AddEq(size,((free->count * b1->stride) * (int)4));
					HX_STACK_LINE(404)
					free = free->next;
				}
				HX_STACK_LINE(406)
				b1 = b1->next;
			}
		}
	}
	HX_STACK_LINE(409)
	return size;
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,freeMemory,return )

::h3d::impl::Buffer MemoryManager_obj::alloc( int nvect,int stride,int align,Dynamic __o_isDynamic,Dynamic allocPos){
Dynamic isDynamic = __o_isDynamic.Default(false);
	HX_STACK_FRAME("h3d.impl.MemoryManager","alloc",0x8659651a,"h3d.impl.MemoryManager.alloc","h3d/impl/MemoryManager.hx",422,0x525e0dab)
	HX_STACK_THIS(this)
	HX_STACK_ARG(nvect,"nvect")
	HX_STACK_ARG(stride,"stride")
	HX_STACK_ARG(align,"align")
	HX_STACK_ARG(isDynamic,"isDynamic")
	HX_STACK_ARG(allocPos,"allocPos")
{
		HX_STACK_LINE(423)
		::h3d::impl::BigBuffer b = this->buffers->__get(stride).StaticCast< ::h3d::impl::BigBuffer >();		HX_STACK_VAR(b,"b");
		HX_STACK_LINE(424)
		::h3d::impl::FreeCell free = null();		HX_STACK_VAR(free,"free");
		HX_STACK_LINE(426)
		if (((bool((nvect == (int)0)) && bool((align == (int)0))))){
			HX_STACK_LINE(427)
			align = (int)3;
		}
		HX_STACK_LINE(429)
		{
			HX_STACK_LINE(429)
			::String _g = ::Std_obj::string(isDynamic);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(429)
			Dynamic msg = (((((((HX_CSTRING("allocating vram nb:") + nvect) + HX_CSTRING(" stride:")) + stride) + HX_CSTRING("  align:")) + align) + HX_CSTRING(" dyn:")) + _g);		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(429)
			::String pos_fileName = HX_CSTRING("MemoryManager.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
			HX_STACK_LINE(429)
			int pos_lineNumber = (int)429;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
			HX_STACK_LINE(429)
			::String pos_className = HX_CSTRING("h3d.impl.MemoryManager");		HX_STACK_VAR(pos_className,"pos_className");
			HX_STACK_LINE(429)
			::String pos_methodName = HX_CSTRING("alloc");		HX_STACK_VAR(pos_methodName,"pos_methodName");
			HX_STACK_LINE(429)
			if (((::hxd::System_obj::debugLevel >= (int)3))){
				HX_STACK_LINE(429)
				::String _g1 = ::Std_obj::string(msg);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(429)
				::String _g2 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g1);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(429)
				::haxe::Log_obj::trace(_g2,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
			}
			HX_STACK_LINE(429)
			msg;
		}
		HX_STACK_LINE(431)
		while((true)){
			HX_STACK_LINE(431)
			if ((!(((b != null()))))){
				HX_STACK_LINE(431)
				break;
			}
			HX_STACK_LINE(432)
			{
				HX_STACK_LINE(432)
				::String pos_fileName = HX_CSTRING("MemoryManager.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(432)
				int pos_lineNumber = (int)432;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(432)
				::String pos_className = HX_CSTRING("h3d.impl.MemoryManager");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(432)
				::String pos_methodName = HX_CSTRING("alloc");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(432)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(432)
					::String _g3 = HX_CSTRING("trying to direct reuse buffer");		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(432)
					::String _g4 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g3);		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(432)
					::haxe::Log_obj::trace(_g4,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(432)
				HX_CSTRING("trying to direct reuse buffer");
			}
			HX_STACK_LINE(433)
			free = b->free;
			HX_STACK_LINE(434)
			while((true)){
				HX_STACK_LINE(434)
				if ((!(((free != null()))))){
					HX_STACK_LINE(434)
					break;
				}
				struct _Function_3_1{
					inline static bool Block( ::h3d::impl::BigBuffer &b,Dynamic &isDynamic){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",435,0x525e0dab)
						{
							HX_STACK_LINE(435)
							int _g5 = ::h3d::impl::BigBufferFlag_obj::BBF_DYNAMIC->__Index();		HX_STACK_VAR(_g5,"_g5");
							HX_STACK_LINE(435)
							int _g6 = (int((int)1) << int(_g5));		HX_STACK_VAR(_g6,"_g6");
							HX_STACK_LINE(435)
							int _g7 = (int(b->flags) & int(_g6));		HX_STACK_VAR(_g7,"_g7");
							HX_STACK_LINE(435)
							bool _g8 = (_g7 != (int)0);		HX_STACK_VAR(_g8,"_g8");
							HX_STACK_LINE(435)
							return (_g8 == isDynamic);
						}
						return null();
					}
				};
				HX_STACK_LINE(435)
				if (((  (((free->count >= nvect))) ? bool(_Function_3_1::Block(b,isDynamic)) : bool(false) ))){
					HX_STACK_LINE(437)
					if (((align == (int)0))){
						HX_STACK_LINE(438)
						if (((free->pos != (int)0))){
							HX_STACK_LINE(439)
							free = null();
						}
						HX_STACK_LINE(440)
						break;
					}
					else{
						HX_STACK_LINE(443)
						if (((b->size != this->allocSize))){
							HX_STACK_LINE(444)
							free = null();
							HX_STACK_LINE(445)
							break;
						}
						HX_STACK_LINE(447)
						int d = hx::Mod(((align - hx::Mod(free->pos,align))),align);		HX_STACK_VAR(d,"d");
						HX_STACK_LINE(448)
						if (((d == (int)0))){
							HX_STACK_LINE(449)
							break;
						}
						HX_STACK_LINE(452)
						if (((free->count >= (nvect + d)))){
							HX_STACK_LINE(453)
							{
								HX_STACK_LINE(453)
								::String pos_fileName = HX_CSTRING("MemoryManager.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
								HX_STACK_LINE(453)
								int pos_lineNumber = (int)453;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
								HX_STACK_LINE(453)
								::String pos_className = HX_CSTRING("h3d.impl.MemoryManager");		HX_STACK_VAR(pos_className,"pos_className");
								HX_STACK_LINE(453)
								::String pos_methodName = HX_CSTRING("alloc");		HX_STACK_VAR(pos_methodName,"pos_methodName");
								HX_STACK_LINE(453)
								if (((::hxd::System_obj::debugLevel >= (int)3))){
									HX_STACK_LINE(453)
									::String _g9 = HX_CSTRING("padding buffer...");		HX_STACK_VAR(_g9,"_g9");
									HX_STACK_LINE(453)
									::String _g10 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g9);		HX_STACK_VAR(_g10,"_g10");
									HX_STACK_LINE(453)
									::haxe::Log_obj::trace(_g10,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
								}
								HX_STACK_LINE(453)
								HX_CSTRING("padding buffer...");
							}
							HX_STACK_LINE(454)
							::h3d::impl::FreeCell _g11 = ::h3d::impl::FreeCell_obj::__new((free->pos + d),(free->count - d),free->next);		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(454)
							free->next = _g11;
							HX_STACK_LINE(455)
							free->count = d;
							HX_STACK_LINE(456)
							free = free->next;
							HX_STACK_LINE(457)
							break;
						}
					}
					HX_STACK_LINE(460)
					break;
				}
				HX_STACK_LINE(462)
				free = free->next;
			}
			HX_STACK_LINE(464)
			if (((free != null()))){
				HX_STACK_LINE(464)
				break;
			}
			HX_STACK_LINE(465)
			b = b->next;
		}
		HX_STACK_LINE(469)
		if (((bool((b == null())) && bool((align > (int)0))))){
			HX_STACK_LINE(470)
			{
				HX_STACK_LINE(470)
				::String pos_fileName = HX_CSTRING("MemoryManager.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(470)
				int pos_lineNumber = (int)470;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(470)
				::String pos_className = HX_CSTRING("h3d.impl.MemoryManager");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(470)
				::String pos_methodName = HX_CSTRING("alloc");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(470)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(470)
					::String _g12 = HX_CSTRING("trying to split big free buffers");		HX_STACK_VAR(_g12,"_g12");
					HX_STACK_LINE(470)
					::String _g13 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g12);		HX_STACK_VAR(_g13,"_g13");
					HX_STACK_LINE(470)
					::haxe::Log_obj::trace(_g13,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(470)
				HX_CSTRING("trying to split big free buffers");
			}
			HX_STACK_LINE(471)
			int size = nvect;		HX_STACK_VAR(size,"size");
			HX_STACK_LINE(472)
			while((true)){
				HX_STACK_LINE(472)
				if ((!(((size > (int)1000))))){
					HX_STACK_LINE(472)
					break;
				}
				HX_STACK_LINE(473)
				b = this->buffers->__get(stride).StaticCast< ::h3d::impl::BigBuffer >();
				HX_STACK_LINE(474)
				hx::ShrEq(size,(int)1);
				HX_STACK_LINE(475)
				hx::SubEq(size,hx::Mod(size,align));
				HX_STACK_LINE(476)
				while((true)){
					HX_STACK_LINE(476)
					if ((!(((b != null()))))){
						HX_STACK_LINE(476)
						break;
					}
					HX_STACK_LINE(477)
					free = b->free;
					struct _Function_4_1{
						inline static bool Block( ::h3d::impl::BigBuffer &b,Dynamic &isDynamic){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",479,0x525e0dab)
							{
								HX_STACK_LINE(479)
								int _g14 = ::h3d::impl::BigBufferFlag_obj::BBF_DYNAMIC->__Index();		HX_STACK_VAR(_g14,"_g14");
								HX_STACK_LINE(479)
								int _g15 = (int((int)1) << int(_g14));		HX_STACK_VAR(_g15,"_g15");
								HX_STACK_LINE(479)
								int _g16 = (int(b->flags) & int(_g15));		HX_STACK_VAR(_g16,"_g16");
								HX_STACK_LINE(479)
								bool _g17 = (_g16 != (int)0);		HX_STACK_VAR(_g17,"_g17");
								HX_STACK_LINE(479)
								return (_g17 != isDynamic);
							}
							return null();
						}
					};
					HX_STACK_LINE(479)
					if (((  ((!(((b->size != this->allocSize))))) ? bool(_Function_4_1::Block(b,isDynamic)) : bool(true) ))){
						HX_STACK_LINE(480)
						free = null();
					}
					HX_STACK_LINE(481)
					while((true)){
						HX_STACK_LINE(481)
						if ((!(((free != null()))))){
							HX_STACK_LINE(481)
							break;
						}
						HX_STACK_LINE(482)
						if (((free->count >= size))){
							HX_STACK_LINE(484)
							int d = hx::Mod(((align - hx::Mod(free->pos,align))),align);		HX_STACK_VAR(d,"d");
							HX_STACK_LINE(485)
							if (((d == (int)0))){
								HX_STACK_LINE(486)
								break;
							}
							HX_STACK_LINE(488)
							if (((free->count >= (size + d)))){
								HX_STACK_LINE(489)
								::h3d::impl::FreeCell _g18 = ::h3d::impl::FreeCell_obj::__new((free->pos + d),(free->count - d),free->next);		HX_STACK_VAR(_g18,"_g18");
								HX_STACK_LINE(489)
								free->next = _g18;
								HX_STACK_LINE(490)
								free->count = d;
								HX_STACK_LINE(491)
								free = free->next;
								HX_STACK_LINE(492)
								break;
							}
						}
						HX_STACK_LINE(495)
						free = free->next;
					}
					HX_STACK_LINE(497)
					if (((free != null()))){
						HX_STACK_LINE(497)
						break;
					}
					HX_STACK_LINE(498)
					b = b->next;
				}
				HX_STACK_LINE(500)
				if (((b != null()))){
					HX_STACK_LINE(500)
					break;
				}
			}
		}
		HX_STACK_LINE(505)
		if (((b == null()))){
			HX_STACK_LINE(506)
			{
				HX_STACK_LINE(506)
				::String pos_fileName = HX_CSTRING("MemoryManager.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(506)
				int pos_lineNumber = (int)506;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(506)
				::String pos_className = HX_CSTRING("h3d.impl.MemoryManager");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(506)
				::String pos_methodName = HX_CSTRING("alloc");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(506)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(506)
					::String _g19 = HX_CSTRING("reusable buffer not found. creating shallow buffer...");		HX_STACK_VAR(_g19,"_g19");
					HX_STACK_LINE(506)
					::String _g20 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g19);		HX_STACK_VAR(_g20,"_g20");
					HX_STACK_LINE(506)
					::haxe::Log_obj::trace(_g20,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(506)
				HX_CSTRING("reusable buffer not found. creating shallow buffer...");
			}
			HX_STACK_LINE(508)
			int size = (int)0;		HX_STACK_VAR(size,"size");
			HX_STACK_LINE(509)
			if (((align == (int)0))){
				HX_STACK_LINE(510)
				size = nvect;
				HX_STACK_LINE(511)
				if (((size > (int)65535))){
					HX_STACK_LINE(511)
					HX_STACK_DO_THROW((HX_CSTRING("Too many vertex to allocate ") + size));
				}
			}
			else{
				HX_STACK_LINE(513)
				size = this->allocSize;
			}
			HX_STACK_LINE(514)
			int mem = ((size * stride) * (int)4);		HX_STACK_VAR(mem,"mem");
			HX_STACK_LINE(514)
			::h3d::impl::GLVB v = null();		HX_STACK_VAR(v,"v");
			struct _Function_2_1{
				inline static bool Block( hx::ObjectPtr< ::h3d::impl::MemoryManager_obj > __this,int &size,int &stride,::h3d::impl::GLVB &v){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",515,0x525e0dab)
					{
						HX_STACK_LINE(515)
						::h3d::impl::GLVB _g21 = __this->driver->allocVertex(size,stride,null());		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(515)
						::h3d::impl::GLVB _g22 = v = _g21;		HX_STACK_VAR(_g22,"_g22");
						HX_STACK_LINE(515)
						return (_g22 == null());
					}
					return null();
				}
			};
			HX_STACK_LINE(515)
			if (((  ((!(((bool(((this->usedMemory + mem) > (int)134217728)) || bool((this->bufferCount >= (int)4096))))))) ? bool(_Function_2_1::Block(this,size,stride,v)) : bool(true) ))){
				HX_STACK_LINE(516)
				int _g23 = this->freeMemory();		HX_STACK_VAR(_g23,"_g23");
				HX_STACK_LINE(516)
				int size1 = (this->usedMemory - _g23);		HX_STACK_VAR(size1,"size1");
				HX_STACK_LINE(517)
				this->garbage();
				HX_STACK_LINE(518)
				this->cleanBuffers();
				HX_STACK_LINE(519)
				int _g24 = this->freeMemory();		HX_STACK_VAR(_g24,"_g24");
				HX_STACK_LINE(519)
				int _g25 = (this->usedMemory - _g24);		HX_STACK_VAR(_g25,"_g25");
				HX_STACK_LINE(519)
				if (((_g25 == size1))){
					HX_STACK_LINE(520)
					if (((this->bufferCount >= (int)4096))){
						HX_STACK_LINE(521)
						HX_STACK_DO_THROW(HX_CSTRING("Too many buffer"));
					}
					HX_STACK_LINE(522)
					HX_STACK_DO_THROW(HX_CSTRING("Memory full"));
				}
				HX_STACK_LINE(524)
				return this->alloc(nvect,stride,align,isDynamic,allocPos);
			}
			HX_STACK_LINE(526)
			hx::AddEq(this->usedMemory,mem);
			HX_STACK_LINE(527)
			(this->bufferCount)++;
			HX_STACK_LINE(528)
			::h3d::impl::BigBuffer _g26 = ::h3d::impl::BigBuffer_obj::__new(hx::ObjectPtr<OBJ_>(this),v,stride,size,isDynamic);		HX_STACK_VAR(_g26,"_g26");
			HX_STACK_LINE(528)
			b = _g26;
			HX_STACK_LINE(532)
			b->next = this->buffers->__get(stride).StaticCast< ::h3d::impl::BigBuffer >();
			HX_STACK_LINE(533)
			this->buffers[stride] = b;
			HX_STACK_LINE(534)
			free = b->free;
		}
		HX_STACK_LINE(539)
		int alloc;		HX_STACK_VAR(alloc,"alloc");
		HX_STACK_LINE(539)
		if (((nvect > free->count))){
			HX_STACK_LINE(539)
			alloc = (free->count - hx::Mod(free->count,align));
		}
		else{
			HX_STACK_LINE(539)
			alloc = nvect;
		}
		HX_STACK_LINE(540)
		int fpos = free->pos;		HX_STACK_VAR(fpos,"fpos");
		HX_STACK_LINE(541)
		hx::AddEq(free->pos,alloc);
		HX_STACK_LINE(542)
		hx::SubEq(free->count,alloc);
		HX_STACK_LINE(543)
		::h3d::impl::Buffer b1 = ::h3d::impl::Buffer_obj::__new(b,fpos,alloc);		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(544)
		hx::SubEq(nvect,alloc);
		HX_STACK_LINE(546)
		::h3d::impl::Buffer head = b1->b->allocHead;		HX_STACK_VAR(head,"head");
		HX_STACK_LINE(547)
		b1->allocPos = allocPos;
		HX_STACK_LINE(548)
		b1->allocNext = head;
		HX_STACK_LINE(549)
		if (((head != null()))){
			HX_STACK_LINE(549)
			head->allocPrev = b1;
		}
		HX_STACK_LINE(550)
		b1->b->allocHead = b1;
		HX_STACK_LINE(552)
		if (((nvect > (int)0))){
			HX_STACK_LINE(553)
			{
				HX_STACK_LINE(553)
				::String pos_fileName = HX_CSTRING("MemoryManager.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
				HX_STACK_LINE(553)
				int pos_lineNumber = (int)553;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
				HX_STACK_LINE(553)
				::String pos_className = HX_CSTRING("h3d.impl.MemoryManager");		HX_STACK_VAR(pos_className,"pos_className");
				HX_STACK_LINE(553)
				::String pos_methodName = HX_CSTRING("alloc");		HX_STACK_VAR(pos_methodName,"pos_methodName");
				HX_STACK_LINE(553)
				if (((::hxd::System_obj::debugLevel >= (int)3))){
					HX_STACK_LINE(553)
					::String _g27 = HX_CSTRING("not enough space, loooping");		HX_STACK_VAR(_g27,"_g27");
					HX_STACK_LINE(553)
					::String _g28 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g27);		HX_STACK_VAR(_g28,"_g28");
					HX_STACK_LINE(553)
					::haxe::Log_obj::trace(_g28,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
				}
				HX_STACK_LINE(553)
				HX_CSTRING("not enough space, loooping");
			}
			HX_STACK_LINE(554)
			::h3d::impl::Buffer _g29 = this->alloc(nvect,stride,align,isDynamic,allocPos);		HX_STACK_VAR(_g29,"_g29");
			HX_STACK_LINE(554)
			b1->next = _g29;
		}
		HX_STACK_LINE(558)
		return b1;
	}
}


HX_DEFINE_DYNAMIC_FUNC5(MemoryManager_obj,alloc,return )

Void MemoryManager_obj::onContextLost( ){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","onContextLost",0xbdc41a39,"h3d.impl.MemoryManager.onContextLost","h3d/impl/MemoryManager.hx",561,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_LINE(562)
		this->indexes->dispose();
		HX_STACK_LINE(563)
		this->quadIndexes->dispose();
		struct _Function_1_1{
			inline static Dynamic Block( hx::ObjectPtr< ::h3d::impl::MemoryManager_obj > __this){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/impl/MemoryManager.hx",564,0x525e0dab)
				{
					hx::Anon __result = hx::Anon_obj::Create();
					__result->Add(HX_CSTRING("iterator") , __this->tdict->keys_dyn(),false);
					return __result;
				}
				return null();
			}
		};
		HX_STACK_LINE(564)
		Array< ::Dynamic > tkeys = ::Lambda_obj::array(_Function_1_1::Block(this));		HX_STACK_VAR(tkeys,"tkeys");
		HX_STACK_LINE(565)
		{
			HX_STACK_LINE(565)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(565)
			while((true)){
				HX_STACK_LINE(565)
				if ((!(((_g < tkeys->length))))){
					HX_STACK_LINE(565)
					break;
				}
				HX_STACK_LINE(565)
				::h3d::mat::Texture t = tkeys->__get(_g).StaticCast< ::h3d::mat::Texture >();		HX_STACK_VAR(t,"t");
				HX_STACK_LINE(565)
				++(_g);
				HX_STACK_LINE(566)
				int _g1 = ::__hxcpp_obj_id(t);		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(566)
				if ((!(this->tdict->__Internal->exists(_g1)))){
					HX_STACK_LINE(567)
					continue;
				}
				HX_STACK_LINE(568)
				if (((t->onContextLost == null()))){
					HX_STACK_LINE(569)
					t->dispose();
				}
				else{
					HX_STACK_LINE(571)
					this->textures->remove(t->t);
					HX_STACK_LINE(572)
					this->initTexture(t);
					HX_STACK_LINE(573)
					t->onContextLost();
				}
			}
		}
		HX_STACK_LINE(576)
		{
			HX_STACK_LINE(576)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(576)
			Array< ::Dynamic > _g1 = this->buffers;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(576)
			while((true)){
				HX_STACK_LINE(576)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(576)
					break;
				}
				HX_STACK_LINE(576)
				::h3d::impl::BigBuffer b = _g1->__get(_g).StaticCast< ::h3d::impl::BigBuffer >();		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(576)
				++(_g);
				HX_STACK_LINE(577)
				::h3d::impl::BigBuffer b1 = b;		HX_STACK_VAR(b1,"b1");
				HX_STACK_LINE(578)
				while((true)){
					HX_STACK_LINE(578)
					if ((!(((b1 != null()))))){
						HX_STACK_LINE(578)
						break;
					}
					HX_STACK_LINE(579)
					b1->dispose();
					HX_STACK_LINE(580)
					b1 = b1->next;
				}
			}
		}
		HX_STACK_LINE(583)
		for(::cpp::FastIterator_obj< ::h3d::impl::Indexes > *__it = ::cpp::CreateFastIterator< ::h3d::impl::Indexes >(this->idict->keys());  __it->hasNext(); ){
			::h3d::impl::Indexes i = __it->next();
			i->dispose();
		}
		HX_STACK_LINE(585)
		this->buffers = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(586)
		this->bufferCount = (int)0;
		HX_STACK_LINE(587)
		this->usedMemory = (int)0;
		HX_STACK_LINE(588)
		this->initIndexes();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,onContextLost,(void))

Void MemoryManager_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.impl.MemoryManager","dispose",0x2d7f7484,"h3d.impl.MemoryManager.dispose","h3d/impl/MemoryManager.hx",591,0x525e0dab)
		HX_STACK_THIS(this)
		HX_STACK_LINE(592)
		this->indexes->dispose();
		HX_STACK_LINE(593)
		this->indexes = null();
		HX_STACK_LINE(594)
		this->quadIndexes->dispose();
		HX_STACK_LINE(595)
		this->quadIndexes = null();
		HX_STACK_LINE(596)
		for(::cpp::FastIterator_obj< ::h3d::mat::Texture > *__it = ::cpp::CreateFastIterator< ::h3d::mat::Texture >(this->tdict->keys());  __it->hasNext(); ){
			::h3d::mat::Texture t = __it->next();
			t->dispose();
		}
		HX_STACK_LINE(598)
		{
			HX_STACK_LINE(598)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(598)
			Array< ::Dynamic > _g1 = this->buffers;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(598)
			while((true)){
				HX_STACK_LINE(598)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(598)
					break;
				}
				HX_STACK_LINE(598)
				::h3d::impl::BigBuffer b = _g1->__get(_g).StaticCast< ::h3d::impl::BigBuffer >();		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(598)
				++(_g);
				HX_STACK_LINE(599)
				::h3d::impl::BigBuffer b1 = b;		HX_STACK_VAR(b1,"b1");
				HX_STACK_LINE(600)
				while((true)){
					HX_STACK_LINE(600)
					if ((!(((b1 != null()))))){
						HX_STACK_LINE(600)
						break;
					}
					HX_STACK_LINE(601)
					b1->dispose();
					HX_STACK_LINE(602)
					b1 = b1->next;
				}
			}
		}
		HX_STACK_LINE(605)
		for(::cpp::FastIterator_obj< ::h3d::impl::Indexes > *__it = ::cpp::CreateFastIterator< ::h3d::impl::Indexes >(this->idict->keys());  __it->hasNext(); ){
			::h3d::impl::Indexes i = __it->next();
			i->dispose();
		}
		HX_STACK_LINE(607)
		this->buffers = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(608)
		this->bufferCount = (int)0;
		HX_STACK_LINE(609)
		this->usedMemory = (int)0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(MemoryManager_obj,dispose,(void))

int MemoryManager_obj::MAX_MEMORY;

int MemoryManager_obj::MAX_BUFFERS;


MemoryManager_obj::MemoryManager_obj()
{
	garbage = new __default_garbage(this);
}

void MemoryManager_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MemoryManager);
	HX_MARK_MEMBER_NAME(driver,"driver");
	HX_MARK_MEMBER_NAME(buffers,"buffers");
	HX_MARK_MEMBER_NAME(idict,"idict");
	HX_MARK_MEMBER_NAME(tdict,"tdict");
	HX_MARK_MEMBER_NAME(textures,"textures");
	HX_MARK_MEMBER_NAME(indexes,"indexes");
	HX_MARK_MEMBER_NAME(quadIndexes,"quadIndexes");
	HX_MARK_MEMBER_NAME(usedMemory,"usedMemory");
	HX_MARK_MEMBER_NAME(bufferCount,"bufferCount");
	HX_MARK_MEMBER_NAME(allocSize,"allocSize");
	HX_MARK_MEMBER_NAME(garbage,"garbage");
	HX_MARK_END_CLASS();
}

void MemoryManager_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(driver,"driver");
	HX_VISIT_MEMBER_NAME(buffers,"buffers");
	HX_VISIT_MEMBER_NAME(idict,"idict");
	HX_VISIT_MEMBER_NAME(tdict,"tdict");
	HX_VISIT_MEMBER_NAME(textures,"textures");
	HX_VISIT_MEMBER_NAME(indexes,"indexes");
	HX_VISIT_MEMBER_NAME(quadIndexes,"quadIndexes");
	HX_VISIT_MEMBER_NAME(usedMemory,"usedMemory");
	HX_VISIT_MEMBER_NAME(bufferCount,"bufferCount");
	HX_VISIT_MEMBER_NAME(allocSize,"allocSize");
	HX_VISIT_MEMBER_NAME(garbage,"garbage");
}

Dynamic MemoryManager_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"idict") ) { return idict; }
		if (HX_FIELD_EQ(inName,"tdict") ) { return tdict; }
		if (HX_FIELD_EQ(inName,"stats") ) { return stats_dyn(); }
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"driver") ) { return driver; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"buffers") ) { return buffers; }
		if (HX_FIELD_EQ(inName,"indexes") ) { return indexes; }
		if (HX_FIELD_EQ(inName,"garbage") ) { return garbage; }
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"textures") ) { return textures; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocSize") ) { return allocSize; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"usedMemory") ) { return usedMemory; }
		if (HX_FIELD_EQ(inName,"allocStats") ) { return allocStats_dyn(); }
		if (HX_FIELD_EQ(inName,"newTexture") ) { return newTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"allocIndex") ) { return allocIndex_dyn(); }
		if (HX_FIELD_EQ(inName,"allocBytes") ) { return allocBytes_dyn(); }
		if (HX_FIELD_EQ(inName,"freeMemory") ) { return freeMemory_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"quadIndexes") ) { return quadIndexes; }
		if (HX_FIELD_EQ(inName,"bufferCount") ) { return bufferCount; }
		if (HX_FIELD_EQ(inName,"initIndexes") ) { return initIndexes_dyn(); }
		if (HX_FIELD_EQ(inName,"initTexture") ) { return initTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"allocVector") ) { return allocVector_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"cleanBuffers") ) { return cleanBuffers_dyn(); }
		if (HX_FIELD_EQ(inName,"allocTexture") ) { return allocTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"freeTextures") ) { return freeTextures_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"deleteIndexes") ) { return deleteIndexes_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteTexture") ) { return deleteTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"resizeTexture") ) { return resizeTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"readAtfHeader") ) { return readAtfHeader_dyn(); }
		if (HX_FIELD_EQ(inName,"onContextLost") ) { return onContextLost_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"allocCubeTexture") ) { return allocCubeTexture_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"allocCustomTexture") ) { return allocCustomTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"allocTargetTexture") ) { return allocTargetTexture_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MemoryManager_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"idict") ) { idict=inValue.Cast< ::haxe::ds::ObjectMap >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tdict") ) { tdict=inValue.Cast< ::haxe::ds::ObjectMap >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"driver") ) { driver=inValue.Cast< ::h3d::impl::Driver >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"buffers") ) { buffers=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"indexes") ) { indexes=inValue.Cast< ::h3d::impl::Indexes >(); return inValue; }
		if (HX_FIELD_EQ(inName,"garbage") ) { garbage=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"textures") ) { textures=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allocSize") ) { allocSize=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"usedMemory") ) { usedMemory=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"quadIndexes") ) { quadIndexes=inValue.Cast< ::h3d::impl::Indexes >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bufferCount") ) { bufferCount=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MemoryManager_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("driver"));
	outFields->push(HX_CSTRING("buffers"));
	outFields->push(HX_CSTRING("idict"));
	outFields->push(HX_CSTRING("tdict"));
	outFields->push(HX_CSTRING("textures"));
	outFields->push(HX_CSTRING("indexes"));
	outFields->push(HX_CSTRING("quadIndexes"));
	outFields->push(HX_CSTRING("usedMemory"));
	outFields->push(HX_CSTRING("bufferCount"));
	outFields->push(HX_CSTRING("allocSize"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("MAX_MEMORY"),
	HX_CSTRING("MAX_BUFFERS"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::impl::Driver*/ ,(int)offsetof(MemoryManager_obj,driver),HX_CSTRING("driver")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(MemoryManager_obj,buffers),HX_CSTRING("buffers")},
	{hx::fsObject /*::haxe::ds::ObjectMap*/ ,(int)offsetof(MemoryManager_obj,idict),HX_CSTRING("idict")},
	{hx::fsObject /*::haxe::ds::ObjectMap*/ ,(int)offsetof(MemoryManager_obj,tdict),HX_CSTRING("tdict")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(MemoryManager_obj,textures),HX_CSTRING("textures")},
	{hx::fsObject /*::h3d::impl::Indexes*/ ,(int)offsetof(MemoryManager_obj,indexes),HX_CSTRING("indexes")},
	{hx::fsObject /*::h3d::impl::Indexes*/ ,(int)offsetof(MemoryManager_obj,quadIndexes),HX_CSTRING("quadIndexes")},
	{hx::fsInt,(int)offsetof(MemoryManager_obj,usedMemory),HX_CSTRING("usedMemory")},
	{hx::fsInt,(int)offsetof(MemoryManager_obj,bufferCount),HX_CSTRING("bufferCount")},
	{hx::fsInt,(int)offsetof(MemoryManager_obj,allocSize),HX_CSTRING("allocSize")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(MemoryManager_obj,garbage),HX_CSTRING("garbage")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("driver"),
	HX_CSTRING("buffers"),
	HX_CSTRING("idict"),
	HX_CSTRING("tdict"),
	HX_CSTRING("textures"),
	HX_CSTRING("indexes"),
	HX_CSTRING("quadIndexes"),
	HX_CSTRING("usedMemory"),
	HX_CSTRING("bufferCount"),
	HX_CSTRING("allocSize"),
	HX_CSTRING("initIndexes"),
	HX_CSTRING("garbage"),
	HX_CSTRING("cleanBuffers"),
	HX_CSTRING("stats"),
	HX_CSTRING("allocStats"),
	HX_CSTRING("newTexture"),
	HX_CSTRING("initTexture"),
	HX_CSTRING("deleteIndexes"),
	HX_CSTRING("deleteTexture"),
	HX_CSTRING("resizeTexture"),
	HX_CSTRING("readAtfHeader"),
	HX_CSTRING("allocCustomTexture"),
	HX_CSTRING("allocTexture"),
	HX_CSTRING("allocTargetTexture"),
	HX_CSTRING("allocCubeTexture"),
	HX_CSTRING("allocIndex"),
	HX_CSTRING("allocBytes"),
	HX_CSTRING("allocVector"),
	HX_CSTRING("freeTextures"),
	HX_CSTRING("freeMemory"),
	HX_CSTRING("alloc"),
	HX_CSTRING("onContextLost"),
	HX_CSTRING("dispose"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MemoryManager_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(MemoryManager_obj::MAX_MEMORY,"MAX_MEMORY");
	HX_MARK_MEMBER_NAME(MemoryManager_obj::MAX_BUFFERS,"MAX_BUFFERS");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MemoryManager_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(MemoryManager_obj::MAX_MEMORY,"MAX_MEMORY");
	HX_VISIT_MEMBER_NAME(MemoryManager_obj::MAX_BUFFERS,"MAX_BUFFERS");
};

#endif

Class MemoryManager_obj::__mClass;

void MemoryManager_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.impl.MemoryManager"), hx::TCanCast< MemoryManager_obj> ,sStaticFields,sMemberFields,
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

void MemoryManager_obj::__boot()
{
	MAX_MEMORY= (int)134217728;
	MAX_BUFFERS= (int)4096;
}

} // end namespace h3d
} // end namespace impl
