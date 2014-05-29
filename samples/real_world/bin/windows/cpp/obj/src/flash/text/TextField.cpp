#include <hxcpp.h>

#ifndef INCLUDED_StringTools
#include <StringTools.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_display_DisplayObject
#include <flash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_flash_display_IBitmapDrawable
#include <flash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_flash_display_InteractiveObject
#include <flash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_text_AntiAliasType
#include <flash/text/AntiAliasType.h>
#endif
#ifndef INCLUDED_flash_text_GridFitType
#include <flash/text/GridFitType.h>
#endif
#ifndef INCLUDED_flash_text_TextField
#include <flash/text/TextField.h>
#endif
#ifndef INCLUDED_flash_text_TextFieldAutoSize
#include <flash/text/TextFieldAutoSize.h>
#endif
#ifndef INCLUDED_flash_text_TextFieldType
#include <flash/text/TextFieldType.h>
#endif
#ifndef INCLUDED_flash_text_TextFormat
#include <flash/text/TextFormat.h>
#endif
#ifndef INCLUDED_flash_text_TextLineMetrics
#include <flash/text/TextLineMetrics.h>
#endif
namespace flash{
namespace text{

Void TextField_obj::__construct()
{
HX_STACK_FRAME("flash.text.TextField","new",0x0e7e789c,"flash.text.TextField.new","flash/text/TextField.hx",40,0x93e6fab4)
HX_STACK_THIS(this)
{
	HX_STACK_LINE(42)
	Dynamic _g = ::flash::text::TextField_obj::lime_text_field_create();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(42)
	super::__construct(_g,HX_CSTRING("TextField"));
	HX_STACK_LINE(44)
	this->gridFitType = ::flash::text::GridFitType_obj::PIXEL;
	HX_STACK_LINE(45)
	this->sharpness = (int)0;
}
;
	return null();
}

//TextField_obj::~TextField_obj() { }

Dynamic TextField_obj::__CreateEmpty() { return  new TextField_obj; }
hx::ObjectPtr< TextField_obj > TextField_obj::__new()
{  hx::ObjectPtr< TextField_obj > result = new TextField_obj();
	result->__construct();
	return result;}

Dynamic TextField_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< TextField_obj > result = new TextField_obj();
	result->__construct();
	return result;}

Void TextField_obj::appendText( ::String text){
{
		HX_STACK_FRAME("flash.text.TextField","appendText",0x48d2e6eb,"flash.text.TextField.appendText","flash/text/TextField.hx",50,0x93e6fab4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(text,"text")
		HX_STACK_LINE(52)
		::String _g = ::flash::text::TextField_obj::lime_text_field_get_text(this->__handle);		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(52)
		::String _g1 = (_g + text);		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(52)
		::flash::text::TextField_obj::lime_text_field_set_text(this->__handle,_g1);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,appendText,(void))

int TextField_obj::getLineOffset( int lineIndex){
	HX_STACK_FRAME("flash.text.TextField","getLineOffset",0xe287ba19,"flash.text.TextField.getLineOffset","flash/text/TextField.hx",59,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(lineIndex,"lineIndex")
	HX_STACK_LINE(59)
	return ::flash::text::TextField_obj::lime_text_field_get_line_offset(this->__handle,lineIndex);
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,getLineOffset,return )

::String TextField_obj::getLineText( int lineIndex){
	HX_STACK_FRAME("flash.text.TextField","getLineText",0xd5be21b3,"flash.text.TextField.getLineText","flash/text/TextField.hx",66,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(lineIndex,"lineIndex")
	HX_STACK_LINE(66)
	return ::flash::text::TextField_obj::lime_text_field_get_line_text(this->__handle,lineIndex);
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,getLineText,return )

::flash::text::TextLineMetrics TextField_obj::getLineMetrics( int lineIndex){
	HX_STACK_FRAME("flash.text.TextField","getLineMetrics",0xa9aab4fd,"flash.text.TextField.getLineMetrics","flash/text/TextField.hx",71,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(lineIndex,"lineIndex")
	HX_STACK_LINE(73)
	::flash::text::TextLineMetrics result = ::flash::text::TextLineMetrics_obj::__new(null(),null(),null(),null(),null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(74)
	::flash::text::TextField_obj::lime_text_field_get_line_metrics(this->__handle,lineIndex,result);
	HX_STACK_LINE(75)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,getLineMetrics,return )

::flash::text::TextFormat TextField_obj::getTextFormat( hx::Null< int >  __o_beginIndex,hx::Null< int >  __o_endIndex){
int beginIndex = __o_beginIndex.Default(-1);
int endIndex = __o_endIndex.Default(-1);
	HX_STACK_FRAME("flash.text.TextField","getTextFormat",0xe21f3736,"flash.text.TextField.getTextFormat","flash/text/TextField.hx",80,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(beginIndex,"beginIndex")
	HX_STACK_ARG(endIndex,"endIndex")
{
		HX_STACK_LINE(82)
		::flash::text::TextFormat result = ::flash::text::TextFormat_obj::__new(null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null());		HX_STACK_VAR(result,"result");
		HX_STACK_LINE(83)
		::flash::text::TextField_obj::lime_text_field_get_text_format(this->__handle,result,beginIndex,endIndex);
		HX_STACK_LINE(84)
		return result;
	}
}


HX_DEFINE_DYNAMIC_FUNC2(TextField_obj,getTextFormat,return )

Void TextField_obj::replaceText( int beginIndex,int endIndex,::String newText){
{
		HX_STACK_FRAME("flash.text.TextField","replaceText",0x873caf3d,"flash.text.TextField.replaceText","flash/text/TextField.hx",89,0x93e6fab4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(beginIndex,"beginIndex")
		HX_STACK_ARG(endIndex,"endIndex")
		HX_STACK_ARG(newText,"newText")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(TextField_obj,replaceText,(void))

Void TextField_obj::setSelection( int beginIndex,int endIndex){
{
		HX_STACK_FRAME("flash.text.TextField","setSelection",0x7f1f288e,"flash.text.TextField.setSelection","flash/text/TextField.hx",96,0x93e6fab4)
		HX_STACK_THIS(this)
		HX_STACK_ARG(beginIndex,"beginIndex")
		HX_STACK_ARG(endIndex,"endIndex")
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(TextField_obj,setSelection,(void))

Void TextField_obj::setTextFormat( ::flash::text::TextFormat format,hx::Null< int >  __o_beginIndex,hx::Null< int >  __o_endIndex){
int beginIndex = __o_beginIndex.Default(-1);
int endIndex = __o_endIndex.Default(-1);
	HX_STACK_FRAME("flash.text.TextField","setTextFormat",0x27251942,"flash.text.TextField.setTextFormat","flash/text/TextField.hx",105,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(format,"format")
	HX_STACK_ARG(beginIndex,"beginIndex")
	HX_STACK_ARG(endIndex,"endIndex")
{
		HX_STACK_LINE(105)
		::flash::text::TextField_obj::lime_text_field_set_text_format(this->__handle,format,beginIndex,endIndex);
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC3(TextField_obj,setTextFormat,(void))

::flash::text::TextFieldAutoSize TextField_obj::get_autoSize( ){
	HX_STACK_FRAME("flash.text.TextField","get_autoSize",0xb147b41d,"flash.text.TextField.get_autoSize","flash/text/TextField.hx",117,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(117)
	int _g = ::flash::text::TextField_obj::lime_text_field_get_auto_size(this->__handle);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(117)
	return ::Type_obj::createEnumIndex(hx::ClassOf< ::flash::text::TextFieldAutoSize >(),_g,null());
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_autoSize,return )

::flash::text::TextFieldAutoSize TextField_obj::set_autoSize( ::flash::text::TextFieldAutoSize value){
	HX_STACK_FRAME("flash.text.TextField","set_autoSize",0xc640d791,"flash.text.TextField.set_autoSize","flash/text/TextField.hx",118,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(118)
	int _g = value->__Index();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(118)
	::flash::text::TextField_obj::lime_text_field_set_auto_size(this->__handle,_g);
	HX_STACK_LINE(118)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_autoSize,return )

bool TextField_obj::get_background( ){
	HX_STACK_FRAME("flash.text.TextField","get_background",0x52f7257b,"flash.text.TextField.get_background","flash/text/TextField.hx",119,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(119)
	return ::flash::text::TextField_obj::lime_text_field_get_background(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_background,return )

bool TextField_obj::set_background( bool value){
	HX_STACK_FRAME("flash.text.TextField","set_background",0x73170def,"flash.text.TextField.set_background","flash/text/TextField.hx",120,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(120)
	::flash::text::TextField_obj::lime_text_field_set_background(this->__handle,value);
	HX_STACK_LINE(120)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_background,return )

int TextField_obj::get_backgroundColor( ){
	HX_STACK_FRAME("flash.text.TextField","get_backgroundColor",0xcd71fde8,"flash.text.TextField.get_backgroundColor","flash/text/TextField.hx",121,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(121)
	return ::flash::text::TextField_obj::lime_text_field_get_background_color(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_backgroundColor,return )

int TextField_obj::set_backgroundColor( int value){
	HX_STACK_FRAME("flash.text.TextField","set_backgroundColor",0x0a0ef0f4,"flash.text.TextField.set_backgroundColor","flash/text/TextField.hx",122,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(122)
	::flash::text::TextField_obj::lime_text_field_set_background_color(this->__handle,value);
	HX_STACK_LINE(122)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_backgroundColor,return )

bool TextField_obj::get_border( ){
	HX_STACK_FRAME("flash.text.TextField","get_border",0x426ed3f9,"flash.text.TextField.get_border","flash/text/TextField.hx",123,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(123)
	return ::flash::text::TextField_obj::lime_text_field_get_border(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_border,return )

bool TextField_obj::set_border( bool value){
	HX_STACK_FRAME("flash.text.TextField","set_border",0x45ec726d,"flash.text.TextField.set_border","flash/text/TextField.hx",124,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(124)
	::flash::text::TextField_obj::lime_text_field_set_border(this->__handle,value);
	HX_STACK_LINE(124)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_border,return )

int TextField_obj::get_borderColor( ){
	HX_STACK_FRAME("flash.text.TextField","get_borderColor",0xe85b06aa,"flash.text.TextField.get_borderColor","flash/text/TextField.hx",125,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(125)
	return ::flash::text::TextField_obj::lime_text_field_get_border_color(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_borderColor,return )

int TextField_obj::set_borderColor( int value){
	HX_STACK_FRAME("flash.text.TextField","set_borderColor",0xe42683b6,"flash.text.TextField.set_borderColor","flash/text/TextField.hx",126,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(126)
	::flash::text::TextField_obj::lime_text_field_set_border_color(this->__handle,value);
	HX_STACK_LINE(126)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_borderColor,return )

int TextField_obj::get_bottomScrollV( ){
	HX_STACK_FRAME("flash.text.TextField","get_bottomScrollV",0x61721c91,"flash.text.TextField.get_bottomScrollV","flash/text/TextField.hx",127,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(127)
	return ::flash::text::TextField_obj::lime_text_field_get_bottom_scroll_v(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_bottomScrollV,return )

::flash::text::TextFormat TextField_obj::get_defaultTextFormat( ){
	HX_STACK_FRAME("flash.text.TextField","get_defaultTextFormat",0x2e9431f8,"flash.text.TextField.get_defaultTextFormat","flash/text/TextField.hx",128,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(128)
	::flash::text::TextFormat result = ::flash::text::TextFormat_obj::__new(null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null(),null());		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(128)
	::flash::text::TextField_obj::lime_text_field_get_def_text_format(this->__handle,result);
	HX_STACK_LINE(128)
	return result;
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_defaultTextFormat,return )

::flash::text::TextFormat TextField_obj::set_defaultTextFormat( ::flash::text::TextFormat value){
	HX_STACK_FRAME("flash.text.TextField","set_defaultTextFormat",0x829d0004,"flash.text.TextField.set_defaultTextFormat","flash/text/TextField.hx",129,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(129)
	::flash::text::TextField_obj::lime_text_field_set_def_text_format(this->__handle,value);
	HX_STACK_LINE(129)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_defaultTextFormat,return )

bool TextField_obj::get_displayAsPassword( ){
	HX_STACK_FRAME("flash.text.TextField","get_displayAsPassword",0x0e4a3522,"flash.text.TextField.get_displayAsPassword","flash/text/TextField.hx",130,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(130)
	return ::flash::text::TextField_obj::lime_text_field_get_display_as_password(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_displayAsPassword,return )

bool TextField_obj::set_displayAsPassword( bool value){
	HX_STACK_FRAME("flash.text.TextField","set_displayAsPassword",0x6253032e,"flash.text.TextField.set_displayAsPassword","flash/text/TextField.hx",131,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(131)
	::flash::text::TextField_obj::lime_text_field_set_display_as_password(this->__handle,value);
	HX_STACK_LINE(131)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_displayAsPassword,return )

bool TextField_obj::get_embedFonts( ){
	HX_STACK_FRAME("flash.text.TextField","get_embedFonts",0xbbbb58b8,"flash.text.TextField.get_embedFonts","flash/text/TextField.hx",132,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(132)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_embedFonts,return )

bool TextField_obj::set_embedFonts( bool value){
	HX_STACK_FRAME("flash.text.TextField","set_embedFonts",0xdbdb412c,"flash.text.TextField.set_embedFonts","flash/text/TextField.hx",133,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(133)
	return true;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_embedFonts,return )

::String TextField_obj::get_htmlText( ){
	HX_STACK_FRAME("flash.text.TextField","get_htmlText",0x92064405,"flash.text.TextField.get_htmlText","flash/text/TextField.hx",134,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(134)
	::String _g = ::flash::text::TextField_obj::lime_text_field_get_html_text(this->__handle);		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(134)
	return ::StringTools_obj::replace(_g,HX_CSTRING("\n"),HX_CSTRING("<br/>"));
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_htmlText,return )

::String TextField_obj::set_htmlText( ::String value){
	HX_STACK_FRAME("flash.text.TextField","set_htmlText",0xa6ff6779,"flash.text.TextField.set_htmlText","flash/text/TextField.hx",135,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(135)
	::flash::text::TextField_obj::lime_text_field_set_html_text(this->__handle,value);
	HX_STACK_LINE(135)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_htmlText,return )

int TextField_obj::get_maxChars( ){
	HX_STACK_FRAME("flash.text.TextField","get_maxChars",0x719f13e6,"flash.text.TextField.get_maxChars","flash/text/TextField.hx",136,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(136)
	return ::flash::text::TextField_obj::lime_text_field_get_max_chars(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_maxChars,return )

int TextField_obj::set_maxChars( int value){
	HX_STACK_FRAME("flash.text.TextField","set_maxChars",0x8698375a,"flash.text.TextField.set_maxChars","flash/text/TextField.hx",137,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(137)
	::flash::text::TextField_obj::lime_text_field_set_max_chars(this->__handle,value);
	HX_STACK_LINE(137)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_maxChars,return )

int TextField_obj::get_maxScrollH( ){
	HX_STACK_FRAME("flash.text.TextField","get_maxScrollH",0xc7d63ee4,"flash.text.TextField.get_maxScrollH","flash/text/TextField.hx",138,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(138)
	return ::flash::text::TextField_obj::lime_text_field_get_max_scroll_h(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_maxScrollH,return )

int TextField_obj::get_maxScrollV( ){
	HX_STACK_FRAME("flash.text.TextField","get_maxScrollV",0xc7d63ef2,"flash.text.TextField.get_maxScrollV","flash/text/TextField.hx",139,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(139)
	return ::flash::text::TextField_obj::lime_text_field_get_max_scroll_v(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_maxScrollV,return )

bool TextField_obj::get_multiline( ){
	HX_STACK_FRAME("flash.text.TextField","get_multiline",0xb0a37200,"flash.text.TextField.get_multiline","flash/text/TextField.hx",140,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(140)
	return ::flash::text::TextField_obj::lime_text_field_get_multiline(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_multiline,return )

bool TextField_obj::set_multiline( bool value){
	HX_STACK_FRAME("flash.text.TextField","set_multiline",0xf5a9540c,"flash.text.TextField.set_multiline","flash/text/TextField.hx",141,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(141)
	::flash::text::TextField_obj::lime_text_field_set_multiline(this->__handle,value);
	HX_STACK_LINE(141)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_multiline,return )

int TextField_obj::get_numLines( ){
	HX_STACK_FRAME("flash.text.TextField","get_numLines",0xb3e01626,"flash.text.TextField.get_numLines","flash/text/TextField.hx",142,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(142)
	return ::flash::text::TextField_obj::lime_text_field_get_num_lines(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_numLines,return )

int TextField_obj::get_scrollH( ){
	HX_STACK_FRAME("flash.text.TextField","get_scrollH",0xdc79d7ee,"flash.text.TextField.get_scrollH","flash/text/TextField.hx",143,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(143)
	return ::flash::text::TextField_obj::lime_text_field_get_scroll_h(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_scrollH,return )

int TextField_obj::set_scrollH( int value){
	HX_STACK_FRAME("flash.text.TextField","set_scrollH",0xe6e6defa,"flash.text.TextField.set_scrollH","flash/text/TextField.hx",144,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(144)
	::flash::text::TextField_obj::lime_text_field_set_scroll_h(this->__handle,value);
	HX_STACK_LINE(144)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_scrollH,return )

int TextField_obj::get_scrollV( ){
	HX_STACK_FRAME("flash.text.TextField","get_scrollV",0xdc79d7fc,"flash.text.TextField.get_scrollV","flash/text/TextField.hx",145,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(145)
	return ::flash::text::TextField_obj::lime_text_field_get_scroll_v(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_scrollV,return )

int TextField_obj::set_scrollV( int value){
	HX_STACK_FRAME("flash.text.TextField","set_scrollV",0xe6e6df08,"flash.text.TextField.set_scrollV","flash/text/TextField.hx",146,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(146)
	::flash::text::TextField_obj::lime_text_field_set_scroll_v(this->__handle,value);
	HX_STACK_LINE(146)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_scrollV,return )

bool TextField_obj::get_selectable( ){
	HX_STACK_FRAME("flash.text.TextField","get_selectable",0xf1044823,"flash.text.TextField.get_selectable","flash/text/TextField.hx",147,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(147)
	return ::flash::text::TextField_obj::lime_text_field_get_selectable(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_selectable,return )

bool TextField_obj::set_selectable( bool value){
	HX_STACK_FRAME("flash.text.TextField","set_selectable",0x11243097,"flash.text.TextField.set_selectable","flash/text/TextField.hx",148,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(148)
	::flash::text::TextField_obj::lime_text_field_set_selectable(this->__handle,value);
	HX_STACK_LINE(148)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_selectable,return )

::String TextField_obj::get_text( ){
	HX_STACK_FRAME("flash.text.TextField","get_text",0x1852867a,"flash.text.TextField.get_text","flash/text/TextField.hx",149,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(149)
	return ::flash::text::TextField_obj::lime_text_field_get_text(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_text,return )

::String TextField_obj::set_text( ::String value){
	HX_STACK_FRAME("flash.text.TextField","set_text",0xc6afdfee,"flash.text.TextField.set_text","flash/text/TextField.hx",150,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(150)
	::flash::text::TextField_obj::lime_text_field_set_text(this->__handle,value);
	HX_STACK_LINE(150)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_text,return )

int TextField_obj::get_textColor( ){
	HX_STACK_FRAME("flash.text.TextField","get_textColor",0xf5dba089,"flash.text.TextField.get_textColor","flash/text/TextField.hx",151,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(151)
	return ::flash::text::TextField_obj::lime_text_field_get_text_color(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_textColor,return )

int TextField_obj::set_textColor( int value){
	HX_STACK_FRAME("flash.text.TextField","set_textColor",0x3ae18295,"flash.text.TextField.set_textColor","flash/text/TextField.hx",152,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(152)
	::flash::text::TextField_obj::lime_text_field_set_text_color(this->__handle,value);
	HX_STACK_LINE(152)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_textColor,return )

Float TextField_obj::get_textWidth( ){
	HX_STACK_FRAME("flash.text.TextField","get_textWidth",0x75e1e52c,"flash.text.TextField.get_textWidth","flash/text/TextField.hx",153,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(153)
	return ::flash::text::TextField_obj::lime_text_field_get_text_width(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_textWidth,return )

Float TextField_obj::get_textHeight( ){
	HX_STACK_FRAME("flash.text.TextField","get_textHeight",0x66161a01,"flash.text.TextField.get_textHeight","flash/text/TextField.hx",154,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(154)
	return ::flash::text::TextField_obj::lime_text_field_get_text_height(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_textHeight,return )

::flash::text::TextFieldType TextField_obj::get_type( ){
	HX_STACK_FRAME("flash.text.TextField","get_type",0x1861ac87,"flash.text.TextField.get_type","flash/text/TextField.hx",155,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(155)
	if ((::flash::text::TextField_obj::lime_text_field_get_type(this->__handle))){
		HX_STACK_LINE(155)
		return ::flash::text::TextFieldType_obj::INPUT;
	}
	else{
		HX_STACK_LINE(155)
		return ::flash::text::TextFieldType_obj::DYNAMIC;
	}
	HX_STACK_LINE(155)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_type,return )

::flash::text::TextFieldType TextField_obj::set_type( ::flash::text::TextFieldType value){
	HX_STACK_FRAME("flash.text.TextField","set_type",0xc6bf05fb,"flash.text.TextField.set_type","flash/text/TextField.hx",156,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(156)
	::flash::text::TextField_obj::lime_text_field_set_type(this->__handle,(value == ::flash::text::TextFieldType_obj::INPUT));
	HX_STACK_LINE(156)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_type,return )

bool TextField_obj::get_wordWrap( ){
	HX_STACK_FRAME("flash.text.TextField","get_wordWrap",0x82a93901,"flash.text.TextField.get_wordWrap","flash/text/TextField.hx",157,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_LINE(157)
	return ::flash::text::TextField_obj::lime_text_field_get_word_wrap(this->__handle);
}


HX_DEFINE_DYNAMIC_FUNC0(TextField_obj,get_wordWrap,return )

bool TextField_obj::set_wordWrap( bool value){
	HX_STACK_FRAME("flash.text.TextField","set_wordWrap",0x97a25c75,"flash.text.TextField.set_wordWrap","flash/text/TextField.hx",158,0x93e6fab4)
	HX_STACK_THIS(this)
	HX_STACK_ARG(value,"value")
	HX_STACK_LINE(158)
	::flash::text::TextField_obj::lime_text_field_set_word_wrap(this->__handle,value);
	HX_STACK_LINE(158)
	return value;
}


HX_DEFINE_DYNAMIC_FUNC1(TextField_obj,set_wordWrap,return )

Dynamic TextField_obj::lime_text_field_create;

Dynamic TextField_obj::lime_text_field_get_text;

Dynamic TextField_obj::lime_text_field_set_text;

Dynamic TextField_obj::lime_text_field_get_html_text;

Dynamic TextField_obj::lime_text_field_set_html_text;

Dynamic TextField_obj::lime_text_field_get_text_color;

Dynamic TextField_obj::lime_text_field_set_text_color;

Dynamic TextField_obj::lime_text_field_get_selectable;

Dynamic TextField_obj::lime_text_field_set_selectable;

Dynamic TextField_obj::lime_text_field_get_display_as_password;

Dynamic TextField_obj::lime_text_field_set_display_as_password;

Dynamic TextField_obj::lime_text_field_get_def_text_format;

Dynamic TextField_obj::lime_text_field_set_def_text_format;

Dynamic TextField_obj::lime_text_field_get_auto_size;

Dynamic TextField_obj::lime_text_field_set_auto_size;

Dynamic TextField_obj::lime_text_field_get_type;

Dynamic TextField_obj::lime_text_field_set_type;

Dynamic TextField_obj::lime_text_field_get_multiline;

Dynamic TextField_obj::lime_text_field_set_multiline;

Dynamic TextField_obj::lime_text_field_get_word_wrap;

Dynamic TextField_obj::lime_text_field_set_word_wrap;

Dynamic TextField_obj::lime_text_field_get_border;

Dynamic TextField_obj::lime_text_field_set_border;

Dynamic TextField_obj::lime_text_field_get_border_color;

Dynamic TextField_obj::lime_text_field_set_border_color;

Dynamic TextField_obj::lime_text_field_get_background;

Dynamic TextField_obj::lime_text_field_set_background;

Dynamic TextField_obj::lime_text_field_get_background_color;

Dynamic TextField_obj::lime_text_field_set_background_color;

Dynamic TextField_obj::lime_text_field_get_text_width;

Dynamic TextField_obj::lime_text_field_get_text_height;

Dynamic TextField_obj::lime_text_field_get_text_format;

Dynamic TextField_obj::lime_text_field_set_text_format;

Dynamic TextField_obj::lime_text_field_get_max_scroll_v;

Dynamic TextField_obj::lime_text_field_get_max_scroll_h;

Dynamic TextField_obj::lime_text_field_get_bottom_scroll_v;

Dynamic TextField_obj::lime_text_field_get_scroll_h;

Dynamic TextField_obj::lime_text_field_set_scroll_h;

Dynamic TextField_obj::lime_text_field_get_scroll_v;

Dynamic TextField_obj::lime_text_field_set_scroll_v;

Dynamic TextField_obj::lime_text_field_get_num_lines;

Dynamic TextField_obj::lime_text_field_get_max_chars;

Dynamic TextField_obj::lime_text_field_set_max_chars;

Dynamic TextField_obj::lime_text_field_get_line_text;

Dynamic TextField_obj::lime_text_field_get_line_metrics;

Dynamic TextField_obj::lime_text_field_get_line_offset;


TextField_obj::TextField_obj()
{
}

void TextField_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(TextField);
	HX_MARK_MEMBER_NAME(antiAliasType,"antiAliasType");
	HX_MARK_MEMBER_NAME(bottomScrollV,"bottomScrollV");
	HX_MARK_MEMBER_NAME(gridFitType,"gridFitType");
	HX_MARK_MEMBER_NAME(maxScrollH,"maxScrollH");
	HX_MARK_MEMBER_NAME(maxScrollV,"maxScrollV");
	HX_MARK_MEMBER_NAME(numLines,"numLines");
	HX_MARK_MEMBER_NAME(sharpness,"sharpness");
	HX_MARK_MEMBER_NAME(textHeight,"textHeight");
	HX_MARK_MEMBER_NAME(textWidth,"textWidth");
	::flash::display::DisplayObject_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void TextField_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(antiAliasType,"antiAliasType");
	HX_VISIT_MEMBER_NAME(bottomScrollV,"bottomScrollV");
	HX_VISIT_MEMBER_NAME(gridFitType,"gridFitType");
	HX_VISIT_MEMBER_NAME(maxScrollH,"maxScrollH");
	HX_VISIT_MEMBER_NAME(maxScrollV,"maxScrollV");
	HX_VISIT_MEMBER_NAME(numLines,"numLines");
	HX_VISIT_MEMBER_NAME(sharpness,"sharpness");
	HX_VISIT_MEMBER_NAME(textHeight,"textHeight");
	HX_VISIT_MEMBER_NAME(textWidth,"textWidth");
	::flash::display::DisplayObject_obj::__Visit(HX_VISIT_ARG);
}

Dynamic TextField_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"text") ) { return get_text(); }
		if (HX_FIELD_EQ(inName,"type") ) { return get_type(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"border") ) { return get_border(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"scrollH") ) { return get_scrollH(); }
		if (HX_FIELD_EQ(inName,"scrollV") ) { return get_scrollV(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"autoSize") ) { return get_autoSize(); }
		if (HX_FIELD_EQ(inName,"htmlText") ) { return get_htmlText(); }
		if (HX_FIELD_EQ(inName,"maxChars") ) { return get_maxChars(); }
		if (HX_FIELD_EQ(inName,"numLines") ) { return inCallProp ? get_numLines() : numLines; }
		if (HX_FIELD_EQ(inName,"wordWrap") ) { return get_wordWrap(); }
		if (HX_FIELD_EQ(inName,"get_text") ) { return get_text_dyn(); }
		if (HX_FIELD_EQ(inName,"set_text") ) { return set_text_dyn(); }
		if (HX_FIELD_EQ(inName,"get_type") ) { return get_type_dyn(); }
		if (HX_FIELD_EQ(inName,"set_type") ) { return set_type_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"multiline") ) { return get_multiline(); }
		if (HX_FIELD_EQ(inName,"sharpness") ) { return sharpness; }
		if (HX_FIELD_EQ(inName,"textColor") ) { return get_textColor(); }
		if (HX_FIELD_EQ(inName,"textWidth") ) { return inCallProp ? get_textWidth() : textWidth; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"background") ) { return get_background(); }
		if (HX_FIELD_EQ(inName,"embedFonts") ) { return get_embedFonts(); }
		if (HX_FIELD_EQ(inName,"maxScrollH") ) { return inCallProp ? get_maxScrollH() : maxScrollH; }
		if (HX_FIELD_EQ(inName,"maxScrollV") ) { return inCallProp ? get_maxScrollV() : maxScrollV; }
		if (HX_FIELD_EQ(inName,"selectable") ) { return get_selectable(); }
		if (HX_FIELD_EQ(inName,"textHeight") ) { return inCallProp ? get_textHeight() : textHeight; }
		if (HX_FIELD_EQ(inName,"appendText") ) { return appendText_dyn(); }
		if (HX_FIELD_EQ(inName,"get_border") ) { return get_border_dyn(); }
		if (HX_FIELD_EQ(inName,"set_border") ) { return set_border_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"borderColor") ) { return get_borderColor(); }
		if (HX_FIELD_EQ(inName,"gridFitType") ) { return gridFitType; }
		if (HX_FIELD_EQ(inName,"getLineText") ) { return getLineText_dyn(); }
		if (HX_FIELD_EQ(inName,"replaceText") ) { return replaceText_dyn(); }
		if (HX_FIELD_EQ(inName,"get_scrollH") ) { return get_scrollH_dyn(); }
		if (HX_FIELD_EQ(inName,"set_scrollH") ) { return set_scrollH_dyn(); }
		if (HX_FIELD_EQ(inName,"get_scrollV") ) { return get_scrollV_dyn(); }
		if (HX_FIELD_EQ(inName,"set_scrollV") ) { return set_scrollV_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"setSelection") ) { return setSelection_dyn(); }
		if (HX_FIELD_EQ(inName,"get_autoSize") ) { return get_autoSize_dyn(); }
		if (HX_FIELD_EQ(inName,"set_autoSize") ) { return set_autoSize_dyn(); }
		if (HX_FIELD_EQ(inName,"get_htmlText") ) { return get_htmlText_dyn(); }
		if (HX_FIELD_EQ(inName,"set_htmlText") ) { return set_htmlText_dyn(); }
		if (HX_FIELD_EQ(inName,"get_maxChars") ) { return get_maxChars_dyn(); }
		if (HX_FIELD_EQ(inName,"set_maxChars") ) { return set_maxChars_dyn(); }
		if (HX_FIELD_EQ(inName,"get_numLines") ) { return get_numLines_dyn(); }
		if (HX_FIELD_EQ(inName,"get_wordWrap") ) { return get_wordWrap_dyn(); }
		if (HX_FIELD_EQ(inName,"set_wordWrap") ) { return set_wordWrap_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"antiAliasType") ) { return antiAliasType; }
		if (HX_FIELD_EQ(inName,"bottomScrollV") ) { return inCallProp ? get_bottomScrollV() : bottomScrollV; }
		if (HX_FIELD_EQ(inName,"getLineOffset") ) { return getLineOffset_dyn(); }
		if (HX_FIELD_EQ(inName,"getTextFormat") ) { return getTextFormat_dyn(); }
		if (HX_FIELD_EQ(inName,"setTextFormat") ) { return setTextFormat_dyn(); }
		if (HX_FIELD_EQ(inName,"get_multiline") ) { return get_multiline_dyn(); }
		if (HX_FIELD_EQ(inName,"set_multiline") ) { return set_multiline_dyn(); }
		if (HX_FIELD_EQ(inName,"get_textColor") ) { return get_textColor_dyn(); }
		if (HX_FIELD_EQ(inName,"set_textColor") ) { return set_textColor_dyn(); }
		if (HX_FIELD_EQ(inName,"get_textWidth") ) { return get_textWidth_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"getLineMetrics") ) { return getLineMetrics_dyn(); }
		if (HX_FIELD_EQ(inName,"get_background") ) { return get_background_dyn(); }
		if (HX_FIELD_EQ(inName,"set_background") ) { return set_background_dyn(); }
		if (HX_FIELD_EQ(inName,"get_embedFonts") ) { return get_embedFonts_dyn(); }
		if (HX_FIELD_EQ(inName,"set_embedFonts") ) { return set_embedFonts_dyn(); }
		if (HX_FIELD_EQ(inName,"get_maxScrollH") ) { return get_maxScrollH_dyn(); }
		if (HX_FIELD_EQ(inName,"get_maxScrollV") ) { return get_maxScrollV_dyn(); }
		if (HX_FIELD_EQ(inName,"get_selectable") ) { return get_selectable_dyn(); }
		if (HX_FIELD_EQ(inName,"set_selectable") ) { return set_selectable_dyn(); }
		if (HX_FIELD_EQ(inName,"get_textHeight") ) { return get_textHeight_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"backgroundColor") ) { return get_backgroundColor(); }
		if (HX_FIELD_EQ(inName,"get_borderColor") ) { return get_borderColor_dyn(); }
		if (HX_FIELD_EQ(inName,"set_borderColor") ) { return set_borderColor_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"defaultTextFormat") ) { return get_defaultTextFormat(); }
		if (HX_FIELD_EQ(inName,"displayAsPassword") ) { return get_displayAsPassword(); }
		if (HX_FIELD_EQ(inName,"get_bottomScrollV") ) { return get_bottomScrollV_dyn(); }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"get_backgroundColor") ) { return get_backgroundColor_dyn(); }
		if (HX_FIELD_EQ(inName,"set_backgroundColor") ) { return set_backgroundColor_dyn(); }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"get_defaultTextFormat") ) { return get_defaultTextFormat_dyn(); }
		if (HX_FIELD_EQ(inName,"set_defaultTextFormat") ) { return set_defaultTextFormat_dyn(); }
		if (HX_FIELD_EQ(inName,"get_displayAsPassword") ) { return get_displayAsPassword_dyn(); }
		if (HX_FIELD_EQ(inName,"set_displayAsPassword") ) { return set_displayAsPassword_dyn(); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"lime_text_field_create") ) { return lime_text_field_create; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text") ) { return lime_text_field_get_text; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_text") ) { return lime_text_field_set_text; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_type") ) { return lime_text_field_get_type; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_type") ) { return lime_text_field_set_type; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_border") ) { return lime_text_field_get_border; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_border") ) { return lime_text_field_set_border; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_scroll_h") ) { return lime_text_field_get_scroll_h; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_scroll_h") ) { return lime_text_field_set_scroll_h; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_scroll_v") ) { return lime_text_field_get_scroll_v; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_scroll_v") ) { return lime_text_field_set_scroll_v; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_html_text") ) { return lime_text_field_get_html_text; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_html_text") ) { return lime_text_field_set_html_text; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_auto_size") ) { return lime_text_field_get_auto_size; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_auto_size") ) { return lime_text_field_set_auto_size; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_multiline") ) { return lime_text_field_get_multiline; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_multiline") ) { return lime_text_field_set_multiline; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_word_wrap") ) { return lime_text_field_get_word_wrap; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_word_wrap") ) { return lime_text_field_set_word_wrap; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_num_lines") ) { return lime_text_field_get_num_lines; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_max_chars") ) { return lime_text_field_get_max_chars; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_max_chars") ) { return lime_text_field_set_max_chars; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_line_text") ) { return lime_text_field_get_line_text; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_color") ) { return lime_text_field_get_text_color; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_text_color") ) { return lime_text_field_set_text_color; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_selectable") ) { return lime_text_field_get_selectable; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_selectable") ) { return lime_text_field_set_selectable; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_background") ) { return lime_text_field_get_background; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_background") ) { return lime_text_field_set_background; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_width") ) { return lime_text_field_get_text_width; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_height") ) { return lime_text_field_get_text_height; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_format") ) { return lime_text_field_get_text_format; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_text_format") ) { return lime_text_field_set_text_format; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_line_offset") ) { return lime_text_field_get_line_offset; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_border_color") ) { return lime_text_field_get_border_color; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_border_color") ) { return lime_text_field_set_border_color; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_max_scroll_v") ) { return lime_text_field_get_max_scroll_v; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_max_scroll_h") ) { return lime_text_field_get_max_scroll_h; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_line_metrics") ) { return lime_text_field_get_line_metrics; }
		break;
	case 35:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_def_text_format") ) { return lime_text_field_get_def_text_format; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_def_text_format") ) { return lime_text_field_set_def_text_format; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_bottom_scroll_v") ) { return lime_text_field_get_bottom_scroll_v; }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_background_color") ) { return lime_text_field_get_background_color; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_background_color") ) { return lime_text_field_set_background_color; }
		break;
	case 39:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_display_as_password") ) { return lime_text_field_get_display_as_password; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_display_as_password") ) { return lime_text_field_set_display_as_password; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic TextField_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"text") ) { return set_text(inValue); }
		if (HX_FIELD_EQ(inName,"type") ) { return set_type(inValue); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"border") ) { return set_border(inValue); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"scrollH") ) { return set_scrollH(inValue); }
		if (HX_FIELD_EQ(inName,"scrollV") ) { return set_scrollV(inValue); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"autoSize") ) { return set_autoSize(inValue); }
		if (HX_FIELD_EQ(inName,"htmlText") ) { return set_htmlText(inValue); }
		if (HX_FIELD_EQ(inName,"maxChars") ) { return set_maxChars(inValue); }
		if (HX_FIELD_EQ(inName,"numLines") ) { numLines=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"wordWrap") ) { return set_wordWrap(inValue); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"multiline") ) { return set_multiline(inValue); }
		if (HX_FIELD_EQ(inName,"sharpness") ) { sharpness=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"textColor") ) { return set_textColor(inValue); }
		if (HX_FIELD_EQ(inName,"textWidth") ) { textWidth=inValue.Cast< Float >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"background") ) { return set_background(inValue); }
		if (HX_FIELD_EQ(inName,"embedFonts") ) { return set_embedFonts(inValue); }
		if (HX_FIELD_EQ(inName,"maxScrollH") ) { maxScrollH=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"maxScrollV") ) { maxScrollV=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"selectable") ) { return set_selectable(inValue); }
		if (HX_FIELD_EQ(inName,"textHeight") ) { textHeight=inValue.Cast< Float >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"borderColor") ) { return set_borderColor(inValue); }
		if (HX_FIELD_EQ(inName,"gridFitType") ) { gridFitType=inValue.Cast< ::flash::text::GridFitType >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"antiAliasType") ) { antiAliasType=inValue.Cast< ::flash::text::AntiAliasType >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bottomScrollV") ) { bottomScrollV=inValue.Cast< int >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"backgroundColor") ) { return set_backgroundColor(inValue); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"defaultTextFormat") ) { return set_defaultTextFormat(inValue); }
		if (HX_FIELD_EQ(inName,"displayAsPassword") ) { return set_displayAsPassword(inValue); }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"lime_text_field_create") ) { lime_text_field_create=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text") ) { lime_text_field_get_text=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_text") ) { lime_text_field_set_text=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_type") ) { lime_text_field_get_type=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_type") ) { lime_text_field_set_type=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_border") ) { lime_text_field_get_border=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_border") ) { lime_text_field_set_border=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_scroll_h") ) { lime_text_field_get_scroll_h=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_scroll_h") ) { lime_text_field_set_scroll_h=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_scroll_v") ) { lime_text_field_get_scroll_v=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_scroll_v") ) { lime_text_field_set_scroll_v=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_html_text") ) { lime_text_field_get_html_text=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_html_text") ) { lime_text_field_set_html_text=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_auto_size") ) { lime_text_field_get_auto_size=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_auto_size") ) { lime_text_field_set_auto_size=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_multiline") ) { lime_text_field_get_multiline=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_multiline") ) { lime_text_field_set_multiline=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_word_wrap") ) { lime_text_field_get_word_wrap=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_word_wrap") ) { lime_text_field_set_word_wrap=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_num_lines") ) { lime_text_field_get_num_lines=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_max_chars") ) { lime_text_field_get_max_chars=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_max_chars") ) { lime_text_field_set_max_chars=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_line_text") ) { lime_text_field_get_line_text=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_color") ) { lime_text_field_get_text_color=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_text_color") ) { lime_text_field_set_text_color=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_selectable") ) { lime_text_field_get_selectable=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_selectable") ) { lime_text_field_set_selectable=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_background") ) { lime_text_field_get_background=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_background") ) { lime_text_field_set_background=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_width") ) { lime_text_field_get_text_width=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_height") ) { lime_text_field_get_text_height=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_text_format") ) { lime_text_field_get_text_format=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_text_format") ) { lime_text_field_set_text_format=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_line_offset") ) { lime_text_field_get_line_offset=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_border_color") ) { lime_text_field_get_border_color=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_border_color") ) { lime_text_field_set_border_color=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_max_scroll_v") ) { lime_text_field_get_max_scroll_v=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_max_scroll_h") ) { lime_text_field_get_max_scroll_h=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_line_metrics") ) { lime_text_field_get_line_metrics=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 35:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_def_text_format") ) { lime_text_field_get_def_text_format=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_def_text_format") ) { lime_text_field_set_def_text_format=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_get_bottom_scroll_v") ) { lime_text_field_get_bottom_scroll_v=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 36:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_background_color") ) { lime_text_field_get_background_color=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_background_color") ) { lime_text_field_set_background_color=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 39:
		if (HX_FIELD_EQ(inName,"lime_text_field_get_display_as_password") ) { lime_text_field_get_display_as_password=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_text_field_set_display_as_password") ) { lime_text_field_set_display_as_password=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void TextField_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("antiAliasType"));
	outFields->push(HX_CSTRING("autoSize"));
	outFields->push(HX_CSTRING("background"));
	outFields->push(HX_CSTRING("backgroundColor"));
	outFields->push(HX_CSTRING("border"));
	outFields->push(HX_CSTRING("borderColor"));
	outFields->push(HX_CSTRING("bottomScrollV"));
	outFields->push(HX_CSTRING("defaultTextFormat"));
	outFields->push(HX_CSTRING("displayAsPassword"));
	outFields->push(HX_CSTRING("embedFonts"));
	outFields->push(HX_CSTRING("gridFitType"));
	outFields->push(HX_CSTRING("htmlText"));
	outFields->push(HX_CSTRING("maxChars"));
	outFields->push(HX_CSTRING("maxScrollH"));
	outFields->push(HX_CSTRING("maxScrollV"));
	outFields->push(HX_CSTRING("multiline"));
	outFields->push(HX_CSTRING("numLines"));
	outFields->push(HX_CSTRING("scrollH"));
	outFields->push(HX_CSTRING("scrollV"));
	outFields->push(HX_CSTRING("selectable"));
	outFields->push(HX_CSTRING("sharpness"));
	outFields->push(HX_CSTRING("text"));
	outFields->push(HX_CSTRING("textColor"));
	outFields->push(HX_CSTRING("textHeight"));
	outFields->push(HX_CSTRING("textWidth"));
	outFields->push(HX_CSTRING("type"));
	outFields->push(HX_CSTRING("wordWrap"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("lime_text_field_create"),
	HX_CSTRING("lime_text_field_get_text"),
	HX_CSTRING("lime_text_field_set_text"),
	HX_CSTRING("lime_text_field_get_html_text"),
	HX_CSTRING("lime_text_field_set_html_text"),
	HX_CSTRING("lime_text_field_get_text_color"),
	HX_CSTRING("lime_text_field_set_text_color"),
	HX_CSTRING("lime_text_field_get_selectable"),
	HX_CSTRING("lime_text_field_set_selectable"),
	HX_CSTRING("lime_text_field_get_display_as_password"),
	HX_CSTRING("lime_text_field_set_display_as_password"),
	HX_CSTRING("lime_text_field_get_def_text_format"),
	HX_CSTRING("lime_text_field_set_def_text_format"),
	HX_CSTRING("lime_text_field_get_auto_size"),
	HX_CSTRING("lime_text_field_set_auto_size"),
	HX_CSTRING("lime_text_field_get_type"),
	HX_CSTRING("lime_text_field_set_type"),
	HX_CSTRING("lime_text_field_get_multiline"),
	HX_CSTRING("lime_text_field_set_multiline"),
	HX_CSTRING("lime_text_field_get_word_wrap"),
	HX_CSTRING("lime_text_field_set_word_wrap"),
	HX_CSTRING("lime_text_field_get_border"),
	HX_CSTRING("lime_text_field_set_border"),
	HX_CSTRING("lime_text_field_get_border_color"),
	HX_CSTRING("lime_text_field_set_border_color"),
	HX_CSTRING("lime_text_field_get_background"),
	HX_CSTRING("lime_text_field_set_background"),
	HX_CSTRING("lime_text_field_get_background_color"),
	HX_CSTRING("lime_text_field_set_background_color"),
	HX_CSTRING("lime_text_field_get_text_width"),
	HX_CSTRING("lime_text_field_get_text_height"),
	HX_CSTRING("lime_text_field_get_text_format"),
	HX_CSTRING("lime_text_field_set_text_format"),
	HX_CSTRING("lime_text_field_get_max_scroll_v"),
	HX_CSTRING("lime_text_field_get_max_scroll_h"),
	HX_CSTRING("lime_text_field_get_bottom_scroll_v"),
	HX_CSTRING("lime_text_field_get_scroll_h"),
	HX_CSTRING("lime_text_field_set_scroll_h"),
	HX_CSTRING("lime_text_field_get_scroll_v"),
	HX_CSTRING("lime_text_field_set_scroll_v"),
	HX_CSTRING("lime_text_field_get_num_lines"),
	HX_CSTRING("lime_text_field_get_max_chars"),
	HX_CSTRING("lime_text_field_set_max_chars"),
	HX_CSTRING("lime_text_field_get_line_text"),
	HX_CSTRING("lime_text_field_get_line_metrics"),
	HX_CSTRING("lime_text_field_get_line_offset"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo sMemberStorageInfo[] = {
	{hx::fsObject /*::flash::text::AntiAliasType*/ ,(int)offsetof(TextField_obj,antiAliasType),HX_CSTRING("antiAliasType")},
	{hx::fsInt,(int)offsetof(TextField_obj,bottomScrollV),HX_CSTRING("bottomScrollV")},
	{hx::fsObject /*::flash::text::GridFitType*/ ,(int)offsetof(TextField_obj,gridFitType),HX_CSTRING("gridFitType")},
	{hx::fsInt,(int)offsetof(TextField_obj,maxScrollH),HX_CSTRING("maxScrollH")},
	{hx::fsInt,(int)offsetof(TextField_obj,maxScrollV),HX_CSTRING("maxScrollV")},
	{hx::fsInt,(int)offsetof(TextField_obj,numLines),HX_CSTRING("numLines")},
	{hx::fsFloat,(int)offsetof(TextField_obj,sharpness),HX_CSTRING("sharpness")},
	{hx::fsFloat,(int)offsetof(TextField_obj,textHeight),HX_CSTRING("textHeight")},
	{hx::fsFloat,(int)offsetof(TextField_obj,textWidth),HX_CSTRING("textWidth")},
	{ hx::fsUnknown, 0, null()}
};
#endif

static ::String sMemberFields[] = {
	HX_CSTRING("antiAliasType"),
	HX_CSTRING("bottomScrollV"),
	HX_CSTRING("gridFitType"),
	HX_CSTRING("maxScrollH"),
	HX_CSTRING("maxScrollV"),
	HX_CSTRING("numLines"),
	HX_CSTRING("sharpness"),
	HX_CSTRING("textHeight"),
	HX_CSTRING("textWidth"),
	HX_CSTRING("appendText"),
	HX_CSTRING("getLineOffset"),
	HX_CSTRING("getLineText"),
	HX_CSTRING("getLineMetrics"),
	HX_CSTRING("getTextFormat"),
	HX_CSTRING("replaceText"),
	HX_CSTRING("setSelection"),
	HX_CSTRING("setTextFormat"),
	HX_CSTRING("get_autoSize"),
	HX_CSTRING("set_autoSize"),
	HX_CSTRING("get_background"),
	HX_CSTRING("set_background"),
	HX_CSTRING("get_backgroundColor"),
	HX_CSTRING("set_backgroundColor"),
	HX_CSTRING("get_border"),
	HX_CSTRING("set_border"),
	HX_CSTRING("get_borderColor"),
	HX_CSTRING("set_borderColor"),
	HX_CSTRING("get_bottomScrollV"),
	HX_CSTRING("get_defaultTextFormat"),
	HX_CSTRING("set_defaultTextFormat"),
	HX_CSTRING("get_displayAsPassword"),
	HX_CSTRING("set_displayAsPassword"),
	HX_CSTRING("get_embedFonts"),
	HX_CSTRING("set_embedFonts"),
	HX_CSTRING("get_htmlText"),
	HX_CSTRING("set_htmlText"),
	HX_CSTRING("get_maxChars"),
	HX_CSTRING("set_maxChars"),
	HX_CSTRING("get_maxScrollH"),
	HX_CSTRING("get_maxScrollV"),
	HX_CSTRING("get_multiline"),
	HX_CSTRING("set_multiline"),
	HX_CSTRING("get_numLines"),
	HX_CSTRING("get_scrollH"),
	HX_CSTRING("set_scrollH"),
	HX_CSTRING("get_scrollV"),
	HX_CSTRING("set_scrollV"),
	HX_CSTRING("get_selectable"),
	HX_CSTRING("set_selectable"),
	HX_CSTRING("get_text"),
	HX_CSTRING("set_text"),
	HX_CSTRING("get_textColor"),
	HX_CSTRING("set_textColor"),
	HX_CSTRING("get_textWidth"),
	HX_CSTRING("get_textHeight"),
	HX_CSTRING("get_type"),
	HX_CSTRING("set_type"),
	HX_CSTRING("get_wordWrap"),
	HX_CSTRING("set_wordWrap"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(TextField_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_create,"lime_text_field_create");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_text,"lime_text_field_get_text");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_text,"lime_text_field_set_text");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_html_text,"lime_text_field_get_html_text");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_html_text,"lime_text_field_set_html_text");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_text_color,"lime_text_field_get_text_color");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_text_color,"lime_text_field_set_text_color");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_selectable,"lime_text_field_get_selectable");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_selectable,"lime_text_field_set_selectable");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_display_as_password,"lime_text_field_get_display_as_password");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_display_as_password,"lime_text_field_set_display_as_password");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_def_text_format,"lime_text_field_get_def_text_format");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_def_text_format,"lime_text_field_set_def_text_format");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_auto_size,"lime_text_field_get_auto_size");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_auto_size,"lime_text_field_set_auto_size");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_type,"lime_text_field_get_type");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_type,"lime_text_field_set_type");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_multiline,"lime_text_field_get_multiline");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_multiline,"lime_text_field_set_multiline");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_word_wrap,"lime_text_field_get_word_wrap");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_word_wrap,"lime_text_field_set_word_wrap");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_border,"lime_text_field_get_border");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_border,"lime_text_field_set_border");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_border_color,"lime_text_field_get_border_color");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_border_color,"lime_text_field_set_border_color");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_background,"lime_text_field_get_background");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_background,"lime_text_field_set_background");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_background_color,"lime_text_field_get_background_color");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_background_color,"lime_text_field_set_background_color");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_text_width,"lime_text_field_get_text_width");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_text_height,"lime_text_field_get_text_height");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_text_format,"lime_text_field_get_text_format");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_text_format,"lime_text_field_set_text_format");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_max_scroll_v,"lime_text_field_get_max_scroll_v");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_max_scroll_h,"lime_text_field_get_max_scroll_h");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_bottom_scroll_v,"lime_text_field_get_bottom_scroll_v");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_scroll_h,"lime_text_field_get_scroll_h");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_scroll_h,"lime_text_field_set_scroll_h");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_scroll_v,"lime_text_field_get_scroll_v");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_scroll_v,"lime_text_field_set_scroll_v");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_num_lines,"lime_text_field_get_num_lines");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_max_chars,"lime_text_field_get_max_chars");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_set_max_chars,"lime_text_field_set_max_chars");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_line_text,"lime_text_field_get_line_text");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_line_metrics,"lime_text_field_get_line_metrics");
	HX_MARK_MEMBER_NAME(TextField_obj::lime_text_field_get_line_offset,"lime_text_field_get_line_offset");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(TextField_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_create,"lime_text_field_create");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_text,"lime_text_field_get_text");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_text,"lime_text_field_set_text");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_html_text,"lime_text_field_get_html_text");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_html_text,"lime_text_field_set_html_text");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_text_color,"lime_text_field_get_text_color");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_text_color,"lime_text_field_set_text_color");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_selectable,"lime_text_field_get_selectable");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_selectable,"lime_text_field_set_selectable");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_display_as_password,"lime_text_field_get_display_as_password");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_display_as_password,"lime_text_field_set_display_as_password");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_def_text_format,"lime_text_field_get_def_text_format");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_def_text_format,"lime_text_field_set_def_text_format");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_auto_size,"lime_text_field_get_auto_size");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_auto_size,"lime_text_field_set_auto_size");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_type,"lime_text_field_get_type");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_type,"lime_text_field_set_type");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_multiline,"lime_text_field_get_multiline");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_multiline,"lime_text_field_set_multiline");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_word_wrap,"lime_text_field_get_word_wrap");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_word_wrap,"lime_text_field_set_word_wrap");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_border,"lime_text_field_get_border");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_border,"lime_text_field_set_border");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_border_color,"lime_text_field_get_border_color");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_border_color,"lime_text_field_set_border_color");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_background,"lime_text_field_get_background");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_background,"lime_text_field_set_background");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_background_color,"lime_text_field_get_background_color");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_background_color,"lime_text_field_set_background_color");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_text_width,"lime_text_field_get_text_width");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_text_height,"lime_text_field_get_text_height");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_text_format,"lime_text_field_get_text_format");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_text_format,"lime_text_field_set_text_format");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_max_scroll_v,"lime_text_field_get_max_scroll_v");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_max_scroll_h,"lime_text_field_get_max_scroll_h");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_bottom_scroll_v,"lime_text_field_get_bottom_scroll_v");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_scroll_h,"lime_text_field_get_scroll_h");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_scroll_h,"lime_text_field_set_scroll_h");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_scroll_v,"lime_text_field_get_scroll_v");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_scroll_v,"lime_text_field_set_scroll_v");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_num_lines,"lime_text_field_get_num_lines");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_max_chars,"lime_text_field_get_max_chars");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_set_max_chars,"lime_text_field_set_max_chars");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_line_text,"lime_text_field_get_line_text");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_line_metrics,"lime_text_field_get_line_metrics");
	HX_VISIT_MEMBER_NAME(TextField_obj::lime_text_field_get_line_offset,"lime_text_field_get_line_offset");
};

