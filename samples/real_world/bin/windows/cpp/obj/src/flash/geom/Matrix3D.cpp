#include <hxcpp.h>

#ifndef INCLUDED_flash__Vector_Vector_Impl_
#include <flash/_Vector/Vector_Impl_.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix3D
#include <flash/geom/Matrix3D.h>
#endif
#ifndef INCLUDED_flash_geom_Vector3D
#include <flash/geom/Vector3D.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace flash{
namespace geom{

Void Matrix3D_obj::__construct(Array< Float > v)
{
HX_STACK_FRAME("flash.geom.Matrix3D","new",0xa74ff9f8,"flash.geom.Matrix3D.new","flash/geom/Matrix3D.hx",17,0x1a66ac18)
HX_STACK_THIS(this)
HX_STACK_ARG(v,"v")
{
	HX_STACK_LINE(17)
	if (((bool((v != null())) && bool((v->length == (int)16))))){
		HX_STACK_LINE(19)
		this->rawData = v;
	}
	else{
		HX_STACK_LINE(23)
		this->rawData = Array_obj< Float >::__new().Add(1.0).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(1.0).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(1.0).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(1.0);
	}
}
;
	return null();
}

//Matrix3D_obj::~Matrix3D_obj() { }

Dynamic Matrix3D_obj::__CreateEmpty() { return  new Matrix3D_obj; }
hx::ObjectPtr< Matrix3D_obj > Matrix3D_obj::__new(Array< Float > v)
{  hx::ObjectPtr< Matrix3D_obj > result = new Matrix3D_obj();
	result->__construct(v);
	return result;}

Dynamic Matrix3D_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Matrix3D_obj > result = new Matrix3D_obj();
	result->__construct(inArgs[0]);
	return result;}

Void Matrix3D_obj::append( ::flash::geom::Matrix3D lhs){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","append",0xec8fc742,"flash.geom.Matrix3D.append","flash/geom/Matrix3D.hx",30,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(lhs,"lhs")
		HX_STACK_LINE(32)
		Float m111 = this->rawData->__get((int)0);		HX_STACK_VAR(m111,"m111");
		HX_STACK_LINE(32)
		Float m121 = this->rawData->__get((int)4);		HX_STACK_VAR(m121,"m121");
		HX_STACK_LINE(32)
		Float m131 = this->rawData->__get((int)8);		HX_STACK_VAR(m131,"m131");
		HX_STACK_LINE(32)
		Float m141 = this->rawData->__get((int)12);		HX_STACK_VAR(m141,"m141");
		HX_STACK_LINE(33)
		Float m112 = this->rawData->__get((int)1);		HX_STACK_VAR(m112,"m112");
		HX_STACK_LINE(33)
		Float m122 = this->rawData->__get((int)5);		HX_STACK_VAR(m122,"m122");
		HX_STACK_LINE(33)
		Float m132 = this->rawData->__get((int)9);		HX_STACK_VAR(m132,"m132");
		HX_STACK_LINE(33)
		Float m142 = this->rawData->__get((int)13);		HX_STACK_VAR(m142,"m142");
		HX_STACK_LINE(34)
		Float m113 = this->rawData->__get((int)2);		HX_STACK_VAR(m113,"m113");
		HX_STACK_LINE(34)
		Float m123 = this->rawData->__get((int)6);		HX_STACK_VAR(m123,"m123");
		HX_STACK_LINE(34)
		Float m133 = this->rawData->__get((int)10);		HX_STACK_VAR(m133,"m133");
		HX_STACK_LINE(34)
		Float m143 = this->rawData->__get((int)14);		HX_STACK_VAR(m143,"m143");
		HX_STACK_LINE(35)
		Float m114 = this->rawData->__get((int)3);		HX_STACK_VAR(m114,"m114");
		HX_STACK_LINE(35)
		Float m124 = this->rawData->__get((int)7);		HX_STACK_VAR(m124,"m124");
		HX_STACK_LINE(35)
		Float m134 = this->rawData->__get((int)11);		HX_STACK_VAR(m134,"m134");
		HX_STACK_LINE(35)
		Float m144 = this->rawData->__get((int)15);		HX_STACK_VAR(m144,"m144");
		HX_STACK_LINE(36)
		Float m211 = lhs->rawData->__get((int)0);		HX_STACK_VAR(m211,"m211");
		HX_STACK_LINE(36)
		Float m221 = lhs->rawData->__get((int)4);		HX_STACK_VAR(m221,"m221");
		HX_STACK_LINE(36)
		Float m231 = lhs->rawData->__get((int)8);		HX_STACK_VAR(m231,"m231");
		HX_STACK_LINE(36)
		Float m241 = lhs->rawData->__get((int)12);		HX_STACK_VAR(m241,"m241");
		HX_STACK_LINE(37)
		Float m212 = lhs->rawData->__get((int)1);		HX_STACK_VAR(m212,"m212");
		HX_STACK_LINE(37)
		Float m222 = lhs->rawData->__get((int)5);		HX_STACK_VAR(m222,"m222");
		HX_STACK_LINE(37)
		Float m232 = lhs->rawData->__get((int)9);		HX_STACK_VAR(m232,"m232");
		HX_STACK_LINE(37)
		Float m242 = lhs->rawData->__get((int)13);		HX_STACK_VAR(m242,"m242");
		HX_STACK_LINE(38)
		Float m213 = lhs->rawData->__get((int)2);		HX_STACK_VAR(m213,"m213");
		HX_STACK_LINE(38)
		Float m223 = lhs->rawData->__get((int)6);		HX_STACK_VAR(m223,"m223");
		HX_STACK_LINE(38)
		Float m233 = lhs->rawData->__get((int)10);		HX_STACK_VAR(m233,"m233");
		HX_STACK_LINE(38)
		Float m243 = lhs->rawData->__get((int)14);		HX_STACK_VAR(m243,"m243");
		HX_STACK_LINE(39)
		Float m214 = lhs->rawData->__get((int)3);		HX_STACK_VAR(m214,"m214");
		HX_STACK_LINE(39)
		Float m224 = lhs->rawData->__get((int)7);		HX_STACK_VAR(m224,"m224");
		HX_STACK_LINE(39)
		Float m234 = lhs->rawData->__get((int)11);		HX_STACK_VAR(m234,"m234");
		HX_STACK_LINE(39)
		Float m244 = lhs->rawData->__get((int)15);		HX_STACK_VAR(m244,"m244");
		HX_STACK_LINE(41)
		this->rawData[(int)0] = ((((m111 * m211) + (m112 * m221)) + (m113 * m231)) + (m114 * m241));
		HX_STACK_LINE(42)
		this->rawData[(int)1] = ((((m111 * m212) + (m112 * m222)) + (m113 * m232)) + (m114 * m242));
		HX_STACK_LINE(43)
		this->rawData[(int)2] = ((((m111 * m213) + (m112 * m223)) + (m113 * m233)) + (m114 * m243));
		HX_STACK_LINE(44)
		this->rawData[(int)3] = ((((m111 * m214) + (m112 * m224)) + (m113 * m234)) + (m114 * m244));
		HX_STACK_LINE(46)
		this->rawData[(int)4] = ((((m121 * m211) + (m122 * m221)) + (m123 * m231)) + (m124 * m241));
		HX_STACK_LINE(47)
		this->rawData[(int)5] = ((((m121 * m212) + (m122 * m222)) + (m123 * m232)) + (m124 * m242));
		HX_STACK_LINE(48)
		this->rawData[(int)6] = ((((m121 * m213) + (m122 * m223)) + (m123 * m233)) + (m124 * m243));
		HX_STACK_LINE(49)
		this->rawData[(int)7] = ((((m121 * m214) + (m122 * m224)) + (m123 * m234)) + (m124 * m244));
		HX_STACK_LINE(51)
		this->rawData[(int)8] = ((((m131 * m211) + (m132 * m221)) + (m133 * m231)) + (m134 * m241));
		HX_STACK_LINE(52)
		this->rawData[(int)9] = ((((m131 * m212) + (m132 * m222)) + (m133 * m232)) + (m134 * m242));
		HX_STACK_LINE(53)
		this->rawData[(int)10] = ((((m131 * m213) + (m132 * m223)) + (m133 * m233)) + (m134 * m243));
		HX_STACK_LINE(54)
		this->rawData[(int)11] = ((((m131 * m214) + (m132 * m224)) + (m133 * m234)) + (m134 * m244));
		HX_STACK_LINE(56)
		this->rawData[(int)12] = ((((m141 * m211) + (m142 * m221)) + (m143 * m231)) + (m144 * m241));
		HX_STACK_LINE(57)
		this->rawData[(int)13] = ((((m141 * m212) + (m142 * m222)) + (m143 * m232)) + (m144 * m242));
		HX_STACK_LINE(58)
		this->rawData[(int)14] = ((((m141 * m213) + (m142 * m223)) + (m143 * m233)) + (m144 * m243));
		HX_STACK_LINE(59)
		this->rawData[(int)15] = ((((m141 * m214) + (m142 * m224)) + (m143 * m234)) + (m144 * m244));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,append,(void))

Void Matrix3D_obj::appendRotation( Float degrees,::flash::geom::Vector3D axis,::flash::geom::Vector3D pivotPoint){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","appendRotation",0x80a3d2a0,"flash.geom.Matrix3D.appendRotation","flash/geom/Matrix3D.hx",64,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(degrees,"degrees")
		HX_STACK_ARG(axis,"axis")
		HX_STACK_ARG(pivotPoint,"pivotPoint")
		HX_STACK_LINE(66)
		::flash::geom::Matrix3D m = ::flash::geom::Matrix3D_obj::getAxisRotation(axis->x,axis->y,axis->z,degrees);		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(68)
		if (((pivotPoint != null()))){
			HX_STACK_LINE(70)
			::flash::geom::Vector3D p = pivotPoint;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(71)
			m->appendTranslation(p->x,p->y,p->z);
		}
		HX_STACK_LINE(75)
		this->append(m);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,appendRotation,(void))

