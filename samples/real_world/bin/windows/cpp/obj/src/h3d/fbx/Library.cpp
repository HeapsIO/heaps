#include <hxcpp.h>

#ifndef INCLUDED_IMap
#include <IMap.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_h2d_Tile
#include <h2d/Tile.h>
#endif
#ifndef INCLUDED_h3d_Matrix
#include <h3d/Matrix.h>
#endif
#ifndef INCLUDED_h3d_Quat
#include <h3d/Quat.h>
#endif
#ifndef INCLUDED_h3d_anim_AnimatedObject
#include <h3d/anim/AnimatedObject.h>
#endif
#ifndef INCLUDED_h3d_anim_Animation
#include <h3d/anim/Animation.h>
#endif
#ifndef INCLUDED_h3d_anim_FrameAnimation
#include <h3d/anim/FrameAnimation.h>
#endif
#ifndef INCLUDED_h3d_anim_Joint
#include <h3d/anim/Joint.h>
#endif
#ifndef INCLUDED_h3d_anim_LinearAnimation
#include <h3d/anim/LinearAnimation.h>
#endif
#ifndef INCLUDED_h3d_anim_LinearFrame
#include <h3d/anim/LinearFrame.h>
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
#ifndef INCLUDED_h3d_anim_Skin
#include <h3d/anim/Skin.h>
#endif
#ifndef INCLUDED_h3d_anim__Skin_Influence
#include <h3d/anim/_Skin/Influence.h>
#endif
#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
#ifndef INCLUDED_h3d_fbx_AnimationMode
#include <h3d/fbx/AnimationMode.h>
#endif
#ifndef INCLUDED_h3d_fbx_DefaultMatrixes
#include <h3d/fbx/DefaultMatrixes.h>
#endif
#ifndef INCLUDED_h3d_fbx_FBxTools
#include <h3d/fbx/FBxTools.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxNode
#include <h3d/fbx/FbxNode.h>
#endif
#ifndef INCLUDED_h3d_fbx_FbxProp
#include <h3d/fbx/FbxProp.h>
#endif
#ifndef INCLUDED_h3d_fbx_Geometry
#include <h3d/fbx/Geometry.h>
#endif
#ifndef INCLUDED_h3d_fbx_Library
#include <h3d/fbx/Library.h>
#endif
#ifndef INCLUDED_h3d_fbx_Parser
#include <h3d/fbx/Parser.h>
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
#ifndef INCLUDED_h3d_mat_Texture
#include <h3d/mat/Texture.h>
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
#ifndef INCLUDED_h3d_scene_MultiMaterial
#include <h3d/scene/MultiMaterial.h>
#endif
#ifndef INCLUDED_h3d_scene_Object
#include <h3d/scene/Object.h>
#endif
#ifndef INCLUDED_h3d_scene_Skin
#include <h3d/scene/Skin.h>
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
namespace fbx{

Void Library_obj::__construct()
{
HX_STACK_FRAME("h3d.fbx.Library","new",0x88574e66,"h3d.fbx.Library.new","h3d/fbx/Library.hx",71,0x38e70acc)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(97)
	this->maxBonesPerSkin = (int)34;
	HX_STACK_LINE(92)
	this->bonesPerVertex = (int)3;
	HX_STACK_LINE(106)
	::h3d::fbx::FbxNode _g = ::h3d::fbx::FbxNode_obj::__new(HX_CSTRING("Root"),Array_obj< ::Dynamic >::__new(),Array_obj< ::Dynamic >::__new());		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(106)
	this->root = _g;
	HX_STACK_LINE(107)
	::haxe::ds::StringMap _g1 = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(107)
	this->keepJoints = _g1;
	HX_STACK_LINE(108)
	::haxe::ds::StringMap _g2 = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(108)
	this->skipObjects = _g2;
	HX_STACK_LINE(109)
	this->reset();
}
;
	return null();
}

//Library_obj::~Library_obj() { }

Dynamic Library_obj::__CreateEmpty() { return  new Library_obj; }
hx::ObjectPtr< Library_obj > Library_obj::__new()
{  hx::ObjectPtr< Library_obj > result = new Library_obj();
	result->__construct();
	return result;}

Dynamic Library_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Library_obj > result = new Library_obj();
	result->__construct();
	return result;}

