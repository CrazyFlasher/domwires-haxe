/**
 * Created by Anton Nefjodov on 30.01.2016.
 */
package com.domwires.core.common;

import haxe.io.Error;

@:rtti
class AbstractDisposable implements IDisposable
{
	public var isDisposed(get, never):Bool;

	private var _isDisposed:Bool;

	@Autowired("huj")
	public var manda:AbstractDisposable;

	@Autowired("pizda", "true")
	public function dispose():Void
	{
		if (_isDisposed)
		{
			trace("Object already disposed!");
			Error.Custom("Object already disposed!");
		}

		_isDisposed = true;
	}

	private function get_isDisposed():Bool
	{
		return _isDisposed;
	}

	public function new()
	{
	}
}

