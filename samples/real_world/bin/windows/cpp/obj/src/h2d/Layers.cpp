#include <hxcpp.h>

#ifndef INCLUDED_h2d_Layers
#include <h2d/Layers.h>
#endif
#ifndef INCLUDED_h2d_Sprite
#include <h2d/Sprite.h>
#endif
namespace h2d{

Void Layers_obj::__construct(::h2d::Sprite parent)
{
HX_STACK_FRAME("h2d.Layers","new",0xeba41d28,"h2d.Layers.new","h2d/Layers.hx",17,0x17723727)
HX_STACK_THIS(this)
HX_STACK_ARG(parent,"parent")
{
	HX_STACK_LINE(18)
	super::__construct(parent);
	HX_STACK_LINE(19)
	this->layers = Array_obj< int >::__new();
	HX_STACK_LINE(20)
	this->layerCount = (int)0;
}
;
	return null();
}

//Layers_obj::~Layers_obj() { }

Dynamic Layers_obj::__CreateEmpty() { return  new Layers_obj; }
hx::ObjectPtr< Layers_obj > Layers_obj::__new(::h2d::Sprite parent)
{  hx::ObjectPtr< Layers_obj > result = new Layers_obj();
	result->__construct(parent);
	return result;}

Dynamic Layers_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Layers_obj > result = new Layers_obj();
	result->__construct(inArgs[0]);
	return result;}

int Layers_obj::getLayer( ::h2d::Sprite s){
	HX_STACK_FRAME("h2d.Layers","getLayer",0xf913ef93,"h2d.Layers.getLayer","h2d/Layers.hx",23,0x17723727)
	HX_STACK_THIS(this)
	HX_STACK_ARG(s,"s")
	HX_STACK_LINE(24)
	int idx = this->getChildIndex(s);		HX_STACK_VAR(idx,"idx");
	HX_STACK_LINE(25)
	int i = (int)0;		HX_STACK_VAR(i,"i");
	HX_STACK_LINE(26)
	while((true)){
		HX_STACK_LINE(26)
		if ((!(((idx > (int)0))))){
			HX_STACK_LINE(26)
			break;
		}
		HX_STACK_LINE(27)
		int _g = (i)++;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(27)
		int _g1 = this->layers->__get(_g);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(27)
		hx::SubEq(idx,_g1);
	}
	HX_STACK_LINE(29)
	return (i - (int)1);
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,getLayer,return )

int Layers_obj::getLayerStart( int layer){
	HX_STACK_FRAME("h2d.Layers","getLayerStart",0x6af89fcf,"h2d.Layers.getLayerStart","h2d/Layers.hx",33,0x17723727)
	HX_STACK_THIS(this)
	HX_STACK_ARG(layer,"layer")
	HX_STACK_LINE(33)
	return this->layers->__get((layer - (int)1));
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,getLayerStart,return )

int Layers_obj::getLayerCount( int layer){
	HX_STACK_FRAME("h2d.Layers","getLayerCount",0x3150703c,"h2d.Layers.getLayerCount","h2d/Layers.hx",40,0x17723727)
	HX_STACK_THIS(this)
	HX_STACK_ARG(layer,"layer")
	HX_STACK_LINE(40)
	if (((layer == this->layerCount))){
		HX_STACK_LINE(41)
		return (this->childs->length - this->layers->__get((layer - (int)1)));
	}
	else{
		HX_STACK_LINE(43)
		return (this->layers->__get(layer) - this->layers->__get((layer - (int)1)));
	}
	HX_STACK_LINE(40)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,getLayerCount,return )

