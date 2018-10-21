package hxd.impl;

class AnyProps {

	public var props(default, set) : Any;

	function set_props(p) {
		this.props = p;
		refreshProps();
		return p;
	}

	public function setDefaultProps( kind : String ) {
		props = getDefaultProps(kind);
	}

	public function getDefaultProps( ?kind : String ) : Any {
		return {};
	}

	public function refreshProps() {
	}

	#if editor
	public function editProps() {
		return new js.jquery.JQuery('<p>No properties for this object</p>');
	}
	#end

}
