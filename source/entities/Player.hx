package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxAsepriteUtil;

class Player extends FlxSprite
{
	var globalState:GlobalState;
	var animList:Array<FlxAnimation>;

	public function new()
	{
		globalState = FlxG.plugins.get(GlobalState);
		super();
		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/hero.png", "assets/data/hero.json");
		this.animation.play("idle");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var moveLeft = false;
		var moveRight = false;
		var moveUp = false;
		var moveDown = false;

		var shootLeft = false;
		var shootRight = false;
		var shootUp = false;
		var shootDown = false;

		if (globalState.isUsingController)
		{
			var controller = FlxG.gamepads.getByID(globalState.controllerId);
			if (controller == null)
			{
				// pause
				return;
			}

			var moveAxis = controller.getAnalogAxes(LEFT_ANALOG_STICK);
			var shootAxis = controller.getAnalogAxes(RIGHT_ANALOG_STICK);

			moveLeft = controller.anyPressed([DPAD_LEFT]) || moveAxis.x < -0.5;
			moveRight = controller.anyPressed([DPAD_RIGHT]) || moveAxis.x > 0.5;
			moveUp = controller.anyPressed([DPAD_UP]) || moveAxis.y < -0.5;
			moveDown = controller.anyPressed([DPAD_DOWN]) || moveAxis.y > 0.5;

			shootLeft = controller.anyPressed([X]) || shootAxis.x < -0.5;
			shootRight = controller.anyPressed([B]) || shootAxis.x > 0.5;
			shootUp = controller.anyPressed([Y]) || shootAxis.y < -0.5;
			shootDown = controller.anyPressed([A]) || shootAxis.y > 0.5;
		}
		else
		{
			moveLeft = FlxG.keys.pressed.A;
			moveRight = FlxG.keys.pressed.D;
			moveUp = FlxG.keys.pressed.W;
			moveDown = FlxG.keys.pressed.S;

			shootLeft = FlxG.keys.pressed.LEFT;
			shootRight = FlxG.keys.pressed.RIGHT;
			shootUp = FlxG.keys.pressed.UP;
			shootDown = FlxG.keys.pressed.DOWN;
		}

		this.velocity.x = 0;
		if (moveLeft)
		{
			this.velocity.x -= 100;
		}
		if (moveRight)
		{
			this.velocity.x += 100;
		}

		this.velocity.y = 0;
		if (moveUp)
		{
			this.velocity.y -= 100;
		}
		if (moveDown)
		{
			this.velocity.y += 100;
		}
	}
}