Void Matrix3D_obj::appendScale( Float xScale,Float yScale,Float zScale){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","appendScale",0xa168e7e8,"flash.geom.Matrix3D.appendScale","flash/geom/Matrix3D.hx",80,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(xScale,"xScale")
		HX_STACK_ARG(yScale,"yScale")
		HX_STACK_ARG(zScale,"zScale")
		HX_STACK_LINE(82)
		::flash::geom::Matrix3D _g = ::flash::geom::Matrix3D_obj::__new(Array_obj< Float >::__new().Add(xScale).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(yScale).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(zScale).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(1.0));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(82)
		this->append(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,appendScale,(void))

Void Matrix3D_obj::appendTranslation( Float x,Float y,Float z){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","appendTranslation",0x0036a4cf,"flash.geom.Matrix3D.appendTranslation","flash/geom/Matrix3D.hx",87,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(89)
		hx::AddEq(this->rawData[(int)12],x);
		HX_STACK_LINE(90)
		hx::AddEq(this->rawData[(int)13],y);
		HX_STACK_LINE(91)
		hx::AddEq(this->rawData[(int)14],z);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,appendTranslation,(void))

::flash::geom::Matrix3D Matrix3D_obj::clone( ){
	HX_STACK_FRAME("flash.geom.Matrix3D","clone",0xc5eed2f5,"flash.geom.Matrix3D.clone","flash/geom/Matrix3D.hx",96,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_LINE(98)
	Array< Float > _g = ::flash::_Vector::Vector_Impl__obj::copy(this->rawData);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(98)
	return ::flash::geom::Matrix3D_obj::__new(_g);
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix3D_obj,clone,return )

Void Matrix3D_obj::copyColumnFrom( int column,::flash::geom::Vector3D vector3D){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","copyColumnFrom",0xef7124dd,"flash.geom.Matrix3D.copyColumnFrom","flash/geom/Matrix3D.hx",103,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(column,"column")
		HX_STACK_ARG(vector3D,"vector3D")
		HX_STACK_LINE(105)
		if (((column > (int)3))){
			HX_STACK_LINE(107)
			HX_STACK_DO_THROW(((HX_CSTRING("Column ") + column) + HX_CSTRING(" out of bounds (3)")));
		}
		HX_STACK_LINE(111)
		this->rawData[column] = vector3D->x;
		HX_STACK_LINE(112)
		this->rawData[((int)4 + column)] = vector3D->y;
		HX_STACK_LINE(113)
		this->rawData[((int)8 + column)] = vector3D->z;
		HX_STACK_LINE(114)
		this->rawData[((int)12 + column)] = vector3D->w;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix3D_obj,copyColumnFrom,(void))

Void Matrix3D_obj::copyColumnTo( int column,::flash::geom::Vector3D vector3D){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","copyColumnTo",0xa9e4122e,"flash.geom.Matrix3D.copyColumnTo","flash/geom/Matrix3D.hx",119,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(column,"column")
		HX_STACK_ARG(vector3D,"vector3D")
		HX_STACK_LINE(121)
		if (((column > (int)3))){
			HX_STACK_LINE(123)
			HX_STACK_DO_THROW(((HX_CSTRING("Column ") + column) + HX_CSTRING(" out of bounds (3)")));
		}
		HX_STACK_LINE(127)
		vector3D->x = this->rawData->__get(column);
		HX_STACK_LINE(128)
		vector3D->y = this->rawData->__get(((int)4 + column));
		HX_STACK_LINE(129)
		vector3D->z = this->rawData->__get(((int)8 + column));
		HX_STACK_LINE(130)
		vector3D->w = this->rawData->__get(((int)12 + column));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix3D_obj,copyColumnTo,(void))

Void Matrix3D_obj::copyFrom( ::flash::geom::Matrix3D other){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","copyFrom",0xb7ef1b27,"flash.geom.Matrix3D.copyFrom","flash/geom/Matrix3D.hx",137,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(other,"other")
		HX_STACK_LINE(137)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(137)
		while((true)){
			HX_STACK_LINE(137)
			if ((!(((_g < (int)16))))){
				HX_STACK_LINE(137)
				break;
			}
			HX_STACK_LINE(137)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(139)
			this->rawData[i] = other->rawData->__get(i);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,copyFrom,(void))

Void Matrix3D_obj::copyRowFrom( int row,::flash::geom::Vector3D vector3D){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","copyRowFrom",0xdbaec707,"flash.geom.Matrix3D.copyRowFrom","flash/geom/Matrix3D.hx",146,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(row,"row")
		HX_STACK_ARG(vector3D,"vector3D")
		HX_STACK_LINE(148)
		if (((row > (int)3))){
			HX_STACK_LINE(150)
			HX_STACK_DO_THROW(((HX_CSTRING("Row ") + row) + HX_CSTRING(" out of bounds (3)")));
		}
		HX_STACK_LINE(154)
		int i = ((int)4 * row);		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(155)
		this->rawData[i] = vector3D->x;
		HX_STACK_LINE(156)
		this->rawData[(i + (int)1)] = vector3D->y;
		HX_STACK_LINE(157)
		this->rawData[(i + (int)2)] = vector3D->z;
		HX_STACK_LINE(158)
		this->rawData[(i + (int)3)] = vector3D->w;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix3D_obj,copyRowFrom,(void))

Void Matrix3D_obj::copyRowTo( int row,::flash::geom::Vector3D vector3D){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","copyRowTo",0x2021f5d8,"flash.geom.Matrix3D.copyRowTo","flash/geom/Matrix3D.hx",163,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(row,"row")
		HX_STACK_ARG(vector3D,"vector3D")
		HX_STACK_LINE(165)
		if (((row > (int)3))){
			HX_STACK_LINE(167)
			HX_STACK_DO_THROW(((HX_CSTRING("Row ") + row) + HX_CSTRING(" out of bounds (3)")));
		}
		HX_STACK_LINE(171)
		int i = ((int)4 * row);		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(172)
		vector3D->x = this->rawData->__get(i);
		HX_STACK_LINE(173)
		vector3D->y = this->rawData->__get((i + (int)1));
		HX_STACK_LINE(174)
		vector3D->z = this->rawData->__get((i + (int)2));
		HX_STACK_LINE(175)
		vector3D->w = this->rawData->__get((i + (int)3));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix3D_obj,copyRowTo,(void))

Void Matrix3D_obj::copyToMatrix3D( ::flash::geom::Matrix3D other){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","copyToMatrix3D",0xb8daab4a,"flash.geom.Matrix3D.copyToMatrix3D","flash/geom/Matrix3D.hx",182,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(other,"other")
		HX_STACK_LINE(182)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(182)
		while((true)){
			HX_STACK_LINE(182)
			if ((!(((_g < (int)16))))){
				HX_STACK_LINE(182)
				break;
			}
			HX_STACK_LINE(182)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(184)
			other->rawData[i] = this->rawData->__get(i);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,copyToMatrix3D,(void))

Array< ::Dynamic > Matrix3D_obj::decompose( ){
	HX_STACK_FRAME("flash.geom.Matrix3D","decompose",0x27672f49,"flash.geom.Matrix3D.decompose","flash/geom/Matrix3D.hx",235,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_LINE(237)
	Array< ::Dynamic > vec = ::flash::_Vector::Vector_Impl__obj::_new(null(),null());		HX_STACK_VAR(vec,"vec");
	HX_STACK_LINE(238)
	::flash::geom::Matrix3D m = this->clone();		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(239)
	Array< Float > mr = m->rawData;		HX_STACK_VAR(mr,"mr");
	HX_STACK_LINE(241)
	::flash::geom::Vector3D pos = ::flash::geom::Vector3D_obj::__new(mr->__get((int)12),mr->__get((int)13),mr->__get((int)14),null());		HX_STACK_VAR(pos,"pos");
	HX_STACK_LINE(242)
	mr[(int)12] = (int)0;
	HX_STACK_LINE(243)
	mr[(int)13] = (int)0;
	HX_STACK_LINE(244)
	mr[(int)14] = (int)0;
	HX_STACK_LINE(246)
	::flash::geom::Vector3D scale = ::flash::geom::Vector3D_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(scale,"scale");
	HX_STACK_LINE(248)
	Float _g = ::Math_obj::sqrt((((mr->__get((int)0) * mr->__get((int)0)) + (mr->__get((int)1) * mr->__get((int)1))) + (mr->__get((int)2) * mr->__get((int)2))));		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(248)
	scale->x = _g;
	HX_STACK_LINE(249)
	Float _g1 = ::Math_obj::sqrt((((mr->__get((int)4) * mr->__get((int)4)) + (mr->__get((int)5) * mr->__get((int)5))) + (mr->__get((int)6) * mr->__get((int)6))));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(249)
	scale->y = _g1;
	HX_STACK_LINE(250)
	Float _g2 = ::Math_obj::sqrt((((mr->__get((int)8) * mr->__get((int)8)) + (mr->__get((int)9) * mr->__get((int)9))) + (mr->__get((int)10) * mr->__get((int)10))));		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(250)
	scale->z = _g2;
	HX_STACK_LINE(252)
	if ((((((mr->__get((int)0) * (((mr->__get((int)5) * mr->__get((int)10)) - (mr->__get((int)6) * mr->__get((int)9))))) - (mr->__get((int)1) * (((mr->__get((int)4) * mr->__get((int)10)) - (mr->__get((int)6) * mr->__get((int)8)))))) + (mr->__get((int)2) * (((mr->__get((int)4) * mr->__get((int)9)) - (mr->__get((int)5) * mr->__get((int)8)))))) < (int)0))){
		HX_STACK_LINE(254)
		scale->z = -(scale->z);
	}
	HX_STACK_LINE(258)
	hx::DivEq(mr[(int)0],scale->x);
	HX_STACK_LINE(259)
	hx::DivEq(mr[(int)1],scale->x);
	HX_STACK_LINE(260)
	hx::DivEq(mr[(int)2],scale->x);
	HX_STACK_LINE(261)
	hx::DivEq(mr[(int)4],scale->y);
	HX_STACK_LINE(262)
	hx::DivEq(mr[(int)5],scale->y);
	HX_STACK_LINE(263)
	hx::DivEq(mr[(int)6],scale->y);
	HX_STACK_LINE(264)
	hx::DivEq(mr[(int)8],scale->z);
	HX_STACK_LINE(265)
	hx::DivEq(mr[(int)9],scale->z);
	HX_STACK_LINE(266)
	hx::DivEq(mr[(int)10],scale->z);
	HX_STACK_LINE(268)
	::flash::geom::Vector3D rot = ::flash::geom::Vector3D_obj::__new(null(),null(),null(),null());		HX_STACK_VAR(rot,"rot");
	HX_STACK_LINE(269)
	Float _g3 = ::Math_obj::asin(-(mr->__get((int)2)));		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(269)
	rot->y = _g3;
	HX_STACK_LINE(270)
	Float C = ::Math_obj::cos(rot->y);		HX_STACK_VAR(C,"C");
	HX_STACK_LINE(272)
	if (((C > (int)0))){
		HX_STACK_LINE(274)
		Float _g4 = ::Math_obj::atan2(mr->__get((int)6),mr->__get((int)10));		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(274)
		rot->x = _g4;
		HX_STACK_LINE(275)
		Float _g5 = ::Math_obj::atan2(mr->__get((int)1),mr->__get((int)0));		HX_STACK_VAR(_g5,"_g5");
		HX_STACK_LINE(275)
		rot->z = _g5;
	}
	else{
		HX_STACK_LINE(279)
		rot->z = (int)0;
		HX_STACK_LINE(280)
		Float _g6 = ::Math_obj::atan2(mr->__get((int)4),mr->__get((int)5));		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(280)
		rot->x = _g6;
	}
	HX_STACK_LINE(284)
	vec->push(pos);
	HX_STACK_LINE(285)
	vec->push(rot);
	HX_STACK_LINE(286)
	vec->push(scale);
	HX_STACK_LINE(288)
	return vec;
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix3D_obj,decompose,return )

::flash::geom::Vector3D Matrix3D_obj::deltaTransformVector( ::flash::geom::Vector3D v){
	HX_STACK_FRAME("flash.geom.Matrix3D","deltaTransformVector",0x6cb78d9f,"flash.geom.Matrix3D.deltaTransformVector","flash/geom/Matrix3D.hx",293,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(295)
	Float x = v->x;		HX_STACK_VAR(x,"x");
	HX_STACK_LINE(295)
	Float y = v->y;		HX_STACK_VAR(y,"y");
	HX_STACK_LINE(295)
	Float z = v->z;		HX_STACK_VAR(z,"z");
	HX_STACK_LINE(297)
	return ::flash::geom::Vector3D_obj::__new(((((x * this->rawData->__get((int)0)) + (y * this->rawData->__get((int)1))) + (z * this->rawData->__get((int)2))) + this->rawData->__get((int)3)),((((x * this->rawData->__get((int)4)) + (y * this->rawData->__get((int)5))) + (z * this->rawData->__get((int)6))) + this->rawData->__get((int)7)),((((x * this->rawData->__get((int)8)) + (y * this->rawData->__get((int)9))) + (z * this->rawData->__get((int)10))) + this->rawData->__get((int)11)),(int)0);
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,deltaTransformVector,return )

Void Matrix3D_obj::identity( ){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","identity",0xa8bd54a6,"flash.geom.Matrix3D.identity","flash/geom/Matrix3D.hx",338,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_LINE(340)
		this->rawData[(int)0] = (int)1;
		HX_STACK_LINE(341)
		this->rawData[(int)1] = (int)0;
		HX_STACK_LINE(342)
		this->rawData[(int)2] = (int)0;
		HX_STACK_LINE(343)
		this->rawData[(int)3] = (int)0;
		HX_STACK_LINE(344)
		this->rawData[(int)4] = (int)0;
		HX_STACK_LINE(345)
		this->rawData[(int)5] = (int)1;
		HX_STACK_LINE(346)
		this->rawData[(int)6] = (int)0;
		HX_STACK_LINE(347)
		this->rawData[(int)7] = (int)0;
		HX_STACK_LINE(348)
		this->rawData[(int)8] = (int)0;
		HX_STACK_LINE(349)
		this->rawData[(int)9] = (int)0;
		HX_STACK_LINE(350)
		this->rawData[(int)10] = (int)1;
		HX_STACK_LINE(351)
		this->rawData[(int)11] = (int)0;
		HX_STACK_LINE(352)
		this->rawData[(int)12] = (int)0;
		HX_STACK_LINE(353)
		this->rawData[(int)13] = (int)0;
		HX_STACK_LINE(354)
		this->rawData[(int)14] = (int)0;
		HX_STACK_LINE(355)
		this->rawData[(int)15] = (int)1;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix3D_obj,identity,(void))

Void Matrix3D_obj::interpolateTo( ::flash::geom::Matrix3D toMat,Float percent){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","interpolateTo",0x4e5ba834,"flash.geom.Matrix3D.interpolateTo","flash/geom/Matrix3D.hx",377,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(toMat,"toMat")
		HX_STACK_ARG(percent,"percent")
		HX_STACK_LINE(377)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(377)
		while((true)){
			HX_STACK_LINE(377)
			if ((!(((_g < (int)16))))){
				HX_STACK_LINE(377)
				break;
			}
			HX_STACK_LINE(377)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(379)
			this->rawData[i] = (this->rawData->__get(i) + (((toMat->rawData->__get(i) - this->rawData->__get(i))) * percent));
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix3D_obj,interpolateTo,(void))

bool Matrix3D_obj::invert( ){
	HX_STACK_FRAME("flash.geom.Matrix3D","invert",0xfc94cc7e,"flash.geom.Matrix3D.invert","flash/geom/Matrix3D.hx",386,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_LINE(388)
	Float d = this->get_determinant();		HX_STACK_VAR(d,"d");
	HX_STACK_LINE(389)
	Float _g = ::Math_obj::abs(d);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(389)
	bool invertable = (_g > 0.00000000001);		HX_STACK_VAR(invertable,"invertable");
	HX_STACK_LINE(391)
	if ((invertable)){
		HX_STACK_LINE(393)
		d = (Float((int)-1) / Float(d));
		HX_STACK_LINE(394)
		Float m11 = this->rawData->__get((int)0);		HX_STACK_VAR(m11,"m11");
		HX_STACK_LINE(394)
		Float m21 = this->rawData->__get((int)4);		HX_STACK_VAR(m21,"m21");
		HX_STACK_LINE(394)
		Float m31 = this->rawData->__get((int)8);		HX_STACK_VAR(m31,"m31");
		HX_STACK_LINE(394)
		Float m41 = this->rawData->__get((int)12);		HX_STACK_VAR(m41,"m41");
		HX_STACK_LINE(395)
		Float m12 = this->rawData->__get((int)1);		HX_STACK_VAR(m12,"m12");
		HX_STACK_LINE(395)
		Float m22 = this->rawData->__get((int)5);		HX_STACK_VAR(m22,"m22");
		HX_STACK_LINE(395)
		Float m32 = this->rawData->__get((int)9);		HX_STACK_VAR(m32,"m32");
		HX_STACK_LINE(395)
		Float m42 = this->rawData->__get((int)13);		HX_STACK_VAR(m42,"m42");
		HX_STACK_LINE(396)
		Float m13 = this->rawData->__get((int)2);		HX_STACK_VAR(m13,"m13");
		HX_STACK_LINE(396)
		Float m23 = this->rawData->__get((int)6);		HX_STACK_VAR(m23,"m23");
		HX_STACK_LINE(396)
		Float m33 = this->rawData->__get((int)10);		HX_STACK_VAR(m33,"m33");
		HX_STACK_LINE(396)
		Float m43 = this->rawData->__get((int)14);		HX_STACK_VAR(m43,"m43");
		HX_STACK_LINE(397)
		Float m14 = this->rawData->__get((int)3);		HX_STACK_VAR(m14,"m14");
		HX_STACK_LINE(397)
		Float m24 = this->rawData->__get((int)7);		HX_STACK_VAR(m24,"m24");
		HX_STACK_LINE(397)
		Float m34 = this->rawData->__get((int)11);		HX_STACK_VAR(m34,"m34");
		HX_STACK_LINE(397)
		Float m44 = this->rawData->__get((int)15);		HX_STACK_VAR(m44,"m44");
		HX_STACK_LINE(399)
		this->rawData[(int)0] = (d * ((((m22 * (((m33 * m44) - (m43 * m34)))) - (m32 * (((m23 * m44) - (m43 * m24))))) + (m42 * (((m23 * m34) - (m33 * m24)))))));
		HX_STACK_LINE(400)
		this->rawData[(int)1] = (-(d) * ((((m12 * (((m33 * m44) - (m43 * m34)))) - (m32 * (((m13 * m44) - (m43 * m14))))) + (m42 * (((m13 * m34) - (m33 * m14)))))));
		HX_STACK_LINE(401)
		this->rawData[(int)2] = (d * ((((m12 * (((m23 * m44) - (m43 * m24)))) - (m22 * (((m13 * m44) - (m43 * m14))))) + (m42 * (((m13 * m24) - (m23 * m14)))))));
		HX_STACK_LINE(402)
		this->rawData[(int)3] = (-(d) * ((((m12 * (((m23 * m34) - (m33 * m24)))) - (m22 * (((m13 * m34) - (m33 * m14))))) + (m32 * (((m13 * m24) - (m23 * m14)))))));
		HX_STACK_LINE(403)
		this->rawData[(int)4] = (-(d) * ((((m21 * (((m33 * m44) - (m43 * m34)))) - (m31 * (((m23 * m44) - (m43 * m24))))) + (m41 * (((m23 * m34) - (m33 * m24)))))));
		HX_STACK_LINE(404)
		this->rawData[(int)5] = (d * ((((m11 * (((m33 * m44) - (m43 * m34)))) - (m31 * (((m13 * m44) - (m43 * m14))))) + (m41 * (((m13 * m34) - (m33 * m14)))))));
		HX_STACK_LINE(405)
		this->rawData[(int)6] = (-(d) * ((((m11 * (((m23 * m44) - (m43 * m24)))) - (m21 * (((m13 * m44) - (m43 * m14))))) + (m41 * (((m13 * m24) - (m23 * m14)))))));
		HX_STACK_LINE(406)
		this->rawData[(int)7] = (d * ((((m11 * (((m23 * m34) - (m33 * m24)))) - (m21 * (((m13 * m34) - (m33 * m14))))) + (m31 * (((m13 * m24) - (m23 * m14)))))));
		HX_STACK_LINE(407)
		this->rawData[(int)8] = (d * ((((m21 * (((m32 * m44) - (m42 * m34)))) - (m31 * (((m22 * m44) - (m42 * m24))))) + (m41 * (((m22 * m34) - (m32 * m24)))))));
		HX_STACK_LINE(408)
		this->rawData[(int)9] = (-(d) * ((((m11 * (((m32 * m44) - (m42 * m34)))) - (m31 * (((m12 * m44) - (m42 * m14))))) + (m41 * (((m12 * m34) - (m32 * m14)))))));
		HX_STACK_LINE(409)
		this->rawData[(int)10] = (d * ((((m11 * (((m22 * m44) - (m42 * m24)))) - (m21 * (((m12 * m44) - (m42 * m14))))) + (m41 * (((m12 * m24) - (m22 * m14)))))));
		HX_STACK_LINE(410)
		this->rawData[(int)11] = (-(d) * ((((m11 * (((m22 * m34) - (m32 * m24)))) - (m21 * (((m12 * m34) - (m32 * m14))))) + (m31 * (((m12 * m24) - (m22 * m14)))))));
		HX_STACK_LINE(411)
		this->rawData[(int)12] = (-(d) * ((((m21 * (((m32 * m43) - (m42 * m33)))) - (m31 * (((m22 * m43) - (m42 * m23))))) + (m41 * (((m22 * m33) - (m32 * m23)))))));
		HX_STACK_LINE(412)
		this->rawData[(int)13] = (d * ((((m11 * (((m32 * m43) - (m42 * m33)))) - (m31 * (((m12 * m43) - (m42 * m13))))) + (m41 * (((m12 * m33) - (m32 * m13)))))));
		HX_STACK_LINE(413)
		this->rawData[(int)14] = (-(d) * ((((m11 * (((m22 * m43) - (m42 * m23)))) - (m21 * (((m12 * m43) - (m42 * m13))))) + (m41 * (((m12 * m23) - (m22 * m13)))))));
		HX_STACK_LINE(414)
		this->rawData[(int)15] = (d * ((((m11 * (((m22 * m33) - (m32 * m23)))) - (m21 * (((m12 * m33) - (m32 * m13))))) + (m31 * (((m12 * m23) - (m22 * m13)))))));
	}
	HX_STACK_LINE(418)
	return invertable;
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix3D_obj,invert,return )

Void Matrix3D_obj::pointAt( ::flash::geom::Vector3D pos,::flash::geom::Vector3D at,::flash::geom::Vector3D up){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","pointAt",0x18ce76fb,"flash.geom.Matrix3D.pointAt","flash/geom/Matrix3D.hx",423,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(pos,"pos")
		HX_STACK_ARG(at,"at")
		HX_STACK_ARG(up,"up")
		HX_STACK_LINE(425)
		if (((at == null()))){
			HX_STACK_LINE(427)
			::flash::geom::Vector3D _g = ::flash::geom::Vector3D_obj::__new((int)0,(int)0,(int)-1,null());		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(427)
			at = _g;
		}
		HX_STACK_LINE(431)
		if (((up == null()))){
			HX_STACK_LINE(433)
			::flash::geom::Vector3D _g1 = ::flash::geom::Vector3D_obj::__new((int)0,(int)-1,(int)0,null());		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(433)
			up = _g1;
		}
		HX_STACK_LINE(437)
		::flash::geom::Vector3D dir = ::flash::geom::Vector3D_obj::__new((at->x - pos->x),(at->y - pos->y),(at->z - pos->z),null());		HX_STACK_VAR(dir,"dir");
		HX_STACK_LINE(438)
		::flash::geom::Vector3D vup = ::flash::geom::Vector3D_obj::__new(up->x,up->y,up->z,up->w);		HX_STACK_VAR(vup,"vup");
		HX_STACK_LINE(439)
		::flash::geom::Vector3D right;		HX_STACK_VAR(right,"right");
		HX_STACK_LINE(441)
		{
			HX_STACK_LINE(441)
			Float l = ::Math_obj::sqrt((((dir->x * dir->x) + (dir->y * dir->y)) + (dir->z * dir->z)));		HX_STACK_VAR(l,"l");
			HX_STACK_LINE(441)
			if (((l != (int)0))){
				HX_STACK_LINE(441)
				hx::DivEq(dir->x,l);
				HX_STACK_LINE(441)
				hx::DivEq(dir->y,l);
				HX_STACK_LINE(441)
				hx::DivEq(dir->z,l);
			}
			HX_STACK_LINE(441)
			l;
		}
		HX_STACK_LINE(442)
		{
			HX_STACK_LINE(442)
			Float l = ::Math_obj::sqrt((((vup->x * vup->x) + (vup->y * vup->y)) + (vup->z * vup->z)));		HX_STACK_VAR(l,"l");
			HX_STACK_LINE(442)
			if (((l != (int)0))){
				HX_STACK_LINE(442)
				hx::DivEq(vup->x,l);
				HX_STACK_LINE(442)
				hx::DivEq(vup->y,l);
				HX_STACK_LINE(442)
				hx::DivEq(vup->z,l);
			}
			HX_STACK_LINE(442)
			l;
		}
		HX_STACK_LINE(444)
		::flash::geom::Vector3D dir2 = ::flash::geom::Vector3D_obj::__new(dir->x,dir->y,dir->z,dir->w);		HX_STACK_VAR(dir2,"dir2");
		HX_STACK_LINE(445)
		{
			HX_STACK_LINE(445)
			Float s = (((vup->x * dir->x) + (vup->y * dir->y)) + (vup->z * dir->z));		HX_STACK_VAR(s,"s");
			HX_STACK_LINE(445)
			hx::MultEq(dir2->x,s);
			HX_STACK_LINE(445)
			hx::MultEq(dir2->y,s);
			HX_STACK_LINE(445)
			hx::MultEq(dir2->z,s);
		}
		HX_STACK_LINE(447)
		::flash::geom::Vector3D _g2 = ::flash::geom::Vector3D_obj::__new((vup->x - dir2->x),(vup->y - dir2->y),(vup->z - dir2->z),null());		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(447)
		vup = _g2;
		HX_STACK_LINE(449)
		Float _g3 = ::Math_obj::sqrt((((vup->x * vup->x) + (vup->y * vup->y)) + (vup->z * vup->z)));		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(449)
		if (((_g3 > (int)0))){
			HX_STACK_LINE(451)
			Float l = ::Math_obj::sqrt((((vup->x * vup->x) + (vup->y * vup->y)) + (vup->z * vup->z)));		HX_STACK_VAR(l,"l");
			HX_STACK_LINE(451)
			if (((l != (int)0))){
				HX_STACK_LINE(451)
				hx::DivEq(vup->x,l);
				HX_STACK_LINE(451)
				hx::DivEq(vup->y,l);
				HX_STACK_LINE(451)
				hx::DivEq(vup->z,l);
			}
			HX_STACK_LINE(451)
			l;
		}
		else{
			HX_STACK_LINE(455)
			if (((dir->x != (int)0))){
				HX_STACK_LINE(457)
				::flash::geom::Vector3D _g4 = ::flash::geom::Vector3D_obj::__new(-(dir->y),dir->x,(int)0,null());		HX_STACK_VAR(_g4,"_g4");
				HX_STACK_LINE(457)
				vup = _g4;
			}
			else{
				HX_STACK_LINE(461)
				::flash::geom::Vector3D _g5 = ::flash::geom::Vector3D_obj::__new((int)1,(int)0,(int)0,null());		HX_STACK_VAR(_g5,"_g5");
				HX_STACK_LINE(461)
				vup = _g5;
			}
		}
		HX_STACK_LINE(467)
		::flash::geom::Vector3D _g6 = ::flash::geom::Vector3D_obj::__new(((vup->y * dir->z) - (vup->z * dir->y)),((vup->z * dir->x) - (vup->x * dir->z)),((vup->x * dir->y) - (vup->y * dir->x)),(int)1);		HX_STACK_VAR(_g6,"_g6");
		HX_STACK_LINE(467)
		right = _g6;
		HX_STACK_LINE(468)
		{
			HX_STACK_LINE(468)
			Float l = ::Math_obj::sqrt((((right->x * right->x) + (right->y * right->y)) + (right->z * right->z)));		HX_STACK_VAR(l,"l");
			HX_STACK_LINE(468)
			if (((l != (int)0))){
				HX_STACK_LINE(468)
				hx::DivEq(right->x,l);
				HX_STACK_LINE(468)
				hx::DivEq(right->y,l);
				HX_STACK_LINE(468)
				hx::DivEq(right->z,l);
			}
			HX_STACK_LINE(468)
			l;
		}
		HX_STACK_LINE(470)
		this->rawData[(int)0] = right->x;
		HX_STACK_LINE(471)
		this->rawData[(int)4] = right->y;
		HX_STACK_LINE(472)
		this->rawData[(int)8] = right->z;
		HX_STACK_LINE(473)
		this->rawData[(int)12] = 0.0;
		HX_STACK_LINE(474)
		this->rawData[(int)1] = vup->x;
		HX_STACK_LINE(475)
		this->rawData[(int)5] = vup->y;
		HX_STACK_LINE(476)
		this->rawData[(int)9] = vup->z;
		HX_STACK_LINE(477)
		this->rawData[(int)13] = 0.0;
		HX_STACK_LINE(478)
		this->rawData[(int)2] = dir->x;
		HX_STACK_LINE(479)
		this->rawData[(int)6] = dir->y;
		HX_STACK_LINE(480)
		this->rawData[(int)10] = dir->z;
		HX_STACK_LINE(481)
		this->rawData[(int)14] = 0.0;
		HX_STACK_LINE(482)
		this->rawData[(int)3] = pos->x;
		HX_STACK_LINE(483)
		this->rawData[(int)7] = pos->y;
		HX_STACK_LINE(484)
		this->rawData[(int)11] = pos->z;
		HX_STACK_LINE(485)
		this->rawData[(int)15] = 1.0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,pointAt,(void))

Void Matrix3D_obj::prepend( ::flash::geom::Matrix3D rhs){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","prepend",0xff8d6ca6,"flash.geom.Matrix3D.prepend","flash/geom/Matrix3D.hx",490,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(rhs,"rhs")
		HX_STACK_LINE(492)
		Float m111 = rhs->rawData->__get((int)0);		HX_STACK_VAR(m111,"m111");
		HX_STACK_LINE(492)
		Float m121 = rhs->rawData->__get((int)4);		HX_STACK_VAR(m121,"m121");
		HX_STACK_LINE(492)
		Float m131 = rhs->rawData->__get((int)8);		HX_STACK_VAR(m131,"m131");
		HX_STACK_LINE(492)
		Float m141 = rhs->rawData->__get((int)12);		HX_STACK_VAR(m141,"m141");
		HX_STACK_LINE(493)
		Float m112 = rhs->rawData->__get((int)1);		HX_STACK_VAR(m112,"m112");
		HX_STACK_LINE(493)
		Float m122 = rhs->rawData->__get((int)5);		HX_STACK_VAR(m122,"m122");
		HX_STACK_LINE(493)
		Float m132 = rhs->rawData->__get((int)9);		HX_STACK_VAR(m132,"m132");
		HX_STACK_LINE(493)
		Float m142 = rhs->rawData->__get((int)13);		HX_STACK_VAR(m142,"m142");
		HX_STACK_LINE(494)
		Float m113 = rhs->rawData->__get((int)2);		HX_STACK_VAR(m113,"m113");
		HX_STACK_LINE(494)
		Float m123 = rhs->rawData->__get((int)6);		HX_STACK_VAR(m123,"m123");
		HX_STACK_LINE(494)
		Float m133 = rhs->rawData->__get((int)10);		HX_STACK_VAR(m133,"m133");
		HX_STACK_LINE(494)
		Float m143 = rhs->rawData->__get((int)14);		HX_STACK_VAR(m143,"m143");
		HX_STACK_LINE(495)
		Float m114 = rhs->rawData->__get((int)3);		HX_STACK_VAR(m114,"m114");
		HX_STACK_LINE(495)
		Float m124 = rhs->rawData->__get((int)7);		HX_STACK_VAR(m124,"m124");
		HX_STACK_LINE(495)
		Float m134 = rhs->rawData->__get((int)11);		HX_STACK_VAR(m134,"m134");
		HX_STACK_LINE(495)
		Float m144 = rhs->rawData->__get((int)15);		HX_STACK_VAR(m144,"m144");
		HX_STACK_LINE(496)
		Float m211 = this->rawData->__get((int)0);		HX_STACK_VAR(m211,"m211");
		HX_STACK_LINE(496)
		Float m221 = this->rawData->__get((int)4);		HX_STACK_VAR(m221,"m221");
		HX_STACK_LINE(496)
		Float m231 = this->rawData->__get((int)8);		HX_STACK_VAR(m231,"m231");
		HX_STACK_LINE(496)
		Float m241 = this->rawData->__get((int)12);		HX_STACK_VAR(m241,"m241");
		HX_STACK_LINE(497)
		Float m212 = this->rawData->__get((int)1);		HX_STACK_VAR(m212,"m212");
		HX_STACK_LINE(497)
		Float m222 = this->rawData->__get((int)5);		HX_STACK_VAR(m222,"m222");
		HX_STACK_LINE(497)
		Float m232 = this->rawData->__get((int)9);		HX_STACK_VAR(m232,"m232");
		HX_STACK_LINE(497)
		Float m242 = this->rawData->__get((int)13);		HX_STACK_VAR(m242,"m242");
		HX_STACK_LINE(498)
		Float m213 = this->rawData->__get((int)2);		HX_STACK_VAR(m213,"m213");
		HX_STACK_LINE(498)
		Float m223 = this->rawData->__get((int)6);		HX_STACK_VAR(m223,"m223");
		HX_STACK_LINE(498)
		Float m233 = this->rawData->__get((int)10);		HX_STACK_VAR(m233,"m233");
		HX_STACK_LINE(498)
		Float m243 = this->rawData->__get((int)14);		HX_STACK_VAR(m243,"m243");
		HX_STACK_LINE(499)
		Float m214 = this->rawData->__get((int)3);		HX_STACK_VAR(m214,"m214");
		HX_STACK_LINE(499)
		Float m224 = this->rawData->__get((int)7);		HX_STACK_VAR(m224,"m224");
		HX_STACK_LINE(499)
		Float m234 = this->rawData->__get((int)11);		HX_STACK_VAR(m234,"m234");
		HX_STACK_LINE(499)
		Float m244 = this->rawData->__get((int)15);		HX_STACK_VAR(m244,"m244");
		HX_STACK_LINE(501)
		this->rawData[(int)0] = ((((m111 * m211) + (m112 * m221)) + (m113 * m231)) + (m114 * m241));
		HX_STACK_LINE(502)
		this->rawData[(int)1] = ((((m111 * m212) + (m112 * m222)) + (m113 * m232)) + (m114 * m242));
		HX_STACK_LINE(503)
		this->rawData[(int)2] = ((((m111 * m213) + (m112 * m223)) + (m113 * m233)) + (m114 * m243));
		HX_STACK_LINE(504)
		this->rawData[(int)3] = ((((m111 * m214) + (m112 * m224)) + (m113 * m234)) + (m114 * m244));
		HX_STACK_LINE(506)
		this->rawData[(int)4] = ((((m121 * m211) + (m122 * m221)) + (m123 * m231)) + (m124 * m241));
		HX_STACK_LINE(507)
		this->rawData[(int)5] = ((((m121 * m212) + (m122 * m222)) + (m123 * m232)) + (m124 * m242));
		HX_STACK_LINE(508)
		this->rawData[(int)6] = ((((m121 * m213) + (m122 * m223)) + (m123 * m233)) + (m124 * m243));
		HX_STACK_LINE(509)
		this->rawData[(int)7] = ((((m121 * m214) + (m122 * m224)) + (m123 * m234)) + (m124 * m244));
		HX_STACK_LINE(511)
		this->rawData[(int)8] = ((((m131 * m211) + (m132 * m221)) + (m133 * m231)) + (m134 * m241));
		HX_STACK_LINE(512)
		this->rawData[(int)9] = ((((m131 * m212) + (m132 * m222)) + (m133 * m232)) + (m134 * m242));
		HX_STACK_LINE(513)
		this->rawData[(int)10] = ((((m131 * m213) + (m132 * m223)) + (m133 * m233)) + (m134 * m243));
		HX_STACK_LINE(514)
		this->rawData[(int)11] = ((((m131 * m214) + (m132 * m224)) + (m133 * m234)) + (m134 * m244));
		HX_STACK_LINE(516)
		this->rawData[(int)12] = ((((m141 * m211) + (m142 * m221)) + (m143 * m231)) + (m144 * m241));
		HX_STACK_LINE(517)
		this->rawData[(int)13] = ((((m141 * m212) + (m142 * m222)) + (m143 * m232)) + (m144 * m242));
		HX_STACK_LINE(518)
		this->rawData[(int)14] = ((((m141 * m213) + (m142 * m223)) + (m143 * m233)) + (m144 * m243));
		HX_STACK_LINE(519)
		this->rawData[(int)15] = ((((m141 * m214) + (m142 * m224)) + (m143 * m234)) + (m144 * m244));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,prepend,(void))

Void Matrix3D_obj::prependRotation( Float degrees,::flash::geom::Vector3D axis,::flash::geom::Vector3D pivotPoint){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","prependRotation",0x579b7c04,"flash.geom.Matrix3D.prependRotation","flash/geom/Matrix3D.hx",524,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(degrees,"degrees")
		HX_STACK_ARG(axis,"axis")
		HX_STACK_ARG(pivotPoint,"pivotPoint")
		HX_STACK_LINE(526)
		::flash::geom::Matrix3D m = ::flash::geom::Matrix3D_obj::getAxisRotation(axis->x,axis->y,axis->z,degrees);		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(528)
		if (((pivotPoint != null()))){
			HX_STACK_LINE(530)
			::flash::geom::Vector3D p = pivotPoint;		HX_STACK_VAR(p,"p");
			HX_STACK_LINE(531)
			m->appendTranslation(p->x,p->y,p->z);
		}
		HX_STACK_LINE(535)
		this->prepend(m);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,prependRotation,(void))

Void Matrix3D_obj::prependScale( Float xScale,Float yScale,Float zScale){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","prependScale",0x77853804,"flash.geom.Matrix3D.prependScale","flash/geom/Matrix3D.hx",540,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(xScale,"xScale")
		HX_STACK_ARG(yScale,"yScale")
		HX_STACK_ARG(zScale,"zScale")
		HX_STACK_LINE(542)
		::flash::geom::Matrix3D _g = ::flash::geom::Matrix3D_obj::__new(Array_obj< Float >::__new().Add(xScale).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(yScale).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(zScale).Add(0.0).Add(0.0).Add(0.0).Add(0.0).Add(1.0));		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(542)
		this->prepend(_g);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,prependScale,(void))

Void Matrix3D_obj::prependTranslation( Float x,Float y,Float z){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","prependTranslation",0x94c7f1eb,"flash.geom.Matrix3D.prependTranslation","flash/geom/Matrix3D.hx",547,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(549)
		::flash::geom::Matrix3D m = ::flash::geom::Matrix3D_obj::__new(null());		HX_STACK_VAR(m,"m");
		HX_STACK_LINE(550)
		::flash::geom::Vector3D _g = ::flash::geom::Vector3D_obj::__new(x,y,z,null());		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(550)
		m->set_position(_g);
		HX_STACK_LINE(551)
		this->prepend(m);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,prependTranslation,(void))

bool Matrix3D_obj::recompose( Array< ::Dynamic > components){
	HX_STACK_FRAME("flash.geom.Matrix3D","recompose",0xb09aed57,"flash.geom.Matrix3D.recompose","flash/geom/Matrix3D.hx",556,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_ARG(components,"components")
	HX_STACK_LINE(558)
	if (((bool((bool((bool((components->length < (int)3)) || bool((components->__get((int)2).StaticCast< ::flash::geom::Vector3D >()->x == (int)0)))) || bool((components->__get((int)2).StaticCast< ::flash::geom::Vector3D >()->y == (int)0)))) || bool((components->__get((int)2).StaticCast< ::flash::geom::Vector3D >()->z == (int)0))))){
		HX_STACK_LINE(558)
		return false;
	}
	HX_STACK_LINE(560)
	this->identity();
	HX_STACK_LINE(561)
	this->appendScale(components->__get((int)2).StaticCast< ::flash::geom::Vector3D >()->x,components->__get((int)2).StaticCast< ::flash::geom::Vector3D >()->y,components->__get((int)2).StaticCast< ::flash::geom::Vector3D >()->z);
	HX_STACK_LINE(563)
	Float angle;		HX_STACK_VAR(angle,"angle");
	HX_STACK_LINE(564)
	angle = -(components->__get((int)1).StaticCast< ::flash::geom::Vector3D >()->x);
	HX_STACK_LINE(565)
	Float _g = ::Math_obj::cos(angle);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(565)
	Float _g1 = -(::Math_obj::sin(angle));		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(565)
	Float _g2 = ::Math_obj::sin(angle);		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(565)
	Float _g3 = ::Math_obj::cos(angle);		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(565)
	Array< Float > _g4 = Array_obj< Float >::__new().Add((int)1).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add(_g).Add(_g1).Add((int)0).Add((int)0).Add(_g2).Add(_g3).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((int)0);		HX_STACK_VAR(_g4,"_g4");
	HX_STACK_LINE(565)
	::flash::geom::Matrix3D _g5 = ::flash::geom::Matrix3D_obj::__new(_g4);		HX_STACK_VAR(_g5,"_g5");
	HX_STACK_LINE(565)
	this->append(_g5);
	HX_STACK_LINE(566)
	angle = -(components->__get((int)1).StaticCast< ::flash::geom::Vector3D >()->y);
	HX_STACK_LINE(567)
	Float _g6 = ::Math_obj::cos(angle);		HX_STACK_VAR(_g6,"_g6");
	HX_STACK_LINE(567)
	Float _g7 = ::Math_obj::sin(angle);		HX_STACK_VAR(_g7,"_g7");
	HX_STACK_LINE(567)
	Float _g8 = -(::Math_obj::sin(angle));		HX_STACK_VAR(_g8,"_g8");
	HX_STACK_LINE(567)
	Float _g9 = ::Math_obj::cos(angle);		HX_STACK_VAR(_g9,"_g9");
	HX_STACK_LINE(567)
	Array< Float > _g10 = Array_obj< Float >::__new().Add(_g6).Add((int)0).Add(_g7).Add((int)0).Add((int)0).Add((int)1).Add((int)0).Add((int)0).Add(_g8).Add((int)0).Add(_g9).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((int)0);		HX_STACK_VAR(_g10,"_g10");
	HX_STACK_LINE(567)
	::flash::geom::Matrix3D _g11 = ::flash::geom::Matrix3D_obj::__new(_g10);		HX_STACK_VAR(_g11,"_g11");
	HX_STACK_LINE(567)
	this->append(_g11);
	HX_STACK_LINE(568)
	angle = -(components->__get((int)1).StaticCast< ::flash::geom::Vector3D >()->z);
	HX_STACK_LINE(569)
	Float _g12 = ::Math_obj::cos(angle);		HX_STACK_VAR(_g12,"_g12");
	HX_STACK_LINE(569)
	Float _g13 = -(::Math_obj::sin(angle));		HX_STACK_VAR(_g13,"_g13");
	HX_STACK_LINE(569)
	Float _g14 = ::Math_obj::sin(angle);		HX_STACK_VAR(_g14,"_g14");
	HX_STACK_LINE(569)
	Float _g15 = ::Math_obj::cos(angle);		HX_STACK_VAR(_g15,"_g15");
	HX_STACK_LINE(569)
	Array< Float > _g16 = Array_obj< Float >::__new().Add(_g12).Add(_g13).Add((int)0).Add((int)0).Add(_g14).Add(_g15).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((int)1).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((int)0);		HX_STACK_VAR(_g16,"_g16");
	HX_STACK_LINE(569)
	::flash::geom::Matrix3D _g17 = ::flash::geom::Matrix3D_obj::__new(_g16);		HX_STACK_VAR(_g17,"_g17");
	HX_STACK_LINE(569)
	this->append(_g17);
	HX_STACK_LINE(571)
	this->set_position(components->__get((int)0).StaticCast< ::flash::geom::Vector3D >());
	HX_STACK_LINE(572)
	this->rawData[(int)15] = (int)1;
	HX_STACK_LINE(574)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,recompose,return )

::flash::geom::Vector3D Matrix3D_obj::transformVector( ::flash::geom::Vector3D v){
	HX_STACK_FRAME("flash.geom.Matrix3D","transformVector",0x421358e7,"flash.geom.Matrix3D.transformVector","flash/geom/Matrix3D.hx",579,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_ARG(v,"v")
	HX_STACK_LINE(581)
	Float x = v->x;		HX_STACK_VAR(x,"x");
	HX_STACK_LINE(581)
	Float y = v->y;		HX_STACK_VAR(y,"y");
	HX_STACK_LINE(581)
	Float z = v->z;		HX_STACK_VAR(z,"z");
	HX_STACK_LINE(583)
	return ::flash::geom::Vector3D_obj::__new(((((x * this->rawData->__get((int)0)) + (y * this->rawData->__get((int)4))) + (z * this->rawData->__get((int)8))) + this->rawData->__get((int)12)),((((x * this->rawData->__get((int)1)) + (y * this->rawData->__get((int)5))) + (z * this->rawData->__get((int)9))) + this->rawData->__get((int)13)),((((x * this->rawData->__get((int)2)) + (y * this->rawData->__get((int)6))) + (z * this->rawData->__get((int)10))) + this->rawData->__get((int)14)),(int)1);
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,transformVector,return )

Void Matrix3D_obj::transformVectors( Array< Float > vin,Array< Float > vout){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","transformVectors",0x8eda71ac,"flash.geom.Matrix3D.transformVectors","flash/geom/Matrix3D.hx",592,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_ARG(vin,"vin")
		HX_STACK_ARG(vout,"vout")
		HX_STACK_LINE(594)
		int i = (int)0;		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(595)
		Float x;		HX_STACK_VAR(x,"x");
		HX_STACK_LINE(595)
		Float y;		HX_STACK_VAR(y,"y");
		HX_STACK_LINE(595)
		Float z;		HX_STACK_VAR(z,"z");
		HX_STACK_LINE(597)
		while((true)){
			HX_STACK_LINE(597)
			if ((!((((i + (int)3) <= vin->length))))){
				HX_STACK_LINE(597)
				break;
			}
			HX_STACK_LINE(599)
			x = vin->__get(i);
			HX_STACK_LINE(600)
			y = vin->__get((i + (int)1));
			HX_STACK_LINE(601)
			z = vin->__get((i + (int)2));
			HX_STACK_LINE(602)
			vout[i] = ((((x * this->rawData->__get((int)0)) + (y * this->rawData->__get((int)4))) + (z * this->rawData->__get((int)8))) + this->rawData->__get((int)12));
			HX_STACK_LINE(603)
			vout[(i + (int)1)] = ((((x * this->rawData->__get((int)1)) + (y * this->rawData->__get((int)5))) + (z * this->rawData->__get((int)9))) + this->rawData->__get((int)13));
			HX_STACK_LINE(604)
			vout[(i + (int)2)] = ((((x * this->rawData->__get((int)2)) + (y * this->rawData->__get((int)6))) + (z * this->rawData->__get((int)10))) + this->rawData->__get((int)14));
			HX_STACK_LINE(605)
			hx::AddEq(i,(int)3);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Matrix3D_obj,transformVectors,(void))

Void Matrix3D_obj::transpose( ){
{
		HX_STACK_FRAME("flash.geom.Matrix3D","transpose",0xf8eebc11,"flash.geom.Matrix3D.transpose","flash/geom/Matrix3D.hx",612,0x1a66ac18)
		HX_STACK_THIS(this)
		HX_STACK_LINE(614)
		Array< Float > oRawData = ::flash::_Vector::Vector_Impl__obj::copy(this->rawData);		HX_STACK_VAR(oRawData,"oRawData");
		HX_STACK_LINE(615)
		this->rawData[(int)1] = oRawData->__get((int)4);
		HX_STACK_LINE(616)
		this->rawData[(int)2] = oRawData->__get((int)8);
		HX_STACK_LINE(617)
		this->rawData[(int)3] = oRawData->__get((int)12);
		HX_STACK_LINE(618)
		this->rawData[(int)4] = oRawData->__get((int)1);
		HX_STACK_LINE(619)
		this->rawData[(int)6] = oRawData->__get((int)9);
		HX_STACK_LINE(620)
		this->rawData[(int)7] = oRawData->__get((int)13);
		HX_STACK_LINE(621)
		this->rawData[(int)8] = oRawData->__get((int)2);
		HX_STACK_LINE(622)
		this->rawData[(int)9] = oRawData->__get((int)6);
		HX_STACK_LINE(623)
		this->rawData[(int)11] = oRawData->__get((int)14);
		HX_STACK_LINE(624)
		this->rawData[(int)12] = oRawData->__get((int)3);
		HX_STACK_LINE(625)
		this->rawData[(int)13] = oRawData->__get((int)7);
		HX_STACK_LINE(626)
		this->rawData[(int)14] = oRawData->__get((int)11);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix3D_obj,transpose,(void))

Float Matrix3D_obj::get_determinant( ){
	HX_STACK_FRAME("flash.geom.Matrix3D","get_determinant",0x625742c4,"flash.geom.Matrix3D.get_determinant","flash/geom/Matrix3D.hx",640,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_LINE(640)
	return ((int)-1 * ((((((((((this->rawData->__get((int)0) * this->rawData->__get((int)5)) - (this->rawData->__get((int)4) * this->rawData->__get((int)1)))) * (((this->rawData->__get((int)10) * this->rawData->__get((int)15)) - (this->rawData->__get((int)14) * this->rawData->__get((int)11))))) - ((((this->rawData->__get((int)0) * this->rawData->__get((int)9)) - (this->rawData->__get((int)8) * this->rawData->__get((int)1)))) * (((this->rawData->__get((int)6) * this->rawData->__get((int)15)) - (this->rawData->__get((int)14) * this->rawData->__get((int)7)))))) + ((((this->rawData->__get((int)0) * this->rawData->__get((int)13)) - (this->rawData->__get((int)12) * this->rawData->__get((int)1)))) * (((this->rawData->__get((int)6) * this->rawData->__get((int)11)) - (this->rawData->__get((int)10) * this->rawData->__get((int)7)))))) + ((((this->rawData->__get((int)4) * this->rawData->__get((int)9)) - (this->rawData->__get((int)8) * this->rawData->__get((int)5)))) * (((this->rawData->__get((int)2) * this->rawData->__get((int)15)) - (this->rawData->__get((int)14) * this->rawData->__get((int)3)))))) - ((((this->rawData->__get((int)4) * this->rawData->__get((int)13)) - (this->rawData->__get((int)12) * this->rawData->__get((int)5)))) * (((this->rawData->__get((int)2) * this->rawData->__get((int)11)) - (this->rawData->__get((int)10) * this->rawData->__get((int)3)))))) + ((((this->rawData->__get((int)8) * this->rawData->__get((int)13)) - (this->rawData->__get((int)12) * this->rawData->__get((int)9)))) * (((this->rawData->__get((int)2) * this->rawData->__get((int)7)) - (this->rawData->__get((int)6) * this->rawData->__get((int)3))))))));
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix3D_obj,get_determinant,return )

::flash::geom::Vector3D Matrix3D_obj::get_position( ){
	HX_STACK_FRAME("flash.geom.Matrix3D","get_position",0x3302381a,"flash.geom.Matrix3D.get_position","flash/geom/Matrix3D.hx",652,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_LINE(652)
	return ::flash::geom::Vector3D_obj::__new(this->rawData->__get((int)12),this->rawData->__get((int)13),this->rawData->__get((int)14),null());
}


HX_DEFINE_DYNAMIC_FUNC0(Matrix3D_obj,get_position,return )

::flash::geom::Vector3D Matrix3D_obj::set_position( ::flash::geom::Vector3D value){
	HX_STACK_FRAME("flash.geom.Matrix3D","set_position",0x47fb5b8e,"flash.geom.Matrix3D.set_position","flash/geom/Matrix3D.hx",657,0x1a66ac18)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(659)
	this->rawData[(int)12] = value->x;
	HX_STACK_LINE(660)
	this->rawData[(int)13] = value->y;
	HX_STACK_LINE(661)
	this->rawData[(int)14] = value->z;
	HX_STACK_LINE(662)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Matrix3D_obj,set_position,return )

::flash::geom::Matrix3D Matrix3D_obj::create2D( Float x,Float y,hx::Null< Float >  __o_scale,hx::Null< Float >  __o_rotation){
Float scale = __o_scale.Default(1);
Float rotation = __o_rotation.Default(0);
	HX_STACK_FRAME("flash.geom.Matrix3D","create2D",0x1b825936,"flash.geom.Matrix3D.create2D","flash/geom/Matrix3D.hx",191,0x1a66ac18)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(scale,"scale")
	HX_STACK_ARG(rotation,"rotation")
{
		HX_STACK_LINE(193)
		Float theta = (Float((rotation * ::Math_obj::PI)) / Float(180.0));		HX_STACK_VAR(theta,"theta");
		HX_STACK_LINE(194)
		Float c = ::Math_obj::cos(theta);		HX_STACK_VAR(c,"c");
		HX_STACK_LINE(195)
		Float s = ::Math_obj::sin(theta);		HX_STACK_VAR(s,"s");
		HX_STACK_LINE(197)
		return ::flash::geom::Matrix3D_obj::__new(Array_obj< Float >::__new().Add((c * scale)).Add((-(s) * scale)).Add((int)0).Add((int)0).Add((s * scale)).Add((c * scale)).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((int)1).Add((int)0).Add(x).Add(y).Add((int)0).Add((int)1));
	}
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Matrix3D_obj,create2D,return )

::flash::geom::Matrix3D Matrix3D_obj::createABCD( Float a,Float b,Float c,Float d,Float tx,Float ty){
	HX_STACK_FRAME("flash.geom.Matrix3D","createABCD",0xcd9c7c26,"flash.geom.Matrix3D.createABCD","flash/geom/Matrix3D.hx",209,0x1a66ac18)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_ARG(c,"c")
	HX_STACK_ARG(d,"d")
	HX_STACK_ARG(tx,"tx")
	HX_STACK_ARG(ty,"ty")
	HX_STACK_LINE(209)
	return ::flash::geom::Matrix3D_obj::__new(Array_obj< Float >::__new().Add(a).Add(b).Add((int)0).Add((int)0).Add(c).Add(d).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((int)1).Add((int)0).Add(tx).Add(ty).Add((int)0).Add((int)1));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC6(Matrix3D_obj,createABCD,return )

::flash::geom::Matrix3D Matrix3D_obj::createOrtho( Float x0,Float x1,Float y0,Float y1,Float zNear,Float zFar){
	HX_STACK_FRAME("flash.geom.Matrix3D","createOrtho",0x4acbd034,"flash.geom.Matrix3D.createOrtho","flash/geom/Matrix3D.hx",219,0x1a66ac18)
	HX_STACK_ARG(x0,"x0")
	HX_STACK_ARG(x1,"x1")
	HX_STACK_ARG(y0,"y0")
	HX_STACK_ARG(y1,"y1")
	HX_STACK_ARG(zNear,"zNear")
	HX_STACK_ARG(zFar,"zFar")
	HX_STACK_LINE(221)
	Float sx = (Float(1.0) / Float(((x1 - x0))));		HX_STACK_VAR(sx,"sx");
	HX_STACK_LINE(222)
	Float sy = (Float(1.0) / Float(((y1 - y0))));		HX_STACK_VAR(sy,"sy");
	HX_STACK_LINE(223)
	Float sz = (Float(1.0) / Float(((zFar - zNear))));		HX_STACK_VAR(sz,"sz");
	HX_STACK_LINE(225)
	return ::flash::geom::Matrix3D_obj::__new(Array_obj< Float >::__new().Add((2.0 * sx)).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((2.0 * sy)).Add((int)0).Add((int)0).Add((int)0).Add((int)0).Add((-2. * sz)).Add((int)0).Add((-(((x0 + x1))) * sx)).Add((-(((y0 + y1))) * sy)).Add((-(((zNear + zFar))) * sz)).Add((int)1));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC6(Matrix3D_obj,createOrtho,return )

::flash::geom::Matrix3D Matrix3D_obj::getAxisRotation( Float x,Float y,Float z,Float degrees){
	HX_STACK_FRAME("flash.geom.Matrix3D","getAxisRotation",0x674aa24d,"flash.geom.Matrix3D.getAxisRotation","flash/geom/Matrix3D.hx",306,0x1a66ac18)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	HX_STACK_ARG(z,"z")
	HX_STACK_ARG(degrees,"degrees")
	HX_STACK_LINE(308)
	::flash::geom::Matrix3D m = ::flash::geom::Matrix3D_obj::__new(null());		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(310)
	::flash::geom::Vector3D a1 = ::flash::geom::Vector3D_obj::__new(x,y,z,null());		HX_STACK_VAR(a1,"a1");
	HX_STACK_LINE(311)
	Float rad = (-(degrees) * ((Float(::Math_obj::PI) / Float((int)180))));		HX_STACK_VAR(rad,"rad");
	HX_STACK_LINE(312)
	Float c = ::Math_obj::cos(rad);		HX_STACK_VAR(c,"c");
	HX_STACK_LINE(313)
	Float s = ::Math_obj::sin(rad);		HX_STACK_VAR(s,"s");
	HX_STACK_LINE(314)
	Float t = (1.0 - c);		HX_STACK_VAR(t,"t");
	HX_STACK_LINE(316)
	m->rawData[(int)0] = (c + ((a1->x * a1->x) * t));
	HX_STACK_LINE(317)
	m->rawData[(int)5] = (c + ((a1->y * a1->y) * t));
	HX_STACK_LINE(318)
	m->rawData[(int)10] = (c + ((a1->z * a1->z) * t));
	HX_STACK_LINE(320)
	Float tmp1 = ((a1->x * a1->y) * t);		HX_STACK_VAR(tmp1,"tmp1");
	HX_STACK_LINE(321)
	Float tmp2 = (a1->z * s);		HX_STACK_VAR(tmp2,"tmp2");
	HX_STACK_LINE(322)
	m->rawData[(int)4] = (tmp1 + tmp2);
	HX_STACK_LINE(323)
	m->rawData[(int)1] = (tmp1 - tmp2);
	HX_STACK_LINE(324)
	tmp1 = ((a1->x * a1->z) * t);
	HX_STACK_LINE(325)
	tmp2 = (a1->y * s);
	HX_STACK_LINE(326)
	m->rawData[(int)8] = (tmp1 - tmp2);
	HX_STACK_LINE(327)
	m->rawData[(int)2] = (tmp1 + tmp2);
	HX_STACK_LINE(328)
	tmp1 = ((a1->y * a1->z) * t);
	HX_STACK_LINE(329)
	tmp2 = (a1->x * s);
	HX_STACK_LINE(330)
	m->rawData[(int)9] = (tmp1 + tmp2);
	HX_STACK_LINE(331)
	m->rawData[(int)6] = (tmp1 - tmp2);
	HX_STACK_LINE(333)
	return m;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Matrix3D_obj,getAxisRotation,return )

::flash::geom::Matrix3D Matrix3D_obj::interpolate( ::flash::geom::Matrix3D thisMat,::flash::geom::Matrix3D toMat,Float percent){
	HX_STACK_FRAME("flash.geom.Matrix3D","interpolate",0x0b565659,"flash.geom.Matrix3D.interpolate","flash/geom/Matrix3D.hx",360,0x1a66ac18)
	HX_STACK_ARG(thisMat,"thisMat")
	HX_STACK_ARG(toMat,"toMat")
	HX_STACK_ARG(percent,"percent")
	HX_STACK_LINE(362)
	::flash::geom::Matrix3D m = ::flash::geom::Matrix3D_obj::__new(null());		HX_STACK_VAR(m,"m");
	HX_STACK_LINE(364)
	{
		HX_STACK_LINE(364)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(364)
		while((true)){
			HX_STACK_LINE(364)
			if ((!(((_g < (int)16))))){
				HX_STACK_LINE(364)
				break;
			}
			HX_STACK_LINE(364)
			int i = (_g)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(366)
			m->rawData[i] = (thisMat->rawData->__get(i) + (((toMat->rawData->__get(i) - thisMat->rawData->__get(i))) * percent));
		}
	}
	HX_STACK_LINE(370)
	return m;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(Matrix3D_obj,interpolate,return )


Matrix3D_obj::Matrix3D_obj()
{
}

void Matrix3D_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Matrix3D);
	HX_MARK_MEMBER_NAME(determinant,"determinant");
	HX_MARK_MEMBER_NAME(rawData,"rawData");
	HX_MARK_END_CLASS();
}

void Matrix3D_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(determinant,"determinant");
	HX_VISIT_MEMBER_NAME(rawData,"rawData");
}

Dynamic Matrix3D_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"append") ) { return append_dyn(); }
		if (HX_FIELD_EQ(inName,"invert") ) { return invert_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"rawData") ) { return rawData; }
		if (HX_FIELD_EQ(inName,"pointAt") ) { return pointAt_dyn(); }
		if (HX_FIELD_EQ(inName,"prepend") ) { return prepend_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"create2D") ) { return create2D_dyn(); }
		if (HX_FIELD_EQ(inName,"position") ) { return get_position(); }
		if (HX_FIELD_EQ(inName,"copyFrom") ) { return copyFrom_dyn(); }
		if (HX_FIELD_EQ(inName,"identity") ) { return identity_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"copyRowTo") ) { return copyRowTo_dyn(); }
		if (HX_FIELD_EQ(inName,"decompose") ) { return decompose_dyn(); }
		if (HX_FIELD_EQ(inName,"recompose") ) { return recompose_dyn(); }
		if (HX_FIELD_EQ(inName,"transpose") ) { return transpose_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"createABCD") ) { return createABCD_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"createOrtho") ) { return createOrtho_dyn(); }
		if (HX_FIELD_EQ(inName,"interpolate") ) { return interpolate_dyn(); }
		if (HX_FIELD_EQ(inName,"determinant") ) { return inCallProp ? get_determinant() : determinant; }
		if (HX_FIELD_EQ(inName,"appendScale") ) { return appendScale_dyn(); }
		if (HX_FIELD_EQ(inName,"copyRowFrom") ) { return copyRowFrom_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"copyColumnTo") ) { return copyColumnTo_dyn(); }
		if (HX_FIELD_EQ(inName,"prependScale") ) { return prependScale_dyn(); }
		if (HX_FIELD_EQ(inName,"get_position") ) { return get_position_dyn(); }
		if (HX_FIELD_EQ(inName,"set_position") ) { return set_position_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"interpolateTo") ) { return interpolateTo_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"appendRotation") ) { return appendRotation_dyn(); }
		if (HX_FIELD_EQ(inName,"copyColumnFrom") ) { return copyColumnFrom_dyn(); }
		if (HX_FIELD_EQ(inName,"copyToMatrix3D") ) { return copyToMatrix3D_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getAxisRotation") ) { return getAxisRotation_dyn(); }
		if (HX_FIELD_EQ(inName,"prependRotation") ) { return prependRotation_dyn(); }
		if (HX_FIELD_EQ(inName,"transformVector") ) { return transformVector_dyn(); }
		if (HX_FIELD_EQ(inName,"get_determinant") ) { return get_determinant_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"transformVectors") ) { return transformVectors_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"appendTranslation") ) { return appendTranslation_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"prependTranslation") ) { return prependTranslation_dyn(); }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"deltaTransformVector") ) { return deltaTransformVector_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Matrix3D_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"rawData") ) { rawData=inValue.Cast< Array< Float > >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"position") ) { return set_position(inValue); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"determinant") ) { determinant=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Matrix3D_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("determinant"));
	outFields->push(HX_CSTRING("position"));
	outFields->push(HX_CSTRING("rawData"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("create2D"),
	HX_CSTRING("createABCD"),
	HX_CSTRING("createOrtho"),
	HX_CSTRING("getAxisRotation"),
	HX_CSTRING("interpolate"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Matrix3D_obj,determinant),HX_CSTRING("determinant")},
	{hx::fsObject /*Array< Float >*/ ,(int)offsetof(Matrix3D_obj,rawData),HX_CSTRING("rawData")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("determinant"),
	HX_CSTRING("rawData"),
	HX_CSTRING("append"),
	HX_CSTRING("appendRotation"),
	HX_CSTRING("appendScale"),
	HX_CSTRING("appendTranslation"),
	HX_CSTRING("clone"),
	HX_CSTRING("copyColumnFrom"),
	HX_CSTRING("copyColumnTo"),
	HX_CSTRING("copyFrom"),
	HX_CSTRING("copyRowFrom"),
	HX_CSTRING("copyRowTo"),
	HX_CSTRING("copyToMatrix3D"),
	HX_CSTRING("decompose"),
	HX_CSTRING("deltaTransformVector"),
	HX_CSTRING("identity"),
	HX_CSTRING("interpolateTo"),
	HX_CSTRING("invert"),
	HX_CSTRING("pointAt"),
	HX_CSTRING("prepend"),
	HX_CSTRING("prependRotation"),
	HX_CSTRING("prependScale"),
	HX_CSTRING("prependTranslation"),
	HX_CSTRING("recompose"),
	HX_CSTRING("transformVector"),
	HX_CSTRING("transformVectors"),
	HX_CSTRING("transpose"),
	HX_CSTRING("get_determinant"),
	HX_CSTRING("get_position"),
	HX_CSTRING("set_position"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Matrix3D_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Matrix3D_obj::__mClass,"__mClass");
};

#endif

Class Matrix3D_obj::__mClass;

void Matrix3D_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.geom.Matrix3D"), hx::TCanCast< Matrix3D_obj> ,sStaticFields,sMemberFields,
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

void Matrix3D_obj::__boot()
{
}

} // end namespace flash
} // end namespace geom
