package hxd.tools;

#if domkit
class SceneInspectorBaseComp extends h2d.Flow implements h2d.domkit.Object {
}

@:uiInitFunction(init)
class SceneInspectorBaseDynComp extends h2d.Flow implements h2d.domkit.Object {
	function new(?parent) {
		super(parent);
		init();
	}

	function init() {
		initComponent();
	}

	public function rebuild() {
		removeChildren();
		init();
	}
}

class SceneInspectorButtonComp extends SceneInspectorBaseComp {
	static var SRC = <scene-inspector-button-comp
		content-align="middle"
		background="#4287f5"
	>
		<text text={text}/>
	</scene-inspector-button-comp>

	var text : String;
	var enable : Bool = true;

	public function new( text : String, ?parent ) {
		this.text = text;
		super(parent);
		initComponent();
		enableInteractive = true;
		interactive.enableRightButton = true;
		interactive.onClick = function(e) {
			if( e.button == 0 && enable )
				onClick();
			else if( e.button == 1 && enable )
				onRightClick();
		};
		interactive.onOver = function(_) {
			dom.hover = true;
		};
		interactive.onOut = function(_) {
			dom.hover = false;
		};
	}

	public dynamic function onClick() { }

	public dynamic function onRightClick() { }
}

class SceneInspectorObjectComp extends SceneInspectorBaseDynComp {
	static var SRC = <scene-inspector-object-comp layout="vertical">
		<flow class="obj-header" layout="horizontal" padding="5" hspacing="5"
			alpha={isVisible() ? 1 : 0.5}
		>
			<scene-inspector-button-comp(expanded ? "-" : "+") min-width="20" onClick={toggleExpand}/>
			<text text={getName()}/>
			<text text={getDesc()}/>
			<scene-inspector-button-comp("visible") onClick={toggleVisibility} />
			<scene-inspector-button-comp("teleport") onClick={teleportTo} if(is3d)/>
		</flow>
	</scene-inspector-object-comp>

	var inspector : SceneInspector;
	var expanded : Bool;
	var is3d : Bool;

	public function new( inspector : SceneInspector, ?parent ){
		this.inspector = inspector;
		this.expanded = false;
		super(parent);
	}

	function getName() : String {
		return "[Object]";
	}

	function getDesc() : String {
		return "";
	}

	function toggleExpand() {
		expanded = !expanded;
		rebuild();
	}

	function isVisible() : Bool {
		return true;
	}

	function toggleVisibility() {
	}

	function teleportTo() {
	}

}

class SceneInspectorObject2dComp extends SceneInspectorObjectComp {
	static var SRC = <scene-inspector-object2d-comp layout="vertical">
		${if( expanded ){
			<flow class="child-list" layout="vertical" padding-left="20">
				for( child in obj ) {
					<scene-inspector-object2d-comp(inspector, child)/>
				}
			</flow>
		}}
	</scene-inspector-object2d-comp>

	var obj : h2d.Object;

	public function new( inspector : SceneInspector, obj : h2d.Object, ?parent ){
		this.obj = obj;
		this.is3d = false;
		super(inspector, parent);
	}

	override function getName() {
		var objName = obj.name ?? "Object";
		return '[$objName]';
	}

	override function getDesc() {
		var typeName = Type.getClassName(Type.getClass(obj));
		var childCount = getChildCountRec(obj);
		return '$typeName (child:$childCount)';
	}

	override function toggleExpand() {
		// prevent expand self
		if( obj == inspector.rootComp )
			return;
		super.toggleExpand();
	}

	override function isVisible() {
		var p = obj;
		while( p != null ){
			if( !p.visible )
				return false;
			p = p.parent;
		}
		return true;
	}

	override function toggleVisibility() {
		// do not make parent or self invisible
		if( obj == inspector.parent || obj == inspector.rootComp )
			return;
		obj.visible = !obj.visible;
		// update might changes visible flag
		haxe.Timer.delay(() -> rebuild(), 0);
	}

	static function getChildCountRec( obj : h2d.Object ) : Int{
		var count = 0;
		for( child in obj )
			count += getChildCountRec(child);
		return obj.numChildren + count;
	}
}

class SceneInspectorObject3dComp extends SceneInspectorObjectComp {
	static var SRC = <scene-inspector-object3d-comp layout="vertical">
		${if( expanded ){
			<flow class="obj-details" layout="vertical" vspacing="5">
				<text text={getProps()}/>
				<flow layout="horizontal" hspacing="5">
					<scene-inspector-button-comp("bounds") onClick={toggleDebugBounds}/>
					<scene-inspector-button-comp("collider") onClick={toggleDebugCollider}/>
					<scene-inspector-button-comp("culling") onClick={toggleDebugCulling}/>
				</flow>
			</flow>
			<flow class="child-list" layout="vertical" padding-left="20">
				for( child in obj ) {
					<scene-inspector-object3d-comp(inspector, child)/>
				}
			</flow>
		}}
	</scene-inspector-object3d-comp>

	var obj : h3d.scene.Object;
	var debugObj : h3d.scene.Object;

	public function new( inspector : SceneInspector, obj : h3d.scene.Object, ?parent ){
		this.obj = obj;
		this.is3d = true;
		super(inspector, parent);
	}

	override function onRemove() {
		if( debugObj != null ) {
			debugObj.remove();
			debugObj = null;
		}
		super.onRemove();
	}

	override function getName() {
		var objName = obj.name ?? "Object";
		return '[$objName]';
	}

