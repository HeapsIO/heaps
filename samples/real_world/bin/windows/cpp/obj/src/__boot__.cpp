#include <hxcpp.h>

#include <sys/io/FileSeek.h>
#include <sys/io/FileOutput.h>
#include <sys/io/FileInput.h>
#include <sys/io/File.h>
#include <sys/FileSystem.h>
#include <sys/_FileSystem/FileKind.h>
#include <openfl/utils/WeakRef.h>
#include <openfl/utils/UInt8Array.h>
#include <openfl/utils/Int16Array.h>
#include <openfl/utils/Float32Array.h>
#include <openfl/utils/ArrayBufferView.h>
#include <openfl/gl/GLTexture.h>
#include <openfl/gl/GLShader.h>
#include <openfl/gl/GLRenderbuffer.h>
#include <openfl/gl/GLProgram.h>
#include <openfl/gl/GLFramebuffer.h>
#include <openfl/gl/GLBuffer.h>
#include <openfl/gl/GLObject.h>
#include <openfl/gl/_GL/Float32Data_Impl_.h>
#include <openfl/events/SystemEvent.h>
#include <openfl/events/JoystickEvent.h>
#include <openfl/display/Tilesheet.h>
#include <openfl/display/OpenGLView.h>
#include <openfl/display/ManagedStage.h>
#include <openfl/display/DirectRenderer.h>
#include <openfl/AssetType.h>
#include <openfl/AssetData.h>
#include <openfl/Assets.h>
#include <openfl/AssetCache.h>
#include <hxd/text/Utf8Tools.h>
#include <hxd/res/TiledMap.h>
#include <hxd/res/Texture.h>
#include <hxd/res/Sound.h>
#include <hxd/res/NanoJpeg.h>
#include <hxd/res/_NanoJpeg/Component.h>
#include <hxd/res/_NanoJpeg/FastBytes_Impl_.h>
#include <hxd/res/Filter.h>
#include <hxd/res/Model.h>
#include <hxd/res/Loader.h>
#include <hxd/res/FontBuilder.h>
#include <hxd/res/Font.h>
#include <hxd/res/FileInput.h>
#include <hxd/res/EmbedFileSystem.h>
#include <hxd/res/_EmbedFileSystem/EmbedEntry.h>
#include <hxd/res/BytesFileEntry.h>
#include <hxd/res/FileEntry.h>
#include <hxd/res/BitmapFont.h>
#include <hxd/res/Any.h>
#include <hxd/res/Resource.h>
#include <hxd/res/_Any/SingleFileSystem.h>
#include <hxd/res/BytesFileSystem.h>
#include <hxd/res/FileSystem.h>
#include <hxd/poly2tri/Utils.h>
#include <hxd/poly2tri/Triangle.h>
#include <hxd/poly2tri/SweepContext.h>
#include <hxd/poly2tri/Sweep.h>
#include <hxd/poly2tri/Point.h>
#include <hxd/poly2tri/Orientation.h>
#include <hxd/poly2tri/Node.h>
#include <hxd/poly2tri/EdgeEvent.h>
#include <hxd/poly2tri/Edge.h>
#include <hxd/poly2tri/Constants.h>
#include <hxd/poly2tri/Basin.h>
#include <hxd/poly2tri/AdvancingFront.h>
#include <hxd/impl/Tmp.h>
#include <hxd/impl/Memory.h>
#include <hxd/impl/MemoryReader.h>
#include <hxd/impl/ArrayIterator.h>
#include <hxd/System.h>
#include <hxd/Cursor.h>
#include <hxd/Stage.h>
#include <hxd/Save.h>
#include <hxd/Res.h>
#include <hxd/Profiler.h>
#include <hxd/Pixels.h>
#include <hxd/Flags.h>
#include <hxd/PixelFormat.h>
#include <hxd/Math.h>
#include <hxd/_IndexBuffer/IndexBuffer_Impl_.h>
#include <hxd/_IndexBuffer/InnerIterator.h>
#include <hxd/_FloatBuffer/FloatBuffer_Impl_.h>
#include <hxd/_FloatBuffer/InnerIterator.h>
#include <hxd/Event.h>
#include <hxd/EventKind.h>
#include <hxd/Charset.h>
#include <hxd/_BytesBuffer/BytesBuffer_Impl_.h>
#include <hxd/ByteConversions.h>
#include <hxd/_BitmapData/BitmapData_Impl_.h>
#include <hxd/Assert.h>
#include <hxd/ArrayTools.h>
#include <haxe/zip/Uncompress.h>
#include <haxe/zip/FlushMode.h>
#include <haxe/zip/Compress.h>
#include <haxe/xml/Fast.h>
#include <haxe/xml/_Fast/NodeListAccess.h>
#include <haxe/xml/_Fast/HasNodeAccess.h>
#include <haxe/xml/_Fast/HasAttribAccess.h>
#include <haxe/xml/_Fast/AttribAccess.h>
#include <haxe/xml/_Fast/NodeAccess.h>
#include <haxe/io/Path.h>
#include <haxe/io/Error.h>
#include <haxe/io/Eof.h>
#include <haxe/io/BytesOutput.h>
#include <haxe/io/BytesInput.h>
#include <haxe/io/BytesBuffer.h>
#include <haxe/ds/WeakMap.h>
#include <haxe/ds/_Vector/Vector_Impl_.h>
#include <haxe/ds/StringMap.h>
#include <haxe/ds/ObjectMap.h>
#include <haxe/ds/_HashMap/HashMap_Impl_.h>
#include <haxe/ds/EnumValueMap.h>
#include <haxe/ds/TreeNode.h>
#include <haxe/ds/BalancedTree.h>
#include <haxe/crypto/Crc32.h>
#include <haxe/crypto/BaseCode.h>
#include <haxe/Utf8.h>
#include <haxe/Unserializer.h>
#include <haxe/Timer.h>
#include <haxe/Resource.h>
#include <haxe/_EnumFlags/EnumFlags_Impl_.h>
#include <haxe/CallStack.h>
#include <haxe/StackItem.h>
#include <h3d/scene/Skin.h>
#include <h3d/scene/Joint.h>
#include <h3d/scene/RenderContext.h>
#include <h3d/scene/MultiMaterial.h>
#include <h3d/scene/Mesh.h>
#include <h3d/scene/Object.h>
#include <h3d/prim/Plan2D.h>
#include <h3d/prim/FBXModel.h>
#include <h3d/prim/MeshPrimitive.h>
#include <h3d/prim/FBXBuffers.h>
#include <h3d/mat/Texture.h>
#include <h3d/mat/MeshMaterial.h>
#include <h3d/mat/MeshShader.h>
#include <h3d/mat/Material.h>
#include <h3d/mat/TextureFormat.h>
#include <h3d/mat/Wrap.h>
#include <h3d/mat/Filter.h>
#include <h3d/mat/MipMap.h>
#include <h3d/mat/Compare.h>
#include <h3d/mat/Blend.h>
#include <h3d/mat/Face.h>
#include <h3d/impl/ColorShader.h>
#include <h3d/impl/LineShader.h>
#include <h3d/impl/PointShader.h>
#include <h3d/impl/ShaderInstance.h>
#include <h3d/impl/Attribute.h>
#include <h3d/impl/Uniform.h>
#include <h3d/impl/ShaderType.h>
#include <h3d/impl/MemoryManager.h>
#include <h3d/impl/BigBuffer.h>
#include <h3d/impl/BigBufferFlag.h>
#include <h3d/impl/FreeCell.h>
#include <h3d/impl/Indexes.h>
#include <h3d/impl/GlDriver.h>
#include <openfl/gl/GL.h>
#include <haxe/Log.h>
#include <haxe/ds/IntMap.h>
#include <h3d/impl/UniformContext.h>
#include <h3d/impl/FBO.h>
#include <h3d/impl/GLActiveInfo.h>
#include <h3d/impl/Driver.h>
#include <h3d/impl/GLVB.h>
#include <h3d/impl/BufferOffset.h>
#include <h3d/impl/Buffer.h>
#include <h3d/fbx/XBXReader.h>
#include <h3d/fbx/Parser.h>
#include <h3d/fbx/_Parser/Token.h>
#include <h3d/fbx/Library.h>
#include <h3d/fbx/TimeMode.h>
#include <h3d/fbx/DefaultMatrixes.h>
#include <h3d/fbx/AnimationMode.h>
#include <h3d/fbx/Geometry.h>
#include <h3d/fbx/FBxTools.h>
#include <h3d/fbx/FbxNode.h>
#include <h3d/fbx/FbxProp.h>
#include <h3d/col/Point.h>
#include <h3d/col/Plane.h>
#include <h3d/col/Bounds.h>
#include <h3d/anim/Skin.h>
#include <h3d/anim/_Skin/Influence.h>
#include <h3d/anim/Joint.h>
#include <h3d/anim/MorphFrameAnimation.h>
#include <h3d/anim/MorphObject.h>
#include <h3d/anim/MorphShape.h>
#include <h3d/anim/LinearAnimation.h>
#include <h3d/anim/LinearObject.h>
#include <h3d/anim/LinearFrame.h>
#include <h3d/anim/FrameAnimation.h>
#include <h3d/anim/FrameObject.h>
#include <h3d/anim/Animation.h>
#include <h3d/anim/_Animation/AnimWait.h>
#include <h3d/anim/AnimatedObject.h>
#include <h3d/Vector.h>
#include <h3d/Quat.h>
#include <h3d/Matrix.h>
#include <h3d/Engine.h>
#include <h3d/Drawable.h>
#include <h3d/Camera.h>
#include <h2d/col/Point.h>
#include <h2d/col/Circle.h>
#include <h2d/col/Bounds.h>
#include <h2d/Tools.h>
#include <h2d/_Tools/CoreObjects.h>
#include <h2d/TileGroup.h>
#include <h2d/_TileGroup/TileLayerContent.h>
#include <h2d/Tile.h>
#include <h2d/Text.h>
#include <h2d/Align.h>
#include <h2d/SpriteBatch.h>
#include <h2d/BatchElement.h>
#include <h2d/Scene.h>
#include <h3d/IDrawable.h>
#include <h2d/Matrix.h>
#include <h2d/Layers.h>
#include <h2d/Interactive.h>
#include <h2d/Graphics.h>
#include <h2d/_Graphics/GraphicsContent.h>
#include <h3d/prim/Primitive.h>
#include <h2d/_Graphics/LinePoint.h>
#include <h2d/Font.h>
#include <h2d/FontChar.h>
#include <h2d/Kerning.h>
#include <h2d/DrawableShader.h>
#include <h3d/impl/Shader.h>
#include <h2d/BlendMode.h>
#include <h2d/Bitmap.h>
#include <h2d/Anim.h>
#include <h2d/Drawable.h>
#include <h2d/Sprite.h>
#include <format/tools/Inflate.h>
#include <format/tools/Deflate.h>
#include <format/png/Tools.h>
#include <format/png/Reader.h>
#include <format/png/Chunk.h>
#include <format/png/Color.h>
#include <flash/utils/Endian.h>
#include <flash/utils/CompressionAlgorithm.h>
#include <flash/utils/ByteArray.h>
#include <flash/utils/IDataInput.h>
#include <openfl/utils/IMemoryRange.h>
#include <flash/utils/IDataOutput.h>
#include <flash/ui/MultitouchInputMode.h>
#include <flash/ui/Multitouch.h>
#include <flash/ui/Keyboard.h>
#include <flash/text/TextLineMetrics.h>
#include <flash/text/TextFormat.h>
#include <flash/text/TextFieldType.h>
#include <flash/text/TextFieldAutoSize.h>
#include <flash/text/TextField.h>
#include <flash/text/GridFitType.h>
#include <flash/text/FontType.h>
#include <flash/text/FontStyle.h>
#include <flash/text/Font.h>
#include <flash/text/AntiAliasType.h>
#include <flash/system/SecurityDomain.h>
#include <flash/system/ScreenMode.h>
#include <flash/system/PixelFormat.h>
#include <flash/system/LoaderContext.h>
#include <flash/system/Capabilities.h>
#include <flash/system/ApplicationDomain.h>
#include <flash/net/URLVariables.h>
#include <flash/net/URLRequestMethod.h>
#include <flash/net/URLRequestHeader.h>
#include <flash/net/URLRequest.h>
#include <flash/net/URLLoaderDataFormat.h>
#include <flash/media/SoundTransform.h>
#include <flash/media/SoundLoaderContext.h>
#include <flash/media/AudioThreadState.h>
#include <flash/media/SoundChannel.h>
#include <flash/media/InternalAudioType.h>
#include <flash/media/Sound.h>
#include <flash/media/ID3Info.h>
#include <flash/geom/Vector3D.h>
#include <flash/geom/Transform.h>
#include <flash/geom/Rectangle.h>
#include <flash/geom/Point.h>
#include <flash/geom/Matrix3D.h>
#include <flash/geom/Matrix.h>
#include <flash/geom/ColorTransform.h>
#include <flash/filters/BitmapFilter.h>
#include <flash/events/UncaughtErrorEvents.h>
#include <flash/events/UncaughtErrorEvent.h>
#include <flash/events/SampleDataEvent.h>
#include <flash/events/ProgressEvent.h>
#include <flash/events/KeyboardEvent.h>
#include <flash/events/IOErrorEvent.h>
#include <flash/events/HTTPStatusEvent.h>
#include <flash/events/FocusEvent.h>
#include <flash/events/EventPhase.h>
#include <flash/events/Listener.h>
#include <flash/events/ErrorEvent.h>
#include <flash/events/TextEvent.h>
#include <flash/errors/RangeError.h>
#include <flash/errors/EOFError.h>
#include <flash/errors/ArgumentError.h>
#include <flash/errors/Error.h>
#include <flash/display/TriangleCulling.h>
#include <flash/display/StageScaleMode.h>
#include <flash/display/StageQuality.h>
#include <flash/display/StageDisplayState.h>
#include <flash/display/StageAlign.h>
#include <flash/display/TouchInfo.h>
#include <flash/display/Stage.h>
#include <flash/events/TouchEvent.h>
#include <flash/events/MouseEvent.h>
#include <flash/events/Event.h>
#include <flash/display/SpreadMethod.h>
#include <flash/display/Shape.h>
#include <flash/display/PixelSnapping.h>
#include <flash/display/MovieClip.h>
#include <flash/display/LoaderInfo.h>
#include <flash/net/URLLoader.h>
#include <flash/display/Loader.h>
#include <flash/display/Sprite.h>
#include <flash/display/LineScaleMode.h>
#include <flash/display/JointStyle.h>
#include <flash/display/InterpolationMethod.h>
#include <flash/display/IGraphicsData.h>
#include <flash/display/GraphicsPathWinding.h>
#include <flash/display/Graphics.h>
#include <flash/display/GradientType.h>
#include <flash/display/FrameLabel.h>
#include <flash/display/DisplayObjectContainer.h>
#include <flash/display/InteractiveObject.h>
#include <flash/display/CapsStyle.h>
#include <flash/display/BlendMode.h>
#include <flash/display/OptimizedPerlin.h>
#include <flash/display/BitmapData.h>
#include <flash/display/Bitmap.h>
#include <flash/display/DisplayObject.h>
#include <flash/display/IBitmapDrawable.h>
#include <flash/events/EventDispatcher.h>
#include <flash/events/IEventDispatcher.h>
#include <flash/_Vector/Vector_Impl_.h>
#include <flash/Memory.h>
#include <flash/Lib.h>
#include <sys/io/_Process/Stdout.h>
#include <haxe/io/Input.h>
#include <haxe/io/Bytes.h>
#include <sys/io/_Process/Stdin.h>
#include <haxe/io/Output.h>
#include <sys/io/Process.h>
#include <cpp/vm/Thread.h>
#include <cpp/vm/Mutex.h>
#include <cpp/rtti/FieldNumericIntegerLookup.h>
#include <cpp/NativeArray.h>
#include <Xml.h>
#include <XmlType.h>
#include <_UInt/UInt_Impl_.h>
#include <Type.h>
#include <ValueType.h>
#include <Sys.h>
#include <StringTools.h>
#include <StringBuf.h>
#include <Std.h>
#include <Reflect.h>
#include <IMap.h>
#include <List.h>
#include <Lambda.h>
#include <IntIterator.h>
#include <EReg.h>
#include <cpp/Lib.h>
#include <DefaultAssetLibrary.h>
#include <_Map/Map_Impl_.h>
#include <openfl/AssetLibrary.h>
#include <Date.h>
#include <DocumentClass.h>
#include <Demo.h>
#include <ApplicationMain.h>

