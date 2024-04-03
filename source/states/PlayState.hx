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
import flixel.math.FlxPoint;
import states.PauseScreen.PauseState;

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

		FlxG.autoPause = false;

		FlxG.worldBounds.set(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);

		globalState = FlxG.plugins.get(GlobalState);

		FlxG.mouse.visible = !globalState.isUsingController;
		FlxG.mouse.load("assets/images/crosshair_outline_small.png", 0.5);

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
		FlxG.camera.targetOffset.set(0, -3.5);

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

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.P)
		{
			openPauseMenu();
		}

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

	function openPauseMenu()
	{
		var subState = new PauseState();
		var screenOrigin = new FlxPoint(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
		FlxG.log.add("screenOrigin: " + screenOrigin.x + ", " + screenOrigin.y);

		subState.setParentScreen(screenOrigin.x, screenOrigin.y);
		subState.create();
		openSubState(subState);
	}

	override function onFocusLost()
	{
		openPauseMenu();
	}
}
