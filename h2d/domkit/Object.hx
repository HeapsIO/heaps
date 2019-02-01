package h2d.domkit;
import h2d.domkit.BaseComponents;

@:build(h2d.domkit.InitComponents.init())
@:autoBuild(h2d.domkit.InitComponents.register())
interface Object extends domkit.Object {
	public var document : domkit.Document<h2d.Object>;
}