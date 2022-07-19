package gameobjects;

import hxd.Res;

class Enemy extends GameObject {

    public var direction : Float = 0;

    public function new( level_ ) {
        super( level_ );
        var s = useAnimationFromSpriteStrip( Res.orange_strip, 5, [0,1] );
	    hitbox = s.getBounds();
        hitbox.scaleCenter( 0.5 );

        level.enemies.push( this );
    }

    override function update() {
        super.update();
        var speed = 1;
        // enemies move
        var e = this;
        var move_x = level.moveObjectWhenWallFree( this, e.x + Math.cos( e.direction ) * speed, e.y );
        var move_y = level.moveObjectWhenWallFree( this, e.x, e.y + Math.sin( e.direction ) * speed );
        if( !move_x || !move_y )
            this.direction = hxd.Math.random( Math.PI * 2 ); // change direction when hitting wall
    }

    override function onRemove() {
        super.onRemove();
        level.enemies.remove( this );
    }
}