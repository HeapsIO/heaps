# Heaps  
_High Performance Game Framework_

[![Build Status](https://travis-ci.org/HeapsIO/heaps.svg?branch=master)](https://travis-ci.org/HeapsIO/heaps)

[![Heaps.io logo](https://raw.githubusercontent.com/HeapsIO/heaps.io/master/assets/logo/logo-heaps-color.png)](http://heaps.io)

**Heaps** is a cross platform graphics engine designed for high performance games. It's designed to leverage modern GPUs that are commonly available on desktop, mobile and consoles.

Heaps is currently working on:
- HTML5 (requires WebGL)
- Mobile (iOS, tvOS and Android)
- Desktop with OpenGL (Win/Linux/OSX) or DirectX (Windows only)
- Consoles (Nintendo Switch, Sony PS4, XBox One - requires being a registered developer)
- Flash Stage3D


Community
---------

Join us on Gitter <https://gitter.im/heapsio/Lobby>

Samples
-------

In order to compile the samples, go to the `samples` directory and run `haxe gen.hxml`, this will generate a `build` directory containing project files for all samples.

To compile:
- For JS/WebGL: run `haxe [sample]_js.hxml`, then open `index.html` to run
- For Flash: run `haxe [sample]_swf.hxml`, then open `<sample>.swf` to run
- For HashLink: run `haxe -lib hlsdl|hldx [sample]_hl.hxml` then run `hl <sample>.hl` to run (can use both SDL and DirectX libraries)
- For OpenFL/Lime: run `openfl test windows` into the sample directory -- OpenFL/Lime is not officially supported, we don't accept issues please send pull requests if you make some changes

Project files for [HaxeDevelop](http://haxedevelop.org) are also generated.

----
* [Official website](http://heaps.io)
* [Documentation](https://github.com/ncannasse/heaps/wiki)
