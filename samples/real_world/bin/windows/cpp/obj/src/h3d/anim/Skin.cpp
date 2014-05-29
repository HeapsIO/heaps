#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h3d_anim_Joint
#include <h3d/anim/Joint.h>
#endif
#ifndef INCLUDED_h3d_anim_Skin
#include <h3d/anim/Skin.h>
#endif
#ifndef INCLUDED_h3d_anim__Skin_Influence
#include <h3d/anim/_Skin/Influence.h>
#endif
#ifndef INCLUDED_h3d_prim_Primitive
#include <h3d/prim/Primitive.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
namespace h3d{
namespace anim{

Void Skin_obj::__construct(int vertexCount,int bonesPerVertex)
{
HX_STACK_FRAME("h3d.anim.Skin","new",0xbcb16817,"h3d.anim.Skin.new","h3d/anim/Skin.hx",59,0xee0056d9)
HX_STACK_THIS(this)
HX_STACK_ARG(vertexCount,"vertexCount")
HX_STACK_ARG(bonesPerVertex,"bonesPerVertex")
{
	HX_STACK_LINE(60)
	this->vertexCount = vertexCount;
	HX_STACK_LINE(61)
	this->bonesPerVertex = bonesPerVertex;
	HX_STACK_LINE(62)
	Array< int > _g1;		HX_STACK_VAR(_g1,"_g1");
	struct _Function_1_1{
		inline static Array< int > Block( int &bonesPerVertex,int &vertexCount){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/anim/Skin.hx",62,0xee0056d9)
			{
				HX_STACK_LINE(62)
				Array< int > this1;		HX_STACK_VAR(this1,"this1");
				HX_STACK_LINE(62)
				Array< int > _g = Array_obj< int >::__new()->__SetSizeExact((vertexCount * bonesPerVertex));		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(62)
				this1 = _g;
				HX_STACK_LINE(62)
				return this1;
			}
			return null();
		}
	};
	HX_STACK_LINE(62)
	_g1 = _Function_1_1::Block(bonesPerVertex,vertexCount);
	HX_STACK_LINE(62)
	this->vertexJoints = _g1;
	HX_STACK_LINE(63)
	Array< Float > _g3;		HX_STACK_VAR(_g3,"_g3");
	struct _Function_1_2{
		inline static Array< Float > Block( int &bonesPerVertex,int &vertexCount){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/anim/Skin.hx",63,0xee0056d9)
			{
				HX_STACK_LINE(63)
				Array< Float > this1;		HX_STACK_VAR(this1,"this1");
				HX_STACK_LINE(63)
				Array< Float > _g2 = Array_obj< Float >::__new()->__SetSizeExact((vertexCount * bonesPerVertex));		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(63)
				this1 = _g2;
				HX_STACK_LINE(63)
				return this1;
			}
			return null();
		}
	};
	HX_STACK_LINE(63)
	_g3 = _Function_1_2::Block(bonesPerVertex,vertexCount);
	HX_STACK_LINE(63)
	this->vertexWeights = _g3;
	HX_STACK_LINE(64)
	this->envelop = Array_obj< ::Dynamic >::__new();
}
;
	return null();
}

//Skin_obj::~Skin_obj() { }

Dynamic Skin_obj::__CreateEmpty() { return  new Skin_obj; }
hx::ObjectPtr< Skin_obj > Skin_obj::__new(int vertexCount,int bonesPerVertex)
{  hx::ObjectPtr< Skin_obj > result = new Skin_obj();
	result->__construct(vertexCount,bonesPerVertex);
	return result;}

Dynamic Skin_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Skin_obj > result = new Skin_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

Void Skin_obj::setJoints( Array< ::Dynamic > joints,Array< ::Dynamic > roots){
{
		HX_STACK_FRAME("h3d.anim.Skin","setJoints",0xb3b21822,"h3d.anim.Skin.setJoints","h3d/anim/Skin.hx",67,0xee0056d9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(joints,"joints")
		HX_STACK_ARG(roots,"roots")
		HX_STACK_LINE(68)
		this->rootJoints = roots;
		HX_STACK_LINE(69)
		this->allJoints = joints;
		HX_STACK_LINE(70)
		::haxe::ds::StringMap _g = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(70)
		this->namedJoints = _g;
		HX_STACK_LINE(71)
		{
			HX_STACK_LINE(71)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(71)
			while((true)){
				HX_STACK_LINE(71)
				if ((!(((_g1 < joints->length))))){
					HX_STACK_LINE(71)
					break;
				}
				HX_STACK_LINE(71)
				::h3d::anim::Joint j = joints->__get(_g1).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
				HX_STACK_LINE(71)
				++(_g1);
				HX_STACK_LINE(72)
				if (((j->name != null()))){
					HX_STACK_LINE(73)
					this->namedJoints->set(j->name,j);
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Skin_obj,setJoints,(void))

Void Skin_obj::addInfluence( int vid,::h3d::anim::Joint j,Float w){
{
		HX_STACK_FRAME("h3d.anim.Skin","addInfluence",0x2b08f8fd,"h3d.anim.Skin.addInfluence","h3d/anim/Skin.hx",76,0xee0056d9)
		HX_STACK_THIS(this)
		HX_STACK_ARG(vid,"vid")
		HX_STACK_ARG(j,"j")
		HX_STACK_ARG(w,"w")
		HX_STACK_LINE(77)
		Array< ::Dynamic > il = this->envelop->__get(vid).StaticCast< Array< ::Dynamic > >();		HX_STACK_VAR(il,"il");
		HX_STACK_LINE(78)
		if (((il == null()))){
			HX_STACK_LINE(79)
			Array< ::Dynamic > _g = this->envelop[vid] = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(79)
			il = _g;
		}
		HX_STACK_LINE(80)
		::h3d::anim::_Skin::Influence _g1 = ::h3d::anim::_Skin::Influence_obj::__new(j,w);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(80)
		il->push(_g1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Skin_obj,addInfluence,(void))

int Skin_obj::sortInfluences( ::h3d::anim::_Skin::Influence i1,::h3d::anim::_Skin::Influence i2){
	HX_STACK_FRAME("h3d.anim.Skin","sortInfluences",0xe4f70b85,"h3d.anim.Skin.sortInfluences","h3d/anim/Skin.hx",84,0xee0056d9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(i1,"i1")
	HX_STACK_ARG(i2,"i2")
	HX_STACK_LINE(84)
	if (((i2->w > i1->w))){
		HX_STACK_LINE(84)
		return (int)1;
	}
	else{
		HX_STACK_LINE(84)
		return (int)-1;
	}
	HX_STACK_LINE(84)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC2(Skin_obj,sortInfluences,return )

bool Skin_obj::isSplit( ){
	HX_STACK_FRAME("h3d.anim.Skin","isSplit",0xacbdcdc7,"h3d.anim.Skin.isSplit","h3d/anim/Skin.hx",88,0xee0056d9)
	HX_STACK_THIS(this)
	HX_STACK_LINE(88)
	return (this->splitJoints != null());
}


HX_DEFINE_DYNAMIC_FUNC0(Skin_obj,isSplit,return )

Void Skin_obj::initWeights( ){
{
		HX_STACK_FRAME("h3d.anim.Skin","initWeights",0x3945ed82,"h3d.anim.Skin.initWeights","h3d/anim/Skin.hx",91,0xee0056d9)
		HX_STACK_THIS(this)
		HX_STACK_LINE(92)
		this->boundJoints = Array_obj< ::Dynamic >::__new();
		HX_STACK_LINE(93)
		int pos = (int)0;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(94)
		{
			HX_STACK_LINE(94)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(94)
			int _g = this->vertexCount;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(94)
			while((true)){
				HX_STACK_LINE(94)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(94)
					break;
				}
				HX_STACK_LINE(94)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(95)
				Array< ::Dynamic > il = this->envelop->__get(i).StaticCast< Array< ::Dynamic > >();		HX_STACK_VAR(il,"il");
				HX_STACK_LINE(96)
				if (((il == null()))){
					HX_STACK_LINE(96)
					il = Array_obj< ::Dynamic >::__new();
				}
				HX_STACK_LINE(97)
				il->sort(this->sortInfluences_dyn());
				HX_STACK_LINE(98)
				if (((il->length > this->bonesPerVertex))){
					HX_STACK_LINE(99)
					Array< ::Dynamic > _g2 = il->slice((int)0,this->bonesPerVertex);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(99)
					il = _g2;
				}
				HX_STACK_LINE(100)
				Float tw = 0.;		HX_STACK_VAR(tw,"tw");
				HX_STACK_LINE(101)
				{
					HX_STACK_LINE(101)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(101)
					while((true)){
						HX_STACK_LINE(101)
						if ((!(((_g2 < il->length))))){
							HX_STACK_LINE(101)
							break;
						}
						HX_STACK_LINE(101)
						::h3d::anim::_Skin::Influence i1 = il->__get(_g2).StaticCast< ::h3d::anim::_Skin::Influence >();		HX_STACK_VAR(i1,"i1");
						HX_STACK_LINE(101)
						++(_g2);
						HX_STACK_LINE(102)
						hx::AddEq(tw,i1->w);
					}
				}
				HX_STACK_LINE(103)
				tw = (Float((int)1) / Float(tw));
				HX_STACK_LINE(104)
				{
					HX_STACK_LINE(104)
					int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(104)
					int _g2 = this->bonesPerVertex;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(104)
					while((true)){
						HX_STACK_LINE(104)
						if ((!(((_g3 < _g2))))){
							HX_STACK_LINE(104)
							break;
						}
						HX_STACK_LINE(104)
						int i1 = (_g3)++;		HX_STACK_VAR(i1,"i1");
						HX_STACK_LINE(105)
						::h3d::anim::_Skin::Influence i2 = il->__get(i1).StaticCast< ::h3d::anim::_Skin::Influence >();		HX_STACK_VAR(i2,"i2");
						HX_STACK_LINE(106)
						if (((i2 == null()))){
							HX_STACK_LINE(107)
							this->vertexJoints->__unsafe_set(pos,(int)0);
							HX_STACK_LINE(108)
							this->vertexWeights->__unsafe_set(pos,(int)0);
						}
						else{
							HX_STACK_LINE(110)
							if (((i2->j->bindIndex == (int)-1))){
								HX_STACK_LINE(111)
								i2->j->bindIndex = this->boundJoints->length;
								HX_STACK_LINE(112)
								this->boundJoints->push(i2->j);
							}
							HX_STACK_LINE(114)
							this->vertexJoints->__unsafe_set(pos,i2->j->bindIndex);
							HX_STACK_LINE(115)
							this->vertexWeights->__unsafe_set(pos,(i2->w * tw));
						}
						HX_STACK_LINE(117)
						(pos)++;
					}
				}
			}
		}
		HX_STACK_LINE(120)
		this->envelop = null();
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Skin_obj,initWeights,(void))

bool Skin_obj::split( int maxBones,Array< int > index){
	HX_STACK_FRAME("h3d.anim.Skin","split",0x422b1e51,"h3d.anim.Skin.split","h3d/anim/Skin.hx",123,0xee0056d9)
	HX_STACK_THIS(this)
	HX_STACK_ARG(maxBones,"maxBones")
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(124)
	if (((this->splitJoints != null()))){
		HX_STACK_LINE(125)
		return true;
	}
	HX_STACK_LINE(126)
	if (((this->boundJoints->length <= maxBones))){
		HX_STACK_LINE(127)
		return false;
	}
	HX_STACK_LINE(129)
	this->splitJoints = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(130)
	Array< int > _g1;		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(130)
	{
		HX_STACK_LINE(130)
		int length = ::Std_obj::_int((Float(index->length) / Float((int)3)));		HX_STACK_VAR(length,"length");
		HX_STACK_LINE(130)
		Array< int > this1;		HX_STACK_VAR(this1,"this1");
		HX_STACK_LINE(130)
		Array< int > _g = Array_obj< int >::__new()->__SetSizeExact(length);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(130)
		this1 = _g;
		HX_STACK_LINE(130)
		_g1 = this1;
	}
	HX_STACK_LINE(130)
	this->triangleGroups = _g1;
	HX_STACK_LINE(133)
	Array< ::Dynamic > curGroup = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(curGroup,"curGroup");
	HX_STACK_LINE(133)
	Array< ::Dynamic > curJoints = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(curJoints,"curJoints");
	HX_STACK_LINE(134)
	int ipos = (int)0;		HX_STACK_VAR(ipos,"ipos");
	HX_STACK_LINE(134)
	int tpos = (int)0;		HX_STACK_VAR(tpos,"tpos");
	HX_STACK_LINE(135)
	while((true)){
		HX_STACK_LINE(135)
		if ((!(((ipos <= index->length))))){
			HX_STACK_LINE(135)
			break;
		}
		HX_STACK_LINE(136)
		Array< ::Dynamic > tjoints = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(tjoints,"tjoints");
		HX_STACK_LINE(136)
		bool flush = false;		HX_STACK_VAR(flush,"flush");
		HX_STACK_LINE(137)
		if (((ipos < index->length))){
			HX_STACK_LINE(138)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(138)
			while((true)){
				HX_STACK_LINE(138)
				if ((!(((_g < (int)3))))){
					HX_STACK_LINE(138)
					break;
				}
				HX_STACK_LINE(138)
				int k = (_g)++;		HX_STACK_VAR(k,"k");
				HX_STACK_LINE(139)
				int vid = index->__get((ipos + k));		HX_STACK_VAR(vid,"vid");
				HX_STACK_LINE(140)
				{
					HX_STACK_LINE(140)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(140)
					int _g11 = this->bonesPerVertex;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(140)
					while((true)){
						HX_STACK_LINE(140)
						if ((!(((_g2 < _g11))))){
							HX_STACK_LINE(140)
							break;
						}
						HX_STACK_LINE(140)
						int b = (_g2)++;		HX_STACK_VAR(b,"b");
						HX_STACK_LINE(141)
						int bidx = ((vid * this->bonesPerVertex) + b);		HX_STACK_VAR(bidx,"bidx");
						HX_STACK_LINE(142)
						Float _g21 = this->vertexWeights->__unsafe_get(bidx);		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(142)
						if (((_g21 == (int)0))){
							HX_STACK_LINE(142)
							continue;
						}
						HX_STACK_LINE(143)
						int _g3 = this->vertexJoints->__unsafe_get(bidx);		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(143)
						::h3d::anim::Joint j = this->boundJoints->__get(_g3).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
						HX_STACK_LINE(144)
						if (((curJoints->__get(j->bindIndex).StaticCast< ::h3d::anim::Joint >() == null()))){
							HX_STACK_LINE(145)
							curJoints[j->bindIndex] = j;
							HX_STACK_LINE(146)
							tjoints->push(j);
						}
					}
				}
			}
		}
		HX_STACK_LINE(151)
		if (((bool(((curGroup->length + tjoints->length) <= maxBones)) && bool((ipos < index->length))))){
			HX_STACK_LINE(152)
			{
				HX_STACK_LINE(152)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(152)
				while((true)){
					HX_STACK_LINE(152)
					if ((!(((_g < tjoints->length))))){
						HX_STACK_LINE(152)
						break;
					}
					HX_STACK_LINE(152)
					::h3d::anim::Joint j = tjoints->__get(_g).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
					HX_STACK_LINE(152)
					++(_g);
					HX_STACK_LINE(153)
					curGroup->push(j);
				}
			}
			HX_STACK_LINE(154)
			{
				HX_STACK_LINE(154)
				int index1 = (tpos)++;		HX_STACK_VAR(index1,"index1");
				HX_STACK_LINE(154)
				this->triangleGroups->__unsafe_set(index1,this->splitJoints->length);
			}
			HX_STACK_LINE(155)
			hx::AddEq(ipos,(int)3);
		}
		else{
			HX_STACK_LINE(157)
			this->splitJoints->push(curGroup);
			HX_STACK_LINE(158)
			curGroup = Array_obj< ::Dynamic >::__new();
			HX_STACK_LINE(159)
			curJoints = Array_obj< ::Dynamic >::__new();
			HX_STACK_LINE(160)
			if (((ipos == index->length))){
				HX_STACK_LINE(160)
				break;
			}
		}
	}
	HX_STACK_LINE(165)
	Dynamic groups;		HX_STACK_VAR(groups,"groups");
	HX_STACK_LINE(165)
	{
		HX_STACK_LINE(165)
		Dynamic _g = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(165)
		{
			HX_STACK_LINE(165)
			int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(165)
			int _g11 = this->splitJoints->length;		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(165)
			while((true)){
				HX_STACK_LINE(165)
				if ((!(((_g2 < _g11))))){
					HX_STACK_LINE(165)
					break;
				}
				HX_STACK_LINE(165)
				int i = (_g2)++;		HX_STACK_VAR(i,"i");
				struct _Function_4_1{
					inline static Dynamic Block( int &i,hx::ObjectPtr< ::h3d::anim::Skin_obj > __this){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/anim/Skin.hx",165,0xee0056d9)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("id") , i,false);
							__result->Add(HX_CSTRING("reserved") , Array_obj< ::Dynamic >::__new(),false);
							__result->Add(HX_CSTRING("joints") , __this->splitJoints->__get(i).StaticCast< Array< ::Dynamic > >(),false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(165)
				_g->__Field(HX_CSTRING("push"),true)(_Function_4_1::Block(i,this));
			}
		}
		HX_STACK_LINE(165)
		groups = _g;
	}
	HX_STACK_LINE(166)
	Dynamic joints;		HX_STACK_VAR(joints,"joints");
	HX_STACK_LINE(166)
	{
		HX_STACK_LINE(166)
		Dynamic _g11 = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(166)
		{
			HX_STACK_LINE(166)
			int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(166)
			Array< ::Dynamic > _g3 = this->boundJoints;		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(166)
			while((true)){
				HX_STACK_LINE(166)
				if ((!(((_g2 < _g3->length))))){
					HX_STACK_LINE(166)
					break;
				}
				HX_STACK_LINE(166)
				::h3d::anim::Joint j = _g3->__get(_g2).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
				HX_STACK_LINE(166)
				++(_g2);
				struct _Function_4_1{
					inline static Dynamic Block( ::h3d::anim::Joint &j){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/anim/Skin.hx",166,0xee0056d9)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("j") , j,false);
							__result->Add(HX_CSTRING("groups") , Dynamic( Array_obj<Dynamic>::__new()),false);
							__result->Add(HX_CSTRING("index") , (int)-1,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(166)
				_g11->__Field(HX_CSTRING("push"),true)(_Function_4_1::Block(j));
			}
		}
		HX_STACK_LINE(166)
		joints = _g11;
	}
	HX_STACK_LINE(167)
	{
		HX_STACK_LINE(167)
		int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(167)
		while((true)){
			HX_STACK_LINE(167)
			if ((!(((_g2 < groups->__Field(HX_CSTRING("length"),true)))))){
				HX_STACK_LINE(167)
				break;
			}
			HX_STACK_LINE(167)
			Dynamic g = groups->__GetItem(_g2);		HX_STACK_VAR(g,"g");
			HX_STACK_LINE(167)
			++(_g2);
			HX_STACK_LINE(168)
			int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(168)
			Array< ::Dynamic > _g4 = g->__Field(HX_CSTRING("joints"),true);		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(168)
			while((true)){
				HX_STACK_LINE(168)
				if ((!(((_g3 < _g4->length))))){
					HX_STACK_LINE(168)
					break;
				}
				HX_STACK_LINE(168)
				::h3d::anim::Joint j = _g4->__get(_g3).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
				HX_STACK_LINE(168)
				++(_g3);
				HX_STACK_LINE(169)
				joints->__GetItem(j->bindIndex)->__Field(HX_CSTRING("groups"),true)->__Field(HX_CSTRING("push"),true)(g);
			}
		}
	}

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	int run(Dynamic j1,Dynamic j2){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h3d/anim/Skin.hx",170,0xee0056d9)
		HX_STACK_ARG(j1,"j1")
		HX_STACK_ARG(j2,"j2")
		{
			HX_STACK_LINE(170)
			return (j2->__Field(HX_CSTRING("groups"),true)->__Field(HX_CSTRING("length"),true) - j1->__Field(HX_CSTRING("groups"),true)->__Field(HX_CSTRING("length"),true));
		}
		return null();
	}
	HX_END_LOCAL_FUNC2(return)

	HX_STACK_LINE(170)
	joints->__Field(HX_CSTRING("sort"),true)( Dynamic(new _Function_1_1()));
	HX_STACK_LINE(171)
	{
		HX_STACK_LINE(171)
		int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(171)
		while((true)){
			HX_STACK_LINE(171)
			if ((!(((_g2 < joints->__Field(HX_CSTRING("length"),true)))))){
				HX_STACK_LINE(171)
				break;
			}
			HX_STACK_LINE(171)
			Dynamic j = joints->__GetItem(_g2);		HX_STACK_VAR(j,"j");
			HX_STACK_LINE(171)
			++(_g2);
			HX_STACK_LINE(172)
			{
				HX_STACK_LINE(172)
				int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(172)
				while((true)){
					HX_STACK_LINE(172)
					if ((!(((_g3 < maxBones))))){
						HX_STACK_LINE(172)
						break;
					}
					HX_STACK_LINE(172)
					int i = (_g3)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(173)
					bool ok = true;		HX_STACK_VAR(ok,"ok");
					HX_STACK_LINE(174)
					{
						HX_STACK_LINE(174)
						int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(174)
						Dynamic _g5 = j->__Field(HX_CSTRING("groups"),true);		HX_STACK_VAR(_g5,"_g5");
						HX_STACK_LINE(174)
						while((true)){
							HX_STACK_LINE(174)
							if ((!(((_g4 < _g5->__Field(HX_CSTRING("length"),true)))))){
								HX_STACK_LINE(174)
								break;
							}
							HX_STACK_LINE(174)
							Dynamic g = _g5->__GetItem(_g4);		HX_STACK_VAR(g,"g");
							HX_STACK_LINE(174)
							++(_g4);
							HX_STACK_LINE(175)
							if (((g->__Field(HX_CSTRING("reserved"),true)->__GetItem(i) != null()))){
								HX_STACK_LINE(176)
								ok = false;
								HX_STACK_LINE(177)
								break;
							}
						}
					}
					HX_STACK_LINE(179)
					if ((ok)){
						HX_STACK_LINE(180)
						j->__Field(HX_CSTRING("j"),true)->__FieldRef(HX_CSTRING("splitIndex")) = i;
						HX_STACK_LINE(181)
						{
							HX_STACK_LINE(181)
							int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
							HX_STACK_LINE(181)
							Dynamic _g5 = j->__Field(HX_CSTRING("groups"),true);		HX_STACK_VAR(_g5,"_g5");
							HX_STACK_LINE(181)
							while((true)){
								HX_STACK_LINE(181)
								if ((!(((_g4 < _g5->__Field(HX_CSTRING("length"),true)))))){
									HX_STACK_LINE(181)
									break;
								}
								HX_STACK_LINE(181)
								Dynamic g = _g5->__GetItem(_g4);		HX_STACK_VAR(g,"g");
								HX_STACK_LINE(181)
								++(_g4);
								HX_STACK_LINE(182)
								hx::IndexRef((g->__Field(HX_CSTRING("reserved"),true)).mPtr,i) = j->__Field(HX_CSTRING("j"),true);
							}
						}
						HX_STACK_LINE(183)
						break;
					}
				}
			}
			HX_STACK_LINE(189)
			if (((j->__Field(HX_CSTRING("j"),true)->__Field(HX_CSTRING("splitIndex"),true) < (int)0))){
				HX_STACK_LINE(189)
				HX_STACK_DO_THROW(HX_CSTRING("Bone conflict while spliting groups"));
			}
		}
	}
	HX_STACK_LINE(193)
	this->splitJoints = Array_obj< ::Dynamic >::__new();
	HX_STACK_LINE(194)
	{
		HX_STACK_LINE(194)
		int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(194)
		while((true)){
			HX_STACK_LINE(194)
			if ((!(((_g2 < groups->__Field(HX_CSTRING("length"),true)))))){
				HX_STACK_LINE(194)
				break;
			}
			HX_STACK_LINE(194)
			Dynamic g = groups->__GetItem(_g2);		HX_STACK_VAR(g,"g");
			HX_STACK_LINE(194)
			++(_g2);
			HX_STACK_LINE(195)
			Array< ::Dynamic > jl = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(jl,"jl");
			HX_STACK_LINE(196)
			{
				HX_STACK_LINE(196)
				int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(196)
				int _g3 = g->__Field(HX_CSTRING("reserved"),true)->__Field(HX_CSTRING("length"),true);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(196)
				while((true)){
					HX_STACK_LINE(196)
					if ((!(((_g4 < _g3))))){
						HX_STACK_LINE(196)
						break;
					}
					HX_STACK_LINE(196)
					int i = (_g4)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(197)
					::h3d::anim::Joint j = g->__Field(HX_CSTRING("reserved"),true)->__GetItem(i);		HX_STACK_VAR(j,"j");
					HX_STACK_LINE(198)
					if (((j == null()))){
						HX_STACK_LINE(198)
						j = this->boundJoints->__get((int)0).StaticCast< ::h3d::anim::Joint >();
					}
					HX_STACK_LINE(199)
					jl->push(j);
				}
			}
			HX_STACK_LINE(201)
			this->splitJoints->push(jl);
		}
	}
	HX_STACK_LINE(205)
	{
		HX_STACK_LINE(205)
		int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(205)
		int _g2 = this->vertexJoints->length;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(205)
		while((true)){
			HX_STACK_LINE(205)
			if ((!(((_g3 < _g2))))){
				HX_STACK_LINE(205)
				break;
			}
			HX_STACK_LINE(205)
			int i = (_g3)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(206)
			this->vertexJoints->__unsafe_set(i,this->boundJoints->__get(this->vertexJoints->__unsafe_get(i)).StaticCast< ::h3d::anim::Joint >()->splitIndex);
		}
	}
	HX_STACK_LINE(208)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC2(Skin_obj,split,return )


Skin_obj::Skin_obj()
{
}

void Skin_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Skin);
	HX_MARK_MEMBER_NAME(vertexCount,"vertexCount");
	HX_MARK_MEMBER_NAME(bonesPerVertex,"bonesPerVertex");
	HX_MARK_MEMBER_NAME(vertexJoints,"vertexJoints");
	HX_MARK_MEMBER_NAME(vertexWeights,"vertexWeights");
	HX_MARK_MEMBER_NAME(rootJoints,"rootJoints");
	HX_MARK_MEMBER_NAME(namedJoints,"namedJoints");
	HX_MARK_MEMBER_NAME(allJoints,"allJoints");
	HX_MARK_MEMBER_NAME(boundJoints,"boundJoints");
	HX_MARK_MEMBER_NAME(primitive,"primitive");
	HX_MARK_MEMBER_NAME(splitJoints,"splitJoints");
	HX_MARK_MEMBER_NAME(triangleGroups,"triangleGroups");
	HX_MARK_MEMBER_NAME(envelop,"envelop");
	HX_MARK_END_CLASS();
}

void Skin_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(vertexCount,"vertexCount");
	HX_VISIT_MEMBER_NAME(bonesPerVertex,"bonesPerVertex");
	HX_VISIT_MEMBER_NAME(vertexJoints,"vertexJoints");
	HX_VISIT_MEMBER_NAME(vertexWeights,"vertexWeights");
	HX_VISIT_MEMBER_NAME(rootJoints,"rootJoints");
	HX_VISIT_MEMBER_NAME(namedJoints,"namedJoints");
	HX_VISIT_MEMBER_NAME(allJoints,"allJoints");
	HX_VISIT_MEMBER_NAME(boundJoints,"boundJoints");
	HX_VISIT_MEMBER_NAME(primitive,"primitive");
	HX_VISIT_MEMBER_NAME(splitJoints,"splitJoints");
	HX_VISIT_MEMBER_NAME(triangleGroups,"triangleGroups");
	HX_VISIT_MEMBER_NAME(envelop,"envelop");
}

Dynamic Skin_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"split") ) { return split_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"envelop") ) { return envelop; }
		if (HX_FIELD_EQ(inName,"isSplit") ) { return isSplit_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allJoints") ) { return allJoints; }
		if (HX_FIELD_EQ(inName,"primitive") ) { return primitive; }
		if (HX_FIELD_EQ(inName,"setJoints") ) { return setJoints_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"rootJoints") ) { return rootJoints; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"vertexCount") ) { return vertexCount; }
		if (HX_FIELD_EQ(inName,"namedJoints") ) { return namedJoints; }
		if (HX_FIELD_EQ(inName,"boundJoints") ) { return boundJoints; }
		if (HX_FIELD_EQ(inName,"splitJoints") ) { return splitJoints; }
		if (HX_FIELD_EQ(inName,"initWeights") ) { return initWeights_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"vertexJoints") ) { return vertexJoints; }
		if (HX_FIELD_EQ(inName,"addInfluence") ) { return addInfluence_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"vertexWeights") ) { return vertexWeights; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"bonesPerVertex") ) { return bonesPerVertex; }
		if (HX_FIELD_EQ(inName,"triangleGroups") ) { return triangleGroups; }
		if (HX_FIELD_EQ(inName,"sortInfluences") ) { return sortInfluences_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Skin_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"envelop") ) { envelop=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"allJoints") ) { allJoints=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"primitive") ) { primitive=inValue.Cast< ::h3d::prim::Primitive >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"rootJoints") ) { rootJoints=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"vertexCount") ) { vertexCount=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"namedJoints") ) { namedJoints=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		if (HX_FIELD_EQ(inName,"boundJoints") ) { boundJoints=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"splitJoints") ) { splitJoints=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"vertexJoints") ) { vertexJoints=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"vertexWeights") ) { vertexWeights=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"bonesPerVertex") ) { bonesPerVertex=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"triangleGroups") ) { triangleGroups=inValue.Cast< Array< int > >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Skin_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("vertexCount"));
	outFields->push(HX_CSTRING("bonesPerVertex"));
	outFields->push(HX_CSTRING("vertexJoints"));
	outFields->push(HX_CSTRING("vertexWeights"));
	outFields->push(HX_CSTRING("rootJoints"));
	outFields->push(HX_CSTRING("namedJoints"));
	outFields->push(HX_CSTRING("allJoints"));
	outFields->push(HX_CSTRING("boundJoints"));
	outFields->push(HX_CSTRING("primitive"));
	outFields->push(HX_CSTRING("splitJoints"));
	outFields->push(HX_CSTRING("triangleGroups"));
	outFields->push(HX_CSTRING("envelop"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(Skin_obj,vertexCount),HX_CSTRING("vertexCount")},
	{hx::fsInt,(int)offsetof(Skin_obj,bonesPerVertex),HX_CSTRING("bonesPerVertex")},
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(Skin_obj,vertexJoints),HX_CSTRING("vertexJoints")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(Skin_obj,vertexWeights),HX_CSTRING("vertexWeights")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,rootJoints),HX_CSTRING("rootJoints")},
	{hx::fsObject /*::haxe::ds::StringMap*/ ,(int)offsetof(Skin_obj,namedJoints),HX_CSTRING("namedJoints")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,allJoints),HX_CSTRING("allJoints")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,boundJoints),HX_CSTRING("boundJoints")},
	{hx::fsObject /*::h3d::prim::Primitive*/ ,(int)offsetof(Skin_obj,primitive),HX_CSTRING("primitive")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,splitJoints),HX_CSTRING("splitJoints")},
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(Skin_obj,triangleGroups),HX_CSTRING("triangleGroups")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(Skin_obj,envelop),HX_CSTRING("envelop")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("vertexCount"),
	HX_CSTRING("bonesPerVertex"),
	HX_CSTRING("vertexJoints"),
	HX_CSTRING("vertexWeights"),
	HX_CSTRING("rootJoints"),
	HX_CSTRING("namedJoints"),
	HX_CSTRING("allJoints"),
	HX_CSTRING("boundJoints"),
	HX_CSTRING("primitive"),
	HX_CSTRING("splitJoints"),
	HX_CSTRING("triangleGroups"),
	HX_CSTRING("envelop"),
	HX_CSTRING("setJoints"),
	HX_CSTRING("addInfluence"),
	HX_CSTRING("sortInfluences"),
	HX_CSTRING("isSplit"),
	HX_CSTRING("initWeights"),
	HX_CSTRING("split"),
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
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.anim.Skin"), hx::TCanCast< Skin_obj> ,sStaticFields,sMemberFields,
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
} // end namespace anim
