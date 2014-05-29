#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObjectContainer
#include <flash/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_InteractiveObject
#include <flash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_flash_display_Stage
#include <flash/display/Stage.h>
#endif
#ifndef INCLUDED_flash_errors_ArgumentError
#include <flash/errors/ArgumentError.h>
#endif
#ifndef INCLUDED_flash_errors_Error
#include <flash/errors/Error.h>
#endif
#ifndef INCLUDED_flash_errors_RangeError
#include <flash/errors/RangeError.h>
#endif
#ifndef INCLUDED_flash_events_Event
#include <flash/events/Event.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_Point
#include <flash/geom/Point.h>
#endif
namespace flash{
namespace display{

Void DisplayObjectContainer_obj::__construct(Dynamic handle,::String type)
{
HX_STACK_FRAME("flash.display.DisplayObjectContainer","new",0xad94a21c,"flash.display.DisplayObjectContainer.new","flash/display/DisplayObjectContainer.hx",21,0xf1925792)
HX_STACK_THIS(this)
HX_STACK_ARG(handle,"handle")
HX_STACK_ARG(type,"type")
{
	HX_STACK_LINE(23)
	super::__construct(handle,type);
	HX_STACK_LINE(24)
	this->__children = Array_obj< ::Dynamic >::__new();
}
;
	return null();
}

//DisplayObjectContainer_obj::~DisplayObjectContainer_obj() { }

Dynamic DisplayObjectContainer_obj::__CreateEmpty() { return  new DisplayObjectContainer_obj; }
hx::ObjectPtr< DisplayObjectContainer_obj > DisplayObjectContainer_obj::__new(Dynamic handle,::String type)
{  hx::ObjectPtr< DisplayObjectContainer_obj > result = new DisplayObjectContainer_obj();
	result->__construct(handle,type);
	return result;}

Dynamic DisplayObjectContainer_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< DisplayObjectContainer_obj > result = new DisplayObjectContainer_obj();
	result->__construct(inArgs[0],inArgs[1]);
	return result;}

::flash::display::DisplayObject DisplayObjectContainer_obj::addChild( ::flash::display::DisplayObject child){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","addChild",0xcb58347f,"flash.display.DisplayObjectContainer.addChild","flash/display/DisplayObjectContainer.hx",29,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(child,"child")
	HX_STACK_LINE(31)
	{
		HX_STACK_LINE(31)
		if (((child == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(31)
			HX_STACK_DO_THROW(HX_CSTRING("Adding to self"));
		}
		HX_STACK_LINE(31)
		if (((child->__parent == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(31)
			this->setChildIndex(child,(this->__children->length - (int)1));
		}
		else{
			HX_STACK_LINE(31)
			child->__setParent(hx::ObjectPtr<OBJ_>(this));
			HX_STACK_LINE(31)
			this->__children->push(child);
			HX_STACK_LINE(31)
			::flash::display::DisplayObjectContainer_obj::lime_doc_add_child(this->__handle,child->__handle);
		}
	}
	HX_STACK_LINE(32)
	return child;
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,addChild,return )

::flash::display::DisplayObject DisplayObjectContainer_obj::addChildAt( ::flash::display::DisplayObject child,int index){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","addChildAt",0x792dcb52,"flash.display.DisplayObjectContainer.addChildAt","flash/display/DisplayObjectContainer.hx",37,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(child,"child")
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(39)
	{
		HX_STACK_LINE(39)
		if (((child == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(39)
			HX_STACK_DO_THROW(HX_CSTRING("Adding to self"));
		}
		HX_STACK_LINE(39)
		if (((child->__parent == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(39)
			this->setChildIndex(child,(this->__children->length - (int)1));
		}
		else{
			HX_STACK_LINE(39)
			child->__setParent(hx::ObjectPtr<OBJ_>(this));
			HX_STACK_LINE(39)
			this->__children->push(child);
			HX_STACK_LINE(39)
			::flash::display::DisplayObjectContainer_obj::lime_doc_add_child(this->__handle,child->__handle);
		}
	}
	HX_STACK_LINE(40)
	{
		HX_STACK_LINE(40)
		if (((index > this->__children->length))){
			HX_STACK_LINE(40)
			HX_STACK_DO_THROW((HX_CSTRING("Invalid index position ") + index));
		}
		HX_STACK_LINE(40)
		int firstIndex = this->__getChildIndex(child);		HX_STACK_VAR(firstIndex,"firstIndex");
		HX_STACK_LINE(40)
		if (((firstIndex < (int)0))){
			HX_STACK_LINE(40)
			::String _g = child->toString();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(40)
			::String _g1 = (HX_CSTRING("setChildIndex : object ") + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(40)
			::String msg = (_g1 + HX_CSTRING(" not found."));		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(40)
			if (((child->__parent == hx::ObjectPtr<OBJ_>(this)))){
				HX_STACK_LINE(40)
				int actualIndex = (int)-1;		HX_STACK_VAR(actualIndex,"actualIndex");
				HX_STACK_LINE(40)
				{
					HX_STACK_LINE(40)
					int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(40)
					int _g2 = this->__children->length;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(40)
					while((true)){
						HX_STACK_LINE(40)
						if ((!(((_g11 < _g2))))){
							HX_STACK_LINE(40)
							break;
						}
						HX_STACK_LINE(40)
						int i = (_g11)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(40)
						if (((this->__children->__get(i).StaticCast< ::flash::display::DisplayObject >() == child))){
							HX_STACK_LINE(40)
							actualIndex = i;
							HX_STACK_LINE(40)
							break;
						}
					}
				}
				HX_STACK_LINE(40)
				if (((actualIndex != (int)-1))){
					HX_STACK_LINE(40)
					::String _g2 = ::Std_obj::string(actualIndex);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(40)
					::String _g3 = (HX_CSTRING("Internal error: Real child index was ") + _g2);		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(40)
					hx::AddEq(msg,_g3);
				}
				else{
					HX_STACK_LINE(40)
					hx::AddEq(msg,HX_CSTRING("Internal error: Child was not in __children array!"));
				}
			}
			HX_STACK_LINE(40)
			HX_STACK_DO_THROW(msg);
		}
		HX_STACK_LINE(40)
		::flash::display::DisplayObjectContainer_obj::lime_doc_set_child_index(this->__handle,child->__handle,index);
		HX_STACK_LINE(40)
		if (((index < firstIndex))){
			HX_STACK_LINE(40)
			int i = firstIndex;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(40)
			while((true)){
				HX_STACK_LINE(40)
				if ((!(((i > index))))){
					HX_STACK_LINE(40)
					break;
				}
				HX_STACK_LINE(40)
				this->__children[i] = this->__children->__get((i - (int)1)).StaticCast< ::flash::display::DisplayObject >();
				HX_STACK_LINE(40)
				(i)--;
			}
			HX_STACK_LINE(40)
			this->__children[index] = child;
		}
		else{
			HX_STACK_LINE(40)
			if (((firstIndex < index))){
				HX_STACK_LINE(40)
				int i = firstIndex;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(40)
				while((true)){
					HX_STACK_LINE(40)
					if ((!(((i < index))))){
						HX_STACK_LINE(40)
						break;
					}
					HX_STACK_LINE(40)
					this->__children[i] = this->__children->__get((i + (int)1)).StaticCast< ::flash::display::DisplayObject >();
					HX_STACK_LINE(40)
					(i)++;
				}
				HX_STACK_LINE(40)
				this->__children[index] = child;
			}
		}
	}
	HX_STACK_LINE(41)
	return child;
}


HX_DEFINE_DYNAMIC_FUNC2(DisplayObjectContainer_obj,addChildAt,return )

bool DisplayObjectContainer_obj::areInaccessibleObjectsUnderPoint( ::flash::geom::Point point){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","areInaccessibleObjectsUnderPoint",0xe271b301,"flash.display.DisplayObjectContainer.areInaccessibleObjectsUnderPoint","flash/display/DisplayObjectContainer.hx",48,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_LINE(48)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,areInaccessibleObjectsUnderPoint,return )

bool DisplayObjectContainer_obj::contains( ::flash::display::DisplayObject child){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","contains",0x38bcbee3,"flash.display.DisplayObjectContainer.contains","flash/display/DisplayObjectContainer.hx",55,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(child,"child")
	HX_STACK_LINE(55)
	return this->__contains(child);
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,contains,return )

::flash::display::DisplayObject DisplayObjectContainer_obj::getChildAt( int index){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","getChildAt",0x6105257d,"flash.display.DisplayObjectContainer.getChildAt","flash/display/DisplayObjectContainer.hx",60,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(62)
	if (((bool((index >= (int)0)) && bool((index < this->__children->length))))){
		HX_STACK_LINE(64)
		return this->__children->__get(index).StaticCast< ::flash::display::DisplayObject >();
	}
	HX_STACK_LINE(68)
	HX_STACK_DO_THROW(::flash::errors::RangeError_obj::__new((((HX_CSTRING("getChildAt : index out of bounds ") + index) + HX_CSTRING("/")) + this->__children->length)));
	HX_STACK_LINE(69)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,getChildAt,return )

::flash::display::DisplayObject DisplayObjectContainer_obj::getChildByName( ::String name){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","getChildByName",0x0f47094c,"flash.display.DisplayObjectContainer.getChildByName","flash/display/DisplayObjectContainer.hx",74,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(76)
	{
		HX_STACK_LINE(76)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(76)
		Array< ::Dynamic > _g1 = this->__children;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(76)
		while((true)){
			HX_STACK_LINE(76)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(76)
				break;
			}
			HX_STACK_LINE(76)
			::flash::display::DisplayObject child = _g1->__get(_g).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(child,"child");
			HX_STACK_LINE(76)
			++(_g);
			HX_STACK_LINE(78)
			::String _g2 = child->get_name();		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(78)
			if (((name == _g2))){
				HX_STACK_LINE(80)
				return child;
			}
		}
	}
	HX_STACK_LINE(86)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,getChildByName,return )

int DisplayObjectContainer_obj::getChildIndex( ::flash::display::DisplayObject child){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","getChildIndex",0xaf293cc8,"flash.display.DisplayObjectContainer.getChildIndex","flash/display/DisplayObjectContainer.hx",93,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(child,"child")
	HX_STACK_LINE(93)
	return this->__getChildIndex(child);
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,getChildIndex,return )

Array< ::Dynamic > DisplayObjectContainer_obj::getObjectsUnderPoint( ::flash::geom::Point point){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","getObjectsUnderPoint",0x02fc8b5a,"flash.display.DisplayObjectContainer.getObjectsUnderPoint","flash/display/DisplayObjectContainer.hx",98,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(point,"point")
	HX_STACK_LINE(101)
	::flash::display::Stage _g = this->get_stage();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(101)
	bool onStage = (_g != null());		HX_STACK_VAR(onStage,"onStage");
	HX_STACK_LINE(102)
	bool cacheVisible = this->get_visible();		HX_STACK_VAR(cacheVisible,"cacheVisible");
	HX_STACK_LINE(104)
	if ((!(onStage))){
		HX_STACK_LINE(106)
		this->set_visible(false);
		HX_STACK_LINE(107)
		::flash::Lib_obj::get_stage()->addChild(hx::ObjectPtr<OBJ_>(this));
	}
	HX_STACK_LINE(111)
	Array< ::Dynamic > result = Array_obj< ::Dynamic >::__new();		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(112)
	this->__getObjectsUnderPoint(point,result);
	HX_STACK_LINE(114)
	if ((!(onStage))){
		HX_STACK_LINE(116)
		::flash::Lib_obj::get_stage()->removeChild(hx::ObjectPtr<OBJ_>(this));
		HX_STACK_LINE(117)
		this->set_visible(cacheVisible);
	}
	HX_STACK_LINE(121)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,getObjectsUnderPoint,return )

::flash::display::DisplayObject DisplayObjectContainer_obj::removeChild( ::flash::display::DisplayObject child){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","removeChild",0x31307474,"flash.display.DisplayObjectContainer.removeChild","flash/display/DisplayObjectContainer.hx",126,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(child,"child")
	HX_STACK_LINE(128)
	int index = this->__getChildIndex(child);		HX_STACK_VAR(index,"index");
	HX_STACK_LINE(130)
	if (((index >= (int)0))){
		HX_STACK_LINE(132)
		child->__setParent(null());
		HX_STACK_LINE(133)
		return child;
	}
	HX_STACK_LINE(137)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,removeChild,return )

::flash::display::DisplayObject DisplayObjectContainer_obj::removeChildAt( int index){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","removeChildAt",0x358db287,"flash.display.DisplayObjectContainer.removeChildAt","flash/display/DisplayObjectContainer.hx",142,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(144)
	if (((bool((index >= (int)0)) && bool((index < this->__children->length))))){
		HX_STACK_LINE(146)
		::flash::display::DisplayObject result = this->__children->__get(index).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(147)
		result->__setParent(null());
		HX_STACK_LINE(148)
		return result;
	}
	HX_STACK_LINE(152)
	HX_STACK_DO_THROW(::flash::errors::ArgumentError_obj::__new(HX_CSTRING("The supplied DisplayObject must be a child of the caller."),null()));
	HX_STACK_LINE(152)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,removeChildAt,return )

Void DisplayObjectContainer_obj::removeChildren( hx::Null< int >  __o_beginIndex,hx::Null< int >  __o_endIndex){
int beginIndex = __o_beginIndex.Default(0);
int endIndex = __o_endIndex.Default(2147483647);
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","removeChildren",0xa693a567,"flash.display.DisplayObjectContainer.removeChildren","flash/display/DisplayObjectContainer.hx",157,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(beginIndex,"beginIndex")
	HX_STACK_ARG(endIndex,"endIndex")
{
		HX_STACK_LINE(159)
		if (((endIndex == (int)2147483647))){
			HX_STACK_LINE(161)
			endIndex = (this->__children->length - (int)1);
			HX_STACK_LINE(163)
			if (((endIndex < (int)0))){
				HX_STACK_LINE(165)
				return null();
			}
		}
		HX_STACK_LINE(171)
		if (((beginIndex > (this->__children->length - (int)1)))){
			HX_STACK_LINE(173)
			return null();
		}
		else{
			HX_STACK_LINE(175)
			if (((bool((bool((endIndex < beginIndex)) || bool((beginIndex < (int)0)))) || bool((endIndex > this->__children->length))))){
				HX_STACK_LINE(177)
				HX_STACK_DO_THROW(::flash::errors::RangeError_obj::__new(HX_CSTRING("The supplied index is out of bounds.")));
			}
		}
		HX_STACK_LINE(181)
		int numRemovals = (endIndex - beginIndex);		HX_STACK_VAR(numRemovals,"numRemovals");
		HX_STACK_LINE(182)
		while((true)){
			HX_STACK_LINE(182)
			if ((!(((numRemovals >= (int)0))))){
				HX_STACK_LINE(182)
				break;
			}
			HX_STACK_LINE(184)
			this->removeChildAt(beginIndex);
			HX_STACK_LINE(185)
			(numRemovals)--;
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(DisplayObjectContainer_obj,removeChildren,(void))

Void DisplayObjectContainer_obj::setChildIndex( ::flash::display::DisplayObject child,int index){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","setChildIndex",0xf42f1ed4,"flash.display.DisplayObjectContainer.setChildIndex","flash/display/DisplayObjectContainer.hx",194,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(child,"child")
		HX_STACK_ARG(index,"index")
		HX_STACK_LINE(194)
		if (((index > this->__children->length))){
			HX_STACK_LINE(194)
			HX_STACK_DO_THROW((HX_CSTRING("Invalid index position ") + index));
		}
		HX_STACK_LINE(194)
		int firstIndex = this->__getChildIndex(child);		HX_STACK_VAR(firstIndex,"firstIndex");
		HX_STACK_LINE(194)
		if (((firstIndex < (int)0))){
			HX_STACK_LINE(194)
			::String _g = child->toString();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(194)
			::String _g1 = (HX_CSTRING("setChildIndex : object ") + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(194)
			::String msg = (_g1 + HX_CSTRING(" not found."));		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(194)
			if (((child->__parent == hx::ObjectPtr<OBJ_>(this)))){
				HX_STACK_LINE(194)
				int actualIndex = (int)-1;		HX_STACK_VAR(actualIndex,"actualIndex");
				HX_STACK_LINE(194)
				{
					HX_STACK_LINE(194)
					int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(194)
					int _g2 = this->__children->length;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(194)
					while((true)){
						HX_STACK_LINE(194)
						if ((!(((_g11 < _g2))))){
							HX_STACK_LINE(194)
							break;
						}
						HX_STACK_LINE(194)
						int i = (_g11)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(194)
						if (((this->__children->__get(i).StaticCast< ::flash::display::DisplayObject >() == child))){
							HX_STACK_LINE(194)
							actualIndex = i;
							HX_STACK_LINE(194)
							break;
						}
					}
				}
				HX_STACK_LINE(194)
				if (((actualIndex != (int)-1))){
					HX_STACK_LINE(194)
					::String _g2 = ::Std_obj::string(actualIndex);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(194)
					::String _g3 = (HX_CSTRING("Internal error: Real child index was ") + _g2);		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(194)
					hx::AddEq(msg,_g3);
				}
				else{
					HX_STACK_LINE(194)
					hx::AddEq(msg,HX_CSTRING("Internal error: Child was not in __children array!"));
				}
			}
			HX_STACK_LINE(194)
			HX_STACK_DO_THROW(msg);
		}
		HX_STACK_LINE(194)
		::flash::display::DisplayObjectContainer_obj::lime_doc_set_child_index(this->__handle,child->__handle,index);
		HX_STACK_LINE(194)
		if (((index < firstIndex))){
			HX_STACK_LINE(194)
			int i = firstIndex;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(194)
			while((true)){
				HX_STACK_LINE(194)
				if ((!(((i > index))))){
					HX_STACK_LINE(194)
					break;
				}
				HX_STACK_LINE(194)
				this->__children[i] = this->__children->__get((i - (int)1)).StaticCast< ::flash::display::DisplayObject >();
				HX_STACK_LINE(194)
				(i)--;
			}
			HX_STACK_LINE(194)
			this->__children[index] = child;
		}
		else{
			HX_STACK_LINE(194)
			if (((firstIndex < index))){
				HX_STACK_LINE(194)
				int i = firstIndex;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(194)
				while((true)){
					HX_STACK_LINE(194)
					if ((!(((i < index))))){
						HX_STACK_LINE(194)
						break;
					}
					HX_STACK_LINE(194)
					this->__children[i] = this->__children->__get((i + (int)1)).StaticCast< ::flash::display::DisplayObject >();
					HX_STACK_LINE(194)
					(i)++;
				}
				HX_STACK_LINE(194)
				this->__children[index] = child;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(DisplayObjectContainer_obj,setChildIndex,(void))

Void DisplayObjectContainer_obj::swapChildren( ::flash::display::DisplayObject child1,::flash::display::DisplayObject child2){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","swapChildren",0x8da061b6,"flash.display.DisplayObjectContainer.swapChildren","flash/display/DisplayObjectContainer.hx",199,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(child1,"child1")
		HX_STACK_ARG(child2,"child2")
		HX_STACK_LINE(201)
		int index1 = this->__getChildIndex(child1);		HX_STACK_VAR(index1,"index1");
		HX_STACK_LINE(202)
		int index2 = this->__getChildIndex(child2);		HX_STACK_VAR(index2,"index2");
		HX_STACK_LINE(204)
		if (((bool((index1 < (int)0)) || bool((index2 < (int)0))))){
			HX_STACK_LINE(206)
			HX_STACK_DO_THROW(HX_CSTRING("swapChildren:Could not find children"));
		}
		HX_STACK_LINE(210)
		{
			HX_STACK_LINE(210)
			if (((bool((bool((bool((index1 < (int)0)) || bool((index2 < (int)0)))) || bool((index1 > this->__children->length)))) || bool((index2 > this->__children->length))))){
				HX_STACK_LINE(210)
				HX_STACK_DO_THROW(::flash::errors::RangeError_obj::__new(HX_CSTRING("swapChildrenAt : index out of bounds")));
			}
			HX_STACK_LINE(210)
			if (((index1 != index2))){
				HX_STACK_LINE(210)
				::flash::display::DisplayObject temp = this->__children->__get(index1).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(temp,"temp");
				HX_STACK_LINE(210)
				this->__children[index1] = this->__children->__get(index2).StaticCast< ::flash::display::DisplayObject >();
				HX_STACK_LINE(210)
				this->__children[index2] = temp;
				HX_STACK_LINE(210)
				::flash::display::DisplayObjectContainer_obj::lime_doc_swap_children(this->__handle,index1,index2);
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(DisplayObjectContainer_obj,swapChildren,(void))

Void DisplayObjectContainer_obj::swapChildrenAt( int index1,int index2){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","swapChildrenAt",0x7fc4f449,"flash.display.DisplayObjectContainer.swapChildrenAt","flash/display/DisplayObjectContainer.hx",217,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(index1,"index1")
		HX_STACK_ARG(index2,"index2")
		HX_STACK_LINE(217)
		if (((bool((bool((bool((index1 < (int)0)) || bool((index2 < (int)0)))) || bool((index1 > this->__children->length)))) || bool((index2 > this->__children->length))))){
			HX_STACK_LINE(217)
			HX_STACK_DO_THROW(::flash::errors::RangeError_obj::__new(HX_CSTRING("swapChildrenAt : index out of bounds")));
		}
		HX_STACK_LINE(217)
		if (((index1 != index2))){
			HX_STACK_LINE(217)
			::flash::display::DisplayObject temp = this->__children->__get(index1).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(temp,"temp");
			HX_STACK_LINE(217)
			this->__children[index1] = this->__children->__get(index2).StaticCast< ::flash::display::DisplayObject >();
			HX_STACK_LINE(217)
			this->__children[index2] = temp;
			HX_STACK_LINE(217)
			::flash::display::DisplayObjectContainer_obj::lime_doc_swap_children(this->__handle,index1,index2);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(DisplayObjectContainer_obj,swapChildrenAt,(void))

Void DisplayObjectContainer_obj::__addChild( ::flash::display::DisplayObject child){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__addChild",0x0d46609f,"flash.display.DisplayObjectContainer.__addChild","flash/display/DisplayObjectContainer.hx",222,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(child,"child")
		HX_STACK_LINE(224)
		if (((child == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(226)
			HX_STACK_DO_THROW(HX_CSTRING("Adding to self"));
		}
		HX_STACK_LINE(230)
		if (((child->__parent == hx::ObjectPtr<OBJ_>(this)))){
			HX_STACK_LINE(232)
			this->setChildIndex(child,(this->__children->length - (int)1));
		}
		else{
			HX_STACK_LINE(236)
			child->__setParent(hx::ObjectPtr<OBJ_>(this));
			HX_STACK_LINE(237)
			this->__children->push(child);
			HX_STACK_LINE(238)
			::flash::display::DisplayObjectContainer_obj::lime_doc_add_child(this->__handle,child->__handle);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,__addChild,(void))

Void DisplayObjectContainer_obj::__broadcast( ::flash::events::Event event){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__broadcast",0xfa88d99d,"flash.display.DisplayObjectContainer.__broadcast","flash/display/DisplayObjectContainer.hx",245,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(event,"event")
		HX_STACK_LINE(247)
		int i = (int)0;		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(249)
		if (((this->__children->length > (int)0))){
			HX_STACK_LINE(251)
			::flash::display::DisplayObject child;		HX_STACK_VAR(child,"child");
			HX_STACK_LINE(253)
			while((true)){
				HX_STACK_LINE(255)
				child = this->__children->__get(i).StaticCast< ::flash::display::DisplayObject >();
				HX_STACK_LINE(256)
				child->__broadcast(event);
				HX_STACK_LINE(258)
				if (((i >= this->__children->length))){
					HX_STACK_LINE(260)
					break;
				}
				HX_STACK_LINE(264)
				if (((this->__children->__get(i).StaticCast< ::flash::display::DisplayObject >() == child))){
					HX_STACK_LINE(266)
					(i)++;
					HX_STACK_LINE(268)
					if (((i >= this->__children->length))){
						HX_STACK_LINE(270)
						break;
					}
				}
			}
		}
		HX_STACK_LINE(280)
		this->super::__broadcast(event);
	}
return null();
}


bool DisplayObjectContainer_obj::__contains( ::flash::display::DisplayObject child){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","__contains",0x7aaaeb03,"flash.display.DisplayObjectContainer.__contains","flash/display/DisplayObjectContainer.hx",285,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(child,"child")
	HX_STACK_LINE(287)
	if (((child == null()))){
		HX_STACK_LINE(289)
		return false;
	}
	HX_STACK_LINE(293)
	if (((hx::ObjectPtr<OBJ_>(this) == child))){
		HX_STACK_LINE(295)
		return true;
	}
	HX_STACK_LINE(299)
	{
		HX_STACK_LINE(299)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(299)
		Array< ::Dynamic > _g1 = this->__children;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(299)
		while((true)){
			HX_STACK_LINE(299)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(299)
				break;
			}
			HX_STACK_LINE(299)
			::flash::display::DisplayObject c = _g1->__get(_g).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(c,"c");
			HX_STACK_LINE(299)
			++(_g);
			HX_STACK_LINE(301)
			if (((  ((!(((c == child))))) ? bool(c->__contains(child)) : bool(true) ))){
				HX_STACK_LINE(303)
				return true;
			}
		}
	}
	HX_STACK_LINE(309)
	return false;
}


::flash::display::DisplayObject DisplayObjectContainer_obj::__findByID( int id){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","__findByID",0xe1e6972f,"flash.display.DisplayObjectContainer.__findByID","flash/display/DisplayObjectContainer.hx",314,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(id,"id")
	HX_STACK_LINE(316)
	if (((this->__id == id))){
		HX_STACK_LINE(318)
		return hx::ObjectPtr<OBJ_>(this);
	}
	HX_STACK_LINE(322)
	::flash::display::DisplayObject found;		HX_STACK_VAR(found,"found");
	HX_STACK_LINE(324)
	{
		HX_STACK_LINE(324)
		int _g = (int)0;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(324)
		Array< ::Dynamic > _g1 = this->__children;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(324)
		while((true)){
			HX_STACK_LINE(324)
			if ((!(((_g < _g1->length))))){
				HX_STACK_LINE(324)
				break;
			}
			HX_STACK_LINE(324)
			::flash::display::DisplayObject child = _g1->__get(_g).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(child,"child");
			HX_STACK_LINE(324)
			++(_g);
			HX_STACK_LINE(326)
			::flash::display::DisplayObject _g2 = child->__findByID(id);		HX_STACK_VAR(_g2,"_g2");
			HX_STACK_LINE(326)
			found = _g2;
			HX_STACK_LINE(328)
			if (((found != null()))){
				HX_STACK_LINE(330)
				return found;
			}
		}
	}
	HX_STACK_LINE(336)
	return this->super::__findByID(id);
}


int DisplayObjectContainer_obj::__getChildIndex( ::flash::display::DisplayObject child){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","__getChildIndex",0x2dc71ca8,"flash.display.DisplayObjectContainer.__getChildIndex","flash/display/DisplayObjectContainer.hx",341,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(child,"child")
	HX_STACK_LINE(343)
	{
		HX_STACK_LINE(343)
		int _g1 = (int)0;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(343)
		int _g = this->__children->length;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(343)
		while((true)){
			HX_STACK_LINE(343)
			if ((!(((_g1 < _g))))){
				HX_STACK_LINE(343)
				break;
			}
			HX_STACK_LINE(343)
			int i = (_g1)++;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(345)
			if (((this->__children->__get(i).StaticCast< ::flash::display::DisplayObject >() == child))){
				HX_STACK_LINE(347)
				return i;
			}
		}
	}
	HX_STACK_LINE(353)
	return (int)-1;
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,__getChildIndex,return )

Void DisplayObjectContainer_obj::__getObjectsUnderPoint( ::flash::geom::Point point,Array< ::Dynamic > result){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__getObjectsUnderPoint",0x3f8c677a,"flash.display.DisplayObjectContainer.__getObjectsUnderPoint","flash/display/DisplayObjectContainer.hx",358,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(point,"point")
		HX_STACK_ARG(result,"result")
		HX_STACK_LINE(360)
		this->super::__getObjectsUnderPoint(point,result);
		HX_STACK_LINE(362)
		{
			HX_STACK_LINE(362)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(362)
			Array< ::Dynamic > _g1 = this->__children;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(362)
			while((true)){
				HX_STACK_LINE(362)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(362)
					break;
				}
				HX_STACK_LINE(362)
				::flash::display::DisplayObject child = _g1->__get(_g).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(child,"child");
				HX_STACK_LINE(362)
				++(_g);
				HX_STACK_LINE(364)
				child->__getObjectsUnderPoint(point,result);
			}
		}
	}
return null();
}


Void DisplayObjectContainer_obj::__onAdded( ::flash::display::DisplayObject object,bool isOnStage){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__onAdded",0xe0c68abd,"flash.display.DisplayObjectContainer.__onAdded","flash/display/DisplayObjectContainer.hx",371,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(object,"object")
		HX_STACK_ARG(isOnStage,"isOnStage")
		HX_STACK_LINE(373)
		this->super::__onAdded(object,isOnStage);
		HX_STACK_LINE(375)
		{
			HX_STACK_LINE(375)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(375)
			Array< ::Dynamic > _g1 = this->__children;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(375)
			while((true)){
				HX_STACK_LINE(375)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(375)
					break;
				}
				HX_STACK_LINE(375)
				::flash::display::DisplayObject child = _g1->__get(_g).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(child,"child");
				HX_STACK_LINE(375)
				++(_g);
				HX_STACK_LINE(377)
				child->__onAdded(object,isOnStage);
			}
		}
	}
return null();
}


Void DisplayObjectContainer_obj::__onRemoved( ::flash::display::DisplayObject object,bool wasOnStage){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__onRemoved",0xe61a0edd,"flash.display.DisplayObjectContainer.__onRemoved","flash/display/DisplayObjectContainer.hx",384,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(object,"object")
		HX_STACK_ARG(wasOnStage,"wasOnStage")
		HX_STACK_LINE(386)
		this->super::__onRemoved(object,wasOnStage);
		HX_STACK_LINE(388)
		{
			HX_STACK_LINE(388)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(388)
			Array< ::Dynamic > _g1 = this->__children;		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(388)
			while((true)){
				HX_STACK_LINE(388)
				if ((!(((_g < _g1->length))))){
					HX_STACK_LINE(388)
					break;
				}
				HX_STACK_LINE(388)
				::flash::display::DisplayObject child = _g1->__get(_g).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(child,"child");
				HX_STACK_LINE(388)
				++(_g);
				HX_STACK_LINE(390)
				child->__onRemoved(object,wasOnStage);
			}
		}
	}
return null();
}


Void DisplayObjectContainer_obj::__removeChildFromArray( ::flash::display::DisplayObject child){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__removeChildFromArray",0xc15a70db,"flash.display.DisplayObjectContainer.__removeChildFromArray","flash/display/DisplayObjectContainer.hx",397,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(child,"child")
		HX_STACK_LINE(399)
		int i = this->__getChildIndex(child);		HX_STACK_VAR(i,"i");
		HX_STACK_LINE(401)
		if (((i >= (int)0))){
			HX_STACK_LINE(403)
			::flash::display::DisplayObjectContainer_obj::lime_doc_remove_child(this->__handle,i);
			HX_STACK_LINE(404)
			this->__children->splice(i,(int)1);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,__removeChildFromArray,(void))

Void DisplayObjectContainer_obj::__setChildIndex( ::flash::display::DisplayObject child,int index){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__setChildIndex",0x72ccfeb4,"flash.display.DisplayObjectContainer.__setChildIndex","flash/display/DisplayObjectContainer.hx",411,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(child,"child")
		HX_STACK_ARG(index,"index")
		HX_STACK_LINE(413)
		if (((index > this->__children->length))){
			HX_STACK_LINE(415)
			HX_STACK_DO_THROW((HX_CSTRING("Invalid index position ") + index));
		}
		HX_STACK_LINE(419)
		int firstIndex = this->__getChildIndex(child);		HX_STACK_VAR(firstIndex,"firstIndex");
		HX_STACK_LINE(421)
		if (((firstIndex < (int)0))){
			HX_STACK_LINE(423)
			::String _g = child->toString();		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(423)
			::String _g1 = (HX_CSTRING("setChildIndex : object ") + _g);		HX_STACK_VAR(_g1,"_g1");
			HX_STACK_LINE(423)
			::String msg = (_g1 + HX_CSTRING(" not found."));		HX_STACK_VAR(msg,"msg");
			HX_STACK_LINE(425)
			if (((child->__parent == hx::ObjectPtr<OBJ_>(this)))){
				HX_STACK_LINE(427)
				int actualIndex = (int)-1;		HX_STACK_VAR(actualIndex,"actualIndex");
				HX_STACK_LINE(429)
				{
					HX_STACK_LINE(429)
					int _g11 = (int)0;		HX_STACK_VAR(_g11,"_g11");
					HX_STACK_LINE(429)
					int _g2 = this->__children->length;		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(429)
					while((true)){
						HX_STACK_LINE(429)
						if ((!(((_g11 < _g2))))){
							HX_STACK_LINE(429)
							break;
						}
						HX_STACK_LINE(429)
						int i = (_g11)++;		HX_STACK_VAR(i,"i");
						HX_STACK_LINE(431)
						if (((this->__children->__get(i).StaticCast< ::flash::display::DisplayObject >() == child))){
							HX_STACK_LINE(433)
							actualIndex = i;
							HX_STACK_LINE(434)
							break;
						}
					}
				}
				HX_STACK_LINE(440)
				if (((actualIndex != (int)-1))){
					HX_STACK_LINE(442)
					::String _g2 = ::Std_obj::string(actualIndex);		HX_STACK_VAR(_g2,"_g2");
					HX_STACK_LINE(442)
					::String _g3 = (HX_CSTRING("Internal error: Real child index was ") + _g2);		HX_STACK_VAR(_g3,"_g3");
					HX_STACK_LINE(442)
					hx::AddEq(msg,_g3);
				}
				else{
					HX_STACK_LINE(446)
					hx::AddEq(msg,HX_CSTRING("Internal error: Child was not in __children array!"));
				}
			}
			HX_STACK_LINE(452)
			HX_STACK_DO_THROW(msg);
		}
		HX_STACK_LINE(456)
		::flash::display::DisplayObjectContainer_obj::lime_doc_set_child_index(this->__handle,child->__handle,index);
		HX_STACK_LINE(458)
		if (((index < firstIndex))){
			HX_STACK_LINE(460)
			int i = firstIndex;		HX_STACK_VAR(i,"i");
			HX_STACK_LINE(462)
			while((true)){
				HX_STACK_LINE(462)
				if ((!(((i > index))))){
					HX_STACK_LINE(462)
					break;
				}
				HX_STACK_LINE(464)
				this->__children[i] = this->__children->__get((i - (int)1)).StaticCast< ::flash::display::DisplayObject >();
				HX_STACK_LINE(465)
				(i)--;
			}
			HX_STACK_LINE(469)
			this->__children[index] = child;
		}
		else{
			HX_STACK_LINE(471)
			if (((firstIndex < index))){
				HX_STACK_LINE(473)
				int i = firstIndex;		HX_STACK_VAR(i,"i");
				HX_STACK_LINE(475)
				while((true)){
					HX_STACK_LINE(475)
					if ((!(((i < index))))){
						HX_STACK_LINE(475)
						break;
					}
					HX_STACK_LINE(477)
					this->__children[i] = this->__children->__get((i + (int)1)).StaticCast< ::flash::display::DisplayObject >();
					HX_STACK_LINE(478)
					(i)++;
				}
				HX_STACK_LINE(482)
				this->__children[index] = child;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(DisplayObjectContainer_obj,__setChildIndex,(void))

Void DisplayObjectContainer_obj::__swapChildrenAt( int index1,int index2){
{
		HX_STACK_FRAME("flash.display.DisplayObjectContainer","__swapChildrenAt",0xcb4af869,"flash.display.DisplayObjectContainer.__swapChildrenAt","flash/display/DisplayObjectContainer.hx",489,0xf1925792)
		HX_STACK_THIS(this)
		HX_STACK_ARG(index1,"index1")
		HX_STACK_ARG(index2,"index2")
		HX_STACK_LINE(491)
		if (((bool((bool((bool((index1 < (int)0)) || bool((index2 < (int)0)))) || bool((index1 > this->__children->length)))) || bool((index2 > this->__children->length))))){
			HX_STACK_LINE(493)
			HX_STACK_DO_THROW(::flash::errors::RangeError_obj::__new(HX_CSTRING("swapChildrenAt : index out of bounds")));
		}
		HX_STACK_LINE(497)
		if (((index1 != index2))){
			HX_STACK_LINE(499)
			::flash::display::DisplayObject temp = this->__children->__get(index1).StaticCast< ::flash::display::DisplayObject >();		HX_STACK_VAR(temp,"temp");
			HX_STACK_LINE(500)
			this->__children[index1] = this->__children->__get(index2).StaticCast< ::flash::display::DisplayObject >();
			HX_STACK_LINE(501)
			this->__children[index2] = temp;
			HX_STACK_LINE(502)
			::flash::display::DisplayObjectContainer_obj::lime_doc_swap_children(this->__handle,index1,index2);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(DisplayObjectContainer_obj,__swapChildrenAt,(void))

bool DisplayObjectContainer_obj::get_mouseChildren( ){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","get_mouseChildren",0x39510697,"flash.display.DisplayObjectContainer.get_mouseChildren","flash/display/DisplayObjectContainer.hx",516,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_LINE(516)
	return ::flash::display::DisplayObjectContainer_obj::lime_doc_get_mouse_children(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(DisplayObjectContainer_obj,get_mouseChildren,return )

bool DisplayObjectContainer_obj::set_mouseChildren( bool value){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","set_mouseChildren",0x5cbedea3,"flash.display.DisplayObjectContainer.set_mouseChildren","flash/display/DisplayObjectContainer.hx",517,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(519)
	::flash::display::DisplayObjectContainer_obj::lime_doc_set_mouse_children(this->__handle,value);
	HX_STACK_LINE(520)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,set_mouseChildren,return )

int DisplayObjectContainer_obj::get_numChildren( ){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","get_numChildren",0x0a749cf8,"flash.display.DisplayObjectContainer.get_numChildren","flash/display/DisplayObjectContainer.hx",525,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_LINE(525)
	return this->__children->length;
}


HX_DEFINE_DYNAMIC_FUNC0(DisplayObjectContainer_obj,get_numChildren,return )

bool DisplayObjectContainer_obj::get_tabChildren( ){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","get_tabChildren",0xf97a4007,"flash.display.DisplayObjectContainer.get_tabChildren","flash/display/DisplayObjectContainer.hx",526,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_LINE(526)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC0(DisplayObjectContainer_obj,get_tabChildren,return )

bool DisplayObjectContainer_obj::set_tabChildren( bool value){
	HX_STACK_FRAME("flash.display.DisplayObjectContainer","set_tabChildren",0xf545bd13,"flash.display.DisplayObjectContainer.set_tabChildren","flash/display/DisplayObjectContainer.hx",527,0xf1925792)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(527)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(DisplayObjectContainer_obj,set_tabChildren,return )

Dynamic DisplayObjectContainer_obj::lime_create_display_object_container;

Dynamic DisplayObjectContainer_obj::lime_doc_add_child;

Dynamic DisplayObjectContainer_obj::lime_doc_remove_child;

Dynamic DisplayObjectContainer_obj::lime_doc_set_child_index;

Dynamic DisplayObjectContainer_obj::lime_doc_get_mouse_children;

Dynamic DisplayObjectContainer_obj::lime_doc_set_mouse_children;

Dynamic DisplayObjectContainer_obj::lime_doc_swap_children;


DisplayObjectContainer_obj::DisplayObjectContainer_obj()
{
}

void DisplayObjectContainer_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DisplayObjectContainer);
	HX_MARK_MEMBER_NAME(numChildren,"numChildren");
	HX_MARK_MEMBER_NAME(__children,"__children");
	::flash::display::DisplayObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void DisplayObjectContainer_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(numChildren,"numChildren");
	HX_VISIT_MEMBER_NAME(__children,"__children");
	::flash::display::DisplayObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic DisplayObjectContainer_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 8:
		if (HX_FIELD_EQ(inName,"addChild") ) { return addChild_dyn(); }
		if (HX_FIELD_EQ(inName,"contains") ) { return contains_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"__onAdded") ) { return __onAdded_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"__children") ) { return __children; }
		if (HX_FIELD_EQ(inName,"addChildAt") ) { return addChildAt_dyn(); }
		if (HX_FIELD_EQ(inName,"getChildAt") ) { return getChildAt_dyn(); }
		if (HX_FIELD_EQ(inName,"__addChild") ) { return __addChild_dyn(); }
		if (HX_FIELD_EQ(inName,"__contains") ) { return __contains_dyn(); }
		if (HX_FIELD_EQ(inName,"__findByID") ) { return __findByID_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"numChildren") ) { return inCallProp ? get_numChildren() : numChildren; }
		if (HX_FIELD_EQ(inName,"tabChildren") ) { return get_tabChildren(); }
		if (HX_FIELD_EQ(inName,"removeChild") ) { return removeChild_dyn(); }
		if (HX_FIELD_EQ(inName,"__broadcast") ) { return __broadcast_dyn(); }
		if (HX_FIELD_EQ(inName,"__onRemoved") ) { return __onRemoved_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"swapChildren") ) { return swapChildren_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"mouseChildren") ) { return get_mouseChildren(); }
		if (HX_FIELD_EQ(inName,"getChildIndex") ) { return getChildIndex_dyn(); }
		if (HX_FIELD_EQ(inName,"removeChildAt") ) { return removeChildAt_dyn(); }
		if (HX_FIELD_EQ(inName,"setChildIndex") ) { return setChildIndex_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"getChildByName") ) { return getChildByName_dyn(); }
		if (HX_FIELD_EQ(inName,"removeChildren") ) { return removeChildren_dyn(); }
		if (HX_FIELD_EQ(inName,"swapChildrenAt") ) { return swapChildrenAt_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"__getChildIndex") ) { return __getChildIndex_dyn(); }
		if (HX_FIELD_EQ(inName,"__setChildIndex") ) { return __setChildIndex_dyn(); }
		if (HX_FIELD_EQ(inName,"get_numChildren") ) { return get_numChildren_dyn(); }
		if (HX_FIELD_EQ(inName,"get_tabChildren") ) { return get_tabChildren_dyn(); }
		if (HX_FIELD_EQ(inName,"set_tabChildren") ) { return set_tabChildren_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"__swapChildrenAt") ) { return __swapChildrenAt_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"get_mouseChildren") ) { return get_mouseChildren_dyn(); }
		if (HX_FIELD_EQ(inName,"set_mouseChildren") ) { return set_mouseChildren_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"lime_doc_add_child") ) { return lime_doc_add_child; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"getObjectsUnderPoint") ) { return getObjectsUnderPoint_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"lime_doc_remove_child") ) { return lime_doc_remove_child; }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"lime_doc_swap_children") ) { return lime_doc_swap_children; }
		if (HX_FIELD_EQ(inName,"__getObjectsUnderPoint") ) { return __getObjectsUnderPoint_dyn(); }
		if (HX_FIELD_EQ(inName,"__removeChildFromArray") ) { return __removeChildFromArray_dyn(); }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_doc_set_child_index") ) { return lime_doc_set_child_index; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_doc_get_mouse_children") ) { return lime_doc_get_mouse_children; }
		if (HX_FIELD_EQ(inName,"lime_doc_set_mouse_children") ) { return lime_doc_set_mouse_children; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"areInaccessibleObjectsUnderPoint") ) { return areInaccessibleObjectsUnderPoint_dyn(); }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"lime_create_display_object_container") ) { return lime_create_display_object_container; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic DisplayObjectContainer_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"__children") ) { __children=inValue.Cast< Array< ::Dynamic > >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"numChildren") ) { numChildren=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"tabChildren") ) { return set_tabChildren(inValue); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"mouseChildren") ) { return set_mouseChildren(inValue); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"lime_doc_add_child") ) { lime_doc_add_child=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"lime_doc_remove_child") ) { lime_doc_remove_child=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"lime_doc_swap_children") ) { lime_doc_swap_children=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_doc_set_child_index") ) { lime_doc_set_child_index=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_doc_get_mouse_children") ) { lime_doc_get_mouse_children=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_doc_set_mouse_children") ) { lime_doc_set_mouse_children=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"lime_create_display_object_container") ) { lime_create_display_object_container=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DisplayObjectContainer_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("mouseChildren"));
	outFields->push(HX_CSTRING("numChildren"));
	outFields->push(HX_CSTRING("tabChildren"));
	outFields->push(HX_CSTRING("__children"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("lime_create_display_object_container"),
	HX_CSTRING("lime_doc_add_child"),
	HX_CSTRING("lime_doc_remove_child"),
	HX_CSTRING("lime_doc_set_child_index"),
	HX_CSTRING("lime_doc_get_mouse_children"),
	HX_CSTRING("lime_doc_set_mouse_children"),
	HX_CSTRING("lime_doc_swap_children"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsInt,(int)offsetof(DisplayObjectContainer_obj,numChildren),HX_CSTRING("numChildren")},
	{hx::fsObject /*Array< ::Dynamic >*/ ,(int)offsetof(DisplayObjectContainer_obj,__children),HX_CSTRING("__children")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("numChildren"),
	HX_CSTRING("__children"),
	HX_CSTRING("addChild"),
	HX_CSTRING("addChildAt"),
	HX_CSTRING("areInaccessibleObjectsUnderPoint"),
	HX_CSTRING("contains"),
	HX_CSTRING("getChildAt"),
	HX_CSTRING("getChildByName"),
	HX_CSTRING("getChildIndex"),
	HX_CSTRING("getObjectsUnderPoint"),
	HX_CSTRING("removeChild"),
	HX_CSTRING("removeChildAt"),
	HX_CSTRING("removeChildren"),
	HX_CSTRING("setChildIndex"),
	HX_CSTRING("swapChildren"),
	HX_CSTRING("swapChildrenAt"),
	HX_CSTRING("__addChild"),
	HX_CSTRING("__broadcast"),
	HX_CSTRING("__contains"),
	HX_CSTRING("__findByID"),
	HX_CSTRING("__getChildIndex"),
	HX_CSTRING("__getObjectsUnderPoint"),
	HX_CSTRING("__onAdded"),
	HX_CSTRING("__onRemoved"),
	HX_CSTRING("__removeChildFromArray"),
	HX_CSTRING("__setChildIndex"),
	HX_CSTRING("__swapChildrenAt"),
	HX_CSTRING("get_mouseChildren"),
	HX_CSTRING("set_mouseChildren"),
	HX_CSTRING("get_numChildren"),
	HX_CSTRING("get_tabChildren"),
	HX_CSTRING("set_tabChildren"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::lime_create_display_object_container,"lime_create_display_object_container");
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_add_child,"lime_doc_add_child");
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_remove_child,"lime_doc_remove_child");
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_set_child_index,"lime_doc_set_child_index");
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_get_mouse_children,"lime_doc_get_mouse_children");
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_set_mouse_children,"lime_doc_set_mouse_children");
	HX_MARK_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_swap_children,"lime_doc_swap_children");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::lime_create_display_object_container,"lime_create_display_object_container");
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_add_child,"lime_doc_add_child");
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_remove_child,"lime_doc_remove_child");
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_set_child_index,"lime_doc_set_child_index");
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_get_mouse_children,"lime_doc_get_mouse_children");
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_set_mouse_children,"lime_doc_set_mouse_children");
	HX_VISIT_MEMBER_NAME(DisplayObjectContainer_obj::lime_doc_swap_children,"lime_doc_swap_children");
};

#endif

Class DisplayObjectContainer_obj::__mClass;

void DisplayObjectContainer_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.display.DisplayObjectContainer"), hx::TCanCast< DisplayObjectContainer_obj> ,sStaticFields,sMemberFields,
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

void DisplayObjectContainer_obj::__boot()
{
	lime_create_display_object_container= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_create_display_object_container"),(int)0);
	lime_doc_add_child= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_doc_add_child"),(int)2);
	lime_doc_remove_child= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_doc_remove_child"),(int)2);
	lime_doc_set_child_index= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_doc_set_child_index"),(int)3);
	lime_doc_get_mouse_children= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_doc_get_mouse_children"),(int)1);
	lime_doc_set_mouse_children= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_doc_set_mouse_children"),(int)2);
	lime_doc_swap_children= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_doc_swap_children"),(int)3);
}

} // end namespace flash
} // end namespace display
