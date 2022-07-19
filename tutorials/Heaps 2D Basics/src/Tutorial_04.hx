import hxd.Res;
import h2d.Anim;

class Tutorial_04 extends hxd.App {
    static function main() {
        new Tutorial_04();

        #if sys
        hxd.Res.initLocal(); // HashLink
        #else
        hxd.Res.initEmbed(); // Html5/js
        #end
    }

    var player  : h2d.Anim;
    var coins   : Array< h2d.Anim > = [];

    var score_collectedCoins : Int = 0;
    var updatableInfoHUD : h2d.Text;

    override function init() {

        this.engine.backgroundColor = 0xFF006600; // a dark green background

        //player
        player = createSprite_animated( Res.blue_strip, 5, [0,1] );
        player.setPosition( s2d.width/2, s2d.height/2 );

        // coins
        for( i in 0...20 ){
            var coin = createSprite_animated( Res.coin_strip, 10, [0,1,2,3,2,1] );
            assignRandomPositionInScene( coin );
            coins.push( coin );
        }

        // "enemies"
        for( i in 0...6 ){
            var enemy  = createSprite_animated( Res.orange_strip, 5, [0,1] );
            assignRandomPositionInScene( enemy );
        }

        // how-to-play
        var t = new h2d.Text( hxd.res.DefaultFont.get(), s2d );
        t.text = "Use the arrow keys or W-A-S-D to move around\n\nPick up the coins!";

        // score
        var t = new h2d.Text( hxd.res.DefaultFont.get(), s2d );
        t.textColor = 0xFFFF00;
        t.scale( 2 );
        updatableInfoHUD = t;
    }

    override function update(dt:Float) {
        player_movement();
        wrapPlayerInScene();
        update_InfoHUD(); // updates score information
        checkCollision_playerAndCoins();
    }

    function wrapPlayerInScene(){
        if( player.x < 0 )
            player.x = s2d.width;
        if( player.y < 0 )
            player.y = s2d.height;
        if( player.x > s2d.width )
            player.x = 0;
        if( player.y > s2d.height )
            player.y = 0;
    }

    function update_InfoHUD() {
        var t = updatableInfoHUD;
        t.text = 'score: $score_collectedCoins';
        t.setPosition( s2d.width - t.getBounds().width - 8, 8 ); // could've used t.textWidth instead
    }

    function checkCollision_playerAndCoins() {
        for( c in coins )
            if( c.getBounds().intersects( player.getBounds() ) ){
                coins.remove( c ); // remove from our own array
                c.remove(); // remove h2d.Anim from scene
                Res.sound.coin.play();
                score_collectedCoins++;
            }
    }

    function player_movement() {
        
        var speed = 1;

        // moving right
        checkKeyboardKeys(
            hxd.Key.RIGHT,
            hxd.Key.D,
            ()->{ changePlayerAnimation( [2,3] ); },
            ()->{ player.x+=speed; }
        );

        // moving left
        checkKeyboardKeys(
            hxd.Key.LEFT,
            hxd.Key.A,
            ()->{ changePlayerAnimation( [2,3], true ); },
            ()->{ player.x-=speed; }
        );

        // moving down
        checkKeyboardKeys(
            hxd.Key.DOWN,
            hxd.Key.S,
            ()->{ changePlayerAnimation( [0,1] ); },
            ()->{ player.y+=speed; }
        );

        // moving up
        checkKeyboardKeys(
            hxd.Key.UP,
            hxd.Key.W,
            ()->{ changePlayerAnimation( [4,5] ); },
            ()->{ player.y-=speed; }
        );
    }

    function checkKeyboardKeys( key0:Int, key1:Int, onPressed:()->Void, onDown:()->Void ) {
        if ( hxd.Key.isPressed(key0) || hxd.Key.isPressed(key1) )
            onPressed();
        if ( hxd.Key.isDown(key0) || hxd.Key.isDown(key1) )
            onDown();
    }

    function assignRandomPositionInScene( obj : h2d.Object ) {
        obj.setPosition( hxd.Math.random(s2d.width), hxd.Math.random(s2d.height) );
    }

    //
    // Sprites + Animations
    //

    function changePlayerAnimation( chosenFrames:Array<Int>, looksLeft:Bool=false ) {
        var old_x = player.x;
        var old_y = player.y;
        var old_sprite = player;

        player = createSprite_animated( Res.blue_strip, 5, chosenFrames, true, looksLeft );

        player.setPosition( old_x, old_y );
        old_sprite.remove();
    }

    // - method name should actually be `createSprite_fromStrip_animated` or `createAnim_fromStrip`
    // - be aware to chose chosenFrames *inside* of what exists!
    function createSprite_animated( image_resource:hxd.res.Image, speed, chosenFrames:Array<Int>, centered:Bool=true, looksLeft:Bool=false ) : h2d.Anim {
        var height = image_resource.getSize().height;
        var autoCount = Math.floor( image_resource.getSize().width / height );
        var allFrames = image_resource.toTile().split( autoCount );
        for( f in allFrames ){
            if( centered )
                f.setCenterRatio();
            if( looksLeft )
                f.flipX();
        }
        var frames = [ for( i in chosenFrames ) allFrames[i] ];
        return new h2d.Anim( frames, speed, s2d );
    }
}