package entities;

import flixel.FlxSprite;

class Bullet extends FlxSprite
{
	var timeToLive:Float = 2.0;

	public var damage:Float = 1.5;

	public function new()
	{
		super(-100, -100);
		width = 4;
		height = 4;
		makeGraphic(4, 4, 0xffe6d32a);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		timeToLive -= elapsed;
		if (timeToLive <= 0)
		{
			kill();
		}
	}
}
