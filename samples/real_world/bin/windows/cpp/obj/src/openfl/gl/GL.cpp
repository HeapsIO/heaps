#include <hxcpp.h>

#ifndef INCLUDED_flash_Lib
#include <flash/Lib.h>
#endif
#ifndef INCLUDED_flash_display_BitmapData
#include <flash/display/BitmapData.h>
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
#ifndef INCLUDED_flash_display_MovieClip
#include <flash/display/MovieClip.h>
#endif
#ifndef INCLUDED_flash_display_Sprite
#include <flash/display/Sprite.h>
#endif
#ifndef INCLUDED_flash_display_Stage
#include <flash/display/Stage.h>
#endif
#ifndef INCLUDED_flash_events_EventDispatcher
#include <flash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_flash_events_IEventDispatcher
#include <flash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_flash_geom_Matrix3D
#include <flash/geom/Matrix3D.h>
#endif
#ifndef INCLUDED_flash_utils_ByteArray
#include <flash/utils/ByteArray.h>
#endif
#ifndef INCLUDED_flash_utils_IDataInput
#include <flash/utils/IDataInput.h>
#endif
#ifndef INCLUDED_flash_utils_IDataOutput
#include <flash/utils/IDataOutput.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_openfl_gl_GL
#include <openfl/gl/GL.h>
#endif
#ifndef INCLUDED_openfl_gl_GLBuffer
#include <openfl/gl/GLBuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLFramebuffer
#include <openfl/gl/GLFramebuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLObject
#include <openfl/gl/GLObject.h>
#endif
#ifndef INCLUDED_openfl_gl_GLProgram
#include <openfl/gl/GLProgram.h>
#endif
#ifndef INCLUDED_openfl_gl_GLRenderbuffer
#include <openfl/gl/GLRenderbuffer.h>
#endif
#ifndef INCLUDED_openfl_gl_GLShader
#include <openfl/gl/GLShader.h>
#endif
#ifndef INCLUDED_openfl_gl_GLTexture
#include <openfl/gl/GLTexture.h>
#endif
#ifndef INCLUDED_openfl_utils_ArrayBufferView
#include <openfl/utils/ArrayBufferView.h>
#endif
#ifndef INCLUDED_openfl_utils_Float32Array
#include <openfl/utils/Float32Array.h>
#endif
#ifndef INCLUDED_openfl_utils_IMemoryRange
#include <openfl/utils/IMemoryRange.h>
#endif
namespace openfl{
namespace gl{

Void GL_obj::__construct()
{
	return null();
}

//GL_obj::~GL_obj() { }

Dynamic GL_obj::__CreateEmpty() { return  new GL_obj; }
hx::ObjectPtr< GL_obj > GL_obj::__new()
{  hx::ObjectPtr< GL_obj > result = new GL_obj();
	result->__construct();
	return result;}

Dynamic GL_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< GL_obj > result = new GL_obj();
	result->__construct();
	return result;}

int GL_obj::DEPTH_BUFFER_BIT;

int GL_obj::STENCIL_BUFFER_BIT;

int GL_obj::COLOR_BUFFER_BIT;

int GL_obj::POINTS;

int GL_obj::LINES;

int GL_obj::LINE_LOOP;

int GL_obj::LINE_STRIP;

int GL_obj::TRIANGLES;

int GL_obj::TRIANGLE_STRIP;

int GL_obj::TRIANGLE_FAN;

int GL_obj::ZERO;

int GL_obj::ONE;

int GL_obj::SRC_COLOR;

int GL_obj::ONE_MINUS_SRC_COLOR;

int GL_obj::SRC_ALPHA;

int GL_obj::ONE_MINUS_SRC_ALPHA;

int GL_obj::DST_ALPHA;

int GL_obj::ONE_MINUS_DST_ALPHA;

int GL_obj::DST_COLOR;

int GL_obj::ONE_MINUS_DST_COLOR;

int GL_obj::SRC_ALPHA_SATURATE;

int GL_obj::FUNC_ADD;

int GL_obj::BLEND_EQUATION;

int GL_obj::BLEND_EQUATION_RGB;

int GL_obj::BLEND_EQUATION_ALPHA;

int GL_obj::FUNC_SUBTRACT;

int GL_obj::FUNC_REVERSE_SUBTRACT;

int GL_obj::BLEND_DST_RGB;

int GL_obj::BLEND_SRC_RGB;

int GL_obj::BLEND_DST_ALPHA;

int GL_obj::BLEND_SRC_ALPHA;

int GL_obj::CONSTANT_COLOR;

int GL_obj::ONE_MINUS_CONSTANT_COLOR;

int GL_obj::CONSTANT_ALPHA;

int GL_obj::ONE_MINUS_CONSTANT_ALPHA;

int GL_obj::BLEND_COLOR;

int GL_obj::ARRAY_BUFFER;

int GL_obj::ELEMENT_ARRAY_BUFFER;

int GL_obj::ARRAY_BUFFER_BINDING;

int GL_obj::ELEMENT_ARRAY_BUFFER_BINDING;

int GL_obj::STREAM_DRAW;

int GL_obj::STATIC_DRAW;

int GL_obj::DYNAMIC_DRAW;

int GL_obj::BUFFER_SIZE;

int GL_obj::BUFFER_USAGE;

int GL_obj::CURRENT_VERTEX_ATTRIB;

int GL_obj::FRONT;

int GL_obj::BACK;

int GL_obj::FRONT_AND_BACK;

int GL_obj::CULL_FACE;

int GL_obj::BLEND;

int GL_obj::DITHER;

int GL_obj::STENCIL_TEST;

int GL_obj::DEPTH_TEST;

int GL_obj::SCISSOR_TEST;

int GL_obj::POLYGON_OFFSET_FILL;

int GL_obj::SAMPLE_ALPHA_TO_COVERAGE;

int GL_obj::SAMPLE_COVERAGE;

int GL_obj::NO_ERROR;

int GL_obj::INVALID_ENUM;

int GL_obj::INVALID_VALUE;

int GL_obj::INVALID_OPERATION;

int GL_obj::OUT_OF_MEMORY;

int GL_obj::CW;

int GL_obj::CCW;

int GL_obj::LINE_WIDTH;

int GL_obj::ALIASED_POINT_SIZE_RANGE;

int GL_obj::ALIASED_LINE_WIDTH_RANGE;

int GL_obj::CULL_FACE_MODE;

int GL_obj::FRONT_FACE;

int GL_obj::DEPTH_RANGE;

int GL_obj::DEPTH_WRITEMASK;

int GL_obj::DEPTH_CLEAR_VALUE;

int GL_obj::DEPTH_FUNC;

int GL_obj::STENCIL_CLEAR_VALUE;

int GL_obj::STENCIL_FUNC;

int GL_obj::STENCIL_FAIL;

int GL_obj::STENCIL_PASS_DEPTH_FAIL;

int GL_obj::STENCIL_PASS_DEPTH_PASS;

int GL_obj::STENCIL_REF;

int GL_obj::STENCIL_VALUE_MASK;

int GL_obj::STENCIL_WRITEMASK;

int GL_obj::STENCIL_BACK_FUNC;

int GL_obj::STENCIL_BACK_FAIL;

int GL_obj::STENCIL_BACK_PASS_DEPTH_FAIL;

int GL_obj::STENCIL_BACK_PASS_DEPTH_PASS;

int GL_obj::STENCIL_BACK_REF;

int GL_obj::STENCIL_BACK_VALUE_MASK;

int GL_obj::STENCIL_BACK_WRITEMASK;

int GL_obj::VIEWPORT;

int GL_obj::SCISSOR_BOX;

int GL_obj::COLOR_CLEAR_VALUE;

int GL_obj::COLOR_WRITEMASK;

int GL_obj::UNPACK_ALIGNMENT;

int GL_obj::PACK_ALIGNMENT;

int GL_obj::MAX_TEXTURE_SIZE;

int GL_obj::MAX_VIEWPORT_DIMS;

int GL_obj::SUBPIXEL_BITS;

int GL_obj::RED_BITS;

int GL_obj::GREEN_BITS;

int GL_obj::BLUE_BITS;

int GL_obj::ALPHA_BITS;

int GL_obj::DEPTH_BITS;

int GL_obj::STENCIL_BITS;

int GL_obj::POLYGON_OFFSET_UNITS;

int GL_obj::POLYGON_OFFSET_FACTOR;

int GL_obj::TEXTURE_BINDING_2D;

int GL_obj::SAMPLE_BUFFERS;

int GL_obj::SAMPLES;

int GL_obj::SAMPLE_COVERAGE_VALUE;

int GL_obj::SAMPLE_COVERAGE_INVERT;

int GL_obj::COMPRESSED_TEXTURE_FORMATS;

int GL_obj::DONT_CARE;

int GL_obj::FASTEST;

int GL_obj::NICEST;

int GL_obj::GENERATE_MIPMAP_HINT;

int GL_obj::BYTE;

int GL_obj::UNSIGNED_BYTE;

int GL_obj::SHORT;

int GL_obj::UNSIGNED_SHORT;

int GL_obj::INT;

int GL_obj::UNSIGNED_INT;

int GL_obj::FLOAT;

int GL_obj::DEPTH_COMPONENT;

int GL_obj::ALPHA;

int GL_obj::RGB;

int GL_obj::RGBA;

int GL_obj::LUMINANCE;

int GL_obj::LUMINANCE_ALPHA;

int GL_obj::UNSIGNED_SHORT_4_4_4_4;

int GL_obj::UNSIGNED_SHORT_5_5_5_1;

int GL_obj::UNSIGNED_SHORT_5_6_5;

int GL_obj::FRAGMENT_SHADER;

int GL_obj::VERTEX_SHADER;

int GL_obj::MAX_VERTEX_ATTRIBS;

int GL_obj::MAX_VERTEX_UNIFORM_VECTORS;

int GL_obj::MAX_VARYING_VECTORS;

int GL_obj::MAX_COMBINED_TEXTURE_IMAGE_UNITS;

int GL_obj::MAX_VERTEX_TEXTURE_IMAGE_UNITS;

int GL_obj::MAX_TEXTURE_IMAGE_UNITS;

int GL_obj::MAX_FRAGMENT_UNIFORM_VECTORS;

int GL_obj::SHADER_TYPE;

int GL_obj::DELETE_STATUS;

int GL_obj::LINK_STATUS;

int GL_obj::VALIDATE_STATUS;

int GL_obj::ATTACHED_SHADERS;

int GL_obj::ACTIVE_UNIFORMS;

int GL_obj::ACTIVE_ATTRIBUTES;

int GL_obj::SHADING_LANGUAGE_VERSION;

int GL_obj::CURRENT_PROGRAM;

int GL_obj::NEVER;

int GL_obj::LESS;

int GL_obj::EQUAL;

int GL_obj::LEQUAL;

int GL_obj::GREATER;

int GL_obj::NOTEQUAL;

int GL_obj::GEQUAL;

int GL_obj::ALWAYS;

int GL_obj::KEEP;

int GL_obj::REPLACE;

int GL_obj::INCR;

int GL_obj::DECR;

int GL_obj::INVERT;

int GL_obj::INCR_WRAP;

int GL_obj::DECR_WRAP;

int GL_obj::VENDOR;

int GL_obj::RENDERER;

int GL_obj::VERSION;

int GL_obj::NEAREST;

int GL_obj::LINEAR;

int GL_obj::NEAREST_MIPMAP_NEAREST;

int GL_obj::LINEAR_MIPMAP_NEAREST;

int GL_obj::NEAREST_MIPMAP_LINEAR;

int GL_obj::LINEAR_MIPMAP_LINEAR;

int GL_obj::TEXTURE_MAG_FILTER;

int GL_obj::TEXTURE_MIN_FILTER;

int GL_obj::TEXTURE_WRAP_S;

int GL_obj::TEXTURE_WRAP_T;

int GL_obj::TEXTURE_2D;

int GL_obj::TEXTURE;

int GL_obj::TEXTURE_CUBE_MAP;

int GL_obj::TEXTURE_BINDING_CUBE_MAP;

int GL_obj::TEXTURE_CUBE_MAP_POSITIVE_X;

int GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_X;

int GL_obj::TEXTURE_CUBE_MAP_POSITIVE_Y;

int GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_Y;

int GL_obj::TEXTURE_CUBE_MAP_POSITIVE_Z;

int GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_Z;

int GL_obj::MAX_CUBE_MAP_TEXTURE_SIZE;

int GL_obj::TEXTURE0;

int GL_obj::TEXTURE1;

int GL_obj::TEXTURE2;

int GL_obj::TEXTURE3;

int GL_obj::TEXTURE4;

int GL_obj::TEXTURE5;

int GL_obj::TEXTURE6;

int GL_obj::TEXTURE7;

int GL_obj::TEXTURE8;

int GL_obj::TEXTURE9;

int GL_obj::TEXTURE10;

int GL_obj::TEXTURE11;

int GL_obj::TEXTURE12;

int GL_obj::TEXTURE13;

int GL_obj::TEXTURE14;

int GL_obj::TEXTURE15;

int GL_obj::TEXTURE16;

int GL_obj::TEXTURE17;

int GL_obj::TEXTURE18;

int GL_obj::TEXTURE19;

int GL_obj::TEXTURE20;

int GL_obj::TEXTURE21;

int GL_obj::TEXTURE22;

int GL_obj::TEXTURE23;

int GL_obj::TEXTURE24;

int GL_obj::TEXTURE25;

int GL_obj::TEXTURE26;

int GL_obj::TEXTURE27;

int GL_obj::TEXTURE28;

int GL_obj::TEXTURE29;

int GL_obj::TEXTURE30;

int GL_obj::TEXTURE31;

int GL_obj::ACTIVE_TEXTURE;

int GL_obj::REPEAT;

int GL_obj::CLAMP_TO_EDGE;

int GL_obj::MIRRORED_REPEAT;

int GL_obj::FLOAT_VEC2;

int GL_obj::FLOAT_VEC3;

int GL_obj::FLOAT_VEC4;

int GL_obj::INT_VEC2;

int GL_obj::INT_VEC3;

int GL_obj::INT_VEC4;

int GL_obj::BOOL;

int GL_obj::BOOL_VEC2;

int GL_obj::BOOL_VEC3;

int GL_obj::BOOL_VEC4;

int GL_obj::FLOAT_MAT2;

int GL_obj::FLOAT_MAT3;

int GL_obj::FLOAT_MAT4;

int GL_obj::SAMPLER_2D;

int GL_obj::SAMPLER_CUBE;

int GL_obj::VERTEX_ATTRIB_ARRAY_ENABLED;

int GL_obj::VERTEX_ATTRIB_ARRAY_SIZE;

int GL_obj::VERTEX_ATTRIB_ARRAY_STRIDE;

int GL_obj::VERTEX_ATTRIB_ARRAY_TYPE;

int GL_obj::VERTEX_ATTRIB_ARRAY_NORMALIZED;

int GL_obj::VERTEX_ATTRIB_ARRAY_POINTER;

int GL_obj::VERTEX_ATTRIB_ARRAY_BUFFER_BINDING;

int GL_obj::VERTEX_PROGRAM_POINT_SIZE;

int GL_obj::POINT_SPRITE;

int GL_obj::COMPILE_STATUS;

int GL_obj::LOW_FLOAT;

int GL_obj::MEDIUM_FLOAT;

int GL_obj::HIGH_FLOAT;

int GL_obj::LOW_INT;

int GL_obj::MEDIUM_INT;

int GL_obj::HIGH_INT;

int GL_obj::FRAMEBUFFER;

int GL_obj::RENDERBUFFER;

int GL_obj::RGBA4;

int GL_obj::RGB5_A1;

int GL_obj::RGB565;

int GL_obj::DEPTH_COMPONENT16;

int GL_obj::STENCIL_INDEX;

int GL_obj::STENCIL_INDEX8;

int GL_obj::DEPTH_STENCIL;

int GL_obj::RENDERBUFFER_WIDTH;

int GL_obj::RENDERBUFFER_HEIGHT;

int GL_obj::RENDERBUFFER_INTERNAL_FORMAT;

int GL_obj::RENDERBUFFER_RED_SIZE;

int GL_obj::RENDERBUFFER_GREEN_SIZE;

int GL_obj::RENDERBUFFER_BLUE_SIZE;

int GL_obj::RENDERBUFFER_ALPHA_SIZE;

int GL_obj::RENDERBUFFER_DEPTH_SIZE;

int GL_obj::RENDERBUFFER_STENCIL_SIZE;

int GL_obj::FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE;

int GL_obj::FRAMEBUFFER_ATTACHMENT_OBJECT_NAME;

int GL_obj::FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL;

int GL_obj::FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE;

int GL_obj::COLOR_ATTACHMENT0;

int GL_obj::DEPTH_ATTACHMENT;

int GL_obj::STENCIL_ATTACHMENT;

int GL_obj::DEPTH_STENCIL_ATTACHMENT;

int GL_obj::NONE;

int GL_obj::FRAMEBUFFER_COMPLETE;

int GL_obj::FRAMEBUFFER_INCOMPLETE_ATTACHMENT;

int GL_obj::FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT;

int GL_obj::FRAMEBUFFER_INCOMPLETE_DIMENSIONS;

int GL_obj::FRAMEBUFFER_UNSUPPORTED;

int GL_obj::FRAMEBUFFER_BINDING;

int GL_obj::RENDERBUFFER_BINDING;

int GL_obj::MAX_RENDERBUFFER_SIZE;

int GL_obj::INVALID_FRAMEBUFFER_OPERATION;

int GL_obj::UNPACK_FLIP_Y_WEBGL;

int GL_obj::UNPACK_PREMULTIPLY_ALPHA_WEBGL;

int GL_obj::CONTEXT_LOST_WEBGL;

int GL_obj::UNPACK_COLORSPACE_CONVERSION_WEBGL;

int GL_obj::BROWSER_DEFAULT_WEBGL;

int GL_obj::drawingBufferHeight;

int GL_obj::drawingBufferWidth;

int GL_obj::version;

Void GL_obj::activeTexture( int texture){
{
		HX_STACK_FRAME("openfl.gl.GL","activeTexture",0x9fd0ac37,"openfl.gl.GL.activeTexture","openfl/gl/GL.hx",436,0x296f94ae)
		HX_STACK_ARG(texture,"texture")
		HX_STACK_LINE(436)
		::openfl::gl::GL_obj::lime_gl_active_texture(texture);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,activeTexture,(void))

Void GL_obj::attachShader( ::openfl::gl::GLProgram program,::openfl::gl::GLShader shader){
{
		HX_STACK_FRAME("openfl.gl.GL","attachShader",0xdf913e88,"openfl.gl.GL.attachShader","openfl/gl/GL.hx",439,0x296f94ae)
		HX_STACK_ARG(program,"program")
		HX_STACK_ARG(shader,"shader")
		HX_STACK_LINE(440)
		program->attach(shader);
		HX_STACK_LINE(441)
		::openfl::gl::GL_obj::lime_gl_attach_shader(program->id,shader->id);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,attachShader,(void))

Void GL_obj::bindAttribLocation( ::openfl::gl::GLProgram program,int index,::String name){
{
		HX_STACK_FRAME("openfl.gl.GL","bindAttribLocation",0x2487f67a,"openfl.gl.GL.bindAttribLocation","openfl/gl/GL.hx",446,0x296f94ae)
		HX_STACK_ARG(program,"program")
		HX_STACK_ARG(index,"index")
		HX_STACK_ARG(name,"name")
		HX_STACK_LINE(446)
		::openfl::gl::GL_obj::lime_gl_bind_attrib_location(program->id,index,name);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,bindAttribLocation,(void))

Void GL_obj::bindBitmapDataTexture( ::flash::display::BitmapData texture){
{
		HX_STACK_FRAME("openfl.gl.GL","bindBitmapDataTexture",0x83bec427,"openfl.gl.GL.bindBitmapDataTexture","openfl/gl/GL.hx",451,0x296f94ae)
		HX_STACK_ARG(texture,"texture")
		HX_STACK_LINE(451)
		::openfl::gl::GL_obj::lime_gl_bind_bitmap_data_texture(texture->__handle);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,bindBitmapDataTexture,(void))

Void GL_obj::bindBuffer( int target,::openfl::gl::GLBuffer buffer){
{
		HX_STACK_FRAME("openfl.gl.GL","bindBuffer",0x54ec74db,"openfl.gl.GL.bindBuffer","openfl/gl/GL.hx",456,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(buffer,"buffer")
		HX_STACK_LINE(456)
		::openfl::gl::GL_obj::lime_gl_bind_buffer(target,(  (((buffer == null()))) ? Dynamic(null()) : Dynamic(buffer->id) ));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,bindBuffer,(void))

Void GL_obj::bindFramebuffer( int target,::openfl::gl::GLFramebuffer framebuffer){
{
		HX_STACK_FRAME("openfl.gl.GL","bindFramebuffer",0xb9c10332,"openfl.gl.GL.bindFramebuffer","openfl/gl/GL.hx",461,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(framebuffer,"framebuffer")
		HX_STACK_LINE(461)
		::openfl::gl::GL_obj::lime_gl_bind_framebuffer(target,(  (((framebuffer == null()))) ? Dynamic(null()) : Dynamic(framebuffer->id) ));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,bindFramebuffer,(void))

Void GL_obj::bindRenderbuffer( int target,::openfl::gl::GLRenderbuffer renderbuffer){
{
		HX_STACK_FRAME("openfl.gl.GL","bindRenderbuffer",0x55addaf1,"openfl.gl.GL.bindRenderbuffer","openfl/gl/GL.hx",466,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(renderbuffer,"renderbuffer")
		HX_STACK_LINE(466)
		::openfl::gl::GL_obj::lime_gl_bind_renderbuffer(target,(  (((renderbuffer == null()))) ? Dynamic(null()) : Dynamic(renderbuffer->id) ));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,bindRenderbuffer,(void))

Void GL_obj::bindTexture( int target,::openfl::gl::GLTexture texture){
{
		HX_STACK_FRAME("openfl.gl.GL","bindTexture",0xe749f0a0,"openfl.gl.GL.bindTexture","openfl/gl/GL.hx",471,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(texture,"texture")
		HX_STACK_LINE(471)
		::openfl::gl::GL_obj::lime_gl_bind_texture(target,(  (((texture == null()))) ? Dynamic(null()) : Dynamic(texture->id) ));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,bindTexture,(void))

Void GL_obj::blendColor( Float red,Float green,Float blue,Float alpha){
{
		HX_STACK_FRAME("openfl.gl.GL","blendColor",0x3ee21590,"openfl.gl.GL.blendColor","openfl/gl/GL.hx",476,0x296f94ae)
		HX_STACK_ARG(red,"red")
		HX_STACK_ARG(green,"green")
		HX_STACK_ARG(blue,"blue")
		HX_STACK_ARG(alpha,"alpha")
		HX_STACK_LINE(476)
		::openfl::gl::GL_obj::lime_gl_blend_color(red,green,blue,alpha);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,blendColor,(void))

Void GL_obj::blendEquation( int mode){
{
		HX_STACK_FRAME("openfl.gl.GL","blendEquation",0x4bd4317f,"openfl.gl.GL.blendEquation","openfl/gl/GL.hx",481,0x296f94ae)
		HX_STACK_ARG(mode,"mode")
		HX_STACK_LINE(481)
		::openfl::gl::GL_obj::lime_gl_blend_equation(mode);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,blendEquation,(void))

Void GL_obj::blendEquationSeparate( int modeRGB,int modeAlpha){
{
		HX_STACK_FRAME("openfl.gl.GL","blendEquationSeparate",0xfb7e2402,"openfl.gl.GL.blendEquationSeparate","openfl/gl/GL.hx",486,0x296f94ae)
		HX_STACK_ARG(modeRGB,"modeRGB")
		HX_STACK_ARG(modeAlpha,"modeAlpha")
		HX_STACK_LINE(486)
		::openfl::gl::GL_obj::lime_gl_blend_equation_separate(modeRGB,modeAlpha);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,blendEquationSeparate,(void))

Void GL_obj::blendFunc( int sfactor,int dfactor){
{
		HX_STACK_FRAME("openfl.gl.GL","blendFunc",0xf5a7abb7,"openfl.gl.GL.blendFunc","openfl/gl/GL.hx",491,0x296f94ae)
		HX_STACK_ARG(sfactor,"sfactor")
		HX_STACK_ARG(dfactor,"dfactor")
		HX_STACK_LINE(491)
		::openfl::gl::GL_obj::lime_gl_blend_func(sfactor,dfactor);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,blendFunc,(void))

Void GL_obj::blendFuncSeparate( int srcRGB,int dstRGB,int srcAlpha,int dstAlpha){
{
		HX_STACK_FRAME("openfl.gl.GL","blendFuncSeparate",0x612a963a,"openfl.gl.GL.blendFuncSeparate","openfl/gl/GL.hx",496,0x296f94ae)
		HX_STACK_ARG(srcRGB,"srcRGB")
		HX_STACK_ARG(dstRGB,"dstRGB")
		HX_STACK_ARG(srcAlpha,"srcAlpha")
		HX_STACK_ARG(dstAlpha,"dstAlpha")
		HX_STACK_LINE(496)
		::openfl::gl::GL_obj::lime_gl_blend_func_separate(srcRGB,dstRGB,srcAlpha,dstAlpha);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,blendFuncSeparate,(void))

Void GL_obj::bufferData( int target,::openfl::utils::IMemoryRange data,int usage){
{
		HX_STACK_FRAME("openfl.gl.GL","bufferData",0xefa1a188,"openfl.gl.GL.bufferData","openfl/gl/GL.hx",500,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(data,"data")
		HX_STACK_ARG(usage,"usage")
		HX_STACK_LINE(501)
		::flash::utils::ByteArray _g = data->getByteBuffer();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(501)
		int _g1 = data->getStart();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(501)
		int _g2 = data->getLength();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(501)
		::openfl::gl::GL_obj::lime_gl_buffer_data(target,_g,_g1,_g2,usage);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,bufferData,(void))

Void GL_obj::bufferSubData( int target,int offset,::openfl::utils::IMemoryRange data){
{
		HX_STACK_FRAME("openfl.gl.GL","bufferSubData",0x8f0b8f2c,"openfl.gl.GL.bufferSubData","openfl/gl/GL.hx",505,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(offset,"offset")
		HX_STACK_ARG(data,"data")
		HX_STACK_LINE(506)
		::flash::utils::ByteArray _g = data->getByteBuffer();		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(506)
		int _g1 = data->getStart();		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(506)
		int _g2 = data->getLength();		HX_STACK_VAR(_g2,"_g2");
		HX_STACK_LINE(506)
		::openfl::gl::GL_obj::lime_gl_buffer_sub_data(target,offset,_g,_g1,_g2);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,bufferSubData,(void))

int GL_obj::checkFramebufferStatus( int target){
	HX_STACK_FRAME("openfl.gl.GL","checkFramebufferStatus",0x498c6d55,"openfl.gl.GL.checkFramebufferStatus","openfl/gl/GL.hx",511,0x296f94ae)
	HX_STACK_ARG(target,"target")
	HX_STACK_LINE(511)
	return ::openfl::gl::GL_obj::lime_gl_check_framebuffer_status(target);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,checkFramebufferStatus,return )

Void GL_obj::clear( int mask){
{
		HX_STACK_FRAME("openfl.gl.GL","clear",0x6f34b80f,"openfl.gl.GL.clear","openfl/gl/GL.hx",516,0x296f94ae)
		HX_STACK_ARG(mask,"mask")
		HX_STACK_LINE(516)
		::openfl::gl::GL_obj::lime_gl_clear(mask);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,clear,(void))

Void GL_obj::clearColor( Float red,Float green,Float blue,Float alpha){
{
		HX_STACK_FRAME("openfl.gl.GL","clearColor",0x7b9492d4,"openfl.gl.GL.clearColor","openfl/gl/GL.hx",521,0x296f94ae)
		HX_STACK_ARG(red,"red")
		HX_STACK_ARG(green,"green")
		HX_STACK_ARG(blue,"blue")
		HX_STACK_ARG(alpha,"alpha")
		HX_STACK_LINE(521)
		::openfl::gl::GL_obj::lime_gl_clear_color(red,green,blue,alpha);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,clearColor,(void))

Void GL_obj::clearDepth( Float depth){
{
		HX_STACK_FRAME("openfl.gl.GL","clearDepth",0x08621274,"openfl.gl.GL.clearDepth","openfl/gl/GL.hx",526,0x296f94ae)
		HX_STACK_ARG(depth,"depth")
		HX_STACK_LINE(526)
		::openfl::gl::GL_obj::lime_gl_clear_depth(depth);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,clearDepth,(void))

Void GL_obj::clearStencil( int s){
{
		HX_STACK_FRAME("openfl.gl.GL","clearStencil",0x889bddad,"openfl.gl.GL.clearStencil","openfl/gl/GL.hx",531,0x296f94ae)
		HX_STACK_ARG(s,"s")
		HX_STACK_LINE(531)
		::openfl::gl::GL_obj::lime_gl_clear_stencil(s);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,clearStencil,(void))

Void GL_obj::colorMask( bool red,bool green,bool blue,bool alpha){
{
		HX_STACK_FRAME("openfl.gl.GL","colorMask",0x11cf7b71,"openfl.gl.GL.colorMask","openfl/gl/GL.hx",536,0x296f94ae)
		HX_STACK_ARG(red,"red")
		HX_STACK_ARG(green,"green")
		HX_STACK_ARG(blue,"blue")
		HX_STACK_ARG(alpha,"alpha")
		HX_STACK_LINE(536)
		::openfl::gl::GL_obj::lime_gl_color_mask(red,green,blue,alpha);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,colorMask,(void))

Void GL_obj::compileShader( ::openfl::gl::GLShader shader){
{
		HX_STACK_FRAME("openfl.gl.GL","compileShader",0x23d9097a,"openfl.gl.GL.compileShader","openfl/gl/GL.hx",541,0x296f94ae)
		HX_STACK_ARG(shader,"shader")
		HX_STACK_LINE(541)
		::openfl::gl::GL_obj::lime_gl_compile_shader(shader->id);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,compileShader,(void))

Void GL_obj::compressedTexImage2D( int target,int level,int internalformat,int width,int height,int border,::openfl::utils::IMemoryRange data){
{
		HX_STACK_FRAME("openfl.gl.GL","compressedTexImage2D",0xeb583465,"openfl.gl.GL.compressedTexImage2D","openfl/gl/GL.hx",545,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(level,"level")
		HX_STACK_ARG(internalformat,"internalformat")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_ARG(border,"border")
		HX_STACK_ARG(data,"data")
		HX_STACK_LINE(546)
		::flash::utils::ByteArray _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(546)
		if (((data == null()))){
			HX_STACK_LINE(546)
			_g = null();
		}
		else{
			HX_STACK_LINE(546)
			_g = data->getByteBuffer();
		}
		HX_STACK_LINE(546)
		Dynamic _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(546)
		if (((data == null()))){
			HX_STACK_LINE(546)
			_g1 = null();
		}
		else{
			HX_STACK_LINE(546)
			_g1 = data->getStart();
		}
		HX_STACK_LINE(546)
		::openfl::gl::GL_obj::lime_gl_compressed_tex_image_2d(target,level,internalformat,width,height,border,_g,_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(GL_obj,compressedTexImage2D,(void))

Void GL_obj::compressedTexSubImage2D( int target,int level,int xoffset,int yoffset,int width,int height,int format,::openfl::utils::IMemoryRange data){
{
		HX_STACK_FRAME("openfl.gl.GL","compressedTexSubImage2D",0x2bc4c4d5,"openfl.gl.GL.compressedTexSubImage2D","openfl/gl/GL.hx",550,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(level,"level")
		HX_STACK_ARG(xoffset,"xoffset")
		HX_STACK_ARG(yoffset,"yoffset")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_ARG(format,"format")
		HX_STACK_ARG(data,"data")
		HX_STACK_LINE(551)
		::flash::utils::ByteArray _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(551)
		if (((data == null()))){
			HX_STACK_LINE(551)
			_g = null();
		}
		else{
			HX_STACK_LINE(551)
			_g = data->getByteBuffer();
		}
		HX_STACK_LINE(551)
		Dynamic _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(551)
		if (((data == null()))){
			HX_STACK_LINE(551)
			_g1 = null();
		}
		else{
			HX_STACK_LINE(551)
			_g1 = data->getStart();
		}
		HX_STACK_LINE(551)
		::openfl::gl::GL_obj::lime_gl_compressed_tex_sub_image_2d(target,level,xoffset,yoffset,width,height,format,_g,_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC8(GL_obj,compressedTexSubImage2D,(void))

Void GL_obj::copyTexImage2D( int target,int level,int internalformat,int x,int y,int width,int height,int border){
{
		HX_STACK_FRAME("openfl.gl.GL","copyTexImage2D",0x9d15aa19,"openfl.gl.GL.copyTexImage2D","openfl/gl/GL.hx",556,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(level,"level")
		HX_STACK_ARG(internalformat,"internalformat")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_ARG(border,"border")
		HX_STACK_LINE(556)
		::openfl::gl::GL_obj::lime_gl_copy_tex_image_2d(target,level,internalformat,x,y,width,height,border);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC8(GL_obj,copyTexImage2D,(void))

Void GL_obj::copyTexSubImage2D( int target,int level,int xoffset,int yoffset,int x,int y,int width,int height){
{
		HX_STACK_FRAME("openfl.gl.GL","copyTexSubImage2D",0x3b18d7a1,"openfl.gl.GL.copyTexSubImage2D","openfl/gl/GL.hx",561,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(level,"level")
		HX_STACK_ARG(xoffset,"xoffset")
		HX_STACK_ARG(yoffset,"yoffset")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(561)
		::openfl::gl::GL_obj::lime_gl_copy_tex_sub_image_2d(target,level,xoffset,yoffset,x,y,width,height);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC8(GL_obj,copyTexSubImage2D,(void))

::openfl::gl::GLBuffer GL_obj::createBuffer( ){
	HX_STACK_FRAME("openfl.gl.GL","createBuffer",0x20036ada,"openfl.gl.GL.createBuffer","openfl/gl/GL.hx",565,0x296f94ae)
	HX_STACK_LINE(566)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(566)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_buffer();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(566)
	return ::openfl::gl::GLBuffer_obj::__new(_g,_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,createBuffer,return )

::openfl::gl::GLFramebuffer GL_obj::createFramebuffer( ){
	HX_STACK_FRAME("openfl.gl.GL","createFramebuffer",0x6352f0d3,"openfl.gl.GL.createFramebuffer","openfl/gl/GL.hx",570,0x296f94ae)
	HX_STACK_LINE(571)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(571)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_framebuffer();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(571)
	return ::openfl::gl::GLFramebuffer_obj::__new(_g,_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,createFramebuffer,return )

::openfl::gl::GLProgram GL_obj::createProgram( ){
	HX_STACK_FRAME("openfl.gl.GL","createProgram",0x2562bb6a,"openfl.gl.GL.createProgram","openfl/gl/GL.hx",575,0x296f94ae)
	HX_STACK_LINE(576)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(576)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_program();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(576)
	return ::openfl::gl::GLProgram_obj::__new(_g,_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,createProgram,return )

::openfl::gl::GLRenderbuffer GL_obj::createRenderbuffer( ){
	HX_STACK_FRAME("openfl.gl.GL","createRenderbuffer",0x0bcbda30,"openfl.gl.GL.createRenderbuffer","openfl/gl/GL.hx",580,0x296f94ae)
	HX_STACK_LINE(581)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(581)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_render_buffer();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(581)
	return ::openfl::gl::GLRenderbuffer_obj::__new(_g,_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,createRenderbuffer,return )

::openfl::gl::GLShader GL_obj::createShader( int type){
	HX_STACK_FRAME("openfl.gl.GL","createShader",0x6c8f6cff,"openfl.gl.GL.createShader","openfl/gl/GL.hx",585,0x296f94ae)
	HX_STACK_ARG(type,"type")
	HX_STACK_LINE(586)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(586)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_shader(type);		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(586)
	return ::openfl::gl::GLShader_obj::__new(_g,_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,createShader,return )

::openfl::gl::GLTexture GL_obj::createTexture( ){
	HX_STACK_FRAME("openfl.gl.GL","createTexture",0xd04a39c1,"openfl.gl.GL.createTexture","openfl/gl/GL.hx",590,0x296f94ae)
	HX_STACK_LINE(591)
	int _g = ::openfl::gl::GL_obj::get_version();		HX_STACK_VAR(_g,"_g");
	HX_STACK_LINE(591)
	Dynamic _g1 = ::openfl::gl::GL_obj::lime_gl_create_texture();		HX_STACK_VAR(_g1,"_g1");
	HX_STACK_LINE(591)
	return ::openfl::gl::GLTexture_obj::__new(_g,_g1);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,createTexture,return )

Void GL_obj::cullFace( int mode){
{
		HX_STACK_FRAME("openfl.gl.GL","cullFace",0x2dd61e2d,"openfl.gl.GL.cullFace","openfl/gl/GL.hx",596,0x296f94ae)
		HX_STACK_ARG(mode,"mode")
		HX_STACK_LINE(596)
		::openfl::gl::GL_obj::lime_gl_cull_face(mode);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,cullFace,(void))

Void GL_obj::deleteBuffer( ::openfl::gl::GLBuffer buffer){
{
		HX_STACK_FRAME("openfl.gl.GL","deleteBuffer",0x64465149,"openfl.gl.GL.deleteBuffer","openfl/gl/GL.hx",600,0x296f94ae)
		HX_STACK_ARG(buffer,"buffer")
		HX_STACK_LINE(601)
		::openfl::gl::GL_obj::lime_gl_delete_buffer(buffer->id);
		HX_STACK_LINE(602)
		buffer->invalidate();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,deleteBuffer,(void))

Void GL_obj::deleteFramebuffer( ::openfl::gl::GLFramebuffer framebuffer){
{
		HX_STACK_FRAME("openfl.gl.GL","deleteFramebuffer",0xe66b5804,"openfl.gl.GL.deleteFramebuffer","openfl/gl/GL.hx",606,0x296f94ae)
		HX_STACK_ARG(framebuffer,"framebuffer")
		HX_STACK_LINE(607)
		::openfl::gl::GL_obj::lime_gl_delete_framebuffer(framebuffer->id);
		HX_STACK_LINE(608)
		framebuffer->invalidate();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,deleteFramebuffer,(void))

Void GL_obj::deleteProgram( ::openfl::gl::GLProgram program){
{
		HX_STACK_FRAME("openfl.gl.GL","deleteProgram",0x9ba9761b,"openfl.gl.GL.deleteProgram","openfl/gl/GL.hx",612,0x296f94ae)
		HX_STACK_ARG(program,"program")
		HX_STACK_LINE(613)
		::openfl::gl::GL_obj::lime_gl_delete_program(program->id);
		HX_STACK_LINE(614)
		program->invalidate();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,deleteProgram,(void))

Void GL_obj::deleteRenderbuffer( ::openfl::gl::GLRenderbuffer renderbuffer){
{
		HX_STACK_FRAME("openfl.gl.GL","deleteRenderbuffer",0x3e0dbddf,"openfl.gl.GL.deleteRenderbuffer","openfl/gl/GL.hx",618,0x296f94ae)
		HX_STACK_ARG(renderbuffer,"renderbuffer")
		HX_STACK_LINE(619)
		::openfl::gl::GL_obj::lime_gl_delete_render_buffer(renderbuffer->id);
		HX_STACK_LINE(620)
		renderbuffer->invalidate();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,deleteRenderbuffer,(void))

Void GL_obj::deleteShader( ::openfl::gl::GLShader shader){
{
		HX_STACK_FRAME("openfl.gl.GL","deleteShader",0xb0d2536e,"openfl.gl.GL.deleteShader","openfl/gl/GL.hx",624,0x296f94ae)
		HX_STACK_ARG(shader,"shader")
		HX_STACK_LINE(625)
		::openfl::gl::GL_obj::lime_gl_delete_shader(shader->id);
		HX_STACK_LINE(626)
		shader->invalidate();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,deleteShader,(void))

Void GL_obj::deleteTexture( ::openfl::gl::GLTexture texture){
{
		HX_STACK_FRAME("openfl.gl.GL","deleteTexture",0x4690f472,"openfl.gl.GL.deleteTexture","openfl/gl/GL.hx",630,0x296f94ae)
		HX_STACK_ARG(texture,"texture")
		HX_STACK_LINE(631)
		::openfl::gl::GL_obj::lime_gl_delete_texture(texture->id);
		HX_STACK_LINE(632)
		texture->invalidate();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,deleteTexture,(void))

Void GL_obj::depthFunc( int func){
{
		HX_STACK_FRAME("openfl.gl.GL","depthFunc",0x8853f569,"openfl.gl.GL.depthFunc","openfl/gl/GL.hx",637,0x296f94ae)
		HX_STACK_ARG(func,"func")
		HX_STACK_LINE(637)
		::openfl::gl::GL_obj::lime_gl_depth_func(func);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,depthFunc,(void))

Void GL_obj::depthMask( bool flag){
{
		HX_STACK_FRAME("openfl.gl.GL","depthMask",0x8ce54b11,"openfl.gl.GL.depthMask","openfl/gl/GL.hx",642,0x296f94ae)
		HX_STACK_ARG(flag,"flag")
		HX_STACK_LINE(642)
		::openfl::gl::GL_obj::lime_gl_depth_mask(flag);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,depthMask,(void))

Void GL_obj::depthRange( Float zNear,Float zFar){
{
		HX_STACK_FRAME("openfl.gl.GL","depthRange",0x9cb97bf8,"openfl.gl.GL.depthRange","openfl/gl/GL.hx",647,0x296f94ae)
		HX_STACK_ARG(zNear,"zNear")
		HX_STACK_ARG(zFar,"zFar")
		HX_STACK_LINE(647)
		::openfl::gl::GL_obj::lime_gl_depth_range(zNear,zFar);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,depthRange,(void))

Void GL_obj::detachShader( ::openfl::gl::GLProgram program,::openfl::gl::GLShader shader){
{
		HX_STACK_FRAME("openfl.gl.GL","detachShader",0x17c73e96,"openfl.gl.GL.detachShader","openfl/gl/GL.hx",652,0x296f94ae)
		HX_STACK_ARG(program,"program")
		HX_STACK_ARG(shader,"shader")
		HX_STACK_LINE(652)
		::openfl::gl::GL_obj::lime_gl_detach_shader(program->id,shader->id);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,detachShader,(void))

Void GL_obj::disable( int cap){
{
		HX_STACK_FRAME("openfl.gl.GL","disable",0x35f1d4ea,"openfl.gl.GL.disable","openfl/gl/GL.hx",657,0x296f94ae)
		HX_STACK_ARG(cap,"cap")
		HX_STACK_LINE(657)
		::openfl::gl::GL_obj::lime_gl_disable(cap);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,disable,(void))

Void GL_obj::disableVertexAttribArray( int index){
{
		HX_STACK_FRAME("openfl.gl.GL","disableVertexAttribArray",0xf35a7ca1,"openfl.gl.GL.disableVertexAttribArray","openfl/gl/GL.hx",662,0x296f94ae)
		HX_STACK_ARG(index,"index")
		HX_STACK_LINE(662)
		::openfl::gl::GL_obj::lime_gl_disable_vertex_attrib_array(index);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,disableVertexAttribArray,(void))

Void GL_obj::drawArrays( int mode,int first,int count){
{
		HX_STACK_FRAME("openfl.gl.GL","drawArrays",0x55e1d61c,"openfl.gl.GL.drawArrays","openfl/gl/GL.hx",667,0x296f94ae)
		HX_STACK_ARG(mode,"mode")
		HX_STACK_ARG(first,"first")
		HX_STACK_ARG(count,"count")
		HX_STACK_LINE(667)
		::openfl::gl::GL_obj::lime_gl_draw_arrays(mode,first,count);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,drawArrays,(void))

Void GL_obj::drawElements( int mode,int count,int type,int offset){
{
		HX_STACK_FRAME("openfl.gl.GL","drawElements",0x86d13019,"openfl.gl.GL.drawElements","openfl/gl/GL.hx",672,0x296f94ae)
		HX_STACK_ARG(mode,"mode")
		HX_STACK_ARG(count,"count")
		HX_STACK_ARG(type,"type")
		HX_STACK_ARG(offset,"offset")
		HX_STACK_LINE(672)
		::openfl::gl::GL_obj::lime_gl_draw_elements(mode,count,type,offset);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,drawElements,(void))

Void GL_obj::enable( int cap){
{
		HX_STACK_FRAME("openfl.gl.GL","enable",0xcfcc19c1,"openfl.gl.GL.enable","openfl/gl/GL.hx",677,0x296f94ae)
		HX_STACK_ARG(cap,"cap")
		HX_STACK_LINE(677)
		::openfl::gl::GL_obj::lime_gl_enable(cap);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,enable,(void))

Void GL_obj::enableVertexAttribArray( int index){
{
		HX_STACK_FRAME("openfl.gl.GL","enableVertexAttribArray",0xa1a155ea,"openfl.gl.GL.enableVertexAttribArray","openfl/gl/GL.hx",682,0x296f94ae)
		HX_STACK_ARG(index,"index")
		HX_STACK_LINE(682)
		::openfl::gl::GL_obj::lime_gl_enable_vertex_attrib_array(index);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,enableVertexAttribArray,(void))

Void GL_obj::finish( ){
{
		HX_STACK_FRAME("openfl.gl.GL","finish",0x5dc3ab91,"openfl.gl.GL.finish","openfl/gl/GL.hx",687,0x296f94ae)
		HX_STACK_LINE(687)
		::openfl::gl::GL_obj::lime_gl_finish();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,finish,(void))

Void GL_obj::flush( ){
{
		HX_STACK_FRAME("openfl.gl.GL","flush",0x2974a946,"openfl.gl.GL.flush","openfl/gl/GL.hx",692,0x296f94ae)
		HX_STACK_LINE(692)
		::openfl::gl::GL_obj::lime_gl_flush();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,flush,(void))

Void GL_obj::framebufferRenderbuffer( int target,int attachment,int renderbuffertarget,::openfl::gl::GLRenderbuffer renderbuffer){
{
		HX_STACK_FRAME("openfl.gl.GL","framebufferRenderbuffer",0x2bf9ec65,"openfl.gl.GL.framebufferRenderbuffer","openfl/gl/GL.hx",697,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(attachment,"attachment")
		HX_STACK_ARG(renderbuffertarget,"renderbuffertarget")
		HX_STACK_ARG(renderbuffer,"renderbuffer")
		HX_STACK_LINE(697)
		::openfl::gl::GL_obj::lime_gl_framebuffer_renderbuffer(target,attachment,renderbuffertarget,renderbuffer->id);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,framebufferRenderbuffer,(void))

Void GL_obj::framebufferTexture2D( int target,int attachment,int textarget,::openfl::gl::GLTexture texture,int level){
{
		HX_STACK_FRAME("openfl.gl.GL","framebufferTexture2D",0xeb1cc27e,"openfl.gl.GL.framebufferTexture2D","openfl/gl/GL.hx",702,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(attachment,"attachment")
		HX_STACK_ARG(textarget,"textarget")
		HX_STACK_ARG(texture,"texture")
		HX_STACK_ARG(level,"level")
		HX_STACK_LINE(702)
		::openfl::gl::GL_obj::lime_gl_framebuffer_texture2D(target,attachment,textarget,texture->id,level);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(GL_obj,framebufferTexture2D,(void))

Void GL_obj::frontFace( int mode){
{
		HX_STACK_FRAME("openfl.gl.GL","frontFace",0x6eccb168,"openfl.gl.GL.frontFace","openfl/gl/GL.hx",707,0x296f94ae)
		HX_STACK_ARG(mode,"mode")
		HX_STACK_LINE(707)
		::openfl::gl::GL_obj::lime_gl_front_face(mode);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,frontFace,(void))

Void GL_obj::generateMipmap( int target){
{
		HX_STACK_FRAME("openfl.gl.GL","generateMipmap",0x13acafdb,"openfl.gl.GL.generateMipmap","openfl/gl/GL.hx",712,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_LINE(712)
		::openfl::gl::GL_obj::lime_gl_generate_mipmap(target);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,generateMipmap,(void))

Dynamic GL_obj::getActiveAttrib( ::openfl::gl::GLProgram program,int index){
	HX_STACK_FRAME("openfl.gl.GL","getActiveAttrib",0x3581c868,"openfl.gl.GL.getActiveAttrib","openfl/gl/GL.hx",717,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(717)
	return ::openfl::gl::GL_obj::lime_gl_get_active_attrib(program->id,index);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getActiveAttrib,return )

Dynamic GL_obj::getActiveUniform( ::openfl::gl::GLProgram program,int index){
	HX_STACK_FRAME("openfl.gl.GL","getActiveUniform",0x18445a56,"openfl.gl.GL.getActiveUniform","openfl/gl/GL.hx",722,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_ARG(index,"index")
	HX_STACK_LINE(722)
	return ::openfl::gl::GL_obj::lime_gl_get_active_uniform(program->id,index);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getActiveUniform,return )

Array< ::Dynamic > GL_obj::getAttachedShaders( ::openfl::gl::GLProgram program){
	HX_STACK_FRAME("openfl.gl.GL","getAttachedShaders",0x99ce7ef2,"openfl.gl.GL.getAttachedShaders","openfl/gl/GL.hx",727,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_LINE(727)
	return program->getShaders();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,getAttachedShaders,return )

int GL_obj::getAttribLocation( ::openfl::gl::GLProgram program,::String name){
	HX_STACK_FRAME("openfl.gl.GL","getAttribLocation",0xf37a1c57,"openfl.gl.GL.getAttribLocation","openfl/gl/GL.hx",732,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(732)
	return ::openfl::gl::GL_obj::lime_gl_get_attrib_location(program->id,name);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getAttribLocation,return )

Dynamic GL_obj::getBufferParameter( int target,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getBufferParameter",0x1b0ba8d1,"openfl.gl.GL.getBufferParameter","openfl/gl/GL.hx",737,0x296f94ae)
	HX_STACK_ARG(target,"target")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(737)
	return ::openfl::gl::GL_obj::lime_gl_get_buffer_paramerter(target,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getBufferParameter,return )

Dynamic GL_obj::getContextAttributes( ){
	HX_STACK_FRAME("openfl.gl.GL","getContextAttributes",0x74dc35ee,"openfl.gl.GL.getContextAttributes","openfl/gl/GL.hx",741,0x296f94ae)
	HX_STACK_LINE(742)
	Dynamic base = ::openfl::gl::GL_obj::lime_gl_get_context_attributes();		HX_STACK_VAR(base,"base");
	HX_STACK_LINE(743)
	base->__FieldRef(HX_CSTRING("premultipliedAlpha")) = false;
	HX_STACK_LINE(744)
	base->__FieldRef(HX_CSTRING("preserveDrawingBuffer")) = false;
	HX_STACK_LINE(745)
	return base;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,getContextAttributes,return )

int GL_obj::getError( ){
	HX_STACK_FRAME("openfl.gl.GL","getError",0x54a51210,"openfl.gl.GL.getError","openfl/gl/GL.hx",750,0x296f94ae)
	HX_STACK_LINE(750)
	return ::openfl::gl::GL_obj::lime_gl_get_error();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,getError,return )

Dynamic GL_obj::getExtension( ::String name){
	HX_STACK_FRAME("openfl.gl.GL","getExtension",0x21809dc7,"openfl.gl.GL.getExtension","openfl/gl/GL.hx",756,0x296f94ae)
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(756)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,getExtension,return )

Dynamic GL_obj::getFramebufferAttachmentParameter( int target,int attachment,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getFramebufferAttachmentParameter",0xfd9a6511,"openfl.gl.GL.getFramebufferAttachmentParameter","openfl/gl/GL.hx",761,0x296f94ae)
	HX_STACK_ARG(target,"target")
	HX_STACK_ARG(attachment,"attachment")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(761)
	return ::openfl::gl::GL_obj::lime_gl_get_framebuffer_attachment_parameter(target,attachment,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,getFramebufferAttachmentParameter,return )

Dynamic GL_obj::getParameter( int pname){
	HX_STACK_FRAME("openfl.gl.GL","getParameter",0x85203ff1,"openfl.gl.GL.getParameter","openfl/gl/GL.hx",766,0x296f94ae)
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(766)
	return ::openfl::gl::GL_obj::lime_gl_get_parameter(pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,getParameter,return )

::String GL_obj::getProgramInfoLog( ::openfl::gl::GLProgram program){
	HX_STACK_FRAME("openfl.gl.GL","getProgramInfoLog",0x645cf34a,"openfl.gl.GL.getProgramInfoLog","openfl/gl/GL.hx",771,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_LINE(771)
	return ::openfl::gl::GL_obj::lime_gl_get_program_info_log(program->id);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,getProgramInfoLog,return )

int GL_obj::getProgramParameter( ::openfl::gl::GLProgram program,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getProgramParameter",0x1caba93d,"openfl.gl.GL.getProgramParameter","openfl/gl/GL.hx",776,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(776)
	return ::openfl::gl::GL_obj::lime_gl_get_program_parameter(program->id,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getProgramParameter,return )

Dynamic GL_obj::getRenderbufferParameter( int target,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getRenderbufferParameter",0xe5bdd43b,"openfl.gl.GL.getRenderbufferParameter","openfl/gl/GL.hx",781,0x296f94ae)
	HX_STACK_ARG(target,"target")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(781)
	return ::openfl::gl::GL_obj::lime_gl_get_render_buffer_parameter(target,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getRenderbufferParameter,return )

::String GL_obj::getShaderInfoLog( ::openfl::gl::GLShader shader){
	HX_STACK_FRAME("openfl.gl.GL","getShaderInfoLog",0x34bee259,"openfl.gl.GL.getShaderInfoLog","openfl/gl/GL.hx",786,0x296f94ae)
	HX_STACK_ARG(shader,"shader")
	HX_STACK_LINE(786)
	return ::openfl::gl::GL_obj::lime_gl_get_shader_info_log(shader->id);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,getShaderInfoLog,return )

int GL_obj::getShaderParameter( ::openfl::gl::GLShader shader,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getShaderParameter",0x3cb2ba0c,"openfl.gl.GL.getShaderParameter","openfl/gl/GL.hx",791,0x296f94ae)
	HX_STACK_ARG(shader,"shader")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(791)
	return ::openfl::gl::GL_obj::lime_gl_get_shader_parameter(shader->id,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getShaderParameter,return )

Dynamic GL_obj::getShaderPrecisionFormat( int shadertype,int precisiontype){
	HX_STACK_FRAME("openfl.gl.GL","getShaderPrecisionFormat",0x77b5cbb8,"openfl.gl.GL.getShaderPrecisionFormat","openfl/gl/GL.hx",796,0x296f94ae)
	HX_STACK_ARG(shadertype,"shadertype")
	HX_STACK_ARG(precisiontype,"precisiontype")
	HX_STACK_LINE(796)
	return ::openfl::gl::GL_obj::lime_gl_get_shader_precision_format(shadertype,precisiontype);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getShaderPrecisionFormat,return )

::String GL_obj::getShaderSource( ::openfl::gl::GLShader shader){
	HX_STACK_FRAME("openfl.gl.GL","getShaderSource",0x9763e098,"openfl.gl.GL.getShaderSource","openfl/gl/GL.hx",801,0x296f94ae)
	HX_STACK_ARG(shader,"shader")
	HX_STACK_LINE(801)
	return ::openfl::gl::GL_obj::lime_gl_get_shader_source(shader->id);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,getShaderSource,return )

Array< ::String > GL_obj::getSupportedExtensions( ){
	HX_STACK_FRAME("openfl.gl.GL","getSupportedExtensions",0xe084c02a,"openfl.gl.GL.getSupportedExtensions","openfl/gl/GL.hx",805,0x296f94ae)
	HX_STACK_LINE(806)
	Array< ::String > result = Array_obj< ::String >::__new();		HX_STACK_VAR(result,"result");
	HX_STACK_LINE(807)
	::openfl::gl::GL_obj::lime_gl_get_supported_extensions(result);
	HX_STACK_LINE(808)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,getSupportedExtensions,return )

Dynamic GL_obj::getTexParameter( int target,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getTexParameter",0xa532d57a,"openfl.gl.GL.getTexParameter","openfl/gl/GL.hx",813,0x296f94ae)
	HX_STACK_ARG(target,"target")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(813)
	return ::openfl::gl::GL_obj::lime_gl_get_tex_parameter(target,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getTexParameter,return )

Dynamic GL_obj::getUniform( ::openfl::gl::GLProgram program,Dynamic location){
	HX_STACK_FRAME("openfl.gl.GL","getUniform",0x60f3a97c,"openfl.gl.GL.getUniform","openfl/gl/GL.hx",818,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_ARG(location,"location")
	HX_STACK_LINE(818)
	return ::openfl::gl::GL_obj::lime_gl_get_uniform(program->id,location);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getUniform,return )

Dynamic GL_obj::getUniformLocation( ::openfl::gl::GLProgram program,::String name){
	HX_STACK_FRAME("openfl.gl.GL","getUniformLocation",0x562bafd1,"openfl.gl.GL.getUniformLocation","openfl/gl/GL.hx",823,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_ARG(name,"name")
	HX_STACK_LINE(823)
	return ::openfl::gl::GL_obj::lime_gl_get_uniform_location(program->id,name);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getUniformLocation,return )

Dynamic GL_obj::getVertexAttrib( int index,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getVertexAttrib",0x757b6c86,"openfl.gl.GL.getVertexAttrib","openfl/gl/GL.hx",828,0x296f94ae)
	HX_STACK_ARG(index,"index")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(828)
	return ::openfl::gl::GL_obj::lime_gl_get_vertex_attrib(index,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getVertexAttrib,return )

int GL_obj::getVertexAttribOffset( int index,int pname){
	HX_STACK_FRAME("openfl.gl.GL","getVertexAttribOffset",0xaae4a0b9,"openfl.gl.GL.getVertexAttribOffset","openfl/gl/GL.hx",833,0x296f94ae)
	HX_STACK_ARG(index,"index")
	HX_STACK_ARG(pname,"pname")
	HX_STACK_LINE(833)
	return ::openfl::gl::GL_obj::lime_gl_get_vertex_attrib_offset(index,pname);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,getVertexAttribOffset,return )

Void GL_obj::hint( int target,int mode){
{
		HX_STACK_FRAME("openfl.gl.GL","hint",0x59e4bd45,"openfl.gl.GL.hint","openfl/gl/GL.hx",838,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(mode,"mode")
		HX_STACK_LINE(838)
		::openfl::gl::GL_obj::lime_gl_hint(target,mode);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,hint,(void))

bool GL_obj::isBuffer( ::openfl::gl::GLBuffer buffer){
	HX_STACK_FRAME("openfl.gl.GL","isBuffer",0xaaa28f48,"openfl.gl.GL.isBuffer","openfl/gl/GL.hx",843,0x296f94ae)
	HX_STACK_ARG(buffer,"buffer")
	HX_STACK_LINE(843)
	if (((buffer != null()))){
		HX_STACK_LINE(843)
		return ::openfl::gl::GL_obj::lime_gl_is_buffer(buffer->id);
	}
	else{
		HX_STACK_LINE(843)
		return false;
	}
	HX_STACK_LINE(843)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,isBuffer,return )

bool GL_obj::isEnabled( int cap){
	HX_STACK_FRAME("openfl.gl.GL","isEnabled",0x703b3139,"openfl.gl.GL.isEnabled","openfl/gl/GL.hx",850,0x296f94ae)
	HX_STACK_ARG(cap,"cap")
	HX_STACK_LINE(850)
	return ::openfl::gl::GL_obj::lime_gl_is_enabled(cap);
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,isEnabled,return )

bool GL_obj::isFramebuffer( ::openfl::gl::GLFramebuffer framebuffer){
	HX_STACK_FRAME("openfl.gl.GL","isFramebuffer",0xcc92fda5,"openfl.gl.GL.isFramebuffer","openfl/gl/GL.hx",855,0x296f94ae)
	HX_STACK_ARG(framebuffer,"framebuffer")
	HX_STACK_LINE(855)
	if (((framebuffer != null()))){
		HX_STACK_LINE(855)
		return ::openfl::gl::GL_obj::lime_gl_is_framebuffer(framebuffer->id);
	}
	else{
		HX_STACK_LINE(855)
		return false;
	}
	HX_STACK_LINE(855)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,isFramebuffer,return )

bool GL_obj::isProgram( ::openfl::gl::GLProgram program){
	HX_STACK_FRAME("openfl.gl.GL","isProgram",0xe603773c,"openfl.gl.GL.isProgram","openfl/gl/GL.hx",860,0x296f94ae)
	HX_STACK_ARG(program,"program")
	HX_STACK_LINE(860)
	if (((program != null()))){
		HX_STACK_LINE(860)
		return ::openfl::gl::GL_obj::lime_gl_is_program(program->id);
	}
	else{
		HX_STACK_LINE(860)
		return false;
	}
	HX_STACK_LINE(860)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,isProgram,return )

bool GL_obj::isRenderbuffer( ::openfl::gl::GLRenderbuffer renderbuffer){
	HX_STACK_FRAME("openfl.gl.GL","isRenderbuffer",0xba97051e,"openfl.gl.GL.isRenderbuffer","openfl/gl/GL.hx",865,0x296f94ae)
	HX_STACK_ARG(renderbuffer,"renderbuffer")
	HX_STACK_LINE(865)
	if (((renderbuffer != null()))){
		HX_STACK_LINE(865)
		return ::openfl::gl::GL_obj::lime_gl_is_renderbuffer(renderbuffer->id);
	}
	else{
		HX_STACK_LINE(865)
		return false;
	}
	HX_STACK_LINE(865)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,isRenderbuffer,return )

bool GL_obj::isShader( ::openfl::gl::GLShader shader){
	HX_STACK_FRAME("openfl.gl.GL","isShader",0xf72e916d,"openfl.gl.GL.isShader","openfl/gl/GL.hx",870,0x296f94ae)
	HX_STACK_ARG(shader,"shader")
	HX_STACK_LINE(870)
	if (((shader != null()))){
		HX_STACK_LINE(870)
		return ::openfl::gl::GL_obj::lime_gl_is_shader(shader->id);
	}
	else{
		HX_STACK_LINE(870)
		return false;
	}
	HX_STACK_LINE(870)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,isShader,return )

bool GL_obj::isTexture( ::openfl::gl::GLTexture texture){
	HX_STACK_FRAME("openfl.gl.GL","isTexture",0x90eaf593,"openfl.gl.GL.isTexture","openfl/gl/GL.hx",875,0x296f94ae)
	HX_STACK_ARG(texture,"texture")
	HX_STACK_LINE(875)
	if (((texture != null()))){
		HX_STACK_LINE(875)
		return ::openfl::gl::GL_obj::lime_gl_is_texture(texture->id);
	}
	else{
		HX_STACK_LINE(875)
		return false;
	}
	HX_STACK_LINE(875)
	return false;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,isTexture,return )

Void GL_obj::lineWidth( Float width){
{
		HX_STACK_FRAME("openfl.gl.GL","lineWidth",0xff6968f4,"openfl.gl.GL.lineWidth","openfl/gl/GL.hx",880,0x296f94ae)
		HX_STACK_ARG(width,"width")
		HX_STACK_LINE(880)
		::openfl::gl::GL_obj::lime_gl_line_width(width);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,lineWidth,(void))

Void GL_obj::linkProgram( ::openfl::gl::GLProgram program){
{
		HX_STACK_FRAME("openfl.gl.GL","linkProgram",0xd573c1ac,"openfl.gl.GL.linkProgram","openfl/gl/GL.hx",885,0x296f94ae)
		HX_STACK_ARG(program,"program")
		HX_STACK_LINE(885)
		::openfl::gl::GL_obj::lime_gl_link_program(program->id);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,linkProgram,(void))

Dynamic GL_obj::load( ::String inName,int inArgCount){
	HX_STACK_FRAME("openfl.gl.GL","load",0x5c8e19e4,"openfl.gl.GL.load","openfl/gl/GL.hx",890,0x296f94ae)
	HX_STACK_ARG(inName,"inName")
	HX_STACK_ARG(inArgCount,"inArgCount")
	HX_STACK_LINE(890)
	try
	{
	HX_STACK_CATCHABLE(Dynamic, 0);
	{
		HX_STACK_LINE(892)
		return ::flash::Lib_obj::load(HX_CSTRING("lime"),inName,inArgCount);
	}
	}
	catch(Dynamic __e){
		{
			HX_STACK_BEGIN_CATCH
			Dynamic e = __e;{
				HX_STACK_LINE(896)
				::haxe::Log_obj::trace(e,hx::SourceInfo(HX_CSTRING("GL.hx"),896,HX_CSTRING("openfl.gl.GL"),HX_CSTRING("load")));
				HX_STACK_LINE(897)
				return null();
			}
		}
	}
	HX_STACK_LINE(890)
	return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,load,return )

Void GL_obj::pixelStorei( int pname,int param){
{
		HX_STACK_FRAME("openfl.gl.GL","pixelStorei",0xccc04890,"openfl.gl.GL.pixelStorei","openfl/gl/GL.hx",903,0x296f94ae)
		HX_STACK_ARG(pname,"pname")
		HX_STACK_ARG(param,"param")
		HX_STACK_LINE(903)
		::openfl::gl::GL_obj::lime_gl_pixel_storei(pname,param);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,pixelStorei,(void))

Void GL_obj::polygonOffset( Float factor,Float units){
{
		HX_STACK_FRAME("openfl.gl.GL","polygonOffset",0xaf73be2f,"openfl.gl.GL.polygonOffset","openfl/gl/GL.hx",908,0x296f94ae)
		HX_STACK_ARG(factor,"factor")
		HX_STACK_ARG(units,"units")
		HX_STACK_LINE(908)
		::openfl::gl::GL_obj::lime_gl_polygon_offset(factor,units);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,polygonOffset,(void))

Void GL_obj::readPixels( int x,int y,int width,int height,int format,int type,::flash::utils::ByteArray pixels){
{
		HX_STACK_FRAME("openfl.gl.GL","readPixels",0xe253b561,"openfl.gl.GL.readPixels","openfl/gl/GL.hx",912,0x296f94ae)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_ARG(format,"format")
		HX_STACK_ARG(type,"type")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_LINE(913)
		::flash::utils::ByteArray _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(913)
		if (((pixels == null()))){
			HX_STACK_LINE(913)
			_g = null();
		}
		else{
			HX_STACK_LINE(913)
			_g = pixels->getByteBuffer();
		}
		HX_STACK_LINE(913)
		Dynamic _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(913)
		if (((pixels == null()))){
			HX_STACK_LINE(913)
			_g1 = null();
		}
		else{
			HX_STACK_LINE(913)
			_g1 = pixels->getStart();
		}
		HX_STACK_LINE(913)
		::openfl::gl::GL_obj::lime_gl_read_pixels(x,y,width,height,format,type,_g,_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(GL_obj,readPixels,(void))

Void GL_obj::renderbufferStorage( int target,int internalformat,int width,int height){
{
		HX_STACK_FRAME("openfl.gl.GL","renderbufferStorage",0x0d7f8707,"openfl.gl.GL.renderbufferStorage","openfl/gl/GL.hx",918,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(internalformat,"internalformat")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(918)
		::openfl::gl::GL_obj::lime_gl_renderbuffer_storage(target,internalformat,width,height);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,renderbufferStorage,(void))

Void GL_obj::sampleCoverage( Float value,bool invert){
{
		HX_STACK_FRAME("openfl.gl.GL","sampleCoverage",0xf4204170,"openfl.gl.GL.sampleCoverage","openfl/gl/GL.hx",923,0x296f94ae)
		HX_STACK_ARG(value,"value")
		HX_STACK_ARG(invert,"invert")
		HX_STACK_LINE(923)
		::openfl::gl::GL_obj::lime_gl_sample_coverage(value,invert);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,sampleCoverage,(void))

Void GL_obj::scissor( int x,int y,int width,int height){
{
		HX_STACK_FRAME("openfl.gl.GL","scissor",0x8980931e,"openfl.gl.GL.scissor","openfl/gl/GL.hx",928,0x296f94ae)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(928)
		::openfl::gl::GL_obj::lime_gl_scissor(x,y,width,height);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,scissor,(void))

Void GL_obj::shaderSource( ::openfl::gl::GLShader shader,::String source){
{
		HX_STACK_FRAME("openfl.gl.GL","shaderSource",0xcf33bb9e,"openfl.gl.GL.shaderSource","openfl/gl/GL.hx",933,0x296f94ae)
		HX_STACK_ARG(shader,"shader")
		HX_STACK_ARG(source,"source")
		HX_STACK_LINE(933)
		::openfl::gl::GL_obj::lime_gl_shader_source(shader->id,source);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,shaderSource,(void))

Void GL_obj::stencilFunc( int func,int ref,int mask){
{
		HX_STACK_FRAME("openfl.gl.GL","stencilFunc",0x8cb69762,"openfl.gl.GL.stencilFunc","openfl/gl/GL.hx",938,0x296f94ae)
		HX_STACK_ARG(func,"func")
		HX_STACK_ARG(ref,"ref")
		HX_STACK_ARG(mask,"mask")
		HX_STACK_LINE(938)
		::openfl::gl::GL_obj::lime_gl_stencil_func(func,ref,mask);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,stencilFunc,(void))

Void GL_obj::stencilFuncSeparate( int face,int func,int ref,int mask){
{
		HX_STACK_FRAME("openfl.gl.GL","stencilFuncSeparate",0x38dda4e5,"openfl.gl.GL.stencilFuncSeparate","openfl/gl/GL.hx",943,0x296f94ae)
		HX_STACK_ARG(face,"face")
		HX_STACK_ARG(func,"func")
		HX_STACK_ARG(ref,"ref")
		HX_STACK_ARG(mask,"mask")
		HX_STACK_LINE(943)
		::openfl::gl::GL_obj::lime_gl_stencil_func_separate(face,func,ref,mask);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,stencilFuncSeparate,(void))

Void GL_obj::stencilMask( int mask){
{
		HX_STACK_FRAME("openfl.gl.GL","stencilMask",0x9147ed0a,"openfl.gl.GL.stencilMask","openfl/gl/GL.hx",948,0x296f94ae)
		HX_STACK_ARG(mask,"mask")
		HX_STACK_LINE(948)
		::openfl::gl::GL_obj::lime_gl_stencil_mask(mask);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,stencilMask,(void))

Void GL_obj::stencilMaskSeparate( int face,int mask){
{
		HX_STACK_FRAME("openfl.gl.GL","stencilMaskSeparate",0x4cb8e28d,"openfl.gl.GL.stencilMaskSeparate","openfl/gl/GL.hx",953,0x296f94ae)
		HX_STACK_ARG(face,"face")
		HX_STACK_ARG(mask,"mask")
		HX_STACK_LINE(953)
		::openfl::gl::GL_obj::lime_gl_stencil_mask_separate(face,mask);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,stencilMaskSeparate,(void))

Void GL_obj::stencilOp( int fail,int zfail,int zpass){
{
		HX_STACK_FRAME("openfl.gl.GL","stencilOp",0x44f829bf,"openfl.gl.GL.stencilOp","openfl/gl/GL.hx",958,0x296f94ae)
		HX_STACK_ARG(fail,"fail")
		HX_STACK_ARG(zfail,"zfail")
		HX_STACK_ARG(zpass,"zpass")
		HX_STACK_LINE(958)
		::openfl::gl::GL_obj::lime_gl_stencil_op(fail,zfail,zpass);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,stencilOp,(void))

Void GL_obj::stencilOpSeparate( int face,int fail,int zfail,int zpass){
{
		HX_STACK_FRAME("openfl.gl.GL","stencilOpSeparate",0xe9b45c42,"openfl.gl.GL.stencilOpSeparate","openfl/gl/GL.hx",963,0x296f94ae)
		HX_STACK_ARG(face,"face")
		HX_STACK_ARG(fail,"fail")
		HX_STACK_ARG(zfail,"zfail")
		HX_STACK_ARG(zpass,"zpass")
		HX_STACK_LINE(963)
		::openfl::gl::GL_obj::lime_gl_stencil_op_separate(face,fail,zfail,zpass);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,stencilOpSeparate,(void))

Void GL_obj::texImage2D( int target,int level,int internalformat,int width,int height,int border,int format,int type,::openfl::utils::ArrayBufferView pixels){
{
		HX_STACK_FRAME("openfl.gl.GL","texImage2D",0x15955f04,"openfl.gl.GL.texImage2D","openfl/gl/GL.hx",967,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(level,"level")
		HX_STACK_ARG(internalformat,"internalformat")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_ARG(border,"border")
		HX_STACK_ARG(format,"format")
		HX_STACK_ARG(type,"type")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_LINE(968)
		::flash::utils::ByteArray _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(968)
		if (((pixels == null()))){
			HX_STACK_LINE(968)
			_g = null();
		}
		else{
			HX_STACK_LINE(968)
			_g = pixels->getByteBuffer();
		}
		HX_STACK_LINE(968)
		Dynamic _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(968)
		if (((pixels == null()))){
			HX_STACK_LINE(968)
			_g1 = null();
		}
		else{
			HX_STACK_LINE(968)
			_g1 = pixels->getStart();
		}
		HX_STACK_LINE(968)
		::openfl::gl::GL_obj::lime_gl_tex_image_2d(target,level,internalformat,width,height,border,format,type,_g,_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC9(GL_obj,texImage2D,(void))

Void GL_obj::texParameterf( int target,int pname,Float param){
{
		HX_STACK_FRAME("openfl.gl.GL","texParameterf",0x8557bfe6,"openfl.gl.GL.texParameterf","openfl/gl/GL.hx",973,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(pname,"pname")
		HX_STACK_ARG(param,"param")
		HX_STACK_LINE(973)
		::openfl::gl::GL_obj::lime_gl_tex_parameterf(target,pname,param);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,texParameterf,(void))

Void GL_obj::texParameteri( int target,int pname,int param){
{
		HX_STACK_FRAME("openfl.gl.GL","texParameteri",0x8557bfe9,"openfl.gl.GL.texParameteri","openfl/gl/GL.hx",978,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(pname,"pname")
		HX_STACK_ARG(param,"param")
		HX_STACK_LINE(978)
		::openfl::gl::GL_obj::lime_gl_tex_parameteri(target,pname,param);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,texParameteri,(void))

Void GL_obj::texSubImage2D( int target,int level,int xoffset,int yoffset,int width,int height,int format,int type,::openfl::utils::ArrayBufferView pixels){
{
		HX_STACK_FRAME("openfl.gl.GL","texSubImage2D",0x71b6c796,"openfl.gl.GL.texSubImage2D","openfl/gl/GL.hx",982,0x296f94ae)
		HX_STACK_ARG(target,"target")
		HX_STACK_ARG(level,"level")
		HX_STACK_ARG(xoffset,"xoffset")
		HX_STACK_ARG(yoffset,"yoffset")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_ARG(format,"format")
		HX_STACK_ARG(type,"type")
		HX_STACK_ARG(pixels,"pixels")
		HX_STACK_LINE(983)
		::flash::utils::ByteArray _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(983)
		if (((pixels == null()))){
			HX_STACK_LINE(983)
			_g = null();
		}
		else{
			HX_STACK_LINE(983)
			_g = pixels->getByteBuffer();
		}
		HX_STACK_LINE(983)
		Dynamic _g1;		HX_STACK_VAR(_g1,"_g1");
		HX_STACK_LINE(983)
		if (((pixels == null()))){
			HX_STACK_LINE(983)
			_g1 = null();
		}
		else{
			HX_STACK_LINE(983)
			_g1 = pixels->getStart();
		}
		HX_STACK_LINE(983)
		::openfl::gl::GL_obj::lime_gl_tex_sub_image_2d(target,level,xoffset,yoffset,width,height,format,type,_g,_g1);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC9(GL_obj,texSubImage2D,(void))

Void GL_obj::uniform1f( Dynamic location,Float x){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform1f",0xf5e9d0cb,"openfl.gl.GL.uniform1f","openfl/gl/GL.hx",988,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(988)
		::openfl::gl::GL_obj::lime_gl_uniform1f(location,x);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform1f,(void))

Void GL_obj::uniform1fv( Dynamic location,Dynamic x){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform1fv",0x36ace14b,"openfl.gl.GL.uniform1fv","openfl/gl/GL.hx",993,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(993)
		::openfl::gl::GL_obj::lime_gl_uniform1fv(location,x);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform1fv,(void))

Void GL_obj::uniform1i( Dynamic location,int x){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform1i",0xf5e9d0ce,"openfl.gl.GL.uniform1i","openfl/gl/GL.hx",998,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(998)
		::openfl::gl::GL_obj::lime_gl_uniform1i(location,x);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform1i,(void))

Void GL_obj::uniform1iv( Dynamic location,Array< int > v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform1iv",0x36ace3e8,"openfl.gl.GL.uniform1iv","openfl/gl/GL.hx",1003,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1003)
		::openfl::gl::GL_obj::lime_gl_uniform1iv(location,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform1iv,(void))

Void GL_obj::uniform2f( Dynamic location,Float x,Float y){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform2f",0xf5e9d1aa,"openfl.gl.GL.uniform2f","openfl/gl/GL.hx",1008,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(1008)
		::openfl::gl::GL_obj::lime_gl_uniform2f(location,x,y);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,uniform2f,(void))

Void GL_obj::uniform2fv( Dynamic location,Dynamic v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform2fv",0x36ada38c,"openfl.gl.GL.uniform2fv","openfl/gl/GL.hx",1013,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1013)
		::openfl::gl::GL_obj::lime_gl_uniform2fv(location,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform2fv,(void))

Void GL_obj::uniform2i( Dynamic location,int x,int y){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform2i",0xf5e9d1ad,"openfl.gl.GL.uniform2i","openfl/gl/GL.hx",1018,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(1018)
		::openfl::gl::GL_obj::lime_gl_uniform2i(location,x,y);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,uniform2i,(void))

Void GL_obj::uniform2iv( Dynamic location,Array< int > v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform2iv",0x36ada629,"openfl.gl.GL.uniform2iv","openfl/gl/GL.hx",1023,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1023)
		::openfl::gl::GL_obj::lime_gl_uniform2iv(location,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform2iv,(void))

Void GL_obj::uniform3f( Dynamic location,Float x,Float y,Float z){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform3f",0xf5e9d289,"openfl.gl.GL.uniform3f","openfl/gl/GL.hx",1028,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(1028)
		::openfl::gl::GL_obj::lime_gl_uniform3f(location,x,y,z);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,uniform3f,(void))

Void GL_obj::uniform3fv( Dynamic location,Dynamic v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform3fv",0x36ae65cd,"openfl.gl.GL.uniform3fv","openfl/gl/GL.hx",1033,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1033)
		::openfl::gl::GL_obj::lime_gl_uniform3fv(location,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform3fv,(void))

Void GL_obj::uniform3i( Dynamic location,int x,int y,int z){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform3i",0xf5e9d28c,"openfl.gl.GL.uniform3i","openfl/gl/GL.hx",1038,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(1038)
		::openfl::gl::GL_obj::lime_gl_uniform3i(location,x,y,z);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,uniform3i,(void))

Void GL_obj::uniform3iv( Dynamic location,Array< int > v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform3iv",0x36ae686a,"openfl.gl.GL.uniform3iv","openfl/gl/GL.hx",1043,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1043)
		::openfl::gl::GL_obj::lime_gl_uniform3iv(location,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform3iv,(void))

Void GL_obj::uniform4f( Dynamic location,Float x,Float y,Float z,Float w){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform4f",0xf5e9d368,"openfl.gl.GL.uniform4f","openfl/gl/GL.hx",1048,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_ARG(w,"w")
		HX_STACK_LINE(1048)
		::openfl::gl::GL_obj::lime_gl_uniform4f(location,x,y,z,w);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(GL_obj,uniform4f,(void))

Void GL_obj::uniform4fv( Dynamic location,Dynamic v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform4fv",0x36af280e,"openfl.gl.GL.uniform4fv","openfl/gl/GL.hx",1053,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1053)
		::openfl::gl::GL_obj::lime_gl_uniform4fv(location,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform4fv,(void))

Void GL_obj::uniform4i( Dynamic location,int x,int y,int z,int w){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform4i",0xf5e9d36b,"openfl.gl.GL.uniform4i","openfl/gl/GL.hx",1058,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_ARG(w,"w")
		HX_STACK_LINE(1058)
		::openfl::gl::GL_obj::lime_gl_uniform4i(location,x,y,z,w);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(GL_obj,uniform4i,(void))

Void GL_obj::uniform4iv( Dynamic location,Dynamic v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniform4iv",0x36af2aab,"openfl.gl.GL.uniform4iv","openfl/gl/GL.hx",1063,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1063)
		::openfl::gl::GL_obj::lime_gl_uniform4iv(location,v);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,uniform4iv,(void))

Void GL_obj::uniformMatrix2fv( Dynamic location,bool transpose,Dynamic v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniformMatrix2fv",0x064faf4b,"openfl.gl.GL.uniformMatrix2fv","openfl/gl/GL.hx",1073,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(transpose,"transpose")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1073)
		::openfl::gl::GL_obj::lime_gl_uniform_matrix(location,transpose,v,(int)2);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,uniformMatrix2fv,(void))

Void GL_obj::uniformMatrix3fv( Dynamic location,bool transpose,Dynamic v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniformMatrix3fv",0x0650718c,"openfl.gl.GL.uniformMatrix3fv","openfl/gl/GL.hx",1083,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(transpose,"transpose")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1083)
		::openfl::gl::GL_obj::lime_gl_uniform_matrix(location,transpose,v,(int)3);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,uniformMatrix3fv,(void))

Void GL_obj::uniformMatrix4fv( Dynamic location,bool transpose,Dynamic v){
{
		HX_STACK_FRAME("openfl.gl.GL","uniformMatrix4fv",0x065133cd,"openfl.gl.GL.uniformMatrix4fv","openfl/gl/GL.hx",1094,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(transpose,"transpose")
		HX_STACK_ARG(v,"v")
		HX_STACK_LINE(1094)
		::openfl::gl::GL_obj::lime_gl_uniform_matrix(location,transpose,v,(int)4);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,uniformMatrix4fv,(void))

Void GL_obj::uniformMatrix3D( Dynamic location,bool transpose,::flash::geom::Matrix3D matrix){
{
		HX_STACK_FRAME("openfl.gl.GL","uniformMatrix3D",0xf11ac388,"openfl.gl.GL.uniformMatrix3D","openfl/gl/GL.hx",1098,0x296f94ae)
		HX_STACK_ARG(location,"location")
		HX_STACK_ARG(transpose,"transpose")
		HX_STACK_ARG(matrix,"matrix")
		HX_STACK_LINE(1099)
		Dynamic _g;		HX_STACK_VAR(_g,"_g");
		HX_STACK_LINE(1099)
		{
			HX_STACK_LINE(1099)
			::openfl::utils::Float32Array f = ::openfl::utils::Float32Array_obj::fromMatrix(matrix);		HX_STACK_VAR(f,"f");
			HX_STACK_LINE(1099)
			Dynamic data = f->getByteBuffer();		HX_STACK_VAR(data,"data");
			HX_STACK_LINE(1099)
			_g = data;
		}
		HX_STACK_LINE(1099)
		::openfl::gl::GL_obj::lime_gl_uniform_matrix(location,transpose,_g,(int)4);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,uniformMatrix3D,(void))

Void GL_obj::useProgram( ::openfl::gl::GLProgram program){
{
		HX_STACK_FRAME("openfl.gl.GL","useProgram",0x52da4f3b,"openfl.gl.GL.useProgram","openfl/gl/GL.hx",1104,0x296f94ae)
		HX_STACK_ARG(program,"program")
		HX_STACK_LINE(1104)
		::openfl::gl::GL_obj::lime_gl_use_program((  (((program == null()))) ? Dynamic(null()) : Dynamic(program->id) ));
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,useProgram,(void))

Void GL_obj::validateProgram( ::openfl::gl::GLProgram program){
{
		HX_STACK_FRAME("openfl.gl.GL","validateProgram",0xc16ebd90,"openfl.gl.GL.validateProgram","openfl/gl/GL.hx",1109,0x296f94ae)
		HX_STACK_ARG(program,"program")
		HX_STACK_LINE(1109)
		::openfl::gl::GL_obj::lime_gl_validate_program(program->id);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(GL_obj,validateProgram,(void))

Void GL_obj::vertexAttrib1f( int indx,Float x){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib1f",0x0c556da1,"openfl.gl.GL.vertexAttrib1f","openfl/gl/GL.hx",1114,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(x,"x")
		HX_STACK_LINE(1114)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib1f(indx,x);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,vertexAttrib1f,(void))

Void GL_obj::vertexAttrib1fv( int indx,Dynamic values){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib1fv",0xbe6a7fb5,"openfl.gl.GL.vertexAttrib1fv","openfl/gl/GL.hx",1119,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(values,"values")
		HX_STACK_LINE(1119)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib1fv(indx,values);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,vertexAttrib1fv,(void))

Void GL_obj::vertexAttrib2f( int indx,Float x,Float y){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib2f",0x0c556e80,"openfl.gl.GL.vertexAttrib2f","openfl/gl/GL.hx",1124,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_LINE(1124)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib2f(indx,x,y);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC3(GL_obj,vertexAttrib2f,(void))

Void GL_obj::vertexAttrib2fv( int indx,Dynamic values){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib2fv",0xbe6b41f6,"openfl.gl.GL.vertexAttrib2fv","openfl/gl/GL.hx",1129,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(values,"values")
		HX_STACK_LINE(1129)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib2fv(indx,values);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,vertexAttrib2fv,(void))

Void GL_obj::vertexAttrib3f( int indx,Float x,Float y,Float z){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib3f",0x0c556f5f,"openfl.gl.GL.vertexAttrib3f","openfl/gl/GL.hx",1134,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_LINE(1134)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib3f(indx,x,y,z);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,vertexAttrib3f,(void))

Void GL_obj::vertexAttrib3fv( int indx,Dynamic values){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib3fv",0xbe6c0437,"openfl.gl.GL.vertexAttrib3fv","openfl/gl/GL.hx",1139,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(values,"values")
		HX_STACK_LINE(1139)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib3fv(indx,values);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,vertexAttrib3fv,(void))

Void GL_obj::vertexAttrib4f( int indx,Float x,Float y,Float z,Float w){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib4f",0x0c55703e,"openfl.gl.GL.vertexAttrib4f","openfl/gl/GL.hx",1144,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(z,"z")
		HX_STACK_ARG(w,"w")
		HX_STACK_LINE(1144)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib4f(indx,x,y,z,w);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(GL_obj,vertexAttrib4f,(void))

Void GL_obj::vertexAttrib4fv( int indx,Dynamic values){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttrib4fv",0xbe6cc678,"openfl.gl.GL.vertexAttrib4fv","openfl/gl/GL.hx",1149,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(values,"values")
		HX_STACK_LINE(1149)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib4fv(indx,values);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(GL_obj,vertexAttrib4fv,(void))

Void GL_obj::vertexAttribPointer( int indx,int size,int type,bool normalized,int stride,int offset){
{
		HX_STACK_FRAME("openfl.gl.GL","vertexAttribPointer",0xc5c4ea91,"openfl.gl.GL.vertexAttribPointer","openfl/gl/GL.hx",1154,0x296f94ae)
		HX_STACK_ARG(indx,"indx")
		HX_STACK_ARG(size,"size")
		HX_STACK_ARG(type,"type")
		HX_STACK_ARG(normalized,"normalized")
		HX_STACK_ARG(stride,"stride")
		HX_STACK_ARG(offset,"offset")
		HX_STACK_LINE(1154)
		::openfl::gl::GL_obj::lime_gl_vertex_attrib_pointer(indx,size,type,normalized,stride,offset);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC6(GL_obj,vertexAttribPointer,(void))

Void GL_obj::viewport( int x,int y,int width,int height){
{
		HX_STACK_FRAME("openfl.gl.GL","viewport",0x1e498324,"openfl.gl.GL.viewport","openfl/gl/GL.hx",1159,0x296f94ae)
		HX_STACK_ARG(x,"x")
		HX_STACK_ARG(y,"y")
		HX_STACK_ARG(width,"width")
		HX_STACK_ARG(height,"height")
		HX_STACK_LINE(1159)
		::openfl::gl::GL_obj::lime_gl_viewport(x,y,width,height);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(GL_obj,viewport,(void))

int GL_obj::get_drawingBufferHeight( ){
	HX_STACK_FRAME("openfl.gl.GL","get_drawingBufferHeight",0xfe52cb1e,"openfl.gl.GL.get_drawingBufferHeight","openfl/gl/GL.hx",1170,0x296f94ae)
	HX_STACK_LINE(1170)
	return ::flash::Lib_obj::get_current()->get_stage()->get_stageHeight();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,get_drawingBufferHeight,return )

int GL_obj::get_drawingBufferWidth( ){
	HX_STACK_FRAME("openfl.gl.GL","get_drawingBufferWidth",0x643286af,"openfl.gl.GL.get_drawingBufferWidth","openfl/gl/GL.hx",1171,0x296f94ae)
	HX_STACK_LINE(1171)
	return ::flash::Lib_obj::get_current()->get_stage()->get_stageWidth();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,get_drawingBufferWidth,return )

int GL_obj::get_version( ){
	HX_STACK_FRAME("openfl.gl.GL","get_version",0x4ee45b31,"openfl.gl.GL.get_version","openfl/gl/GL.hx",1172,0x296f94ae)
	HX_STACK_LINE(1172)
	return ::openfl::gl::GL_obj::lime_gl_version();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(GL_obj,get_version,return )

Dynamic GL_obj::lime_gl_active_texture;

Dynamic GL_obj::lime_gl_attach_shader;

Dynamic GL_obj::lime_gl_bind_attrib_location;

Dynamic GL_obj::lime_gl_bind_bitmap_data_texture;

Dynamic GL_obj::lime_gl_bind_buffer;

Dynamic GL_obj::lime_gl_bind_framebuffer;

Dynamic GL_obj::lime_gl_bind_renderbuffer;

Dynamic GL_obj::lime_gl_bind_texture;

Dynamic GL_obj::lime_gl_blend_color;

Dynamic GL_obj::lime_gl_blend_equation;

Dynamic GL_obj::lime_gl_blend_equation_separate;

Dynamic GL_obj::lime_gl_blend_func;

Dynamic GL_obj::lime_gl_blend_func_separate;

Dynamic GL_obj::lime_gl_buffer_data;

Dynamic GL_obj::lime_gl_buffer_sub_data;

Dynamic GL_obj::lime_gl_check_framebuffer_status;

Dynamic GL_obj::lime_gl_clear;

Dynamic GL_obj::lime_gl_clear_color;

Dynamic GL_obj::lime_gl_clear_depth;

Dynamic GL_obj::lime_gl_clear_stencil;

Dynamic GL_obj::lime_gl_color_mask;

Dynamic GL_obj::lime_gl_compile_shader;

Dynamic GL_obj::lime_gl_compressed_tex_image_2d;

Dynamic GL_obj::lime_gl_compressed_tex_sub_image_2d;

Dynamic GL_obj::lime_gl_copy_tex_image_2d;

Dynamic GL_obj::lime_gl_copy_tex_sub_image_2d;

Dynamic GL_obj::lime_gl_create_buffer;

Dynamic GL_obj::lime_gl_create_framebuffer;

Dynamic GL_obj::lime_gl_create_program;

Dynamic GL_obj::lime_gl_create_render_buffer;

Dynamic GL_obj::lime_gl_create_shader;

Dynamic GL_obj::lime_gl_create_texture;

Dynamic GL_obj::lime_gl_cull_face;

Dynamic GL_obj::lime_gl_delete_buffer;

Dynamic GL_obj::lime_gl_delete_framebuffer;

Dynamic GL_obj::lime_gl_delete_program;

Dynamic GL_obj::lime_gl_delete_render_buffer;

Dynamic GL_obj::lime_gl_delete_shader;

Dynamic GL_obj::lime_gl_delete_texture;

Dynamic GL_obj::lime_gl_depth_func;

Dynamic GL_obj::lime_gl_depth_mask;

Dynamic GL_obj::lime_gl_depth_range;

Dynamic GL_obj::lime_gl_detach_shader;

Dynamic GL_obj::lime_gl_disable;

Dynamic GL_obj::lime_gl_disable_vertex_attrib_array;

Dynamic GL_obj::lime_gl_draw_arrays;

Dynamic GL_obj::lime_gl_draw_elements;

Dynamic GL_obj::lime_gl_enable;

Dynamic GL_obj::lime_gl_enable_vertex_attrib_array;

Dynamic GL_obj::lime_gl_finish;

Dynamic GL_obj::lime_gl_flush;

Dynamic GL_obj::lime_gl_framebuffer_renderbuffer;

Dynamic GL_obj::lime_gl_framebuffer_texture2D;

Dynamic GL_obj::lime_gl_front_face;

Dynamic GL_obj::lime_gl_generate_mipmap;

Dynamic GL_obj::lime_gl_get_active_attrib;

Dynamic GL_obj::lime_gl_get_active_uniform;

Dynamic GL_obj::lime_gl_get_attrib_location;

Dynamic GL_obj::lime_gl_get_buffer_paramerter;

Dynamic GL_obj::lime_gl_get_context_attributes;

Dynamic GL_obj::lime_gl_get_error;

Dynamic GL_obj::lime_gl_get_framebuffer_attachment_parameter;

Dynamic GL_obj::lime_gl_get_parameter;

Dynamic GL_obj::lime_gl_get_program_info_log;

Dynamic GL_obj::lime_gl_get_program_parameter;

Dynamic GL_obj::lime_gl_get_render_buffer_parameter;

Dynamic GL_obj::lime_gl_get_shader_info_log;

Dynamic GL_obj::lime_gl_get_shader_parameter;

Dynamic GL_obj::lime_gl_get_shader_precision_format;

Dynamic GL_obj::lime_gl_get_shader_source;

Dynamic GL_obj::lime_gl_get_supported_extensions;

Dynamic GL_obj::lime_gl_get_tex_parameter;

Dynamic GL_obj::lime_gl_get_uniform;

Dynamic GL_obj::lime_gl_get_uniform_location;

Dynamic GL_obj::lime_gl_get_vertex_attrib;

Dynamic GL_obj::lime_gl_get_vertex_attrib_offset;

Dynamic GL_obj::lime_gl_hint;

Dynamic GL_obj::lime_gl_is_buffer;

Dynamic GL_obj::lime_gl_is_enabled;

Dynamic GL_obj::lime_gl_is_framebuffer;

Dynamic GL_obj::lime_gl_is_program;

Dynamic GL_obj::lime_gl_is_renderbuffer;

Dynamic GL_obj::lime_gl_is_shader;

Dynamic GL_obj::lime_gl_is_texture;

Dynamic GL_obj::lime_gl_line_width;

Dynamic GL_obj::lime_gl_link_program;

Dynamic GL_obj::lime_gl_pixel_storei;

Dynamic GL_obj::lime_gl_polygon_offset;

Dynamic GL_obj::lime_gl_read_pixels;

Dynamic GL_obj::lime_gl_renderbuffer_storage;

Dynamic GL_obj::lime_gl_sample_coverage;

Dynamic GL_obj::lime_gl_scissor;

Dynamic GL_obj::lime_gl_shader_source;

Dynamic GL_obj::lime_gl_stencil_func;

Dynamic GL_obj::lime_gl_stencil_func_separate;

Dynamic GL_obj::lime_gl_stencil_mask;

Dynamic GL_obj::lime_gl_stencil_mask_separate;

Dynamic GL_obj::lime_gl_stencil_op;

Dynamic GL_obj::lime_gl_stencil_op_separate;

Dynamic GL_obj::lime_gl_tex_image_2d;

Dynamic GL_obj::lime_gl_tex_parameterf;

Dynamic GL_obj::lime_gl_tex_parameteri;

Dynamic GL_obj::lime_gl_tex_sub_image_2d;

Dynamic GL_obj::lime_gl_uniform1f;

Dynamic GL_obj::lime_gl_uniform1fv;

Dynamic GL_obj::lime_gl_uniform1i;

Dynamic GL_obj::lime_gl_uniform1iv;

Dynamic GL_obj::lime_gl_uniform2f;

Dynamic GL_obj::lime_gl_uniform2fv;

Dynamic GL_obj::lime_gl_uniform2i;

Dynamic GL_obj::lime_gl_uniform2iv;

Dynamic GL_obj::lime_gl_uniform3f;

Dynamic GL_obj::lime_gl_uniform3fv;

Dynamic GL_obj::lime_gl_uniform3i;

Dynamic GL_obj::lime_gl_uniform3iv;

Dynamic GL_obj::lime_gl_uniform4f;

Dynamic GL_obj::lime_gl_uniform4fv;

Dynamic GL_obj::lime_gl_uniform4i;

Dynamic GL_obj::lime_gl_uniform4iv;

Dynamic GL_obj::lime_gl_uniform_matrix;

Dynamic GL_obj::lime_gl_use_program;

Dynamic GL_obj::lime_gl_validate_program;

Dynamic GL_obj::lime_gl_version;

Dynamic GL_obj::lime_gl_vertex_attrib1f;

Dynamic GL_obj::lime_gl_vertex_attrib1fv;

Dynamic GL_obj::lime_gl_vertex_attrib2f;

Dynamic GL_obj::lime_gl_vertex_attrib2fv;

Dynamic GL_obj::lime_gl_vertex_attrib3f;

Dynamic GL_obj::lime_gl_vertex_attrib3fv;

Dynamic GL_obj::lime_gl_vertex_attrib4f;

Dynamic GL_obj::lime_gl_vertex_attrib4fv;

Dynamic GL_obj::lime_gl_vertex_attrib_pointer;

Dynamic GL_obj::lime_gl_viewport;


GL_obj::GL_obj()
{
}

Dynamic GL_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"hint") ) { return hint_dyn(); }
		if (HX_FIELD_EQ(inName,"load") ) { return load_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"clear") ) { return clear_dyn(); }
		if (HX_FIELD_EQ(inName,"flush") ) { return flush_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"enable") ) { return enable_dyn(); }
		if (HX_FIELD_EQ(inName,"finish") ) { return finish_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"version") ) { return inCallProp ? get_version() : version; }
		if (HX_FIELD_EQ(inName,"disable") ) { return disable_dyn(); }
		if (HX_FIELD_EQ(inName,"scissor") ) { return scissor_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"cullFace") ) { return cullFace_dyn(); }
		if (HX_FIELD_EQ(inName,"getError") ) { return getError_dyn(); }
		if (HX_FIELD_EQ(inName,"isBuffer") ) { return isBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"isShader") ) { return isShader_dyn(); }
		if (HX_FIELD_EQ(inName,"viewport") ) { return viewport_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"blendFunc") ) { return blendFunc_dyn(); }
		if (HX_FIELD_EQ(inName,"colorMask") ) { return colorMask_dyn(); }
		if (HX_FIELD_EQ(inName,"depthFunc") ) { return depthFunc_dyn(); }
		if (HX_FIELD_EQ(inName,"depthMask") ) { return depthMask_dyn(); }
		if (HX_FIELD_EQ(inName,"frontFace") ) { return frontFace_dyn(); }
		if (HX_FIELD_EQ(inName,"isEnabled") ) { return isEnabled_dyn(); }
		if (HX_FIELD_EQ(inName,"isProgram") ) { return isProgram_dyn(); }
		if (HX_FIELD_EQ(inName,"isTexture") ) { return isTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"lineWidth") ) { return lineWidth_dyn(); }
		if (HX_FIELD_EQ(inName,"stencilOp") ) { return stencilOp_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform1f") ) { return uniform1f_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform1i") ) { return uniform1i_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform2f") ) { return uniform2f_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform2i") ) { return uniform2i_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform3f") ) { return uniform3f_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform3i") ) { return uniform3i_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform4f") ) { return uniform4f_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform4i") ) { return uniform4i_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"bindBuffer") ) { return bindBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"blendColor") ) { return blendColor_dyn(); }
		if (HX_FIELD_EQ(inName,"bufferData") ) { return bufferData_dyn(); }
		if (HX_FIELD_EQ(inName,"clearColor") ) { return clearColor_dyn(); }
		if (HX_FIELD_EQ(inName,"clearDepth") ) { return clearDepth_dyn(); }
		if (HX_FIELD_EQ(inName,"depthRange") ) { return depthRange_dyn(); }
		if (HX_FIELD_EQ(inName,"drawArrays") ) { return drawArrays_dyn(); }
		if (HX_FIELD_EQ(inName,"getUniform") ) { return getUniform_dyn(); }
		if (HX_FIELD_EQ(inName,"readPixels") ) { return readPixels_dyn(); }
		if (HX_FIELD_EQ(inName,"texImage2D") ) { return texImage2D_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform1fv") ) { return uniform1fv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform1iv") ) { return uniform1iv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform2fv") ) { return uniform2fv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform2iv") ) { return uniform2iv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform3fv") ) { return uniform3fv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform3iv") ) { return uniform3iv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform4fv") ) { return uniform4fv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniform4iv") ) { return uniform4iv_dyn(); }
		if (HX_FIELD_EQ(inName,"useProgram") ) { return useProgram_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"bindTexture") ) { return bindTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"linkProgram") ) { return linkProgram_dyn(); }
		if (HX_FIELD_EQ(inName,"pixelStorei") ) { return pixelStorei_dyn(); }
		if (HX_FIELD_EQ(inName,"stencilFunc") ) { return stencilFunc_dyn(); }
		if (HX_FIELD_EQ(inName,"stencilMask") ) { return stencilMask_dyn(); }
		if (HX_FIELD_EQ(inName,"get_version") ) { return get_version_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"attachShader") ) { return attachShader_dyn(); }
		if (HX_FIELD_EQ(inName,"clearStencil") ) { return clearStencil_dyn(); }
		if (HX_FIELD_EQ(inName,"createBuffer") ) { return createBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"createShader") ) { return createShader_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteBuffer") ) { return deleteBuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteShader") ) { return deleteShader_dyn(); }
		if (HX_FIELD_EQ(inName,"detachShader") ) { return detachShader_dyn(); }
		if (HX_FIELD_EQ(inName,"drawElements") ) { return drawElements_dyn(); }
		if (HX_FIELD_EQ(inName,"getExtension") ) { return getExtension_dyn(); }
		if (HX_FIELD_EQ(inName,"getParameter") ) { return getParameter_dyn(); }
		if (HX_FIELD_EQ(inName,"shaderSource") ) { return shaderSource_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_hint") ) { return lime_gl_hint; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"activeTexture") ) { return activeTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"blendEquation") ) { return blendEquation_dyn(); }
		if (HX_FIELD_EQ(inName,"bufferSubData") ) { return bufferSubData_dyn(); }
		if (HX_FIELD_EQ(inName,"compileShader") ) { return compileShader_dyn(); }
		if (HX_FIELD_EQ(inName,"createProgram") ) { return createProgram_dyn(); }
		if (HX_FIELD_EQ(inName,"createTexture") ) { return createTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteProgram") ) { return deleteProgram_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteTexture") ) { return deleteTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"isFramebuffer") ) { return isFramebuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"polygonOffset") ) { return polygonOffset_dyn(); }
		if (HX_FIELD_EQ(inName,"texParameterf") ) { return texParameterf_dyn(); }
		if (HX_FIELD_EQ(inName,"texParameteri") ) { return texParameteri_dyn(); }
		if (HX_FIELD_EQ(inName,"texSubImage2D") ) { return texSubImage2D_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_clear") ) { return lime_gl_clear; }
		if (HX_FIELD_EQ(inName,"lime_gl_flush") ) { return lime_gl_flush; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"copyTexImage2D") ) { return copyTexImage2D_dyn(); }
		if (HX_FIELD_EQ(inName,"generateMipmap") ) { return generateMipmap_dyn(); }
		if (HX_FIELD_EQ(inName,"isRenderbuffer") ) { return isRenderbuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"sampleCoverage") ) { return sampleCoverage_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib1f") ) { return vertexAttrib1f_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib2f") ) { return vertexAttrib2f_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib3f") ) { return vertexAttrib3f_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib4f") ) { return vertexAttrib4f_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_enable") ) { return lime_gl_enable; }
		if (HX_FIELD_EQ(inName,"lime_gl_finish") ) { return lime_gl_finish; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"bindFramebuffer") ) { return bindFramebuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"getActiveAttrib") ) { return getActiveAttrib_dyn(); }
		if (HX_FIELD_EQ(inName,"getShaderSource") ) { return getShaderSource_dyn(); }
		if (HX_FIELD_EQ(inName,"getTexParameter") ) { return getTexParameter_dyn(); }
		if (HX_FIELD_EQ(inName,"getVertexAttrib") ) { return getVertexAttrib_dyn(); }
		if (HX_FIELD_EQ(inName,"uniformMatrix3D") ) { return uniformMatrix3D_dyn(); }
		if (HX_FIELD_EQ(inName,"validateProgram") ) { return validateProgram_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib1fv") ) { return vertexAttrib1fv_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib2fv") ) { return vertexAttrib2fv_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib3fv") ) { return vertexAttrib3fv_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttrib4fv") ) { return vertexAttrib4fv_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_disable") ) { return lime_gl_disable; }
		if (HX_FIELD_EQ(inName,"lime_gl_scissor") ) { return lime_gl_scissor; }
		if (HX_FIELD_EQ(inName,"lime_gl_version") ) { return lime_gl_version; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"bindRenderbuffer") ) { return bindRenderbuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"getActiveUniform") ) { return getActiveUniform_dyn(); }
		if (HX_FIELD_EQ(inName,"getShaderInfoLog") ) { return getShaderInfoLog_dyn(); }
		if (HX_FIELD_EQ(inName,"uniformMatrix2fv") ) { return uniformMatrix2fv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniformMatrix3fv") ) { return uniformMatrix3fv_dyn(); }
		if (HX_FIELD_EQ(inName,"uniformMatrix4fv") ) { return uniformMatrix4fv_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_viewport") ) { return lime_gl_viewport; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"blendFuncSeparate") ) { return blendFuncSeparate_dyn(); }
		if (HX_FIELD_EQ(inName,"copyTexSubImage2D") ) { return copyTexSubImage2D_dyn(); }
		if (HX_FIELD_EQ(inName,"createFramebuffer") ) { return createFramebuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteFramebuffer") ) { return deleteFramebuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"getAttribLocation") ) { return getAttribLocation_dyn(); }
		if (HX_FIELD_EQ(inName,"getProgramInfoLog") ) { return getProgramInfoLog_dyn(); }
		if (HX_FIELD_EQ(inName,"stencilOpSeparate") ) { return stencilOpSeparate_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_cull_face") ) { return lime_gl_cull_face; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_error") ) { return lime_gl_get_error; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_buffer") ) { return lime_gl_is_buffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_shader") ) { return lime_gl_is_shader; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1f") ) { return lime_gl_uniform1f; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1i") ) { return lime_gl_uniform1i; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2f") ) { return lime_gl_uniform2f; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2i") ) { return lime_gl_uniform2i; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3f") ) { return lime_gl_uniform3f; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3i") ) { return lime_gl_uniform3i; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4f") ) { return lime_gl_uniform4f; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4i") ) { return lime_gl_uniform4i; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"drawingBufferWidth") ) { return inCallProp ? get_drawingBufferWidth() : drawingBufferWidth; }
		if (HX_FIELD_EQ(inName,"bindAttribLocation") ) { return bindAttribLocation_dyn(); }
		if (HX_FIELD_EQ(inName,"createRenderbuffer") ) { return createRenderbuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"deleteRenderbuffer") ) { return deleteRenderbuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"getAttachedShaders") ) { return getAttachedShaders_dyn(); }
		if (HX_FIELD_EQ(inName,"getBufferParameter") ) { return getBufferParameter_dyn(); }
		if (HX_FIELD_EQ(inName,"getShaderParameter") ) { return getShaderParameter_dyn(); }
		if (HX_FIELD_EQ(inName,"getUniformLocation") ) { return getUniformLocation_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_blend_func") ) { return lime_gl_blend_func; }
		if (HX_FIELD_EQ(inName,"lime_gl_color_mask") ) { return lime_gl_color_mask; }
		if (HX_FIELD_EQ(inName,"lime_gl_depth_func") ) { return lime_gl_depth_func; }
		if (HX_FIELD_EQ(inName,"lime_gl_depth_mask") ) { return lime_gl_depth_mask; }
		if (HX_FIELD_EQ(inName,"lime_gl_front_face") ) { return lime_gl_front_face; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_enabled") ) { return lime_gl_is_enabled; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_program") ) { return lime_gl_is_program; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_texture") ) { return lime_gl_is_texture; }
		if (HX_FIELD_EQ(inName,"lime_gl_line_width") ) { return lime_gl_line_width; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_op") ) { return lime_gl_stencil_op; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1fv") ) { return lime_gl_uniform1fv; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1iv") ) { return lime_gl_uniform1iv; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2fv") ) { return lime_gl_uniform2fv; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2iv") ) { return lime_gl_uniform2iv; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3fv") ) { return lime_gl_uniform3fv; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3iv") ) { return lime_gl_uniform3iv; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4fv") ) { return lime_gl_uniform4fv; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4iv") ) { return lime_gl_uniform4iv; }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"drawingBufferHeight") ) { return inCallProp ? get_drawingBufferHeight() : drawingBufferHeight; }
		if (HX_FIELD_EQ(inName,"getProgramParameter") ) { return getProgramParameter_dyn(); }
		if (HX_FIELD_EQ(inName,"renderbufferStorage") ) { return renderbufferStorage_dyn(); }
		if (HX_FIELD_EQ(inName,"stencilFuncSeparate") ) { return stencilFuncSeparate_dyn(); }
		if (HX_FIELD_EQ(inName,"stencilMaskSeparate") ) { return stencilMaskSeparate_dyn(); }
		if (HX_FIELD_EQ(inName,"vertexAttribPointer") ) { return vertexAttribPointer_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_bind_buffer") ) { return lime_gl_bind_buffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_blend_color") ) { return lime_gl_blend_color; }
		if (HX_FIELD_EQ(inName,"lime_gl_buffer_data") ) { return lime_gl_buffer_data; }
		if (HX_FIELD_EQ(inName,"lime_gl_clear_color") ) { return lime_gl_clear_color; }
		if (HX_FIELD_EQ(inName,"lime_gl_clear_depth") ) { return lime_gl_clear_depth; }
		if (HX_FIELD_EQ(inName,"lime_gl_depth_range") ) { return lime_gl_depth_range; }
		if (HX_FIELD_EQ(inName,"lime_gl_draw_arrays") ) { return lime_gl_draw_arrays; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_uniform") ) { return lime_gl_get_uniform; }
		if (HX_FIELD_EQ(inName,"lime_gl_read_pixels") ) { return lime_gl_read_pixels; }
		if (HX_FIELD_EQ(inName,"lime_gl_use_program") ) { return lime_gl_use_program; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"compressedTexImage2D") ) { return compressedTexImage2D_dyn(); }
		if (HX_FIELD_EQ(inName,"framebufferTexture2D") ) { return framebufferTexture2D_dyn(); }
		if (HX_FIELD_EQ(inName,"getContextAttributes") ) { return getContextAttributes_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_bind_texture") ) { return lime_gl_bind_texture; }
		if (HX_FIELD_EQ(inName,"lime_gl_link_program") ) { return lime_gl_link_program; }
		if (HX_FIELD_EQ(inName,"lime_gl_pixel_storei") ) { return lime_gl_pixel_storei; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_func") ) { return lime_gl_stencil_func; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_mask") ) { return lime_gl_stencil_mask; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_image_2d") ) { return lime_gl_tex_image_2d; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"bindBitmapDataTexture") ) { return bindBitmapDataTexture_dyn(); }
		if (HX_FIELD_EQ(inName,"blendEquationSeparate") ) { return blendEquationSeparate_dyn(); }
		if (HX_FIELD_EQ(inName,"getVertexAttribOffset") ) { return getVertexAttribOffset_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_attach_shader") ) { return lime_gl_attach_shader; }
		if (HX_FIELD_EQ(inName,"lime_gl_clear_stencil") ) { return lime_gl_clear_stencil; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_buffer") ) { return lime_gl_create_buffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_shader") ) { return lime_gl_create_shader; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_buffer") ) { return lime_gl_delete_buffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_shader") ) { return lime_gl_delete_shader; }
		if (HX_FIELD_EQ(inName,"lime_gl_detach_shader") ) { return lime_gl_detach_shader; }
		if (HX_FIELD_EQ(inName,"lime_gl_draw_elements") ) { return lime_gl_draw_elements; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_parameter") ) { return lime_gl_get_parameter; }
		if (HX_FIELD_EQ(inName,"lime_gl_shader_source") ) { return lime_gl_shader_source; }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"checkFramebufferStatus") ) { return checkFramebufferStatus_dyn(); }
		if (HX_FIELD_EQ(inName,"getSupportedExtensions") ) { return getSupportedExtensions_dyn(); }
		if (HX_FIELD_EQ(inName,"get_drawingBufferWidth") ) { return get_drawingBufferWidth_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_active_texture") ) { return lime_gl_active_texture; }
		if (HX_FIELD_EQ(inName,"lime_gl_blend_equation") ) { return lime_gl_blend_equation; }
		if (HX_FIELD_EQ(inName,"lime_gl_compile_shader") ) { return lime_gl_compile_shader; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_program") ) { return lime_gl_create_program; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_texture") ) { return lime_gl_create_texture; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_program") ) { return lime_gl_delete_program; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_texture") ) { return lime_gl_delete_texture; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_framebuffer") ) { return lime_gl_is_framebuffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_polygon_offset") ) { return lime_gl_polygon_offset; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_parameterf") ) { return lime_gl_tex_parameterf; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_parameteri") ) { return lime_gl_tex_parameteri; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform_matrix") ) { return lime_gl_uniform_matrix; }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"compressedTexSubImage2D") ) { return compressedTexSubImage2D_dyn(); }
		if (HX_FIELD_EQ(inName,"enableVertexAttribArray") ) { return enableVertexAttribArray_dyn(); }
		if (HX_FIELD_EQ(inName,"framebufferRenderbuffer") ) { return framebufferRenderbuffer_dyn(); }
		if (HX_FIELD_EQ(inName,"get_drawingBufferHeight") ) { return get_drawingBufferHeight_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_buffer_sub_data") ) { return lime_gl_buffer_sub_data; }
		if (HX_FIELD_EQ(inName,"lime_gl_generate_mipmap") ) { return lime_gl_generate_mipmap; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_renderbuffer") ) { return lime_gl_is_renderbuffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_sample_coverage") ) { return lime_gl_sample_coverage; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib1f") ) { return lime_gl_vertex_attrib1f; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib2f") ) { return lime_gl_vertex_attrib2f; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib3f") ) { return lime_gl_vertex_attrib3f; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib4f") ) { return lime_gl_vertex_attrib4f; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"disableVertexAttribArray") ) { return disableVertexAttribArray_dyn(); }
		if (HX_FIELD_EQ(inName,"getRenderbufferParameter") ) { return getRenderbufferParameter_dyn(); }
		if (HX_FIELD_EQ(inName,"getShaderPrecisionFormat") ) { return getShaderPrecisionFormat_dyn(); }
		if (HX_FIELD_EQ(inName,"lime_gl_bind_framebuffer") ) { return lime_gl_bind_framebuffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_sub_image_2d") ) { return lime_gl_tex_sub_image_2d; }
		if (HX_FIELD_EQ(inName,"lime_gl_validate_program") ) { return lime_gl_validate_program; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib1fv") ) { return lime_gl_vertex_attrib1fv; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib2fv") ) { return lime_gl_vertex_attrib2fv; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib3fv") ) { return lime_gl_vertex_attrib3fv; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib4fv") ) { return lime_gl_vertex_attrib4fv; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_renderbuffer") ) { return lime_gl_bind_renderbuffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_copy_tex_image_2d") ) { return lime_gl_copy_tex_image_2d; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_active_attrib") ) { return lime_gl_get_active_attrib; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_source") ) { return lime_gl_get_shader_source; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_tex_parameter") ) { return lime_gl_get_tex_parameter; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_vertex_attrib") ) { return lime_gl_get_vertex_attrib; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"lime_gl_create_framebuffer") ) { return lime_gl_create_framebuffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_framebuffer") ) { return lime_gl_delete_framebuffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_active_uniform") ) { return lime_gl_get_active_uniform; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_gl_blend_func_separate") ) { return lime_gl_blend_func_separate; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_attrib_location") ) { return lime_gl_get_attrib_location; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_info_log") ) { return lime_gl_get_shader_info_log; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_op_separate") ) { return lime_gl_stencil_op_separate; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_attrib_location") ) { return lime_gl_bind_attrib_location; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_render_buffer") ) { return lime_gl_create_render_buffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_render_buffer") ) { return lime_gl_delete_render_buffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_program_info_log") ) { return lime_gl_get_program_info_log; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_parameter") ) { return lime_gl_get_shader_parameter; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_uniform_location") ) { return lime_gl_get_uniform_location; }
		if (HX_FIELD_EQ(inName,"lime_gl_renderbuffer_storage") ) { return lime_gl_renderbuffer_storage; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_gl_copy_tex_sub_image_2d") ) { return lime_gl_copy_tex_sub_image_2d; }
		if (HX_FIELD_EQ(inName,"lime_gl_framebuffer_texture2D") ) { return lime_gl_framebuffer_texture2D; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_buffer_paramerter") ) { return lime_gl_get_buffer_paramerter; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_program_parameter") ) { return lime_gl_get_program_parameter; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_func_separate") ) { return lime_gl_stencil_func_separate; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_mask_separate") ) { return lime_gl_stencil_mask_separate; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib_pointer") ) { return lime_gl_vertex_attrib_pointer; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_gl_get_context_attributes") ) { return lime_gl_get_context_attributes; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"lime_gl_blend_equation_separate") ) { return lime_gl_blend_equation_separate; }
		if (HX_FIELD_EQ(inName,"lime_gl_compressed_tex_image_2d") ) { return lime_gl_compressed_tex_image_2d; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_bitmap_data_texture") ) { return lime_gl_bind_bitmap_data_texture; }
		if (HX_FIELD_EQ(inName,"lime_gl_check_framebuffer_status") ) { return lime_gl_check_framebuffer_status; }
		if (HX_FIELD_EQ(inName,"lime_gl_framebuffer_renderbuffer") ) { return lime_gl_framebuffer_renderbuffer; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_supported_extensions") ) { return lime_gl_get_supported_extensions; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_vertex_attrib_offset") ) { return lime_gl_get_vertex_attrib_offset; }
		break;
	case 33:
		if (HX_FIELD_EQ(inName,"getFramebufferAttachmentParameter") ) { return getFramebufferAttachmentParameter_dyn(); }
		break;
	case 34:
		if (HX_FIELD_EQ(inName,"lime_gl_enable_vertex_attrib_array") ) { return lime_gl_enable_vertex_attrib_array; }
		break;
	case 35:
		if (HX_FIELD_EQ(inName,"lime_gl_compressed_tex_sub_image_2d") ) { return lime_gl_compressed_tex_sub_image_2d; }
		if (HX_FIELD_EQ(inName,"lime_gl_disable_vertex_attrib_array") ) { return lime_gl_disable_vertex_attrib_array; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_render_buffer_parameter") ) { return lime_gl_get_render_buffer_parameter; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_precision_format") ) { return lime_gl_get_shader_precision_format; }
		break;
	case 44:
		if (HX_FIELD_EQ(inName,"lime_gl_get_framebuffer_attachment_parameter") ) { return lime_gl_get_framebuffer_attachment_parameter; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic GL_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 7:
		if (HX_FIELD_EQ(inName,"version") ) { version=inValue.Cast< int >(); return inValue; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"lime_gl_hint") ) { lime_gl_hint=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"lime_gl_clear") ) { lime_gl_clear=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_flush") ) { lime_gl_flush=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"lime_gl_enable") ) { lime_gl_enable=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_finish") ) { lime_gl_finish=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"lime_gl_disable") ) { lime_gl_disable=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_scissor") ) { lime_gl_scissor=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_version") ) { lime_gl_version=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"lime_gl_viewport") ) { lime_gl_viewport=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"lime_gl_cull_face") ) { lime_gl_cull_face=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_error") ) { lime_gl_get_error=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_buffer") ) { lime_gl_is_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_shader") ) { lime_gl_is_shader=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1f") ) { lime_gl_uniform1f=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1i") ) { lime_gl_uniform1i=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2f") ) { lime_gl_uniform2f=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2i") ) { lime_gl_uniform2i=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3f") ) { lime_gl_uniform3f=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3i") ) { lime_gl_uniform3i=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4f") ) { lime_gl_uniform4f=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4i") ) { lime_gl_uniform4i=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"drawingBufferWidth") ) { drawingBufferWidth=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_blend_func") ) { lime_gl_blend_func=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_color_mask") ) { lime_gl_color_mask=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_depth_func") ) { lime_gl_depth_func=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_depth_mask") ) { lime_gl_depth_mask=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_front_face") ) { lime_gl_front_face=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_enabled") ) { lime_gl_is_enabled=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_program") ) { lime_gl_is_program=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_texture") ) { lime_gl_is_texture=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_line_width") ) { lime_gl_line_width=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_op") ) { lime_gl_stencil_op=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1fv") ) { lime_gl_uniform1fv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform1iv") ) { lime_gl_uniform1iv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2fv") ) { lime_gl_uniform2fv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform2iv") ) { lime_gl_uniform2iv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3fv") ) { lime_gl_uniform3fv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform3iv") ) { lime_gl_uniform3iv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4fv") ) { lime_gl_uniform4fv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform4iv") ) { lime_gl_uniform4iv=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 19:
		if (HX_FIELD_EQ(inName,"drawingBufferHeight") ) { drawingBufferHeight=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_bind_buffer") ) { lime_gl_bind_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_blend_color") ) { lime_gl_blend_color=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_buffer_data") ) { lime_gl_buffer_data=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_clear_color") ) { lime_gl_clear_color=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_clear_depth") ) { lime_gl_clear_depth=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_depth_range") ) { lime_gl_depth_range=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_draw_arrays") ) { lime_gl_draw_arrays=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_uniform") ) { lime_gl_get_uniform=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_read_pixels") ) { lime_gl_read_pixels=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_use_program") ) { lime_gl_use_program=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 20:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_texture") ) { lime_gl_bind_texture=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_link_program") ) { lime_gl_link_program=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_pixel_storei") ) { lime_gl_pixel_storei=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_func") ) { lime_gl_stencil_func=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_mask") ) { lime_gl_stencil_mask=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_image_2d") ) { lime_gl_tex_image_2d=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 21:
		if (HX_FIELD_EQ(inName,"lime_gl_attach_shader") ) { lime_gl_attach_shader=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_clear_stencil") ) { lime_gl_clear_stencil=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_buffer") ) { lime_gl_create_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_shader") ) { lime_gl_create_shader=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_buffer") ) { lime_gl_delete_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_shader") ) { lime_gl_delete_shader=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_detach_shader") ) { lime_gl_detach_shader=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_draw_elements") ) { lime_gl_draw_elements=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_parameter") ) { lime_gl_get_parameter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_shader_source") ) { lime_gl_shader_source=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 22:
		if (HX_FIELD_EQ(inName,"lime_gl_active_texture") ) { lime_gl_active_texture=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_blend_equation") ) { lime_gl_blend_equation=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_compile_shader") ) { lime_gl_compile_shader=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_program") ) { lime_gl_create_program=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_texture") ) { lime_gl_create_texture=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_program") ) { lime_gl_delete_program=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_texture") ) { lime_gl_delete_texture=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_framebuffer") ) { lime_gl_is_framebuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_polygon_offset") ) { lime_gl_polygon_offset=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_parameterf") ) { lime_gl_tex_parameterf=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_parameteri") ) { lime_gl_tex_parameteri=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_uniform_matrix") ) { lime_gl_uniform_matrix=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 23:
		if (HX_FIELD_EQ(inName,"lime_gl_buffer_sub_data") ) { lime_gl_buffer_sub_data=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_generate_mipmap") ) { lime_gl_generate_mipmap=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_is_renderbuffer") ) { lime_gl_is_renderbuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_sample_coverage") ) { lime_gl_sample_coverage=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib1f") ) { lime_gl_vertex_attrib1f=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib2f") ) { lime_gl_vertex_attrib2f=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib3f") ) { lime_gl_vertex_attrib3f=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib4f") ) { lime_gl_vertex_attrib4f=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 24:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_framebuffer") ) { lime_gl_bind_framebuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_tex_sub_image_2d") ) { lime_gl_tex_sub_image_2d=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_validate_program") ) { lime_gl_validate_program=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib1fv") ) { lime_gl_vertex_attrib1fv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib2fv") ) { lime_gl_vertex_attrib2fv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib3fv") ) { lime_gl_vertex_attrib3fv=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib4fv") ) { lime_gl_vertex_attrib4fv=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 25:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_renderbuffer") ) { lime_gl_bind_renderbuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_copy_tex_image_2d") ) { lime_gl_copy_tex_image_2d=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_active_attrib") ) { lime_gl_get_active_attrib=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_source") ) { lime_gl_get_shader_source=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_tex_parameter") ) { lime_gl_get_tex_parameter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_vertex_attrib") ) { lime_gl_get_vertex_attrib=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 26:
		if (HX_FIELD_EQ(inName,"lime_gl_create_framebuffer") ) { lime_gl_create_framebuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_framebuffer") ) { lime_gl_delete_framebuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_active_uniform") ) { lime_gl_get_active_uniform=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"lime_gl_blend_func_separate") ) { lime_gl_blend_func_separate=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_attrib_location") ) { lime_gl_get_attrib_location=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_info_log") ) { lime_gl_get_shader_info_log=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_op_separate") ) { lime_gl_stencil_op_separate=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 28:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_attrib_location") ) { lime_gl_bind_attrib_location=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_create_render_buffer") ) { lime_gl_create_render_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_delete_render_buffer") ) { lime_gl_delete_render_buffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_program_info_log") ) { lime_gl_get_program_info_log=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_parameter") ) { lime_gl_get_shader_parameter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_uniform_location") ) { lime_gl_get_uniform_location=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_renderbuffer_storage") ) { lime_gl_renderbuffer_storage=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 29:
		if (HX_FIELD_EQ(inName,"lime_gl_copy_tex_sub_image_2d") ) { lime_gl_copy_tex_sub_image_2d=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_framebuffer_texture2D") ) { lime_gl_framebuffer_texture2D=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_buffer_paramerter") ) { lime_gl_get_buffer_paramerter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_program_parameter") ) { lime_gl_get_program_parameter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_func_separate") ) { lime_gl_stencil_func_separate=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_stencil_mask_separate") ) { lime_gl_stencil_mask_separate=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_vertex_attrib_pointer") ) { lime_gl_vertex_attrib_pointer=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 30:
		if (HX_FIELD_EQ(inName,"lime_gl_get_context_attributes") ) { lime_gl_get_context_attributes=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 31:
		if (HX_FIELD_EQ(inName,"lime_gl_blend_equation_separate") ) { lime_gl_blend_equation_separate=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_compressed_tex_image_2d") ) { lime_gl_compressed_tex_image_2d=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 32:
		if (HX_FIELD_EQ(inName,"lime_gl_bind_bitmap_data_texture") ) { lime_gl_bind_bitmap_data_texture=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_check_framebuffer_status") ) { lime_gl_check_framebuffer_status=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_framebuffer_renderbuffer") ) { lime_gl_framebuffer_renderbuffer=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_supported_extensions") ) { lime_gl_get_supported_extensions=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_vertex_attrib_offset") ) { lime_gl_get_vertex_attrib_offset=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 34:
		if (HX_FIELD_EQ(inName,"lime_gl_enable_vertex_attrib_array") ) { lime_gl_enable_vertex_attrib_array=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 35:
		if (HX_FIELD_EQ(inName,"lime_gl_compressed_tex_sub_image_2d") ) { lime_gl_compressed_tex_sub_image_2d=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_disable_vertex_attrib_array") ) { lime_gl_disable_vertex_attrib_array=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_render_buffer_parameter") ) { lime_gl_get_render_buffer_parameter=inValue.Cast< Dynamic >(); return inValue; }
		if (HX_FIELD_EQ(inName,"lime_gl_get_shader_precision_format") ) { lime_gl_get_shader_precision_format=inValue.Cast< Dynamic >(); return inValue; }
		break;
	case 44:
		if (HX_FIELD_EQ(inName,"lime_gl_get_framebuffer_attachment_parameter") ) { lime_gl_get_framebuffer_attachment_parameter=inValue.Cast< Dynamic >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GL_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("DEPTH_BUFFER_BIT"),
	HX_CSTRING("STENCIL_BUFFER_BIT"),
	HX_CSTRING("COLOR_BUFFER_BIT"),
	HX_CSTRING("POINTS"),
	HX_CSTRING("LINES"),
	HX_CSTRING("LINE_LOOP"),
	HX_CSTRING("LINE_STRIP"),
	HX_CSTRING("TRIANGLES"),
	HX_CSTRING("TRIANGLE_STRIP"),
	HX_CSTRING("TRIANGLE_FAN"),
	HX_CSTRING("ZERO"),
	HX_CSTRING("ONE"),
	HX_CSTRING("SRC_COLOR"),
	HX_CSTRING("ONE_MINUS_SRC_COLOR"),
	HX_CSTRING("SRC_ALPHA"),
	HX_CSTRING("ONE_MINUS_SRC_ALPHA"),
	HX_CSTRING("DST_ALPHA"),
	HX_CSTRING("ONE_MINUS_DST_ALPHA"),
	HX_CSTRING("DST_COLOR"),
	HX_CSTRING("ONE_MINUS_DST_COLOR"),
	HX_CSTRING("SRC_ALPHA_SATURATE"),
	HX_CSTRING("FUNC_ADD"),
	HX_CSTRING("BLEND_EQUATION"),
	HX_CSTRING("BLEND_EQUATION_RGB"),
	HX_CSTRING("BLEND_EQUATION_ALPHA"),
	HX_CSTRING("FUNC_SUBTRACT"),
	HX_CSTRING("FUNC_REVERSE_SUBTRACT"),
	HX_CSTRING("BLEND_DST_RGB"),
	HX_CSTRING("BLEND_SRC_RGB"),
	HX_CSTRING("BLEND_DST_ALPHA"),
	HX_CSTRING("BLEND_SRC_ALPHA"),
	HX_CSTRING("CONSTANT_COLOR"),
	HX_CSTRING("ONE_MINUS_CONSTANT_COLOR"),
	HX_CSTRING("CONSTANT_ALPHA"),
	HX_CSTRING("ONE_MINUS_CONSTANT_ALPHA"),
	HX_CSTRING("BLEND_COLOR"),
	HX_CSTRING("ARRAY_BUFFER"),
	HX_CSTRING("ELEMENT_ARRAY_BUFFER"),
	HX_CSTRING("ARRAY_BUFFER_BINDING"),
	HX_CSTRING("ELEMENT_ARRAY_BUFFER_BINDING"),
	HX_CSTRING("STREAM_DRAW"),
	HX_CSTRING("STATIC_DRAW"),
	HX_CSTRING("DYNAMIC_DRAW"),
	HX_CSTRING("BUFFER_SIZE"),
	HX_CSTRING("BUFFER_USAGE"),
	HX_CSTRING("CURRENT_VERTEX_ATTRIB"),
	HX_CSTRING("FRONT"),
	HX_CSTRING("BACK"),
	HX_CSTRING("FRONT_AND_BACK"),
	HX_CSTRING("CULL_FACE"),
	HX_CSTRING("BLEND"),
	HX_CSTRING("DITHER"),
	HX_CSTRING("STENCIL_TEST"),
	HX_CSTRING("DEPTH_TEST"),
	HX_CSTRING("SCISSOR_TEST"),
	HX_CSTRING("POLYGON_OFFSET_FILL"),
	HX_CSTRING("SAMPLE_ALPHA_TO_COVERAGE"),
	HX_CSTRING("SAMPLE_COVERAGE"),
	HX_CSTRING("NO_ERROR"),
	HX_CSTRING("INVALID_ENUM"),
	HX_CSTRING("INVALID_VALUE"),
	HX_CSTRING("INVALID_OPERATION"),
	HX_CSTRING("OUT_OF_MEMORY"),
	HX_CSTRING("CW"),
	HX_CSTRING("CCW"),
	HX_CSTRING("LINE_WIDTH"),
	HX_CSTRING("ALIASED_POINT_SIZE_RANGE"),
	HX_CSTRING("ALIASED_LINE_WIDTH_RANGE"),
	HX_CSTRING("CULL_FACE_MODE"),
	HX_CSTRING("FRONT_FACE"),
	HX_CSTRING("DEPTH_RANGE"),
	HX_CSTRING("DEPTH_WRITEMASK"),
	HX_CSTRING("DEPTH_CLEAR_VALUE"),
	HX_CSTRING("DEPTH_FUNC"),
	HX_CSTRING("STENCIL_CLEAR_VALUE"),
	HX_CSTRING("STENCIL_FUNC"),
	HX_CSTRING("STENCIL_FAIL"),
	HX_CSTRING("STENCIL_PASS_DEPTH_FAIL"),
	HX_CSTRING("STENCIL_PASS_DEPTH_PASS"),
	HX_CSTRING("STENCIL_REF"),
	HX_CSTRING("STENCIL_VALUE_MASK"),
	HX_CSTRING("STENCIL_WRITEMASK"),
	HX_CSTRING("STENCIL_BACK_FUNC"),
	HX_CSTRING("STENCIL_BACK_FAIL"),
	HX_CSTRING("STENCIL_BACK_PASS_DEPTH_FAIL"),
	HX_CSTRING("STENCIL_BACK_PASS_DEPTH_PASS"),
	HX_CSTRING("STENCIL_BACK_REF"),
	HX_CSTRING("STENCIL_BACK_VALUE_MASK"),
	HX_CSTRING("STENCIL_BACK_WRITEMASK"),
	HX_CSTRING("VIEWPORT"),
	HX_CSTRING("SCISSOR_BOX"),
	HX_CSTRING("COLOR_CLEAR_VALUE"),
	HX_CSTRING("COLOR_WRITEMASK"),
	HX_CSTRING("UNPACK_ALIGNMENT"),
	HX_CSTRING("PACK_ALIGNMENT"),
	HX_CSTRING("MAX_TEXTURE_SIZE"),
	HX_CSTRING("MAX_VIEWPORT_DIMS"),
	HX_CSTRING("SUBPIXEL_BITS"),
	HX_CSTRING("RED_BITS"),
	HX_CSTRING("GREEN_BITS"),
	HX_CSTRING("BLUE_BITS"),
	HX_CSTRING("ALPHA_BITS"),
	HX_CSTRING("DEPTH_BITS"),
	HX_CSTRING("STENCIL_BITS"),
	HX_CSTRING("POLYGON_OFFSET_UNITS"),
	HX_CSTRING("POLYGON_OFFSET_FACTOR"),
	HX_CSTRING("TEXTURE_BINDING_2D"),
	HX_CSTRING("SAMPLE_BUFFERS"),
	HX_CSTRING("SAMPLES"),
	HX_CSTRING("SAMPLE_COVERAGE_VALUE"),
	HX_CSTRING("SAMPLE_COVERAGE_INVERT"),
	HX_CSTRING("COMPRESSED_TEXTURE_FORMATS"),
	HX_CSTRING("DONT_CARE"),
	HX_CSTRING("FASTEST"),
	HX_CSTRING("NICEST"),
	HX_CSTRING("GENERATE_MIPMAP_HINT"),
	HX_CSTRING("BYTE"),
	HX_CSTRING("UNSIGNED_BYTE"),
	HX_CSTRING("SHORT"),
	HX_CSTRING("UNSIGNED_SHORT"),
	HX_CSTRING("INT"),
	HX_CSTRING("UNSIGNED_INT"),
	HX_CSTRING("FLOAT"),
	HX_CSTRING("DEPTH_COMPONENT"),
	HX_CSTRING("ALPHA"),
	HX_CSTRING("RGB"),
	HX_CSTRING("RGBA"),
	HX_CSTRING("LUMINANCE"),
	HX_CSTRING("LUMINANCE_ALPHA"),
	HX_CSTRING("UNSIGNED_SHORT_4_4_4_4"),
	HX_CSTRING("UNSIGNED_SHORT_5_5_5_1"),
	HX_CSTRING("UNSIGNED_SHORT_5_6_5"),
	HX_CSTRING("FRAGMENT_SHADER"),
	HX_CSTRING("VERTEX_SHADER"),
	HX_CSTRING("MAX_VERTEX_ATTRIBS"),
	HX_CSTRING("MAX_VERTEX_UNIFORM_VECTORS"),
	HX_CSTRING("MAX_VARYING_VECTORS"),
	HX_CSTRING("MAX_COMBINED_TEXTURE_IMAGE_UNITS"),
	HX_CSTRING("MAX_VERTEX_TEXTURE_IMAGE_UNITS"),
	HX_CSTRING("MAX_TEXTURE_IMAGE_UNITS"),
	HX_CSTRING("MAX_FRAGMENT_UNIFORM_VECTORS"),
	HX_CSTRING("SHADER_TYPE"),
	HX_CSTRING("DELETE_STATUS"),
	HX_CSTRING("LINK_STATUS"),
	HX_CSTRING("VALIDATE_STATUS"),
	HX_CSTRING("ATTACHED_SHADERS"),
	HX_CSTRING("ACTIVE_UNIFORMS"),
	HX_CSTRING("ACTIVE_ATTRIBUTES"),
	HX_CSTRING("SHADING_LANGUAGE_VERSION"),
	HX_CSTRING("CURRENT_PROGRAM"),
	HX_CSTRING("NEVER"),
	HX_CSTRING("LESS"),
	HX_CSTRING("EQUAL"),
	HX_CSTRING("LEQUAL"),
	HX_CSTRING("GREATER"),
	HX_CSTRING("NOTEQUAL"),
	HX_CSTRING("GEQUAL"),
	HX_CSTRING("ALWAYS"),
	HX_CSTRING("KEEP"),
	HX_CSTRING("REPLACE"),
	HX_CSTRING("INCR"),
	HX_CSTRING("DECR"),
	HX_CSTRING("INVERT"),
	HX_CSTRING("INCR_WRAP"),
	HX_CSTRING("DECR_WRAP"),
	HX_CSTRING("VENDOR"),
	HX_CSTRING("RENDERER"),
	HX_CSTRING("VERSION"),
	HX_CSTRING("NEAREST"),
	HX_CSTRING("LINEAR"),
	HX_CSTRING("NEAREST_MIPMAP_NEAREST"),
	HX_CSTRING("LINEAR_MIPMAP_NEAREST"),
	HX_CSTRING("NEAREST_MIPMAP_LINEAR"),
	HX_CSTRING("LINEAR_MIPMAP_LINEAR"),
	HX_CSTRING("TEXTURE_MAG_FILTER"),
	HX_CSTRING("TEXTURE_MIN_FILTER"),
	HX_CSTRING("TEXTURE_WRAP_S"),
	HX_CSTRING("TEXTURE_WRAP_T"),
	HX_CSTRING("TEXTURE_2D"),
	HX_CSTRING("TEXTURE"),
	HX_CSTRING("TEXTURE_CUBE_MAP"),
	HX_CSTRING("TEXTURE_BINDING_CUBE_MAP"),
	HX_CSTRING("TEXTURE_CUBE_MAP_POSITIVE_X"),
	HX_CSTRING("TEXTURE_CUBE_MAP_NEGATIVE_X"),
	HX_CSTRING("TEXTURE_CUBE_MAP_POSITIVE_Y"),
	HX_CSTRING("TEXTURE_CUBE_MAP_NEGATIVE_Y"),
	HX_CSTRING("TEXTURE_CUBE_MAP_POSITIVE_Z"),
	HX_CSTRING("TEXTURE_CUBE_MAP_NEGATIVE_Z"),
	HX_CSTRING("MAX_CUBE_MAP_TEXTURE_SIZE"),
	HX_CSTRING("TEXTURE0"),
	HX_CSTRING("TEXTURE1"),
	HX_CSTRING("TEXTURE2"),
	HX_CSTRING("TEXTURE3"),
	HX_CSTRING("TEXTURE4"),
	HX_CSTRING("TEXTURE5"),
	HX_CSTRING("TEXTURE6"),
	HX_CSTRING("TEXTURE7"),
	HX_CSTRING("TEXTURE8"),
	HX_CSTRING("TEXTURE9"),
	HX_CSTRING("TEXTURE10"),
	HX_CSTRING("TEXTURE11"),
	HX_CSTRING("TEXTURE12"),
	HX_CSTRING("TEXTURE13"),
	HX_CSTRING("TEXTURE14"),
	HX_CSTRING("TEXTURE15"),
	HX_CSTRING("TEXTURE16"),
	HX_CSTRING("TEXTURE17"),
	HX_CSTRING("TEXTURE18"),
	HX_CSTRING("TEXTURE19"),
	HX_CSTRING("TEXTURE20"),
	HX_CSTRING("TEXTURE21"),
	HX_CSTRING("TEXTURE22"),
	HX_CSTRING("TEXTURE23"),
	HX_CSTRING("TEXTURE24"),
	HX_CSTRING("TEXTURE25"),
	HX_CSTRING("TEXTURE26"),
	HX_CSTRING("TEXTURE27"),
	HX_CSTRING("TEXTURE28"),
	HX_CSTRING("TEXTURE29"),
	HX_CSTRING("TEXTURE30"),
	HX_CSTRING("TEXTURE31"),
	HX_CSTRING("ACTIVE_TEXTURE"),
	HX_CSTRING("REPEAT"),
	HX_CSTRING("CLAMP_TO_EDGE"),
	HX_CSTRING("MIRRORED_REPEAT"),
	HX_CSTRING("FLOAT_VEC2"),
	HX_CSTRING("FLOAT_VEC3"),
	HX_CSTRING("FLOAT_VEC4"),
	HX_CSTRING("INT_VEC2"),
	HX_CSTRING("INT_VEC3"),
	HX_CSTRING("INT_VEC4"),
	HX_CSTRING("BOOL"),
	HX_CSTRING("BOOL_VEC2"),
	HX_CSTRING("BOOL_VEC3"),
	HX_CSTRING("BOOL_VEC4"),
	HX_CSTRING("FLOAT_MAT2"),
	HX_CSTRING("FLOAT_MAT3"),
	HX_CSTRING("FLOAT_MAT4"),
	HX_CSTRING("SAMPLER_2D"),
	HX_CSTRING("SAMPLER_CUBE"),
	HX_CSTRING("VERTEX_ATTRIB_ARRAY_ENABLED"),
	HX_CSTRING("VERTEX_ATTRIB_ARRAY_SIZE"),
	HX_CSTRING("VERTEX_ATTRIB_ARRAY_STRIDE"),
	HX_CSTRING("VERTEX_ATTRIB_ARRAY_TYPE"),
	HX_CSTRING("VERTEX_ATTRIB_ARRAY_NORMALIZED"),
	HX_CSTRING("VERTEX_ATTRIB_ARRAY_POINTER"),
	HX_CSTRING("VERTEX_ATTRIB_ARRAY_BUFFER_BINDING"),
	HX_CSTRING("VERTEX_PROGRAM_POINT_SIZE"),
	HX_CSTRING("POINT_SPRITE"),
	HX_CSTRING("COMPILE_STATUS"),
	HX_CSTRING("LOW_FLOAT"),
	HX_CSTRING("MEDIUM_FLOAT"),
	HX_CSTRING("HIGH_FLOAT"),
	HX_CSTRING("LOW_INT"),
	HX_CSTRING("MEDIUM_INT"),
	HX_CSTRING("HIGH_INT"),
	HX_CSTRING("FRAMEBUFFER"),
	HX_CSTRING("RENDERBUFFER"),
	HX_CSTRING("RGBA4"),
	HX_CSTRING("RGB5_A1"),
	HX_CSTRING("RGB565"),
	HX_CSTRING("DEPTH_COMPONENT16"),
	HX_CSTRING("STENCIL_INDEX"),
	HX_CSTRING("STENCIL_INDEX8"),
	HX_CSTRING("DEPTH_STENCIL"),
	HX_CSTRING("RENDERBUFFER_WIDTH"),
	HX_CSTRING("RENDERBUFFER_HEIGHT"),
	HX_CSTRING("RENDERBUFFER_INTERNAL_FORMAT"),
	HX_CSTRING("RENDERBUFFER_RED_SIZE"),
	HX_CSTRING("RENDERBUFFER_GREEN_SIZE"),
	HX_CSTRING("RENDERBUFFER_BLUE_SIZE"),
	HX_CSTRING("RENDERBUFFER_ALPHA_SIZE"),
	HX_CSTRING("RENDERBUFFER_DEPTH_SIZE"),
	HX_CSTRING("RENDERBUFFER_STENCIL_SIZE"),
	HX_CSTRING("FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE"),
	HX_CSTRING("FRAMEBUFFER_ATTACHMENT_OBJECT_NAME"),
	HX_CSTRING("FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL"),
	HX_CSTRING("FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE"),
	HX_CSTRING("COLOR_ATTACHMENT0"),
	HX_CSTRING("DEPTH_ATTACHMENT"),
	HX_CSTRING("STENCIL_ATTACHMENT"),
	HX_CSTRING("DEPTH_STENCIL_ATTACHMENT"),
	HX_CSTRING("NONE"),
	HX_CSTRING("FRAMEBUFFER_COMPLETE"),
	HX_CSTRING("FRAMEBUFFER_INCOMPLETE_ATTACHMENT"),
	HX_CSTRING("FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT"),
	HX_CSTRING("FRAMEBUFFER_INCOMPLETE_DIMENSIONS"),
	HX_CSTRING("FRAMEBUFFER_UNSUPPORTED"),
	HX_CSTRING("FRAMEBUFFER_BINDING"),
	HX_CSTRING("RENDERBUFFER_BINDING"),
	HX_CSTRING("MAX_RENDERBUFFER_SIZE"),
	HX_CSTRING("INVALID_FRAMEBUFFER_OPERATION"),
	HX_CSTRING("UNPACK_FLIP_Y_WEBGL"),
	HX_CSTRING("UNPACK_PREMULTIPLY_ALPHA_WEBGL"),
	HX_CSTRING("CONTEXT_LOST_WEBGL"),
	HX_CSTRING("UNPACK_COLORSPACE_CONVERSION_WEBGL"),
	HX_CSTRING("BROWSER_DEFAULT_WEBGL"),
	HX_CSTRING("drawingBufferHeight"),
	HX_CSTRING("drawingBufferWidth"),
	HX_CSTRING("version"),
	HX_CSTRING("activeTexture"),
	HX_CSTRING("attachShader"),
	HX_CSTRING("bindAttribLocation"),
	HX_CSTRING("bindBitmapDataTexture"),
	HX_CSTRING("bindBuffer"),
	HX_CSTRING("bindFramebuffer"),
	HX_CSTRING("bindRenderbuffer"),
	HX_CSTRING("bindTexture"),
	HX_CSTRING("blendColor"),
	HX_CSTRING("blendEquation"),
	HX_CSTRING("blendEquationSeparate"),
	HX_CSTRING("blendFunc"),
	HX_CSTRING("blendFuncSeparate"),
	HX_CSTRING("bufferData"),
	HX_CSTRING("bufferSubData"),
	HX_CSTRING("checkFramebufferStatus"),
	HX_CSTRING("clear"),
	HX_CSTRING("clearColor"),
	HX_CSTRING("clearDepth"),
	HX_CSTRING("clearStencil"),
	HX_CSTRING("colorMask"),
	HX_CSTRING("compileShader"),
	HX_CSTRING("compressedTexImage2D"),
	HX_CSTRING("compressedTexSubImage2D"),
	HX_CSTRING("copyTexImage2D"),
	HX_CSTRING("copyTexSubImage2D"),
	HX_CSTRING("createBuffer"),
	HX_CSTRING("createFramebuffer"),
	HX_CSTRING("createProgram"),
	HX_CSTRING("createRenderbuffer"),
	HX_CSTRING("createShader"),
	HX_CSTRING("createTexture"),
	HX_CSTRING("cullFace"),
	HX_CSTRING("deleteBuffer"),
	HX_CSTRING("deleteFramebuffer"),
	HX_CSTRING("deleteProgram"),
	HX_CSTRING("deleteRenderbuffer"),
	HX_CSTRING("deleteShader"),
	HX_CSTRING("deleteTexture"),
	HX_CSTRING("depthFunc"),
	HX_CSTRING("depthMask"),
	HX_CSTRING("depthRange"),
	HX_CSTRING("detachShader"),
	HX_CSTRING("disable"),
	HX_CSTRING("disableVertexAttribArray"),
	HX_CSTRING("drawArrays"),
	HX_CSTRING("drawElements"),
	HX_CSTRING("enable"),
	HX_CSTRING("enableVertexAttribArray"),
	HX_CSTRING("finish"),
	HX_CSTRING("flush"),
	HX_CSTRING("framebufferRenderbuffer"),
	HX_CSTRING("framebufferTexture2D"),
	HX_CSTRING("frontFace"),
	HX_CSTRING("generateMipmap"),
	HX_CSTRING("getActiveAttrib"),
	HX_CSTRING("getActiveUniform"),
	HX_CSTRING("getAttachedShaders"),
	HX_CSTRING("getAttribLocation"),
	HX_CSTRING("getBufferParameter"),
	HX_CSTRING("getContextAttributes"),
	HX_CSTRING("getError"),
	HX_CSTRING("getExtension"),
	HX_CSTRING("getFramebufferAttachmentParameter"),
	HX_CSTRING("getParameter"),
	HX_CSTRING("getProgramInfoLog"),
	HX_CSTRING("getProgramParameter"),
	HX_CSTRING("getRenderbufferParameter"),
	HX_CSTRING("getShaderInfoLog"),
	HX_CSTRING("getShaderParameter"),
	HX_CSTRING("getShaderPrecisionFormat"),
	HX_CSTRING("getShaderSource"),
	HX_CSTRING("getSupportedExtensions"),
	HX_CSTRING("getTexParameter"),
	HX_CSTRING("getUniform"),
	HX_CSTRING("getUniformLocation"),
	HX_CSTRING("getVertexAttrib"),
	HX_CSTRING("getVertexAttribOffset"),
	HX_CSTRING("hint"),
	HX_CSTRING("isBuffer"),
	HX_CSTRING("isEnabled"),
	HX_CSTRING("isFramebuffer"),
	HX_CSTRING("isProgram"),
	HX_CSTRING("isRenderbuffer"),
	HX_CSTRING("isShader"),
	HX_CSTRING("isTexture"),
	HX_CSTRING("lineWidth"),
	HX_CSTRING("linkProgram"),
	HX_CSTRING("load"),
	HX_CSTRING("pixelStorei"),
	HX_CSTRING("polygonOffset"),
	HX_CSTRING("readPixels"),
	HX_CSTRING("renderbufferStorage"),
	HX_CSTRING("sampleCoverage"),
	HX_CSTRING("scissor"),
	HX_CSTRING("shaderSource"),
	HX_CSTRING("stencilFunc"),
	HX_CSTRING("stencilFuncSeparate"),
	HX_CSTRING("stencilMask"),
	HX_CSTRING("stencilMaskSeparate"),
	HX_CSTRING("stencilOp"),
	HX_CSTRING("stencilOpSeparate"),
	HX_CSTRING("texImage2D"),
	HX_CSTRING("texParameterf"),
	HX_CSTRING("texParameteri"),
	HX_CSTRING("texSubImage2D"),
	HX_CSTRING("uniform1f"),
	HX_CSTRING("uniform1fv"),
	HX_CSTRING("uniform1i"),
	HX_CSTRING("uniform1iv"),
	HX_CSTRING("uniform2f"),
	HX_CSTRING("uniform2fv"),
	HX_CSTRING("uniform2i"),
	HX_CSTRING("uniform2iv"),
	HX_CSTRING("uniform3f"),
	HX_CSTRING("uniform3fv"),
	HX_CSTRING("uniform3i"),
	HX_CSTRING("uniform3iv"),
	HX_CSTRING("uniform4f"),
	HX_CSTRING("uniform4fv"),
	HX_CSTRING("uniform4i"),
	HX_CSTRING("uniform4iv"),
	HX_CSTRING("uniformMatrix2fv"),
	HX_CSTRING("uniformMatrix3fv"),
	HX_CSTRING("uniformMatrix4fv"),
	HX_CSTRING("uniformMatrix3D"),
	HX_CSTRING("useProgram"),
	HX_CSTRING("validateProgram"),
	HX_CSTRING("vertexAttrib1f"),
	HX_CSTRING("vertexAttrib1fv"),
	HX_CSTRING("vertexAttrib2f"),
	HX_CSTRING("vertexAttrib2fv"),
	HX_CSTRING("vertexAttrib3f"),
	HX_CSTRING("vertexAttrib3fv"),
	HX_CSTRING("vertexAttrib4f"),
	HX_CSTRING("vertexAttrib4fv"),
	HX_CSTRING("vertexAttribPointer"),
	HX_CSTRING("viewport"),
	HX_CSTRING("get_drawingBufferHeight"),
	HX_CSTRING("get_drawingBufferWidth"),
	HX_CSTRING("get_version"),
	HX_CSTRING("lime_gl_active_texture"),
	HX_CSTRING("lime_gl_attach_shader"),
	HX_CSTRING("lime_gl_bind_attrib_location"),
	HX_CSTRING("lime_gl_bind_bitmap_data_texture"),
	HX_CSTRING("lime_gl_bind_buffer"),
	HX_CSTRING("lime_gl_bind_framebuffer"),
	HX_CSTRING("lime_gl_bind_renderbuffer"),
	HX_CSTRING("lime_gl_bind_texture"),
	HX_CSTRING("lime_gl_blend_color"),
	HX_CSTRING("lime_gl_blend_equation"),
	HX_CSTRING("lime_gl_blend_equation_separate"),
	HX_CSTRING("lime_gl_blend_func"),
	HX_CSTRING("lime_gl_blend_func_separate"),
	HX_CSTRING("lime_gl_buffer_data"),
	HX_CSTRING("lime_gl_buffer_sub_data"),
	HX_CSTRING("lime_gl_check_framebuffer_status"),
	HX_CSTRING("lime_gl_clear"),
	HX_CSTRING("lime_gl_clear_color"),
	HX_CSTRING("lime_gl_clear_depth"),
	HX_CSTRING("lime_gl_clear_stencil"),
	HX_CSTRING("lime_gl_color_mask"),
	HX_CSTRING("lime_gl_compile_shader"),
	HX_CSTRING("lime_gl_compressed_tex_image_2d"),
	HX_CSTRING("lime_gl_compressed_tex_sub_image_2d"),
	HX_CSTRING("lime_gl_copy_tex_image_2d"),
	HX_CSTRING("lime_gl_copy_tex_sub_image_2d"),
	HX_CSTRING("lime_gl_create_buffer"),
	HX_CSTRING("lime_gl_create_framebuffer"),
	HX_CSTRING("lime_gl_create_program"),
	HX_CSTRING("lime_gl_create_render_buffer"),
	HX_CSTRING("lime_gl_create_shader"),
	HX_CSTRING("lime_gl_create_texture"),
	HX_CSTRING("lime_gl_cull_face"),
	HX_CSTRING("lime_gl_delete_buffer"),
	HX_CSTRING("lime_gl_delete_framebuffer"),
	HX_CSTRING("lime_gl_delete_program"),
	HX_CSTRING("lime_gl_delete_render_buffer"),
	HX_CSTRING("lime_gl_delete_shader"),
	HX_CSTRING("lime_gl_delete_texture"),
	HX_CSTRING("lime_gl_depth_func"),
	HX_CSTRING("lime_gl_depth_mask"),
	HX_CSTRING("lime_gl_depth_range"),
	HX_CSTRING("lime_gl_detach_shader"),
	HX_CSTRING("lime_gl_disable"),
	HX_CSTRING("lime_gl_disable_vertex_attrib_array"),
	HX_CSTRING("lime_gl_draw_arrays"),
	HX_CSTRING("lime_gl_draw_elements"),
	HX_CSTRING("lime_gl_enable"),
	HX_CSTRING("lime_gl_enable_vertex_attrib_array"),
	HX_CSTRING("lime_gl_finish"),
	HX_CSTRING("lime_gl_flush"),
	HX_CSTRING("lime_gl_framebuffer_renderbuffer"),
	HX_CSTRING("lime_gl_framebuffer_texture2D"),
	HX_CSTRING("lime_gl_front_face"),
	HX_CSTRING("lime_gl_generate_mipmap"),
	HX_CSTRING("lime_gl_get_active_attrib"),
	HX_CSTRING("lime_gl_get_active_uniform"),
	HX_CSTRING("lime_gl_get_attrib_location"),
	HX_CSTRING("lime_gl_get_buffer_paramerter"),
	HX_CSTRING("lime_gl_get_context_attributes"),
	HX_CSTRING("lime_gl_get_error"),
	HX_CSTRING("lime_gl_get_framebuffer_attachment_parameter"),
	HX_CSTRING("lime_gl_get_parameter"),
	HX_CSTRING("lime_gl_get_program_info_log"),
	HX_CSTRING("lime_gl_get_program_parameter"),
	HX_CSTRING("lime_gl_get_render_buffer_parameter"),
	HX_CSTRING("lime_gl_get_shader_info_log"),
	HX_CSTRING("lime_gl_get_shader_parameter"),
	HX_CSTRING("lime_gl_get_shader_precision_format"),
	HX_CSTRING("lime_gl_get_shader_source"),
	HX_CSTRING("lime_gl_get_supported_extensions"),
	HX_CSTRING("lime_gl_get_tex_parameter"),
	HX_CSTRING("lime_gl_get_uniform"),
	HX_CSTRING("lime_gl_get_uniform_location"),
	HX_CSTRING("lime_gl_get_vertex_attrib"),
	HX_CSTRING("lime_gl_get_vertex_attrib_offset"),
	HX_CSTRING("lime_gl_hint"),
	HX_CSTRING("lime_gl_is_buffer"),
	HX_CSTRING("lime_gl_is_enabled"),
	HX_CSTRING("lime_gl_is_framebuffer"),
	HX_CSTRING("lime_gl_is_program"),
	HX_CSTRING("lime_gl_is_renderbuffer"),
	HX_CSTRING("lime_gl_is_shader"),
	HX_CSTRING("lime_gl_is_texture"),
	HX_CSTRING("lime_gl_line_width"),
	HX_CSTRING("lime_gl_link_program"),
	HX_CSTRING("lime_gl_pixel_storei"),
	HX_CSTRING("lime_gl_polygon_offset"),
	HX_CSTRING("lime_gl_read_pixels"),
	HX_CSTRING("lime_gl_renderbuffer_storage"),
	HX_CSTRING("lime_gl_sample_coverage"),
	HX_CSTRING("lime_gl_scissor"),
	HX_CSTRING("lime_gl_shader_source"),
	HX_CSTRING("lime_gl_stencil_func"),
	HX_CSTRING("lime_gl_stencil_func_separate"),
	HX_CSTRING("lime_gl_stencil_mask"),
	HX_CSTRING("lime_gl_stencil_mask_separate"),
	HX_CSTRING("lime_gl_stencil_op"),
	HX_CSTRING("lime_gl_stencil_op_separate"),
	HX_CSTRING("lime_gl_tex_image_2d"),
	HX_CSTRING("lime_gl_tex_parameterf"),
	HX_CSTRING("lime_gl_tex_parameteri"),
	HX_CSTRING("lime_gl_tex_sub_image_2d"),
	HX_CSTRING("lime_gl_uniform1f"),
	HX_CSTRING("lime_gl_uniform1fv"),
	HX_CSTRING("lime_gl_uniform1i"),
	HX_CSTRING("lime_gl_uniform1iv"),
	HX_CSTRING("lime_gl_uniform2f"),
	HX_CSTRING("lime_gl_uniform2fv"),
	HX_CSTRING("lime_gl_uniform2i"),
	HX_CSTRING("lime_gl_uniform2iv"),
	HX_CSTRING("lime_gl_uniform3f"),
	HX_CSTRING("lime_gl_uniform3fv"),
	HX_CSTRING("lime_gl_uniform3i"),
	HX_CSTRING("lime_gl_uniform3iv"),
	HX_CSTRING("lime_gl_uniform4f"),
	HX_CSTRING("lime_gl_uniform4fv"),
	HX_CSTRING("lime_gl_uniform4i"),
	HX_CSTRING("lime_gl_uniform4iv"),
	HX_CSTRING("lime_gl_uniform_matrix"),
	HX_CSTRING("lime_gl_use_program"),
	HX_CSTRING("lime_gl_validate_program"),
	HX_CSTRING("lime_gl_version"),
	HX_CSTRING("lime_gl_vertex_attrib1f"),
	HX_CSTRING("lime_gl_vertex_attrib1fv"),
	HX_CSTRING("lime_gl_vertex_attrib2f"),
	HX_CSTRING("lime_gl_vertex_attrib2fv"),
	HX_CSTRING("lime_gl_vertex_attrib3f"),
	HX_CSTRING("lime_gl_vertex_attrib3fv"),
	HX_CSTRING("lime_gl_vertex_attrib4f"),
	HX_CSTRING("lime_gl_vertex_attrib4fv"),
	HX_CSTRING("lime_gl_vertex_attrib_pointer"),
	HX_CSTRING("lime_gl_viewport"),
	String(null()) };

#if HXCPP_SCRIPTABLE
static hx::StorageInfo *sMemberStorageInfo = 0;
#endif

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(GL_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_BUFFER_BIT,"DEPTH_BUFFER_BIT");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BUFFER_BIT,"STENCIL_BUFFER_BIT");
	HX_MARK_MEMBER_NAME(GL_obj::COLOR_BUFFER_BIT,"COLOR_BUFFER_BIT");
	HX_MARK_MEMBER_NAME(GL_obj::POINTS,"POINTS");
	HX_MARK_MEMBER_NAME(GL_obj::LINES,"LINES");
	HX_MARK_MEMBER_NAME(GL_obj::LINE_LOOP,"LINE_LOOP");
	HX_MARK_MEMBER_NAME(GL_obj::LINE_STRIP,"LINE_STRIP");
	HX_MARK_MEMBER_NAME(GL_obj::TRIANGLES,"TRIANGLES");
	HX_MARK_MEMBER_NAME(GL_obj::TRIANGLE_STRIP,"TRIANGLE_STRIP");
	HX_MARK_MEMBER_NAME(GL_obj::TRIANGLE_FAN,"TRIANGLE_FAN");
	HX_MARK_MEMBER_NAME(GL_obj::ZERO,"ZERO");
	HX_MARK_MEMBER_NAME(GL_obj::ONE,"ONE");
	HX_MARK_MEMBER_NAME(GL_obj::SRC_COLOR,"SRC_COLOR");
	HX_MARK_MEMBER_NAME(GL_obj::ONE_MINUS_SRC_COLOR,"ONE_MINUS_SRC_COLOR");
	HX_MARK_MEMBER_NAME(GL_obj::SRC_ALPHA,"SRC_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::ONE_MINUS_SRC_ALPHA,"ONE_MINUS_SRC_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::DST_ALPHA,"DST_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::ONE_MINUS_DST_ALPHA,"ONE_MINUS_DST_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::DST_COLOR,"DST_COLOR");
	HX_MARK_MEMBER_NAME(GL_obj::ONE_MINUS_DST_COLOR,"ONE_MINUS_DST_COLOR");
	HX_MARK_MEMBER_NAME(GL_obj::SRC_ALPHA_SATURATE,"SRC_ALPHA_SATURATE");
	HX_MARK_MEMBER_NAME(GL_obj::FUNC_ADD,"FUNC_ADD");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_EQUATION,"BLEND_EQUATION");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_EQUATION_RGB,"BLEND_EQUATION_RGB");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_EQUATION_ALPHA,"BLEND_EQUATION_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::FUNC_SUBTRACT,"FUNC_SUBTRACT");
	HX_MARK_MEMBER_NAME(GL_obj::FUNC_REVERSE_SUBTRACT,"FUNC_REVERSE_SUBTRACT");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_DST_RGB,"BLEND_DST_RGB");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_SRC_RGB,"BLEND_SRC_RGB");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_DST_ALPHA,"BLEND_DST_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_SRC_ALPHA,"BLEND_SRC_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::CONSTANT_COLOR,"CONSTANT_COLOR");
	HX_MARK_MEMBER_NAME(GL_obj::ONE_MINUS_CONSTANT_COLOR,"ONE_MINUS_CONSTANT_COLOR");
	HX_MARK_MEMBER_NAME(GL_obj::CONSTANT_ALPHA,"CONSTANT_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::ONE_MINUS_CONSTANT_ALPHA,"ONE_MINUS_CONSTANT_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND_COLOR,"BLEND_COLOR");
	HX_MARK_MEMBER_NAME(GL_obj::ARRAY_BUFFER,"ARRAY_BUFFER");
	HX_MARK_MEMBER_NAME(GL_obj::ELEMENT_ARRAY_BUFFER,"ELEMENT_ARRAY_BUFFER");
	HX_MARK_MEMBER_NAME(GL_obj::ARRAY_BUFFER_BINDING,"ARRAY_BUFFER_BINDING");
	HX_MARK_MEMBER_NAME(GL_obj::ELEMENT_ARRAY_BUFFER_BINDING,"ELEMENT_ARRAY_BUFFER_BINDING");
	HX_MARK_MEMBER_NAME(GL_obj::STREAM_DRAW,"STREAM_DRAW");
	HX_MARK_MEMBER_NAME(GL_obj::STATIC_DRAW,"STATIC_DRAW");
	HX_MARK_MEMBER_NAME(GL_obj::DYNAMIC_DRAW,"DYNAMIC_DRAW");
	HX_MARK_MEMBER_NAME(GL_obj::BUFFER_SIZE,"BUFFER_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::BUFFER_USAGE,"BUFFER_USAGE");
	HX_MARK_MEMBER_NAME(GL_obj::CURRENT_VERTEX_ATTRIB,"CURRENT_VERTEX_ATTRIB");
	HX_MARK_MEMBER_NAME(GL_obj::FRONT,"FRONT");
	HX_MARK_MEMBER_NAME(GL_obj::BACK,"BACK");
	HX_MARK_MEMBER_NAME(GL_obj::FRONT_AND_BACK,"FRONT_AND_BACK");
	HX_MARK_MEMBER_NAME(GL_obj::CULL_FACE,"CULL_FACE");
	HX_MARK_MEMBER_NAME(GL_obj::BLEND,"BLEND");
	HX_MARK_MEMBER_NAME(GL_obj::DITHER,"DITHER");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_TEST,"STENCIL_TEST");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_TEST,"DEPTH_TEST");
	HX_MARK_MEMBER_NAME(GL_obj::SCISSOR_TEST,"SCISSOR_TEST");
	HX_MARK_MEMBER_NAME(GL_obj::POLYGON_OFFSET_FILL,"POLYGON_OFFSET_FILL");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLE_ALPHA_TO_COVERAGE,"SAMPLE_ALPHA_TO_COVERAGE");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLE_COVERAGE,"SAMPLE_COVERAGE");
	HX_MARK_MEMBER_NAME(GL_obj::NO_ERROR,"NO_ERROR");
	HX_MARK_MEMBER_NAME(GL_obj::INVALID_ENUM,"INVALID_ENUM");
	HX_MARK_MEMBER_NAME(GL_obj::INVALID_VALUE,"INVALID_VALUE");
	HX_MARK_MEMBER_NAME(GL_obj::INVALID_OPERATION,"INVALID_OPERATION");
	HX_MARK_MEMBER_NAME(GL_obj::OUT_OF_MEMORY,"OUT_OF_MEMORY");
	HX_MARK_MEMBER_NAME(GL_obj::CW,"CW");
	HX_MARK_MEMBER_NAME(GL_obj::CCW,"CCW");
	HX_MARK_MEMBER_NAME(GL_obj::LINE_WIDTH,"LINE_WIDTH");
	HX_MARK_MEMBER_NAME(GL_obj::ALIASED_POINT_SIZE_RANGE,"ALIASED_POINT_SIZE_RANGE");
	HX_MARK_MEMBER_NAME(GL_obj::ALIASED_LINE_WIDTH_RANGE,"ALIASED_LINE_WIDTH_RANGE");
	HX_MARK_MEMBER_NAME(GL_obj::CULL_FACE_MODE,"CULL_FACE_MODE");
	HX_MARK_MEMBER_NAME(GL_obj::FRONT_FACE,"FRONT_FACE");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_RANGE,"DEPTH_RANGE");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_WRITEMASK,"DEPTH_WRITEMASK");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_CLEAR_VALUE,"DEPTH_CLEAR_VALUE");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_FUNC,"DEPTH_FUNC");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_CLEAR_VALUE,"STENCIL_CLEAR_VALUE");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_FUNC,"STENCIL_FUNC");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_FAIL,"STENCIL_FAIL");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_PASS_DEPTH_FAIL,"STENCIL_PASS_DEPTH_FAIL");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_PASS_DEPTH_PASS,"STENCIL_PASS_DEPTH_PASS");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_REF,"STENCIL_REF");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_VALUE_MASK,"STENCIL_VALUE_MASK");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_WRITEMASK,"STENCIL_WRITEMASK");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BACK_FUNC,"STENCIL_BACK_FUNC");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BACK_FAIL,"STENCIL_BACK_FAIL");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BACK_PASS_DEPTH_FAIL,"STENCIL_BACK_PASS_DEPTH_FAIL");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BACK_PASS_DEPTH_PASS,"STENCIL_BACK_PASS_DEPTH_PASS");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BACK_REF,"STENCIL_BACK_REF");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BACK_VALUE_MASK,"STENCIL_BACK_VALUE_MASK");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BACK_WRITEMASK,"STENCIL_BACK_WRITEMASK");
	HX_MARK_MEMBER_NAME(GL_obj::VIEWPORT,"VIEWPORT");
	HX_MARK_MEMBER_NAME(GL_obj::SCISSOR_BOX,"SCISSOR_BOX");
	HX_MARK_MEMBER_NAME(GL_obj::COLOR_CLEAR_VALUE,"COLOR_CLEAR_VALUE");
	HX_MARK_MEMBER_NAME(GL_obj::COLOR_WRITEMASK,"COLOR_WRITEMASK");
	HX_MARK_MEMBER_NAME(GL_obj::UNPACK_ALIGNMENT,"UNPACK_ALIGNMENT");
	HX_MARK_MEMBER_NAME(GL_obj::PACK_ALIGNMENT,"PACK_ALIGNMENT");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_TEXTURE_SIZE,"MAX_TEXTURE_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_VIEWPORT_DIMS,"MAX_VIEWPORT_DIMS");
	HX_MARK_MEMBER_NAME(GL_obj::SUBPIXEL_BITS,"SUBPIXEL_BITS");
	HX_MARK_MEMBER_NAME(GL_obj::RED_BITS,"RED_BITS");
	HX_MARK_MEMBER_NAME(GL_obj::GREEN_BITS,"GREEN_BITS");
	HX_MARK_MEMBER_NAME(GL_obj::BLUE_BITS,"BLUE_BITS");
	HX_MARK_MEMBER_NAME(GL_obj::ALPHA_BITS,"ALPHA_BITS");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_BITS,"DEPTH_BITS");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_BITS,"STENCIL_BITS");
	HX_MARK_MEMBER_NAME(GL_obj::POLYGON_OFFSET_UNITS,"POLYGON_OFFSET_UNITS");
	HX_MARK_MEMBER_NAME(GL_obj::POLYGON_OFFSET_FACTOR,"POLYGON_OFFSET_FACTOR");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_BINDING_2D,"TEXTURE_BINDING_2D");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLE_BUFFERS,"SAMPLE_BUFFERS");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLES,"SAMPLES");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLE_COVERAGE_VALUE,"SAMPLE_COVERAGE_VALUE");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLE_COVERAGE_INVERT,"SAMPLE_COVERAGE_INVERT");
	HX_MARK_MEMBER_NAME(GL_obj::COMPRESSED_TEXTURE_FORMATS,"COMPRESSED_TEXTURE_FORMATS");
	HX_MARK_MEMBER_NAME(GL_obj::DONT_CARE,"DONT_CARE");
	HX_MARK_MEMBER_NAME(GL_obj::FASTEST,"FASTEST");
	HX_MARK_MEMBER_NAME(GL_obj::NICEST,"NICEST");
	HX_MARK_MEMBER_NAME(GL_obj::GENERATE_MIPMAP_HINT,"GENERATE_MIPMAP_HINT");
	HX_MARK_MEMBER_NAME(GL_obj::BYTE,"BYTE");
	HX_MARK_MEMBER_NAME(GL_obj::UNSIGNED_BYTE,"UNSIGNED_BYTE");
	HX_MARK_MEMBER_NAME(GL_obj::SHORT,"SHORT");
	HX_MARK_MEMBER_NAME(GL_obj::UNSIGNED_SHORT,"UNSIGNED_SHORT");
	HX_MARK_MEMBER_NAME(GL_obj::INT,"INT");
	HX_MARK_MEMBER_NAME(GL_obj::UNSIGNED_INT,"UNSIGNED_INT");
	HX_MARK_MEMBER_NAME(GL_obj::FLOAT,"FLOAT");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_COMPONENT,"DEPTH_COMPONENT");
	HX_MARK_MEMBER_NAME(GL_obj::ALPHA,"ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::RGB,"RGB");
	HX_MARK_MEMBER_NAME(GL_obj::RGBA,"RGBA");
	HX_MARK_MEMBER_NAME(GL_obj::LUMINANCE,"LUMINANCE");
	HX_MARK_MEMBER_NAME(GL_obj::LUMINANCE_ALPHA,"LUMINANCE_ALPHA");
	HX_MARK_MEMBER_NAME(GL_obj::UNSIGNED_SHORT_4_4_4_4,"UNSIGNED_SHORT_4_4_4_4");
	HX_MARK_MEMBER_NAME(GL_obj::UNSIGNED_SHORT_5_5_5_1,"UNSIGNED_SHORT_5_5_5_1");
	HX_MARK_MEMBER_NAME(GL_obj::UNSIGNED_SHORT_5_6_5,"UNSIGNED_SHORT_5_6_5");
	HX_MARK_MEMBER_NAME(GL_obj::FRAGMENT_SHADER,"FRAGMENT_SHADER");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_SHADER,"VERTEX_SHADER");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_VERTEX_ATTRIBS,"MAX_VERTEX_ATTRIBS");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_VERTEX_UNIFORM_VECTORS,"MAX_VERTEX_UNIFORM_VECTORS");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_VARYING_VECTORS,"MAX_VARYING_VECTORS");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_COMBINED_TEXTURE_IMAGE_UNITS,"MAX_COMBINED_TEXTURE_IMAGE_UNITS");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_VERTEX_TEXTURE_IMAGE_UNITS,"MAX_VERTEX_TEXTURE_IMAGE_UNITS");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_TEXTURE_IMAGE_UNITS,"MAX_TEXTURE_IMAGE_UNITS");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_FRAGMENT_UNIFORM_VECTORS,"MAX_FRAGMENT_UNIFORM_VECTORS");
	HX_MARK_MEMBER_NAME(GL_obj::SHADER_TYPE,"SHADER_TYPE");
	HX_MARK_MEMBER_NAME(GL_obj::DELETE_STATUS,"DELETE_STATUS");
	HX_MARK_MEMBER_NAME(GL_obj::LINK_STATUS,"LINK_STATUS");
	HX_MARK_MEMBER_NAME(GL_obj::VALIDATE_STATUS,"VALIDATE_STATUS");
	HX_MARK_MEMBER_NAME(GL_obj::ATTACHED_SHADERS,"ATTACHED_SHADERS");
	HX_MARK_MEMBER_NAME(GL_obj::ACTIVE_UNIFORMS,"ACTIVE_UNIFORMS");
	HX_MARK_MEMBER_NAME(GL_obj::ACTIVE_ATTRIBUTES,"ACTIVE_ATTRIBUTES");
	HX_MARK_MEMBER_NAME(GL_obj::SHADING_LANGUAGE_VERSION,"SHADING_LANGUAGE_VERSION");
	HX_MARK_MEMBER_NAME(GL_obj::CURRENT_PROGRAM,"CURRENT_PROGRAM");
	HX_MARK_MEMBER_NAME(GL_obj::NEVER,"NEVER");
	HX_MARK_MEMBER_NAME(GL_obj::LESS,"LESS");
	HX_MARK_MEMBER_NAME(GL_obj::EQUAL,"EQUAL");
	HX_MARK_MEMBER_NAME(GL_obj::LEQUAL,"LEQUAL");
	HX_MARK_MEMBER_NAME(GL_obj::GREATER,"GREATER");
	HX_MARK_MEMBER_NAME(GL_obj::NOTEQUAL,"NOTEQUAL");
	HX_MARK_MEMBER_NAME(GL_obj::GEQUAL,"GEQUAL");
	HX_MARK_MEMBER_NAME(GL_obj::ALWAYS,"ALWAYS");
	HX_MARK_MEMBER_NAME(GL_obj::KEEP,"KEEP");
	HX_MARK_MEMBER_NAME(GL_obj::REPLACE,"REPLACE");
	HX_MARK_MEMBER_NAME(GL_obj::INCR,"INCR");
	HX_MARK_MEMBER_NAME(GL_obj::DECR,"DECR");
	HX_MARK_MEMBER_NAME(GL_obj::INVERT,"INVERT");
	HX_MARK_MEMBER_NAME(GL_obj::INCR_WRAP,"INCR_WRAP");
	HX_MARK_MEMBER_NAME(GL_obj::DECR_WRAP,"DECR_WRAP");
	HX_MARK_MEMBER_NAME(GL_obj::VENDOR,"VENDOR");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERER,"RENDERER");
	HX_MARK_MEMBER_NAME(GL_obj::VERSION,"VERSION");
	HX_MARK_MEMBER_NAME(GL_obj::NEAREST,"NEAREST");
	HX_MARK_MEMBER_NAME(GL_obj::LINEAR,"LINEAR");
	HX_MARK_MEMBER_NAME(GL_obj::NEAREST_MIPMAP_NEAREST,"NEAREST_MIPMAP_NEAREST");
	HX_MARK_MEMBER_NAME(GL_obj::LINEAR_MIPMAP_NEAREST,"LINEAR_MIPMAP_NEAREST");
	HX_MARK_MEMBER_NAME(GL_obj::NEAREST_MIPMAP_LINEAR,"NEAREST_MIPMAP_LINEAR");
	HX_MARK_MEMBER_NAME(GL_obj::LINEAR_MIPMAP_LINEAR,"LINEAR_MIPMAP_LINEAR");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_MAG_FILTER,"TEXTURE_MAG_FILTER");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_MIN_FILTER,"TEXTURE_MIN_FILTER");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_WRAP_S,"TEXTURE_WRAP_S");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_WRAP_T,"TEXTURE_WRAP_T");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_2D,"TEXTURE_2D");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE,"TEXTURE");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP,"TEXTURE_CUBE_MAP");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_BINDING_CUBE_MAP,"TEXTURE_BINDING_CUBE_MAP");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_POSITIVE_X,"TEXTURE_CUBE_MAP_POSITIVE_X");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_X,"TEXTURE_CUBE_MAP_NEGATIVE_X");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_POSITIVE_Y,"TEXTURE_CUBE_MAP_POSITIVE_Y");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_Y,"TEXTURE_CUBE_MAP_NEGATIVE_Y");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_POSITIVE_Z,"TEXTURE_CUBE_MAP_POSITIVE_Z");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_Z,"TEXTURE_CUBE_MAP_NEGATIVE_Z");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_CUBE_MAP_TEXTURE_SIZE,"MAX_CUBE_MAP_TEXTURE_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE0,"TEXTURE0");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE1,"TEXTURE1");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE2,"TEXTURE2");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE3,"TEXTURE3");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE4,"TEXTURE4");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE5,"TEXTURE5");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE6,"TEXTURE6");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE7,"TEXTURE7");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE8,"TEXTURE8");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE9,"TEXTURE9");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE10,"TEXTURE10");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE11,"TEXTURE11");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE12,"TEXTURE12");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE13,"TEXTURE13");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE14,"TEXTURE14");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE15,"TEXTURE15");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE16,"TEXTURE16");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE17,"TEXTURE17");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE18,"TEXTURE18");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE19,"TEXTURE19");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE20,"TEXTURE20");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE21,"TEXTURE21");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE22,"TEXTURE22");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE23,"TEXTURE23");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE24,"TEXTURE24");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE25,"TEXTURE25");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE26,"TEXTURE26");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE27,"TEXTURE27");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE28,"TEXTURE28");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE29,"TEXTURE29");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE30,"TEXTURE30");
	HX_MARK_MEMBER_NAME(GL_obj::TEXTURE31,"TEXTURE31");
	HX_MARK_MEMBER_NAME(GL_obj::ACTIVE_TEXTURE,"ACTIVE_TEXTURE");
	HX_MARK_MEMBER_NAME(GL_obj::REPEAT,"REPEAT");
	HX_MARK_MEMBER_NAME(GL_obj::CLAMP_TO_EDGE,"CLAMP_TO_EDGE");
	HX_MARK_MEMBER_NAME(GL_obj::MIRRORED_REPEAT,"MIRRORED_REPEAT");
	HX_MARK_MEMBER_NAME(GL_obj::FLOAT_VEC2,"FLOAT_VEC2");
	HX_MARK_MEMBER_NAME(GL_obj::FLOAT_VEC3,"FLOAT_VEC3");
	HX_MARK_MEMBER_NAME(GL_obj::FLOAT_VEC4,"FLOAT_VEC4");
	HX_MARK_MEMBER_NAME(GL_obj::INT_VEC2,"INT_VEC2");
	HX_MARK_MEMBER_NAME(GL_obj::INT_VEC3,"INT_VEC3");
	HX_MARK_MEMBER_NAME(GL_obj::INT_VEC4,"INT_VEC4");
	HX_MARK_MEMBER_NAME(GL_obj::BOOL,"BOOL");
	HX_MARK_MEMBER_NAME(GL_obj::BOOL_VEC2,"BOOL_VEC2");
	HX_MARK_MEMBER_NAME(GL_obj::BOOL_VEC3,"BOOL_VEC3");
	HX_MARK_MEMBER_NAME(GL_obj::BOOL_VEC4,"BOOL_VEC4");
	HX_MARK_MEMBER_NAME(GL_obj::FLOAT_MAT2,"FLOAT_MAT2");
	HX_MARK_MEMBER_NAME(GL_obj::FLOAT_MAT3,"FLOAT_MAT3");
	HX_MARK_MEMBER_NAME(GL_obj::FLOAT_MAT4,"FLOAT_MAT4");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLER_2D,"SAMPLER_2D");
	HX_MARK_MEMBER_NAME(GL_obj::SAMPLER_CUBE,"SAMPLER_CUBE");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_ENABLED,"VERTEX_ATTRIB_ARRAY_ENABLED");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_SIZE,"VERTEX_ATTRIB_ARRAY_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_STRIDE,"VERTEX_ATTRIB_ARRAY_STRIDE");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_TYPE,"VERTEX_ATTRIB_ARRAY_TYPE");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_NORMALIZED,"VERTEX_ATTRIB_ARRAY_NORMALIZED");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_POINTER,"VERTEX_ATTRIB_ARRAY_POINTER");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,"VERTEX_ATTRIB_ARRAY_BUFFER_BINDING");
	HX_MARK_MEMBER_NAME(GL_obj::VERTEX_PROGRAM_POINT_SIZE,"VERTEX_PROGRAM_POINT_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::POINT_SPRITE,"POINT_SPRITE");
	HX_MARK_MEMBER_NAME(GL_obj::COMPILE_STATUS,"COMPILE_STATUS");
	HX_MARK_MEMBER_NAME(GL_obj::LOW_FLOAT,"LOW_FLOAT");
	HX_MARK_MEMBER_NAME(GL_obj::MEDIUM_FLOAT,"MEDIUM_FLOAT");
	HX_MARK_MEMBER_NAME(GL_obj::HIGH_FLOAT,"HIGH_FLOAT");
	HX_MARK_MEMBER_NAME(GL_obj::LOW_INT,"LOW_INT");
	HX_MARK_MEMBER_NAME(GL_obj::MEDIUM_INT,"MEDIUM_INT");
	HX_MARK_MEMBER_NAME(GL_obj::HIGH_INT,"HIGH_INT");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER,"FRAMEBUFFER");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER,"RENDERBUFFER");
	HX_MARK_MEMBER_NAME(GL_obj::RGBA4,"RGBA4");
	HX_MARK_MEMBER_NAME(GL_obj::RGB5_A1,"RGB5_A1");
	HX_MARK_MEMBER_NAME(GL_obj::RGB565,"RGB565");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_COMPONENT16,"DEPTH_COMPONENT16");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_INDEX,"STENCIL_INDEX");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_INDEX8,"STENCIL_INDEX8");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_STENCIL,"DEPTH_STENCIL");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_WIDTH,"RENDERBUFFER_WIDTH");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_HEIGHT,"RENDERBUFFER_HEIGHT");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_INTERNAL_FORMAT,"RENDERBUFFER_INTERNAL_FORMAT");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_RED_SIZE,"RENDERBUFFER_RED_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_GREEN_SIZE,"RENDERBUFFER_GREEN_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_BLUE_SIZE,"RENDERBUFFER_BLUE_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_ALPHA_SIZE,"RENDERBUFFER_ALPHA_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_DEPTH_SIZE,"RENDERBUFFER_DEPTH_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_STENCIL_SIZE,"RENDERBUFFER_STENCIL_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,"FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_OBJECT_NAME,"FRAMEBUFFER_ATTACHMENT_OBJECT_NAME");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL,"FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE,"FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE");
	HX_MARK_MEMBER_NAME(GL_obj::COLOR_ATTACHMENT0,"COLOR_ATTACHMENT0");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_ATTACHMENT,"DEPTH_ATTACHMENT");
	HX_MARK_MEMBER_NAME(GL_obj::STENCIL_ATTACHMENT,"STENCIL_ATTACHMENT");
	HX_MARK_MEMBER_NAME(GL_obj::DEPTH_STENCIL_ATTACHMENT,"DEPTH_STENCIL_ATTACHMENT");
	HX_MARK_MEMBER_NAME(GL_obj::NONE,"NONE");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_COMPLETE,"FRAMEBUFFER_COMPLETE");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_INCOMPLETE_ATTACHMENT,"FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT,"FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_INCOMPLETE_DIMENSIONS,"FRAMEBUFFER_INCOMPLETE_DIMENSIONS");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_UNSUPPORTED,"FRAMEBUFFER_UNSUPPORTED");
	HX_MARK_MEMBER_NAME(GL_obj::FRAMEBUFFER_BINDING,"FRAMEBUFFER_BINDING");
	HX_MARK_MEMBER_NAME(GL_obj::RENDERBUFFER_BINDING,"RENDERBUFFER_BINDING");
	HX_MARK_MEMBER_NAME(GL_obj::MAX_RENDERBUFFER_SIZE,"MAX_RENDERBUFFER_SIZE");
	HX_MARK_MEMBER_NAME(GL_obj::INVALID_FRAMEBUFFER_OPERATION,"INVALID_FRAMEBUFFER_OPERATION");
	HX_MARK_MEMBER_NAME(GL_obj::UNPACK_FLIP_Y_WEBGL,"UNPACK_FLIP_Y_WEBGL");
	HX_MARK_MEMBER_NAME(GL_obj::UNPACK_PREMULTIPLY_ALPHA_WEBGL,"UNPACK_PREMULTIPLY_ALPHA_WEBGL");
	HX_MARK_MEMBER_NAME(GL_obj::CONTEXT_LOST_WEBGL,"CONTEXT_LOST_WEBGL");
	HX_MARK_MEMBER_NAME(GL_obj::UNPACK_COLORSPACE_CONVERSION_WEBGL,"UNPACK_COLORSPACE_CONVERSION_WEBGL");
	HX_MARK_MEMBER_NAME(GL_obj::BROWSER_DEFAULT_WEBGL,"BROWSER_DEFAULT_WEBGL");
	HX_MARK_MEMBER_NAME(GL_obj::drawingBufferHeight,"drawingBufferHeight");
	HX_MARK_MEMBER_NAME(GL_obj::drawingBufferWidth,"drawingBufferWidth");
	HX_MARK_MEMBER_NAME(GL_obj::version,"version");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_active_texture,"lime_gl_active_texture");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_attach_shader,"lime_gl_attach_shader");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_bind_attrib_location,"lime_gl_bind_attrib_location");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_bind_bitmap_data_texture,"lime_gl_bind_bitmap_data_texture");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_bind_buffer,"lime_gl_bind_buffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_bind_framebuffer,"lime_gl_bind_framebuffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_bind_renderbuffer,"lime_gl_bind_renderbuffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_bind_texture,"lime_gl_bind_texture");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_blend_color,"lime_gl_blend_color");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_blend_equation,"lime_gl_blend_equation");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_blend_equation_separate,"lime_gl_blend_equation_separate");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_blend_func,"lime_gl_blend_func");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_blend_func_separate,"lime_gl_blend_func_separate");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_buffer_data,"lime_gl_buffer_data");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_buffer_sub_data,"lime_gl_buffer_sub_data");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_check_framebuffer_status,"lime_gl_check_framebuffer_status");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_clear,"lime_gl_clear");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_clear_color,"lime_gl_clear_color");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_clear_depth,"lime_gl_clear_depth");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_clear_stencil,"lime_gl_clear_stencil");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_color_mask,"lime_gl_color_mask");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_compile_shader,"lime_gl_compile_shader");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_compressed_tex_image_2d,"lime_gl_compressed_tex_image_2d");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_compressed_tex_sub_image_2d,"lime_gl_compressed_tex_sub_image_2d");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_copy_tex_image_2d,"lime_gl_copy_tex_image_2d");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_copy_tex_sub_image_2d,"lime_gl_copy_tex_sub_image_2d");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_create_buffer,"lime_gl_create_buffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_create_framebuffer,"lime_gl_create_framebuffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_create_program,"lime_gl_create_program");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_create_render_buffer,"lime_gl_create_render_buffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_create_shader,"lime_gl_create_shader");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_create_texture,"lime_gl_create_texture");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_cull_face,"lime_gl_cull_face");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_delete_buffer,"lime_gl_delete_buffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_delete_framebuffer,"lime_gl_delete_framebuffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_delete_program,"lime_gl_delete_program");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_delete_render_buffer,"lime_gl_delete_render_buffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_delete_shader,"lime_gl_delete_shader");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_delete_texture,"lime_gl_delete_texture");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_depth_func,"lime_gl_depth_func");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_depth_mask,"lime_gl_depth_mask");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_depth_range,"lime_gl_depth_range");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_detach_shader,"lime_gl_detach_shader");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_disable,"lime_gl_disable");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_disable_vertex_attrib_array,"lime_gl_disable_vertex_attrib_array");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_draw_arrays,"lime_gl_draw_arrays");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_draw_elements,"lime_gl_draw_elements");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_enable,"lime_gl_enable");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_enable_vertex_attrib_array,"lime_gl_enable_vertex_attrib_array");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_finish,"lime_gl_finish");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_flush,"lime_gl_flush");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_framebuffer_renderbuffer,"lime_gl_framebuffer_renderbuffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_framebuffer_texture2D,"lime_gl_framebuffer_texture2D");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_front_face,"lime_gl_front_face");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_generate_mipmap,"lime_gl_generate_mipmap");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_active_attrib,"lime_gl_get_active_attrib");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_active_uniform,"lime_gl_get_active_uniform");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_attrib_location,"lime_gl_get_attrib_location");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_buffer_paramerter,"lime_gl_get_buffer_paramerter");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_context_attributes,"lime_gl_get_context_attributes");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_error,"lime_gl_get_error");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_framebuffer_attachment_parameter,"lime_gl_get_framebuffer_attachment_parameter");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_parameter,"lime_gl_get_parameter");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_program_info_log,"lime_gl_get_program_info_log");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_program_parameter,"lime_gl_get_program_parameter");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_render_buffer_parameter,"lime_gl_get_render_buffer_parameter");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_shader_info_log,"lime_gl_get_shader_info_log");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_shader_parameter,"lime_gl_get_shader_parameter");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_shader_precision_format,"lime_gl_get_shader_precision_format");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_shader_source,"lime_gl_get_shader_source");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_supported_extensions,"lime_gl_get_supported_extensions");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_tex_parameter,"lime_gl_get_tex_parameter");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_uniform,"lime_gl_get_uniform");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_uniform_location,"lime_gl_get_uniform_location");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_vertex_attrib,"lime_gl_get_vertex_attrib");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_get_vertex_attrib_offset,"lime_gl_get_vertex_attrib_offset");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_hint,"lime_gl_hint");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_is_buffer,"lime_gl_is_buffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_is_enabled,"lime_gl_is_enabled");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_is_framebuffer,"lime_gl_is_framebuffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_is_program,"lime_gl_is_program");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_is_renderbuffer,"lime_gl_is_renderbuffer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_is_shader,"lime_gl_is_shader");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_is_texture,"lime_gl_is_texture");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_line_width,"lime_gl_line_width");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_link_program,"lime_gl_link_program");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_pixel_storei,"lime_gl_pixel_storei");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_polygon_offset,"lime_gl_polygon_offset");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_read_pixels,"lime_gl_read_pixels");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_renderbuffer_storage,"lime_gl_renderbuffer_storage");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_sample_coverage,"lime_gl_sample_coverage");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_scissor,"lime_gl_scissor");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_shader_source,"lime_gl_shader_source");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_stencil_func,"lime_gl_stencil_func");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_stencil_func_separate,"lime_gl_stencil_func_separate");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_stencil_mask,"lime_gl_stencil_mask");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_stencil_mask_separate,"lime_gl_stencil_mask_separate");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_stencil_op,"lime_gl_stencil_op");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_stencil_op_separate,"lime_gl_stencil_op_separate");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_tex_image_2d,"lime_gl_tex_image_2d");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_tex_parameterf,"lime_gl_tex_parameterf");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_tex_parameteri,"lime_gl_tex_parameteri");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_tex_sub_image_2d,"lime_gl_tex_sub_image_2d");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform1f,"lime_gl_uniform1f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform1fv,"lime_gl_uniform1fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform1i,"lime_gl_uniform1i");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform1iv,"lime_gl_uniform1iv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform2f,"lime_gl_uniform2f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform2fv,"lime_gl_uniform2fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform2i,"lime_gl_uniform2i");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform2iv,"lime_gl_uniform2iv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform3f,"lime_gl_uniform3f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform3fv,"lime_gl_uniform3fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform3i,"lime_gl_uniform3i");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform3iv,"lime_gl_uniform3iv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform4f,"lime_gl_uniform4f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform4fv,"lime_gl_uniform4fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform4i,"lime_gl_uniform4i");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform4iv,"lime_gl_uniform4iv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_uniform_matrix,"lime_gl_uniform_matrix");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_use_program,"lime_gl_use_program");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_validate_program,"lime_gl_validate_program");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_version,"lime_gl_version");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib1f,"lime_gl_vertex_attrib1f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib1fv,"lime_gl_vertex_attrib1fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib2f,"lime_gl_vertex_attrib2f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib2fv,"lime_gl_vertex_attrib2fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib3f,"lime_gl_vertex_attrib3f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib3fv,"lime_gl_vertex_attrib3fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib4f,"lime_gl_vertex_attrib4f");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib4fv,"lime_gl_vertex_attrib4fv");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib_pointer,"lime_gl_vertex_attrib_pointer");
	HX_MARK_MEMBER_NAME(GL_obj::lime_gl_viewport,"lime_gl_viewport");
};

