## 1.9.0 (February 28, 2021)

HL:
* Fixes compatibility with Haxe 4.2 (requires 4.2.1)

2D:
* More DomKit APIs
* Flow overflow: Hidden and Scroll support
* Text.letterSpacing is now 0 by default
* New Camera implementation (@Yanrishatum)
* Allow different textures for Graphics/TileGroup/SpriteBatch using BatchDrawState (@Yanrishatum)
* <a> link support in HtmlText (@Azrou)

3D:
* Refactor PBR Renderer (begin/end), allow shader injection in RendererFX
* Support for Y-up exported FBX (auto convert to Z-up)
* Support for centimer exported FBX (auto convert to meters)
* Added Texture.lodBias support for mipmaps
* More detailed skin collider support based on joint bounding boxes
* Added HMD large index (models with >64K vertexes)
* PBR Forward support (@ShiroSmith)
* new MetchBatch implementation (unlimited instances)

HxSL:
* Added Mat2 type
* Added Array of textures support
* Added texture.size() / textureSize(tex) (@Yanrishatum)
* Added @borrow to import another shader var (@Yanrishatum)
* Added @sampler(groupName) to bypass 16 samplers DX limit

Other:
* Added DDS support for compressed/mipmaped/float textures
* Added HDR texture support
* More APIs/support for float/hdr/16 bit textures
* ... and many many other improvements

 
## 1.8.0 (April 7, 2020)

2D:
* DomKit 0.3 support, more domkit properties
* added DomKit inspector (h2d.domkit.Style.allowInspect)
* fixed Graphics.drawRect with lines (#776)
* delayed Text rebuild and HtmlText refactor (@Yanrishatum)
* added HtmlText.defaultFormatText
* Flow : allow absolute+align for components
* fixed interactive handling wrt not uniform scaling + rotation

3D:
* allow inheritance of culling collider
* added h3d.prim.Disc (@tong)
* fixes for single channel textures

Other:
* JS : new WebAudio Driver (@Yanrishatum)
* added _FragCoord in HxSL
* alloc position now capture full stack (-D track-alloc)
* added hxd.Pad.axisDeadZone
* ... and many many other fixes

## 1.7.0 (September 9, 2019)

2D:
* DomKit v2 support (direct h2d.Object.dom property with -lib domkit)
* added h2d.Scene.scaleMode (Pavel Alexandrov)
* added hxd.App.setCurrent to switch current App
* fixed JS fullscreen support

3D:
* HMDv3 - more compact animation data
* reference counting on h3d.prim.Primitive (Pavel Alexandrov)
* PCF shadows
* completed support for DXT textures
* changed pass sorting API

Other:
* compatibility with Haxe 4.0-RC4+
* fixed GL with unused inputs (was causing some issue with recent Chrome)
* faster serializer for hxsl data
* added HXSL texelFetch (Pavel Alexandrov)
* improved shader cache file, support mesh batch
* move prefabs handling from Heaps to Hide
* added resource baking capabilities
* ... and many many other fixes

## 1.6.0 (March 9, 2019)

2D:
* added DomKit support
* added h2d.Camera
* review h2d filters wrt alpha handling
* added h2d.Flow.layout
* support for SDF fonts
* support for sub pixel Tiles (various coordinates/sizes are now Float instead of Int)
* added h2d.Interactive.onReleaseOutside and .shape for custom shape handling
* h2d.Object.onParentChanged is now onHierarchyMoved
* handle multiple Interactive onOver

3D:
* added h3d.col.Capsule
* added h3d.col.Collider.inSphere + changed inFrustum
* added Driver.capturePixels sub region
* added h3d.scene.MeshBatch
* optimized shadows maps culling
* optimized internal pass lists handling
* moved h3d.scene.DirLight/PointLight/LightSystem/Renderer to h3d.scene.fwd package
* more work on pbr renderer and terrain system
* various optimizations (less allocations)

Other:
* [js] heaps now defaults to canvas instead of window for events
* review hxd.prefab.Prefab API
* added mp3 sound support
* added S3TC dds texture support
* new samples : Camera2D, Domkit, Flows, FXView, Interactive2D, MeshBatch, Lights

## 1.5.0 (October 25, 2018)

* haxe 4 preview5+ support
* h2d.Sprite becomes h2d.Object, and some other renaming
* hxd.Stage becomes hxd.Window
* improved JS audio (Pavel Alexandrov)
* added wireframe support to h3d Material (Pavel Alexandrov)
* changes in hxd.Timer : hxd.App.update dt is now in seconds
* h2d.Video JS support (Pavel Alexandrov)
* h2d.Particles "isRelative" support (Pavel Alexandrov)
* hxd.BitmapData drawLine implementation (TheTrueCalgari)
* and many other fixes

## 1.4.0 (October 1, 2018)

* haxe 4 preview5+ support
* added h2d.filter.Outline (Leo Bergman)
* added h2d.Graphics.drawEllipse (Josu Igoa)
* added JS custom cursors + hl/js animated cursors support (Pavel Alexandrov)
* JS sound quality fixes (Pavel Alexandrov)
* renamed h2d.Sprite to h2d.Object and some other API changes
* added HtmlText textAlign support (Pascal Peridont)
* added spot lights and shadows (pbr only)
* added point lights shadows
* added 32 bit indexes support
* added binary FBX support (Pavel Alexandrov)
* added instanced drawing support
* and many other fixes
## 1.3.0 (July 31, 2018)

* WebGL 2 support
* Added full PBR support
* Per Light shadows
* Faster Blur
* Added Prefabs for HIDE
* Added TGA support
* Maya FBX fixes
* ... and much more !

## previous versions

* everything else
