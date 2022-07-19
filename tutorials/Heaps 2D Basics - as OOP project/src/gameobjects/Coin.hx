package gameobjects;

import hxd.Res;

class Coin extends GameObject {

    public function new( level_ ) {
        super( level_ );
        var s = useAnimationFromSpriteStrip( Res.coin_strip, 10, [0,1,2,3,2,1] );
        hitbox = s.getBounds();
        hitbox.scaleCenter( 0.5 );

        level.coins.push( this );
    }

    override function onRemove() {
        super.onRemove();
        level.coins.remove( this );
    }
}