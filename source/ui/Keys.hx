package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxAsepriteUtil;

class Keys extends FlxSprite
{
	public static inline var W:Float = 36;
	public static inline var H:Float = 33;

	public function new(X, Y, key:String)
	{
		super(X, Y);

		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/KeyboardKeys.png", "assets/data/KeyboardKeys.json");

		this.animation.play(key);

		FlxG.log.add(this.animation.getAnimationList().toString());
	}
}
