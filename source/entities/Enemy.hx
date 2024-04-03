package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class Enemy extends FlxSprite
{
	var globalState:GlobalState;
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

		this.immovable = true;
		this.isInPushback = false;
		this.lastMoveX = true;
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
		super.update(elapsed);

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

		velocity.set(dx * speed, dy * speed);
	}
}
