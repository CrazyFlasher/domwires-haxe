/**
 * Created by CrazyFlasher on 17.11.2016.
 */
package com.domwires.core.factory;


class DependencyVo
{
	public var implementation(get, never):String;
	public var value(get, never):Dynamic;
	public var newInstance(get, never):Bool;

	private var _implementation:String;
	private var _value:Dynamic;
	private var _newInstance:Bool;

	public function new(json:Dynamic)
	{
		if (json.implementation == null)
		{
			trace("'implementation' is not set in json!");
		} else
		{
			_implementation = json.implementation;
		}

		_value = json.value;

		if (json.newInstance)
		{
			_newInstance = json.newInstance;
		}
	}

	private function get_implementation():String
	{
		return _implementation;
	}

	private function get_value():Dynamic
	{
		return _value;
	}

	private function get_newInstance():Bool
	{
		return _newInstance;
	}
}

