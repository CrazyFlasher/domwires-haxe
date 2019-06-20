/**
 * Created by CrazyFlasher on 23.03.2018.
 */
package com.domwires.core.testObject;


class BusyPoolObject
{
	public var isBusy(get, set):Bool;

	private var _isBusy:Bool;

	private function get_isBusy():Bool
	{
		return _isBusy;
	}

	private function set_isBusy(value:Bool):Bool
	{
		_isBusy = value;
		return value;
	}
}
