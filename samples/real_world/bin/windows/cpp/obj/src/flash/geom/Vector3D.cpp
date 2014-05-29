#include <hxcpp.h>

#ifndef INCLUDED_flash_geom_Vector3D
#include <flash/geom/Vector3D.h>
#endif
#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
namespace flash{
namespace geom{

Void Vector3D_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w)
{
HX_STACK_FRAME("flash.geom.Vector3D","new",0x392341fa,"flash.geom.Vector3D.new","flash/geom/Vector3D.hx",19,0xa71bda56)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
HX_STACK_ARG(__o_z,"z")
HX_STACK_ARG(__o_w,"w")
Float x = __o_x.Default(0);
Float y = __o_y.Default(0);
Float z = __o_z.Default(0);
Float w = __o_w.Default(0);
{
	HX_STACK_LINE(21)
	this->w = w;
	HX_STACK_LINE(22)
	this->x = x;
	HX_STACK_LINE(23)
	this->y = y;
	HX_STACK_LINE(24)
	this->z = z;
}
;
	return null();
}

//Vector3D_obj::~Vector3D_obj() { }

Dynamic Vector3D_obj::__CreateEmpty() { return  new Vector3D_obj; }
hx::ObjectPtr< Vector3D_obj > Vector3D_obj::__new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_z,hx::Null< Float >  __o_w)
{  hx::ObjectPtr< Vector3D_obj > result = new Vector3D_obj();
	result->__construct(__o_x,__o_y,__o_z,__o_w);
	return result;}

Dynamic Vector3D_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Vector3D_obj > result = new Vector3D_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