#ifdef HXCPP_VISIT_ALLOCS
static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(GL_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_BUFFER_BIT,"DEPTH_BUFFER_BIT");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BUFFER_BIT,"STENCIL_BUFFER_BIT");
	HX_VISIT_MEMBER_NAME(GL_obj::COLOR_BUFFER_BIT,"COLOR_BUFFER_BIT");
	HX_VISIT_MEMBER_NAME(GL_obj::POINTS,"POINTS");
	HX_VISIT_MEMBER_NAME(GL_obj::LINES,"LINES");
	HX_VISIT_MEMBER_NAME(GL_obj::LINE_LOOP,"LINE_LOOP");
	HX_VISIT_MEMBER_NAME(GL_obj::LINE_STRIP,"LINE_STRIP");
	HX_VISIT_MEMBER_NAME(GL_obj::TRIANGLES,"TRIANGLES");
	HX_VISIT_MEMBER_NAME(GL_obj::TRIANGLE_STRIP,"TRIANGLE_STRIP");
	HX_VISIT_MEMBER_NAME(GL_obj::TRIANGLE_FAN,"TRIANGLE_FAN");
	HX_VISIT_MEMBER_NAME(GL_obj::ZERO,"ZERO");
	HX_VISIT_MEMBER_NAME(GL_obj::ONE,"ONE");
	HX_VISIT_MEMBER_NAME(GL_obj::SRC_COLOR,"SRC_COLOR");
	HX_VISIT_MEMBER_NAME(GL_obj::ONE_MINUS_SRC_COLOR,"ONE_MINUS_SRC_COLOR");
	HX_VISIT_MEMBER_NAME(GL_obj::SRC_ALPHA,"SRC_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::ONE_MINUS_SRC_ALPHA,"ONE_MINUS_SRC_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::DST_ALPHA,"DST_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::ONE_MINUS_DST_ALPHA,"ONE_MINUS_DST_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::DST_COLOR,"DST_COLOR");
	HX_VISIT_MEMBER_NAME(GL_obj::ONE_MINUS_DST_COLOR,"ONE_MINUS_DST_COLOR");
	HX_VISIT_MEMBER_NAME(GL_obj::SRC_ALPHA_SATURATE,"SRC_ALPHA_SATURATE");
	HX_VISIT_MEMBER_NAME(GL_obj::FUNC_ADD,"FUNC_ADD");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_EQUATION,"BLEND_EQUATION");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_EQUATION_RGB,"BLEND_EQUATION_RGB");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_EQUATION_ALPHA,"BLEND_EQUATION_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::FUNC_SUBTRACT,"FUNC_SUBTRACT");
	HX_VISIT_MEMBER_NAME(GL_obj::FUNC_REVERSE_SUBTRACT,"FUNC_REVERSE_SUBTRACT");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_DST_RGB,"BLEND_DST_RGB");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_SRC_RGB,"BLEND_SRC_RGB");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_DST_ALPHA,"BLEND_DST_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_SRC_ALPHA,"BLEND_SRC_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::CONSTANT_COLOR,"CONSTANT_COLOR");
	HX_VISIT_MEMBER_NAME(GL_obj::ONE_MINUS_CONSTANT_COLOR,"ONE_MINUS_CONSTANT_COLOR");
	HX_VISIT_MEMBER_NAME(GL_obj::CONSTANT_ALPHA,"CONSTANT_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::ONE_MINUS_CONSTANT_ALPHA,"ONE_MINUS_CONSTANT_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND_COLOR,"BLEND_COLOR");
	HX_VISIT_MEMBER_NAME(GL_obj::ARRAY_BUFFER,"ARRAY_BUFFER");
	HX_VISIT_MEMBER_NAME(GL_obj::ELEMENT_ARRAY_BUFFER,"ELEMENT_ARRAY_BUFFER");
	HX_VISIT_MEMBER_NAME(GL_obj::ARRAY_BUFFER_BINDING,"ARRAY_BUFFER_BINDING");
	HX_VISIT_MEMBER_NAME(GL_obj::ELEMENT_ARRAY_BUFFER_BINDING,"ELEMENT_ARRAY_BUFFER_BINDING");
	HX_VISIT_MEMBER_NAME(GL_obj::STREAM_DRAW,"STREAM_DRAW");
	HX_VISIT_MEMBER_NAME(GL_obj::STATIC_DRAW,"STATIC_DRAW");
	HX_VISIT_MEMBER_NAME(GL_obj::DYNAMIC_DRAW,"DYNAMIC_DRAW");
	HX_VISIT_MEMBER_NAME(GL_obj::BUFFER_SIZE,"BUFFER_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::BUFFER_USAGE,"BUFFER_USAGE");
	HX_VISIT_MEMBER_NAME(GL_obj::CURRENT_VERTEX_ATTRIB,"CURRENT_VERTEX_ATTRIB");
	HX_VISIT_MEMBER_NAME(GL_obj::FRONT,"FRONT");
	HX_VISIT_MEMBER_NAME(GL_obj::BACK,"BACK");
	HX_VISIT_MEMBER_NAME(GL_obj::FRONT_AND_BACK,"FRONT_AND_BACK");
	HX_VISIT_MEMBER_NAME(GL_obj::CULL_FACE,"CULL_FACE");
	HX_VISIT_MEMBER_NAME(GL_obj::BLEND,"BLEND");
	HX_VISIT_MEMBER_NAME(GL_obj::DITHER,"DITHER");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_TEST,"STENCIL_TEST");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_TEST,"DEPTH_TEST");
	HX_VISIT_MEMBER_NAME(GL_obj::SCISSOR_TEST,"SCISSOR_TEST");
	HX_VISIT_MEMBER_NAME(GL_obj::POLYGON_OFFSET_FILL,"POLYGON_OFFSET_FILL");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLE_ALPHA_TO_COVERAGE,"SAMPLE_ALPHA_TO_COVERAGE");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLE_COVERAGE,"SAMPLE_COVERAGE");
	HX_VISIT_MEMBER_NAME(GL_obj::NO_ERROR,"NO_ERROR");
	HX_VISIT_MEMBER_NAME(GL_obj::INVALID_ENUM,"INVALID_ENUM");
	HX_VISIT_MEMBER_NAME(GL_obj::INVALID_VALUE,"INVALID_VALUE");
	HX_VISIT_MEMBER_NAME(GL_obj::INVALID_OPERATION,"INVALID_OPERATION");
	HX_VISIT_MEMBER_NAME(GL_obj::OUT_OF_MEMORY,"OUT_OF_MEMORY");
	HX_VISIT_MEMBER_NAME(GL_obj::CW,"CW");
	HX_VISIT_MEMBER_NAME(GL_obj::CCW,"CCW");
	HX_VISIT_MEMBER_NAME(GL_obj::LINE_WIDTH,"LINE_WIDTH");
	HX_VISIT_MEMBER_NAME(GL_obj::ALIASED_POINT_SIZE_RANGE,"ALIASED_POINT_SIZE_RANGE");
	HX_VISIT_MEMBER_NAME(GL_obj::ALIASED_LINE_WIDTH_RANGE,"ALIASED_LINE_WIDTH_RANGE");
	HX_VISIT_MEMBER_NAME(GL_obj::CULL_FACE_MODE,"CULL_FACE_MODE");
	HX_VISIT_MEMBER_NAME(GL_obj::FRONT_FACE,"FRONT_FACE");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_RANGE,"DEPTH_RANGE");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_WRITEMASK,"DEPTH_WRITEMASK");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_CLEAR_VALUE,"DEPTH_CLEAR_VALUE");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_FUNC,"DEPTH_FUNC");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_CLEAR_VALUE,"STENCIL_CLEAR_VALUE");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_FUNC,"STENCIL_FUNC");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_FAIL,"STENCIL_FAIL");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_PASS_DEPTH_FAIL,"STENCIL_PASS_DEPTH_FAIL");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_PASS_DEPTH_PASS,"STENCIL_PASS_DEPTH_PASS");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_REF,"STENCIL_REF");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_VALUE_MASK,"STENCIL_VALUE_MASK");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_WRITEMASK,"STENCIL_WRITEMASK");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BACK_FUNC,"STENCIL_BACK_FUNC");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BACK_FAIL,"STENCIL_BACK_FAIL");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BACK_PASS_DEPTH_FAIL,"STENCIL_BACK_PASS_DEPTH_FAIL");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BACK_PASS_DEPTH_PASS,"STENCIL_BACK_PASS_DEPTH_PASS");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BACK_REF,"STENCIL_BACK_REF");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BACK_VALUE_MASK,"STENCIL_BACK_VALUE_MASK");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BACK_WRITEMASK,"STENCIL_BACK_WRITEMASK");
	HX_VISIT_MEMBER_NAME(GL_obj::VIEWPORT,"VIEWPORT");
	HX_VISIT_MEMBER_NAME(GL_obj::SCISSOR_BOX,"SCISSOR_BOX");
	HX_VISIT_MEMBER_NAME(GL_obj::COLOR_CLEAR_VALUE,"COLOR_CLEAR_VALUE");
	HX_VISIT_MEMBER_NAME(GL_obj::COLOR_WRITEMASK,"COLOR_WRITEMASK");
	HX_VISIT_MEMBER_NAME(GL_obj::UNPACK_ALIGNMENT,"UNPACK_ALIGNMENT");
	HX_VISIT_MEMBER_NAME(GL_obj::PACK_ALIGNMENT,"PACK_ALIGNMENT");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_TEXTURE_SIZE,"MAX_TEXTURE_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_VIEWPORT_DIMS,"MAX_VIEWPORT_DIMS");
	HX_VISIT_MEMBER_NAME(GL_obj::SUBPIXEL_BITS,"SUBPIXEL_BITS");
	HX_VISIT_MEMBER_NAME(GL_obj::RED_BITS,"RED_BITS");
	HX_VISIT_MEMBER_NAME(GL_obj::GREEN_BITS,"GREEN_BITS");
	HX_VISIT_MEMBER_NAME(GL_obj::BLUE_BITS,"BLUE_BITS");
	HX_VISIT_MEMBER_NAME(GL_obj::ALPHA_BITS,"ALPHA_BITS");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_BITS,"DEPTH_BITS");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_BITS,"STENCIL_BITS");
	HX_VISIT_MEMBER_NAME(GL_obj::POLYGON_OFFSET_UNITS,"POLYGON_OFFSET_UNITS");
	HX_VISIT_MEMBER_NAME(GL_obj::POLYGON_OFFSET_FACTOR,"POLYGON_OFFSET_FACTOR");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_BINDING_2D,"TEXTURE_BINDING_2D");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLE_BUFFERS,"SAMPLE_BUFFERS");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLES,"SAMPLES");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLE_COVERAGE_VALUE,"SAMPLE_COVERAGE_VALUE");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLE_COVERAGE_INVERT,"SAMPLE_COVERAGE_INVERT");
	HX_VISIT_MEMBER_NAME(GL_obj::COMPRESSED_TEXTURE_FORMATS,"COMPRESSED_TEXTURE_FORMATS");
	HX_VISIT_MEMBER_NAME(GL_obj::DONT_CARE,"DONT_CARE");
	HX_VISIT_MEMBER_NAME(GL_obj::FASTEST,"FASTEST");
	HX_VISIT_MEMBER_NAME(GL_obj::NICEST,"NICEST");
	HX_VISIT_MEMBER_NAME(GL_obj::GENERATE_MIPMAP_HINT,"GENERATE_MIPMAP_HINT");
	HX_VISIT_MEMBER_NAME(GL_obj::BYTE,"BYTE");
	HX_VISIT_MEMBER_NAME(GL_obj::UNSIGNED_BYTE,"UNSIGNED_BYTE");
	HX_VISIT_MEMBER_NAME(GL_obj::SHORT,"SHORT");
	HX_VISIT_MEMBER_NAME(GL_obj::UNSIGNED_SHORT,"UNSIGNED_SHORT");
	HX_VISIT_MEMBER_NAME(GL_obj::INT,"INT");
	HX_VISIT_MEMBER_NAME(GL_obj::UNSIGNED_INT,"UNSIGNED_INT");
	HX_VISIT_MEMBER_NAME(GL_obj::FLOAT,"FLOAT");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_COMPONENT,"DEPTH_COMPONENT");
	HX_VISIT_MEMBER_NAME(GL_obj::ALPHA,"ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::RGB,"RGB");
	HX_VISIT_MEMBER_NAME(GL_obj::RGBA,"RGBA");
	HX_VISIT_MEMBER_NAME(GL_obj::LUMINANCE,"LUMINANCE");
	HX_VISIT_MEMBER_NAME(GL_obj::LUMINANCE_ALPHA,"LUMINANCE_ALPHA");
	HX_VISIT_MEMBER_NAME(GL_obj::UNSIGNED_SHORT_4_4_4_4,"UNSIGNED_SHORT_4_4_4_4");
	HX_VISIT_MEMBER_NAME(GL_obj::UNSIGNED_SHORT_5_5_5_1,"UNSIGNED_SHORT_5_5_5_1");
	HX_VISIT_MEMBER_NAME(GL_obj::UNSIGNED_SHORT_5_6_5,"UNSIGNED_SHORT_5_6_5");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAGMENT_SHADER,"FRAGMENT_SHADER");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_SHADER,"VERTEX_SHADER");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_VERTEX_ATTRIBS,"MAX_VERTEX_ATTRIBS");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_VERTEX_UNIFORM_VECTORS,"MAX_VERTEX_UNIFORM_VECTORS");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_VARYING_VECTORS,"MAX_VARYING_VECTORS");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_COMBINED_TEXTURE_IMAGE_UNITS,"MAX_COMBINED_TEXTURE_IMAGE_UNITS");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_VERTEX_TEXTURE_IMAGE_UNITS,"MAX_VERTEX_TEXTURE_IMAGE_UNITS");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_TEXTURE_IMAGE_UNITS,"MAX_TEXTURE_IMAGE_UNITS");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_FRAGMENT_UNIFORM_VECTORS,"MAX_FRAGMENT_UNIFORM_VECTORS");
	HX_VISIT_MEMBER_NAME(GL_obj::SHADER_TYPE,"SHADER_TYPE");
	HX_VISIT_MEMBER_NAME(GL_obj::DELETE_STATUS,"DELETE_STATUS");
	HX_VISIT_MEMBER_NAME(GL_obj::LINK_STATUS,"LINK_STATUS");
	HX_VISIT_MEMBER_NAME(GL_obj::VALIDATE_STATUS,"VALIDATE_STATUS");
	HX_VISIT_MEMBER_NAME(GL_obj::ATTACHED_SHADERS,"ATTACHED_SHADERS");
	HX_VISIT_MEMBER_NAME(GL_obj::ACTIVE_UNIFORMS,"ACTIVE_UNIFORMS");
	HX_VISIT_MEMBER_NAME(GL_obj::ACTIVE_ATTRIBUTES,"ACTIVE_ATTRIBUTES");
	HX_VISIT_MEMBER_NAME(GL_obj::SHADING_LANGUAGE_VERSION,"SHADING_LANGUAGE_VERSION");
	HX_VISIT_MEMBER_NAME(GL_obj::CURRENT_PROGRAM,"CURRENT_PROGRAM");
	HX_VISIT_MEMBER_NAME(GL_obj::NEVER,"NEVER");
	HX_VISIT_MEMBER_NAME(GL_obj::LESS,"LESS");
	HX_VISIT_MEMBER_NAME(GL_obj::EQUAL,"EQUAL");
	HX_VISIT_MEMBER_NAME(GL_obj::LEQUAL,"LEQUAL");
	HX_VISIT_MEMBER_NAME(GL_obj::GREATER,"GREATER");
	HX_VISIT_MEMBER_NAME(GL_obj::NOTEQUAL,"NOTEQUAL");
	HX_VISIT_MEMBER_NAME(GL_obj::GEQUAL,"GEQUAL");
	HX_VISIT_MEMBER_NAME(GL_obj::ALWAYS,"ALWAYS");
	HX_VISIT_MEMBER_NAME(GL_obj::KEEP,"KEEP");
	HX_VISIT_MEMBER_NAME(GL_obj::REPLACE,"REPLACE");
	HX_VISIT_MEMBER_NAME(GL_obj::INCR,"INCR");
	HX_VISIT_MEMBER_NAME(GL_obj::DECR,"DECR");
	HX_VISIT_MEMBER_NAME(GL_obj::INVERT,"INVERT");
	HX_VISIT_MEMBER_NAME(GL_obj::INCR_WRAP,"INCR_WRAP");
	HX_VISIT_MEMBER_NAME(GL_obj::DECR_WRAP,"DECR_WRAP");
	HX_VISIT_MEMBER_NAME(GL_obj::VENDOR,"VENDOR");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERER,"RENDERER");
	HX_VISIT_MEMBER_NAME(GL_obj::VERSION,"VERSION");
	HX_VISIT_MEMBER_NAME(GL_obj::NEAREST,"NEAREST");
	HX_VISIT_MEMBER_NAME(GL_obj::LINEAR,"LINEAR");
	HX_VISIT_MEMBER_NAME(GL_obj::NEAREST_MIPMAP_NEAREST,"NEAREST_MIPMAP_NEAREST");
	HX_VISIT_MEMBER_NAME(GL_obj::LINEAR_MIPMAP_NEAREST,"LINEAR_MIPMAP_NEAREST");
	HX_VISIT_MEMBER_NAME(GL_obj::NEAREST_MIPMAP_LINEAR,"NEAREST_MIPMAP_LINEAR");
	HX_VISIT_MEMBER_NAME(GL_obj::LINEAR_MIPMAP_LINEAR,"LINEAR_MIPMAP_LINEAR");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_MAG_FILTER,"TEXTURE_MAG_FILTER");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_MIN_FILTER,"TEXTURE_MIN_FILTER");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_WRAP_S,"TEXTURE_WRAP_S");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_WRAP_T,"TEXTURE_WRAP_T");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_2D,"TEXTURE_2D");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE,"TEXTURE");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP,"TEXTURE_CUBE_MAP");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_BINDING_CUBE_MAP,"TEXTURE_BINDING_CUBE_MAP");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_POSITIVE_X,"TEXTURE_CUBE_MAP_POSITIVE_X");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_X,"TEXTURE_CUBE_MAP_NEGATIVE_X");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_POSITIVE_Y,"TEXTURE_CUBE_MAP_POSITIVE_Y");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_Y,"TEXTURE_CUBE_MAP_NEGATIVE_Y");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_POSITIVE_Z,"TEXTURE_CUBE_MAP_POSITIVE_Z");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE_CUBE_MAP_NEGATIVE_Z,"TEXTURE_CUBE_MAP_NEGATIVE_Z");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_CUBE_MAP_TEXTURE_SIZE,"MAX_CUBE_MAP_TEXTURE_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE0,"TEXTURE0");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE1,"TEXTURE1");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE2,"TEXTURE2");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE3,"TEXTURE3");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE4,"TEXTURE4");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE5,"TEXTURE5");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE6,"TEXTURE6");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE7,"TEXTURE7");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE8,"TEXTURE8");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE9,"TEXTURE9");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE10,"TEXTURE10");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE11,"TEXTURE11");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE12,"TEXTURE12");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE13,"TEXTURE13");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE14,"TEXTURE14");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE15,"TEXTURE15");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE16,"TEXTURE16");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE17,"TEXTURE17");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE18,"TEXTURE18");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE19,"TEXTURE19");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE20,"TEXTURE20");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE21,"TEXTURE21");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE22,"TEXTURE22");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE23,"TEXTURE23");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE24,"TEXTURE24");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE25,"TEXTURE25");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE26,"TEXTURE26");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE27,"TEXTURE27");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE28,"TEXTURE28");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE29,"TEXTURE29");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE30,"TEXTURE30");
	HX_VISIT_MEMBER_NAME(GL_obj::TEXTURE31,"TEXTURE31");
	HX_VISIT_MEMBER_NAME(GL_obj::ACTIVE_TEXTURE,"ACTIVE_TEXTURE");
	HX_VISIT_MEMBER_NAME(GL_obj::REPEAT,"REPEAT");
	HX_VISIT_MEMBER_NAME(GL_obj::CLAMP_TO_EDGE,"CLAMP_TO_EDGE");
	HX_VISIT_MEMBER_NAME(GL_obj::MIRRORED_REPEAT,"MIRRORED_REPEAT");
	HX_VISIT_MEMBER_NAME(GL_obj::FLOAT_VEC2,"FLOAT_VEC2");
	HX_VISIT_MEMBER_NAME(GL_obj::FLOAT_VEC3,"FLOAT_VEC3");
	HX_VISIT_MEMBER_NAME(GL_obj::FLOAT_VEC4,"FLOAT_VEC4");
	HX_VISIT_MEMBER_NAME(GL_obj::INT_VEC2,"INT_VEC2");
	HX_VISIT_MEMBER_NAME(GL_obj::INT_VEC3,"INT_VEC3");
	HX_VISIT_MEMBER_NAME(GL_obj::INT_VEC4,"INT_VEC4");
	HX_VISIT_MEMBER_NAME(GL_obj::BOOL,"BOOL");
	HX_VISIT_MEMBER_NAME(GL_obj::BOOL_VEC2,"BOOL_VEC2");
	HX_VISIT_MEMBER_NAME(GL_obj::BOOL_VEC3,"BOOL_VEC3");
	HX_VISIT_MEMBER_NAME(GL_obj::BOOL_VEC4,"BOOL_VEC4");
	HX_VISIT_MEMBER_NAME(GL_obj::FLOAT_MAT2,"FLOAT_MAT2");
	HX_VISIT_MEMBER_NAME(GL_obj::FLOAT_MAT3,"FLOAT_MAT3");
	HX_VISIT_MEMBER_NAME(GL_obj::FLOAT_MAT4,"FLOAT_MAT4");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLER_2D,"SAMPLER_2D");
	HX_VISIT_MEMBER_NAME(GL_obj::SAMPLER_CUBE,"SAMPLER_CUBE");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_ENABLED,"VERTEX_ATTRIB_ARRAY_ENABLED");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_SIZE,"VERTEX_ATTRIB_ARRAY_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_STRIDE,"VERTEX_ATTRIB_ARRAY_STRIDE");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_TYPE,"VERTEX_ATTRIB_ARRAY_TYPE");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_NORMALIZED,"VERTEX_ATTRIB_ARRAY_NORMALIZED");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_POINTER,"VERTEX_ATTRIB_ARRAY_POINTER");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,"VERTEX_ATTRIB_ARRAY_BUFFER_BINDING");
	HX_VISIT_MEMBER_NAME(GL_obj::VERTEX_PROGRAM_POINT_SIZE,"VERTEX_PROGRAM_POINT_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::POINT_SPRITE,"POINT_SPRITE");
	HX_VISIT_MEMBER_NAME(GL_obj::COMPILE_STATUS,"COMPILE_STATUS");
	HX_VISIT_MEMBER_NAME(GL_obj::LOW_FLOAT,"LOW_FLOAT");
	HX_VISIT_MEMBER_NAME(GL_obj::MEDIUM_FLOAT,"MEDIUM_FLOAT");
	HX_VISIT_MEMBER_NAME(GL_obj::HIGH_FLOAT,"HIGH_FLOAT");
	HX_VISIT_MEMBER_NAME(GL_obj::LOW_INT,"LOW_INT");
	HX_VISIT_MEMBER_NAME(GL_obj::MEDIUM_INT,"MEDIUM_INT");
	HX_VISIT_MEMBER_NAME(GL_obj::HIGH_INT,"HIGH_INT");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER,"FRAMEBUFFER");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER,"RENDERBUFFER");
	HX_VISIT_MEMBER_NAME(GL_obj::RGBA4,"RGBA4");
	HX_VISIT_MEMBER_NAME(GL_obj::RGB5_A1,"RGB5_A1");
	HX_VISIT_MEMBER_NAME(GL_obj::RGB565,"RGB565");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_COMPONENT16,"DEPTH_COMPONENT16");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_INDEX,"STENCIL_INDEX");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_INDEX8,"STENCIL_INDEX8");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_STENCIL,"DEPTH_STENCIL");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_WIDTH,"RENDERBUFFER_WIDTH");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_HEIGHT,"RENDERBUFFER_HEIGHT");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_INTERNAL_FORMAT,"RENDERBUFFER_INTERNAL_FORMAT");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_RED_SIZE,"RENDERBUFFER_RED_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_GREEN_SIZE,"RENDERBUFFER_GREEN_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_BLUE_SIZE,"RENDERBUFFER_BLUE_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_ALPHA_SIZE,"RENDERBUFFER_ALPHA_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_DEPTH_SIZE,"RENDERBUFFER_DEPTH_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_STENCIL_SIZE,"RENDERBUFFER_STENCIL_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,"FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_OBJECT_NAME,"FRAMEBUFFER_ATTACHMENT_OBJECT_NAME");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL,"FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE,"FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE");
	HX_VISIT_MEMBER_NAME(GL_obj::COLOR_ATTACHMENT0,"COLOR_ATTACHMENT0");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_ATTACHMENT,"DEPTH_ATTACHMENT");
	HX_VISIT_MEMBER_NAME(GL_obj::STENCIL_ATTACHMENT,"STENCIL_ATTACHMENT");
	HX_VISIT_MEMBER_NAME(GL_obj::DEPTH_STENCIL_ATTACHMENT,"DEPTH_STENCIL_ATTACHMENT");
	HX_VISIT_MEMBER_NAME(GL_obj::NONE,"NONE");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_COMPLETE,"FRAMEBUFFER_COMPLETE");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_INCOMPLETE_ATTACHMENT,"FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT,"FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_INCOMPLETE_DIMENSIONS,"FRAMEBUFFER_INCOMPLETE_DIMENSIONS");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_UNSUPPORTED,"FRAMEBUFFER_UNSUPPORTED");
	HX_VISIT_MEMBER_NAME(GL_obj::FRAMEBUFFER_BINDING,"FRAMEBUFFER_BINDING");
	HX_VISIT_MEMBER_NAME(GL_obj::RENDERBUFFER_BINDING,"RENDERBUFFER_BINDING");
	HX_VISIT_MEMBER_NAME(GL_obj::MAX_RENDERBUFFER_SIZE,"MAX_RENDERBUFFER_SIZE");
	HX_VISIT_MEMBER_NAME(GL_obj::INVALID_FRAMEBUFFER_OPERATION,"INVALID_FRAMEBUFFER_OPERATION");
	HX_VISIT_MEMBER_NAME(GL_obj::UNPACK_FLIP_Y_WEBGL,"UNPACK_FLIP_Y_WEBGL");
	HX_VISIT_MEMBER_NAME(GL_obj::UNPACK_PREMULTIPLY_ALPHA_WEBGL,"UNPACK_PREMULTIPLY_ALPHA_WEBGL");
	HX_VISIT_MEMBER_NAME(GL_obj::CONTEXT_LOST_WEBGL,"CONTEXT_LOST_WEBGL");
	HX_VISIT_MEMBER_NAME(GL_obj::UNPACK_COLORSPACE_CONVERSION_WEBGL,"UNPACK_COLORSPACE_CONVERSION_WEBGL");
	HX_VISIT_MEMBER_NAME(GL_obj::BROWSER_DEFAULT_WEBGL,"BROWSER_DEFAULT_WEBGL");
	HX_VISIT_MEMBER_NAME(GL_obj::drawingBufferHeight,"drawingBufferHeight");
	HX_VISIT_MEMBER_NAME(GL_obj::drawingBufferWidth,"drawingBufferWidth");
	HX_VISIT_MEMBER_NAME(GL_obj::version,"version");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_active_texture,"lime_gl_active_texture");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_attach_shader,"lime_gl_attach_shader");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_bind_attrib_location,"lime_gl_bind_attrib_location");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_bind_bitmap_data_texture,"lime_gl_bind_bitmap_data_texture");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_bind_buffer,"lime_gl_bind_buffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_bind_framebuffer,"lime_gl_bind_framebuffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_bind_renderbuffer,"lime_gl_bind_renderbuffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_bind_texture,"lime_gl_bind_texture");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_blend_color,"lime_gl_blend_color");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_blend_equation,"lime_gl_blend_equation");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_blend_equation_separate,"lime_gl_blend_equation_separate");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_blend_func,"lime_gl_blend_func");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_blend_func_separate,"lime_gl_blend_func_separate");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_buffer_data,"lime_gl_buffer_data");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_buffer_sub_data,"lime_gl_buffer_sub_data");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_check_framebuffer_status,"lime_gl_check_framebuffer_status");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_clear,"lime_gl_clear");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_clear_color,"lime_gl_clear_color");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_clear_depth,"lime_gl_clear_depth");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_clear_stencil,"lime_gl_clear_stencil");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_color_mask,"lime_gl_color_mask");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_compile_shader,"lime_gl_compile_shader");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_compressed_tex_image_2d,"lime_gl_compressed_tex_image_2d");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_compressed_tex_sub_image_2d,"lime_gl_compressed_tex_sub_image_2d");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_copy_tex_image_2d,"lime_gl_copy_tex_image_2d");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_copy_tex_sub_image_2d,"lime_gl_copy_tex_sub_image_2d");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_create_buffer,"lime_gl_create_buffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_create_framebuffer,"lime_gl_create_framebuffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_create_program,"lime_gl_create_program");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_create_render_buffer,"lime_gl_create_render_buffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_create_shader,"lime_gl_create_shader");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_create_texture,"lime_gl_create_texture");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_cull_face,"lime_gl_cull_face");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_delete_buffer,"lime_gl_delete_buffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_delete_framebuffer,"lime_gl_delete_framebuffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_delete_program,"lime_gl_delete_program");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_delete_render_buffer,"lime_gl_delete_render_buffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_delete_shader,"lime_gl_delete_shader");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_delete_texture,"lime_gl_delete_texture");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_depth_func,"lime_gl_depth_func");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_depth_mask,"lime_gl_depth_mask");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_depth_range,"lime_gl_depth_range");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_detach_shader,"lime_gl_detach_shader");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_disable,"lime_gl_disable");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_disable_vertex_attrib_array,"lime_gl_disable_vertex_attrib_array");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_draw_arrays,"lime_gl_draw_arrays");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_draw_elements,"lime_gl_draw_elements");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_enable,"lime_gl_enable");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_enable_vertex_attrib_array,"lime_gl_enable_vertex_attrib_array");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_finish,"lime_gl_finish");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_flush,"lime_gl_flush");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_framebuffer_renderbuffer,"lime_gl_framebuffer_renderbuffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_framebuffer_texture2D,"lime_gl_framebuffer_texture2D");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_front_face,"lime_gl_front_face");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_generate_mipmap,"lime_gl_generate_mipmap");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_active_attrib,"lime_gl_get_active_attrib");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_active_uniform,"lime_gl_get_active_uniform");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_attrib_location,"lime_gl_get_attrib_location");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_buffer_paramerter,"lime_gl_get_buffer_paramerter");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_context_attributes,"lime_gl_get_context_attributes");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_error,"lime_gl_get_error");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_framebuffer_attachment_parameter,"lime_gl_get_framebuffer_attachment_parameter");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_parameter,"lime_gl_get_parameter");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_program_info_log,"lime_gl_get_program_info_log");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_program_parameter,"lime_gl_get_program_parameter");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_render_buffer_parameter,"lime_gl_get_render_buffer_parameter");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_shader_info_log,"lime_gl_get_shader_info_log");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_shader_parameter,"lime_gl_get_shader_parameter");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_shader_precision_format,"lime_gl_get_shader_precision_format");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_shader_source,"lime_gl_get_shader_source");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_supported_extensions,"lime_gl_get_supported_extensions");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_tex_parameter,"lime_gl_get_tex_parameter");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_uniform,"lime_gl_get_uniform");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_uniform_location,"lime_gl_get_uniform_location");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_vertex_attrib,"lime_gl_get_vertex_attrib");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_get_vertex_attrib_offset,"lime_gl_get_vertex_attrib_offset");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_hint,"lime_gl_hint");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_is_buffer,"lime_gl_is_buffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_is_enabled,"lime_gl_is_enabled");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_is_framebuffer,"lime_gl_is_framebuffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_is_program,"lime_gl_is_program");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_is_renderbuffer,"lime_gl_is_renderbuffer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_is_shader,"lime_gl_is_shader");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_is_texture,"lime_gl_is_texture");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_line_width,"lime_gl_line_width");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_link_program,"lime_gl_link_program");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_pixel_storei,"lime_gl_pixel_storei");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_polygon_offset,"lime_gl_polygon_offset");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_read_pixels,"lime_gl_read_pixels");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_renderbuffer_storage,"lime_gl_renderbuffer_storage");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_sample_coverage,"lime_gl_sample_coverage");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_scissor,"lime_gl_scissor");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_shader_source,"lime_gl_shader_source");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_stencil_func,"lime_gl_stencil_func");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_stencil_func_separate,"lime_gl_stencil_func_separate");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_stencil_mask,"lime_gl_stencil_mask");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_stencil_mask_separate,"lime_gl_stencil_mask_separate");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_stencil_op,"lime_gl_stencil_op");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_stencil_op_separate,"lime_gl_stencil_op_separate");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_tex_image_2d,"lime_gl_tex_image_2d");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_tex_parameterf,"lime_gl_tex_parameterf");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_tex_parameteri,"lime_gl_tex_parameteri");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_tex_sub_image_2d,"lime_gl_tex_sub_image_2d");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform1f,"lime_gl_uniform1f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform1fv,"lime_gl_uniform1fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform1i,"lime_gl_uniform1i");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform1iv,"lime_gl_uniform1iv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform2f,"lime_gl_uniform2f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform2fv,"lime_gl_uniform2fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform2i,"lime_gl_uniform2i");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform2iv,"lime_gl_uniform2iv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform3f,"lime_gl_uniform3f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform3fv,"lime_gl_uniform3fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform3i,"lime_gl_uniform3i");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform3iv,"lime_gl_uniform3iv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform4f,"lime_gl_uniform4f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform4fv,"lime_gl_uniform4fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform4i,"lime_gl_uniform4i");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform4iv,"lime_gl_uniform4iv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_uniform_matrix,"lime_gl_uniform_matrix");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_use_program,"lime_gl_use_program");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_validate_program,"lime_gl_validate_program");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_version,"lime_gl_version");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib1f,"lime_gl_vertex_attrib1f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib1fv,"lime_gl_vertex_attrib1fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib2f,"lime_gl_vertex_attrib2f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib2fv,"lime_gl_vertex_attrib2fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib3f,"lime_gl_vertex_attrib3f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib3fv,"lime_gl_vertex_attrib3fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib4f,"lime_gl_vertex_attrib4f");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib4fv,"lime_gl_vertex_attrib4fv");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_vertex_attrib_pointer,"lime_gl_vertex_attrib_pointer");
	HX_VISIT_MEMBER_NAME(GL_obj::lime_gl_viewport,"lime_gl_viewport");
};