Void Library_obj::reset( ){
{
		HX_STACK_FRAME("h3d.fbx.Library","reset",0x152bd555,"h3d.fbx.Library.reset","h3d/fbx/Library.hx",112,0x38e70acc)
		HX_STACK_THIS(this)
		HX_STACK_LINE(113)
		::haxe::ds::IntMap _g = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(113)
		this->ids = _g;
		HX_STACK_LINE(114)
		::haxe::ds::IntMap _g1 = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(114)
		this->connect = _g1;
		HX_STACK_LINE(115)
		::haxe::ds::IntMap _g2 = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(115)
		this->invConnect = _g2;
		HX_STACK_LINE(116)
		::haxe::ds::StringMap _g3 = ::haxe::ds::StringMap_obj::__new();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(116)
		this->defaultModelMatrixes = _g3;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Library_obj,reset,(void))

Void Library_obj::loadTextFile( ::String data){
{
		HX_STACK_FRAME("h3d.fbx.Library","loadTextFile",0x087b9f49,"h3d.fbx.Library.loadTextFile","h3d/fbx/Library.hx",119,0x38e70acc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(data,"data")
		HX_STACK_LINE(120)
		::h3d::fbx::FbxNode _g = ::h3d::fbx::Parser_obj::parse(data);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(120)
		this->load(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,loadTextFile,(void))

Void Library_obj::load( ::h3d::fbx::FbxNode root){
{
		HX_STACK_FRAME("h3d.fbx.Library","load",0xc2c26160,"h3d.fbx.Library.load","h3d/fbx/Library.hx",123,0x38e70acc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(root,"root")
		HX_STACK_LINE(124)
		this->reset();
		HX_STACK_LINE(125)
		this->root = root;
		HX_STACK_LINE(126)
		{
			HX_STACK_LINE(126)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(126)
			Array< ::Dynamic > _g1 = root->childs;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(126)
			while((true)){
				HX_STACK_LINE(126)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(126)
					break;
				}
				HX_STACK_LINE(126)
				::h3d::fbx::FbxNode c = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(126)
				++(_g);
				HX_STACK_LINE(127)
				this->init(c);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,load,(void))

Void Library_obj::convertPoints( Array< Float > a){
{
		HX_STACK_FRAME("h3d.fbx.Library","convertPoints",0x7a4b7dfc,"h3d.fbx.Library.convertPoints","h3d/fbx/Library.hx",130,0x38e70acc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(131)
		int p = (int)0;		HX_STACK_VAR(p,"p");
		HX_STACK_LINE(132)
		{
			HX_STACK_LINE(132)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(132)
			int _g = ::Std_obj::_int((Float(a->length) / Float((int)3)));		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(132)
			while((true)){
				HX_STACK_LINE(132)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(132)
					break;
				}
				HX_STACK_LINE(132)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(133)
				a[p] = -(a->__get(p));
				HX_STACK_LINE(134)
				hx::AddEq(p,(int)3);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,convertPoints,(void))

Void Library_obj::leftHandConvert( ){
{
		HX_STACK_FRAME("h3d.fbx.Library","leftHandConvert",0x9d14d483,"h3d.fbx.Library.leftHandConvert","h3d/fbx/Library.hx",138,0x38e70acc)
		HX_STACK_THIS(this)
		HX_STACK_LINE(139)
		if ((this->leftHand)){
			HX_STACK_LINE(139)
			return null();
		}
		HX_STACK_LINE(140)
		this->leftHand = true;
		HX_STACK_LINE(141)
		{
			HX_STACK_LINE(141)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(141)
			Array< ::Dynamic > _g1 = this->root->getAll(HX_CSTRING("Objects.Geometry"));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(141)
			while((true)){
				HX_STACK_LINE(141)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(141)
					break;
				}
				HX_STACK_LINE(141)
				::h3d::fbx::FbxNode g = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(g,"g");
				HX_STACK_LINE(141)
				++(_g);
				HX_STACK_LINE(142)
				{
					HX_STACK_LINE(142)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(142)
					Array< ::Dynamic > _g3 = g->getAll(HX_CSTRING("Vertices"));		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(142)
					while((true)){
						HX_STACK_LINE(142)
						if ((!(((_g2 < _g3->length))))){
							HX_STACK_LINE(142)
							break;
						}
						HX_STACK_LINE(142)
						::h3d::fbx::FbxNode v = _g3->__get(_g2).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(v,"v");
						HX_STACK_LINE(142)
						++(_g2);
						HX_STACK_LINE(143)
						Array< Float > _g4 = v->getFloats();		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(143)
						this->convertPoints(_g4);
					}
				}
				HX_STACK_LINE(144)
				{
					HX_STACK_LINE(144)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(144)
					Array< ::Dynamic > _g3 = g->getAll(HX_CSTRING("LayerElementNormal.Normals"));		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(144)
					while((true)){
						HX_STACK_LINE(144)
						if ((!(((_g2 < _g3->length))))){
							HX_STACK_LINE(144)
							break;
						}
						HX_STACK_LINE(144)
						::h3d::fbx::FbxNode v = _g3->__get(_g2).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(v,"v");
						HX_STACK_LINE(144)
						++(_g2);
						HX_STACK_LINE(145)
						Array< Float > _g11 = v->getFloats();		HX_STACK_VAR(_g11,"_g11");
						HX_STACK_LINE(145)
						this->convertPoints(_g11);
					}
				}
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Library_obj,leftHandConvert,(void))

Void Library_obj::init( ::h3d::fbx::FbxNode n){
{
		HX_STACK_FRAME("h3d.fbx.Library","init",0xc0c6024a,"h3d.fbx.Library.init","h3d/fbx/Library.hx",150,0x38e70acc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(n,"n")
		HX_STACK_LINE(150)
		::String _g = n->name;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(150)
		::String _switch_1 = (_g);
		if (  ( _switch_1==HX_CSTRING("Connections"))){
			HX_STACK_LINE(152)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(152)
			Array< ::Dynamic > _g2 = n->childs;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(152)
			while((true)){
				HX_STACK_LINE(152)
				if ((!(((_g1 < _g2->length))))){
					HX_STACK_LINE(152)
					break;
				}
				HX_STACK_LINE(152)
				::h3d::fbx::FbxNode c = _g2->__get(_g1).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(152)
				++(_g1);
				HX_STACK_LINE(153)
				if (((c->name != HX_CSTRING("C")))){
					HX_STACK_LINE(154)
					continue;
				}
				HX_STACK_LINE(155)
				int child = ::h3d::fbx::FBxTools_obj::toInt(c->props->__get((int)1).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(child,"child");
				HX_STACK_LINE(156)
				int parent = ::h3d::fbx::FBxTools_obj::toInt(c->props->__get((int)2).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(parent,"parent");
				HX_STACK_LINE(158)
				Array< int > c1 = this->connect->get(parent);		HX_STACK_VAR(c1,"c1");
				HX_STACK_LINE(159)
				if (((c1 == null()))){
					HX_STACK_LINE(160)
					c1 = Array_obj< int >::__new();
					HX_STACK_LINE(161)
					this->connect->set(parent,c1);
				}
				HX_STACK_LINE(163)
				c1->push(child);
				HX_STACK_LINE(165)
				if (((parent == (int)0))){
					HX_STACK_LINE(166)
					continue;
				}
				HX_STACK_LINE(168)
				Array< int > c2 = this->invConnect->get(child);		HX_STACK_VAR(c2,"c2");
				HX_STACK_LINE(169)
				if (((c2 == null()))){
					HX_STACK_LINE(170)
					c2 = Array_obj< int >::__new();
					HX_STACK_LINE(171)
					this->invConnect->set(child,c2);
				}
				HX_STACK_LINE(173)
				c2->push(parent);
			}
		}
		else if (  ( _switch_1==HX_CSTRING("Objects"))){
			HX_STACK_LINE(176)
			int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(176)
			Array< ::Dynamic > _g2 = n->childs;		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(176)
			while((true)){
				HX_STACK_LINE(176)
				if ((!(((_g1 < _g2->length))))){
					HX_STACK_LINE(176)
					break;
				}
				HX_STACK_LINE(176)
				::h3d::fbx::FbxNode c = _g2->__get(_g1).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(c,"c");
				HX_STACK_LINE(176)
				++(_g1);
				HX_STACK_LINE(177)
				int key = c->getId();		HX_STACK_VAR(key,"key");
				HX_STACK_LINE(177)
				this->ids->set(key,c);
			}
		}
		else  {
		}
;
;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,init,(void))

::h3d::fbx::Geometry Library_obj::getGeometry( ::String __o_name){
::String name = __o_name.Default(HX_CSTRING(""));
	HX_STACK_FRAME("h3d.fbx.Library","getGeometry",0x7ef6b96e,"h3d.fbx.Library.getGeometry","h3d/fbx/Library.hx",182,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
{
		HX_STACK_LINE(183)
		::h3d::fbx::FbxNode geom = null();		HX_STACK_VAR(geom,"geom");
		HX_STACK_LINE(184)
		{
			HX_STACK_LINE(184)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(184)
			Array< ::Dynamic > _g1 = this->root->getAll(HX_CSTRING("Objects.Geometry"));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(184)
			while((true)){
				HX_STACK_LINE(184)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(184)
					break;
				}
				HX_STACK_LINE(184)
				::h3d::fbx::FbxNode g = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(g,"g");
				HX_STACK_LINE(184)
				++(_g);
				HX_STACK_LINE(185)
				::h3d::fbx::FbxProp _g2 = ::h3d::fbx::FbxProp_obj::PString((HX_CSTRING("Geometry::") + name));		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(185)
				if ((g->hasProp(_g2))){
					HX_STACK_LINE(186)
					geom = g;
					HX_STACK_LINE(187)
					break;
				}
			}
		}
		HX_STACK_LINE(189)
		if (((geom == null()))){
			HX_STACK_LINE(190)
			HX_STACK_DO_THROW(((HX_CSTRING("Geometry ") + name) + HX_CSTRING(" not found")));
		}
		HX_STACK_LINE(191)
		return ::h3d::fbx::Geometry_obj::__new(hx::ObjectPtr<OBJ_>(this),geom);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,getGeometry,return )

Array< ::Dynamic > Library_obj::collectByName( ::String nodeName){
	HX_STACK_FRAME("h3d.fbx.Library","collectByName",0xb2d16292,"h3d.fbx.Library.collectByName","h3d/fbx/Library.hx",194,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(nodeName,"nodeName")
	HX_STACK_LINE(195)
	Array< ::Dynamic > r = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(r,"r");
	HX_STACK_LINE(196)
	for(::cpp::FastIterator_obj< ::h3d::fbx::FbxNode > *__it = ::cpp::CreateFastIterator< ::h3d::fbx::FbxNode >(this->ids->iterator());  __it->hasNext(); ){
		::h3d::fbx::FbxNode n = __it->next();
		if (((n->name == nodeName))){
			HX_STACK_LINE(198)
			r->push(n);
		}
;
	}
	HX_STACK_LINE(200)
	return r;
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,collectByName,return )

::h3d::fbx::FbxNode Library_obj::getParent( ::h3d::fbx::FbxNode node,::String nodeName,Dynamic opt){
	HX_STACK_FRAME("h3d.fbx.Library","getParent",0xe00b54e6,"h3d.fbx.Library.getParent","h3d/fbx/Library.hx",204,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_ARG(nodeName,"nodeName")
	HX_STACK_ARG(opt,"opt")
	HX_STACK_LINE(205)
	Array< ::Dynamic > p = this->getParents(node,nodeName);		HX_STACK_VAR(p,"p");
	HX_STACK_LINE(206)
	if (((p->length > (int)1))){
		HX_STACK_LINE(207)
		::String _g = node->getName();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(207)
		::String _g1 = (_g + HX_CSTRING(" has "));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(207)
		::String _g2 = (_g1 + p->length);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(207)
		::String _g3 = (_g2 + HX_CSTRING(" "));		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(207)
		::String _g4 = (_g3 + nodeName);		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(207)
		HX_STACK_DO_THROW((_g4 + HX_CSTRING(" parents")));
	}
	HX_STACK_LINE(208)
	if (((bool((p->length == (int)0)) && bool(!(opt))))){
		HX_STACK_LINE(209)
		Array< ::Dynamic > allParents = this->getParents(node,null());		HX_STACK_VAR(allParents,"allParents");
		HX_STACK_LINE(210)
		Dynamic hierarch = this->dumpParents(node,null(),null());		HX_STACK_VAR(hierarch,"hierarch");
		HX_STACK_LINE(212)
		::String _g5 = node->getName();		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(212)
		::String _g6 = (HX_CSTRING("Missing ") + _g5);		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(212)
		::String _g7 = (_g6 + HX_CSTRING(" "));		HX_STACK_VAR(_g7,"_g7");
		HX_STACK_LINE(212)
		::String _g8 = (_g7 + nodeName);		HX_STACK_VAR(_g8,"_g8");
		HX_STACK_LINE(212)
		::String _g9 = (_g8 + HX_CSTRING(" parent among "));		HX_STACK_VAR(_g9,"_g9");
		HX_STACK_LINE(212)
		::String _g10 = ::Std_obj::string(allParents);		HX_STACK_VAR(_g10,"_g10");
		HX_STACK_LINE(212)
		::String _g11 = (_g9 + _g10);		HX_STACK_VAR(_g11,"_g11");
		HX_STACK_LINE(212)
		HX_STACK_DO_THROW((_g11 + HX_CSTRING(".")));
	}
	HX_STACK_LINE(214)
	return p->__get((int)0).StaticCast< ::h3d::fbx::FbxNode >();
}


HX_DEFINE_DYNAMIC_FUNC3(Library_obj,getParent,return )

bool Library_obj::hasChild( ::h3d::fbx::FbxNode node,::String nodeName){
	HX_STACK_FRAME("h3d.fbx.Library","hasChild",0xbcc9e01c,"h3d.fbx.Library.hasChild","h3d/fbx/Library.hx",217,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_ARG(nodeName,"nodeName")
	HX_STACK_LINE(218)
	Array< int > c;		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(218)
	{
		HX_STACK_LINE(218)
		int key = node->getId();		HX_STACK_VAR(key,"key");
		HX_STACK_LINE(218)
		c = this->connect->get(key);
	}
	HX_STACK_LINE(219)
	if (((c != null()))){
		HX_STACK_LINE(220)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(220)
		while((true)){
			HX_STACK_LINE(220)
			if ((!(((_g < c->length))))){
				HX_STACK_LINE(220)
				break;
			}
			HX_STACK_LINE(220)
			int id = c->__get(_g);		HX_STACK_VAR(id,"id");
			HX_STACK_LINE(220)
			++(_g);
			HX_STACK_LINE(221)
			::h3d::fbx::FbxNode n = this->ids->get(id);		HX_STACK_VAR(n,"n");
			HX_STACK_LINE(222)
			if (((n == null()))){
				HX_STACK_LINE(222)
				HX_STACK_DO_THROW((id + HX_CSTRING(" not found")));
			}
			HX_STACK_LINE(223)
			if (((bool((nodeName != null())) && bool((n->name != nodeName))))){
				HX_STACK_LINE(224)
				continue;
			}
			HX_STACK_LINE(225)
			return true;
		}
	}
	HX_STACK_LINE(228)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC2(Library_obj,hasChild,return )

::h3d::fbx::FbxNode Library_obj::getChild( ::h3d::fbx::FbxNode node,::String nodeName,Dynamic opt){
	HX_STACK_FRAME("h3d.fbx.Library","getChild",0x9048a560,"h3d.fbx.Library.getChild","h3d/fbx/Library.hx",231,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_ARG(nodeName,"nodeName")
	HX_STACK_ARG(opt,"opt")
	HX_STACK_LINE(232)
	Array< int > c;		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(232)
	{
		HX_STACK_LINE(232)
		int key = node->getId();		HX_STACK_VAR(key,"key");
		HX_STACK_LINE(232)
		c = this->connect->get(key);
	}
	HX_STACK_LINE(233)
	if (((c != null()))){
		HX_STACK_LINE(234)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(234)
		while((true)){
			HX_STACK_LINE(234)
			if ((!(((_g < c->length))))){
				HX_STACK_LINE(234)
				break;
			}
			HX_STACK_LINE(234)
			int id = c->__get(_g);		HX_STACK_VAR(id,"id");
			HX_STACK_LINE(234)
			++(_g);
			HX_STACK_LINE(235)
			::h3d::fbx::FbxNode n = this->ids->get(id);		HX_STACK_VAR(n,"n");
			HX_STACK_LINE(236)
			if (((n == null()))){
				HX_STACK_LINE(236)
				HX_STACK_DO_THROW((id + HX_CSTRING(" not found")));
			}
			HX_STACK_LINE(237)
			if (((bool((nodeName != null())) && bool((n->name != nodeName))))){
				HX_STACK_LINE(238)
				continue;
			}
			HX_STACK_LINE(239)
			return n;
		}
	}
	HX_STACK_LINE(241)
	::String _g = node->getName();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(241)
	::String _g1 = (HX_CSTRING("Missing ") + _g);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(241)
	::String _g2 = (_g1 + HX_CSTRING(" "));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(241)
	::String _g3 = (_g2 + nodeName);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(241)
	HX_STACK_DO_THROW((_g3 + HX_CSTRING(" child")));
	HX_STACK_LINE(241)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Library_obj,getChild,return )

Array< ::Dynamic > Library_obj::getChilds( ::h3d::fbx::FbxNode node,::String nodeName){
	HX_STACK_FRAME("h3d.fbx.Library","getChilds",0xaf480f13,"h3d.fbx.Library.getChilds","h3d/fbx/Library.hx",244,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_ARG(nodeName,"nodeName")
	HX_STACK_LINE(245)
	Array< int > c;		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(245)
	{
		HX_STACK_LINE(245)
		int key = node->getId();		HX_STACK_VAR(key,"key");
		HX_STACK_LINE(245)
		c = this->connect->get(key);
	}
	HX_STACK_LINE(246)
	Array< ::Dynamic > subs = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(subs,"subs");
	HX_STACK_LINE(247)
	if (((c != null()))){
		HX_STACK_LINE(248)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(248)
		while((true)){
			HX_STACK_LINE(248)
			if ((!(((_g < c->length))))){
				HX_STACK_LINE(248)
				break;
			}
			HX_STACK_LINE(248)
			int id = c->__get(_g);		HX_STACK_VAR(id,"id");
			HX_STACK_LINE(248)
			++(_g);
			HX_STACK_LINE(249)
			::h3d::fbx::FbxNode n = this->ids->get(id);		HX_STACK_VAR(n,"n");
			HX_STACK_LINE(250)
			if (((n == null()))){
				HX_STACK_LINE(250)
				HX_STACK_DO_THROW((id + HX_CSTRING(" not found")));
			}
			HX_STACK_LINE(251)
			if (((bool((nodeName != null())) && bool((n->name != nodeName))))){
				HX_STACK_LINE(252)
				continue;
			}
			HX_STACK_LINE(253)
			subs->push(n);
		}
	}
	HX_STACK_LINE(255)
	return subs;
}


HX_DEFINE_DYNAMIC_FUNC2(Library_obj,getChilds,return )

Dynamic Library_obj::dumpParents( ::h3d::fbx::FbxNode node,Dynamic rep,Dynamic __o_depth){
Dynamic depth = __o_depth.Default(0);
	HX_STACK_FRAME("h3d.fbx.Library","dumpParents",0x4437ed3b,"h3d.fbx.Library.dumpParents","h3d/fbx/Library.hx",259,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_ARG(rep,"rep")
	HX_STACK_ARG(depth,"depth")
{
		HX_STACK_LINE(260)
		if (((rep == null()))){
			HX_STACK_LINE(260)
			rep = Dynamic( Array_obj<Dynamic>::__new());
		}
		HX_STACK_LINE(261)
		Array< ::Dynamic > ns = this->getParents(node,null());		HX_STACK_VAR(ns,"ns");
		HX_STACK_LINE(262)
		{
			HX_STACK_LINE(262)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(262)
			while((true)){
				HX_STACK_LINE(262)
				if ((!(((_g < ns->length))))){
					HX_STACK_LINE(262)
					break;
				}
				HX_STACK_LINE(262)
				::h3d::fbx::FbxNode n = ns->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(262)
				++(_g);
				struct _Function_3_1{
					inline static Dynamic Block( Dynamic &depth,::h3d::fbx::FbxNode &n){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",263,0x38e70acc)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("depth") , (depth + (int)1),false);
							__result->Add(HX_CSTRING("n") , n,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(263)
				rep->__Field(HX_CSTRING("push"),true)(_Function_3_1::Block(depth,n));
				HX_STACK_LINE(264)
				this->dumpParents(n,rep,(depth + (int)1));
			}
		}
		HX_STACK_LINE(266)
		return rep;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Library_obj,dumpParents,return )

Dynamic Library_obj::dumpChildren( ::h3d::fbx::FbxNode node,Dynamic proc,Dynamic rep,Dynamic __o_depth){
Dynamic depth = __o_depth.Default(0);
	HX_STACK_FRAME("h3d.fbx.Library","dumpChildren",0x103837cd,"h3d.fbx.Library.dumpChildren","h3d/fbx/Library.hx",269,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_ARG(proc,"proc")
	HX_STACK_ARG(rep,"rep")
	HX_STACK_ARG(depth,"depth")
{
		HX_STACK_LINE(270)
		if (((rep == null()))){
			HX_STACK_LINE(270)
			rep = Dynamic( Array_obj<Dynamic>::__new());
		}
		HX_STACK_LINE(271)
		Array< ::Dynamic > ns = this->getChilds(node,null());		HX_STACK_VAR(ns,"ns");
		HX_STACK_LINE(272)
		{
			HX_STACK_LINE(272)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(272)
			while((true)){
				HX_STACK_LINE(272)
				if ((!(((_g < ns->length))))){
					HX_STACK_LINE(272)
					break;
				}
				HX_STACK_LINE(272)
				::h3d::fbx::FbxNode n = ns->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(n,"n");
				HX_STACK_LINE(272)
				++(_g);
				HX_STACK_LINE(273)
				Dynamic _g1 = proc(n);		HX_STACK_VAR(_g1,"_g1");
				struct _Function_3_1{
					inline static Dynamic Block( Dynamic &_g1,Dynamic &depth){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",273,0x38e70acc)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("depth") , (depth + (int)1),false);
							__result->Add(HX_CSTRING("n") , _g1,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(273)
				Dynamic _g11 = _Function_3_1::Block(_g1,depth);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(273)
				rep->__Field(HX_CSTRING("push"),true)(_g11);
				HX_STACK_LINE(274)
				this->dumpChildren(n,proc,rep,(depth + (int)1));
			}
		}
		HX_STACK_LINE(276)
		return rep;
	}
}


HX_DEFINE_DYNAMIC_FUNC4(Library_obj,dumpChildren,return )

Array< ::Dynamic > Library_obj::getParents( ::h3d::fbx::FbxNode node,::String nodeName){
	HX_STACK_FRAME("h3d.fbx.Library","getParents",0x29def4cd,"h3d.fbx.Library.getParents","h3d/fbx/Library.hx",279,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(node,"node")
	HX_STACK_ARG(nodeName,"nodeName")
	HX_STACK_LINE(280)
	int id = node->getId();		HX_STACK_VAR(id,"id");
	HX_STACK_LINE(281)
	Array< int > c = this->invConnect->get(id);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(282)
	Array< ::Dynamic > pl = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(pl,"pl");
	HX_STACK_LINE(283)
	if (((c != null()))){
		HX_STACK_LINE(284)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(284)
		while((true)){
			HX_STACK_LINE(284)
			if ((!(((_g < c->length))))){
				HX_STACK_LINE(284)
				break;
			}
			HX_STACK_LINE(284)
			int id1 = c->__get(_g);		HX_STACK_VAR(id1,"id1");
			HX_STACK_LINE(284)
			++(_g);
			HX_STACK_LINE(285)
			::h3d::fbx::FbxNode n = this->ids->get(id1);		HX_STACK_VAR(n,"n");
			HX_STACK_LINE(286)
			if (((n == null()))){
				HX_STACK_LINE(286)
				HX_STACK_DO_THROW((id1 + HX_CSTRING(" not found")));
			}
			HX_STACK_LINE(287)
			if (((bool((nodeName != null())) && bool((n->name != nodeName))))){
				HX_STACK_LINE(288)
				continue;
			}
			HX_STACK_LINE(290)
			pl->push(n);
		}
	}
	HX_STACK_LINE(293)
	return pl;
}


HX_DEFINE_DYNAMIC_FUNC2(Library_obj,getParents,return )

::h3d::fbx::FbxNode Library_obj::getRoot( ){
	HX_STACK_FRAME("h3d.fbx.Library","getRoot",0x553396de,"h3d.fbx.Library.getRoot","h3d/fbx/Library.hx",297,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_LINE(297)
	return this->root;
}


HX_DEFINE_DYNAMIC_FUNC0(Library_obj,getRoot,return )

Void Library_obj::ignoreMissingObject( ::String name){
{
		HX_STACK_FRAME("h3d.fbx.Library","ignoreMissingObject",0xa82d8059,"h3d.fbx.Library.ignoreMissingObject","h3d/fbx/Library.hx",300,0x38e70acc)
		HX_STACK_THIS(this)
		HX_STACK_ARG(name,"name")
		HX_STACK_LINE(301)
		::h3d::fbx::DefaultMatrixes def = this->defaultModelMatrixes->get(name);		HX_STACK_VAR(def,"def");
		HX_STACK_LINE(302)
		if (((def == null()))){
			HX_STACK_LINE(303)
			::h3d::fbx::DefaultMatrixes _g = ::h3d::fbx::DefaultMatrixes_obj::__new();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(303)
			def = _g;
			HX_STACK_LINE(304)
			def->wasRemoved = (int)-1;
			HX_STACK_LINE(305)
			this->defaultModelMatrixes->set(name,def);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,ignoreMissingObject,(void))

::h3d::anim::Animation Library_obj::loadAnimation( ::h3d::fbx::AnimationMode mode,::String animName,::h3d::fbx::FbxNode root,::h3d::fbx::Library lib){
	HX_STACK_FRAME("h3d.fbx.Library","loadAnimation",0x155e4184,"h3d.fbx.Library.loadAnimation","h3d/fbx/Library.hx",309,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(mode,"mode")
	HX_STACK_ARG(animName,"animName")
	HX_STACK_ARG(root,"root")
	HX_STACK_ARG(lib,"lib")
	HX_STACK_LINE(310)
	::String inAnimName = animName;		HX_STACK_VAR(inAnimName,"inAnimName");
	HX_STACK_LINE(311)
	if (((lib != null()))){
		HX_STACK_LINE(312)
		lib->defaultModelMatrixes = this->defaultModelMatrixes;
		HX_STACK_LINE(313)
		return lib->loadAnimation(mode,animName,null(),null());
	}
	HX_STACK_LINE(315)
	if (((root != null()))){
		HX_STACK_LINE(316)
		::h3d::fbx::Library l = ::h3d::fbx::Library_obj::__new();		HX_STACK_VAR(l,"l");
		HX_STACK_LINE(317)
		l->load(root);
		HX_STACK_LINE(318)
		if ((this->leftHand)){
			HX_STACK_LINE(318)
			l->leftHandConvert();
		}
		HX_STACK_LINE(319)
		l->defaultModelMatrixes = this->defaultModelMatrixes;
		HX_STACK_LINE(320)
		return l->loadAnimation(mode,animName,null(),null());
	}
	HX_STACK_LINE(322)
	::h3d::fbx::FbxNode animNode = null();		HX_STACK_VAR(animNode,"animNode");
	HX_STACK_LINE(323)
	{
		HX_STACK_LINE(323)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(323)
		Array< ::Dynamic > _g1 = this->root->getAll(HX_CSTRING("Objects.AnimationStack"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(323)
		while((true)){
			HX_STACK_LINE(323)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(323)
				break;
			}
			HX_STACK_LINE(323)
			::h3d::fbx::FbxNode a = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(323)
			++(_g);
			struct _Function_3_1{
				inline static bool Block( ::String &animName,::h3d::fbx::FbxNode &a){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",324,0x38e70acc)
					{
						HX_STACK_LINE(324)
						::String _g2 = a->getName();		HX_STACK_VAR(_g2,"_g2");
						HX_STACK_LINE(324)
						return (_g2 == animName);
					}
					return null();
				}
			};
			HX_STACK_LINE(324)
			if (((  ((!(((animName == null()))))) ? bool(_Function_3_1::Block(animName,a)) : bool(true) ))){
				HX_STACK_LINE(325)
				if (((animName == null()))){
					HX_STACK_LINE(325)
					::String _g11 = a->getName();		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(325)
					animName = _g11;
				}
				HX_STACK_LINE(326)
				::h3d::fbx::FbxNode _g2 = this->getChild(a,HX_CSTRING("AnimationLayer"),null());		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(326)
				animNode = _g2;
				HX_STACK_LINE(327)
				break;
			}
		}
	}
	HX_STACK_LINE(329)
	if (((animNode == null()))){
		HX_STACK_LINE(330)
		if (((animName == null()))){
			HX_STACK_LINE(330)
			return null();
		}
		HX_STACK_LINE(331)
		HX_STACK_DO_THROW((HX_CSTRING("Animation not found ") + animName));
	}
	HX_STACK_LINE(334)
	::haxe::ds::IntMap curves = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(curves,"curves");
	HX_STACK_LINE(335)
	::h3d::col::Point P0 = ::h3d::col::Point_obj::__new(null(),null(),null());		HX_STACK_VAR(P0,"P0");
	HX_STACK_LINE(336)
	::h3d::col::Point P1 = ::h3d::col::Point_obj::__new((int)1,(int)1,(int)1);		HX_STACK_VAR(P1,"P1");
	HX_STACK_LINE(337)
	Float F = (Float(::Math_obj::PI) / Float((int)180));		HX_STACK_VAR(F,"F");
	HX_STACK_LINE(338)
	::haxe::ds::IntMap allTimes = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(allTimes,"allTimes");
	HX_STACK_LINE(339)
	{
		HX_STACK_LINE(339)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(339)
		Array< ::Dynamic > _g1 = this->getChilds(animNode,HX_CSTRING("AnimationCurveNode"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(339)
		while((true)){
			HX_STACK_LINE(339)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(339)
				break;
			}
			HX_STACK_LINE(339)
			::h3d::fbx::FbxNode cn = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(cn,"cn");
			HX_STACK_LINE(339)
			++(_g);
			HX_STACK_LINE(340)
			::h3d::fbx::FbxNode model = this->getParent(cn,HX_CSTRING("Model"),true);		HX_STACK_VAR(model,"model");
			HX_STACK_LINE(341)
			if (((model == null()))){
				HX_STACK_LINE(341)
				continue;
			}
			HX_STACK_LINE(343)
			Dynamic c;		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(343)
			{
				HX_STACK_LINE(343)
				int key = model->getId();		HX_STACK_VAR(key,"key");
				HX_STACK_LINE(343)
				c = curves->get(key);
			}
			HX_STACK_LINE(344)
			if (((c == null()))){
				HX_STACK_LINE(345)
				::String name = model->getName();		HX_STACK_VAR(name,"name");
				HX_STACK_LINE(347)
				::String _g3 = model->getType();		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(347)
				if (((  (((_g3 == HX_CSTRING("Null")))) ? bool((this->getChilds(model,HX_CSTRING("Model"))->length == (int)0)) : bool(false) ))){
					HX_STACK_LINE(348)
					continue;
				}
				HX_STACK_LINE(349)
				::h3d::fbx::DefaultMatrixes def = this->defaultModelMatrixes->get(name);		HX_STACK_VAR(def,"def");
				HX_STACK_LINE(350)
				if (((def == null()))){
					HX_STACK_LINE(351)
					HX_STACK_DO_THROW((((HX_CSTRING("Default Matrixes not found for ") + name) + HX_CSTRING(" in ")) + animName));
				}
				HX_STACK_LINE(353)
				if (((def->wasRemoved != null()))){
					HX_STACK_LINE(354)
					::String _g4 = cn->getName();		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(354)
					if (((_g4 != HX_CSTRING("Visibility")))){
						HX_STACK_LINE(355)
						continue;
					}
					HX_STACK_LINE(357)
					::h3d::fbx::FbxNode _g5 = this->ids->get(def->wasRemoved);		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(357)
					model = _g5;
					HX_STACK_LINE(358)
					::String _g6 = model->getName();		HX_STACK_VAR(_g6,"_g6");
					HX_STACK_LINE(358)
					name = _g6;
					HX_STACK_LINE(359)
					Dynamic _g7 = curves->get(def->wasRemoved);		HX_STACK_VAR(_g7,"_g7");
					HX_STACK_LINE(359)
					c = _g7;
					HX_STACK_LINE(360)
					::h3d::fbx::DefaultMatrixes _g8 = this->defaultModelMatrixes->get(name);		HX_STACK_VAR(_g8,"_g8");
					HX_STACK_LINE(360)
					def = _g8;
					HX_STACK_LINE(362)
					if (((def == null()))){
						HX_STACK_LINE(362)
						HX_STACK_DO_THROW(HX_CSTRING("assert"));
					}
				}
				HX_STACK_LINE(364)
				if (((c == null()))){
					struct _Function_5_1{
						inline static Dynamic Block( ::h3d::fbx::DefaultMatrixes &def,::String &name){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",365,0x38e70acc)
							{
								hx::Anon __result = hx::Anon_obj::Create();
								__result->Add(HX_CSTRING("def") , def,false);
								__result->Add(HX_CSTRING("t") , null(),false);
								__result->Add(HX_CSTRING("r") , null(),false);
								__result->Add(HX_CSTRING("s") , null(),false);
								__result->Add(HX_CSTRING("a") , null(),false);
								__result->Add(HX_CSTRING("name") , name,false);
								return __result;
							}
							return null();
						}
					};
					HX_STACK_LINE(365)
					c = _Function_5_1::Block(def,name);
					HX_STACK_LINE(366)
					{
						HX_STACK_LINE(366)
						int key = model->getId();		HX_STACK_VAR(key,"key");
						HX_STACK_LINE(366)
						curves->set(key,c);
					}
				}
			}
			HX_STACK_LINE(369)
			Array< ::Dynamic > data = this->getChilds(cn,HX_CSTRING("AnimationCurve"));		HX_STACK_VAR(data,"data");
			HX_STACK_LINE(370)
			::String cname = cn->getName();		HX_STACK_VAR(cname,"cname");
			HX_STACK_LINE(372)
			Array< Float > times = data->__get((int)0).StaticCast< ::h3d::fbx::FbxNode >()->get(HX_CSTRING("KeyTime"),null())->getFloats();		HX_STACK_VAR(times,"times");
			HX_STACK_LINE(373)
			{
				HX_STACK_LINE(373)
				int _g3 = (int)0;		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(373)
				int _g2 = times->length;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(373)
				while((true)){
					HX_STACK_LINE(373)
					if ((!(((_g3 < _g2))))){
						HX_STACK_LINE(373)
						break;
					}
					HX_STACK_LINE(373)
					int i = (_g3)++;		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(374)
					Float t = times->__get(i);		HX_STACK_VAR(t,"t");
					HX_STACK_LINE(376)
					if (((hx::Mod(t,(int)100) != (int)0))){
						HX_STACK_LINE(377)
						hx::AddEq(t,((int)100 - hx::Mod(t,(int)100)));
						HX_STACK_LINE(378)
						times[i] = t;
					}
					HX_STACK_LINE(381)
					int it = ::Std_obj::_int((Float(t) / Float((int)200000)));		HX_STACK_VAR(it,"it");
					HX_STACK_LINE(382)
					allTimes->set(it,t);
				}
			}
			HX_STACK_LINE(385)
			if (((data->length != (int)3))){
				HX_STACK_LINE(386)
				::String _switch_2 = (cname);
				if (  ( _switch_2==HX_CSTRING("Visibility"))){
					HX_STACK_LINE(389)
					Array< Float > _g9 = data->__get((int)0).StaticCast< ::h3d::fbx::FbxNode >()->get(HX_CSTRING("KeyValueFloat"),null())->getFloats();		HX_STACK_VAR(_g9,"_g9");
					struct _Function_5_1{
						inline static Dynamic Block( Array< Float > &times,Array< Float > &_g9){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",388,0x38e70acc)
							{
								hx::Anon __result = hx::Anon_obj::Create();
								__result->Add(HX_CSTRING("v") , _g9,false);
								__result->Add(HX_CSTRING("t") , times,false);
								return __result;
							}
							return null();
						}
					};
					HX_STACK_LINE(388)
					Dynamic _g10 = _Function_5_1::Block(times,_g9);		HX_STACK_VAR(_g10,"_g10");
					HX_STACK_LINE(388)
					c->__FieldRef(HX_CSTRING("a")) = _g10;
					HX_STACK_LINE(392)
					continue;
				}
				else  {
				}
;
;
				HX_STACK_LINE(395)
				::String _g11 = model->getName();		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(395)
				::String _g12 = (_g11 + HX_CSTRING("."));		HX_STACK_VAR(_g12,"_g12");
				HX_STACK_LINE(395)
				::String _g13 = (_g12 + cname);		HX_STACK_VAR(_g13,"_g13");
				HX_STACK_LINE(395)
				::String _g14 = (_g13 + HX_CSTRING(" has "));		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(395)
				::String _g15 = (_g14 + data->length);		HX_STACK_VAR(_g15,"_g15");
				HX_STACK_LINE(395)
				HX_STACK_DO_THROW((_g15 + HX_CSTRING(" curves")));
			}
			HX_STACK_LINE(399)
			Array< Float > _g16 = data->__get((int)0).StaticCast< ::h3d::fbx::FbxNode >()->get(HX_CSTRING("KeyValueFloat"),null())->getFloats();		HX_STACK_VAR(_g16,"_g16");
			HX_STACK_LINE(400)
			Array< Float > _g17 = data->__get((int)1).StaticCast< ::h3d::fbx::FbxNode >()->get(HX_CSTRING("KeyValueFloat"),null())->getFloats();		HX_STACK_VAR(_g17,"_g17");
			HX_STACK_LINE(401)
			Array< Float > _g18 = data->__get((int)2).StaticCast< ::h3d::fbx::FbxNode >()->get(HX_CSTRING("KeyValueFloat"),null())->getFloats();		HX_STACK_VAR(_g18,"_g18");
			struct _Function_3_1{
				inline static Dynamic Block( Array< Float > &_g17,Array< Float > &_g16,Array< Float > &_g18,Array< Float > &times){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",398,0x38e70acc)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("x") , _g16,false);
						__result->Add(HX_CSTRING("y") , _g17,false);
						__result->Add(HX_CSTRING("z") , _g18,false);
						__result->Add(HX_CSTRING("t") , times,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(398)
			Dynamic data1 = _Function_3_1::Block(_g17,_g16,_g18,times);		HX_STACK_VAR(data1,"data1");
			HX_STACK_LINE(408)
			Float E = 1e-10;		HX_STACK_VAR(E,"E");
			HX_STACK_LINE(408)
			Float M = 1.0;		HX_STACK_VAR(M,"M");
			HX_STACK_LINE(409)
			::h3d::col::Point def;		HX_STACK_VAR(def,"def");
			HX_STACK_LINE(409)
			::String _switch_3 = (cname);
			if (  ( _switch_3==HX_CSTRING("T"))){
				HX_STACK_LINE(410)
				if (((c->__Field(HX_CSTRING("def"),true)->__Field(HX_CSTRING("trans"),true) == null()))){
					HX_STACK_LINE(410)
					def = P0;
				}
				else{
					HX_STACK_LINE(410)
					def = c->__Field(HX_CSTRING("def"),true)->__Field(HX_CSTRING("trans"),true);
				}
			}
			else if (  ( _switch_3==HX_CSTRING("R"))){
				HX_STACK_LINE(411)
				M = F;
				HX_STACK_LINE(411)
				if (((c->__Field(HX_CSTRING("def"),true)->__Field(HX_CSTRING("rotate"),true) == null()))){
					HX_STACK_LINE(411)
					def = P0;
				}
				else{
					HX_STACK_LINE(411)
					def = c->__Field(HX_CSTRING("def"),true)->__Field(HX_CSTRING("rotate"),true);
				}
			}
			else if (  ( _switch_3==HX_CSTRING("S"))){
				HX_STACK_LINE(412)
				if (((c->__Field(HX_CSTRING("def"),true)->__Field(HX_CSTRING("scale"),true) == null()))){
					HX_STACK_LINE(412)
					def = P1;
				}
				else{
					HX_STACK_LINE(412)
					def = c->__Field(HX_CSTRING("def"),true)->__Field(HX_CSTRING("scale"),true);
				}
			}
			else  {
				HX_STACK_LINE(414)
				::String _g19 = model->getName();		HX_STACK_VAR(_g19,"_g19");
				HX_STACK_LINE(414)
				::String _g20 = (HX_CSTRING("Unknown curve ") + _g19);		HX_STACK_VAR(_g20,"_g20");
				HX_STACK_LINE(414)
				::String _g21 = (_g20 + HX_CSTRING("."));		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(414)
				HX_STACK_DO_THROW((_g21 + cname));
			}
;
;
			HX_STACK_LINE(416)
			bool hasValue = false;		HX_STACK_VAR(hasValue,"hasValue");
			HX_STACK_LINE(417)
			{
				HX_STACK_LINE(417)
				int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(417)
				Array< Float > _g3 = data1->__Field(HX_CSTRING("x"),true);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(417)
				while((true)){
					HX_STACK_LINE(417)
					if ((!(((_g2 < _g3->length))))){
						HX_STACK_LINE(417)
						break;
					}
					HX_STACK_LINE(417)
					Float v = _g3->__get(_g2);		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(417)
					++(_g2);
					HX_STACK_LINE(418)
					if (((bool(((v * M) < (def->x - E))) || bool(((v * M) > (def->x + E)))))){
						HX_STACK_LINE(419)
						hasValue = true;
						HX_STACK_LINE(420)
						break;
					}
				}
			}
			HX_STACK_LINE(422)
			if ((!(hasValue))){
				HX_STACK_LINE(423)
				int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(423)
				Array< Float > _g3 = data1->__Field(HX_CSTRING("y"),true);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(423)
				while((true)){
					HX_STACK_LINE(423)
					if ((!(((_g2 < _g3->length))))){
						HX_STACK_LINE(423)
						break;
					}
					HX_STACK_LINE(423)
					Float v = _g3->__get(_g2);		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(423)
					++(_g2);
					HX_STACK_LINE(424)
					if (((bool(((v * M) < (def->y - E))) || bool(((v * M) > (def->y + E)))))){
						HX_STACK_LINE(425)
						hasValue = true;
						HX_STACK_LINE(426)
						break;
					}
				}
			}
			HX_STACK_LINE(429)
			if ((!(hasValue))){
				HX_STACK_LINE(430)
				int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(430)
				Array< Float > _g3 = data1->__Field(HX_CSTRING("z"),true);		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(430)
				while((true)){
					HX_STACK_LINE(430)
					if ((!(((_g2 < _g3->length))))){
						HX_STACK_LINE(430)
						break;
					}
					HX_STACK_LINE(430)
					Float v = _g3->__get(_g2);		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(430)
					++(_g2);
					HX_STACK_LINE(431)
					if (((bool(((v * M) < (def->z - E))) || bool(((v * M) > (def->z + E)))))){
						HX_STACK_LINE(432)
						hasValue = true;
						HX_STACK_LINE(433)
						break;
					}
				}
			}
			HX_STACK_LINE(437)
			if ((!(hasValue))){
				HX_STACK_LINE(438)
				continue;
			}
			HX_STACK_LINE(439)
			::String _switch_4 = (cname);
			if (  ( _switch_4==HX_CSTRING("T"))){
				HX_STACK_LINE(440)
				c->__FieldRef(HX_CSTRING("t")) = data1;
			}
			else if (  ( _switch_4==HX_CSTRING("R"))){
				HX_STACK_LINE(441)
				c->__FieldRef(HX_CSTRING("r")) = data1;
			}
			else if (  ( _switch_4==HX_CSTRING("S"))){
				HX_STACK_LINE(442)
				c->__FieldRef(HX_CSTRING("s")) = data1;
			}
			else  {
				HX_STACK_LINE(443)
				HX_STACK_DO_THROW(HX_CSTRING("assert"));
			}
;
;
		}
	}
	HX_STACK_LINE(447)
	Array< Float > times = Array_obj< Float >::__new();		HX_STACK_VAR(times,"times");
	HX_STACK_LINE(448)
	for(::cpp::FastIterator_obj< Float > *__it = ::cpp::CreateFastIterator< Float >(allTimes->iterator());  __it->hasNext(); ){
		Float a = __it->next();
		times->push(a);
	}
	HX_STACK_LINE(450)
	Array< Float > allTimes1 = times;		HX_STACK_VAR(allTimes1,"allTimes1");
	HX_STACK_LINE(451)
	allTimes1->sort(this->sortDistinctFloats_dyn());
	HX_STACK_LINE(452)
	Float maxTime = allTimes1->__get((allTimes1->length - (int)1));		HX_STACK_VAR(maxTime,"maxTime");
	HX_STACK_LINE(453)
	Float minDT = maxTime;		HX_STACK_VAR(minDT,"minDT");
	HX_STACK_LINE(454)
	Float curT = allTimes1->__get((int)0);		HX_STACK_VAR(curT,"curT");
	HX_STACK_LINE(455)
	{
		HX_STACK_LINE(455)
		int _g1 = (int)1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(455)
		int _g = allTimes1->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(455)
		while((true)){
			HX_STACK_LINE(455)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(455)
				break;
			}
			HX_STACK_LINE(455)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(456)
			Float t = allTimes1->__get(i);		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(457)
			Float dt = (t - curT);		HX_STACK_VAR(dt,"dt");
			HX_STACK_LINE(458)
			if (((dt < minDT))){
				HX_STACK_LINE(458)
				minDT = dt;
			}
			HX_STACK_LINE(459)
			curT = t;
		}
	}
	HX_STACK_LINE(461)
	int numFrames;		HX_STACK_VAR(numFrames,"numFrames");
	HX_STACK_LINE(461)
	if (((maxTime == (int)0))){
		HX_STACK_LINE(461)
		numFrames = (int)1;
	}
	else{
		HX_STACK_LINE(461)
		int _g22 = ::Std_obj::_int((Float(((maxTime - allTimes1->__get((int)0)))) / Float(minDT)));		HX_STACK_VAR(_g22,"_g22");
		HX_STACK_LINE(461)
		numFrames = ((int)1 + _g22);
	}
	HX_STACK_LINE(462)
	Float sampling = (Float(15.0) / Float(((Float(minDT) / Float(3079077200)))));		HX_STACK_VAR(sampling,"sampling");
	HX_STACK_LINE(464)
	switch( (int)(mode->__Index())){
		case (int)0: {
			HX_STACK_LINE(466)
			::h3d::anim::FrameAnimation anim = ::h3d::anim::FrameAnimation_obj::__new(animName,numFrames,sampling);		HX_STACK_VAR(anim,"anim");
			HX_STACK_LINE(468)
			for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(curves->iterator());  __it->hasNext(); ){
				Dynamic c = __it->next();
				{
					HX_STACK_LINE(469)
					Array< ::Dynamic > frames;		HX_STACK_VAR(frames,"frames");
					HX_STACK_LINE(469)
					if (((bool((bool((c->__Field(HX_CSTRING("t"),true) == null())) && bool((c->__Field(HX_CSTRING("r"),true) == null())))) && bool((c->__Field(HX_CSTRING("s"),true) == null()))))){
						HX_STACK_LINE(469)
						frames = null();
					}
					else{
						struct _Function_4_1{
							inline static Array< ::Dynamic > Block( int &numFrames){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",469,0x38e70acc)
								{
									HX_STACK_LINE(469)
									Array< ::Dynamic > this1;		HX_STACK_VAR(this1,"this1");
									HX_STACK_LINE(469)
									Array< ::Dynamic > _g23 = Array_obj< ::Dynamic >::__new()->__SetSizeExact(numFrames);		HX_STACK_VAR(_g23,"_g23");
									HX_STACK_LINE(469)
									this1 = _g23;
									HX_STACK_LINE(469)
									return this1;
								}
								return null();
							}
						};
						HX_STACK_LINE(469)
						frames = _Function_4_1::Block(numFrames);
					}
					HX_STACK_LINE(470)
					Array< Float > alpha;		HX_STACK_VAR(alpha,"alpha");
					HX_STACK_LINE(470)
					if (((c->__Field(HX_CSTRING("a"),true) == null()))){
						HX_STACK_LINE(470)
						alpha = null();
					}
					else{
						struct _Function_4_1{
							inline static Array< Float > Block( int &numFrames){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",470,0x38e70acc)
								{
									HX_STACK_LINE(470)
									Array< Float > this1;		HX_STACK_VAR(this1,"this1");
									HX_STACK_LINE(470)
									Array< Float > _g24 = Array_obj< Float >::__new()->__SetSizeExact(numFrames);		HX_STACK_VAR(_g24,"_g24");
									HX_STACK_LINE(470)
									this1 = _g24;
									HX_STACK_LINE(470)
									return this1;
								}
								return null();
							}
						};
						HX_STACK_LINE(470)
						alpha = _Function_4_1::Block(numFrames);
					}
					HX_STACK_LINE(472)
					if (((bool((frames == null())) && bool((alpha == null()))))){
						HX_STACK_LINE(473)
						continue;
					}
					HX_STACK_LINE(474)
					Array< Float > ctx;		HX_STACK_VAR(ctx,"ctx");
					HX_STACK_LINE(474)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(474)
						ctx = null();
					}
					else{
						HX_STACK_LINE(474)
						ctx = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("x"),true);
					}
					HX_STACK_LINE(475)
					Array< Float > cty;		HX_STACK_VAR(cty,"cty");
					HX_STACK_LINE(475)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(475)
						cty = null();
					}
					else{
						HX_STACK_LINE(475)
						cty = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("y"),true);
					}
					HX_STACK_LINE(476)
					Array< Float > ctz;		HX_STACK_VAR(ctz,"ctz");
					HX_STACK_LINE(476)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(476)
						ctz = null();
					}
					else{
						HX_STACK_LINE(476)
						ctz = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("z"),true);
					}
					HX_STACK_LINE(477)
					Array< Float > ctt;		HX_STACK_VAR(ctt,"ctt");
					HX_STACK_LINE(477)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(477)
						ctt = Array_obj< Float >::__new().Add(-1.);
					}
					else{
						HX_STACK_LINE(477)
						ctt = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(478)
					Array< Float > crx;		HX_STACK_VAR(crx,"crx");
					HX_STACK_LINE(478)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(478)
						crx = null();
					}
					else{
						HX_STACK_LINE(478)
						crx = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("x"),true);
					}
					HX_STACK_LINE(479)
					Array< Float > cry;		HX_STACK_VAR(cry,"cry");
					HX_STACK_LINE(479)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(479)
						cry = null();
					}
					else{
						HX_STACK_LINE(479)
						cry = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("y"),true);
					}
					HX_STACK_LINE(480)
					Array< Float > crz;		HX_STACK_VAR(crz,"crz");
					HX_STACK_LINE(480)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(480)
						crz = null();
					}
					else{
						HX_STACK_LINE(480)
						crz = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("z"),true);
					}
					HX_STACK_LINE(481)
					Array< Float > crt;		HX_STACK_VAR(crt,"crt");
					HX_STACK_LINE(481)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(481)
						crt = Array_obj< Float >::__new().Add(-1.);
					}
					else{
						HX_STACK_LINE(481)
						crt = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(482)
					Array< Float > csx;		HX_STACK_VAR(csx,"csx");
					HX_STACK_LINE(482)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(482)
						csx = null();
					}
					else{
						HX_STACK_LINE(482)
						csx = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("x"),true);
					}
					HX_STACK_LINE(483)
					Array< Float > csy;		HX_STACK_VAR(csy,"csy");
					HX_STACK_LINE(483)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(483)
						csy = null();
					}
					else{
						HX_STACK_LINE(483)
						csy = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("y"),true);
					}
					HX_STACK_LINE(484)
					Array< Float > csz;		HX_STACK_VAR(csz,"csz");
					HX_STACK_LINE(484)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(484)
						csz = null();
					}
					else{
						HX_STACK_LINE(484)
						csz = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("z"),true);
					}
					HX_STACK_LINE(485)
					Array< Float > cst;		HX_STACK_VAR(cst,"cst");
					HX_STACK_LINE(485)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(485)
						cst = Array_obj< Float >::__new().Add(-1.);
					}
					else{
						HX_STACK_LINE(485)
						cst = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(486)
					Array< Float > cav;		HX_STACK_VAR(cav,"cav");
					HX_STACK_LINE(486)
					if (((c->__Field(HX_CSTRING("a"),true) == null()))){
						HX_STACK_LINE(486)
						cav = null();
					}
					else{
						HX_STACK_LINE(486)
						cav = c->__Field(HX_CSTRING("a"),true)->__Field(HX_CSTRING("v"),true);
					}
					HX_STACK_LINE(487)
					Array< Float > cat;		HX_STACK_VAR(cat,"cat");
					HX_STACK_LINE(487)
					if (((c->__Field(HX_CSTRING("a"),true) == null()))){
						HX_STACK_LINE(487)
						cat = null();
					}
					else{
						HX_STACK_LINE(487)
						cat = c->__Field(HX_CSTRING("a"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(488)
					::h3d::fbx::DefaultMatrixes def = c->__Field(HX_CSTRING("def"),true);		HX_STACK_VAR(def,"def");
					HX_STACK_LINE(489)
					int tp = (int)0;		HX_STACK_VAR(tp,"tp");
					HX_STACK_LINE(489)
					int rp = (int)0;		HX_STACK_VAR(rp,"rp");
					HX_STACK_LINE(489)
					int sp = (int)0;		HX_STACK_VAR(sp,"sp");
					HX_STACK_LINE(489)
					int ap = (int)0;		HX_STACK_VAR(ap,"ap");
					HX_STACK_LINE(490)
					::h3d::Matrix curMat = null();		HX_STACK_VAR(curMat,"curMat");
					HX_STACK_LINE(491)
					{
						HX_STACK_LINE(491)
						int _g = (int)0;		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(491)
						while((true)){
							HX_STACK_LINE(491)
							if ((!(((_g < numFrames))))){
								HX_STACK_LINE(491)
								break;
							}
							HX_STACK_LINE(491)
							int f = (_g)++;		HX_STACK_VAR(f,"f");
							HX_STACK_LINE(492)
							bool changed = (curMat == null());		HX_STACK_VAR(changed,"changed");
							HX_STACK_LINE(493)
							if (((allTimes1->__get(f) == ctt->__get(tp)))){
								HX_STACK_LINE(494)
								changed = true;
								HX_STACK_LINE(495)
								(tp)++;
							}
							HX_STACK_LINE(497)
							if (((allTimes1->__get(f) == crt->__get(rp)))){
								HX_STACK_LINE(498)
								changed = true;
								HX_STACK_LINE(499)
								(rp)++;
							}
							HX_STACK_LINE(501)
							if (((allTimes1->__get(f) == cst->__get(sp)))){
								HX_STACK_LINE(502)
								changed = true;
								HX_STACK_LINE(503)
								(sp)++;
							}
							HX_STACK_LINE(505)
							if ((changed)){
								HX_STACK_LINE(506)
								::h3d::Matrix m = ::h3d::Matrix_obj::__new();		HX_STACK_VAR(m,"m");
								HX_STACK_LINE(507)
								m->identity();
								HX_STACK_LINE(508)
								if (((bool((c->__Field(HX_CSTRING("s"),true) == null())) || bool((sp == (int)0))))){
									HX_STACK_LINE(509)
									if (((def->scale != null()))){
										HX_STACK_LINE(510)
										m->scale(def->scale->x,def->scale->y,def->scale->z);
									}
								}
								else{
									HX_STACK_LINE(512)
									m->scale(csx->__get((sp - (int)1)),csy->__get((sp - (int)1)),csz->__get((sp - (int)1)));
								}
								HX_STACK_LINE(514)
								if (((bool((c->__Field(HX_CSTRING("r"),true) == null())) || bool((rp == (int)0))))){
									HX_STACK_LINE(515)
									if (((def->rotate != null()))){
										HX_STACK_LINE(516)
										m->rotate(def->rotate->x,def->rotate->y,def->rotate->z);
									}
								}
								else{
									HX_STACK_LINE(518)
									m->rotate((crx->__get((rp - (int)1)) * F),(cry->__get((rp - (int)1)) * F),(crz->__get((rp - (int)1)) * F));
								}
								HX_STACK_LINE(520)
								if (((def->preRot != null()))){
									HX_STACK_LINE(521)
									m->rotate(def->preRot->x,def->preRot->y,def->preRot->z);
								}
								HX_STACK_LINE(523)
								if (((bool((c->__Field(HX_CSTRING("t"),true) == null())) || bool((tp == (int)0))))){
									HX_STACK_LINE(524)
									if (((def->trans != null()))){
										HX_STACK_LINE(525)
										m->translate(def->trans->x,def->trans->y,def->trans->z);
									}
								}
								else{
									HX_STACK_LINE(527)
									m->translate(ctx->__get((tp - (int)1)),cty->__get((tp - (int)1)),ctz->__get((tp - (int)1)));
								}
								HX_STACK_LINE(529)
								if ((this->leftHand)){
									HX_STACK_LINE(530)
									hx::MultEq(m->_12,(int)-1);
									HX_STACK_LINE(530)
									hx::MultEq(m->_13,(int)-1);
									HX_STACK_LINE(530)
									hx::MultEq(m->_21,(int)-1);
									HX_STACK_LINE(530)
									hx::MultEq(m->_31,(int)-1);
									HX_STACK_LINE(530)
									hx::MultEq(m->_41,(int)-1);
								}
								HX_STACK_LINE(532)
								curMat = m;
							}
							HX_STACK_LINE(534)
							if (((frames != null()))){
								HX_STACK_LINE(535)
								frames->__unsafe_set(f,curMat);
							}
							HX_STACK_LINE(536)
							if (((alpha != null()))){
								HX_STACK_LINE(537)
								if (((allTimes1->__get(f) == cat->__get(ap)))){
									HX_STACK_LINE(538)
									(ap)++;
								}
								HX_STACK_LINE(539)
								alpha->__unsafe_set(f,cav->__get((ap - (int)1)));
							}
						}
					}
					HX_STACK_LINE(543)
					if (((frames != null()))){
						HX_STACK_LINE(544)
						anim->addCurve(c->__Field(HX_CSTRING("name"),true),frames);
					}
					HX_STACK_LINE(545)
					if (((alpha != null()))){
						HX_STACK_LINE(546)
						anim->addAlphaCurve(c->__Field(HX_CSTRING("name"),true),alpha);
					}
				}
;
			}
			HX_STACK_LINE(548)
			return anim;
		}
		;break;
		case (int)1: {
			HX_STACK_LINE(552)
			::h3d::anim::LinearAnimation anim = ::h3d::anim::LinearAnimation_obj::__new(animName,numFrames,sampling);		HX_STACK_VAR(anim,"anim");
			HX_STACK_LINE(553)
			::h3d::Quat q = ::h3d::Quat_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(q,"q");
			HX_STACK_LINE(553)
			::h3d::Quat q2 = ::h3d::Quat_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(q2,"q2");
			HX_STACK_LINE(555)
			for(::cpp::FastIterator_obj< Dynamic > *__it = ::cpp::CreateFastIterator< Dynamic >(curves->iterator());  __it->hasNext(); ){
				Dynamic c = __it->next();
				{
					HX_STACK_LINE(556)
					Array< ::Dynamic > frames;		HX_STACK_VAR(frames,"frames");
					HX_STACK_LINE(556)
					if (((bool((bool((c->__Field(HX_CSTRING("t"),true) == null())) && bool((c->__Field(HX_CSTRING("r"),true) == null())))) && bool((c->__Field(HX_CSTRING("s"),true) == null()))))){
						HX_STACK_LINE(556)
						frames = null();
					}
					else{
						struct _Function_4_1{
							inline static Array< ::Dynamic > Block( int &numFrames){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",556,0x38e70acc)
								{
									HX_STACK_LINE(556)
									Array< ::Dynamic > this1;		HX_STACK_VAR(this1,"this1");
									HX_STACK_LINE(556)
									Array< ::Dynamic > _g25 = Array_obj< ::Dynamic >::__new()->__SetSizeExact(numFrames);		HX_STACK_VAR(_g25,"_g25");
									HX_STACK_LINE(556)
									this1 = _g25;
									HX_STACK_LINE(556)
									return this1;
								}
								return null();
							}
						};
						HX_STACK_LINE(556)
						frames = _Function_4_1::Block(numFrames);
					}
					HX_STACK_LINE(557)
					Array< Float > alpha;		HX_STACK_VAR(alpha,"alpha");
					HX_STACK_LINE(557)
					if (((c->__Field(HX_CSTRING("a"),true) == null()))){
						HX_STACK_LINE(557)
						alpha = null();
					}
					else{
						struct _Function_4_1{
							inline static Array< Float > Block( int &numFrames){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",557,0x38e70acc)
								{
									HX_STACK_LINE(557)
									Array< Float > this1;		HX_STACK_VAR(this1,"this1");
									HX_STACK_LINE(557)
									Array< Float > _g26 = Array_obj< Float >::__new()->__SetSizeExact(numFrames);		HX_STACK_VAR(_g26,"_g26");
									HX_STACK_LINE(557)
									this1 = _g26;
									HX_STACK_LINE(557)
									return this1;
								}
								return null();
							}
						};
						HX_STACK_LINE(557)
						alpha = _Function_4_1::Block(numFrames);
					}
					HX_STACK_LINE(559)
					if (((bool((frames == null())) && bool((alpha == null()))))){
						HX_STACK_LINE(560)
						continue;
					}
					HX_STACK_LINE(561)
					Array< Float > ctx;		HX_STACK_VAR(ctx,"ctx");
					HX_STACK_LINE(561)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(561)
						ctx = null();
					}
					else{
						HX_STACK_LINE(561)
						ctx = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("x"),true);
					}
					HX_STACK_LINE(562)
					Array< Float > cty;		HX_STACK_VAR(cty,"cty");
					HX_STACK_LINE(562)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(562)
						cty = null();
					}
					else{
						HX_STACK_LINE(562)
						cty = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("y"),true);
					}
					HX_STACK_LINE(563)
					Array< Float > ctz;		HX_STACK_VAR(ctz,"ctz");
					HX_STACK_LINE(563)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(563)
						ctz = null();
					}
					else{
						HX_STACK_LINE(563)
						ctz = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("z"),true);
					}
					HX_STACK_LINE(564)
					Array< Float > ctt;		HX_STACK_VAR(ctt,"ctt");
					HX_STACK_LINE(564)
					if (((c->__Field(HX_CSTRING("t"),true) == null()))){
						HX_STACK_LINE(564)
						ctt = Array_obj< Float >::__new().Add(-1.);
					}
					else{
						HX_STACK_LINE(564)
						ctt = c->__Field(HX_CSTRING("t"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(565)
					Array< Float > crx;		HX_STACK_VAR(crx,"crx");
					HX_STACK_LINE(565)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(565)
						crx = null();
					}
					else{
						HX_STACK_LINE(565)
						crx = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("x"),true);
					}
					HX_STACK_LINE(566)
					Array< Float > cry;		HX_STACK_VAR(cry,"cry");
					HX_STACK_LINE(566)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(566)
						cry = null();
					}
					else{
						HX_STACK_LINE(566)
						cry = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("y"),true);
					}
					HX_STACK_LINE(567)
					Array< Float > crz;		HX_STACK_VAR(crz,"crz");
					HX_STACK_LINE(567)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(567)
						crz = null();
					}
					else{
						HX_STACK_LINE(567)
						crz = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("z"),true);
					}
					HX_STACK_LINE(568)
					Array< Float > crt;		HX_STACK_VAR(crt,"crt");
					HX_STACK_LINE(568)
					if (((c->__Field(HX_CSTRING("r"),true) == null()))){
						HX_STACK_LINE(568)
						crt = Array_obj< Float >::__new().Add(-1.);
					}
					else{
						HX_STACK_LINE(568)
						crt = c->__Field(HX_CSTRING("r"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(569)
					Array< Float > csx;		HX_STACK_VAR(csx,"csx");
					HX_STACK_LINE(569)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(569)
						csx = null();
					}
					else{
						HX_STACK_LINE(569)
						csx = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("x"),true);
					}
					HX_STACK_LINE(570)
					Array< Float > csy;		HX_STACK_VAR(csy,"csy");
					HX_STACK_LINE(570)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(570)
						csy = null();
					}
					else{
						HX_STACK_LINE(570)
						csy = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("y"),true);
					}
					HX_STACK_LINE(571)
					Array< Float > csz;		HX_STACK_VAR(csz,"csz");
					HX_STACK_LINE(571)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(571)
						csz = null();
					}
					else{
						HX_STACK_LINE(571)
						csz = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("z"),true);
					}
					HX_STACK_LINE(572)
					Array< Float > cst;		HX_STACK_VAR(cst,"cst");
					HX_STACK_LINE(572)
					if (((c->__Field(HX_CSTRING("s"),true) == null()))){
						HX_STACK_LINE(572)
						cst = Array_obj< Float >::__new().Add(-1.);
					}
					else{
						HX_STACK_LINE(572)
						cst = c->__Field(HX_CSTRING("s"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(573)
					Array< Float > cav;		HX_STACK_VAR(cav,"cav");
					HX_STACK_LINE(573)
					if (((c->__Field(HX_CSTRING("a"),true) == null()))){
						HX_STACK_LINE(573)
						cav = null();
					}
					else{
						HX_STACK_LINE(573)
						cav = c->__Field(HX_CSTRING("a"),true)->__Field(HX_CSTRING("v"),true);
					}
					HX_STACK_LINE(574)
					Array< Float > cat;		HX_STACK_VAR(cat,"cat");
					HX_STACK_LINE(574)
					if (((c->__Field(HX_CSTRING("a"),true) == null()))){
						HX_STACK_LINE(574)
						cat = null();
					}
					else{
						HX_STACK_LINE(574)
						cat = c->__Field(HX_CSTRING("a"),true)->__Field(HX_CSTRING("t"),true);
					}
					HX_STACK_LINE(575)
					::h3d::fbx::DefaultMatrixes def = c->__Field(HX_CSTRING("def"),true);		HX_STACK_VAR(def,"def");
					HX_STACK_LINE(576)
					int tp = (int)0;		HX_STACK_VAR(tp,"tp");
					HX_STACK_LINE(576)
					int rp = (int)0;		HX_STACK_VAR(rp,"rp");
					HX_STACK_LINE(576)
					int sp = (int)0;		HX_STACK_VAR(sp,"sp");
					HX_STACK_LINE(576)
					int ap = (int)0;		HX_STACK_VAR(ap,"ap");
					HX_STACK_LINE(577)
					::h3d::anim::LinearFrame curFrame = null();		HX_STACK_VAR(curFrame,"curFrame");
					HX_STACK_LINE(578)
					{
						HX_STACK_LINE(578)
						int _g = (int)0;		HX_STACK_VAR(_g,"_g");
						HX_STACK_LINE(578)
						while((true)){
							HX_STACK_LINE(578)
							if ((!(((_g < numFrames))))){
								HX_STACK_LINE(578)
								break;
							}
							HX_STACK_LINE(578)
							int f = (_g)++;		HX_STACK_VAR(f,"f");
							HX_STACK_LINE(579)
							bool changed = (curFrame == null());		HX_STACK_VAR(changed,"changed");
							HX_STACK_LINE(580)
							if (((allTimes1->__get(f) == ctt->__get(tp)))){
								HX_STACK_LINE(581)
								changed = true;
								HX_STACK_LINE(582)
								(tp)++;
							}
							HX_STACK_LINE(584)
							if (((allTimes1->__get(f) == crt->__get(rp)))){
								HX_STACK_LINE(585)
								changed = true;
								HX_STACK_LINE(586)
								(rp)++;
							}
							HX_STACK_LINE(588)
							if (((allTimes1->__get(f) == cst->__get(sp)))){
								HX_STACK_LINE(589)
								changed = true;
								HX_STACK_LINE(590)
								(sp)++;
							}
							HX_STACK_LINE(592)
							if ((changed)){
								HX_STACK_LINE(593)
								::h3d::anim::LinearFrame f1 = ::h3d::anim::LinearFrame_obj::__new();		HX_STACK_VAR(f1,"f1");
								HX_STACK_LINE(594)
								if (((bool((c->__Field(HX_CSTRING("s"),true) == null())) || bool((sp == (int)0))))){
									HX_STACK_LINE(595)
									if (((def->scale != null()))){
										HX_STACK_LINE(596)
										f1->sx = def->scale->x;
										HX_STACK_LINE(597)
										f1->sy = def->scale->y;
										HX_STACK_LINE(598)
										f1->sz = def->scale->z;
									}
									else{
										HX_STACK_LINE(600)
										f1->sx = (int)1;
										HX_STACK_LINE(601)
										f1->sy = (int)1;
										HX_STACK_LINE(602)
										f1->sx = (int)1;
									}
								}
								else{
									HX_STACK_LINE(605)
									f1->sx = csx->__get((sp - (int)1));
									HX_STACK_LINE(606)
									f1->sy = csy->__get((sp - (int)1));
									HX_STACK_LINE(607)
									f1->sz = csz->__get((sp - (int)1));
								}
								HX_STACK_LINE(610)
								if (((bool((c->__Field(HX_CSTRING("r"),true) == null())) || bool((rp == (int)0))))){
									HX_STACK_LINE(611)
									if (((def->rotate != null()))){
										HX_STACK_LINE(612)
										q->initRotate(def->rotate->x,def->rotate->y,def->rotate->z);
									}
									else{
										HX_STACK_LINE(614)
										Float _g27 = q->z = (int)0;		HX_STACK_VAR(_g27,"_g27");
										HX_STACK_LINE(614)
										Float _g28 = q->y = _g27;		HX_STACK_VAR(_g28,"_g28");
										HX_STACK_LINE(614)
										q->x = _g28;
										HX_STACK_LINE(614)
										q->w = (int)1;
									}
								}
								else{
									HX_STACK_LINE(616)
									q->initRotate((crx->__get((rp - (int)1)) * F),(cry->__get((rp - (int)1)) * F),(crz->__get((rp - (int)1)) * F));
								}
								HX_STACK_LINE(618)
								if (((def->preRot != null()))){
									HX_STACK_LINE(619)
									q2->initRotate(def->preRot->x,def->preRot->y,def->preRot->z);
									HX_STACK_LINE(620)
									q->multiply(q,q2);
								}
								HX_STACK_LINE(623)
								f1->qx = q->x;
								HX_STACK_LINE(624)
								f1->qy = q->y;
								HX_STACK_LINE(625)
								f1->qz = q->z;
								HX_STACK_LINE(626)
								f1->qw = q->w;
								HX_STACK_LINE(628)
								if (((bool((c->__Field(HX_CSTRING("t"),true) == null())) || bool((tp == (int)0))))){
									HX_STACK_LINE(629)
									if (((def->trans != null()))){
										HX_STACK_LINE(630)
										f1->tx = def->trans->x;
										HX_STACK_LINE(631)
										f1->ty = def->trans->y;
										HX_STACK_LINE(632)
										f1->tz = def->trans->z;
									}
									else{
										HX_STACK_LINE(634)
										f1->tx = (int)0;
										HX_STACK_LINE(635)
										f1->ty = (int)0;
										HX_STACK_LINE(636)
										f1->tz = (int)0;
									}
								}
								else{
									HX_STACK_LINE(639)
									f1->tx = ctx->__get((tp - (int)1));
									HX_STACK_LINE(640)
									f1->ty = cty->__get((tp - (int)1));
									HX_STACK_LINE(641)
									f1->tz = ctz->__get((tp - (int)1));
								}
								HX_STACK_LINE(644)
								if ((this->leftHand)){
									HX_STACK_LINE(645)
									hx::MultEq(f1->tx,(int)-1);
									HX_STACK_LINE(646)
									hx::MultEq(f1->qy,(int)-1);
									HX_STACK_LINE(647)
									hx::MultEq(f1->qz,(int)-1);
								}
								HX_STACK_LINE(650)
								curFrame = f1;
							}
							HX_STACK_LINE(652)
							if (((frames != null()))){
								HX_STACK_LINE(653)
								frames->__unsafe_set(f,curFrame);
							}
							HX_STACK_LINE(654)
							if (((alpha != null()))){
								HX_STACK_LINE(655)
								if (((allTimes1->__get(f) == cat->__get(ap)))){
									HX_STACK_LINE(656)
									(ap)++;
								}
								HX_STACK_LINE(657)
								alpha->__unsafe_set(f,cav->__get((ap - (int)1)));
							}
						}
					}
					HX_STACK_LINE(661)
					if (((frames != null()))){
						HX_STACK_LINE(662)
						anim->addCurve(c->__Field(HX_CSTRING("name"),true),frames,(bool((c->__Field(HX_CSTRING("r"),true) != null())) || bool((def->rotate != null()))),(bool((c->__Field(HX_CSTRING("s"),true) != null())) || bool((def->scale != null()))));
					}
					HX_STACK_LINE(663)
					if (((alpha != null()))){
						HX_STACK_LINE(664)
						anim->addAlphaCurve(c->__Field(HX_CSTRING("name"),true),alpha);
					}
				}
;
			}
			HX_STACK_LINE(666)
			return anim;
		}
		;break;
	}
	HX_STACK_LINE(464)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Library_obj,loadAnimation,return )

Array< ::Dynamic > Library_obj::getTakes( ){
	HX_STACK_FRAME("h3d.fbx.Library","getTakes",0x55798210,"h3d.fbx.Library.getTakes","h3d/fbx/Library.hx",672,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_LINE(672)
	return this->root->getAll(HX_CSTRING("Takes.Take"));
}


HX_DEFINE_DYNAMIC_FUNC0(Library_obj,getTakes,return )

::h3d::anim::MorphFrameAnimation Library_obj::loadMorphAnimation( ::h3d::fbx::AnimationMode mode,::String animName,::h3d::fbx::FbxNode root,::h3d::fbx::Library lib){
	HX_STACK_FRAME("h3d.fbx.Library","loadMorphAnimation",0x0894c69c,"h3d.fbx.Library.loadMorphAnimation","h3d/fbx/Library.hx",675,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(mode,"mode")
	HX_STACK_ARG(animName,"animName")
	HX_STACK_ARG(root,"root")
	HX_STACK_ARG(lib,"lib")
	HX_STACK_LINE(676)
	::String inAnimName = animName;		HX_STACK_VAR(inAnimName,"inAnimName");
	HX_STACK_LINE(677)
	if (((lib != null()))){
		HX_STACK_LINE(678)
		lib->defaultModelMatrixes = this->defaultModelMatrixes;
		HX_STACK_LINE(679)
		return lib->loadMorphAnimation(mode,animName,null(),null());
	}
	HX_STACK_LINE(681)
	if (((root != null()))){
		HX_STACK_LINE(682)
		::h3d::fbx::Library l = ::h3d::fbx::Library_obj::__new();		HX_STACK_VAR(l,"l");
		HX_STACK_LINE(683)
		l->load(root);
		HX_STACK_LINE(684)
		if ((this->leftHand)){
			HX_STACK_LINE(684)
			l->leftHandConvert();
		}
		HX_STACK_LINE(685)
		l->defaultModelMatrixes = this->defaultModelMatrixes;
		HX_STACK_LINE(686)
		return l->loadMorphAnimation(mode,animName,null(),null());
	}
	HX_STACK_LINE(689)
	::h3d::fbx::FbxNode animNode = null();		HX_STACK_VAR(animNode,"animNode");
	HX_STACK_LINE(690)
	bool found = false;		HX_STACK_VAR(found,"found");
	HX_STACK_LINE(691)
	{
		HX_STACK_LINE(691)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(691)
		Array< ::Dynamic > _g1 = this->root->getAll(HX_CSTRING("Takes.Take"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(691)
		while((true)){
			HX_STACK_LINE(691)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(691)
				break;
			}
			HX_STACK_LINE(691)
			::h3d::fbx::FbxNode a = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(a,"a");
			HX_STACK_LINE(691)
			++(_g);
			HX_STACK_LINE(692)
			::String st = a->getStringProp((int)0);		HX_STACK_VAR(st,"st");
			HX_STACK_LINE(693)
			if (((bool((animName == null())) || bool((st == animName))))){
				HX_STACK_LINE(694)
				if (((animName == null()))){
					HX_STACK_LINE(694)
					animName = st;
				}
				HX_STACK_LINE(695)
				{
					HX_STACK_LINE(695)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(695)
					Array< ::Dynamic > _g3 = this->getRoot()->getAll(HX_CSTRING("Objects.AnimationStack"));		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(695)
					while((true)){
						HX_STACK_LINE(695)
						if ((!(((_g2 < _g3->length))))){
							HX_STACK_LINE(695)
							break;
						}
						HX_STACK_LINE(695)
						::h3d::fbx::FbxNode s = _g3->__get(_g2).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(s,"s");
						HX_STACK_LINE(695)
						++(_g2);
						HX_STACK_LINE(696)
						::String _g4 = s->getName();		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(696)
						if (((_g4 == animName))){
							HX_STACK_LINE(698)
							::h3d::fbx::FbxNode _g11 = this->getChild(s,HX_CSTRING("AnimationLayer"),null());		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(698)
							animNode = _g11;
							HX_STACK_LINE(699)
							found = true;
							HX_STACK_LINE(700)
							break;
						}
					}
				}
				HX_STACK_LINE(703)
				if ((found)){
					HX_STACK_LINE(703)
					break;
				}
			}
		}
	}
	HX_STACK_LINE(707)
	if (((animNode == null()))){
		HX_STACK_LINE(708)
		if (((inAnimName == null()))){
			HX_STACK_LINE(708)
			return null();
		}
		HX_STACK_LINE(709)
		HX_STACK_DO_THROW((HX_CSTRING("Animation not found ") + animName));
	}
	HX_STACK_LINE(712)
	if ((!(found))){
		HX_STACK_LINE(712)
		HX_STACK_DO_THROW((HX_CSTRING("Animation not found ") + animName));
	}
	HX_STACK_LINE(714)
	Array< ::Dynamic > cns = this->getChilds(animNode,HX_CSTRING("AnimationCurveNode"));		HX_STACK_VAR(cns,"cns");

	HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_1_1)
	bool run(::h3d::fbx::FbxNode n){
		HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h3d/fbx/Library.hx",716,0x38e70acc)
		HX_STACK_ARG(n,"n")
		{
			HX_STACK_LINE(716)
			return (n->getStringProp((int)1) == HX_CSTRING("AnimCurveNode::DeformPercent"));
		}
		return null();
	}
	HX_END_LOCAL_FUNC1(return)

	HX_STACK_LINE(715)
	Array< ::Dynamic > _g2 = cns->filter( Dynamic(new _Function_1_1()));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(715)
	cns = _g2;
	HX_STACK_LINE(718)
	::haxe::ds::IntMap allTimes = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(allTimes,"allTimes");
	HX_STACK_LINE(719)
	Dynamic shapes = Dynamic( Array_obj<Dynamic>::__new());		HX_STACK_VAR(shapes,"shapes");
	HX_STACK_LINE(721)
	{
		HX_STACK_LINE(721)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(721)
		while((true)){
			HX_STACK_LINE(721)
			if ((!(((_g < cns->length))))){
				HX_STACK_LINE(721)
				break;
			}
			HX_STACK_LINE(721)
			::h3d::fbx::FbxNode cn = cns->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(cn,"cn");
			HX_STACK_LINE(721)
			++(_g);
			HX_STACK_LINE(722)
			::h3d::fbx::FbxNode animCurve = this->getChild(cn,HX_CSTRING("AnimationCurve"),null());		HX_STACK_VAR(animCurve,"animCurve");
			HX_STACK_LINE(723)
			int i = (int)0;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(725)
			Array< Float > times = animCurve->get(HX_CSTRING("KeyTime"),null())->getFloats();		HX_STACK_VAR(times,"times");
			HX_STACK_LINE(727)
			{
				HX_STACK_LINE(727)
				int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(727)
				int _g1 = times->length;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(727)
				while((true)){
					HX_STACK_LINE(727)
					if ((!(((_g21 < _g1))))){
						HX_STACK_LINE(727)
						break;
					}
					HX_STACK_LINE(727)
					int i1 = (_g21)++;		HX_STACK_VAR(i1,"i1");
					HX_STACK_LINE(728)
					Float t = times->__get(i1);		HX_STACK_VAR(t,"t");
					HX_STACK_LINE(730)
					if (((hx::Mod(t,(int)100) != (int)0))){
						HX_STACK_LINE(731)
						hx::AddEq(t,((int)100 - hx::Mod(t,(int)100)));
						HX_STACK_LINE(732)
						times[i1] = t;
					}
					HX_STACK_LINE(735)
					int it = ::Std_obj::_int((Float(t) / Float((int)200000)));		HX_STACK_VAR(it,"it");
					HX_STACK_LINE(736)
					allTimes->set(it,t);
				}
			}
			HX_STACK_LINE(738)
			::h3d::fbx::FbxNode g = this->getParent(cn,HX_CSTRING("Deformer"),null());		HX_STACK_VAR(g,"g");
			HX_STACK_LINE(739)
			::String _g3 = cn->getName();		HX_STACK_VAR(_g3,"_g3");
			struct _Function_3_1{
				inline static Dynamic Block( ::h3d::fbx::FbxNode &g,::h3d::fbx::FbxNode &animCurve,::h3d::fbx::FbxNode &cn,::String &_g3){
					HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",739,0x38e70acc)
					{
						hx::Anon __result = hx::Anon_obj::Create();
						__result->Add(HX_CSTRING("name") , _g3,false);
						__result->Add(HX_CSTRING("cn") , cn,false);
						__result->Add(HX_CSTRING("ac") , animCurve,false);
						__result->Add(HX_CSTRING("shape") , g,false);
						return __result;
					}
					return null();
				}
			};
			HX_STACK_LINE(739)
			Dynamic _g4 = _Function_3_1::Block(g,animCurve,cn,_g3);		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(739)
			shapes->__Field(HX_CSTRING("push"),true)(_g4);
		}
	}
	HX_STACK_LINE(742)
	Array< Float > times = Array_obj< Float >::__new();		HX_STACK_VAR(times,"times");
	HX_STACK_LINE(743)
	for(::cpp::FastIterator_obj< Float > *__it = ::cpp::CreateFastIterator< Float >(allTimes->iterator());  __it->hasNext(); ){
		Float a = __it->next();
		times->push(a);
	}
	HX_STACK_LINE(745)
	Array< Float > allTimes1 = times;		HX_STACK_VAR(allTimes1,"allTimes1");
	HX_STACK_LINE(746)
	allTimes1->sort(this->sortDistinctFloats_dyn());
	HX_STACK_LINE(747)
	Float maxTime = allTimes1->__get((allTimes1->length - (int)1));		HX_STACK_VAR(maxTime,"maxTime");
	HX_STACK_LINE(748)
	Float minDT = maxTime;		HX_STACK_VAR(minDT,"minDT");
	HX_STACK_LINE(749)
	Float curT = allTimes1->__get((int)0);		HX_STACK_VAR(curT,"curT");
	HX_STACK_LINE(750)
	{
		HX_STACK_LINE(750)
		int _g1 = (int)1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(750)
		int _g = allTimes1->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(750)
		while((true)){
			HX_STACK_LINE(750)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(750)
				break;
			}
			HX_STACK_LINE(750)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(751)
			Float t = allTimes1->__get(i);		HX_STACK_VAR(t,"t");
			HX_STACK_LINE(752)
			Float dt = (t - curT);		HX_STACK_VAR(dt,"dt");
			HX_STACK_LINE(753)
			if (((dt < minDT))){
				HX_STACK_LINE(753)
				minDT = dt;
			}
			HX_STACK_LINE(754)
			curT = t;
		}
	}
	HX_STACK_LINE(756)
	int numFrames;		HX_STACK_VAR(numFrames,"numFrames");
	HX_STACK_LINE(756)
	if (((maxTime == (int)0))){
		HX_STACK_LINE(756)
		numFrames = (int)1;
	}
	else{
		HX_STACK_LINE(756)
		int _g5 = ::Std_obj::_int((Float(((maxTime - allTimes1->__get((int)0)))) / Float(minDT)));		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(756)
		numFrames = ((int)1 + _g5);
	}
	HX_STACK_LINE(757)
	Float sampling = (Float(15.0) / Float(((Float(minDT) / Float(3079077200)))));		HX_STACK_VAR(sampling,"sampling");
	HX_STACK_LINE(759)
	int i = (int)0;		HX_STACK_VAR(i,"i");
	HX_STACK_LINE(760)
	::h3d::anim::MorphFrameAnimation anim = null();		HX_STACK_VAR(anim,"anim");
	HX_STACK_LINE(761)
	switch( (int)(mode->__Index())){
		case (int)0: {
			HX_STACK_LINE(766)
			::h3d::anim::MorphFrameAnimation frAnim = ::h3d::anim::MorphFrameAnimation_obj::__new(animName,numFrames,sampling);		HX_STACK_VAR(frAnim,"frAnim");
			HX_STACK_LINE(767)
			::h3d::fbx::FbxNode model = this->getParent(shapes->__GetItem((int)0)->__Field(HX_CSTRING("shape"),true),HX_CSTRING("Deformer"),null());		HX_STACK_VAR(model,"model");
			HX_STACK_LINE(768)
			::h3d::fbx::FbxNode _g6 = this->getParent(model,HX_CSTRING("Geometry"),null());		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(768)
			model = _g6;
			HX_STACK_LINE(769)
			::h3d::fbx::FbxNode _g7 = this->getParent(model,HX_CSTRING("Model"),null());		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(769)
			model = _g7;
			HX_STACK_LINE(773)
			::String name = model->getName();		HX_STACK_VAR(name,"name");
			HX_STACK_LINE(775)
			::h3d::fbx::DefaultMatrixes def = this->defaultModelMatrixes->get(name);		HX_STACK_VAR(def,"def");
			HX_STACK_LINE(776)
			if (((def != null()))){
				HX_STACK_LINE(777)
				if (((def->wasRemoved != null()))){
					HX_STACK_LINE(778)
					::String newName = this->ids->get(def->wasRemoved)->__Field(HX_CSTRING("getName"),true)();		HX_STACK_VAR(newName,"newName");
					HX_STACK_LINE(779)
					{
						HX_STACK_LINE(779)
						Dynamic msg = (((HX_CSTRING("remapping morph anim from ") + name) + HX_CSTRING(" to ")) + newName);		HX_STACK_VAR(msg,"msg");
						HX_STACK_LINE(779)
						::String pos_fileName = HX_CSTRING("Library.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
						HX_STACK_LINE(779)
						int pos_lineNumber = (int)779;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
						HX_STACK_LINE(779)
						::String pos_className = HX_CSTRING("h3d.fbx.Library");		HX_STACK_VAR(pos_className,"pos_className");
						HX_STACK_LINE(779)
						::String pos_methodName = HX_CSTRING("loadMorphAnimation");		HX_STACK_VAR(pos_methodName,"pos_methodName");
						HX_STACK_LINE(779)
						if (((::hxd::System_obj::debugLevel >= (int)3))){
							HX_STACK_LINE(779)
							::String _g8 = ::Std_obj::string(msg);		HX_STACK_VAR(_g8,"_g8");
							HX_STACK_LINE(779)
							::String _g9 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g8);		HX_STACK_VAR(_g9,"_g9");
							HX_STACK_LINE(779)
							::haxe::Log_obj::trace(_g9,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
						}
						HX_STACK_LINE(779)
						msg;
					}
					HX_STACK_LINE(780)
					name = newName;
				}
			}
			HX_STACK_LINE(783)
			::h3d::anim::MorphObject obj;		HX_STACK_VAR(obj,"obj");
			HX_STACK_LINE(783)
			{
				HX_STACK_LINE(783)
				::h3d::anim::MorphObject fr = ::h3d::anim::MorphObject_obj::__new(name);		HX_STACK_VAR(fr,"fr");
				HX_STACK_LINE(783)
				frAnim->objects->push(fr);
				HX_STACK_LINE(783)
				Array< ::Dynamic > _g11;		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(783)
				{
					HX_STACK_LINE(783)
					Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(783)
					{
						HX_STACK_LINE(783)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(783)
						while((true)){
							HX_STACK_LINE(783)
							if ((!(((_g1 < shapes->__Field(HX_CSTRING("length"),true)))))){
								HX_STACK_LINE(783)
								break;
							}
							HX_STACK_LINE(783)
							int i1 = (_g1)++;		HX_STACK_VAR(i1,"i1");
							HX_STACK_LINE(783)
							Array< Float > _g10;		HX_STACK_VAR(_g10,"_g10");
							HX_STACK_LINE(783)
							{
								HX_STACK_LINE(783)
								Array< Float > _g21 = Array_obj< Float >::__new();		HX_STACK_VAR(_g21,"_g21");
								HX_STACK_LINE(783)
								{
									HX_STACK_LINE(783)
									int _g4 = (int)0;		HX_STACK_VAR(_g4,"_g4");
									HX_STACK_LINE(783)
									int _g3 = frAnim->frameCount;		HX_STACK_VAR(_g3,"_g3");
									HX_STACK_LINE(783)
									while((true)){
										HX_STACK_LINE(783)
										if ((!(((_g4 < _g3))))){
											HX_STACK_LINE(783)
											break;
										}
										HX_STACK_LINE(783)
										int j = (_g4)++;		HX_STACK_VAR(j,"j");
										HX_STACK_LINE(783)
										_g21->push(0.0);
									}
								}
								HX_STACK_LINE(783)
								_g10 = _g21;
							}
							HX_STACK_LINE(783)
							_g->push(_g10);
						}
					}
					HX_STACK_LINE(783)
					_g11 = _g;
				}
				HX_STACK_LINE(783)
				fr->ratio = _g11;
				HX_STACK_LINE(783)
				obj = fr;
			}
			HX_STACK_LINE(785)
			int shapeIndex = (int)0;		HX_STACK_VAR(shapeIndex,"shapeIndex");
			HX_STACK_LINE(786)
			{
				HX_STACK_LINE(786)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(786)
				while((true)){
					HX_STACK_LINE(786)
					if ((!(((_g < shapes->__Field(HX_CSTRING("length"),true)))))){
						HX_STACK_LINE(786)
						break;
					}
					HX_STACK_LINE(786)
					Dynamic s = shapes->__GetItem(_g);		HX_STACK_VAR(s,"s");
					HX_STACK_LINE(786)
					++(_g);
					HX_STACK_LINE(787)
					::h3d::fbx::FbxNode cn = s->__Field(HX_CSTRING("cn"),true);		HX_STACK_VAR(cn,"cn");
					HX_STACK_LINE(788)
					::h3d::fbx::FbxNode ac = s->__Field(HX_CSTRING("ac"),true);		HX_STACK_VAR(ac,"ac");
					HX_STACK_LINE(789)
					::h3d::fbx::FbxNode shape = s->__Field(HX_CSTRING("shape"),true);		HX_STACK_VAR(shape,"shape");
					HX_STACK_LINE(790)
					Array< Float > weights = ac->get(HX_CSTRING("KeyValueFloat"),null())->getFloats();		HX_STACK_VAR(weights,"weights");
					HX_STACK_LINE(791)
					::String _g12 = this->getChild(shape,HX_CSTRING("Geometry"),null())->getName();		HX_STACK_VAR(_g12,"_g12");
					HX_STACK_LINE(791)
					::h3d::fbx::Geometry geom = this->getGeometry(_g12);		HX_STACK_VAR(geom,"geom");
					HX_STACK_LINE(793)
					Array< int > pidx = geom->getShapeIndexes();		HX_STACK_VAR(pidx,"pidx");
					HX_STACK_LINE(794)
					Array< Float > pvtx = geom->getVertices();		HX_STACK_VAR(pvtx,"pvtx");
					HX_STACK_LINE(795)
					Array< Float > pnrm = geom->getShapeNormals();		HX_STACK_VAR(pnrm,"pnrm");
					HX_STACK_LINE(797)
					Array< int > index;		HX_STACK_VAR(index,"index");
					HX_STACK_LINE(797)
					{
						HX_STACK_LINE(797)
						Array< int > a = pidx;		HX_STACK_VAR(a,"a");
						HX_STACK_LINE(797)
						Array< int > v;		HX_STACK_VAR(v,"v");
						struct _Function_5_1{
							inline static Array< int > Block( Array< int > &a){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",797,0x38e70acc)
								{
									HX_STACK_LINE(797)
									Array< int > this1;		HX_STACK_VAR(this1,"this1");
									HX_STACK_LINE(797)
									Array< int > _g13 = Array_obj< int >::__new()->__SetSizeExact(a->length);		HX_STACK_VAR(_g13,"_g13");
									HX_STACK_LINE(797)
									this1 = _g13;
									HX_STACK_LINE(797)
									return this1;
								}
								return null();
							}
						};
						HX_STACK_LINE(797)
						v = _Function_5_1::Block(a);
						HX_STACK_LINE(797)
						{
							HX_STACK_LINE(797)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(797)
							int _g1 = a->length;		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(797)
							while((true)){
								HX_STACK_LINE(797)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(797)
									break;
								}
								HX_STACK_LINE(797)
								int i1 = (_g21)++;		HX_STACK_VAR(i1,"i1");
								HX_STACK_LINE(797)
								v->__unsafe_set(i1,a->__get(i1));
							}
						}
						HX_STACK_LINE(797)
						index = v;
					}
					HX_STACK_LINE(798)
					Array< Float > vertex;		HX_STACK_VAR(vertex,"vertex");
					HX_STACK_LINE(798)
					{
						HX_STACK_LINE(798)
						Array< Float > a = pvtx;		HX_STACK_VAR(a,"a");
						HX_STACK_LINE(798)
						Array< Float > v;		HX_STACK_VAR(v,"v");
						struct _Function_5_1{
							inline static Array< Float > Block( Array< Float > &a){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",798,0x38e70acc)
								{
									HX_STACK_LINE(798)
									Array< Float > this1;		HX_STACK_VAR(this1,"this1");
									HX_STACK_LINE(798)
									Array< Float > _g14 = Array_obj< Float >::__new()->__SetSizeExact(a->length);		HX_STACK_VAR(_g14,"_g14");
									HX_STACK_LINE(798)
									this1 = _g14;
									HX_STACK_LINE(798)
									return this1;
								}
								return null();
							}
						};
						HX_STACK_LINE(798)
						v = _Function_5_1::Block(a);
						HX_STACK_LINE(798)
						{
							HX_STACK_LINE(798)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(798)
							int _g1 = a->length;		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(798)
							while((true)){
								HX_STACK_LINE(798)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(798)
									break;
								}
								HX_STACK_LINE(798)
								int i1 = (_g21)++;		HX_STACK_VAR(i1,"i1");
								HX_STACK_LINE(798)
								v->__unsafe_set(i1,a->__get(i1));
							}
						}
						HX_STACK_LINE(798)
						vertex = v;
					}
					HX_STACK_LINE(799)
					Array< Float > normal;		HX_STACK_VAR(normal,"normal");
					HX_STACK_LINE(799)
					{
						HX_STACK_LINE(799)
						Array< Float > a = pnrm;		HX_STACK_VAR(a,"a");
						HX_STACK_LINE(799)
						Array< Float > v;		HX_STACK_VAR(v,"v");
						struct _Function_5_1{
							inline static Array< Float > Block( Array< Float > &a){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",799,0x38e70acc)
								{
									HX_STACK_LINE(799)
									Array< Float > this1;		HX_STACK_VAR(this1,"this1");
									HX_STACK_LINE(799)
									Array< Float > _g15 = Array_obj< Float >::__new()->__SetSizeExact(a->length);		HX_STACK_VAR(_g15,"_g15");
									HX_STACK_LINE(799)
									this1 = _g15;
									HX_STACK_LINE(799)
									return this1;
								}
								return null();
							}
						};
						HX_STACK_LINE(799)
						v = _Function_5_1::Block(a);
						HX_STACK_LINE(799)
						{
							HX_STACK_LINE(799)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(799)
							int _g1 = a->length;		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(799)
							while((true)){
								HX_STACK_LINE(799)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(799)
									break;
								}
								HX_STACK_LINE(799)
								int i1 = (_g21)++;		HX_STACK_VAR(i1,"i1");
								HX_STACK_LINE(799)
								v->__unsafe_set(i1,a->__get(i1));
							}
						}
						HX_STACK_LINE(799)
						normal = v;
					}
					HX_STACK_LINE(801)
					{
						HX_STACK_LINE(801)
						::h3d::anim::MorphShape f = ::h3d::anim::MorphShape_obj::__new(index,vertex,normal);		HX_STACK_VAR(f,"f");
						HX_STACK_LINE(801)
						f->index = index;
						HX_STACK_LINE(801)
						f->vertex = vertex;
						HX_STACK_LINE(801)
						f->normal = normal;
						HX_STACK_LINE(801)
						frAnim->shapes->push(f);
					}
					HX_STACK_LINE(803)
					{
						HX_STACK_LINE(803)
						int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(803)
						int _g1 = weights->length;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(803)
						while((true)){
							HX_STACK_LINE(803)
							if ((!(((_g21 < _g1))))){
								HX_STACK_LINE(803)
								break;
							}
							HX_STACK_LINE(803)
							int i1 = (_g21)++;		HX_STACK_VAR(i1,"i1");
							HX_STACK_LINE(803)
							obj->ratio->__get(shapeIndex).StaticCast< Array< Float > >()[i1] = (weights->__get(i1) * 0.01);
						}
					}
					HX_STACK_LINE(805)
					(shapeIndex)++;
				}
			}
			HX_STACK_LINE(807)
			anim = frAnim;
		}
		;break;
		default: {
			HX_STACK_LINE(762)
			HX_STACK_DO_THROW(HX_CSTRING("not supportd yet"));
		}
	}
	HX_STACK_LINE(811)
	return anim;
}


HX_DEFINE_DYNAMIC_FUNC4(Library_obj,loadMorphAnimation,return )

bool Library_obj::isNullJoint( ::h3d::fbx::FbxNode model){
	HX_STACK_FRAME("h3d.fbx.Library","isNullJoint",0xcb92abff,"h3d.fbx.Library.isNullJoint","h3d/fbx/Library.hx",814,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(model,"model")
	HX_STACK_LINE(815)
	::h3d::fbx::FbxNode _g = this->getParent(model,HX_CSTRING("Deformer"),true);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(815)
	if (((_g != null()))){
		HX_STACK_LINE(816)
		return false;
	}
	HX_STACK_LINE(817)
	::h3d::fbx::FbxNode parent = this->getParent(model,HX_CSTRING("Model"),true);		HX_STACK_VAR(parent,"parent");
	HX_STACK_LINE(818)
	if (((parent == null()))){
		HX_STACK_LINE(819)
		return true;
	}
	HX_STACK_LINE(820)
	::String t = parent->getType();		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(821)
	if (((bool((t == HX_CSTRING("LimbNode"))) || bool((t == HX_CSTRING("Root")))))){
		HX_STACK_LINE(822)
		return false;
	}
	HX_STACK_LINE(823)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,isNullJoint,return )

int Library_obj::sortDistinctFloats( Float a,Float b){
	HX_STACK_FRAME("h3d.fbx.Library","sortDistinctFloats",0xc0ff916b,"h3d.fbx.Library.sortDistinctFloats","h3d/fbx/Library.hx",827,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(827)
	if (((a > b))){
		HX_STACK_LINE(827)
		return (int)1;
	}
	else{
		HX_STACK_LINE(827)
		return (int)-1;
	}
	HX_STACK_LINE(827)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC2(Library_obj,sortDistinctFloats,return )

::h3d::scene::Object Library_obj::makeObject( Dynamic textureLoader,hx::Null< bool >  __o_dynamicVertices){
bool dynamicVertices = __o_dynamicVertices.Default(false);
	HX_STACK_FRAME("h3d.fbx.Library","makeObject",0x60c64207,"h3d.fbx.Library.makeObject","h3d/fbx/Library.hx",834,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(textureLoader,"textureLoader")
	HX_STACK_ARG(dynamicVertices,"dynamicVertices")
{
		HX_STACK_LINE(835)
		::h3d::scene::Object scene = ::h3d::scene::Object_obj::__new(null());		HX_STACK_VAR(scene,"scene");
		HX_STACK_LINE(836)
		scene->name = HX_CSTRING("FbxLibrary Object");
		HX_STACK_LINE(837)
		::haxe::ds::IntMap hobjects = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(hobjects,"hobjects");
		HX_STACK_LINE(838)
		::haxe::ds::IntMap hgeom = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(hgeom,"hgeom");
		HX_STACK_LINE(839)
		Dynamic objects = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(objects,"objects");
		HX_STACK_LINE(840)
		::haxe::ds::IntMap hjoints = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(hjoints,"hjoints");
		HX_STACK_LINE(841)
		Dynamic joints = Dynamic( Array_obj<Dynamic>::__new() );		HX_STACK_VAR(joints,"joints");
		HX_STACK_LINE(842)
		::haxe::ds::IntMap hskins = ::haxe::ds::IntMap_obj::__new();		HX_STACK_VAR(hskins,"hskins");
		HX_STACK_LINE(844)
		if (((textureLoader == null()))){
			HX_STACK_LINE(845)
			Array< ::Dynamic > tmpTex = Array_obj< ::Dynamic >::__new().Add(null());		HX_STACK_VAR(tmpTex,"tmpTex");

			HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_2_1,Array< ::Dynamic >,tmpTex)
			::h3d::mat::MeshMaterial run(::String _,::h3d::fbx::FbxNode _1){
				HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","h3d/fbx/Library.hx",846,0x38e70acc)
				HX_STACK_ARG(_,"_")
				HX_STACK_ARG(_1,"_1")
				{
					HX_STACK_LINE(847)
					if (((tmpTex->__get((int)0).StaticCast< ::h3d::mat::Texture >() == null()))){
						HX_STACK_LINE(848)
						tmpTex[(int)0] = ::h3d::mat::Texture_obj::fromColor((int)-65281,hx::SourceInfo(HX_CSTRING("Library.hx"),848,HX_CSTRING("h3d.fbx.Library"),HX_CSTRING("makeObject")));
					}
					HX_STACK_LINE(849)
					return ::h3d::mat::MeshMaterial_obj::__new(tmpTex->__get((int)0).StaticCast< ::h3d::mat::Texture >(),null());
				}
				return null();
			}
			HX_END_LOCAL_FUNC2(return)

			HX_STACK_LINE(846)
			textureLoader =  Dynamic(new _Function_2_1(tmpTex));
		}
		HX_STACK_LINE(854)
		{
			HX_STACK_LINE(854)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(854)
			Array< ::Dynamic > _g1 = this->root->getAll(HX_CSTRING("Objects.Model"));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(854)
			while((true)){
				HX_STACK_LINE(854)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(854)
					break;
				}
				HX_STACK_LINE(854)
				::h3d::fbx::FbxNode model = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(model,"model");
				HX_STACK_LINE(854)
				++(_g);
				HX_STACK_LINE(855)
				::h3d::scene::Object o;		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(856)
				::String name = model->getName();		HX_STACK_VAR(name,"name");
				HX_STACK_LINE(857)
				if ((this->skipObjects->get(name))){
					HX_STACK_LINE(858)
					continue;
				}
				HX_STACK_LINE(859)
				::String mtype = model->getType();		HX_STACK_VAR(mtype,"mtype");
				HX_STACK_LINE(860)
				if (((  (((bool(this->unskinnedJointsAsObjects) && bool((mtype == HX_CSTRING("LimbNode")))))) ? bool(this->isNullJoint(model)) : bool(false) ))){
					HX_STACK_LINE(861)
					mtype = HX_CSTRING("Null");
				}
				HX_STACK_LINE(862)
				{
					HX_STACK_LINE(862)
					::String type = mtype;		HX_STACK_VAR(type,"type");
					HX_STACK_LINE(862)
					::String _switch_5 = (mtype);
					if (  ( _switch_5==HX_CSTRING("Null")) ||  ( _switch_5==HX_CSTRING("Root")) ||  ( _switch_5==HX_CSTRING("Camera"))){
						HX_STACK_LINE(864)
						bool hasJoint = false;		HX_STACK_VAR(hasJoint,"hasJoint");
						HX_STACK_LINE(865)
						{
							HX_STACK_LINE(865)
							int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(865)
							Array< ::Dynamic > _g3 = this->getChilds(model,HX_CSTRING("Model"));		HX_STACK_VAR(_g3,"_g3");
							HX_STACK_LINE(865)
							while((true)){
								HX_STACK_LINE(865)
								if ((!(((_g2 < _g3->length))))){
									HX_STACK_LINE(865)
									break;
								}
								HX_STACK_LINE(865)
								::h3d::fbx::FbxNode c = _g3->__get(_g2).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(c,"c");
								HX_STACK_LINE(865)
								++(_g2);
								HX_STACK_LINE(866)
								::String _g4 = c->getType();		HX_STACK_VAR(_g4,"_g4");
								HX_STACK_LINE(866)
								if (((_g4 == HX_CSTRING("LimbNode")))){
									HX_STACK_LINE(867)
									if (((  ((this->unskinnedJointsAsObjects)) ? bool(this->isNullJoint(c)) : bool(false) ))){
										HX_STACK_LINE(867)
										continue;
									}
									HX_STACK_LINE(868)
									hasJoint = true;
									HX_STACK_LINE(869)
									break;
								}
							}
						}
						HX_STACK_LINE(871)
						if ((hasJoint)){
							HX_STACK_LINE(872)
							::h3d::scene::Skin _g11 = ::h3d::scene::Skin_obj::__new(null(),null(),scene);		HX_STACK_VAR(_g11,"_g11");
							HX_STACK_LINE(872)
							o = _g11;
						}
						else{
							HX_STACK_LINE(874)
							::h3d::scene::Object _g2 = ::h3d::scene::Object_obj::__new(scene);		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(874)
							o = _g2;
						}
					}
					else if (  ( _switch_5==HX_CSTRING("LimbNode"))){
						HX_STACK_LINE(876)
						::h3d::anim::Joint j = ::h3d::anim::Joint_obj::__new();		HX_STACK_VAR(j,"j");
						HX_STACK_LINE(877)
						this->getDefaultMatrixes(model);
						HX_STACK_LINE(878)
						int _g3 = model->getId();		HX_STACK_VAR(_g3,"_g3");
						HX_STACK_LINE(878)
						j->index = _g3;
						HX_STACK_LINE(879)
						::String _g4 = model->getName();		HX_STACK_VAR(_g4,"_g4");
						HX_STACK_LINE(879)
						j->name = _g4;
						HX_STACK_LINE(880)
						hjoints->set(j->index,j);
						struct _Function_5_1{
							inline static Dynamic Block( ::h3d::anim::Joint &j,::h3d::fbx::FbxNode &model){
								HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",881,0x38e70acc)
								{
									hx::Anon __result = hx::Anon_obj::Create();
									__result->Add(HX_CSTRING("model") , model,false);
									__result->Add(HX_CSTRING("joint") , j,false);
									return __result;
								}
								return null();
							}
						};
						HX_STACK_LINE(881)
						joints->__Field(HX_CSTRING("push"),true)(_Function_5_1::Block(j,model));
						HX_STACK_LINE(882)
						continue;
					}
					else if (  ( _switch_5==HX_CSTRING("Mesh"))){
						HX_STACK_LINE(885)
						::h3d::fbx::FbxNode g = this->getChild(model,HX_CSTRING("Geometry"),null());		HX_STACK_VAR(g,"g");
						HX_STACK_LINE(886)
						::h3d::prim::FBXModel prim;		HX_STACK_VAR(prim,"prim");
						HX_STACK_LINE(886)
						{
							HX_STACK_LINE(886)
							int key = g->getId();		HX_STACK_VAR(key,"key");
							HX_STACK_LINE(886)
							prim = hgeom->get(key);
						}
						HX_STACK_LINE(887)
						if (((prim == null()))){
							HX_STACK_LINE(888)
							::h3d::fbx::Geometry _g5 = ::h3d::fbx::Geometry_obj::__new(hx::ObjectPtr<OBJ_>(this),g);		HX_STACK_VAR(_g5,"_g5");
							HX_STACK_LINE(888)
							::h3d::prim::FBXModel _g6 = ::h3d::prim::FBXModel_obj::__new(_g5,null());		HX_STACK_VAR(_g6,"_g6");
							HX_STACK_LINE(888)
							prim = _g6;
							HX_STACK_LINE(889)
							{
								HX_STACK_LINE(889)
								int key = g->getId();		HX_STACK_VAR(key,"key");
								HX_STACK_LINE(889)
								hgeom->set(key,prim);
							}
						}
						HX_STACK_LINE(892)
						Array< ::Dynamic > mats = this->getChilds(model,HX_CSTRING("Material"));		HX_STACK_VAR(mats,"mats");
						HX_STACK_LINE(893)
						Array< ::Dynamic > tmats = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(tmats,"tmats");
						HX_STACK_LINE(894)
						Dynamic _g7 = prim->geom->getColors();		HX_STACK_VAR(_g7,"_g7");
						HX_STACK_LINE(894)
						bool vcolor = (_g7 != null());		HX_STACK_VAR(vcolor,"vcolor");
						HX_STACK_LINE(895)
						int lastAdded = (int)0;		HX_STACK_VAR(lastAdded,"lastAdded");
						HX_STACK_LINE(896)
						{
							HX_STACK_LINE(896)
							int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(896)
							while((true)){
								HX_STACK_LINE(896)
								if ((!(((_g2 < mats->length))))){
									HX_STACK_LINE(896)
									break;
								}
								HX_STACK_LINE(896)
								::h3d::fbx::FbxNode mat = mats->__get(_g2).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(mat,"mat");
								HX_STACK_LINE(896)
								++(_g2);
								HX_STACK_LINE(897)
								Array< ::Dynamic > _g8 = this->getChilds(mat,HX_CSTRING("Texture"));		HX_STACK_VAR(_g8,"_g8");
								HX_STACK_LINE(897)
								::h3d::fbx::FbxNode tex = _g8->__get((int)0).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(tex,"tex");
								HX_STACK_LINE(898)
								if (((tex == null()))){
									HX_STACK_LINE(899)
									tmats->push(null());
									HX_STACK_LINE(900)
									continue;
								}
								HX_STACK_LINE(902)
								::String _g9 = ::h3d::fbx::FBxTools_obj::toString(tex->get(HX_CSTRING("RelativeFilename"),null())->props->__get((int)0).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g9,"_g9");
								HX_STACK_LINE(902)
								::h3d::mat::MeshMaterial mat1 = textureLoader(_g9,mat).Cast< ::h3d::mat::MeshMaterial >();		HX_STACK_VAR(mat1,"mat1");
								HX_STACK_LINE(903)
								if ((vcolor)){
									HX_STACK_LINE(904)
									{
										HX_STACK_LINE(904)
										::String pos_fileName = HX_CSTRING("Library.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
										HX_STACK_LINE(904)
										int pos_lineNumber = (int)904;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
										HX_STACK_LINE(904)
										::String pos_className = HX_CSTRING("h3d.fbx.Library");		HX_STACK_VAR(pos_className,"pos_className");
										HX_STACK_LINE(904)
										::String pos_methodName = HX_CSTRING("makeObject");		HX_STACK_VAR(pos_methodName,"pos_methodName");
										HX_STACK_LINE(904)
										if (((::hxd::System_obj::debugLevel >= (int)3))){
											HX_STACK_LINE(904)
											::String _g10 = HX_CSTRING("detected vertex color");		HX_STACK_VAR(_g10,"_g10");
											HX_STACK_LINE(904)
											::String _g11 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g10);		HX_STACK_VAR(_g11,"_g11");
											HX_STACK_LINE(904)
											::haxe::Log_obj::trace(_g11,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
										}
										HX_STACK_LINE(904)
										HX_CSTRING("detected vertex color");
									}
									HX_STACK_LINE(905)
									mat1->get_mshader()->hasVertexColor = true;
								}
								HX_STACK_LINE(907)
								if (((mat1 == null()))){
									HX_STACK_LINE(907)
									::String pos_fileName = HX_CSTRING("Library.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
									HX_STACK_LINE(907)
									int pos_lineNumber = (int)907;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
									HX_STACK_LINE(907)
									::String pos_className = HX_CSTRING("h3d.fbx.Library");		HX_STACK_VAR(pos_className,"pos_className");
									HX_STACK_LINE(907)
									::String pos_methodName = HX_CSTRING("makeObject");		HX_STACK_VAR(pos_methodName,"pos_methodName");
									HX_STACK_LINE(907)
									if (((::hxd::System_obj::debugLevel >= (int)3))){
										HX_STACK_LINE(907)
										::String _g12 = HX_CSTRING("null mat detected");		HX_STACK_VAR(_g12,"_g12");
										HX_STACK_LINE(907)
										::String _g13 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g12);		HX_STACK_VAR(_g13,"_g13");
										HX_STACK_LINE(907)
										::haxe::Log_obj::trace(_g13,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
									}
									HX_STACK_LINE(907)
									HX_CSTRING("null mat detected");
								}
								HX_STACK_LINE(908)
								tmats->push(mat1);
								HX_STACK_LINE(909)
								lastAdded = tmats->length;
							}
						}
						HX_STACK_LINE(912)
						while((true)){
							HX_STACK_LINE(912)
							if ((!(((tmats->length > lastAdded))))){
								HX_STACK_LINE(912)
								break;
							}
							HX_STACK_LINE(913)
							tmats->pop().StaticCast< ::h3d::mat::MeshMaterial >();
						}

						HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_5_1)
						::h3d::mat::MeshMaterial run(){
							HX_STACK_FRAME("*","_Function_5_1",0x5203f63b,"*._Function_5_1","h3d/fbx/Library.hx",915,0x38e70acc)
							{
								HX_STACK_LINE(915)
								::h3d::mat::Texture _g14 = ::h2d::Tile_obj::fromColor((int)-65281,null(),null(),hx::SourceInfo(HX_CSTRING("Library.hx"),915,HX_CSTRING("h3d.fbx.Library"),HX_CSTRING("makeObject")))->getTexture();		HX_STACK_VAR(_g14,"_g14");
								HX_STACK_LINE(915)
								return ::h3d::mat::MeshMaterial_obj::__new(_g14,null());
							}
							return null();
						}
						HX_END_LOCAL_FUNC0(return)

						HX_STACK_LINE(915)
						Dynamic defaultMat =  Dynamic(new _Function_5_1());		HX_STACK_VAR(defaultMat,"defaultMat");
						HX_STACK_LINE(917)
						if (((tmats->length == (int)0))){
							HX_STACK_LINE(918)
							::h3d::mat::MeshMaterial _g15 = defaultMat().Cast< ::h3d::mat::MeshMaterial >();		HX_STACK_VAR(_g15,"_g15");
							HX_STACK_LINE(918)
							tmats->push(_g15);
						}
						HX_STACK_LINE(921)
						int i = (int)0;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(922)
						{
							HX_STACK_LINE(922)
							int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
							HX_STACK_LINE(922)
							while((true)){
								HX_STACK_LINE(922)
								if ((!(((_g2 < tmats->length))))){
									HX_STACK_LINE(922)
									break;
								}
								HX_STACK_LINE(922)
								::h3d::mat::MeshMaterial tm = tmats->__get(_g2).StaticCast< ::h3d::mat::MeshMaterial >();		HX_STACK_VAR(tm,"tm");
								HX_STACK_LINE(922)
								++(_g2);
								HX_STACK_LINE(923)
								if (((tm == null()))){
									HX_STACK_LINE(924)
									tmats[i] = defaultMat().Cast< ::h3d::mat::MeshMaterial >();
								}
								HX_STACK_LINE(925)
								(i)++;
							}
						}
						HX_STACK_LINE(929)
						if (((tmats->length == (int)1))){
							HX_STACK_LINE(930)
							::h3d::scene::Mesh _g16 = ::h3d::scene::Mesh_obj::__new(prim,tmats->__get((int)0).StaticCast< ::h3d::mat::MeshMaterial >(),scene);		HX_STACK_VAR(_g16,"_g16");
							HX_STACK_LINE(930)
							o = _g16;
						}
						else{
							HX_STACK_LINE(932)
							prim->multiMaterial = true;
							HX_STACK_LINE(933)
							::h3d::scene::MultiMaterial _g17 = ::h3d::scene::MultiMaterial_obj::__new(prim,tmats,scene);		HX_STACK_VAR(_g17,"_g17");
							HX_STACK_LINE(933)
							o = _g17;
						}
						HX_STACK_LINE(936)
						{
							HX_STACK_LINE(936)
							Dynamic msg = (HX_CSTRING("read Mesh : ") + name);		HX_STACK_VAR(msg,"msg");
							HX_STACK_LINE(936)
							::String pos_fileName = HX_CSTRING("Library.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
							HX_STACK_LINE(936)
							int pos_lineNumber = (int)936;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
							HX_STACK_LINE(936)
							::String pos_className = HX_CSTRING("h3d.fbx.Library");		HX_STACK_VAR(pos_className,"pos_className");
							HX_STACK_LINE(936)
							::String pos_methodName = HX_CSTRING("makeObject");		HX_STACK_VAR(pos_methodName,"pos_methodName");
							HX_STACK_LINE(936)
							if (((::hxd::System_obj::debugLevel >= (int)3))){
								HX_STACK_LINE(936)
								::String _g18 = ::Std_obj::string(msg);		HX_STACK_VAR(_g18,"_g18");
								HX_STACK_LINE(936)
								::String _g19 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g18);		HX_STACK_VAR(_g19,"_g19");
								HX_STACK_LINE(936)
								::haxe::Log_obj::trace(_g19,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
							}
							HX_STACK_LINE(936)
							msg;
						}
						HX_STACK_LINE(937)
						if ((this->hasChild(g,HX_CSTRING("Deformer")))){

							HX_BEGIN_LOCAL_FUNC_S0(hx::LocalFunc,_Function_6_1)
							bool run(::h3d::fbx::FbxNode n){
								HX_STACK_FRAME("*","_Function_6_1",0x5204b87c,"*._Function_6_1","h3d/fbx/Library.hx",938,0x38e70acc)
								HX_STACK_ARG(n,"n")
								{
									HX_STACK_LINE(938)
									return (n->getType() == HX_CSTRING("BlendShape"));
								}
								return null();
							}
							HX_END_LOCAL_FUNC1(return)

							HX_STACK_LINE(938)
							Array< ::Dynamic > blendShapes = this->getChilds(g,HX_CSTRING("Deformer"))->filter( Dynamic(new _Function_6_1()));		HX_STACK_VAR(blendShapes,"blendShapes");
							HX_STACK_LINE(939)
							if (((blendShapes->length > (int)1))){
								HX_STACK_LINE(939)
								HX_STACK_DO_THROW(HX_CSTRING("unsupported multiple morph for now"));
							}
							HX_STACK_LINE(941)
							::h3d::fbx::FbxNode blendShape = blendShapes->__get((int)0).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(blendShape,"blendShape");
							HX_STACK_LINE(942)
							if (((blendShape != null()))){
								HX_STACK_LINE(943)
								int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
								HX_STACK_LINE(943)
								Array< ::Dynamic > _g3 = this->getChilds(blendShape,null());		HX_STACK_VAR(_g3,"_g3");
								HX_STACK_LINE(943)
								while((true)){
									HX_STACK_LINE(943)
									if ((!(((_g2 < _g3->length))))){
										HX_STACK_LINE(943)
										break;
									}
									HX_STACK_LINE(943)
									::h3d::fbx::FbxNode bs = _g3->__get(_g2).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(bs,"bs");
									HX_STACK_LINE(943)
									++(_g2);
									HX_STACK_LINE(944)
									::h3d::fbx::FbxNode _g20 = this->getChild(bs,HX_CSTRING("Geometry"),null());		HX_STACK_VAR(_g20,"_g20");
									HX_STACK_LINE(944)
									::h3d::fbx::Geometry _g21 = ::h3d::fbx::Geometry_obj::__new(hx::ObjectPtr<OBJ_>(this),_g20);		HX_STACK_VAR(_g21,"_g21");
									HX_STACK_LINE(944)
									prim->blendShapes->push(_g21);
									HX_STACK_LINE(945)
									{
										HX_STACK_LINE(945)
										::String pos_fileName = HX_CSTRING("Library.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
										HX_STACK_LINE(945)
										int pos_lineNumber = (int)945;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
										HX_STACK_LINE(945)
										::String pos_className = HX_CSTRING("h3d.fbx.Library");		HX_STACK_VAR(pos_className,"pos_className");
										HX_STACK_LINE(945)
										::String pos_methodName = HX_CSTRING("makeObject");		HX_STACK_VAR(pos_methodName,"pos_methodName");
										HX_STACK_LINE(945)
										if (((::hxd::System_obj::debugLevel >= (int)3))){
											HX_STACK_LINE(945)
											::String _g22 = HX_CSTRING("Adding blendshape");		HX_STACK_VAR(_g22,"_g22");
											HX_STACK_LINE(945)
											::String _g23 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g22);		HX_STACK_VAR(_g23,"_g23");
											HX_STACK_LINE(945)
											::haxe::Log_obj::trace(_g23,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
										}
										HX_STACK_LINE(945)
										HX_CSTRING("Adding blendshape");
									}
								}
							}
						}
					}
					else  {
						HX_STACK_LINE(949)
						::String _g24 = model->getName();		HX_STACK_VAR(_g24,"_g24");
						HX_STACK_LINE(949)
						HX_STACK_DO_THROW((((HX_CSTRING("Unknown model type ") + type) + HX_CSTRING(" for ")) + _g24));
					}
;
;
				}
				HX_STACK_LINE(951)
				o->name = name;
				HX_STACK_LINE(952)
				::h3d::fbx::DefaultMatrixes m = this->getDefaultMatrixes(model);		HX_STACK_VAR(m,"m");
				HX_STACK_LINE(953)
				if (((bool((bool((bool((m->trans != null())) || bool((m->rotate != null())))) || bool((m->scale != null())))) || bool((m->preRot != null()))))){
					HX_STACK_LINE(954)
					::h3d::Matrix v = m->toMatrix(this->leftHand);		HX_STACK_VAR(v,"v");
					HX_STACK_LINE(954)
					o->defaultTransform = v;
					HX_STACK_LINE(954)
					o->posChanged = true;
					HX_STACK_LINE(954)
					v;
				}
				HX_STACK_LINE(955)
				{
					HX_STACK_LINE(955)
					int key = model->getId();		HX_STACK_VAR(key,"key");
					HX_STACK_LINE(955)
					hobjects->set(key,o);
				}
				struct _Function_3_1{
					inline static Dynamic Block( ::h3d::scene::Object &o,::h3d::fbx::FbxNode &model){
						HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",956,0x38e70acc)
						{
							hx::Anon __result = hx::Anon_obj::Create();
							__result->Add(HX_CSTRING("model") , model,false);
							__result->Add(HX_CSTRING("obj") , o,false);
							return __result;
						}
						return null();
					}
				};
				HX_STACK_LINE(956)
				objects->__Field(HX_CSTRING("push"),true)(_Function_3_1::Block(o,model));
			}
		}
		HX_STACK_LINE(959)
		{
			HX_STACK_LINE(959)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(959)
			while((true)){
				HX_STACK_LINE(959)
				if ((!(((_g < joints->__Field(HX_CSTRING("length"),true)))))){
					HX_STACK_LINE(959)
					break;
				}
				HX_STACK_LINE(959)
				Dynamic j = joints->__GetItem(_g);		HX_STACK_VAR(j,"j");
				HX_STACK_LINE(959)
				++(_g);
				HX_STACK_LINE(960)
				::h3d::fbx::FbxNode p = this->getParent(j->__Field(HX_CSTRING("model"),true),HX_CSTRING("Model"),null());		HX_STACK_VAR(p,"p");
				HX_STACK_LINE(961)
				::h3d::anim::Joint jparent;		HX_STACK_VAR(jparent,"jparent");
				HX_STACK_LINE(961)
				{
					HX_STACK_LINE(961)
					int key = p->getId();		HX_STACK_VAR(key,"key");
					HX_STACK_LINE(961)
					jparent = hjoints->get(key);
				}
				HX_STACK_LINE(962)
				if (((jparent != null()))){
					HX_STACK_LINE(963)
					jparent->subs->push(j->__Field(HX_CSTRING("joint"),true));
					HX_STACK_LINE(964)
					j->__Field(HX_CSTRING("joint"),true)->__FieldRef(HX_CSTRING("parent")) = jparent;
				}
				else{
					HX_STACK_LINE(965)
					::String _g25 = p->getType();		HX_STACK_VAR(_g25,"_g25");
					struct _Function_4_1{
						inline static bool Block( ::h3d::fbx::FbxNode &p){
							HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",965,0x38e70acc)
							{
								HX_STACK_LINE(965)
								::String _g26 = p->getType();		HX_STACK_VAR(_g26,"_g26");
								HX_STACK_LINE(965)
								return (_g26 != HX_CSTRING("Null"));
							}
							return null();
						}
					};
					HX_STACK_LINE(965)
					if (((  (((_g25 != HX_CSTRING("Root")))) ? bool(_Function_4_1::Block(p)) : bool(false) ))){
						HX_STACK_LINE(966)
						::String _g27 = p->getName();		HX_STACK_VAR(_g27,"_g27");
						HX_STACK_LINE(966)
						HX_STACK_DO_THROW((HX_CSTRING("Parent joint not found ") + _g27));
					}
				}
			}
		}
		HX_STACK_LINE(969)
		{
			HX_STACK_LINE(969)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(969)
			while((true)){
				HX_STACK_LINE(969)
				if ((!(((_g < objects->__Field(HX_CSTRING("length"),true)))))){
					HX_STACK_LINE(969)
					break;
				}
				HX_STACK_LINE(969)
				Dynamic o = objects->__GetItem(_g);		HX_STACK_VAR(o,"o");
				HX_STACK_LINE(969)
				++(_g);
				HX_STACK_LINE(971)
				{
					HX_STACK_LINE(971)
					::String _g28 = ::Std_obj::string(o->__Field(HX_CSTRING("model"),true));		HX_STACK_VAR(_g28,"_g28");
					HX_STACK_LINE(971)
					Dynamic msg = (HX_CSTRING("fbx.Library : loading ") + _g28);		HX_STACK_VAR(msg,"msg");
					HX_STACK_LINE(971)
					::String pos_fileName = HX_CSTRING("Library.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
					HX_STACK_LINE(971)
					int pos_lineNumber = (int)971;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
					HX_STACK_LINE(971)
					::String pos_className = HX_CSTRING("h3d.fbx.Library");		HX_STACK_VAR(pos_className,"pos_className");
					HX_STACK_LINE(971)
					::String pos_methodName = HX_CSTRING("makeObject");		HX_STACK_VAR(pos_methodName,"pos_methodName");
					HX_STACK_LINE(971)
					if (((::hxd::System_obj::debugLevel >= (int)3))){
						HX_STACK_LINE(971)
						::String _g29 = ::Std_obj::string(msg);		HX_STACK_VAR(_g29,"_g29");
						HX_STACK_LINE(971)
						::String _g30 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g29);		HX_STACK_VAR(_g30,"_g30");
						HX_STACK_LINE(971)
						::haxe::Log_obj::trace(_g30,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
					}
					HX_STACK_LINE(971)
					msg;
				}
				HX_STACK_LINE(973)
				Array< ::Dynamic > rootJoints = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(rootJoints,"rootJoints");
				HX_STACK_LINE(974)
				{
					HX_STACK_LINE(974)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(974)
					Array< ::Dynamic > _g2 = this->getChilds(o->__Field(HX_CSTRING("model"),true),HX_CSTRING("Model"));		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(974)
					while((true)){
						HX_STACK_LINE(974)
						if ((!(((_g1 < _g2->length))))){
							HX_STACK_LINE(974)
							break;
						}
						HX_STACK_LINE(974)
						::h3d::fbx::FbxNode sub = _g2->__get(_g1).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(sub,"sub");
						HX_STACK_LINE(974)
						++(_g1);
						HX_STACK_LINE(975)
						::h3d::scene::Object sobj;		HX_STACK_VAR(sobj,"sobj");
						HX_STACK_LINE(975)
						{
							HX_STACK_LINE(975)
							int key = sub->getId();		HX_STACK_VAR(key,"key");
							HX_STACK_LINE(975)
							sobj = hobjects->get(key);
						}
						HX_STACK_LINE(976)
						if (((sobj == null()))){
							HX_STACK_LINE(977)
							::String _g31 = sub->getType();		HX_STACK_VAR(_g31,"_g31");
							HX_STACK_LINE(977)
							if (((_g31 == HX_CSTRING("LimbNode")))){
								HX_STACK_LINE(978)
								::h3d::anim::Joint j;		HX_STACK_VAR(j,"j");
								HX_STACK_LINE(978)
								{
									HX_STACK_LINE(978)
									int key = sub->getId();		HX_STACK_VAR(key,"key");
									HX_STACK_LINE(978)
									j = hjoints->get(key);
								}
								HX_STACK_LINE(979)
								if (((j == null()))){
									HX_STACK_LINE(979)
									::String _g32 = sub->getName();		HX_STACK_VAR(_g32,"_g32");
									HX_STACK_LINE(979)
									HX_STACK_DO_THROW((HX_CSTRING("Missing sub joint ") + _g32));
								}
								HX_STACK_LINE(980)
								rootJoints->push(j);
								HX_STACK_LINE(981)
								continue;
							}
							HX_STACK_LINE(983)
							::String _g33 = sub->getName();		HX_STACK_VAR(_g33,"_g33");
							HX_STACK_LINE(983)
							HX_STACK_DO_THROW((HX_CSTRING("Missing sub ") + _g33));
						}
						HX_STACK_LINE(985)
						o->__Field(HX_CSTRING("obj"),true)->__Field(HX_CSTRING("addChild"),true)(sobj);
					}
				}
				HX_STACK_LINE(987)
				if (((rootJoints->length != (int)0))){
					HX_STACK_LINE(988)
					if ((!(::Std_obj::is(o->__Field(HX_CSTRING("obj"),true),hx::ClassOf< ::h3d::scene::Skin >())))){
						HX_STACK_LINE(989)
						::String _g34 = o->__Field(HX_CSTRING("model"),true)->__Field(HX_CSTRING("getType"),true)();		HX_STACK_VAR(_g34,"_g34");
						HX_STACK_LINE(989)
						::String _g35 = ((o->__Field(HX_CSTRING("obj"),true)->__Field(HX_CSTRING("name"),true) + HX_CSTRING(":")) + _g34);		HX_STACK_VAR(_g35,"_g35");
						HX_STACK_LINE(989)
						HX_STACK_DO_THROW((_g35 + HX_CSTRING(" should be a skin")));
					}
					HX_STACK_LINE(990)
					::h3d::scene::Skin skin = o->__Field(HX_CSTRING("obj"),true);		HX_STACK_VAR(skin,"skin");
					HX_STACK_LINE(991)
					::h3d::anim::Skin skinData = this->createSkin(hskins,hgeom,rootJoints,this->bonesPerVertex);		HX_STACK_VAR(skinData,"skinData");
					HX_STACK_LINE(993)
					{
						HX_STACK_LINE(993)
						::String pos_fileName = HX_CSTRING("Library.hx");		HX_STACK_VAR(pos_fileName,"pos_fileName");
						HX_STACK_LINE(993)
						int pos_lineNumber = (int)993;		HX_STACK_VAR(pos_lineNumber,"pos_lineNumber");
						HX_STACK_LINE(993)
						::String pos_className = HX_CSTRING("h3d.fbx.Library");		HX_STACK_VAR(pos_className,"pos_className");
						HX_STACK_LINE(993)
						::String pos_methodName = HX_CSTRING("makeObject");		HX_STACK_VAR(pos_methodName,"pos_methodName");
						HX_STACK_LINE(993)
						if (((::hxd::System_obj::debugLevel >= (int)3))){
							HX_STACK_LINE(993)
							::String _g36 = HX_CSTRING("generating skin");		HX_STACK_VAR(_g36,"_g36");
							HX_STACK_LINE(993)
							::String _g37 = ((((((pos_fileName + HX_CSTRING(":")) + pos_methodName) + HX_CSTRING(":")) + pos_lineNumber) + HX_CSTRING(" ")) + _g36);		HX_STACK_VAR(_g37,"_g37");
							HX_STACK_LINE(993)
							::haxe::Log_obj::trace(_g37,hx::SourceInfo(HX_CSTRING("System.hx"),325,HX_CSTRING("hxd.System"),HX_CSTRING("trace3")));
						}
						HX_STACK_LINE(993)
						HX_CSTRING("generating skin");
					}
					HX_STACK_LINE(996)
					{
						HX_STACK_LINE(996)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(996)
						while((true)){
							HX_STACK_LINE(996)
							if ((!(((_g1 < objects->__Field(HX_CSTRING("length"),true)))))){
								HX_STACK_LINE(996)
								break;
							}
							HX_STACK_LINE(996)
							Dynamic osub = objects->__GetItem(_g1);		HX_STACK_VAR(osub,"osub");
							HX_STACK_LINE(996)
							++(_g1);
							HX_STACK_LINE(997)
							if ((!(::Std_obj::is(osub->__Field(HX_CSTRING("obj"),true),hx::ClassOf< ::h3d::scene::Mesh >())))){
								HX_STACK_LINE(997)
								continue;
							}
							HX_STACK_LINE(998)
							::h3d::scene::Mesh m = osub->__Field(HX_CSTRING("obj"),true)->__Field(HX_CSTRING("toMesh"),true)();		HX_STACK_VAR(m,"m");
							HX_STACK_LINE(999)
							if (((bool((m->primitive != skinData->primitive)) || bool((m == skin))))){
								HX_STACK_LINE(1000)
								continue;
							}
							HX_STACK_LINE(1001)
							skin->material = m->material;
							HX_STACK_LINE(1002)
							if (((bool((m != null())) && bool((m->parent != null()))))){
								HX_STACK_LINE(1002)
								m->parent->removeChild(m);
							}
							HX_STACK_LINE(1004)
							int _g38 = o->__Field(HX_CSTRING("model"),true)->__Field(HX_CSTRING("getId"),true)();		HX_STACK_VAR(_g38,"_g38");
							HX_STACK_LINE(1004)
							this->defaultModelMatrixes->get(osub->__Field(HX_CSTRING("obj"),true)->__Field(HX_CSTRING("name"),true))->__FieldRef(HX_CSTRING("wasRemoved")) = _g38;
						}
					}
					HX_STACK_LINE(1007)
					if (((skinData->boundJoints->length > this->maxBonesPerSkin))){
						HX_STACK_LINE(1008)
						if (((::hxd::System_obj::debugLevel >= (int)1))){
							HX_STACK_LINE(1008)
							HX_STACK_DO_THROW(HX_CSTRING("too many joints by skin"));
						}
						HX_STACK_LINE(1009)
						skinData->split(this->maxBonesPerSkin,::Std_obj::instance(skinData->primitive,hx::ClassOf< ::h3d::prim::FBXModel >())->__Field(HX_CSTRING("geom"),true)->__Field(HX_CSTRING("getIndexes"),true)()->__Field(HX_CSTRING("vidx"),true));
					}
					HX_STACK_LINE(1011)
					skin->setSkinData(skinData);
				}
			}
		}
		HX_STACK_LINE(1014)
		if (((scene->childs->length == (int)1))){
			HX_STACK_LINE(1014)
			return scene->childs->__get((int)0).StaticCast< ::h3d::scene::Object >();
		}
		else{
			HX_STACK_LINE(1014)
			return scene;
		}
		HX_STACK_LINE(1014)
		return null();
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Library_obj,makeObject,return )

Dynamic Library_obj::keepJoint( ::h3d::anim::Joint j){
	HX_STACK_FRAME("h3d.fbx.Library","keepJoint",0x474a9d0b,"h3d.fbx.Library.keepJoint","h3d/fbx/Library.hx",1018,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(j,"j")
	HX_STACK_LINE(1018)
	return this->keepJoints->get(j->name);
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,keepJoint,return )

::h3d::anim::Skin Library_obj::createSkin( ::haxe::ds::IntMap hskins,::haxe::ds::IntMap hgeom,Array< ::Dynamic > rootJoints,int bonesPerVertex){
	HX_STACK_FRAME("h3d.fbx.Library","createSkin",0x5899c653,"h3d.fbx.Library.createSkin","h3d/fbx/Library.hx",1021,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(hskins,"hskins")
	HX_STACK_ARG(hgeom,"hgeom")
	HX_STACK_ARG(rootJoints,"rootJoints")
	HX_STACK_ARG(bonesPerVertex,"bonesPerVertex")
	HX_STACK_LINE(1022)
	Array< ::Dynamic > allJoints = Array_obj< ::Dynamic >::__new().Add(Array_obj< ::Dynamic >::__new());		HX_STACK_VAR(allJoints,"allJoints");
	HX_STACK_LINE(1023)
	Dynamic collectJoints;		HX_STACK_VAR(collectJoints,"collectJoints");
	HX_STACK_LINE(1023)
	{
		HX_STACK_LINE(1023)
		Dynamic collectJoints1 = Dynamic( Array_obj<Dynamic>::__new().Add(null()));		HX_STACK_VAR(collectJoints1,"collectJoints1");

		HX_BEGIN_LOCAL_FUNC_S2(hx::LocalFunc,_Function_2_1,Dynamic,collectJoints1,Array< ::Dynamic >,allJoints)
		Void run(::h3d::anim::Joint j){
			HX_STACK_FRAME("*","_Function_2_1",0x5201af78,"*._Function_2_1","h3d/fbx/Library.hx",1023,0x38e70acc)
			HX_STACK_ARG(j,"j")
			{
				HX_STACK_LINE(1025)
				{
					HX_STACK_LINE(1025)
					int _g = (int)0;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(1025)
					Array< ::Dynamic > _g1 = j->subs;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(1025)
					while(((_g < _g1->length))){
						HX_STACK_LINE(1025)
						::h3d::anim::Joint j1 = _g1->__get(_g).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j1,"j1");
						HX_STACK_LINE(1025)
						++(_g);
						HX_STACK_LINE(1026)
						collectJoints1->__GetItem((int)0)(j1).Cast< Void >();
					}
				}
				HX_STACK_LINE(1027)
				allJoints->__get((int)0).StaticCast< Array< ::Dynamic > >()->push(j);
			}
			return null();
		}
		HX_END_LOCAL_FUNC1((void))

		HX_STACK_LINE(1023)
		hx::IndexRef((collectJoints1).mPtr,(int)0) =  Dynamic(new _Function_2_1(collectJoints1,allJoints));
		HX_STACK_LINE(1023)
		collectJoints = collectJoints1->__GetItem((int)0);
	}
	HX_STACK_LINE(1029)
	{
		HX_STACK_LINE(1029)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1029)
		while((true)){
			HX_STACK_LINE(1029)
			if ((!(((_g < rootJoints->length))))){
				HX_STACK_LINE(1029)
				break;
			}
			HX_STACK_LINE(1029)
			::h3d::anim::Joint j = rootJoints->__get(_g).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
			HX_STACK_LINE(1029)
			++(_g);
			HX_STACK_LINE(1030)
			collectJoints(j).Cast< Void >();
		}
	}
	HX_STACK_LINE(1031)
	::h3d::anim::Skin skin = null();		HX_STACK_VAR(skin,"skin");
	HX_STACK_LINE(1032)
	Dynamic geomTrans = null();		HX_STACK_VAR(geomTrans,"geomTrans");
	HX_STACK_LINE(1033)
	Array< ::Dynamic > iterJoints = allJoints->__get((int)0).StaticCast< Array< ::Dynamic > >()->copy();		HX_STACK_VAR(iterJoints,"iterJoints");
	HX_STACK_LINE(1034)
	{
		HX_STACK_LINE(1034)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1034)
		while((true)){
			HX_STACK_LINE(1034)
			if ((!(((_g < iterJoints->length))))){
				HX_STACK_LINE(1034)
				break;
			}
			HX_STACK_LINE(1034)
			::h3d::anim::Joint j = iterJoints->__get(_g).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
			HX_STACK_LINE(1034)
			++(_g);
			HX_STACK_LINE(1035)
			::h3d::fbx::FbxNode jModel = this->ids->get(j->index);		HX_STACK_VAR(jModel,"jModel");
			HX_STACK_LINE(1036)
			::h3d::fbx::FbxNode subDef = this->getParent(jModel,HX_CSTRING("Deformer"),true);		HX_STACK_VAR(subDef,"subDef");
			HX_STACK_LINE(1037)
			::h3d::fbx::DefaultMatrixes defMat;		HX_STACK_VAR(defMat,"defMat");
			HX_STACK_LINE(1037)
			{
				HX_STACK_LINE(1037)
				::String key = jModel->getName();		HX_STACK_VAR(key,"key");
				HX_STACK_LINE(1037)
				defMat = this->defaultModelMatrixes->get(key);
			}
			HX_STACK_LINE(1038)
			if (((subDef == null()))){
				HX_STACK_LINE(1040)
				if (((  ((!(((j->subs->length > (int)0))))) ? bool(this->keepJoint(j)) : bool(true) ))){
					HX_STACK_LINE(1041)
					continue;
				}
				HX_STACK_LINE(1043)
				if (((j->parent == null()))){
					HX_STACK_LINE(1044)
					rootJoints->remove(j);
				}
				else{
					HX_STACK_LINE(1046)
					j->parent->subs->remove(j);
				}
				HX_STACK_LINE(1047)
				allJoints->__get((int)0).StaticCast< Array< ::Dynamic > >()->remove(j);
				HX_STACK_LINE(1049)
				defMat->wasRemoved = (int)-1;
				HX_STACK_LINE(1050)
				continue;
			}
			HX_STACK_LINE(1053)
			if (((skin == null()))){
				HX_STACK_LINE(1054)
				::h3d::fbx::FbxNode def = this->getParent(subDef,HX_CSTRING("Deformer"),null());		HX_STACK_VAR(def,"def");
				HX_STACK_LINE(1055)
				::h3d::anim::Skin _g1;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(1055)
				{
					HX_STACK_LINE(1055)
					int key = def->getId();		HX_STACK_VAR(key,"key");
					HX_STACK_LINE(1055)
					_g1 = hskins->get(key);
				}
				HX_STACK_LINE(1055)
				skin = _g1;
				HX_STACK_LINE(1057)
				if (((skin != null()))){
					HX_STACK_LINE(1058)
					return skin;
				}
				HX_STACK_LINE(1059)
				::h3d::prim::FBXModel geom;		HX_STACK_VAR(geom,"geom");
				HX_STACK_LINE(1059)
				{
					HX_STACK_LINE(1059)
					int key = this->getParent(def,HX_CSTRING("Geometry"),null())->getId();		HX_STACK_VAR(key,"key");
					HX_STACK_LINE(1059)
					geom = hgeom->get(key);
				}
				HX_STACK_LINE(1060)
				int _g11 = geom->getVerticesCount();		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(1060)
				::h3d::anim::Skin _g2 = ::h3d::anim::Skin_obj::__new(_g11,bonesPerVertex);		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(1060)
				skin = _g2;
				HX_STACK_LINE(1061)
				geom->skin = skin;
				HX_STACK_LINE(1062)
				skin->primitive = geom;
				HX_STACK_LINE(1063)
				{
					HX_STACK_LINE(1063)
					int key = def->getId();		HX_STACK_VAR(key,"key");
					HX_STACK_LINE(1063)
					hskins->set(key,skin);
				}
			}
			HX_STACK_LINE(1065)
			Array< Float > _g3 = subDef->get(HX_CSTRING("Transform"),null())->getFloats();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(1065)
			::h3d::Matrix _g4 = ::h3d::Matrix_obj::L(_g3);		HX_STACK_VAR(_g4,"_g4");
			HX_STACK_LINE(1065)
			j->transPos = _g4;
			HX_STACK_LINE(1066)
			::h3d::Matrix _g5 = defMat->toMatrix(this->leftHand);		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(1066)
			j->defMat = _g5;
			HX_STACK_LINE(1067)
			if ((this->leftHand)){
				HX_STACK_LINE(1067)
				::h3d::Matrix m = j->transPos;		HX_STACK_VAR(m,"m");
				HX_STACK_LINE(1067)
				hx::MultEq(m->_12,(int)-1);
				HX_STACK_LINE(1067)
				hx::MultEq(m->_13,(int)-1);
				HX_STACK_LINE(1067)
				hx::MultEq(m->_21,(int)-1);
				HX_STACK_LINE(1067)
				hx::MultEq(m->_31,(int)-1);
				HX_STACK_LINE(1067)
				hx::MultEq(m->_41,(int)-1);
			}
			HX_STACK_LINE(1069)
			Array< ::Dynamic > weights = subDef->getAll(HX_CSTRING("Weights"));		HX_STACK_VAR(weights,"weights");
			HX_STACK_LINE(1070)
			if (((weights->length > (int)0))){
				HX_STACK_LINE(1071)
				Array< Float > weights1 = weights->__get((int)0).StaticCast< ::h3d::fbx::FbxNode >()->getFloats();		HX_STACK_VAR(weights1,"weights1");
				HX_STACK_LINE(1072)
				Array< int > vertex = subDef->get(HX_CSTRING("Indexes"),null())->getInts();		HX_STACK_VAR(vertex,"vertex");
				HX_STACK_LINE(1073)
				{
					HX_STACK_LINE(1073)
					int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(1073)
					int _g1 = vertex->length;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(1073)
					while((true)){
						HX_STACK_LINE(1073)
						if ((!(((_g2 < _g1))))){
							HX_STACK_LINE(1073)
							break;
						}
						HX_STACK_LINE(1073)
						int i = (_g2)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(1074)
						Float w = weights1->__get(i);		HX_STACK_VAR(w,"w");
						HX_STACK_LINE(1075)
						if (((w < 0.01))){
							HX_STACK_LINE(1076)
							continue;
						}
						HX_STACK_LINE(1077)
						{
							HX_STACK_LINE(1077)
							int vid = vertex->__get(i);		HX_STACK_VAR(vid,"vid");
							HX_STACK_LINE(1077)
							Array< ::Dynamic > il = skin->envelop->__get(vid).StaticCast< Array< ::Dynamic > >();		HX_STACK_VAR(il,"il");
							HX_STACK_LINE(1077)
							if (((il == null()))){
								HX_STACK_LINE(1077)
								Array< ::Dynamic > _g6 = skin->envelop[vid] = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g6,"_g6");
								HX_STACK_LINE(1077)
								il = _g6;
							}
							HX_STACK_LINE(1077)
							::h3d::anim::_Skin::Influence _g7 = ::h3d::anim::_Skin::Influence_obj::__new(j,w);		HX_STACK_VAR(_g7,"_g7");
							HX_STACK_LINE(1077)
							il->push(_g7);
						}
					}
				}
			}
		}
	}
	HX_STACK_LINE(1081)
	if (((skin == null()))){
		struct _Function_2_1{
			inline static Array< ::String > Block( Array< ::Dynamic > &iterJoints){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","h3d/fbx/Library.hx",1082,0x38e70acc)
				{
					HX_STACK_LINE(1082)
					Array< ::String > _g = Array_obj< ::String >::__new();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(1082)
					{
						HX_STACK_LINE(1082)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(1082)
						while((true)){
							HX_STACK_LINE(1082)
							if ((!(((_g1 < iterJoints->length))))){
								HX_STACK_LINE(1082)
								break;
							}
							HX_STACK_LINE(1082)
							::h3d::anim::Joint j = iterJoints->__get(_g1).StaticCast< ::h3d::anim::Joint >();		HX_STACK_VAR(j,"j");
							HX_STACK_LINE(1082)
							++(_g1);
							HX_STACK_LINE(1082)
							_g->push(j->name);
						}
					}
					HX_STACK_LINE(1082)
					return _g;
				}
				return null();
			}
		};
		HX_STACK_LINE(1082)
		::String _g8 = (_Function_2_1::Block(iterJoints))->join(HX_CSTRING(","));		HX_STACK_VAR(_g8,"_g8");
		HX_STACK_LINE(1082)
		::String _g9 = (HX_CSTRING("No joint is skinned (") + _g8);		HX_STACK_VAR(_g9,"_g9");
		HX_STACK_LINE(1082)
		HX_STACK_DO_THROW((_g9 + HX_CSTRING(")")));
	}
	HX_STACK_LINE(1083)
	allJoints->__get((int)0).StaticCast< Array< ::Dynamic > >()->reverse();
	HX_STACK_LINE(1084)
	{
		HX_STACK_LINE(1084)
		int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(1084)
		int _g1 = allJoints->__get((int)0).StaticCast< Array< ::Dynamic > >()->length;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1084)
		while((true)){
			HX_STACK_LINE(1084)
			if ((!(((_g2 < _g1))))){
				HX_STACK_LINE(1084)
				break;
			}
			HX_STACK_LINE(1084)
			int i = (_g2)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(1085)
			allJoints->__get((int)0).StaticCast< Array< ::Dynamic > >()->__get(i).StaticCast< ::h3d::anim::Joint >()->index = i;
		}
	}
	HX_STACK_LINE(1086)
	skin->setJoints(allJoints->__get((int)0).StaticCast< Array< ::Dynamic > >(),rootJoints);
	HX_STACK_LINE(1087)
	skin->initWeights();
	HX_STACK_LINE(1088)
	return skin;
}


HX_DEFINE_DYNAMIC_FUNC4(Library_obj,createSkin,return )

::h3d::fbx::DefaultMatrixes Library_obj::getDefaultMatrixes( ::h3d::fbx::FbxNode model){
	HX_STACK_FRAME("h3d.fbx.Library","getDefaultMatrixes",0x9581f794,"h3d.fbx.Library.getDefaultMatrixes","h3d/fbx/Library.hx",1091,0x38e70acc)
	HX_STACK_THIS(this)
	HX_STACK_ARG(model,"model")
	HX_STACK_LINE(1092)
	::h3d::fbx::DefaultMatrixes d = ::h3d::fbx::DefaultMatrixes_obj::__new();		HX_STACK_VAR(d,"d");
	HX_STACK_LINE(1093)
	Float F = (Float(::Math_obj::PI) / Float((int)180));		HX_STACK_VAR(F,"F");
	HX_STACK_LINE(1094)
	{
		HX_STACK_LINE(1094)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1094)
		Array< ::Dynamic > _g1 = model->getAll(HX_CSTRING("Properties70.P"));		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(1094)
		while((true)){
			HX_STACK_LINE(1094)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(1094)
				break;
			}
			HX_STACK_LINE(1094)
			::h3d::fbx::FbxNode p = _g1->__get(_g).StaticCast< ::h3d::fbx::FbxNode >();		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(1094)
			++(_g);
			HX_STACK_LINE(1095)
			::String _g2 = ::h3d::fbx::FBxTools_obj::toString(p->props->__get((int)0).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(1095)
			::String _switch_6 = (_g2);
			if (  ( _switch_6==HX_CSTRING("GeometricTranslation"))){
			}
			else if (  ( _switch_6==HX_CSTRING("PreRotation"))){
				HX_STACK_LINE(1099)
				Float _g3 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)4).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(1099)
				Float _g11 = (_g3 * F);		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(1099)
				Float _g21 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)5).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(1099)
				Float _g31 = (_g21 * F);		HX_STACK_VAR(_g31,"_g31");
				HX_STACK_LINE(1099)
				Float _g4 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)6).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(1099)
				Float _g5 = (_g4 * F);		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(1099)
				::h3d::col::Point _g6 = ::h3d::col::Point_obj::__new(_g11,_g31,_g5);		HX_STACK_VAR(_g6,"_g6");
				HX_STACK_LINE(1099)
				d->preRot = _g6;
			}
			else if (  ( _switch_6==HX_CSTRING("Lcl Rotation"))){
				HX_STACK_LINE(1101)
				Float _g7 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)4).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g7,"_g7");
				HX_STACK_LINE(1101)
				Float _g8 = (_g7 * F);		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(1101)
				Float _g9 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)5).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g9,"_g9");
				HX_STACK_LINE(1101)
				Float _g10 = (_g9 * F);		HX_STACK_VAR(_g10,"_g10");
				HX_STACK_LINE(1101)
				Float _g11 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)6).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g11,"_g11");
				HX_STACK_LINE(1101)
				Float _g12 = (_g11 * F);		HX_STACK_VAR(_g12,"_g12");
				HX_STACK_LINE(1101)
				::h3d::col::Point _g13 = ::h3d::col::Point_obj::__new(_g8,_g10,_g12);		HX_STACK_VAR(_g13,"_g13");
				HX_STACK_LINE(1101)
				d->rotate = _g13;
			}
			else if (  ( _switch_6==HX_CSTRING("Lcl Translation"))){
				HX_STACK_LINE(1103)
				Float _g14 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)4).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g14,"_g14");
				HX_STACK_LINE(1103)
				Float _g15 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)5).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g15,"_g15");
				HX_STACK_LINE(1103)
				Float _g16 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)6).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g16,"_g16");
				HX_STACK_LINE(1103)
				::h3d::col::Point _g17 = ::h3d::col::Point_obj::__new(_g14,_g15,_g16);		HX_STACK_VAR(_g17,"_g17");
				HX_STACK_LINE(1103)
				d->trans = _g17;
			}
			else if (  ( _switch_6==HX_CSTRING("Lcl Scaling"))){
				HX_STACK_LINE(1105)
				Float _g18 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)4).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g18,"_g18");
				HX_STACK_LINE(1105)
				Float _g19 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)5).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g19,"_g19");
				HX_STACK_LINE(1105)
				Float _g20 = ::h3d::fbx::FBxTools_obj::toFloat(p->props->__get((int)6).StaticCast< ::h3d::fbx::FbxProp >());		HX_STACK_VAR(_g20,"_g20");
				HX_STACK_LINE(1105)
				::h3d::col::Point _g21 = ::h3d::col::Point_obj::__new(_g18,_g19,_g20);		HX_STACK_VAR(_g21,"_g21");
				HX_STACK_LINE(1105)
				d->scale = _g21;
			}
			else  {
			}
