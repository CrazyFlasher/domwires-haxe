/**
 * Created by CrazyFlasher on 18.11.2016.
 */
package com.domwires.core.testObject;

import com.domwires.core.mvc.model.AbstractModel;
import com.domwires.core.testObject.IDefault;

@:rtti
class SuperCoolModel extends AbstractModel implements ISuperCoolModel
{
	public var value(get, never):Int;
	public var def(get, never):IDefault;
	public var object(get, never):Dynamic;
	public var array(get, never):Array<Dynamic>;

	@Autowired("myBool")
	public var _myBool:Bool = true;

	@Autowired("coolValue")

	public var _coolValue:Int;

	@Autowired
	public var _value:Int;

	@Autowired("def")
	public var _def:IDefault;

	@Autowired("obj")
	public var _object:Dynamic;

	@Autowired
	public var _array:Array<Dynamic>;

	public function getCoolValue():Int
	{
		return _coolValue;
	}

	public function getMyBool():Bool
	{
		return _myBool;
	}

	private function get_value():Int
	{
		return _value;
	}

	private function get_def():IDefault
	{
		return _def;
	}

	private function get_object():Dynamic
	{
		return _object;
	}

	private function get_array():Array<Dynamic>
	{
		return _array;
	}

	public function new()
	{
		super();
	}
}

