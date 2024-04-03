package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ui.Gamepad;
import ui.Keys;
import ui.Mouse;

class MenuState extends FlxState
{
	var textArray:Array<FlxText>;
	var el:Float;

	var globalState:GlobalState;

	override public function create()
	{
		globalState = new GlobalState();
		super.create();

		FlxG.plugins.addPlugin(globalState);

		var text:String = "Yet Another Survivors Game";
		textArray = splitText(text);

		// Add each FlxText object to the state
		for (i in 0...textArray.length)
		{
			add(textArray[i]);
		}

		var instructions:FlxText = new FlxText(0, FlxG.height - 32, FlxG.width, "Press any key or button to start");
		instructions.size = 16;
		instructions.alignment = "center";
		add(instructions);

		el = 180;

		var moveGuideAnchor:FlxPoint = new FlxPoint(FlxG.width / 2 - 96, FlxG.height / 2);

		var moveGuide:FlxText = new FlxText(moveGuideAnchor.x - 128, moveGuideAnchor.y - 64, 256, "Move");
		moveGuide.size = 24;
		moveGuide.alignment = "center";
		moveGuide.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(moveGuide);
		add(Keys.createWASD(moveGuideAnchor.x - 16, moveGuideAnchor.y));
		var gamePadM = new Gamepad(moveGuideAnchor.x - Gamepad.W * 0.5, moveGuideAnchor.y + 96, "stick-left");
		gamePadM.setAngleSpeeds(new FlxPoint(90, 140));
		add(gamePadM);

		var shootGuideAnchor:FlxPoint = new FlxPoint(FlxG.width / 2 + 96, FlxG.height / 2);
		var moveGuide:FlxText = new FlxText(shootGuideAnchor.x - 128, shootGuideAnchor.y - 64, 256, "Shoot");
		moveGuide.size = 24;
		moveGuide.alignment = "center";
		moveGuide.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(moveGuide);
		var mouse = new Mouse(shootGuideAnchor.x, shootGuideAnchor.y, "LongLeftClick");
		mouse.setMovement(new FlxRect(shootGuideAnchor.x - 64, shootGuideAnchor.y - 32, 128, 64), 30, 70);
		add(mouse);
		var gamePadS = new Gamepad(shootGuideAnchor.x - Gamepad.W * 0.5, shootGuideAnchor.y + 96, "stick-right");
		gamePadS.setAngleSpeeds(new FlxPoint(90, 140));
		add(gamePadS);
	}

	function orText(x:Float, y:Float):FlxText
	{
		var t:FlxText = new FlxText(x, y, 0, "OR");
		t.size = 16;
		t.alignment = "center";
		t.borderStyle = FlxTextBorderStyle.OUTLINE;
		return t;
	}

	function splitText(text:String):Array<FlxText>
	{
		// Split the text into an array of characters
		var characters:Array<String> = text.split("");

		// Create an array of FlxText objects
		var textArray:Array<FlxText> = new Array<FlxText>();

		// Create a FlxText object for each character and position
		// them centered on the screen
		var acculumX = 0;
		for (i in 0...characters.length)
		{
			var n = characters[i] == "I";
			var xpos = n ? 28 : 36;
			var xpNeg = n ? 8 : 0;

			var char:FlxText = new FlxText(0, 0, FlxG.width, characters[i]);
			char.size = 48;
			char.alignment = "center";
			char.x = acculumX + xpos;
			char.y = 0;
			char.borderColor = 0xffffffff;
			char.borderSize = 4;
			char.borderQuality = 4;
			char.borderStyle = FlxTextBorderStyle.OUTLINE;
			textArray.push(char);
			acculumX += xpos - xpNeg;
		}

		for (i in 0...textArray.length)
		{
			textArray[i].x -= acculumX / 2;
		}

		return textArray;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		el += elapsed;
		for (i in 0...textArray.length)
		{
			textArray[i].y = 64 + Math.sin(el * 2.3 + i * 0.5) * 15;
			textArray[i].angle = Math.sin(el * 1.7 + i * 0.5) * 10;
			var col = FlxColor.fromRGB(Std.int(Math.sin(el * 1.3 + i * 0.5) * 128 + 128), Std.int(Math.sin(el * 1.5 + i * 0.5) * 128 + 128),
				256 - Std.int(Math.sin(el * 1.3 + i * 0.5) * 128 + 128));
			textArray[i].color = col;
			textArray[i].borderColor = col.getInverted();
		}

		if (FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.anyJustPressed([
			A, B, X, Y, START, BACK, LEFT_SHOULDER, RIGHT_SHOULDER, LEFT_TRIGGER, RIGHT_TRIGGER
		]))
		{
			globalState.isUsingController = true;
			globalState.controllerId = FlxG.gamepads.lastActive.id;
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.anyJustPressed(generateAllKeys()))
		{
			globalState.isUsingController = false;
			FlxG.switchState(new PlayState());
		}
	}

	function generateAllKeys():Array<flixel.input.keyboard.FlxKey>
	{
		return [
			A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE,
			NUMPADZERO, NUMPADONE, NUMPADTWO, NUMPADTHREE, NUMPADFOUR, NUMPADFIVE, NUMPADSIX, NUMPADSEVEN, NUMPADEIGHT, NUMPADNINE, F1, F2, F3, F4, F5, F6,
			F7, F8, F9, F10, F11, F12, TAB, CAPSLOCK, SHIFT, CONTROL, ALT, SPACE, ENTER, BACKSPACE, DELETE, INSERT, HOME, END, PAGEUP, PAGEDOWN, PRINTSCREEN,
		];
	}
}
