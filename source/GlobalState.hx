package;

import entities.Bullet;
import entities.Player;
import flixel.FlxBasic;
import flixel.util.FlxPool;

class GlobalState extends FlxBasic
{
	public var isUsingController:Bool = false;
	public var controllerId:Int = 0;
	public var bulletsPool:FlxPool<Bullet>;
	public var player:Player;

	// public var currentWeapon = new ();

	public function new()
	{
		super();
		bulletsPool = new FlxPool<Bullet>(PoolFactory.fromFunction(() -> new Bullet()));
		bulletsPool.preAllocate(100);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
