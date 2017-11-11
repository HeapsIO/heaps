import h2d.Graphics;
import h2d.Particles;
import hxd.Res;

class Particles2d extends SampleApp
{
	var g:ParticleGroup;
	var particles:Particles;
	var movableParticleGroup:ParticleGroup;
	var time:Float;

	override function init()
	{
		super.init();
		
		particles = new Particles(s2d);
		
		addButton("PartEmitMode.Point Demo", changeToPointDemo);
		addButton("PartEmitMode.Point + movable Demo", changeToPointAndMovableDemo);
		addButton("PartEmitMode.Point + emitDirectionAsAngle Demo", changeToPointAndDirectionAsAngleDemo);
		addButton("PartEmitMode.Cone Demo", changeToConeDemo);
		addButton("PartEmitMode.Box Demo", changeToBoxDemo);
		addButton("PartEmitMode.Direction Demo", changeToDirectionDemo);
		addButton("PartEmitMode.Direction + emitDirectionAsAngle Demo", changeToDirectionAndDirectionAsAngleDemo);
		
		changeToPointDemo();
	}
	
	function changeToPointDemo()
	{
		clear();
		
		g = new ParticleGroup(particles);
		g.sizeRand = .2;
		g.life = 1;
		g.speed = 100;
		g.speedRand = 3;
		g.rotSpeed = 2;
		g.nparts = 15;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 0;
		g.emitLoop = false;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.dx = cast s2d.width / 2;
		g.dy = cast s2d.height / 2;
		
		particles.addGroup(g);
	}
	
	function changeToPointAndMovableDemo()
	{
		clear();
		
		movableParticleGroup = g = new ParticleGroup(particles);
		g.sizeRand = .2;
		g.life = 1;
		g.speed = 100;
		g.speedRand = 3;
		g.rotSpeed = 2;
		g.nparts = 15;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 0;
		g.emitLoop = true;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.dx = cast s2d.width / 2;
		g.dy = cast s2d.height / 2;
		g.movable = true;
		
		particles.addGroup(g);
	}
	
	function changeToPointAndDirectionAsAngleDemo()
	{
		clear();
		
		g = new ParticleGroup(particles);
		g.size = .8;
		g.sizeRand = .2;
		g.life = .5;
		g.speed = 100;
		g.speedRand = 3;
		g.nparts = 15;
		g.emitDirectionAsAngle = true;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 0;
		g.emitLoop = false;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.dx = cast s2d.width / 2;
		g.dy = cast s2d.height / 2;
		g.texture = Res.arrow.toTexture();
		
		particles.addGroup(g);
	}
	
	function changeToConeDemo()
	{
		clear();
		
		g = new ParticleGroup(particles);
		g.size = .2;
		g.gravity = 1;
		g.life = 5;
		g.speed = 100;
		g.speedRand = 3;
		g.nparts = 200;
		g.emitMode = PartEmitMode.Cone;
		g.emitAngle = Math.PI;
		g.emitDist = 0;
		g.emitDistY = 0;
		g.fadeIn = 1;
		g.fadeOut = 1;
		g.dx = cast s2d.width / 2;
		g.dy = cast s2d.height / 2;
		
		particles.addGroup(g);
	}
	
	function changeToBoxDemo()
	{
		clear();
		
		g = new ParticleGroup(particles);
		g.size = .2;
		g.gravity = 1;
		g.life = 5;
		g.speed = 100;
		g.speedRand = 3;
		g.nparts = 200;
		g.emitMode = PartEmitMode.Box;
		g.emitAngle = Math.PI;
		g.emitDist = s2d.width;
		g.emitDistY = s2d.height;
		g.dx = cast s2d.width / 2;
		
		particles.addGroup(g);
	}
	
	function changeToDirectionDemo()
	{
		clear();
		
		g = new ParticleGroup(particles);
		g.size = .2;
		g.gravity = 1;
		g.life = 5;
		g.speed = 100;
		g.speedRand = 3;
		g.nparts = 200;
		g.emitMode = PartEmitMode.Direction;
		g.emitDist = s2d.width;
		g.emitAngle = Math.PI / 2;
		g.fadeOut = .5;
		
		particles.addGroup(g);
	}
	
	function changeToDirectionAndDirectionAsAngleDemo()
	{
		clear();
		
		g = new ParticleGroup(particles);
		g.size = .8;
		g.sizeRand = .2;
		g.life = 6;
		g.speed = 200;
		g.speedRand = 3;
		g.nparts = 200;
		g.emitDirectionAsAngle = true;
		g.emitMode = PartEmitMode.Direction;
		g.emitDist = s2d.height;
		g.emitAngle = Math.PI / 4;
		g.fadeIn = 0;
		g.fadeOut = 0;
		g.texture = Res.arrow.toTexture();
		
		particles.addGroup(g);
	}
	
	static function main()
	{
		Res.initEmbed();
		new Particles2d();
	}
	
	function clear():Void 
	{
		time = 0;
		if (movableParticleGroup != null) movableParticleGroup = null;
		if (g != null) particles.removeGroup(g);
	}
	
	override function update(dt:Float) 
	{
		super.update(dt);
		
		if (movableParticleGroup != null)
		{
			time += dt * 0.01;
			movableParticleGroup.dx = cast s2d.width / 2 + Math.cos(time) * 200;
			movableParticleGroup.dy = cast s2d.height / 2 + Math.sin(time) * 200;
		}
	}
}