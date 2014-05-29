#include <hxcpp.h>

#ifndef INCLUDED_flash_geom_Matrix
#include <flash/geom/Matrix.h>
#endif
#ifndef INCLUDED_flash_geom_Point
#include <flash/geom/Point.h>
#endif
#ifndef INCLUDED_flash_geom_Rectangle
#include <flash/geom/Rectangle.h>
#endif
namespace flash{
namespace geom{

Void Rectangle_obj::__construct(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height)
{
HX_STACK_FRAME("flash.geom.Rectangle","new",0x321c8f4d,"flash.geom.Rectangle.new","flash/geom/Rectangle.hx",20,0xb9f20523)
HX_STACK_THIS(this)
HX_STACK_ARG(__o_x,"x")
HX_STACK_ARG(__o_y,"y")
HX_STACK_ARG(__o_width,"width")
HX_STACK_ARG(__o_height,"height")
Float x = __o_x.Default(0);
Float y = __o_y.Default(0);
Float width = __o_width.Default(0);
Float height = __o_height.Default(0);
{
	HX_STACK_LINE(22)
	this->x = x;
	HX_STACK_LINE(23)
	this->y = y;
	HX_STACK_LINE(24)
	this->width = width;
	HX_STACK_LINE(25)
	this->height = height;
}
;
	return null();
}

//Rectangle_obj::~Rectangle_obj() { }

Dynamic Rectangle_obj::__CreateEmpty() { return  new Rectangle_obj; }
hx::ObjectPtr< Rectangle_obj > Rectangle_obj::__new(hx::Null< Float >  __o_x,hx::Null< Float >  __o_y,hx::Null< Float >  __o_width,hx::Null< Float >  __o_height)
{  hx::ObjectPtr< Rectangle_obj > result = new Rectangle_obj();
	result->__construct(__o_x,__o_y,__o_width,__o_height);
	return result;}

Dynamic Rectangle_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Rectangle_obj > result = new Rectangle_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return result;}

::flash::geom::Rectangle Rectangle_obj::clone( ){
	HX_STACK_FRAME("flash.geom.Rectangle","clone",0x0d0b278a,"flash.geom.Rectangle.clone","flash/geom/Rectangle.hx",32,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(32)
	return ::flash::geom::Rectangle_obj::__new(this->x,this->y,this->width,this->height);
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,clone,return )

bool Rectangle_obj::contains( Float x,Float y){
	HX_STACK_FRAME("flash.geom.Rectangle","contains",0x16d66012,"flash.geom.Rectangle.contains","flash/geom/Rectangle.hx",39,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(x,"x")
	HX_STACK_ARG(y,"y")
	struct _Function_1_1{
		inline static bool Block( hx::ObjectPtr< ::flash::geom::Rectangle_obj > __this,Float &x){
			HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","flash/geom/Rectangle.hx",39,0xb9f20523)
			{
				HX_STACK_LINE(39)
				Float _g = __this->get_right();		HX_STACK_VAR(_g,"_g");
				HX_STACK_LINE(39)
				return (x < _g);
			}
			return null();
		}
	};
	HX_STACK_LINE(39)
	if (((  (((bool((x >= this->x)) && bool((y >= this->y))))) ? bool(_Function_1_1::Block(this,x)) : bool(false) ))){
		HX_STACK_LINE(39)
		Float _g1 = this->get_bottom();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(39)
		return (y < _g1);
	}
	else{
		HX_STACK_LINE(39)
		return false;
	}
	HX_STACK_LINE(39)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC2(Rectangle_obj,contains,return )

bool Rectangle_obj::containsPoint( ::flash::geom::Point point){
	HX_STACK_FRAME("flash.geom.Rectangle","containsPoint",0x303742de,"flash.geom.Rectangle.containsPoint","flash/geom/Rectangle.hx",46,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_LINE(46)
	return this->contains(point->x,point->y);
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,containsPoint,return )

bool Rectangle_obj::containsRect( ::flash::geom::Rectangle rect){
	HX_STACK_FRAME("flash.geom.Rectangle","containsRect",0x453d4a56,"flash.geom.Rectangle.containsRect","flash/geom/Rectangle.hx",53,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(rect,"rect")
	HX_STACK_LINE(53)
	if (((bool((rect->width <= (int)0)) || bool((rect->height <= (int)0))))){
		struct _Function_2_1{
			inline static bool Block( hx::ObjectPtr< ::flash::geom::Rectangle_obj > __this,::flash::geom::Rectangle &rect){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","flash/geom/Rectangle.hx",55,0xb9f20523)
				{
					HX_STACK_LINE(55)
					Float _g = rect->get_right();		HX_STACK_VAR(_g,"_g");
					HX_STACK_LINE(55)
					Float _g1 = __this->get_right();		HX_STACK_VAR(_g1,"_g1");
					HX_STACK_LINE(55)
					return (_g < _g1);
				}
				return null();
			}
		};
		HX_STACK_LINE(55)
		if (((  (((bool((rect->x > this->x)) && bool((rect->y > this->y))))) ? bool(_Function_2_1::Block(this,rect)) : bool(false) ))){
			HX_STACK_LINE(55)
			Float _g2 = rect->get_bottom();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(55)
			Float _g3 = this->get_bottom();		HX_STACK_VAR(_g3,"_g3");
			HX_STACK_LINE(55)
			return (_g2 < _g3);
		}
		else{
			HX_STACK_LINE(55)
			return false;
		}
	}
	else{
		struct _Function_2_1{
			inline static bool Block( hx::ObjectPtr< ::flash::geom::Rectangle_obj > __this,::flash::geom::Rectangle &rect){
				HX_STACK_FRAME("*","closure",0x5bdab937,"*.closure","flash/geom/Rectangle.hx",59,0xb9f20523)
				{
					HX_STACK_LINE(59)
					Float _g4 = rect->get_right();		HX_STACK_VAR(_g4,"_g4");
					HX_STACK_LINE(59)
					Float _g5 = __this->get_right();		HX_STACK_VAR(_g5,"_g5");
					HX_STACK_LINE(59)
					return (_g4 <= _g5);
				}
				return null();
			}
		};
		HX_STACK_LINE(59)
		if (((  (((bool((rect->x >= this->x)) && bool((rect->y >= this->y))))) ? bool(_Function_2_1::Block(this,rect)) : bool(false) ))){
			HX_STACK_LINE(59)
			Float _g6 = rect->get_bottom();		HX_STACK_VAR(_g6,"_g6");
			HX_STACK_LINE(59)
			Float _g7 = this->get_bottom();		HX_STACK_VAR(_g7,"_g7");
			HX_STACK_LINE(59)
			return (_g6 <= _g7);
		}
		else{
			HX_STACK_LINE(59)
			return false;
		}
	}
	HX_STACK_LINE(53)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,containsRect,return )

Void Rectangle_obj::copyFrom( ::flash::geom::Rectangle sourceRect){
{
		HX_STACK_FRAME("flash.geom.Rectangle","copyFrom",0xb2bc11b2,"flash.geom.Rectangle.copyFrom","flash/geom/Rectangle.hx",66,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_ARG(sourceRect,"sourceRect")
		HX_STACK_LINE(68)
		this->x = sourceRect->x;
		HX_STACK_LINE(69)
		this->y = sourceRect->y;
		HX_STACK_LINE(70)
		this->width = sourceRect->width;
		HX_STACK_LINE(71)
		this->height = sourceRect->height;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,copyFrom,(void))

bool Rectangle_obj::equals( ::flash::geom::Rectangle toCompare){
	HX_STACK_FRAME("flash.geom.Rectangle","equals",0x0e5c8172,"flash.geom.Rectangle.equals","flash/geom/Rectangle.hx",78,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(toCompare,"toCompare")
	HX_STACK_LINE(78)
	return (bool((bool((bool((this->x == toCompare->x)) && bool((this->y == toCompare->y)))) && bool((this->width == toCompare->width)))) && bool((this->height == toCompare->height)));
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,equals,return )

Void Rectangle_obj::extendBounds( ::flash::geom::Rectangle r){
{
		HX_STACK_FRAME("flash.geom.Rectangle","extendBounds",0xbfa72762,"flash.geom.Rectangle.extendBounds","flash/geom/Rectangle.hx",83,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_ARG(r,"r")
		HX_STACK_LINE(85)
		Float dx = (this->x - r->x);		HX_STACK_VAR(dx,"dx");
		HX_STACK_LINE(86)
		if (((dx > (int)0))){
			HX_STACK_LINE(88)
			hx::SubEq(this->x,dx);
			HX_STACK_LINE(89)
			hx::AddEq(this->width,dx);
		}
		HX_STACK_LINE(93)
		Float dy = (this->y - r->y);		HX_STACK_VAR(dy,"dy");
		HX_STACK_LINE(94)
		if (((dy > (int)0))){
			HX_STACK_LINE(96)
			hx::SubEq(this->y,dy);
			HX_STACK_LINE(97)
			hx::AddEq(this->height,dy);
		}
		HX_STACK_LINE(101)
		Float _g = r->get_right();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(101)
		Float _g1 = this->get_right();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(101)
		if (((_g > _g1))){
			HX_STACK_LINE(103)
			Float _g2 = r->get_right();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(103)
			this->set_right(_g2);
		}
		HX_STACK_LINE(107)
		Float _g3 = r->get_bottom();		HX_STACK_VAR(_g3,"_g3");
		HX_STACK_LINE(107)
		Float _g4 = this->get_bottom();		HX_STACK_VAR(_g4,"_g4");
		HX_STACK_LINE(107)
		if (((_g3 > _g4))){
			HX_STACK_LINE(109)
			Float _g5 = r->get_bottom();		HX_STACK_VAR(_g5,"_g5");
			HX_STACK_LINE(109)
			this->set_bottom(_g5);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,extendBounds,(void))

Void Rectangle_obj::inflate( Float dx,Float dy){
{
		HX_STACK_FRAME("flash.geom.Rectangle","inflate",0x5a12d5f4,"flash.geom.Rectangle.inflate","flash/geom/Rectangle.hx",116,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_LINE(118)
		hx::SubEq(this->x,dx);
		HX_STACK_LINE(119)
		hx::SubEq(this->y,dy);
		HX_STACK_LINE(120)
		hx::AddEq(this->width,(dx * (int)2));
		HX_STACK_LINE(121)
		hx::AddEq(this->height,(dy * (int)2));
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Rectangle_obj,inflate,(void))

Void Rectangle_obj::inflatePoint( ::flash::geom::Point point){
{
		HX_STACK_FRAME("flash.geom.Rectangle","inflatePoint",0xd15a39bc,"flash.geom.Rectangle.inflatePoint","flash/geom/Rectangle.hx",128,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_ARG(point,"point")
		HX_STACK_LINE(128)
		this->inflate(point->x,point->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,inflatePoint,(void))

::flash::geom::Rectangle Rectangle_obj::intersection( ::flash::geom::Rectangle toIntersect){
	HX_STACK_FRAME("flash.geom.Rectangle","intersection",0x27821dbc,"flash.geom.Rectangle.intersection","flash/geom/Rectangle.hx",133,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(toIntersect,"toIntersect")
	HX_STACK_LINE(135)
	Float x0;		HX_STACK_VAR(x0,"x0");
	HX_STACK_LINE(135)
	if (((this->x < toIntersect->x))){
		HX_STACK_LINE(135)
		x0 = toIntersect->x;
	}
	else{
		HX_STACK_LINE(135)
		x0 = this->x;
	}
	HX_STACK_LINE(136)
	Float _g = this->get_right();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(136)
	Float _g1 = toIntersect->get_right();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(136)
	Float x1;		HX_STACK_VAR(x1,"x1");
	HX_STACK_LINE(136)
	if (((_g > _g1))){
		HX_STACK_LINE(136)
		x1 = toIntersect->get_right();
	}
	else{
		HX_STACK_LINE(136)
		x1 = this->get_right();
	}
	HX_STACK_LINE(137)
	if (((x1 <= x0))){
		HX_STACK_LINE(139)
		return ::flash::geom::Rectangle_obj::__new(null(),null(),null(),null());
	}
	HX_STACK_LINE(143)
	Float y0;		HX_STACK_VAR(y0,"y0");
	HX_STACK_LINE(143)
	if (((this->y < toIntersect->y))){
		HX_STACK_LINE(143)
		y0 = toIntersect->y;
	}
	else{
		HX_STACK_LINE(143)
		y0 = this->y;
	}
	HX_STACK_LINE(144)
	Float _g2 = this->get_bottom();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(144)
	Float _g3 = toIntersect->get_bottom();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(144)
	Float y1;		HX_STACK_VAR(y1,"y1");
	HX_STACK_LINE(144)
	if (((_g2 > _g3))){
		HX_STACK_LINE(144)
		y1 = toIntersect->get_bottom();
	}
	else{
		HX_STACK_LINE(144)
		y1 = this->get_bottom();
	}
	HX_STACK_LINE(145)
	if (((y1 <= y0))){
		HX_STACK_LINE(147)
		return ::flash::geom::Rectangle_obj::__new(null(),null(),null(),null());
	}
	HX_STACK_LINE(151)
	return ::flash::geom::Rectangle_obj::__new(x0,y0,(x1 - x0),(y1 - y0));
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,intersection,return )

bool Rectangle_obj::intersects( ::flash::geom::Rectangle toIntersect){
	HX_STACK_FRAME("flash.geom.Rectangle","intersects",0x5f8a6b67,"flash.geom.Rectangle.intersects","flash/geom/Rectangle.hx",156,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(toIntersect,"toIntersect")
	HX_STACK_LINE(158)
	Float x0;		HX_STACK_VAR(x0,"x0");
	HX_STACK_LINE(158)
	if (((this->x < toIntersect->x))){
		HX_STACK_LINE(158)
		x0 = toIntersect->x;
	}
	else{
		HX_STACK_LINE(158)
		x0 = this->x;
	}
	HX_STACK_LINE(159)
	Float _g = this->get_right();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(159)
	Float _g1 = toIntersect->get_right();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(159)
	Float x1;		HX_STACK_VAR(x1,"x1");
	HX_STACK_LINE(159)
	if (((_g > _g1))){
		HX_STACK_LINE(159)
		x1 = toIntersect->get_right();
	}
	else{
		HX_STACK_LINE(159)
		x1 = this->get_right();
	}
	HX_STACK_LINE(160)
	if (((x1 <= x0))){
		HX_STACK_LINE(162)
		return false;
	}
	HX_STACK_LINE(166)
	Float y0;		HX_STACK_VAR(y0,"y0");
	HX_STACK_LINE(166)
	if (((this->y < toIntersect->y))){
		HX_STACK_LINE(166)
		y0 = toIntersect->y;
	}
	else{
		HX_STACK_LINE(166)
		y0 = this->y;
	}
	HX_STACK_LINE(167)
	Float _g2 = this->get_bottom();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(167)
	Float _g3 = toIntersect->get_bottom();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(167)
	Float y1;		HX_STACK_VAR(y1,"y1");
	HX_STACK_LINE(167)
	if (((_g2 > _g3))){
		HX_STACK_LINE(167)
		y1 = toIntersect->get_bottom();
	}
	else{
		HX_STACK_LINE(167)
		y1 = this->get_bottom();
	}
	HX_STACK_LINE(168)
	return (y1 > y0);
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,intersects,return )

bool Rectangle_obj::isEmpty( ){
	HX_STACK_FRAME("flash.geom.Rectangle","isEmpty",0x5a5717b0,"flash.geom.Rectangle.isEmpty","flash/geom/Rectangle.hx",175,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(175)
	return (bool((this->width <= (int)0)) || bool((this->height <= (int)0)));
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,isEmpty,return )

Void Rectangle_obj::offset( Float dx,Float dy){
{
		HX_STACK_FRAME("flash.geom.Rectangle","offset",0xaea92ac6,"flash.geom.Rectangle.offset","flash/geom/Rectangle.hx",180,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_ARG(dx,"dx")
		HX_STACK_ARG(dy,"dy")
		HX_STACK_LINE(182)
		hx::AddEq(this->x,dx);
		HX_STACK_LINE(183)
		hx::AddEq(this->y,dy);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(Rectangle_obj,offset,(void))

Void Rectangle_obj::offsetPoint( ::flash::geom::Point point){
{
		HX_STACK_FRAME("flash.geom.Rectangle","offsetPoint",0x0e452baa,"flash.geom.Rectangle.offsetPoint","flash/geom/Rectangle.hx",188,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_ARG(point,"point")
		HX_STACK_LINE(190)
		hx::AddEq(this->x,point->x);
		HX_STACK_LINE(191)
		hx::AddEq(this->y,point->y);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,offsetPoint,(void))

Void Rectangle_obj::setEmpty( ){
{
		HX_STACK_FRAME("flash.geom.Rectangle","setEmpty",0x6869a97e,"flash.geom.Rectangle.setEmpty","flash/geom/Rectangle.hx",196,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_LINE(198)
		this->x = (int)0;
		HX_STACK_LINE(199)
		this->y = (int)0;
		HX_STACK_LINE(200)
		this->width = (int)0;
		HX_STACK_LINE(201)
		this->height = (int)0;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,setEmpty,(void))

Void Rectangle_obj::setTo( Float xa,Float ya,Float widtha,Float heighta){
{
		HX_STACK_FRAME("flash.geom.Rectangle","setTo",0x3ed7a5ea,"flash.geom.Rectangle.setTo","flash/geom/Rectangle.hx",206,0xb9f20523)
		HX_STACK_THIS(this)
		HX_STACK_ARG(xa,"xa")
		HX_STACK_ARG(ya,"ya")
		HX_STACK_ARG(widtha,"widtha")
		HX_STACK_ARG(heighta,"heighta")
		HX_STACK_LINE(208)
		this->x = xa;
		HX_STACK_LINE(209)
		this->y = ya;
		HX_STACK_LINE(210)
		this->width = widtha;
		HX_STACK_LINE(211)
		this->height = heighta;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC4(Rectangle_obj,setTo,(void))

::String Rectangle_obj::toString( ){
	HX_STACK_FRAME("flash.geom.Rectangle","toString",0x22c9d69f,"flash.geom.Rectangle.toString","flash/geom/Rectangle.hx",218,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(218)
	return ((((((((HX_CSTRING("(x=") + this->x) + HX_CSTRING(", y=")) + this->y) + HX_CSTRING(", width=")) + this->width) + HX_CSTRING(", height=")) + this->height) + HX_CSTRING(")"));
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,toString,return )

::flash::geom::Rectangle Rectangle_obj::transform( ::flash::geom::Matrix m){
	HX_STACK_FRAME("flash.geom.Rectangle","transform",0x6add5c19,"flash.geom.Rectangle.transform","flash/geom/Rectangle.hx",223,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(m,"m")
	HX_STACK_LINE(225)
	Float tx0 = ((m->a * this->x) + (m->c * this->y));		HX_STACK_VAR(tx0,"tx0");
	HX_STACK_LINE(226)
	Float tx1 = tx0;		HX_STACK_VAR(tx1,"tx1");
	HX_STACK_LINE(227)
	Float ty0 = ((m->b * this->x) + (m->d * this->y));		HX_STACK_VAR(ty0,"ty0");
	HX_STACK_LINE(228)
	Float ty1 = tx0;		HX_STACK_VAR(ty1,"ty1");
	HX_STACK_LINE(230)
	Float tx = ((m->a * ((this->x + this->width))) + (m->c * this->y));		HX_STACK_VAR(tx,"tx");
	HX_STACK_LINE(231)
	Float ty = ((m->b * ((this->x + this->width))) + (m->d * this->y));		HX_STACK_VAR(ty,"ty");
	HX_STACK_LINE(232)
	if (((tx < tx0))){
		HX_STACK_LINE(232)
		tx0 = tx;
	}
	HX_STACK_LINE(233)
	if (((ty < ty0))){
		HX_STACK_LINE(233)
		ty0 = ty;
	}
	HX_STACK_LINE(234)
	if (((tx > tx1))){
		HX_STACK_LINE(234)
		tx1 = tx;
	}
	HX_STACK_LINE(235)
	if (((ty > ty1))){
		HX_STACK_LINE(235)
		ty1 = ty;
	}
	HX_STACK_LINE(237)
	tx = ((m->a * ((this->x + this->width))) + (m->c * ((this->y + this->height))));
	HX_STACK_LINE(238)
	ty = ((m->b * ((this->x + this->width))) + (m->d * ((this->y + this->height))));
	HX_STACK_LINE(239)
	if (((tx < tx0))){
		HX_STACK_LINE(239)
		tx0 = tx;
	}
	HX_STACK_LINE(240)
	if (((ty < ty0))){
		HX_STACK_LINE(240)
		ty0 = ty;
	}
	HX_STACK_LINE(241)
	if (((tx > tx1))){
		HX_STACK_LINE(241)
		tx1 = tx;
	}
	HX_STACK_LINE(242)
	if (((ty > ty1))){
		HX_STACK_LINE(242)
		ty1 = ty;
	}
	HX_STACK_LINE(244)
	tx = ((m->a * this->x) + (m->c * ((this->y + this->height))));
	HX_STACK_LINE(245)
	ty = ((m->b * this->x) + (m->d * ((this->y + this->height))));
	HX_STACK_LINE(246)
	if (((tx < tx0))){
		HX_STACK_LINE(246)
		tx0 = tx;
	}
	HX_STACK_LINE(247)
	if (((ty < ty0))){
		HX_STACK_LINE(247)
		ty0 = ty;
	}
	HX_STACK_LINE(248)
	if (((tx > tx1))){
		HX_STACK_LINE(248)
		tx1 = tx;
	}
	HX_STACK_LINE(249)
	if (((ty > ty1))){
		HX_STACK_LINE(249)
		ty1 = ty;
	}
	HX_STACK_LINE(251)
	return ::flash::geom::Rectangle_obj::__new((tx0 + m->tx),(ty0 + m->ty),(tx1 - tx0),(ty1 - ty0));
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,transform,return )

::flash::geom::Rectangle Rectangle_obj::_union( ::flash::geom::Rectangle toUnion){
	HX_STACK_FRAME("flash.geom.Rectangle","union",0x6b8f793c,"flash.geom.Rectangle.union","flash/geom/Rectangle.hx",256,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(toUnion,"toUnion")
	HX_STACK_LINE(258)
	Float x0;		HX_STACK_VAR(x0,"x0");
	HX_STACK_LINE(258)
	if (((this->x > toUnion->x))){
		HX_STACK_LINE(258)
		x0 = toUnion->x;
	}
	else{
		HX_STACK_LINE(258)
		x0 = this->x;
	}
	HX_STACK_LINE(259)
	Float _g = this->get_right();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(259)
	Float _g1 = toUnion->get_right();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(259)
	Float x1;		HX_STACK_VAR(x1,"x1");
	HX_STACK_LINE(259)
	if (((_g < _g1))){
		HX_STACK_LINE(259)
		x1 = toUnion->get_right();
	}
	else{
		HX_STACK_LINE(259)
		x1 = this->get_right();
	}
	HX_STACK_LINE(260)
	Float y0;		HX_STACK_VAR(y0,"y0");
	HX_STACK_LINE(260)
	if (((this->y > toUnion->y))){
		HX_STACK_LINE(260)
		y0 = toUnion->y;
	}
	else{
		HX_STACK_LINE(260)
		y0 = this->y;
	}
	HX_STACK_LINE(261)
	Float _g2 = this->get_bottom();		HX_STACK_VAR(_g2,"_g2");
	HX_STACK_LINE(261)
	Float _g3 = toUnion->get_bottom();		HX_STACK_VAR(_g3,"_g3");
	HX_STACK_LINE(261)
	Float y1;		HX_STACK_VAR(y1,"y1");
	HX_STACK_LINE(261)
	if (((_g2 < _g3))){
		HX_STACK_LINE(261)
		y1 = toUnion->get_bottom();
	}
	else{
		HX_STACK_LINE(261)
		y1 = this->get_bottom();
	}
	HX_STACK_LINE(262)
	return ::flash::geom::Rectangle_obj::__new(x0,y0,(x1 - x0),(y1 - y0));
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,_union,return )

Float Rectangle_obj::get_bottom( ){
	HX_STACK_FRAME("flash.geom.Rectangle","get_bottom",0xd19eff67,"flash.geom.Rectangle.get_bottom","flash/geom/Rectangle.hx",274,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(274)
	return (this->y + this->height);
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,get_bottom,return )

Float Rectangle_obj::set_bottom( Float value){
	HX_STACK_FRAME("flash.geom.Rectangle","set_bottom",0xd51c9ddb,"flash.geom.Rectangle.set_bottom","flash/geom/Rectangle.hx",275,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(275)
	this->height = (value - this->y);
	HX_STACK_LINE(275)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,set_bottom,return )

::flash::geom::Point Rectangle_obj::get_bottomRight( ){
	HX_STACK_FRAME("flash.geom.Rectangle","get_bottomRight",0x3df846f5,"flash.geom.Rectangle.get_bottomRight","flash/geom/Rectangle.hx",276,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(276)
	return ::flash::geom::Point_obj::__new((this->x + this->width),(this->y + this->height));
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,get_bottomRight,return )

::flash::geom::Point Rectangle_obj::set_bottomRight( ::flash::geom::Point value){
	HX_STACK_FRAME("flash.geom.Rectangle","set_bottomRight",0x39c3c401,"flash.geom.Rectangle.set_bottomRight","flash/geom/Rectangle.hx",277,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(277)
	this->width = (value->x - this->x);
	HX_STACK_LINE(277)
	this->height = (value->y - this->y);
	HX_STACK_LINE(277)
	return value->clone();
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,set_bottomRight,return )

Float Rectangle_obj::get_left( ){
	HX_STACK_FRAME("flash.geom.Rectangle","get_left",0xb1c5c983,"flash.geom.Rectangle.get_left","flash/geom/Rectangle.hx",278,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(278)
	return this->x;
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,get_left,return )

Float Rectangle_obj::set_left( Float value){
	HX_STACK_FRAME("flash.geom.Rectangle","set_left",0x602322f7,"flash.geom.Rectangle.set_left","flash/geom/Rectangle.hx",279,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(279)
	hx::SubEq(this->width,(value - this->x));
	HX_STACK_LINE(279)
	this->x = value;
	HX_STACK_LINE(279)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,set_left,return )

Float Rectangle_obj::get_right( ){
	HX_STACK_FRAME("flash.geom.Rectangle","get_right",0x525796e0,"flash.geom.Rectangle.get_right","flash/geom/Rectangle.hx",280,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(280)
	return (this->x + this->width);
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,get_right,return )

Float Rectangle_obj::set_right( Float value){
	HX_STACK_FRAME("flash.geom.Rectangle","set_right",0x35a882ec,"flash.geom.Rectangle.set_right","flash/geom/Rectangle.hx",281,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(281)
	this->width = (value - this->x);
	HX_STACK_LINE(281)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,set_right,return )

::flash::geom::Point Rectangle_obj::get_size( ){
	HX_STACK_FRAME("flash.geom.Rectangle","get_size",0xb669623d,"flash.geom.Rectangle.get_size","flash/geom/Rectangle.hx",282,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(282)
	return ::flash::geom::Point_obj::__new(this->width,this->height);
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,get_size,return )

::flash::geom::Point Rectangle_obj::set_size( ::flash::geom::Point value){
	HX_STACK_FRAME("flash.geom.Rectangle","set_size",0x64c6bbb1,"flash.geom.Rectangle.set_size","flash/geom/Rectangle.hx",283,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(283)
	this->width = value->x;
	HX_STACK_LINE(283)
	this->height = value->y;
	HX_STACK_LINE(283)
	return value->clone();
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,set_size,return )

Float Rectangle_obj::get_top( ){
	HX_STACK_FRAME("flash.geom.Rectangle","get_top",0x74c46899,"flash.geom.Rectangle.get_top","flash/geom/Rectangle.hx",284,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(284)
	return this->y;
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,get_top,return )

Float Rectangle_obj::set_top( Float value){
	HX_STACK_FRAME("flash.geom.Rectangle","set_top",0x67c5f9a5,"flash.geom.Rectangle.set_top","flash/geom/Rectangle.hx",285,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(285)
	hx::SubEq(this->height,(value - this->y));
	HX_STACK_LINE(285)
	this->y = value;
	HX_STACK_LINE(285)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,set_top,return )

::flash::geom::Point Rectangle_obj::get_topLeft( ){
	HX_STACK_FRAME("flash.geom.Rectangle","get_topLeft",0x1df05d40,"flash.geom.Rectangle.get_topLeft","flash/geom/Rectangle.hx",286,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_LINE(286)
	return ::flash::geom::Point_obj::__new(this->x,this->y);
}


HX_DEFINE_DYNAMIC_FUNC0(Rectangle_obj,get_topLeft,return )

::flash::geom::Point Rectangle_obj::set_topLeft( ::flash::geom::Point value){
	HX_STACK_FRAME("flash.geom.Rectangle","set_topLeft",0x285d644c,"flash.geom.Rectangle.set_topLeft","flash/geom/Rectangle.hx",287,0xb9f20523)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(287)
	this->x = value->x;
	HX_STACK_LINE(287)
	this->y = value->y;
	HX_STACK_LINE(287)
	return value->clone();
}


HX_DEFINE_DYNAMIC_FUNC1(Rectangle_obj,set_topLeft,return )


Rectangle_obj::Rectangle_obj()
{
}

Dynamic Rectangle_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return x; }
		if (HX_FIELD_EQ(inName,"y") ) { return y; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"top") ) { return get_top(); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"left") ) { return get_left(); }
		if (HX_FIELD_EQ(inName,"size") ) { return get_size(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"right") ) { return get_right(); }
		if (HX_FIELD_EQ(inName,"width") ) { return width; }
		if (HX_FIELD_EQ(inName,"clone") ) { return clone_dyn(); }
		if (HX_FIELD_EQ(inName,"setTo") ) { return setTo_dyn(); }
		if (HX_FIELD_EQ(inName,"union") ) { return _union_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"bottom") ) { return get_bottom(); }
		if (HX_FIELD_EQ(inName,"height") ) { return height; }
		if (HX_FIELD_EQ(inName,"equals") ) { return equals_dyn(); }
		if (HX_FIELD_EQ(inName,"offset") ) { return offset_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"topLeft") ) { return get_topLeft(); }
		if (HX_FIELD_EQ(inName,"inflate") ) { return inflate_dyn(); }
		if (HX_FIELD_EQ(inName,"isEmpty") ) { return isEmpty_dyn(); }
		if (HX_FIELD_EQ(inName,"get_top") ) { return get_top_dyn(); }
		if (HX_FIELD_EQ(inName,"set_top") ) { return set_top_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"contains") ) { return contains_dyn(); }
		if (HX_FIELD_EQ(inName,"copyFrom") ) { return copyFrom_dyn(); }
		if (HX_FIELD_EQ(inName,"setEmpty") ) { return setEmpty_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		if (HX_FIELD_EQ(inName,"get_left") ) { return get_left_dyn(); }
		if (HX_FIELD_EQ(inName,"set_left") ) { return set_left_dyn(); }
		if (HX_FIELD_EQ(inName,"get_size") ) { return get_size_dyn(); }
		if (HX_FIELD_EQ(inName,"set_size") ) { return set_size_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"transform") ) { return transform_dyn(); }
		if (HX_FIELD_EQ(inName,"get_right") ) { return get_right_dyn(); }
		if (HX_FIELD_EQ(inName,"set_right") ) { return set_right_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"intersects") ) { return intersects_dyn(); }
		if (HX_FIELD_EQ(inName,"get_bottom") ) { return get_bottom_dyn(); }
		if (HX_FIELD_EQ(inName,"set_bottom") ) { return set_bottom_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bottomRight") ) { return get_bottomRight(); }
		if (HX_FIELD_EQ(inName,"offsetPoint") ) { return offsetPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"get_topLeft") ) { return get_topLeft_dyn(); }
		if (HX_FIELD_EQ(inName,"set_topLeft") ) { return set_topLeft_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"containsRect") ) { return containsRect_dyn(); }
		if (HX_FIELD_EQ(inName,"extendBounds") ) { return extendBounds_dyn(); }
		if (HX_FIELD_EQ(inName,"inflatePoint") ) { return inflatePoint_dyn(); }
		if (HX_FIELD_EQ(inName,"intersection") ) { return intersection_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"containsPoint") ) { return containsPoint_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"get_bottomRight") ) { return get_bottomRight_dyn(); }
		if (HX_FIELD_EQ(inName,"set_bottomRight") ) { return set_bottomRight_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Rectangle_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< Float >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"top") ) { return set_top(inValue); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"left") ) { return set_left(inValue); }
		if (HX_FIELD_EQ(inName,"size") ) { return set_size(inValue); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"right") ) { return set_right(inValue); }
		if (HX_FIELD_EQ(inName,"width") ) { width=inValue.Cast< Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"bottom") ) { return set_bottom(inValue); }
		if (HX_FIELD_EQ(inName,"height") ) { height=inValue.Cast< Float >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"topLeft") ) { return set_topLeft(inValue); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bottomRight") ) { return set_bottomRight(inValue); }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Rectangle_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("bottom"));
	outFields->push(HX_CSTRING("bottomRight"));
	outFields->push(HX_CSTRING("height"));
	outFields->push(HX_CSTRING("left"));
	outFields->push(HX_CSTRING("right"));
	outFields->push(HX_CSTRING("size"));
	outFields->push(HX_CSTRING("top"));
	outFields->push(HX_CSTRING("topLeft"));
	outFields->push(HX_CSTRING("width"));
	outFields->push(HX_CSTRING("x"));
	outFields->push(HX_CSTRING("y"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsFloat,(int)offsetof(Rectangle_obj,height),HX_CSTRING("height")},
	{hx::fsFloat,(int)offsetof(Rectangle_obj,width),HX_CSTRING("width")},
	{hx::fsFloat,(int)offsetof(Rectangle_obj,x),HX_CSTRING("x")},
	{hx::fsFloat,(int)offsetof(Rectangle_obj,y),HX_CSTRING("y")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("height"),
	HX_CSTRING("width"),
	HX_CSTRING("x"),
	HX_CSTRING("y"),
	HX_CSTRING("clone"),
	HX_CSTRING("contains"),
	HX_CSTRING("containsPoint"),
	HX_CSTRING("containsRect"),
	HX_CSTRING("copyFrom"),
	HX_CSTRING("equals"),
	HX_CSTRING("extendBounds"),
	HX_CSTRING("inflate"),
	HX_CSTRING("inflatePoint"),
	HX_CSTRING("intersection"),
	HX_CSTRING("intersects"),
	HX_CSTRING("isEmpty"),
	HX_CSTRING("offset"),
	HX_CSTRING("offsetPoint"),
	HX_CSTRING("setEmpty"),
	HX_CSTRING("setTo"),
	HX_CSTRING("toString"),
	HX_CSTRING("transform"),
	HX_CSTRING("union"),
	HX_CSTRING("get_bottom"),
	HX_CSTRING("set_bottom"),
	HX_CSTRING("get_bottomRight"),
	HX_CSTRING("set_bottomRight"),
	HX_CSTRING("get_left"),
	HX_CSTRING("set_left"),
	HX_CSTRING("get_right"),
	HX_CSTRING("set_right"),
	HX_CSTRING("get_size"),
	HX_CSTRING("set_size"),
	HX_CSTRING("get_top"),
	HX_CSTRING("set_top"),
	HX_CSTRING("get_topLeft"),
	HX_CSTRING("set_topLeft"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Rectangle_obj::__mClass,"__mClass");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Rectangle_obj::__mClass,"__mClass");
};

#endif

Class Rectangle_obj::__mClass;

void Rectangle_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.geom.Rectangle"), hx::TCanCast< Rectangle_obj> ,sStaticFields,sMemberFields,
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

void Rectangle_obj::__boot()
{
}

} // end namespace flash
} // end namespace geom
