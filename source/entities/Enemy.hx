package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class Enemy extends FlxSprite
{
	var labels:FlxTypedGroup<FlxText>;

	public function new(X, Y)
	{
		super(X, Y);

		width = 12;
		height = 18;
		makeGraphic(Std.int(width), Std.int(height), 0xff93240b);

		labels = new FlxTypedGroup();

		this.immovable = true;
	}

	override public function hurt(damage:Float)
	{
		var label = new FlxText(x, y, 100, Std.string(damage));
		label.health = 1;
		label.velocity.y = -50;
		label.velocity.x = FlxG.random.float(-20, 20);
		labels.add(label);
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
	}

	override public function draw()
	{
		super.draw();
		labels.draw();
	}
}