;
;
		}
	}
	HX_STACK_LINE(1108)
	{
		HX_STACK_LINE(1108)
		::String key = model->getName();		HX_STACK_VAR(key,"key");
		HX_STACK_LINE(1108)
		this->defaultModelMatrixes->set(key,d);
	}
	HX_STACK_LINE(1109)
	return d;
}


HX_DEFINE_DYNAMIC_FUNC1(Library_obj,getDefaultMatrixes,return )


Library_obj::Library_obj()
{
}

void Library_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Library);
	HX_MARK_MEMBER_NAME(root,"root");
	HX_MARK_MEMBER_NAME(ids,"ids");
	HX_MARK_MEMBER_NAME(connect,"connect");
	HX_MARK_MEMBER_NAME(invConnect,"invConnect");
	HX_MARK_MEMBER_NAME(leftHand,"leftHand");
	HX_MARK_MEMBER_NAME(defaultModelMatrixes,"defaultModelMatrixes");
	HX_MARK_MEMBER_NAME(keepJoints,"keepJoints");
	HX_MARK_MEMBER_NAME(skipObjects,"skipObjects");
	HX_MARK_MEMBER_NAME(bonesPerVertex,"bonesPerVertex");
	HX_MARK_MEMBER_NAME(maxBonesPerSkin,"maxBonesPerSkin");
	HX_MARK_MEMBER_NAME(unskinnedJointsAsObjects,"unskinnedJointsAsObjects");
	HX_MARK_END_CLASS();
}

