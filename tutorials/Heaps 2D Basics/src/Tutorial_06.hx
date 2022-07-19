import hxd.Res;
import h2d.Anim;

class Tutorial_06 extends hxd.App {
    static function main() {
        new Tutorial_06();
        
        #if sys
        hxd.Res.initLocal(); // HashLink
        #else
        hxd.Res.initEmbed(); // Html5/js
        #end
    }

    var player  : h2d.Anim;
    var coins   : Array< h2d.Anim > = [];
    var enemies : Array< { sprite:h2d.Anim, direction:Float } > = [];
    var bullets : Array< h2d.Graphics > = [];

    var background_tilegroup : h2d.TileGroup;

    var score_collectedCoins : Int = 0;
    var updatableInfoHUD : h2d.Text;

    override function init() {

        // level setup

        background_tilegroup = new h2d.TileGroup( Res.tilegroup.toTile(), s2d );

        loadLevel( hxd.Res.level02.entry.getText() ); //loadLevel( sys.io.File.getContent( "./res/level02.txt" ) );

        this.engine.backgroundColor = 0xFF006600; // a dark green background

        //player
        player = createSprite_animated( Res.blue_strip, 5, [0,1] );
        player.setPosition( s2d.width/2, s2d.height/2 );

        // coins
        for( i in 0...20 ){
            var coin = create_coin();
            assignRandomPositionInScene( coin );
        }

        // "enemies"
        for( i in 0...6 ){
            var enemy  = createSprite_animated( Res.orange_strip, 5, [0,1] );
            assignRandomPositionInScene( enemy );
            enemies.push( {
                sprite    : enemy,
                direction : hxd.Math.random( Math.PI*2 )
            } );
        }

        // how-to-play
        var t = new h2d.Text( hxd.res.DefaultFont.get(), s2d );
        t.text = "Use the arrow keys or W-A-S-D to move around.\nPress left mouse button to shoot.\n\nPick up the coins!";

        // score
        var t = new h2d.Text( hxd.res.DefaultFont.get(), s2d );
        t.textColor = 0xFFFF00;
        t.scale( 2 );
        updatableInfoHUD = t;
    }

    override function update(dt:Float) {
        player_movement();
        player_shooting();
        wrapInsideScene( player ); // player can't leave scene
        update_enemies();
        update_bullets();
        update_InfoHUD(); // updates score information
        checkCollision_playerAndCoins();
        checkCollision_playerAndEnemies();
        checkCollision_bullets();
    }

    function checkCollision_bullets() {
        for( b in bullets ) {
            for( e in enemies ){
                if( b.getBounds().intersects( e.sprite.getBounds() ) ){
                    //e.direction = b.rotation;
                    assignRandomPositionInScene( e.sprite );
                    bullets.remove( b );
                    b.remove();
                }
            }
            for( c in coins ){
                if( b.getBounds().intersects( c.getBounds() ) ){
                    Res.sound.coin.play();
                    score_collectedCoins++;
                    coins.remove( c );
                    c.remove();
                    bullets.remove( b );
                    b.remove();
                }
            }
        }
    }

    function update_bullets() {
        for( b in bullets )
            b.move( 6, 6 );
    }

    function player_shooting() {
        if( hxd.Key.isPressed( hxd.Key.MOUSE_LEFT ) ){
            var bullet = new h2d.Graphics( s2d );
            bullet.setPosition( player.x, player.y );
            bullet.rotation = hxd.Math.atan2( s2d.mouseY - player.y, s2d.mouseX - player.x );
            bullet.beginFill( 0xB5B5B5 );
            bullet.drawRect( -8, -4, 16, 8 );
            bullets.push( bullet );
        }
    }

    function checkCollision_playerAndEnemies() {
        var speed = 1;
        for( e in enemies ){
            var enemy = e.sprite;
            if( enemy.getBounds().intersects( player.getBounds() ) ){
                // the player gets pushed/carried away
                player.x += Math.cos( e.direction ) * speed;
                player.y += Math.sin( e.direction ) * speed;
            }
        }
    }

    function update_enemies() {
        var speed = 1;
        for( e in enemies ){
            // enemies move
            var obj = e.sprite;
            obj.x += Math.cos( e.direction ) * speed;
            obj.y += Math.sin( e.direction ) * speed;
            // and are trapped inside the scene
            wrapInsideScene( obj );
        }
    }

    function wrapInsideScene( obj:h2d.Object ){
        if( obj.x < 0 )
            obj.x = s2d.width;
        if( obj.y < 0 )
            obj.y = s2d.height;
        if( obj.x > s2d.width )
            obj.x = 0;
        if( obj.y > s2d.height )
            obj.y = 0;
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

    function loadLevel( level_string:String, startX:Float=0, startY:Float=0 ) {
        
        var fieldSize = 32;
        var x = 0;
        var y = 0;

        // local function (to calculate the real position in the scene)
        var positionInScene = ( x:Int, y:Int ) -> {
            var sx = (x *fieldSize) + startX;
            var sy = (y *fieldSize) + startY;
            return {
                x: sx,
                y: sy
            };
        };

        for( i in 0...level_string.length ){
            var char = level_string.charAt( i );
            switch( char ){
                case "\n":
                    y++;
                    x=0;
                case "o":
                    var coin = create_coin();
                    var posInSc = positionInScene( x, y );
                    coin.setPosition( posInSc.x +16, posInSc.y +16 ); // +16 because coin sprite is centered
                case "#":
                    var posInSc = positionInScene( x, y );
                    create_wall( Math.floor(posInSc.x), Math.floor(posInSc.y) );
                default:
            }
            x++;
        }
    }

    function create_wall( x:Int, y:Int ) {
        var tile = Res.tilegroup.toTile().grid( 16 );
        var chosenTile = tile[1][0];
        chosenTile.scaleToSize( 32, 32 ); // making tile bigger on screen: from 16 to 32
        background_tilegroup.add( x, y, chosenTile );
    }

    function create_coin() {
        var coin = createSprite_animated( Res.coin_strip, 10, [0,1,2,3,2,1] );
        coins.push( coin );

        return coin;
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
        var allFrames  = image_resource.toTile().split( autoCount );
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