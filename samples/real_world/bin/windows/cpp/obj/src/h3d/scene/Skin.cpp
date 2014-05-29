#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_h3d_Engine
#include <h3d/Engine.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Vector
#include <h3d/Vector.h>
#endif
#ifndef INCLUDED_h3d_anim_Joint
#include <h3d/anim/Joint.h>
#endif
#ifndef INCLUDED_h3d_anim_Skin
#include <h3d/anim/Skin.h>
#endif
#ifndef INCLUDED_h3d_col_Bounds
#include <h3d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_impl_Shader
#include <h3d/impl/Shader.h>
#endif
#ifndef INCLUDED_h3d_mat_Material
#include <h3d/mat/Material.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshMaterial
#include <h3d/mat/MeshMaterial.h>
#endif
#ifndef INCLUDED_h3d_mat_MeshShader
#include <h3d/mat/MeshShader.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_h3d_scene_Joint
#include <h3d/scene/Joint.h>
#endif
#ifndef INCLUDED_h3d_scene_Mesh
#include <h3d/scene/Mesh.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_h3d_scene_RenderContext
#include <h3d/scene/RenderContext.h>
#endif
#ifndef INCLUDED_h3d_scene_Skin
#include <h3d/scene/Skin.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_Timer
#include <haxe/Timer.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_hxd_Profiler
#include <hxd/Profiler.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace h3d{
namespace scene{

Void Skin_obj::__construct(::h3d::anim::Skin s,::h3d::mat::MeshMaterial mat,::h3d::scene::Object parent)
{
HX_STACK_FRAME("h3d.scene.Skin","new",0x02761706,"h3d.scene.Skin.new","h3d/scene/Skin.hx",50,0xc713f0a8)
HX_STACK_THIS(this)
HX_STACK_ARG(s,"s")
HX_STACK_ARG(mat,"mat")
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(68)
	this->syncIfHidden = true;
	HX_STACK_LINE(71)
	if (((::hxd::System_obj::debugLevel >= (int)2))){
		HX_STACK_LINE(71)
		::haxe::Log_obj::trace(HX_CSTRING("Skin.new();"),hx::SourceInfo(HX_CSTRING("Skin.hx"),71,HX_CSTRING("h3d.scene.Skin"),HX_CSTRING("new")));
	}
	HX_STACK_LINE(73)
	super::__construct(null(),mat,parent);
	HX_STACK_LINE(74)
	if (((s != null()))){
		HX_STACK_LINE(75)
		this->setSkinData(s);
	}
}
;
	return null();
}

//Skin_obj::~Skin_obj() { }

Dynamic Skin_obj::__CreateEmpty() { return  new Skin_obj; }
hx::ObjectPtr< Skin_obj > Skin_obj::__new(::h3d::anim::Skin s,::h3d::mat::MeshMaterial mat,::h3d::scene::Object parent)
{  hx::ObjectPtr< Skin_obj > result = new Skin_obj();
	result->__construct(s,mat,parent);
	return result;}

Dynamic Skin_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Skin_obj > result = new Skin_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2]);
	return result;}

