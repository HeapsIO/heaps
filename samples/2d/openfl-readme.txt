About OpenFL

  OpenFL is the successor of NME, for Haxe 3+.
  
	Building a game or application with OpenFL is almost like writing for a single platform. However, 
	when you are ready to publish your application, you can choose between targets like iOS, webOS, 
	Android, Windows, Mac, Linux and Flash Player.

	Instead of using the lowest common denominator between platforms with a "universal" runtime, 
	OpenFL projects are compiled as SWF bytecode or C++ applications, using the Haxe language compiler 
	and the standard C++ compiler toolchain for each platform.
	
	Read more: 
	http://openfl.org/

Project configuration, libraries, classpaths
	
	OpenFL configuration is based on a XML file - it allows you very complex
	configurations depending on the target platform. There is no GUI for it.
	
	DO NOT modify FlashDevelop project properties as they will automatically be synchronized with the
	XML when you modify it.

Development

	OpenFL is encouraging to develop using the Flash API (ie. flash.display.Sprite) as in ActionScript 3.

	Just code like you would code a Flash application, with the limitation that you can only use
	the drawing API, bitmaps (see below) and TextFields. 
	
	However test often all the platforms you plan to target!
	
	In OpenFL 3.x, SWFs and videos aren't supported yet.

Assets

	Place all your images, sounds, fonts in /assets and access them in your code using the 
	global Assets class which abstracts assets management for all platforms:
	
		var img = new Bitmap(Assets.getBitmapData("assets/my-image.png"));
		addChild(img);
	
	Tutorials:
	https://github.com/openfl/openfl/wiki/Get-Started

Debugging

	By default your project targets Flash so you'll be able to add breakpoints and debug your app 
	like any AS3 project. 
	HTML5 target can be debugged in the browser - some browsers, like Chrome, support "script maps" 
	which let you interactively debug .hx code directly instead of the generated JS.
	There is however no interactive debugger yet for native targets.
	
Changing target platform

	For OpenFL projects, an additional drop-down menu appears in the main toolbar where you can choose
	a supported targets on Windows: flash, html5, windows, neko, android, webos, blackberry.
	You can also manually enter a custom target not in the list.
	
	Attention, for native targets you'll need to install additional compilers & SDKs. The compiler 
	will tell you in the Output panel what command to execute for that. More information here:
	https://github.com/openfl/openfl/wiki/Get-Started
	
Tips:
	- in C++ expect first compilation to be very long as it first compiles the whole OpenFL API,
	- if a change is not taken in account, delete everything in /bin to start a fresh compilation,
	- on mobile, Bitmap blitting is NOT performant,
	- use spritesheets and Tilesheet.drawTiles for optimal rendering performance.
