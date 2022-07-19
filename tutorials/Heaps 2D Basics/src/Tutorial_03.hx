import hxd.Res;
import h2d.Anim;

class Tutorial_03 extends hxd.App {
    static function main() {
        new Tutorial_03();
        
        #if sys
        hxd.Res.initLocal(); // HashLink
        #else
        hxd.Res.initEmbed(); // Html5/js
        #end
    }
    var player  : h2d.Anim;
    
    override function init() {

        this.engine.backgroundColor = 0xFF006600; // a dark green background

        //player
        var tiles  = Res.blue_strip.toTile().split( 6 );
        var frames = [ tiles[0], tiles[1] ];
        player = new h2d.Anim( frames, 2, s2d );
        player.setPosition( s2d.width/2, s2d.height/2 );

        // coins
        for( i in 0...20 ){
            var tiles  = Res.coin_strip.toTile().split( 4 );
            var frames = tiles.concat( [ tiles[2], tiles[1] ] );
            var coin  = new h2d.Anim( frames, 5, s2d );
            assignRandomPositionInScene( coin );
        }

        // "enemies"
        for( i in 0...6 ){
            var tiles  = Res.orange_strip.toTile().split( 6 );
            var frames = [ tiles[0], tiles[1] ];
            var enemy  = new h2d.Anim( frames, 2, s2d );
            assignRandomPositionInScene( enemy );
        }

        // how-to-play
        var t = new h2d.Text( hxd.res.DefaultFont.get(), s2d );
        t.text = "Use the arrow keys or W-A-S-D to move around\nhowever there's not much to do beside that...";
    }

    override function update(dt:Float) {
        player_movement();
    }

    function player_movement() {
        
        var speed = 1;
        var key0, key1 ;

        // moving right
        key0 = hxd.Key.RIGHT;
        key1 = hxd.Key.D;
        if( hxd.Key.isDown(key0) || hxd.Key.isDown(key1) )
            player.x+=speed;
        if( hxd.Key.isPressed(key0) || hxd.Key.isPressed(key1) )
            changePlayerAnimation( [2,3] );

        // moving left
        key0 = hxd.Key.LEFT;
        key1 = hxd.Key.A;
        if( hxd.Key.isDown(key0) || hxd.Key.isDown(key1) )
            player.x-=speed;
        if( hxd.Key.isPressed(key0) || hxd.Key.isPressed(key1) )
            changePlayerAnimation( [2,3], true );

        // moving down
        key0 = hxd.Key.DOWN;
        key1 = hxd.Key.S;
        if( hxd.Key.isDown(key0) || hxd.Key.isDown(key1) )
            player.y+=speed;
        if( hxd.Key.isPressed(key0) || hxd.Key.isPressed(key1) )
            changePlayerAnimation( [0,1] );

        // moving up
        key0 = hxd.Key.UP;
        key1 = hxd.Key.W;
        if( hxd.Key.isDown(key0) || hxd.Key.isDown(key1) )
            player.y-=speed;
        if( hxd.Key.isPressed(key0) || hxd.Key.isPressed(key1) )
            changePlayerAnimation( [4,5] );
    }

    function changePlayerAnimation( frame_indices:Array<Int>, looksLeft:Bool=false ) {
        var old_x = player.x;
        var old_y = player.y;
        var old_sprite = player;

        var tile = Res.blue_strip.toTile();
        var framesAll = tile.split( 6 );
        for( f in framesAll ){
            f.center();
            if( looksLeft ){
                f.flipX();
                f.dx += f.width;
            }
        }
        var framesChosen = [ for( i in frame_indices ) framesAll[i] ];
        player = new h2d.Anim( framesChosen, 2, s2d );

        player.setPosition( old_x, old_y );
        old_sprite.remove();
    }

    function assignRandomPositionInScene( obj : h2d.Object ) {
        obj.setPosition( hxd.Math.random(s2d.width), hxd.Math.random(s2d.height) );
    }
}