package h3d.impl;

#if render_graph
import h3d.Engine.DepthBinding;

class RenderGraph {
	static var enable = false;
	public static var frame : Frame;

	public static function start() {
		enable = true;
		frame = new Frame();
		var e = h3d.Engine.getCurrent();
		e.setDriver(new h3d.impl.RenderGraphDriver(e.driver));
	}

	public static function mark(step : String) {
		if ( !enable ) return;
		frame.mark(step);
	}

	public static function setTargets(targets : Array<h3d.mat.Texture>, depthBinding : DepthBinding ) {
		if ( !enable ) return;
		frame.setTargetSection(new TargetsSection(targets, depthBinding));
	}

	public static function setTarget(target : h3d.mat.Texture, layer : Int, mipLevel : Int, depthBinding : DepthBinding) {
		if ( !enable ) return;
		frame.setTargetSection(new TargetSection(target, layer, mipLevel, depthBinding));
	}

	public static function setDepth(target : h3d.mat.Texture) {
		if ( !enable ) return;
		frame.setTargetSection(new DepthSection(target));
	}

	public static function clearTarget() {
		if ( !enable ) return;
		frame.clearTarget();
	}

	public static function sampleTexture(t : h3d.mat.Texture) {
		if ( !enable ) return;
		if ( t == null || !t.flags.has(Target) ) return;
		frame.sampleTexture(t);
	}

	public static function save(outFile: String) {
		if ( frame == null ) return;
		var content = frame.dump();
		sys.io.File.saveContent(outFile, haxe.Json.stringify(content, "\t"));
	}

	public static function end() {
		if ( !enable ) return;
		enable = false;
		var e = h3d.Engine.getCurrent();
		var logDriver = cast(e.driver, h3d.impl.RenderGraphDriver);
		e.setDriver(@:privateAccess logDriver.d);
	}

	public static function dispose() {
		frame = null;
	}

}

class Frame {
	var curStep : String;
	public var sections : Array<RenderSection>;
	public var textures : Map<h3d.mat.Texture, TexData>;

	public function new() {
		sections = [];
		textures = [];
	}

	public function useTexture(t : h3d.mat.Texture) {
		if ( t != null && textures.get(t) == null )
			textures.set(t, @:privateAccess new TexData(t));
	}

	public function getTextureData(t : h3d.mat.Texture) {
		if ( t == null )
			return null;
		useTexture(t);
		return textures.get(t);
	}

	public function getTextureId(t : h3d.mat.Texture) {
		if ( t == null )
			return -1;
		return getTextureData(t).id;
	}

	public function getTextureDataById(id:Int):TexData {
		for (t in textures)
			if (t.id == id)
				return t;
		return null;
	}

	public function mark(step : String) {
		if ( curStep != step ) {
			curStep =  step;
			sections.push(new RenderSection(step));
		}
	}

	public function getCurSection() {
		if ( sections.length == 0 ) {
			var curSection = new RenderSection("begin");
			sections.push(curSection);
			return curSection;
		}
		return sections[sections.length - 1];
	}

	public function getCurTargetSection() {
		var curSection = getCurSection();
		var curTargetSection = curSection.getCurSection();
		if ( curTargetSection == null )
			curSection.setTargetSection(new TargetSection(h3d.Engine.getCurrent().getCurrentTarget(), 0, 0, NotBound));
		return curSection.getCurSection();
	}

	public function setTargetSection(targetSection : TargetSectionBase) {
		var curSection = getCurSection();
		curSection.setTargetSection(targetSection);
	}

	public function clearTarget() {
		getCurTargetSection().clearTarget();
	}

	public function sampleTexture(t : h3d.mat.Texture) {
		getCurTargetSection().sampleTexture(t);
	}

	public function dump() {
		var tex = [for ( t in textures) t];
		tex.sort((t1,t2) -> return t1.id > t2.id ? 1 : -1);
		return {
			renderSections : [for ( s in sections ) s.dump()],
			textures : tex
		}
	}
}

class RenderSection {
	public var step : String;
	public var targetSections : Array<TargetSectionBase>;

	public function new(step : String) {
		this.step = step;
		targetSections = [];
	}

	public function getCurSection() {
		return targetSections[targetSections.length - 1];
	}

	public function setTargetSection(targetSection : TargetSectionBase) {
		targetSections.push(targetSection);
	}

	public function dump() {
		return {
			step : step,
			sections : [for ( ts in targetSections ) ts.dump()],
		}
	}
}

class TargetSectionBase {
	public var depthBinding : DepthBinding;
	public var events : Array<Event>;

	public function new(depthBinding : DepthBinding) {
		this.depthBinding = depthBinding;
		events = [];
	}

	public function clearTarget() {
		events.push(new ClearEvent());
	}

	public function sampleTexture(t : h3d.mat.Texture) {
		events.push(new SampleTextureEvent(t));
	}

	public function getTextureIds() : Array<Int> {
		return [];
	}

	public function dump() : Dynamic {
		return {
			events : [for ( e in events ) e.dump()],
		};
	}

}

class TargetSection extends TargetSectionBase {
	public var textureId : Int;
	public var layer : Int;
	public var mipLevel : Int;

	public function new(target : h3d.mat.Texture, layer : Int, mipLevel : Int, depthBinding : DepthBinding) {
		super(depthBinding);
		this.textureId = RenderGraph.frame.getTextureId(target);
		this.layer = layer;
		this.mipLevel = mipLevel;
	}

	override function getTextureIds() {
		return [textureId];
	}

	override function dump() {
		var res = super.dump();
		res.texture = textureId;
		res.layer = layer;
		res.mipLevel = mipLevel;
		return res;
	}
}

class TargetsSection extends TargetSectionBase {
	public var textureIds : Array<Int>;

	public function new(targets : Array<h3d.mat.Texture>, depthBinding : DepthBinding) {
		super(depthBinding);
		this.textureIds = [];
		for ( t in targets )
			textureIds.push(RenderGraph.frame.getTextureId(t));
	}

	override function getTextureIds() {
		return textureIds;
	}

	override function dump() {
		var res = super.dump();
		res.textures = textureIds;
		return res;
	}
}

class DepthSection extends TargetSectionBase {
	public var depthId : Int;

	public function new(depth : h3d.mat.Texture) {
		super(DepthOnly);
		this.depthId = RenderGraph.frame.getTextureId(depth);
	}

	override function dump() {
		var res = super.dump();
		res.depth = depthId;
		return res;
	}
}

class TexData {
	static var CUR_ID : Int = 0;
	public var name : String;
	public var width : Int;
	public var height : Int;
	public var fmt : hxd.PixelFormat;
	public var id(default, null) : Int;

	function new(t : h3d.mat.Texture) {
		name = t.name;
		width = t.width;
		height = t.height;
		fmt = t.format;
		id = CUR_ID;
		CUR_ID++;
	}

	public function dump() {
		return {
			name : name,
			width : width,
			height : height,
			fmt : fmt.getName(),
			id : id,
		}
	}
}

class Event {
	public function new() {

	}

	public function dump() : Dynamic {
		return {};
	}
}

class ClearEvent extends Event {
	public function new() {
		super();
	}

	override function dump() {
		var res = super.dump();
		res.event = "clear event";
		return res;
	}
}

class SampleTextureEvent extends Event {
	public var textureId : Int;
	public function new(t : h3d.mat.Texture) {
		super();
		textureId = RenderGraph.frame.getTextureId(t);
	}

	override function dump() {
		var res = super.dump();
		res.event = "sample texture";
		res.texture = textureId;
		return res;
	}
}
#end