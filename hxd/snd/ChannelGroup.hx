package hxd.snd;

class ChannelGroup extends ChannelBase {

	public var name (default, null) : String;

	public function new(name : String) {
		super();
		this.name = name;
	}

}