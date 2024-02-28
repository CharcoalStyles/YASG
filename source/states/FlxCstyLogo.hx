package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

typedef UpdPix =
{
	x:Int,
	y:Int,
	timer:Float
}

class FlxCstyLogo extends FlxState
{
	private var sprite:FlxSprite;
	private var bkgrnd:FlxSprite;

	private var nextState:FlxState;

	private var cstyLogoPixels:Array<FlxPoint>;
	private var timerLength:Float = 0.1;
	private var timer:Float = 0.1;
	private var updatingPixels:Array<UpdPix>;

	private var logoFinished:Bool = false;

	public function new()
	{
		super();

		nextState = new MenuState();
	}

	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;

		bkgrnd = new FlxSprite();
		bkgrnd.makeGraphic(FlxG.width, FlxG.height);
		add(bkgrnd);

		sprite = new FlxSprite(0, 0, "assets/images/csty.png");
		sprite.setGraphicSize(Std.int(FlxG.width / 1.5), 0);
		sprite.updateHitbox();
		sprite.x = (FlxG.width - sprite.width) / 2;
		sprite.y = (FlxG.height - sprite.height) / 2.5;
		add(sprite);

		cstyLogoPixels = [];
		updatingPixels = [];

		for (sx in 0...33)
		{
			for (sy in 0...13)
			{
				var c:Int = sprite.pixels.getPixel(sx, sy);
				FlxG.log.add("sx: " + sx + " sy: " + sy + " c: " + c);
				if (c == 0)
				{
					cstyLogoPixels.push(new FlxPoint(sx, sy));
					sprite.pixels.setPixel(sx, sy, FlxColor.WHITE);
				}
			}
		};

		FlxG.log.add("cstyLogoPixels: " + cstyLogoPixels.length);

		FlxG.random.shuffle(cstyLogoPixels);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		timer -= elapsed;

		if (timer <= 0)
		{
			timer = timerLength;
			timerLength *= 0.97;
			for (i in 0...2)
			{
				var point = cstyLogoPixels.pop();
				if (point != null)
					updatingPixels.push({x: Std.int(point.x), y: Std.int(point.y), timer: timerLength * 5});
			}
		}

		for (up in updatingPixels)
		{
			up.timer -= elapsed;
			var col = FlxG.random.color();
			if (up.timer <= 0)
			{
				updatingPixels.remove(up);
				col = FlxColor.BLACK;
			}
			sprite.pixels.setPixel(up.x, up.y, col);
		}
		if (cstyLogoPixels.length == 0 && updatingPixels.length == 0 && !logoFinished)
		{
			logoFinished = true;
			timer = 1;
		}

		if (logoFinished && timer > 0)
		{
			timer -= elapsed;
			if (timer <= 0)
			{
				FlxG.camera.fade(0xff000000, 0.75, false, onFade);
			}
		}
	}

	private function onFade()
	{
		FlxG.switchState(nextState);
	}
}
