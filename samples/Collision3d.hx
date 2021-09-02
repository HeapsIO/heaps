class Collision3d extends hxd.App {
  static inline var ENEMY_COLOR = 0xcc0000;
  static inline var PLAYER_COLOR = 0x0000cc;
  static inline var COLLIDED_COLOR = 0xcc00cc;
  static inline var PLAYER_SPEED = 10;

  var enemy : h3d.scene.Mesh;
  var player : h3d.scene.Mesh;
  var text : h2d.Text;

  override function init() {
    // checkered ground
    var worldSize = 16;
    var halfWorldSize = Std.int(worldSize / 2);
    var tileSize = 2;
    var tiles = Std.int(worldSize / tileSize);
    var plane = new h3d.prim.Cube(tileSize, tileSize, 0);
    plane.addNormals();
    plane.addUVs();

    for (x in 0...tiles) {
      for (y in 0...tiles) {
        var mesh = new h3d.scene.Mesh(plane, s3d);
        var yOddEven = x % 2 == 0 ? 1 : 0;
        var color = y % 2 == yOddEven ? 0x408020 : 0x204010;
        mesh.x = x * tileSize - halfWorldSize;
        mesh.y = y * tileSize - halfWorldSize;
        mesh.material.texture = h3d.mat.Texture.fromColor(color);
      }
    }

    // primitive cube
    var cube = new h3d.prim.Cube(3, 3, 3);
    cube.translate(-0.5, -0.5, -0.5);
    cube.addNormals();
    cube.addUVs();

    // enemy mesh
    enemy = new h3d.scene.Mesh(cube, s3d);
    enemy.x = -5;
    enemy.y = 1;
    enemy.z = 3;
    enemy.material.color.setColor(ENEMY_COLOR);

    // player mesh
    player = new h3d.scene.Mesh(cube, s3d);
    player.z = 1.5;
    player.material.color.setColor(PLAYER_COLOR);

    // camera
    s3d.camera.target.set(0, 0, 0);
    s3d.camera.pos.set(30, 30, 25);
    new h3d.scene.CameraController(s3d).loadFromCamera();

    // directional light
    new h3d.scene.fwd.DirLight(new h3d.Vector(0.3, -0.4, -0.9), s3d);
    cast(s3d.lightSystem, h3d.scene.fwd.LightSystem).ambientLight.setColor(0x909090);

    // text instructions
    text = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
    text.x = 15;
    text.y = 15;
  }

  override function update(dt: Float) {
    // simple x or y movement, can't move diagonally (x and y) or vertically (z)
    var dx = 0;
    var dy = 0;

    if (hxd.Key.isDown(hxd.Key.A)) {
      dx = -1;
    } else if (hxd.Key.isDown(hxd.Key.D)) {
      dx = 1;
    } else if (hxd.Key.isDown(hxd.Key.W)) {
      dy = -1;
    } else if (hxd.Key.isDown(hxd.Key.S)) {
      dy = 1;
    }

    player.x += dt * dx * PLAYER_SPEED;
    player.y += dt * dy * PLAYER_SPEED;

    // check for player collision with enemy
    var collided = player.getBounds().collide(enemy.getBounds());

    player.material.color.setColor(collided ? COLLIDED_COLOR : PLAYER_COLOR);

    text.text = 'wasd move cube\nplayer x: ${player.x}\nplayer y: ${player.y}\nplayer collided: ${collided}';
  }

  static function main() {
    new Collision3d();
  }
}