::flash::geom::Vector3D Vector3D_obj::add( ::flash::geom::Vector3D a){
	HX_STACK_FRAME("flash.geom.Vector3D","add",0x391963bb,"flash.geom.Vector3D.add","flash/geom/Vector3D.hx",31,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(31)
	return ::flash::geom::Vector3D_obj::__new((this->x + a->x),(this->y + a->y),(this->z + a->z),null());
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,add,return )

::flash::geom::Vector3D Vector3D_obj::clone( ){
	HX_STACK_FRAME("flash.geom.Vector3D","clone",0xe9259f77,"flash.geom.Vector3D.clone","flash/geom/Vector3D.hx",49,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_LINE(49)
	return ::flash::geom::Vector3D_obj::__new(this->x,this->y,this->z,this->w);
}


HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,clone,return )

Void Vector3D_obj::copyFrom( ::flash::geom::Vector3D sourceVector3D){
{
		HX_STACK_FRAME("flash.geom.Vector3D","copyFrom",0x27ed8be5,"flash.geom.Vector3D.copyFrom","flash/geom/Vector3D.hx",54,0xa71bda56)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sourceVector3D,"sourceVector3D")
		HX_STACK_LINE(56)
		this->x = sourceVector3D->x;
		HX_STACK_LINE(57)
		this->y = sourceVector3D->y;
		HX_STACK_LINE(58)
		this->z = sourceVector3D->z;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,copyFrom,(void))

::flash::geom::Vector3D Vector3D_obj::crossProduct( ::flash::geom::Vector3D a){
	HX_STACK_FRAME("flash.geom.Vector3D","crossProduct",0xa4d032b5,"flash.geom.Vector3D.crossProduct","flash/geom/Vector3D.hx",65,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(65)
	return ::flash::geom::Vector3D_obj::__new(((this->y * a->z) - (this->z * a->y)),((this->z * a->x) - (this->x * a->z)),((this->x * a->y) - (this->y * a->x)),(int)1);
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,crossProduct,return )

Void Vector3D_obj::decrementBy( ::flash::geom::Vector3D a){
{
		HX_STACK_FRAME("flash.geom.Vector3D","decrementBy",0x41dbb664,"flash.geom.Vector3D.decrementBy","flash/geom/Vector3D.hx",70,0xa71bda56)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(72)
		hx::SubEq(this->x,a->x);
		HX_STACK_LINE(73)
		hx::SubEq(this->y,a->y);
		HX_STACK_LINE(74)
		hx::SubEq(this->z,a->z);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,decrementBy,(void))

Float Vector3D_obj::dotProduct( ::flash::geom::Vector3D a){
	HX_STACK_FRAME("flash.geom.Vector3D","dotProduct",0xf9b97d4c,"flash.geom.Vector3D.dotProduct","flash/geom/Vector3D.hx",92,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(92)
	return (((this->x * a->x) + (this->y * a->y)) + (this->z * a->z));
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,dotProduct,return )

bool Vector3D_obj::equals( ::flash::geom::Vector3D toCompare,hx::Null< bool >  __o_allFour){
bool allFour = __o_allFour.Default(false);
	HX_STACK_FRAME("flash.geom.Vector3D","equals",0xc96af8e5,"flash.geom.Vector3D.equals","flash/geom/Vector3D.hx",99,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_ARG(toCompare,"toCompare")
	HX_STACK_ARG(allFour,"allFour")
{
		HX_STACK_LINE(99)
		return (bool((bool((bool((this->x == toCompare->x)) && bool((this->y == toCompare->y)))) && bool((this->z == toCompare->z)))) && bool(((bool(!(allFour)) || bool((this->w == toCompare->w))))));
	}
}


HX_DEFINE_DYNAMIC_FUNC2(Vector3D_obj,equals,return )

Void Vector3D_obj::incrementBy( ::flash::geom::Vector3D a){
{
		HX_STACK_FRAME("flash.geom.Vector3D","incrementBy",0x88d20580,"flash.geom.Vector3D.incrementBy","flash/geom/Vector3D.hx",104,0xa71bda56)
		HX_STACK_THIS(this)
		HX_STACK_ARG(a,"a")
		HX_STACK_LINE(106)
		hx::AddEq(this->x,a->x);
		HX_STACK_LINE(107)
		hx::AddEq(this->y,a->y);
		HX_STACK_LINE(108)
		hx::AddEq(this->z,a->z);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,incrementBy,(void))

bool Vector3D_obj::nearEquals( ::flash::geom::Vector3D toCompare,Float tolerance,hx::Null< bool >  __o_allFour){
bool allFour = __o_allFour.Default(false);
	HX_STACK_FRAME("flash.geom.Vector3D","nearEquals",0xba3ac6ed,"flash.geom.Vector3D.nearEquals","flash/geom/Vector3D.hx",113,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_ARG(toCompare,"toCompare")
	HX_STACK_ARG(tolerance,"tolerance")
	HX_STACK_ARG(allFour,"allFour")
{
		HX_STACK_LINE(115)
		Float _g = ::Math_obj::abs((this->x - toCompare->x));		HX_STACK_VAR(_g,"_g");
		struct _Function_1_1{
			inline static bool Block( hx::ObjectPtr< ::flash::geom::Vector3D_obj > __this,::flash::geom::Vector3D &toCompare,Float &tolerance){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","flash/geom/Vector3D.hx",115,0xa71bda56)
				{
					HX_STACK_LINE(115)
					Float _g1 = ::Math_obj::abs((__this->y - toCompare->y));		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(115)
					return (_g1 < tolerance);
				}
				return null();
			}
		};
		struct _Function_1_2{
			inline static bool Block( hx::ObjectPtr< ::flash::geom::Vector3D_obj > __this,::flash::geom::Vector3D &toCompare,Float &tolerance){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","flash/geom/Vector3D.hx",115,0xa71bda56)
				{
					HX_STACK_LINE(115)
					Float _g2 = ::Math_obj::abs((__this->z - toCompare->z));		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(115)
					return (_g2 < tolerance);
				}
				return null();
			}
		};
		HX_STACK_LINE(115)
		if (((  (((  (((_g < tolerance))) ? bool(_Function_1_1::Block(this,toCompare,tolerance)) : bool(false) ))) ? bool(_Function_1_2::Block(this,toCompare,tolerance)) : bool(false) ))){
			HX_STACK_LINE(115)
			if ((!((!(allFour))))){
				HX_STACK_LINE(115)
				Float _g3 = ::Math_obj::abs((this->w - toCompare->w));		HX_STACK_VAR(_g3,"_g3");
				HX_STACK_LINE(115)
				return (_g3 < tolerance);
			}
			else{
				HX_STACK_LINE(115)
				return true;
			}
		}
		else{
			HX_STACK_LINE(115)
			return false;
		}
		HX_STACK_LINE(115)
		return false;
	}
}


HX_DEFINE_DYNAMIC_FUNC3(Vector3D_obj,nearEquals,return )

Void Vector3D_obj::negate( ){
{
		HX_STACK_FRAME("flash.geom.Vector3D","negate",0x70914c68,"flash.geom.Vector3D.negate","flash/geom/Vector3D.hx",120,0xa71bda56)
		HX_STACK_THIS(this)
		HX_STACK_LINE(122)
		hx::MultEq(this->x,(int)-1);
		HX_STACK_LINE(123)
		hx::MultEq(this->y,(int)-1);
		HX_STACK_LINE(124)
		hx::MultEq(this->z,(int)-1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,negate,(void))

Float Vector3D_obj::normalize( ){
	HX_STACK_FRAME("flash.geom.Vector3D","normalize",0xe704d8a7,"flash.geom.Vector3D.normalize","flash/geom/Vector3D.hx",129,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_LINE(131)
	Float l = ::Math_obj::sqrt((((this->x * this->x) + (this->y * this->y)) + (this->z * this->z)));		HX_STACK_VAR(l,"l");
	HX_STACK_LINE(133)
	if (((l != (int)0))){
		HX_STACK_LINE(135)
		hx::DivEq(this->x,l);
		HX_STACK_LINE(136)
		hx::DivEq(this->y,l);
		HX_STACK_LINE(137)
		hx::DivEq(this->z,l);
	}
	HX_STACK_LINE(141)
	return l;
}


HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,normalize,return )

Void Vector3D_obj::project( ){
{
		HX_STACK_FRAME("flash.geom.Vector3D","project",0x357c5973,"flash.geom.Vector3D.project","flash/geom/Vector3D.hx",146,0xa71bda56)
		HX_STACK_THIS(this)
		HX_STACK_LINE(148)
		hx::DivEq(this->x,this->w);
		HX_STACK_LINE(149)
		hx::DivEq(this->y,this->w);
		HX_STACK_LINE(150)
		hx::DivEq(this->z,this->w);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,project,(void))

Void Vector3D_obj::setTo( Float xa,Float ya,Float za){
{
		HX_STACK_FRAME("flash.geom.Vector3D","setTo",0x1af21dd7,"flash.geom.Vector3D.setTo","flash/geom/Vector3D.hx",155,0xa71bda56)
		HX_STACK_THIS(this)
		HX_STACK_ARG(xa,"xa")
		HX_STACK_ARG(ya,"ya")
		HX_STACK_ARG(za,"za")
		HX_STACK_LINE(157)
		this->x = xa;
		HX_STACK_LINE(158)
		this->y = ya;
		HX_STACK_LINE(159)
		this->z = za;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(Vector3D_obj,setTo,(void))

Void Vector3D_obj::scaleBy( Float s){
{
		HX_STACK_FRAME("flash.geom.Vector3D","scaleBy",0xa498859b,"flash.geom.Vector3D.scaleBy","flash/geom/Vector3D.hx",164,0xa71bda56)
		HX_STACK_THIS(this)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(166)
		hx::MultEq(this->x,s);
		HX_STACK_LINE(167)
		hx::MultEq(this->y,s);
		HX_STACK_LINE(168)
		hx::MultEq(this->z,s);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,scaleBy,(void))

::flash::geom::Vector3D Vector3D_obj::subtract( ::flash::geom::Vector3D a){
	HX_STACK_FRAME("flash.geom.Vector3D","subtract",0x579df53a,"flash.geom.Vector3D.subtract","flash/geom/Vector3D.hx",175,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_ARG(a,"a")
	HX_STACK_LINE(175)
	return ::flash::geom::Vector3D_obj::__new((this->x - a->x),(this->y - a->y),(this->z - a->z),null());
}


HX_DEFINE_DYNAMIC_FUNC1(Vector3D_obj,subtract,return )

::String Vector3D_obj::toString( ){
	HX_STACK_FRAME("flash.geom.Vector3D","toString",0x97fb50d2,"flash.geom.Vector3D.toString","flash/geom/Vector3D.hx",182,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_LINE(182)
	return ((((((HX_CSTRING("Vector3D(") + this->x) + HX_CSTRING(", ")) + this->y) + HX_CSTRING(", ")) + this->z) + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,toString,return )

Float Vector3D_obj::get_length( ){
	HX_STACK_FRAME("flash.geom.Vector3D","get_length",0x4b585a55,"flash.geom.Vector3D.get_length","flash/geom/Vector3D.hx",194,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_LINE(194)
	return ::Math_obj::sqrt((((this->x * this->x) + (this->y * this->y)) + (this->z * this->z)));
}


HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,get_length,return )

Float Vector3D_obj::get_lengthSquared( ){
	HX_STACK_FRAME("flash.geom.Vector3D","get_lengthSquared",0x51a67b52,"flash.geom.Vector3D.get_lengthSquared","flash/geom/Vector3D.hx",195,0xa71bda56)
	HX_STACK_THIS(this)
	HX_STACK_LINE(195)
	return (((this->x * this->x) + (this->y * this->y)) + (this->z * this->z));
}


HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,get_lengthSquared,return )

::flash::geom::Vector3D Vector3D_obj::X_AXIS;

::flash::geom::Vector3D Vector3D_obj::Y_AXIS;

::flash::geom::Vector3D Vector3D_obj::Z_AXIS;

Float Vector3D_obj::angleBetween( ::flash::geom::Vector3D a,::flash::geom::Vector3D b){
	HX_STACK_FRAME("flash.geom.Vector3D","angleBetween",0xaadb715b,"flash.geom.Vector3D.angleBetween","flash/geom/Vector3D.hx",36,0xa71bda56)
	HX_STACK_ARG(a,"a")
	HX_STACK_ARG(b,"b")
	HX_STACK_LINE(38)
	::flash::geom::Vector3D a0 = ::flash::geom::Vector3D_obj::__new(a->x,a->y,a->z,a->w);		HX_STACK_VAR(a0,"a0");
	HX_STACK_LINE(39)
	{
		HX_STACK_LINE(39)
		Float l = ::Math_obj::sqrt((((a0->x * a0->x) + (a0->y * a0->y)) + (a0->z * a0->z)));		HX_STACK_VAR(l,"l");
		HX_STACK_LINE(39)
		if (((l != (int)0))){
			HX_STACK_LINE(39)
			hx::DivEq(a0->x,l);
			HX_STACK_LINE(39)
			hx::DivEq(a0->y,l);
			HX_STACK_LINE(39)
			hx::DivEq(a0->z,l);
		}
		HX_STACK_LINE(39)
		l;
	}
	HX_STACK_LINE(40)
	::flash::geom::Vector3D b0 = ::flash::geom::Vector3D_obj::__new(b->x,b->y,b->z,b->w);		HX_STACK_VAR(b0,"b0");
	HX_STACK_LINE(41)
	{
		HX_STACK_LINE(41)
		Float l = ::Math_obj::sqrt((((b0->x * b0->x) + (b0->y * b0->y)) + (b0->z * b0->z)));		HX_STACK_VAR(l,"l");
		HX_STACK_LINE(41)
		if (((l != (int)0))){
			HX_STACK_LINE(41)
			hx::DivEq(b0->x,l);
			HX_STACK_LINE(41)
			hx::DivEq(b0->y,l);
			HX_STACK_LINE(41)
			hx::DivEq(b0->z,l);
		}
		HX_STACK_LINE(41)
		l;
	}
	HX_STACK_LINE(42)
	return ::Math_obj::acos((((a0->x * b0->x) + (a0->y * b0->y)) + (a0->z * b0->z)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Vector3D_obj,angleBetween,return )

Float Vector3D_obj::distance( ::flash::geom::Vector3D pt1,::flash::geom::Vector3D pt2){
	HX_STACK_FRAME("flash.geom.Vector3D","distance",0xcb86135b,"flash.geom.Vector3D.distance","flash/geom/Vector3D.hx",79,0xa71bda56)
	HX_STACK_ARG(pt1,"pt1")
	HX_STACK_ARG(pt2,"pt2")
	HX_STACK_LINE(81)
	Float x = (pt2->x - pt1->x);		HX_STACK_VAR(x,"x");
	HX_STACK_LINE(82)
	Float y = (pt2->y - pt1->y);		HX_STACK_VAR(y,"y");
	HX_STACK_LINE(83)
	Float z = (pt2->z - pt1->z);		HX_STACK_VAR(z,"z");
	HX_STACK_LINE(85)
	return ::Math_obj::sqrt((((x * x) + (y * y)) + (z * z)));
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Vector3D_obj,distance,return )

::flash::geom::Vector3D Vector3D_obj::get_X_AXIS( ){
	HX_STACK_FRAME("flash.geom.Vector3D","get_X_AXIS",0xba038697,"flash.geom.Vector3D.get_X_AXIS","flash/geom/Vector3D.hx",196,0xa71bda56)
	HX_STACK_LINE(196)
	return ::flash::geom::Vector3D_obj::__new((int)1,(int)0,(int)0,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,get_X_AXIS,return )

::flash::geom::Vector3D Vector3D_obj::get_Y_AXIS( ){
	HX_STACK_FRAME("flash.geom.Vector3D","get_Y_AXIS",0x205ee2f6,"flash.geom.Vector3D.get_Y_AXIS","flash/geom/Vector3D.hx",197,0xa71bda56)
	HX_STACK_LINE(197)
	return ::flash::geom::Vector3D_obj::__new((int)0,(int)1,(int)0,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,get_Y_AXIS,return )

::flash::geom::Vector3D Vector3D_obj::get_Z_AXIS( ){
	HX_STACK_FRAME("flash.geom.Vector3D","get_Z_AXIS",0x86ba3f55,"flash.geom.Vector3D.get_Z_AXIS","flash/geom/Vector3D.hx",198,0xa71bda56)
	HX_STACK_LINE(198)
	return ::flash::geom::Vector3D_obj::__new((int)0,(int)0,(int)1,null());
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Vector3D_obj,get_Z_AXIS,return )


Vector3D_obj::Vector3D_obj()
{
}

Dynamic Vector3D_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"w") ) { return w; }
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		if (HX_FIELD_EQ(inName,"z") ) { return z; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"add") ) { return add_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"setTo") ) { return setTo_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"X_AXIS") ) { return inCallProp ? get_X_AXIS() : X_AXIS; }
		if (HX_FIELD_EQ(inName,"Y_AXIS") ) { return inCallProp ? get_Y_AXIS() : Y_AXIS; }
		if (HX_FIELD_EQ(inName,"Z_AXIS") ) { return inCallProp ? get_Z_AXIS() : Z_AXIS; }
		if (HX_FIELD_EQ(inName,"length") ) { return inCallProp ? get_length() : length; }
		if (HX_FIELD_EQ(inName,"equals") ) { return equals_dyn(); }
		if (HX_FIELD_EQ(inName,"negate") ) { return negate_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"project") ) { return project_dyn(); }
		if (HX_FIELD_EQ(inName,"scaleBy") ) { return scaleBy_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"distance") ) { return distance_dyn(); }
		if (HX_FIELD_EQ(inName,"copyFrom") ) { return copyFrom_dyn(); }
		if (HX_FIELD_EQ(inName,"subtract") ) { return subtract_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"normalize") ) { return normalize_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"get_X_AXIS") ) { return get_X_AXIS_dyn(); }
		if (HX_FIELD_EQ(inName,"get_Y_AXIS") ) { return get_Y_AXIS_dyn(); }
		if (HX_FIELD_EQ(inName,"get_Z_AXIS") ) { return get_Z_AXIS_dyn(); }
		if (HX_FIELD_EQ(inName,"dotProduct") ) { return dotProduct_dyn(); }
		if (HX_FIELD_EQ(inName,"nearEquals") ) { return nearEquals_dyn(); }
		if (HX_FIELD_EQ(inName,"get_length") ) { return get_length_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"decrementBy") ) { return decrementBy_dyn(); }
		if (HX_FIELD_EQ(inName,"incrementBy") ) { return incrementBy_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"angleBetween") ) { return angleBetween_dyn(); }
		if (HX_FIELD_EQ(inName,"crossProduct") ) { return crossProduct_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"lengthSquared") ) { return inCallProp ? get_lengthSquared() : lengthSquared; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"get_lengthSquared") ) { return get_lengthSquared_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Vector3D_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"w") ) { w=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"z") ) { z=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"X_AXIS") ) { X_AXIS=inValue.Cast< ::flash::geom::Vector3D >(); return inValue; }
		if (HX_FIELD_EQ(inName,"Y_AXIS") ) { Y_AXIS=inValue.Cast< ::flash::geom::Vector3D >(); return inValue; }
		if (HX_FIELD_EQ(inName,"Z_AXIS") ) { Z_AXIS=inValue.Cast< ::flash::geom::Vector3D >(); return inValue; }
		if (HX_FIELD_EQ(inName,"length") ) { length=inValue.Cast< Float >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"lengthSquared") ) { lengthSquared=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Vector3D_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("length"));
	outFields->push(HX_CSTRING("lengthSquared"));
	outFields->push(HX_CSTRING("w"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	outFields->push(HX_CSTRING("z"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("X_AXIS"),
	HX_CSTRING("Y_AXIS"),
	HX_CSTRING("Z_AXIS"),
	HX_CSTRING("angleBetween"),
	HX_CSTRING("distance"),
	HX_CSTRING("get_X_AXIS"),
	HX_CSTRING("get_Y_AXIS"),
	HX_CSTRING("get_Z_AXIS"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Vector3D_obj,length),HX_CSTRING("length")},
	{hx::fsFloat,(int)offsetof(Vector3D_obj,lengthSquared),HX_CSTRING("lengthSquared")},
	{hx::fsFloat,(int)offsetof(Vector3D_obj,w),HX_CSTRING("w")},
	{hx::fsFloat,(int)offsetof(Vector3D_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Vector3D_obj,y),HX_CSTRING("y")},
	{hx::fsFloat,(int)offsetof(Vector3D_obj,z),HX_CSTRING("z")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("length"),
	HX_CSTRING("lengthSquared"),
	HX_CSTRING("w"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("z"),
	HX_CSTRING("add"),
	HX_CSTRING("clone"),
	HX_CSTRING("copyFrom"),
	HX_CSTRING("crossProduct"),
	HX_CSTRING("decrementBy"),
	HX_CSTRING("dotProduct"),
	HX_CSTRING("equals"),
	HX_CSTRING("incrementBy"),
	HX_CSTRING("nearEquals"),
	HX_CSTRING("negate"),
	HX_CSTRING("normalize"),
	HX_CSTRING("project"),
	HX_CSTRING("setTo"),
	HX_CSTRING("scaleBy"),
	HX_CSTRING("subtract"),
	HX_CSTRING("toString"),
	HX_CSTRING("get_length"),
	HX_CSTRING("get_lengthSquared"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Vector3D_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Vector3D_obj::X_AXIS,"X_AXIS");
	HX_MARK_MEMBER_NAME(Vector3D_obj::Y_AXIS,"Y_AXIS");
	HX_MARK_MEMBER_NAME(Vector3D_obj::Z_AXIS,"Z_AXIS");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Vector3D_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Vector3D_obj::X_AXIS,"X_AXIS");
	HX_VISIT_MEMBER_NAME(Vector3D_obj::Y_AXIS,"Y_AXIS");
	HX_VISIT_MEMBER_NAME(Vector3D_obj::Z_AXIS,"Z_AXIS");
};

#endif

Class Vector3D_obj::__mClass;

void Vector3D_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.geom.Vector3D"), hx::TCanCast< Vector3D_obj> ,sStaticFields,sMemberFields,
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

void Vector3D_obj::__boot()
{
}

} // end namespace flash
} // end namespace geom
