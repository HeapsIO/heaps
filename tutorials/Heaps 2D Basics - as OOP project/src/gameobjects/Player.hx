package gameobjects;

import hxd.Res;

class Player extends GameObject {

    public var bullets : Array< h2d.Graphics > = []; // bullets fired by player

    public function new( level_ ) {
        super( level_ );
        var s = useAnimationFromSpriteStrip( Res.blue_strip, 5, [0,1] );
        hitbox = s.getBounds();
        hitbox.scaleCenter( 0.5 );

        level.player = this;
    }

    override function update() {
        super.update();
        player_movement();
        player_shooting();
        update_bullets();
    }

    function update_bullets() {
        for( b in bullets )
            b.move( 6, 6 );
    }

    function player_shooting() {
        if( hxd.Key.isPressed( hxd.Key.MOUSE_LEFT ) ){
            var bullet = new h2d.Graphics( level );
            bullet.setPosition( this.x, this.y );
            bullet.rotation = hxd.Math.atan2( level.mouseY - this.y, level.mouseX - this.x );
            bullet.beginFill( 0xB5B5B5 );
            bullet.drawRect( -8, -4, 16, 8 );
            bullets.push( bullet );
        }
    }

    function player_movement() {
        
        var speed = 1;

        // moving right
        checkKeyboardKeys(
            hxd.Key.RIGHT,
            hxd.Key.D,
            ()->{ changePlayerAnimation( [2,3] ); },
            ()->{ level.moveObjectWhenWallFree( this, this.x+speed, this.y ); }
        );

        // moving left
        checkKeyboardKeys(
            hxd.Key.LEFT,
            hxd.Key.A,
            ()->{ changePlayerAnimation( [2,3], true ); },
            ()->{ level.moveObjectWhenWallFree( this, this.x-speed, this.y ); }
        );

        // moving down
        checkKeyboardKeys(
            hxd.Key.DOWN,
            hxd.Key.S,
            ()->{ changePlayerAnimation( [0,1] ); },
            ()->{ level.moveObjectWhenWallFree( this, this.x, this.y+speed ); }
        );

        // moving up
        checkKeyboardKeys(
            hxd.Key.UP,
            hxd.Key.W,
            ()->{ changePlayerAnimation( [4,5] ); },
            ()->{ level.moveObjectWhenWallFree( this, this.x, this.y-speed ); }
        );
    }

    function checkKeyboardKeys( key0:Int, key1:Int, onPressed:()->Void, onDown:()->Void ) {
        if ( hxd.Key.isPressed(key0) || hxd.Key.isPressed(key1) )
            onPressed();
        if ( hxd.Key.isDown(key0) || hxd.Key.isDown(key1) )
            onDown();
    }

    public function changePlayerAnimation( chosenFrames:Array<Int>, looksLeft:Bool=false ) {
        useAnimationFromSpriteStrip( Res.blue_strip, 5, chosenFrames, true, looksLeft );
    }

    override function onRemove() {
        super.onRemove();
        level.player = null;
    }
}