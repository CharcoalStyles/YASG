package states;

import entities.Bullet;
import entities.DamageLabel;
import entities.Enemy;
import entities.Player;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var globalState:GlobalState;
	var player:Player;
	var activeBullets:FlxTypedGroup<Bullet>;
	var activeEnemies:FlxTypedGroup<Enemy>;
	var damageLabels:FlxTypedGroup<DamageLabel>;

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
		damageLabels = new FlxTypedGroup<DamageLabel>();
		add(activeBullets);
		add(activeEnemies);
		// add(damageLabels);

		player = new Player((b:Bullet) ->
		{
			activeBullets.add(b); // TODO: look at, make sure we're pooling properly
		});

		globalState.player = player;

		// put player in the middle of the screen
		player.x = (FlxG.width - player.width) / 2;
		player.y = (FlxG.height - player.height) / 2;

		add(player);

		FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);

		// add enemies + labels
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

		for (dl in damageLabels.members)
		{
			if (dl.active)
			{
				dl.update(elapsed);
			}
		}

		FlxG.overlap(activeBullets, activeEnemies, (b:Bullet, e:Enemy) ->
		{
			e.hurt(b.damage);

			damageLabels.recycle(DamageLabel).set(e.x, e.y, b.damage);

			FlxG.log.add("DamageLabel count (l/a): " + damageLabels.countLiving() + " / " + damageLabels.members.length);
			FlxG.log.add("DamageLabel max: " + damageLabels.maxSize);

			b.kill();
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

	override public function draw()
	{
		super.draw();
		damageLabels.draw();
	}
}
