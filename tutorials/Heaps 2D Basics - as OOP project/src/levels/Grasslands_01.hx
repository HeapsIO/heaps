package levels;

import gameobjects.*;

import hxd.Res;

class Grasslands_01 extends Level {

    var score_collectedCoins : Int = 0;
    var updatableInfoHUD : h2d.Text;

    public function new( app:hxd.App ) {
        super();

        LevelLoader.loadLevel( sys.io.File.getContent( "./res/level03.txt" ), this );

        app.engine.backgroundColor = 0xFF006600; // a dark green background

        //player
        player = new Player( this );
        player.setPosition( this.width/2, this.height/2 );

        // coins
        for( i in 0...20 ){
            var coin = new Coin( this );
            assignRandomPositionInScene( coin );
        }

        // "enemies"
        for( i in 0...6 ){
            var enemy = new Enemy( this );
            assignRandomPositionInScene( enemy );
            enemy.direction = hxd.Math.random( Math.PI*2 );
        }

        // how-to-play
        var t = new h2d.Text( hxd.res.DefaultFont.get(), this );
        t.text = "Use the arrow keys or W-A-S-D to move around.\nPress left mouse button to shoot.\n\nPick up the coins!";

        // score
        var t = new h2d.Text( hxd.res.DefaultFont.get(), this );
        t.textColor = 0xFFFF00;
        t.scale( 2 );
        updatableInfoHUD = t;
    }

    public function update() {
        player.update();
        wrapInsideScene( player ); // player can't leave scene
        update_enemies();
        update_InfoHUD(); // updates score information
        checkCollision_playerAndCoins();
        checkCollision_playerAndEnemies();
        checkCollision_bullets();
    }

    function update_enemies() {
        for( e in enemies ){
            e.update();
            wrapInsideScene( e );
        }
    }

    function checkCollision_bullets() {
        for( b in player.bullets ) {
            var bullet_bounds = b.getBounds();
            bullet_bounds.scaleCenter( 0.5 ); // smaller bullet bounds/hitbox
            //bullet_bounds.rotate( b.rotation ); // rotate bounds ---- doesn't work properly...
            for( e in enemies ){
                if( bullet_bounds.intersects( e.hitbox ) ){
                    //e.direction = b.rotation;
                    assignRandomPositionInScene( e );
                    player.bullets.remove( b );
                    b.remove();
                }
            }
            for( c in coins ){
                if( bullet_bounds.intersects( c.hitbox ) ){
                    Res.sound.coin.play();
                    score_collectedCoins++;
                    coins.remove( c );
                    c.remove();
                    player.bullets.remove( b );
                    b.remove();
                }
            }
        }
    }

    function checkCollision_playerAndEnemies() {
        var speed = 1;
        for( e in enemies ){
            if( e.hitbox.intersects( player.hitbox ) ){
                // the player gets pushed/carried away
                moveObjectWhenWallFree(
                    player,
                    player.x + Math.cos( e.direction ) * speed,
                    player.y );
                moveObjectWhenWallFree(
                    player,
                    player.x,
                    player.y + Math.sin( e.direction ) * speed );
            }
        }
    }

    function checkCollision_playerAndCoins() {
        for( c in coins )
            if( c.hitbox.intersects( player.hitbox ) ){
                coins.remove( c ); // remove from our own array
                c.remove(); // remove h2d.Anim from scene
                Res.sound.coin.play();
                score_collectedCoins++;
            }
    }

    function update_InfoHUD() {
        var t = updatableInfoHUD;
        t.text = 'score: $score_collectedCoins';
        t.setPosition( this.width - t.getBounds().width - 8, 8 ); // could've used t.textWidth instead
    }
}