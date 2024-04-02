package entities;

import flixel.FlxG;
import flixel.text.FlxText;

class DamageLabel extends FlxText
{
	var xDir:Float;
	var yDir:Float;

	public function new()
	{
		super();
	}

	public function set(x:Float, y:Float, damage:Float):Void
	{
		this.reset(x, y);
		this.text = "" + damage;
		alpha = 1;

		xDir = FlxG.random.float(-20, 20);
		yDir = -50;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		x += xDir * elapsed;
		y += yDir * elapsed;

		if (alpha > 0)
		{
			alpha -= 0.01;
		}
		else
		{
			kill();
		}
	}
}
