import hxd.Res;
import h2d.Anim;

class Tutorial_02 extends hxd.App {
    static function main() {
        new Tutorial_02();
        
        #if sys
        hxd.Res.initLocal(); // HashLink
        #else
        hxd.Res.initEmbed(); // Html5/js
        #end
    }

    var player  : h2d.Anim;
    
    override function init() {

        //player
        var tiles  = Res.blue_strip.toTile().split( 6 );
        var frames = [ tiles[0], tiles[1] ];
        player = new h2d.Anim( frames, 2, s2d );
        player.setPosition( s2d.width/2, s2d.height/2 );

        // coins
        for( i in 0...20 ){
            var tiles  = Res.coin_strip.toTile().split( 4 );
            var frames = tiles.concat( [ tiles[2], tiles[1] ] ); // this will make (0, 1, 2, 3, 2, 1), thus going back and forth...
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

        // moving right
        if( hxd.Key.isDown(hxd.Key.RIGHT) || hxd.Key.isDown(hxd.Key.D) )
            player.x += speed;

        // moving left
        if( hxd.Key.isDown(hxd.Key.LEFT ) || hxd.Key.isDown(hxd.Key.A) )
            player.x -= speed;

        // moving down
        if( hxd.Key.isDown(hxd.Key.DOWN ) || hxd.Key.isDown(hxd.Key.S) )
            player.y += speed;

        // moving up
        if( hxd.Key.isDown(hxd.Key.UP   ) || hxd.Key.isDown(hxd.Key.W) )
            player.y -= speed;
    }

    function assignRandomPositionInScene( obj : h2d.Object ) {
        obj.setPosition( hxd.Math.random(s2d.width), hxd.Math.random(s2d.height) );
    }
}