::h3d::scene::Object Skin_obj::clone( ::h3d::scene::Object o){
	HX_STACK_FRAME("h3d.scene.Skin","clone",0xcca0cf83,"h3d.scene.Skin.clone","h3d/scene/Skin.hx",83,0xc713f0a8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(o,"o")
	HX_STACK_LINE(84)
	::h3d::scene::Skin s;		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(84)
	if (((o == null()))){
		HX_STACK_LINE(84)
		s = ::h3d::scene::Skin_obj::__new(null(),this->material,null());
	}
	else{
		HX_STACK_LINE(84)
		s = o;
	}
	HX_STACK_LINE(85)
	hx::TCast< ::h3d::scene::Mesh >::cast(this->super::clone(s));
	HX_STACK_LINE(86)
	s->setSkinData(this->skinData);
	HX_STACK_LINE(87)
	Array< ::Dynamic > _g = this->currentRelPose->copy();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(87)
	s->currentRelPose = _g;
	HX_STACK_LINE(88)
	return s;
}


::h3d::col::Bounds Skin_obj::getBounds( ::h3d::col::Bounds b){
	HX_STACK_FRAME("h3d.scene.Skin","getBounds",0xff79d6d1,"h3d.scene.Skin.getBounds","h3d/scene/Skin.hx",92,0xc713f0a8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(93)
	::h3d::col::Bounds _g = this->super::getBounds(b);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(93)
	b = _g;
	HX_STACK_LINE(94)
	::h3d::col::Bounds tmp;		HX_STACK_VAR(tmp,"tmp");
	HX_STACK_LINE(94)
	{
		HX_STACK_LINE(94)
		::h3d::col::Bounds _this = this->primitive->getBounds();		HX_STACK_VAR(_this,"_this");
		HX_STACK_LINE(94)
		::h3d::col::Bounds b1 = ::h3d::col::Bounds_obj::__new();		HX_STACK_VAR(b1,"b1");
		HX_STACK_LINE(94)
		b1->xMin = _this->xMin;
		HX_STACK_LINE(94)
		b1->xMax = _this->xMax;
		HX_STACK_LINE(94)
		b1->yMin = _this->yMin;
		HX_STACK_LINE(94)
		b1->yMax = _this->yMax;
		HX_STACK_LINE(94)
		b1->zMin = _this->zMin;
		HX_STACK_LINE(94)
		b1->zMax = _this->zMax;
		HX_STACK_LINE(94)
		tmp = b1;
	}
	HX_STACK_LINE(95)
	::h3d::anim::Joint b0 = this->skinData->allJoints->__get((int)0).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(b0,"b0");
	HX_STACK_LINE(97)
	if (((bool((bool((b0 != null())) && bool((b0->defMat != null())))) && bool((b0->parent == null()))))){
		HX_STACK_LINE(98)
		::h3d::Matrix mtmp = this->absPos->clone();		HX_STACK_VAR(mtmp,"mtmp");
		HX_STACK_LINE(99)
		::h3d::Matrix r = this->currentRelPose->__get(b0->index).StaticCast< ::h3d::Matrix >();		HX_STACK_VAR(r,"r");
		HX_STACK_LINE(100)
		if (((r != null()))){
			HX_STACK_LINE(101)
			mtmp->multiply3x4(r,mtmp);
		}
		else{
			HX_STACK_LINE(103)
			mtmp->multiply3x4(b0->defMat,mtmp);
		}
		HX_STACK_LINE(104)
		mtmp->multiply3x4(b0->transPos,mtmp);
		HX_STACK_LINE(105)
		tmp->transform3x4(mtmp);
	}
	else{
		HX_STACK_LINE(107)
		tmp->transform3x4(this->absPos);
	}
	HX_STACK_LINE(109)
	{
		HX_STACK_LINE(109)
		if (((tmp->xMin < b->xMin))){
			HX_STACK_LINE(109)
			b->xMin = tmp->xMin;
		}
		HX_STACK_LINE(109)
		if (((tmp->xMax > b->xMax))){
			HX_STACK_LINE(109)
			b->xMax = tmp->xMax;
		}
		HX_STACK_LINE(109)
		if (((tmp->yMin < b->yMin))){
			HX_STACK_LINE(109)
			b->yMin = tmp->yMin;
		}
		HX_STACK_LINE(109)
		if (((tmp->yMax > b->yMax))){
			HX_STACK_LINE(109)
			b->yMax = tmp->yMax;
		}
		HX_STACK_LINE(109)
		if (((tmp->zMin < b->zMin))){
			HX_STACK_LINE(109)
			b->zMin = tmp->zMin;
		}
		HX_STACK_LINE(109)
		if (((tmp->zMax > b->zMax))){
			HX_STACK_LINE(109)
			b->zMax = tmp->zMax;
		}
	}
	HX_STACK_LINE(110)
	return b;
}


::h3d::scene::Object Skin_obj::getObjectByName( ::String name){
	HX_STACK_FRAME("h3d.scene.Skin","getObjectByName",0x9587353d,"h3d.scene.Skin.getObjectByName","h3d/scene/Skin.hx",113,0xc713f0a8)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(114)
	::h3d::scene::Object o = this->super::getObjectByName(name);		HX_STACK_VAR(o,"o");
	HX_STACK_LINE(115)
	if (((o != null()))){
		HX_STACK_LINE(115)
		return o;
	}
	HX_STACK_LINE(117)
	if (((this->skinData != null()))){
		HX_STACK_LINE(118)
		::h3d::anim::Joint j = this->skinData->namedJoints->get(name);		HX_STACK_VAR(j,"j");
		HX_STACK_LINE(119)
		if (((j != null()))){
			HX_STACK_LINE(120)
			return ::h3d::scene::Joint_obj::__new(hx::ObjectPtr<OBJ_>(this),j->index);
		}
	}
	HX_STACK_LINE(122)
	return null();
}


Void Skin_obj::calcAbsPos( ){
{
		HX_STACK_FRAME("h3d.scene.Skin","calcAbsPos",0x7f1a9cd1,"h3d.scene.Skin.calcAbsPos","h3d/scene/Skin.hx",125,0xc713f0a8)
		HX_STACK_THIS(this)
		HX_STACK_LINE(126)
		this->super::calcAbsPos();
		HX_STACK_LINE(128)
		this->jointsUpdated = true;
	}
return null();
}


Void Skin_obj::setSkinData( ::h3d::anim::Skin s){
{
		HX_STACK_FRAME("h3d.scene.Skin","setSkinData",0x81ae41af,"h3d.scene.Skin.setSkinData","h3d/scene/Skin.hx",131,0xc713f0a8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(132)
		if (((::hxd::System_obj::debugLevel >= (int)2))){
			HX_STACK_LINE(132)
			::haxe::Log_obj::trace(HX_CSTRING("Skin.setSkinData();"),hx::SourceInfo(HX_CSTRING("Skin.hx"),132,HX_CSTRING("h3d.scene.Skin"),HX_CSTRING("setSkinData")));
		}
		HX_STACK_LINE(133)
		this->skinData = s;
		HX_STACK_LINE(134)
		this->jointsUpdated = true;
		HX_STACK_LINE(135)
		this->primitive = s->primitive;
		HX_STACK_LINE(136)
		this->material->get_mshader()->hasSkin = true;
		HX_STACK_LINE(137)
		this->currentRelPose = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(138)
		this->currentAbsPose = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(139)
		this->currentPalette = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(140)
		this->paletteChanged = true;
		HX_STACK_LINE(141)
		{
			HX_STACK_LINE(141)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(141)
			Array< ::Dynamic > _g1 = this->skinData->allJoints;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(141)
			while((true)){
				HX_STACK_LINE(141)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(141)
					break;
				}
				HX_STACK_LINE(141)
				::h3d::anim::Joint j = _g1->__get(_g).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
				HX_STACK_LINE(141)
				++(_g);
				HX_STACK_LINE(142)
				::h3d::Matrix _g2 = ::h3d::Matrix_obj::I();		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(142)
				this->currentAbsPose->push(_g2);
			}
		}
		HX_STACK_LINE(143)
		{
			HX_STACK_LINE(143)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(143)
			int _g = this->skinData->boundJoints->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(143)
			while((true)){
				HX_STACK_LINE(143)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(143)
					break;
				}
				HX_STACK_LINE(143)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(144)
				::h3d::Matrix _g11 = ::h3d::Matrix_obj::I();		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(144)
				this->currentPalette->push(_g11);
			}
		}
		HX_STACK_LINE(145)
		if (((this->skinData->splitJoints != null()))){
			HX_STACK_LINE(146)
			this->splitPalette = Array_obj< ::Dynamic >::__new();
			HX_STACK_LINE(147)
			{
				HX_STACK_LINE(147)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(147)
				Array< ::Dynamic > _g1 = this->skinData->splitJoints;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(147)
				while((true)){
					HX_STACK_LINE(147)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(147)
						break;
					}
					HX_STACK_LINE(147)
					Array< ::Dynamic > a = _g1->__get(_g).StaticCast< Array< ::Dynamic > >();		HX_STACK_VAR(a,"a");
					HX_STACK_LINE(147)
					++(_g);
					HX_STACK_LINE(148)
					Array< ::Dynamic > _g2;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(148)
					{
						HX_STACK_LINE(148)
						Array< ::Dynamic > _g21 = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(148)
						{
							HX_STACK_LINE(148)
							int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
							HX_STACK_LINE(148)
							while((true)){
								HX_STACK_LINE(148)
								if ((!(((_g3 < a->length))))){
									HX_STACK_LINE(148)
									break;
								}
								HX_STACK_LINE(148)
								::h3d::anim::Joint j = a->__get(_g3).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
								HX_STACK_LINE(148)
								++(_g3);
								HX_STACK_LINE(148)
								_g21->push(this->currentPalette->__get(j->bindIndex).StaticCast< ::h3d::Matrix >());
							}
						}
						HX_STACK_LINE(148)
						_g2 = _g21;
					}
					HX_STACK_LINE(148)
					this->splitPalette->push(_g2);
				}
			}
		}
		else{
			HX_STACK_LINE(150)
			this->splitPalette = null();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Skin_obj,setSkinData,(void))

Void Skin_obj::sync( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.Skin","sync",0x283b44f5,"h3d.scene.Skin.sync","h3d/scene/Skin.hx",153,0xc713f0a8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(154)
		if ((!(((bool(this->visible) || bool(this->syncIfHidden)))))){
			HX_STACK_LINE(155)
			return null();
		}
		HX_STACK_LINE(156)
		if (((bool(this->jointsUpdated) || bool(this->posChanged)))){
			HX_STACK_LINE(157)
			this->super::sync(ctx);
			HX_STACK_LINE(158)
			{
				HX_STACK_LINE(158)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(158)
				Array< ::Dynamic > _g1 = this->skinData->allJoints;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(158)
				while((true)){
					HX_STACK_LINE(158)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(158)
						break;
					}
					HX_STACK_LINE(158)
					::h3d::anim::Joint j = _g1->__get(_g).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
					HX_STACK_LINE(158)
					++(_g);
					HX_STACK_LINE(159)
					int id = j->index;		HX_STACK_VAR(id,"id");
					HX_STACK_LINE(160)
					::h3d::Matrix m = this->currentAbsPose->__get(id).StaticCast< ::h3d::Matrix >();		HX_STACK_VAR(m,"m");
					HX_STACK_LINE(161)
					::h3d::Matrix r = this->currentRelPose->__get(id).StaticCast< ::h3d::Matrix >();		HX_STACK_VAR(r,"r");
					HX_STACK_LINE(162)
					if (((r == null()))){
						HX_STACK_LINE(163)
						int bid = j->bindIndex;		HX_STACK_VAR(bid,"bid");
						HX_STACK_LINE(164)
						if (((bid >= (int)0))){
							HX_STACK_LINE(164)
							r = j->defMat;
						}
						else{
							HX_STACK_LINE(164)
							continue;
						}
					}
					HX_STACK_LINE(166)
					if (((j->parent == null()))){
						HX_STACK_LINE(167)
						m->multiply3x4(r,this->absPos);
					}
					else{
						HX_STACK_LINE(169)
						m->multiply3x4(r,this->currentAbsPose->__get(j->parent->index).StaticCast< ::h3d::Matrix >());
					}
					HX_STACK_LINE(170)
					int bid = j->bindIndex;		HX_STACK_VAR(bid,"bid");
					HX_STACK_LINE(171)
					if (((bid >= (int)0))){
						HX_STACK_LINE(172)
						this->currentPalette->__get(bid).StaticCast< ::h3d::Matrix >()->multiply3x4(j->transPos,m);
					}
				}
			}
			HX_STACK_LINE(174)
			this->paletteChanged = true;
			HX_STACK_LINE(175)
			if (((this->jointsAbsPosInv != null()))){
				HX_STACK_LINE(175)
				this->jointsAbsPosInv->_44 = (int)0;
			}
			HX_STACK_LINE(176)
			this->jointsUpdated = false;
		}
		else{
			HX_STACK_LINE(178)
			this->super::sync(ctx);
		}
	}
return null();
}


