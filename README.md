Heaps
=====

[![Build Status](https://travis-ci.org/HeapsIO/heaps.svg?branch=master)](https://travis-ci.org/HeapsIO/heaps)

_High Performance Game Framework_

**Heaps** is a cross platform graphics engine designed for high performance games. It's designed to leverage modern GPUs that are commonly available on both desktop and mobile devices. The framework currently supports HTML5 WebGL, Flash Stage3D, native Mobile (iOS and Android) and Desktop with OpenGL.

Community
---------

Join us on Gitter https://gitter.im/heapsio/Lobby

Samples
-------

In order to compile the samples, go to the `samples` directory and run `haxe gen.hxml`, this will generate a `build` directory containing project files for all samples.

To compile:
- For JS/WebGL: run `haxe [sample]_js.hxml`, then open `index.html` to run
- For Flash: run `haxe [sample]_swf.hxml`, then open `<sample>.swf` to run
- For HashLink: run `haxe -lib hlsdl|hldx [sample]_hl.hxml` then run `hl <sample>.hl` to run (can use both SDL and DirectX libraries)
- For OpenFL/Lime: run `openfl test windows` into the sample directory -- OpenFL/Lime is not officially supported, we don't accept issues please send pull requests if you make some changes

Project files for [HaxeDevelop](http://haxedevelop.org) are also generated

----
* [Official website](http://heaps.io)
* [Documentation](https://github.com/ncannasse/heaps/wiki)
