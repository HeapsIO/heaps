#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
#endif
#ifndef INCLUDED_h3d_anim_Animation
#include <h3d/anim/Animation.h>
#endif
#ifndef INCLUDED_h3d_anim_MorphFrameAnimation
#include <h3d/anim/MorphFrameAnimation.h>
#endif
#ifndef INCLUDED_h3d_anim_MorphObject
#include <h3d/anim/MorphObject.h>
#endif
#ifndef INCLUDED_h3d_anim_MorphShape
#include <h3d/anim/MorphShape.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_BufferOffset
#include <h3d/impl/BufferOffset.h>
#endif
#ifndef INCLUDED_h3d_prim_FBXBuffers
#include <h3d/prim/FBXBuffers.h>
#endif
#ifndef INCLUDED_h3d_prim_FBXModel
#include <h3d/prim/FBXModel.h>
#endif
#ifndef INCLUDED_h3d_prim_MeshPrimitive
#include <h3d/prim/MeshPrimitive.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_h3d_scene_Mesh
#include <h3d/scene/Mesh.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace h3d{
namespace anim{

Void MorphFrameAnimation_obj::__construct(::String name,int frame,Float sampling)
{
HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","new",0xbd8aa349,"h3d.anim.MorphFrameAnimation.new","h3d/anim/MorphFrameAnimation.hx",55,0x117abca7)
HX_STACK_THIS(this)
HX_STACK_ARG(name,"name")
HX_STACK_ARG(frame,"frame")
HX_STACK_ARG(sampling,"sampling")
{
	HX_STACK_LINE(57)
	this->shapes = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(56)
	this->syncFrame = (int)-1;
	HX_STACK_LINE(60)
	super::__construct(name,frame,sampling);
}
;
	return null();
}

//MorphFrameAnimation_obj::~MorphFrameAnimation_obj() { }

Dynamic MorphFrameAnimation_obj::__CreateEmpty() { return  new MorphFrameAnimation_obj; }
hx::ObjectPtr< MorphFrameAnimation_obj > MorphFrameAnimation_obj::__new(::String name,int frame,Float sampling)
{  hx::ObjectPtr< MorphFrameAnimation_obj > result = new MorphFrameAnimation_obj();
	result->__construct(name,frame,sampling);
	return result;}

Dynamic MorphFrameAnimation_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< MorphFrameAnimation_obj > result = new MorphFrameAnimation_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

Array< ::Dynamic > MorphFrameAnimation_obj::getObjects( ){
	HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","getObjects",0x37c23b15,"h3d.anim.MorphFrameAnimation.getObjects","h3d/anim/MorphFrameAnimation.hx",65,0x117abca7)
	HX_STACK_THIS(this)
	HX_STACK_LINE(65)
	return this->objects;
}


HX_DEFINE_DYNAMIC_FUNC0(MorphFrameAnimation_obj,getObjects,return )

::h3d::anim::MorphObject MorphFrameAnimation_obj::addObject( ::String name,int nbShape){
	HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","addObject",0xcb8d1b69,"h3d.anim.MorphFrameAnimation.addObject","h3d/anim/MorphFrameAnimation.hx",68,0x117abca7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_ARG(nbShape,"nbShape")
	HX_STACK_LINE(69)
	::h3d::anim::MorphObject fr = ::h3d::anim::MorphObject_obj::__new(name);		HX_STACK_VAR(fr,"fr");
	HX_STACK_LINE(70)
	this->objects->push(fr);
	HX_STACK_LINE(71)
	Array< ::Dynamic > _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(71)
	{
		HX_STACK_LINE(71)
		Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(71)
		{
			HX_STACK_LINE(71)
			int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(71)
			while((true)){
				HX_STACK_LINE(71)
				if ((!(((_g11 < nbShape))))){
					HX_STACK_LINE(71)
					break;
				}
				HX_STACK_LINE(71)
				int i = (_g11)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(71)
				Array< Float > _g2;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(71)
				{
					HX_STACK_LINE(71)
					Array< Float > _g21 = Array_obj< Float >::__new();		HX_STACK_VAR(_g21,"_g21");
					HX_STACK_LINE(71)
					{
						HX_STACK_LINE(71)
						int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(71)
						int _g3 = this->frameCount;		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(71)
						while((true)){
							HX_STACK_LINE(71)
							if ((!(((_g4 < _g3))))){
								HX_STACK_LINE(71)
								break;
							}
							HX_STACK_LINE(71)
							int j = (_g4)++;		HX_STACK_VAR(j,"j");
							HX_STACK_LINE(71)
							_g21->push(0.0);
						}
					}
					HX_STACK_LINE(71)
					_g2 = _g21;
				}
				HX_STACK_LINE(71)
				_g->push(_g2);
			}
		}
		HX_STACK_LINE(71)
		_g1 = _g;
	}
	HX_STACK_LINE(71)
	fr->ratio = _g1;
	HX_STACK_LINE(72)
	return fr;
}


HX_DEFINE_DYNAMIC_FUNC2(MorphFrameAnimation_obj,addObject,return )

Void MorphFrameAnimation_obj::addShape( Array< int > index,Array< Float > vertex,Array< Float > normal){
{
		HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","addShape",0xaf7109b7,"h3d.anim.MorphFrameAnimation.addShape","h3d/anim/MorphFrameAnimation.hx",75,0x117abca7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(index,"index")
		HX_STACK_ARG(vertex,"vertex")
		HX_STACK_ARG(normal,"normal")
		HX_STACK_LINE(76)
		::h3d::anim::MorphShape f = ::h3d::anim::MorphShape_obj::__new(index,vertex,normal);		HX_STACK_VAR(f,"f");
		HX_STACK_LINE(77)
		f->index = index;
		HX_STACK_LINE(77)
		f->vertex = vertex;
		HX_STACK_LINE(77)
		f->normal = normal;
		HX_STACK_LINE(78)
		this->shapes->push(f);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(MorphFrameAnimation_obj,addShape,(void))

::h3d::anim::Animation MorphFrameAnimation_obj::clone( ::h3d::anim::Animation a){
	HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","clone",0xdf233286,"h3d.anim.MorphFrameAnimation.clone","h3d/anim/MorphFrameAnimation.hx",81,0x117abca7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(82)
	if (((a == null()))){
		HX_STACK_LINE(83)
		::h3d::anim::MorphFrameAnimation m = ::h3d::anim::MorphFrameAnimation_obj::__new(this->name,this->frameCount,this->sampling);		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(84)
		m->shapes = this->shapes;
		HX_STACK_LINE(85)
		a = m;
	}
	HX_STACK_LINE(88)
	this->super::clone(a);
	HX_STACK_LINE(90)
	return a;
}


Void MorphFrameAnimation_obj::sync( hx::Null< bool >  __o_decompose){
bool decompose = __o_decompose.Default(false);
	HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","sync",0x1f217352,"h3d.anim.MorphFrameAnimation.sync","h3d/anim/MorphFrameAnimation.hx",93,0x117abca7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(decompose,"decompose")
{
		HX_STACK_LINE(95)
		if ((decompose)){
			HX_STACK_LINE(95)
			HX_STACK_DO_THROW(HX_CSTRING("Decompose not supported on Frame Animation"));
		}
		HX_STACK_LINE(97)
		int frame = ::Std_obj::_int(this->frame);		HX_STACK_VAR(frame,"frame");
		HX_STACK_LINE(98)
		if (((frame < (int)0))){
			HX_STACK_LINE(98)
			frame = (int)0;
		}
		else{
			HX_STACK_LINE(98)
			if (((frame >= this->frameCount))){
				HX_STACK_LINE(98)
				frame = (this->frameCount - (int)1);
			}
		}
		HX_STACK_LINE(99)
		if (((frame == this->syncFrame))){
			HX_STACK_LINE(100)
			return null();
		}
		HX_STACK_LINE(102)
		this->syncFrame = frame;
		HX_STACK_LINE(104)
		Float dx = 0.0;		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(105)
		Float dy = 0.0;		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(106)
		Float dz = 0.0;		HX_STACK_VAR(dz,"dz");
		HX_STACK_LINE(107)
		::h3d::Engine engine;		HX_STACK_VAR(engine,"engine");
		HX_STACK_LINE(107)
		{
			HX_STACK_LINE(107)
			if (((::hxd::System_obj::debugLevel >= (int)1))){
				HX_STACK_LINE(107)
				if (((::h3d::Engine_obj::CURRENT == null()))){
					HX_STACK_LINE(107)
					HX_STACK_DO_THROW(HX_CSTRING("no current context, please do this operation after engine init/creation"));
				}
			}
			HX_STACK_LINE(107)
			engine = ::h3d::Engine_obj::CURRENT;
		}
		HX_STACK_LINE(111)
		{
			HX_STACK_LINE(111)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(111)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(111)
			while((true)){
				HX_STACK_LINE(111)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(111)
					break;
				}
				HX_STACK_LINE(111)
				::h3d::anim::MorphObject obj = _g1->__get(_g).StaticCast< ::h3d::anim::MorphObject >();		HX_STACK_VAR(obj,"obj");
				HX_STACK_LINE(111)
				++(_g);
				HX_STACK_LINE(112)
				::h3d::prim::FBXModel prim = obj->targetFbxPrim;		HX_STACK_VAR(prim,"prim");
				HX_STACK_LINE(113)
				if (((bool((null() == prim)) || bool((null() == prim->geomCache))))){
					HX_STACK_LINE(115)
					this->syncFrame = (int)-1;
					HX_STACK_LINE(116)
					::haxe::Log_obj::trace(HX_CSTRING("cannot sync as model is not bound"),hx::SourceInfo(HX_CSTRING("MorphFrameAnimation.hx"),116,HX_CSTRING("h3d.anim.MorphFrameAnimation"),HX_CSTRING("sync")));
					HX_STACK_LINE(117)
					continue;
				}
				HX_STACK_LINE(120)
				::h3d::prim::FBXBuffers cache = prim->geomCache;		HX_STACK_VAR(cache,"cache");
				HX_STACK_LINE(123)
				Array< Float > workBuf;		HX_STACK_VAR(workBuf,"workBuf");
				HX_STACK_LINE(123)
				if (((obj->workBuf == null()))){
					HX_STACK_LINE(123)
					Array< Float > _g2;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(123)
					{
						HX_STACK_LINE(123)
						Array< Float > this1 = prim->geomCache->pbuf;		HX_STACK_VAR(this1,"this1");
						HX_STACK_LINE(123)
						Array< Float > v = Array_obj< Float >::__new();		HX_STACK_VAR(v,"v");
						HX_STACK_LINE(123)
						{
							HX_STACK_LINE(123)
							int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(123)
							int _g3 = this1->length;		HX_STACK_VAR(_g3,"_g3");
							HX_STACK_LINE(123)
							while((true)){
								HX_STACK_LINE(123)
								if ((!(((_g11 < _g3))))){
									HX_STACK_LINE(123)
									break;
								}
								HX_STACK_LINE(123)
								int i = (_g11)++;		HX_STACK_VAR(i,"i");
								HX_STACK_LINE(123)
								if (((v->length <= i))){
									HX_STACK_LINE(123)
									HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
								}
								HX_STACK_LINE(123)
								v[i] = this1->__get(i);
							}
						}
						HX_STACK_LINE(123)
						_g2 = v;
					}
					HX_STACK_LINE(123)
					workBuf = obj->workBuf = _g2;
				}
				else{
					HX_STACK_LINE(125)
					{
						HX_STACK_LINE(125)
						Array< Float > this1 = obj->workBuf;		HX_STACK_VAR(this1,"this1");
						HX_STACK_LINE(125)
						Array< Float > src = prim->geomCache->pbuf;		HX_STACK_VAR(src,"src");
						HX_STACK_LINE(125)
						{
							HX_STACK_LINE(125)
							int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(125)
							while((true)){
								HX_STACK_LINE(125)
								if ((!(((_g2 < prim->geomCache->pbuf->length))))){
									HX_STACK_LINE(125)
									break;
								}
								HX_STACK_LINE(125)
								int i = (_g2)++;		HX_STACK_VAR(i,"i");
								HX_STACK_LINE(125)
								if (((this1->length <= i))){
									HX_STACK_LINE(125)
									HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
								}
								HX_STACK_LINE(125)
								this1[i] = src->__get(i);
							}
						}
					}
					HX_STACK_LINE(126)
					workBuf = obj->workBuf;
				}
				HX_STACK_LINE(130)
				{
					HX_STACK_LINE(130)
					int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(130)
					int _g2 = this->shapes->length;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(130)
					while((true)){
						HX_STACK_LINE(130)
						if ((!(((_g3 < _g2))))){
							HX_STACK_LINE(130)
							break;
						}
						HX_STACK_LINE(130)
						int si = (_g3)++;		HX_STACK_VAR(si,"si");
						HX_STACK_LINE(131)
						::h3d::anim::MorphShape shape = this->shapes->__get(si).StaticCast< ::h3d::anim::MorphShape >();		HX_STACK_VAR(shape,"shape");
						HX_STACK_LINE(132)
						int i = (int)0;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(133)
						Float r = obj->ratio->__get(si).StaticCast< Array< Float > >()->__get(frame);		HX_STACK_VAR(r,"r");
						HX_STACK_LINE(134)
						Array< int > l = null();		HX_STACK_VAR(l,"l");
						HX_STACK_LINE(135)
						{
							HX_STACK_LINE(135)
							int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
							HX_STACK_LINE(135)
							Array< int > _g5 = shape->index;		HX_STACK_VAR(_g5,"_g5");
							HX_STACK_LINE(135)
							while((true)){
								HX_STACK_LINE(135)
								if ((!(((_g4 < _g5->length))))){
									HX_STACK_LINE(135)
									break;
								}
								HX_STACK_LINE(135)
								Dynamic idx = _g5->__unsafe_get(_g4);		HX_STACK_VAR(idx,"idx");
								HX_STACK_LINE(135)
								++(_g4);
								HX_STACK_LINE(136)
								Array< int > _g11 = cache->oldToNew->get(idx);		HX_STACK_VAR(_g11,"_g11");
								HX_STACK_LINE(136)
								l = _g11;
								HX_STACK_LINE(137)
								if (((l != null()))){
									HX_STACK_LINE(138)
									int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
									HX_STACK_LINE(138)
									while((true)){
										HX_STACK_LINE(138)
										if ((!(((_g6 < l->length))))){
											HX_STACK_LINE(138)
											break;
										}
										HX_STACK_LINE(138)
										int vidx = l->__get(_g6);		HX_STACK_VAR(vidx,"vidx");
										HX_STACK_LINE(138)
										++(_g6);
										HX_STACK_LINE(139)
										int vidx3 = (vidx * (int)3);		HX_STACK_VAR(vidx3,"vidx3");
										HX_STACK_LINE(140)
										{
											HX_STACK_LINE(140)
											int _g7 = vidx3;		HX_STACK_VAR(_g7,"_g7");
											HX_STACK_LINE(140)
											{
												HX_STACK_LINE(140)
												Float _g21 = shape->vertex->__unsafe_get((i * (int)3));		HX_STACK_VAR(_g21,"_g21");
												HX_STACK_LINE(140)
												Float _g31 = (r * _g21);		HX_STACK_VAR(_g31,"_g31");
												HX_STACK_LINE(140)
												Float value = (workBuf->__get(_g7) + _g31);		HX_STACK_VAR(value,"value");
												HX_STACK_LINE(140)
												if (((workBuf->length <= _g7))){
													HX_STACK_LINE(140)
													HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + _g7));
												}
												HX_STACK_LINE(140)
												workBuf[_g7] = value;
											}
										}
										HX_STACK_LINE(141)
										{
											HX_STACK_LINE(141)
											int _g7 = (vidx3 + (int)1);		HX_STACK_VAR(_g7,"_g7");
											HX_STACK_LINE(141)
											{
												HX_STACK_LINE(141)
												Float _g41 = shape->vertex->__unsafe_get(((i * (int)3) + (int)1));		HX_STACK_VAR(_g41,"_g41");
												HX_STACK_LINE(141)
												Float _g51 = (r * _g41);		HX_STACK_VAR(_g51,"_g51");
												HX_STACK_LINE(141)
												Float value = (workBuf->__get(_g7) + _g51);		HX_STACK_VAR(value,"value");
												HX_STACK_LINE(141)
												if (((workBuf->length <= _g7))){
													HX_STACK_LINE(141)
													HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + _g7));
												}
												HX_STACK_LINE(141)
												workBuf[_g7] = value;
											}
										}
										HX_STACK_LINE(142)
										{
											HX_STACK_LINE(142)
											int _g7 = (vidx3 + (int)2);		HX_STACK_VAR(_g7,"_g7");
											HX_STACK_LINE(142)
											{
												HX_STACK_LINE(142)
												Float _g61 = shape->vertex->__unsafe_get(((i * (int)3) + (int)2));		HX_STACK_VAR(_g61,"_g61");
												HX_STACK_LINE(142)
												Float _g71 = (r * _g61);		HX_STACK_VAR(_g71,"_g71");
												HX_STACK_LINE(142)
												Float value = (workBuf->__get(_g7) + _g71);		HX_STACK_VAR(value,"value");
												HX_STACK_LINE(142)
												if (((workBuf->length <= _g7))){
													HX_STACK_LINE(142)
													HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + _g7));
												}
												HX_STACK_LINE(142)
												workBuf[_g7] = value;
											}
										}
									}
								}
								HX_STACK_LINE(144)
								(i)++;
							}
						}
					}
				}
				HX_STACK_LINE(147)
				::h3d::impl::BufferOffset b = prim->bufferCache->get(HX_CSTRING("pos"));		HX_STACK_VAR(b,"b");
				HX_STACK_LINE(148)
				int _g8 = ::Math_obj::round((Float(workBuf->length) / Float((int)3)));		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(148)
				b->b->uploadVector(workBuf,(int)0,_g8);
				HX_STACK_LINE(150)
				::h3d::impl::BufferOffset b1 = prim->bufferCache->get(HX_CSTRING("normal"));		HX_STACK_VAR(b1,"b1");
				HX_STACK_LINE(151)
				if (((b1 != null()))){
					HX_STACK_LINE(152)
					{
						HX_STACK_LINE(152)
						Array< Float > src = prim->geomCache->nbuf;		HX_STACK_VAR(src,"src");
						HX_STACK_LINE(152)
						int count = ::Math_obj::round((Float(prim->geomCache->nbuf->length) / Float((int)3)));		HX_STACK_VAR(count,"count");
						HX_STACK_LINE(152)
						{
							HX_STACK_LINE(152)
							int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(152)
							while((true)){
								HX_STACK_LINE(152)
								if ((!(((_g2 < count))))){
									HX_STACK_LINE(152)
									break;
								}
								HX_STACK_LINE(152)
								int i = (_g2)++;		HX_STACK_VAR(i,"i");
								HX_STACK_LINE(152)
								if (((workBuf->length <= i))){
									HX_STACK_LINE(152)
									HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
								}
								HX_STACK_LINE(152)
								workBuf[i] = src->__get(i);
							}
						}
					}
					HX_STACK_LINE(156)
					{
						HX_STACK_LINE(156)
						int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(156)
						int _g2 = this->shapes->length;		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(156)
						while((true)){
							HX_STACK_LINE(156)
							if ((!(((_g3 < _g2))))){
								HX_STACK_LINE(156)
								break;
							}
							HX_STACK_LINE(156)
							int si = (_g3)++;		HX_STACK_VAR(si,"si");
							HX_STACK_LINE(157)
							::h3d::anim::MorphShape shape = this->shapes->__get(si).StaticCast< ::h3d::anim::MorphShape >();		HX_STACK_VAR(shape,"shape");
							HX_STACK_LINE(158)
							int i = (int)0;		HX_STACK_VAR(i,"i");
							HX_STACK_LINE(159)
							Float r = obj->ratio->__get(si).StaticCast< Array< Float > >()->__get(frame);		HX_STACK_VAR(r,"r");
							HX_STACK_LINE(160)
							Array< int > l = null();		HX_STACK_VAR(l,"l");
							HX_STACK_LINE(161)
							{
								HX_STACK_LINE(161)
								int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
								HX_STACK_LINE(161)
								Array< int > _g5 = shape->index;		HX_STACK_VAR(_g5,"_g5");
								HX_STACK_LINE(161)
								while((true)){
									HX_STACK_LINE(161)
									if ((!(((_g4 < _g5->length))))){
										HX_STACK_LINE(161)
										break;
									}
									HX_STACK_LINE(161)
									Dynamic idx = _g5->__unsafe_get(_g4);		HX_STACK_VAR(idx,"idx");
									HX_STACK_LINE(161)
									++(_g4);
									HX_STACK_LINE(164)
									Array< int > _g9 = cache->oldToNew->get(idx);		HX_STACK_VAR(_g9,"_g9");
									HX_STACK_LINE(164)
									l = _g9;
									HX_STACK_LINE(165)
									if (((l != null()))){
										HX_STACK_LINE(166)
										int _g6 = (int)0;		HX_STACK_VAR(_g6,"_g6");
										HX_STACK_LINE(166)
										while((true)){
											HX_STACK_LINE(166)
											if ((!(((_g6 < l->length))))){
												HX_STACK_LINE(166)
												break;
											}
											HX_STACK_LINE(166)
											int vidx = l->__get(_g6);		HX_STACK_VAR(vidx,"vidx");
											HX_STACK_LINE(166)
											++(_g6);
											HX_STACK_LINE(167)
											int vidx3 = (vidx * (int)3);		HX_STACK_VAR(vidx3,"vidx3");
											HX_STACK_LINE(169)
											Float nx;		HX_STACK_VAR(nx,"nx");
											HX_STACK_LINE(169)
											{
												HX_STACK_LINE(169)
												int _g7 = vidx3;		HX_STACK_VAR(_g7,"_g7");
												HX_STACK_LINE(169)
												{
													HX_STACK_LINE(169)
													Float _g10 = shape->normal->__unsafe_get((i * (int)3));		HX_STACK_VAR(_g10,"_g10");
													HX_STACK_LINE(169)
													Float _g11 = (r * _g10);		HX_STACK_VAR(_g11,"_g11");
													HX_STACK_LINE(169)
													Float value = (workBuf->__get(_g7) + _g11);		HX_STACK_VAR(value,"value");
													HX_STACK_LINE(169)
													if (((workBuf->length <= _g7))){
														HX_STACK_LINE(169)
														HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + _g7));
													}
													HX_STACK_LINE(169)
													nx = workBuf[_g7] = value;
												}
											}
											HX_STACK_LINE(170)
											Float ny;		HX_STACK_VAR(ny,"ny");
											HX_STACK_LINE(170)
											{
												HX_STACK_LINE(170)
												int _g7 = (vidx3 + (int)1);		HX_STACK_VAR(_g7,"_g7");
												HX_STACK_LINE(170)
												{
													HX_STACK_LINE(170)
													Float _g12 = shape->normal->__unsafe_get(((i * (int)3) + (int)1));		HX_STACK_VAR(_g12,"_g12");
													HX_STACK_LINE(170)
													Float _g13 = (r * _g12);		HX_STACK_VAR(_g13,"_g13");
													HX_STACK_LINE(170)
													Float value = (workBuf->__get(_g7) + _g13);		HX_STACK_VAR(value,"value");
													HX_STACK_LINE(170)
													if (((workBuf->length <= _g7))){
														HX_STACK_LINE(170)
														HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + _g7));
													}
													HX_STACK_LINE(170)
													ny = workBuf[_g7] = value;
												}
											}
											HX_STACK_LINE(171)
											Float nz;		HX_STACK_VAR(nz,"nz");
											HX_STACK_LINE(171)
											{
												HX_STACK_LINE(171)
												int _g7 = (vidx3 + (int)2);		HX_STACK_VAR(_g7,"_g7");
												HX_STACK_LINE(171)
												{
													HX_STACK_LINE(171)
													Float _g14 = shape->normal->__unsafe_get(((i * (int)3) + (int)2));		HX_STACK_VAR(_g14,"_g14");
													HX_STACK_LINE(171)
													Float _g15 = (r * _g14);		HX_STACK_VAR(_g15,"_g15");
													HX_STACK_LINE(171)
													Float value = (workBuf->__get(_g7) + _g15);		HX_STACK_VAR(value,"value");
													HX_STACK_LINE(171)
													if (((workBuf->length <= _g7))){
														HX_STACK_LINE(171)
														HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + _g7));
													}
													HX_STACK_LINE(171)
													nz = workBuf[_g7] = value;
												}
											}
											HX_STACK_LINE(173)
											Float _g16 = ::Math_obj::sqrt((((nx * nx) + (ny * ny)) + (nz * nz)));		HX_STACK_VAR(_g16,"_g16");
											HX_STACK_LINE(173)
											Float l1 = (Float(1.0) / Float(_g16));		HX_STACK_VAR(l1,"l1");
											HX_STACK_LINE(175)
											{
												HX_STACK_LINE(175)
												if (((workBuf->length <= vidx3))){
													HX_STACK_LINE(175)
													HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + vidx3));
												}
												HX_STACK_LINE(175)
												workBuf[vidx3] = (nx * l1);
											}
											HX_STACK_LINE(176)
											{
												HX_STACK_LINE(176)
												int key = (vidx3 + (int)1);		HX_STACK_VAR(key,"key");
												HX_STACK_LINE(176)
												if (((workBuf->length <= key))){
													HX_STACK_LINE(176)
													HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
												}
												HX_STACK_LINE(176)
												workBuf[key] = (ny * l1);
											}
											HX_STACK_LINE(177)
											{
												HX_STACK_LINE(177)
												int key = (vidx3 + (int)2);		HX_STACK_VAR(key,"key");
												HX_STACK_LINE(177)
												if (((workBuf->length <= key))){
													HX_STACK_LINE(177)
													HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + key));
												}
												HX_STACK_LINE(177)
												workBuf[key] = (nz * l1);
											}
										}
									}
									HX_STACK_LINE(179)
									(i)++;
								}
							}
						}
					}
					HX_STACK_LINE(182)
					::h3d::impl::BufferOffset b2 = prim->bufferCache->get(HX_CSTRING("normal"));		HX_STACK_VAR(b2,"b2");
					HX_STACK_LINE(183)
					int _g17 = ::Math_obj::round((Float(workBuf->length) / Float((int)3)));		HX_STACK_VAR(_g17,"_g17");
					HX_STACK_LINE(183)
					b2->b->uploadVector(workBuf,(int)0,_g17);
				}
			}
		}
	}
