package states;

import entities.Bullet;
import entities.Enemy;
import entities.Player;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var globalState:GlobalState;
	var player:Player;
	var activeBullets:FlxTypedGroup<Bullet>;
	var activeEnemies:FlxTypedGroup<Enemy>;

	override public function create()
	{
		super.create();

		FlxG.worldBounds.set(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);

		globalState = FlxG.plugins.get(GlobalState);

		// add background
		var backdrop = new FlxBackdrop("assets/images/grassTile.png");
		add(backdrop);

		activeBullets = new FlxTypedGroup<Bullet>();
		activeEnemies = new FlxTypedGroup<Enemy>();
		add(activeBullets);
		add(activeEnemies);

		player = new Player((b:Bullet) ->
		{
			activeBullets.add(b);
		});
		globalState.player = player;

		// put player in the middle of the screen
		player.x = (FlxG.width - player.width) / 2;
		player.y = (FlxG.height - player.height) / 2;

		add(player);

		FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);

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

		FlxG.overlap(activeBullets, activeEnemies, (b:Bullet, e:Enemy) ->
		{
			e.hurt(b.damage);
			b.kill();
		}, (b:Bullet, e:Enemy) ->
			{
				FlxG.log.add("overlap callback");
				return b.active && e.active;
			});

		FlxG.overlap(player, activeEnemies, (p:Player, e:Enemy) ->
		{
			// p.hurt(1);

			for (e in activeEnemies.members)
			{
				e.doPushback();
			}
		});
	}
}
