package mock.mvc.models;

import mock.mvc.models.SuperCoolModel;

interface ISuperCoolModel
{
	var getMyBool(get, never):Bool;
	var getCoolValue(get, never):Int;
	var value(get, never):Int;
	var def(get, never):IDefault;
	var object(get, never):Dynamic;
	var array(get, never):Array<String>;
}
