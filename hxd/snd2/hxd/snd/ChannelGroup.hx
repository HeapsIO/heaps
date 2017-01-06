package hxd.snd;

@:allow(hxd.snd.System)
class ChannelGroup extends ChannelBase {
	public var name (default, null) : String;
	private function new(name : String) {
		super();
		this.name = name;
	}
}