package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxAsepriteUtil;
import flixel.group.FlxGroup;

class Gamepad extends FlxSprite
{
	public static var W:Float = 36;
	public static var H:Float = 36;

	public function new(X, Y, key:String)
	{
		super(X, Y);

		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/Joypad.png", "assets/data/Joypad.json");

		this.animation.play(key);
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
