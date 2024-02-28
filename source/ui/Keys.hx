package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxAsepriteUtil;
import flixel.group.FlxGroup.FlxTypedGroup;

class Keys extends FlxSprite
{
	public static var W:Float = 36;
	public static var H:Float = 33;

	public function new(X, Y, key:String)
	{
		super(X, Y);

		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/KeyboardKeys.png", "assets/data/KeyboardKeys.json");

		this.animation.play(key);
	}

	public static function createWASD(X:Float, Y:Float):FlxTypedGroup<Keys>
	{
		var keys = new FlxTypedGroup<Keys>();
		keys.add(new Keys(X, Y, "w"));
		keys.add(new Keys(X - (Keys.W), Y + Keys.H, "a"));
		keys.add(new Keys(X, Y + Keys.H, "s"));
		keys.add(new Keys(X + (Keys.W), Y + Keys.H, "d"));
		return keys;
	}

	public static function createArrows(X:Float, Y:Float):FlxTypedGroup<Keys>
	{
		var keys = new FlxTypedGroup<Keys>();
		keys.add(new Keys(X, Y, "Up"));
		keys.add(new Keys(X - (Keys.W), Y + Keys.H, "Left"));
		keys.add(new Keys(X, Y + Keys.H, "Down"));
		keys.add(new Keys(X + (Keys.W), Y + Keys.H, "Right"));
		return keys;
	}
}
