package ui;

import flixel.FlxSprite;
import flixel.graphics.FlxAsepriteUtil;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class Mouse extends FlxSprite
{
	public static var W:Float = 29;
	public static var H:Float = 42;

	var speed:Float = 0;
	var minMaxSpeed:FlxPoint = new FlxPoint(0, 0);
	var moveBox:FlxRect;

	var target:FlxPoint;

	public function new(X, Y, key:String)
	{
		super(X, Y);

		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/Mouse_Modern.png", "assets/data/Mouse_Modern.json");

		this.animation.play(key);
	}

	public function setMovement(rect:FlxRect, minSpeed:Float, maxSpeed:Float):Void
	{
		this.moveBox = rect;
		this.minMaxSpeed.set(minSpeed, maxSpeed);
		this.speed = 1;

		target = new FlxPoint(this.x, this.y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.moveBox == null || this.speed == 0)
			return;

		// get distance to target
		var dx = target.x - this.x;
		var dy = target.y - this.y;
		var distance = Math.sqrt(dx * dx + dy * dy);

		// if we are close enough to the target, set a new target
		if (distance < 1)
		{
			this.x = target.x;
			this.y = target.y;
			this.speed = this.minMaxSpeed.x + Math.random() * (this.minMaxSpeed.y - this.minMaxSpeed.x);

			target.x = this.moveBox.x + Math.random() * this.moveBox.width;
			target.y = this.moveBox.y + Math.random() * this.moveBox.height;
		}
		else
		{
			// move towards target
			this.x += dx / distance * this.speed * elapsed;
			this.y += dy / distance * this.speed * elapsed;
		}
	}

	public static function createFaceButtons(X:Float, Y:Float):FlxTypedGroup<Gamepad>
	{
		var keys = new FlxTypedGroup<Gamepad>();
		keys.add(new Gamepad(X, Y - Gamepad.H / 2.5, "button"));
		keys.add(new Gamepad(X, Y + Gamepad.H / 2.5, "button"));
		keys.add(new Gamepad(X - Gamepad.W / 2.5, Y, "button"));
		keys.add(new Gamepad(X + Gamepad.W / 2.5, Y, "button"));
		return keys;
	}
}