void Library_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(root,"root");
	HX_VISIT_MEMBER_NAME(ids,"ids");
	HX_VISIT_MEMBER_NAME(connect,"connect");
	HX_VISIT_MEMBER_NAME(invConnect,"invConnect");
	HX_VISIT_MEMBER_NAME(leftHand,"leftHand");
	HX_VISIT_MEMBER_NAME(defaultModelMatrixes,"defaultModelMatrixes");
	HX_VISIT_MEMBER_NAME(keepJoints,"keepJoints");
	HX_VISIT_MEMBER_NAME(skipObjects,"skipObjects");
	HX_VISIT_MEMBER_NAME(bonesPerVertex,"bonesPerVertex");
	HX_VISIT_MEMBER_NAME(maxBonesPerSkin,"maxBonesPerSkin");
	HX_VISIT_MEMBER_NAME(unskinnedJointsAsObjects,"unskinnedJointsAsObjects");
}

Dynamic Library_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ids") ) { return ids; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { return root; }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		if (HX_FIELD_EQ(inName,"init") ) { return init_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"reset") ) { return reset_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"connect") ) { return connect; }
		if (HX_FIELD_EQ(inName,"getRoot") ) { return getRoot_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"leftHand") ) { return leftHand; }
		if (HX_FIELD_EQ(inName,"hasChild") ) { return hasChild_dyn(); }
		if (HX_FIELD_EQ(inName,"getChild") ) { return getChild_dyn(); }
		if (HX_FIELD_EQ(inName,"getTakes") ) { return getTakes_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"getParent") ) { return getParent_dyn(); }
		if (HX_FIELD_EQ(inName,"getChilds") ) { return getChilds_dyn(); }
		if (HX_FIELD_EQ(inName,"keepJoint") ) { return keepJoint_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"invConnect") ) { return invConnect; }
		if (HX_FIELD_EQ(inName,"keepJoints") ) { return keepJoints; }
		if (HX_FIELD_EQ(inName,"getParents") ) { return getParents_dyn(); }
		if (HX_FIELD_EQ(inName,"makeObject") ) { return makeObject_dyn(); }
		if (HX_FIELD_EQ(inName,"createSkin") ) { return createSkin_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"skipObjects") ) { return skipObjects; }
		if (HX_FIELD_EQ(inName,"getGeometry") ) { return getGeometry_dyn(); }
		if (HX_FIELD_EQ(inName,"dumpParents") ) { return dumpParents_dyn(); }
		if (HX_FIELD_EQ(inName,"isNullJoint") ) { return isNullJoint_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"loadTextFile") ) { return loadTextFile_dyn(); }
		if (HX_FIELD_EQ(inName,"dumpChildren") ) { return dumpChildren_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"convertPoints") ) { return convertPoints_dyn(); }
		if (HX_FIELD_EQ(inName,"collectByName") ) { return collectByName_dyn(); }
		if (HX_FIELD_EQ(inName,"loadAnimation") ) { return loadAnimation_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"bonesPerVertex") ) { return bonesPerVertex; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"maxBonesPerSkin") ) { return maxBonesPerSkin; }
		if (HX_FIELD_EQ(inName,"leftHandConvert") ) { return leftHandConvert_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"loadMorphAnimation") ) { return loadMorphAnimation_dyn(); }
		if (HX_FIELD_EQ(inName,"sortDistinctFloats") ) { return sortDistinctFloats_dyn(); }
		if (HX_FIELD_EQ(inName,"getDefaultMatrixes") ) { return getDefaultMatrixes_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"ignoreMissingObject") ) { return ignoreMissingObject_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"defaultModelMatrixes") ) { return defaultModelMatrixes; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"unskinnedJointsAsObjects") ) { return unskinnedJointsAsObjects; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Library_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"ids") ) { ids=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { root=inValue.Cast< ::h3d::fbx::FbxNode >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"connect") ) { connect=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"leftHand") ) { leftHand=inValue.Cast< bool >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"invConnect") ) { invConnect=inValue.Cast< ::haxe::ds::IntMap >(); return inValue; }
		if (HX_FIELD_EQ(inName,"keepJoints") ) { keepJoints=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"skipObjects") ) { skipObjects=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"bonesPerVertex") ) { bonesPerVertex=inValue.Cast< int >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"maxBonesPerSkin") ) { maxBonesPerSkin=inValue.Cast< int >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"defaultModelMatrixes") ) { defaultModelMatrixes=inValue.Cast< ::haxe::ds::StringMap >(); return inValue; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"unskinnedJointsAsObjects") ) { unskinnedJointsAsObjects=inValue.Cast< bool >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Library_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("root"));
	outFields->push(HX_CSTRING("ids"));
	outFields->push(HX_CSTRING("connect"));
	outFields->push(HX_CSTRING("invConnect"));
	outFields->push(HX_CSTRING("leftHand"));
	outFields->push(HX_CSTRING("defaultModelMatrixes"));
	outFields->push(HX_CSTRING("keepJoints"));
	outFields->push(HX_CSTRING("skipObjects"));
	outFields->push(HX_CSTRING("bonesPerVertex"));
	outFields->push(HX_CSTRING("maxBonesPerSkin"));
	outFields->push(HX_CSTRING("unskinnedJointsAsObjects"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::fbx::FbxNode*/ ,(int)offsetof(Library_obj,root),HX_CSTRING("root")},
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(Library_obj,ids),HX_CSTRING("ids")},
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(Library_obj,connect),HX_CSTRING("connect")},
	{hx::fsObject /*::haxe::ds::IntMap*/ ,(int)offsetof(Library_obj,invConnect),HX_CSTRING("invConnect")},
	{hx::fsBool,(int)offsetof(Library_obj,leftHand),HX_CSTRING("leftHand")},
	{hx::fsObject /*::haxe::ds::StringMap*/ ,(int)offsetof(Library_obj,defaultModelMatrixes),HX_CSTRING("defaultModelMatrixes")},
	{hx::fsObject /*::haxe::ds::StringMap*/ ,(int)offsetof(Library_obj,keepJoints),HX_CSTRING("keepJoints")},
	{hx::fsObject /*::haxe::ds::StringMap*/ ,(int)offsetof(Library_obj,skipObjects),HX_CSTRING("skipObjects")},
	{hx::fsInt,(int)offsetof(Library_obj,bonesPerVertex),HX_CSTRING("bonesPerVertex")},
	{hx::fsInt,(int)offsetof(Library_obj,maxBonesPerSkin),HX_CSTRING("maxBonesPerSkin")},
	{hx::fsBool,(int)offsetof(Library_obj,unskinnedJointsAsObjects),HX_CSTRING("unskinnedJointsAsObjects")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("root"),
	HX_CSTRING("ids"),
	HX_CSTRING("connect"),
	HX_CSTRING("invConnect"),
	HX_CSTRING("leftHand"),
	HX_CSTRING("defaultModelMatrixes"),
	HX_CSTRING("keepJoints"),
	HX_CSTRING("skipObjects"),
	HX_CSTRING("bonesPerVertex"),
	HX_CSTRING("maxBonesPerSkin"),
	HX_CSTRING("unskinnedJointsAsObjects"),
	HX_CSTRING("reset"),
	HX_CSTRING("loadTextFile"),
	HX_CSTRING("load"),
	HX_CSTRING("convertPoints"),
	HX_CSTRING("leftHandConvert"),
	HX_CSTRING("init"),
	HX_CSTRING("getGeometry"),
	HX_CSTRING("collectByName"),
	HX_CSTRING("getParent"),
	HX_CSTRING("hasChild"),
	HX_CSTRING("getChild"),
	HX_CSTRING("getChilds"),
	HX_CSTRING("dumpParents"),
	HX_CSTRING("dumpChildren"),
	HX_CSTRING("getParents"),
	HX_CSTRING("getRoot"),
	HX_CSTRING("ignoreMissingObject"),
	HX_CSTRING("loadAnimation"),
	HX_CSTRING("getTakes"),
	HX_CSTRING("loadMorphAnimation"),
	HX_CSTRING("isNullJoint"),
	HX_CSTRING("sortDistinctFloats"),
	HX_CSTRING("makeObject"),
	HX_CSTRING("keepJoint"),
	HX_CSTRING("createSkin"),
	HX_CSTRING("getDefaultMatrixes"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Library_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Library_obj::__mClass,"__mClass");
};

#endif

Class Library_obj::__mClass;

void Library_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.fbx.Library"), hx::TCanCast< Library_obj> ,sStaticFields,sMemberFields,
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

void Library_obj::__boot()
{
}

} // end namespace h3d
} // end namespace fbx