Void Skin_obj::draw( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.Skin","draw",0x1e4bb69e,"h3d.scene.Skin.draw","h3d/scene/Skin.hx",181,0xc713f0a8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(183)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(183)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(183)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("skin draw"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(183)
			if (((null() == ent))){
				struct _Function_3_1{
					inline static Dynamic Block( ){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/scene/Skin.hx",183,0xc713f0a8)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("start") , null(),false);
							__result->Add(HX_CSTRING("total") , 0.0,false);
							__result->Add(HX_CSTRING("hit") , (int)0,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(183)
				ent = _Function_3_1::Block();
				HX_STACK_LINE(183)
				::hxd::Profiler_obj::h->set(HX_CSTRING("skin draw"),ent);
			}
			HX_STACK_LINE(183)
			ent->__FieldRef(HX_CSTRING("start")) = t;
			HX_STACK_LINE(183)
			(ent->__FieldRef(HX_CSTRING("hit")))++;
		}
		HX_STACK_LINE(184)
		if (((this->splitPalette == null()))){
			HX_STACK_LINE(185)
			if ((this->paletteChanged)){
				HX_STACK_LINE(186)
				this->paletteChanged = false;
				HX_STACK_LINE(188)
				this->material->set_skinMatrixes(this->currentPalette);
			}
			HX_STACK_LINE(195)
			this->super::draw(ctx);
		}
		else{
			HX_STACK_LINE(197)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(197)
			int _g = this->splitPalette->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(197)
			while((true)){
				HX_STACK_LINE(197)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(197)
					break;
				}
				HX_STACK_LINE(197)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(198)
				this->material->set_skinMatrixes(this->splitPalette->__get(i).StaticCast< Array< ::Dynamic > >());
				HX_STACK_LINE(205)
				this->primitive->selectMaterial(i);
				HX_STACK_LINE(206)
				this->super::draw(ctx);
			}
		}
		HX_STACK_LINE(212)
		ctx->addPass(this->drawJoints_dyn());
		HX_STACK_LINE(213)
		if ((::hxd::Profiler_obj::enable)){
			HX_STACK_LINE(213)
			Float t = ::haxe::Timer_obj::stamp();		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(213)
			Dynamic ent = ::hxd::Profiler_obj::h->get(HX_CSTRING("skin draw"));		HX_STACK_VAR(ent,"ent");
			HX_STACK_LINE(213)
			if (((null() != ent))){
				HX_STACK_LINE(213)
				if (((ent->__Field(HX_CSTRING("start"),true) != null()))){
					HX_STACK_LINE(213)
					hx::AddEq(ent->__FieldRef(HX_CSTRING("total")),(t - ent->__Field(HX_CSTRING("start"),true)));
				}
			}
		}
	}
return null();
}