Void Layers_obj::addChild( ::h2d::Sprite s){
{
		HX_STACK_FRAME("h2d.Layers","addChild",0xe8932df3,"h2d.Layers.addChild","h2d/Layers.hx",51,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(51)
		this->addChildAt(s,(int)0);
	}
return null();
}


Void Layers_obj::add( ::h2d::Sprite s,int layer){
{
		HX_STACK_FRAME("h2d.Layers","add",0xeb9a3ee9,"h2d.Layers.add","h2d/Layers.hx",55,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_ARG(layer,"layer")
		HX_STACK_LINE(55)
		return null(this->addChildAt(s,layer));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Layers_obj,add,(void))

Void Layers_obj::clearLayer( int layer){
{
		HX_STACK_FRAME("h2d.Layers","clearLayer",0x0cc51d3c,"h2d.Layers.clearLayer","h2d/Layers.hx",58,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(layer,"layer")
		HX_STACK_LINE(59)
		int start = this->layers->__get((layer - (int)1));		HX_STACK_VAR(start,"start");
		HX_STACK_LINE(60)
		int idx;		HX_STACK_VAR(idx,"idx");
		HX_STACK_LINE(60)
		idx = (start + ((  (((layer == this->layerCount))) ? int((this->childs->length - this->layers->__get((layer - (int)1)))) : int((this->layers->__get(layer) - this->layers->__get((layer - (int)1)))) )));
		HX_STACK_LINE(61)
		while((true)){
			HX_STACK_LINE(61)
			int _g = (idx)--;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(61)
			if ((!(((_g > start))))){
				HX_STACK_LINE(61)
				break;
			}
			HX_STACK_LINE(62)
			this->removeChildAt(idx);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,clearLayer,(void))

Void Layers_obj::addChildAt( ::h2d::Sprite s,int layer){
{
		HX_STACK_FRAME("h2d.Layers","addChildAt",0x963109c6,"h2d.Layers.addChildAt","h2d/Layers.hx",65,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_ARG(layer,"layer")
		HX_STACK_LINE(66)
		if (((s->parent == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(67)
			bool old = s->allocated;		HX_STACK_VAR(old,"old");
			HX_STACK_LINE(68)
			s->allocated = false;
			HX_STACK_LINE(69)
			this->removeChild(s);
			HX_STACK_LINE(70)
			s->allocated = old;
		}
		HX_STACK_LINE(73)
		while((true)){
			HX_STACK_LINE(73)
			if ((!(((layer >= this->layerCount))))){
				HX_STACK_LINE(73)
				break;
			}
			HX_STACK_LINE(74)
			int _g = (this->layerCount)++;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(74)
			this->layers[_g] = this->childs->length;
		}
		HX_STACK_LINE(75)
		this->super::addChildAt(s,this->layers->__get(layer));
		HX_STACK_LINE(76)
		{
			HX_STACK_LINE(76)
			int _g1 = layer;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(76)
			int _g = this->layerCount;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(76)
			while((true)){
				HX_STACK_LINE(76)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(76)
					break;
				}
				HX_STACK_LINE(76)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(77)
				(this->layers[i])++;
			}
		}
	}
return null();
}


Void Layers_obj::removeChildAt( int i){
{
		HX_STACK_FRAME("h2d.Layers","removeChildAt",0x2451f493,"h2d.Layers.removeChildAt","h2d/Layers.hx",80,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(i,"i")
		HX_STACK_LINE(81)
		::h2d::Sprite s = this->childs->__get(i).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(82)
		this->childs->splice(i,(int)1);
		HX_STACK_LINE(83)
		if ((s->allocated)){
			HX_STACK_LINE(83)
			s->onDelete();
		}
		HX_STACK_LINE(84)
		s->parent = null();
		HX_STACK_LINE(85)
		int k = (this->layerCount - (int)1);		HX_STACK_VAR(k,"k");
		HX_STACK_LINE(86)
		while((true)){
			HX_STACK_LINE(86)
			if ((!(((bool((k >= (int)0)) && bool((this->layers->__get(k) > i))))))){
				HX_STACK_LINE(86)
				break;
			}
			HX_STACK_LINE(87)
			(this->layers[k])--;
			HX_STACK_LINE(88)
			(k)--;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,removeChildAt,(void))

Void Layers_obj::removeChild( ::h2d::Sprite s){
{
		HX_STACK_FRAME("h2d.Layers","removeChild",0x7703db80,"h2d.Layers.removeChild","h2d/Layers.hx",93,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(93)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(93)
		int _g = this->childs->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(93)
		while((true)){
			HX_STACK_LINE(93)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(93)
				break;
			}
			HX_STACK_LINE(93)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(94)
			if (((this->childs->__get(i).StaticCast< ::h2d::Sprite >() == s))){
				HX_STACK_LINE(95)
				this->removeChildAt(i);
				HX_STACK_LINE(96)
				return null();
			}
		}
	}
return null();
}


Void Layers_obj::under( ::h2d::Sprite s){
{
		HX_STACK_FRAME("h2d.Layers","under",0x40769fe0,"h2d.Layers.under","h2d/Layers.hx",102,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(102)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(102)
		int _g = this->childs->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(102)
		while((true)){
			HX_STACK_LINE(102)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(102)
				break;
			}
			HX_STACK_LINE(102)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(103)
			if (((this->childs->__get(i).StaticCast< ::h2d::Sprite >() == s))){
				HX_STACK_LINE(104)
				int pos = (int)0;		HX_STACK_VAR(pos,"pos");
				HX_STACK_LINE(105)
				{
					HX_STACK_LINE(105)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(105)
					Array< int > _g3 = this->layers;		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(105)
					while((true)){
						HX_STACK_LINE(105)
						if ((!(((_g2 < _g3->length))))){
							HX_STACK_LINE(105)
							break;
						}
						HX_STACK_LINE(105)
						int l = _g3->__get(_g2);		HX_STACK_VAR(l,"l");
						HX_STACK_LINE(105)
						++(_g2);
						HX_STACK_LINE(106)
						if (((l > i))){
							HX_STACK_LINE(107)
							break;
						}
						else{
							HX_STACK_LINE(109)
							pos = l;
						}
					}
				}
				HX_STACK_LINE(110)
				int p = i;		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(111)
				while((true)){
					HX_STACK_LINE(111)
					if ((!(((p > pos))))){
						HX_STACK_LINE(111)
						break;
					}
					HX_STACK_LINE(112)
					this->childs[p] = this->childs->__get((p - (int)1)).StaticCast< ::h2d::Sprite >();
					HX_STACK_LINE(113)
					(p)--;
				}
				HX_STACK_LINE(115)
				this->childs[pos] = s;
				HX_STACK_LINE(116)
				break;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,under,(void))

Void Layers_obj::over( ::h2d::Sprite s){
{
		HX_STACK_FRAME("h2d.Layers","over",0x44ab738c,"h2d.Layers.over","h2d/Layers.hx",121,0x17723727)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(121)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(121)
		int _g = this->childs->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(121)
		while((true)){
			HX_STACK_LINE(121)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(121)
				break;
			}
			HX_STACK_LINE(121)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(122)
			if (((this->childs->__get(i).StaticCast< ::h2d::Sprite >() == s))){
				HX_STACK_LINE(123)
				{
					HX_STACK_LINE(123)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(123)
					Array< int > _g3 = this->layers;		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(123)
					while((true)){
						HX_STACK_LINE(123)
						if ((!(((_g2 < _g3->length))))){
							HX_STACK_LINE(123)
							break;
						}
						HX_STACK_LINE(123)
						int l = _g3->__get(_g2);		HX_STACK_VAR(l,"l");
						HX_STACK_LINE(123)
						++(_g2);
						HX_STACK_LINE(124)
						if (((l > i))){
							HX_STACK_LINE(125)
							{
								HX_STACK_LINE(125)
								int _g5 = i;		HX_STACK_VAR(_g5,"_g5");
								HX_STACK_LINE(125)
								int _g4 = (l - (int)1);		HX_STACK_VAR(_g4,"_g4");
								HX_STACK_LINE(125)
								while((true)){
									HX_STACK_LINE(125)
									if ((!(((_g5 < _g4))))){
										HX_STACK_LINE(125)
										break;
									}
									HX_STACK_LINE(125)
									int p = (_g5)++;		HX_STACK_VAR(p,"p");
									HX_STACK_LINE(126)
									this->childs[p] = this->childs->__get((p + (int)1)).StaticCast< ::h2d::Sprite >();
								}
							}
							HX_STACK_LINE(127)
							this->childs[(l - (int)1)] = s;
							HX_STACK_LINE(128)
							break;
						}
					}
				}
				HX_STACK_LINE(130)
				break;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,over,(void))

Void Layers_obj::ysort( hx::Null< int >  __o_layer){
int layer = __o_layer.Default(0);
	HX_STACK_FRAME("h2d.Layers","ysort",0x9167671f,"h2d.Layers.ysort","h2d/Layers.hx",134,0x17723727)
	HX_STACK_THIS(this)
	HX_STACK_ARG(layer,"layer")
{
		HX_STACK_LINE(135)
		if (((layer >= this->layerCount))){
			HX_STACK_LINE(135)
			return null();
		}
		HX_STACK_LINE(136)
		int start;		HX_STACK_VAR(start,"start");
		HX_STACK_LINE(136)
		if (((layer == (int)0))){
			HX_STACK_LINE(136)
			start = (int)0;
		}
		else{
			HX_STACK_LINE(136)
			start = this->layers->__get((layer - (int)1));
		}
		HX_STACK_LINE(137)
		int max = this->layers->__get(layer);		HX_STACK_VAR(max,"max");
		HX_STACK_LINE(138)
		if (((start == max))){
			HX_STACK_LINE(139)
			return null();
		}
		HX_STACK_LINE(140)
		int pos = start;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(141)
		int _g = (pos)++;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(141)
		Float ymax = this->childs->__get(_g).StaticCast< ::h2d::Sprite >()->y;		HX_STACK_VAR(ymax,"ymax");
		HX_STACK_LINE(142)
		while((true)){
			HX_STACK_LINE(142)
			if ((!(((pos < max))))){
				HX_STACK_LINE(142)
				break;
			}
			HX_STACK_LINE(143)
			::h2d::Sprite c = this->childs->__get(pos).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(144)
			if (((c->y < ymax))){
				HX_STACK_LINE(145)
				int p = (pos - (int)1);		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(146)
				while((true)){
					HX_STACK_LINE(146)
					if ((!(((p >= start))))){
						HX_STACK_LINE(146)
						break;
					}
					HX_STACK_LINE(147)
					::h2d::Sprite c2 = this->childs->__get(p).StaticCast< ::h2d::Sprite >();		HX_STACK_VAR(c2,"c2");
					HX_STACK_LINE(148)
					if (((c->y >= c2->y))){
						HX_STACK_LINE(148)
						break;
					}
					HX_STACK_LINE(149)
					this->childs[(p + (int)1)] = c2;
					HX_STACK_LINE(150)
					(p)--;
				}
				HX_STACK_LINE(152)
				this->childs[(p + (int)1)] = c;
			}
			else{
				HX_STACK_LINE(154)
				ymax = c->y;
			}
			HX_STACK_LINE(155)
			(pos)++;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Layers_obj,ysort,(void))


Layers_obj::Layers_obj()
{
}

void Layers_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Layers);
	HX_MARK_MEMBER_NAME(layers,"layers");
	HX_MARK_MEMBER_NAME(layerCount,"layerCount");
	::h2d::Sprite_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Layers_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(layers,"layers");
	HX_VISIT_MEMBER_NAME(layerCount,"layerCount");
	::h2d::Sprite_obj::__Visit(HX_VISIT_ARG);
}

Dynamic Layers_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"over") ) { return over_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"under") ) { return under_dyn(); }
		if (HX_FIELD_EQ(inName,"ysort") ) { return ysort_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"layers") ) { return layers; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getLayer") ) { return getLayer_dyn(); }
		if (HX_FIELD_EQ(inName,"addChild") ) { return addChild_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"layerCount") ) { return layerCount; }
		if (HX_FIELD_EQ(inName,"clearLayer") ) { return clearLayer_dyn(); }
		if (HX_FIELD_EQ(inName,"addChildAt") ) { return addChildAt_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"removeChild") ) { return removeChild_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getLayerStart") ) { return getLayerStart_dyn(); }
		if (HX_FIELD_EQ(inName,"getLayerCount") ) { return getLayerCount_dyn(); }
		if (HX_FIELD_EQ(inName,"removeChildAt") ) { return removeChildAt_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Layers_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"layers") ) { layers=inValue.Cast< Array< int > >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"layerCount") ) { layerCount=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Layers_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("layers"));
	outFields->push(HX_CSTRING("layerCount"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*Array< int >*/ ,(int)offsetof(Layers_obj,layers),HX_CSTRING("layers")},
	{hx::fsInt,(int)offsetof(Layers_obj,layerCount),HX_CSTRING("layerCount")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("layers"),
	HX_CSTRING("layerCount"),
	HX_CSTRING("getLayer"),
	HX_CSTRING("getLayerStart"),
	HX_CSTRING("getLayerCount"),
	HX_CSTRING("addChild"),
	HX_CSTRING("add"),
	HX_CSTRING("clearLayer"),
	HX_CSTRING("addChildAt"),
	HX_CSTRING("removeChildAt"),
	HX_CSTRING("removeChild"),
	HX_CSTRING("under"),
	HX_CSTRING("over"),
	HX_CSTRING("ysort"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Layers_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Layers_obj::__mClass,"__mClass");
};

#endif

Class Layers_obj::__mClass;

void Layers_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h2d.Layers"), hx::TCanCast< Layers_obj> ,sStaticFields,sMemberFields,
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

void Layers_obj::__boot()
{
}

} // end namespace h2d
