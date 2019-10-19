package com.domwires.core.factory;

class PoolModel
{
	public var capacity(get, never):Int;
	public var instanceCount(get, never):Int;
	public var allItemsAreBusy(get, never):Bool;
	public var busyItemsCount(get, never):Int;

	private var list:Array<Dynamic> = [];
	private var _capacity:Int;

	private var currentIndex:Int;
	private var factory:AppFactory;
	private var isBusyFlagGetterName:String;

	private var _args:Array<Dynamic>;

	@:allow(com.domwires.core.factory.AppFactory)
	private function new(factory:AppFactory, capacity:Int, isBusyFlagGetterName:String)
	{
		this.factory = factory;
		_capacity = capacity;
		this.isBusyFlagGetterName = isBusyFlagGetterName;
	}

	@:allow(com.domwires.core.factory.AppFactory)
	private function get(type:Class<Dynamic>, args:Array<Dynamic> = null, createNewIfNeeded:Bool = true):Dynamic
	{
		var instance:Dynamic;

		if (args == null && _args != null)
		{
			args = _args;
		} else
		{
			_args = args;
		}

		if (list.length < _capacity && createNewIfNeeded)
		{
			instance = factory.getInstance(type, args, null, true);

			list.push(instance);
		} else
		{
			instance = list[currentIndex];

			currentIndex++;

			if (currentIndex == _capacity || currentIndex == list.length)
			{
				currentIndex = 0;
			}

			if (isBusyFlagGetterName != null && Reflect.field(instance, isBusyFlagGetterName) == true)
			{
				return get(type, args, createNewIfNeeded);
			}
		}

		return instance;
	}

	@:allow(com.domwires.core.factory.AppFactory)
	private function increaseCapacity(value:Int):Void
	{
		_capacity += value;
	}

	@:allow(com.domwires.core.factory.AppFactory)
	private function dispose():Void
	{
		list = null;
		factory = null;
	}

	private function get_capacity():Int
	{
		return _capacity;
	}

	private function get_instanceCount():Int
	{
		return list.length;
	}

	private function get_allItemsAreBusy():Bool
	{
		if (list.length < _capacity)
		{
			return false;
		}
		if (isBusyFlagGetterName == null)
		{
			return false;
		}

		var instance:Dynamic;

		for (i in 0..._capacity)
		{
			instance = list[i];

			if (Reflect.field(instance, isBusyFlagGetterName) == false)
			{
				return false;
			}
		}

		return true;
	}

	private function get_busyItemsCount():Int
	{
		if (isBusyFlagGetterName == null)
		{
			return 0;
		}

		var count:Int = 0;
		var instance:Dynamic;
		for (i in 0...list.length)
		{
			instance = list[i];

			if (Reflect.field(instance, isBusyFlagGetterName) == true)
			{
				count++;
			}
		}

		return count;
	}
}

