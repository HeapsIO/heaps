package h3d;

interface IDrawable {
	public function render( engine : Engine ) : Void;
	public function free() : Void;
}