#endif

Class TextField_obj::__mClass;

void TextField_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("flash.text.TextField"), hx::TCanCast< TextField_obj> ,sStaticFields,sMemberFields,
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

void TextField_obj::__boot()
{
	lime_text_field_create= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_create"),(int)0);
	lime_text_field_get_text= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_text"),(int)1);
	lime_text_field_set_text= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_text"),(int)2);
	lime_text_field_get_html_text= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_html_text"),(int)1);
	lime_text_field_set_html_text= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_html_text"),(int)2);
	lime_text_field_get_text_color= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_text_color"),(int)1);
	lime_text_field_set_text_color= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_text_color"),(int)2);
	lime_text_field_get_selectable= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_selectable"),(int)1);
	lime_text_field_set_selectable= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_selectable"),(int)2);
	lime_text_field_get_display_as_password= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_display_as_password"),(int)1);
	lime_text_field_set_display_as_password= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_display_as_password"),(int)2);
	lime_text_field_get_def_text_format= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_def_text_format"),(int)2);
	lime_text_field_set_def_text_format= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_def_text_format"),(int)2);
	lime_text_field_get_auto_size= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_auto_size"),(int)1);
	lime_text_field_set_auto_size= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_auto_size"),(int)2);
	lime_text_field_get_type= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_type"),(int)1);
	lime_text_field_set_type= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_type"),(int)2);
	lime_text_field_get_multiline= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_multiline"),(int)1);
	lime_text_field_set_multiline= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_multiline"),(int)2);
	lime_text_field_get_word_wrap= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_word_wrap"),(int)1);
	lime_text_field_set_word_wrap= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_word_wrap"),(int)2);
	lime_text_field_get_border= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_border"),(int)1);
	lime_text_field_set_border= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_border"),(int)2);
	lime_text_field_get_border_color= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_border_color"),(int)1);
	lime_text_field_set_border_color= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_border_color"),(int)2);
	lime_text_field_get_background= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_background"),(int)1);
	lime_text_field_set_background= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_background"),(int)2);
	lime_text_field_get_background_color= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_background_color"),(int)1);
	lime_text_field_set_background_color= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_background_color"),(int)2);
	lime_text_field_get_text_width= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_text_width"),(int)1);
	lime_text_field_get_text_height= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_text_height"),(int)1);
	lime_text_field_get_text_format= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_text_format"),(int)4);
	lime_text_field_set_text_format= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_text_format"),(int)4);
	lime_text_field_get_max_scroll_v= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_max_scroll_v"),(int)1);
	lime_text_field_get_max_scroll_h= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_max_scroll_h"),(int)1);
	lime_text_field_get_bottom_scroll_v= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_bottom_scroll_v"),(int)1);
	lime_text_field_get_scroll_h= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_scroll_h"),(int)1);
	lime_text_field_set_scroll_h= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_scroll_h"),(int)2);
	lime_text_field_get_scroll_v= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_scroll_v"),(int)1);
	lime_text_field_set_scroll_v= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_scroll_v"),(int)2);
	lime_text_field_get_num_lines= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_num_lines"),(int)1);
	lime_text_field_get_max_chars= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_max_chars"),(int)1);
	lime_text_field_set_max_chars= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_set_max_chars"),(int)2);
	lime_text_field_get_line_text= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_line_text"),(int)2);
	lime_text_field_get_line_metrics= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_line_metrics"),(int)3);
	lime_text_field_get_line_offset= ::flash::Lib_obj::load(HX_CSTRING("lime"),HX_CSTRING("lime_text_field_get_line_offset"),(int)2);
}

} // end namespace flash
} // end namespace text