return null();
}


Array< Float > MorphFrameAnimation_obj::norm3( Array< Float > fb){
	HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","norm3",0x36897da0,"h3d.anim.MorphFrameAnimation.norm3","h3d/anim/MorphFrameAnimation.hx",189,0x117abca7)
	HX_STACK_THIS(this)
	HX_STACK_ARG(fb,"fb")
	HX_STACK_LINE(190)
	Float nx = 0.0;		HX_STACK_VAR(nx,"nx");
	HX_STACK_LINE(190)
	Float ny = 0.0;		HX_STACK_VAR(ny,"ny");
	HX_STACK_LINE(190)
	Float nz = 0.0;		HX_STACK_VAR(nz,"nz");
	HX_STACK_LINE(190)
	Float l = 0.0;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(191)
	int len = ::Math_obj::round((Float(fb->length) / Float((int)3)));		HX_STACK_VAR(len,"len");
	HX_STACK_LINE(192)
	{
		HX_STACK_LINE(192)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(192)
		while((true)){
			HX_STACK_LINE(192)
			if ((!(((_g < len))))){
				HX_STACK_LINE(192)
				break;
			}
			HX_STACK_LINE(192)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(193)
			nx = fb->__get((i * (int)3));
			HX_STACK_LINE(194)
			ny = fb->__get(((i * (int)3) + (int)1));
			HX_STACK_LINE(195)
			nz = fb->__get(((i * (int)3) + (int)2));
			HX_STACK_LINE(197)
			Float _g1 = ::Math_obj::sqrt((((nx * nx) + (ny * ny)) + (nz * nz)));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(197)
			Float _g11 = (Float(1.0) / Float(_g1));		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(197)
			l = _g11;
			HX_STACK_LINE(199)
			hx::MultEq(nx,l);
			HX_STACK_LINE(200)
			hx::MultEq(ny,l);
			HX_STACK_LINE(201)
			hx::MultEq(nz,l);
			HX_STACK_LINE(203)
			fb[(i * (int)3)] = nx;
			HX_STACK_LINE(204)
			fb[((i * (int)3) + (int)1)] = ny;
			HX_STACK_LINE(205)
			fb[((i * (int)3) + (int)2)] = nz;
		}
	}
	HX_STACK_LINE(207)
	return fb;
}


