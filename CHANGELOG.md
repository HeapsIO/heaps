## 1.6.0 (March XX, 2019)

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
