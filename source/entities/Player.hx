package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxAsepriteUtil;

typedef Controls =
{
	moveLeft:Bool,
	moveRight:Bool,
	moveUp:Bool,
	moveDown:Bool,
	shootLeft:Bool,
	shootRight:Bool,
	shootUp:Bool,
	shootDown:Bool
};

class Player extends FlxSprite
{
	var globalState:GlobalState;
	var animList:Array<FlxAnimation>;

	var shootTimer:Float = 0;
	var shootDelay:Float = 0.15;

	var onAddBullet:Bullet->Void;

	public function new(onAddBullet:Bullet->Void)
	{
		globalState = FlxG.plugins.get(GlobalState);
		super();

		this.onAddBullet = onAddBullet;

		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/hero.png", "assets/data/hero.json");
		this.animation.play("idle");
		this.scale.set(1.5, 1.5);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var controls = handleControls();

		this.velocity.x = 0;
		if (controls.moveLeft)
		{
			this.velocity.x -= 100;
		}
		if (controls.moveRight)
		{
			this.velocity.x += 100;
		}

		this.velocity.y = 0;
		if (controls.moveUp)
		{
			this.velocity.y -= 100;
		}
		if (controls.moveDown)
		{
			this.velocity.y += 100;
		}

		shootTimer -= elapsed;

		if (shootTimer <= 0)
		{
			var bulletX:Float = 0;
			var bulletY:Float = 0;

			if (controls.shootLeft)
			{
				bulletX -= 1;
			}
			if (controls.shootRight)
			{
				bulletX += 1;
			}
			if (controls.shootUp)
			{
				bulletY -= 1;
			}
			if (controls.shootDown)
			{
				bulletY += 1;
			}

			if (bulletX != 0 || bulletY != 0)
			{
				// convert to unit vector
				var length = Math.sqrt(bulletX * bulletX + bulletY * bulletY);
				bulletX /= length;
				bulletY /= length;

				var bulletXpos = this.x + ((this.width + bulletX * 4) / 2);
				var bulletYpos = this.y + ((this.height + bulletY * 4) / 2);

				var bullet = globalState.bulletsPool.get();
				bullet.reset(bulletXpos, bulletYpos);
				bullet.velocity.x = bulletX * 200;
				bullet.velocity.y = bulletY * 200;
				onAddBullet(bullet);

				shootTimer = shootDelay;
			}
		}

		if (this.velocity.x != 0 || this.velocity.y != 0)
		{
			var shootLeft = controls.shootLeft;
			var shootRight = controls.shootRight;
			var runLeft = this.velocity.x < 0;
			var runRight = this.velocity.x > 0;

			this.flipX = runLeft;

			if ((runLeft && shootRight) || (runRight && shootLeft))
			{
				this.flipX = !this.flipX;
				this.animation.play("run", false, true);
			}
			else
			{
				this.animation.play("run");
			}
		}
		else
		{
			this.animation.play("idle");
		}
	}

	function handleControls():Controls
	{
		var controls:Controls = {
			moveLeft: false,
			moveRight: false,
			moveUp: false,
			moveDown: false,
			shootLeft: false,
			shootRight: false,
			shootUp: false,
			shootDown: false
		};

		if (globalState.isUsingController)
		{
			controls = getControlsFromController();
		}
		else
		{
			controls = getControlsFromKeyboard();
		}

		return controls;
	}

	function getControlsFromKeyboard():Controls
	{
		return {
			moveLeft: FlxG.keys.pressed.A,
			moveRight: FlxG.keys.pressed.D,
			moveUp: FlxG.keys.pressed.W,
			moveDown: FlxG.keys.pressed.S,
			shootLeft: FlxG.keys.pressed.LEFT,
			shootRight: FlxG.keys.pressed.RIGHT,
			shootUp: FlxG.keys.pressed.UP,
			shootDown: FlxG.keys.pressed.DOWN,
		};
	}

	function getControlsFromController():Controls
	{
		var controller = FlxG.gamepads.getByID(globalState.controllerId);
		if (controller == null)
		{
			// pause
			return {
				moveLeft: false,
				moveRight: false,
				moveUp: false,
				moveDown: false,
				shootLeft: false,
				shootRight: false,
				shootUp: false,
				shootDown: false
			};
		}

		var moveAxis = controller.getAnalogAxes(LEFT_ANALOG_STICK);
		var shootAxis = controller.getAnalogAxes(RIGHT_ANALOG_STICK);

		return {
			moveLeft: controller.anyPressed([DPAD_LEFT]) || moveAxis.x < -0.5,
			moveRight: controller.anyPressed([DPAD_RIGHT]) || moveAxis.x > 0.5,
			moveUp: controller.anyPressed([DPAD_UP]) || moveAxis.y < -0.5,
			moveDown: controller.anyPressed([DPAD_DOWN]) || moveAxis.y > 0.5,

			shootLeft: controller.anyPressed([X]) || shootAxis.x < -0.5,
			shootRight: controller.anyPressed([B]) || shootAxis.x > 0.5,
			shootUp: controller.anyPressed([Y]) || shootAxis.y < -0.5,
			shootDown: controller.anyPressed([A]) || shootAxis.y > 0.5,
		};
	}
}