Void Skin_obj::drawJoints( ::h3d::scene::RenderContext ctx){
{
		HX_STACK_FRAME("h3d.scene.Skin","drawJoints",0x1ad5dd27,"h3d.scene.Skin.drawJoints","h3d/scene/Skin.hx",217,0xc713f0a8)
		HX_STACK_THIS(this)
		HX_STACK_ARG(ctx,"ctx")
		HX_STACK_LINE(217)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(217)
		Array< ::Dynamic > _g1 = this->skinData->allJoints;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(217)
		while((true)){
			HX_STACK_LINE(217)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(217)
				break;
			}
			HX_STACK_LINE(217)
			::h3d::anim::Joint j = _g1->__get(_g).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
			HX_STACK_LINE(217)
			++(_g);
			HX_STACK_LINE(218)
			::h3d::Matrix m = this->currentAbsPose->__get(j->index).StaticCast< ::h3d::Matrix >();		HX_STACK_VAR(m,"m");
			HX_STACK_LINE(219)
			::h3d::Matrix mp;		HX_STACK_VAR(mp,"mp");
			HX_STACK_LINE(219)
			if (((j->parent == null()))){
				HX_STACK_LINE(219)
				mp = this->absPos;
			}
			else{
				HX_STACK_LINE(219)
				mp = this->currentAbsPose->__get(j->parent->index).StaticCast< ::h3d::Matrix >();
			}
			HX_STACK_LINE(220)
			ctx->engine->line(mp->_41,mp->_42,mp->_43,m->_41,m->_42,m->_43,(  (((j->parent == null()))) ? int((int)-16776961) : int((int)-256) ),null());
			HX_STACK_LINE(222)
			::h3d::Vector dz = ::h3d::Vector_obj::__new((int)0,0.01,(int)0,null());		HX_STACK_VAR(dz,"dz");
			HX_STACK_LINE(223)
			{
				HX_STACK_LINE(223)
				Float px = ((((dz->x * m->_11) + (dz->y * m->_21)) + (dz->z * m->_31)) + (dz->w * m->_41));		HX_STACK_VAR(px,"px");
				HX_STACK_LINE(223)
				Float py = ((((dz->x * m->_12) + (dz->y * m->_22)) + (dz->z * m->_32)) + (dz->w * m->_42));		HX_STACK_VAR(py,"py");
				HX_STACK_LINE(223)
				Float pz = ((((dz->x * m->_13) + (dz->y * m->_23)) + (dz->z * m->_33)) + (dz->w * m->_43));		HX_STACK_VAR(pz,"pz");
				HX_STACK_LINE(223)
				Float pw = ((((dz->x * m->_14) + (dz->y * m->_24)) + (dz->z * m->_34)) + (dz->w * m->_44));		HX_STACK_VAR(pw,"pw");
				HX_STACK_LINE(223)
				dz->x = px;
				HX_STACK_LINE(223)
				dz->y = py;
				HX_STACK_LINE(223)
				dz->z = pz;
				HX_STACK_LINE(223)
				dz->w = pw;
			}
			HX_STACK_LINE(224)
			ctx->engine->line(m->_41,m->_42,m->_43,dz->x,dz->y,dz->z,(int)-16711936,null());
			HX_STACK_LINE(226)
			ctx->engine->point(m->_41,m->_42,m->_43,(  (((j->bindIndex < (int)0))) ? int((int)-16776961) : int((int)-65536) ),null(),null());
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Skin_obj,drawJoints,(void))


Skin_obj::Skin_obj()
{
}

void Skin_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Skin);
	HX_MARK_MEMBER_NAME(skinData,"skinData");
	HX_MARK_MEMBER_NAME(currentRelPose,"currentRelPose");
	HX_MARK_MEMBER_NAME(currentAbsPose,"currentAbsPose");
	HX_MARK_MEMBER_NAME(currentPalette,"currentPalette");
	HX_MARK_MEMBER_NAME(splitPalette,"splitPalette");
	HX_MARK_MEMBER_NAME(jointsUpdated,"jointsUpdated");
	HX_MARK_MEMBER_NAME(jointsAbsPosInv,"jointsAbsPosInv");
	HX_MARK_MEMBER_NAME(paletteChanged,"paletteChanged");
	HX_MARK_MEMBER_NAME(showJoints,"showJoints");
	HX_MARK_MEMBER_NAME(syncIfHidden,"syncIfHidden");
	::h3d::scene::Mesh_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Skin_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(skinData,"skinData");
	HX_VISIT_MEMBER_NAME(currentRelPose,"currentRelPose");
	HX_VISIT_MEMBER_NAME(currentAbsPose,"currentAbsPose");
	HX_VISIT_MEMBER_NAME(currentPalette,"currentPalette");
	HX_VISIT_MEMBER_NAME(splitPalette,"splitPalette");
	HX_VISIT_MEMBER_NAME(jointsUpdated,"jointsUpdated");
	HX_VISIT_MEMBER_NAME(jointsAbsPosInv,"jointsAbsPosInv");
	HX_VISIT_MEMBER_NAME(paletteChanged,"paletteChanged");
	HX_VISIT_MEMBER_NAME(showJoints,"showJoints");
	HX_VISIT_MEMBER_NAME(syncIfHidden,"syncIfHidden");
	::h3d::scene::Mesh_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Skin_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"sync") ) { return sync_dyn(); }
		if (HX_FIELD_EQ(inName,"draw") ) { return draw_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"skinData") ) { return skinData; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getBounds") ) { return getBounds_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"showJoints") ) { return showJoints; }
		if (HX_FIELD_EQ(inName,"calcAbsPos") ) { return calcAbsPos_dyn(); }
		if (HX_FIELD_EQ(inName,"drawJoints") ) { return drawJoints_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"setSkinData") ) { return setSkinData_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"splitPalette") ) { return splitPalette; }
		if (HX_FIELD_EQ(inName,"syncIfHidden") ) { return syncIfHidden; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"jointsUpdated") ) { return jointsUpdated; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"currentRelPose") ) { return currentRelPose; }
		if (HX_FIELD_EQ(inName,"currentAbsPose") ) { return currentAbsPose; }
		if (HX_FIELD_EQ(inName,"currentPalette") ) { return currentPalette; }
		if (HX_FIELD_EQ(inName,"paletteChanged") ) { return paletteChanged; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"jointsAbsPosInv") ) { return jointsAbsPosInv; }
		if (HX_FIELD_EQ(inName,"getObjectByName") ) { return getObjectByName_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Skin_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"skinData") ) { skinData=inValue.Cast< ::h3d::anim::Skin >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"showJoints") ) { showJoints=inValue.Cast< bool >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"splitPalette") ) { splitPalette=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"syncIfHidden") ) { syncIfHidden=inValue.Cast< bool >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"jointsUpdated") ) { jointsUpdated=inValue.Cast< bool >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"currentRelPose") ) { currentRelPose=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"currentAbsPose") ) { currentAbsPose=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"currentPalette") ) { currentPalette=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"paletteChanged") ) { paletteChanged=inValue.Cast< bool >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"jointsAbsPosInv") ) { jointsAbsPosInv=inValue.Cast< ::h3d::Matrix >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Skin_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("skinData"));
	outFields->push(HX_CSTRING("currentRelPose"));
	outFields->push(HX_CSTRING("currentAbsPose"));
	outFields->push(HX_CSTRING("currentPalette"));
	outFields->push(HX_CSTRING("splitPalette"));
	outFields->push(HX_CSTRING("jointsUpdated"));
	outFields->push(HX_CSTRING("jointsAbsPosInv"));
	outFields->push(HX_CSTRING("paletteChanged"));
	outFields->push(HX_CSTRING("showJoints"));
	outFields->push(HX_CSTRING("syncIfHidden"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::anim::Skin*/ ,(int)offsetof(Skin_obj,skinData),HX_CSTRING("skinData")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,currentRelPose),HX_CSTRING("currentRelPose")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,currentAbsPose),HX_CSTRING("currentAbsPose")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,currentPalette),HX_CSTRING("currentPalette")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,splitPalette),HX_CSTRING("splitPalette")},
	{hx::fsBool,(int)offsetof(Skin_obj,jointsUpdated),HX_CSTRING("jointsUpdated")},
	{hx::fsObject /*::h3d::Matrix*/ ,(int)offsetof(Skin_obj,jointsAbsPosInv),HX_CSTRING("jointsAbsPosInv")},
	{hx::fsBool,(int)offsetof(Skin_obj,paletteChanged),HX_CSTRING("paletteChanged")},
	{hx::fsBool,(int)offsetof(Skin_obj,showJoints),HX_CSTRING("showJoints")},
	{hx::fsBool,(int)offsetof(Skin_obj,syncIfHidden),HX_CSTRING("syncIfHidden")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("skinData"),
	HX_CSTRING("currentRelPose"),
	HX_CSTRING("currentAbsPose"),
	HX_CSTRING("currentPalette"),
	HX_CSTRING("splitPalette"),
	HX_CSTRING("jointsUpdated"),
	HX_CSTRING("jointsAbsPosInv"),
	HX_CSTRING("paletteChanged"),
	HX_CSTRING("showJoints"),
	HX_CSTRING("syncIfHidden"),
	HX_CSTRING("clone"),
	HX_CSTRING("getBounds"),
	HX_CSTRING("getObjectByName"),
	HX_CSTRING("calcAbsPos"),
	HX_CSTRING("setSkinData"),
	HX_CSTRING("sync"),
	HX_CSTRING("draw"),
	HX_CSTRING("drawJoints"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Skin_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Skin_obj::__mClass,"__mClass");
};

#endif

Class Skin_obj::__mClass;

void Skin_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.scene.Skin"), hx::TCanCast< Skin_obj> ,sStaticFields,sMemberFields,
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

void Skin_obj::__boot()
{
}

} // end namespace h3d
} // end namespace scene
