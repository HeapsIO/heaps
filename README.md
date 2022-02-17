# Heaps
_High Performance Game Framework_

[![Build Status](https://travis-ci.org/HeapsIO/heaps.svg?branch=master)](https://travis-ci.org/HeapsIO/heaps)
[![](https://img.shields.io/discord/162395145352904705.svg?logo=discord)](https://discordapp.com/invite/sWCGm33)

[![Heaps.io logo](https://raw.githubusercontent.com/HeapsIO/heaps.io/master/assets/logo/logo-heaps-color.png)](http://heaps.io)

**Heaps** is a cross platform graphics engine designed for high performance games. It's designed to leverage modern GPUs that are commonly available on desktop, mobile and consoles.

Heaps is currently working on:
- HTML5 (requires WebGL)
- Mobile (iOS, tvOS and Android)
- Desktop with OpenGL (Win/Linux/OSX) or DirectX (Windows only)
- Consoles (Nintendo Switch, Sony PS4, XBox One - requires being a registered developer)
- Flash Stage3D

_Warning: Heaps is low-level flexible engine made essentially in-house by ShiroGames, and features are implemented when needed. It's open source, but not community oriented. It's not for people who don't know how to work with a low-level engine, especially not for people who only used gamemaker/unity/ue/godot or any other engine that is extremely reliant on its editor. People who stick with Heaps are mainly ones who want more control over the internals, and they know how to build whatever they want on it. People without such experience 9 out of 10 times would have a really hard time with Heaps._

_Heaps does not contain optional game components often found in more dense game engines, such as: an entity system, a collision system, physics system, tween library, 'n so on. Those options are for you to integrate yourself or DIY, according to your individual project's needs. Instead, it provides you with a base io (input/output) framework, which of course includes input handling and output handling (rendering, shaders, etc.), but also core game components such as a scene tree, scene handling, cameras, 'n so on, for both 2D and 3D modules._

Community
---------

Ask questions or discuss on <https://community.heaps.io>

Chat on Discord <https://discord.gg/sWCGm33> or Gitter <https://gitter.im/heapsio/Lobby>

Samples
-------

In order to compile the samples, go to the `samples` directory and run `haxe gen.hxml`, this will generate a `build` directory containing project files for all samples.

To compile:
- For JS/WebGL: run `haxe [sample]_js.hxml`, then open `index.html` to run
- For [HashLink](https://hashlink.haxe.org): run `haxe [sample]_hl.hxml` then run `hl <sample>.hl` to run (will use SDL, replace `-lib hlsdl` by `-lib hldx` in hxml to use DirectX)
- For Flash: run `haxe [sample]_swf.hxml`, then open `<sample>.swf` to run
- For Consoles, contact us: nicolas@haxe.org

Project files for [Visual Studio Code](https://code.visualstudio.com/) are also generated.

Get started!
------------
* [Installation](https://heaps.io/documentation/installation.html)
* [Live samples with source code](https://heaps.io/samples/)
* [Documentation](https://heaps.io/documentation/home.html)
* [API documentation](https://heaps.io/api/)