	override function getDesc() {
		var typeName = Type.getClassName(Type.getClass(obj));
		var childCount = getChildCountRec(obj);
		var triangleCount = getTriangleCount(obj);
		return '$typeName (child:$childCount) (tri:$triangleCount)';
	}

	override function isVisible() {
		var p = obj;
		while( p != null ){
			if( !p.visible )
				return false;
			p = p.parent;
		}
		return true;
	}

	override function toggleVisibility() {
		obj.visible = !obj.visible;
		// update might changes visible flag
		haxe.Timer.delay(() -> rebuild(), 0);
	}

	override function teleportTo() {
		inspector.teleportTo(obj);
	}

	function getProps() {
		var position = obj.getAbsPos().getPosition();
		var flags = @:privateAccess obj.flags.toString();
		return 'absPos:$position\n'
			+ 'flags:$flags';
	}

	function toggleDebugBounds() {
		debugObj = inspector.toggle3dDebug(obj, debugObj, Bounds);
	}

	function toggleDebugCollider() {
		debugObj = inspector.toggle3dDebug(obj, debugObj, Collider);
	}

	function toggleDebugCulling() {
		debugObj = inspector.toggle3dDebug(obj, debugObj, Culling);
	}

	static function getChildCountRec( obj : h3d.scene.Object ) : Int{
		var count = 0;
		for( child in obj )
			count += getChildCountRec(child);
		return obj.numChildren + count;
	}

	static function getVisibleMeshes( obj: h3d.scene.Object, ?out : Array<h3d.scene.Mesh> ) {
		if( out == null ) out = [];
		if( obj.visible ){
			var m = Std.downcast(obj, h3d.scene.Mesh);
			if( m != null ) out.push(m);
			for( c in obj )
				getVisibleMeshes(c, out);
		}
		return out;
	}

	static function getTriangleCount( obj: h3d.scene.Object ) : Int {
		var tri = 0;
		for( m in getVisibleMeshes(obj) ){
			tri += m.primitive.triCount();
		}
		return tri;
	}
}

class SceneInspectorComp extends SceneInspectorBaseComp {
	static var SRC = <scene-inspector-comp
	 	layout="vertical" overflow="scroll"
	 	padding="5" max-height="720"
		background="#555555" background-alpha="0.8"
	>
		<scene-inspector-object3d-comp(inspector, root3d)/>
		<scene-inspector-object2d-comp(inspector, root2d) if(root2d != null)/>
	</scene-inspector-comp>

	var inspector : SceneInspector;

	public function new( inspector : SceneInspector, root3d : h3d.scene.Object, root2d : Null<h2d.Object>, ?parent ) {
		this.inspector = inspector;
		super(parent);
		initComponent();
	}
}

enum SceneInspectorDebugMode {
	Bounds;
	Collider;
	Culling;
}

/**
	Requires:
	`-lib domkit --macro domkit.Macros.registerComponentsPath("$")`.

	Inspect `h3d.scene.Object` (usually `s3d`) and `h2d.Object` (usually `s2d`) with domkit-based UI.
**/
class SceneInspector {
	public var style(default, null) : h2d.domkit.Style;
	public var parent(default, null) : h2d.Object;
	var s3d : h3d.scene.Object;
	var s2d : h2d.Object;
	var debug3dObjs : Array<h3d.scene.Object>;
	public var rootComp(default, null) : SceneInspectorComp;

	public function new( parent : h2d.Object, s3d : h3d.scene.Object, ?s2d : h2d.Object ) {
		style = new h2d.domkit.Style();
		this.parent = parent;
		this.s3d = s3d;
		this.s2d = s2d;
		debug3dObjs = [];
		rootComp = new SceneInspectorComp(this, s3d, s2d, parent);
		style.addObject(rootComp);
	}

	public function dispose() {
		style = null;
		if( parent != null ) {
			parent.removeChild(rootComp);
		}
		parent = null;
		s3d = null;
		s2d = null;
		rootComp = null;
		for( obj in debug3dObjs ) {
			obj.remove();
		}
		debug3dObjs = [];
		teleportTo = function(obj) {};
	}

	public dynamic function teleportTo( obj : h3d.scene.Object ) {
	}

	public function toggle3dDebug( obj : h3d.scene.Object, debugObj : Null<h3d.scene.Object>, mode : SceneInspectorDebugMode ) {
		if( debugObj == null ) {
			var collider = try switch( mode ) {
				case Bounds: obj.getBounds(null, obj);
				case Collider: obj.getCollider();
				case Culling: obj.cullingCollider;
				case _: null;
			} catch( e ) {
				trace("Can't get collider: " + e);
				null;
			};
			if( collider != null ) {
				debugObj = collider.makeDebugObj();
				if( debugObj != null ) {
					// restore relative position in case that the obj move
					if( !mode.match(Bounds) ) {
						debugObj.x -= obj.x;
						debugObj.y -= obj.y;
						debugObj.z -= obj.z;
					}
					debugObj.follow = obj;
					debugObj.ignoreBounds = true;
					debugObj.ignoreCollide = true;
					h3d.scene.Interactive.setupDebugMaterial(debugObj);
					s3d.addChild(debugObj);
					debug3dObjs.push(debugObj);
				}
			}
		} else {
			debug3dObjs.remove(debugObj);
			debugObj.remove();
			debugObj = null;
		}
		return debugObj;
	}

}
#end
