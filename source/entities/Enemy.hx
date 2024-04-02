package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class Enemy extends FlxSprite
{
	var globalState:GlobalState;
	var labels:FlxTypedGroup<FlxText>;
	var isInPushback:Bool;
	var lastMoveX:Bool;
	var speed = 90;

	public function new(X, Y)
	{
		super(X, Y);

		globalState = FlxG.plugins.get(GlobalState);

		health = 10;

		width = 12;
		height = 18;
		makeGraphic(Std.int(width), Std.int(height), 0xff93240b);

		labels = new FlxTypedGroup();

		this.immovable = true;
		this.isInPushback = false;
		this.lastMoveX = true;
	}

	override public function hurt(damage:Float)
	{
		super.hurt(damage);
		var label = new FlxText(x, y, 100, Std.string(damage));
		label.health = 1;
		label.velocity.y = -50;
		label.velocity.x = FlxG.random.float(-20, 20);
		labels.add(label);
	}

	public function doPushback()
	{
		if (!isInPushback)
		{
			isInPushback = true;
			var player = globalState.player;

			var dx = player.x - x;
			var dy = player.y - y;

			var length = Math.sqrt(dx * dx + dy * dy);
			if (length > 0)
			{
				dx /= length;
				dy /= length;
				dx *= (1000 - length) / 100;
				dy *= (1000 - length) / 100;
			}

			this.velocity.set(dx * -15, dy * -15);
			this.drag.x = 250;
			this.drag.y = 250;
		}
	}

	override public function update(elapsed:Float):Void
	{
		for (label in labels.members)
		{
			if (label != null)
			{
				label.health -= elapsed;
				label.alpha = label.health;
				label.x += label.velocity.x * elapsed;
				label.y += label.velocity.y * elapsed;

				if (label.health <= 0)
				{
					labels.remove(label, true);
					label.kill();
				}
			}
		}
		super.update(elapsed);
		labels.update(elapsed);

		if (isInPushback)
		{
			if (velocity.x == 0 && velocity.y == 0)
			{
				isInPushback = false;
				this.drag.x = 0;
				this.drag.y = 0;
			}
			return;
		}

		var player = globalState.player;

		var dx = player.x - x;
		var dy = player.y - y;

		var length = Math.sqrt(dx * dx + dy * dy);
		if (length > 0)
		{
			dx /= length;
			dy /= length;
		}

		if (Math.abs(dx) > Math.abs(dy))
		{
			velocity.x = dx * speed * (lastMoveX ? 1 : 1.45);
			velocity.y = 0;

			lastMoveX = true;
		}
		else
		{
			velocity.x = 0;
			velocity.y = dy * speed * (lastMoveX ? 1.45 : 1);
			lastMoveX = false;
		}
	}

	override public function draw()
	{
		super.draw();
		labels.draw();
	}
}
