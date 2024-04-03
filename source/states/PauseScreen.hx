package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;

class PauseState extends FlxSubState
{
	public function new()
	{
		super(0x80333333);

		// create a text field with the text "PAUSED" in the center of the screen
		var text:FlxText = new FlxText(0, FlxG.height / 2 - 64, FlxG.width, "PAUSED");
		text.setFormat(null, 72, 0xffffff, "center");
		add(text);

		// create a text field with the text "Press ENTER to continue" in the center of the screen
		var text2:FlxText = new FlxText(0, FlxG.height / 2 + 32, FlxG.width, "Press ENTER to continue");
		text2.setFormat(null, 48, 0xffffff, "center");
		add(text2);

		// create a text field with the text "Press ESC to go back to the menu" in the center of the screen
		var text3:FlxText = new FlxText(0, FlxG.height / 2 + 80, FlxG.width, "Press ESC to go back to the menu");
		text3.setFormat(null, 48, 0xffffff, "center");
		add(text3);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			close();
		}
		else if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
		}
	}
}
