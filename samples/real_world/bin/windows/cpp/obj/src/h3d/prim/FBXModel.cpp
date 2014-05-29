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
#ifndef INCLUDED_h3d_anim_Joint
#include <h3d/anim/Joint.h>
#endif
#ifndef INCLUDED_h3d_anim_Skin
#include <h3d/anim/Skin.h>
#endif
#ifndef INCLUDED_h3d_col_Bounds
#include <h3d/col/Bounds.h>
#endif
#ifndef INCLUDED_h3d_col_Point
#include <h3d/col/Point.h>
#endif
#ifndef INCLUDED_h3d_fbx_Geometry
#include <h3d/fbx/Geometry.h>
#endif
#ifndef INCLUDED_h3d_impl_Buffer
#include <h3d/impl/Buffer.h>
#endif
#ifndef INCLUDED_h3d_impl_BufferOffset
#include <h3d/impl/BufferOffset.h>
#endif
#ifndef INCLUDED_h3d_impl_Indexes
#include <h3d/impl/Indexes.h>
#endif
#ifndef INCLUDED_h3d_impl_MemoryManager
#include <h3d/impl/MemoryManager.h>
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
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_ds_IntMap
#include <haxe/ds/IntMap.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_haxe_io_BytesBuffer
#include <haxe/io/BytesBuffer.h>
#endif
#ifndef INCLUDED_haxe_io_BytesOutput
#include <haxe/io/BytesOutput.h>
#endif
#ifndef INCLUDED_haxe_io_Output
#include <haxe/io/Output.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_hxd_Assert
#include <hxd/Assert.h>
#endif
#ifndef INCLUDED_hxd_System
#include <hxd/System.h>
#endif
namespace h3d{
namespace prim{

Void FBXModel_obj::__construct(::h3d::fbx::Geometry g,hx::Null< bool >  __o_isDynamic)
{
HX_STACK_FRAME("h3d.prim.FBXModel","new",0xdbaa0a72,"h3d.prim.FBXModel.new","h3d/prim/FBXModel.hx",34,0xe945c8de)
HX_STACK_THIS(this)
HX_STACK_ARG(g,"g")
HX_STACK_ARG(__o_isDynamic,"isDynamic")
bool isDynamic = __o_isDynamic.Default(false);
{
	HX_STACK_LINE(160)
	this->tempNorm = Array_obj< Float >::__new();
	HX_STACK_LINE(159)
	this->tempVert = Array_obj< Float >::__new();
	HX_STACK_LINE(49)
	this->id = (int)0;
	HX_STACK_LINE(55)
	int _g = (::h3d::prim::FBXModel_obj::uid)++;		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(55)
	this->id = _g;
	HX_STACK_LINE(56)
	if (((::hxd::System_obj::debugLevel >= (int)2))){
		HX_STACK_LINE(56)
		int _g1 = (::h3d::prim::FBXModel_obj::uid)++;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(56)
		int _g2 = this->id = _g1;		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(56)
		::String _g3 = (HX_CSTRING("FBXModel.new() ") + _g2);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(56)
		::haxe::Log_obj::trace(_g3,hx::SourceInfo(HX_CSTRING("FBXModel.hx"),56,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("new")));
	}
	HX_STACK_LINE(57)
	super::__construct();
	HX_STACK_LINE(58)
	this->geom = g;
	HX_STACK_LINE(59)
	this->curMaterial = (int)-1;
	HX_STACK_LINE(60)
	this->isDynamic = isDynamic;
	HX_STACK_LINE(61)
	this->blendShapes = Array_obj< ::Dynamic >::__new();
}
;
	return null();
}

//FBXModel_obj::~FBXModel_obj() { }

Dynamic FBXModel_obj::__CreateEmpty() { return  new FBXModel_obj; }
hx::ObjectPtr< FBXModel_obj > FBXModel_obj::__new(::h3d::fbx::Geometry g,hx::Null< bool >  __o_isDynamic)
{  hx::ObjectPtr< FBXModel_obj > result = new FBXModel_obj();
	result->__construct(g,__o_isDynamic);
	return result;}

Dynamic FBXModel_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< FBXModel_obj > result = new FBXModel_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

HX_BEGIN_DEFAULT_FUNC(__default_onVertexBuffer,FBXModel_obj)
Array< Float > run(Array< Float > vb){
	HX_STACK_FRAME("h3d.prim.FBXModel","onVertexBuffer",0x714eca71,"h3d.prim.FBXModel.onVertexBuffer","h3d/prim/FBXModel.hx",69,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(vb,"vb")
	HX_STACK_LINE(69)
	return vb;
}
HX_END_LOCAL_FUNC1(return )
HX_END_DEFAULT_FUNC

HX_BEGIN_DEFAULT_FUNC(__default_onNormalBuffer,FBXModel_obj)
Array< Float > run(Array< Float > nb){
	HX_STACK_FRAME("h3d.prim.FBXModel","onNormalBuffer",0xcf9e5574,"h3d.prim.FBXModel.onNormalBuffer","h3d/prim/FBXModel.hx",77,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(nb,"nb")
	HX_STACK_LINE(77)
	return nb;
}
HX_END_LOCAL_FUNC1(return )
HX_END_DEFAULT_FUNC

int FBXModel_obj::getVerticesCount( ){
	HX_STACK_FRAME("h3d.prim.FBXModel","getVerticesCount",0x26417a4e,"h3d.prim.FBXModel.getVerticesCount","h3d/prim/FBXModel.hx",81,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_LINE(81)
	return ::Std_obj::_int((Float(this->geom->getVertices()->length) / Float((int)3)));
}


HX_DEFINE_DYNAMIC_FUNC0(FBXModel_obj,getVerticesCount,return )

Array< Float > FBXModel_obj::set_shapeRatios( Array< Float > v){
	HX_STACK_FRAME("h3d.prim.FBXModel","set_shapeRatios",0x12c75cbe,"h3d.prim.FBXModel.set_shapeRatios","h3d/prim/FBXModel.hx",84,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(85)
	if (((v != null()))){
		HX_STACK_LINE(86)
		if (((v->length < this->blendShapes->length))){
			HX_STACK_LINE(87)
			int _g1 = v->length;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(87)
			int _g = this->blendShapes->length;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(87)
			while((true)){
				HX_STACK_LINE(87)
				if ((!(((_g1 < _g))))){
					HX_STACK_LINE(87)
					break;
				}
				HX_STACK_LINE(87)
				int i = (_g1)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(88)
				v[i] = 0.0;
			}
		}
	}
	HX_STACK_LINE(90)
	return this->shapeRatios = v;
}


HX_DEFINE_DYNAMIC_FUNC1(FBXModel_obj,set_shapeRatios,return )

::h3d::col::Bounds FBXModel_obj::getBounds( ){
	HX_STACK_FRAME("h3d.prim.FBXModel","getBounds",0xabb4233d,"h3d.prim.FBXModel.getBounds","h3d/prim/FBXModel.hx",92,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_LINE(93)
	if (((this->bounds != null()))){
		HX_STACK_LINE(94)
		return this->bounds;
	}
	HX_STACK_LINE(95)
	::h3d::col::Bounds _g = ::h3d::col::Bounds_obj::__new();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(95)
	this->bounds = _g;
	HX_STACK_LINE(96)
	Array< Float > verts = this->geom->getVertices();		HX_STACK_VAR(verts,"verts");
	HX_STACK_LINE(97)
	::h3d::col::Point gt = this->geom->getGeomTranslate();		HX_STACK_VAR(gt,"gt");
	HX_STACK_LINE(98)
	if (((gt == null()))){
		HX_STACK_LINE(98)
		::h3d::col::Point _g1 = ::h3d::col::Point_obj::__new(null(),null(),null());		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(98)
		gt = _g1;
	}
	HX_STACK_LINE(99)
	if (((verts->length > (int)0))){
		HX_STACK_LINE(100)
		Float _g2 = this->bounds->xMax = (verts->__get((int)0) + gt->x);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(100)
		this->bounds->xMin = _g2;
		HX_STACK_LINE(101)
		Float _g3 = this->bounds->yMax = (verts->__get((int)1) + gt->y);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(101)
		this->bounds->yMin = _g3;
		HX_STACK_LINE(102)
		Float _g4 = this->bounds->zMax = (verts->__get((int)2) + gt->z);		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(102)
		this->bounds->zMin = _g4;
	}
	HX_STACK_LINE(104)
	int pos = (int)3;		HX_STACK_VAR(pos,"pos");
	HX_STACK_LINE(105)
	{
		HX_STACK_LINE(105)
		int _g1 = (int)1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(105)
		int _g2 = ::Std_obj::_int((Float(verts->length) / Float((int)3)));		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(105)
		while((true)){
			HX_STACK_LINE(105)
			if ((!(((_g1 < _g2))))){
				HX_STACK_LINE(105)
				break;
			}
			HX_STACK_LINE(105)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(106)
			int _g5 = (pos)++;		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(106)
			Float _g6 = verts->__get(_g5);		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(106)
			Float x = (_g6 + gt->x);		HX_STACK_VAR(x,"x");
			HX_STACK_LINE(107)
			int _g7 = (pos)++;		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(107)
			Float _g8 = verts->__get(_g7);		HX_STACK_VAR(_g8,"_g8");
			HX_STACK_LINE(107)
			Float y = (_g8 + gt->y);		HX_STACK_VAR(y,"y");
			HX_STACK_LINE(108)
			int _g9 = (pos)++;		HX_STACK_VAR(_g9,"_g9");
			HX_STACK_LINE(108)
			Float _g10 = verts->__get(_g9);		HX_STACK_VAR(_g10,"_g10");
			HX_STACK_LINE(108)
			Float z = (_g10 + gt->z);		HX_STACK_VAR(z,"z");
			HX_STACK_LINE(109)
			if (((x > this->bounds->xMax))){
				HX_STACK_LINE(109)
				this->bounds->xMax = x;
			}
			HX_STACK_LINE(110)
			if (((x < this->bounds->xMin))){
				HX_STACK_LINE(110)
				this->bounds->xMin = x;
			}
			HX_STACK_LINE(111)
			if (((y > this->bounds->yMax))){
				HX_STACK_LINE(111)
				this->bounds->yMax = y;
			}
			HX_STACK_LINE(112)
			if (((y < this->bounds->yMin))){
				HX_STACK_LINE(112)
				this->bounds->yMin = y;
			}
			HX_STACK_LINE(113)
			if (((z > this->bounds->zMax))){
				HX_STACK_LINE(113)
				this->bounds->zMax = z;
			}
			HX_STACK_LINE(114)
			if (((z < this->bounds->zMin))){
				HX_STACK_LINE(114)
				this->bounds->zMin = z;
			}
		}
	}
	HX_STACK_LINE(116)
	return this->bounds;
}


Void FBXModel_obj::render( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.prim.FBXModel","render",0xc5d94884,"h3d.prim.FBXModel.render","h3d/prim/FBXModel.hx",119,0xe945c8de)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(120)
		if (((this->curMaterial < (int)0))){
			HX_STACK_LINE(121)
			this->super::render(engine);
			HX_STACK_LINE(122)
			return null();
		}
		HX_STACK_LINE(124)
		if (((  ((!(((this->indexes == null()))))) ? bool(this->indexes->isDisposed()) : bool(true) ))){
			HX_STACK_LINE(125)
			this->alloc(engine);
		}
		HX_STACK_LINE(126)
		::h3d::impl::Indexes idx = this->indexes;		HX_STACK_VAR(idx,"idx");
		HX_STACK_LINE(127)
		this->indexes = this->groupIndexes->__get(this->curMaterial).StaticCast< ::h3d::impl::Indexes >();
		HX_STACK_LINE(128)
		if (((this->indexes != null()))){
			HX_STACK_LINE(128)
			this->super::render(engine);
		}
		HX_STACK_LINE(129)
		this->indexes = idx;
		HX_STACK_LINE(130)
		this->curMaterial = (int)-1;
	}
return null();
}


Void FBXModel_obj::selectMaterial( int material){
{
		HX_STACK_FRAME("h3d.prim.FBXModel","selectMaterial",0x208d4af1,"h3d.prim.FBXModel.selectMaterial","h3d/prim/FBXModel.hx",134,0xe945c8de)
		HX_STACK_THIS(this)
		HX_STACK_ARG(material,"material")
		HX_STACK_LINE(134)
		this->curMaterial = material;
	}
return null();
}


Void FBXModel_obj::dispose( ){
{
		HX_STACK_FRAME("h3d.prim.FBXModel","dispose",0x947e2bb1,"h3d.prim.FBXModel.dispose","h3d/prim/FBXModel.hx",137,0xe945c8de)
		HX_STACK_THIS(this)
		HX_STACK_LINE(138)
		this->super::dispose();
		HX_STACK_LINE(139)
		if (((this->groupIndexes != null()))){
			HX_STACK_LINE(140)
			{
				HX_STACK_LINE(140)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(140)
				Array< ::Dynamic > _g1 = this->groupIndexes;		HX_STACK_VAR(_g1,"_g1");
				HX_STACK_LINE(140)
				while((true)){
					HX_STACK_LINE(140)
					if ((!(((_g < _g1->length))))){
						HX_STACK_LINE(140)
						break;
					}
					HX_STACK_LINE(140)
					::h3d::impl::Indexes i = _g1->__get(_g).StaticCast< ::h3d::impl::Indexes >();		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(140)
					++(_g);
					HX_STACK_LINE(141)
					if (((i != null()))){
						HX_STACK_LINE(142)
						i->dispose();
					}
				}
			}
			HX_STACK_LINE(143)
			this->groupIndexes = null();
		}
	}
return null();
}


Array< Float > FBXModel_obj::processShapesVerts( Array< Float > vbuf){
	HX_STACK_FRAME("h3d.prim.FBXModel","processShapesVerts",0x48ecef0f,"h3d.prim.FBXModel.processShapesVerts","h3d/prim/FBXModel.hx",162,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(vbuf,"vbuf")
	HX_STACK_LINE(163)
	Array< Float > computedV = vbuf;		HX_STACK_VAR(computedV,"computedV");
	HX_STACK_LINE(164)
	int vlen = ::Std_obj::_int((Float(computedV->length) / Float((int)3)));		HX_STACK_VAR(vlen,"vlen");
	HX_STACK_LINE(165)
	Array< Float > resV = this->tempVert;		HX_STACK_VAR(resV,"resV");
	HX_STACK_LINE(167)
	::h3d::prim::FBXModel_obj::blit(resV,(int)0,computedV,(int)0,computedV->length);
	HX_STACK_LINE(169)
	{
		HX_STACK_LINE(169)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(169)
		int _g = this->blendShapes->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(169)
		while((true)){
			HX_STACK_LINE(169)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(169)
				break;
			}
			HX_STACK_LINE(169)
			int si = (_g1)++;		HX_STACK_VAR(si,"si");
			HX_STACK_LINE(170)
			::h3d::fbx::Geometry shape = this->blendShapes->__get(si).StaticCast< ::h3d::fbx::Geometry >();		HX_STACK_VAR(shape,"shape");
			HX_STACK_LINE(171)
			Array< int > index = shape->getShapeIndexes();		HX_STACK_VAR(index,"index");
			HX_STACK_LINE(172)
			Array< Float > vertex = shape->getVertices();		HX_STACK_VAR(vertex,"vertex");
			HX_STACK_LINE(173)
			int i = (int)0;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(174)
			Float r = this->shapeRatios->__get(si);		HX_STACK_VAR(r,"r");
			HX_STACK_LINE(177)
			::hxd::Assert_obj::notNan(r,null());
			HX_STACK_LINE(179)
			{
				HX_STACK_LINE(179)
				int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(179)
				while((true)){
					HX_STACK_LINE(179)
					if ((!(((_g2 < index->length))))){
						HX_STACK_LINE(179)
						break;
					}
					HX_STACK_LINE(179)
					int idx = index->__get(_g2);		HX_STACK_VAR(idx,"idx");
					HX_STACK_LINE(179)
					++(_g2);
					HX_STACK_LINE(180)
					hx::AddEq(resV[(idx * (int)3)],(r * vertex->__get((i * (int)3))));
					HX_STACK_LINE(181)
					hx::AddEq(resV[((idx * (int)3) + (int)1)],(r * vertex->__get(((i * (int)3) + (int)1))));
					HX_STACK_LINE(182)
					hx::AddEq(resV[((idx * (int)3) + (int)2)],(r * vertex->__get(((i * (int)3) + (int)2))));
					HX_STACK_LINE(184)
					(i)++;
				}
			}
		}
	}
	HX_STACK_LINE(188)
	return resV;
}


HX_DEFINE_DYNAMIC_FUNC1(FBXModel_obj,processShapesVerts,return )

Array< Float > FBXModel_obj::norm3( Array< Float > fb){
	HX_STACK_FRAME("h3d.prim.FBXModel","norm3",0xa8afc109,"h3d.prim.FBXModel.norm3","h3d/prim/FBXModel.hx",191,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(fb,"fb")
	HX_STACK_LINE(192)
	Float nx = 0.0;		HX_STACK_VAR(nx,"nx");
	HX_STACK_LINE(192)
	Float ny = 0.0;		HX_STACK_VAR(ny,"ny");
	HX_STACK_LINE(192)
	Float nz = 0.0;		HX_STACK_VAR(nz,"nz");
	HX_STACK_LINE(192)
	Float l = 0.0;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(193)
	int len = ::Math_obj::round((Float(fb->length) / Float((int)3)));		HX_STACK_VAR(len,"len");
	HX_STACK_LINE(194)
	{
		HX_STACK_LINE(194)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(194)
		while((true)){
			HX_STACK_LINE(194)
			if ((!(((_g < len))))){
				HX_STACK_LINE(194)
				break;
			}
			HX_STACK_LINE(194)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(195)
			nx = fb->__get((i * (int)3));
			HX_STACK_LINE(196)
			ny = fb->__get(((i * (int)3) + (int)1));
			HX_STACK_LINE(197)
			nz = fb->__get(((i * (int)3) + (int)2));
			HX_STACK_LINE(199)
			Float _g1 = ::Math_obj::sqrt((((nx * nx) + (ny * ny)) + (nz * nz)));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(199)
			Float _g11 = (Float(1.0) / Float(_g1));		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(199)
			l = _g11;
			HX_STACK_LINE(201)
			hx::MultEq(nx,l);
			HX_STACK_LINE(202)
			hx::MultEq(ny,l);
			HX_STACK_LINE(203)
			hx::MultEq(nz,l);
			HX_STACK_LINE(205)
			fb[(i * (int)3)] = nx;
			HX_STACK_LINE(206)
			fb[((i * (int)3) + (int)1)] = ny;
			HX_STACK_LINE(207)
			fb[((i * (int)3) + (int)2)] = nz;
		}
	}
	HX_STACK_LINE(209)
	return fb;
}


HX_DEFINE_DYNAMIC_FUNC1(FBXModel_obj,norm3,return )

Array< Float > FBXModel_obj::processShapesNorms( Array< Float > nbuf){
	HX_STACK_FRAME("h3d.prim.FBXModel","processShapesNorms",0xb4546724,"h3d.prim.FBXModel.processShapesNorms","h3d/prim/FBXModel.hx",213,0xe945c8de)
	HX_STACK_THIS(this)
	HX_STACK_ARG(nbuf,"nbuf")
	HX_STACK_LINE(214)
	Array< Float > computedN = nbuf;		HX_STACK_VAR(computedN,"computedN");
	HX_STACK_LINE(215)
	int vlen = ::Std_obj::_int((Float(computedN->length) / Float((int)3)));		HX_STACK_VAR(vlen,"vlen");
	HX_STACK_LINE(216)
	Float nx = 0.0;		HX_STACK_VAR(nx,"nx");
	HX_STACK_LINE(217)
	Float ny = 0.0;		HX_STACK_VAR(ny,"ny");
	HX_STACK_LINE(218)
	Float nz = 0.0;		HX_STACK_VAR(nz,"nz");
	HX_STACK_LINE(219)
	Float l = 0.0;		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(220)
	Float z = 0.0;		HX_STACK_VAR(z,"z");
	HX_STACK_LINE(221)
	Array< Float > resN = this->tempNorm;		HX_STACK_VAR(resN,"resN");
	HX_STACK_LINE(223)
	if (((resN->length < vlen))){
		HX_STACK_LINE(223)
		resN[vlen] = 0.0;
	}
	HX_STACK_LINE(224)
	::h3d::prim::FBXModel_obj::zero(resN);
	HX_STACK_LINE(226)
	{
		HX_STACK_LINE(226)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(226)
		int _g = this->blendShapes->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(226)
		while((true)){
			HX_STACK_LINE(226)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(226)
				break;
			}
			HX_STACK_LINE(226)
			int si = (_g1)++;		HX_STACK_VAR(si,"si");
			HX_STACK_LINE(227)
			::h3d::fbx::Geometry shape = this->blendShapes->__get(si).StaticCast< ::h3d::fbx::Geometry >();		HX_STACK_VAR(shape,"shape");
			HX_STACK_LINE(228)
			Array< Float > normals = shape->getShapeNormals();		HX_STACK_VAR(normals,"normals");
			HX_STACK_LINE(229)
			Array< int > index = shape->getShapeIndexes();		HX_STACK_VAR(index,"index");
			HX_STACK_LINE(230)
			int i = (int)0;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(231)
			Float r = this->shapeRatios->__get(si);		HX_STACK_VAR(r,"r");
			HX_STACK_LINE(233)
			::hxd::Assert_obj::notNan(r,null());
			HX_STACK_LINE(235)
			{
				HX_STACK_LINE(235)
				int _g2 = (int)0;		HX_STACK_VAR(_g2,"_g2");
				HX_STACK_LINE(235)
				while((true)){
					HX_STACK_LINE(235)
					if ((!(((_g2 < index->length))))){
						HX_STACK_LINE(235)
						break;
					}
					HX_STACK_LINE(235)
					int idx = index->__get(_g2);		HX_STACK_VAR(idx,"idx");
					HX_STACK_LINE(235)
					++(_g2);
					HX_STACK_LINE(236)
					hx::AddEq(resN[(idx * (int)3)],(r * normals->__get((i * (int)3))));
					HX_STACK_LINE(237)
					hx::AddEq(resN[((idx * (int)3) + (int)1)],(r * normals->__get(((i * (int)3) + (int)1))));
					HX_STACK_LINE(238)
					hx::AddEq(resN[((idx * (int)3) + (int)2)],(r * normals->__get(((i * (int)3) + (int)2))));
					HX_STACK_LINE(239)
					(i)++;
				}
			}
		}
	}
	HX_STACK_LINE(243)
	Float nx1 = 0.0;		HX_STACK_VAR(nx1,"nx1");
	HX_STACK_LINE(243)
	Float ny1 = 0.0;		HX_STACK_VAR(ny1,"ny1");
	HX_STACK_LINE(243)
	Float nz1 = 0.0;		HX_STACK_VAR(nz1,"nz1");
	HX_STACK_LINE(243)
	Float l1 = 0.0;		HX_STACK_VAR(l1,"l1");
	HX_STACK_LINE(243)
	int len = ::Math_obj::round((Float(resN->length) / Float((int)3)));		HX_STACK_VAR(len,"len");
	HX_STACK_LINE(243)
	{
		HX_STACK_LINE(243)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(243)
		while((true)){
			HX_STACK_LINE(243)
			if ((!(((_g < len))))){
				HX_STACK_LINE(243)
				break;
			}
			HX_STACK_LINE(243)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(243)
			nx1 = resN->__get((i * (int)3));
			HX_STACK_LINE(243)
			ny1 = resN->__get(((i * (int)3) + (int)1));
			HX_STACK_LINE(243)
			nz1 = resN->__get(((i * (int)3) + (int)2));
			HX_STACK_LINE(243)
			Float _g1 = ::Math_obj::sqrt((((nx1 * nx1) + (ny1 * ny1)) + (nz1 * nz1)));		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(243)
			Float _g11 = (Float(1.0) / Float(_g1));		HX_STACK_VAR(_g11,"_g11");
			HX_STACK_LINE(243)
			l1 = _g11;
			HX_STACK_LINE(243)
			hx::MultEq(nx1,l1);
			HX_STACK_LINE(243)
			hx::MultEq(ny1,l1);
			HX_STACK_LINE(243)
			hx::MultEq(nz1,l1);
			HX_STACK_LINE(243)
			resN[(i * (int)3)] = nx1;
			HX_STACK_LINE(243)
			resN[((i * (int)3) + (int)1)] = ny1;
			HX_STACK_LINE(243)
			resN[((i * (int)3) + (int)2)] = nz1;
		}
	}
	HX_STACK_LINE(243)
	return resN;
}


HX_DEFINE_DYNAMIC_FUNC1(FBXModel_obj,processShapesNorms,return )

Void FBXModel_obj::alloc( ::h3d::Engine engine){
{
		HX_STACK_FRAME("h3d.prim.FBXModel","alloc",0x2a7a0707,"h3d.prim.FBXModel.alloc","h3d/prim/FBXModel.hx",247,0xe945c8de)
		HX_STACK_THIS(this)
		HX_STACK_ARG(engine,"engine")
		HX_STACK_LINE(248)
		this->dispose();
		HX_STACK_LINE(250)
		if (((::hxd::System_obj::debugLevel >= (int)2))){
			HX_STACK_LINE(250)
			::haxe::Log_obj::trace(((HX_CSTRING("FBXModel(#") + this->id) + HX_CSTRING(").alloc()")),hx::SourceInfo(HX_CSTRING("FBXModel.hx"),250,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("alloc")));
		}
		HX_STACK_LINE(252)
		Array< Float > verts = this->geom->getVertices();		HX_STACK_VAR(verts,"verts");
		HX_STACK_LINE(253)
		Array< Float > norms = this->geom->getNormals();		HX_STACK_VAR(norms,"norms");
		HX_STACK_LINE(255)
		if (((this->shapeRatios != null()))){
			HX_STACK_LINE(256)
			Array< Float > _g = this->processShapesVerts(verts);		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(256)
			verts = _g;
			HX_STACK_LINE(257)
			Array< Float > _g1 = this->processShapesNorms(norms);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(257)
			norms = _g1;
		}
		HX_STACK_LINE(261)
		Array< Float > _g2 = this->onVertexBuffer(verts);		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(261)
		verts = _g2;
		HX_STACK_LINE(262)
		Array< Float > _g3 = this->onNormalBuffer(norms);		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(262)
		norms = _g3;
		HX_STACK_LINE(264)
		Dynamic _g4 = this->geom->getUVs();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(264)
		Dynamic tuvs = _g4->__GetItem((int)0);		HX_STACK_VAR(tuvs,"tuvs");
		HX_STACK_LINE(265)
		Dynamic colors = this->geom->getColors();		HX_STACK_VAR(colors,"colors");
		HX_STACK_LINE(266)
		Array< int > mats;		HX_STACK_VAR(mats,"mats");
		HX_STACK_LINE(266)
		if ((this->multiMaterial)){
			HX_STACK_LINE(266)
			mats = this->geom->getMaterials();
		}
		else{
			HX_STACK_LINE(266)
			mats = null();
		}
		HX_STACK_LINE(268)
		::h3d::col::Point gt = this->geom->getGeomTranslate();		HX_STACK_VAR(gt,"gt");
		HX_STACK_LINE(269)
		if (((gt == null()))){
			HX_STACK_LINE(269)
			::h3d::col::Point _g5 = ::h3d::col::Point_obj::__new(null(),null(),null());		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(269)
			gt = _g5;
		}
		HX_STACK_LINE(271)
		Array< int > idx;		HX_STACK_VAR(idx,"idx");
		HX_STACK_LINE(271)
		{
			HX_STACK_LINE(271)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(271)
			idx = Array_obj< int >::__new();
		}
		HX_STACK_LINE(272)
		Array< ::Dynamic > midx = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(midx,"midx");
		HX_STACK_LINE(274)
		Array< Float > pbuf;		HX_STACK_VAR(pbuf,"pbuf");
		HX_STACK_LINE(274)
		{
			HX_STACK_LINE(274)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(274)
			pbuf = Array_obj< Float >::__new();
		}
		HX_STACK_LINE(275)
		Array< Float > nbuf;		HX_STACK_VAR(nbuf,"nbuf");
		HX_STACK_LINE(275)
		if (((norms == null()))){
			HX_STACK_LINE(275)
			nbuf = null();
		}
		else{
			HX_STACK_LINE(275)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(275)
			nbuf = Array_obj< Float >::__new();
		}
		HX_STACK_LINE(276)
		::haxe::io::BytesOutput sbuf;		HX_STACK_VAR(sbuf,"sbuf");
		HX_STACK_LINE(276)
		if (((this->skin == null()))){
			HX_STACK_LINE(276)
			sbuf = null();
		}
		else{
			HX_STACK_LINE(276)
			sbuf = ::haxe::io::BytesOutput_obj::__new();
		}
		HX_STACK_LINE(277)
		Array< Float > tbuf;		HX_STACK_VAR(tbuf,"tbuf");
		HX_STACK_LINE(277)
		if (((tuvs == null()))){
			HX_STACK_LINE(277)
			tbuf = null();
		}
		else{
			HX_STACK_LINE(277)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(277)
			tbuf = Array_obj< Float >::__new();
		}
		HX_STACK_LINE(279)
		Array< Float > cbuf;		HX_STACK_VAR(cbuf,"cbuf");
		HX_STACK_LINE(279)
		if (((colors == null()))){
			HX_STACK_LINE(279)
			cbuf = null();
		}
		else{
			HX_STACK_LINE(279)
			int length = (int)0;		HX_STACK_VAR(length,"length");
			HX_STACK_LINE(279)
			cbuf = Array_obj< Float >::__new();
		}
		HX_STACK_LINE(282)
		Array< ::Dynamic > sidx = null();		HX_STACK_VAR(sidx,"sidx");
		HX_STACK_LINE(282)
		int stri = (int)0;		HX_STACK_VAR(stri,"stri");
		HX_STACK_LINE(283)
		if (((bool((this->skin != null())) && bool((this->skin->splitJoints != null()))))){
			HX_STACK_LINE(284)
			if ((this->multiMaterial)){
				HX_STACK_LINE(284)
				HX_STACK_DO_THROW(HX_CSTRING("Multimaterial not supported with skin split"));
			}
			HX_STACK_LINE(285)
			Array< ::Dynamic > _g7;		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(285)
			{
				HX_STACK_LINE(285)
				Array< ::Dynamic > _g = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(285)
				{
					HX_STACK_LINE(285)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(285)
					Array< ::Dynamic > _g21 = this->skin->splitJoints;		HX_STACK_VAR(_g21,"_g21");
					HX_STACK_LINE(285)
					while((true)){
						HX_STACK_LINE(285)
						if ((!(((_g1 < _g21->length))))){
							HX_STACK_LINE(285)
							break;
						}
						HX_STACK_LINE(285)
						Array< ::Dynamic > _ = _g21->__get(_g1).StaticCast< Array< ::Dynamic > >();		HX_STACK_VAR(_,"_");
						HX_STACK_LINE(285)
						++(_g1);
						HX_STACK_LINE(285)
						Array< int > _g6;		HX_STACK_VAR(_g6,"_g6");
						HX_STACK_LINE(285)
						{
							HX_STACK_LINE(285)
							int length = (int)0;		HX_STACK_VAR(length,"length");
							HX_STACK_LINE(285)
							_g6 = Array_obj< int >::__new();
						}
						HX_STACK_LINE(285)
						_g->push(_g6);
					}
				}
				HX_STACK_LINE(285)
				_g7 = _g;
			}
			HX_STACK_LINE(285)
			sidx = _g7;
		}
		HX_STACK_LINE(288)
		if (((sbuf != null()))){
			HX_STACK_LINE(288)
			if (((::hxd::System_obj::debugLevel >= (int)2))){
				HX_STACK_LINE(288)
				::haxe::Log_obj::trace(((HX_CSTRING("FBXModel(#") + this->id) + HX_CSTRING(").alloc() has skin infos")),hx::SourceInfo(HX_CSTRING("FBXModel.hx"),288,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("alloc")));
			}
		}
		HX_STACK_LINE(290)
		Array< ::Dynamic > oldToNew = Array_obj< ::Dynamic >::__new().Add(::haxe::ds::IntMap_obj::__new());		HX_STACK_VAR(oldToNew,"oldToNew");
		HX_STACK_LINE(294)
		int count = (int)0;		HX_STACK_VAR(count,"count");
		HX_STACK_LINE(294)
		int pos = (int)0;		HX_STACK_VAR(pos,"pos");
		HX_STACK_LINE(294)
		int matPos = (int)0;		HX_STACK_VAR(matPos,"matPos");
		HX_STACK_LINE(295)
		Array< int > index = this->geom->getPolygons();		HX_STACK_VAR(index,"index");

		HX_BEGIN_LOCAL_FUNC_S1(hx::LocalFunc,_Function_1_1,Array< ::Dynamic >,oldToNew)
		Void run(int oindx,int nindex){
			HX_STACK_FRAME("*","_Function_1_1",0x5200ed37,"*._Function_1_1","h3d/prim/FBXModel.hx",297,0xe945c8de)
			HX_STACK_ARG(oindx,"oindx")
			HX_STACK_ARG(nindex,"nindex")
			{
				HX_STACK_LINE(298)
				Array< int > tgt = null();		HX_STACK_VAR(tgt,"tgt");
				HX_STACK_LINE(299)
				Array< int > _g8 = oldToNew->__get((int)0).StaticCast< ::haxe::ds::IntMap >()->get(oindx);		HX_STACK_VAR(_g8,"_g8");
				HX_STACK_LINE(299)
				if (((_g8 == null()))){
					HX_STACK_LINE(300)
					Array< int > value = tgt = Array_obj< int >::__new();		HX_STACK_VAR(value,"value");
					HX_STACK_LINE(300)
					oldToNew->__get((int)0).StaticCast< ::haxe::ds::IntMap >()->set(oindx,value);
				}
				else{
					HX_STACK_LINE(301)
					Array< int > _g9 = oldToNew->__get((int)0).StaticCast< ::haxe::ds::IntMap >()->get(oindx);		HX_STACK_VAR(_g9,"_g9");
					HX_STACK_LINE(301)
					tgt = _g9;
				}
				HX_STACK_LINE(302)
				tgt->push(nindex);
			}
			return null();
		}
		HX_END_LOCAL_FUNC2((void))

		HX_STACK_LINE(297)
		Dynamic link =  Dynamic(new _Function_1_1(oldToNew));		HX_STACK_VAR(link,"link");
		HX_STACK_LINE(305)
		{
			HX_STACK_LINE(305)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(305)
			while((true)){
				HX_STACK_LINE(305)
				if ((!(((_g < index->length))))){
					HX_STACK_LINE(305)
					break;
				}
				HX_STACK_LINE(305)
				int i = index->__get(_g);		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(305)
				++(_g);
				HX_STACK_LINE(306)
				(count)++;
				HX_STACK_LINE(307)
				if (((i < (int)0))){
					HX_STACK_LINE(308)
					index[pos] = (-(i) - (int)1);
					HX_STACK_LINE(309)
					int start = ((pos - count) + (int)1);		HX_STACK_VAR(start,"start");
					HX_STACK_LINE(310)
					{
						HX_STACK_LINE(310)
						int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(310)
						while((true)){
							HX_STACK_LINE(310)
							if ((!(((_g1 < count))))){
								HX_STACK_LINE(310)
								break;
							}
							HX_STACK_LINE(310)
							int n = (_g1)++;		HX_STACK_VAR(n,"n");
							HX_STACK_LINE(311)
							int k = (n + start);		HX_STACK_VAR(k,"k");
							HX_STACK_LINE(312)
							int vidx = index->__get(k);		HX_STACK_VAR(vidx,"vidx");
							HX_STACK_LINE(314)
							Float x = (verts->__get((vidx * (int)3)) + gt->x);		HX_STACK_VAR(x,"x");
							HX_STACK_LINE(315)
							Float y = (verts->__get(((vidx * (int)3) + (int)1)) + gt->y);		HX_STACK_VAR(y,"y");
							HX_STACK_LINE(316)
							Float z = (verts->__get(((vidx * (int)3) + (int)2)) + gt->z);		HX_STACK_VAR(z,"z");
							HX_STACK_LINE(318)
							if ((this->isDynamic)){
								HX_STACK_LINE(318)
								int _g10 = ::Math_obj::round((Float(pbuf->length) / Float((int)3)));		HX_STACK_VAR(_g10,"_g10");
								HX_STACK_LINE(318)
								link(vidx,_g10).Cast< Void >();
							}
							HX_STACK_LINE(320)
							pbuf->push(x);
							HX_STACK_LINE(321)
							pbuf->push(y);
							HX_STACK_LINE(322)
							pbuf->push(z);
							HX_STACK_LINE(324)
							if (((nbuf != null()))){
								HX_STACK_LINE(325)
								nbuf->push(norms->__get((k * (int)3)));
								HX_STACK_LINE(326)
								nbuf->push(norms->__get(((k * (int)3) + (int)1)));
								HX_STACK_LINE(327)
								nbuf->push(norms->__get(((k * (int)3) + (int)2)));
							}
							HX_STACK_LINE(330)
							if (((tbuf != null()))){
								HX_STACK_LINE(331)
								int iuv = tuvs->__Field(HX_CSTRING("index"),true)->__GetItem(k);		HX_STACK_VAR(iuv,"iuv");
								HX_STACK_LINE(332)
								tbuf->push(tuvs->__Field(HX_CSTRING("values"),true)->__GetItem((iuv * (int)2)));
								HX_STACK_LINE(333)
								tbuf->push(((int)1 - tuvs->__Field(HX_CSTRING("values"),true)->__GetItem(((iuv * (int)2) + (int)1))));
							}
							HX_STACK_LINE(336)
							if (((sbuf != null()))){
								HX_STACK_LINE(337)
								int p = (vidx * this->skin->bonesPerVertex);		HX_STACK_VAR(p,"p");
								HX_STACK_LINE(338)
								int idx1 = (int)0;		HX_STACK_VAR(idx1,"idx1");
								HX_STACK_LINE(339)
								{
									HX_STACK_LINE(339)
									int _g31 = (int)0;		HX_STACK_VAR(_g31,"_g31");
									HX_STACK_LINE(339)
									int _g21 = this->skin->bonesPerVertex;		HX_STACK_VAR(_g21,"_g21");
									HX_STACK_LINE(339)
									while((true)){
										HX_STACK_LINE(339)
										if ((!(((_g31 < _g21))))){
											HX_STACK_LINE(339)
											break;
										}
										HX_STACK_LINE(339)
										int i1 = (_g31)++;		HX_STACK_VAR(i1,"i1");
										HX_STACK_LINE(340)
										{
											HX_STACK_LINE(340)
											Float v = this->skin->vertexWeights->__unsafe_get((p + i1));		HX_STACK_VAR(v,"v");
											HX_STACK_LINE(340)
											sbuf->writeFloat(v);
										}
										HX_STACK_LINE(341)
										int _g11 = this->skin->vertexJoints->__unsafe_get((p + i1));		HX_STACK_VAR(_g11,"_g11");
										HX_STACK_LINE(341)
										int _g12 = (int(_g11) << int(((int)8 * i1)));		HX_STACK_VAR(_g12,"_g12");
										HX_STACK_LINE(341)
										int _g13 = (int(_g12) | int(idx1));		HX_STACK_VAR(_g13,"_g13");
										HX_STACK_LINE(341)
										idx1 = _g13;
									}
								}
								HX_STACK_LINE(343)
								sbuf->writeInt32(idx1);
							}
							HX_STACK_LINE(346)
							if (((cbuf != null()))){
								HX_STACK_LINE(347)
								int icol = colors->__Field(HX_CSTRING("index"),true)->__GetItem(k);		HX_STACK_VAR(icol,"icol");
								HX_STACK_LINE(348)
								cbuf->push(colors->__Field(HX_CSTRING("values"),true)->__GetItem((icol * (int)4)));
								HX_STACK_LINE(349)
								cbuf->push(colors->__Field(HX_CSTRING("values"),true)->__GetItem(((icol * (int)4) + (int)1)));
								HX_STACK_LINE(350)
								cbuf->push(colors->__Field(HX_CSTRING("values"),true)->__GetItem(((icol * (int)4) + (int)2)));
							}
						}
					}
					HX_STACK_LINE(354)
					{
						HX_STACK_LINE(354)
						int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(354)
						int _g1 = (count - (int)2);		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(354)
						while((true)){
							HX_STACK_LINE(354)
							if ((!(((_g21 < _g1))))){
								HX_STACK_LINE(354)
								break;
							}
							HX_STACK_LINE(354)
							int n = (_g21)++;		HX_STACK_VAR(n,"n");
							HX_STACK_LINE(355)
							idx->push((start + n));
							HX_STACK_LINE(356)
							idx->push(((start + count) - (int)1));
							HX_STACK_LINE(357)
							idx->push(((start + n) + (int)1));
						}
					}
					HX_STACK_LINE(360)
					if (((bool((this->skin != null())) && bool((this->skin->splitJoints != null()))))){
						HX_STACK_LINE(361)
						int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
						HX_STACK_LINE(361)
						int _g1 = (count - (int)2);		HX_STACK_VAR(_g1,"_g1");
						HX_STACK_LINE(361)
						while((true)){
							HX_STACK_LINE(361)
							if ((!(((_g21 < _g1))))){
								HX_STACK_LINE(361)
								break;
							}
							HX_STACK_LINE(361)
							int n = (_g21)++;		HX_STACK_VAR(n,"n");
							HX_STACK_LINE(362)
							Dynamic _g14;		HX_STACK_VAR(_g14,"_g14");
							HX_STACK_LINE(362)
							{
								HX_STACK_LINE(362)
								int index1 = (stri)++;		HX_STACK_VAR(index1,"index1");
								HX_STACK_LINE(362)
								_g14 = this->skin->triangleGroups->__unsafe_get(index1);
							}
							HX_STACK_LINE(362)
							Array< int > idx1 = sidx->__get(_g14).StaticCast< Array< int > >();		HX_STACK_VAR(idx1,"idx1");
							HX_STACK_LINE(363)
							idx1->push((start + n));
							HX_STACK_LINE(364)
							idx1->push(((start + count) - (int)1));
							HX_STACK_LINE(365)
							idx1->push(((start + n) + (int)1));
						}
					}
					HX_STACK_LINE(369)
					if (((mats != null()))){
						HX_STACK_LINE(370)
						int _g15 = (matPos)++;		HX_STACK_VAR(_g15,"_g15");
						HX_STACK_LINE(370)
						int mid = mats->__get(_g15);		HX_STACK_VAR(mid,"mid");
						HX_STACK_LINE(371)
						Array< int > idx1 = midx->__get(mid).StaticCast< Array< int > >();		HX_STACK_VAR(idx1,"idx1");
						HX_STACK_LINE(372)
						if (((idx1 == null()))){
							HX_STACK_LINE(373)
							Array< int > _g16;		HX_STACK_VAR(_g16,"_g16");
							HX_STACK_LINE(373)
							{
								HX_STACK_LINE(373)
								int length = (int)0;		HX_STACK_VAR(length,"length");
								HX_STACK_LINE(373)
								_g16 = Array_obj< int >::__new();
							}
							HX_STACK_LINE(373)
							idx1 = _g16;
							HX_STACK_LINE(374)
							midx[mid] = idx1;
						}
						HX_STACK_LINE(376)
						{
							HX_STACK_LINE(376)
							int _g21 = (int)0;		HX_STACK_VAR(_g21,"_g21");
							HX_STACK_LINE(376)
							int _g1 = (count - (int)2);		HX_STACK_VAR(_g1,"_g1");
							HX_STACK_LINE(376)
							while((true)){
								HX_STACK_LINE(376)
								if ((!(((_g21 < _g1))))){
									HX_STACK_LINE(376)
									break;
								}
								HX_STACK_LINE(376)
								int n = (_g21)++;		HX_STACK_VAR(n,"n");
								HX_STACK_LINE(377)
								idx1->push((start + n));
								HX_STACK_LINE(378)
								idx1->push(((start + count) - (int)1));
								HX_STACK_LINE(379)
								idx1->push(((start + n) + (int)1));
							}
						}
					}
					HX_STACK_LINE(382)
					index[pos] = i;
					HX_STACK_LINE(383)
					count = (int)0;
				}
				HX_STACK_LINE(385)
				(pos)++;
			}
		}
		HX_STACK_LINE(388)
		if ((this->isDynamic)){
			HX_STACK_LINE(390)
			::h3d::prim::FBXBuffers _g17 = ::h3d::prim::FBXBuffers_obj::__new();		HX_STACK_VAR(_g17,"_g17");
			HX_STACK_LINE(390)
			this->geomCache = _g17;
			HX_STACK_LINE(392)
			this->geomCache->originalVerts = verts;
			HX_STACK_LINE(394)
			Array< int > _g18 = index->copy();		HX_STACK_VAR(_g18,"_g18");
			HX_STACK_LINE(394)
			this->geomCache->index = _g18;
			HX_STACK_LINE(395)
			this->geomCache->gt = gt;
			HX_STACK_LINE(396)
			Array< Float > _g19;		HX_STACK_VAR(_g19,"_g19");
			HX_STACK_LINE(396)
			{
				HX_STACK_LINE(396)
				Array< Float > v = Array_obj< Float >::__new();		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(396)
				{
					HX_STACK_LINE(396)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(396)
					int _g = pbuf->length;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(396)
					while((true)){
						HX_STACK_LINE(396)
						if ((!(((_g1 < _g))))){
							HX_STACK_LINE(396)
							break;
						}
						HX_STACK_LINE(396)
						int i = (_g1)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(396)
						if (((v->length <= i))){
							HX_STACK_LINE(396)
							HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
						}
						HX_STACK_LINE(396)
						v[i] = pbuf->__get(i);
					}
				}
				HX_STACK_LINE(396)
				_g19 = v;
			}
			HX_STACK_LINE(396)
			this->geomCache->pbuf = _g19;
			HX_STACK_LINE(397)
			this->geomCache->idx = idx;
			HX_STACK_LINE(398)
			this->geomCache->midx = midx;
			HX_STACK_LINE(399)
			this->geomCache->tbuf = tbuf;
			HX_STACK_LINE(400)
			Array< Float > _g20;		HX_STACK_VAR(_g20,"_g20");
			HX_STACK_LINE(400)
			{
				HX_STACK_LINE(400)
				Array< Float > v = Array_obj< Float >::__new();		HX_STACK_VAR(v,"v");
				HX_STACK_LINE(400)
				{
					HX_STACK_LINE(400)
					int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(400)
					int _g = nbuf->length;		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(400)
					while((true)){
						HX_STACK_LINE(400)
						if ((!(((_g1 < _g))))){
							HX_STACK_LINE(400)
							break;
						}
						HX_STACK_LINE(400)
						int i = (_g1)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(400)
						if (((v->length <= i))){
							HX_STACK_LINE(400)
							HX_STACK_DO_THROW((HX_CSTRING("need regrow until ") + i));
						}
						HX_STACK_LINE(400)
						v[i] = nbuf->__get(i);
					}
				}
				HX_STACK_LINE(400)
				_g20 = v;
			}
			HX_STACK_LINE(400)
			this->geomCache->nbuf = _g20;
			HX_STACK_LINE(401)
			this->geomCache->sbuf = sbuf;
			HX_STACK_LINE(402)
			this->geomCache->cbuf = cbuf;
			HX_STACK_LINE(403)
			this->geomCache->oldToNew = oldToNew->__get((int)0).StaticCast< ::haxe::ds::IntMap >();
		}
		HX_STACK_LINE(407)
		::h3d::impl::Buffer _g21 = engine->mem->allocVector(pbuf,(int)3,(int)0,null(),hx::SourceInfo(HX_CSTRING("FBXModel.hx"),407,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g21,"_g21");
		HX_STACK_LINE(407)
		this->addBuffer(HX_CSTRING("pos"),_g21,null(),null(),null());
		HX_STACK_LINE(408)
		if (((nbuf != null()))){
			HX_STACK_LINE(408)
			::h3d::impl::Buffer _g22 = engine->mem->allocVector(nbuf,(int)3,(int)0,null(),hx::SourceInfo(HX_CSTRING("FBXModel.hx"),408,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g22,"_g22");
			HX_STACK_LINE(408)
			this->addBuffer(HX_CSTRING("normal"),_g22,null(),null(),null());
		}
		HX_STACK_LINE(409)
		if (((tbuf != null()))){
			HX_STACK_LINE(409)
			::h3d::impl::Buffer _g23 = engine->mem->allocVector(tbuf,(int)2,(int)0,null(),hx::SourceInfo(HX_CSTRING("FBXModel.hx"),409,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g23,"_g23");
			HX_STACK_LINE(409)
			this->addBuffer(HX_CSTRING("uv"),_g23,null(),null(),null());
		}
		HX_STACK_LINE(410)
		if (((sbuf != null()))){
			HX_STACK_LINE(411)
			int nverts = ::Std_obj::_int((Float(sbuf->b->b->length) / Float(((((this->skin->bonesPerVertex + (int)1)) * (int)4)))));		HX_STACK_VAR(nverts,"nverts");
			HX_STACK_LINE(412)
			::h3d::impl::Buffer skinBuf = engine->mem->alloc(nverts,(this->skin->bonesPerVertex + (int)1),(int)0,null(),hx::SourceInfo(HX_CSTRING("FBXModel.hx"),412,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("alloc")));		HX_STACK_VAR(skinBuf,"skinBuf");
			HX_STACK_LINE(413)
			::haxe::io::Bytes _g24 = sbuf->getBytes();		HX_STACK_VAR(_g24,"_g24");
			HX_STACK_LINE(413)
			skinBuf->uploadBytes(_g24,(int)0,nverts);
			HX_STACK_LINE(414)
			::h3d::impl::BufferOffset bw = this->addBuffer(HX_CSTRING("weights"),skinBuf,(int)0,null(),null());		HX_STACK_VAR(bw,"bw");
			HX_STACK_LINE(415)
			bw->shared = true;
			HX_STACK_LINE(415)
			bw->stride = (int)16;
			HX_STACK_LINE(417)
			::h3d::impl::BufferOffset bi = this->addBuffer(HX_CSTRING("indexes"),skinBuf,this->skin->bonesPerVertex,null(),null());		HX_STACK_VAR(bi,"bi");
			HX_STACK_LINE(418)
			bi->shared = true;
			HX_STACK_LINE(418)
			bi->stride = (int)16;
		}
		else{
			HX_STACK_LINE(421)
			Dynamic();
		}
		HX_STACK_LINE(424)
		if (((cbuf != null()))){
			HX_STACK_LINE(424)
			::h3d::impl::Buffer _g25 = engine->mem->allocVector(cbuf,(int)3,(int)0,null(),hx::SourceInfo(HX_CSTRING("FBXModel.hx"),424,HX_CSTRING("h3d.prim.FBXModel"),HX_CSTRING("alloc")));		HX_STACK_VAR(_g25,"_g25");
			HX_STACK_LINE(424)
			this->addBuffer(HX_CSTRING("color"),_g25,null(),null(),null());
		}
		HX_STACK_LINE(426)
		::h3d::impl::Indexes _g26 = engine->mem->allocIndex(idx,null(),null());		HX_STACK_VAR(_g26,"_g26");
		HX_STACK_LINE(426)
		this->indexes = _g26;
		HX_STACK_LINE(427)
		if (((mats != null()))){
			HX_STACK_LINE(428)
			this->groupIndexes = Array_obj< ::Dynamic >::__new();
			HX_STACK_LINE(429)
			{
				HX_STACK_LINE(429)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(429)
				while((true)){
					HX_STACK_LINE(429)
					if ((!(((_g < midx->length))))){
						HX_STACK_LINE(429)
						break;
					}
					HX_STACK_LINE(429)
					Array< int > i = midx->__get(_g).StaticCast< Array< int > >();		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(429)
					++(_g);
					HX_STACK_LINE(430)
					::h3d::impl::Indexes _g27;		HX_STACK_VAR(_g27,"_g27");
					HX_STACK_LINE(430)
					if (((i == null()))){
						HX_STACK_LINE(430)
						_g27 = null();
					}
					else{
						HX_STACK_LINE(430)
						_g27 = engine->mem->allocIndex(i,null(),null());
					}
					HX_STACK_LINE(430)
					this->groupIndexes->push(_g27);
				}
			}
		}
		HX_STACK_LINE(432)
		if (((sidx != null()))){
			HX_STACK_LINE(433)
			this->groupIndexes = Array_obj< ::Dynamic >::__new();
			HX_STACK_LINE(434)
			{
				HX_STACK_LINE(434)
				int _g = (int)0;		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(434)
				while((true)){
					HX_STACK_LINE(434)
					if ((!(((_g < sidx->length))))){
						HX_STACK_LINE(434)
						break;
					}
					HX_STACK_LINE(434)
					Array< int > i = sidx->__get(_g).StaticCast< Array< int > >();		HX_STACK_VAR(i,"i");
					HX_STACK_LINE(434)
					++(_g);
					HX_STACK_LINE(435)
					::h3d::impl::Indexes _g28;		HX_STACK_VAR(_g28,"_g28");
					HX_STACK_LINE(435)
					if (((i == null()))){
						HX_STACK_LINE(435)
						_g28 = null();
					}
					else{
						HX_STACK_LINE(435)
						_g28 = engine->mem->allocIndex(i,null(),null());
					}
					HX_STACK_LINE(435)
					this->groupIndexes->push(_g28);
				}
			}
		}
	}
return null();
}


int FBXModel_obj::uid;

Void FBXModel_obj::zero( Array< Float > t){
{
		HX_STACK_FRAME("h3d.prim.FBXModel","zero",0x610da4d6,"h3d.prim.FBXModel.zero","h3d/prim/FBXModel.hx",148,0xe945c8de)
		HX_STACK_ARG(t,"t")
		HX_STACK_LINE(148)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(148)
		int _g = t->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(148)
		while((true)){
			HX_STACK_LINE(148)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(148)
				break;
			}
			HX_STACK_LINE(148)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(148)
			t[i] = 0.0;
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(FBXModel_obj,zero,(void))

Void FBXModel_obj::blit( Array< Float > d,Dynamic __o_dstPos,Array< Float > src,Dynamic __o_srcPos,Dynamic __o_nb){
Dynamic dstPos = __o_dstPos.Default(0);
Dynamic srcPos = __o_srcPos.Default(0);
Dynamic nb = __o_nb.Default(-1);
	HX_STACK_FRAME("h3d.prim.FBXModel","blit",0x5135cde3,"h3d.prim.FBXModel.blit","h3d/prim/FBXModel.hx",151,0xe945c8de)
	HX_STACK_ARG(d,"d")
	HX_STACK_ARG(dstPos,"dstPos")
	HX_STACK_ARG(src,"src")
	HX_STACK_ARG(srcPos,"srcPos")
	HX_STACK_ARG(nb,"nb")
{
		HX_STACK_LINE(152)
		if (((nb < (int)0))){
			HX_STACK_LINE(152)
			nb = src->length;
		}
		HX_STACK_LINE(154)
		{
			HX_STACK_LINE(154)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(154)
			while((true)){
				HX_STACK_LINE(154)
				if ((!(((_g < nb))))){
					HX_STACK_LINE(154)
					break;
				}
				HX_STACK_LINE(154)
				int i = (_g)++;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(155)
				d[(i + dstPos)] = src->__get((i + srcPos));
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(FBXModel_obj,blit,(void))


FBXModel_obj::FBXModel_obj()
{
	onVertexBuffer = new __default_onVertexBuffer(this);
	onNormalBuffer = new __default_onNormalBuffer(this);
}

void FBXModel_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(FBXModel);
	HX_MARK_MEMBER_NAME(geom,"geom");
	HX_MARK_MEMBER_NAME(blendShapes,"blendShapes");
	HX_MARK_MEMBER_NAME(skin,"skin");
	HX_MARK_MEMBER_NAME(multiMaterial,"multiMaterial");
	HX_MARK_MEMBER_NAME(bounds,"bounds");
	HX_MARK_MEMBER_NAME(curMaterial,"curMaterial");
	HX_MARK_MEMBER_NAME(groupIndexes,"groupIndexes");
	HX_MARK_MEMBER_NAME(isDynamic,"isDynamic");
	HX_MARK_MEMBER_NAME(geomCache,"geomCache");
	HX_MARK_MEMBER_NAME(id,"id");
	HX_MARK_MEMBER_NAME(shapeRatios,"shapeRatios");
	HX_MARK_MEMBER_NAME(onVertexBuffer,"onVertexBuffer");
	HX_MARK_MEMBER_NAME(onNormalBuffer,"onNormalBuffer");
	HX_MARK_MEMBER_NAME(tempVert,"tempVert");
	HX_MARK_MEMBER_NAME(tempNorm,"tempNorm");
	::h3d::prim::MeshPrimitive_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void FBXModel_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(geom,"geom");
	HX_VISIT_MEMBER_NAME(blendShapes,"blendShapes");
	HX_VISIT_MEMBER_NAME(skin,"skin");
	HX_VISIT_MEMBER_NAME(multiMaterial,"multiMaterial");
	HX_VISIT_MEMBER_NAME(bounds,"bounds");
	HX_VISIT_MEMBER_NAME(curMaterial,"curMaterial");
	HX_VISIT_MEMBER_NAME(groupIndexes,"groupIndexes");
	HX_VISIT_MEMBER_NAME(isDynamic,"isDynamic");
	HX_VISIT_MEMBER_NAME(geomCache,"geomCache");
	HX_VISIT_MEMBER_NAME(id,"id");
	HX_VISIT_MEMBER_NAME(shapeRatios,"shapeRatios");
	HX_VISIT_MEMBER_NAME(onVertexBuffer,"onVertexBuffer");
	HX_VISIT_MEMBER_NAME(onNormalBuffer,"onNormalBuffer");
	HX_VISIT_MEMBER_NAME(tempVert,"tempVert");
	HX_VISIT_MEMBER_NAME(tempNorm,"tempNorm");
	::h3d::prim::MeshPrimitive_obj::__Visit(HX_VISIT_ARG);
}

Dynamic FBXModel_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { return id; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"uid") ) { return uid; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"zero") ) { return zero_dyn(); }
		if (HX_FIELD_EQ(inName,"blit") ) { return blit_dyn(); }
		if (HX_FIELD_EQ(inName,"geom") ) { return geom; }
		if (HX_FIELD_EQ(inName,"skin") ) { return skin; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"norm3") ) { return norm3_dyn(); }
		if (HX_FIELD_EQ(inName,"alloc") ) { return alloc_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"bounds") ) { return bounds; }
		if (HX_FIELD_EQ(inName,"render") ) { return render_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"dispose") ) { return dispose_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"tempVert") ) { return tempVert; }
		if (HX_FIELD_EQ(inName,"tempNorm") ) { return tempNorm; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"isDynamic") ) { return isDynamic; }
		if (HX_FIELD_EQ(inName,"geomCache") ) { return geomCache; }
		if (HX_FIELD_EQ(inName,"getBounds") ) { return getBounds_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"blendShapes") ) { return blendShapes; }
		if (HX_FIELD_EQ(inName,"curMaterial") ) { return curMaterial; }
		if (HX_FIELD_EQ(inName,"shapeRatios") ) { return shapeRatios; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"groupIndexes") ) { return groupIndexes; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"multiMaterial") ) { return multiMaterial; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"onVertexBuffer") ) { return onVertexBuffer; }
		if (HX_FIELD_EQ(inName,"onNormalBuffer") ) { return onNormalBuffer; }
		if (HX_FIELD_EQ(inName,"selectMaterial") ) { return selectMaterial_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"set_shapeRatios") ) { return set_shapeRatios_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"getVerticesCount") ) { return getVerticesCount_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"processShapesVerts") ) { return processShapesVerts_dyn(); }
		if (HX_FIELD_EQ(inName,"processShapesNorms") ) { return processShapesNorms_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic FBXModel_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"id") ) { id=inValue.Cast< int >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"uid") ) { uid=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"geom") ) { geom=inValue.Cast< ::h3d::fbx::Geometry >(); return inValue; }
		if (HX_FIELD_EQ(inName,"skin") ) { skin=inValue.Cast< ::h3d::anim::Skin >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"bounds") ) { bounds=inValue.Cast< ::h3d::col::Bounds >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"tempVert") ) { tempVert=inValue.Cast< Array< Float > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tempNorm") ) { tempNorm=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"isDynamic") ) { isDynamic=inValue.Cast< bool >(); return inValue; }
		if (HX_FIELD_EQ(inName,"geomCache") ) { geomCache=inValue.Cast< ::h3d::prim::FBXBuffers >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"blendShapes") ) { blendShapes=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"curMaterial") ) { curMaterial=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"shapeRatios") ) { if (inCallProp) return set_shapeRatios(inValue);shapeRatios=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"groupIndexes") ) { groupIndexes=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"multiMaterial") ) { multiMaterial=inValue.Cast< bool >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"onVertexBuffer") ) { onVertexBuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"onNormalBuffer") ) { onNormalBuffer=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void FBXModel_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("geom"));
	outFields->push(HX_CSTRING("blendShapes"));
	outFields->push(HX_CSTRING("skin"));
	outFields->push(HX_CSTRING("multiMaterial"));
	outFields->push(HX_CSTRING("bounds"));
	outFields->push(HX_CSTRING("curMaterial"));
	outFields->push(HX_CSTRING("groupIndexes"));
	outFields->push(HX_CSTRING("isDynamic"));
	outFields->push(HX_CSTRING("geomCache"));
	outFields->push(HX_CSTRING("id"));
	outFields->push(HX_CSTRING("shapeRatios"));
	outFields->push(HX_CSTRING("tempVert"));
	outFields->push(HX_CSTRING("tempNorm"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("uid"),
	HX_CSTRING("zero"),
	HX_CSTRING("blit"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::h3d::fbx::Geometry*/ ,(int)offsetof(FBXModel_obj,geom),HX_CSTRING("geom")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(FBXModel_obj,blendShapes),HX_CSTRING("blendShapes")},
	{hx::fsObject /*::h3d::anim::Skin*/ ,(int)offsetof(FBXModel_obj,skin),HX_CSTRING("skin")},
	{hx::fsBool,(int)offsetof(FBXModel_obj,multiMaterial),HX_CSTRING("multiMaterial")},
	{hx::fsObject /*::h3d::col::Bounds*/ ,(int)offsetof(FBXModel_obj,bounds),HX_CSTRING("bounds")},
	{hx::fsInt,(int)offsetof(FBXModel_obj,curMaterial),HX_CSTRING("curMaterial")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(FBXModel_obj,groupIndexes),HX_CSTRING("groupIndexes")},
	{hx::fsBool,(int)offsetof(FBXModel_obj,isDynamic),HX_CSTRING("isDynamic")},
	{hx::fsObject /*::h3d::prim::FBXBuffers*/ ,(int)offsetof(FBXModel_obj,geomCache),HX_CSTRING("geomCache")},
	{hx::fsInt,(int)offsetof(FBXModel_obj,id),HX_CSTRING("id")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXModel_obj,shapeRatios),HX_CSTRING("shapeRatios")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(FBXModel_obj,onVertexBuffer),HX_CSTRING("onVertexBuffer")},
	{hx::fsObject /*Dynamic*/ ,(int)offsetof(FBXModel_obj,onNormalBuffer),HX_CSTRING("onNormalBuffer")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXModel_obj,tempVert),HX_CSTRING("tempVert")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(FBXModel_obj,tempNorm),HX_CSTRING("tempNorm")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("geom"),
	HX_CSTRING("blendShapes"),
	HX_CSTRING("skin"),
	HX_CSTRING("multiMaterial"),
	HX_CSTRING("bounds"),
	HX_CSTRING("curMaterial"),
	HX_CSTRING("groupIndexes"),
	HX_CSTRING("isDynamic"),
	HX_CSTRING("geomCache"),
	HX_CSTRING("id"),
	HX_CSTRING("shapeRatios"),
	HX_CSTRING("onVertexBuffer"),
	HX_CSTRING("onNormalBuffer"),
	HX_CSTRING("getVerticesCount"),
	HX_CSTRING("set_shapeRatios"),
	HX_CSTRING("getBounds"),
	HX_CSTRING("render"),
	HX_CSTRING("selectMaterial"),
	HX_CSTRING("dispose"),
	HX_CSTRING("tempVert"),
	HX_CSTRING("tempNorm"),
	HX_CSTRING("processShapesVerts"),
	HX_CSTRING("norm3"),
	HX_CSTRING("processShapesNorms"),
	HX_CSTRING("alloc"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(FBXModel_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(FBXModel_obj::uid,"uid");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(FBXModel_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(FBXModel_obj::uid,"uid");
};

#endif

Class FBXModel_obj::__mClass;

void FBXModel_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("h3d.prim.FBXModel"), hx::TCanCast< FBXModel_obj> ,sStaticFields,sMemberFields,
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

void FBXModel_obj::__boot()
{
	uid= (int)0;
}

} // end namespace h3d
} // end namespace prim
