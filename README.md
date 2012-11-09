Haxe 3D Engine
=========

A lightweight 3D Engine for Haxe.

Currently only supports Flash/Stage3D, but is abstracted to support other backends in the near future.

In order to setup the engine, you can do :

> var engine = new h3d.Engine();
> engine.onReady = startMyApp;
> engine.init();

Then in your render loop you can do :

> engine.begin();
> ... render objects ...
> engine.end()

Objects can be created using a combination of a `h3d.mat.Material` (shader and blendmode) and `h3d.prim.Primitive` (geometry).

You can look at available examples in `samples` directory.

2D GPU Engine
-------------

The `h2d` package contains classes that provides a complete 2D API that is built on top of `h3d`, and is then GPU accelerated.

It contains an object hierarchy which base class is `h2d.Sprite` and root is `h2d.Scene`

