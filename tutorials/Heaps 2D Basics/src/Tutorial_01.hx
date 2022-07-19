import hxd.Res;
import h2d.Bitmap;

class Tutorial_01 extends hxd.App {
    static function main() {
        new Tutorial_01();

        // make our game resources/assets available (!)
        #if sys
        hxd.Res.initLocal(); // use this for HashLink
        #else
        hxd.Res.initEmbed(); // use this for html5/js
        #end
    }
    
    override function init() {

        //player
        var tile = Res.blue.toTile();
        var player = new Bitmap( tile, s2d );
        player.setPosition( s2d.width/2, s2d.height/2 );

        // coins
        for( i in 0...20 ){
            var tile = Res.coin.toTile();
            var coin  = new Bitmap( tile, s2d );
            assignRandomPositionInScene( coin );
        }

        // "enemies"
        for( i in 0...6 ){
            var tile = Res.orange.toTile();
            var enemy  = new Bitmap( tile, s2d );
            assignRandomPositionInScene( enemy );
        }

        // how-to-play
        var t = new h2d.Text( hxd.res.DefaultFont.get(), s2d );
        t.text = "Welcome to the Heaps 2D tutorial!";
    }

    function assignRandomPositionInScene( obj : h2d.Object ) {
        obj.setPosition( hxd.Math.random(s2d.width), hxd.Math.random(s2d.height) );
    }
}