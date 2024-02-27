package states;

import entities.Bullet;
import entities.Enemy;
import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.util.FlxPool;

class PlayState extends FlxState
{
	var globalState:GlobalState;
	var player:Player;
	var activeBullets:FlxTypedGroup<Bullet>;
	var activeEnemies:FlxTypedGroup<Enemy>;

	override public function create()
	{
		super.create();

		globalState = FlxG.plugins.get(GlobalState);

		activeBullets = new FlxTypedGroup<Bullet>();
		activeEnemies = new FlxTypedGroup<Enemy>();
		add(activeBullets);
		add(activeEnemies);

		player = new Player((b:Bullet) ->
		{
			activeBullets.add(b);
		});

		// put player in the middle of the screen
		player.x = (FlxG.width - player.width) / 2;
		player.y = (FlxG.height - player.height) / 2;

		add(player);

		// add enemies
		for (i in 0...10)
		{
			var enemy = new Enemy(0, 0);
			enemy.x = Math.random() * FlxG.width;
			enemy.y = Math.random() * FlxG.height;
			activeEnemies.add(enemy);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(activeBullets, activeEnemies, (b:Bullet, e:Enemy) ->
		{
			e.hurt(b.damage);
			b.kill();
		});
	}
}
