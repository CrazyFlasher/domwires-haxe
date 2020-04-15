package mock.mvc.models;

import com.domwires.core.mvc.model.AbstractModel;

class SuperCoolModel extends AbstractModel implements ISuperCoolModel
{
	@Inject("myBool")
	public var _myBool:Bool = true;

	@Inject("coolValue")
	public var _coolValue:Int;

	@Inject
	public var _value:Int;

	@Inject("def")
	public var _def:IDefault;

	@Inject("obj")
	public var _object:Dynamic;

	@Inject
	public var _array:Array<String>;

	public var getMyBool(get, never):Bool;
	public var getCoolValue(get, never):Int;
	public var value(get, never):Int;
	public var def(get, never):IDefault;
	public var object(get, never):Dynamic;
	public var array(get, never):Array<String>;

	private function get_getMyBool():Bool
	{
		return _myBool;
	}

	private function get_getCoolValue():Int
	{
		return _coolValue;
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

	private function get_array():Array<String>
	{
		return _array;
	}
}
