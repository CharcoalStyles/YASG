package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxAsepriteUtil;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

class Gamepad extends FlxSprite
{
	public static var W:Float = 36;
	public static var H:Float = 36;

	var minMaxSpeed:FlxPoint = new FlxPoint(0, 0);
	var angleSpeed:Float = 0;
	var targetAngle:Float = 0;

	public function new(X, Y, key:String)
	{
		super(X, Y);

		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/Joypad.png", "assets/data/Joypad.json");

		this.animation.play(key);
	}

	public function setAngleSpeeds(speed:FlxPoint):Void
	{
		this.minMaxSpeed = speed;
		this.targetAngle = this.angle;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.minMaxSpeed.length > 0)
		{
			// difference between target angle and current angle
			var diff = this.targetAngle - this.angle;

			// if the difference is minimal, we are at the target angle
			if (Math.abs(diff) < 5)
			{
				// set a new target angle
				this.targetAngle = (Math.random() * 2 - 1) * 360;

				// set a new speed
				this.angleSpeed = this.minMaxSpeed.x + Math.random() * (this.minMaxSpeed.y - this.minMaxSpeed.x);

				// set the direction of the rotation to the new target angle
				if (this.targetAngle < this.angle)
				{
					this.angleSpeed *= -1;
				}
			}
			else
			{
				// rotate the object
				this.angle += this.angleSpeed * elapsed;
			}
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
