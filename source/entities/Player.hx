package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxAsepriteUtil;

class Player extends FlxSprite
{
	var animList:Array<FlxAnimation>;

	public function new()
	{
		super();
		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/player.png", "assets/player.json");
		this.animation.play("idle");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// FlxG.gamepads.deviceConnected
	}
}