#endif

Class GL_obj::__mClass;

void GL_obj::__register()
{
	hx::Static(__mClass) = hx::RegisterClass(HX_CSTRING("openfl.gl.GL"), hx::TCanCast< GL_obj> ,sStaticFields,sMemberFields,
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

void GL_obj::__boot()
{
	DEPTH_BUFFER_BIT= (int)256;
	STENCIL_BUFFER_BIT= (int)1024;
	COLOR_BUFFER_BIT= (int)16384;
	POINTS= (int)0;
	LINES= (int)1;
	LINE_LOOP= (int)2;
	LINE_STRIP= (int)3;
	TRIANGLES= (int)4;
	TRIANGLE_STRIP= (int)5;
	TRIANGLE_FAN= (int)6;
	ZERO= (int)0;
	ONE= (int)1;
	SRC_COLOR= (int)768;
	ONE_MINUS_SRC_COLOR= (int)769;
	SRC_ALPHA= (int)770;
	ONE_MINUS_SRC_ALPHA= (int)771;
	DST_ALPHA= (int)772;
	ONE_MINUS_DST_ALPHA= (int)773;
	DST_COLOR= (int)774;
	ONE_MINUS_DST_COLOR= (int)775;
	SRC_ALPHA_SATURATE= (int)776;
	FUNC_ADD= (int)32774;
	BLEND_EQUATION= (int)32777;
	BLEND_EQUATION_RGB= (int)32777;
	BLEND_EQUATION_ALPHA= (int)34877;
	FUNC_SUBTRACT= (int)32778;
	FUNC_REVERSE_SUBTRACT= (int)32779;
	BLEND_DST_RGB= (int)32968;
	BLEND_SRC_RGB= (int)32969;
	BLEND_DST_ALPHA= (int)32970;
	BLEND_SRC_ALPHA= (int)32971;
	CONSTANT_COLOR= (int)32769;
	ONE_MINUS_CONSTANT_COLOR= (int)32770;
	CONSTANT_ALPHA= (int)32771;
	ONE_MINUS_CONSTANT_ALPHA= (int)32772;
	BLEND_COLOR= (int)32773;
	ARRAY_BUFFER= (int)34962;
	ELEMENT_ARRAY_BUFFER= (int)34963;
	ARRAY_BUFFER_BINDING= (int)34964;
	ELEMENT_ARRAY_BUFFER_BINDING= (int)34965;
	STREAM_DRAW= (int)35040;
	STATIC_DRAW= (int)35044;
	DYNAMIC_DRAW= (int)35048;
	BUFFER_SIZE= (int)34660;
	BUFFER_USAGE= (int)34661;
	CURRENT_VERTEX_ATTRIB= (int)34342;
	FRONT= (int)1028;
	BACK= (int)1029;
	FRONT_AND_BACK= (int)1032;
	CULL_FACE= (int)2884;
	BLEND= (int)3042;
	DITHER= (int)3024;
	STENCIL_TEST= (int)2960;
	DEPTH_TEST= (int)2929;
	SCISSOR_TEST= (int)3089;
	POLYGON_OFFSET_FILL= (int)32823;
	SAMPLE_ALPHA_TO_COVERAGE= (int)32926;
	SAMPLE_COVERAGE= (int)32928;
	NO_ERROR= (int)0;
	INVALID_ENUM= (int)1280;
	INVALID_VALUE= (int)1281;
	INVALID_OPERATION= (int)1282;
	OUT_OF_MEMORY= (int)1285;
	CW= (int)2304;
	CCW= (int)2305;
	LINE_WIDTH= (int)2849;
	ALIASED_POINT_SIZE_RANGE= (int)33901;
	ALIASED_LINE_WIDTH_RANGE= (int)33902;
	CULL_FACE_MODE= (int)2885;
	FRONT_FACE= (int)2886;
	DEPTH_RANGE= (int)2928;
	DEPTH_WRITEMASK= (int)2930;
	DEPTH_CLEAR_VALUE= (int)2931;
	DEPTH_FUNC= (int)2932;
	STENCIL_CLEAR_VALUE= (int)2961;
	STENCIL_FUNC= (int)2962;
	STENCIL_FAIL= (int)2964;
	STENCIL_PASS_DEPTH_FAIL= (int)2965;
	STENCIL_PASS_DEPTH_PASS= (int)2966;
	STENCIL_REF= (int)2967;
	STENCIL_VALUE_MASK= (int)2963;
	STENCIL_WRITEMASK= (int)2968;
	STENCIL_BACK_FUNC= (int)34816;
	STENCIL_BACK_FAIL= (int)34817;
	STENCIL_BACK_PASS_DEPTH_FAIL= (int)34818;
	STENCIL_BACK_PASS_DEPTH_PASS= (int)34819;
	STENCIL_BACK_REF= (int)36003;
	STENCIL_BACK_VALUE_MASK= (int)36004;
	STENCIL_BACK_WRITEMASK= (int)36005;
	VIEWPORT= (int)2978;
	SCISSOR_BOX= (int)3088;
	COLOR_CLEAR_VALUE= (int)3106;
	COLOR_WRITEMASK= (int)3107;
	UNPACK_ALIGNMENT= (int)3317;
	PACK_ALIGNMENT= (int)3333;
	MAX_TEXTURE_SIZE= (int)3379;
	MAX_VIEWPORT_DIMS= (int)3386;
	SUBPIXEL_BITS= (int)3408;
	RED_BITS= (int)3410;
	GREEN_BITS= (int)3411;
	BLUE_BITS= (int)3412;
	ALPHA_BITS= (int)3413;
	DEPTH_BITS= (int)3414;
	STENCIL_BITS= (int)3415;
	POLYGON_OFFSET_UNITS= (int)10752;
	POLYGON_OFFSET_FACTOR= (int)32824;
	TEXTURE_BINDING_2D= (int)32873;
	SAMPLE_BUFFERS= (int)32936;
	SAMPLES= (int)32937;
	SAMPLE_COVERAGE_VALUE= (int)32938;
	SAMPLE_COVERAGE_INVERT= (int)32939;
	COMPRESSED_TEXTURE_FORMATS= (int)34467;
	DONT_CARE= (int)4352;
	FASTEST= (int)4353;
	NICEST= (int)4354;
	GENERATE_MIPMAP_HINT= (int)33170;
	BYTE= (int)5120;
	UNSIGNED_BYTE= (int)5121;
	SHORT= (int)5122;
	UNSIGNED_SHORT= (int)5123;
	INT= (int)5124;
	UNSIGNED_INT= (int)5125;
	FLOAT= (int)5126;
	DEPTH_COMPONENT= (int)6402;
	ALPHA= (int)6406;
	RGB= (int)6407;
	RGBA= (int)6408;
	LUMINANCE= (int)6409;
	LUMINANCE_ALPHA= (int)6410;
	UNSIGNED_SHORT_4_4_4_4= (int)32819;
	UNSIGNED_SHORT_5_5_5_1= (int)32820;
	UNSIGNED_SHORT_5_6_5= (int)33635;
	FRAGMENT_SHADER= (int)35632;
	VERTEX_SHADER= (int)35633;
	MAX_VERTEX_ATTRIBS= (int)34921;
	MAX_VERTEX_UNIFORM_VECTORS= (int)36347;
	MAX_VARYING_VECTORS= (int)36348;
	MAX_COMBINED_TEXTURE_IMAGE_UNITS= (int)35661;
	MAX_VERTEX_TEXTURE_IMAGE_UNITS= (int)35660;
	MAX_TEXTURE_IMAGE_UNITS= (int)34930;
	MAX_FRAGMENT_UNIFORM_VECTORS= (int)36349;
	SHADER_TYPE= (int)35663;
	DELETE_STATUS= (int)35712;
	LINK_STATUS= (int)35714;
	VALIDATE_STATUS= (int)35715;
	ATTACHED_SHADERS= (int)35717;
	ACTIVE_UNIFORMS= (int)35718;
	ACTIVE_ATTRIBUTES= (int)35721;
	SHADING_LANGUAGE_VERSION= (int)35724;
	CURRENT_PROGRAM= (int)35725;
	NEVER= (int)512;
	LESS= (int)513;
	EQUAL= (int)514;
	LEQUAL= (int)515;
	GREATER= (int)516;
	NOTEQUAL= (int)517;
	GEQUAL= (int)518;
	ALWAYS= (int)519;
	KEEP= (int)7680;
	REPLACE= (int)7681;
	INCR= (int)7682;
	DECR= (int)7683;
	INVERT= (int)5386;
	INCR_WRAP= (int)34055;
	DECR_WRAP= (int)34056;
	VENDOR= (int)7936;
	RENDERER= (int)7937;
	VERSION= (int)7938;
	NEAREST= (int)9728;
	LINEAR= (int)9729;
	NEAREST_MIPMAP_NEAREST= (int)9984;
	LINEAR_MIPMAP_NEAREST= (int)9985;
	NEAREST_MIPMAP_LINEAR= (int)9986;
	LINEAR_MIPMAP_LINEAR= (int)9987;
	TEXTURE_MAG_FILTER= (int)10240;
	TEXTURE_MIN_FILTER= (int)10241;
	TEXTURE_WRAP_S= (int)10242;
	TEXTURE_WRAP_T= (int)10243;
	TEXTURE_2D= (int)3553;
	TEXTURE= (int)5890;
	TEXTURE_CUBE_MAP= (int)34067;
	TEXTURE_BINDING_CUBE_MAP= (int)34068;
	TEXTURE_CUBE_MAP_POSITIVE_X= (int)34069;
	TEXTURE_CUBE_MAP_NEGATIVE_X= (int)34070;
	TEXTURE_CUBE_MAP_POSITIVE_Y= (int)34071;
	TEXTURE_CUBE_MAP_NEGATIVE_Y= (int)34072;
	TEXTURE_CUBE_MAP_POSITIVE_Z= (int)34073;
	TEXTURE_CUBE_MAP_NEGATIVE_Z= (int)34074;
	MAX_CUBE_MAP_TEXTURE_SIZE= (int)34076;
	TEXTURE0= (int)33984;
	TEXTURE1= (int)33985;
	TEXTURE2= (int)33986;
	TEXTURE3= (int)33987;
	TEXTURE4= (int)33988;
	TEXTURE5= (int)33989;
	TEXTURE6= (int)33990;
	TEXTURE7= (int)33991;
	TEXTURE8= (int)33992;
	TEXTURE9= (int)33993;
	TEXTURE10= (int)33994;
	TEXTURE11= (int)33995;
	TEXTURE12= (int)33996;
	TEXTURE13= (int)33997;
	TEXTURE14= (int)33998;
	TEXTURE15= (int)33999;
	TEXTURE16= (int)34000;
	TEXTURE17= (int)34001;
	TEXTURE18= (int)34002;
	TEXTURE19= (int)34003;
	TEXTURE20= (int)34004;
	TEXTURE21= (int)34005;
	TEXTURE22= (int)34006;
	TEXTURE23= (int)34007;
	TEXTURE24= (int)34008;
	TEXTURE25= (int)34009;
	TEXTURE26= (int)34010;
	TEXTURE27= (int)34011;
	TEXTURE28= (int)34012;
	TEXTURE29= (int)34013;
	TEXTURE30= (int)34014;
	TEXTURE31= (int)34015;
	ACTIVE_TEXTURE= (int)34016;
	REPEAT= (int)10497;
	CLAMP_TO_EDGE= (int)33071;
	MIRRORED_REPEAT= (int)33648;
	FLOAT_VEC2= (int)35664;
	FLOAT_VEC3= (int)35665;
	FLOAT_VEC4= (int)35666;
	INT_VEC2= (int)35667;
	INT_VEC3= (int)35668;
	INT_VEC4= (int)35669;
	BOOL= (int)35670;
	BOOL_VEC2= (int)35671;
	BOOL_VEC3= (int)35672;
	BOOL_VEC4= (int)35673;
	FLOAT_MAT2= (int)35674;
	FLOAT_MAT3= (int)35675;
	FLOAT_MAT4= (int)35676;
	SAMPLER_2D= (int)35678;
	SAMPLER_CUBE= (int)35680;
	VERTEX_ATTRIB_ARRAY_ENABLED= (int)34338;
	VERTEX_ATTRIB_ARRAY_SIZE= (int)34339;
	VERTEX_ATTRIB_ARRAY_STRIDE= (int)34340;
	VERTEX_ATTRIB_ARRAY_TYPE= (int)34341;
	VERTEX_ATTRIB_ARRAY_NORMALIZED= (int)34922;
	VERTEX_ATTRIB_ARRAY_POINTER= (int)34373;
	VERTEX_ATTRIB_ARRAY_BUFFER_BINDING= (int)34975;
	VERTEX_PROGRAM_POINT_SIZE= (int)34370;
	POINT_SPRITE= (int)34913;
	COMPILE_STATUS= (int)35713;
	LOW_FLOAT= (int)36336;
	MEDIUM_FLOAT= (int)36337;
	HIGH_FLOAT= (int)36338;
	LOW_INT= (int)36339;
	MEDIUM_INT= (int)36340;
	HIGH_INT= (int)36341;
	FRAMEBUFFER= (int)36160;
	RENDERBUFFER= (int)36161;
	RGBA4= (int)32854;
	RGB5_A1= (int)32855;
	RGB565= (int)36194;
	DEPTH_COMPONENT16= (int)33189;
	STENCIL_INDEX= (int)6401;
	STENCIL_INDEX8= (int)36168;
	DEPTH_STENCIL= (int)34041;
	RENDERBUFFER_WIDTH= (int)36162;
	RENDERBUFFER_HEIGHT= (int)36163;
	RENDERBUFFER_INTERNAL_FORMAT= (int)36164;
	RENDERBUFFER_RED_SIZE= (int)36176;
	RENDERBUFFER_GREEN_SIZE= (int)36177;
	RENDERBUFFER_BLUE_SIZE= (int)36178;
	RENDERBUFFER_ALPHA_SIZE= (int)36179;
	RENDERBUFFER_DEPTH_SIZE= (int)36180;
	RENDERBUFFER_STENCIL_SIZE= (int)36181;
	FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE= (int)36048;
	FRAMEBUFFER_ATTACHMENT_OBJECT_NAME= (int)36049;
	FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL= (int)36050;
	FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE= (int)36051;
	COLOR_ATTACHMENT0= (int)36064;
	DEPTH_ATTACHMENT= (int)36096;
	STENCIL_ATTACHMENT= (int)36128;
	DEPTH_STENCIL_ATTACHMENT= (int)33306;
	NONE= (int)0;
	FRAMEBUFFER_COMPLETE= (int)36053;
	FRAMEBUFFER_INCOMPLETE_ATTACHMENT= (int)36054;
	FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT= (int)36055;
	FRAMEBUFFER_INCOMPLETE_DIMENSIONS= (int)36057;
	FRAMEBUFFER_UNSUPPORTED= (int)36061;
	FRAMEBUFFER_BINDING= (int)36006;
	RENDERBUFFER_BINDING= (int)36007;
	MAX_RENDERBUFFER_SIZE= (int)34024;
	INVALID_FRAMEBUFFER_OPERATION= (int)1286;
	UNPACK_FLIP_Y_WEBGL= (int)37440;
	UNPACK_PREMULTIPLY_ALPHA_WEBGL= (int)37441;
	CONTEXT_LOST_WEBGL= (int)37442;
	UNPACK_COLORSPACE_CONVERSION_WEBGL= (int)37443;
	BROWSER_DEFAULT_WEBGL= (int)37444;
	lime_gl_active_texture= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_active_texture"),(int)1);
	lime_gl_attach_shader= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_attach_shader"),(int)2);
	lime_gl_bind_attrib_location= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_bind_attrib_location"),(int)3);
	lime_gl_bind_bitmap_data_texture= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_bind_bitmap_data_texture"),(int)1);
	lime_gl_bind_buffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_bind_buffer"),(int)2);
	lime_gl_bind_framebuffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_bind_framebuffer"),(int)2);
	lime_gl_bind_renderbuffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_bind_renderbuffer"),(int)2);
	lime_gl_bind_texture= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_bind_texture"),(int)2);
	lime_gl_blend_color= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_blend_color"),(int)4);
	lime_gl_blend_equation= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_blend_equation"),(int)1);
	lime_gl_blend_equation_separate= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_blend_equation_separate"),(int)2);
	lime_gl_blend_func= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_blend_func"),(int)2);
	lime_gl_blend_func_separate= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_blend_func_separate"),(int)4);
	lime_gl_buffer_data= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_buffer_data"),(int)5);
	lime_gl_buffer_sub_data= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_buffer_sub_data"),(int)5);
	lime_gl_check_framebuffer_status= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_check_framebuffer_status"),(int)1);
	lime_gl_clear= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_clear"),(int)1);
	lime_gl_clear_color= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_clear_color"),(int)4);
	lime_gl_clear_depth= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_clear_depth"),(int)1);
	lime_gl_clear_stencil= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_clear_stencil"),(int)1);
	lime_gl_color_mask= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_color_mask"),(int)4);
	lime_gl_compile_shader= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_compile_shader"),(int)1);
	lime_gl_compressed_tex_image_2d= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_compressed_tex_image_2d"),(int)-1);
	lime_gl_compressed_tex_sub_image_2d= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_compressed_tex_sub_image_2d"),(int)-1);
	lime_gl_copy_tex_image_2d= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_copy_tex_image_2d"),(int)-1);
	lime_gl_copy_tex_sub_image_2d= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_copy_tex_sub_image_2d"),(int)-1);
	lime_gl_create_buffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_create_buffer"),(int)0);
	lime_gl_create_framebuffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_create_framebuffer"),(int)0);
	lime_gl_create_program= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_create_program"),(int)0);
	lime_gl_create_render_buffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_create_render_buffer"),(int)0);
	lime_gl_create_shader= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_create_shader"),(int)1);
	lime_gl_create_texture= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_create_texture"),(int)0);
	lime_gl_cull_face= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_cull_face"),(int)1);
	lime_gl_delete_buffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_delete_buffer"),(int)1);
	lime_gl_delete_framebuffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_delete_framebuffer"),(int)1);
	lime_gl_delete_program= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_delete_program"),(int)1);
	lime_gl_delete_render_buffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_delete_render_buffer"),(int)1);
	lime_gl_delete_shader= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_delete_shader"),(int)1);
	lime_gl_delete_texture= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_delete_texture"),(int)1);
	lime_gl_depth_func= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_depth_func"),(int)1);
	lime_gl_depth_mask= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_depth_mask"),(int)1);
	lime_gl_depth_range= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_depth_range"),(int)2);
	lime_gl_detach_shader= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_detach_shader"),(int)2);
	lime_gl_disable= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_disable"),(int)1);
	lime_gl_disable_vertex_attrib_array= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_disable_vertex_attrib_array"),(int)1);
	lime_gl_draw_arrays= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_draw_arrays"),(int)3);
	lime_gl_draw_elements= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_draw_elements"),(int)4);
	lime_gl_enable= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_enable"),(int)1);
	lime_gl_enable_vertex_attrib_array= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_enable_vertex_attrib_array"),(int)1);
	lime_gl_finish= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_finish"),(int)0);
	lime_gl_flush= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_flush"),(int)0);
	lime_gl_framebuffer_renderbuffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_framebuffer_renderbuffer"),(int)4);
	lime_gl_framebuffer_texture2D= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_framebuffer_texture2D"),(int)5);
	lime_gl_front_face= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_front_face"),(int)1);
	lime_gl_generate_mipmap= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_generate_mipmap"),(int)1);
	lime_gl_get_active_attrib= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_active_attrib"),(int)2);
	lime_gl_get_active_uniform= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_active_uniform"),(int)2);
	lime_gl_get_attrib_location= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_attrib_location"),(int)2);
	lime_gl_get_buffer_paramerter= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_buffer_paramerter"),(int)2);
	lime_gl_get_context_attributes= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_context_attributes"),(int)0);
	lime_gl_get_error= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_error"),(int)0);
	lime_gl_get_framebuffer_attachment_parameter= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_framebuffer_attachment_parameter"),(int)3);
	lime_gl_get_parameter= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_parameter"),(int)1);
	lime_gl_get_program_info_log= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_program_info_log"),(int)1);
	lime_gl_get_program_parameter= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_program_parameter"),(int)2);
	lime_gl_get_render_buffer_parameter= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_render_buffer_parameter"),(int)2);
	lime_gl_get_shader_info_log= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_shader_info_log"),(int)1);
	lime_gl_get_shader_parameter= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_shader_parameter"),(int)2);
	lime_gl_get_shader_precision_format= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_shader_precision_format"),(int)2);
	lime_gl_get_shader_source= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_shader_source"),(int)1);
	lime_gl_get_supported_extensions= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_supported_extensions"),(int)1);
	lime_gl_get_tex_parameter= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_tex_parameter"),(int)2);
	lime_gl_get_uniform= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_uniform"),(int)2);
	lime_gl_get_uniform_location= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_uniform_location"),(int)2);
	lime_gl_get_vertex_attrib= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_vertex_attrib"),(int)2);
	lime_gl_get_vertex_attrib_offset= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_get_vertex_attrib_offset"),(int)2);
	lime_gl_hint= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_hint"),(int)2);
	lime_gl_is_buffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_is_buffer"),(int)1);
	lime_gl_is_enabled= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_is_enabled"),(int)1);
	lime_gl_is_framebuffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_is_framebuffer"),(int)1);
	lime_gl_is_program= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_is_program"),(int)1);
	lime_gl_is_renderbuffer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_is_renderbuffer"),(int)1);
	lime_gl_is_shader= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_is_shader"),(int)1);
	lime_gl_is_texture= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_is_texture"),(int)1);
	lime_gl_line_width= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_line_width"),(int)1);
	lime_gl_link_program= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_link_program"),(int)1);
	lime_gl_pixel_storei= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_pixel_storei"),(int)2);
	lime_gl_polygon_offset= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_polygon_offset"),(int)2);
	lime_gl_read_pixels= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_read_pixels"),(int)-1);
	lime_gl_renderbuffer_storage= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_renderbuffer_storage"),(int)4);
	lime_gl_sample_coverage= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_sample_coverage"),(int)2);
	lime_gl_scissor= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_scissor"),(int)4);
	lime_gl_shader_source= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_shader_source"),(int)2);
	lime_gl_stencil_func= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_stencil_func"),(int)3);
	lime_gl_stencil_func_separate= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_stencil_func_separate"),(int)4);
	lime_gl_stencil_mask= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_stencil_mask"),(int)1);
	lime_gl_stencil_mask_separate= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_stencil_mask_separate"),(int)2);
	lime_gl_stencil_op= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_stencil_op"),(int)3);
	lime_gl_stencil_op_separate= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_stencil_op_separate"),(int)4);
	lime_gl_tex_image_2d= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_tex_image_2d"),(int)-1);
	lime_gl_tex_parameterf= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_tex_parameterf"),(int)3);
	lime_gl_tex_parameteri= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_tex_parameteri"),(int)3);
	lime_gl_tex_sub_image_2d= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_tex_sub_image_2d"),(int)-1);
	lime_gl_uniform1f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform1f"),(int)2);
	lime_gl_uniform1fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform1fv"),(int)2);
	lime_gl_uniform1i= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform1i"),(int)2);
	lime_gl_uniform1iv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform1iv"),(int)2);
	lime_gl_uniform2f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform2f"),(int)3);
	lime_gl_uniform2fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform2fv"),(int)2);
	lime_gl_uniform2i= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform2i"),(int)3);
	lime_gl_uniform2iv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform2iv"),(int)2);
	lime_gl_uniform3f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform3f"),(int)4);
	lime_gl_uniform3fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform3fv"),(int)2);
	lime_gl_uniform3i= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform3i"),(int)4);
	lime_gl_uniform3iv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform3iv"),(int)2);
	lime_gl_uniform4f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform4f"),(int)5);
	lime_gl_uniform4fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform4fv"),(int)2);
	lime_gl_uniform4i= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform4i"),(int)5);
	lime_gl_uniform4iv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform4iv"),(int)2);
	lime_gl_uniform_matrix= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_uniform_matrix"),(int)4);
	lime_gl_use_program= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_use_program"),(int)1);
	lime_gl_validate_program= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_validate_program"),(int)1);
	lime_gl_version= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_version"),(int)0);
	lime_gl_vertex_attrib1f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib1f"),(int)2);
	lime_gl_vertex_attrib1fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib1fv"),(int)2);
	lime_gl_vertex_attrib2f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib2f"),(int)3);
	lime_gl_vertex_attrib2fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib2fv"),(int)2);
	lime_gl_vertex_attrib3f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib3f"),(int)4);
	lime_gl_vertex_attrib3fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib3fv"),(int)2);
	lime_gl_vertex_attrib4f= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib4f"),(int)5);
	lime_gl_vertex_attrib4fv= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib4fv"),(int)2);
	lime_gl_vertex_attrib_pointer= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_vertex_attrib_pointer"),(int)-1);
	lime_gl_viewport= ::openfl::gl::GL_obj::load(HX_CSTRING("lime_gl_viewport"),(int)4);
}

} // end namespace openfl
} // end namespace gl
