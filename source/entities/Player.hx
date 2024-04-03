package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxAsepriteUtil;
import flixel.math.FlxPoint;

typedef Controls =
{
	move:FlxPoint,
	shoot:FlxPoint,
	isKeyboard:Bool,
};

class Player extends FlxSprite
{
	var globalState:GlobalState;
	var animList:Array<FlxAnimation>;

	var speed = 100;

	var shootTimer:Float = 0;
	var shootDelay:Float = 0.15;

	var onAddBullet:Bullet->Void;

	var lastControls:Controls;

	public function new(onAddBullet:Bullet->Void)
	{
		globalState = FlxG.plugins.get(GlobalState);
		super();

		this.onAddBullet = onAddBullet;

		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/hero.png", "assets/data/hero.json");
		this.animation.play("idle");
		this.scale.set(1.5, 1.5);

		this.setSize(14, 14);
		this.centerOffsets();
		this.offset.add(0, 6);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var controls = handleControls();

		this.velocity = controls.move * speed;

		shootTimer -= elapsed;

		if (shootTimer <= 0)
		{
			if (controls.shoot.length > 0)
			{
				var bulletXpos = this.x + ((this.width + controls.shoot.x * 4) / 2);
				var bulletYpos = this.y + ((this.height + controls.shoot.y * 4) / 2);

				var bullet = globalState.bulletsPool.get();
				bullet.reset(bulletXpos, bulletYpos);
				bullet.velocity.x = controls.shoot.x * 400;
				bullet.velocity.y = controls.shoot.y * 400;
				onAddBullet(bullet);

				shootTimer = shootDelay;
			}
		}

		if (this.velocity.x != 0 || this.velocity.y != 0)
		{
			var shootLeft = controls.shoot.x < 0;
			var shootRight = controls.shoot.y > 0;
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

		lastControls = controls;
	}

	function handleControls():Controls
	{
		var controls:Controls = {
			move: FlxPoint.get(0, 0),
			shoot: FlxPoint.get(0, 0),
			isKeyboard: !globalState.isUsingController
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
		var moveX = 0;
		var moveY = 0;

		if (FlxG.keys.pressed.A)
		{
			moveX = -1;
		}
		else if (FlxG.keys.pressed.D)
		{
			moveX = 1;
		}

		if (FlxG.keys.pressed.W)
		{
			moveY = -1;
		}
		else if (FlxG.keys.pressed.S)
		{
			moveY = 1;
		}

		var shootDir = FlxPoint.get(0, 0);

		if (FlxG.mouse.pressed)
		{
			var mousePos = FlxPoint.get(FlxG.mouse.x + 8, FlxG.mouse.y + 8);
			// get the player centre
			var playerPos = FlxPoint.get(this.x + this.width / 2, this.y + this.height / 2);
			shootDir = mousePos.subtract(playerPos.x, playerPos.y);
		}

		return {
			move: FlxPoint.get(moveX, moveY).normalize(),
			shoot: shootDir.normalize(),
			isKeyboard: true
		};
	}

	function getControlsFromController():Controls
	{
		var controller = FlxG.gamepads.getByID(globalState.controllerId);
		if (controller == null)
		{
			// pause
			return {
				move: FlxPoint.get(0, 0),
				shoot: FlxPoint.get(0, 0),
				isKeyboard: false
			};
		}

		var moveAxis = controller.getAnalogAxes(LEFT_ANALOG_STICK);
		var shootAxis = controller.getAnalogAxes(RIGHT_ANALOG_STICK);

		return {
			move: FlxPoint.get(moveAxis.x, moveAxis.y).normalize(),
			shoot: FlxPoint.get(shootAxis.x, shootAxis.y).normalize(),
			isKeyboard: false
		};
	}
}