void __files__boot();

void __boot_all()
{
__files__boot();
hx::RegisterResources( hx::GetResources() );
::sys::io::FileSeek_obj::__register();
::sys::io::FileOutput_obj::__register();
::sys::io::FileInput_obj::__register();
::sys::io::File_obj::__register();
::sys::FileSystem_obj::__register();
::sys::_FileSystem::FileKind_obj::__register();
::openfl::utils::WeakRef_obj::__register();
::openfl::utils::UInt8Array_obj::__register();
::openfl::utils::Int16Array_obj::__register();
::openfl::utils::Float32Array_obj::__register();
::openfl::utils::ArrayBufferView_obj::__register();
::openfl::gl::GLTexture_obj::__register();
::openfl::gl::GLShader_obj::__register();
::openfl::gl::GLRenderbuffer_obj::__register();
::openfl::gl::GLProgram_obj::__register();
::openfl::gl::GLFramebuffer_obj::__register();
::openfl::gl::GLBuffer_obj::__register();
::openfl::gl::GLObject_obj::__register();
::openfl::gl::_GL::Float32Data_Impl__obj::__register();
::openfl::events::SystemEvent_obj::__register();
::openfl::events::JoystickEvent_obj::__register();
::openfl::display::Tilesheet_obj::__register();
::openfl::display::OpenGLView_obj::__register();
::openfl::display::ManagedStage_obj::__register();
::openfl::display::DirectRenderer_obj::__register();
::openfl::AssetType_obj::__register();
::openfl::AssetData_obj::__register();
::openfl::Assets_obj::__register();
::openfl::AssetCache_obj::__register();
::hxd::text::Utf8Tools_obj::__register();
::hxd::res::TiledMap_obj::__register();
::hxd::res::Texture_obj::__register();
::hxd::res::Sound_obj::__register();
::hxd::res::NanoJpeg_obj::__register();
::hxd::res::_NanoJpeg::Component_obj::__register();
::hxd::res::_NanoJpeg::FastBytes_Impl__obj::__register();
::hxd::res::Filter_obj::__register();
::hxd::res::Model_obj::__register();
::hxd::res::Loader_obj::__register();
::hxd::res::FontBuilder_obj::__register();
::hxd::res::Font_obj::__register();
::hxd::res::FileInput_obj::__register();
::hxd::res::EmbedFileSystem_obj::__register();
::hxd::res::_EmbedFileSystem::EmbedEntry_obj::__register();
::hxd::res::BytesFileEntry_obj::__register();
::hxd::res::FileEntry_obj::__register();
::hxd::res::BitmapFont_obj::__register();
::hxd::res::Any_obj::__register();
::hxd::res::Resource_obj::__register();
::hxd::res::_Any::SingleFileSystem_obj::__register();
::hxd::res::BytesFileSystem_obj::__register();
::hxd::res::FileSystem_obj::__register();
::hxd::poly2tri::Utils_obj::__register();
::hxd::poly2tri::Triangle_obj::__register();
::hxd::poly2tri::SweepContext_obj::__register();
::hxd::poly2tri::Sweep_obj::__register();
::hxd::poly2tri::Point_obj::__register();
::hxd::poly2tri::Orientation_obj::__register();
::hxd::poly2tri::Node_obj::__register();
::hxd::poly2tri::EdgeEvent_obj::__register();
::hxd::poly2tri::Edge_obj::__register();
::hxd::poly2tri::Constants_obj::__register();
::hxd::poly2tri::Basin_obj::__register();
::hxd::poly2tri::AdvancingFront_obj::__register();
::hxd::impl::Tmp_obj::__register();
::hxd::impl::Memory_obj::__register();
::hxd::impl::MemoryReader_obj::__register();
::hxd::impl::ArrayIterator_obj::__register();
::hxd::System_obj::__register();
::hxd::Cursor_obj::__register();
::hxd::Stage_obj::__register();
::hxd::Save_obj::__register();
::hxd::Res_obj::__register();
::hxd::Profiler_obj::__register();
::hxd::Pixels_obj::__register();
::hxd::Flags_obj::__register();
::hxd::PixelFormat_obj::__register();
::hxd::Math_obj::__register();
::hxd::_IndexBuffer::IndexBuffer_Impl__obj::__register();
::hxd::_IndexBuffer::InnerIterator_obj::__register();
::hxd::_FloatBuffer::FloatBuffer_Impl__obj::__register();
::hxd::_FloatBuffer::InnerIterator_obj::__register();
::hxd::Event_obj::__register();
::hxd::EventKind_obj::__register();
::hxd::Charset_obj::__register();
::hxd::_BytesBuffer::BytesBuffer_Impl__obj::__register();
::hxd::ByteConversions_obj::__register();
::hxd::_BitmapData::BitmapData_Impl__obj::__register();
::hxd::Assert_obj::__register();
::hxd::ArrayTools_obj::__register();
::haxe::zip::Uncompress_obj::__register();
::haxe::zip::FlushMode_obj::__register();
::haxe::zip::Compress_obj::__register();
::haxe::xml::Fast_obj::__register();
::haxe::xml::_Fast::NodeListAccess_obj::__register();
::haxe::xml::_Fast::HasNodeAccess_obj::__register();
::haxe::xml::_Fast::HasAttribAccess_obj::__register();
::haxe::xml::_Fast::AttribAccess_obj::__register();
::haxe::xml::_Fast::NodeAccess_obj::__register();
::haxe::io::Path_obj::__register();
::haxe::io::Error_obj::__register();
::haxe::io::Eof_obj::__register();
::haxe::io::BytesOutput_obj::__register();
::haxe::io::BytesInput_obj::__register();
::haxe::io::BytesBuffer_obj::__register();
::haxe::ds::WeakMap_obj::__register();
::haxe::ds::_Vector::Vector_Impl__obj::__register();
::haxe::ds::StringMap_obj::__register();
::haxe::ds::ObjectMap_obj::__register();
::haxe::ds::_HashMap::HashMap_Impl__obj::__register();
::haxe::ds::EnumValueMap_obj::__register();
::haxe::ds::TreeNode_obj::__register();
::haxe::ds::BalancedTree_obj::__register();
::haxe::crypto::Crc32_obj::__register();
::haxe::crypto::BaseCode_obj::__register();
::haxe::Utf8_obj::__register();
::haxe::Unserializer_obj::__register();
::haxe::Timer_obj::__register();
::haxe::Resource_obj::__register();
::haxe::_EnumFlags::EnumFlags_Impl__obj::__register();
::haxe::CallStack_obj::__register();
::haxe::StackItem_obj::__register();
::h3d::scene::Skin_obj::__register();
::h3d::scene::Joint_obj::__register();
::h3d::scene::RenderContext_obj::__register();
::h3d::scene::MultiMaterial_obj::__register();
::h3d::scene::Mesh_obj::__register();
::h3d::scene::Object_obj::__register();
::h3d::prim::Plan2D_obj::__register();
::h3d::prim::FBXModel_obj::__register();
::h3d::prim::MeshPrimitive_obj::__register();
::h3d::prim::FBXBuffers_obj::__register();
::h3d::mat::Texture_obj::__register();
::h3d::mat::MeshMaterial_obj::__register();
::h3d::mat::MeshShader_obj::__register();
::h3d::mat::Material_obj::__register();
::h3d::mat::TextureFormat_obj::__register();
::h3d::mat::Wrap_obj::__register();
::h3d::mat::Filter_obj::__register();
::h3d::mat::MipMap_obj::__register();
::h3d::mat::Compare_obj::__register();
::h3d::mat::Blend_obj::__register();
::h3d::mat::Face_obj::__register();
::h3d::impl::ColorShader_obj::__register();
::h3d::impl::LineShader_obj::__register();
::h3d::impl::PointShader_obj::__register();
::h3d::impl::ShaderInstance_obj::__register();
::h3d::impl::Attribute_obj::__register();
::h3d::impl::Uniform_obj::__register();
::h3d::impl::ShaderType_obj::__register();
::h3d::impl::MemoryManager_obj::__register();
::h3d::impl::BigBuffer_obj::__register();
::h3d::impl::BigBufferFlag_obj::__register();
::h3d::impl::FreeCell_obj::__register();
::h3d::impl::Indexes_obj::__register();
::h3d::impl::GlDriver_obj::__register();
::openfl::gl::GL_obj::__register();
::haxe::Log_obj::__register();
::haxe::ds::IntMap_obj::__register();
::h3d::impl::UniformContext_obj::__register();
::h3d::impl::FBO_obj::__register();
::h3d::impl::GLActiveInfo_obj::__register();
::h3d::impl::Driver_obj::__register();
::h3d::impl::GLVB_obj::__register();
::h3d::impl::BufferOffset_obj::__register();
::h3d::impl::Buffer_obj::__register();
::h3d::fbx::XBXReader_obj::__register();
::h3d::fbx::Parser_obj::__register();
::h3d::fbx::_Parser::Token_obj::__register();
::h3d::fbx::Library_obj::__register();
::h3d::fbx::TimeMode_obj::__register();
::h3d::fbx::DefaultMatrixes_obj::__register();
::h3d::fbx::AnimationMode_obj::__register();
::h3d::fbx::Geometry_obj::__register();
::h3d::fbx::FBxTools_obj::__register();
::h3d::fbx::FbxNode_obj::__register();
::h3d::fbx::FbxProp_obj::__register();
::h3d::col::Point_obj::__register();
::h3d::col::Plane_obj::__register();
::h3d::col::Bounds_obj::__register();
::h3d::anim::Skin_obj::__register();
::h3d::anim::_Skin::Influence_obj::__register();
::h3d::anim::Joint_obj::__register();
::h3d::anim::MorphFrameAnimation_obj::__register();
::h3d::anim::MorphObject_obj::__register();
::h3d::anim::MorphShape_obj::__register();
::h3d::anim::LinearAnimation_obj::__register();
::h3d::anim::LinearObject_obj::__register();
::h3d::anim::LinearFrame_obj::__register();
::h3d::anim::FrameAnimation_obj::__register();
::h3d::anim::FrameObject_obj::__register();
::h3d::anim::Animation_obj::__register();
::h3d::anim::_Animation::AnimWait_obj::__register();
::h3d::anim::AnimatedObject_obj::__register();
::h3d::Vector_obj::__register();
::h3d::Quat_obj::__register();
::h3d::Matrix_obj::__register();
::h3d::Engine_obj::__register();
::h3d::Drawable_obj::__register();
::h3d::Camera_obj::__register();
::h2d::col::Point_obj::__register();
::h2d::col::Circle_obj::__register();
::h2d::col::Bounds_obj::__register();
::h2d::Tools_obj::__register();
::h2d::_Tools::CoreObjects_obj::__register();
::h2d::TileGroup_obj::__register();
::h2d::_TileGroup::TileLayerContent_obj::__register();
::h2d::Tile_obj::__register();
::h2d::Text_obj::__register();
::h2d::Align_obj::__register();
::h2d::SpriteBatch_obj::__register();
::h2d::BatchElement_obj::__register();
::h2d::Scene_obj::__register();
::h3d::IDrawable_obj::__register();
::h2d::Matrix_obj::__register();
::h2d::Layers_obj::__register();
::h2d::Interactive_obj::__register();
::h2d::Graphics_obj::__register();
::h2d::_Graphics::GraphicsContent_obj::__register();
::h3d::prim::Primitive_obj::__register();
::h2d::_Graphics::LinePoint_obj::__register();
::h2d::Font_obj::__register();
::h2d::FontChar_obj::__register();
::h2d::Kerning_obj::__register();
::h2d::DrawableShader_obj::__register();
::h3d::impl::Shader_obj::__register();
::h2d::BlendMode_obj::__register();
::h2d::Bitmap_obj::__register();
::h2d::Anim_obj::__register();
::h2d::Drawable_obj::__register();
::h2d::Sprite_obj::__register();
::format::tools::Inflate_obj::__register();
::format::tools::Deflate_obj::__register();
::format::png::Tools_obj::__register();
::format::png::Reader_obj::__register();
::format::png::Chunk_obj::__register();
::format::png::Color_obj::__register();
::flash::utils::Endian_obj::__register();
::flash::utils::CompressionAlgorithm_obj::__register();
::flash::utils::ByteArray_obj::__register();
::flash::utils::IDataInput_obj::__register();
::openfl::utils::IMemoryRange_obj::__register();
::flash::utils::IDataOutput_obj::__register();
::flash::ui::MultitouchInputMode_obj::__register();
::flash::ui::Multitouch_obj::__register();
::flash::ui::Keyboard_obj::__register();
::flash::text::TextLineMetrics_obj::__register();
::flash::text::TextFormat_obj::__register();
::flash::text::TextFieldType_obj::__register();
::flash::text::TextFieldAutoSize_obj::__register();
::flash::text::TextField_obj::__register();
::flash::text::GridFitType_obj::__register();
::flash::text::FontType_obj::__register();
::flash::text::FontStyle_obj::__register();
::flash::text::Font_obj::__register();
::flash::text::AntiAliasType_obj::__register();
::flash::system::SecurityDomain_obj::__register();
::flash::system::ScreenMode_obj::__register();
::flash::system::PixelFormat_obj::__register();
::flash::system::LoaderContext_obj::__register();
::flash::system::Capabilities_obj::__register();
::flash::system::ApplicationDomain_obj::__register();
::flash::net::URLVariables_obj::__register();
::flash::net::URLRequestMethod_obj::__register();
::flash::net::URLRequestHeader_obj::__register();
::flash::net::URLRequest_obj::__register();
::flash::net::URLLoaderDataFormat_obj::__register();
::flash::media::SoundTransform_obj::__register();
::flash::media::SoundLoaderContext_obj::__register();
::flash::media::AudioThreadState_obj::__register();
::flash::media::SoundChannel_obj::__register();
::flash::media::InternalAudioType_obj::__register();
::flash::media::Sound_obj::__register();
::flash::media::ID3Info_obj::__register();
::flash::geom::Vector3D_obj::__register();
::flash::geom::Transform_obj::__register();
::flash::geom::Rectangle_obj::__register();
::flash::geom::Point_obj::__register();
::flash::geom::Matrix3D_obj::__register();
::flash::geom::Matrix_obj::__register();
::flash::geom::ColorTransform_obj::__register();
::flash::filters::BitmapFilter_obj::__register();
::flash::events::UncaughtErrorEvents_obj::__register();
::flash::events::UncaughtErrorEvent_obj::__register();
::flash::events::SampleDataEvent_obj::__register();
::flash::events::ProgressEvent_obj::__register();
::flash::events::KeyboardEvent_obj::__register();
::flash::events::IOErrorEvent_obj::__register();
::flash::events::HTTPStatusEvent_obj::__register();
::flash::events::FocusEvent_obj::__register();
::flash::events::EventPhase_obj::__register();
::flash::events::Listener_obj::__register();
::flash::events::ErrorEvent_obj::__register();
::flash::events::TextEvent_obj::__register();
::flash::errors::RangeError_obj::__register();
::flash::errors::EOFError_obj::__register();
::flash::errors::ArgumentError_obj::__register();
::flash::errors::Error_obj::__register();
::flash::display::TriangleCulling_obj::__register();
::flash::display::StageScaleMode_obj::__register();
::flash::display::StageQuality_obj::__register();
::flash::display::StageDisplayState_obj::__register();
::flash::display::StageAlign_obj::__register();
::flash::display::TouchInfo_obj::__register();
::flash::display::Stage_obj::__register();
::flash::events::TouchEvent_obj::__register();
::flash::events::MouseEvent_obj::__register();
::flash::events::Event_obj::__register();
::flash::display::SpreadMethod_obj::__register();
::flash::display::Shape_obj::__register();
::flash::display::PixelSnapping_obj::__register();
::flash::display::MovieClip_obj::__register();
::flash::display::LoaderInfo_obj::__register();
::flash::net::URLLoader_obj::__register();
::flash::display::Loader_obj::__register();
::flash::display::Sprite_obj::__register();
::flash::display::LineScaleMode_obj::__register();
::flash::display::JointStyle_obj::__register();
::flash::display::InterpolationMethod_obj::__register();
::flash::display::IGraphicsData_obj::__register();
::flash::display::GraphicsPathWinding_obj::__register();
::flash::display::Graphics_obj::__register();
::flash::display::GradientType_obj::__register();
::flash::display::FrameLabel_obj::__register();
::flash::display::DisplayObjectContainer_obj::__register();
::flash::display::InteractiveObject_obj::__register();
::flash::display::CapsStyle_obj::__register();
::flash::display::BlendMode_obj::__register();
::flash::display::OptimizedPerlin_obj::__register();
::flash::display::BitmapData_obj::__register();
::flash::display::Bitmap_obj::__register();
::flash::display::DisplayObject_obj::__register();
::flash::display::IBitmapDrawable_obj::__register();
::flash::events::EventDispatcher_obj::__register();
::flash::events::IEventDispatcher_obj::__register();
::flash::_Vector::Vector_Impl__obj::__register();
::flash::Memory_obj::__register();
::flash::Lib_obj::__register();
::sys::io::_Process::Stdout_obj::__register();
::haxe::io::Input_obj::__register();
::haxe::io::Bytes_obj::__register();
::sys::io::_Process::Stdin_obj::__register();
::haxe::io::Output_obj::__register();
::sys::io::Process_obj::__register();
::cpp::vm::Thread_obj::__register();
::cpp::vm::Mutex_obj::__register();
::cpp::rtti::FieldNumericIntegerLookup_obj::__register();
::cpp::NativeArray_obj::__register();
::Xml_obj::__register();
::XmlType_obj::__register();
::_UInt::UInt_Impl__obj::__register();
::Type_obj::__register();
::ValueType_obj::__register();
::Sys_obj::__register();
::StringTools_obj::__register();
::StringBuf_obj::__register();
::Std_obj::__register();
::Reflect_obj::__register();
::IMap_obj::__register();
::List_obj::__register();
::Lambda_obj::__register();
::IntIterator_obj::__register();
::EReg_obj::__register();
::cpp::Lib_obj::__register();
::DefaultAssetLibrary_obj::__register();
::_Map::Map_Impl__obj::__register();
::openfl::AssetLibrary_obj::__register();
::Date_obj::__register();
::DocumentClass_obj::__register();
::Demo_obj::__register();
::ApplicationMain_obj::__register();
::Xml_obj::__init__();
::flash::ui::Multitouch_obj::__init__();
::flash::utils::ByteArray_obj::__init__();
::cpp::Lib_obj::__boot();
::EReg_obj::__boot();
::Xml_obj::__boot();
::cpp::NativeArray_obj::__boot();
::cpp::rtti::FieldNumericIntegerLookup_obj::__boot();
::cpp::vm::Mutex_obj::__boot();
::cpp::vm::Thread_obj::__boot();
::haxe::Log_obj::__boot();
::ApplicationMain_obj::__boot();
::Demo_obj::__boot();
::DocumentClass_obj::__boot();
::Date_obj::__boot();
::openfl::AssetLibrary_obj::__boot();
::_Map::Map_Impl__obj::__boot();
::DefaultAssetLibrary_obj::__boot();
::IntIterator_obj::__boot();
::Lambda_obj::__boot();
::List_obj::__boot();
::IMap_obj::__boot();
::Reflect_obj::__boot();
::Std_obj::__boot();
::StringBuf_obj::__boot();
::StringTools_obj::__boot();
::Sys_obj::__boot();
::ValueType_obj::__boot();
::Type_obj::__boot();
::_UInt::UInt_Impl__obj::__boot();
::XmlType_obj::__boot();
::sys::io::Process_obj::__boot();
::haxe::io::Output_obj::__boot();
::sys::io::_Process::Stdin_obj::__boot();
::haxe::io::Bytes_obj::__boot();
::haxe::io::Input_obj::__boot();
::sys::io::_Process::Stdout_obj::__boot();
::flash::Lib_obj::__boot();
::flash::Memory_obj::__boot();
::flash::_Vector::Vector_Impl__obj::__boot();
::flash::events::IEventDispatcher_obj::__boot();
::flash::events::EventDispatcher_obj::__boot();
::flash::display::IBitmapDrawable_obj::__boot();
::flash::display::DisplayObject_obj::__boot();
::flash::display::Bitmap_obj::__boot();
::flash::display::BitmapData_obj::__boot();
::flash::display::OptimizedPerlin_obj::__boot();
::flash::display::BlendMode_obj::__boot();
::flash::display::CapsStyle_obj::__boot();
::flash::display::InteractiveObject_obj::__boot();
::flash::display::DisplayObjectContainer_obj::__boot();
::flash::display::FrameLabel_obj::__boot();
::flash::display::GradientType_obj::__boot();
::flash::display::Graphics_obj::__boot();
::flash::display::GraphicsPathWinding_obj::__boot();
::flash::display::IGraphicsData_obj::__boot();
::flash::display::InterpolationMethod_obj::__boot();
::flash::display::JointStyle_obj::__boot();
::flash::display::LineScaleMode_obj::__boot();
::flash::display::Sprite_obj::__boot();
::flash::display::Loader_obj::__boot();
::flash::net::URLLoader_obj::__boot();
::flash::display::LoaderInfo_obj::__boot();
::flash::display::MovieClip_obj::__boot();
::flash::display::PixelSnapping_obj::__boot();
::flash::display::Shape_obj::__boot();
::flash::display::SpreadMethod_obj::__boot();
::flash::events::Event_obj::__boot();
::flash::events::MouseEvent_obj::__boot();
::flash::events::TouchEvent_obj::__boot();
::flash::display::Stage_obj::__boot();
::flash::display::TouchInfo_obj::__boot();
::flash::display::StageAlign_obj::__boot();
::flash::display::StageDisplayState_obj::__boot();
::flash::display::StageQuality_obj::__boot();
::flash::display::StageScaleMode_obj::__boot();
::flash::display::TriangleCulling_obj::__boot();
::flash::errors::Error_obj::__boot();
::flash::errors::ArgumentError_obj::__boot();
::flash::errors::EOFError_obj::__boot();
::flash::errors::RangeError_obj::__boot();
::flash::events::TextEvent_obj::__boot();
::flash::events::ErrorEvent_obj::__boot();
::flash::events::Listener_obj::__boot();
::flash::events::EventPhase_obj::__boot();
::flash::events::FocusEvent_obj::__boot();
::flash::events::HTTPStatusEvent_obj::__boot();
::flash::events::IOErrorEvent_obj::__boot();
::flash::events::KeyboardEvent_obj::__boot();
::flash::events::ProgressEvent_obj::__boot();
::flash::events::SampleDataEvent_obj::__boot();
::flash::events::UncaughtErrorEvent_obj::__boot();
::flash::events::UncaughtErrorEvents_obj::__boot();
::flash::filters::BitmapFilter_obj::__boot();
::flash::geom::ColorTransform_obj::__boot();
::flash::geom::Matrix_obj::__boot();
::flash::geom::Matrix3D_obj::__boot();
::flash::geom::Point_obj::__boot();
::flash::geom::Rectangle_obj::__boot();
::flash::geom::Transform_obj::__boot();
::flash::geom::Vector3D_obj::__boot();
::flash::media::ID3Info_obj::__boot();
::flash::media::Sound_obj::__boot();
::flash::media::InternalAudioType_obj::__boot();
::flash::media::SoundChannel_obj::__boot();
::flash::media::AudioThreadState_obj::__boot();
::flash::media::SoundLoaderContext_obj::__boot();
::flash::media::SoundTransform_obj::__boot();
::flash::net::URLLoaderDataFormat_obj::__boot();
::flash::net::URLRequest_obj::__boot();
::flash::net::URLRequestHeader_obj::__boot();
::flash::net::URLRequestMethod_obj::__boot();
::flash::net::URLVariables_obj::__boot();
::flash::system::ApplicationDomain_obj::__boot();
::flash::system::Capabilities_obj::__boot();
::flash::system::LoaderContext_obj::__boot();
::flash::system::PixelFormat_obj::__boot();
::flash::system::ScreenMode_obj::__boot();
::flash::system::SecurityDomain_obj::__boot();
::flash::text::AntiAliasType_obj::__boot();
::flash::text::Font_obj::__boot();
::flash::text::FontStyle_obj::__boot();
::flash::text::FontType_obj::__boot();
::flash::text::GridFitType_obj::__boot();
::flash::text::TextField_obj::__boot();
::flash::text::TextFieldAutoSize_obj::__boot();
::flash::text::TextFieldType_obj::__boot();
::flash::text::TextFormat_obj::__boot();
::flash::text::TextLineMetrics_obj::__boot();
::flash::ui::Keyboard_obj::__boot();
::flash::ui::Multitouch_obj::__boot();
::flash::ui::MultitouchInputMode_obj::__boot();
::flash::utils::IDataOutput_obj::__boot();
::openfl::utils::IMemoryRange_obj::__boot();
::flash::utils::IDataInput_obj::__boot();
::flash::utils::ByteArray_obj::__boot();
::flash::utils::CompressionAlgorithm_obj::__boot();
::flash::utils::Endian_obj::__boot();
::format::png::Color_obj::__boot();
::format::png::Chunk_obj::__boot();
::format::png::Reader_obj::__boot();
::format::png::Tools_obj::__boot();
::format::tools::Deflate_obj::__boot();
::format::tools::Inflate_obj::__boot();
::h2d::Sprite_obj::__boot();
::h2d::Drawable_obj::__boot();
::h2d::Anim_obj::__boot();
::h2d::Bitmap_obj::__boot();
::h2d::BlendMode_obj::__boot();
::h3d::impl::Shader_obj::__boot();
::h2d::DrawableShader_obj::__boot();
::h2d::Kerning_obj::__boot();
::h2d::FontChar_obj::__boot();
::h2d::Font_obj::__boot();
::h2d::_Graphics::LinePoint_obj::__boot();
::h3d::prim::Primitive_obj::__boot();
::h2d::_Graphics::GraphicsContent_obj::__boot();
::h2d::Graphics_obj::__boot();
::h2d::Interactive_obj::__boot();
::h2d::Layers_obj::__boot();
::h2d::Matrix_obj::__boot();
::h3d::IDrawable_obj::__boot();
::h2d::Scene_obj::__boot();
::h2d::BatchElement_obj::__boot();
::h2d::SpriteBatch_obj::__boot();
::h2d::Align_obj::__boot();
::h2d::Text_obj::__boot();
::h2d::Tile_obj::__boot();
::h2d::_TileGroup::TileLayerContent_obj::__boot();
::h2d::TileGroup_obj::__boot();
::h2d::_Tools::CoreObjects_obj::__boot();
::h2d::Tools_obj::__boot();
::h2d::col::Bounds_obj::__boot();
::h2d::col::Circle_obj::__boot();
::h2d::col::Point_obj::__boot();
::h3d::Camera_obj::__boot();
::h3d::Drawable_obj::__boot();
::h3d::Engine_obj::__boot();
::h3d::Matrix_obj::__boot();
::h3d::Quat_obj::__boot();
::h3d::Vector_obj::__boot();
::h3d::anim::AnimatedObject_obj::__boot();
::h3d::anim::_Animation::AnimWait_obj::__boot();
::h3d::anim::Animation_obj::__boot();
::h3d::anim::FrameObject_obj::__boot();
::h3d::anim::FrameAnimation_obj::__boot();
::h3d::anim::LinearFrame_obj::__boot();
::h3d::anim::LinearObject_obj::__boot();
::h3d::anim::LinearAnimation_obj::__boot();
::h3d::anim::MorphShape_obj::__boot();
::h3d::anim::MorphObject_obj::__boot();
::h3d::anim::MorphFrameAnimation_obj::__boot();
::h3d::anim::Joint_obj::__boot();
::h3d::anim::_Skin::Influence_obj::__boot();
::h3d::anim::Skin_obj::__boot();
::h3d::col::Bounds_obj::__boot();
::h3d::col::Plane_obj::__boot();
::h3d::col::Point_obj::__boot();
::h3d::fbx::FbxProp_obj::__boot();
::h3d::fbx::FbxNode_obj::__boot();
::h3d::fbx::FBxTools_obj::__boot();
::h3d::fbx::Geometry_obj::__boot();
::h3d::fbx::AnimationMode_obj::__boot();
::h3d::fbx::DefaultMatrixes_obj::__boot();
::h3d::fbx::TimeMode_obj::__boot();
::h3d::fbx::Library_obj::__boot();
::h3d::fbx::_Parser::Token_obj::__boot();
::h3d::fbx::Parser_obj::__boot();
::h3d::fbx::XBXReader_obj::__boot();
::h3d::impl::Buffer_obj::__boot();
::h3d::impl::BufferOffset_obj::__boot();
::h3d::impl::GLVB_obj::__boot();
::h3d::impl::Driver_obj::__boot();
::h3d::impl::GLActiveInfo_obj::__boot();
::h3d::impl::FBO_obj::__boot();
::h3d::impl::UniformContext_obj::__boot();
::haxe::ds::IntMap_obj::__boot();
::openfl::gl::GL_obj::__boot();
::h3d::impl::GlDriver_obj::__boot();
::h3d::impl::Indexes_obj::__boot();
::h3d::impl::FreeCell_obj::__boot();
::h3d::impl::BigBufferFlag_obj::__boot();
::h3d::impl::BigBuffer_obj::__boot();
::h3d::impl::MemoryManager_obj::__boot();
::h3d::impl::ShaderType_obj::__boot();
::h3d::impl::Uniform_obj::__boot();
::h3d::impl::Attribute_obj::__boot();
::h3d::impl::ShaderInstance_obj::__boot();
::h3d::impl::PointShader_obj::__boot();
::h3d::impl::LineShader_obj::__boot();
::h3d::impl::ColorShader_obj::__boot();
::h3d::mat::Face_obj::__boot();
::h3d::mat::Blend_obj::__boot();
::h3d::mat::Compare_obj::__boot();
::h3d::mat::MipMap_obj::__boot();
::h3d::mat::Filter_obj::__boot();
::h3d::mat::Wrap_obj::__boot();
::h3d::mat::TextureFormat_obj::__boot();
::h3d::mat::Material_obj::__boot();
::h3d::mat::MeshShader_obj::__boot();
::h3d::mat::MeshMaterial_obj::__boot();
::h3d::mat::Texture_obj::__boot();
::h3d::prim::FBXBuffers_obj::__boot();
::h3d::prim::MeshPrimitive_obj::__boot();
::h3d::prim::FBXModel_obj::__boot();
::h3d::prim::Plan2D_obj::__boot();
::h3d::scene::Object_obj::__boot();
::h3d::scene::Mesh_obj::__boot();
::h3d::scene::MultiMaterial_obj::__boot();
::h3d::scene::RenderContext_obj::__boot();
::h3d::scene::Joint_obj::__boot();
::h3d::scene::Skin_obj::__boot();
::haxe::StackItem_obj::__boot();
::haxe::CallStack_obj::__boot();
::haxe::_EnumFlags::EnumFlags_Impl__obj::__boot();
::haxe::Resource_obj::__boot();
::haxe::Timer_obj::__boot();
::haxe::Unserializer_obj::__boot();
::haxe::Utf8_obj::__boot();
::haxe::crypto::BaseCode_obj::__boot();
::haxe::crypto::Crc32_obj::__boot();
::haxe::ds::BalancedTree_obj::__boot();
::haxe::ds::TreeNode_obj::__boot();
::haxe::ds::EnumValueMap_obj::__boot();
::haxe::ds::_HashMap::HashMap_Impl__obj::__boot();
::haxe::ds::ObjectMap_obj::__boot();
::haxe::ds::StringMap_obj::__boot();
::haxe::ds::_Vector::Vector_Impl__obj::__boot();
::haxe::ds::WeakMap_obj::__boot();
::haxe::io::BytesBuffer_obj::__boot();
::haxe::io::BytesInput_obj::__boot();
::haxe::io::BytesOutput_obj::__boot();
::haxe::io::Eof_obj::__boot();
::haxe::io::Error_obj::__boot();
::haxe::io::Path_obj::__boot();
::haxe::xml::_Fast::NodeAccess_obj::__boot();
::haxe::xml::_Fast::AttribAccess_obj::__boot();
::haxe::xml::_Fast::HasAttribAccess_obj::__boot();
::haxe::xml::_Fast::HasNodeAccess_obj::__boot();
::haxe::xml::_Fast::NodeListAccess_obj::__boot();
::haxe::xml::Fast_obj::__boot();
::haxe::zip::Compress_obj::__boot();
::haxe::zip::FlushMode_obj::__boot();
::haxe::zip::Uncompress_obj::__boot();
::hxd::ArrayTools_obj::__boot();
::hxd::Assert_obj::__boot();
::hxd::_BitmapData::BitmapData_Impl__obj::__boot();
::hxd::ByteConversions_obj::__boot();
::hxd::_BytesBuffer::BytesBuffer_Impl__obj::__boot();
::hxd::Charset_obj::__boot();
::hxd::EventKind_obj::__boot();
::hxd::Event_obj::__boot();
::hxd::_FloatBuffer::InnerIterator_obj::__boot();
::hxd::_FloatBuffer::FloatBuffer_Impl__obj::__boot();
::hxd::_IndexBuffer::InnerIterator_obj::__boot();
::hxd::_IndexBuffer::IndexBuffer_Impl__obj::__boot();
::hxd::Math_obj::__boot();
::hxd::PixelFormat_obj::__boot();
::hxd::Flags_obj::__boot();
::hxd::Pixels_obj::__boot();
::hxd::Profiler_obj::__boot();
::hxd::Res_obj::__boot();
::hxd::Save_obj::__boot();
::hxd::Stage_obj::__boot();
::hxd::Cursor_obj::__boot();
::hxd::System_obj::__boot();
::hxd::impl::ArrayIterator_obj::__boot();
::hxd::impl::MemoryReader_obj::__boot();
::hxd::impl::Memory_obj::__boot();
::hxd::impl::Tmp_obj::__boot();
::hxd::poly2tri::AdvancingFront_obj::__boot();
::hxd::poly2tri::Basin_obj::__boot();
::hxd::poly2tri::Constants_obj::__boot();
::hxd::poly2tri::Edge_obj::__boot();
::hxd::poly2tri::EdgeEvent_obj::__boot();
::hxd::poly2tri::Node_obj::__boot();
::hxd::poly2tri::Orientation_obj::__boot();
::hxd::poly2tri::Point_obj::__boot();
::hxd::poly2tri::Sweep_obj::__boot();
::hxd::poly2tri::SweepContext_obj::__boot();
::hxd::poly2tri::Triangle_obj::__boot();
::hxd::poly2tri::Utils_obj::__boot();
::hxd::res::FileSystem_obj::__boot();
::hxd::res::BytesFileSystem_obj::__boot();
::hxd::res::_Any::SingleFileSystem_obj::__boot();
::hxd::res::Resource_obj::__boot();
::hxd::res::Any_obj::__boot();
::hxd::res::BitmapFont_obj::__boot();
::hxd::res::FileEntry_obj::__boot();
::hxd::res::BytesFileEntry_obj::__boot();
::hxd::res::_EmbedFileSystem::EmbedEntry_obj::__boot();
::hxd::res::EmbedFileSystem_obj::__boot();
::hxd::res::FileInput_obj::__boot();
::hxd::res::Font_obj::__boot();
::hxd::res::FontBuilder_obj::__boot();
::hxd::res::Loader_obj::__boot();
::hxd::res::Model_obj::__boot();
::hxd::res::Filter_obj::__boot();
::hxd::res::_NanoJpeg::FastBytes_Impl__obj::__boot();
::hxd::res::_NanoJpeg::Component_obj::__boot();
::hxd::res::NanoJpeg_obj::__boot();
::hxd::res::Sound_obj::__boot();
::hxd::res::Texture_obj::__boot();
::hxd::res::TiledMap_obj::__boot();
::hxd::text::Utf8Tools_obj::__boot();
::openfl::AssetCache_obj::__boot();
::openfl::Assets_obj::__boot();
::openfl::AssetData_obj::__boot();
::openfl::AssetType_obj::__boot();
::openfl::display::DirectRenderer_obj::__boot();
::openfl::display::ManagedStage_obj::__boot();
::openfl::display::OpenGLView_obj::__boot();
::openfl::display::Tilesheet_obj::__boot();
::openfl::events::JoystickEvent_obj::__boot();
::openfl::events::SystemEvent_obj::__boot();
::openfl::gl::_GL::Float32Data_Impl__obj::__boot();
::openfl::gl::GLObject_obj::__boot();
::openfl::gl::GLBuffer_obj::__boot();
::openfl::gl::GLFramebuffer_obj::__boot();
::openfl::gl::GLProgram_obj::__boot();
::openfl::gl::GLRenderbuffer_obj::__boot();
::openfl::gl::GLShader_obj::__boot();
::openfl::gl::GLTexture_obj::__boot();
::openfl::utils::ArrayBufferView_obj::__boot();
::openfl::utils::Float32Array_obj::__boot();
::openfl::utils::Int16Array_obj::__boot();
::openfl::utils::UInt8Array_obj::__boot();
::openfl::utils::WeakRef_obj::__boot();
::sys::_FileSystem::FileKind_obj::__boot();
::sys::FileSystem_obj::__boot();
::sys::io::File_obj::__boot();
::sys::io::FileInput_obj::__boot();
::sys::io::FileOutput_obj::__boot();
::sys::io::FileSeek_obj::__boot();
}