HX_DEFINE_DYNAMIC_FUNC1(MorphFrameAnimation_obj,norm3,return )

Void MorphFrameAnimation_obj::writeTarget( int fr){
{
		HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","writeTarget",0x04f7a979,"h3d.anim.MorphFrameAnimation.writeTarget","h3d/anim/MorphFrameAnimation.hx",215,0x117abca7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(fr,"fr")
		HX_STACK_LINE(215)
		Array< int > fr1 = Array_obj< int >::__new().Add(fr);		HX_STACK_VAR(fr1,"fr1");
		HX_STACK_LINE(215)
		Array< ::Dynamic > _g2 = Array_obj< ::Dynamic >::__new().Add(hx::ObjectPtr<OBJ_>(this));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(216)
		if (((fr1->__get((int)0) >= this->objects->__get((int)0).StaticCast< ::h3d::anim::MorphObject >()->ratio->__get((int)0).StaticCast< Array< Float > >()->length))){
			HX_STACK_LINE(216)
			HX_STACK_DO_THROW(HX_CSTRING("invalid frame"));
		}
		HX_STACK_LINE(218)
		{
			HX_STACK_LINE(218)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(218)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(218)
			while((true)){
				HX_STACK_LINE(218)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(218)
					break;
				}
				HX_STACK_LINE(218)
				Array< ::Dynamic > obj = Array_obj< ::Dynamic >::__new().Add(_g1->__get(_g).StaticCast< ::h3d::anim::MorphObject >());		HX_STACK_VAR(obj,"obj");
				HX_STACK_LINE(218)
				++(_g);
				HX_STACK_LINE(220)
				::h3d::scene::Object targetObject = obj->__get((int)0).StaticCast< ::h3d::anim::MorphObject >()->targetObject;		HX_STACK_VAR(targetObject,"targetObject");
				HX_STACK_LINE(221)
				if (((targetObject == null()))){
					HX_STACK_LINE(221)
					HX_STACK_DO_THROW(HX_CSTRING("scene object is not bound !"));
				}
				HX_STACK_LINE(223)
				if ((::Std_obj::is(targetObject,hx::ClassOf< ::h3d::scene::Mesh >()))){
					HX_STACK_LINE(224)
					::h3d::scene::Mesh t = targetObject;		HX_STACK_VAR(t,"t");
					HX_STACK_LINE(225)
					::h3d::prim::Primitive prim = t->primitive;		HX_STACK_VAR(prim,"prim");
					HX_STACK_LINE(226)
					if ((::Std_obj::is(prim,hx::ClassOf< ::h3d::prim::FBXModel >()))){
						HX_STACK_LINE(227)
						::h3d::prim::FBXModel fbxPrim = prim;		HX_STACK_VAR(fbxPrim,"fbxPrim");
						HX_STACK_LINE(229)
						Dynamic onnb = Dynamic( Array_obj<Dynamic>::__new().Add(fbxPrim->onNormalBuffer_dyn()));		HX_STACK_VAR(onnb,"onnb");
						HX_STACK_LINE(230)
						Dynamic onvb = Dynamic( Array_obj<Dynamic>::__new().Add(fbxPrim->onVertexBuffer_dyn()));		HX_STACK_VAR(onvb,"onvb");

						HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_5_1,Array< int >,fr1,Dynamic,onnb,Array< ::Dynamic >,obj,Array< ::Dynamic >,_g2)
						Array< Float > run(Array< Float > nbuf){
							HX_STACK_FRAME("*","_Function_5_1",0x5203f63b,"*._Function_5_1","h3d/anim/MorphFrameAnimation.hx",232,0x117abca7)
							HX_STACK_ARG(nbuf,"nbuf")
							{
								HX_STACK_LINE(233)
								Array< Float > originalN = nbuf;		HX_STACK_VAR(originalN,"originalN");
								HX_STACK_LINE(234)
								Array< Float > computedN = onnb->__GetItem((int)0)(nbuf).Cast< Array< Float > >();		HX_STACK_VAR(computedN,"computedN");
								HX_STACK_LINE(235)
								int vlen = ::Std_obj::_int((Float(originalN->length) / Float((int)3)));		HX_STACK_VAR(vlen,"vlen");
								HX_STACK_LINE(236)
								Float nx = 0.0;		HX_STACK_VAR(nx,"nx");
								HX_STACK_LINE(237)
								Float ny = 0.0;		HX_STACK_VAR(ny,"ny");
								HX_STACK_LINE(238)
								Float nz = 0.0;		HX_STACK_VAR(nz,"nz");
								HX_STACK_LINE(239)
								Float l = 0.0;		HX_STACK_VAR(l,"l");
								HX_STACK_LINE(241)
								Array< Float > resN = Array_obj< Float >::__new();		HX_STACK_VAR(resN,"resN");
								HX_STACK_LINE(242)
								{
									HX_STACK_LINE(242)
									int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
									HX_STACK_LINE(242)
									int _g21 = resN->length;		HX_STACK_VAR(_g21,"_g21");
									HX_STACK_LINE(242)
									while(((_g3 < _g21))){
										HX_STACK_LINE(242)
										int i = (_g3)++;		HX_STACK_VAR(i,"i");
										HX_STACK_LINE(242)
										resN[i] = 0.0;
									}
								}
								HX_STACK_LINE(244)
								{
									HX_STACK_LINE(244)
									int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
									HX_STACK_LINE(244)
									int _g3 = _g2->__get((int)0).StaticCast< ::h3d::anim::MorphFrameAnimation >()->shapes->length;		HX_STACK_VAR(_g3,"_g3");
									HX_STACK_LINE(244)
									while(((_g4 < _g3))){
										HX_STACK_LINE(244)
										int si = (_g4)++;		HX_STACK_VAR(si,"si");
										HX_STACK_LINE(245)
										::h3d::anim::MorphShape shape = _g2->__get((int)0).StaticCast< ::h3d::anim::MorphFrameAnimation >()->shapes->__get(si).StaticCast< ::h3d::anim::MorphShape >();		HX_STACK_VAR(shape,"shape");
										HX_STACK_LINE(247)
										int i = (int)0;		HX_STACK_VAR(i,"i");
										HX_STACK_LINE(248)
										Float r = obj->__get((int)0).StaticCast< ::h3d::anim::MorphObject >()->ratio->__get(si).StaticCast< Array< Float > >()->__get(fr1->__get((int)0));		HX_STACK_VAR(r,"r");
										HX_STACK_LINE(249)
										{
											HX_STACK_LINE(249)
											int _g5 = (int)0;		HX_STACK_VAR(_g5,"_g5");
											HX_STACK_LINE(249)
											Array< int > _g6 = shape->index;		HX_STACK_VAR(_g6,"_g6");
											HX_STACK_LINE(249)
											while(((_g5 < _g6->length))){
												HX_STACK_LINE(249)
												Dynamic idx = _g6->__unsafe_get(_g5);		HX_STACK_VAR(idx,"idx");
												HX_STACK_LINE(249)
												++(_g5);
												HX_STACK_LINE(250)
												hx::AddEq(resN[(idx * (int)3)],(r * shape->normal->__unsafe_get((i * (int)3))));
												HX_STACK_LINE(251)
												hx::AddEq(resN[((idx * (int)3) + (int)1)],(r * shape->normal->__unsafe_get(((i * (int)3) + (int)1))));
												HX_STACK_LINE(252)
												hx::AddEq(resN[((idx * (int)3) + (int)2)],(r * shape->normal->__unsafe_get(((i * (int)3) + (int)2))));
												HX_STACK_LINE(253)
												(i)++;
											}
										}
									}
								}
								HX_STACK_LINE(257)
								Float nx1 = 0.0;		HX_STACK_VAR(nx1,"nx1");
								HX_STACK_LINE(257)
								Float ny1 = 0.0;		HX_STACK_VAR(ny1,"ny1");
								HX_STACK_LINE(257)
								Float nz1 = 0.0;		HX_STACK_VAR(nz1,"nz1");
								HX_STACK_LINE(257)
								Float l1 = 0.0;		HX_STACK_VAR(l1,"l1");
								HX_STACK_LINE(257)
								int len = ::Math_obj::round((Float(resN->length) / Float((int)3)));		HX_STACK_VAR(len,"len");
								HX_STACK_LINE(257)
								{
									HX_STACK_LINE(257)
									int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
									HX_STACK_LINE(257)
									while(((_g3 < len))){
										HX_STACK_LINE(257)
										int i = (_g3)++;		HX_STACK_VAR(i,"i");
										HX_STACK_LINE(257)
										nx1 = resN->__get((i * (int)3));
										HX_STACK_LINE(257)
										ny1 = resN->__get(((i * (int)3) + (int)1));
										HX_STACK_LINE(257)
										nz1 = resN->__get(((i * (int)3) + (int)2));
										HX_STACK_LINE(257)
										l1 = (Float(1.0) / Float(::Math_obj::sqrt((((nx1 * nx1) + (ny1 * ny1)) + (nz1 * nz1)))));
										HX_STACK_LINE(257)
										hx::MultEq(nx1,l1);
										HX_STACK_LINE(257)
										hx::MultEq(ny1,l1);
										HX_STACK_LINE(257)
										hx::MultEq(nz1,l1);
										HX_STACK_LINE(257)
										resN[(i * (int)3)] = nx1;
										HX_STACK_LINE(257)
										resN[((i * (int)3) + (int)1)] = ny1;
										HX_STACK_LINE(257)
										resN[((i * (int)3) + (int)2)] = nz1;
									}
								}
								HX_STACK_LINE(257)
								return resN;
							}
							return null();
						}
						HX_END_LOCAL_FUNC1(return)

						HX_STACK_LINE(232)
						fbxPrim->onNormalBuffer =  Dynamic(new _Function_5_1(fr1,onnb,obj,_g2));

						HX_BEGIN_LOCAL_FUNC_S4(hx::LocalFunc,_Function_5_2,Array< int >,fr1,Dynamic,onvb,Array< ::Dynamic >,obj,Array< ::Dynamic >,_g2)
						Array< Float > run(Array< Float > vbuf){
							HX_STACK_FRAME("*","_Function_5_2",0x5203f63c,"*._Function_5_2","h3d/anim/MorphFrameAnimation.hx",260,0x117abca7)
							HX_STACK_ARG(vbuf,"vbuf")
							{
								HX_STACK_LINE(261)
								Array< Float > originalV = vbuf;		HX_STACK_VAR(originalV,"originalV");
								HX_STACK_LINE(262)
								Array< Float > computedV = onvb->__GetItem((int)0)(vbuf).Cast< Array< Float > >();		HX_STACK_VAR(computedV,"computedV");
								HX_STACK_LINE(263)
								Array< Float > resV = Array_obj< Float >::__new();		HX_STACK_VAR(resV,"resV");
								HX_STACK_LINE(265)
								{
									HX_STACK_LINE(265)
									int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
									HX_STACK_LINE(265)
									int _g21 = computedV->length;		HX_STACK_VAR(_g21,"_g21");
									HX_STACK_LINE(265)
									while(((_g3 < _g21))){
										HX_STACK_LINE(265)
										int c = (_g3)++;		HX_STACK_VAR(c,"c");
										HX_STACK_LINE(265)
										resV[c] = computedV->__get(c);
									}
								}
								HX_STACK_LINE(266)
								{
									HX_STACK_LINE(266)
									int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
									HX_STACK_LINE(266)
									int _g3 = _g2->__get((int)0).StaticCast< ::h3d::anim::MorphFrameAnimation >()->shapes->length;		HX_STACK_VAR(_g3,"_g3");
									HX_STACK_LINE(266)
									while(((_g4 < _g3))){
										HX_STACK_LINE(266)
										int si = (_g4)++;		HX_STACK_VAR(si,"si");
										HX_STACK_LINE(268)
										::h3d::anim::MorphShape shape = _g2->__get((int)0).StaticCast< ::h3d::anim::MorphFrameAnimation >()->shapes->__get(si).StaticCast< ::h3d::anim::MorphShape >();		HX_STACK_VAR(shape,"shape");
										HX_STACK_LINE(269)
										int i = (int)0;		HX_STACK_VAR(i,"i");
										HX_STACK_LINE(271)
										Float r = obj->__get((int)0).StaticCast< ::h3d::anim::MorphObject >()->ratio->__get(si).StaticCast< Array< Float > >()->__get(fr1->__get((int)0));		HX_STACK_VAR(r,"r");
										HX_STACK_LINE(272)
										{
											HX_STACK_LINE(272)
											int _g5 = (int)0;		HX_STACK_VAR(_g5,"_g5");
											HX_STACK_LINE(272)
											Array< int > _g6 = shape->index;		HX_STACK_VAR(_g6,"_g6");
											HX_STACK_LINE(272)
											while(((_g5 < _g6->length))){
												HX_STACK_LINE(272)
												Dynamic idx = _g6->__unsafe_get(_g5);		HX_STACK_VAR(idx,"idx");
												HX_STACK_LINE(272)
												++(_g5);
												HX_STACK_LINE(274)
												hx::AddEq(resV[(idx * (int)3)],(r * shape->vertex->__unsafe_get((i * (int)3))));
												HX_STACK_LINE(275)
												hx::AddEq(resV[((idx * (int)3) + (int)1)],(r * shape->vertex->__unsafe_get(((i * (int)3) + (int)1))));
												HX_STACK_LINE(276)
												hx::AddEq(resV[((idx * (int)3) + (int)2)],(r * shape->vertex->__unsafe_get(((i * (int)3) + (int)2))));
												HX_STACK_LINE(278)
												(i)++;
											}
										}
									}
								}
								HX_STACK_LINE(282)
								return resV;
							}
							return null();
						}
						HX_END_LOCAL_FUNC1(return)

						HX_STACK_LINE(260)
						fbxPrim->onVertexBuffer =  Dynamic(new _Function_5_2(fr1,onvb,obj,_g2));
					}
				}
				else{
					HX_STACK_LINE(286)
					HX_STACK_DO_THROW(HX_CSTRING("unsupported"));
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(MorphFrameAnimation_obj,writeTarget,(void))

Void MorphFrameAnimation_obj::manualBind( ::h3d::scene::Object base){
{
		HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","manualBind",0xec10375a,"h3d.anim.MorphFrameAnimation.manualBind","h3d/anim/MorphFrameAnimation.hx",295,0x117abca7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(base,"base")
		HX_STACK_LINE(295)
		this->super::bind(base);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(MorphFrameAnimation_obj,manualBind,(void))

Void MorphFrameAnimation_obj::bind( ::h3d::scene::Object base){
{
		HX_STACK_FRAME("h3d.anim.MorphFrameAnimation","bind",0x13d8aeb4,"h3d.anim.MorphFrameAnimation.bind","h3d/anim/MorphFrameAnimation.hx",298,0x117abca7)
		HX_STACK_THIS(this)
		HX_STACK_ARG(base,"base")
		HX_STACK_LINE(299)
		this->super::bind(base);
		HX_STACK_LINE(301)
		{
			HX_STACK_LINE(301)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(301)
			Array< ::Dynamic > _g1 = this->objects;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(301)
			while((true)){
				HX_STACK_LINE(301)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(301)
					break;
				}
				HX_STACK_LINE(301)
				::h3d::anim::MorphObject obj = _g1->__get(_g).StaticCast< ::h3d::anim::MorphObject >();		HX_STACK_VAR(obj,"obj");
				HX_STACK_LINE(301)
				++(_g);
				HX_STACK_LINE(302)
				if ((::Std_obj::is(obj->targetObject,hx::ClassOf< ::h3d::scene::Mesh >()))){
					HX_STACK_LINE(303)
					::h3d::scene::Mesh t = obj->targetObject;		HX_STACK_VAR(t,"t");
					HX_STACK_LINE(304)
					::h3d::prim::Primitive prim = t->primitive;		HX_STACK_VAR(prim,"prim");
					HX_STACK_LINE(305)
					if ((::Std_obj::is(prim,hx::ClassOf< ::h3d::prim::FBXModel >()))){
						HX_STACK_LINE(306)
						::h3d::prim::FBXModel fbxPrim = prim;		HX_STACK_VAR(fbxPrim,"fbxPrim");
						HX_STACK_LINE(307)
						if ((!(fbxPrim->isDynamic))){
							HX_STACK_LINE(308)
							fbxPrim->dispose();
							HX_STACK_LINE(309)
							fbxPrim->isDynamic = true;
							HX_STACK_LINE(310)
							obj->targetFbxPrim = fbxPrim;
						}
					}
				}
			}
		}
	}
return null();
}



MorphFrameAnimation_obj::MorphFrameAnimation_obj()
{
}

void MorphFrameAnimation_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(MorphFrameAnimation);
	HX_MARK_MEMBER_NAME(syncFrame,"syncFrame");
	HX_MARK_MEMBER_NAME(shapes,"shapes");
	::h3d::anim::Animation_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void MorphFrameAnimation_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(syncFrame,"syncFrame");
	HX_VISIT_MEMBER_NAME(shapes,"shapes");
	::h3d::anim::Animation_obj::__Visit(HX_VISIT_ARG);
}

Dynamic MorphFrameAnimation_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		if (HX_FIELD_EQ(inName,"bind") ) { return bind_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"norm3") ) { return norm3_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"shapes") ) { return shapes; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"addShape") ) { return addShape_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"syncFrame") ) { return syncFrame; }
		if (HX_FIELD_EQ(inName,"addObject") ) { return addObject_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"getObjects") ) { return getObjects_dyn(); }
		if (HX_FIELD_EQ(inName,"manualBind") ) { return manualBind_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"writeTarget") ) { return writeTarget_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic MorphFrameAnimation_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"shapes") ) { shapes=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"syncFrame") ) { syncFrame=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void MorphFrameAnimation_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("syncFrame"));
	outFields->push(HX_CSTRING("shapes"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(MorphFrameAnimation_obj,syncFrame),HX_CSTRING("syncFrame")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(MorphFrameAnimation_obj,shapes),HX_CSTRING("shapes")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("syncFrame"),
	HX_CSTRING("shapes"),
	HX_CSTRING("getObjects"),
	HX_CSTRING("addObject"),
	HX_CSTRING("addShape"),
	HX_CSTRING("clone"),
	HX_CSTRING("sync"),
	HX_CSTRING("norm3"),
	HX_CSTRING("writeTarget"),
	HX_CSTRING("manualBind"),
	HX_CSTRING("bind"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(MorphFrameAnimation_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(MorphFrameAnimation_obj::__mClass,"__mClass");
};

#endif

Class MorphFrameAnimation_obj::__mClass;

void MorphFrameAnimation_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.MorphFrameAnimation"), hx::TCanCast< MorphFrameAnimation_obj> ,sStaticFields,sMemberFields,
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

void MorphFrameAnimation_obj::__boot()
{
}

} // end namespace h3d
} // end namespace anim
