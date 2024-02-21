package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var globalState:GlobalState;
	var player:Player;

	override public function create()
	{
		globalState = FlxG.plugins.get(GlobalState);
		super.create();

		player = new Player();

		// put player in the middle of the screen
		player.x = (FlxG.width - player.width) / 2;
		player.y = (FlxG.height - player.height) / 2;

		add(player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
